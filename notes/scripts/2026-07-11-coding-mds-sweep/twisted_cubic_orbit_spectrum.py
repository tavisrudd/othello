#!/usr/bin/env python3
"""Twisted-cubic external-orbit transversal (tau) spectrum -- completion-core sec 6.5.

For C_3(q) subset PG(3,q), rho(x) = tau{ B in C(C_3(q),3) : x in <B> } is the
minimum number of cubic points whose deletion destroys every 3-point plane
representation of the external point x (the MDS-lengthening deletion number of
the [q+1,4] NRC).  This script classifies (N, nu, rho) by PGL(2,q) orbit, where
PGL(2,q) is the twisted cubic's stabiliser acting through the symmetric-cube
(degree-3 Veronese) representation, and cross-checks orbit sizes against
Bartoli-Davydov-Marcugini-Pambianco (arXiv:1909.00207, Thm 2.2(B)(ii)).

Prime fields only; intended q = 5, 7, 11 (all q != 0 mod 3).  Reuses the exact
(nu, tau) machinery of twisted_cubic_gate.py.
"""

from __future__ import annotations

import argparse
import functools
import itertools
from collections import defaultdict


# ---- exact plane / invariant machinery (shared with twisted_cubic_gate.py) ----

def det3(a, p):
    return (
        a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
        - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
        + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
    ) % p


def plane_normal(rows, p):
    h = []
    for j in range(4):
        minor = [[row[k] for k in range(4) if k != j] for row in rows]
        v = det3(minor, p)
        if j & 1:
            v = -v
        h.append(v % p)
    assert any(h)
    assert all(sum(a * b for a, b in zip(row, h)) % p == 0 for row in rows)
    return tuple(h)


def pg3_points(p):
    for first in range(4):
        for tail in itertools.product(range(p), repeat=3 - first):
            yield (0,) * first + (1,) + tail


def popcount(x):
    return x.bit_count()


def invariants(edge_vertex_masks, edge_bits, triples_in_subset, n):
    alpha = 0
    for mask in range(1 << n):
        if popcount(mask) <= alpha:
            continue
        if edge_bits & triples_in_subset[mask] == 0:
            alpha = popcount(mask)

    by_vertex = [[] for _ in range(n)]
    for e in edge_vertex_masks:
        for v in range(n):
            if e >> v & 1:
                by_vertex[v].append(e)

    @functools.lru_cache(None)
    def matching(avail):
        if popcount(avail) < 3:
            return 0
        vbit = avail & -avail
        v = vbit.bit_length() - 1
        best = matching(avail ^ vbit)
        for e in by_vertex[v]:
            if e & avail == e:
                best = max(best, 1 + matching(avail ^ e))
        return best

    return matching((1 << n) - 1), n - alpha


# ---- PGL(2,q) symmetric-cube action on PG(3,q) --------------------------------

def linpow(a, b, e, p):
    """(a*s + b*u)^e as coeffs [c_0..c_e] with c_i on s^(e-i) u^i."""
    out = [0] * (e + 1)
    binom = 1
    for i in range(e + 1):
        out[i] = binom * pow(a, e - i, p) % p * pow(b, i, p) % p
        binom = binom * (e - i) // (i + 1)
    return [c % p for c in out]


def conv(f, g, p):
    out = [0] * (len(f) + len(g) - 1)
    for i, a in enumerate(f):
        for j, b in enumerate(g):
            out[i + j] = (out[i + j] + a * b) % p
    return out


def sym3_matrix(a, b, c, d, p):
    """Sym^3 of [[a,b],[c,d]] preserving the RNC [s^3 : s^2 u : s u^2 : u^3].

    With s' = a s + b u, u' = c s + d u, the image curve point has coordinate i
    equal to (s')^(3-i) (u')^i, a cubic in (s,u); row i is its expansion on the
    input basis (s^3, s^2 u, s u^2, u^3).  So M[i][k] = coeff of s^(3-k) u^k in
    (a s + b u)^(3-i) (c s + d u)^i.
    """
    return [conv(linpow(a, b, 3 - i, p), linpow(c, d, i, p), p) for i in range(4)]


def apply_mat(M, x, p):
    return tuple(sum(M[i][j] * x[j] for j in range(4)) % p for i in range(4))


def normalize(x, p):
    for i in range(4):
        if x[i]:
            inv = pow(x[i], p - 2, p)
            return tuple(c * inv % p for c in x)
    raise ValueError("zero vector")


def primitive_root(p):
    for g in range(2, p):
        seen, y = set(), 1
        for _ in range(p - 1):
            y = y * g % p
            seen.add(y)
        if len(seen) == p - 1:
            return g
    raise ValueError("no primitive root")


