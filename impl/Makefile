# Oberon-lab: RISC5 под Verilator + тесты + синтез
RTL  := rtl/RISC5.v rtl/Registers.v rtl/Multiplier.v rtl/Divider.v \
        rtl/FPAdder.v rtl/FPMultiplier.v rtl/FPDivider.v \
        rtl/LeftShifter.v rtl/RightShifter.v
# Кэш байт-кода Python опасен для воспроизводимости: время файлов на macOS
# имеет секундную гранулярность, и правка инструмента в ту же секунду, в
# которую был записан .pyc, оставляет в работе СТАРЫЙ код. Ловилось вживую:
# восстановленный из копии дизассемблер продолжал выдавать мутированный разбор.
export PYTHONDONTWRITEBYTECODE := 1

VFLAGS := -Wno-fatal --cc --build --exe --public-flat-rw -CFLAGS "-O2 -I../../tb"
TESTS  := t1_latency t1_flags t1_fpb2b t1_fp t1_arith t1_umul t1_probe_flags \
          t1_branch t1_branch_width t1_logic t1_dontcare t1_prime t1_alu_diff1 t1_alu_diff2 t1_shift t1_mem t1_movspec t1_irq
ASM    := $(patsubst %,tests/%.bin,$(TESTS) t2_chk t2_chk_hi)

.PHONY: site all check test roundtrip pristine bootstrap rebuild book labs image lab image-check equiv lockstep lockstep-chk boot boot-chk selfhost syn configs tools web deps clean
all: tools build/obj_tests/run_tests build/obj_chk/run_tests_chk $(ASM)

# ───────────────────────────────────────────────────────────────────────────
# Внешние инструменты. Раньше лежали в дереве как готовые бинарники без единого
# правила сборки — на не-macOS/не-ARM не собиралось НИЧЕГО (найдено аудитом).
# ───────────────────────────────────────────────────────────────────────────
NOREBO := ext/norebo/norebo.bin
REFTOOLS := ext/refemu/refboot ext/refemu/reftrace

tools: $(NOREBO) $(REFTOOLS)

# ⚠ Имя norebo.bin, а не norebo: на файловых системах, нечувствительных к регистру
# (macOS по умолчанию), цель `norebo` совпадает с каталогом `Norebo/`, и make
# считает её готовой. Поэтому собираем напрямую и под другим именем.
$(NOREBO): ext/norebo/Runtime/norebo.c ext/norebo/Runtime/risc-cpu.c
	@$(CC) -o $@ $^ -O2 -std=c99 -w
	@echo "собран $@"

ext/refemu/refboot: ext/refemu/boot.c ext/refemu/risc.c ext/refemu/risc-fp.c ext/refemu/disk.c
	@$(CC) -o $@ $^ -O2 -std=c99 -w

ext/refemu/reftrace: ext/refemu/trace.c ext/refemu/risc.c ext/refemu/risc-fp.c ext/refemu/disk.c
	@$(CC) -o $@ $^ -O2 -std=c99 -w

