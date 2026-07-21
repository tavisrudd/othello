#!/usr/bin/env python3
"""Exact continuation gates for the post-C438 Klein/Mathieu bridge."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
STEM = "2026-07-20-c438-continuation-mathieu-gate"
OUT = ROOT / "notes" / f"{STEM}.json"
INPUT = ROOT / "notes" / "2026-07-19-c379-clebsch-deep-hole-extension.json"
INPUT_SHA256 = "3cc3a7008d91a06f95504cbced7adc2eef9b304355a3a56bb64bdd0bea19ad8d"
C405_INPUT = ROOT / "notes" / "2026-07-20-c405-twisted-cubic-deep-hole-pilot.json"
C405_INPUT_SHA256 = "c1d9a0e11b7890c415a18c49a989301101784ae3b4d9931be59a15820c5df692"
Q = 11
INF = 11
OMEGA = tuple(range(12))


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inverse(x: int) -> int:
    return pow(x, -1, Q)


def canonical(matrix: tuple[int, int, int, int]) -> tuple[int, int, int, int]:
    for entry in matrix:
        if entry:
            scale = inverse(entry)
            return tuple(scale * x % Q for x in matrix)
    raise ValueError("zero matrix")


def multiply(left, right):
    a, b, c, d = left
    e, f, g, h = right
    return canonical(
        ((a * e + b * g) % Q, (a * f + b * h) % Q,
         (c * e + d * g) % Q, (c * f + d * h) % Q)
    )


def determinant(matrix) -> int:
    a, b, c, d = matrix
    return (a * d - b * c) % Q


def mobius(matrix, x: int) -> int:
    a, b, c, d = matrix
    if x == INF:
        return INF if c == 0 else a * inverse(c) % Q
    denominator = (c * x + d) % Q
    return INF if denominator == 0 else (a * x + b) * inverse(denominator) % Q


def generated_group(generators):
    identity = canonical((1, 0, 0, 1))
    group = {identity}
    queue = [identity]
    while queue:
        left = queue.pop()
        for right in generators:
            value = multiply(left, right)
            if value not in group:
                group.add(value)
                queue.append(value)
    return group


def conic_parameter(point) -> int:
    """Pencil coordinate on x^2+y^2+z^2=0 based at (1,1,3).

    The base point receives the tangent-line parameter 8.
    """
    x, y, z = point
    numerator = (y - x) % Q
    denominator = (z - 3 * x) % Q
    if numerator == denominator == 0:
        return 8
    return INF if denominator == 0 else numerator * inverse(denominator) % Q


def f9_add(x: int, y: int) -> int:
    return ((x % 3 + y % 3) % 3) + 3 * (((x // 3) + (y // 3)) % 3)


def f9_mul(x: int, y: int) -> int:
    a, b = x % 3, x // 3
    c, d = y % 3, y // 3
    return ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)


def f9_neg(x: int) -> int:
    return ((-x % 3) % 3) + 3 * ((-(x // 3)) % 3)


def f9_sub(x: int, y: int) -> int:
    return f9_add(x, f9_neg(y))


def f9_pow(x: int, exponent: int) -> int:
    answer = 1
    while exponent:
        if exponent & 1:
            answer = f9_mul(answer, x)
        x = f9_mul(x, x)
        exponent >>= 1
    return answer


def f9_normalize(vector):
    leading = next(x for x in vector if x)
    scale = f9_pow(leading, 7)
    return tuple(f9_mul(scale, x) for x in vector)


def f9_dot(left, right):
    total = 0
    for x, y in zip(left, right):
        total = f9_add(total, f9_mul(x, y))
    return total


def f9_transpose(matrix):
    return tuple(tuple(matrix[i][j] for i in range(len(matrix))) for j in range(len(matrix[0])))


def f9_mat_vec(matrix, vector):
    return tuple(f9_dot(row, vector) for row in matrix)


def f9_mat_mul(left, right):
    return tuple(tuple(f9_dot(row, column) for column in f9_transpose(right)) for row in left)


def f9_rref(matrix):
    answer = [list(row) for row in matrix]
    pivots = []
    row = 0
    for column in range(len(answer[0])):
        pivot = next((i for i in range(row, len(answer)) if answer[i][column]), None)
        if pivot is None:
            continue
        answer[row], answer[pivot] = answer[pivot], answer[row]
        scale = f9_pow(answer[row][column], 7)
        answer[row] = [f9_mul(scale, x) for x in answer[row]]
        for other in range(len(answer)):
            if other == row:
                continue
            multiple = answer[other][column]
            answer[other] = [f9_sub(x, f9_mul(multiple, y)) for x, y in zip(answer[other], answer[row])]
        pivots.append(column)
        row += 1
        if row == len(answer):
            break
    return answer, tuple(pivots)


def f9_inverse_matrix(matrix):
    size = len(matrix)
    augmented = [list(matrix[i]) + [int(i == j) for j in range(size)] for i in range(size)]
    reduced, pivots = f9_rref(augmented)
    assert pivots[:size] == tuple(range(size))
    return tuple(tuple(row[size:]) for row in reduced)


def f9_frame_map(source, target):
    dimension = len(source[0])
    assert len(source) == len(target) == dimension + 1
    source_columns = f9_transpose(source[:dimension])
    target_columns = f9_transpose(target[:dimension])
    if len(f9_rref(source_columns)[1]) != dimension or len(f9_rref(target_columns)[1]) != dimension:
        return None
    source_inverse = f9_inverse_matrix(source_columns)
    target_inverse = f9_inverse_matrix(target_columns)
    source_last = f9_mat_vec(source_inverse, source[-1])
    target_last = f9_mat_vec(target_inverse, target[-1])
    if not all(source_last) or not all(target_last):
        return None
    diagonal = tuple(f9_mul(target_last[i], f9_pow(source_last[i], 7)) for i in range(dimension))
    scaled_target = tuple(
        tuple(f9_mul(target_columns[row][column], diagonal[column]) for column in range(dimension))
        for row in range(dimension)
    )
    matrix = f9_mat_mul(scaled_target, source_inverse)
    leading = next(x for row in matrix for x in row if x)
    scale = f9_pow(leading, 7)
    return tuple(tuple(f9_mul(scale, x) for x in row) for row in matrix)


def f9_apply(matrix, point):
    return f9_normalize(f9_mat_vec(matrix, point))


def projective_stabilizer_order(points):
    points = tuple(points)
    point_set = set(points)
    source = next(frame for frame in itertools.permutations(points, 4) if f9_frame_map(frame, frame) is not None)
    matrices = set()
    for target in itertools.permutations(points, 4):
        matrix = f9_frame_map(source, target)
        if matrix is not None and {f9_apply(matrix, point) for point in points} == point_set:
            matrices.add(matrix)
    return len(matrices)


def q9_deletion_gate(c405):
    row = next(row for row in c405["rows"] if row["q"] == 9)
    octad = [tuple(point) for point in row["near_misses"][0]["locus"]]
    mark = octad[0]
    assert mark[0] == 1 and all(point[0] == 1 for point in octad)
    heptad = []
    for point in octad[1:]:
        image = tuple(f9_sub(point[i], f9_mul(mark[i], point[0])) for i in range(1, 4))
        heptad.append(f9_normalize(image))
    assert len(set(heptad)) == 7
    heptad_order = projective_stabilizer_order(heptad)
    deletion_orders = [projective_stabilizer_order(heptad[:i] + heptad[i + 1:]) for i in range(7)]
    assert heptad_order == 21 and deletion_orders == [3] * 7
    return heptad, heptad_order, deletion_orders


def f9_projective_points():
    for vector in itertools.product(range(9), repeat=3):
        if vector != (0, 0, 0) and f9_normalize(vector) == vector:
            yield vector


def count_q9_curves():
    hermitian = ((0, 6, 3), (3, 0, 5), (6, 8, 0))

    def hermitian_value(v):
        total = 0
        for i in range(3):
            for j in range(3):
                total = f9_add(total, f9_mul(f9_mul(f9_pow(v[i], 3), hermitian[i][j]), v[j]))
        return total

    def klein_value(v):
        x, y, z = v
        return f9_add(
            f9_add(f9_mul(f9_pow(x, 3), y), f9_mul(f9_pow(y, 3), z)),
            f9_mul(f9_pow(z, 3), x),
        )

    points = tuple(f9_projective_points())
    return sum(hermitian_value(v) == 0 for v in points), sum(klein_value(v) == 0 for v in points)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    assert digest(INPUT) == INPUT_SHA256
    assert digest(C405_INPUT) == C405_INPUT_SHA256
    frozen = json.loads(INPUT.read_text())
    c405 = json.loads(C405_INPUT.read_text())

    psl = generated_group(((1, 1, 0, 1), (0, 10, 1, 0)))
    assert len(psl) == 660
    psl_permutations = {tuple(mobius(g, x) for x in OMEGA) for g in psl}

    unseen = {frozenset(block) for block in itertools.combinations(OMEGA, 6)}
    orbits = []
    while unseen:
        seed = next(iter(unseen))
        orbit = {frozenset(permutation[x] for x in seed) for permutation in psl_permutations}
        unseen -= orbit
        orbits.append(orbit)
    assert sorted(map(len, orbits)) == [110, 110, 110, 132, 132, 330]

    designs = []
    for orbit in orbits:
        five_counts = Counter(
            subset for block in orbit for subset in itertools.combinations(sorted(block), 5)
        )
        if len(orbit) == 132 and len(five_counts) == 792 and set(five_counts.values()) == {1}:
            designs.append(orbit)
    assert len(designs) == 2
    assert all({frozenset(OMEGA) - block for block in design} == design for design in designs)

    outer = canonical((2, 0, 0, 1))
    assert determinant(outer) not in {1, 3, 4, 5, 9}
    outer_permutation = tuple(mobius(outer, x) for x in OMEGA)
    assert {frozenset(outer_permutation[x] for x in block) for block in designs[0]} == designs[1]

    conic_points = frozen["deep_hole_conic"]
    assert sorted(conic_parameter(point) for point in conic_points) == list(OMEGA)
    sheets = frozen["one_factorization_biplane"]
    profiles = {}
    for sheet_name in ("tau8_sheet_matchings", "tau4_sheet_matchings"):
        sheet_profiles = []
        for matching in sheets[sheet_name]:
            edges = [frozenset(conic_parameter(point) for point in edge) for edge in matching]
            design_profiles = []
            for design in designs:
                transversal_count = sum(
                    all(len(block & edge) == 1 for edge in edges) for block in design
                )
                three_edge_unions = sum(
                    block == frozenset().union(*chosen)
                    for block in design
                    for chosen in itertools.combinations(edges, 3)
                )
                edge_profile = Counter(sum(edge <= block for edge in edges) for block in design)
                design_profiles.append(
                    {
                        "transversal_hexads": transversal_count,
                        "three_edge_union_hexads": three_edge_unions,
                        "contained_matching_edge_profile": dict(sorted(edge_profile.items())),
                    }
                )
            sheet_profiles.append(design_profiles)
        assert all(value == sheet_profiles[0] for value in sheet_profiles)
        profiles[sheet_name] = sheet_profiles[0]

    hermitian_points, klein_points = count_q9_curves()
    assert (hermitian_points, klein_points) == (28, 10)
    heptad, heptad_order, deletion_orders = q9_deletion_gate(c405)
    result = {
        "schema": "c438-continuation-mathieu-gate-v1",
        "trusted_inputs": [
            {"path": str(INPUT.relative_to(ROOT)), "sha256": INPUT_SHA256},
            {"path": str(C405_INPUT.relative_to(ROOT)), "sha256": C405_INPUT_SHA256},
        ],
        "q9_klein_twist_gate": {
            "frozen_hermitian_F9_points": hermitian_points,
            "standard_klein_reduction_F9_points": klein_points,
            "F9_isomorphic": False,
            "reason": "different rational point counts",
        },
        "q9_e7_to_e6_deletion_gate": {
            "projected_aronhold_heptad": [list(point) for point in heptad],
            "heptad_projective_stabilizer_order": heptad_order,
            "six_point_deletion_stabilizer_orders": deletion_orders,
            "clebsch_A5_order": 60,
            "special_clebsch_identification": False,
        },
        "q11_witt_gate": {
            "psl2_11_order": len(psl),
            "six_subset_orbit_sizes": sorted(map(len, orbits)),
            "psl_invariant_W12_designs": len(designs),
            "blocks_per_design": [len(design) for design in designs],
            "each_five_subset_occurs_once": True,
            "each_design_closed_under_complement": True,
            "outer_pgl_element_exchanges_designs": True,
            "matching_profiles": profiles,
        },
        "disposition": {
            "mathieu_host": "positive",
            "canonical_parent_recovery": "negative: profiles are identical on all 22 matchings",
            "new_orientation_torsor": "two PSL2(11)-invariant Witt designs exchanged by PGL2(11)",
        },
    }
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered
        print(f"checked {OUT.relative_to(ROOT)}")
    else:
        OUT.write_text(rendered)
        print(f"wrote {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
