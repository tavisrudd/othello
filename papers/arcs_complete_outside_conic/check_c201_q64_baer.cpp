// Independent raw-family checker for probe_c201_q64_baer.py.
// It does not use the Python orbit quotient: all compatible pair-pairs are checked.
#include <array>
#include <bitset>
#include <cstdint>
#include <iostream>
#include <set>
#include <vector>

constexpr int Q = 64;
constexpr int N = Q * Q + Q + 1;
using Point = std::array<uint8_t, 3>;
using Row = std::array<uint8_t, 6>;

uint8_t mul(uint8_t a, uint8_t b) {
  uint8_t out = 0;
  while (b) {
    if (b & 1) out ^= a;
    b >>= 1;
    a <<= 1;
    if (a & Q) a ^= 0x43;
  }
  return out;
}

uint8_t power(uint8_t a, int n) {
  uint8_t out = 1;
  while (n) {
    if (n & 1) out = mul(out, a);
    a = mul(a, a);
    n >>= 1;
  }
  return out;
}

uint8_t inv(uint8_t a) { return power(a, Q - 2); }

Point normalize(Point p) {
  uint8_t lead = p[0] ? p[0] : p[1] ? p[1] : p[2];
  lead = inv(lead);
  for (auto &x : p) x = mul(lead, x);
  return p;
}

uint16_t code(Point p) { return uint16_t(p[0]) << 12 | uint16_t(p[1]) << 6 | p[2]; }

uint8_t det(const Point &x, const Point &y, const Point &z) {
  return mul(x[0], mul(y[1], z[2]) ^ mul(y[2], z[1]))
       ^ mul(x[1], mul(y[0], z[2]) ^ mul(y[2], z[0]))
       ^ mul(x[2], mul(y[0], z[1]) ^ mul(y[1], z[0]));
}

Point line(const Point &x, const Point &y) {
  return normalize({
      uint8_t(mul(x[1], y[2]) ^ mul(x[2], y[1])),
      uint8_t(mul(x[2], y[0]) ^ mul(x[0], y[2])),
      uint8_t(mul(x[0], y[1]) ^ mul(x[1], y[0]))});
}

uint8_t dot3(const Point &a, const Point &b) {
  return mul(a[0], b[0]) ^ mul(a[1], b[1]) ^ mul(a[2], b[2]);
}

Row monomial(const Point &p) {
  return {mul(p[0], p[0]), mul(p[1], p[1]), mul(p[2], p[2]),
          mul(p[0], p[1]), mul(p[0], p[2]), mul(p[1], p[2])};
}

int rank6(std::vector<Row> rows) {
  int row = 0;
  for (int col = 0; col < 6 && row < static_cast<int>(rows.size()); ++col) {
    int pivot = row;
    while (pivot < static_cast<int>(rows.size()) && !rows[pivot][col]) ++pivot;
    if (pivot == static_cast<int>(rows.size())) continue;
    std::swap(rows[row], rows[pivot]);
    uint8_t scale = inv(rows[row][col]);
    for (auto &x : rows[row]) x = mul(scale, x);
    for (int i = 0; i < static_cast<int>(rows.size()); ++i) if (i != row && rows[i][col]) {
      scale = rows[i][col];
      for (int j = 0; j < 6; ++j) rows[i][j] ^= mul(scale, rows[row][j]);
    }
    ++row;
  }
  return row;
}

int main() {
  std::vector<Point> points;
  std::array<int, 1 << 18> index;
  index.fill(-1);
  points.push_back({0, 0, 1});
  for (int z = 0; z < Q; ++z) points.push_back({0, 1, uint8_t(z)});
  for (int y = 0; y < Q; ++y) for (int z = 0; z < Q; ++z)
    points.push_back({1, uint8_t(y), uint8_t(z)});
  for (int i = 0; i < N; ++i) index[code(points[i])] = i;

  std::vector<std::bitset<N>> line_points(N);
  for (int ell = 0; ell < N; ++ell)
    for (int p = 0; p < N; ++p)
      if (!dot3(points[ell], points[p])) line_points[ell].set(p);

  std::vector<uint8_t> subfield;
  for (int x = 0; x < Q; ++x) if (power(x, 8) == x) subfield.push_back(x);
  std::vector<int> conic{index[code({0, 0, 1})]};
  for (auto t : subfield) conic.push_back(index[code({1, t, mul(t, t)})]);

  auto sigma = [&](int p) {
    Point out = points[p];
    for (auto &x : out) x = power(x, 8);
    return index[code(normalize(out))];
  };
  std::vector<std::array<int, 2>> pairs;
  std::bitset<N> seen;
  for (int p = 0; p < N; ++p) {
    int q = sigma(p);
    if (p == q || seen[p]) continue;
    seen.set(p); seen.set(q);
    std::vector<int> arc = conic;
    arc.push_back(p); arc.push_back(q);
    bool legal = true;
    for (int i = 0; i < 11 && legal; ++i)
      for (int j = 0; j < i && legal; ++j)
        for (int k = 0; k < j; ++k)
          if (!det(points[arc[i]], points[arc[j]], points[arc[k]])) { legal = false; break; }
    if (legal) pairs.push_back({std::min(p, q), std::max(p, q)});
  }

  uint64_t compatible = 0;
  for (int left = 0; left < static_cast<int>(pairs.size()); ++left) {
    for (int right = left + 1; right < static_cast<int>(pairs.size()); ++right) {
      std::vector<int> arc = conic;
      arc.insert(arc.end(), pairs[left].begin(), pairs[left].end());
      arc.insert(arc.end(), pairs[right].begin(), pairs[right].end());
      bool legal = true;
      for (int i = 0; i < 13 && legal; ++i)
        for (int j = 0; j < i && legal; ++j)
          for (int k = 0; k < j; ++k)
            if (!det(points[arc[i]], points[arc[j]], points[arc[k]])) { legal = false; break; }
      if (!legal) continue;
      ++compatible;
      std::bitset<N> covered;
      for (int i = 0; i < 13; ++i) for (int j = 0; j < i; ++j) {
        Point ell = line(points[arc[i]], points[arc[j]]);
        covered |= line_points[index[code(ell)]];
      }
      std::vector<Row> rows;
      for (int p = 0; p < N; ++p) if (!covered[p]) rows.push_back(monomial(points[p]));
      if (rank6(std::move(rows)) != 6) {
        std::cerr << "RANK_DEFECT left=" << left << " right=" << right << "\n";
        return 1;
      }
    }
  }
  std::cout << "legal_conjugate_pairs " << pairs.size() << "\n"
            << "compatible_pair_pairs " << compatible << "\n"
            << "full_rank " << compatible << "\nPASS\n";
}
