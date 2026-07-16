#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <map>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

// Independent proposal generator for the complete C151 orbit-5 row cover.  It mirrors the
// executable formula in Q25ResidualAction.residualApply, but Lean must check every emitted bad
// triple and residual image used in the final certificate.

using V = std::array<int, 3>;
using Triple = std::array<int, 3>;

constexpr int kPointCount = 651;
constexpr int kOrbitCount = 310;
constexpr int kParameterCount = 400;
constexpr int kLeanFiveInternalOrbit = 65;
constexpr int kExpectedRows = 46056;
constexpr int kExpectedValidRows = 7044;
constexpr int kExpectedClasses = 1189;

int add25(int x, int y) {
  return ((x % 5 + y % 5) % 5) + 5 * ((x / 5 + y / 5) % 5);
}

int neg25(int x) {
  return ((-x % 5) + 5) % 5 + 5 * (((-(x / 5) % 5) + 5) % 5);
}

int sub25(int x, int y) { return add25(x, neg25(y)); }

int mul25(int x, int y) {
  const int a = x % 5;
  const int b = x / 5;
  const int c = y % 5;
  const int d = y / 5;
  return ((a * c + 2 * b * d) % 5) + 5 * ((a * d + b * c) % 5);
}

int pow25(int x, int n) {
  int out = 1;
  while (n != 0) {
    if ((n & 1) != 0) out = mul25(out, x);
    x = mul25(x, x);
    n >>= 1;
  }
  return out;
}

int inv25(int x) {
  assert(x != 0);
  return pow25(x, 23);
}

V norm(V v) {
  int pivot = 0;
  while (v[pivot] == 0) ++pivot;
  const int inverse = inv25(v[pivot]);
  for (int &x : v) x = mul25(x, inverse);
  return v;
}

int key(const V &v) { return v[0] + 25 * v[1] + 625 * v[2]; }

int projectiveRank(const V &v) {
  if (v[0] == 1) return v[1] * 25 + v[2];
  if (v[1] == 1) return 625 + v[2];
  return 650;
}

int leanOrbitNumber(const V &p, const V &q) {
  const V &v = projectiveRank(p) < projectiveRank(q) ? p : q;
  if (v[0] == 1) {
    const int yReal = v[1] % 5;
    const int yImag = v[1] / 5;
    if (yImag != 0) {
      assert(yImag == 1 || yImag == 2);
      return (yReal * 2 + yImag - 1) * 25 + v[2];
    }
    const int zReal = v[2] % 5;
    const int zImag = v[2] / 5;
    assert(zImag == 1 || zImag == 2);
    return 250 + (yReal * 5 + zReal) * 2 + zImag - 1;
  }
  const int zReal = v[2] % 5;
  const int zImag = v[2] / 5;
  assert(v[1] == 1 && (zImag == 1 || zImag == 2));
  return 300 + zReal * 2 + zImag - 1;
}

V cross(const V &a, const V &b) {
  return norm({sub25(mul25(a[1], b[2]), mul25(a[2], b[1])),
               sub25(mul25(a[2], b[0]), mul25(a[0], b[2])),
               sub25(mul25(a[0], b[1]), mul25(a[1], b[0]))});
}

int dot(const V &a, const V &b) {
  return add25(add25(mul25(a[0], b[0]), mul25(a[1], b[1])),
               mul25(a[2], b[2]));
}

V frobenius(V v) {
  for (int &x : v) x = pow25(x, 5);
  return norm(v);
}

int imagPart(int x) { return x / 5; }
int realPart(int x) { return x % 5; }

int scale(int x) {
  assert(imagPart(x) != 0);
  return inv25(imagPart(x));
}

int shift(int x) { return neg25(mul25(scale(x), realPart(x))); }

// Exact canonical-coordinate cases of Q25ResidualAction.residualApply.
V residualApply(int y, int z, const V &v) {
  assert(imagPart(y) != 0 && imagPart(z) != 0);
  if (v[0] == 1) {
    return {1, add25(shift(y), mul25(scale(y), v[1])),
            add25(shift(z), mul25(scale(z), v[2]))};
  }
  if (v[1] == 1) {
    return {0, 1, mul25(mul25(inv25(scale(y)), scale(z)), v[2])};
  }
  assert(v == V({0, 0, 1}));
  return v;
}

struct Parameter {
  int y = 0;
  int z = 0;
};

