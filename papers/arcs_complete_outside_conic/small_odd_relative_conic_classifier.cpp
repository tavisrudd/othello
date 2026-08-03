#include <algorithm>
#include <array>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <set>
#include <stdexcept>
#include <string>
#include <tuple>
#include <vector>

using Point = std::array<int, 3>;
using Matrix = std::array<std::array<int, 3>, 3>;
using Row = std::array<int, 6>;
using Arc = std::vector<int>;

static int q;
static std::vector<Point> points;
static std::vector<int> pointIndex;

static int mod(int x) {
  x %= q;
  return x < 0 ? x + q : x;
}

static int inverseScalar(int x) {
  for (int y = 1; y < q; ++y) {
    if (mod(x * y) == 1) return y;
  }
  throw std::runtime_error("noninvertible scalar");
}

static Point normalize(Point p) {
  const int pivot = p[0] ? p[0] : p[1] ? p[1] : p[2];
  const int z = inverseScalar(pivot);
  for (int &x : p) x = mod(z * x);
  return p;
}

static int pointCode(const Point &p) {
  return (p[0] * q + p[1]) * q + p[2];
}

static int determinant(const Point &a, const Point &b, const Point &c) {
  return mod(
      a[0] * mod(b[1] * c[2] - b[2] * c[1]) -
      a[1] * mod(b[0] * c[2] - b[2] * c[0]) +
      a[2] * mod(b[0] * c[1] - b[1] * c[0]));
}

static Point multiply(const Matrix &m, const Point &p) {
  Point out{};
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) out[i] += m[i][j] * p[j];
    out[i] = mod(out[i]);
  }
  return out;
}

static Matrix inverseMatrix(const Point &a, const Point &b, const Point &c) {
  Matrix m{{{{a[0], b[0], c[0]}}, {{a[1], b[1], c[1]}}, {{a[2], b[2], c[2]}}}};
  Matrix out{{{{1, 0, 0}}, {{0, 1, 0}}, {{0, 0, 1}}}};
  for (int col = 0; col < 3; ++col) {
    int pivot = col;
    while (pivot < 3 && m[pivot][col] == 0) ++pivot;
    if (pivot == 3) throw std::runtime_error("singular frame");
    std::swap(m[pivot], m[col]);
    std::swap(out[pivot], out[col]);
    const int z = inverseScalar(m[col][col]);
    for (int j = 0; j < 3; ++j) {
      m[col][j] = mod(z * m[col][j]);
      out[col][j] = mod(z * out[col][j]);
    }
    for (int i = 0; i < 3; ++i) {
      if (i == col || m[i][col] == 0) continue;
      const int w = m[i][col];
      for (int j = 0; j < 3; ++j) {
        m[i][j] = mod(m[i][j] - w * m[col][j]);
        out[i][j] = mod(out[i][j] - w * out[col][j]);
      }
    }
  }
  return out;
}

static Arc canonical(const Arc &arc) {
  Arc best;
  const int n = static_cast<int>(arc.size());
  for (int i = 0; i < n; ++i) {
    for (int j = 0; j < n; ++j) {
      if (j == i) continue;
      for (int k = 0; k < n; ++k) {
        if (k == i || k == j) continue;
        for (int l = 0; l < n; ++l) {
          if (l == i || l == j || l == k) continue;
          Matrix m = inverseMatrix(
              points[arc[i]], points[arc[j]], points[arc[k]]);
          const Point fourth = multiply(m, points[arc[l]]);
          for (int row = 0; row < 3; ++row) {
            const int z = inverseScalar(fourth[row]);
            for (int col = 0; col < 3; ++col) {
              m[row][col] = mod(z * m[row][col]);
            }
          }
          Arc image;
          image.reserve(arc.size());
          for (int x : arc) {
            const Point p = normalize(multiply(m, points[x]));
            image.push_back(pointIndex[pointCode(p)]);
          }
          std::sort(image.begin(), image.end());
          if (best.empty() || image < best) best = std::move(image);
        }
      }
    }
  }
  return best;
}

static bool legalAdd(const Arc &arc, int x) {
  for (std::size_t i = 0; i < arc.size(); ++i) {
    for (std::size_t j = 0; j < i; ++j) {
      if (determinant(points[arc[i]], points[arc[j]], points[x]) == 0) return false;
    }
  }
  return true;
}

