// Чтение файловой системы Оберона прямо из образа, лежащего в памяти машины.
// Порт tools/oberonfs.py; раскладка снята с исходников системы:
//   Kernel.Mod:  сектор adr лежит по смещению (adr DIV 29 - 1) * 1024
//   FileDir.Mod: DirPage = mark, m, p0, fill[52], e[24]; запись = имя 32, adr, p
//                FileHeader = mark, name[32], aleng, bleng, date, ext[12], sec[64]
//   Files.Mod:   длина = aleng * 1024 + bleng - 352
//
// Нужен лабораториям, чтобы проверять результат по ДИСКУ, а не по надписи
// на экране: «скомпилировалось» и «файл на диске изменился» — разные вещи.

const SS = 1024, HS = 352, DIRROOT = 29;

/** Разбор объектного файла (.rsc). Раскладка та же, что в tools/rsc.py,
    снята с ORTool.DecObj: имя, ключ, версия, размер, импорты, дескрипторы
    типов, размер данных, строки, КОД. Нужен лабораториям, чтобы сравнивать
    размер порождённого кода и ключ интерфейса. */
export function parseRsc(bytes) {
  let i = 0;
  const str = () => { let s = ''; while (bytes[i]) s += String.fromCharCode(bytes[i++]); i++; return s; };
  const int = () => { const v = bytes[i] | bytes[i+1]<<8 | bytes[i+2]<<16 | bytes[i+3]<<24; i += 4; return v; };
  const name = str(), key = int() >>> 0, version = bytes[i++], size = int();
  const imports = [];
  for (let n = str(); n; n = str()) imports.push([n, int() >>> 0]);
  const td = int() / 4; i += td * 4;
  const datasize = int();
  const slen = int(); i += slen;
  const nwords = int();
  const code = new Uint32Array(nwords);
  for (let k = 0; k < nwords; k++) code[k] = int() >>> 0;
  return { name, key, version, size, imports, datasize, codeWords: nwords, code };
}

/** Текст Оберона из файла.

    Файлы, сохранённые редактором, лежат НЕ в виде голого ASCII: первый байт —
    метка формата (F1H), затем смещение текста, затем описания кусков со
    шрифтами. Наивное чтение даёт мусор в начале, а концы строк — возврат
    каретки, а не перевод. Разбор по Texts.Mod: Open читает метку, Load —
    смещение и куски. */
export function readText(bytes) {
  if (bytes[0] !== 0xF1) return new TextDecoder('latin1').decode(bytes);   // простой ASCII
  const off = bytes[1] | bytes[2] << 8 | bytes[3] << 16 | bytes[4] << 24;
  return new TextDecoder('latin1').decode(bytes.subarray(off)).replace(/\r/g, '\n');
}

export class OberonFS {
  constructor(machine) { this.m = machine; }

  secOff(adr) { return ((adr / DIRROOT | 0) - 1) * SS; }
  word(adr, i) { return this.m.disk(this.secOff(adr) + i * 4); }

  byte(adr, i) {
    const w = this.m.disk(this.secOff(adr) + (i & ~3));
    return (w >>> ((i & 3) * 8)) & 0xFF;
  }

  name(adr, off) {
    let s = '';
    for (let i = 0; i < 32; i++) {
      const c = this.byte(adr, off + i);
      if (!c) break;
      s += String.fromCharCode(c);
    }
    return s;
  }

  *entries(adr = DIRROOT) {
    if (!adr) return;
    const m = this.word(adr, 1) | 0, p0 = this.word(adr, 2) | 0;
    yield* this.entries(p0);
    for (let i = 0; i < m; i++) {
      const base = 64 + i * 40;
      const nm = this.name(adr, base);
      const hdr = this.m.disk(this.secOff(adr) + base + 32) | 0;
      const p = this.m.disk(this.secOff(adr) + base + 36) | 0;
      yield [nm, hdr];
      yield* this.entries(p);
    }
  }

  files() {
    const out = new Map();
    for (const [n, h] of this.entries()) out.set(n, h);
    return out;
  }

  length(hdr) {
    const aleng = this.m.disk(this.secOff(hdr) + 36) | 0;
    const bleng = this.m.disk(this.secOff(hdr) + 40) | 0;
    return aleng * SS + bleng - HS;
  }

  read(hdr) {
    const base = this.secOff(hdr);
    const aleng = this.m.disk(base + 36) | 0, bleng = this.m.disk(base + 40) | 0;
    const len = aleng * SS + bleng - HS;
    const out = new Uint8Array(len);
    let o = 0;
    const copy = (off, n) => {
      for (let i = 0; i < n && o < len; i += 4) {
        const w = this.m.disk(off + i);
        for (let b = 0; b < 4 && o < len; b++) out[o++] = (w >>> (b * 8)) & 0xFF;
      }
    };
    copy(base + HS, SS - HS);
    for (let i = 1; i <= aleng; i++) {
      let a;
      if (i < 64) a = this.m.disk(base + 96 + i * 4) | 0;
      else {
        const ext = this.m.disk(base + 48 + (((i - 64) / 256) | 0) * 4) | 0;
        a = this.m.disk(this.secOff(ext) + ((i - 64) % 256) * 4) | 0;
      }
      copy(this.secOff(a), SS);
    }
    return out;
  }
}
