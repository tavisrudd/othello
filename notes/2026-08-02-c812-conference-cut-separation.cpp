#include <algorithm>
#include <array>
#include <bit>
#include <cstdint>
#include <fstream>
#include <iostream>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>

using Mask = std::uint32_t;
using Count = std::int64_t;

static const std::array<const char *, 15> GRAPH6 = {
R"(X}rM\QTeLEuUlQY[I\IgtWfTxCrhEOZo{FfwEew`LXMbWp}JDtM)",
R"(X}rM\QWh[jUYkiYYJMBDfSrXsLRgdOMusE{{JQhgxiMDSxVEplU)",
R"(X}rM\Qhd[fU`kdUSjDjHjWqxtOJdOgMxwEzYFRPgtdMDctfIpsu)",
R"(X}rUTEdmTpQxbkSxHkZceZBLtObTQHHmsbM{EFxwrroAtQtBtBr)",
R"(X}rUTEdmTpQybiSwhkjgeYbLrHBX`HI\wavYEFxwrroAt`tBsdr)",
R"(X}rUTIbmLqQybiTWh[jcXZCtqpBYPHE]wcuyEFxwrroAtQtBtBr)",
R"(X}rU\adeSetTjKWNJEYNR]PLjPBgUGVTkK^YKbipMcxbk`{DlXF)",
R"(X}r^SQbkLJQjesS[jLJQhPxTcZZcZ?S|krEYBlQolTZDhWuNKKN)",
R"(X}r^SQbkLQqjdwS[jLJJHQtTcZZcZ?L\krEYBlQostZDhWuNKKN)",
R"(X}vEKeLlTTUXjKXXK[ZKo]EXZAqxI``\khVUD]VOVptAqtXBbrL)",
R"(X}vEKiJklYUXjKXWk[jKo]EXYdQyD`amkgmuD]VGVpuAqtUBbrR)",
R"(X}vEKiJlTTUUjQWxKkZKo]EXZBQxH`a]kguuC}NGZquAptYBdrJ)",
R"(X}ve[IJd\FUImBSYmFJRIWfLLRYmJ?Tl[ZKYHhsokuXdhS{NKKN)",
R"(X~rM[Edd\RRBkpOxlMIqZXDxTWZdQGX][fI[EsholidDRdVNGk])",
R"(X~rM[Ihi[eQVlQPTkTiqrWwxXgZgiGX^KfWqEdu?nG\dRP}NGk])",
};

Count choose(int n, int k) {
    if (k < 0 || k > n) return 0;
    if (k > n - k) k = n - k;
    Count answer = 1;
    for (int i = 1; i <= k; ++i) answer = answer * (n - k + i) / i;
    return answer;
}

std::array<Mask, 25> decode_graph6(const std::string &line) {
    if (line.size() != 51 || static_cast<unsigned char>(line[0]) != 25 + 63)
        throw std::runtime_error("unexpected graph6 record");
    std::vector<int> bits;
    for (std::size_t p = 1; p < line.size(); ++p) {
        int value = static_cast<unsigned char>(line[p]) - 63;
        if (value < 0 || value > 63) throw std::runtime_error("bad graph6 byte");
        for (int shift = 5; shift >= 0; --shift) bits.push_back((value >> shift) & 1);
    }
    std::array<Mask, 25> adjacency{};
    std::size_t p = 0;
    for (int j = 1; j < 25; ++j)
        for (int i = 0; i < j; ++i)
            if (bits[p++]) {
                adjacency[i] |= Mask(1) << j;
                adjacency[j] |= Mask(1) << i;
            }
    return adjacency;
}

void check_srg(const std::array<Mask, 25> &adjacency) {
    for (int i = 0; i < 25; ++i) {
        if (std::popcount(adjacency[i]) != 12) throw std::runtime_error("not degree 12");
        for (int j = i + 1; j < 25; ++j) {
            int common = std::popcount(adjacency[i] & adjacency[j]);
            bool edge = (adjacency[i] >> j) & 1U;
            if (common != (edge ? 5 : 6)) throw std::runtime_error("not SRG(25,12,5,6)");
        }
    }
}

int triangle(const std::array<Mask, 25> &adjacency, int a, int b, int c) {
    auto edge = [&](int x, int y) {
        if (x == 25 || y == 25) return 0;
        return int((adjacency[x] >> y) & 1U);
    };
    return edge(a, b) ^ edge(a, c) ^ edge(b, c);
}

std::vector<Mask> aligned_blocks(const std::array<Mask, 25> &adjacency) {
    std::vector<Mask> blocks;
    for (int a = 0; a < 23; ++a)
        for (int b = a + 1; b < 24; ++b)
            for (int c = b + 1; c < 25; ++c)
                for (int d = c + 1; d < 26; ++d) {
                    int t = triangle(adjacency, a, b, c);
                    if (triangle(adjacency, a, b, d) == t &&
                        triangle(adjacency, a, c, d) == t &&
                        triangle(adjacency, b, c, d) == t)
                        blocks.push_back((Mask(1) << a) | (Mask(1) << b) |
                                         (Mask(1) << c) | (Mask(1) << d));
                }
    if (blocks.size() != 3250) throw std::runtime_error("aligned block count is not 3250");
    std::map<Mask, int> triple_degrees;
    for (Mask block : blocks) {
        std::array<int, 4> vertices{};
        int p = 0;
        for (int v = 0; v < 26; ++v)
            if ((block >> v) & 1U) vertices[p++] = v;
        for (int omitted = 0; omitted < 4; ++omitted) {
            Mask triple = block & ~(Mask(1) << vertices[omitted]);
            ++triple_degrees[triple];
        }
    }
    if (triple_degrees.size() != 2600) throw std::runtime_error("missing triples");
    for (auto [triple, degree] : triple_degrees)
        if (degree != 5) throw std::runtime_error("not a 3-(26,4,5) design");
    return blocks;
}

