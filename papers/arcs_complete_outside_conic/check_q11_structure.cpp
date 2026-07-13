#include <algorithm>
#include <array>
#include <cassert>
#include <iostream>
#include <map>
#include <numeric>
#include <queue>
#include <set>
#include <tuple>
#include <vector>

// Independent prime-field replay of check_q11_structure.py.  This implementation
// shares no project code or generated data beyond the six published coordinates.

namespace {
constexpr int q = 11;
using P = std::array<int, 3>;
using G = std::array<int, 4>;
using M3 = std::array<std::array<int, 3>, 3>;

constexpr std::array<P, 6> arc{{
    P{1, 10, 0}, P{1, 9, 1}, P{1, 4, 7},
    P{1, 8, 5}, P{0, 1, 4}, P{1, 1, 7},
}};

int mod(int x) {
  x %= q;
  return x < 0 ? x + q : x;
}

int inv(int x) {
  x = mod(x);
  for (int y = 1; y < q; ++y) {
    if (x * y % q == 1) return y;
  }
  assert(false);
  return 0;
}

int powmod(int x, int n) {
  int out = 1;
  for (; n; n >>= 1, x = mod(x * x)) if (n & 1) out = mod(out * x);
  return out;
}

template <std::size_t n>
std::array<int, n> normalize(std::array<int, n> x) {
  auto it = std::find_if(x.begin(), x.end(), [](int y) { return mod(y) != 0; });
  assert(it != x.end());
  const int z = inv(*it);
  for (int& y : x) y = mod(z * y);
  return x;
}

int det(P a, P b, P c) {
  return mod(a[0] * (b[1] * c[2] - b[2] * c[1])
      - a[1] * (b[0] * c[2] - b[2] * c[0])
      + a[2] * (b[0] * c[1] - b[1] * c[0]));
}

P add(P a, P b) {
  for (int i = 0; i < 3; ++i) a[i] = mod(a[i] + b[i]);
  return a;
}

P scale(int c, P a) {
  for (int& x : a) x = mod(c * x);
  return a;
}

int encode(P a) { return a[0] * q * q + a[1] * q + a[2]; }

std::vector<P> points() {
  std::vector<P> out;
  for (int y = 0; y < q; ++y)
    for (int z = 0; z < q; ++z) out.push_back({1, y, z});
  for (int z = 0; z < q; ++z) out.push_back({0, 1, z});
  out.push_back({0, 0, 1});
  return out;
}

bool on_conic(P p) { return mod(p[0] * p[2]) == mod(p[1] * p[1]); }

template <typename Container>
bool is_arc(const Container& a) {
  std::set<P> distinct(a.begin(), a.end());
  if (distinct.size() != a.size()) return false;
  for (std::size_t i = 0; i < a.size(); ++i)
    for (std::size_t j = i + 1; j < a.size(); ++j)
      for (std::size_t k = j + 1; k < a.size(); ++k)
        if (det(a[i], a[j], a[k]) == 0) return false;
  return true;
}

template <typename Container>
int secant_index(P p, const Container& a) {
  int result = 0;
  for (std::size_t i = 0; i < a.size(); ++i)
    for (std::size_t j = i + 1; j < a.size(); ++j)
      result += det(a[i], a[j], p) == 0;
  return result;
}

template <typename Container>
std::vector<P> extensions(const Container& a, const std::vector<P>& plane) {
  std::set<P> aset(a.begin(), a.end());
  std::vector<P> out;
  for (P p : plane) {
    if (aset.count(p)) continue;
    bool good = true;
    for (std::size_t i = 0; i < a.size() && good; ++i)
      for (std::size_t j = i + 1; j < a.size(); ++j)
        if (det(a[i], a[j], p) == 0) good = false;
    if (good) out.push_back(p);
  }
  return out;
}

int quadratic_rank(const std::array<P, 6>& a) {
  std::array<std::array<int, 6>, 6> m{};
  for (int i = 0; i < 6; ++i) {
    const auto [x, y, z] = a[i];
    m[i] = {mod(x * x), mod(x * y), mod(x * z), mod(y * y), mod(y * z), mod(z * z)};
  }
  int r = 0;
  for (int c = 0; c < 6; ++c) {
    int pivot = r;
    while (pivot < 6 && m[pivot][c] == 0) ++pivot;
    if (pivot == 6) continue;
    std::swap(m[r], m[pivot]);
    int z = inv(m[r][c]);
    for (int j = c; j < 6; ++j) m[r][j] = mod(z * m[r][j]);
    for (int i = 0; i < 6; ++i) if (i != r && m[i][c]) {
      z = m[i][c];
      for (int j = c; j < 6; ++j) m[i][j] = mod(m[i][j] - z * m[r][j]);
    }
    ++r;
  }
  return r;
}

struct SyndromeSummary {
  std::map<int, int> distances;
  std::map<int, int> leaders2;
  auto operator<=>(const SyndromeSummary&) const = default;
};

template <typename Container>
SyndromeSummary syndrome_summary(const Container& a) {
  std::array<int, q * q * q> distance;
  std::array<int, q * q * q> count2{};
  distance.fill(4);
  distance[0] = 0;
  for (P x : a) for (int c = 1; c < q; ++c)
    distance[encode(scale(c, x))] = std::min(distance[encode(scale(c, x))], 1);
  for (std::size_t i = 0; i < a.size(); ++i)
    for (std::size_t j = i + 1; j < a.size(); ++j)
      for (int c = 1; c < q; ++c) for (int d = 1; d < q; ++d) {
        P s = add(scale(c, a[i]), scale(d, a[j]));
        ++count2[encode(s)];
        distance[encode(s)] = std::min(distance[encode(s)], 2);
      }
  for (std::size_t i = 0; i < a.size(); ++i)
    for (std::size_t j = i + 1; j < a.size(); ++j)
      for (std::size_t k = j + 1; k < a.size(); ++k)
        for (int c = 1; c < q; ++c) for (int d = 1; d < q; ++d)
          for (int e = 1; e < q; ++e) {
            P s = add(add(scale(c, a[i]), scale(d, a[j])), scale(e, a[k]));
            distance[encode(s)] = std::min(distance[encode(s)], 3);
          }
  SyndromeSummary out;
  for (int s = 0; s < q * q * q; ++s) {
    assert(distance[s] <= 3);
    ++out.distances[distance[s]];
    if (distance[s] == 2) ++out.leaders2[count2[s]];
  }
  return out;
}

G gmul(G g, G h) {
  const auto [a, b, c, d] = g;
  const auto [e, f, k, l] = h;
  return normalize(G{a * e + b * k, a * f + b * l, c * e + d * k, c * f + d * l});
}

M3 sym2(G g) {
  const auto [a, b, c, d] = g;
  return {{{mod(a * a), mod(2 * a * b), mod(b * b)},
           {mod(a * c), mod(a * d + b * c), mod(b * d)},
           {mod(c * c), mod(2 * c * d), mod(d * d)}}};
}

P apply(M3 m, P p) {
  P out{};
  for (int i = 0; i < 3; ++i)
    for (int j = 0; j < 3; ++j) out[i] = mod(out[i] + m[i][j] * p[j]);
  return normalize(out);
}

std::vector<G> pgl2() {
  std::set<G> unique;
  for (int a = 0; a < q; ++a) for (int b = 0; b < q; ++b)
    for (int c = 0; c < q; ++c) for (int d = 0; d < q; ++d)
      if (mod(a * d - b * c)) unique.insert(normalize(G{a, b, c, d}));
  return {unique.begin(), unique.end()};
}

int order(G g) {
  const G one{1, 0, 0, 1};
  G x = one;
  for (int n = 1; n <= 120; ++n) {
    x = gmul(x, g);
    if (x == one) return n;
  }
  assert(false);
  return 0;
}

std::set<G> generated(G x, G y) {
  const G one{1, 0, 0, 1};
  std::set<G> seen{one};
  std::queue<G> todo;
  todo.push(one);
  while (!todo.empty()) {
    G z = todo.front();
    todo.pop();
    for (G g : {x, y}) {
      G w = gmul(z, g);
      if (seen.insert(w).second) todo.push(w);
    }
  }
  return seen;
}

template <typename Container>
std::vector<G> stabilizer(const Container& a, const std::vector<G>& pgl) {
  std::set<P> target(a.begin(), a.end());
  std::vector<G> out;
  for (G g : pgl) {
    std::set<P> image;
    for (P p : a) image.insert(apply(sym2(g), p));
    if (image == target) out.push_back(g);
  }
  return out;
}

std::vector<int> orbit_sizes(const std::vector<G>& group, const std::vector<P>& plane) {
  std::set<P> remaining(plane.begin(), plane.end());
  std::vector<int> sizes;
  while (!remaining.empty()) {
    P seed = *remaining.begin();
    std::set<P> orbit;
    for (G g : group) orbit.insert(apply(sym2(g), seed));
    sizes.push_back(static_cast<int>(orbit.size()));
    for (P p : orbit) remaining.erase(p);
  }
  std::sort(sizes.begin(), sizes.end());
  return sizes;
}

std::string map_text(const std::map<int, int>& xs) {
  std::string out;
  for (auto [k, v] : xs) {
    if (!out.empty()) out += ',';
    out += std::to_string(k) + ':' + std::to_string(v);
  }
  return out;
}
}  // namespace

