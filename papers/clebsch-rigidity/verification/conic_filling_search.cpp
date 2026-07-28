#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <iostream>
#include <numeric>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

using Point = std::array<int, 3>;
using Matrix2 = std::array<int, 4>;
using Matrix3 = std::array<int, 9>;

struct DSU {
  std::vector<int> parent;
  explicit DSU(int n) : parent(n) { std::iota(parent.begin(), parent.end(), 0); }
  int find(int x) {
    while (parent[x] != x) {
      parent[x] = parent[parent[x]];
      x = parent[x];
    }
    return x;
  }
  void join(int x, int y) {
    x = find(x);
    y = find(y);
    if (x != y) parent[y] = x;
  }
};

struct SearchStats {
  std::array<std::uint64_t, 9> states{};
  std::uint64_t multiplicity_prunes = 0;
  std::uint64_t coverage_prunes = 0;
  std::uint64_t terminal_arcs = 0;
  std::uint64_t spectrum_matches = 0;
  std::vector<std::string> witnesses;
};

class Search {
 public:
  explicit Search(int q) : q_(q) {
    if (q_ != 13 && q_ != 17 && q_ != 19)
      throw std::runtime_error("q must be one of 13, 17, 19");
    build_points();
    build_lines();
    build_group();
    build_graph();
    build_edge_orbits();
    validate_forced_spectrum();
  }

  void run() {
    std::cout << "{\n";
    std::cout << "  \"schema\": \"c605-eight-point-conic-filling-v1\",\n";
    std::cout << "  \"q\": " << q_ << ",\n";
    std::cout << "  \"pg2_points\": " << points_.size() << ",\n";
    std::cout << "  \"conic_points\": " << conic_.size() << ",\n";
    std::cout << "  \"off_conic_points\": " << off_.size() << ",\n";
    std::cout << "  \"pgl2_order\": " << group_.size() << ",\n";
    std::cout << "  \"passant_edges\": " << edges_.size() << ",\n";
    std::cout << "  \"edge_orbits\": " << edge_orbits_.size() << ",\n";
    const auto spectrum_zero = forced_spectrum(0);
    const auto spectrum_one = forced_spectrum(1);
    std::cout << "  \"forced_spectrum\": {\"a_range\": [0, "
              << forced_a_max() << "], \"constant\": [";
    for (int i = 0; i < 4; ++i) {
      if (i) std::cout << ", ";
      std::cout << spectrum_zero[i];
    }
    std::cout << "], \"a_coefficient\": [";
    for (int i = 0; i < 4; ++i) {
      if (i) std::cout << ", ";
      std::cout << spectrum_one[i] - spectrum_zero[i];
    }
    std::cout << "], \"moment_identities_checked\": true},\n";
    std::cout << "  \"roots\": [\n";

    std::set<std::string> global_witnesses;
    int maximum_arc_size = 0;
    std::array<std::uint64_t, 9> rooted_states{};
    for (std::size_t r = 0; r < edge_orbits_.size(); ++r) {
      const int edge_id = edge_orbits_[r].front();
      const auto [a, b] = edges_[edge_id];
      stabilizer_.clear();
      for (const auto &perm : group_perms_) {
        int x = perm[a], y = perm[b];
        if (x > y) std::swap(x, y);
        if (x == a && y == b) stabilizer_.push_back(&perm);
      }
      if (stabilizer_.size() * edge_orbits_[r].size() != group_.size())
        throw std::runtime_error("orbit-stabilizer failure");

      selected_ = {a, b};
      multiplicity_.assign(off_.size(), 0);
      covered_ = 0;
      add_line(line_for_pair_[a][b], +1);
      seen_.assign(9, {});
      stats_ = SearchStats{};
      dfs();
      add_line(line_for_pair_[a][b], -1);

      for (int k = 2; k <= 8; ++k) {
        rooted_states[k] += stats_.states[k];
        if (stats_.states[k] != 0) maximum_arc_size = std::max(maximum_arc_size, k);
      }
      for (const auto &key : stats_.witnesses) global_witnesses.insert(key);
      std::cout << "    {\n";
      std::cout << "      \"representative\": [" << point_json(off_[a]) << ", "
                << point_json(off_[b]) << "],\n";
      std::cout << "      \"orbit_size\": " << edge_orbits_[r].size() << ",\n";
      std::cout << "      \"stabilizer_order\": " << stabilizer_.size() << ",\n";
      std::cout << "      \"states_by_size\": [";
      for (int k = 0; k <= 8; ++k) {
        if (k) std::cout << ", ";
        std::cout << stats_.states[k];
      }
      std::cout << "],\n";
      std::cout << "      \"multiplicity_prunes\": " << stats_.multiplicity_prunes << ",\n";
      std::cout << "      \"coverage_prunes\": " << stats_.coverage_prunes << ",\n";
      std::cout << "      \"terminal_arcs\": " << stats_.terminal_arcs << ",\n";
      std::cout << "      \"spectrum_matches\": " << stats_.spectrum_matches << ",\n";
      std::cout << "      \"witnesses\": " << stats_.witnesses.size() << "\n";
      std::cout << "    }" << (r + 1 == edge_orbits_.size() ? "\n" : ",\n");
    }
    std::cout << "  ],\n";
    std::cout << "  \"rooted_stabilizer_states_by_size\": [";
    for (int k = 0; k <= 8; ++k) {
      if (k) std::cout << ", ";
      std::cout << rooted_states[k];
    }
    std::cout << "],\n";
    std::cout << "  \"maximum_passant_arc_size\": " << maximum_arc_size << ",\n";
    std::cout << "  \"witness_orbits\": " << global_witnesses.size() << ",\n";
    std::cout << "  \"witnesses\": [";
    bool first = true;
    for (const auto &key : global_witnesses) {
      if (!first) std::cout << ", ";
      first = false;
      std::cout << key_to_json(key);
    }
    std::cout << "]\n";
    std::cout << "}\n";
  }

