#include <array>
#include <fstream>
#include <iostream>
#include <regex>
#include <set>
#include <sstream>
#include <string>
#include <tuple>
#include <vector>

using P = std::array<int, 3>;
using F = std::array<int, 6>;

static int gm(int a, int b) {
  int out = 0;
  while (b) {
    if (b & 1) out ^= a;
    b >>= 1;
    a <<= 1;
    if (a & 16) a ^= 0x13;
  }
  return out;
}

static int gi(int a) {
  for (int b = 1; b < 16; ++b) if (gm(a, b) == 1) return b;
  throw std::runtime_error("zero inverse");
}

static int dot(const P &a, const P &b) {
  return gm(a[0], b[0]) ^ gm(a[1], b[1]) ^ gm(a[2], b[2]);
}

static P norm(P a) {
  int lead = a[0] ? a[0] : (a[1] ? a[1] : a[2]);
  int z = gi(lead);
  for (int &x : a) x = gm(z, x);
  return a;
}

static P cross(const P &a, const P &b) {
  return norm({gm(a[1], b[2]) ^ gm(a[2], b[1]),
               gm(a[2], b[0]) ^ gm(a[0], b[2]),
               gm(a[0], b[1]) ^ gm(a[1], b[0])});
}

static F mono(const P &p) {
  return {gm(p[0], p[0]), gm(p[1], p[1]), gm(p[2], p[2]),
          gm(p[0], p[1]), gm(p[0], p[2]), gm(p[1], p[2])};
}

static F fnorm(F f) {
  int lead = 0;
  while (lead < 6 && !f[lead]) ++lead;
  int z = gi(f[lead]);
  for (int &x : f) x = gm(z, x);
  return f;
}

static int eval(const F &f, const F &v) {
  int out = 0;
  for (int i = 0; i < 6; ++i) out ^= gm(f[i], v[i]);
  return out;
}

static std::pair<int, F> kernel5(std::array<F, 5> a) {
  int row = 0;
  std::array<int, 5> piv{};
  for (int col = 0; col < 6 && row < 5; ++col) {
    int at = row;
    while (at < 5 && !a[at][col]) ++at;
    if (at == 5) continue;
    std::swap(a[row], a[at]);
    int z = gi(a[row][col]);
    for (int j = 0; j < 6; ++j) a[row][j] = gm(z, a[row][j]);
    for (int i = 0; i < 5; ++i) if (i != row && a[i][col]) {
      int c = a[i][col];
      for (int j = 0; j < 6; ++j) a[i][j] ^= gm(c, a[row][j]);
    }
    piv[row++] = col;
  }
  if (row != 5) return {row, {}};
  int free_col = 0;
  while (free_col < 6) {
    bool used = false;
    for (int i = 0; i < 5; ++i) used |= piv[i] == free_col;
    if (!used) break;
    ++free_col;
  }
  F v{};
  v[free_col] = 1;
  for (int i = 0; i < 5; ++i) v[piv[i]] = a[i][free_col];
  return {5, fnorm(v)};
}

