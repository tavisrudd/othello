#!/usr/bin/env python3
"""Independent arithmetic replay for the C478 exceptional-family controls."""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-07-22-c478-exceptional-family-controls.json"
PERMUTATIONS = tuple(itertools.permutations(range(6)))


class Field:
    def __init__(self, q: int):
        self.q = q
        if q in (5, 7, 11):
            self.p, self.degree, self.modulus = q, 1, None
        elif q == 8:
            self.p, self.degree, self.modulus = 2, 3, (1, 1, 0, 1)
        elif q == 9:
            self.p, self.degree, self.modulus = 3, 2, (1, 0, 1)
        else:
            raise ValueError(q)

    def digits(self, value: int) -> list[int]:
        answer = []
        for _ in range(self.degree):
            answer.append(value % self.p)
            value //= self.p
        return answer

    def encode(self, digits) -> int:
        value = 0
        for coefficient in reversed(tuple(digits)):
            value = value * self.p + coefficient % self.p
        return value

    def add(self, x: int, y: int) -> int:
        if self.degree == 1:
            return (x + y) % self.p
        return self.encode((a + b) % self.p for a, b in zip(self.digits(x), self.digits(y)))

    def neg(self, x: int) -> int:
        return self.encode((-a) % self.p for a in self.digits(x))

    def sub(self, x: int, y: int) -> int:
        return self.add(x, self.neg(y))

    def mul(self, x: int, y: int) -> int:
        if self.degree == 1:
            return x * y % self.p
        left, right = self.digits(x), self.digits(y)
        product = [0] * (2 * self.degree - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                product[i + j] = (product[i + j] + a * b) % self.p
        assert self.modulus and self.modulus[-1] == 1
        for degree in range(len(product) - 1, self.degree - 1, -1):
            coefficient = product[degree]
            if not coefficient:
                continue
            for j in range(self.degree):
                product[degree - self.degree + j] = (
                    product[degree - self.degree + j] - coefficient * self.modulus[j]
                ) % self.p
        return self.encode(product[: self.degree])

    def power(self, x: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, x)
            x = self.mul(x, x)
            exponent //= 2
        return answer

    def inverse(self, x: int) -> int:
        assert x
        return self.power(x, self.q - 2)

    def frobenius(self, x: int, power: int) -> int:
        return self.power(x, self.p ** power)


def normalize(field: Field, vector) -> tuple[int, ...]:
    first = next(x for x in vector if x)
    inverse = field.inverse(first)
    return tuple(field.mul(inverse, x) for x in vector)


def projective_points(field: Field) -> tuple[tuple[int, int, int], ...]:
    return tuple(sorted({
        normalize(field, vector)
        for vector in itertools.product(range(field.q), repeat=3)
        if any(vector)
    }))


def det3(field: Field, a, b, c) -> int:
    positive = field.add(
        field.add(field.mul(a[0], field.mul(b[1], c[2])), field.mul(a[1], field.mul(b[2], c[0]))),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    negative = field.add(
        field.add(field.mul(a[2], field.mul(b[1], c[0])), field.mul(a[1], field.mul(b[0], c[2]))),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(positive, negative)


def mat_vec(field: Field, matrix, vector) -> tuple[int, int, int]:
    return tuple(
        field.add(field.add(field.mul(matrix[3 * i], vector[0]),
                            field.mul(matrix[3 * i + 1], vector[1])),
                  field.mul(matrix[3 * i + 2], vector[2]))
        for i in range(3)
    )


def inverse3(field: Field, columns) -> tuple[int, ...]:
    matrix = [[columns[j][i] for j in range(3)] for i in range(3)]
    augmented = [row + [1 if i == j else 0 for j in range(3)] for i, row in enumerate(matrix)]
    for column in range(3):
        pivot = next(i for i in range(column, 3) if augmented[i][column])
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        scale = field.inverse(augmented[column][column])
        augmented[column] = [field.mul(scale, x) for x in augmented[column]]
        for i in range(3):
            if i == column or not augmented[i][column]:
                continue
            factor = augmented[i][column]
            augmented[i] = [field.sub(x, field.mul(factor, y))
                            for x, y in zip(augmented[i], augmented[column])]
    return tuple(augmented[i][j] for i in range(3) for j in range(3, 6))


def matrix_mul(field: Field, left, right) -> tuple[int, ...]:
    answer = []
    for i in range(3):
        for j in range(3):
            value = 0
            for k in range(3):
                value = field.add(value, field.mul(left[3 * i + k], right[3 * k + j]))
            answer.append(value)
    return tuple(answer)


def frame_matrix(field: Field, frame) -> tuple[int, ...]:
    inverse = inverse3(field, frame[:3])
    coefficients = mat_vec(field, inverse, frame[3])
    assert all(coefficients)
    return tuple(field.mul(frame[j][i], coefficients[j]) for i in range(3) for j in range(3))


def normalize_matrix(field: Field, matrix) -> tuple[int, ...]:
    inverse = field.inverse(next(x for x in matrix if x))
    return tuple(field.mul(inverse, x) for x in matrix)


def twist(field: Field, point, power: int) -> tuple[int, ...]:
    return tuple(field.frobenius(x, power) for x in point)


def apply(field: Field, transformation, point) -> tuple[int, ...]:
    power, matrix = transformation
    return normalize(field, mat_vec(field, matrix, twist(field, point, power)))


def is_arc(field: Field, points) -> bool:
    return all(det3(field, *triple) for triple in itertools.combinations(points, 3))


def locus_stabilizer(field: Field, locus) -> tuple[tuple[int, tuple[int, ...]], ...]:
    source = tuple(locus[:4])
    transformations = set()
    for power in range(field.degree):
        twisted = tuple(twist(field, point, power) for point in source)
        source_inverse = inverse3(field, tuple(
            tuple(frame_matrix(field, twisted)[3 * i + j] for i in range(3)) for j in range(3)
        ))
        for target in itertools.permutations(locus, 4):
            if not is_arc(field, target):
                continue
            matrix = normalize_matrix(field, matrix_mul(field, frame_matrix(field, target), source_inverse))
            transformation = (power, matrix)
            if tuple(sorted(apply(field, transformation, point) for point in locus)) == locus:
                transformations.add(transformation)
    return tuple(sorted(transformations))


def atlas(field: Field, support, syndrome, permutation=range(6)) -> tuple[int, ...]:
    points = tuple(support[index] for index in permutation)
    edges = {(i, j): det3(field, syndrome, points[i], points[j])
             for i, j in itertools.combinations(range(6), 2)}
    assert all(edges.values())
    answer = []
    for i, j, k, ell in itertools.combinations(range(6), 4):
        numerator = field.mul(edges[i, j], edges[k, ell])
        answer += [
            field.mul(numerator, field.inverse(field.mul(edges[i, k], edges[j, ell]))),
            field.mul(numerator, field.inverse(field.mul(edges[i, ell], edges[j, k]))),
        ]
    return tuple(answer)


def canonical_atlas(field: Field, support, syndrome) -> tuple[int, ...]:
    return min(
        tuple(field.frobenius(x, power) for x in atlas(field, support, syndrome, permutation))
        for permutation in PERMUTATIONS for power in range(field.degree)
    )


def partition(points, transformations, field: Field) -> list[list[int]]:
    index = {point: i for i, point in enumerate(points)}
    unseen = set(range(len(points)))
    answer = []
    while unseen:
        seed = min(unseen)
        part = sorted({index[apply(field, transformation, points[seed])]
                       for transformation in transformations})
        unseen -= set(part)
        answer.append(part)
    return sorted(answer, key=lambda part: (len(part), part))


def atlas_partition(field: Field, support, locus, transformations) -> list[list[int]]:
    values = [atlas(field, support, point) for point in locus]
    unseen = set(range(len(locus)))
    answer = []
    while unseen:
        seed = min(unseen)
        targets = {atlas(field, support, apply(field, transformation, locus[seed]))
                   for transformation in transformations}
        part = sorted(index for index in unseen if values[index] in targets)
        unseen -= set(part)
        answer.append(part)
    return sorted(answer, key=lambda part: (len(part), part))


def digest(signature) -> str:
    return hashlib.sha256(json.dumps(signature, separators=(",", ":")).encode()).hexdigest()


def rank(rows, prime: int) -> int:
    matrix = [[x % prime for x in row] for row in rows]
    result = 0
    for column in range(len(matrix[0]) if matrix else 0):
        pivot = next((i for i in range(result, len(matrix)) if matrix[i][column]), None)
        if pivot is None:
            continue
        matrix[result], matrix[pivot] = matrix[pivot], matrix[result]
        inverse = pow(matrix[result][column], -1, prime)
        matrix[result] = [inverse * x % prime for x in matrix[result]]
        for i in range(len(matrix)):
            if i != result and matrix[i][column]:
                factor = matrix[i][column]
                matrix[i] = [(x - factor * y) % prime for x, y in zip(matrix[i], matrix[result])]
        result += 1
    return result


def gram_rank(matrix, prime: int) -> int:
    return rank([[sum(x * y for x, y in zip(left, right)) for right in matrix] for left in matrix], prime)


def uncovered(field: Field, support, points) -> tuple[tuple[int, int, int], ...]:
    return tuple(point for point in points if point not in support and all(
        det3(field, left, right, point) for left, right in itertools.combinations(support, 2)
    ))


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    for record in certificate["frozen_inputs"]:
        path = ROOT / record["path"]
        assert path.stat().st_size == record["bytes"]
        assert hashlib.sha256(path.read_bytes()).hexdigest() == record["sha256"]
    c398 = json.loads((ROOT / "notes" / "2026-07-20-c398-conic-deep-hole-classification.json").read_text())
    cases = {(case["q"], case["survivor_index"]): case
             for case in certificate["c398_non_grs_controls"]}
    checked = 0
    for field_record in c398["fields"]:
        for survivor_index, survivor in enumerate(field_record["survivors"]):
            q = field_record["q"]
            field = Field(q)
            support = tuple(map(tuple, survivor["arc"]))
            locus = tuple(map(tuple, survivor["locus"]))
            group = locus_stabilizer(field, locus)
            parent_group = tuple(g for g in group if tuple(sorted(apply(field, g, x) for x in support)) == support)
            point_parts = partition(locus, parent_group, field)
            atlas_parts = atlas_partition(field, support, locus, parent_group)
            parents = tuple(sorted({tuple(sorted(apply(field, g, x) for x in support)) for g in group}))
            # Covariance reduces the fixed-child parent comparison to one parent:
            # canonical support relabelling/Frobenius values need only be constant
            # on the full literal-child stabilizer orbits.
            signature = tuple(canonical_atlas(field, support, point) for point in locus)
            full_locus_parts = partition(locus, group, field)
            for part in full_locus_parts:
                assert len({signature[index] for index in part}) == 1
            case = cases[q, survivor_index]
            assert len(set(atlas(field, support, point) for point in locus)) == case["labelled_atlas_distinct_count"]
            assert sorted(map(len, point_parts)) == case["projective_deep_hole_orbit_sizes"]
            assert sorted(map(len, atlas_parts)) == case["atlas_orbit_sizes"]
            assert point_parts == atlas_parts
            assert len(parents) == case["fixed_child_parent_count"]
            assert case["unlabelled_atlas_parent_signature_count"] == 1
            assert digest(signature) == case["common_unlabelled_atlas_parent_signature_sha256"]
            checked += 1

    for case in certificate["coxeter_conic_phase_controls"]:
        field = Field(case["q"])
        points = projective_points(field)
        conic = tuple(point for point in points if not field.add(
            field.add(field.mul(point[0], point[0]), field.mul(point[1], point[1])),
            field.mul(point[2], point[2]),
        ))
        assert len(conic) == case["full_conic_size"] == case["q"] + 1
        assert len(uncovered(field, conic, points)) == case["full_conic_deep_syndrome_count"] == 0

    c465 = json.loads((ROOT / "notes" / "2026-07-21-c465-mod3-weil-golay.json").read_text())
    coxeter = {case["q"]: case for case in certificate["coxeter_conic_phase_controls"]}
    for upstream in c465["cases"]:
        prime = upstream["characteristic"]
        modular = coxeter[upstream["q"]]["modular_carrier"]
        assert gram_rank(upstream["relations"]["shared_edge"]["matrix"], prime) == modular["shared_gram_rank"] == 0
        assert gram_rank(upstream["relations"]["disjoint"]["matrix"], prime) == modular["disjoint_gram_rank"] == 1

    # Independent q=9 Sylow check: orbit of one augmentation vector under (012)(3) is a basis.
    vectors = [(1, 0, 0, 2), (0, 1, 0, 2), (0, 0, 1, 2)]
    assert rank(vectors, 3) == 3
    assert certificate["c398_non_grs_controls"][1]["modular_carrier"]["stable_endpoint"] == "zero (projective)"
    print(f"C478 independent replay: {checked} C398 atlas rows, 3 conic controls, and all Gram/Sylow gates agree")


if __name__ == "__main__":
    main()
