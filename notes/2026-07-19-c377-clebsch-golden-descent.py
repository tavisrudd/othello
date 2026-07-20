#!/usr/bin/env python3
"""Exact symbolic checker for C377's Clebsch golden descent stop."""

from __future__ import annotations

import argparse
import itertools
import json
from collections import Counter
from dataclasses import dataclass
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-19-c377-clebsch-golden-descent.json"


@dataclass(frozen=True, order=True)
class QTau:
    """a+b*tau in Q(tau), with tau^2=tau+1."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    def __add__(self, other: QTau) -> QTau:
        return QTau(self.a + other.a, self.b + other.b)

    def __neg__(self) -> QTau:
        return QTau(-self.a, -self.b)

    def __sub__(self, other: QTau) -> QTau:
        return self + (-other)

    def __mul__(self, other: QTau) -> QTau:
        return QTau(
            self.a * other.a + self.b * other.b,
            self.a * other.b + self.b * other.a + self.b * other.b,
        )

    def inverse(self) -> QTau:
        norm = self.a * self.a + self.a * self.b - self.b * self.b
        assert norm
        return QTau((self.a + self.b) / norm, -self.b / norm)

    def __truediv__(self, other: QTau) -> QTau:
        return self * other.inverse()

    def sigma(self) -> QTau:
        return QTau(self.a + self.b, -self.b)

    def encoded(self) -> list[int] | list[list[int]]:
        if self.a.denominator == self.b.denominator == 1:
            return [self.a.numerator, self.b.numerator]
        return [
            [self.a.numerator, self.a.denominator],
            [self.b.numerator, self.b.denominator],
        ]


ZERO = QTau()
ONE = QTau(Fraction(1))
TAU = QTau(Fraction(0), Fraction(1))
Matrix = tuple[tuple[QTau, QTau, QTau], tuple[QTau, QTau, QTau], tuple[QTau, QTau, QTau]]
Vector = tuple[QTau, QTau, QTau]
Permutation = tuple[int, int, int, int, int, int]


def qsum(values) -> QTau:
    total = ZERO
    for value in values:
        total += value
    return total


def mat_mul(left: Matrix, right: Matrix) -> Matrix:
    return tuple(
        tuple(qsum(left[i][k] * right[k][j] for k in range(3)) for j in range(3))
        for i in range(3)
    )  # type: ignore[return-value]


def mat_vec(matrix: Matrix, vector: Vector) -> Vector:
    return tuple(qsum(matrix[i][j] * vector[j] for j in range(3)) for i in range(3))  # type: ignore[return-value]


def det3(matrix: Matrix) -> QTau:
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    )


def mat_inverse(matrix: Matrix) -> Matrix:
    determinant = det3(matrix)
    assert determinant != ZERO
    rows = []
    for i in range(3):
        row = []
        for j in range(3):
            source_rows = [r for r in range(3) if r != j]
            source_columns = [c for c in range(3) if c != i]
            minor = (
                matrix[source_rows[0]][source_columns[0]]
                * matrix[source_rows[1]][source_columns[1]]
                - matrix[source_rows[0]][source_columns[1]]
                * matrix[source_rows[1]][source_columns[0]]
            )
            row.append((minor if (i + j) % 2 == 0 else -minor) / determinant)
        rows.append(tuple(row))
    return tuple(rows)  # type: ignore[return-value]


def columns_matrix(columns: list[Vector]) -> Matrix:
    return tuple(tuple(columns[j][i] for j in range(3)) for i in range(3))  # type: ignore[return-value]


def frame_matrix(points: list[Vector]) -> Matrix:
    basis = columns_matrix(points[:3])
    coordinates = mat_vec(mat_inverse(basis), points[3])
    assert all(coordinate != ZERO for coordinate in coordinates)
    return tuple(
        tuple(basis[i][j] * coordinates[j] for j in range(3)) for i in range(3)
    )  # type: ignore[return-value]


def frame_map(source: list[Vector], target: list[Vector]) -> Matrix:
    return mat_mul(frame_matrix(target), mat_inverse(frame_matrix(source)))


def proportional(left: Vector, right: Vector) -> bool:
    return all(
        left[i] * right[j] == left[j] * right[i]
        for i in range(3)
        for j in range(3)
    )


def sigma_vector(vector: Vector) -> Vector:
    return tuple(value.sigma() for value in vector)  # type: ignore[return-value]


def sigma_matrix(matrix: Matrix) -> Matrix:
    return tuple(tuple(value.sigma() for value in row) for row in matrix)  # type: ignore[return-value]


def six_points() -> list[Vector]:
    one_minus_tau = ONE - TAU
    return [
        (ZERO, ONE, one_minus_tau),
        (ZERO, ONE, -one_minus_tau),
        (ONE, one_minus_tau, ZERO),
        (ONE, -one_minus_tau, ZERO),
        (ONE, ZERO, -TAU),
        (ONE, ZERO, TAU),
    ]


def equivalences(source: list[Vector], target: list[Vector]) -> dict[Permutation, Matrix]:
    passing: dict[Permutation, Matrix] = {}
    for raw_permutation in itertools.permutations(range(6)):
        permutation: Permutation = raw_permutation  # type: ignore[assignment]
        matrix = frame_map(source[:4], [target[permutation[i]] for i in range(4)])
        if all(
            proportional(mat_vec(matrix, source[i]), target[permutation[i]])
            for i in range(6)
        ):
            passing[permutation] = matrix
    return passing


def permutation_parity(permutation: Permutation) -> int:
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(6)
        for j in range(i + 1, 6)
    )
    return inversions % 2


def compose(left: Permutation, right: Permutation) -> Permutation:
    """right after left."""
    return tuple(right[left[i]] for i in range(6))  # type: ignore[return-value]


def cycle_type(permutation: Permutation) -> str:
    seen: set[int] = set()
    lengths: list[int] = []
    for start in range(6):
        if start in seen:
            continue
        point = start
        length = 0
        while point not in seen:
            seen.add(point)
            length += 1
            point = permutation[point]
        lengths.append(length)
    return ".".join(str(length) for length in sorted(lengths, reverse=True))


def is_scalar_matrix(matrix: Matrix) -> bool:
    return (
        matrix[0][0] == matrix[1][1] == matrix[2][2]
        and all(matrix[i][j] == ZERO for i in range(3) for j in range(3) if i != j)
    )


def triple_orbits(group: set[Permutation]) -> list[list[tuple[int, int, int]]]:
    triples = set(itertools.combinations(range(6), 3))
    orbits = []
    while triples:
        seed = min(triples)
        orbit = {
            tuple(sorted(permutation[index] for index in seed))
            for permutation in group
        }
        triples -= orbit
        orbits.append(sorted(orbit))
    return sorted(orbits, key=lambda orbit: orbit[0])


def det_columns(points: list[Vector], triple: tuple[int, int, int]) -> QTau:
    return det3(columns_matrix([points[index] for index in triple]))


def line_names() -> list[str]:
    return (
        [f"E{i}" for i in range(6)]
        + [f"L{i}{j}" for i, j in itertools.combinations(range(6), 2)]
        + [f"Q{i}" for i in range(6)]
    )


def line_image(name: str, permutation: Permutation) -> str:
    if name[0] in "EQ":
        return f"{name[0]}{permutation[int(name[1:])]}"
    left, right = sorted((permutation[int(name[1])], permutation[int(name[2])]))
    return f"L{left}{right}"


def lines_intersect(left: str, right: str) -> bool:
    if left == right:
        return False
    if left[0] == "E" and right[0] != "E":
        return lines_intersect(right, left)
    if left[0] == "Q" and right[0] == "E":
        return int(left[1:]) != int(right[1:])
    if left[0] == "L" and right[0] == "E":
        return int(right[1:]) in {int(left[1]), int(left[2])}
    if left[0] == "L" and right[0] == "Q":
        return int(right[1:]) in {int(left[1]), int(left[2])}
    if left[0] == "Q" and right[0] == "L":
        return lines_intersect(right, left)
    if left[0] == right[0] == "L":
        return not ({int(left[1]), int(left[2])} & {int(right[1]), int(right[2])})
    return False


def mod_inv(value: int, prime: int) -> int:
    assert value % prime
    return pow(value % prime, prime - 2, prime)


def mod_normalize(vector: tuple[int, int, int], prime: int) -> tuple[int, int, int]:
    reduced = tuple(value % prime for value in vector)
    pivot = next(value for value in reduced if value)
    scale = mod_inv(pivot, prime)
    return tuple(value * scale % prime for value in reduced)  # type: ignore[return-value]


def mod_mat_vec(matrix, vector, prime: int):
    return tuple(sum(matrix[i][j] * vector[j] for j in range(3)) % prime for i in range(3))


def mod_mat_inverse(matrix, prime: int):
    work = [list(row) + [int(i == j) for j in range(3)] for i, row in enumerate(matrix)]
    for column in range(3):
        pivot = next(row for row in range(column, 3) if work[row][column] % prime)
        work[column], work[pivot] = work[pivot], work[column]
        scale = mod_inv(work[column][column], prime)
        work[column] = [value * scale % prime for value in work[column]]
        for row in range(3):
            if row == column:
                continue
            factor = work[row][column]
            work[row] = [
                (left - factor * right) % prime
                for left, right in zip(work[row], work[column])
            ]
    return tuple(tuple(row[3:]) for row in work)


def mod_mat_mul(left, right, prime: int):
    return tuple(
        tuple(sum(left[i][k] * right[k][j] for k in range(3)) % prime for j in range(3))
        for i in range(3)
    )


def mod_frame(points, prime: int):
    basis = tuple(tuple(points[j][i] for j in range(3)) for i in range(3))
    coordinates = mod_mat_vec(mod_mat_inverse(basis, prime), points[3], prime)
    assert all(coordinates)
    return tuple(
        tuple(basis[i][j] * coordinates[j] % prime for j in range(3)) for i in range(3)
    )


def mod_equivalence_count(source, target, prime: int) -> int:
    source_frame_inverse = mod_mat_inverse(mod_frame(source[:4], prime), prime)
    count = 0
    for permutation in itertools.permutations(range(6)):
        target_frame = mod_frame([target[permutation[i]] for i in range(4)], prime)
        matrix = mod_mat_mul(target_frame, source_frame_inverse, prime)
        if all(
            mod_normalize(mod_mat_vec(matrix, source[i], prime), prime)
            == mod_normalize(target[permutation[i]], prime)
            for i in range(6)
        ):
            count += 1
    return count


def points_mod(prime: int, tau: int):
    raw = [
        (0, 1, 1 - tau),
        (0, 1, tau - 1),
        (1, 1 - tau, 0),
        (1, tau - 1, 0),
        (1, 0, -tau),
        (1, 0, tau),
    ]
    return [mod_normalize(point, prime) for point in raw]


def main() -> dict[str, object]:
    identity: Matrix = ((ONE, ZERO, ZERO), (ZERO, ONE, ZERO), (ZERO, ZERO, ONE))
    points = six_points()
    conjugate_points = [sigma_vector(point) for point in points]
    same = equivalences(points, points)
    cross = equivalences(points, conjugate_points)
    same_permutations = set(same)
    cross_permutations = set(cross)
    assert len(same) == len(cross) == 60
    assert all(permutation_parity(permutation) == 0 for permutation in same)
    assert all(permutation_parity(permutation) == 1 for permutation in cross)
    normalizer = same_permutations | cross_permutations
    assert len(normalizer) == 120
    assert {
        compose(left, right) for left in normalizer for right in normalizer
    } == normalizer

    permutation: Permutation = (1, 0, 4, 5, 2, 3)
    intertwiner: Matrix = (
        (ONE, ZERO, ZERO),
        (ZERO, ZERO, -ONE),
        (ZERO, -ONE, ZERO),
    )
    assert cross[permutation] == intertwiner
    assert mat_mul(sigma_matrix(intertwiner), intertwiner) == identity
    scalars = (TAU - ONE, ONE - TAU, ONE, ONE, ONE, ONE)
    assert all(
        mat_vec(intertwiner, points[index])
        == tuple(scalars[index] * value for value in conjugate_points[permutation[index]])
        for index in range(6)
    )

    involutive_cross = {
        p: matrix
        for p, matrix in cross.items()
        if compose(p, p) == tuple(range(6))
        and is_scalar_matrix(mat_mul(sigma_matrix(matrix), matrix))
    }
    assert len(involutive_cross) == 10
    assert permutation in involutive_cross

    orbits = triple_orbits(same_permutations)
    assert [len(orbit) for orbit in orbits] == [10, 10]
    orbit_index = {triple: index for index, orbit in enumerate(orbits) for triple in orbit}
    assert all(
        orbit_index[tuple(sorted(permutation[index] for index in triple))] == 1 - orbit_index[triple]
        for triple in itertools.combinations(range(6), 3)
    )

    pluecker = []
    for triple in itertools.combinations(range(6), 3):
        target_triple = tuple(sorted(permutation[index] for index in triple))
        source_minor = det_columns(points, triple)
        target_minor = det_columns(conjugate_points, target_triple)
        sign = 1
        ordered_target = tuple(permutation[index] for index in triple)
        sign = -1 if sum(
            ordered_target[i] > ordered_target[j]
            for i in range(3) for j in range(i + 1, 3)
        ) % 2 else 1
        scale = scalars[triple[0]] * scalars[triple[1]] * scalars[triple[2]]
        signed_target = target_minor if sign == 1 else -target_minor
        assert det3(intertwiner) * source_minor == signed_target * scale
        pluecker.append(
            {
                "source": list(triple),
                "target": list(target_triple),
                "source_minor": source_minor.encoded(),
                "target_minor": target_minor.encoded(),
                "column_scale": scale.encoded(),
                "reordering_sign": sign,
            }
        )

    names = line_names()
    intersecting_pairs = {
        tuple(sorted((left, right)))
        for left, right in itertools.combinations(names, 2)
        if lines_intersect(left, right)
    }
    assert len(intersecting_pairs) == 135
    assert all(
        lines_intersect(left, right)
        == lines_intersect(line_image(left, permutation), line_image(right, permutation))
        for left, right in itertools.combinations(names, 2)
    )
    assert all(line_image(f"E{i}", permutation)[0] == "E" for i in range(6))
    assert all(line_image(f"Q{i}", permutation)[0] == "Q" for i in range(6))

    tau8 = points_mod(11, 8)
    tau4 = points_mod(11, 4)
    tau3 = points_mod(5, 3)
    assert mod_equivalence_count(tau8, tau8, 11) == 60
    assert mod_equivalence_count(tau8, tau4, 11) == 60
    assert mod_equivalence_count(tau3, tau3, 5) == 120
    assert all((x * x + y * y + z * z) % 5 == 0 for x, y, z in tau3)

    return {
        "schema": "c377-clebsch-golden-descent-v1",
        "ring": {
            "definition": "Z[tau]/(tau^2-tau-1)",
            "conjugation": "sigma(tau)=1-tau",
            "bad_characteristic_excluded": 2,
        },
        "symbolic_intertwiner": {
            "matrix": [[value.encoded() for value in row] for row in intertwiner],
            "label_permutation": list(permutation),
            "label_cycle_type": cycle_type(permutation),
            "column_scalars": [value.encoded() for value in scalars],
            "cocycle_square": "identity",
            "determinant": det3(intertwiner).encoded(),
        },
        "exact_projective_equivalences": {
            "same_fiber": len(same),
            "same_fiber_parity": "even",
            "cross_fiber": len(cross),
            "cross_fiber_parity": "odd",
            "normalizer": len(normalizer),
            "cross_cycle_types": dict(sorted(Counter(cycle_type(p) for p in cross).items())),
            "involutive_outer_permutations": len(involutive_cross),
            "selected_integral_datum_has_identity_cocycle": True,
        },
        "chirality": {
            "three_subset_orbit_sizes": [len(orbit) for orbit in orbits],
            "descent_exchanges_orbits": True,
            "outer_class": "nontrivial in S5/A5",
        },
        "pluecker": {"checked_minors": len(pluecker), "ledger": pluecker},
        "double_six": {
            "line_count": len(names),
            "intersecting_pairs": len(intersecting_pairs),
            "E_row_action": [permutation[index] for index in range(6)],
            "Q_row_action": [permutation[index] for index in range(6)],
            "rows_exchanged": False,
            "incidence_preserved": True,
            "picard_action": "H fixed; E_i maps to E_pi(i); Q_i maps to Q_pi(i)",
        },
        "code_and_scheme": {
            "column_relation": "J P_i(tau)=lambda_i P_pi(i)(sigma(tau))",
            "monomial_code_equivalence": True,
            "syndrome_direction_equivalence": True,
            "chirality_exchanged": True,
        },
        "specializations": {
            "split": "two linear fibers exchanged by J; outer label class",
            "inert": "J composed with Frobenius is a semilinear involution; outer label class",
            "ramified_5": {
                "tau": 3,
                "six_points_on_conic_x2_y2_z2": True,
                "linear_stabilizer_order": 120,
                "A5_index": 2,
            },
            "q11": {
                "roots": [8, 4],
                "same_fiber_projectivities": 60,
                "cross_fiber_projectivities": 60,
                "selected_permutation_is_outer": True,
            },
        },
        "disposition": {
            "generic_descent_is_standard": True,
            "brauer_obstruction": "trivial",
            "crown_gate": "STOPPED: Benson 2024 already proves the A5 golden outer descent and lambda=1",
            "surviving_scope": "exact Clebsch six-arc, Pluecker, double-six, code, and q=11/q=5 specialization",
        },
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    arguments = parser.parse_args()
    assert not (arguments.check and arguments.write)
    encoded = canonical_bytes(main())
    if arguments.check:
        assert OUTPUT.read_bytes() == encoded
        print("C377 primary check passed")
    elif arguments.write:
        OUTPUT.write_bytes(encoded)
        print(f"wrote {OUTPUT}")
    else:
        print(encoded.decode(), end="")
