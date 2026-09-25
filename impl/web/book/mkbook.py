#!/usr/bin/env python3
"""Собирает английскую главу методички из русской.

Берёт оформление и навигацию из исходной главы, подменяет названия и вставляет
переданный текст. Так оформление остаётся в одном месте: поправишь стиль в
русской — английская подхватит при следующей сборке.
"""
import pathlib, re, sys, json

TITLES = {
    'index.html':             'Oberon: the handbook',
    '01-zachem.html':         'What this is for, and what here is real',
    '02-mashina.html':        'The machine: RISC5',
    '03-yazyk.html':          'The language: Oberon in one chapter',
    '04-sistema.html':        'The system: text instead of buttons',
    '05-moduli.html':         'Modules, symbol files and keys',
    '06-kompilyator.html':    'The compiler from inside',
    '07-samoraskrutka.html':  'Self-hosting and the fixed point',
    '08-izmereno.html':       'What we measured and what we found',
}

def build(src_name, article_html):
    src = pathlib.Path(src_name).read_text(encoding='utf-8')

    head, rest = src.split('<nav>', 1)
    _, tail = rest.split('</nav>', 1)

    head = re.sub(r'<title>.*?</title>', f'<title>{TITLES[src_name]}</title>', head, flags=re.S)

    nav = ['<nav><a class="top" href="index.html">Oberon: the handbook</a>']
    for f, t in TITLES.items():
        if f == 'index.html':
            continue
        cur = ' cur' if f == src_name else ''
        nav.append(f'<a class="{cur.strip()}" href="{f}">{t}</a>')
    nav.append('<a href="../../lab.html" style="margin-top:14px">→ Labs</a></nav>')

    body = f'<article><h1>{TITLES[src_name]}</h1>\n{article_html}\n</article>'
    # Хвост после </article> — подвал, если он есть.
    foot = tail.split('</article>', 1)[1] if '</article>' in tail else '\n</div>\n'
    out = head + ''.join(nav) + '\n' + body + foot
    pathlib.Path('en') / src_name
    (pathlib.Path('en') / src_name).write_text(out, encoding='utf-8')
    return len(out)

if __name__ == '__main__':
    name = sys.argv[1]
    art = pathlib.Path(sys.argv[2]).read_text(encoding='utf-8')
    print(f'  {name}: {build(name, art)} байт')
