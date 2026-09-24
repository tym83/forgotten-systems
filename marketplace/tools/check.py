#!/usr/bin/env python3
"""Проверки каталога «Забытые системы».

Штатный валидатор Cozystack проверяет структуру репозитория и ссылки в
ApplicationDefinition. Он не знает про две вещи, которые для этого каталога
важны, и их проверяем здесь:

  * ссылки на артефакты внутри метаприложения (родительский чарт рендерит
    HelmRelease на компоненты того же репозитория — если имя разъедется,
    метаприложение молча поставит пустоту);
  * описания приложений в каталоге, собранные генератором, — не отстали ли они
    от схем чартов.

Каждая проверка, которая что-то утверждает, сопровождается мутацией: мы ломаем
проверяемое и убеждаемся, что проверка падает. Проверка, которая не умеет
провалиться, ничего не проверяет.
"""
from __future__ import annotations

import json
import pathlib
import re
import shutil
import subprocess
import sys
import tempfile

import yaml

ROOT = pathlib.Path(__file__).resolve().parent.parent
COZYPKG = shutil.which("cozypkg") or "/tmp/cozypkg"
REPOS = ["machines", "languages", "images"]

ok_count = 0
fail_count = 0


def report(passed: bool, text: str) -> None:
    global ok_count, fail_count
    if passed:
        ok_count += 1
        print(f"  ✅ {text}")
    else:
        fail_count += 1
        print(f"  ❌ {text}")


def run(args: list[str], cwd: pathlib.Path | None = None) -> subprocess.CompletedProcess:
    return subprocess.run(args, cwd=cwd or ROOT, capture_output=True, text=True)


def artifact_name(ps: str, variant: str, component: str) -> str:
    part = lambda s: s.replace(".", "-")
    return f"{part(ps)}-{part(variant)}-{part(component)}"


def load_source(repo: str) -> dict:
    files = list((ROOT / "repos" / repo / "packages" / "sources").glob("*.yaml"))
    assert len(files) == 1, f"{repo}: ожидался ровно один файл источника"
    return yaml.safe_load(files[0].read_text(encoding="utf-8"))


def declared_artifacts(repo: str) -> set[str]:
    src = load_source(repo)
    name = src["metadata"]["name"]
    out = set()
    for variant in src["spec"]["variants"]:
        for comp in variant["components"]:
            out.add(artifact_name(name, variant["name"], comp["name"]))
    return out


# ─── 1. Метаиндекс ──────────────────────────────────────────────────────────
def check_index() -> None:
    print("\nМетаиндекс")
    r = run([COZYPKG, "search", "--index", "index"])
    entries = [l for l in r.stdout.splitlines()[1:] if l.strip()]
    report(r.returncode == 0 and len(entries) == 3,
           f"cozypkg читает индекс, записей: {len(entries)}")

    # Мутация: индекс разбирается строго, лишнее поле должно ломать разбор.
    victim = ROOT / "index" / "paleocomputing-images.yaml"
    original = victim.read_text(encoding="utf-8")
    try:
        victim.write_text(original + "kind: Image\n", encoding="utf-8")
        bad = run([COZYPKG, "search", "--index", "index"])
        report(bad.returncode != 0 or "unknown field" in (bad.stdout + bad.stderr),
               "мутация: лишнее поле в записи индекса отвергается")
    finally:
        victim.write_text(original, encoding="utf-8")

    # Каждая запись должна нести тег, иначе её не найти: тип записи в этой
    # схеме выражается только тегами.
    for f in sorted((ROOT / "index").glob("*.yaml")):
        entry = yaml.safe_load(f.read_text(encoding="utf-8"))
        report(bool(entry.get("tags")), f"у записи {entry['name']} есть теги")


