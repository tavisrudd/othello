#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <limits>
#include <string>
#include <vector>

namespace {

constexpr int MAX_WORDS = 48;
constexpr int TARGET_SIZE = 13;
constexpr std::size_t CACHE_SIZE = 1U << 18;

int q;
int direction_count;
int vertex_count;
int word_count;
int nonsquare;
int internal_character;

int mod(std::int64_t value) {
  value %= q;
  return static_cast<int>(value < 0 ? value + q : value);
}

int power(int base, int exponent) {
  int result = 1;
  while (exponent > 0) {
    if (exponent & 1) result = mod(static_cast<std::int64_t>(result) * base);
    base = mod(static_cast<std::int64_t>(base) * base);
    exponent >>= 1;
  }
  return result;
}

int inverse(int value) { return power(mod(value), q - 2); }

int character(int value) {
  value = mod(value);
  if (value == 0) return 0;
  return power(value, (q - 1) / 2) == 1 ? 1 : -1;
}

struct Bits {
  std::array<std::uint64_t, MAX_WORDS> words{};
};

bool any(const Bits &bits) {
  for (int i = 0; i < word_count; ++i) {
    if (bits.words[i]) return true;
  }
  return false;
}

int first(const Bits &bits) {
  for (int i = 0; i < word_count; ++i) {
    if (bits.words[i]) return 64 * i + __builtin_ctzll(bits.words[i]);
  }
  return -1;
}

void clear(Bits &bits, int vertex) {
  bits.words[vertex / 64] &= ~(std::uint64_t{1} << (vertex % 64));
}

void set(Bits &bits, int vertex) {
  bits.words[vertex / 64] |= std::uint64_t{1} << (vertex % 64);
}

Bits intersection(const Bits &left, const Bits &right) {
  Bits result;
  for (int i = 0; i < word_count; ++i) {
    result.words[i] = left.words[i] & right.words[i];
  }
  return result;
}

void subtract(Bits &left, const Bits &right) {
  for (int i = 0; i < word_count; ++i) left.words[i] &= ~right.words[i];
}

struct Vertex {
  int direction;
  int s;
  int a;
  int b;
};

std::vector<Vertex> vertices;
std::vector<Bits> adjacency;

struct CacheEntry {
  std::uint64_t key = std::numeric_limits<std::uint64_t>::max();
  Bits value;
};

std::vector<CacheEntry> forbidden_cache(CACHE_SIZE);

const Bits &forbidden(int left_index, int right_index) {
  if (left_index > right_index) std::swap(left_index, right_index);
  const std::uint64_t key =
      static_cast<std::uint64_t>(left_index) * vertex_count + right_index;
  CacheEntry &entry = forbidden_cache[(key * 11400714819323198485ull) &
                                      (CACHE_SIZE - 1)];
  if (entry.key == key) return entry.value;

  entry.key = key;
  entry.value = Bits{};
  const Vertex &left = vertices[left_index];
  const Vertex &right = vertices[right_index];
  const int determinant = mod(static_cast<std::int64_t>(left.a) * right.b -
                              static_cast<std::int64_t>(right.a) * left.b);
  const int determinant_inverse = inverse(determinant);
  for (int direction = 0; direction < direction_count; ++direction) {
    if (direction == left.direction || direction == right.direction) continue;
    const Vertex &prototype = vertices[direction * q];
    const int first_minor =
        mod(static_cast<std::int64_t>(right.a) * prototype.b -
            static_cast<std::int64_t>(prototype.a) * right.b);
    const int second_minor =
        mod(static_cast<std::int64_t>(left.a) * prototype.b -
            static_cast<std::int64_t>(prototype.a) * left.b);
    const int offset = mod(-static_cast<std::int64_t>(
        mod(static_cast<std::int64_t>(left.s) * first_minor -
            static_cast<std::int64_t>(right.s) * second_minor)) *
                           determinant_inverse);
    set(entry.value, direction * q + offset);
  }
  return entry.value;
}

std::array<int, TARGET_SIZE> chosen{};
std::uint64_t search_nodes = 0;
std::uint64_t geometric_stars = 0;
std::vector<std::array<int, TARGET_SIZE>> witnesses;

struct Coloring {
  std::vector<int> order;
  std::vector<int> bounds;
};

Coloring color_sort(Bits candidates) {
  Coloring result;
  result.order.reserve(vertex_count);
  result.bounds.reserve(vertex_count);
  Bits remaining = candidates;
  int color = 0;
  while (any(remaining)) {
    ++color;
    Bits available = remaining;
    while (any(available)) {
      const int vertex = first(available);
      result.order.push_back(vertex);
      result.bounds.push_back(color);
      clear(remaining, vertex);
      clear(available, vertex);
      subtract(available, adjacency[vertex]);
    }
  }
  return result;
}

void search(int depth, Bits candidates) {
  ++search_nodes;
  if (depth == TARGET_SIZE) {
    ++geometric_stars;
    witnesses.push_back(chosen);
    return;
  }
  Coloring coloring = color_sort(candidates);
  for (int position = static_cast<int>(coloring.order.size()) - 1;
       position >= 0; --position) {
    if (depth + coloring.bounds[position] < TARGET_SIZE) return;
    const int vertex = coloring.order[position];
    if (!(candidates.words[vertex / 64] &
          (std::uint64_t{1} << (vertex % 64)))) {
      continue;
    }
    Bits next = intersection(candidates, adjacency[vertex]);
    for (int i = 0; i < depth; ++i) subtract(next, forbidden(chosen[i], vertex));
    chosen[depth] = vertex;
    search(depth + 1, next);
    clear(candidates, vertex);
  }
}

void build_graph() {
  direction_count = (q - 1) / 2;
  vertex_count = direction_count * q;
  word_count = (vertex_count + 63) / 64;
  if (word_count > MAX_WORDS) throw std::runtime_error("MAX_WORDS too small");

  nonsquare = 2;
  while (character(nonsquare) != -1) ++nonsquare;
  internal_character = q % 4 == 3 ? -1 : 1;

  vertices.reserve(vertex_count);
  for (int direction = 0; direction < direction_count; ++direction) {
    const int u = direction + 1;
    for (int s = 0; s < q; ++s) {
      vertices.push_back({direction, s, u, inverse(u)});
    }
  }

  adjacency.resize(vertex_count);
  for (int i = 0; i < vertex_count; ++i) {
    const Vertex &left = vertices[i];
    for (int j = 0; j < i; ++j) {
      const Vertex &right = vertices[j];
      if (left.direction == right.direction) continue;
      const int determinant =
          mod(static_cast<std::int64_t>(left.a) * right.b -
              static_cast<std::int64_t>(right.a) * left.b);
      const int determinant_inverse = inverse(determinant);
      const int x = mod(static_cast<std::int64_t>(left.b) * right.s -
                        static_cast<std::int64_t>(right.b) * left.s);
      const int y = mod(static_cast<std::int64_t>(right.a) * left.s -
                        static_cast<std::int64_t>(left.a) * right.s);
      const int node_value =
          mod(static_cast<std::int64_t>(x) * y * determinant_inverse *
                  determinant_inverse -
              nonsquare);
      if (character(node_value) == internal_character) {
        set(adjacency[i], j);
        set(adjacency[j], i);
      }
    }
  }
}

void write_output(const std::string &path, int seed_s) {
  std::ofstream out(path);
  if (!out) throw std::runtime_error("cannot open output");
  out << "{\n  \"q\": " << q << ",\n";
  out << "  \"seed_s\": " << seed_s << ",\n";
  out << "  \"search_nodes\": " << search_nodes << ",\n";
  out << "  \"geometric_stars\": " << geometric_stars << ",\n";
  out << "  \"witnesses\": [";
  for (std::size_t w = 0; w < witnesses.size(); ++w) {
    if (w) out << ',';
    out << "\n    [";
    for (int i = 0; i < TARGET_SIZE; ++i) {
      if (i) out << ',';
      const Vertex &vertex = vertices[witnesses[w][i]];
      out << '[' << vertex.direction << ',' << vertex.s << ']';
    }
    out << ']';
  }
  if (!witnesses.empty()) out << '\n';
  out << "  ]\n}\n";
}

}  // namespace

int main(int argc, char **argv) {
  if (argc != 4) {
    std::cerr << "usage: mixed-star-geometry Q SEED_S OUTPUT.json\n";
    return 2;
  }
  q = std::stoi(argv[1]);
  const int seed_s = std::stoi(argv[2]);
  if (q != 71 && q != 73) {
    std::cerr << "only q=71 and q=73 are supported\n";
    return 2;
  }
  if (seed_s < 0 || seed_s >= q) {
    std::cerr << "seed out of range\n";
    return 2;
  }
  build_graph();
  const int seed = seed_s;
  chosen[0] = seed;
  search(1, adjacency[seed]);
  write_output(argv[3], seed_s);
  return 0;
}
