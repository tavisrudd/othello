#!/usr/bin/env python3
"""C201: orbit-reduced Frobenius-stable Baer-conic 13-arcs in PG(2,64).

Family: the nine GF(8)-rational points of XZ=Y^2, extended by two
GF(64)/GF(8) Frobenius-conjugate point-pairs.  The quotient group is the
natural PΓL(2,8) action on the conic, extended to PG(2,64).
"""

from __future__ import annotations

import collections
import itertools
import json

Q = 64
MODULUS = 0x43  # x^6 + x + 1


def raw_mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        b >>= 1
        a <<= 1
        if a & Q:
            a ^= MODULUS
    return out


MUL = tuple(tuple(raw_mul(a, b) for b in range(Q)) for a in range(Q))


def mul(a: int, b: int) -> int:
    return MUL[a][b]


def power(a: int, n: int) -> int:
    out = 1
    while n:
        if n & 1:
            out = mul(out, a)
        a = mul(a, a)
        n >>= 1
    return out


INV = (0,) + tuple(power(a, Q - 2) for a in range(1, Q))


def normalize(v: tuple[int, ...]) -> tuple[int, ...]:
    lead = next(x for x in v if x)
    return tuple(mul(INV[lead], x) for x in v)


POINTS = tuple(
    [(0, 0, 1)]
    + [(0, 1, z) for z in range(Q)]
    + [(1, y, z) for y in range(Q) for z in range(Q)]
)
POINT_INDEX = {p: i for i, p in enumerate(POINTS)}
assert len(POINTS) == len(POINT_INDEX) == 4161


def dot(a: tuple[int, ...], b: tuple[int, ...]) -> int:
    out = 0
    for x, y in zip(a, b):
        out ^= mul(x, y)
    return out


def determinant(a: int, b: int, c: int) -> int:
    x, y, z = POINTS[a], POINTS[b], POINTS[c]
    return (
        mul(x[0], mul(y[1], z[2]) ^ mul(y[2], z[1]))
        ^ mul(x[1], mul(y[0], z[2]) ^ mul(y[2], z[0]))
        ^ mul(x[2], mul(y[0], z[1]) ^ mul(y[1], z[0]))
    )


