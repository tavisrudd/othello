#!/usr/bin/env python3
"""Exact q=11 Stage-T1 restriction of tautological Fourier to the common A4."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-20-c414-exceptional-twisted-fourier.json"
C341_PATH = ROOT / "2026-07-18-c341-a5-subgroup-decoder.py"
C341_SHA256 = "4419cf398eae700b54e79b8b3ffe237d9ae2ddcefe496fcdadecfc78dddfa5be"
Q = 11
ORDER = Q - 1
GENERATOR = 2
PHI10 = (1, -1, 1, -1, 1)
DEGREE = 4
J = ((1, 0, 0), (0, 0, 10), (0, 10, 0))
ZERO = (0, 0, 0, 0)
ONE = (1, 0, 0, 0)


def load_c341():
    assert hashlib.sha256(C341_PATH.read_bytes()).hexdigest() == C341_SHA256
    spec = importlib.util.spec_from_file_location("c341_for_c414_t1", C341_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def canonical_bytes(value: object) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def reduce_poly(coefficients) -> tuple[int, int, int, int]:
    work = list(coefficients) + [0] * max(0, DEGREE + 1 - len(coefficients))
    for current in range(len(work) - 1, DEGREE - 1, -1):
        leading = work[current]
        if not leading:
            continue
        offset = current - DEGREE
        for index, coefficient in enumerate(PHI10):
            work[offset + index] -= leading * coefficient
    return tuple(work[:DEGREE])


ROOTS = tuple(reduce_poly([0] * exponent + [1]) for exponent in range(ORDER))


def add(left, right):
    return tuple(x + y for x, y in zip(left, right))


def neg(value):
    return tuple(-x for x in value)


def multiply(left, right):
    raw = [0] * (2 * DEGREE - 1)
    for i, x in enumerate(left):
        for j, y in enumerate(right):
            raw[i + j] += x * y
    return reduce_poly(raw)


def scale(integer, value):
    return tuple(integer * x for x in value)


def matrix_product(left, right):
    return [
        [
            sum_cyclo(multiply(left[i][k], right[k][j]) for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def sum_cyclo(values):
    answer = ZERO
    for value in values:
        answer = add(answer, value)
    return answer


def projective_points(c341):
    return sorted(
        {
            c341.normalize(vector, Q)
            for vector in c341.all_vectors(Q)
            if vector != (0, 0, 0)
        }
    )


def pivot_scale(vector):
    return next(value for value in vector if value)


def logs():
    table = {pow(GENERATOR, exponent, Q): exponent for exponent in range(ORDER)}
    assert len(table) == ORDER
    return table


def projective_orbits(c341, group, points):
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {
            c341.normalize(c341.mat_vec(matrix, seed, Q), Q)
            for matrix in group
        }
        unseen -= orbit
        answer.append((seed, orbit))
    return sorted(answer, key=lambda item: (len(item[1]), item[0]))


def invariant_sections(c341, group, points, point_index, weight, log_table):
    surviving = []
    killed = []
    for seed, orbit in projective_orbits(c341, group, points):
        assigned = {}
        consistent = True
        for matrix in group:
            image = c341.mat_vec(matrix, seed, Q)
            target = c341.normalize(image, Q)
            exponent = (-weight * log_table[pivot_scale(image)]) % ORDER
            if target in assigned and assigned[target] != exponent:
                consistent = False
            assigned[target] = exponent
        assert set(assigned) == orbit
        if not consistent:
            killed.append({"seed": list(seed), "orbit_size": len(orbit)})
            continue
        section = [None] * len(points)
        for point, exponent in assigned.items():
            section[point_index[point]] = exponent
        assert section[point_index[seed]] == 0
        surviving.append(
            {
                "seed": seed,
                "orbit": orbit,
                "orbit_size": len(orbit),
                "section": section,
            }
        )
    return surviving, killed


def apply_group(c341, matrix, inverse, points, point_index, section, weight, log_table):
    answer = [None] * len(points)
    for index, point in enumerate(points):
        preimage = c341.mat_vec(inverse, point, Q)
        target = c341.normalize(preimage, Q)
        value = section[point_index[target]]
        if value is not None:
            answer[index] = (value + weight * log_table[pivot_scale(preimage)]) % ORDER
    return answer


def multiply_section_by_root(section, exponent):
    return [None if value is None else (value + exponent) % ORDER for value in section]


def verify_invariance(c341, group, points, point_index, records, weight, log_table):
    for matrix in group:
        inverse = c341.mat_inverse(matrix, Q)
        for record in records:
            assert apply_group(
                c341, matrix, inverse, points, point_index, record["section"], weight, log_table
            ) == record["section"]


def involution_action(c341, points, point_index, records, weight, log_table):
    support_index = {
        frozenset(record["orbit"]): index for index, record in enumerate(records)
    }
    actions = []
    for record in records:
        transformed = apply_group(c341, J, J, points, point_index, record["section"], weight, log_table)
        support = frozenset(points[i] for i, value in enumerate(transformed) if value is not None)
        target = support_index[support]
        target_record = records[target]
        coefficient = transformed[point_index[target_record["seed"]]]
        assert coefficient is not None
        assert transformed == multiply_section_by_root(target_record["section"], coefficient)
        actions.append((target, coefficient))
    for index, (target, coefficient) in enumerate(actions):
        back, back_coefficient = actions[target]
        assert back == index
        assert (coefficient + back_coefficient) % ORDER == 0
    return actions


def parity_basis(actions, parity):
    basis = []
    visited = set()
    for index, (target, coefficient) in enumerate(actions):
        if index in visited:
            continue
        visited |= {index, target}
        vector = [ZERO] * len(actions)
        if target == index:
            eigenvalue = 1 if coefficient == 0 else -1 if coefficient == ORDER // 2 else None
            assert eigenvalue is not None
            if eigenvalue == parity:
                vector[index] = ONE
                basis.append(vector)
            continue
        if index < target:
            vector[index] = ONE
            signed = ROOTS[coefficient] if parity == 1 else neg(ROOTS[coefficient])
            vector[target] = signed
            basis.append(vector)
    return basis


def apply_kernel(c341, points, section, weight, log_table):
    answer = []
    for target in points:
        value = ZERO
        for source, source_exponent in zip(points, section):
            if source_exponent is None:
                continue
            pairing = c341.dot(target, source, Q)
            if pairing:
                exponent = (source_exponent - weight * log_table[pairing]) % ORDER
                value = add(value, ROOTS[exponent])
        answer.append(value)
    return answer


def fourier_matrix(c341, points, point_index, source_records, target_records, weight, log_table):
    matrix = [[ZERO for _ in source_records] for _ in target_records]
    for column, source in enumerate(source_records):
        image = apply_kernel(c341, points, source["section"], weight, log_table)
        reconstructed = [ZERO] * len(points)
        for row, target in enumerate(target_records):
            coefficient = image[point_index[target["seed"]]]
            matrix[row][column] = coefficient
            for index, exponent in enumerate(target["section"]):
                if exponent is not None:
                    reconstructed[index] = multiply(coefficient, ROOTS[exponent])
        assert image == reconstructed
    return matrix


def coordinates_in_disjoint_basis(vector, basis):
    remainder = list(vector)
    coordinates = []
    for column in basis:
        pivot = next(index for index, value in enumerate(column) if value != ZERO)
        assert column[pivot] == ONE
        coefficient = remainder[pivot]
        coordinates.append(coefficient)
        remainder = [add(value, neg(multiply(coefficient, entry))) for value, entry in zip(remainder, column)]
    assert all(value == ZERO for value in remainder)
    return coordinates


def restrict_matrix(matrix, source_basis, target_basis):
    columns = []
    for source_vector in source_basis:
        image = [
            sum_cyclo(multiply(matrix[row][column], source_vector[column]) for column in range(len(source_vector)))
            for row in range(len(matrix))
        ]
        columns.append(coordinates_in_disjoint_basis(image, target_basis))
    return [[columns[column][row] for column in range(len(columns))] for row in range(len(target_basis))]


def section_hash(records):
    return hashlib.sha256(canonical_bytes([record["section"] for record in records])).hexdigest()


def matrix_negate(matrix):
    return tuple(tuple(-entry % Q for entry in row) for row in matrix)


def determinant(matrix):
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % Q


def matrix_order(c341, matrix):
    identity = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    power = identity
    for order in range(1, 25):
        power = c341.mat_mul(power, matrix, Q)
        if power == identity:
            return order
    raise AssertionError


def build():
    c341 = load_c341()
    plus = c341.reflection_group(Q, c341.h3_roots(Q, 8))
    minus = c341.reflection_group(Q, c341.h3_roots(Q, 4))
    common = plus & minus
    assert len(common) == 12
    identity = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    for matrix in common | {J}:
        transpose = tuple(zip(*matrix))
        assert c341.mat_mul(transpose, matrix, Q) == identity
    assert {
        c341.mat_normalize(c341.mat_mul(c341.mat_mul(J, matrix, Q), J, Q), Q)
        for matrix in common
    } == common

    # The normalized projective lifts have a nontrivial +/-I multiplication cocycle, but in odd
    # dimension determinant one gives the unique rotational A4 splitting.
    minus_identity = matrix_negate(identity)
    lift_group = common | {matrix_negate(matrix) for matrix in common}
    assert len(lift_group) == 24 and minus_identity in lift_group
    assert {
        c341.mat_mul(left, right, Q) for left in lift_group for right in lift_group
    } == lift_group
    lift_order_counts = {}
    for matrix in lift_group:
        order = matrix_order(c341, matrix)
        lift_order_counts[order] = lift_order_counts.get(order, 0) + 1
    assert lift_order_counts == {1: 1, 2: 7, 3: 8, 6: 8}
    negative_cocycle_products = 0
    for left in common:
        for right in common:
            raw = c341.mat_mul(left, right, Q)
            normalized = c341.mat_normalize(raw, Q)
            assert raw in {normalized, matrix_negate(normalized)}
            negative_cocycle_products += raw == matrix_negate(normalized)
    assert negative_cocycle_products
    rotation_group = {
        matrix if determinant(matrix) == 1 else matrix_negate(matrix) for matrix in common
    }
    assert len(rotation_group) == 12
    assert all(determinant(matrix) == 1 for matrix in rotation_group)
    assert {
        c341.mat_mul(left, right, Q) for left in rotation_group for right in rotation_group
    } == rotation_group
    rotation_order_counts = {}
    for matrix in rotation_group:
        order = matrix_order(c341, matrix)
        rotation_order_counts[order] = rotation_order_counts.get(order, 0) + 1
    assert rotation_order_counts == {1: 1, 2: 3, 3: 8}

    points = projective_points(c341)
    point_index = {point: index for index, point in enumerate(points)}
    log_table = logs()
    by_weight = {}
    for weight in (-1, 1, 4, 6):
        records, killed = invariant_sections(c341, rotation_group, points, point_index, weight, log_table)
        verify_invariance(c341, rotation_group, points, point_index, records, weight, log_table)
        actions = involution_action(c341, points, point_index, records, weight, log_table)
        even = parity_basis(actions, 1)
        odd = parity_basis(actions, -1)
        assert len(even) + len(odd) == len(records)
        by_weight[weight] = {
            "records": records,
            "killed": killed,
            "actions": actions,
            "even": even,
            "odd": odd,
        }

    def paired_blocks(source_weight, target_weight):
        source = by_weight[source_weight]
        target = by_weight[target_weight]
        forward = fourier_matrix(
            c341, points, point_index, source["records"], target["records"], source_weight, log_table
        )
        reverse = fourier_matrix(
            c341, points, point_index, target["records"], source["records"], target_weight, log_table
        )
        assert matrix_product(reverse, forward) == [
            [scale(Q * Q * int(i == j), ONE) for j in range(len(source["records"]))]
            for i in range(len(source["records"]))
        ]
        parity_blocks = {}
        for name in ("even", "odd"):
            forward_parity = restrict_matrix(forward, source[name], target[name])
            reverse_parity = restrict_matrix(reverse, target[name], source[name])
            assert matrix_product(reverse_parity, forward_parity) == [
                [scale(Q * Q * int(i == j), ONE) for j in range(len(source[name]))]
                for i in range(len(source[name]))
            ]
            parity_blocks[name] = {
                "dimension": len(source[name]),
                "forward": forward_parity,
                "reverse": reverse_parity,
            }
        return {
            "source_weight": source_weight % ORDER,
            "target_weight": target_weight % ORDER,
            "full_dimension": len(source["records"]),
            "forward": forward,
            "reverse": reverse,
            "parity_blocks": parity_blocks,
        }

    tautological = paired_blocks(-1, 1)
    factorization = paired_blocks(4, 6)

    def weight_record(weight):
        data = by_weight[weight]
        return {
            "weight": weight,
            "projective_orbit_count": len(data["records"]) + len(data["killed"]),
            "twisted_invariant_dimension": len(data["records"]),
            "surviving_orbit_sizes": sorted(record["orbit_size"] for record in data["records"]),
            "killed_orbit_sizes": sorted(record["orbit_size"] for record in data["killed"]),
            "J_even_dimension": len(data["even"]),
            "J_odd_dimension": len(data["odd"]),
            "section_basis_sha256": section_hash(data["records"]),
            "J_monomial_action": [list(action) for action in data["actions"]],
        }

    return {
        "schema": "c414-exceptional-twisted-fourier-v1",
        "field": Q,
        "multiplicative_generator": GENERATOR,
        "cyclotomic_basis": "1,zeta_10,zeta_10^2,zeta_10^3",
        "cyclotomic_polynomial_low_to_high": list(PHI10),
        "common_projective_group": "A4",
        "common_projective_group_order": len(common),
        "all_common_matrices_are_exactly_orthogonal": True,
        "J_normalizes_common_group_and_is_exactly_orthogonal": True,
        "projective_line_count": len(points),
        "projective_lift_cocycle": {
            "linear_lift_group_order": len(lift_group),
            "linear_lift_group_type": "A4 x C2",
            "element_order_counts": dict(sorted(lift_order_counts.items())),
            "negative_products_in_normalized_section": negative_cocycle_products,
            "extension_splits": True,
            "canonical_splitting": "unique determinant-one rotational lift",
            "rotation_group_order": len(rotation_group),
            "rotation_group_element_order_counts": dict(sorted(rotation_order_counts.items())),
            "odd_scalar_weights_require_the_determinant_one_splitting": True,
        },
        "weights": [weight_record(weight) for weight in (-1, 1, 4, 6)],
        "tautological_weight_pair": tautological,
        "factorization_weight_pair": factorization,
        "all_full_and_parity_reverse_compositions_equal_121_I": True,
        "verdict": (
            "THEOREM; DETERMINANT ONE CANONICALLY SPLITS THE PROJECTIVE A4 SCALAR COCYCLE; "
            "THE WEIGHT-4/6 A4-INVARIANT SECTORS HAVE FOUR-DIMENSIONAL J-ODD PARTS "
            "EXCHANGED BY AN EXACT INVERTIBLE TWISTED-FOURIER BLOCK"
        ),
        "boundary": (
            "No matching quotient/product section identity, ordinary M_odd comparison, q=7 analogue, "
            "modular reduction, geometric depth interpretation, or novelty claim is certified."
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    assert args.write ^ args.check, "choose exactly one of --write or --check"
    payload = canonical_bytes(build())
    if args.write:
        OUTPUT.write_bytes(payload)
    else:
        assert OUTPUT.read_bytes() == payload
    print("C414 q=11 exceptional twisted Fourier certificate OK")


if __name__ == "__main__":
    main()
