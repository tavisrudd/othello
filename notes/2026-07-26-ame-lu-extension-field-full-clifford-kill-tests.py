#!/usr/bin/env python3
"""Exact extension-field full-Clifford kill tests for the AME pencil."""

from __future__ import annotations

import argparse
import collections
import hashlib
import importlib.util
import itertools
import json
import sys
from pathlib import Path
from typing import Iterable, Sequence

HERE = Path(__file__).resolve().parent
INPUT = HERE / "2026-07-23-c396-holonomy-completeness.py"
INPUT_SHA256 = "b536913531c7393e92633b2c6521df50aa32a823a95cc4e92285a0955cc8fa49"
CERTIFICATE = HERE / "2026-07-26-ame-lu-extension-field-full-clifford-kill-tests.json"


def load_input():
    digest = hashlib.sha256(INPUT.read_bytes()).hexdigest()
    if digest != INPUT_SHA256:
        raise AssertionError(f"stale C396 input: {digest}")
    spec = importlib.util.spec_from_file_location("c396_extension_field_input", INPUT)
    if spec is None or spec.loader is None:
        raise AssertionError("cannot load C396 input")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


C396 = load_input()
FiniteField = C396.FiniteField
Element = tuple[int, ...]
Matrix = tuple[tuple[int, ...], ...]
N = 6


def canonical_json_bytes(value: object) -> bytes:
    return (json.dumps(value, sort_keys=True, separators=(",", ":")) + "\n").encode()


def admitted_parameters(field: FiniteField) -> list[Element]:
    quartic = (1, -4, 7, -4, 1)
    result = []
    for parameter in field.elements():
        points = C396.C395.ff_points(field, parameter)
        arc = all(
            C396.C395.ff_det3(
                field, tuple(points[index] for index in triple)
            )
            != field.zero
            for triple in itertools.combinations(range(N), 3)
        )
        grs = field.peval(quartic, parameter) == field.zero
        if arc and not grs:
            result.append(tuple(parameter))
    return result


def prime_characteristic_polynomial(
    field: FiniteField, first: Element, second: Element
) -> tuple[int, ...]:
    polynomial = [field.one]
    for eigenvalue in (first, second):
        for power in range(field.degree):
            root = field.pow(eigenvalue, field.p**power)
            product = [field.zero] * (len(polynomial) + 1)
            for index, coefficient in enumerate(polynomial):
                product[index] = field.sub(
                    product[index], field.mul(coefficient, root)
                )
                product[index + 1] = field.add(
                    product[index + 1], coefficient
                )
            polynomial = product
    if not all(all(coefficient == 0 for coefficient in value[1:]) for value in polynomial):
        raise AssertionError("restriction-of-scalars characteristic polynomial left F_p")
    return tuple(value[0] for value in polynomial)


def holonomy_pairs(field: FiniteField, parameter: Element) -> list[tuple[Element, Element]]:
    code = C396.code_from_points(
        field, C396.C395.ff_points(field, parameter)
    )
    data = C396.minimal_support_data(field, code)
    result = []
    for source, target in itertools.combinations(range(N), 2):
        supports = [
            support
            for support in sorted(data)
            if source in support and target in support
        ]
        for first, second in itertools.combinations(supports, 2):
            holonomy = C396.m2_mul(
                field,
                C396.relation(field, data, second, target, source),
                C396.relation(field, data, first, source, target),
            )
            for matrix in (holonomy, C396.m2_inv(field, holonomy)):
                result.append((matrix[0][0], matrix[1][1]))
    if len(result) != 450:
        raise AssertionError("holonomy count mismatch")
    return result


def prime_characteristic_signature(
    field: FiniteField, parameter: Element
) -> tuple[tuple[tuple[int, ...], int], ...]:
    counter = collections.Counter(
        prime_characteristic_polynomial(field, first, second)
        for first, second in holonomy_pairs(field, parameter)
    )
    return tuple(sorted(counter.items()))


def add_to_basis(vector: Sequence[int], basis: list[list[int]], p: int) -> bool:
    row = [value % p for value in vector]
    for pivot_row in basis:
        pivot = next(index for index, value in enumerate(pivot_row) if value)
        if row[pivot]:
            scale = row[pivot]
            row = [
                (value - scale * pivot_value) % p
                for value, pivot_value in zip(row, pivot_row)
            ]
    if not any(row):
        return False
    pivot = next(index for index, value in enumerate(row) if value)
    scale = pow(row[pivot], -1, p)
    row = [(scale * value) % p for value in row]
    for index, pivot_row in enumerate(basis):
        if pivot_row[pivot]:
            scale = pivot_row[pivot]
            basis[index] = [
                (value - scale * row_value) % p
                for value, row_value in zip(pivot_row, row)
            ]
    basis.append(row)
    basis.sort(key=lambda value: next(i for i, entry in enumerate(value) if entry))
    return True


