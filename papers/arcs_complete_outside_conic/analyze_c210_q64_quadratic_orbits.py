#!/usr/bin/env python3
"""Recognize conic-stabilizer orbits of the C210 q=64 quadratic repairs."""

from __future__ import annotations

import itertools
import json
from pathlib import Path
from math import comb

from probe_c210_two_layer_parabolas import (
    QuadraticField,
    covered_points,
    layer,
    projective_points,
)

Point = tuple[int, int, int]
Matrix2 = tuple[int, int, int, int]


def pgl2_representatives(field: QuadraticField) -> list[Matrix2]:
    """Canonical projective representatives of PGL(2,q)."""
    q = field.q
    matrices = []
    for b in range(q):
        for c in range(q):
            bc = field.mul(b, c)
            for d in range(q):
                if field.add(d, bc) != 0:  # det [[1,b],[c,d]] in characteristic two
                    matrices.append((1, b, c, d))
    for c in range(1, q):
        for d in range(q):
            matrices.append((0, 1, c, d))
    assert len(matrices) == q * (q * q - 1)
    return matrices


def frobenius_point(field: QuadraticField, point: Point, exponent: int) -> Point:
    return tuple(field.power(x, exponent) for x in point)  # type: ignore[return-value]


def symmetric_square_image(field: QuadraticField, matrix: Matrix2, point: Point) -> Point:
    """Apply Sym^2(matrix) to [X:Y:Z] in characteristic two."""
    a, b, c, d = matrix
    X, Y, Z = point
    determinant = field.add(field.mul(a, d), field.mul(b, c))
    image = (
        field.add(field.mul(field.mul(a, a), X), field.mul(field.mul(b, b), Z)),
        field.add(
            field.add(field.mul(field.mul(a, c), X), field.mul(determinant, Y)),
            field.mul(field.mul(b, d), Z),
        ),
        field.add(field.mul(field.mul(c, c), X), field.mul(field.mul(d, d), Z)),
    )
    return field.normalize(image)


def semilinear_image(field: QuadraticField, matrix: Matrix2,
                     frobenius_exponent: int, point: Point) -> Point:
    return symmetric_square_image(
        field, matrix, frobenius_point(field, point, frobenius_exponent)
    )


def repair_points(field: QuadraticField, subfield: tuple[int, ...],
                  eta: int, a: int, b: int, c: int) -> frozenset[Point]:
    points = []
    for r in subfield:
        y = field.add(eta, r)
        height = field.add(
            field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)), c
        )
        points.append((1, y, field.add(field.mul(y, y), height)))
    return frozenset(points)


def components(adjacency: list[set[int]]) -> list[list[int]]:
    unseen = set(range(len(adjacency)))
    out = []
    while unseen:
        root = min(unseen)
        stack = [root]
        component = set()
        while stack:
            vertex = stack.pop()
            if vertex in component:
                continue
            component.add(vertex)
            stack.extend(adjacency[vertex] - component)
        unseen -= component
        out.append(sorted(component))
    return out


def main() -> None:
    field = QuadraticField.for_subfield_order(8)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    output_path = Path(__file__).with_name("probe_c210_quadratic_coset_repairs_output.txt")
    record = json.loads(output_path.read_text().splitlines()[-1])
    alpha, beta = record["seed_offsets"]
    raw_survivors = [row[:4] for row in record["nonlinear_legal_parameters"]]
    seed = frozenset(layer(field, alpha, subfield) + layer(field, beta, subfield))
    repairs = [repair_points(field, subfield, *row) for row in raw_survivors]
    arcs = [seed | repair for repair in repairs]
    assert all(len(arc) == 24 for arc in arcs)
    arc_index = {arc: i for i, arc in enumerate(arcs)}
    assert len(arc_index) == len(arcs)

    matrices = pgl2_representatives(field)
    stabilizer = []
    projective_stabilizer = 0
    for frobenius_exponent in (1, 2, 4, 8, 16, 32):
        source_seed = tuple(
            frobenius_point(field, point, frobenius_exponent) for point in seed
        )
        for matrix in matrices:
            if all(symmetric_square_image(field, matrix, point) in seed
                   for point in source_seed):
                stabilizer.append((frobenius_exponent, matrix))
                if frobenius_exponent == 1:
                    projective_stabilizer += 1

    adjacency = [set([i]) for i in range(len(arcs))]
    recognized_images = 0
    action_rows = []
    for frobenius_exponent, matrix in stabilizer:
        permutation = []
        for arc in arcs:
            image = frozenset(
                semilinear_image(field, matrix, frobenius_exponent, point)
                for point in arc
            )
            target = arc_index.get(image)
            permutation.append(target)
            if target is not None:
                recognized_images += 1
        if any(target is not None and target != i for i, target in enumerate(permutation)):
            action_rows.append({
                "frobenius_exponent": frobenius_exponent,
                "matrix": list(matrix),
                "survivor_images": permutation,
            })
        for i, target in enumerate(permutation):
            if target is not None:
                adjacency[i].add(target)
                adjacency[target].add(i)

    survivor_orbits = components(adjacency)
    all_points = projective_points(field)
    uncovered_profiles = []
    orbit_invariants = []
    for orbit in survivor_orbits:
        representative = orbit[0]
        eta, a, b, c = raw_survivors[representative]
        assert all(raw_survivors[i][:3] == [eta, a, b] for i in orbit)
        c_values = sorted(raw_survivors[i][3] for i in orbit)
        translation_c_values = sorted({
            field.add(
                c,
                field.add(field.mul(a, field.mul(d, d)), field.mul(b, d)),
            )
            for d in subfield
        })
        assert c_values == translation_c_values
        ratio = field.div(a, b)
        assert field.in_subfield(ratio)
        orbit_invariants.append({
            "orbit": orbit,
            "a_times_b": field.mul(a, b),
            "a_over_b": ratio,
            "trace_eta": field.add(eta, field.power(eta, 8)),
            "translation_c_values": c_values,
        })
        uncovered = all_points - covered_points(field, tuple(arcs[representative]))
        affine_uncovered = sorted(point for point in uncovered if point[0] != 0)
        infinity_uncovered = sorted(point for point in uncovered if point[0] == 0)
        assert not affine_uncovered
        assert len(infinity_uncovered) == 19
        completed = tuple(arcs[representative]) + tuple(infinity_uncovered[:2])
        completed_lines = {
            field.cross(x, y) for x, y in itertools.combinations(completed, 2)
        }
        assert len(completed_lines) == comb(len(completed), 2)
        assert not (all_points - covered_points(field, completed))
        uncovered_profiles.append({
            "orbit": orbit,
            "representative": raw_survivors[representative],
            "affine_uncovered": affine_uncovered,
            "infinity_uncovered": [list(point) for point in infinity_uncovered],
            "two_direction_completion_size": len(completed),
        })

    print(json.dumps({
        "q": field.q,
        "seed_offsets": [alpha, beta],
        "survivors": raw_survivors,
        "pgl2_size": len(matrices),
        "projective_seed_stabilizer_size": projective_stabilizer,
        "semilinear_seed_stabilizer_size": len(stabilizer),
        "recognized_survivor_images": recognized_images,
        "survivor_orbits": survivor_orbits,
        "orbit_invariants": orbit_invariants,
        "uncovered_profiles": uncovered_profiles,
        "nontrivial_actions": action_rows,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
