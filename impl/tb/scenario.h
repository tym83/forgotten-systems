#pragma once
// Переносимый каркас оснастки: сценарный ввод и выгрузка экрана.
//
// Зачем отдельным файлом. В плане платформы первым шагом стоит «вынести
// оснастку RISC5 в переносимый каркас»: без этого вторая машина стоит столько
// же, сколько первая. Здесь собрано ровно то, что от архитектуры НЕ зависит —
// язык сценария, его разбор и проигрывание, формат выгрузки кадра. Всё, что
// зависит, машина сообщает через маленький адаптер ниже.
//
// Язык сценария (строка на событие, «#» — комментарий):
//   <инструкция> M <x> <y> <кнопки>   поставить указатель
//   <инструкция> K <скан-код>         послать код клавиши
//   <инструкция> S <файл>             выгрузить экран
//
// Координата y в сценарии задаётся в системе машины (как её видит драйвер),
// перевод «как на картинке» делает генератор tools/mkscript.py.

#include <cstdio>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>

namespace harness {

struct Event { uint64_t at; char kind; int a, b, c; std::string str; };

inline std::vector<Event> load_script(const char* path) {
    std::vector<Event> ev;
    FILE* f = fopen(path, "r");
    if (!f) return ev;
    char line[256];
    while (fgets(line, sizeof line, f)) {
        if (line[0] == '#' || line[0] == '\n') continue;
        unsigned long long at; char k; char rest[200] = {0};
        if (sscanf(line, "%llu %c %199[^\n]", &at, &k, rest) < 2) continue;
        Event e{at, k, 0, 0, 0, ""};
        if (k == 'M') sscanf(rest, "%d %d %d", &e.a, &e.b, &e.c);
        else if (k == 'K') sscanf(rest, "%d", &e.a);
        else e.str = rest;
        ev.push_back(e);
    }
    fclose(f);
    return ev;
}

// Описание экрана конкретной машины. Единственное, что здесь зависит от
// архитектуры: где лежит кадровый буфер, какого он размера и в каком порядке
// идут строки. У RISC5 строки хранятся СНИЗУ ВВЕРХ (VID.v: vidadr = Org +
// {3'b0, ~vcnt, hword}), поэтому наивная выкладка даёт перевёрнутый экран.
struct Screen {
    const uint32_t* words;      // начало кадрового буфера
    int width, height;          // в пикселях
    bool bottom_up;             // строки идут снизу вверх
};

// Выгрузка в PBM (P1). ВАЖНО: в этом формате 1 — ЧЁРНЫЙ, 0 — белый. В кадровом
// буфере Оберона единицы это текст, нули — белый фон; обратная выкладка даёт
// негатив. На этом мы один раз уже споткнулись (находка аудита).
inline bool dump_pbm(const Screen& s, const char* path) {
    FILE* f = fopen(path, "wb");
    if (!f) return false;
    const int wpl = s.width / 32;
    fprintf(f, "P1\n%d %d\n", s.width, s.height);
    for (int y = 0; y < s.height; y++) {
        int src = s.bottom_up ? (s.height - 1 - y) : y;
        for (int x = 0; x < s.width; x++) {
            uint32_t w = s.words[src * wpl + (x >> 5)];
            fputc(((w >> (x & 31)) & 1) ? '1' : '0', f);
            fputc(' ', f);
        }
        fputc('\n', f);
    }
    fclose(f);
    return true;
}

// Адаптер машины. Три действия — больше сценарию ничего не нужно.
struct Host {
    virtual void set_mouse(int x, int y, int keys) = 0;
    virtual void push_key(uint8_t code) = 0;
    virtual Screen screen() = 0;
    virtual ~Host() {}
};

// Проигрыватель: отдаёт события, чей момент уже наступил.
struct Player {
    std::vector<Event> ev;
    size_t i = 0;
    bool verbose = true;

    void load(const std::string& path) {
        if (path.empty()) return;
        ev = load_script(path.c_str());
        if (verbose) printf("  сценарий: %s, событий %zu\n", path.c_str(), ev.size());
    }

    void advance(uint64_t now, Host& h) {
        while (i < ev.size() && ev[i].at <= now) {
            const Event& e = ev[i++];
            if (e.kind == 'M') {
                h.set_mouse(e.a, e.b, e.c);
                if (verbose) printf("  [%llu] мышь %d,%d кнопки %d\n",
                                    (unsigned long long)now, e.a, e.b, e.c);
            } else if (e.kind == 'K') {
                h.push_key((uint8_t)e.a);
                if (verbose) printf("  [%llu] клавиша %02X\n",
                                    (unsigned long long)now, e.a);
            } else if (e.kind == 'S') {
                if (dump_pbm(h.screen(), e.str.c_str()) && verbose)
                    printf("  экран выгружен: %s\n", e.str.c_str());
            }
        }
    }
};

}  // namespace harness
