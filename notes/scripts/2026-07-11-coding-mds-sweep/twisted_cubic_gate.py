#!/usr/bin/env python3
"""Exact small-q gate for twisted-cubic representation hypergraphs.

For every x off C_3(q), B_x consists of triples of curve points whose plane
contains x.  Report edge count N, matching number nu, and transversal number
tau, grouped by N.  Prime fields only; intended q=5,7,11.
"""

from __future__ import annotations

import argparse
import functools
import itertools
from collections import defaultdict


def det3(a, p):
    return (
        a[0][0] * (a[1][1] * a[2][2] - a[1][2] * a[2][1])
        - a[0][1] * (a[1][0] * a[2][2] - a[1][2] * a[2][0])
        + a[0][2] * (a[1][0] * a[2][1] - a[1][1] * a[2][0])
    ) % p


def plane_normal(rows, p):
    # Cofactor vector: sum_j rows[i][j] h[j] = 0 for every input row i.
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
    # Unique normalization: first nonzero homogeneous coordinate is 1.
    for first in range(4):
        for tail in itertools.product(range(p), repeat=3 - first):
            yield (0,) * first + (1,) + tail


def popcount(x):
    return x.bit_count()


def invariants(edge_vertex_masks, edge_bits, triples_in_subset, n):
    # alpha = largest edge-free vertex subset, tau = n-alpha.
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
        best = matching(avail ^ vbit)  # v unmatched
        for e in by_vertex[v]:
            if e & avail == e:
                best = max(best, 1 + matching(avail ^ e))
        return best

    return matching((1 << n) - 1), n - alpha


def run(p):
    curve = [(1, t, t * t % p, t * t * t % p) for t in range(p)]
    curve.append((0, 0, 0, 1))  # infinity
    curve_set = set(curve)
    n = p + 1

    triple_indices = list(itertools.combinations(range(n), 3))
    triple_masks = [sum(1 << i for i in tri) for tri in triple_indices]
    normals = [plane_normal([curve[i] for i in tri], p) for tri in triple_indices]

    # Bit j says triple j is contained in this vertex subset.
    triples_in_subset = [0] * (1 << n)
    for mask in range(1 << n):
        bits = 0
        for j, em in enumerate(triple_masks):
            if em & mask == em:
                bits |= 1 << j
        triples_in_subset[mask] = bits

    groups = defaultdict(lambda: defaultdict(list))
    total_N = 0
    external_count = 0
    e2_record = None
    for x in pg3_points(p):
        if x in curve_set:
            continue
        external_count += 1
        edge_ids = [j for j, h in enumerate(normals)
                    if sum(a * b for a, b in zip(h, x)) % p == 0]
        edge_bits = sum(1 << j for j in edge_ids)
        edges = [triple_masks[j] for j in edge_ids]
        nu, tau = invariants(edges, edge_bits, triples_in_subset, n)
        N = len(edges)
        total_N += N
        groups[N][(nu, tau)].append(x)
        if x == (0, 0, 1, 0):
            e2_record = (N, nu, tau, edge_ids)

    expected_points = p**3 + p**2 + p + 1 - (p + 1)
    expected_inc = len(triple_indices) * (p * p + p - 2)
    assert external_count == expected_points
    assert total_N == expected_inc

    print(f"q={p} curve={n} external={external_count} triples={len(triple_indices)}")
    print(f"incidence_sum={total_N} expected={expected_inc} OK")
    mixed = []
    for N in sorted(groups):
        cells = groups[N]
        desc = ", ".join(
            f"(nu={nu},tau={tau}):{len(xs)}"
            for (nu, tau), xs in sorted(cells.items())
        )
        print(f"N={N}: {desc}")
        taus = {tau for (_, tau) in cells}
        if len(taus) > 1:
            examples = []
            for key, xs in sorted(cells.items()):
                examples.append((key, xs[0]))
            mixed.append((N, examples))
    if mixed:
        print("EQUAL_N_DIFFERENT_TAU=YES")
        for N, examples in mixed:
            print(f"  witness N={N}: {examples}")
    else:
        print("EQUAL_N_DIFFERENT_TAU=NO")

    assert e2_record is not None
    N, nu, tau, edge_ids = e2_record
    finite_zero_sum = [
        j for j, tri in enumerate(triple_indices)
        if n - 1 not in tri and sum(tri) % p == 0
    ]
    assert edge_ids == finite_zero_sum
    zero_masks = [sum(1 << i for i in triple_indices[j]) for j in finite_zero_sum]
    Z3 = max(
        popcount(mask)
        for mask in range(1 << p)
        if not any(em & mask == em for em in zero_masks)
    )
    assert tau == p - Z3
    print(f"e2=(0,0,1,0): N={N} nu={nu} tau={tau} Z3={Z3} q-Z3={p-Z3} OK")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("q", nargs="+", type=int)
    args = ap.parse_args()
    for p in args.q:
        run(p)


if __name__ == "__main__":
    main()