def holonomy_algebra_dimension(
    field: FiniteField, pairs: Sequence[tuple[Element, Element]]
) -> int:
    unit = tuple(field.one) + tuple(field.one)
    basis: list[list[int]] = []
    add_to_basis(unit, basis, field.p)
    changed = True
    while changed:
        changed = False
        old_basis = [tuple(row) for row in basis]
        for row in old_basis:
            left = tuple(row[: field.degree])
            right = tuple(row[field.degree :])
            for first, second in pairs:
                product = tuple(field.mul(left, first)) + tuple(
                    field.mul(right, second)
                )
                changed = add_to_basis(product, basis, field.p) or changed
    return len(basis)


def frobenius_orbit_representative(field: FiniteField, value: Element) -> Element:
    return min(
        tuple(field.pow(value, field.p**power))
        for power in range(field.degree)
    )


def field_census(p: int, modulus: Sequence[int]) -> dict[str, object]:
    field = FiniteField(p, modulus)
    rows = []
    for parameter in admitted_parameters(field):
        z_value = tuple(C396.parameter_z(field, parameter))
        signature = prime_characteristic_signature(field, parameter)
        signature_json = [
            [list(polynomial), multiplicity]
            for polynomial, multiplicity in signature
        ]
        rows.append(
            {
                "parameter": list(parameter),
                "z": list(z_value),
                "z_orbit_representative": list(
                    frobenius_orbit_representative(field, z_value)
                ),
                "signature_sha256": hashlib.sha256(
                    canonical_json_bytes(signature_json)
                ).hexdigest(),
                "holonomy_algebra_dimension": holonomy_algebra_dimension(
                    field, holonomy_pairs(field, parameter)
                ),
            }
        )
    gal_partition = collections.defaultdict(list)
    signature_partition = collections.defaultdict(list)
    for row in rows:
        parameter = tuple(row["parameter"])
        gal_partition[tuple(row["z_orbit_representative"])].append(parameter)
        signature_partition[row["signature_sha256"]].append(parameter)
    gal_packets = sorted(tuple(sorted(packet)) for packet in gal_partition.values())
    signature_packets = sorted(
        tuple(sorted(packet)) for packet in signature_partition.values()
    )
    if gal_packets != signature_packets:
        raise AssertionError(f"Sigma_p and Gal(z) partitions differ over F_{field.order}")
    packet_rows = []
    for representative, parameters in sorted(gal_partition.items()):
        signature_hashes = {
            row["signature_sha256"]
            for row in rows
            if tuple(row["parameter"]) in parameters
        }
        if len(signature_hashes) != 1:
            raise AssertionError("one Galois packet has multiple signatures")
        packet_rows.append(
            {
                "z_orbit_representative": list(representative),
                "parameters": [list(parameter) for parameter in sorted(parameters)],
                "signature_sha256": next(iter(signature_hashes)),
            }
        )
    return {
        "q": field.order,
        "p": p,
        "degree": field.degree,
        "modulus_low_to_high": list(modulus),
        "admitted_parameter_count": len(rows),
        "classical_z_packet_count": len({tuple(row["z"]) for row in rows}),
        "galois_z_packet_count": len(gal_packets),
        "sigma_p_packet_count": len(signature_packets),
        "sigma_p_equals_galois_z_partition": True,
        "holonomy_algebra_dimension_histogram": {
            str(dimension): count
            for dimension, count in sorted(
                collections.Counter(
                    row["holonomy_algebra_dimension"] for row in rows
                ).items()
            )
        },
        "packets": packet_rows,
    }


def matrix_mul(left: Matrix, right: Matrix, p: int) -> Matrix:
    size = len(left)
    return tuple(
        tuple(
            sum(left[i][k] * right[k][j] for k in range(size)) % p
            for j in range(size)
        )
        for i in range(size)
    )


def matrix_transpose(matrix: Matrix) -> Matrix:
    return tuple(tuple(matrix[j][i] for j in range(len(matrix))) for i in range(len(matrix)))