# ─── 2. Штатный валидатор ───────────────────────────────────────────────────
def check_validate() -> None:
    print("\nВалидатор Cozystack")
    for repo in REPOS:
        r = run([COZYPKG, "validate", f"repos/{repo}"])
        tail = r.stdout.strip().splitlines()[-1] if r.stdout.strip() else "(пусто)"
        errs = re.search(r"(\d+) error", tail)
        report(bool(errs) and errs.group(1) == "0", f"repos/{repo}: {tail}")

    # ⚠ Проверять надо и то, что реально уезжает в реестр. В артефакт попадает
    # ТОЛЬКО содержимое packages/, с отброшенной приставкой. Манифест источника
    # когда-то лежал рядом, в sources/, и молча терялся при публикации: дерево
    # исходников проходило проверку, а опубликованное — нет. Поймано только
    # круговым прогоном через настоящий реестр.
    for repo in REPOS:
        r = run([COZYPKG, "validate", f"repos/{repo}/packages"])
        tail = r.stdout.strip().splitlines()[-1] if r.stdout.strip() else "(пусто)"
        errs = re.search(r"(\d+) error", tail)
        report(bool(errs) and errs.group(1) == "0",
               f"repos/{repo} в опубликованной форме: {tail}")

    # Мутация: убрать манифест источника из packages/ — публикуемая форма
    # обязана перестать проходить.
    src = ROOT / "repos/machines/packages/sources/machines.yaml"
    moved = ROOT / "repos/machines/sources-moved-for-test.yaml"
    try:
        src.rename(moved)
        bad = run([COZYPKG, "validate", "repos/machines/packages"])
        report("no-packagesource" in bad.stdout,
               "мутация: манифест источника вне packages/ ломает публикуемую форму")
    finally:
        moved.rename(src)

    # Мутация: испортить ссылку на чарт — валидатор обязан заметить.
    victim = ROOT / "repos/machines/packages/system/machines-rd/cozyrds/oberon-lab.yaml"
    original = victim.read_text(encoding="utf-8")
    try:
        victim.write_text(
            original.replace("paleocomputing-machines-default-oberon-lab",
                             "nonsense-does-not-exist"),
            encoding="utf-8")
        bad = run([COZYPKG, "validate", "repos/machines"])
        report("appdef-dangling" in bad.stdout,
               "мутация: сломанная ссылка на чарт поймана валидатором")
    finally:
        victim.write_text(original, encoding="utf-8")

    # Привилегированный компонент обязан быть виден оператору.
    r = run([COZYPKG, "validate", "repos/images"])
    report("(privileged)" in r.stdout,
           "образы помечены привилегированными и валидатор об этом предупреждает")


# ─── 3. Описания каталога не отстали от чартов ──────────────────────────────
def check_generated() -> None:
    print("\nОписания приложений для каталога")
    for rd in sorted(ROOT.glob("repos/*/packages/system/*-rd")):
        if not (rd / "appdefs.yaml").is_file():
            continue
        before = {p.name: p.read_text(encoding="utf-8") for p in (rd / "cozyrds").glob("*.yaml")}
        r = run([sys.executable, "tools/gen-appdefs.py", str(rd)])
        after = {p.name: p.read_text(encoding="utf-8") for p in (rd / "cozyrds").glob("*.yaml")}
        report(r.returncode == 0 and before == after,
               f"{rd.relative_to(ROOT)}: сгенерированное совпадает с лежащим в дереве")

        # Схема в каталоге обязана быть ровно схемой чарта.
        spec = yaml.safe_load((rd / "appdefs.yaml").read_text(encoding="utf-8"))
        packages = rd.parents[1]
        for app in spec["apps"]:
            doc = yaml.safe_load((rd / "cozyrds" / f"{app['component']}.yaml").read_text(encoding="utf-8"))
            in_catalog = json.loads(doc["spec"]["application"]["openAPISchema"])
            in_chart = json.loads((packages / app["chartPath"] / "values.schema.json")
                                  .read_text(encoding="utf-8"))
            report(in_catalog == in_chart,
                   f"{app['component']}: схема в каталоге совпадает со схемой чарта")


# ─── 4. Ссылки метаприложения (этого валидатор Cozystack не проверяет) ──────
def metaapp_refs(values_overrides: list[str] | None = None) -> set[str]:
    chart = ROOT / "repos/machines/packages/apps/workbench"
    args = ["helm", "template", "w", str(chart)] + (values_overrides or [])
    r = run(args)
    if r.returncode != 0:
        return set()
    refs = set()
    for doc in yaml.safe_load_all(r.stdout):
        if isinstance(doc, dict) and doc.get("kind") == "HelmRelease":
            ref = doc["spec"]["chartRef"]
            if ref.get("kind") == "ExternalArtifact":
                refs.add(ref["name"])
    return refs