 private:
  int q_;
  std::vector<Point> points_, conic_, off_, lines_;
  std::unordered_map<std::string, int> off_index_, line_index_;
  std::vector<std::vector<int>> line_points_;
  std::vector<Matrix2> group_;
  std::vector<std::vector<int>> group_perms_;
  std::vector<std::vector<unsigned char>> compatible_;
  std::vector<std::vector<int>> line_for_pair_;
  std::vector<std::pair<int, int>> edges_;
  std::vector<std::vector<int>> edge_orbits_;

  std::vector<int> selected_, multiplicity_;
  int covered_ = 0;
  std::vector<const std::vector<int> *> stabilizer_;
  std::vector<std::unordered_set<std::string>> seen_;
  SearchStats stats_;

  int mod(long long x) const {
    x %= q_;
    if (x < 0) x += q_;
    return static_cast<int>(x);
  }
  int inv(int x) const {
    if (x == 0) throw std::runtime_error("division by zero");
    int result = 1;
    for (int e = q_ - 2; e; e >>= 1, x = mod(1LL * x * x))
      if (e & 1) result = mod(1LL * result * x);
    return result;
  }
  Point normalize(Point p) const {
    for (int x : p) {
      if (x != 0) {
        const int s = inv(x);
        for (int &y : p) y = mod(1LL * s * y);
        return p;
      }
    }
    throw std::runtime_error("zero projective vector");
  }
  std::string point_key(const Point &p) const {
    return std::to_string(p[0]) + "," + std::to_string(p[1]) + "," +
           std::to_string(p[2]);
  }
  std::string point_json(const Point &p) const {
    return "[" + std::to_string(p[0]) + ", " + std::to_string(p[1]) + ", " +
           std::to_string(p[2]) + "]";
  }
  Point cross(const Point &a, const Point &b) const {
    return normalize({mod(1LL * a[1] * b[2] - 1LL * a[2] * b[1]),
                      mod(1LL * a[2] * b[0] - 1LL * a[0] * b[2]),
                      mod(1LL * a[0] * b[1] - 1LL * a[1] * b[0])});
  }
  int dot(const Point &a, const Point &b) const {
    return mod(1LL * a[0] * b[0] + 1LL * a[1] * b[1] + 1LL * a[2] * b[2]);
  }
  bool on_conic(const Point &p) const {
    return mod(1LL * p[0] * p[2] - 1LL * p[1] * p[1]) == 0;
  }