struct CoverRecord {
  int b = 0;
  int c = 0;
  bool valid = false;
  Triple bad = {-1, -1, -1};
  Triple canonicalInternal = {-1, -1, -1};
  Triple canonicalLean = {-1, -1, -1};
  int classIndex = -1;
  int y = -1;
  int z = -1;
  int legal = -1;
  int orbitSize = -1;
};

uint64_t fnvFeed(uint64_t hash, uint32_t value) {
  for (int byte = 0; byte < 4; ++byte) {
    hash ^= (value >> (8 * byte)) & 0xffU;
    hash *= UINT64_C(1099511628211);
  }
  return hash;
}

int main(int argc, char **argv) {
  enum class Output { Summary, Csv, LeanRow };
  Output output = Output::Summary;
  int requestedLeanRow = -1;
  if (argc == 2 && std::string(argv[1]) == "--csv") {
    output = Output::Csv;
  } else if (argc == 3 && std::string(argv[1]) == "--lean-row") {
    output = Output::LeanRow;
    requestedLeanRow = std::stoi(argv[2]);
    if (!(5 < requestedLeanRow && requestedLeanRow < 309)) {
      std::cerr << "--lean-row requires 5 < b < 309\n";
      return 2;
    }
  } else if (argc != 1) {
    std::cerr << "usage: " << argv[0] << " [--csv | --lean-row B]\n";
    return 2;
  }

  std::vector<V> points;
  std::unordered_map<int, int> pointId;
  for (int a = 0; a < 25; ++a) {
    for (int b = 0; b < 25; ++b) {
      for (int c = 0; c < 25; ++c) {
        if (!(a || b || c)) continue;
        const V point = norm({a, b, c});
        const int pointKey = key(point);
        if (!pointId.contains(pointKey)) {
          pointId[pointKey] = static_cast<int>(points.size());
          points.push_back(point);
        }
      }
    }
  }
  assert(points.size() == kPointCount);

  std::vector<int> sigma(kPointCount);
  std::vector<int> fixed;
  for (int i = 0; i < kPointCount; ++i) {
    sigma[i] = pointId.at(key(frobenius(points[i])));
    if (sigma[i] == i) fixed.push_back(i);
  }
  assert(fixed.size() == 31);

  std::vector<std::pair<int, int>> orbits;
  for (int i = 0; i < kPointCount; ++i) {
    if (i < sigma[i]) {
      assert(projectiveRank(points[i]) < projectiveRank(points[sigma[i]]));
      orbits.push_back({i, sigma[i]});
    }
  }
  assert(orbits.size() == kOrbitCount);

  std::vector<int> orbitOfPoint(kPointCount, -1);
  std::vector<int> orbitByLeanNumber(kOrbitCount, -1);
  std::vector<int> leanNumberOfOrbit(kOrbitCount, -1);
  for (int orbit = 0; orbit < kOrbitCount; ++orbit) {
    orbitOfPoint[orbits[orbit].first] = orbit;
    orbitOfPoint[orbits[orbit].second] = orbit;
    const int lean = leanOrbitNumber(points[orbits[orbit].first], points[orbits[orbit].second]);
    assert(orbitByLeanNumber[lean] == -1);
    orbitByLeanNumber[lean] = orbit;
    leanNumberOfOrbit[orbit] = lean;
  }
  assert(orbitByLeanNumber[5] == kLeanFiveInternalOrbit);

  std::vector<std::vector<int>> linePoints(kPointCount);
  for (int line = 0; line < kPointCount; ++line) {
    for (int point = 0; point < kPointCount; ++point) {
      if (dot(points[point], points[line]) == 0) linePoints[line].push_back(point);
    }
    assert(linePoints[line].size() == 26);
  }
  std::vector<std::vector<int>> join(kPointCount, std::vector<int>(kPointCount, -1));
  for (int a = 0; a < kPointCount; ++a) {
    for (int b = a + 1; b < kPointCount; ++b) {
      join[a][b] = join[b][a] = pointId.at(key(cross(points[a], points[b])));
    }
  }

  const int fixedA = fixed[0];
  const int fixedB = fixed[1];
  assert(points[fixedA] == V({0, 0, 1}));
  assert(points[fixedB] == V({0, 1, 0}));

  std::vector<Parameter> parameters;
  for (int y = 5; y < 25; ++y) {
    for (int z = 5; z < 25; ++z) parameters.push_back({y, z});
  }
  assert(parameters.size() == kParameterCount);

  std::vector<std::array<uint16_t, kOrbitCount>> action(kParameterCount);
  for (int g = 0; g < kParameterCount; ++g) {
    std::array<bool, kOrbitCount> seen{};
    for (int orbit = 0; orbit < kOrbitCount; ++orbit) {
      const int imageFirst = pointId.at(key(residualApply(
          parameters[g].y, parameters[g].z, points[orbits[orbit].first])));
      const int imageSecond = pointId.at(key(residualApply(
          parameters[g].y, parameters[g].z, points[orbits[orbit].second])));
      const int imageOrbit = orbitOfPoint[imageFirst];
      assert(imageOrbit >= 0 && orbitOfPoint[imageSecond] == imageOrbit);
      action[g][orbit] = static_cast<uint16_t>(imageOrbit);
      assert(!seen[imageOrbit]);
      seen[imageOrbit] = true;
    }
    assert(pointId.at(key(residualApply(parameters[g].y, parameters[g].z,
                                        points[fixedA]))) == fixedA);
    assert(pointId.at(key(residualApply(parameters[g].y, parameters[g].z,
                                        points[fixedB]))) == fixedB);
  }
  assert(parameters[0].y == 5 && parameters[0].z == 5);
  for (int orbit = 0; orbit < kOrbitCount; ++orbit) assert(action[0][orbit] == orbit);

  auto imageTriple = [&](const Triple &triple, int g) {
    Triple image = {action[g][triple[0]], action[g][triple[1]], action[g][triple[2]]};
    std::sort(image.begin(), image.end());
    return image;
  };
  auto leanTriple = [&](const Triple &triple) {
    Triple lean = {leanNumberOfOrbit[triple[0]], leanNumberOfOrbit[triple[1]],
                   leanNumberOfOrbit[triple[2]]};
    std::sort(lean.begin(), lean.end());
    return lean;
  };
  auto configFromInternal = [&](const Triple &triple) {
    std::array<int, 8> config = {fixedA, fixedB,
        orbits[triple[0]].first, orbits[triple[0]].second,
        orbits[triple[1]].first, orbits[triple[1]].second,
        orbits[triple[2]].first, orbits[triple[2]].second};
    return config;
  };

  std::vector<uint8_t> selected(kPointCount);
  std::vector<uint8_t> occupied(kPointCount);
  std::vector<uint8_t> covered(kPointCount);
  auto legalCount = [&](const Triple &triple) {
    const auto config = configFromInternal(triple);
    std::fill(selected.begin(), selected.end(), 0);
    std::fill(occupied.begin(), occupied.end(), 0);
    std::fill(covered.begin(), covered.end(), 0);
    for (int point : config) selected[point] = 1;
    for (int point : config) {
      if (sigma[point] == point) {
        for (int line : linePoints[point]) {
          if (sigma[line] == line) occupied[line] = 1;
        }
      }
    }
    for (int orbit : triple) {
      occupied[join[orbits[orbit].first][orbits[orbit].second]] = 1;
    }
    for (int i = 0; i < 8; ++i) {
      for (int j = i + 1; j < 8; ++j) {
        for (int point : linePoints[join[config[i]][config[j]]]) covered[point] = 1;
      }
    }
    int legal = 0;
    for (int orbit = 0; orbit < kOrbitCount; ++orbit) {
      const int p = orbits[orbit].first;
      const int q = orbits[orbit].second;
      if (!selected[p] && !occupied[join[p][q]] && !covered[p]) {
        assert(!selected[q] && !covered[q]);
        ++legal;
      }
    }
    return legal;
  };

  std::vector<CoverRecord> records;
  records.reserve(kExpectedRows);
  std::set<Triple> canonicalSet;
  std::map<Triple, int> canonicalLegal;
  std::map<Triple, int> canonicalOrbitSize;
  int validRows = 0;
  int badRows = 0;
  uint64_t imagePointChecks = 0;
  uint64_t legalInvarianceChecks = 0;

  for (int b = 6; b < 309; ++b) {
    for (int c = b + 1; c < 310; ++c) {
      CoverRecord result;
      result.b = b;
      result.c = c;
      const int orbitB = orbitByLeanNumber[b];
      const int orbitC = orbitByLeanNumber[c];
      const std::array<int, 8> leanOrderedConfig = {
          fixedA, fixedB,
          orbits[kLeanFiveInternalOrbit].first, orbits[kLeanFiveInternalOrbit].second,
          orbits[orbitB].first, orbits[orbitB].second,
          orbits[orbitC].first, orbits[orbitC].second};
      Triple source = {kLeanFiveInternalOrbit, orbitB, orbitC};
      std::sort(source.begin(), source.end());

      bool valid = true;
      for (int i = 0; i < 8 && valid; ++i) {
        for (int j = i + 1; j < 8 && valid; ++j) {
          for (int k = j + 1; k < 8; ++k) {
            if (dot(points[leanOrderedConfig[k]],
                    points[join[leanOrderedConfig[i]][leanOrderedConfig[j]]]) == 0) {
              result.bad = {i, j, k};
              valid = false;
              break;
            }
          }
        }
      }
      if (!valid) {
        assert(result.bad[0] < result.bad[1] && result.bad[1] < result.bad[2]);
        ++badRows;
        records.push_back(result);
        continue;
      }

      result.valid = true;
      ++validRows;
      std::vector<Triple> images;
      images.reserve(kParameterCount);
      Triple canonical = {kOrbitCount, kOrbitCount, kOrbitCount};
      for (int g = 0; g < kParameterCount; ++g) {
        const Triple image = imageTriple(source, g);
        images.push_back(image);
        canonical = std::min(canonical, image);
      }
      std::sort(images.begin(), images.end());
      images.erase(std::unique(images.begin(), images.end()), images.end());
      assert(kParameterCount % images.size() == 0);
      assert(std::find(canonical.begin(), canonical.end(), kLeanFiveInternalOrbit) != canonical.end());
      result.canonicalInternal = canonical;
      result.canonicalLean = leanTriple(canonical);
      assert(result.canonicalLean[0] == 5);
      result.orbitSize = static_cast<int>(images.size());

      int transporter = -1;
      for (int g = 0; g < kParameterCount; ++g) {
        if (imageTriple(source, g) == canonical) {
          transporter = g;
          break;
        }
      }
      assert(transporter >= 0);
      result.y = parameters[transporter].y;
      result.z = parameters[transporter].z;
      assert(imagPart(result.y) != 0 && imagPart(result.z) != 0);

      std::vector<int> mappedSource;
      std::vector<int> canonicalPoints;
      mappedSource.reserve(8);
      canonicalPoints.reserve(8);
      for (int point : leanOrderedConfig) {
        mappedSource.push_back(pointId.at(key(residualApply(result.y, result.z, points[point]))));
        ++imagePointChecks;
      }
      const auto canonicalConfig = configFromInternal(canonical);
      canonicalPoints.assign(canonicalConfig.begin(), canonicalConfig.end());
      std::sort(mappedSource.begin(), mappedSource.end());
      std::sort(canonicalPoints.begin(), canonicalPoints.end());
      assert(mappedSource == canonicalPoints);

      result.legal = legalCount(source);
      const int targetLegal = legalCount(canonical);
      assert(result.legal == targetLegal);
      ++legalInvarianceChecks;
      const auto [legalIt, legalInserted] = canonicalLegal.emplace(canonical, result.legal);
      assert(legalInserted || legalIt->second == result.legal);
      const auto [sizeIt, sizeInserted] = canonicalOrbitSize.emplace(canonical, result.orbitSize);
      assert(sizeInserted || sizeIt->second == result.orbitSize);
      canonicalSet.insert(canonical);
      records.push_back(result);
    }
  }
  assert(records.size() == kExpectedRows);
  assert(validRows == kExpectedValidRows);
  assert(badRows == kExpectedRows - kExpectedValidRows);
  assert(canonicalSet.size() == kExpectedClasses);

  std::map<Triple, int> classIndex;
  int nextClass = 0;
  for (const Triple &canonical : canonicalSet) classIndex[canonical] = nextClass++;
  std::map<int, int> classSize;
  std::map<int, int> orbitSizeHistogram;
  std::map<int, int> legalClassHistogram;
  for (CoverRecord &result : records) {
    if (!result.valid) continue;
    result.classIndex = classIndex.at(result.canonicalInternal);
    ++classSize[result.classIndex];
  }
  for (const auto &[canonical, index] : classIndex) {
    const int orbitSize = canonicalOrbitSize.at(canonical);
    ++orbitSizeHistogram[orbitSize];
    ++legalClassHistogram[canonicalLegal.at(canonical)];
    const int expectedSliceSize = orbitSize == 200 ? 3 : 6;
    assert(classSize[index] == expectedSliceSize);
    assert(leanTriple(canonical)[0] == 5);
  }
  assert(orbitSizeHistogram[200] == 30);
  assert(orbitSizeHistogram[400] == 1159);

  uint64_t dataHash = UINT64_C(14695981039346656037);
  for (const CoverRecord &result : records) {
    dataHash = fnvFeed(dataHash, result.b);
    dataHash = fnvFeed(dataHash, result.c);
    dataHash = fnvFeed(dataHash, result.valid ? 1U : 0U);
    for (int x : result.bad) dataHash = fnvFeed(dataHash, static_cast<uint32_t>(x));
    dataHash = fnvFeed(dataHash, static_cast<uint32_t>(result.classIndex));
    for (int x : result.canonicalLean) dataHash = fnvFeed(dataHash, static_cast<uint32_t>(x));
    dataHash = fnvFeed(dataHash, static_cast<uint32_t>(result.y));
    dataHash = fnvFeed(dataHash, static_cast<uint32_t>(result.z));
    dataHash = fnvFeed(dataHash, static_cast<uint32_t>(result.legal));
    dataHash = fnvFeed(dataHash, static_cast<uint32_t>(result.orbitSize));
  }

  if (output == Output::Summary) {
    std::cout << "points=" << points.size() << " nonfixed_orbits=" << orbits.size()
              << " residual_parameters=" << parameters.size() << '\n';
    std::cout << "rows=" << records.size() << " bad_rows=" << badRows
              << " valid_rows=" << validRows << " residual_classes=" << canonicalSet.size()
              << " image_point_checks=" << imagePointChecks
              << " legal_invariance_checks=" << legalInvarianceChecks << '\n';
    std::cout << "orbit_size_histogram";
    for (const auto &[size, count] : orbitSizeHistogram) std::cout << ' ' << size << ':' << count;
    std::cout << "\nclass_legal_histogram";
    for (const auto &[legal, count] : legalClassHistogram) std::cout << ' ' << legal << ':' << count;
    std::cout << "\ndata_fnv1a64=" << std::hex << std::setw(16) << std::setfill('0')
              << dataHash << std::dec << '\n';
    std::cout << "csv_columns=b,c,tag,bad_i,bad_j,bad_k,class_index,canonical_b,"
                 "canonical_c,y,z,legal,orbit_size\n";
  } else if (output == Output::Csv) {
    std::cout << "b,c,tag,bad_i,bad_j,bad_k,class_index,canonical_b,canonical_c,y,z,legal,"
                 "orbit_size\n";
    for (const CoverRecord &result : records) {
      std::cout << result.b << ',' << result.c << ',' << (result.valid ? 'V' : 'B') << ','
                << result.bad[0] << ',' << result.bad[1] << ',' << result.bad[2] << ','
                << result.classIndex << ',';
      if (result.valid) {
        std::cout << result.canonicalLean[1] << ',' << result.canonicalLean[2] << ','
                  << result.y << ',' << result.z << ',' << result.legal << ','
                  << result.orbitSize;
      } else {
        std::cout << "-1,-1,-1,-1,-1,-1";
      }
      std::cout << '\n';
    }
  } else {
    std::cout << "-- Generated by notes/2026-07-15-c151-residual-cover.cpp --lean-row "
              << requestedLeanRow << '\n';
    std::cout << "-- bad entry: #[c, 0, i, j, k]\n";
    std::cout << "-- valid entry: #[c, 1, class, canonicalB, canonicalC, y, z, legal, orbitSize]\n";
    std::cout << "def c151ResidualCoverRow" << requestedLeanRow
              << " : Array (Array Nat) := #[\n";
    for (const CoverRecord &result : records) {
      if (result.b != requestedLeanRow) continue;
      if (result.valid) {
        std::cout << "  #[" << result.c << ", 1, " << result.classIndex << ", "
                  << result.canonicalLean[1] << ", " << result.canonicalLean[2] << ", "
                  << result.y << ", " << result.z << ", " << result.legal << ", "
                  << result.orbitSize << "],\n";
      } else {
        std::cout << "  #[" << result.c << ", 0, " << result.bad[0] << ", "
                  << result.bad[1] << ", " << result.bad[2] << "],\n";
      }
    }
    std::cout << "]\n";
  }
}