def matrix_inverse(matrix: Matrix, p: int) -> Matrix:
    size = len(matrix)
    augmented = [
        list(matrix[i]) + [int(i == j) for j in range(size)]
        for i in range(size)
    ]
    for column in range(size):
        pivot = next(
            row
            for row in range(column, size)
            if augmented[row][column] % p
        )
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = pow(augmented[column][column] % p, -1, p)
        augmented[column] = [
            scale * value % p for value in augmented[column]
        ]
        for row in range(size):
            if row != column and augmented[row][column] % p:
                scale = augmented[row][column] % p
                augmented[row] = [
                    (value - scale * pivot_value) % p
                    for value, pivot_value in zip(
                        augmented[row], augmented[column]
                    )
                ]
    return tuple(tuple(row[size:]) for row in augmented)


def matrix_vector(matrix: Matrix, vector: Sequence[int], p: int) -> tuple[int, ...]:
    return tuple(
        sum(matrix[i][j] * vector[j] for j in range(len(vector))) % p
        for i in range(len(matrix))
    )


def bilinear(left: Sequence[int], form: Matrix, right: Sequence[int], p: int) -> int:
    return sum(
        left[i] * form[i][j] * right[j]
        for i in range(len(left))
        for j in range(len(right))
    ) % p


def multiplication_matrix(field: FiniteField, value: Element) -> Matrix:
    basis = [
        tuple(int(index == column) for index in range(field.degree))
        for column in range(field.degree)
    ]
    columns = [field.mul(value, basis_vector) for basis_vector in basis]
    return tuple(
        tuple(columns[column][row] for column in range(field.degree))
        for row in range(field.degree)
    )


def diagonal_multiplication_matrix(
    field: FiniteField, first: Element, second: Element
) -> Matrix:
    first_matrix = multiplication_matrix(field, first)
    second_matrix = multiplication_matrix(field, second)
    degree = field.degree
    return tuple(
        tuple(
            first_matrix[i][j]
            if i < degree and j < degree
            else second_matrix[i - degree][j - degree]
            if i >= degree and j >= degree
            else 0
            for j in range(2 * degree)
        )
        for i in range(2 * degree)
    )


def trace_to_prime(field: FiniteField, value: Element) -> int:
    result = field.zero
    for power in range(field.degree):
        result = field.add(result, field.pow(value, field.p**power))
    if any(result[1:]):
        raise AssertionError("field trace left the prime field")
    return result[0]


def q9_symplectic_form(field: FiniteField) -> Matrix:
    basis = [field.one, (field.zero[0], 1)]
    gram = tuple(
        tuple(trace_to_prime(field, field.mul(left, right)) for right in basis)
        for left in basis
    )
    degree = field.degree
    return tuple(
        tuple(
            0
            if (i < degree) == (j < degree)
            else gram[i % degree][j % degree]
            if i < degree
            else -gram[i % degree][j % degree] % field.p
            for j in range(2 * degree)
        )
        for i in range(2 * degree)
    )


def symplectic_matrices_dimension_four(form: Matrix, p: int) -> Iterable[Matrix]:
    vectors = [
        vector
        for vector in itertools.product(range(p), repeat=4)
        if any(vector)
    ]
    for first in vectors:
        for third in vectors:
            if bilinear(first, form, third, p) != form[0][2]:
                continue
            orthogonal = [
                vector
                for vector in vectors
                if bilinear(first, form, vector, p) == 0
                and bilinear(third, form, vector, p) == 0
            ]
            for second in orthogonal:
                for fourth in orthogonal:
                    if bilinear(second, form, fourth, p) != form[1][3]:
                        continue
                    columns = (first, second, third, fourth)
                    yield tuple(
                        tuple(columns[column][row] for column in range(4))
                        for row in range(4)
                    )


