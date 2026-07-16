#!/usr/bin/env python3
"""C202: exact q=9 repair-extremizer and PGL(2,9)-orbit certificate.

The script imports only the independent finite-field/matroid verifier beside it.  It reconstructs
PGL(2,9) from normalized 2x2 matrices, derives the induced axis action from the unique
three-cubic/one-axis circuits, and independently solves the set-packing and set-cover problems.

Radius-three orbit representatives are materialized.  At radius four the maximum-matching orbit
sets are too large to be useful; their exact orbit counts are instead certified by Burnside's
lemma, with every fixed-point count obtained by a separate orbit-item packing dynamic program.
Use --write-lp DIR to emit conventional binary ILP models for external solver replay.
"""

from __future__ import annotations

import argparse
from collections import Counter
from functools import lru_cache
import hashlib
import importlib.util
from itertools import combinations, product
import json
from pathlib import Path
import sys
from typing import Iterable


HERE = Path(__file__).resolve().parent
VERIFIER = HERE / "2026-07-13-projective-completion-verifier.py"


def load_verifier():
    spec = importlib.util.spec_from_file_location("projective_completion_verifier", VERIFIER)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def mask(items: Iterable[int]) -> int:
    return sum(1 << item for item in items)


def mask_items(value: int, size: int = 20) -> list[int]:
    return [item for item in range(size) if value & (1 << item)]


def transform_mask(value: int, permutation: tuple[int, ...]) -> int:
    return mask(permutation[item] for item in mask_items(value, len(permutation)))


def pgl_cubic_permutations(field) -> tuple[tuple[int, ...], ...]:
    """Enumerate PGL(2,q) on P^1 via t |-> (b+d*t)/(a+c*t)."""

    q = field.q

    def fractional(matrix: tuple[int, int, int, int], t: int) -> int:
        a, b, c, d = matrix
        if t == q:
            return q if c == 0 else field.div(d, c)
        denominator = field.add(a, field.mul(c, t))
        numerator = field.add(b, field.mul(d, t))
        return q if denominator == 0 else field.div(numerator, denominator)

    normalized = set()
    for matrix in product(range(q), repeat=4):
        a, b, c, d = matrix
        if field.sub(field.mul(a, d), field.mul(b, c)) == 0:
            continue
        inverse = field.inv(next(entry for entry in matrix if entry))
        normalized.add(tuple(field.mul(inverse, entry) for entry in matrix))
    permutations = tuple(sorted({tuple(fractional(g, t) for t in range(q + 1))
                                 for g in normalized}))
    assert len(normalized) == q**3 - q
    assert len(permutations) == q**3 - q
    return permutations


def completed_pgl_group(field, circuits, cubic_group) -> tuple[tuple[int, ...], ...]:
    """Recover the induced axis action from the circuit incidence relation."""

    q = field.q
    completion: dict[frozenset[int], int] = {}
    for circuit in circuits:
        cubics = [item for item in circuit if item <= q]
        axes = [item for item in circuit if item > q]
        if len(circuit) == 4 and len(cubics) == 3 and len(axes) == 1:
            completion[frozenset(cubics)] = axes[0]
    representatives = {
        axis: next(triple for triple, completion_axis in completion.items()
                   if completion_axis == axis)
        for axis in range(q + 1, 2 * q + 2)
    }
    group = []
    for cubic_permutation in cubic_group:
        permutation = list(cubic_permutation) + [0] * (q + 1)
        for axis, triple in representatives.items():
            permutation[axis] = completion[
                frozenset(cubic_permutation[item] for item in triple)
            ]
        assert all(
            completion[frozenset(cubic_permutation[item] for item in triple)]
            == permutation[axis]
            for triple, axis in completion.items()
        )
        group.append(tuple(permutation))
    answer = tuple(sorted(set(group)))
    assert len(answer) == q**3 - q
    return answer


def repair_edges(circuits, target: int, radius: int) -> tuple[int, ...]:
    return tuple(sorted({
        mask(item for item in circuit if item != target)
        for circuit in circuits
        if target in circuit and len(circuit) - 1 <= radius
    }))


