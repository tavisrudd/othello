import sys
from common import data, eps, gmat, rank_mod

for p in (7, 11):
    n, k = 2 * p, p - 1
    E, _, _ = data(p)
    G = gmat(p)
    ep = eps(p)
    print(f"--- p={p} n={n} k={k}")
    print("  shape E:", len(E), "x", len(E[0]))
    print("  rank G =", rank_mod(G, p), "(claim", p, ")")
    # G D G^T
    gdg = [[sum(G[a][i] * ep[i] * G[b][i] for i in range(n)) % p
            for b in range(p)] for a in range(p)]
    print("  G D G^T == 0:", all(all(x == 0 for x in row) for row in gdg))
    # rows of E distinct
    rows = [tuple(r) for r in E]
    print("  rows of E distinct:", len(set(rows)) == n,
          "distinct =", len(set(rows)))
    # L^{o2}
    prods = []
    for a in range(p):
        for b in range(a, p):
            prods.append([(G[a][i] * G[b][i]) % p for i in range(n)])
    d = rank_mod(prods, p)
    print("  dim L^o2 =", d, "(claim", 2 * p - 1, ")")
    ok = all(sum(ep[i] * v[i] for i in range(n)) % p == 0 for v in prods)
    print("  L^o2 subset eps^perp:", ok, "-> equality:", ok and d == n - 1)
