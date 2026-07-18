// Exact connected-K-set Node--Kayles recursion for a fixed graph of at most 128 vertices.

#include <array>
#include <cstdint>
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <stdexcept>
#include <unordered_map>
#include <vector>

struct Mask {
    uint64_t lo = 0;
    uint64_t hi = 0;
    friend bool operator==(Mask a, Mask b) { return a.lo == b.lo && a.hi == b.hi; }
};

struct MaskHash {
    size_t operator()(Mask value) const {
        uint64_t x = value.lo ^ (value.hi + 0x9e3779b97f4a7c15ULL +
                                 (value.lo << 6) + (value.lo >> 2));
        x ^= x >> 30;
        x *= 0xbf58476d1ce4e5b9ULL;
        x ^= x >> 27;
        x *= 0x94d049bb133111ebULL;
        return static_cast<size_t>(x ^ (x >> 31));
    }
};

static Mask operator&(Mask a, Mask b) { return {a.lo & b.lo, a.hi & b.hi}; }
static Mask operator|(Mask a, Mask b) { return {a.lo | b.lo, a.hi | b.hi}; }
static Mask and_not(Mask a, Mask b) { return {a.lo & ~b.lo, a.hi & ~b.hi}; }
static bool empty(Mask a) { return a.lo == 0 && a.hi == 0; }

static int pop_first(Mask &mask) {
    if (mask.lo) {
        int bit = __builtin_ctzll(mask.lo);
        mask.lo &= mask.lo - 1;
        return bit;
    }
    int bit = __builtin_ctzll(mask.hi);
    mask.hi &= mask.hi - 1;
    return bit + 64;
}

static Mask singleton(int vertex) {
    return vertex < 64 ? Mask{1ULL << vertex, 0} : Mask{0, 1ULL << (vertex - 64)};
}

struct LimitReached : std::runtime_error {
    LimitReached() : std::runtime_error("state limit reached") {}
};

class Solver {
  public:
    explicit Solver(size_t limit) : limit_(limit) {}

    uint8_t nimber(Mask mask) {
        if (empty(mask)) return 0;
        std::vector<Mask> parts = components(mask);
        if (parts.size() != 1) {
            ++decompositions;
            uint8_t value = 0;
            for (Mask part : parts) value ^= nimber(part);
            return value;
        }
        auto found = cache_.find(mask);
        if (found != cache_.end()) {
            ++cache_hits;
            return found->second;
        }
        if (cache_.size() >= limit_) {
            limit_vertices = __builtin_popcountll(mask.lo) + __builtin_popcountll(mask.hi);
            throw LimitReached();
        }
        ++connected_states;
        std::array<uint64_t, 2> seen{};
        Mask moves = mask;
        while (!empty(moves)) {
            int vertex = pop_first(moves);
            uint8_t child = nimber(and_not(mask, closed[vertex]));
            if (child < 64) seen[0] |= 1ULL << child;
            else seen[1] |= 1ULL << (child - 64);
        }
        uint8_t value;
        if (~seen[0]) value = static_cast<uint8_t>(__builtin_ctzll(~seen[0]));
        else value = static_cast<uint8_t>(64 + __builtin_ctzll(~seen[1]));
        cache_.emplace(mask, value);
        return value;
    }

    std::vector<Mask> adjacency;
    std::vector<Mask> closed;
    uint64_t cache_hits = 0;
    uint64_t connected_states = 0;
    uint64_t decompositions = 0;
    int limit_vertices = -1;

  private:
    std::vector<Mask> components(Mask mask) const {
        std::vector<Mask> result;
        Mask unseen = mask;
        while (!empty(unseen)) {
            int seed_vertex = pop_first(unseen);
            Mask component = singleton(seed_vertex);
            Mask frontier = component;
            while (!empty(frontier)) {
                int vertex = pop_first(frontier);
                Mask added = adjacency[vertex] & unseen;
                unseen = and_not(unseen, added);
                frontier = frontier | added;
                component = component | added;
            }
            result.push_back(component);
        }
        return result;
    }

    size_t limit_;
    std::unordered_map<Mask, uint8_t, MaskHash> cache_;
};

int main(int argc, char **argv) {
    if (argc < 2 || argc > 3) {
        std::cerr << "usage: c294-kset-nimber STATE_LIMIT [OUTPUT]\n";
        return 2;
    }
    size_t limit = std::strtoull(argv[1], nullptr, 10);
    int field_order;
    int type_index;
    int size;
    if (!(std::cin >> field_order >> type_index >> size) || size < 0 || size > 128) return 2;
    Solver solver(limit);
    solver.adjacency.resize(size);
    solver.closed.resize(size);
    for (int vertex = 0; vertex < size; ++vertex) {
        std::cin >> solver.adjacency[vertex].lo >> solver.adjacency[vertex].hi;
        solver.closed[vertex] = solver.adjacency[vertex] | singleton(vertex);
    }
    Mask root;
    std::cin >> root.lo >> root.hi;
    bool stopped = false;
    int value = -1;
    try {
        value = solver.nimber(root);
    } catch (const LimitReached &) {
        stopped = true;
    }
    std::ofstream output_file;
    std::ostream *output = &std::cout;
    if (argc == 3) {
        output_file.open(argv[2]);
        if (!output_file) return 2;
        output = &output_file;
    }
    *output << "{\n"
              << "  \"cache_hits\": " << solver.cache_hits << ",\n"
              << "  \"connected_states\": " << solver.connected_states << ",\n"
              << "  \"decompositions\": " << solver.decompositions << ",\n"
              << "  \"field_order\": " << field_order << ",\n"
              << "  \"follower_nimber\": " << value << ",\n"
              << "  \"limit_vertices\": " << solver.limit_vertices << ",\n"
              << "  \"state_limit\": " << limit << ",\n"
              << "  \"stopped_at_limit\": " << (stopped ? "true" : "false") << ",\n"
              << "  \"type_index\": " << type_index << "\n"
              << "}\n";
}
