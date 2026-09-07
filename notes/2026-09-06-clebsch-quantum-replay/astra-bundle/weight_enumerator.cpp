#include <algorithm>
#include <array>
#include <cstdint>
#include <iostream>
#include <vector>

using Integer = std::int64_t;

Integer choose(int n, int k) {
    if (k < 0 || k > n) return 0;
    Integer r = 1;
    for (int j = 1; j <= k; ++j) r = r * (n-j+1) / j;
    return r;
}

int main() {
    int p, k, n;
    if (!(std::cin >> p >> k >> n) || (p != 7 && p != 11) || k != p || n != 2*p) return 1;
    std::vector<std::vector<int>> g(k, std::vector<int>(n));
    for (auto &row : g) for (int &x : row) {
        if (!(std::cin >> x) || x < 0 || x >= p) return 1;
    }
    std::array<int, 11> inverse{};
    for (int a = 1; a < p; ++a) for (int b = 1; b < p; ++b) if (a*b % p == 1) inverse[a] = b;
    std::vector<std::vector<Integer>> ranks(n+1, std::vector<Integer>(k+1));
    std::array<int, 22> columns{};
    for (std::uint32_t mask = 0; mask < (1u << n); ++mask) {
        int weight = __builtin_popcount(mask);
        if (weight > k || (weight == k && !(mask & 1u))) continue;
        int c = 0;
        for (int j = 0; j < n; ++j) if (mask & (1u << j)) columns[c++] = j;
        int a[11][11]{};
        for (int i = 0; i < k; ++i) for (int j = 0; j < weight; ++j) a[i][j] = g[i][columns[j]];
        int rank = 0;
        for (int j = 0; j < weight; ++j) {
            int pivot = rank;
            while (pivot < k && a[pivot][j] == 0) ++pivot;
            if (pivot == k) continue;
            for (int h = j; h < weight; ++h) std::swap(a[rank][h], a[pivot][h]);
            int inv = inverse[a[rank][j]];
            for (int h = j; h < weight; ++h) a[rank][h] = a[rank][h] * inv % p;
            for (int i = rank+1; i < k; ++i) {
                int scale = a[i][j];
                if (!scale) continue;
                for (int h = j+1; h < weight; ++h) a[i][h] = (a[i][h] - scale*a[rank][h] + p*p) % p;
                a[i][j] = 0;
            }
            ++rank;
        }
        ranks[weight][rank]++;
        ranks[n-weight][n-weight+rank-k]++;
    }
    std::vector<Integer> powers(k+1, 1), counts(n+1), supported(n+1);
    for (int i = 1; i <= k; ++i) powers[i] = powers[i-1]*p;
    for (int w = 0; w <= n; ++w) {
        for (int r = 0; r <= k; ++r) if (ranks[w][r]) supported[w] += ranks[w][r]*powers[w-r];
        counts[w] = supported[w];
        for (int j = 0; j < w; ++j) counts[w] -= choose(n-j,w-j)*counts[j];
    }
    Integer total = 0;
    for (int w = 0; w <= n; ++w) {
        total += counts[w];
        std::cout << w << " " << counts[w] << " ";
        for (int r = 0; r <= k; ++r) if (ranks[w][r]) std::cout << r << ":" << ranks[w][r] << ",";
        std::cout << "\n";
    }
    std::cerr << "Total codewords: " << total << "; expected " << powers[k] << "\n";
    return total == powers[k] ? 0 : 2;
}
