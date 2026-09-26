// Проверка центрального номера: числа, которые увидит читатель, считаются здесь.
//
// Проверка, которая просто печатает числа, бесполезна — поэтому здесь заявлены
// ожидания: программы обязаны дойти до конца, аппаратная проверка обязана
// экономить ровно одну команду и один такт на индексацию, а полезная работа
// обязана совпасть (накопитель — в R4).
import fs from 'node:fs';
import { runBench, perCheck } from './bench.js';

// ⚠ Читаем то, что уезжает ЧИТАТЕЛЮ, а не порождаемое в tests/: там файлы
// собираются на месте и в свежем дереве их нет вовсе. Проверка должна считать
// ровно те же байты, что страница.
const P = JSON.parse(fs.readFileSync('bench_bounds.json', 'utf8'));
// ⚠ `fs.readFileSync` для мелких файлов отдаёт ВИД на общий пул node, а не
// собственный буфер: `.buffer` там — весь пул, и второе чтение подряд даёт
// чужие байты. Программа при этом собирается из мусора и просто не доходит до
// конца — молча, без единой ошибки. Берём ровно своё окно.
const load = n => {
  const b = fs.readFileSync(`bench_bounds_${n}.bin`);
  return new Uint32Array(b.buffer, b.byteOffset, b.length / 4);
};

let bad = 0;
const say = (ok, s) => { console.log(`  ${ok ? '✅' : '❌'} ${s}`); if (!ok) bad++; };

const b = await runBench((await import('./risc5.js')).default, load('b'), P);
const e = await runBench((await import('./risc5-chk.js')).default, load('e'), P);

say(b.iterations > 1000 && !b.trapped,
    `B: ${b.iterations} итераций за ${b.insns} инструкций, ${b.cycles} тактов`);
say(e.iterations > 1000 && !e.trapped,
    `E: ${e.iterations} итераций за ${e.insns} инструкций, ${e.cycles} тактов`);

const d = perCheck(b, e);
say(Math.abs(d.insnsB - 10) < 0.01, `итерация B стоит ${d.insnsB.toFixed(3)} команд (ожидалось 10)`);
say(Math.abs(d.insnsE - 9) < 0.01,  `итерация E стоит ${d.insnsE.toFixed(3)} команд (ожидалось 9)`);
say(Math.abs(d.insnsPer - 1) < 0.01,
    `аппаратная проверка экономит ${d.insnsPer.toFixed(3)} команды на индексацию`);
say(d.cyclesPer > 0.9 && d.cyclesPer < 1.1,
    `и ${d.cyclesPer.toFixed(3)} такта: ${d.cyclesB.toFixed(2)} → ${d.cyclesE.toFixed(2)}`);
say(d.percent > 5 && d.percent < 20,
    `на этой нагрузке проверка границ стоит ${d.percent.toFixed(1)}% тактов`);

console.log(bad ? `\n❌ центральный номер: ${bad} расхождений` : '\n✅ числа центрального номера сходятся');
process.exit(bad ? 1 : 0);
