#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wreturn-type"
#define main c637_original_main
#include "2026-07-25-c637-secant-hull-coupling.cpp"
#undef main
#pragma GCC diagnostic pop

#include <map>
#include <sstream>

struct Signature {
  int uncoveredSize = 0;
  bool uncoveredArc = false;
  int rank = 0;
  int conicExceptions = -1;
  int selectedOnConic = -1;
  int selectedInternal = -1;
  int selectedExternal = -1;
  int repeatedCoverage = 0;
  int maximumMultiplicity = 0;
};

static std::vector<int> quadraticKernel(std::vector<Row> rows) {
  std::array<int, 6> pivotRow{};
  pivotRow.fill(-1);
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
    pivotRow[col] = rank++;
  }
  int freeCol = -1;
  for (int col = 5; col >= 0; --col) {
    if (pivotRow[col] == -1) {
      freeCol = col;
      break;
    }
  }
  if (freeCol == -1) return {};
  std::vector<int> kernel(6, 0);
  kernel[freeCol] = 1;
  for (int col = 5; col >= 0; --col) {
    if (pivotRow[col] == -1) continue;
    int value = 0;
    for (int j = col + 1; j < 6; ++j) {
      value = mod(value + rows[pivotRow[col]][j] * kernel[j]);
    }
    kernel[col] = mod(-value);
  }
  return kernel;
}

static int evaluateQuadratic(const std::vector<int> &form, const Point &p) {
  const Row row = quadraticRow(p);
  int value = 0;
  for (int i = 0; i < 6; ++i) value = mod(value + form[i] * row[i]);
  return value;
}

static Signature signature(const Arc &arc) {
  std::vector<bool> chosen(points.size(), false);
  std::vector<int> multiplicity(points.size(), 0);
  for (int x : arc) chosen[x] = true;
  for (std::size_t i = 0; i < arc.size(); ++i) {
    for (std::size_t j = 0; j < i; ++j) {
      for (int x = 0; x < static_cast<int>(points.size()); ++x) {
        if (!chosen[x] &&
            determinant(points[arc[i]], points[arc[j]], points[x]) == 0) {
          ++multiplicity[x];
        }
      }
    }
  }

  std::vector<int> uncovered;
  std::vector<Row> rows;
  Signature result;
  for (int x = 0; x < static_cast<int>(points.size()); ++x) {
    if (chosen[x]) continue;
    result.maximumMultiplicity = std::max(result.maximumMultiplicity, multiplicity[x]);
    result.repeatedCoverage += std::max(0, multiplicity[x] - 1);
    if (multiplicity[x] == 0) {
      uncovered.push_back(x);
      rows.push_back(quadraticRow(points[x]));
    }
  }
  result.uncoveredSize = static_cast<int>(uncovered.size());
  result.rank = rowRank(rows);
  result.uncoveredArc = true;
  for (std::size_t i = 0; i < uncovered.size() && result.uncoveredArc; ++i) {
    for (std::size_t j = 0; j < i && result.uncoveredArc; ++j) {
      for (std::size_t k = 0; k < j; ++k) {
        if (determinant(points[uncovered[i]], points[uncovered[j]],
                        points[uncovered[k]]) == 0) {
          result.uncoveredArc = false;
          break;
        }
      }
    }
  }

  if (!result.uncoveredArc || uncovered.size() < 6) return result;
  std::vector<Row> fiveRows;
  for (int i = 0; i < 5; ++i) fiveRows.push_back(quadraticRow(points[uncovered[i]]));
  const std::vector<int> form = quadraticKernel(fiveRows);
  if (form.empty()) throw std::runtime_error("five uncovered arc points lack a conic");
  result.conicExceptions = 0;
  for (int x : uncovered) {
    if (evaluateQuadratic(form, points[x]) != 0) ++result.conicExceptions;
  }

  std::vector<int> conicPoints;
  for (int x = 0; x < static_cast<int>(points.size()); ++x) {
    if (evaluateQuadratic(form, points[x]) == 0) conicPoints.push_back(x);
  }
  if (static_cast<int>(conicPoints.size()) != q + 1) {
    throw std::runtime_error("five-arc conic is not nonsingular");
  }
  result.selectedOnConic = 0;
  result.selectedInternal = 0;
  result.selectedExternal = 0;
  for (int x : arc) {
    if (evaluateQuadratic(form, points[x]) == 0) {
      ++result.selectedOnConic;
      continue;
    }
    int conicSecants = 0;
    for (std::size_t i = 0; i < conicPoints.size(); ++i) {
      for (std::size_t j = 0; j < i; ++j) {
        if (determinant(points[conicPoints[i]], points[conicPoints[j]],
                        points[x]) == 0) {
          ++conicSecants;
        }
      }
    }
    if (conicSecants == (q + 1) / 2) {
      ++result.selectedInternal;
    } else if (conicSecants == (q - 1) / 2) {
      ++result.selectedExternal;
    } else {
      throw std::runtime_error("invalid odd-conic point type");
    }
  }
  return result;
}

