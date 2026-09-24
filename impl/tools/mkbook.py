#!/usr/bin/env python3
"""Сборка методички: docs/book/*.md -> web/book/*.html.

Источник истины — Markdown в репозитории: его можно читать и рецензировать
в гите. Вывод — страницы рядом с лабораториями, чтобы читать и делать задания
в одном месте.

Проверяется то, что ломается чаще всего: битые ссылки между главами и ссылки
на несуществующие лабораторные. Битая ссылка в учебнике хуже отсутствующей
главы, потому что выглядит рабочей.
"""
import pathlib, re, sys
import markdown

SRC = pathlib.Path("docs/book")
OUT = pathlib.Path("web/book")

CSS = """
:root { color-scheme: light dark; --bg:#f6f6f4; --fg:#1a1a1a; --mut:#666;
        --line:#d8d8d4; --acc:#2b5fa8; --code:#eceae5; }
@media (prefers-color-scheme: dark) {
  :root { --bg:#16181c; --fg:#e6e6e6; --mut:#9aa0a6; --line:#2e3238;
          --acc:#7aa7e8; --code:#20242a; } }
* { box-sizing:border-box }
body { margin:0; background:var(--bg); color:var(--fg);
       font:16px/1.65 ui-serif,Georgia,"Times New Roman",serif; }
.wrap { display:grid; grid-template-columns:240px minmax(0,72ch); gap:40px;
        max-width:1100px; margin:0 auto; padding:28px 20px 80px }
@media (max-width:900px) { .wrap { grid-template-columns:1fr; gap:16px } }
nav { position:sticky; top:20px; align-self:start;
      font:13px/1.5 ui-sans-serif,system-ui,sans-serif }
nav a { display:block; padding:3px 0; color:var(--mut); text-decoration:none }
nav a:hover { color:var(--acc) }
nav a.cur { color:var(--fg); font-weight:600 }
nav .top { font-weight:600; color:var(--fg); margin-bottom:10px; display:block }
h1 { font-size:26px; line-height:1.25; margin:0 0 24px }
h2 { font-size:20px; margin:32px 0 10px }
h3 { font-size:17px; margin:24px 0 8px }
p, li { margin:0 0 12px }
ul, ol { padding-left:24px }
a { color:var(--acc) }
code { font:13px/1.5 ui-monospace,SFMono-Regular,Menlo,monospace;
       background:var(--code); padding:1px 4px; border-radius:3px }
pre { background:var(--code); padding:12px 14px; border-radius:7px;
      overflow-x:auto; border:1px solid var(--line) }
pre code { background:none; padding:0; font-size:12.5px }
table { border-collapse:collapse; width:100%; font-size:14px; margin:0 0 16px;
        display:block; overflow-x:auto }
th, td { border:1px solid var(--line); padding:6px 9px; text-align:left }
th { background:var(--code) }
blockquote { margin:0 0 14px; padding:8px 14px; border-left:3px solid var(--line);
             color:var(--mut) }
.foot { margin-top:48px; padding-top:16px; border-top:1px solid var(--line);
        display:flex; justify-content:space-between;
        font:14px ui-sans-serif,system-ui,sans-serif }
"""

TPL = """<!doctype html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{title}</title>
<style>{css}</style>
<div class="wrap">
<nav><a class="top" href="index.html">Оберон: методичка</a>{toc}
<a href="../lab.html" style="margin-top:14px">→ Лаборатории</a></nav>
<article>{body}<div class="foot"><span>{prev}</span><span>{next}</span></div></article>
</div>
"""


def lab_ids():
    """Номера существующих лабораторных — из самого web/labs.js, а не списком
    здесь: иначе проверка ссылок разъедется с реальностью при первой же новой
    лабораторной."""
    src = pathlib.Path("web/labs.js").read_text(encoding="utf-8")
    return set(re.findall(r"^\s*id: (\d+),", src, re.M))


def chapters():
    return sorted(SRC.glob("*.md"))


def title_of(path):
    for line in open(path, encoding="utf-8"):
        if line.startswith("# "):
            return line[2:].strip()
    return path.stem


def main():
    files = chapters()
    if not files:
        sys.exit("нет глав в docs/book")
    OUT.mkdir(parents=True, exist_ok=True)
    names = [f.stem + ".html" for f in files]
    titles = [title_of(f) for f in files]

    LABS = lab_ids()
    problems = []
    md = markdown.Markdown(extensions=["tables", "fenced_code", "sane_lists"])

    for i, f in enumerate(files):
        text = open(f, encoding="utf-8").read()
        # ссылки между главами пишутся на .md, а в вывод идут на .html
        for target in re.findall(r"\]\((\d[\w-]*)\.md\)", text):
            if target + ".md" not in [x.name for x in files]:
                problems.append(f"{f.name}: ссылка на несуществующую главу {target}.md")
        text = re.sub(r"\]\((\d[\w-]*)\.md", r"](\1.html", text)
        for lab in re.findall(r"лаб\w*\s+№(\d+)", text):
            if lab not in LABS:
                problems.append(f"{f.name}: ссылка на лабораторную №{lab}, которой нет")
        md.reset()
        body = md.convert(text)
        toc = "".join(
            f'<a class="{"cur" if j == i else ""}" href="{names[j]}">{titles[j]}</a>'
            for j in range(len(files)))
        prev = f'<a href="{names[i-1]}">← {titles[i-1]}</a>' if i else ""
        nxt = f'<a href="{names[i+1]}">{titles[i+1]} →</a>' if i + 1 < len(files) else ""
        (OUT / names[i]).write_text(
            TPL.format(title=titles[i], css=CSS, toc=toc, body=body, prev=prev, next=nxt),
            encoding="utf-8")

    idx = "<h1>Оберон: методичка</h1><ol>" + "".join(
        f'<li><a href="{names[j]}">{titles[j]}</a></li>' for j in range(len(files))) + "</ol>"
    (OUT / "index.html").write_text(
        TPL.format(title="Оберон: методичка", css=CSS, toc="", body=idx, prev="", next=""),
        encoding="utf-8")

    words = sum(len(re.findall(r"[А-Яа-яЁёA-Za-z]+", open(f, encoding="utf-8").read()))
                for f in files)
    print(f"  глав: {len(files)}, слов: {words}")
    for j, t in enumerate(titles):
        print(f"    {j+1}. {t}")
    if problems:
        print("\n❌ битые ссылки:")
        for p in problems:
            print("   ", p)
        return 1
    print("\n✅ методичка собрана, ссылки целы")
    return 0


if __name__ == "__main__":
    sys.exit(main())
