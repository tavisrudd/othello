#!/usr/bin/env python3
"""Generate the exact C477 certificate for the frozen q=11 collision fibre."""

from __future__ import annotations

import argparse
import hashlib
import json
import tempfile
from itertools import combinations, product
from pathlib import Path

Q = 11
INF = Q
SUPPORT = (0, 1, 2, 3, 4, INF)
ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-22-c477-first-atlas-collision-fibre.json"
UPSTREAM = ROOT / "2026-07-22-c476-standard-grs-atlas-pilot.json"


def inv(x: int) -> int:
    return pow(x % Q, -1, Q)


def canonical_matrix(m: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    scale = inv(next(x for x in m if x % Q))
    return tuple((scale * x) % Q for x in m)


def pgl2() -> list[tuple[int, int, int, int]]:
    matrices = {
        canonical_matrix((a, b, c, d))
        for a, b, c, d in product(range(Q), repeat=4)
        if (a * d - b * c) % Q
    }
    assert len(matrices) == Q * (Q * Q - 1)
    return sorted(matrices)


def mobius(m: tuple[int, int, int, int], t: int) -> int:
    a, b, c, d = m
    if t == INF:
        return INF if c == 0 else a * inv(c) % Q
    den = (c * t + d) % Q
    return INF if den == 0 else (a * t + b) * inv(den) % Q


def permutation(m: tuple[int, int, int, int]) -> tuple[int, ...]:
    return tuple(mobius(m, t) for t in range(Q + 1))


def cycles(perm: tuple[int, ...]) -> list[list[int]]:
    seen: set[int] = set()
    answer: list[list[int]] = []
    for x in range(Q + 1):
        if x in seen:
            continue
        cycle: list[int] = []
        y = x
        while y not in seen:
            seen.add(y)
            cycle.append(y)
            y = perm[y]
        answer.append(cycle)
    return answer


def orbits(perms: list[tuple[int, ...]], domain: set[int]) -> list[list[int]]:
    unseen = set(domain)
    answer: list[list[int]] = []
    while unseen:
        x = min(unseen)
        orbit = sorted({p[x] for p in perms})
        assert set(orbit) <= domain
        answer.append(orbit)
        unseen -= set(orbit)
    return answer


def fixed_geometry(m: tuple[int, int, int, int], perm: tuple[int, ...]) -> dict[str, object]:
    a, b, c, d = m
    rational = [x for x in range(Q + 1) if perm[x] == x]
    # On the affine chart the fixed polynomial is c*t^2+(d-a)*t-b.
    discriminant = ((d - a) * (d - a) + 4 * b * c) % Q
    square_class = "zero" if discriminant == 0 else (
        "square" if pow(discriminant, (Q - 1) // 2, Q) == 1 else "nonsquare"
    )
    return {
        "matrix": list(m),
        "permutation": list(perm),
        "cycles": cycles(perm),
        "rational_fixed_points": rational,
        "fixed_polynomial_discriminant": discriminant,
        "fixed_polynomial_discriminant_class": square_class,
    }


def conic_point(t: int) -> tuple[int, int, int]:
    return (0, 0, 1) if t == INF else (1, t, t * t % Q)


def det3(rows: tuple[tuple[int, int, int], ...]) -> int:
    (a, b, c), (d, e, f), (g, h, i) = rows
    return (a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g)) % Q


def pg2() -> list[tuple[int, int, int]]:
    return (
        [(1, y, z) for y in range(Q) for z in range(Q)]
        + [(0, 1, z) for z in range(Q)]
        + [(0, 0, 1)]
    )


def rank_mod_q(rows: list[list[int]]) -> int:
    a = [[x % Q for x in row] for row in rows]
    rank = 0
    for col in range(len(a[0]) if a else 0):
        pivot = next((r for r in range(rank, len(a)) if a[r][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        scale = inv(a[rank][col])
        a[rank] = [scale * x % Q for x in a[rank]]
        for r in range(len(a)):
            if r != rank and a[r][col]:
                scale = a[r][col]
                a[r] = [(x - scale * y) % Q for x, y in zip(a[r], a[rank])]
        rank += 1
    return rank


def quadratic_evaluation(point: tuple[int, int, int]) -> list[int]:
    x, y, z = point
    return [x * x % Q, x * y % Q, x * z % Q, y * y % Q, y * z % Q, z * z % Q]


def atlas_for_radical(r: int) -> list[int]:
    # beta(v_s,v_t) factors as a_s*a_t for u=v_r, including infinity.
    # Each four-subset contributes its two independent balanced ratios.
    labels: dict[tuple[int, int], int] = {}
    for i, j in combinations(range(6), 2):
        s, t = SUPPORT[i], SUPPORT[j]
        ui, uj = conic_point(s), conic_point(t)
        value = det3((ui, uj, conic_point(r)))
        bracket = det2_p1(s, t)
        labels[i, j] = value * inv(bracket) % Q
        assert labels[i, j]
    atlas: list[int] = []
    for i, j, k, ell in combinations(range(6), 4):
        atlas.append(labels[i, j] * labels[k, ell] * inv(labels[i, k] * labels[j, ell]) % Q)
        atlas.append(labels[i, j] * labels[k, ell] * inv(labels[i, ell] * labels[j, k]) % Q)
    assert len(atlas) == 30 and set(atlas) == {1}
    return atlas


def det2_p1(s: int, t: int) -> int:
    vs = (0, 1) if s == INF else (1, s)
    vt = (0, 1) if t == INF else (1, t)
    return (vs[0] * vt[1] - vs[1] * vt[0]) % Q


def legal_continuations(arc: list[tuple[int, int, int]]) -> list[tuple[int, int, int]]:
    arc_set = set(arc)
    answer = []
    for x in pg2():
        if x in arc_set:
            continue
        if all(det3((a, b, x)) for a, b in combinations(arc, 2)):
            answer.append(x)
    return answer


def compatible(arc: list[tuple[int, int, int]], x: tuple[int, int, int], y: tuple[int, int, int]) -> bool:
    return all(det3((a, x, y)) for a in arc)


def graph_profile(arc: list[tuple[int, int, int]], vertices: list[tuple[int, int, int]]) -> dict[str, object]:
    continuation_edges = [
        (i, j) for i, j in combinations(range(len(vertices)), 2)
        if compatible(arc, vertices[i], vertices[j])
    ]
    degrees = [0] * len(vertices)
    for i, j in continuation_edges:
        degrees[i] += 1
        degrees[j] += 1
    neighbours = {i: set() for i in range(len(vertices))}
    for i, j in continuation_edges:
        neighbours[i].add(j)
        neighbours[j].add(i)
    unseen = set(neighbours)
    components = []
    while unseen:
        stack = [min(unseen)]
        component = set()
        while stack:
            i = stack.pop()
            if i in component:
                continue
            component.add(i)
            stack.extend(neighbours[i] - component)
        unseen -= component
        components.append({
            "size": len(component),
            "degree_multiset": sorted(len(neighbours[i] & component) for i in component),
        })
    components.sort(key=lambda x: (-x["size"], x["degree_multiset"]))
    total_pairs = len(vertices) * (len(vertices) - 1) // 2
    return {
        "vertex_count": len(vertices),
        "vertices": [list(v) for v in vertices],
        "continuation_edge_count": len(continuation_edges),
        "conflict_edge_count": total_pairs - len(continuation_edges),
        "continuation_degree_multiset": sorted(degrees),
        "continuation_components": components,
        "quadratic_evaluation_rank_on_continuations": rank_mod_q(
            [quadratic_evaluation(v) for v in vertices]
        ),
    }


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def quotient_value(t: int) -> int:
    if t == INF:
        return INF
    numerator = t * (4 - t) * (1 - t) * (3 - t) % Q
    denominator = (1 + 5 * t) ** 2 % Q
    return INF if denominator == 0 else numerator * inv(denominator) % Q


def generate() -> dict[str, object]:
    stabilizer_matrices = [
        m for m in pgl2()
        if {mobius(m, s) for s in SUPPORT} == set(SUPPORT)
    ]
    stabilizer_perms = [permutation(m) for m in stabilizer_matrices]
    assert len(stabilizer_matrices) == 4
    complement = set(range(Q + 1)) - set(SUPPORT)
    complement_orbits = orbits(stabilizer_perms, complement)
    assert complement_orbits == [[5, 10], [6, 7, 8, 9]]
    quotient_fibres = orbits(stabilizer_perms, set(range(Q + 1)))
    assert all(len({quotient_value(t) for t in orbit}) == 1 for orbit in quotient_fibres)

    all_atlases = {r: atlas_for_radical(r) for r in sorted(complement)}
    assert len({tuple(atlas) for atlas in all_atlases.values()}) == 1

    fibre = []
    for orbit in complement_orbits:
        r = orbit[0]
        extended_arc = [conic_point(s) for s in SUPPORT + (r,)]
        continuations = legal_continuations(extended_arc)
        fibre.append({
            "representative_radical": r,
            "syndrome_representative": list(conic_point(r)),
            "radical_orbit": orbit,
            "orbit_size": len(orbit),
            "radical_point_stabilizer_order": len(stabilizer_perms) // len(orbit),
            "raw_atlas": atlas_for_radical(r),
            "quadratic_evaluation_rank_on_extended_arc": rank_mod_q(
                [quadratic_evaluation(v) for v in extended_arc]
            ),
            "extension_and_continuation_profile": graph_profile(extended_arc, continuations),
        })

    # Freeze the upstream bytes but do not import its computation.
    upstream = {
        "path": "notes/2026-07-22-c476-standard-grs-atlas-pilot.json",
        "bytes": UPSTREAM.stat().st_size,
        "sha256": sha256(UPSTREAM),
    }
    result = {
        "schema": "c477-first-atlas-collision-fibre-v1",
        "task": "C477",
        "field": {"q": Q, "model": "prime field integers modulo 11", "infinity": INF},
        "support": list(SUPPORT),
        "upstream_frozen_input": upstream,
        "stabilizer": {
            "order": len(stabilizer_matrices),
            "abstract_structure": "Klein four",
            "elements": [fixed_geometry(m, p) for m, p in zip(stabilizer_matrices, stabilizer_perms)],
            "support_orbits": orbits(stabilizer_perms, set(SUPPORT)),
            "complement_orbits": complement_orbits,
            "quotient_coordinate": {
                "formula": "t*(4-t)*(1-t)*(3-t)/(1+5*t)^2",
                "rational_fibres": [
                    {"value": quotient_value(orbit[0]), "points": orbit}
                    for orbit in quotient_fibres
                ],
            },
        },
        "complete_raw_rank_one_atlas_fibre": {
            "radicals": sorted(complement),
            "atlas_coordinate_count": 30,
            "distinct_atlas_count": 1,
            "pairwise_atlas_equality_count": 15,
            "common_atlas": all_atlases[min(complement)],
        },
        "collision_fibre": fibre,
        "control_verdicts": {
            "evaluation_rank_separates": len({x["quadratic_evaluation_rank_on_extended_arc"] for x in fibre}) > 1,
            "extension_conflict_profile_separates": len({
                json.dumps(x["extension_and_continuation_profile"], sort_keys=True)
                for x in fibre
            }) > 1,
            "continuation_graph_profile_separates": len({
                (
                    x["extension_and_continuation_profile"]["vertex_count"],
                    x["extension_and_continuation_profile"]["continuation_edge_count"],
                    tuple(x["extension_and_continuation_profile"]["continuation_degree_multiset"]),
                )
                for x in fibre
            }) > 1,
            "ramification_bit_separates": len({x["radical_point_stabilizer_order"] > 1 for x in fibre}) > 1,
        },
    }
    return result


def serialized() -> bytes:
    return (json.dumps(generate(), indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = serialized()
    if args.check:
        with tempfile.TemporaryDirectory() as tmp:
            candidate = Path(tmp) / OUTPUT.name
            candidate.write_bytes(data)
            if not OUTPUT.exists() or OUTPUT.read_bytes() != candidate.read_bytes():
                raise SystemExit(f"stale certificate: {OUTPUT}")
        print("C477 primary check: exact certificate matches")
    else:
        OUTPUT.write_bytes(data)
        print(f"wrote {OUTPUT}")


if __name__ == "__main__":
    main()