static std::string signatureKey(const Signature &s) {
  std::ostringstream out;
  out << s.uncoveredSize << "," << (s.uncoveredArc ? 1 : 0) << "," << s.rank
      << "," << s.conicExceptions << "," << s.selectedOnConic << ","
      << s.selectedInternal << "," << s.selectedExternal << ","
      << s.repeatedCoverage << "," << s.maximumMultiplicity;
  return out.str();
}

static void initializePlane(int fieldOrder) {
  q = fieldOrder;
  points.clear();
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
}

int main(int argc, char **argv) {
  if (argc != 4 && argc != 5) {
    std::cerr << "usage: obstruction-signatures Q K OUTPUT.json [--extensions]\n";
    return 2;
  }
  const int fieldOrder = std::stoi(argv[1]);
  const int target = std::stoi(argv[2]);
  const std::string outputPath = argv[3];
  const bool testExtensions = argc == 5 && std::string(argv[4]) == "--extensions";
  if (argc == 5 && !testExtensions) throw std::runtime_error("unknown mode");
  for (int x = 2; x < fieldOrder; ++x) {
    if (fieldOrder % x == 0) throw std::runtime_error("Q must be prime");
  }
  initializePlane(fieldOrder);

  Arc frame{
      pointIndex[pointCode({1, 0, 0})],
      pointIndex[pointCode({0, 1, 0})],
      pointIndex[pointCode({0, 0, 1})],
      pointIndex[pointCode({1, 1, 1})]};
  std::sort(frame.begin(), frame.end());
  std::vector<Arc> classes{canonical(frame)};
  std::vector<std::uint64_t> classCounts{1};
  std::map<std::string, std::uint64_t> signatures;
  std::uint64_t tested = 0;
  std::uint64_t collinearTripleCertificates = 0;
  std::uint64_t sixPointConicCertificates = 0;
  Arc arcSurvivor;
  HullProfile arcSurvivorProfile;
  std::vector<int> arcSurvivorConic;

  auto record = [&](const Arc &arc) {
    const Signature s = signature(arc);
    ++tested;
    ++signatures[signatureKey(s)];
    if (!s.uncoveredArc) {
      ++collinearTripleCertificates;
    } else if (s.rank == 6 && s.uncoveredSize >= 6 && s.conicExceptions > 0) {
      ++sixPointConicCertificates;
      if (arcSurvivor.empty()) {
        arcSurvivor = arc;
        arcSurvivorProfile = hullProfile(arc);
        std::vector<Row> fiveRows;
        for (int i = 0; i < 5; ++i) {
          fiveRows.push_back(quadraticRow(points[arcSurvivorProfile.uncovered[i]]));
        }
        arcSurvivorConic = quadraticKernel(fiveRows);
      }
    } else {
      throw std::runtime_error("candidate lacks a compressed obstruction certificate");
    }
  };

  for (int n = 5; n <= target; ++n) {
    std::set<Arc> next;
    for (const Arc &arc : classes) {
      for (int x = 0; x < static_cast<int>(points.size()); ++x) {
        if (std::binary_search(arc.begin(), arc.end(), x) || !legalAdd(arc, x)) continue;
        Arc child = arc;
        child.push_back(x);
        std::sort(child.begin(), child.end());
        if (testExtensions && n == target) {
          record(child);
        } else {
          next.insert(canonical(child));
        }
      }
    }
    if (testExtensions && n == target) break;
    classes.assign(next.begin(), next.end());
    classCounts.push_back(classes.size());
    std::cerr << "q=" << q << " n=" << n << " classes=" << classes.size() << "\n";
  }
  if (!testExtensions) {
    for (const Arc &arc : classes) record(arc);
  }

  std::ofstream out(outputPath);
  if (!out) throw std::runtime_error("cannot open output path");
  out << "{\"schema\":\"c643-obstruction-signatures-v1\",\"q\":" << q
      << ",\"k\":" << target << ",\"mode\":\""
      << (testExtensions ? "extensions" : "projective_classes")
      << "\",\"class_counts\":[";
  for (std::size_t i = 0; i < classCounts.size(); ++i) {
    if (i) out << ",";
    out << classCounts[i];
  }
  out << "],\"tested\":" << tested
      << ",\"collinear_triple_certificates\":" << collinearTripleCertificates
      << ",\"six_point_conic_certificates\":" << sixPointConicCertificates
      << ",\"signature_fields\":[\"uncovered_size\",\"uncovered_is_arc\","
         "\"quadratic_rank\",\"off_five_point_conic\",\"selected_on_conic\","
         "\"selected_internal\",\"selected_external\",\"repeated_coverage\","
         "\"maximum_secant_multiplicity\"],\"signatures\":{";
  bool first = true;
  for (const auto &[key, count] : signatures) {
    if (!first) out << ",";
    first = false;
    out << "\"" << key << "\":" << count;
  }
  out << "}";
  if (!arcSurvivor.empty()) {
    out << ",\"arc_survivor\":";
    writePointList(out, arcSurvivor);
    out << ",\"arc_survivor_uncovered\":";
    writePointList(out, arcSurvivorProfile.uncovered);
    out << ",\"five_point_conic\":[";
    for (std::size_t i = 0; i < arcSurvivorConic.size(); ++i) {
      if (i) out << ",";
      out << arcSurvivorConic[i];
    }
    out << "]";
  }
  out << "}\n";
}
