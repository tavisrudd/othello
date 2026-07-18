"""Probe: does the C294 bronze family extend to p = 7, 23 (mod 40)?

Reuses the committed C294 checker's own check_parameter (all load-bearing
asserts: six-arc determinants, tau conjugation swap, fixed-point-freeness,
nonadjacency, dead-set invariance, unipotent word) on primes the theorem
excludes, and adds an independent direct Grundy recursion for small p.
"""
import importlib.util
import sys
from functools import lru_cache

spec = importlib.util.spec_from_file_location(
    "crown", "notes/2026-07-17-c294-full-conic-continuation-crown.py")
crown = importlib.util.module_from_spec(spec)
spec.loader.exec_module(crown)


def admissible(p):
    return [b for b in range(p)
            if b not in (0, 1, 2, p - 1)
            and crown.legendre((b - 1) ** 2 + 4, p) == -1]


def residual_graph(p, b):
    centre_pairs = crown.centres_for(b)
    centres = tuple((r % p, c % p, 1) for r, c in centre_pairs)
    gens = [crown.sigma_matrix(r, c, p) for r, c in centre_pairs]
    dead = set()
    from itertools import combinations
    for u, v in combinations(centres, 2):
        for t in range(p + 1):
            if crown.det3((u, v, crown.conic_point(t, p)), p) == 0:
                dead.add(t)
    live = sorted(set(range(p + 1)) - dead)
    idx = {t: i for i, t in enumerate(live)}
    adj = [0] * len(live)
    for t in live:
        for g in gens:
            u = crown.act(g, t, p)
            if u != t and u in idx:
                adj[idx[t]] |= 1 << idx[u]
    return live, adj


def grundy(adj):
    n = len(adj)
    full = (1 << n) - 1

    @lru_cache(maxsize=None)
    def g(mask):
        seen = set()
        m = mask
        while m:
            v = (m & -m).bit_length() - 1
            m &= m - 1
            seen.add(g(mask & ~((adj[v] & mask) | (1 << v))))
        x = 0
        while x in seen:
            x += 1
        return x

    return g(full)


for p in (7, 23, 47, 103):
    assert crown.is_prime(p) and p % 40 in (7, 23)
    assert [crown.legendre(x, p) for x in (-1, 5)] == [-1, -1]
    assert crown.legendre(8, p) == 1  # 2 is a square: p = 7 (mod 8)
    params = admissible(p)
    assert len(params) == (p - 3) // 2, (p, len(params))
    for b in params:
        row = crown.check_parameter(p, b, enumerate_group=(b == params[0]))
        if b == params[0]:
            assert row["generated_group_order"] == row["pgl2_order"]
    print(f"p={p:3d} ({p%40} mod 40): {len(params)} = (p-3)/2 admissible; "
          f"all check_parameter asserts pass; "
          f"group order {p*(p*p-1)} verified for b={params[0]}")

# independent value cross-check: direct Grundy at the smallest primes
for p, count in ((7, None), (23, None)):
    for b in admissible(p):
        live, adj = residual_graph(p, b)
        val = grundy(adj)
        assert val == 0, (p, b, val)
    print(f"p={p:3d}: direct Grundy recursion gives value 0 for every admissible b "
          f"(residual sizes {sorted({len(residual_graph(p, bb)[0]) for bb in admissible(p)})})")

print("ALL CHECKS PASSED")