def mat_vec(m: tuple[tuple[int, ...], ...], v: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(mul(row[0], v[0]) ^ mul(row[1], v[1]) ^ mul(row[2], v[2]) for row in m)


def point_permutation(m: tuple[tuple[int, ...], ...]) -> tuple[int, ...]:
    return tuple(POINT_INDEX[normalize(mat_vec(m, p))] for p in POINTS)


def line(a: int, b: int) -> tuple[int, ...]:
    x, y = POINTS[a], POINTS[b]
    return normalize((
        mul(x[1], y[2]) ^ mul(x[2], y[1]),
        mul(x[2], y[0]) ^ mul(x[0], y[2]),
        mul(x[0], y[1]) ^ mul(x[1], y[0]),
    ))


LINE_POINTS = {
    ell: tuple(i for i, p in enumerate(POINTS) if dot(ell, p) == 0)
    for ell in POINTS
}
assert all(len(xs) == Q + 1 for xs in LINE_POINTS.values())


SUBFIELD = tuple(x for x in range(Q) if power(x, 8) == x)
assert len(SUBFIELD) == 8
CONIC8 = tuple(
    [POINT_INDEX[(0, 0, 1)]]
    + [POINT_INDEX[(1, t, mul(t, t))] for t in SUBFIELD]
)


def sigma_point(i: int) -> int:
    return POINT_INDEX[normalize(tuple(power(x, 8) for x in POINTS[i]))]


def is_arc(points: tuple[int, ...]) -> bool:
    return all(determinant(a, b, c) for a, b, c in itertools.combinations(points, 3))


def legal_conjugate_pairs() -> list[tuple[int, int]]:
    seen: set[int] = set()
    answer = []
    for i in range(len(POINTS)):
        j = sigma_point(i)
        if i == j or i in seen:
            continue
        seen.update((i, j))
        pair = tuple(sorted((i, j)))
        if is_arc(CONIC8 + pair):
            answer.append(pair)
    assert len(seen) == 4088
    return answer


def compatible_edges(pairs: list[tuple[int, int]]) -> set[tuple[int, int]]:
    answer = set()
    for i, left in enumerate(pairs):
        for j in range(i + 1, len(pairs)):
            right = pairs[j]
            # Each eleven-point half is already an arc.  Only mixed triples remain.
            if not all(determinant(a, b, c) for a in CONIC8 for b in left for c in right):
                continue
            if not all(determinant(left[0], left[1], c) for c in right):
                continue
            if not all(determinant(right[0], right[1], c) for c in left):
                continue
            answer.add((i, j))
    return answer


def conic_matrix(a: int, b: int, c: int, d: int) -> tuple[tuple[int, ...], ...]:
    # Symmetric-square action on (s^2,st,t^2) in characteristic two.
    return (
        (mul(a, a), 0, mul(b, b)),
        (mul(a, c), mul(a, d) ^ mul(b, c), mul(b, d)),
        (mul(c, c), 0, mul(d, d)),
    )


def pair_action(
    pairs: list[tuple[int, int]], matrix: tuple[tuple[int, ...], ...]
) -> tuple[int, ...]:
    point_action = point_permutation(matrix)
    lookup = {pair: i for i, pair in enumerate(pairs)}
    return tuple(lookup[tuple(sorted((point_action[a], point_action[b])))] for a, b in pairs)


def frobenius_pair_action(pairs: list[tuple[int, int]]) -> tuple[int, ...]:
    lookup = {pair: i for i, pair in enumerate(pairs)}
    return tuple(
        lookup[tuple(sorted(POINT_INDEX[normalize(tuple(mul(x, x) for x in POINTS[p]))] for p in pair))]
        for pair in pairs
    )


def group_generators(pairs: list[tuple[int, int]]) -> list[tuple[int, ...]]:
    primitive = next(x for x in SUBFIELD if x != 1 and power(x, 7) == 1)
    matrices = (
        conic_matrix(1, 1, 0, 1),          # t -> t+1
        conic_matrix(primitive, 0, 0, 1),  # scaling
        conic_matrix(0, 1, 1, 0),          # inversion
    )
    return [pair_action(pairs, m) for m in matrices] + [frobenius_pair_action(pairs)]


def edge_orbits(
    edges: set[tuple[int, int]], generators: list[tuple[int, ...]]
) -> list[tuple[tuple[int, int], int]]:
    remaining = set(edges)
    answer = []
    while remaining:
        seed = min(remaining)
        orbit = {seed}
        frontier = [seed]
        while frontier:
            edge = frontier.pop()
            for action in generators:
                image = tuple(sorted((action[edge[0]], action[edge[1]])))
                assert image in edges
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        answer.append((seed, len(orbit)))
        remaining -= orbit
    assert sum(size for _, size in answer) == len(edges)
    assert all(1512 % size == 0 for _, size in answer)
    return sorted(answer)


def monomial(p: tuple[int, ...]) -> tuple[int, ...]:
    x, y, z = p
    return (mul(x, x), mul(y, y), mul(z, z), mul(x, y), mul(x, z), mul(y, z))


def kernel(rows: list[tuple[int, ...]]) -> list[tuple[int, ...]]:
    a = [list(row) for row in rows]
    pivots: list[int] = []
    row = 0
    for col in range(6):
        pivot = next((i for i in range(row, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        scale = INV[a[row][col]]
        a[row] = [mul(scale, x) for x in a[row]]
        for i in range(len(a)):
            if i != row and a[i][col]:
                scale = a[i][col]
                a[i] = [x ^ mul(scale, y) for x, y in zip(a[i], a[row])]
        pivots.append(col)
        row += 1
        if row == len(a):
            break
    answer = []
    for free in (c for c in range(6) if c not in pivots):
        vector = [0] * 6
        vector[free] = 1
        for i, pivot in enumerate(pivots):
            vector[pivot] = a[i][free]
        answer.append(tuple(vector))
    return answer


def profile(arc: tuple[int, ...]) -> dict:
    assert len(arc) == 13 and is_arc(arc)
    counts = [0] * len(POINTS)
    for a, b in itertools.combinations(arc, 2):
        for x in LINE_POINTS[line(a, b)]:
            counts[x] += 1
    for x in arc:
        counts[x] = -1
    spectrum = collections.Counter(x for x in counts if x >= 0)
    uncovered = tuple(i for i, value in enumerate(counts) if value == 0)
    basis = kernel([monomial(POINTS[x]) for x in uncovered])
    forced = tuple(
        x for x in arc if basis and all(dot(qform, monomial(POINTS[x])) == 0 for qform in basis)
    )
    return {
        "rank": 6 - len(basis),
        "nullity": len(basis),
        "uncovered_size": len(uncovered),
        "spectrum_0_to_6": tuple(spectrum.get(i, 0) for i in range(7)),
        "scaled_defect": sum((value - 1) * (6 - value) for value in counts if value > 0),
        "forced_hit_count": len(forced),
    }


def main() -> None:
    pairs = legal_conjugate_pairs()
    edges = compatible_edges(pairs)
    generators = group_generators(pairs)
    orbits = edge_orbits(edges, generators)
    results = []
    invariance_matrix = ((1, 2, 4), (0, 1, 8), (0, 0, 1))
    invariance_action = point_permutation(invariance_matrix)
    for edge, orbit_size in orbits:
        arc = tuple(sorted(CONIC8 + pairs[edge[0]] + pairs[edge[1]]))
        item = profile(arc)
        transformed = tuple(reversed([invariance_action[x] for x in arc]))
        transformed_item = profile(transformed)
        for key in ("rank", "nullity", "uncovered_size", "spectrum_0_to_6",
                    "scaled_defect", "forced_hit_count"):
            assert transformed_item[key] == item[key], (edge, key)
        item.update({
            "edge": edge,
            "orbit_size": orbit_size,
            "family_stabilizer_order": 1512 // orbit_size,
        })
        results.append(item)

    rank_histogram = collections.Counter(item["rank"] for item in results)
    weighted_rank_histogram = collections.Counter()
    verdict_histogram = collections.Counter()
    for item in results:
        weighted_rank_histogram[item["rank"]] += item["orbit_size"]
        verdict = "fullRank" if item["rank"] == 6 else (
            "forcedHit" if item["forced_hit_count"] else "avoidingQuadratic"
        )
        verdict_histogram[verdict] += item["orbit_size"]
    print(f"subfield {list(SUBFIELD)} conic8 {list(CONIC8)}")
    print(f"legal_conjugate_pairs {len(pairs)} compatible_pair_pairs {len(edges)}")
    print(f"pgamma_orbits {len(orbits)} orbit_size_histogram {dict(sorted(collections.Counter(s for _, s in orbits).items()))}")
    print(f"representative_rank_histogram {dict(sorted(rank_histogram.items()))}")
    print(f"weighted_rank_histogram {dict(sorted(weighted_rank_histogram.items()))}")
    print(f"weighted_verdict_histogram {dict(sorted(verdict_histogram.items()))}")
    print("invariance_check PASS: fixed projectivity plus relabeling on all orbit representatives")
    print(
        f"uncovered_size_range {min(item['uncovered_size'] for item in results)}.."
        f"{max(item['uncovered_size'] for item in results)} "
        f"scaled_defect_range {min(item['scaled_defect'] for item in results)}.."
        f"{max(item['scaled_defect'] for item in results)}"
    )
    cells = collections.Counter(
        (item["rank"], item["uncovered_size"], item["spectrum_0_to_6"],
         item["scaled_defect"], item["forced_hit_count"])
        for item in results
    )
    print(f"profile_cells {len(cells)}")
    for item in results:
        if item["rank"] < 6:
            print("DEFICIENT " + json.dumps(item, sort_keys=True))


if __name__ == "__main__":
    main()
