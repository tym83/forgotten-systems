#!/usr/bin/env python3
"""Чтение файловой системы Оберона прямо из образа диска.

Раскладка снята с исходников системы, а не угадана:

  Kernel.Mod:  GetSector(src) -> src DIV 29, затем *2 + FSoffset (80000H) в
               512-байтных блоках SD. Эмулятор диска вычитает 80002H
               (tb/disk/disk.c), поэтому сектор adr лежит в образе по
               смещению (adr DIV 29 - 1) * 1024.

  FileDir.Mod: DirPage = mark, m, p0, fill[52], e[24] — 64 байта заголовка и
               24 записи по 40 байт (имя 32, adr 4, p 4). Это B-дерево:
               p0 — левый потомок, p каждой записи — правый.
               FileHeader = mark, name[32], aleng, bleng, date, ext[12],
               sec[64] — ровно 352 байта (HeaderSize), дальше данные.

  Files.Mod:   Length(f) = aleng * 1024 + bleng - 352.

Нужен, чтобы доказать неподвижную точку пересборки: сравнить объектные файлы
до и после побайтово, а не по числам на экране.
"""
import struct, sys

SS, HS, DIRROOT = 1024, 352, 29


class Image:
    def __init__(self, path):
        self.d = open(path, "rb").read()

    def sector(self, adr):
        k = adr // DIRROOT
        off = (k - 1) * SS
        return self.d[off:off + SS]

    def entries(self, adr=DIRROOT):
        """Обход B-дерева каталога: имя -> адрес заголовка файла."""
        if adr == 0:
            return
        s = self.sector(adr)
        m, p0 = struct.unpack_from("<ii", s, 4)
        yield from self.entries(p0)
        for i in range(m):
            base = 64 + i * 40
            name = s[base:base + 32].split(b"\0")[0].decode("latin-1")
            hdr, p = struct.unpack_from("<ii", s, base + 32)
            yield name, hdr
            yield from self.entries(p)

    def date(self, hdr):
        """Отметка времени из заголовка файла (FileDir.Mod: поле date).

        Отличает «пересобрано и совпало побайтово» от «файл не трогали»:
        побайтовое сравнение эти два случая не различает, а это ровно та
        разница, из-за которой проверка могла бы тихо пройти на несобранном.
        """
        return struct.unpack_from("<i", self.sector(hdr), 44)[0]

    def read(self, hdr):
        h = self.sector(hdr)
        aleng, bleng = struct.unpack_from("<ii", h, 36)
        sec = struct.unpack_from("<64i", h, 96)
        length = aleng * SS + bleng - HS
        out = bytearray(h[HS:])                       # хвост первого сектора
        for i in range(1, aleng + 1):
            if i < 64:
                a = sec[i]
            else:                                     # длинные файлы: индексные страницы
                ext = struct.unpack_from("<12i", h, 48)
                page = self.sector(ext[(i - 64) // 256])
                a = struct.unpack_from("<i", page, ((i - 64) % 256) * 4)[0]
            out += self.sector(a)
        return bytes(out[:length])

    def files(self):
        return dict(self.entries())


if __name__ == "__main__":
    img = Image(sys.argv[1])
    fs = img.files()
    if len(sys.argv) > 2:
        for name in sys.argv[2:]:
            sys.stdout.buffer.write(img.read(fs[name]))
    else:
        print(f"файлов: {len(fs)}")
        for n in sorted(fs)[:8]:
            print(f"  {n:24s} {len(img.read(fs[n])):8d} байт")
