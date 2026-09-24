// Диск в памяти: тот же протокол SD поверх SPI, что в эталонном эмуляторе,
// но образ лежит байтовым массивом, а не файлом. Нужно для браузера:
// в WASM нет файловой системы, образ приходит из JS.
// Логика повторяет tb/disk/disk.c слово в слово, включая определение
// образа-«только файловая система» по сигнатуре 0x9B1EA38D в нулевом секторе.
#pragma once
#include <cstdint>
#include <cstring>
#include <vector>

struct MemDisk {
    enum State { Command, Read, Write, Writing };
    State state = Command;
    std::vector<uint8_t> img;
    uint32_t offset = 0;
    uint32_t pos = 0;                 // позиция в байтах
    uint32_t rx_buf[128] = {0};
    int rx_idx = 0;
    uint32_t tx_buf[130] = {0};
    int tx_cnt = 0, tx_idx = 0;

    /* Чтение образа из лабораторной: проверка должна убеждаться, что файл на
       диске действительно изменился, а не верить надписи на экране. */
    uint32_t word(size_t off) const {
        uint32_t v = 0;
        for (int b = 0; b < 4; b++)
            v |= (uint32_t)(off + b < img.size() ? img[off + b] : 0) << (b * 8);
        return v;
    }
    uint32_t size() const { return (uint32_t)img.size(); }

    void init(const uint8_t* data, size_t len) {
        img.assign(data, data + len);
        uint32_t s0[128];
        seek(0); read_sector(s0);
        offset = (s0[0] == 0x9B1EA38D) ? 0x80002u : 0u;
    }
    void seek(uint32_t sec) { pos = sec * 512u; }
    void read_sector(uint32_t buf[128]) {
        for (int i = 0; i < 128; i++) {
            uint32_t v = 0;
            for (int b = 0; b < 4; b++) {
                size_t k = (size_t)pos + i * 4 + b;
                v |= (uint32_t)(k < img.size() ? img[k] : 0) << (b * 8);
            }
            buf[i] = v;
        }
        pos += 512;
    }
    void write_sector(const uint32_t buf[128]) {
        // ⚠ Найдено аудитом: pos = sec*512u переполняется в uint32, и при
        // испорченном номере сектора resize пытался выделить до 4 ГБ — то есть
        // abort() в WASM и убитая вкладка. Растём только в разумных пределах.
        static const size_t MAX_GROWTH = 16u << 20;      // 16 МБ сверх образа
        size_t need = (size_t)pos + 512;
        if (need > img.size()) {
            if (need > img.size() + MAX_GROWTH) return;  // запись мимо — игнорируем
            img.resize(need, 0);
        }
        for (int i = 0; i < 128; i++)
            for (int b = 0; b < 4; b++)
                img[(size_t)pos + i * 4 + b] = (uint8_t)(buf[i] >> (b * 8));
        pos += 512;
    }
    void run_command() {
        uint32_t cmd = rx_buf[0];
        uint32_t arg = (rx_buf[1] << 24) | (rx_buf[2] << 16) | (rx_buf[3] << 8) | rx_buf[4];
        switch (cmd) {
            case 81:                              // CMD17: чтение сектора
                state = Read; tx_buf[0] = 0; tx_buf[1] = 254;
                seek(arg - offset); read_sector(&tx_buf[2]);
                tx_cnt = 2 + 128; break;
            case 88:                              // CMD24: запись сектора
                state = Write; seek(arg - offset);
                tx_buf[0] = 0; tx_cnt = 1; break;
            default:
                tx_buf[0] = 0; tx_cnt = 1; break;
        }
        tx_idx = -1;
    }
    uint32_t read() {
        return (tx_idx >= 0 && tx_idx < tx_cnt) ? tx_buf[tx_idx] : 255u;
    }
    void write(uint32_t value) {
        tx_idx++;
        switch (state) {
            case Command:
                if ((uint8_t)value != 0xFF || rx_idx != 0) {
                    rx_buf[rx_idx++] = value;
                    if (rx_idx == 6) { run_command(); rx_idx = 0; }
                }
                break;
            case Read:
                if (tx_idx == tx_cnt) { state = Command; tx_cnt = 0; tx_idx = 0; }
                break;
            case Write:
                if (value == 254) state = Writing;
                break;
            case Writing:
                if (rx_idx < 128) rx_buf[rx_idx] = value;
                rx_idx++;
                if (rx_idx == 128) write_sector(rx_buf);
                if (rx_idx == 130) {
                    tx_buf[0] = 5; tx_cnt = 1; tx_idx = -1; rx_idx = 0; state = Command;
                }
                break;
        }
    }
};