void add_supersets(Mask block, const std::array<int, 22> &outside,
                   std::vector<std::uint16_t> &contained) {
    ++contained[block];
    for (int a = 0; a < 22; ++a) {
        Mask ma = block | (Mask(1) << outside[a]);
        ++contained[ma];
        for (int b = a + 1; b < 22; ++b) {
            Mask mb = ma | (Mask(1) << outside[b]);
            ++contained[mb];
            for (int c = b + 1; c < 22; ++c) {
                Mask mc = mb | (Mask(1) << outside[c]);
                ++contained[mc];
                for (int d = c + 1; d < 22; ++d)
                    ++contained[mc | (Mask(1) << outside[d])];
            }
        }
    }
}

struct Record {
    std::map<int, Count> pair_profile;
    std::map<int, Count> triple_profile;
};

Record profiles(const std::vector<Mask> &blocks) {
    std::vector<std::uint16_t> contained(std::size_t(1) << 26, 0);
    for (Mask block : blocks) {
        std::array<int, 22> outside{};
        int p = 0;
        for (int v = 0; v < 26; ++v)
            if (((block >> v) & 1U) == 0) outside[p++] = v;
        add_supersets(block, outside, contained);
    }

    Record record;
    std::map<int, Count> pair_with_third;
    constexpr Count block_count = 3250;
    constexpr Count lambda1 = 500;
    constexpr Count lambda2 = 60;
    constexpr Count lambda3 = 5;
    for (std::size_t i = 0; i < blocks.size(); ++i)
        for (std::size_t j = i + 1; j < blocks.size(); ++j) {
            Mask united = blocks[i] | blocks[j];
            int u = std::popcount(united);
            ++record.pair_profile[u];
            std::array<Count, 5> n{};
            n[4] = contained[united];
            n[3] = lambda3 * choose(u, 3) - 4 * n[4];
            n[2] = lambda2 * choose(u, 2) - 3 * n[3] - 6 * n[4];
            n[1] = lambda1 * u - 2 * n[2] - 3 * n[3] - 4 * n[4];
            n[0] = block_count - n[1] - n[2] - n[3] - n[4];
            for (int intersection = 0; intersection <= 4; ++intersection) {
                if (n[intersection] < 0) throw std::runtime_error("negative intersection count");
                pair_with_third[u + 4 - intersection] += n[intersection];
            }
            pair_with_third[u] -= 2;
        }
    for (auto [u, count] : pair_with_third) {
        if (count % 3 != 0) throw std::runtime_error("triple profile not divisible by three");
        record.triple_profile[u] = count / 3;
    }
    Count total = 0;
    for (auto [u, count] : record.triple_profile) total += count;
    if (total != choose(3250, 3)) throw std::runtime_error("triple profile mass mismatch");
    return record;
}

void print_map(std::ostream &out, const std::map<int, Count> &values) {
    out << "{";
    bool first = true;
    for (auto [key, value] : values) {
        if (!first) out << ",";
        first = false;
        out << "\"" << key << "\":" << value;
    }
    out << "}";
}

void print_json_string(std::ostream &out, const std::string &value) {
    out << '"';
    for (char c : value) {
        if (c == '\\' || c == '"') out << '\\';
        out << c;
    }
    out << '"';
}

int main(int argc, char **argv) {
    if (argc != 3 || std::string(argv[1]) != "--output") {
        std::cerr << "usage: " << argv[0] << " --output FILE\n";
        return 2;
    }
    std::ofstream out(argv[2]);
    if (!out) throw std::runtime_error("cannot open output");
    out << "{\n  \"schema\":\"c812-conference-cut-separation-v1\",\n";
    out << "  \"source\":{\"url\":\"https://users.cecs.anu.edu.au/~bdm/data/sr251256.g6\",";
    out << "\"sha256\":\"f55f86eb48cd61c3315c62341cc3a8c59289c58504edb3ab859d7ef2068b9aa4\",";
    out << "\"records\":15},\n  \"graphs\":[\n";
    for (std::size_t index = 0; index < GRAPH6.size(); ++index) {
        auto adjacency = decode_graph6(GRAPH6[index]);
        check_srg(adjacency);
        auto blocks = aligned_blocks(adjacency);
        auto record = profiles(blocks);
        if (index) out << ",\n";
        out << "    {\"index\":" << index + 1 << ",\"graph6\":";
        print_json_string(out, GRAPH6[index]);
        out << ",\"aligned_blocks\":" << blocks.size() << ",\"pair_profile\":";
        print_map(out, record.pair_profile);
        out << ",\"triple_profile\":";
        print_map(out, record.triple_profile);
        out << "}";
        std::cerr << "finished graph " << index + 1 << "\n";
    }
    out << "\n  ]\n}\n";
}