  void build_points() {
    for (int y = 0; y < q_; ++y)
      for (int z = 0; z < q_; ++z) points_.push_back({1, y, z});
    for (int z = 0; z < q_; ++z) points_.push_back({0, 1, z});
    points_.push_back({0, 0, 1});
    for (const Point &p : points_) {
      if (on_conic(p))
        conic_.push_back(p);
      else {
        off_index_[point_key(p)] = static_cast<int>(off_.size());
        off_.push_back(p);
      }
    }
    if (points_.size() != static_cast<std::size_t>(q_ * q_ + q_ + 1) ||
        conic_.size() != static_cast<std::size_t>(q_ + 1) ||
        off_.size() != static_cast<std::size_t>(q_ * q_))
      throw std::runtime_error("projective point count failure");
  }

  void build_lines() {
    lines_ = points_;
    line_points_.resize(lines_.size());
    for (std::size_t i = 0; i < lines_.size(); ++i) {
      line_index_[point_key(lines_[i])] = static_cast<int>(i);
      for (std::size_t j = 0; j < off_.size(); ++j)
        if (dot(lines_[i], off_[j]) == 0) line_points_[i].push_back(j);
    }
  }

  Matrix2 normalize2(Matrix2 m) const {
    for (int x : m) {
      if (x != 0) {
        const int s = inv(x);
        for (int &y : m) y = mod(1LL * s * y);
        return m;
      }
    }
    throw std::runtime_error("zero matrix");
  }
  Matrix3 sym2(const Matrix2 &m) const {
    const int a = m[0], b = m[1], c = m[2], d = m[3];
    return {mod(1LL * a * a), mod(2LL * a * b), mod(1LL * b * b),
            mod(1LL * a * c), mod(1LL * a * d + 1LL * b * c), mod(1LL * b * d),
            mod(1LL * c * c), mod(2LL * c * d), mod(1LL * d * d)};
  }
  Point apply3(const Matrix3 &m, const Point &p) const {
    Point result{};
    for (int i = 0; i < 3; ++i)
      result[i] = mod(1LL * m[3 * i] * p[0] + 1LL * m[3 * i + 1] * p[1] +
                      1LL * m[3 * i + 2] * p[2]);
    return normalize(result);
  }
  void build_group() {
    std::set<Matrix2> unique;
    for (int a = 0; a < q_; ++a)
      for (int b = 0; b < q_; ++b)
        for (int c = 0; c < q_; ++c)
          for (int d = 0; d < q_; ++d) {
            if (mod(1LL * a * d - 1LL * b * c) == 0) continue;
            unique.insert(normalize2({a, b, c, d}));
          }
    group_.assign(unique.begin(), unique.end());
    if (group_.size() != static_cast<std::size_t>(q_ * (q_ - 1) * (q_ + 1)))
      throw std::runtime_error("PGL2 count failure");
    for (const Matrix2 &m : group_) {
      const Matrix3 action = sym2(m);
      std::vector<int> perm(off_.size());
      for (std::size_t i = 0; i < off_.size(); ++i) {
        const auto it = off_index_.find(point_key(apply3(action, off_[i])));
        if (it == off_index_.end()) throw std::runtime_error("group leaves off-conic set");
        perm[i] = it->second;
      }
      group_perms_.push_back(std::move(perm));
    }
  }

