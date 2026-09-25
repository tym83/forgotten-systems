# Декодер порождается из insn.decode генератором самого QEMU. Ширина команды
# 32 бита — у RISC5 все четыре формата одинаковой длины, что и делает декодер
# таким коротким.
gen = [
  decodetree.process('insn.decode', extra_args: [ '--static-decode', 'decode_insn',
                                                  '--insnwidth', '32' ])
]

risc5_ss = ss.source_set()
risc5_system_ss = ss.source_set()

risc5_ss.add(gen)
risc5_ss.add(files(
  'translate.c',
  'helper.c',
  'fp.c',
  'cpu.c'))

# Ответы наблюдателю нужны только в системной сборке.
risc5_system_ss.add(files('qmp-cmds.c'))

target_arch += {'risc5': risc5_ss}
target_system_arch += {'risc5': risc5_system_ss}