def q9_exotic_gauge_certificate() -> dict[str, object]:
    field = FiniteField(3, (1, 0, 1))
    parameter = (1, 1)
    code = C396.code_from_points(
        field, C396.C395.ff_points(field, parameter)
    )
    data = C396.minimal_support_data(field, code)
    form = q9_symplectic_form(field)
    identity = tuple(
        tuple(int(i == j) for j in range(4)) for i in range(4)
    )

    relations: dict[tuple[tuple[int, ...], int, int], Matrix] = {}
    for support in sorted(data):
        for source, target in itertools.permutations(support, 2):
            relation = C396.relation(
                field, data, support, source, target
            )
            relations[(support, source, target)] = diagonal_multiplication_matrix(
                field, relation[0][0], relation[1][1]
            )

    transport = [identity]
    for party in range(1, N):
        support = next(
            support for support in sorted(data) if 0 in support and party in support
        )
        transport.append(relations[(support, 0, party)])

    scalar_generator = diagonal_multiplication_matrix(
        field, (0, 1), (0, 1)
    )
    scalar_field = {
        diagonal_multiplication_matrix(field, value, value)
        for value in field.elements()
    }

    expected_base = (
        (2, 0, 1, 0),
        (0, 2, 0, 2),
        (2, 0, 0, 0),
        (0, 1, 0, 0),
    )
    compatible_count = 0
    semilinear_base_count = 0
    exotic_example: list[Matrix] | None = None
    sp_count = 0
    for base in symplectic_matrices_dimension_four(form, field.p):
        sp_count += 1
        local = [
            matrix_mul(
                matrix_mul(transport[party], base, field.p),
                matrix_inverse(transport[party], field.p),
                field.p,
            )
            for party in range(N)
        ]
        if not all(
            matrix_mul(
                matrix_mul(matrix_transpose(matrix), form, field.p),
                matrix,
                field.p,
            )
            == form
            for matrix in local
        ):
            continue
        compatible = True
        for support in sorted(data):
            source = support[0]
            for target in support[1:]:
                relation = relations[(support, source, target)]
                if matrix_mul(local[target], relation, field.p) != matrix_mul(
                    relation, local[source], field.p
                ):
                    compatible = False
                    break
            if not compatible:
                break
        if not compatible:
            continue
        compatible_count += 1
        conjugated_generator = matrix_mul(
            matrix_mul(base, scalar_generator, field.p),
            matrix_inverse(base, field.p),
            field.p,
        )
        is_standard_semilinear = conjugated_generator in scalar_field
        if is_standard_semilinear:
            semilinear_base_count += 1
        elif base == expected_base:
            exotic_example = local

    if sp_count != 51840:
        raise AssertionError(f"Sp_4(F_3) enumeration has size {sp_count}")
    if compatible_count != 96 or semilinear_base_count != 16:
        raise AssertionError(
            "q=9 gauge counts changed: "
            f"{compatible_count} compatible, {semilinear_base_count} semilinear"
        )
    if exotic_example is None:
        raise AssertionError("no exotic q=9 gauge found")
    if exotic_example[0] != expected_base:
        raise AssertionError("requested exotic example changed")
    return {
        "q": 9,
        "p": 3,
        "degree": 2,
        "modulus_low_to_high": [1, 0, 1],
        "parameter": list(parameter),
        "coordinate_order": ["x_0", "x_1", "z_0", "z_1"],
        "symplectic_form": [list(row) for row in form],
        "sp4_order_checked": sp_count,
        "identity_party_compatible_gauge_count": compatible_count,
        "standard_scalar_field_normalizer_base_count": semilinear_base_count,
        "exotic_base_count": compatible_count - semilinear_base_count,
        "canonical_exotic_local_blocks": [
            [list(row) for row in matrix] for matrix in exotic_example
        ],
    }


def generate_certificate() -> dict[str, object]:
    fields = [
        (3, (1, 0, 1)),
        (5, (3, 0, 1)),
        (3, (1, 2, 0, 1)),
        (7, (1, 0, 1)),
    ]
    return {
        "schema": "ame-lu-extension-field-full-clifford-kill-tests-v1",
        "input": {
            "path": INPUT.name,
            "sha256": INPUT_SHA256,
        },
        "sigma_p_definition": (
            "multiset of F_p-characteristic polynomials of the 450 oriented "
            "minimum-support holonomies, including each holonomy and its inverse"
        ),
        "q9_exotic_gauge": q9_exotic_gauge_certificate(),
        "field_censuses": [
            field_census(p, modulus) for p, modulus in fields
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--write",
        action="store_true",
        help="write the canonical JSON certificate",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="regenerate in memory and compare with the tracked certificate",
    )
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    generated = canonical_json_bytes(generate_certificate())
    if args.write:
        CERTIFICATE.write_bytes(generated)
        print(f"wrote {CERTIFICATE.name} ({len(generated)} bytes)")
        return
    expected = CERTIFICATE.read_bytes()
    if generated != expected:
        raise AssertionError(
            f"stale certificate: generated sha256={hashlib.sha256(generated).hexdigest()}, "
            f"tracked sha256={hashlib.sha256(expected).hexdigest()}"
        )
    print(
        f"PASS {CERTIFICATE.name} "
        f"sha256={hashlib.sha256(expected).hexdigest()} bytes={len(expected)}"
    )


if __name__ == "__main__":
    main()
