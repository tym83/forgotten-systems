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
# ⚠ Пинуем, а не берём master: сборка обязана быть воспроизводимой. На master
# уже менялось поведение журнала `-d cpu` — и сверка с RTL поехала так, что
# выглядело ошибкой реализации, а не сменой версии.
QEMU_REF ?= v9.2.4

build:
	@test -d $(QEMU_SRC) || git clone --depth 1 -b $(QEMU_REF) \
	  https://gitlab.com/qemu-project/qemu.git $(QEMU_SRC)
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