static Row quadraticRow(const Point &p) {
  return {
      mod(p[0] * p[0]), mod(p[1] * p[1]), mod(p[2] * p[2]),
      mod(p[0] * p[1]), mod(p[0] * p[2]), mod(p[1] * p[2])};
}

static int rowRank(std::vector<Row> rows) {
  int rank = 0;
  for (int col = 0; col < 6 && rank < static_cast<int>(rows.size()); ++col) {
    int pivot = rank;
    while (pivot < static_cast<int>(rows.size()) && rows[pivot][col] == 0) ++pivot;
    if (pivot == static_cast<int>(rows.size())) continue;
    std::swap(rows[pivot], rows[rank]);
    const int z = inverseScalar(rows[rank][col]);
    for (int j = col; j < 6; ++j) rows[rank][j] = mod(z * rows[rank][j]);
    for (int i = 0; i < static_cast<int>(rows.size()); ++i) {
      if (i == rank || rows[i][col] == 0) continue;
      const int w = rows[i][col];
      for (int j = col; j < 6; ++j) {
        rows[i][j] = mod(rows[i][j] - w * rows[rank][j]);
      }
    }
    ++rank;
  }
  return rank;
}

struct HullProfile {
  std::vector<int> uncovered;
  int rank;
  bool uncoveredArc;
  bool selectedHullPoint;
};

static HullProfile hullProfile(const Arc &arc) {
  std::vector<bool> chosen(points.size(), false);
  std::vector<bool> covered(points.size(), false);
  for (int x : arc) chosen[x] = true;
  for (std::size_t i = 0; i < arc.size(); ++i) {
    for (std::size_t j = 0; j < i; ++j) {
      for (int x = 0; x < static_cast<int>(points.size()); ++x) {
        if (determinant(points[arc[i]], points[arc[j]], points[x]) == 0) {
          covered[x] = true;
        }
      }
    }
  }
  HullProfile profile;
  std::vector<Row> rows;
  for (int x = 0; x < static_cast<int>(points.size()); ++x) {
    if (!chosen[x] && !covered[x]) {
      profile.uncovered.push_back(x);
      rows.push_back(quadraticRow(points[x]));
    }
  }
  profile.rank = rowRank(rows);
  profile.uncoveredArc = true;
  for (std::size_t i = 0; i < profile.uncovered.size() && profile.uncoveredArc; ++i) {
    for (std::size_t j = 0; j < i && profile.uncoveredArc; ++j) {
      for (std::size_t k = 0; k < j; ++k) {
        if (determinant(
                points[profile.uncovered[i]], points[profile.uncovered[j]],
                points[profile.uncovered[k]]) == 0) {
          profile.uncoveredArc = false;
          break;
        }
      }
    }
  }
  profile.selectedHullPoint = false;
  if (profile.rank < 6) {
    for (int x : arc) {
      auto augmented = rows;
      augmented.push_back(quadraticRow(points[x]));
      if (rowRank(augmented) == profile.rank) {
        profile.selectedHullPoint = true;
        break;
      }
    }
  }
  return profile;
}

static void writePoint(std::ostream &out, const Point &p) {
  out << "[" << p[0] << "," << p[1] << "," << p[2] << "]";
}

static void writePointList(std::ostream &out, const std::vector<int> &indices) {
  out << "[";
  for (std::size_t i = 0; i < indices.size(); ++i) {
    if (i) out << ",";
    writePoint(out, points[indices[i]]);
  }
  out << "]";
}

