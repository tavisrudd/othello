#!/usr/bin/env python3
"""Exact bounded classification of the q=11 Clebsch six-axis AME pencil."""

from __future__ import annotations

import argparse
import collections
import hashlib
import itertools
import json
from pathlib import Path
from typing import Iterable, Sequence


Q = 11
N = 6
HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "quantum-family-classification.json"

Vector = tuple[int, ...]
Matrix = tuple[Vector, ...]
Matrix2 = tuple[tuple[int, int], tuple[int, int]]
PointSet = tuple[Vector, ...]


def inv(a: int) -> int:
    if a % Q == 0:
        raise ZeroDivisionError("zero has no inverse")
    return pow(a % Q, Q - 2, Q)


def rref(rows: Iterable[Sequence[int]]) -> tuple[Matrix, tuple[int, ...]]:
    a = [[x % Q for x in row] for row in rows]
    if not a:
        return (), ()
    width = len(a[0])
    pivot_row = 0
    pivots: list[int] = []
    for col in range(width):
        pivot = next((i for i in range(pivot_row, len(a)) if a[i][col]), None)
        if pivot is None:
            continue
        a[pivot_row], a[pivot] = a[pivot], a[pivot_row]
        scale = inv(a[pivot_row][col])
        a[pivot_row] = [(scale * x) % Q for x in a[pivot_row]]
        for i in range(len(a)):
            if i == pivot_row or a[i][col] == 0:
                continue
            scale = a[i][col]
            a[i] = [(x - scale * y) % Q for x, y in zip(a[i], a[pivot_row])]
        pivots.append(col)
        pivot_row += 1
        if pivot_row == len(a):
            break
    return tuple(tuple(row) for row in a if any(row)), tuple(pivots)


def rowspace(rows: Iterable[Sequence[int]]) -> Matrix:
    return rref(rows)[0]


def nullspace(rows: Iterable[Sequence[int]], width: int | None = None) -> Matrix:
    raw = tuple(tuple(row) for row in rows)
    if raw:
        width = len(raw[0])
    if width is None:
        raise ValueError("width is required for an empty matrix")
    reduced, pivots = rref(raw)
    free = [j for j in range(width) if j not in pivots]
    basis: list[Vector] = []
    for free_col in free:
        v = [0] * width
        v[free_col] = 1
        for i, pivot_col in enumerate(pivots):
            v[pivot_col] = (-reduced[i][free_col]) % Q
        basis.append(tuple(v))
    return tuple(basis)


def matmul_row(v: Sequence[int], rows: Matrix) -> Vector:
    return tuple(sum(v[i] * rows[i][j] for i in range(len(rows))) % Q for j in range(len(rows[0])))


def canonical_projective(v: Sequence[int]) -> Vector:
    first = next(x % Q for x in v if x % Q)
    scale = inv(first)
    return tuple(scale * x % Q for x in v)


def det3(columns: Sequence[Sequence[int]]) -> int:
    a, b, c = columns
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - b[0] * (a[1] * c[2] - a[2] * c[1])
        + c[0] * (a[1] * b[2] - a[2] * b[1])
    ) % Q


def inverse3(rows: Matrix) -> Matrix:
    augmented = tuple(tuple(row) + tuple(int(i == j) for j in range(3)) for i, row in enumerate(rows))
    reduced, pivots = rref(augmented)
    if pivots[:3] != (0, 1, 2):
        raise ValueError("singular 3x3 matrix")
    return tuple(row[3:] for row in reduced)


def matvec(rows: Matrix, v: Sequence[int]) -> Vector:
    return tuple(sum(row[j] * v[j] for j in range(3)) % Q for row in rows)


def parity_check(points: Sequence[Vector]) -> Matrix:
    return tuple(tuple(points[j][i] for j in range(N)) for i in range(3))


def pencil_points(t: int) -> PointSet:
    return tuple(
        canonical_projective(point)
        for point in (
            (0, 1, 1 - t),
            (0, 1, t - 1),
            (1, 1 - t, 0),
            (1, t - 1, 0),
            (1, 0, -t),
            (1, 0, t),
        )
    )


