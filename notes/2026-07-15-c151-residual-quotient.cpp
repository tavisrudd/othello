#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <limits>
#include <map>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

// Independent C151 scout for the quotient of the complete normalized Q25 arc census by the
// ordered-fixed-pair stabilizer in PGL(3,5).  This emits proposal data only; Lean must check any
// table entries used in a proof.

using V = std::array<int, 3>;
using Mat = std::array<int, 9>;
using Triple = std::array<int, 3>;

constexpr int kPointCount = 651;
constexpr int kOrbitCount = 310;
constexpr int kGroupOrder = 400;
constexpr int kLeanFiveInternalOrbit = 65;
constexpr int kExpectedArcCount = 469600;

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

int det5(const Mat &m) {
  int determinant = m[0] * (m[4] * m[8] - m[5] * m[7])
                  - m[1] * (m[3] * m[8] - m[5] * m[6])
                  + m[2] * (m[3] * m[7] - m[4] * m[6]);
  determinant %= 5;
  return determinant < 0 ? determinant + 5 : determinant;
}

V applyMat(const Mat &m, const V &v) {
  V out{};
  for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
      out[i] = add25(out[i], mul25(m[3 * i + j], v[j]));
    }
  }
  return norm(out);
}

uint32_t choose2(uint32_t n) { return n * (n - 1) / 2; }
uint32_t choose3(uint32_t n) { return n * (n - 1) * (n - 2) / 6; }

uint32_t tripleRank(const Triple &triple) {
  assert(0 <= triple[0] && triple[0] < triple[1] && triple[1] < triple[2] &&
         triple[2] < kOrbitCount);
  return choose3(static_cast<uint32_t>(triple[2])) +
         choose2(static_cast<uint32_t>(triple[1])) +
         static_cast<uint32_t>(triple[0]);
}

bool containsOrbit(const Triple &triple, int orbit) {
  return std::find(triple.begin(), triple.end(), orbit) != triple.end();
}

struct ArcRecord {
  Triple triple{};
  uint8_t legal = 0;
};

struct ClassRecord {
  Triple canonical{};
  Triple canonicalLean{};
  uint16_t orbitSize = 0;
  uint16_t stabilizerSize = 0;
  uint16_t sliceSize = 0;
  uint8_t legal = 0;
  Triple sliceRepresentative{};
  Triple sliceRepresentativeLean{};
  int transporter = -1;  // residualGroup[transporter] sends canonical to sliceRepresentative
};

uint64_t fnvFeed(uint64_t hash, uint32_t value) {
  for (int shift = 0; shift < 32; shift += 8) {
    hash ^= (value >> shift) & 0xffU;
    hash *= UINT64_C(1099511628211);
  }
  return hash;
}