# Браузерная сборка. Команды emcc не было нигде — аудитор восстанавливал её
# по косвенным признакам.
VINC := $(shell verilator --getenv VERILATOR_ROOT)/include
WASM_SRC := $$(ls build/obj_wasm/*.cpp | grep -v "__Dpi\.cpp$$")

web: web/risc5.js web/prom_sd.mem web/oberon.dsk

build/obj_wasm/VRISC5.cpp: $(RTL)
	@verilator -Wno-fatal --cc --public-flat-rw --Mdir build/obj_wasm --top-module RISC5 $(RTL)

# ⚠ Список порождённых файлов берётся ОБОЛОЧКОЙ, а не $(wildcard).
#
# GNU make кэширует содержимое каталога на весь прогон: build/obj_wasm он
# читает раньше, чем verilator туда пишет, и список остаётся пустым. Тогда
# VRISC5.cpp в сборку не попадает, и связывание падает на eval_step.
#
# Локально это не видно: файлы лежат с прошлого раза, и кэш их застаёт. Видно
# только на чистой сборке — то есть там, где собирают все остальные.
web/risc5.js: build/obj_wasm/VRISC5.cpp tb/wasm_main.cpp tb/wasm_stubs.cpp tb/memdisk.h
	@em++ -O3 -I build/obj_wasm -I $(VINC) -I $(VINC)/vltstd -I tb 	  -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=0 -DVM_TRACE_FST=0 -DVM_TRACE_VCD=0 -DVM_TRACE_SAIF=0 	  $$(ls build/obj_wasm/*.cpp | grep -v "__Dpi\.cpp$$") 	  $(VINC)/verilated.cpp $(VINC)/verilated_threads.cpp tb/wasm_main.cpp tb/wasm_stubs.cpp 	  -s EXPORTED_FUNCTIONS='["_soc_init","_soc_run","_soc_framebuffer","_soc_fb_words","_soc_cycles","_soc_insns","_soc_pc","_soc_key","_soc_mouse","_soc_reg","_soc_flags","_soc_h","_soc_ram","_soc_fb_crc","_soc_disk_word","_soc_disk_size","_soc_poke","_malloc","_free"]' 	  -s EXPORTED_RUNTIME_METHODS='["HEAPU8","HEAPU32"]' 	  -s ALLOW_MEMORY_GROWTH=1 -s MODULARIZE=1 -s EXPORT_ES6=1 -s EXPORT_NAME=OberonRISC5 	  -s ENVIRONMENT=web,node -s FILESYSTEM=0 -o $@

web/prom_sd.mem: rtl/prom_sd.mem
	@cp $< $@
web/oberon.dsk: ext/disk/Oberon-2016-08-02.dsk
	@cp $< $@

# Проверка окружения: без этого ошибки вылезают посреди сборки
deps:
	@for t in verilator yosys python3 cc; do \
	  command -v $$t >/dev/null || { echo "НЕТ: $$t"; exit 1; }; \
	  printf "  %-12s ✅ %s\n" "$$t" "$$($$t --version 2>&1 | head -1 | cut -c1-48)"; \
	done
	@command -v em++ >/dev/null && echo "  em++         ✅ (нужен только для make web)" || echo "  em++         ⚠ нет — make web не соберётся"
	@test -f $(SKY130) && echo "  Sky130       ✅" || echo "  Sky130       ⚠ нет — возьмётся сама при make syn (12 МБ)"

# Порождаемые тесты: держим их производными от генераторов, иначе .s может
# отстать от модели и проверка тихо выродится в сверку с самой собой.
tests/t1_alu_diff1.s tests/t1_alu_diff2.s: tools/gen_alu_diff.py tools/alu_model.py tools/asm.py
	@python3 tools/gen_alu_diff.py

tests/t1_dontcare.s: tools/gen_dontcare_test.py
	@python3 tools/gen_dontcare_test.py

tests/t1_branch.s: tools/gen_branch_test.py
	@python3 tools/gen_branch_test.py

tests/%.bin tests/%.chk: tests/%.s tools/asm.py
	@python3 tools/asm.py $<

# 🔴 Найдено аудитом: `|| true` съедал ошибку сборки, и `make test` рапортовал
# «ВСЁ ЗЕЛЁНОЕ» при нуле выполненных тестов. Теперь сборка обязана пройти.
build/obj_tests/run_tests: $(RTL) tb/run_tests.cpp tb/soc_mem.h
	@mkdir -p build
	@verilator $(VFLAGS) -o run_tests --top-module RISC5 --Mdir build/obj_tests $(RTL) tb/run_tests.cpp
	@test -x $@ || { echo "СБОРКА НЕ ДАЛА БИНАРНИКА: $@"; exit 1; }

build/obj_chk/run_tests_chk: $(RTL) tb/run_tests.cpp tb/soc_mem.h
	@mkdir -p build
	@verilator $(VFLAGS) -DWITH_CHK -DCHK_SPLIT -o run_tests_chk --top-module RISC5 --Mdir build/obj_chk $(RTL) tb/run_tests.cpp
	@test -x $@ || { echo "СБОРКА НЕ ДАЛА БИНАРНИКА: $@"; exit 1; }

# Полная регрессия. Базовые тесты обязаны давать ИДЕНТИЧНЫЕ такты на обоих ядрах —
# это и есть проверка «расширение ISA не меняет поведение существующего кода».
test: all
	@mkdir -p build
	@python3 -c "import sys; sys.path.insert(0,'tools'); import asm; sys.exit(asm._selftest())" \
	  > build/asm_selftest.txt \
	  || { cat build/asm_selftest.txt; echo "  ❌ самотест ассемблера провален"; exit 1; }
	@tail -1 build/asm_selftest.txt
	@python3 tools/sweep_encoding.py > build/sweep.txt \
	  || { cat build/sweep.txt; echo "  ❌ перебор кодировок провален"; exit 1; }
	@head -2 build/sweep.txt
	@fail=0; \
	for t in $(TESTS); do \
	  for v in "build/obj_tests/run_tests:базовое" "build/obj_chk/run_tests_chk:с CHK"; do \
	    bin=$${v%%:*}; name=$${v##*:}; \
	    out=$$($$bin tests/$$t); rc=$$?; \
	    printf "  %-12s %-9s %s\n" "$$t" "$$name" "$$(echo "$$out" | tail -1)"; \
	    [ $$rc -eq 0 ] || fail=1; \
	  done; \
	done; \
	for t in t2_chk t2_chk_hi; do \
	  out=$$(build/obj_chk/run_tests_chk tests/$$t); rc=$$?; \
	  printf "  %-12s %-9s %s\n" "$$t" "с CHK" "$$(echo "$$out" | tail -1)"; \
	  [ $$rc -eq 0 ] || fail=1; \
	done; \
	echo; [ $$fail -eq 0 ] || { echo "ЕСТЬ ПРОВАЛЫ ❌"; exit 1; }; \
	$(MAKE) --no-print-directory equiv && echo && echo "ВСЁ ЗЕЛЁНОЕ ✅"

# Проверка эквивалентности декодера: все 256 комбинаций {IR[31:28] x op}
# на пяти наборах операндов. Различаться должна РОВНО одна кодировка.
# В RISC5 нет ловушки на неизвестную инструкцию, поэтому занятие чужой
# кодировки проявилось бы молчаливым изменением поведения старого кода.
equiv:
	@verilator $(VFLAGS) -o deq_base --top-module RISC5 --Mdir build/obj_deqb $(RTL) tb/decoder_equiv.cpp 2>&1 | grep -E "error:" || true
	@verilator $(VFLAGS) -DWITH_CHK -DCHK_SPLIT -o deq_chk --top-module RISC5 --Mdir build/obj_deqc $(RTL) tb/decoder_equiv.cpp 2>&1 | grep -E "error:" || true
	@./build/obj_deqb/deq_base > build/deq_base.txt
	@./build/obj_deqc/deq_chk  > build/deq_chk.txt
	@python3 tools/cmp_decoder.py build/deq_base.txt build/deq_chk.txt

# Дифференциальный стенд: RTL против эталонного эмулятора, инструкция за
# инструкцией, на загрузке настоящей системы Оберон.
REFOBJ := build/refobj/risc.o build/refobj/risc-fp.o build/refobj/disk.o
$(REFOBJ): build/refobj/%.o: ext/refemu/%.c
	@mkdir -p build/refobj && cc -O2 -std=c99 -w -c $< -o $@

lockstep: $(REFOBJ)
	@cp -f ext/disk/Oberon-2016-08-02.dsk build/disk_rtl.dsk
	@cp -f ext/disk/Oberon-2016-08-02.dsk build/disk_ref.dsk
	@verilator $(VFLAGS) -CFLAGS "-I../../ext/refemu" -o lockstep --top-module RISC5 \
	  --Mdir build/obj_ls $(RTL) tb/lockstep.cpp \
	  ../../build/refobj/risc.o ../../build/refobj/risc-fp.o ../../build/refobj/disk.o \
	  2>&1 | grep -E "error:" || true
	@./build/obj_ls/lockstep --max=15000000

# Загрузка системы на RTL с выгрузкой экрана
# Эталонная контрольная сумма кадрового буфера после загрузки системы.
# Совпадает во всех сборках: нативной с файловым диском, нативной с диском
# в памяти и в WASM.
BOOT_CRC := B5DFC933

boot:
	@mkdir -p build
	@verilator $(VFLAGS) -o soc_tb --top-module RISC5 --Mdir build/obj_soc $(RTL) tb/soc_tb.cpp tb/disk/disk.c
	@./build/obj_soc/soc_tb --prom=rtl/prom_sd.mem --max=12000000 --expect-crc=$(BOOT_CRC)

# Те же системные прогоны на ядре С расширением ISA. Найдено аудитом: все системные
# доказательства (lockstep, загрузка, CRC экрана) снимались только на базовом ядре.
lockstep-chk: $(REFOBJ)
	@cp -f ext/disk/Oberon-2016-08-02.dsk build/disk_rtl.dsk
	@cp -f ext/disk/Oberon-2016-08-02.dsk build/disk_ref.dsk
	@verilator $(VFLAGS) -DWITH_CHK -DCHK_SPLIT -CFLAGS "-I../../ext/refemu" -o lockstep_chk \
	  --top-module RISC5 --Mdir build/obj_ls_chk $(RTL) tb/lockstep.cpp \
	  ../../build/refobj/risc.o ../../build/refobj/risc-fp.o ../../build/refobj/disk.o \
	  2>&1 | grep -E "error:" || true
	@./build/obj_ls_chk/lockstep_chk --max=15000000

boot-chk:
	@mkdir -p build
	@verilator $(VFLAGS) -DWITH_CHK -DCHK_SPLIT -o soc_tb_chk --top-module RISC5 --Mdir build/obj_soc_chk $(RTL) tb/soc_tb.cpp tb/disk/disk.c
	@./build/obj_soc_chk/soc_tb_chk --prom=rtl/prom_sd.mem --max=12000000 --expect-crc=$(BOOT_CRC)

# ───────────────────────────────────────────────────────────────────────────
# Полная проверка. Раньше сильнейшие проверки (диффстенд, загрузка системы)
# были отдельными целями и ни от чего не зависели — то есть в гейт не входили.
# ───────────────────────────────────────────────────────────────────────────
check: pristine test boot boot-chk lockstep selfhost roundtrip bootstrap rebuild book labs
	@echo
	@echo "═══ ПОЛНАЯ ПРОВЕРКА ПРОЙДЕНА ═══"

# Замыкание круга: компилятор Оберона работает на настоящем RTL, а не на
# эмуляторе, и порождает побайтово тот же код.
build/obj_nb/norebo_tb: $(RTL) tb/norebo_tb.cpp tb/norebo_bridge.cpp
	@mkdir -p build
	@verilator $(VFLAGS) -o norebo_tb --top-module RISC5 --Mdir build/obj_nb $(RTL) tb/norebo_tb.cpp tb/norebo_bridge.cpp
	@test -x $@ || { echo "СБОРКА НЕ ДАЛА БИНАРНИКА: $@"; exit 1; }

selfhost: build/obj_nb/norebo_tb $(NOREBO)
	@bash tools/selfhost_rtl.sh

# Замкнутый круг на НАСТОЯЩЕМ выводе компилятора Вирта: каждое слово кода из
# .rsc дизассемблируется и собирается обратно, требуется побитовое совпадение.
# Зависит от selfhost — объектные файлы порождает он.
roundtrip:
	@test -f build/self_rtl/ORP.rsc \
	  || { echo "  ❌ нет объектных файлов, сначала make selfhost"; exit 1; }
	@python3 tools/roundtrip.py build/self_rtl/*.rsc build/self_emu/*.rsc

# Образ с инструментарием для лабораторных, которым не хватает браузера.
# Правка процессора и правка компилятора требуют верилятора и сборки — это
# обычная пакетная нагрузка, и она одинаково запускается локально и заданием
# в кластере (deploy/k8s/lab-job.yaml).
IMAGE ?= oberon-lab:dev

image:
	@docker build -f deploy/Containerfile -t $(IMAGE) .
	@docker image ls $(IMAGE) --format "  образ {{.Repository}}:{{.Tag}}, {{.Size}}"

# Прогон лабораторной в контейнере. Правка подаётся каталогом:
#   make lab WORK=build/labwork TASK=isa
WORK ?= build/labwork
TASK ?= isa

lab:
	@mkdir -p $(WORK)
	@docker run --rm -v "$(PWD)/$(WORK):/work" $(IMAGE) $(TASK)

# Проверка самого образа: на чистом дереве лабораторная обязана пройти,
# на сломанной правке — провалиться. Без второй половины образ бесполезен:
# вердикт, который всегда зелёный, ничего не проверяет.
image-check: image
	@rm -rf build/imgtest && mkdir -p build/imgtest
	@docker run --rm -v "$(PWD)/build/imgtest:/work" $(IMAGE) isa > /dev/null \
	  && echo "  чистое дерево: прошло ✅" \
	  || { echo "  ❌ чистое дерево не прошло"; exit 1; }
	@mkdir -p build/imgtest/rtl
	@sed 's|(~op\[0\] ? B & C1 : B & ~C1)|(~op[0] ? B \& ~C1 : B \& C1)|' \
	  rtl/RISC5.v > build/imgtest/rtl/RISC5.v
	@cmp -s rtl/RISC5.v build/imgtest/rtl/RISC5.v \
	  && { echo "  ❌ пробная правка не применилась"; exit 1; } || true
	@docker run --rm -v "$(PWD)/build/imgtest:/work" $(IMAGE) isa > /dev/null 2>&1 \
	  && { echo "  ❌ сломанная правка прошла"; exit 1; } \
	  || echo "  сломанная правка: провалилась ✅"

# Методичка: docs/book/*.md -> web/book/*.html. Проверяются ссылки между
# главами и ссылки на лабораторные: битая ссылка в учебнике хуже отсутствующей
# главы, потому что выглядит рабочей.
book:
	@python3 tools/mkbook.py

# Сайт: то же, что делает раскладка на Pages. Проверяет состав и местные
# ссылки, поэтому годится как проверка перед пушем, а не только как просмотр.
site: web book
	@cd .. && ./tools/build-site.sh _site

# Лаборатории: безголовый прогон сценариев каждой лабы. Проверка, которая
# всегда зелёная или всегда красная, бесполезна, поэтому тест требует перехода
# из «не сделано» в «сделано» от предусмотренных действий.
labs: web book
	@cd web && node labs-test.mjs

# Полная пересборка системы Обероном внутри самой системы на RTL.
# Три сессии: пачками, затем поодиночке то, что упало в ловушку 4 (исчерпание
# кучи внутри команды). Между сессиями состояние переносится диском.
# Прогон тяжёлый: около миллиарда инструкций, порядка восьми минут.
REBUILD_SRC := build/disksrc

$(REBUILD_SRC):
	@mkdir -p $@
	@python3 -c "import sys; sys.path.insert(0,'tools'); from oberonfs import Image; \
	  img=Image('ext/disk/Oberon-2016-08-02.dsk'); fs=img.files(); \
	  [open('$@/'+n,'wb').write(img.read(h)) for n,h in fs.items() if n.endswith('.Mod')]"

scripts/rebuild1.txt scripts/rebuild2.txt: tools/gen_rebuild.py tools/modorder.py | $(REBUILD_SRC)
	@python3 tools/gen_rebuild.py $(REBUILD_SRC) > /dev/null
	@for n in 1 2; do PYTHONPATH=tools python3 tools/mkscript.py scripts/rebuild$$n.src > scripts/rebuild$$n.txt; done

scripts/rebuild3.txt: scripts/rebuild3.src
	@PYTHONPATH=tools python3 tools/mkscript.py $< > $@

rebuild: scripts/rebuild1.txt scripts/rebuild2.txt scripts/rebuild3.txt
	@mkdir -p build
	@verilator $(VFLAGS) -o soc_tb --top-module RISC5 --Mdir build/obj_soc $(RTL) tb/soc_tb.cpp tb/disk/disk.c
	@cp -f ext/disk/Oberon-2016-08-02.dsk build/rebuild.dsk
	@echo "  пересборка системы внутри системы: 3 сессии, ~8 минут"
	@./build/obj_soc/soc_tb --prom=rtl/prom_sd.mem --max=430000000 \
	  --disk=build/rebuild.dsk --persist --script=scripts/rebuild1.txt | grep -c "экран выгружен" | xargs echo "    сессия 1, снимков:"
	@./build/obj_soc/soc_tb --prom=rtl/prom_sd.mem --max=450000000 \
	  --disk=build/rebuild.dsk --persist --script=scripts/rebuild2.txt | grep -c "экран выгружен" | xargs echo "    сессия 2, снимков:"
	@./build/obj_soc/soc_tb --prom=rtl/prom_sd.mem --max=210000000 \
	  --disk=build/rebuild.dsk --persist --script=scripts/rebuild3.txt | grep -c "экран выгружен" | xargs echo "    сессия 3, снимков:"
	@python3 tools/check_rebuild.py ext/disk/Oberon-2016-08-02.dsk build/rebuild.dsk
	@cp -f build/rebuild.dsk build/rebuild_boot.dsk
	@./build/obj_soc/soc_tb --prom=rtl/prom_sd.mem --max=12000000 \
	  --disk=build/rebuild_boot.dsk --expect-crc=$(BOOT_CRC) | grep -E "совпал|❌"

# Эталонный образ диска — источник истины. Эмулятор диска пишет в образ
# настоящие сектора, так что прогон, случайно пущенный прямо на нём, молча
# портит исходник. Проверка загрузки этого не ловит: её контрольная сумма
# совпадает и на испорченном образе.
pristine:
	@cd ext/disk && shasum -a 256 -c SHA256SUMS >/dev/null \
	  && echo "  эталонный образ диска ✅" \
	  || { echo "  ❌ эталонный образ диска изменён — восстановите из upstream"; exit 1; }

# Самораскрутка внутри самой системы: ни одной строки кода с хоста в контуре,
# только мышь и клавиатура. Два поколения компилятора должны совпасть.
# Прогон тяжёлый: 715 млн инструкций, около четырёх минут.
scripts/gen2_sep.txt: scripts/gen2_sep.src tools/mkscript.py tools/keymap.py
	@PYTHONPATH=tools python3 tools/mkscript.py $< > $@

bootstrap: scripts/gen2_sep.txt
	@mkdir -p build
	@verilator $(VFLAGS) -o soc_tb --top-module RISC5 --Mdir build/obj_soc $(RTL) tb/soc_tb.cpp tb/disk/disk.c
	@echo "  самораскрутка внутри системы: 715 млн инструкций, ~4 минуты"
	@./build/obj_soc/soc_tb --prom=rtl/prom_sd.mem --max=715000000 \
	  --script=scripts/gen2_sep.txt | grep -E "инструкций|расхождений"
	@python3 tools/check_bootstrap.py build/g2_gen2.pbm

# Библиотека ячеек Sky130 (Apache-2.0) — 12 МБ, тянется по требованию.
# Прежняя Nangate45 распространению не подлежит, см. THIRD-PARTY.md.
SKY130 := syn/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
SKY130_URL := https://raw.githubusercontent.com/The-OpenROAD-Project/OpenROAD-flow-scripts/master/flow/platforms/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

lib: $(SKY130)
$(SKY130):
	@mkdir -p syn/lib && curl -fsSL -o $@ $(SKY130_URL) \
	  && echo "  библиотека ячеек Sky130 загружена ($$(du -h $@ | cut -f1))"

syn: $(SKY130)
	@python3 syn/sweep.py

# ⚠ Патчи кодогенератора живут в patches/, а НЕ в build/ — иначе одна команда clean
# уничтожает все конфигурации вместе с серией измерений (найдено аудитом).
clean:
	@rm -rf build tests/*.bin tests/*.chk
	@echo "патчи кодогенератора сохранены в patches/ — восстановить: make configs"

# Восстановить рабочие каталоги конфигураций из версионируемых патчей
configs:
	@for c in A C D E; do mkdir -p build/cfg$$c && cp patches/ORG-cfg$$c.Mod build/cfg$$c/ORG.Mod; done
	@mkdir -p build/cfgB
	@echo "конфигурации восстановлены из patches/ (B — сток, без патча)"