def is_arc(points: Sequence[Vector]) -> bool:
    return len(set(points)) == N and all(det3(triple) for triple in itertools.combinations(points, 3))


def conic_evaluation(point: Vector) -> Vector:
    x, y, z = point
    return (x * x % Q, y * y % Q, z * z % Q, x * y % Q, x * z % Q, y * z % Q)


def determinant(rows: Sequence[Sequence[int]]) -> int:
    a = [[x % Q for x in row] for row in rows]
    result = 1
    for col in range(len(a)):
        pivot = next((i for i in range(col, len(a)) if a[i][col]), None)
        if pivot is None:
            return 0
        if pivot != col:
            a[col], a[pivot] = a[pivot], a[col]
            result = -result
        pivot_value = a[col][col]
        result = result * pivot_value % Q
        scale = inv(pivot_value)
        a[col] = [scale * x % Q for x in a[col]]
        for i in range(col + 1, len(a)):
            factor = a[i][col]
            a[i] = [(x - factor * y) % Q for x, y in zip(a[i], a[col])]
    return result % Q


def lies_on_conic(points: Sequence[Vector]) -> bool:
    return len(rowspace(conic_evaluation(point) for point in points)) < 6


def frame_transform(points: Sequence[Vector], frame: tuple[int, int, int, int]) -> Matrix:
    a, b, c, d = (points[i] for i in frame)
    basis_rows = tuple(tuple((a, b, c)[j][i] for j in range(3)) for i in range(3))
    basis_inverse = inverse3(basis_rows)
    coordinates = matvec(basis_inverse, d)
    if not all(coordinates):
        raise AssertionError("four arc points did not form a projective frame")
    scaled_basis = tuple(
        tuple(((a, b, c)[j][i] * coordinates[j]) % Q for j in range(3))
        for i in range(3)
    )
    return inverse3(scaled_basis)


def normalize_frame(points: Sequence[Vector], frame: tuple[int, int, int, int]) -> PointSet:
    transform = frame_transform(points, frame)
    normalized = tuple(sorted(canonical_projective(matvec(transform, point)) for point in points))
    expected = {(0, 0, 1), (0, 1, 0), (1, 0, 0), (1, 1, 1)}
    if not expected.issubset(normalized):
        raise AssertionError("frame normalization failed")
    return normalized


def canonical_arc(points: Sequence[Vector]) -> PointSet:
    return min(normalize_frame(points, frame) for frame in itertools.permutations(range(N), 4))


def normalizing_witness(points: Sequence[Vector], target: PointSet) -> dict[str, object]:
    for frame in itertools.permutations(range(N), 4):
        transform = frame_transform(points, frame)
        transformed = tuple(matvec(transform, point) for point in points)
        normalized = tuple(canonical_projective(point) for point in transformed)
        if tuple(sorted(normalized)) != target:
            continue
        source_to_target = tuple(target.index(point) for point in normalized)
        scalars = tuple(next(x for x in point if x) for point in transformed)
        if any(
            transformed[source][coordinate] % Q
            != scalars[source] * target[source_to_target[source]][coordinate] % Q
            for source in range(N)
            for coordinate in range(3)
        ):
            raise AssertionError("normalizing witness has an incorrect column scalar")
        return {
            "frame": list(frame),
            "row_transform": [list(row) for row in transform],
            "source_to_canonical_party": list(source_to_target),
            "transformed_column_scalars": list(scalars),
        }
    raise AssertionError("canonical representative has no normalizing witness")


def projectively_equivalent(left: Sequence[Vector], right: Sequence[Vector]) -> bool:
    target = set(right)
    for frame in itertools.permutations(range(N), 4):
        left_normalized = normalize_frame(left, (0, 1, 2, 3))
        right_normalized = normalize_frame(right, frame)
        if left_normalized == right_normalized:
            return True
    return False


