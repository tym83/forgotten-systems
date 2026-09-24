risc5_ss = ss.source_set()
risc5_ss.add(when: 'CONFIG_OBERON',
             if_true: files('oberon.c', 'io.c', 'spi-disk.c', 'display.c',
                            'input.c'))

hw_arch += {'risc5': risc5_ss}
