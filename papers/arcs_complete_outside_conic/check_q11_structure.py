#!/usr/bin/env python3
"""Independent exhaustive checks for the exceptional q=11 witness.

This script deliberately does not import the manuscript verifier.  It rebuilds
PG(2,11), the standard conic, syndrome errors, and PGL(2,11) from elementary
prime-field arithmetic.  Its output is deterministic JSON suitable for hashing.
"""

from __future__ import annotations

from collections import Counter, deque
from itertools import combinations, product
import json

Q = 11
Point = tuple[int, int, int]
PGL2 = tuple[int, int, int, int]

ARC: tuple[Point, ...] = (
    (1, 10, 0),
    (1, 9, 1),
    (1, 4, 7),
    (1, 8, 5),
    (0, 1, 4),
    (1, 1, 7),
)


def inv(x: int) -> int:
    return pow(x % Q, -1, Q)


def normalize(xs: tuple[int, ...]) -> tuple[int, ...]:
    ys = tuple(x % Q for x in xs)
    pivot = next(x for x in ys if x)
    scale = inv(pivot)
    return tuple(scale * x % Q for x in ys)


def det(u: Point, v: Point, w: Point) -> int:
    return (
        u[0] * (v[1] * w[2] - v[2] * w[1])
        - u[1] * (v[0] * w[2] - v[2] * w[0])
        + u[2] * (v[0] * w[1] - v[1] * w[0])
    ) % Q


def add(*vs: Point) -> Point:
    return tuple(sum(v[i] for v in vs) % Q for i in range(3))  # type: ignore[return-value]


def scale(c: int, v: Point) -> Point:
    return tuple(c * x % Q for x in v)  # type: ignore[return-value]