int main(int argc, char **argv) {
  bool tableOnly = false;
  if (argc == 2 && std::string(argv[1]) == "--table-only") tableOnly = true;
  else if (argc != 1) {
    std::cerr << "usage: " << argv[0] << " [--table-only]\n";
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
    if (i < sigma[i]) orbits.push_back({i, sigma[i]});
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
  std::vector<Mat> residualGroup;
  constexpr int matrixCount = 1953125;  // 5^9
  for (int code = 0; code < matrixCount; ++code) {
    int remaining = code;
    Mat matrix{};
    for (int j = 0; j < 9; ++j) {
      matrix[j] = remaining % 5;
      remaining /= 5;
    }
    const auto first = std::find_if(matrix.begin(), matrix.end(), [](int x) { return x != 0; });
    if (first == matrix.end() || *first != 1 || det5(matrix) == 0) continue;
    if (pointId.at(key(applyMat(matrix, points[fixedA]))) != fixedA ||
        pointId.at(key(applyMat(matrix, points[fixedB]))) != fixedB) continue;
    residualGroup.push_back(matrix);
  }
  assert(residualGroup.size() == kGroupOrder);

  std::vector<std::array<uint16_t, kOrbitCount>> action(kGroupOrder);
  for (int g = 0; g < kGroupOrder; ++g) {
    std::array<bool, kOrbitCount> seen{};
    for (int orbit = 0; orbit < kOrbitCount; ++orbit) {
      const int imagePoint = pointId.at(key(applyMat(
          residualGroup[g], points[orbits[orbit].first])));
      const int imageConjugate = pointId.at(key(applyMat(
          residualGroup[g], points[orbits[orbit].second])));
      const int imageOrbit = orbitOfPoint[imagePoint];
      assert(imageOrbit >= 0 && orbitOfPoint[imageConjugate] == imageOrbit);
      action[g][orbit] = static_cast<uint16_t>(imageOrbit);
      assert(!seen[imageOrbit]);
      seen[imageOrbit] = true;
    }
  }

  std::set<int> fiveImages;
  for (int g = 0; g < kGroupOrder; ++g) fiveImages.insert(action[g][kLeanFiveInternalOrbit]);

  std::vector<int> good;
  for (int orbit = 0; orbit < kOrbitCount; ++orbit) {
    const std::array<int, 4> config = {
        fixedA, fixedB, orbits[orbit].first, orbits[orbit].second};
    bool valid = true;
    for (int i = 0; i < 4; ++i) {
      for (int j = i + 1; j < 4; ++j) {
        for (int k = j + 1; k < 4; ++k) {
          if (dot(points[config[k]], points[join[config[i]][config[j]]]) == 0) valid = false;
        }
      }
    }
    if (valid) good.push_back(orbit);
  }
  assert(good.size() == 200);
  assert(fiveImages.size() == good.size());
  assert(std::equal(fiveImages.begin(), fiveImages.end(), good.begin(), good.end()));

  const int goodCount = static_cast<int>(good.size());
  std::vector<std::vector<uint8_t>> compatible(
      goodCount, std::vector<uint8_t>(goodCount));
  for (int i = 0; i < goodCount; ++i) {
    for (int j = i + 1; j < goodCount; ++j) {
      const int firstOrbit = good[i];
      const int secondOrbit = good[j];
      const std::array<int, 6> config = {
          fixedA, fixedB,
          orbits[firstOrbit].first, orbits[firstOrbit].second,
          orbits[secondOrbit].first, orbits[secondOrbit].second};
      bool valid = true;
      for (int x = 0; x < 6 && valid; ++x) {
        for (int y = x + 1; y < 6 && valid; ++y) {
          for (int z = y + 1; z < 6; ++z) {
            if (dot(points[config[z]], points[join[config[x]][config[y]]]) == 0) {
              valid = false;
              break;
            }
          }
        }
      }
      compatible[i][j] = compatible[j][i] = valid;
    }
  }

  const uint32_t tripleCount = choose3(kOrbitCount);
  std::vector<int32_t> recordAtRank(tripleCount, -1);
  std::vector<ArcRecord> arcs;
  std::map<int, uint64_t> legalHistogram;
  std::vector<uint8_t> selected(kPointCount);
  std::vector<uint8_t> occupied(kPointCount);
  std::vector<uint8_t> covered(kPointCount);

  for (int ii = 0; ii < goodCount; ++ii) {
    for (int jj = ii + 1; jj < goodCount; ++jj) {
      if (!compatible[ii][jj]) continue;
      for (int kk = jj + 1; kk < goodCount; ++kk) {
        if (!compatible[ii][kk] || !compatible[jj][kk]) continue;
        const int oi = good[ii];
        const int oj = good[jj];
        const int ok = good[kk];
        const std::array<int, 8> config = {
            fixedA, fixedB,
            orbits[oi].first, orbits[oi].second,
            orbits[oj].first, orbits[oj].second,
            orbits[ok].first, orbits[ok].second};
        bool valid = true;
        for (int x = 2; x < 4 && valid; ++x) {
          for (int y = 4; y < 6 && valid; ++y) {
            for (int z = 6; z < 8; ++z) {
              if (dot(points[config[z]], points[join[config[x]][config[y]]]) == 0) {
                valid = false;
                break;
              }
            }
          }
        }
        if (!valid) continue;

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
        for (int orbit : {oi, oj, ok}) {
          occupied[join[orbits[orbit].first][orbits[orbit].second]] = 1;
        }
        for (int x = 0; x < 8; ++x) {
          for (int y = x + 1; y < 8; ++y) {
            const int line = join[config[x]][config[y]];
            for (int point : linePoints[line]) covered[point] = 1;
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

        const Triple triple = {oi, oj, ok};
        const uint32_t rank = tripleRank(triple);
        assert(recordAtRank[rank] == -1);
        recordAtRank[rank] = static_cast<int32_t>(arcs.size());
        arcs.push_back({triple, static_cast<uint8_t>(legal)});
        ++legalHistogram[legal];
      }
    }
  }
  assert(arcs.size() == kExpectedArcCount);

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
  auto findRecord = [&](const Triple &triple) {
    const int32_t record = recordAtRank[tripleRank(triple)];
    assert(record >= 0 && arcs[record].triple == triple);
    return static_cast<int>(record);
  };

  std::vector<int32_t> classOf(arcs.size(), -1);
  std::vector<ClassRecord> classes;
  std::map<int, uint64_t> orbitSizeHistogram;
  std::map<int, uint64_t> sliceSizeHistogram;
  std::map<int, uint64_t> classLegalHistogram;
  uint64_t invariantComparisons = 0;

  for (int record = 0; record < static_cast<int>(arcs.size()); ++record) {
    if (classOf[record] >= 0) continue;
    std::vector<int> images;
    images.reserve(kGroupOrder);
    Triple canonical = {kOrbitCount, kOrbitCount, kOrbitCount};
    for (int g = 0; g < kGroupOrder; ++g) {
      const Triple image = imageTriple(arcs[record].triple, g);
      const int imageRecord = findRecord(image);
      assert(arcs[imageRecord].legal == arcs[record].legal);
      ++invariantComparisons;
      images.push_back(imageRecord);
      canonical = std::min(canonical, image);
    }
    std::sort(images.begin(), images.end());
    images.erase(std::unique(images.begin(), images.end()), images.end());
    assert(kGroupOrder % images.size() == 0);

    const int classIndex = static_cast<int>(classes.size());
    for (int imageRecord : images) {
      assert(classOf[imageRecord] == -1 || classOf[imageRecord] == classIndex);
      classOf[imageRecord] = classIndex;
    }

    ClassRecord result;
    result.canonical = canonical;
    result.canonicalLean = leanTriple(canonical);
    result.orbitSize = static_cast<uint16_t>(images.size());
    result.stabilizerSize = static_cast<uint16_t>(kGroupOrder / images.size());
    result.legal = arcs[record].legal;
    result.sliceRepresentative = {kOrbitCount, kOrbitCount, kOrbitCount};
    for (int imageRecord : images) {
      const Triple &image = arcs[imageRecord].triple;
      if (containsOrbit(image, kLeanFiveInternalOrbit)) {
        ++result.sliceSize;
        result.sliceRepresentative = std::min(result.sliceRepresentative, image);
      }
    }
    if (result.sliceSize != 0) {
      result.sliceRepresentativeLean = leanTriple(result.sliceRepresentative);
      const int canonicalRecord = findRecord(canonical);
      for (int g = 0; g < kGroupOrder; ++g) {
        if (imageTriple(arcs[canonicalRecord].triple, g) == result.sliceRepresentative) {
          result.transporter = g;
          break;
        }
      }
      assert(result.transporter >= 0);
    }
    classes.push_back(result);
    ++orbitSizeHistogram[result.orbitSize];
    ++sliceSizeHistogram[result.sliceSize];
    ++classLegalHistogram[result.legal];
  }
  assert(std::all_of(classOf.begin(), classOf.end(), [](int32_t x) { return x >= 0; }));
  assert(std::is_sorted(classes.begin(), classes.end(),
                        [](const ClassRecord &a, const ClassRecord &b) {
                          return a.canonical < b.canonical;
                        }));

  uint64_t memberTotal = 0;
  uint64_t sliceArcCount = 0;
  uint64_t sliceClassCount = 0;
  for (const ClassRecord &result : classes) {
    memberTotal += result.orbitSize;
    sliceArcCount += result.sliceSize;
    sliceClassCount += result.sliceSize != 0;
  }
  assert(memberTotal == arcs.size());
  assert(sliceArcCount == 7044);
  assert(sliceClassCount == classes.size());
  assert(std::all_of(classes.begin(), classes.end(), [](const ClassRecord &result) {
    return containsOrbit(result.canonical, kLeanFiveInternalOrbit) &&
           result.sliceRepresentative == result.canonical && result.transporter == 0;
  }));

  uint64_t tableHash = UINT64_C(14695981039346656037);
  for (const ClassRecord &result : classes) {
    for (int x : result.canonical) tableHash = fnvFeed(tableHash, x);
    for (int x : result.canonicalLean) tableHash = fnvFeed(tableHash, x);
    tableHash = fnvFeed(tableHash, result.orbitSize);
    tableHash = fnvFeed(tableHash, result.stabilizerSize);
    tableHash = fnvFeed(tableHash, result.legal);
    tableHash = fnvFeed(tableHash, result.sliceSize);
    for (int x : result.sliceRepresentative) tableHash = fnvFeed(tableHash, x);
    for (int x : result.sliceRepresentativeLean) tableHash = fnvFeed(tableHash, x);
    tableHash = fnvFeed(tableHash, static_cast<uint32_t>(result.transporter));
  }

  auto printTriple = [](const Triple &triple) {
    std::cout << triple[0] << ',' << triple[1] << ',' << triple[2];
  };

  if (!tableOnly) {
    std::cout << "points=" << points.size() << " nonfixed_orbits=" << orbits.size()
              << " good_orbits=" << good.size() << " residual_group=" << residualGroup.size()
              << " orbit_of_lean5_size=" << fiveImages.size() << '\n';
    std::cout << "normalized_arcs=" << arcs.size() << " arcs_containing_lean5=" << sliceArcCount
              << " residual_classes=" << classes.size()
              << " slice_intersecting_classes=" << sliceClassCount
              << " legal_invariance_comparisons=" << invariantComparisons << '\n';
    std::cout << "orbit_size_histogram";
    for (const auto &[size, count] : orbitSizeHistogram) std::cout << ' ' << size << ':' << count;
    std::cout << "\nslice_size_histogram";
    for (const auto &[size, count] : sliceSizeHistogram) std::cout << ' ' << size << ':' << count;
    std::cout << "\nlegal_histogram";
    for (const auto &[legal, count] : legalHistogram) std::cout << ' ' << legal << ':' << count;
    std::cout << "\nclass_legal_histogram";
    for (const auto &[legal, count] : classLegalHistogram) std::cout << ' ' << legal << ':' << count;
    std::cout << "\nrepresentative_table_rows=" << classes.size() << " table_fnv1a64="
              << std::hex << std::setw(16) << std::setfill('0') << tableHash << std::dec << '\n';
    std::cout << "table_columns=canonical_internal,canonical_lean,orbit_size,stabilizer,legal,"
                 "slice_size,slice_internal,slice_lean,canonical_to_slice_group_index\n";
  } else {
    std::cout << "canonical_internal,canonical_lean,orbit_size,stabilizer,legal,slice_size,"
                 "slice_internal,slice_lean,canonical_to_slice_group_index\n";
    for (const ClassRecord &result : classes) {
      printTriple(result.canonical);
      std::cout << ',';
      printTriple(result.canonicalLean);
      std::cout << ',' << result.orbitSize << ',' << result.stabilizerSize << ','
                << static_cast<int>(result.legal) << ',' << result.sliceSize << ',';
      if (result.sliceSize == 0) {
        std::cout << "-,-,-,-,-,-,-";
      } else {
        printTriple(result.sliceRepresentative);
        std::cout << ',';
        printTriple(result.sliceRepresentativeLean);
        std::cout << ',' << result.transporter;
      }
      std::cout << '\n';
    }
  }
}