def check_metaapp() -> None:
    print("\nМетаприложение")
    declared = declared_artifacts("machines")
    refs = metaapp_refs()
    report(len(refs) == 2, f"метаприложение заказывает {len(refs)} части")
    report(refs and refs <= declared,
           "все ссылки метаприложения ведут в компоненты этого же репозитория")

    # Мутация: сдвинуть приставку имени артефакта — ссылки обязаны «повиснуть».
    broken = metaapp_refs(["--set", "artifactPrefix=wrong-prefix"])
    report(broken and not (broken <= declared),
           "мутация: сдвинутая приставка делает ссылки висячими")

    # Окружение без единой части не имеет смысла.
    r = run(["helm", "template", "w", str(ROOT / "repos/machines/packages/apps/workbench"),
             "--set", "machine=false", "--set", "manual=false"])
    report(r.returncode != 0, "пустое окружение отвергается")


# ─── 5. Документация действительно доезжает читаемой ────────────────────────
def check_handbook() -> None:
    print("\nМетодичка")
    chart = ROOT / "repos/machines/packages/apps/handbook"
    body = "первая строка\nвторая строка\n<tag> & \"кавычки\"\n"
    pages = json.dumps([{"name": "p1", "title": "Глава <1>", "body": body}])
    r = run(["helm", "template", "h", str(chart), "--set-json", f"pages={pages}"])
    cm = next((d for d in yaml.safe_load_all(r.stdout)
               if isinstance(d, dict) and d.get("kind") == "ConfigMap"), None)
    report(cm is not None, "страницы собираются в ConfigMap")
    if cm:
        page = cm["data"]["p1.html"]
        report("первая строка\nвторая строка" in page,
               "переносы строк пережили укладку в YAML")
        report("&lt;tag&gt;" in page and "&amp;" in page and "<tag>" not in page,
               "разметка в тексте экранирована, а не выполнена")
        report('<a href="p1.html">' in cm["data"]["index.html"],
               "оглавление ссылается на страницу")

    # Мутация: методичка без источника — ни образа, ни страниц.
    bad = run(["helm", "template", "h", str(chart)])
    report(bad.returncode != 0, "мутация: методичка без источника отвергается")


# ─── 6. Образы: коллизии с платформой ───────────────────────────────────────
def check_images() -> None:
    print("\nОбразы машин")
    chart = ROOT / "repos/images/packages/system/machine-images"
    imgs = json.dumps([{"name": "oberon-risc5", "url": "https://example.org/a.qcow2"}])
    r = run(["helm", "template", "mi", str(chart), "--set-json", f"images={imgs}"])
    names = [d["metadata"]["name"] for d in yaml.safe_load_all(r.stdout)
             if isinstance(d, dict) and d.get("kind") == "DataVolume"]
    report(names == ["vm-default-images-fs-oberon-risc5"],
           f"образ публикуется под именем с приставкой: {names}")
    ns = {d["metadata"]["namespace"] for d in yaml.safe_load_all(r.stdout)
          if isinstance(d, dict) and d.get("kind") == "DataVolume"}
    report(ns == {"cozy-public"}, "образ кладётся в общее пространство cozy-public")

    # Мутации: совпадение с платформой, дубль, пустая приставка.
    collide = json.dumps([{"name": "24.04", "url": "https://example.org/a"}])
    bad = run(["helm", "template", "mi", str(chart), "--set", "namePrefix=ubuntu-",
               "--set-json", f"images={collide}"])
    report("занято образом платформы" in (bad.stdout + bad.stderr),
           "мутация: совпадение с образом платформы поймано")
    dup = json.dumps([{"name": "d", "url": "https://e.org/a"},
                      {"name": "d", "url": "https://e.org/b"}])
    bad = run(["helm", "template", "mi", str(chart), "--set-json", f"images={dup}"])
    report("дважды" in (bad.stdout + bad.stderr), "мутация: дубль в списке пойман")


