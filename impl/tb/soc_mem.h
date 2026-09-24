// Модель памяти для стенда ядра RISC5.
// Одна плоская RAM обслуживает и codebus, и inbus — ровно как настоящий SoC:
// adr либо следующий PC, либо адрес данных (во время stallL0), никогда оба сразу.
// Это и есть фон-неймановское стойло, из-за которого LD/ST стоят 2 такта.
#pragma once
#include <cstdint>
#include <cstring>
#include <vector>

struct Mem {
    static constexpr uint32_t WORDS = 1u << 18;      // 1 МБ
    std::vector<uint32_t> w;
    Mem() : w(WORDS, 0) {}

    uint32_t read(uint32_t byteaddr) const {
        uint32_t i = (byteaddr >> 2) & (WORDS - 1);
        return w[i];
    }
    // ben=0 — слово; ben=1 — байт, выбираемый adr[1:0].
    // Ядро уже разложило байт по нужной полосе outbus (см. RISC5.v assign outbus).
    void write(uint32_t byteaddr, uint32_t data, bool ben) {
        uint32_t i = (byteaddr >> 2) & (WORDS - 1);
        if (!ben) { w[i] = data; return; }
        uint32_t lane = byteaddr & 3;
        uint32_t mask = 0xFFu << (lane * 8);
        w[i] = (w[i] & ~mask) | (data & mask);
    }
    void load_words(uint32_t byteaddr, const uint32_t* src, size_t n) {
        for (size_t k = 0; k < n; k++) w[((byteaddr >> 2) + k) & (WORDS - 1)] = src[k];
    }
};
