#!/usr/bin/env python3
"""Собирает ApplicationDefinition для каталога Cozystack из описания репозитория.

Схему приложения берёт не из отдельного текста, а прямо из values.schema.json
соответствующего чарта: так описание в каталоге не может разойтись с тем, что
чарт на самом деле принимает. Иконку — из файла чарта.

Имя ссылки на чарт складывается по правилу самой платформы
(internal/marketplace/naming.ArtifactName): <источник>-<вариант>-<компонент>,
точки заменяются дефисами.
"""
import base64
import json
import pathlib
import sys

import yaml


def artifact_name(package_source: str, variant: str, component: str) -> str:
    """Правило именования артефактов Cozystack, повторённое буквально."""
    part = lambda s: s.replace(".", "-")
    return f"{part(package_source)}-{part(variant)}-{part(component)}"


def build(repo: pathlib.Path) -> dict[str, str]:
    spec_path = repo / "appdefs.yaml"
    spec = yaml.safe_load(spec_path.read_text(encoding="utf-8"))
    packages = repo.parents[1]  # <repo>/packages/system/<x>-rd -> <repo>/packages

    out: dict[str, str] = {}
    for app in spec["apps"]:
        chart = packages / app["chartPath"]
        schema_file = chart / "values.schema.json"
        if not schema_file.is_file():
            sys.exit(f"нет {schema_file}: схему брать неоткуда")
        # Схема каталога — это ровно схема значений чарта, без пересказа.
        schema = json.loads(schema_file.read_text(encoding="utf-8"))

        dash = dict(app["dashboard"])
        icon_rel = dash.pop("icon", None)
        if icon_rel:
            icon_bytes = (chart / icon_rel).read_bytes()
            dash["icon"] = base64.b64encode(icon_bytes).decode("ascii")

        doc = {
            "apiVersion": "cozystack.io/v1alpha1",
            "kind": "ApplicationDefinition",
            "metadata": {"name": app["component"]},
            "spec": {
                "application": {
                    "kind": app["kind"],
                    "plural": app["plural"],
                    "singular": app["singular"],
                    "openAPISchema": json.dumps(schema, separators=(",", ":"),
                                                ensure_ascii=False),
                },
                "release": {
                    "prefix": app["prefix"],
                    "labels": {"sharding.fluxcd.io/key": "tenants"},
                    "chartRef": {
                        "kind": "ExternalArtifact",
                        "name": artifact_name(spec["packageSource"],
                                              spec["variant"],
                                              app["component"]),
                        "namespace": spec["artifactNamespace"],
                    },
                },
                "dashboard": dash,
            },
        }
        header = (
            "# Сгенерировано tools/gen-appdefs.py из appdefs.yaml и\n"
            f"# {app['chartPath']}/values.schema.json. Руками не править:\n"
            "# `make gen` перезапишет, `make check` поймает расхождение.\n"
        )
        out[f"{app['component']}.yaml"] = header + yaml.safe_dump(
            doc, allow_unicode=True, sort_keys=False, width=10**6
        )
    return out


def main() -> None:
    if len(sys.argv) != 2:
        sys.exit("использование: gen-appdefs.py <каталог-*-rd>")
    repo = pathlib.Path(sys.argv[1]).resolve()
    files = build(repo)
    dest = repo / "cozyrds"
    dest.mkdir(exist_ok=True)
    for name, text in files.items():
        (dest / name).write_text(text, encoding="utf-8")
    # Лишние файлы удалять не пытаемся: отчёт честнее молчаливой уборки.
    stale = sorted(p.name for p in dest.glob("*.yaml") if p.name not in files)
    for name, _ in sorted(files.items()):
        print(f"  записано cozyrds/{name}")
    for name in stale:
        print(f"  ⚠ лишний файл cozyrds/{name} — его не описывает appdefs.yaml")


if __name__ == "__main__":
    main()