int main(int argc, char **argv) {
  if (argc != 4 && argc != 5) {
    std::cerr << "usage: secant-hull-coupling Q K OUTPUT.json [--extension-witness]\n";
    return 2;
  }
  q = std::stoi(argv[1]);
  const int target = std::stoi(argv[2]);
  const std::string outputPath = argv[3];
  const bool extensionWitness = argc == 5 && std::string(argv[4]) == "--extension-witness";
  if (argc == 5 && !extensionWitness) {
    throw std::runtime_error("unknown search mode");
  }
  if (q < 5 || target < 4 || target > q - 3) {
    throw std::runtime_error("requires q >= 5 and 4 <= k <= q-3");
  }
  for (int x = 2; x < q; ++x) {
    if (q % x == 0) throw std::runtime_error("Q must be prime");
  }

  pointIndex.assign(q * q * q, -1);
  std::set<Point> normalizedPoints;
  for (int x = 0; x < q; ++x) {
    for (int y = 0; y < q; ++y) {
      for (int z = 0; z < q; ++z) {
        if (x || y || z) normalizedPoints.insert(normalize({x, y, z}));
      }
    }
  }
  for (const Point &p : normalizedPoints) {
    pointIndex[pointCode(p)] = static_cast<int>(points.size());
    points.push_back(p);
  }

  Arc frame{
      pointIndex[pointCode({1, 0, 0})],
      pointIndex[pointCode({0, 1, 0})],
      pointIndex[pointCode({0, 0, 1})],
      pointIndex[pointCode({1, 1, 1})]};
  std::sort(frame.begin(), frame.end());
  std::vector<Arc> classes{canonical(frame)};
  std::vector<std::uint64_t> classCounts{1};
  std::vector<std::uint64_t> extensionCounts;
  bool found = false;
  Arc witness;
  HullProfile witnessProfile;
  std::size_t tested = 0;
  std::array<std::uint64_t, 7> ranks{};

  for (int n = 5; n <= target; ++n) {
    std::set<Arc> next;
    std::uint64_t extensions = 0;
    for (const Arc &arc : classes) {
      for (int x = 0; x < static_cast<int>(points.size()); ++x) {
        if (std::binary_search(arc.begin(), arc.end(), x) || !legalAdd(arc, x)) continue;
        ++extensions;
        Arc child = arc;
        child.push_back(x);
        std::sort(child.begin(), child.end());
        if (extensionWitness && n == target) {
          const HullProfile profile = hullProfile(child);
          ++tested;
          ++ranks[profile.rank];
          if (profile.rank < 6 && profile.uncoveredArc && !profile.selectedHullPoint) {
            found = true;
            witness = child;
            witnessProfile = profile;
            break;
          }
          continue;
        }
        next.insert(canonical(child));
      }
      if (found) break;
    }
    extensionCounts.push_back(extensions);
    if (extensionWitness && n == target) break;
    classes.assign(next.begin(), next.end());
    classCounts.push_back(classes.size());
    std::cerr << "q=" << q << " n=" << n << " classes=" << classes.size()
              << " extensions=" << extensions << "\n";
  }

  if (!extensionWitness) {
    for (const Arc &arc : classes) {
      const HullProfile profile = hullProfile(arc);
      ++tested;
      ++ranks[profile.rank];
      if (profile.rank < 6 && profile.uncoveredArc && !profile.selectedHullPoint) {
        found = true;
        witness = arc;
        witnessProfile = profile;
        break;
      }
    }
  }

  std::ofstream out(outputPath);
  if (!out) throw std::runtime_error("cannot open output path");
  out << "{\"schema\":\"secant-hull-coupling-v1\",\"q\":" << q
      << ",\"k\":" << target << ",\"points\":" << points.size()
      << ",\"search_mode\":\""
      << (extensionWitness ? "frame_extension_witness" : "projective_classes")
      << "\""
      << ",\"class_counts\":[";
  for (std::size_t i = 0; i < classCounts.size(); ++i) {
    if (i) out << ",";
    out << classCounts[i];
  }
  out << "],\"extension_counts\":[";
  for (std::size_t i = 0; i < extensionCounts.size(); ++i) {
    if (i) out << ",";
    out << extensionCounts[i];
  }
  out << "],\"tested_candidates\":" << tested << ",\"rank_counts\":[";
  for (std::size_t i = 0; i < ranks.size(); ++i) {
    if (i) out << ",";
    out << ranks[i];
  }
  out << "],\"verdict\":\"" << (found ? "witness" : "no_witness") << "\"";
  if (found) {
    out << ",\"arc\":";
    writePointList(out, witness);
    out << ",\"uncovered\":";
    writePointList(out, witnessProfile.uncovered);
    out << ",\"quadratic_rank\":" << witnessProfile.rank
        << ",\"uncovered_is_arc\":true,\"selected_hull_point\":false";
  }
  out << "}\n";
}