int main(int argc, char **argv) {
  bool write = false, check = false;
  std::string output =
      "notes/2026-07-26-c667-q16-multibase-involution-expansion.json";
  for (int i = 1; i < argc; ++i) {
    std::string arg = argv[i];
    if (arg == "--write") write = true;
    else if (arg == "--check") check = true;
    else if (arg == "--output" && i + 1 < argc) output = argv[++i];
    else throw std::runtime_error("usage: --write|--check [--output PATH]");
  }
  if (write == check)
    throw std::runtime_error("choose exactly one of --write or --check");

  std::vector<P> pts{{0, 0, 1}};
  for (int z = 0; z < 16; ++z) pts.push_back({0, 1, z});
  for (int y = 0; y < 16; ++y)
    for (int z = 0; z < 16; ++z) pts.push_back({1, y, z});
  std::vector<F> mons;
  for (const auto &p : pts) mons.push_back(mono(p));
  std::array<int, 4096> point_index{};
  for (int i = 0; i < 273; ++i)
    point_index[(pts[i][0] << 8) | (pts[i][1] << 4) | pts[i][2]] = i;

  std::vector<std::vector<int>> lines(273);
  for (int l = 0; l < 273; ++l)
    for (int x = 0; x < 273; ++x)
      if (!dot(pts[l], pts[x])) lines[l].push_back(x);

  const std::array<int, 8> boundary_arc{2, 25, 26, 43, 44, 89, 108, 197};
  std::array<bool, 273> standard_conic{}, boundary_covered{};
  for (int x = 0; x < 273; ++x)
    standard_conic[x] =
        (gm(pts[x][0], pts[x][2]) ^ gm(pts[x][1], pts[x][1])) == 0;
  for (int i = 0; i < 8; ++i) for (int j = i + 1; j < 8; ++j) {
    P l = cross(pts[boundary_arc[i]], pts[boundary_arc[j]]);
    int li = point_index[(l[0] << 8) | (l[1] << 4) | l[2]];
    for (int x : lines[li]) boundary_covered[x] = true;
  }
  std::vector<int> boundary_u, boundary_off_holes, boundary_profile;
  for (int x = 0; x < 273; ++x) {
    if (standard_conic[x] && !boundary_covered[x]) boundary_u.push_back(x);
    if (!standard_conic[x] && !boundary_covered[x]) {
      bool selected = false;
      for (int a : boundary_arc) selected |= x == a;
      if (!selected) boundary_off_holes.push_back(x);
    }
  }
  for (int a : boundary_arc) {
    int boundary = 0;
    for (int u : boundary_u) {
      P l = cross(pts[a], pts[u]);
      int li = point_index[(l[0] << 8) | (l[1] << 4) | l[2]];
      int image = u;
      for (int x : lines[li])
        if (x != u && standard_conic[x]) image = x;
      bool stays = false;
      for (int x : boundary_u) stays |= image == x;
      boundary += !stays;
    }
    boundary_profile.push_back(boundary);
  }
  if (boundary_u != std::vector<int>({53, 70, 84, 174, 202, 239}) ||
      boundary_off_holes !=
          std::vector<int>({7, 8, 12, 16, 83, 88, 98, 101, 113, 132, 139,
                            158, 159, 171, 175, 184, 187, 222}) ||
      boundary_profile != std::vector<int>({4, 2, 3, 2, 2, 4, 4, 3}))
    throw std::runtime_error("boundary-only witness mismatch");

  std::ifstream in("lean/RelativeConicArcs/Q16CertificateLevels.lean");
  std::string text((std::istreambuf_iterator<char>(in)), {});
  auto begin = text.find("def level8");
  auto end = text.find("\n]\n\nend", begin);
  text = text.substr(begin, end - begin);
  std::regex item("\\{([0-9,]+)\\}");
  std::vector<std::array<int, 8>> arcs;
  for (std::sregex_iterator it(text.begin(), text.end(), item), stop; it != stop; ++it) {
    std::array<int, 8> a{};
    std::stringstream ss((*it)[1].str());
    std::string token;
    int i = 0;
    while (std::getline(ss, token, ',')) a[i++] = std::stoi(token);
    if (i == 8) arcs.push_back(a);
  }
  if (arcs.size() != 2633) throw std::runtime_error("level8 parse");

  long long tested = 0;
  long long small_uncovered_pairs = 0;
  int minimum_visible_holes = 1000;
  int minimum_leaf = -1;
  F minimum_form{};
  std::array<int, 8> minimum_arc{};
  std::vector<int> minimum_u;
  std::vector<int> minimum_off_holes;
  for (int leaf = 0; leaf < static_cast<int>(arcs.size()); ++leaf) {
    const auto &arc = arcs[leaf];
    std::array<bool, 273> covered{};
    for (int i = 0; i < 8; ++i) for (int j = i + 1; j < 8; ++j) {
      P l = cross(pts[arc[i]], pts[arc[j]]);
      int li = point_index[(l[0] << 8) | (l[1] << 4) | l[2]];
      for (int x : lines[li]) covered[x] = true;
    }
    std::vector<int> holes;
    for (int x = 0; x < 273; ++x) if (!covered[x]) holes.push_back(x);
    std::set<F> seen;
    int n = holes.size();
    for (int i0 = 0; i0 < n; ++i0)
    for (int i1 = i0 + 1; i1 < n; ++i1)
    for (int i2 = i1 + 1; i2 < n; ++i2)
    for (int i3 = i2 + 1; i3 < n; ++i3)
    for (int i4 = i3 + 1; i4 < n; ++i4) {
      auto [rank, form] = kernel5({mons[holes[i0]], mons[holes[i1]],
                                   mons[holes[i2]], mons[holes[i3]],
                                   mons[holes[i4]]});
      if (rank != 5 || !seen.insert(form).second) continue;
      ++tested;
      bool disjoint = true;
      for (int a : arc) disjoint &= eval(form, mons[a]) != 0;
      if (!disjoint) continue;
      int xy = form[3], xz = form[4], yz = form[5];
      P radical{};
      int radical_count = 0;
      for (const auto &p : pts)
        if (!(gm(xy, p[1]) ^ gm(xz, p[2])) &&
            !(gm(xy, p[0]) ^ gm(yz, p[2])) &&
            !(gm(xz, p[0]) ^ gm(yz, p[1]))) {
          radical = p;
          ++radical_count;
        }
      if (radical_count != 1 || !eval(form, mono(radical))) continue;

      std::array<bool, 273> conic{};
      for (int x = 0; x < 273; ++x) conic[x] = !eval(form, mons[x]);
      std::vector<int> u;
      bool all_holes = true;
      for (int h : holes) {
        if (conic[h]) u.push_back(h);
        else all_holes = false;
      }
      if (u.size() < 6) continue;
      ++small_uncovered_pairs;
      if (all_holes) {
        throw std::runtime_error("relative counterexample");
      }
      std::array<bool, 273> visible{};
      for (int base : u) for (int a : arc) {
        P l = cross(pts[base], pts[a]);
        int li = point_index[(l[0] << 8) | (l[1] << 4) | l[2]];
        for (int x : lines[li]) visible[x] = true;
      }
      bool good = true;
      int visible_holes = 0;
      std::vector<int> off_holes;
      for (int h : holes) if (!conic[h]) {
        off_holes.push_back(h);
        if (visible[h]) {
          good = false;
          ++visible_holes;
        }
      }
      if (visible_holes < minimum_visible_holes) {
        minimum_visible_holes = visible_holes;
        minimum_leaf = leaf;
        minimum_form = form;
        minimum_arc = arc;
        minimum_u = u;
        minimum_off_holes = off_holes;
      }
      if (!good) continue;
      throw std::runtime_error("multi-base survivor");
    }
    if (leaf % 100 == 0)
      std::cerr << "leaf=" << leaf << " tested=" << tested << "\n";
  }
  auto array_json = [](const auto &values) {
    std::ostringstream out;
    out << "[";
    bool first = true;
    for (int x : values) {
      if (!first) out << ", ";
      first = false;
      out << x;
    }
    out << "]";
    return out.str();
  };
  std::ostringstream json;
  json << "{\n"
       << "  \"boundary_only_arc_indices\": " << array_json(boundary_arc) << ",\n"
       << "  \"boundary_only_off_conic_holes\": "
       << array_json(boundary_off_holes) << ",\n"
       << "  \"boundary_only_profiles\": "
       << array_json(boundary_profile) << ",\n"
       << "  \"boundary_only_uncovered_conic_points\": "
       << array_json(boundary_u) << ",\n"
       << "  \"candidate_quadrics_tested\": " << tested << ",\n"
       << "  \"leaf_count\": " << arcs.size() << ",\n"
       << "  \"minimum_arc_indices\": " << array_json(minimum_arc) << ",\n"
       << "  \"minimum_form\": " << array_json(minimum_form) << ",\n"
       << "  \"minimum_leaf\": " << minimum_leaf << ",\n"
       << "  \"minimum_off_conic_holes\": "
       << array_json(minimum_off_holes) << ",\n"
       << "  \"minimum_uncovered_conic_points\": "
       << array_json(minimum_u) << ",\n"
       << "  \"minimum_visible_off_conic_holes\": "
       << minimum_visible_holes << ",\n"
       << "  \"multibase_survivors\": 0,\n"
       << "  \"schema\": \"c667-q16-multibase-involution-expansion-v1\",\n"
       << "  \"small_uncovered_candidate_pairs\": "
       << small_uncovered_pairs << "\n"
       << "}\n";
  if (write) {
    std::ofstream out(output);
    out << json.str();
    return 0;
  }
  std::ifstream expected_file(output);
  std::string expected((std::istreambuf_iterator<char>(expected_file)), {});
  if (expected != json.str()) throw std::runtime_error("certificate mismatch");
  std::cout << "PASS\n";
}
