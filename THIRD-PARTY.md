# Что здесь чужое и на каких условиях

Наша часть — под Apache-2.0 (файл `LICENSE`). Ниже — всё, что взято готовым.
Условия всех трёх компонентов разрешительные и требуют одного: сохранять
уведомление об авторстве. Оно сохранено.

## Project Oberon — Никлаус Вирт, Юрг Гуткнехт, Пол Рид

* `impl/rtl/` — описание процессора RISC5 и периферии
* `impl/ext/oberon-src/`, `impl/ext/po2013-src/` — исходники системы
* `impl/ext/disk/Oberon-2016-08-02.dsk` — образ системы
* `site/oberon/oberon.dsk` — тот же образ для браузера

Источник: [projectoberon.net](http://www.projectoberon.net/).
Текст уведомления: `impl/ext/norebo/license.txt`.

Наша правка: 53 строки в `RISC5.v` — добавленная команда проверки границ, ради
которой затевалось измерение. `Registers.v` переписан с примитивов Xilinx на
поведенческое описание, чтобы модуль собирался открытым инструментарием.

## project-norebo — Peter De Wachter

* `impl/ext/norebo/` — компилятор Оберона, запускаемый из командной строки

Источник: [github.com/pdewacht/project-norebo](https://github.com/pdewacht/project-norebo).
Условия — те же, что у Project Oberon (`impl/ext/norebo/license.txt`).

Наша правка: счётчик тактов и профилировщик в рантайме.

## oberon-risc-emu — Peter De Wachter

* `impl/ext/refemu/` — эталонный эмулятор, против которого идёт пошаговая сверка

Источник: [github.com/pdewacht/oberon-risc-emu](https://github.com/pdewacht/oberon-risc-emu).
Уведомление: `impl/ext/refemu/LICENSE` — перенесено из README упомянутого
репозитория, отдельного файла лицензии там нет.

Наша правка: счётчик тактов и трассировка для дифференциального стенда.

## Чего здесь нет намеренно

**Библиотека ячеек Nangate45** (`impl/syn/lib/*.lib`) в репозиторий не входит.
Её шапка прямо запрещает публикацию: *«provided pursuant to a License Agreement
containing restrictions on its use»*, *«does not indicate actual or intended
publication of this file»*.

Без неё работает всё, кроме `make syn` и `make fmax` — оценки площади и частоты.
`make deps` про её отсутствие предупреждает. Если она у вас есть, положите её в
`impl/syn/lib/`.