def dual(code: Matrix) -> Matrix:
    return nullspace(code)


def minimum_distance(code: Matrix) -> int:
    best = N + 1
    for coefficients in itertools.product(range(Q), repeat=len(code)):
        if not any(coefficients):
            continue
        best = min(best, sum(x != 0 for x in matmul_row(coefficients, code)))
    return best


def shortened_word(code: Matrix, omitted: tuple[int, int]) -> Vector:
    equations = tuple(tuple(code[r][i] for r in range(len(code))) for i in omitted)
    coeffs = nullspace(equations)
    if len(coeffs) != 1:
        raise AssertionError("MDS shortening is not one-dimensional")
    word = canonical_projective(matmul_row(coeffs[0], code))
    expected = tuple(i for i in range(N) if i not in omitted)
    if tuple(i for i, x in enumerate(word) if x) != expected:
        raise AssertionError("shortened word has incorrect support")
    return word


def minimal_support_data(code: Matrix) -> dict[tuple[int, ...], tuple[Vector, Vector]]:
    code_dual = dual(code)
    result: dict[tuple[int, ...], tuple[Vector, Vector]] = {}
    for omitted in itertools.combinations(range(N), 2):
        support = tuple(i for i in range(N) if i not in omitted)
        result[support] = (shortened_word(code, omitted), shortened_word(code_dual, omitted))
    return result


def m2_mul(a: Matrix2, b: Matrix2) -> Matrix2:
    return (
        ((a[0][0] * b[0][0] + a[0][1] * b[1][0]) % Q,
         (a[0][0] * b[0][1] + a[0][1] * b[1][1]) % Q),
        ((a[1][0] * b[0][0] + a[1][1] * b[1][0]) % Q,
         (a[1][0] * b[0][1] + a[1][1] * b[1][1]) % Q),
    )


def m2_det(a: Matrix2) -> int:
    return (a[0][0] * a[1][1] - a[0][1] * a[1][0]) % Q


def m2_inv(a: Matrix2) -> Matrix2:
    scale = inv(m2_det(a))
    return (
        ((scale * a[1][1]) % Q, (-scale * a[0][1]) % Q),
        ((-scale * a[1][0]) % Q, (scale * a[0][0]) % Q),
    )


def relation(data: dict[tuple[int, ...], tuple[Vector, Vector]], support: tuple[int, ...], a: int, b: int) -> Matrix2:
    xword, zword = data[support]
    return ((xword[b] * inv(xword[a]) % Q, 0), (0, zword[b] * inv(zword[a]) % Q))


def cycle_signature(code: Matrix) -> tuple[tuple[tuple[int, int], int], ...]:
    data = minimal_support_data(code)
    signature: list[tuple[int, int]] = []
    for a, b in itertools.combinations(range(N), 2):
        supports = [support for support in sorted(data) if a in support and b in support]
        for first, second in itertools.combinations(supports, 2):
            holonomy = m2_mul(relation(data, second, b, a), relation(data, first, a, b))
            reverse = m2_inv(holonomy)
            signature.append(((holonomy[0][0] + holonomy[1][1]) % Q, m2_det(holonomy)))
            signature.append(((reverse[0][0] + reverse[1][1]) % Q, m2_det(reverse)))
    if len(signature) != 450:
        raise AssertionError("incorrect cycle-signature length")
    return tuple(sorted(collections.Counter(signature).items()))


def stabilizer_space(code: Matrix) -> Matrix:
    zero = (0,) * N
    return rowspace(tuple(row) + zero for row in code) + rowspace(zero + tuple(row) for row in dual(code))