def matching_optimum_and_count(edges: tuple[int, ...], universe: int) -> tuple[int, int]:
    incident = [tuple(edge for edge in edges if edge & (1 << vertex)) for vertex in range(20)]

    @lru_cache(None)
    def solve(available: int) -> tuple[int, int]:
        active = 0
        for edge in edges:
            if edge & ~available == 0:
                active |= edge
        if active == 0:
            return 0, 1
        vertex = (active & -active).bit_length() - 1
        best, count = solve(available ^ (1 << vertex))
        for edge in incident[vertex]:
            if edge & ~available:
                continue
            candidate, candidate_count = solve(available & ~edge)
            candidate += 1
            if candidate > best:
                best, count = candidate, candidate_count
            elif candidate == best:
                count += candidate_count
        return best, count

    return solve(universe)


def enumerate_maximum_matchings(
    edges: tuple[int, ...], universe: int, optimum: int
) -> tuple[tuple[int, ...], ...]:
    incident = [tuple(edge for edge in edges if edge & (1 << vertex)) for vertex in range(20)]

    @lru_cache(None)
    def best(available: int) -> int:
        active = 0
        for edge in edges:
            if edge & ~available == 0:
                active |= edge
        if active == 0:
            return 0
        vertex = (active & -active).bit_length() - 1
        value = best(available ^ (1 << vertex))
        for edge in incident[vertex]:
            if edge & ~available == 0:
                value = max(value, 1 + best(available & ~edge))
        return value

    answer: list[tuple[int, ...]] = []

    def visit(available: int, family: tuple[int, ...]) -> None:
        if len(family) + best(available) < optimum:
            return
        active = 0
        for edge in edges:
            if edge & ~available == 0:
                active |= edge
        if active == 0:
            if len(family) == optimum:
                answer.append(tuple(sorted(family)))
            return
        vertex = (active & -active).bit_length() - 1
        without = available ^ (1 << vertex)
        if len(family) + best(without) >= optimum:
            visit(without, family)
        for edge in incident[vertex]:
            remaining = available & ~edge
            if edge & ~available == 0 and len(family) + 1 + best(remaining) >= optimum:
                visit(remaining, family + (edge,))

    visit(universe, ())
    assert len(answer) == len(set(answer))
    return tuple(answer)


def transversal_optimum(edges: tuple[int, ...]) -> int:
    incident: dict[int, int] = {}
    for edge_index, edge in enumerate(edges):
        for vertex in mask_items(edge):
            incident[vertex] = incident.get(vertex, 0) | (1 << edge_index)

    @lru_cache(None)
    def solve(remaining: int) -> int:
        if remaining == 0:
            return 0
        edge_index = (remaining & -remaining).bit_length() - 1
        return 1 + min(
            solve(remaining & ~incident[vertex])
            for vertex in mask_items(edges[edge_index])
        )

    return solve((1 << len(edges)) - 1)


def enumerate_minimum_transversals(
    edges: tuple[int, ...], helpers: tuple[int, ...], optimum: int
) -> tuple[int, ...]:
    answer = []
    for chosen in combinations(helpers, optimum):
        candidate = mask(chosen)
        if all(candidate & edge for edge in edges):
            answer.append(candidate)
    return tuple(answer)


def canonical_matching(family: tuple[int, ...], group) -> tuple[int, ...]:
    return min(tuple(sorted(transform_mask(edge, g) for edge in family)) for g in group)


def canonical_set(chosen: int, group) -> int:
    return min(transform_mask(chosen, g) for g in group)


def orbit_table(objects, canonicalizer) -> list[tuple[object, int]]:
    table: Counter = Counter(canonicalizer(item) for item in objects)
    return sorted(table.items())


