#!/usr/bin/env python3
"""Independent C201 anatomy check for the frozen PG(2,16) eight-arc list.

The script deliberately consumes only Q16CertificateLevels.lean.  It does not
reuse the C++ enumerator's finite-field, secant, rank, or stabilizer code.
"""

from __future__ import annotations

import argparse
import collections
import hashlib
import itertools
import json
import pathlib
import re
from typing import Iterable, Sequence

MODULUS = 0x13  # x^4 + x + 1
Q = 16


def add(a: int, b: int) -> int:
    return a ^ b


def mul(a: int, b: int) -> int:
    out = 0
    while b:
        if b & 1:
            out ^= a
        b >>= 1
        a <<= 1
        if a & Q:
            a ^= MODULUS
    return out


def inv(a: int) -> int:
    assert a
    for b in range(1, Q):
        if mul(a, b) == 1:
            return b
    raise AssertionError("nonzero field element has no inverse")


def scale(c: int, v: Sequence[int]) -> tuple[int, ...]:
    return tuple(mul(c, x) for x in v)


def normalize(v: Sequence[int]) -> tuple[int, ...]:
    lead = next(x for x in v if x)
    return scale(inv(lead), v)


POINTS = tuple(
    [(0, 0, 1)]
    + [(0, 1, z) for z in range(Q)]
    + [(1, y, z) for y in range(Q) for z in range(Q)]
)
POINT_INDEX = {p: i for i, p in enumerate(POINTS)}
assert len(POINTS) == len(POINT_INDEX) == 273


def det(a: Sequence[int], b: Sequence[int], c: Sequence[int]) -> int:
    return add(
        add(mul(a[0], add(mul(b[1], c[2]), mul(b[2], c[1]))),
            mul(a[1], add(mul(b[0], c[2]), mul(b[2], c[0])))),
        mul(a[2], add(mul(b[0], c[1]), mul(b[1], c[0]))),
    )


def mat_vec(m: Sequence[Sequence[int]], v: Sequence[int]) -> tuple[int, ...]:
    return tuple(
        mul(m[i][0], v[0]) ^ mul(m[i][1], v[1]) ^ mul(m[i][2], v[2])
        for i in range(3)
    )


def mat_mul(a: Sequence[Sequence[int]], b: Sequence[Sequence[int]]) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(
            mul(a[i][0], b[0][j]) ^ mul(a[i][1], b[1][j]) ^ mul(a[i][2], b[2][j])
            for j in range(3)
        )
        for i in range(3)
    )


def mat_inv(m: Sequence[Sequence[int]]) -> tuple[tuple[int, ...], ...]:
    a = [list(row) + [int(i == j) for j in range(3)] for i, row in enumerate(m)]
    for col in range(3):
        pivot = next(i for i in range(col, 3) if a[i][col])
        a[col], a[pivot] = a[pivot], a[col]
        a[col] = list(scale(inv(a[col][col]), a[col]))
        for i in range(3):
            if i != col and a[i][col]:
                c = a[i][col]
                a[i] = [x ^ mul(c, y) for x, y in zip(a[i], a[col])]
    return tuple(tuple(row[3:]) for row in a)


def frame_map(frame: Sequence[int]) -> tuple[tuple[int, ...], ...]:
    """Map an ordered projective frame to e0,e1,e2,(1,1,1)."""
    cols = tuple(tuple(POINTS[frame[j]][i] for j in range(3)) for i in range(3))
    base = mat_inv(cols)
    fourth = mat_vec(base, POINTS[frame[3]])
    assert all(fourth)
    return tuple(scale(inv(fourth[i]), base[i]) for i in range(3))


def projectivity_permutation(m: Sequence[Sequence[int]]) -> tuple[int, ...]:
    return tuple(POINT_INDEX[normalize(mat_vec(m, p))] for p in POINTS)


def monomial(p: Sequence[int]) -> tuple[int, ...]:
    x, y, z = p
    return (mul(x, x), mul(y, y), mul(z, z), mul(x, y), mul(x, z), mul(y, z))


def dot(a: Sequence[int], b: Sequence[int]) -> int:
    out = 0
    for x, y in zip(a, b):
        out ^= mul(x, y)
    return out