  void build_graph() {
    const int n = off_.size();
    compatible_.assign(n, std::vector<unsigned char>(n, 0));
    line_for_pair_.assign(n, std::vector<int>(n, -1));
    for (int i = 0; i < n; ++i)
      for (int j = i + 1; j < n; ++j) {
        const Point line = cross(off_[i], off_[j]);
        const int line_id = line_index_.at(point_key(line));
        line_for_pair_[i][j] = line_for_pair_[j][i] = line_id;
        bool passant = true;
        for (const Point &p : conic_)
          if (dot(line, p) == 0) {
            passant = false;
            break;
          }
        if (passant) {
          compatible_[i][j] = compatible_[j][i] = 1;
          edges_.push_back({i, j});
        }
      }
  }

  void build_edge_orbits() {
    std::unordered_map<std::uint64_t, int> edge_id;
    auto pack = [](int a, int b) -> std::uint64_t {
      if (a > b) std::swap(a, b);
      return (static_cast<std::uint64_t>(a) << 32) | static_cast<unsigned>(b);
    };
    for (std::size_t i = 0; i < edges_.size(); ++i)
      edge_id[pack(edges_[i].first, edges_[i].second)] = i;
    DSU dsu(edges_.size());
    for (std::size_t e = 0; e < edges_.size(); ++e) {
      const auto [a, b] = edges_[e];
      for (const auto &perm : group_perms_) {
        const auto it = edge_id.find(pack(perm[a], perm[b]));
        if (it == edge_id.end()) throw std::runtime_error("passant graph not invariant");
        dsu.join(e, it->second);
      }
    }
    std::unordered_map<int, std::vector<int>> classes;
    for (std::size_t e = 0; e < edges_.size(); ++e) classes[dsu.find(e)].push_back(e);
    for (auto &[root, orbit] : classes) {
      (void)root;
      std::sort(orbit.begin(), orbit.end());
      edge_orbits_.push_back(std::move(orbit));
    }
    std::sort(edge_orbits_.begin(), edge_orbits_.end(),
              [](const auto &a, const auto &b) { return a.front() < b.front(); });
  }

  std::string set_key(const std::vector<int> &set) const {
    std::string key;
    key.reserve(2 * set.size());
    for (int x : set) {
      key.push_back(static_cast<char>(x & 255));
      key.push_back(static_cast<char>((x >> 8) & 255));
    }
    return key;
  }
  std::string canonical_key(const std::vector<int> &set,
                            const std::vector<const std::vector<int> *> &group) const {
    std::string best;
    bool initialized = false;
    std::vector<int> image(set.size());
    for (const auto *perm : group) {
      for (std::size_t i = 0; i < set.size(); ++i) image[i] = (*perm)[set[i]];
      std::sort(image.begin(), image.end());
      const std::string key = set_key(image);
      if (!initialized || key < best) {
        best = key;
        initialized = true;
      }
    }
    return best;
  }
  std::string full_canonical_key() const {
    std::vector<const std::vector<int> *> full;
    full.reserve(group_perms_.size());
    for (const auto &perm : group_perms_) full.push_back(&perm);
    return canonical_key(selected_, full);
  }
  std::string key_to_json(const std::string &key) const {
    std::ostringstream out;
    out << "[";
    for (std::size_t i = 0; i < key.size(); i += 2) {
      const int x = static_cast<unsigned char>(key[i]) |
                    (static_cast<int>(static_cast<unsigned char>(key[i + 1])) << 8);
      if (i) out << ", ";
      out << point_json(off_[x]);
    }
    out << "]";
    return out.str();
  }

