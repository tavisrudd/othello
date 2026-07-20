#!/usr/bin/env python3
"""Exact arithmetic-phase certificate for C400's scalar-A5 schemes."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, deque
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-20-c400-a5-fourier-phases.json"

Vector = tuple[int, int, int]
Matrix = tuple[Vector, Vector, Vector]


@dataclass(frozen=True)
class Field:
    """The mandated prime fields and F_9=F_3[tau]/(tau^2-tau-1)."""

    q: int

    @property
    def p(self) -> int:
        return 3 if self.q == 9 else self.q

    def add(self, left: int, right: int) -> int:
        if self.q != 9:
            return (left + right) % self.q
        return ((left % 3 + right % 3) % 3) + 3 * (
            (left // 3 + right // 3) % 3
        )

    def neg(self, value: int) -> int:
        return self.mul(self.q - 1 if self.q != 9 else 2, value)

    def sub(self, left: int, right: int) -> int:
        return self.add(left, self.neg(right))

    def mul(self, left: int, right: int) -> int:
        if self.q != 9:
            return left * right % self.q
        a, b = left % 3, left // 3
        c, d = right % 3, right // 3
        # tau^2=tau+1; encode a+b*tau as a+3b.
        return (a * c + b * d) % 3 + 3 * ((a * d + b * c + b * d) % 3)

    def power(self, value: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, value)
            value = self.mul(value, value)
            exponent //= 2
        return answer

    def inv(self, value: int) -> int:
        assert value
        return self.power(value, self.q - 2)

    def square(self, value: int) -> int:
        return self.mul(value, value)

    def scalar(self, value: int) -> int:
        return value % self.p


def tau_value(field: Field) -> int:
    if field.q == 9:
        return 3  # encoded tau
    roots = [
        value
        for value in range(field.q)
        if field.sub(field.sub(field.square(value), value), 1) == 0
    ]
    assert roots
    return max(roots)


def dot(left: Vector, right: Vector, field: Field) -> int:
    total = 0
    for a, b in zip(left, right):
        total = field.add(total, field.mul(a, b))
    return total


def scale_vector(scalar: int, vector: Vector, field: Field) -> Vector:
    return tuple(field.mul(scalar, value) for value in vector)  # type: ignore[return-value]


def normalize(vector: Vector, field: Field) -> Vector:
    pivot = next(value for value in vector if value)
    return scale_vector(field.inv(pivot), vector, field)


def mat_mul(left: Matrix, right: Matrix, field: Field) -> Matrix:
    return tuple(
        tuple(
            dot(left[i], tuple(right[k][j] for k in range(3)), field)
            for j in range(3)
        )
        for i in range(3)
    )  # type: ignore[return-value]


def mat_vec(matrix: Matrix, vector: Vector, field: Field) -> Vector:
    return tuple(dot(row, vector, field) for row in matrix)  # type: ignore[return-value]


def mat_transpose(matrix: Matrix) -> Matrix:
    return tuple(tuple(matrix[j][i] for j in range(3)) for i in range(3))  # type: ignore[return-value]


def mat_normalize(matrix: Matrix, field: Field) -> Matrix:
    pivot = next(value for row in matrix for value in row if value)
    scalar = field.inv(pivot)
    return tuple(scale_vector(scalar, row, field) for row in matrix)  # type: ignore[return-value]


def projective_points(field: Field) -> set[Vector]:
    return {
        normalize(vector, field)
        for vector in itertools.product(range(field.q), repeat=3)
        if vector != (0, 0, 0)
    }


def h3_roots(field: Field, tau: int) -> set[Vector]:
    one = 1
    roots = {(one, 0, 0), (0, one, 0), (0, 0, one)}
    tau_minus_one = field.sub(tau, one)
    for left_sign, right_sign in itertools.product((one, field.neg(one)), repeat=2):
        root = (
            one,
            field.mul(left_sign, tau),
            field.mul(right_sign, tau_minus_one),
        )
        roots.update(normalize(root[i:] + root[:i], field) for i in range(3))
    assert len(roots) == 15
    return roots


def six_points(field: Field, tau: int) -> set[Vector]:
    one = 1
    raw = [
        (0, one, field.sub(one, tau)),
        (0, one, field.sub(tau, one)),
        (one, field.sub(one, tau), 0),
        (one, field.sub(tau, one), 0),
        (one, 0, field.neg(tau)),
        (one, 0, tau),
    ]
    answer = {normalize(point, field) for point in raw}
    assert len(answer) == 6
    return answer


def reflection(root: Vector, field: Field) -> Matrix:
    denominator = dot(root, root, field)
    factor = field.mul(field.scalar(2), field.inv(denominator))
    return tuple(
        tuple(
            field.sub(int(i == j), field.mul(factor, field.mul(root[i], root[j])))
            for j in range(3)
        )
        for i in range(3)
    )  # type: ignore[return-value]


def reflection_group(field: Field, roots: set[Vector]) -> set[Matrix]:
    identity: Matrix = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    generators = [mat_normalize(reflection(root, field), field) for root in sorted(roots)]
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            child = mat_normalize(mat_mul(current, generator, field), field)
            if child not in group:
                group.add(child)
                queue.append(child)
                assert len(group) <= 60
    assert len(group) == 60
    return group


def group_closure(field: Field, generators: list[Matrix], cap: int) -> set[Matrix]:
    identity: Matrix = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            child = mat_normalize(mat_mul(current, generator, field), field)
            if child not in group:
                group.add(child)
                queue.append(child)
                assert len(group) <= cap
    return group


def omega_group(field: Field, points: set[Vector]) -> tuple[set[Matrix], int]:
    """Construct projective Omega_3(q) from equal-spinor-class reflection pairs."""
    squares = {field.square(value) for value in range(1, field.q)}
    reflections_by_type: dict[bool, list[Matrix]] = {False: [], True: []}
    for point in sorted(points):
        norm = dot(point, point, field)
        if norm:
            reflections_by_type[norm in squares].append(reflection(point, field))
    candidates = []
    for reflections in reflections_by_type.values():
        base = reflections[0]
        candidates.extend(
            mat_normalize(mat_mul(base, item, field), field)
            for item in reflections[1:]
        )
    target = field.q * (field.q**2 - 1) // 2
    generators: list[Matrix] = []
    group: set[Matrix] = {((1, 0, 0), (0, 1, 0), (0, 0, 1))}
    for candidate in candidates:
        if candidate in group:
            continue
        generators.append(candidate)
        group = group_closure(field, generators, target)
        if len(group) == target:
            break
    assert len(group) == target
    return group, len(generators)


def projective_orbits(
    field: Field, group: set[Matrix], points: set[Vector]
) -> list[set[Vector]]:
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {normalize(mat_vec(matrix, seed, field), field) for matrix in group}
        assert orbit <= points
        unseen -= orbit
        answer.append(orbit)
    return answer


def orbit_label(
    orbit: set[Vector],
    field: Field,
    group: set[Matrix],
    roots: set[Vector],
    columns: set[Vector],
) -> tuple[str, int, int]:
    representative = min(orbit)
    stabilizer = sum(
        normalize(mat_vec(matrix, representative, field), field) == representative
        for matrix in group
    )
    mirror_multiplicity = sum(dot(root, representative, field) == 0 for root in roots)
    if representative in columns:
        base = "source_D5"
    elif stabilizer == 6 and mirror_multiplicity == 3:
        base = "triple_S3"
    elif stabilizer == 4 and mirror_multiplicity == 2:
        base = "double_V4"
    elif stabilizer == 2 and mirror_multiplicity == 1:
        base = "mirror_C2"
    elif stabilizer == 3 and mirror_multiplicity == 0:
        base = "deep_C3"
    elif stabilizer == 5 and mirror_multiplicity == 0:
        base = "deep_C5"
    elif stabilizer == 1 and mirror_multiplicity == 0:
        base = "deep_free"
    else:
        raise AssertionError((field.q, representative, stabilizer, mirror_multiplicity))
    return base, stabilizer, mirror_multiplicity


def ordered_orbits(
    field: Field,
    group: set[Matrix],
    roots: set[Vector],
    columns: set[Vector],
) -> tuple[list[str], list[set[Vector]], list[int], list[int]]:
    priority = {
        "source_D5": 0,
        "triple_S3": 1,
        "double_V4": 2,
        "mirror_C2": 3,
        "deep_C3": 4,
        "deep_C5": 5,
        "deep_free": 6,
    }
    data = []
    for orbit in projective_orbits(field, group, projective_points(field)):
        base, stabilizer, multiplicity = orbit_label(
            orbit, field, group, roots, columns
        )
        data.append((priority[base], min(orbit), base, orbit, stabilizer, multiplicity))
    data.sort()
    counters: Counter[str] = Counter()
    labels = ["zero"]
    orbits = [{(0, 0, 0)}]
    stabilizers = [60]
    multiplicities = [0]
    for _, _, base, orbit, stabilizer, multiplicity in data:
        counters[base] += 1
        labels.append(f"{base}_{counters[base]}")
        orbits.append(orbit)
        stabilizers.append(stabilizer)
        multiplicities.append(multiplicity)
    return labels, orbits, stabilizers, multiplicities


def quadratic_type(vector: Vector, field: Field) -> str:
    if vector == (0, 0, 0):
        return "zero_vector"
    value = dot(vector, vector, field)
    if value == 0:
        return "isotropic"
    squares = {field.square(item) for item in range(1, field.q)}
    return "square" if value in squares else "nonsquare"


def eigenmatrix(orbits: list[set[Vector]], field: Field) -> list[list[int]]:
    representatives = [min(orbit) for orbit in orbits]
    answer = []
    for character in representatives:
        row = []
        for index, orbit in enumerate(orbits):
            if index == 0:
                row.append(1)
                continue
            zero_lines = sum(dot(character, line, field) == 0 for line in orbit)
            row.append(field.q * zero_lines - len(orbit))
        answer.append(row)
    return answer


def mat_int_mul(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [
        [sum(left[i][k] * right[k][j] for k in range(len(right))) for j in range(len(right[0]))]
        for i in range(len(left))
    ]


def canonical_partition(blocks: list[list[int]]) -> list[list[int]]:
    return sorted(
        (sorted(block) for block in blocks if block),
        key=lambda block: (0 not in block, block),
    )


def row_partition(matrix: list[list[int]], column_blocks: list[list[int]]) -> list[list[int]]:
    signatures: dict[tuple[int, ...], list[int]] = {}
    for row in range(len(matrix)):
        signature = tuple(sum(matrix[row][column] for column in block) for block in column_blocks)
        signatures.setdefault(signature, []).append(row)
    return canonical_partition(list(signatures.values()))


def is_self_dual_fusion(matrix: list[list[int]], blocks: list[list[int]]) -> bool:
    return row_partition(matrix, blocks) == canonical_partition(blocks)


def set_partitions(items: tuple[int, ...]):
    if not items:
        yield []
        return
    first, rest = items[0], items[1:]
    for partition in set_partitions(rest):
        yield [[first]] + [block[:] for block in partition]
        for index in range(len(partition)):
            yield [
                ([first] + block if position == index else block[:])
                for position, block in enumerate(partition)
            ]


def exhaustive_fusions(matrix: list[list[int]]) -> tuple[int, list[dict[str, object]]]:
    rank = len(matrix)
    assert rank <= 8
    tested = 0
    answer = []
    for partition in set_partitions(tuple(range(1, rank))):
        tested += 1
        relation_blocks = [[0]] + partition
        dual_blocks = row_partition(matrix, relation_blocks)
        if len(dual_blocks) == len(relation_blocks):
            answer.append(
                {
                    "rank": len(relation_blocks),
                    "relation_blocks": canonical_partition(relation_blocks),
                    "dual_blocks": dual_blocks,
                }
            )
    answer.sort(key=lambda item: (item["rank"], item["relation_blocks"]))
    return tested, answer


def orbit_formula(q: int) -> dict[str, int]:
    epsilon3 = int(q % 3 == 1)
    epsilon5 = int(q % 5 == 1)
    free = ((q - 5) * (q - 9) - 20 * epsilon3 - 12 * epsilon5) // 60
    assert free >= 0
    return {
        "D5": 1,
        "S3": 1,
        "V4": 1,
        "C2": (q - 5) // 2,
        "C3": epsilon3,
        "C5": epsilon5,
        "trivial": free,
    }


def isotropic_orbit_formula(q: int, characteristic: int) -> dict[str, int]:
    characteristic_three = int(characteristic == 3)
    characteristic_five = int(characteristic == 5)
    epsilon2 = int(characteristic not in (3, 5) and q % 4 == 1)
    epsilon3 = int(characteristic != 3 and q % 3 == 1)
    epsilon5 = int(characteristic != 5 and q % 5 == 1)
    free = (
        q
        + 1
        - 6 * characteristic_five
        - 10 * characteristic_three
        - 30 * epsilon2
        - 20 * epsilon3
        - 12 * epsilon5
    ) // 60
    assert free >= 0
    return {
        "D5": characteristic_five,
        "S3": characteristic_three,
        "C2": epsilon2,
        "C3": epsilon3,
        "C5": epsilon5,
        "trivial": free,
    }


def field_certificate(q: int) -> dict[str, object]:
    field = Field(q)
    tau = tau_value(field)
    roots = h3_roots(field, tau)
    columns = six_points(field, tau)
    group = reflection_group(field, roots)
    assert all(
        mat_normalize(mat_mul(mat_transpose(matrix), matrix, field), field)
        == ((1, 0, 0), (0, 1, 0), (0, 0, 1))
        for matrix in group
    )
    labels, projective, stabilizers, mirror_multiplicities = ordered_orbits(
        field, group, roots, columns
    )
    p_matrix = eigenmatrix(projective, field)
    rank = len(projective)
    product = mat_int_mul(p_matrix, p_matrix)
    assert all(product[i][j] == q**3 * int(i == j) for i in range(rank) for j in range(rank))
    valencies = [1] + [(q - 1) * len(orbit) for orbit in projective[1:]]
    assert p_matrix[0] == valencies
    types = [quadratic_type(min(orbit), field) for orbit in projective]
    orthogonal_blocks = canonical_partition(
        [[index for index, item in enumerate(types) if item == kind]
         for kind in ("zero_vector", "isotropic", "square", "nonsquare")]
    )
    assert is_self_dual_fusion(p_matrix, orthogonal_blocks)
    trivial_blocks = [[0], list(range(1, rank))]
    assert is_self_dual_fusion(p_matrix, trivial_blocks)

    observed = Counter()
    for stabilizer in stabilizers[1:]:
        observed[{10: "D5", 6: "S3", 4: "V4", 2: "C2", 3: "C3", 5: "C5", 1: "trivial"}[stabilizer]] += 1
    assert dict(observed) == {key: value for key, value in orbit_formula(q).items() if value}

    observed_isotropic = Counter()
    stabilizer_name = {
        10: "D5",
        6: "S3",
        4: "V4",
        2: "C2",
        3: "C3",
        5: "C5",
        1: "trivial",
    }
    isotropic_block = [index for index, item in enumerate(types) if item == "isotropic"]
    for index in isotropic_block:
        observed_isotropic[stabilizer_name[stabilizers[index]]] += 1
    assert dict(observed_isotropic) == {
        key: value
        for key, value in isotropic_orbit_formula(q, field.p).items()
        if value
    }

    # Burnside's lemma: the order-2, order-3, and order-5 projective fixed-point
    # counts are q+2, 1+2*epsilon_3, and 1+2*epsilon_5 respectively.
    fixed3 = 1 + 2 * int(field.p != 3 and q % 3 == 1)
    fixed5 = 1 + 2 * int(field.p != 5 and q % 5 == 1)
    burnside_numerator = q * q + q + 1 + 15 * (q + 2) + 20 * fixed3 + 24 * fixed5
    assert burnside_numerator % 60 == 0
    assert 1 + burnside_numerator // 60 == rank

    omega, omega_generator_count = omega_group(field, projective_points(field))
    assert group <= omega
    omega_projective_orbits = projective_orbits(field, omega, projective_points(field))
    assert sorted(map(len, omega_projective_orbits)) == sorted(
        [q + 1, q * (q - 1) // 2, q * (q + 1) // 2]
    )
    omega_blocks = []
    for omega_orbit in omega_projective_orbits:
        block = [
            index
            for index, a5_orbit in enumerate(projective[1:], 1)
            if a5_orbit <= omega_orbit
        ]
        assert set().union(*(projective[index] for index in block)) == omega_orbit
        omega_blocks.append(block)
    assert canonical_partition([[0]] + omega_blocks) == orthogonal_blocks

    exhaustive = None
    if rank <= 8:
        tested, fusions = exhaustive_fusions(p_matrix)
        exhaustive = {
            "set_partitions_tested": tested,
            "fusion_count": len(fusions),
            "fusions": fusions,
        }

    decoder_blocks = canonical_partition(
        [
            [0],
            [index for index, label in enumerate(labels) if label.startswith("source_")],
            [index for index, label in enumerate(labels) if label.startswith("triple_")],
            [index for index, label in enumerate(labels) if label.startswith("double_")],
            [index for index, label in enumerate(labels) if label.startswith("mirror_")],
            [index for index, label in enumerate(labels) if label.startswith("deep_")],
        ]
    )
    decoder_dual_blocks = row_partition(p_matrix, decoder_blocks)

    return {
        "q": q,
        "tau_encoding": tau,
        "rank": rank,
        "relation_labels": labels,
        "projective_orbit_sizes": [len(orbit) for orbit in projective],
        "valencies": valencies,
        "point_stabilizer_orders": stabilizers,
        "mirror_multiplicities": mirror_multiplicities,
        "quadratic_types": types,
        "orbit_formula": orbit_formula(q),
        "isotropic_orbit_formula": isotropic_orbit_formula(q, field.p),
        "burnside_fixed_points_by_order": {
            "1": q * q + q + 1,
            "2": q + 2,
            "3": fixed3,
            "5": fixed5,
        },
        "first_and_second_eigenmatrix": p_matrix,
        "formal_fourier_self_dual": True,
        "orthogonal_fusion_blocks": orthogonal_blocks,
        "orthogonal_group_order": len(omega),
        "orthogonal_group_generator_count": omega_generator_count,
        "orthogonal_projective_orbit_sizes": sorted(map(len, omega_projective_orbits)),
        "exhaustive_coherent_fusions_when_feasible": exhaustive,
        "decoder_weight_partition_blocks": decoder_blocks,
        "decoder_weight_partition_dual_block_count": len(decoder_dual_blocks),
        "decoder_weight_partition_is_fusion": len(decoder_dual_blocks) == len(decoder_blocks),
        "primitive": all(len(orbit) != 1 for orbit in projective[1:]),
    }


def certificate() -> dict[str, object]:
    fields = [field_certificate(q) for q in (5, 9, 11, 19, 29, 59)]
    return {
        "schema": "c400-a5-fourier-phases-v1",
        "comparison_fields": fields,
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(certificate())
    if args.write:
        OUTPUT.write_bytes(data)
    if args.check:
        assert OUTPUT.read_bytes() == data
    if not args.write and not args.check:
        print(data.decode(), end="")
    print(f"sha256={hashlib.sha256(data).hexdigest()} bytes={len(data)}")


if __name__ == "__main__":
    main()