def rank_mod(rows: list[tuple[int, ...]]) -> int:
    a = [list(x % Q for x in row) for row in rows]
    if not a:
        return 0
    r = 0
    for c in range(len(a[0])):
        pivot = next((i for i in range(r, len(a)) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        z = inv(a[r][c])
        a[r] = [z * x % Q for x in a[r]]
        for i in range(len(a)):
            if i != r and a[i][c]:
                z = a[i][c]
                a[i] = [(x - z * y) % Q for x, y in zip(a[i], a[r])]
        r += 1
        if r == len(a):
            break
    return r


def projective_points() -> tuple[Point, ...]:
    return tuple(
        [(1, y, z) for y in range(Q) for z in range(Q)]
        + [(0, 1, z) for z in range(Q)]
        + [(0, 0, 1)]
    )


POINTS = projective_points()
CONIC = tuple(p for p in POINTS if p[0] * p[2] % Q == p[1] * p[1] % Q)


def is_arc(arc: tuple[Point, ...]) -> bool:
    return len(set(arc)) == len(arc) and all(det(*triple) for triple in combinations(arc, 3))


def secant_index(p: Point, arc: tuple[Point, ...]) -> int:
    return sum(det(a, b, p) == 0 for a, b in combinations(arc, 2))


def quadratic_rank(arc: tuple[Point, ...]) -> int:
    return rank_mod([
        (x * x, x * y, x * z, y * y, y * z, z * z)
        for x, y, z in arc
    ])


def extension_points(arc: tuple[Point, ...]) -> tuple[Point, ...]:
    aset = set(arc)
    return tuple(
        p for p in POINTS
        if p not in aset and all(det(a, b, p) for a, b in combinations(arc, 2))
    )


def syndrome_summary(arc: tuple[Point, ...]) -> dict[str, object]:
    zero: Point = (0, 0, 0)
    by_weight: list[Counter[Point]] = [Counter() for _ in range(4)]
    by_weight[0][zero] = 1
    for i, a in enumerate(arc):
        del i
        for c in range(1, Q):
            by_weight[1][scale(c, a)] += 1
    for i, j in combinations(range(len(arc)), 2):
        for c, d in product(range(1, Q), repeat=2):
            by_weight[2][add(scale(c, arc[i]), scale(d, arc[j]))] += 1
    for i, j, k in combinations(range(len(arc)), 3):
        for c, d, e in product(range(1, Q), repeat=3):
            by_weight[3][add(scale(c, arc[i]), scale(d, arc[j]), scale(e, arc[k]))] += 1

    distance: dict[Point, int] = {}
    for weight, syndromes in enumerate(by_weight):
        for s in syndromes:
            distance.setdefault(s, weight)
    assert len(distance) == Q**3
    dcounts = Counter(distance.values())
    leaders2 = Counter(by_weight[2][s] for s, d in distance.items() if d == 2)
    return {
        "distance_counts": dict(sorted(dcounts.items())),
        "distance_two_leader_histogram": dict(sorted(leaders2.items())),
    }


def mat3_apply(m: tuple[tuple[int, int, int], ...], p: Point) -> Point:
    return normalize(tuple(sum(m[i][j] * p[j] for j in range(3)) % Q for i in range(3)))  # type: ignore[return-value]


def pgl2_mul(g: PGL2, h: PGL2) -> PGL2:
    a, b, c, d = g
    e, f, k, l = h
    return normalize((a * e + b * k, a * f + b * l, c * e + d * k, c * f + d * l))  # type: ignore[return-value]


def sym2(g: PGL2) -> tuple[tuple[int, int, int], ...]:
    a, b, c, d = g
    return (
        (a * a % Q, 2 * a * b % Q, b * b % Q),
        (a * c % Q, (a * d + b * c) % Q, b * d % Q),
        (c * c % Q, 2 * c * d % Q, d * d % Q),
    )


def pgl2_elements() -> tuple[PGL2, ...]:
    return tuple(sorted({
        normalize((a, b, c, d))  # type: ignore[arg-type]
        for a, b, c, d in product(range(Q), repeat=4)
        if (a * d - b * c) % Q
    }))


def pgl2_order(g: PGL2) -> int:
    identity: PGL2 = (1, 0, 0, 1)
    x = identity
    for n in range(1, 121):
        x = pgl2_mul(x, g)
        if x == identity:
            return n
    raise AssertionError("PGL2 element order exceeded group order bound")


def generated_subgroup(generators: tuple[PGL2, ...]) -> set[PGL2]:
    identity: PGL2 = (1, 0, 0, 1)
    seen = {identity}
    todo = deque([identity])
    while todo:
        x = todo.popleft()
        for g in generators:
            y = pgl2_mul(x, g)
            if y not in seen:
                seen.add(y)
                todo.append(y)
    return seen


def action_orbits(group: tuple[PGL2, ...], objects: tuple[Point, ...]) -> list[tuple[Point, ...]]:
    remaining = set(objects)
    result: list[tuple[Point, ...]] = []
    while remaining:
        seed = min(remaining)
        orbit = {mat3_apply(sym2(g), seed) for g in group}
        assert orbit <= set(objects)
        result.append(tuple(sorted(orbit)))
        remaining -= orbit
    return result


def group_summary(arc: tuple[Point, ...]) -> tuple[dict[str, object], tuple[PGL2, ...]]:
    pgl = pgl2_elements()
    aset = set(arc)
    stabilizer = tuple(g for g in pgl if {mat3_apply(sym2(g), p) for p in arc} == aset)
    orders = Counter(pgl2_order(g) for g in stabilizer)
    determinant_square = Counter(
        pow((g[0] * g[3] - g[1] * g[2]) % Q, (Q - 1) // 2, Q)
        for g in stabilizer
    )

    by_order: dict[int, list[PGL2]] = {}
    for g in stabilizer:
        by_order.setdefault(pgl2_order(g), []).append(g)
    generators: tuple[PGL2, PGL2] | None = None
    for x in by_order.get(2, []):
        for y in by_order.get(3, []):
            if pgl2_order(pgl2_mul(x, y)) == 5 and len(generated_subgroup((x, y))) == 60:
                generators = (x, y)
                break
        if generators is not None:
            break
    assert generators is not None

    orbit_rows = []
    for orbit in action_orbits(stabilizer, POINTS):
        in_arc = orbit[0] in aset
        on_conic = orbit[0] in set(CONIC)
        indices = sorted({secant_index(p, arc) for p in orbit}) if not in_arc else []
        orbit_rows.append({
            "size": len(orbit),
            "arc": in_arc,
            "conic": on_conic,
            "secant_indices": indices,
            "representative": orbit[0],
        })
    orbit_rows.sort(key=lambda row: (not row["arc"], not row["conic"], row["size"], row["representative"]))
    return ({
        "pgl2_size": len(pgl),
        "stabilizer_size": len(stabilizer),
        "element_orders": dict(sorted(orders.items())),
        "determinant_legendre": dict(sorted(determinant_square.items())),
        "generators_order_2_3": generators,
        "generator_product_order": pgl2_order(pgl2_mul(*generators)),
        "generated_size": len(generated_subgroup(generators)),
        "point_orbits": orbit_rows,
    }, stabilizer)


def chord_summary(arc: tuple[Point, ...], extensions: tuple[Point, ...]) -> dict[str, object]:
    edges: list[tuple[Point, Point]] = []
    colors: list[list[tuple[Point, Point]]] = [[] for _ in arc]
    for p, q in combinations(extensions, 2):
        witnesses = [i for i, a in enumerate(arc) if det(p, q, a) == 0]
        if witnesses:
            assert len(witnesses) == 1
            edge = (p, q)
            edges.append(edge)
            colors[witnesses[0]].append(edge)

    degrees = Counter()
    for p, q in edges:
        degrees[p] += 1
        degrees[q] += 1

    color_rows = []
    for i, matching in enumerate(colors):
        used = [p for edge in matching for p in edge]
        assert len(used) == len(set(used))
        missing = sorted(set(extensions) - set(used))
        tangent_contacts = sorted(
            p for p in extensions
            if sum(det(arc[i], p, q) == 0 for q in extensions) == 1
        )
        assert missing == tangent_contacts
        color_rows.append({
            "witness": i,
            "edges": len(matching),
            "covered_vertices": len(used),
            "missing_tangent_contacts": missing,
        })

    edge_set = {frozenset(edge) for edge in edges}
    return {
        "edges": len(edges),
        "degree_histogram": dict(sorted(Counter(degrees.values()).items())),
        "color_classes": color_rows,
        "partition_distinct": sum(len(x) for x in colors) == len(edge_set),
    }


def transformed_invariance(arc: tuple[Point, ...], conic: tuple[Point, ...], stabilizer: tuple[PGL2, ...]) -> bool:
    transform = ((1, 1, 0), (0, 1, 1), (1, 0, 1))
    transformed_arc = tuple(reversed(tuple(mat3_apply(transform, p) for p in arc)))
    transformed_conic = tuple(mat3_apply(transform, p) for p in conic)
    transformed_extensions = extension_points(transformed_arc)
    if set(transformed_extensions) != set(transformed_conic):
        return False
    if quadratic_rank(transformed_arc) != quadratic_rank(arc):
        return False
    if syndrome_summary(transformed_arc) != syndrome_summary(arc):
        return False
    # Directly transport every stabilizer permutation; conjugate matrices are unnecessary here.
    original_orbits = sorted(len(o) for o in action_orbits(stabilizer, POINTS))
    transformed_images = {
        tuple(mat3_apply(transform, mat3_apply(sym2(g), p)) for p in arc)
        for g in stabilizer
    }
    return len(transformed_images) == 60 and original_orbits == [6, 10, 12, 15, 30, 30, 30]


def negative_control(stabilizer: tuple[PGL2, ...], generators: tuple[PGL2, PGL2]) -> dict[str, object]:
    original_extensions = extension_points(ARC)
    perturbed: tuple[Point, ...] | None = None
    for replacement in POINTS:
        candidate = (replacement,) + ARC[1:]
        if replacement not in CONIC and is_arc(candidate):
            if set(extension_points(candidate)) != set(original_extensions):
                perturbed = candidate
                break
    assert perturbed is not None
    perturbed_stabilizer = tuple(
        g for g in pgl2_elements()
        if {mat3_apply(sym2(g), p) for p in perturbed} == set(perturbed)
    )

    g = generators[0]
    mutated: PGL2 | None = None
    for i in range(4):
        raw = list(g)
        raw[i] = (raw[i] + 1) % Q
        if (raw[0] * raw[3] - raw[1] * raw[2]) % Q:
            candidate = normalize(tuple(raw))  # type: ignore[arg-type]
            if candidate not in stabilizer:
                mutated = candidate  # type: ignore[assignment]
                break
    assert mutated is not None
    return {
        "perturbed_first_point": perturbed[0],
        "perturbed_extension_count": len(extension_points(perturbed)),
        "perturbed_stabilizer_size": len(perturbed_stabilizer),
        "mutated_generator_preserves_arc": mutated in stabilizer,
    }


def main() -> None:
    assert len(POINTS) == 133 and len(set(POINTS)) == 133
    assert len(CONIC) == 12
    assert is_arc(ARC) and set(ARC).isdisjoint(CONIC)

    off_arc = [p for p in POINTS if p not in set(ARC)]
    required = [p for p in off_arc if p not in set(CONIC)]
    required_indices = Counter(secant_index(p, ARC) for p in required)
    conic_indices = Counter(secant_index(p, ARC) for p in CONIC)
    extensions = extension_points(ARC)
    assert set(extensions) == set(CONIC)

    group, stabilizer = group_summary(ARC)
    chords = chord_summary(ARC, extensions)
    syndrome = syndrome_summary(ARC)
    generators = group["generators_order_2_3"]
    assert isinstance(generators, tuple)

    edge_set = {
        frozenset((p, q)) for p, q in combinations(extensions, 2)
        if any(det(p, q, a) == 0 for a in ARC)
    }
    edge_orbit = {
        frozenset((mat3_apply(sym2(g), p), mat3_apply(sym2(g), q)))
        for g in stabilizer for p, q in [tuple(next(iter(edge_set)))]
    }

    result = {
        "field": Q,
        "points": len(POINTS),
        "conic_points": len(CONIC),
        "arc_points": len(ARC),
        "quadratic_evaluation_rank": quadratic_rank(ARC),
        "required_secant_indices": dict(sorted(required_indices.items())),
        "conic_secant_indices": dict(sorted(conic_indices.items())),
        "single_extensions": len(extensions),
        "syndromes": syndrome,
        "chords": chords,
        "group": group,
        "action_transitivity": {
            "arc_orbit": len({mat3_apply(sym2(g), ARC[0]) for g in stabilizer}),
            "conic_orbit": len({mat3_apply(sym2(g), CONIC[0]) for g in stabilizer}),
            "edge_orbit": len(edge_orbit),
        },
        "coordinate_invariance": transformed_invariance(ARC, CONIC, stabilizer),
        "negative_control": negative_control(stabilizer, generators),
    }

    assert result["quadratic_evaluation_rank"] == 6
    assert result["required_secant_indices"] == {1: 90, 2: 15, 3: 10}
    assert result["conic_secant_indices"] == {0: 12}
    assert syndrome["distance_counts"] == {0: 1, 1: 60, 2: 1150, 3: 120}
    assert syndrome["distance_two_leader_histogram"] == {1: 900, 2: 150, 3: 100}
    assert chords["edges"] == 30
    assert chords["degree_histogram"] == {5: 12}
    assert all(row["edges"] == 5 for row in chords["color_classes"])
    assert group["stabilizer_size"] == 60
    assert group["element_orders"] == {1: 1, 2: 15, 3: 20, 5: 24}
    assert group["determinant_legendre"] == {1: 60}
    assert result["action_transitivity"] == {"arc_orbit": 6, "conic_orbit": 12, "edge_orbit": 30}
    assert result["coordinate_invariance"] is True
    assert result["negative_control"]["mutated_generator_preserves_arc"] is False
    print(json.dumps(result, sort_keys=True, separators=(",", ":")))


if __name__ == "__main__":
    main()