def stabilizer_shortenings(code: Matrix) -> tuple[Matrix, ...]:
    stabilizer = stabilizer_space(code)
    result: list[Matrix] = []
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(stabilizer[r][coordinate] for r in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(equations)
        if len(coefficients) != 2:
            raise AssertionError("four-party stabilizer shortening is not two-dimensional")
        result.append(coefficients)
    return tuple(result)


def cycle_signature_lagrangian_replay(code: Matrix) -> tuple[tuple[tuple[int, int], int], ...]:
    stabilizer = stabilizer_space(code)
    support_projections: dict[tuple[int, ...], dict[int, Matrix2]] = {}
    for omitted in itertools.combinations(range(N), 2):
        support = tuple(i for i in range(N) if i not in omitted)
        equations = tuple(
            tuple(stabilizer[r][coordinate] for r in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        coefficients = nullspace(equations)
        shortened = tuple(matmul_row(coefficient, stabilizer) for coefficient in coefficients)
        projections: dict[int, Matrix2] = {}
        for party in support:
            projection = (
                (shortened[0][party], shortened[1][party]),
                (shortened[0][N + party], shortened[1][N + party]),
            )
            if m2_det(projection) == 0:
                raise AssertionError("minimal stabilizer projection is singular")
            projections[party] = projection
        support_projections[support] = projections

    signature: list[tuple[int, int]] = []
    for a, b in itertools.combinations(range(N), 2):
        supports = [support for support in sorted(support_projections) if a in support and b in support]
        for first, second in itertools.combinations(supports, 2):
            first_map = m2_mul(support_projections[first][b], m2_inv(support_projections[first][a]))
            second_map = m2_mul(support_projections[second][a], m2_inv(support_projections[second][b]))
            holonomy = m2_mul(second_map, first_map)
            reverse = m2_inv(holonomy)
            signature.append(((holonomy[0][0] + holonomy[1][1]) % Q, m2_det(holonomy)))
            signature.append(((reverse[0][0] + reverse[1][1]) % Q, m2_det(reverse)))
    return tuple(sorted(collections.Counter(signature).items()))


def moment_distribution(code: Matrix) -> tuple[tuple[int, int], ...]:
    shortenings = stabilizer_shortenings(code)
    ranks = collections.Counter(
        len(rowspace(row for index in triple for row in shortenings[index]))
        for triple in itertools.combinations(range(len(shortenings)), 3)
    )
    if sum(ranks.values()) != 455:
        raise AssertionError("incorrect marginal-triple count")
    return tuple(sorted(ranks.items()))


def moment_distribution_ambient_replay(code: Matrix) -> tuple[tuple[int, int], ...]:
    stabilizer = stabilizer_space(code)
    ambient: list[Matrix] = []
    for omitted in itertools.combinations(range(N), 2):
        equations = tuple(
            tuple(stabilizer[r][coordinate] for r in range(N))
            for party in omitted
            for coordinate in (party, N + party)
        )
        ambient.append(tuple(matmul_row(coeff, stabilizer) for coeff in nullspace(equations)))
    ranks = collections.Counter(
        len(rowspace(row for index in triple for row in ambient[index]))
        for triple in itertools.combinations(range(len(ambient)), 3)
    )
    return tuple(sorted(ranks.items()))


def signature_json(signature: tuple[tuple[tuple[int, int], int], ...]) -> list[dict[str, int]]:
    return [
        {"trace": trace, "determinant": determinant, "multiplicity": multiplicity}
        for (trace, determinant), multiplicity in signature
    ]


def moment_json(distribution: tuple[tuple[int, int], ...]) -> list[dict[str, int | str]]:
    return [
        {"sum_rank": rank, "moment": f"11^-{rank}", "triple_count": count}
        for rank, count in distribution
    ]


def build_certificate() -> dict[str, object]:
    valid_parameters = [t for t in range(Q) if is_arc(pencil_points(t))]
    arc_failures = {
        str(t): {
            "duplicate_pairs": [
                list(pair)
                for pair in itertools.combinations(range(N), 2)
                if pencil_points(t)[pair[0]] == pencil_points(t)[pair[1]]
            ],
            "collinear_triples": [
                list(triple)
                for triple in itertools.combinations(range(N), 3)
                if det3(tuple(pencil_points(t)[i] for i in triple)) == 0
            ],
        }
        for t in range(Q)
        if t not in valid_parameters
    }
    by_canonical: dict[PointSet, list[int]] = collections.defaultdict(list)
    for t in valid_parameters:
        by_canonical[canonical_arc(pencil_points(t))].append(t)

    representatives = sorted(by_canonical)
    for i, left in enumerate(representatives):
        for j, right in enumerate(representatives):
            equivalent = projectively_equivalent(left, right)
            if equivalent != (i == j):
                raise AssertionError("pairwise projective replay disagrees with canonical partition")

    classes: list[dict[str, object]] = []
    moment_buckets: dict[tuple[tuple[int, int], ...], list[int]] = collections.defaultdict(list)
    cycle_buckets: dict[tuple[tuple[tuple[int, int], int], ...], list[int]] = collections.defaultdict(list)
    for class_id, points in enumerate(representatives):
        code = nullspace(parity_check(points))
        cycle = cycle_signature(code)
        if cycle != cycle_signature_lagrangian_replay(code):
            raise AssertionError("direct Lagrangian cycle-signature replay failed")
        moment = moment_distribution(code)
        if moment != moment_distribution_ambient_replay(code):
            raise AssertionError("ambient marginal-rank replay failed")
        grs = lies_on_conic(points)
        conic_determinant = determinant(tuple(conic_evaluation(point) for point in points))
        if grs != (conic_determinant == 0):
            raise AssertionError("conic rank and determinant tests disagree")
        if minimum_distance(code) != 4 or minimum_distance(dual(code)) != 4:
            raise AssertionError("arc code or dual is not [6,3,4] MDS")
        moment_buckets[moment].append(class_id)
        cycle_buckets[cycle].append(class_id)
        if 8 in by_canonical[points]:
            expected_cycle = (
                ((1, 10), 120),
                ((2, 1), 60),
                ((3, 1), 120),
                ((9, 1), 30),
                ((10, 10), 120),
            )
            if cycle != expected_cycle or moment != ((4, 70), (6, 385)):
                raise AssertionError("base state equivalence Clebsch invariant regression")
        classes.append(
            {
                "class_id": class_id,
                "parameters": by_canonical[points],
                "parameter_witnesses": {
                    str(t): normalizing_witness(pencil_points(t), points) for t in by_canonical[points]
                },
                "canonical_points": [list(point) for point in points],
                "grs": grs,
                "conic_evaluation_determinant": conic_determinant,
                "cycle_signature": signature_json(cycle),
                "triple_moments": moment_json(moment),
            }
        )

    non_grs_ids = [record["class_id"] for record in classes if not record["grs"]]
    if len(non_grs_ids) < 2:
        raise AssertionError("family gate requires at least two non-GRS monomial classes")
    return {
        "schema": "family-clebsch-ame-pencil-v1",
        "field_order": Q,
        "parameter_domain": list(range(Q)),
        "valid_arc_parameters": valid_parameters,
        "invalid_arc_parameters": [t for t in range(Q) if t not in valid_parameters],
        "arc_failures": arc_failures,
        "monomial_class_count": len(classes),
        "non_grs_class_ids": non_grs_ids,
        "grs_class_ids": [record["class_id"] for record in classes if record["grs"]],
        "cycle_signature_bucket_sizes": sorted(len(ids) for ids in cycle_buckets.values()),
        "moment_bucket_sizes": sorted(len(ids) for ids in moment_buckets.values()),
        "moment_collision_class_ids": [ids for ids in moment_buckets.values() if len(ids) > 1],
        "classes": classes,
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="verify the tracked certificate")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    if args.check:
        tracked = OUTPUT.read_bytes()
        if payload != tracked:
            raise SystemExit(
                "certificate mismatch: regenerated "
                f"{hashlib.sha256(payload).hexdigest()} != tracked {hashlib.sha256(tracked).hexdigest()}"
            )
        print(f"ok {OUTPUT.name} {len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()}")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.name} {len(payload)} bytes sha256={hashlib.sha256(payload).hexdigest()}")


if __name__ == "__main__":
    main()