int main() {
  const std::vector<P> plane = points();
  assert(plane.size() == 133);
  assert(is_arc(arc));
  std::vector<P> conic;
  for (P p : plane) if (on_conic(p)) conic.push_back(p);
  assert(conic.size() == 12);
  for (P p : arc) assert(!on_conic(p));

  std::map<int, int> required_indices, conic_indices;
  std::set<P> aset(arc.begin(), arc.end()), cset(conic.begin(), conic.end());
  for (P p : plane) {
    if (aset.count(p)) continue;
    if (cset.count(p)) ++conic_indices[secant_index(p, arc)];
    else ++required_indices[secant_index(p, arc)];
  }
  assert((required_indices == std::map<int, int>{{1, 90}, {2, 15}, {3, 10}}));
  assert((conic_indices == std::map<int, int>{{0, 12}}));
  assert(quadratic_rank(arc) == 6);

  const std::vector<P> ext = extensions(arc, plane);
  assert(std::set<P>(ext.begin(), ext.end()) == cset);
  const SyndromeSummary syndromes = syndrome_summary(arc);
  assert((syndromes.distances == std::map<int, int>{{0, 1}, {1, 60}, {2, 1150}, {3, 120}}));
  assert((syndromes.leaders2 == std::map<int, int>{{1, 900}, {2, 150}, {3, 100}}));

  int edges = 0;
  std::array<int, 12> degrees{};
  std::array<int, 6> color_edges{};
  std::array<std::set<int>, 6> color_vertices;
  std::set<std::pair<int, int>> edge_set;
  for (int i = 0; i < 12; ++i) for (int j = i + 1; j < 12; ++j) {
    std::vector<int> witnesses;
    for (int a = 0; a < 6; ++a) if (det(ext[i], ext[j], arc[a]) == 0) witnesses.push_back(a);
    if (!witnesses.empty()) {
      assert(witnesses.size() == 1);
      ++edges;
      ++degrees[i]; ++degrees[j];
      ++color_edges[witnesses[0]];
      color_vertices[witnesses[0]].insert(i);
      color_vertices[witnesses[0]].insert(j);
      edge_set.insert({i, j});
    }
  }
  assert(edges == 30);
  for (int d : degrees) assert(d == 5);
  for (int a = 0; a < 6; ++a) {
    assert(color_edges[a] == 5);
    assert(color_vertices[a].size() == 10);
    std::set<int> tangents;
    for (int i = 0; i < 12; ++i) {
      int intersections = 0;
      for (int j = 0; j < 12; ++j) intersections += det(arc[a], ext[i], ext[j]) == 0;
      if (intersections == 1) tangents.insert(i);
    }
    std::set<int> missing;
    for (int i = 0; i < 12; ++i) if (!color_vertices[a].count(i)) missing.insert(i);
    assert(missing == tangents && tangents.size() == 2);
  }

  const std::vector<G> pgl = pgl2();
  assert(pgl.size() == 1320);
  const std::vector<G> stab = stabilizer(arc, pgl);
  assert(stab.size() == 60);
  std::map<int, int> orders;
  for (G g : stab) {
    ++orders[order(g)];
    const int determinant = mod(g[0] * g[3] - g[1] * g[2]);
    assert(powmod(determinant, 5) == 1);
  }
  assert((orders == std::map<int, int>{{1, 1}, {2, 15}, {3, 20}, {5, 24}}));
  assert((orbit_sizes(stab, plane) == std::vector<int>{6, 10, 12, 15, 30, 30, 30}));

  G gen2{}, gen3{};
  bool found_generators = false;
  for (G x : stab) if (order(x) == 2) {
    for (G y : stab) if (order(y) == 3 && order(gmul(x, y)) == 5) {
      if (generated(x, y).size() == 60) {
        gen2 = x; gen3 = y; found_generators = true; break;
      }
    }
    if (found_generators) break;
  }
  assert(found_generators);

  std::set<P> arc_orbit, conic_orbit;
  for (G g : stab) {
    arc_orbit.insert(apply(sym2(g), arc[0]));
    conic_orbit.insert(apply(sym2(g), conic[0]));
  }
  assert(arc_orbit.size() == 6 && conic_orbit.size() == 12);
  std::set<std::pair<P, P>> edge_orbit;
  const auto [ei, ej] = *edge_set.begin();
  for (G g : stab) {
    P x = apply(sym2(g), ext[ei]), y = apply(sym2(g), ext[ej]);
    if (y < x) std::swap(x, y);
    edge_orbit.insert({x, y});
  }
  assert(edge_orbit.size() == 30);

  const M3 transform{{{{1, 1, 0}}, {{0, 1, 1}}, {{1, 0, 1}}}};
  std::array<P, 6> transformed_arc{};
  std::vector<P> transformed_conic;
  for (int i = 0; i < 6; ++i) transformed_arc[5 - i] = apply(transform, arc[i]);
  for (P p : conic) transformed_conic.push_back(apply(transform, p));
  const auto transformed_ext = extensions(transformed_arc, plane);
  assert(std::set<P>(transformed_ext.begin(), transformed_ext.end())
      == std::set<P>(transformed_conic.begin(), transformed_conic.end()));
  assert(quadratic_rank(transformed_arc) == 6);
  assert(syndrome_summary(transformed_arc) == syndromes);

  std::array<P, 6> perturbed = arc;
  perturbed[0] = {1, 0, 8};
  assert(is_arc(perturbed));
  const auto perturbed_ext = extensions(perturbed, plane);
  const auto perturbed_stab = stabilizer(perturbed, pgl);
  assert(perturbed_ext.size() == 20 && perturbed_stab.size() == 2);

  G mutated = gen2;
  mutated[0] = mod(mutated[0] + 1);
  if (mod(mutated[0] * mutated[3] - mutated[1] * mutated[2]) == 0 ||
      std::find(stab.begin(), stab.end(), normalize(mutated)) != stab.end()) {
    mutated = gen2;
    mutated[1] = mod(mutated[1] + 1);
  }
  assert(mod(mutated[0] * mutated[3] - mutated[1] * mutated[2]));
  assert(std::find(stab.begin(), stab.end(), normalize(mutated)) == stab.end());

  std::cout << "points=133 conic=12 arc=6 quadratic_rank=6"
            << " required_indices=" << map_text(required_indices)
            << " syndrome_distances=" << map_text(syndromes.distances)
            << " distance2_leaders=" << map_text(syndromes.leaders2)
            << " extensions=12 edges=30 degrees=5x12 colors=5x6 tangents=2x6"
            << " pgl2=1320 stabilizer=60 orders=" << map_text(orders)
            << " orbits=6,10,12,15,30,30,30"
            << " generators=2,3 product=5 generated=60"
            << " transitive=arc6,conic12,edge30"
            << " coordinate_invariance=PASS"
            << " negative=extensions20,stabilizer2,mutated_generator_rejected"
            << '\n';
}
