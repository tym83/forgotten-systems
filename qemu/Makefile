# Цель RISC5 для QEMU — своя сборка.
QEMU_DECODETREE ?= /tmp/decodetree.py

.PHONY: check decodetree help build diff

help:
	@echo "  make check   проверить декодер генератором самого QEMU"
	@echo "  make build   собрать qemu-system-risc5 в контейнере"
	@echo "  make diff    сверить QEMU с моделью, снятой с настоящего RTL"

# Скачиваем генератор, если его нет: он маленький и лежит в дереве QEMU.
$(QEMU_DECODETREE):
	@curl -fsSL -o $@ https://raw.githubusercontent.com/qemu/qemu/master/scripts/decodetree.py

# ⚠ Проверка обязана уметь падать. Генератор ругается, если хоть один бит
# команды не расписан — именно на этом декодер и ловился, пока безразличные
# биты были помечены точкой вместо дефиса.
check: $(QEMU_DECODETREE)
	@python3 $(QEMU_DECODETREE) --output-null target/risc5/insn.decode \
	  && echo "  декодер принят генератором QEMU ✅"
	@python3 $(QEMU_DECODETREE) -o /tmp/risc5-decode.c.inc target/risc5/insn.decode
	@n=$$(grep -c 'trans_' /tmp/risc5-decode.c.inc); \
	  test "$$n" -ge 5 && echo "  функций разбора: $$n (по одной на формат) ✅" \
	  || { echo "  ❌ форматов меньше пяти"; exit 1; }

# Сборка в контейнере: зависимости QEMU на машину разработчика не ставим.
# QEMU_SRC — куда клонировать дерево, по умолчанию рядом, в .qemu-work.
QEMU_SRC ?= ../.qemu-work
# ⚠ Дерево QEMU пинуется КОММИТОМ, а не веткой и не тегом.
#
# Веткой нельзя: master сегодня и master через неделю — разные машины, а сверка
# с RTL, которая не воспроизводится, ничего не доказывает.
#
# Тегом не выходит: цель написана под текущий master, где заголовки лежат в
# hw/core/ и system/. В 10.2 они ещё в hw/ и sysemu/, в 9.2 — тем более, и
# сборка падает на первом же include. Проверено обоими.
QEMU_REF ?= 942229961efea74b153c44c59188eb08375f10f1

build:
	@test -d $(QEMU_SRC) || { mkdir -p $(QEMU_SRC) && cd $(QEMU_SRC) && \
	  git init -q && git remote add origin https://gitlab.com/qemu-project/qemu.git && \
	  git fetch --depth 1 -q origin $(QEMU_REF) && git checkout -q FETCH_HEAD; }
	@./graft.sh $(QEMU_SRC)
	@docker build -q -f build/Containerfile -t qemu-build:risc5 . >/dev/null
	@docker run --rm -v "$$(cd $(QEMU_SRC) && pwd):/src" qemu-build:risc5 \
	  'cd /src && test -d build || ./configure --target-list=risc5-softmmu \
	     --disable-docs --disable-tools --disable-guest-agent \
	     --without-default-features --enable-vnc --enable-pixman >/dev/null; ninja -C build'
	@echo "  собран: $(QEMU_SRC)/build/qemu-system-risc5"

# Главная проверка цели: не «собралось», а «считает то же, что железо».
diff:
	@python3 test/compare.py $(abspath $(QEMU_SRC))
