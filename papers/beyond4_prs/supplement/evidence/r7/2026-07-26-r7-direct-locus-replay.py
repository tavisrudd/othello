#!/usr/bin/env python3
"""Independent direct-locus replay for the bounded R7 classification.

This checker does not import the C509 generator or its affine-orbit quotient.
For q < 16 it constructs the infinity-pointed bad locus as the literal
complement of all four-finite-secant spans in PG(5,q).  For q >= 16 it
constructs the proved R6 pointed locus directly from the persistent
quadratic-recurrence locus, the marked secant star, and the binary nucleus
line, together with the transient marked orbit at q=19.  It transports that
locus to every marker, intersects the q+1 contraction conditions in PG(6,q),
rebuilds the PGL2 orbit partition, and compares the result with the public
Certificate R7 record.

The only imported executable code is the separately written R5 replay's
finite-field implementation.  No R7 generator, quotient representative,
stored orbit partition, or R7 certificate code is imported.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
if HERE.name == "r7" and HERE.parent.name == "evidence":
    SUPPLEMENT = HERE.parents[1]
else:
    SUPPLEMENT = HERE.parent / "papers" / "beyond4_prs" / "supplement"
R5_REPLAY = (
    SUPPLEMENT / "evidence" / "r5" /
    "2026-07-22-c491-prs-deep-hole-replay.py"
)
PUBLIC_RECORD = SUPPLEMENT / "CLASSIFICATION-RECORDS.json"
DEFAULT_CERTIFICATE = Path(__file__).with_suffix(".json")


def load_field_module():
    spec = importlib.util.spec_from_file_location("c545_r5_field", R5_REPLAY)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


R5 = load_field_module()


def field_pow(field, value, exponent):
    result = 1
    while exponent:
        if exponent & 1:
            result = field.mul(result, value)
        value = field.mul(value, value)
        exponent >>= 1
    return result


def primitive_element(field):
    for candidate in range(2, field.q):
        if len({field_pow(field, candidate, exponent)
                for exponent in range(field.q - 1)}) == field.q - 1:
            return candidate
    return 1


def canonical(field, vector):
    for entry in vector:
        if entry:
            inverse = field.inv(entry)
            return tuple(field.mul(inverse, value) for value in vector)
    return None


def encode(field, vector):
    code = 0
    for value in vector:
        code = code * field.q + value
    return code


def decode(field, code, length):
    vector = [0] * length
    for index in range(length - 1, -1, -1):
        vector[index] = code % field.q
        code //= field.q
    return tuple(vector)


def projective_points(field, dimension):
    for leading in range(dimension):
        for tail in itertools.product(
            range(field.q), repeat=dimension - leading - 1
        ):
            yield (0,) * leading + (1,) + tail


def linear_combination(field, coefficients, rows):
    result = [0] * len(rows[0])
    for coefficient, row in zip(coefficients, rows):
        if coefficient:
            for index, value in enumerate(row):
                result[index] = field.add(
                    result[index], field.mul(coefficient, value)
                )
    return tuple(result)


def matrix_vector(field, matrix, vector):
    return tuple(
        sum_in_field(field, (
            field.mul(coefficient, value)
            for coefficient, value in zip(row, vector)
        ))
        for row in matrix
    )


def sum_in_field(field, values):
    result = 0
    for value in values:
        result = field.add(result, value)
    return result


def rref(field, rows, column_count):
    matrix = [list(row) for row in rows]
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        selected = next(
            (row for row in range(pivot_row, len(matrix))
             if matrix[row][column]),
            None,
        )
        if selected is None:
            continue
        matrix[pivot_row], matrix[selected] = matrix[selected], matrix[pivot_row]
        inverse = field.inv(matrix[pivot_row][column])
        matrix[pivot_row] = [
            field.mul(inverse, value) for value in matrix[pivot_row]
        ]
        for row in range(len(matrix)):
            if row == pivot_row or not matrix[row][column]:
                continue
            coefficient = matrix[row][column]
            matrix[row] = [
                field.sub(value, field.mul(coefficient, pivot))
                for value, pivot in zip(matrix[row], matrix[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return matrix[:pivot_row], pivots


def nullspace(field, rows, column_count):
    reduced, pivots = rref(field, rows, column_count)
    free = [column for column in range(column_count) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * column_count
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = field.neg(reduced[row][free_column])
        basis.append(tuple(vector))
    return basis


def curve(field, degree):
    points = []
    for parameter in range(field.q):
        row = [1]
        for _ in range(degree):
            row.append(field.mul(row[-1], parameter))
        points.append(tuple(row))
    points.append((0,) * degree + (1,))
    return points


def symmetric_power_matrix(field, transformation, degree):
    alpha, beta, gamma, delta = transformation
    matrix = [[0] * (degree + 1) for _ in range(degree + 1)]
    for source in range(degree + 1):
        polynomial = [1]
        for _ in range(source):
            polynomial = polynomial_multiply(
                field, polynomial, [beta, alpha]
            )
        for _ in range(degree - source):
            polynomial = polynomial_multiply(
                field, polynomial, [delta, gamma]
            )
        for target, value in enumerate(polynomial):
            matrix[source][target] = value
    return matrix


def polynomial_multiply(field, left, right):
    result = [0] * (len(left) + len(right) - 1)
    for left_index, left_value in enumerate(left):
        for right_index, right_value in enumerate(right):
            result[left_index + right_index] = field.add(
                result[left_index + right_index],
                field.mul(left_value, right_value),
            )
    return result


def pointed_bad_exhaustive(field):
    finite_curve = curve(field, 5)[:-1]
    marked = set()
    coefficients = tuple(projective_points(field, 4))
    for indices in itertools.combinations(range(field.q), 4):
        rows = [finite_curve[index] for index in indices]
        for coefficient in coefficients:
            marked.add(encode(
                field,
                canonical(field, linear_combination(field, coefficient, rows)),
            ))
    return {
        encode(field, vector)
        for vector in projective_points(field, 6)
        if encode(field, vector) not in marked
    }


def persistent_pointed_locus(field):
    quadratics = []
    for root in range(field.q):
        quadratics.append((
            field.mul(root, root),
            field.neg(field.add(root, root)),
            1,
        ))
    quadratics.append((1, 0, 0))
    for linear in range(field.q):
        for constant in range(field.q):
            if all(
                field.add(
                    field.add(field.mul(root, root),
                              field.mul(linear, root)),
                    constant,
                )
                != 0
                for root in range(field.q)
            ):
                quadratics.append((constant, linear, 1))

    result = set()
    rank_one = {encode(field, point) for point in curve(field, 5)}
    for q0, q1, q2 in quadratics:
        rows = []
        for shift in range(4):
            row = [0] * 6
            row[shift:shift + 3] = (q0, q1, q2)
            rows.append(row)
        basis = nullspace(field, rows, 6)
        assert len(basis) == 2
        for coefficients in projective_points(field, 2):
            vector = canonical(
                field, linear_combination(field, coefficients, basis)
            )
            code = encode(field, vector)
            if code not in rank_one:
                result.add(code)
    expected = field.q * (field.q + 1) ** 2 // 2
    assert len(result) == expected, (field.q, len(result), expected)
    return result


def marked_secant_star(field):
    points = curve(field, 5)
    infinity = points[-1]
    result = {encode(field, infinity)}
    for finite in points[:-1]:
        for coefficient in range(1, field.q):
            vector = canonical(field, tuple(
                field.add(left, field.mul(coefficient, right))
                for left, right in zip(infinity, finite)
            ))
            result.add(encode(field, vector))
    assert len(result) == field.q * field.q - field.q + 1
    return result


def binary_nucleus_line(field):
    if field.p != 2 or field.m % 2 == 0:
        return set()
    return {
        encode(field, vector)
        for vector in (
            *((0, 0, 1, value, 0, 0) for value in range(field.q)),
            (0, 0, 0, 1, 0, 0),
        )
    }


def transient_pointed_orbit(field):
    """The q=19 marked orbit of W=<1,t^3,t^4>, absent otherwise."""
    if field.q != 19:
        return set()
    representative = (0, 0, 1, 0, 0, 0)
    orbit = {
        encode(
            field,
            canonical(
                field,
                matrix_vector(
                    field,
                    symmetric_power_matrix(field, (scale, shift, 0, 1), 5),
                    representative,
                ),
            ),
        )
        for scale in range(1, field.q)
        for shift in range(field.q)
    }
    assert len(orbit) == 19
    return orbit


def pointed_bad_formula(field):
    return (
        persistent_pointed_locus(field)
        | marked_secant_star(field)
        | binary_nucleus_line(field)
        | transient_pointed_orbit(field)
    )


def transport_pointed_locus(field, base):
    transported = []
    for marker in range(field.q):
        matrix = symmetric_power_matrix(field, (marker, 1, 1, 0), 5)
        transported.append({
            encode(
                field,
                canonical(field, matrix_vector(field, matrix, decode(field, code, 6))),
            )
            for code in base
        })
    transported.append(base)
    return transported


def contraction(field, sextic, marker):
    if marker == field.q:
        return sextic[:6]
    return tuple(
        field.sub(sextic[index + 1], field.mul(marker, sextic[index]))
        for index in range(6)
    )


def split_free_sextics(field, base):
    pointed = transport_pointed_locus(field, base)
    result = set()
    for base_code in sorted(base):
        prefix = decode(field, base_code, 6)
        for final in range(field.q):
            sextic = prefix + (final,)
            if all(
                encode(field, canonical(field, contraction(field, sextic, marker)))
                in pointed[marker]
                for marker in range(field.q)
            ):
                result.add(encode(field, sextic))
    endpoint = (0,) * 6 + (1,)
    if all(
        encode(field, canonical(field, contraction(field, endpoint, marker)))
        in pointed[marker]
        for marker in range(field.q)
    ):
        result.add(encode(field, endpoint))
    return result


def pgl_orbit(field, start, primitive):
    generators = [
        symmetric_power_matrix(field, (0, 1, 1, 0), 6),
        symmetric_power_matrix(field, (1, 1, 0, 1), 6),
        symmetric_power_matrix(field, (primitive, 0, 0, 1), 6),
    ]
    normalized = canonical(field, start)
    seen = {encode(field, normalized)}
    pending = [normalized]
    while pending:
        vector = pending.pop()
        for matrix in generators:
            image = canonical(field, matrix_vector(field, matrix, vector))
            code = encode(field, image)
            if code not in seen:
                seen.add(code)
                pending.append(image)
    return seen


def orbit_partition(field, split_free):
    primitive = primitive_element(field)
    unseen = set(split_free)
    records = []
    point_to_representative = {}
    while unseen:
        representative = min(unseen)
        component = pgl_orbit(
            field, decode(field, representative, 7), primitive
        )
        assert component <= split_free
        unseen -= component
        for point in component:
            point_to_representative[point] = representative
        records.append({
            "canonical_index": representative,
            "orbit_size": len(component),
            "stabilizer_order": (field.q ** 3 - field.q) // len(component),
        })
    for record in records:
        vector = decode(field, record["canonical_index"], 7)
        frobenius = tuple(field_pow(field, value, field.p) for value in vector)
        record["frobenius_target_index"] = point_to_representative[
            encode(field, canonical(field, frobenius))
        ]
    records.sort(key=lambda record: (
        record["orbit_size"], record["canonical_index"]
    ))
    return records


def public_r7_fields():
    document = json.loads(PUBLIC_RECORD.read_text(encoding="utf-8"))
    record = document["records"]["R7"]
    assert record["public_label"] == "Certificate R7"
    return {field["q"]: field for field in record["fields"]}


def digest_integers(values):
    payload = "\n".join(str(value) for value in sorted(values)) + "\n"
    return hashlib.sha256(payload.encode("ascii")).hexdigest()


def digest_records(records):
    payload = json.dumps(records, sort_keys=True, separators=(",", ":")) + "\n"
    return hashlib.sha256(payload.encode("ascii")).hexdigest()


def replay_field(q, expected):
    field = R5.GF(q)
    base_method = (
        "literal-four-secant-complement"
        if q < 16
        else (
            "direct-r6-persistent-marked-star-transient-union"
            if q == 19
            else "direct-r6-persistent-marked-star-nucleus-union"
        )
    )
    base = (
        pointed_bad_exhaustive(field)
        if q < 16 else
        pointed_bad_formula(field)
    )
    split_free = split_free_sextics(field, base)
    records = orbit_partition(field, split_free)
    public_records = [
        {
            "canonical_index": orbit["canonical_index"],
            "orbit_size": orbit["orbit_size"],
            "stabilizer_order": orbit["stabilizer_order"],
            "frobenius_target_index": orbit["frobenius_target_index"],
        }
        for orbit in expected["orbits"]
    ]
    public_records.sort(key=lambda record: (
        record["orbit_size"], record["canonical_index"]
    ))
    searched_candidate_count = len(base) * q + 1
    assert searched_candidate_count == expected["searched_candidate_count"], q
    assert len(split_free) == expected["classified_split_free_count"], q
    assert records == public_records, q
    return {
        "q": q,
        "pointed_method": base_method,
        "pointed_bad_count": len(base),
        "transient_pointed_count": len(transient_pointed_orbit(field)),
        "searched_candidate_count": searched_candidate_count,
        "split_free_count": len(split_free),
        "split_free_set_sha256": digest_integers(split_free),
        "pgl_orbit_count": len(records),
        "orbit_partition_sha256": digest_records(records),
        "matches_public_record": True,
    }


def canonical_document(fields):
    expected = public_r7_fields()
    rows = []
    for q in fields:
        row = replay_field(q, expected[q])
        rows.append(row)
        print(
            f"q={q}: pointed={row['pointed_bad_count']} "
            f"split_free={row['split_free_count']} "
            f"PGL={row['pgl_orbit_count']}: PASS",
            flush=True,
        )
    return {
        "schema": "c545-r7-direct-locus-replay-v2",
        "field_implementation": str(R5_REPLAY.relative_to(SUPPLEMENT)),
        "public_record": str(PUBLIC_RECORD.relative_to(SUPPLEMENT)),
        "fields": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--fields",
        default="7,8,9,11,13,16,17,19,23,25,27,29,31,32",
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    fields = tuple(int(value) for value in args.fields.split(",") if value)
    document = canonical_document(fields)
    payload = json.dumps(document, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(payload, encoding="utf-8")
    if args.check:
        assert args.check.read_text(encoding="utf-8") == payload
        print(f"PASS byte-identical certificate {args.check}")
    if not args.output and not args.check:
        print(payload, end="")


if __name__ == "__main__":
    main()