# ─── 7. Окружение для языка ─────────────────────────────────────────────────
def check_langpack() -> None:
    print("\nОкружение для языка")
    chart = ROOT / "repos/languages/packages/apps/langpack"
    base = ["helm", "template", "l", str(chart), "--set", "language=Oberon",
            "--set", "image=example/obc:1"]

    prog = json.dumps([{"path": "Hello.Mod", "content": "MODULE Hello;\nEND Hello.\n"}])
    r = run(base + ["--set-json", f"program={prog}"])
    kinds = {d["kind"] for d in yaml.safe_load_all(r.stdout) if isinstance(d, dict)}
    report(kinds == {"ConfigMap", "Job"},
           f"разовый прогон даёт задание и исходники: {sorted(kinds)}")

    r = run(base + ["--set", "mode=service", "--set", "host=l.example.org"])
    kinds = {d["kind"] for d in yaml.safe_load_all(r.stdout) if isinstance(d, dict)}
    report(kinds == {"Deployment", "Service", "Ingress"},
           f"постоянная среда даёт развёртывание и доступ: {sorted(kinds)}")

    # Исходники монтируются только на чтение, рабочий каталог — на запись.
    r = run(base + ["--set-json", f"program={prog}"])
    job = next(d for d in yaml.safe_load_all(r.stdout)
               if isinstance(d, dict) and d["kind"] == "Job")
    mounts = {m["mountPath"]: m.get("readOnly", False)
              for m in job["spec"]["template"]["spec"]["containers"][0]["volumeMounts"]}
    report(mounts.get("/src") is True and mounts.get("/work") is False,
           "исходники только на чтение, рабочий каталог на запись")

    # Мутации: каждая защита обязана сработать.
    report(run(base + ["--set", "host=h.example.org"]).returncode != 0,
           "мутация: внешнее имя у разового прогона отвергается")
    report(run(base + ["--set", "srcdir=/work", "--set-json", f"program={prog}"]).returncode != 0,
           "мутация: совпадение srcdir и workdir отвергается")
    report(run(base + ["--set", "mode=nonsense"]).returncode != 0,
           "мутация: неизвестный режим отвергается схемой")


# ─── 8. Схемы не должны закрывать корень ────────────────────────────────────
def check_schema_roots() -> None:
    print("\nСхемы значений")
    # ⚠ Найдено на живом кластере, не здесь. cozystack-engine подмешивает в
    # values приложения тенанта ключи _cluster и _namespace. Если корень схемы
    # закрыт (additionalProperties: false), Helm отвергает значения целиком и
    # приложение не разворачивается — при том что артефакт валиден, каталог
    # подключается и описания встают. Ни один чарт платформы корень не
    # закрывает; проверка держит это правило.
    schemas = sorted(ROOT.glob("repos/*/packages/*/*/values.schema.json"))
    report(len(schemas) >= 5, f"схем найдено: {len(schemas)}")
    for s in schemas:
        d = json.loads(s.read_text(encoding="utf-8"))
        report(d.get("additionalProperties") is not False,
               f"{s.parent.name}: корень схемы открыт для ключей движка")

    # Мутация: закрыть корень — проверка обязана покраснеть.
    victim = ROOT / "repos/machines/packages/apps/oberon-lab/values.schema.json"
    original = victim.read_text(encoding="utf-8")
    try:
        d = json.loads(original)
        d["additionalProperties"] = False
        victim.write_text(json.dumps(d, ensure_ascii=False, indent=2), encoding="utf-8")
        bad = json.loads(victim.read_text(encoding="utf-8"))
        report(bad.get("additionalProperties") is False,
               "мутация: закрытый корень отличим от открытого")
    finally:
        victim.write_text(original, encoding="utf-8")


def main() -> None:
    print("Проверки каталога «Забытые системы»")
    check_index()
    check_validate()
    check_generated()
    check_metaapp()
    check_handbook()
    check_images()
    check_langpack()
    check_schema_roots()
    print(f"\nИтог: успешно {ok_count}, провалено {fail_count}")
    sys.exit(1 if fail_count else 0)


if __name__ == "__main__":
    main()