def fixed_matching_count(
    edges: tuple[int, ...], universe: int, optimum: int, permutation: tuple[int, ...]
) -> int:
    """Count invariant optimum matchings as packings of cyclic edge-orbit items."""

    unseen = set(edges)
    items: list[tuple[int, int]] = []
    while unseen:
        edge = min(unseen)
        orbit = []
        image = edge
        while image not in orbit:
            orbit.append(image)
            image = transform_mask(image, permutation)
        assert image == edge
        unseen.difference_update(orbit)
        union = 0
        internally_disjoint = True
        for member in orbit:
            if union & member:
                internally_disjoint = False
            union |= member
        if internally_disjoint and len(orbit) <= optimum:
            items.append((union, len(orbit)))
    incident = [[] for _ in range(20)]
    for union, weight in items:
        for vertex in mask_items(union):
            incident[vertex].append((union, weight))

    @lru_cache(None)
    def solve(available: int) -> tuple[int, ...]:
        active = 0
        for union, _ in items:
            if union & ~available == 0:
                active |= union
        if active == 0:
            return (1,) + (0,) * optimum
        vertex = (active & -active).bit_length() - 1
        counts = list(solve(available ^ (1 << vertex)))
        for union, weight in incident[vertex]:
            if union & ~available:
                continue
            subcounts = solve(available & ~union)
            for size in range(optimum - weight + 1):
                counts[size + weight] += subcounts[size]
        return tuple(counts)

    return solve(universe)[optimum]


def burnside_matching_certificate(edges, universe, optimum, group) -> dict:
    fixed_counts = [fixed_matching_count(edges, universe, optimum, g) for g in group]
    assert sum(fixed_counts) % len(group) == 0
    return {
        "fixed_count_distribution": {
            str(fixed): multiplicity for fixed, multiplicity in sorted(Counter(fixed_counts).items())
        },
        "orbit_count": sum(fixed_counts) // len(group),
    }


def labels_for_mask(value: int, labels: list[str]) -> list[str]:
    return [labels[item] for item in mask_items(value)]


def matching_orbits_json(table, labels: list[str]) -> list[dict]:
    return [
        {
            "orbit_size": orbit_size,
            "representative": [labels_for_mask(edge, labels) for edge in family],
        }
        for family, orbit_size in table
    ]


def transversal_orbits_json(table, labels: list[str]) -> list[dict]:
    return [
        {"orbit_size": orbit_size, "representative": labels_for_mask(chosen, labels)}
        for chosen, orbit_size in table
    ]


def write_lp(path: Path, edges: tuple[int, ...], helpers: tuple[int, ...], kind: str) -> None:
    """Emit a conventional binary ILP for external replay, without requiring a solver here."""

    lines = ["Maximize" if kind == "matching" else "Minimize"]
    variables = [f"x_{index}" for index in range(len(edges))] if kind == "matching" else [
        f"x_{vertex}" for vertex in helpers
    ]
    lines.append(" obj: " + " + ".join(variables))
    lines.append("Subject To")
    if kind == "matching":
        for vertex in helpers:
            terms = [f"x_{index}" for index, edge in enumerate(edges) if edge & (1 << vertex)]
            if terms:
                lines.append(f" vertex_{vertex}: " + " + ".join(terms) + " <= 1")
    else:
        for index, edge in enumerate(edges):
            terms = [f"x_{vertex}" for vertex in helpers if edge & (1 << vertex)]
            lines.append(f" edge_{index}: " + " + ".join(terms) + " >= 1")
    lines.append("Binary")
    lines.extend(f" {variable}" for variable in variables)
    lines.append("End")
    path.write_text("\n".join(lines) + "\n")