  bool lies_on_selected_join(int v) const {
    for (std::size_t i = 0; i < selected_.size(); ++i)
      for (std::size_t j = i + 1; j < selected_.size(); ++j)
        if (dot(lines_[line_for_pair_[selected_[i]][selected_[j]]], off_[v]) == 0)
          return true;
    return false;
  }
  void add_line(int line, int delta) {
    for (int p : line_points_[line]) {
      if (delta == 1 && multiplicity_[p]++ == 0) ++covered_;
      if (delta == -1 && --multiplicity_[p] == 0) --covered_;
    }
  }
  bool multiplicities_valid() const {
    for (std::size_t p = 0; p < multiplicity_.size(); ++p) {
      if (std::find(selected_.begin(), selected_.end(), static_cast<int>(p)) != selected_.end())
        continue;
      if (multiplicity_[p] > 4) return false;
    }
    return true;
  }
  bool coverage_possible() const {
    int upper = covered_;
    for (int i = selected_.size(); i < 8; ++i) upper += 1 + i * (q_ - 1);
    return upper >= static_cast<int>(off_.size());
  }
  bool spectrum_matches() const {
    if (covered_ != static_cast<int>(off_.size())) return false;
    std::array<int, 8> counts{};
    for (std::size_t p = 0; p < multiplicity_.size(); ++p) {
      if (std::find(selected_.begin(), selected_.end(), static_cast<int>(p)) != selected_.end())
        continue;
      if (multiplicity_[p] < 0 || multiplicity_[p] >= static_cast<int>(counts.size()))
        return false;
      ++counts[multiplicity_[p]];
    }
    if (counts[0] != 0) return false;
    const int a = counts[4];
    const auto forced = forced_spectrum(a);
    return 0 <= a && a <= forced_a_max() && counts[1] == forced[0] &&
           counts[2] == forced[1] && counts[3] == forced[2] &&
           counts[4] == forced[3];
  }
  int forced_a_max() const {
    if (q_ == 13) return 11;
    if (q_ == 17) return 14;
    return 19;
  }
  std::array<int, 4> forced_spectrum(int a) const {
    if (q_ == 13) return {21 - a, 105 + 3 * a, 35 - 3 * a, a};
    if (q_ == 17) return {157 - a, 81 + 3 * a, 43 - 3 * a, a};
    return {261 - a, 33 + 3 * a, 59 - 3 * a, a};
  }
  void validate_forced_spectrum() const {
    for (int a = 0; a <= forced_a_max(); ++a) {
      const auto n = forced_spectrum(a);
      if (std::any_of(n.begin(), n.end(), [](int value) { return value < 0; }))
        throw std::runtime_error("negative forced spectrum");
      const int zeroth = n[0] + n[1] + n[2] + n[3];
      const int first = n[0] + 2 * n[1] + 3 * n[2] + 4 * n[3];
      const int second = n[1] + 3 * n[2] + 6 * n[3];
      if (zeroth != q_ * q_ - 8 || first != 28 * (q_ - 1) ||
          second != 210)
        throw std::runtime_error("forced spectrum moment failure");
    }
  }

  void dfs() {
    std::vector<int> sorted = selected_;
    std::sort(sorted.begin(), sorted.end());
    const int k = sorted.size();
    const std::string canonical = canonical_key(sorted, stabilizer_);
    if (!seen_[k].insert(canonical).second) return;
    ++stats_.states[k];

    if (!multiplicities_valid()) {
      ++stats_.multiplicity_prunes;
      return;
    }
    if (!coverage_possible()) {
      ++stats_.coverage_prunes;
      return;
    }
    if (k == 8) {
      ++stats_.terminal_arcs;
      if (spectrum_matches()) {
        ++stats_.spectrum_matches;
        stats_.witnesses.push_back(full_canonical_key());
      }
      return;
    }

    for (int v = 0; v < static_cast<int>(off_.size()); ++v) {
      if (std::find(selected_.begin(), selected_.end(), v) != selected_.end()) continue;
      bool ok = true;
      for (int s : selected_)
        if (!compatible_[v][s]) {
          ok = false;
          break;
        }
      if (!ok || lies_on_selected_join(v)) continue;

      const std::vector<int> old_selected = selected_;
      for (int s : old_selected) add_line(line_for_pair_[s][v], +1);
      selected_.push_back(v);
      dfs();
      selected_.pop_back();
      for (int s : old_selected) add_line(line_for_pair_[s][v], -1);
    }
  }
};

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cerr << "usage: c605-search Q\n";
    return 2;
  }
  try {
    Search search(std::stoi(argv[1]));
    search.run();
  } catch (const std::exception &e) {
    std::cerr << "error: " << e.what() << "\n";
    return 1;
  }
}