def rref(rows: Iterable[Sequence[int]], width: int = 6) -> tuple[list[list[int]], list[int]]:
    a = [list(row) for row in rows]
    pivots: list[int] = []
    row = 0
    for col in range(width):
        pivot = next((i for i in range(row, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        a[row] = list(scale(inv(a[row][col]), a[row]))
        for i in range(len(a)):
            if i != row and a[i][col]:
                c = a[i][col]
                a[i] = [x ^ mul(c, y) for x, y in zip(a[i], a[row])]
        pivots.append(col)
        row += 1
        if row == len(a):
            break
    return a, pivots


def kernel(rows: Iterable[Sequence[int]]) -> list[tuple[int, ...]]:
    reduced, pivots = rref(rows)
    free = [j for j in range(6) if j not in pivots]
    out = []
    for f in free:
        v = [0] * 6
        v[f] = 1
        for i, p in enumerate(pivots):
            v[p] = reduced[i][f]
        out.append(tuple(v))
    return out


def point_indices(arc: Sequence[int]) -> tuple[int, ...]:
    chosen = set(arc)
    counts = [0] * len(POINTS)
    for a, b in itertools.combinations(arc, 2):
        for x in line_points(a, b):
            counts[x] += 1
    return tuple(-1 if x in chosen else counts[x] for x in range(len(POINTS)))


def line_points(a: int, b: int) -> tuple[int, ...]:
    pa, pb = POINTS[a], POINTS[b]
    line = normalize((
        mul(pa[1], pb[2]) ^ mul(pa[2], pb[1]),
        mul(pa[2], pb[0]) ^ mul(pa[0], pb[2]),
        mul(pa[0], pb[1]) ^ mul(pa[1], pb[0]),
    ))
    return LINE_POINTS[line]


LINE_POINTS = {
    line: tuple(i for i, p in enumerate(POINTS) if dot(line, p) == 0)
    for line in POINTS
}
assert all(len(xs) == 17 for xs in LINE_POINTS.values())


def quadratic_kind(qform: Sequence[int]) -> str:
    # In characteristic two the polar radical is [YZ,XZ,XY].  A conic is
    # nonsingular exactly when that radical point is not on the conic.
    radical = (qform[5], qform[4], qform[3])
    if any(radical) and dot(qform, monomial(radical)):
        return "nonsingular"
    zeros = sum(dot(qform, monomial(p)) == 0 for p in POINTS)
    if zeros == 33:
        return "split-lines"
    if zeros == 17:
        return "double-line"
    return f"singular-{zeros}-points"


def orbits(domain: Iterable[int], permutations: Sequence[Sequence[int]]) -> list[list[int]]:
    remaining = set(domain)
    answer = []
    while remaining:
        seed = min(remaining)
        orbit = {g[seed] for g in permutations}
        # The enumerated stabilizer is already a group; close defensively.
        old = set()
        while orbit != old:
            old = set(orbit)
            orbit |= {g[x] for g in permutations for x in tuple(orbit)}
        answer.append(sorted(orbit))
        remaining -= orbit
    return answer


def stabilizer(arc: Sequence[int]) -> list[tuple[int, ...]]:
    source_map = frame_map(arc[:4])
    aset = set(arc)
    found = set()
    for target in itertools.permutations(arc, 4):
        m = mat_mul(mat_inv(frame_map(target)), source_map)
        perm = projectivity_permutation(m)
        if {perm[x] for x in arc} == aset:
            found.add(perm)
    return sorted(found)


def read_level8(path: pathlib.Path) -> list[tuple[int, ...]]:
    text = path.read_text()
    match = re.search(r"def level8 .*? := \[\n(.*?)\n\]\n\nend", text, re.S)
    if not match:
        raise ValueError(f"could not locate level8 in {path}")
    arcs = [tuple(map(int, xs.split(','))) for xs in re.findall(r"\{([0-9,]+)\}", match.group(1))]
    if len(arcs) != 2633 or any(len(a) != 8 for a in arcs):
        raise ValueError(f"unexpected frozen leaf shape: {len(arcs)} leaves")
    return arcs


def basic_profile(arc: Sequence[int]) -> dict:
    assert len(set(arc)) == 8
    assert all(det(POINTS[a], POINTS[b], POINTS[c]) for a, b, c in itertools.combinations(arc, 3))
    indices = point_indices(arc)
    spectrum = collections.Counter(i for i in indices if i >= 0)
    uncovered = tuple(i for i, r in enumerate(indices) if r == 0)
    ker = kernel(monomial(POINTS[x]) for x in uncovered)
    scaled_defect = sum((r - 1) * (4 - r) for r in indices if r > 0)
    return {
        "uncovered": uncovered,
        "uncovered_size": len(uncovered),
        "rank": 6 - len(ker),
        "nullity": len(ker),
        "kernel": ker,
        "spectrum": tuple(spectrum.get(i, 0) for i in range(5)),
        "scaled_defect": scaled_defect,
    }


def transformed_arc(arc: Sequence[int]) -> tuple[int, ...]:
    m = ((1, 2, 4), (0, 1, 8), (0, 0, 1))
    return tuple(reversed([projectivity_permutation(m)[x] for x in arc]))


def main() -> None:
    parser = argparse.ArgumentParser()
    default_levels = pathlib.Path(__file__).resolve().parents[2] / "lean/RelativeConicArcs/Q16CertificateLevels.lean"
    parser.add_argument("--levels", type=pathlib.Path, default=default_levels)
    parser.add_argument("--json", action="store_true", help="emit the full deterministic summary as JSON")
    args = parser.parse_args()

    arcs = read_level8(args.levels)
    profiles = [basic_profile(arc) for arc in arcs]
    histogram = collections.Counter(
        (p["rank"], p["uncovered_size"], p["spectrum"], p["scaled_defect"])
        for p in profiles
    )
    invariant_ranks: dict[tuple, collections.Counter] = collections.defaultdict(collections.Counter)
    for p in profiles:
        invariant_ranks[(p["uncovered_size"], p["spectrum"], p["scaled_defect"])][p["rank"]] += 1
    rank_collisions = {key: counts for key, counts in invariant_ranks.items() if len(counts) > 1}
    deficient = [i for i, p in enumerate(profiles) if p["rank"] < 6]
    assert len(deficient) == 3

    exceptional = []
    for leaf in deficient:
        arc = arcs[leaf]
        p = profiles[leaf]
        assert p["nullity"] == 1
        qform = normalize(p["kernel"][0])
        group = stabilizer(arc)
        arc_hits = [x for x in arc if dot(qform, monomial(POINTS[x])) == 0]
        zeros = [x for x in range(len(POINTS)) if dot(qform, monomial(POINTS[x])) == 0]
        check = basic_profile(transformed_arc(arc))
        for key in ("uncovered_size", "rank", "nullity", "spectrum", "scaled_defect"):
            assert check[key] == p[key], (leaf, key)
        assert quadratic_kind(normalize(check["kernel"][0])) == quadratic_kind(qform)
        exceptional.append({
            "leaf": leaf,
            "arc": list(arc),
            "arc_points": [list(POINTS[x]) for x in arc],
            "uncovered_size": p["uncovered_size"],
            "rank": p["rank"],
            "kernel_generator": list(qform),
            "quadratic_kind": quadratic_kind(qform),
            "quadratic_zero_count": len(zeros),
            "arc_intersection": len(arc_hits),
            "arc_hit_orbit_sizes": sorted(len(o) for o in orbits(arc_hits, group)),
            "arc_orbit_sizes": sorted(len(o) for o in orbits(arc, group)),
            "uncovered_orbit_sizes": sorted(len(o) for o in orbits(p["uncovered"], group)),
            "stabilizer_order": len(group),
            "secant_index_spectrum_0_to_4": list(p["spectrum"]),
            "scaled_defect": p["scaled_defect"],
        })

    serial_histogram = [
        {
            "count": count,
            "rank": key[0],
            "uncovered_size": key[1],
            "secant_index_spectrum_0_to_4": list(key[2]),
            "scaled_defect": key[3],
        }
        for key, count in sorted(histogram.items())
    ]
    digest = hashlib.sha256(args.levels.read_bytes()).hexdigest()
    summary = {
        "field": "GF(16), modulus x^4+x+1",
        "levels_sha256": digest,
        "leaf_count": len(arcs),
        "rank_histogram": dict(sorted(collections.Counter(p["rank"] for p in profiles).items())),
        "minimum_scaled_defect": min(p["scaled_defect"] for p in profiles),
        "minimum_full_rank_scaled_defect": min(
            p["scaled_defect"] for p in profiles if p["rank"] == 6
        ),
        "zero_defect_leaf_count": sum(p["scaled_defect"] == 0 for p in profiles),
        "minimum_defect_leaf_count": sum(
            p["scaled_defect"] == min(q["scaled_defect"] for q in profiles) for p in profiles
        ),
        "rank_colliding_index_defect_cells": len(rank_collisions),
        "profile_cells": serial_histogram,
        "exceptional": exceptional,
        "invariance_check": "PASS: fixed projectivity plus point-order reversal on all exceptional leaves",
    }
    if args.json:
        print(json.dumps(summary, indent=2, sort_keys=True))
        return
    print(f"levels_sha256 {digest}")
    print(f"leaves {len(arcs)} rank_histogram {dict(sorted(collections.Counter(p['rank'] for p in profiles).items()))}")
    print(f"profile_cells {len(histogram)} minimum_scaled_defect {summary['minimum_scaled_defect']}")
    print(f"minimum_full_rank_scaled_defect {summary['minimum_full_rank_scaled_defect']}")
    print(
        f"zero_defect_leaves {summary['zero_defect_leaf_count']} "
        f"minimum_defect_leaves {summary['minimum_defect_leaf_count']} "
        f"rank_colliding_index_defect_cells {summary['rank_colliding_index_defect_cells']}"
    )
    for item in exceptional:
        print("EXCEPTIONAL " + json.dumps(item, sort_keys=True))
    print(summary["invariance_check"])


if __name__ == "__main__":
    main()