def small_field_control(verifier, field) -> dict:
    """Run the same orbit census at q=3 as a boundary and persistence control."""

    points, labels = verifier.completed_points(field)
    circuits = tuple(verifier.minimal_circuits_up_to_five(field, points))
    group = completed_pgl_group(field, circuits, pgl_cubic_permutations(field))
    q = field.q
    answer = {}
    for target, name in ((q, "cubic_infinity"), (2 * q + 1, "axis_infinity")):
        helpers = tuple(item for item in range(len(points)) if item != target)
        universe = mask(helpers)
        stabilizer = tuple(g for g in group if g[target] == target)
        radii = {}
        for radius in (3, 4):
            edges = repair_edges(circuits, target, radius)
            matching_optimum, matching_count = matching_optimum_and_count(edges, universe)
            cover_optimum = transversal_optimum(edges)
            transversals = enumerate_minimum_transversals(edges, helpers, cover_optimum)
            radii[str(radius)] = {
                "matching_optimum": matching_optimum,
                "matching_extremizer_count": matching_count,
                "matching_orbit_count": burnside_matching_certificate(
                    edges, universe, matching_optimum, stabilizer
                )["orbit_count"],
                "transversal_optimum": cover_optimum,
                "transversal_extremizer_count": len(transversals),
                "transversal_orbit_count": len(orbit_table(
                    transversals, lambda chosen: canonical_set(chosen, stabilizer)
                )),
            }
        answer[name] = {"label": labels[target], "radii": radii}
    return {"q": q, "pgl_order": len(group), "targets": answer}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--write-lp", type=Path)
    args = parser.parse_args()

    verifier = load_verifier()
    field = verifier.FIELDS[1]
    assert field.q == 9
    points, labels = verifier.completed_points(field)
    circuits = tuple(verifier.minimal_circuits_up_to_five(field, points))
    cubic_group = pgl_cubic_permutations(field)
    group = completed_pgl_group(field, circuits, cubic_group)
    circuit_masks = {mask(circuit) for circuit in circuits}
    assert all(
        {transform_mask(circuit, permutation) for circuit in circuit_masks} == circuit_masks
        for permutation in group
    )
    q = field.q
    targets = ((q, "cubic_infinity"), (2 * q + 1, "axis_infinity"))
    certificate = {
        "task": "C202",
        "q": q,
        "field_encoding": "GF(3)[x]/(x^2+1), base-3 coefficient encoding",
        "verifier_sha256": hashlib.sha256(VERIFIER.read_bytes()).hexdigest(),
        "circuit_count_by_size": {
            str(size): sum(len(circuit) == size for circuit in circuits) for size in range(3, 6)
        },
        "pgl_order": len(group),
        "q3_boundary_control": small_field_control(verifier, verifier.FIELDS[0]),
        "targets": {},
    }
    if args.write_lp:
        args.write_lp.mkdir(parents=True, exist_ok=True)

    for target, target_name in targets:
        helpers = tuple(item for item in range(len(points)) if item != target)
        universe = mask(helpers)
        stabilizer = tuple(g for g in group if g[target] == target)
        assert len(stabilizer) == q * (q - 1)
        target_json = {"label": labels[target], "stabilizer_order": len(stabilizer), "radii": {}}
        for radius in (3, 4):
            edges = repair_edges(circuits, target, radius)
            matching_optimum, matching_count = matching_optimum_and_count(edges, universe)
            cover_optimum = transversal_optimum(edges)
            assert verifier.matching_number(edges, universe) == matching_optimum
            assert verifier.transversal_number(edges) == cover_optimum
            transversals = enumerate_minimum_transversals(edges, helpers, cover_optimum)
            transversal_table = orbit_table(
                transversals, lambda chosen: canonical_set(chosen, stabilizer)
            )
            burnside = burnside_matching_certificate(
                edges, universe, matching_optimum, stabilizer
            )
            radius_json = {
                "edge_count": len(edges),
                "edge_count_by_size": {
                    str(size): sum(edge.bit_count() == size for edge in edges)
                    for size in range(2, 5)
                },
                "matching": {
                    "optimum": matching_optimum,
                    "extremizer_count": matching_count,
                    **burnside,
                },
                "transversal": {
                    "optimum": cover_optimum,
                    "extremizer_count": len(transversals),
                    "orbit_count": len(transversal_table),
                    "orbits": transversal_orbits_json(transversal_table, labels),
                },
            }
            if matching_count <= 10_000:
                matchings = enumerate_maximum_matchings(edges, universe, matching_optimum)
                assert len(matchings) == matching_count
                matching_table = orbit_table(
                    matchings, lambda family: canonical_matching(family, stabilizer)
                )
                assert len(matching_table) == burnside["orbit_count"]
                radius_json["matching"]["orbits"] = matching_orbits_json(matching_table, labels)
            else:
                radius_json["matching"]["orbits"] = None
                radius_json["matching"]["representatives_omitted"] = (
                    "Exact Burnside census retained; materializing this many orbit representatives "
                    "is not a useful bounded structural classification."
                )
            target_json["radii"][str(radius)] = radius_json
            if args.write_lp:
                stem = f"q9-{target_name}-radius{radius}"
                write_lp(args.write_lp / f"{stem}-matching.lp", edges, helpers, "matching")
                write_lp(args.write_lp / f"{stem}-transversal.lp", edges, helpers, "transversal")
        certificate["targets"][target_name] = target_json

    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
