# Цель RISC5 для QEMU — своя сборка.
QEMU_DECODETREE ?= /tmp/decodetree.py

.PHONY: check decodetree help

help:
	@echo "  make check   проверить декодер генератором самого QEMU"

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
