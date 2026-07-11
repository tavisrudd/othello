#!/usr/bin/env python3
"""Exact GF(9) gate for the Sym^3(PGL(2,9))-orbit augmentation seed."""

from collections import Counter, defaultdict
from functools import lru_cache
from hashlib import sha256
from itertools import combinations, product

# GF(9) = GF(3)[w]/(w^2+1), encoded a+3b*w; hence w^2=2.
Q = 9


def add(x, y):
    return ((x % 3 + y % 3) % 3) + 3 * (((x // 3 + y // 3) % 3))


def neg(x):
    return ((-x % 3) % 3) + 3 * ((-(x // 3) % 3) % 3)


def sub(x, y):
    return add(x, neg(y))


def mul(x, y):
    a, b = x % 3, x // 3
    c, d = y % 3, y // 3
    return ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)


def powq(x, n):
    z = 1
    while n:
        if n & 1:
            z = mul(z, x)
        x = mul(x, x)
        n >>= 1
    return z


def inv(x):
    assert x
    return powq(x, 7)


def scale(v, a):
    return tuple(mul(a, x) for x in v)


def normalize(v):
    for x in v:
        if x:
            return scale(v, inv(x))
    raise ValueError("zero projective vector")


def rank(cols):
    if not cols:
        return 0
    a = [list(row) for row in zip(*cols)]
    nr, nc, r = len(a), len(a[0]), 0
    for c in range(nc):
        p = next((i for i in range(r, nr) if a[i][c]), None)
        if p is None:
            continue
        a[r], a[p] = a[p], a[r]
        z = inv(a[r][c])
        a[r] = [mul(z, t) for t in a[r]]
        for i in range(nr):
            if i != r and a[i][c]:
                z = a[i][c]
                a[i] = [sub(a[i][j], mul(z, a[r][j])) for j in range(nc)]
        r += 1
        if r == nr:
            break
    return r


def mat_vec(m, v):
    return tuple(sum_gf(mul(m[i][j], v[j]) for j in range(4)) for i in range(4))


def sum_gf(xs):
    z = 0
    for x in xs:
        z = add(z, x)
    return z


def sym3(a, b, c, d):
    two = 2
    return (
        (powq(a, 3), 0, 0, powq(b, 3)),
        (mul(mul(a, a), c),
         add(mul(mul(a, a), d), mul(two, mul(mul(a, b), c))),
         add(mul(two, mul(mul(a, b), d)), mul(mul(b, b), c)),
         mul(mul(b, b), d)),
        (mul(a, mul(c, c)),
         add(mul(two, mul(mul(a, c), d)), mul(b, mul(c, c))),
         add(mul(a, mul(d, d)), mul(two, mul(mul(b, c), d))),
         mul(b, mul(d, d))),
        (powq(c, 3), 0, 0, powq(d, 3)),
    )


def pgl2():
    seen = set()
    for a, b, c, d in product(range(Q), repeat=4):
        if sub(mul(a, d), mul(b, c)) == 0:
            continue
        g = normalize((a, b, c, d))
        seen.add(g)
    return sorted(seen)


def min_repair_edges(cols, target):
    others = [i for i in range(len(cols)) if i != target]
    found = []
    for s in range(1, 4):
        for rr in combinations(others, s):
            if any(set(e).issubset(rr) for e in found):
                continue
            base = [cols[i] for i in rr]
            if rank(base) == rank(base + [cols[target]]):
                found.append(tuple(rr))
    return found


def invariants(edges, target, n):
    verts = [i for i in range(n) if i != target]
    loc = {v: j for j, v in enumerate(verts)}
    em = []
    for e in edges:
        mask = 0
        for v in e:
            mask |= 1 << loc[v]
        em.append(mask)
    by_v = [[] for _ in verts]
    for e in em:
        for j in range(len(verts)):
            if e >> j & 1:
                by_v[j].append(e)

    @lru_cache(None)
    def pack(avail):
        if not avail:
            return 0
        j = (avail & -avail).bit_length() - 1
        best = pack(avail & ~(1 << j))
        for e in by_v[j]:
            if e & avail == e:
                best = max(best, 1 + pack(avail ^ e))
        return best

    nu = pack((1 << len(verts)) - 1)

    bad = bytearray(1 << len(verts))
    for e in em:
        bad[e] = 1
    for j in range(len(verts)):
        bit = 1 << j
        for mask in range(1 << len(verts)):
            if mask & bit and bad[mask ^ bit]:
                bad[mask] = 1
    alpha = max(mask.bit_count() for mask, is_bad in enumerate(bad) if not is_bad)
    tau = len(verts) - alpha
    return nu, tau


def main():
    gs = pgl2()
    x = (0, 0, 1, 0)
    orbit = sorted({normalize(mat_vec(sym3(*g), x)) for g in gs})
    curve = [normalize((1, t, mul(t, t), powq(t, 3))) for t in range(Q)]
    curve_set, orbit_set = set(curve), set(orbit)
    cols = curve + [v for v in orbit if v not in curve_set]
    kinds = ["curve"] * len(curve) + ["orbit"] * (len(cols) - len(curve))

    # Minimum distance by enumerating projective nonzero linear functionals.
    forms = set()
    for v in product(range(Q), repeat=4):
        if any(v):
            forms.add(normalize(v))
    max_zeros = 0
    weight_dist = Counter()
    for f in forms:
        zeros = sum(sum_gf(mul(f[j], c[j]) for j in range(4)) == 0 for c in cols)
        max_zeros = max(max_zeros, zeros)
        weight_dist[len(cols) - zeros] += 1

    print(f"GF9_model=w^2+1 PGL={len(gs)} orbit_raw={len(gs)} orbit_dedup={len(orbit)}")
    print(f"curve_finite={len(curve)} curve_orbit_overlap={len(curve_set & orbit_set)} n={len(cols)} rank={rank(cols)} d={len(cols)-max_zeros}")
    print("orbit_columns=" + repr(orbit))
    print("projective_codeword_weights=" + repr(sorted(weight_dist.items())))

    summaries = defaultdict(list)
    circuits = set()
    for i in range(len(cols)):
        edges = min_repair_edges(cols, i)
        circuits.update(frozenset((i,) + e) for e in edges)
        nu, tau = invariants(edges, i, len(cols))
        sizes = tuple(sorted(Counter(map(len, edges)).items()))
        key = (kinds[i], sizes, nu, tau)
        summaries[key].append(i)
    robust = 0
    for (kind, sizes, nu, tau), ids in sorted(summaries.items()):
        print(f"type={kind} count={len(ids)} ids={ids} minimal_repairs={sizes} nu={nu} tau={tau} ratio={tau}/{nu}")
        if tau > nu:
            robust += len(ids)
    print("minimal_circuits=" + repr(sorted(Counter(map(len, circuits)).items())))
    local_all = all(min_repair_edges(cols, i) for i in range(len(cols)))
    print(f"all_symbol_locality_le3={local_all} robust={robust}/{len(cols)} robust_fraction={robust/len(cols):.12f}")
    success = local_all and len(cols)-max_zeros > 0 and 10*robust > len(cols)
    print(f"FROZEN_SUCCESS={success}")


if __name__ == "__main__":
    main()