def pgl_generators(p):
    g = primitive_root(p)
    gens = [
        (1, 1, 0, 1),          # translation t -> t+1
        (0, 1, 1, 0),          # inversion   t -> 1/t
        (g, 0, 0, 1),          # scaling      t -> g t  (det = primitive root)
    ]
    return [sym3_matrix(*mat, p) for mat in gens]


# ---- driver -------------------------------------------------------------------

def bdmp_sizes(p):
    q = p
    return {
        "M2 {tangent T-points}": q * (q + 1),
        "M3 {3Gamma-points}": q * (q * q - 1) // 6,
        "M4 {1Gamma-points}": q * (q * q - 1) // 2,
        "M5 {0Gamma-points}": q * (q * q - 1) // 3,
    }


def bdmp_label(size, p):
    # A size can match >1 BDMP orbit formula (e.g. M2=M3 at q=7); report all.
    hits = [name for name, s in bdmp_sizes(p).items() if s == size]
    if not hits:
        return "UNMATCHED"
    return "|".join(h.split()[0] for h in hits) + (
        " " + hits[0].split(maxsplit=1)[1] if len(hits) == 1 else " (size-degenerate)"
    )


def run(p):
    assert p % 3 != 0, "this classification is for q != 0 mod 3"
    curve = [(1, t, t * t % p, t * t * t % p) for t in range(p)]
    curve.append((0, 0, 0, 1))
    curve_set = set(curve)
    n = p + 1

    # Verify the symmetric-cube action stabilises the cubic.
    gens = pgl_generators(p)
    for M in gens:
        for c in curve:
            assert normalize(apply_mat(M, c, p), p) in curve_set

    triple_indices = list(itertools.combinations(range(n), 3))
    triple_masks = [sum(1 << i for i in tri) for tri in triple_indices]
    normals = [plane_normal([curve[i] for i in tri], p) for tri in triple_indices]

    triples_in_subset = [0] * (1 << n)
    for mask in range(1 << n):
        bits = 0
        for j, em in enumerate(triple_masks):
            if em & mask == em:
                bits |= 1 << j
        triples_in_subset[mask] = bits

    def inv_tuple(x):
        edge_ids = [j for j, h in enumerate(normals)
                    if sum(a * b for a, b in zip(h, x)) % p == 0]
        edge_bits = sum(1 << j for j in edge_ids)
        edges = [triple_masks[j] for j in edge_ids]
        nu, tau = invariants(edges, edge_bits, triples_in_subset, n)
        return (len(edges), nu, tau)

    # Orbit partition of external points under the symmetric-cube PGL(2,q).
    externals = [x for x in pg3_points(p) if x not in curve_set]
    assert len(externals) == p**3 + p**2
    remaining = set(externals)
    orbits = []
    while remaining:
        start = next(iter(remaining))
        orbit, frontier = {start}, [start]
        while frontier:
            y = frontier.pop()
            for M in gens:
                z = normalize(apply_mat(M, y, p), p)
                if z not in orbit:
                    orbit.add(z)
                    frontier.append(z)
        orbits.append(orbit)
        remaining -= orbit

    print(f"q={p} external={len(externals)} orbits={len(orbits)}")
    rows = []
    for orbit in orbits:
        rep = min(orbit)
        tup = inv_tuple(rep)
        # invariants must be constant on a PGL orbit
        assert all(inv_tuple(x) == tup for x in orbit), "invariant not orbit-constant"
        rows.append((len(orbit), tup, rep))

    rows.sort()
    tau_values = set()
    for size, (N, nu, tau), rep in rows:
        tau_values.add(tau)
        print(f"  {bdmp_label(size, p):24s} size={size:5d} "
              f"N={N:3d} nu={nu} rho(tau)={tau}  rep={rep}")
    # cell = orbit check: number of distinct (N,nu,tau) cells equals orbit count
    cells = {tup for _, tup, _ in rows}
    print(f"  distinct (N,nu,rho) cells={len(cells)} orbits={len(orbits)} "
          f"cell_equals_orbit={len(cells) == len(orbits)}")
    print(f"  rho spectrum over external orbits = {sorted(tau_values)}")
    got = sorted(size for size, _, _ in rows)
    want = sorted(bdmp_sizes(p).values())
    assert got == want, f"orbit-size multiset {got} != BDMP {want}"
    print("  ALL_ORBIT_SIZES_MATCH_BDMP=True")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("q", nargs="+", type=int)
    args = ap.parse_args()
    for p in args.q:
        run(p)


if __name__ == "__main__":
    main()
