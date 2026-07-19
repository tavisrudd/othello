#!/usr/bin/env python3
"""Exact certificate for C346: arithmetic reduction of the H3 arrangement.

The symbolic half works in Z[tau], tau^2=tau+1.  It enumerates all
three-by-three minors of the fifteen mirror normals and reconstructs the
rank-two flats from their incidence signatures.  The finite-field half is an
independent point-by-point replay over representative split, inert, and
ramified residue fields.  For odd characteristic it also constructs the
projectivized reflection group and checks its A5 order and orbit geometry.

This file is standard-library-only and deterministic.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter, deque
from itertools import combinations, product
from pathlib import Path
from typing import Iterable, Protocol, TypeAlias


SCHEMA = "c346-h3-good-reduction-v1"
DEFAULT_OUTPUT = Path(__file__).with_suffix(".json")


# Elements of Z[tau], represented by a+b*tau.
QuadInt: TypeAlias = tuple[int, int]
ZI_ZERO: QuadInt = (0, 0)
ZI_ONE: QuadInt = (1, 0)
ZI_TAU: QuadInt = (0, 1)
ZI_TAU_MINUS_ONE: QuadInt = (-1, 1)


def zi_add(left: QuadInt, right: QuadInt) -> QuadInt:
    return left[0] + right[0], left[1] + right[1]


def zi_neg(value: QuadInt) -> QuadInt:
    return -value[0], -value[1]


def zi_sub(left: QuadInt, right: QuadInt) -> QuadInt:
    return zi_add(left, zi_neg(right))


def zi_mul(left: QuadInt, right: QuadInt) -> QuadInt:
    a, b = left
    c, d = right
    return a * c + b * d, a * d + b * c + b * d


def zi_norm(value: QuadInt) -> int:
    a, b = value
    return a * a + a * b - b * b


ZiVector: TypeAlias = tuple[QuadInt, QuadInt, QuadInt]


def zi_roots() -> list[ZiVector]:
    roots: list[ZiVector] = [
        (ZI_ONE, ZI_ZERO, ZI_ZERO),
        (ZI_ZERO, ZI_ONE, ZI_ZERO),
        (ZI_ZERO, ZI_ZERO, ZI_ONE),
    ]
    for left_sign, right_sign in product((1, -1), repeat=2):
        root = (
            ZI_ONE,
            ZI_TAU if left_sign == 1 else zi_neg(ZI_TAU),
            ZI_TAU_MINUS_ONE
            if right_sign == 1
            else zi_neg(ZI_TAU_MINUS_ONE),
        )
        roots.extend((root, (root[1], root[2], root[0]), (root[2], root[0], root[1])))
    assert len(roots) == 15 and len(set(roots)) == 15
    return roots


def zi_det(rows: tuple[ZiVector, ZiVector, ZiVector]) -> QuadInt:
    a, b, c = rows
    return zi_add(
        zi_sub(
            zi_mul(a[0], zi_sub(zi_mul(b[1], c[2]), zi_mul(b[2], c[1]))),
            zi_mul(a[1], zi_sub(zi_mul(b[0], c[2]), zi_mul(b[2], c[0]))),
        ),
        zi_mul(a[2], zi_sub(zi_mul(b[0], c[1]), zi_mul(b[1], c[0]))),
    )


def zi_dot(left: ZiVector, right: ZiVector) -> QuadInt:
    total = ZI_ZERO
    for a, b in zip(left, right):
        total = zi_add(total, zi_mul(a, b))
    return total


def zi_matrix_vector(matrix: tuple[ZiVector, ZiVector, ZiVector], vector: ZiVector) -> ZiVector:
    return tuple(zi_dot(row, vector) for row in matrix)  # type: ignore[return-value]


def zi_projectively_equal(left: ZiVector, right: ZiVector) -> bool:
    cross = (
        zi_sub(zi_mul(left[1], right[2]), zi_mul(left[2], right[1])),
        zi_sub(zi_mul(left[2], right[0]), zi_mul(left[0], right[2])),
        zi_sub(zi_mul(left[0], right[1]), zi_mul(left[1], right[0])),
    )
    return cross == (ZI_ZERO, ZI_ZERO, ZI_ZERO)


def zi_scaled_reflection(root: ZiVector) -> tuple[ZiVector, ZiVector, ZiVector]:
    # d*R=d*I-2rr^T avoids division; d is 1 or 4 for this root model.
    d = zi_dot(root, root)
    rows: list[ZiVector] = []
    for i in range(3):
        row: list[QuadInt] = []
        for j in range(3):
            entry = d if i == j else ZI_ZERO
            entry = zi_sub(entry, zi_mul((2, 0), zi_mul(root[i], root[j])))
            row.append(entry)
        rows.append(tuple(row))  # type: ignore[arg-type]
    return tuple(rows)  # type: ignore[return-value]


def compose_permutations(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def generated_permutation_group(generators: list[tuple[int, ...]]) -> set[tuple[int, ...]]:
    identity = tuple(range(len(generators[0])))
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            child = compose_permutations(current, generator)
            if child not in group:
                group.add(child)
                queue.append(child)
                assert len(group) <= 60
    return group


class Field(Protocol):
    p: int
    degree: int
    order: int
    zero: tuple[int, ...]
    one: tuple[int, ...]

    def elements(self) -> list[tuple[int, ...]]: ...
    def add(self, left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]: ...
    def neg(self, value: tuple[int, ...]) -> tuple[int, ...]: ...
    def mul(self, left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]: ...
    def inv(self, value: tuple[int, ...]) -> tuple[int, ...]: ...
    def power(self, value: tuple[int, ...], exponent: int) -> tuple[int, ...]: ...


class PrimeField:
    degree = 1

    def __init__(self, p: int) -> None:
        self.p = p
        self.order = p
        self.zero = (0,)
        self.one = (1,)

    def elements(self) -> list[tuple[int, ...]]:
        return [(a,) for a in range(self.p)]

    def add(self, left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
        return ((left[0] + right[0]) % self.p,)

    def neg(self, value: tuple[int, ...]) -> tuple[int, ...]:
        return (-value[0] % self.p,)

    def mul(self, left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
        return (left[0] * right[0] % self.p,)

    def power(self, value: tuple[int, ...], exponent: int) -> tuple[int, ...]:
        return (pow(value[0], exponent, self.p),)

    def inv(self, value: tuple[int, ...]) -> tuple[int, ...]:
        assert value != self.zero
        return self.power(value, self.p - 2)


class GoldenQuadraticField:
    """F_p[tau]/(tau^2-tau-1), used only when the polynomial is irreducible."""

    degree = 2

    def __init__(self, p: int) -> None:
        assert p % 5 in (2, 3)
        self.p = p
        self.order = p * p
        self.zero = (0, 0)
        self.one = (1, 0)

    def elements(self) -> list[tuple[int, ...]]:
        return [(a, b) for a in range(self.p) for b in range(self.p)]

    def add(self, left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
        return (left[0] + right[0]) % self.p, (left[1] + right[1]) % self.p

    def neg(self, value: tuple[int, ...]) -> tuple[int, ...]:
        return -value[0] % self.p, -value[1] % self.p

    def mul(self, left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
        a, b = left
        c, d = right
        return (a * c + b * d) % self.p, (a * d + b * c + b * d) % self.p

    def power(self, value: tuple[int, ...], exponent: int) -> tuple[int, ...]:
        result = self.one
        base = value
        while exponent:
            if exponent & 1:
                result = self.mul(result, base)
            base = self.mul(base, base)
            exponent //= 2
        return result

    def inv(self, value: tuple[int, ...]) -> tuple[int, ...]:
        assert value != self.zero
        return self.power(value, self.order - 2)


Element: TypeAlias = tuple[int, ...]
Vector: TypeAlias = tuple[Element, Element, Element]
Matrix: TypeAlias = tuple[Vector, Vector, Vector]


def f_sub(field: Field, left: Element, right: Element) -> Element:
    return field.add(left, field.neg(right))


def f_scale(field: Field, scalar: Element, vector: Vector) -> Vector:
    return tuple(field.mul(scalar, value) for value in vector)  # type: ignore[return-value]


def f_dot(field: Field, left: Vector, right: Vector) -> Element:
    total = field.zero
    for a, b in zip(left, right):
        total = field.add(total, field.mul(a, b))
    return total


def f_normalize(field: Field, vector: Vector) -> Vector:
    pivot = next(value for value in vector if value != field.zero)
    return f_scale(field, field.inv(pivot), vector)


def reduce_zi(field: Field, tau: Element, value: QuadInt) -> Element:
    integer = (value[0] % field.p,) if field.degree == 1 else (value[0] % field.p, 0)
    coefficient = (value[1] % field.p,) if field.degree == 1 else (value[1] % field.p, 0)
    return field.add(integer, field.mul(coefficient, tau))


def reduced_roots(field: Field, tau: Element) -> set[Vector]:
    return {
        f_normalize(field, tuple(reduce_zi(field, tau, coordinate) for coordinate in root))  # type: ignore[arg-type]
        for root in zi_roots()
    }


def projective_points(field: Field) -> list[Vector]:
    elements = field.elements()
    points = (
        [(field.one, y, z) for y in elements for z in elements]
        + [(field.zero, field.one, z) for z in elements]
        + [(field.zero, field.zero, field.one)]
    )
    assert len(points) == field.order * field.order + field.order + 1
    return points


def point_spectrum(field: Field, lines: set[Vector]) -> tuple[Counter[int], dict[Vector, int]]:
    multiplicities = {
        point: sum(f_dot(field, line, point) == field.zero for line in lines)
        for point in projective_points(field)
    }
    return Counter(multiplicities.values()), multiplicities


def matrix_mul(field: Field, left: Matrix, right: Matrix) -> Matrix:
    rows: list[Vector] = []
    for i in range(3):
        row: list[Element] = []
        for j in range(3):
            total = field.zero
            for k in range(3):
                total = field.add(total, field.mul(left[i][k], right[k][j]))
            row.append(total)
        rows.append(tuple(row))  # type: ignore[arg-type]
    return tuple(rows)  # type: ignore[return-value]


def matrix_vector(field: Field, matrix: Matrix, vector: Vector) -> Vector:
    return tuple(f_dot(field, row, vector) for row in matrix)  # type: ignore[return-value]


def normalize_matrix(field: Field, matrix: Matrix) -> Matrix:
    pivot = next(value for row in matrix for value in row if value != field.zero)
    inverse = field.inv(pivot)
    return tuple(f_scale(field, inverse, row) for row in matrix)  # type: ignore[return-value]


def identity_matrix(field: Field) -> Matrix:
    z, o = field.zero, field.one
    return ((o, z, z), (z, o, z), (z, z, o))


def reflection_matrix(field: Field, root: Vector) -> Matrix:
    # s_r(x)=x-2(x.r)/(r.r)r.  This coordinate lattice requires char != 2.
    assert field.p != 2
    two = field.add(field.one, field.one)
    denominator = f_dot(field, root, root)
    assert denominator != field.zero
    factor = field.mul(two, field.inv(denominator))
    rows: list[Vector] = []
    for i in range(3):
        row: list[Element] = []
        for j in range(3):
            entry = field.one if i == j else field.zero
            entry = f_sub(field, entry, field.mul(factor, field.mul(root[i], root[j])))
            row.append(entry)
        rows.append(tuple(row))  # type: ignore[arg-type]
    return tuple(rows)  # type: ignore[return-value]


def projective_reflection_group(field: Field, lines: set[Vector]) -> set[Matrix]:
    generators = [normalize_matrix(field, reflection_matrix(field, root)) for root in sorted(lines)]
    identity = identity_matrix(field)
    group = {identity}
    queue = deque([identity])
    while queue:
        current = queue.popleft()
        for generator in generators:
            child = normalize_matrix(field, matrix_mul(field, current, generator))
            if child not in group:
                group.add(child)
                queue.append(child)
                assert len(group) <= 60
    assert len(group) == 60
    for matrix in group:
        assert {
            f_normalize(field, matrix_vector(field, matrix, line)) for line in lines
        } == lines
    return group


def orbit_sizes(field: Field, group: set[Matrix], objects: Iterable[Vector]) -> list[int]:
    unseen = set(objects)
    sizes: list[int] = []
    while unseen:
        seed = min(unseen)
        orbit = {
            f_normalize(field, matrix_vector(field, matrix, seed)) for matrix in group
        }
        assert orbit <= unseen | (set(objects) - unseen)
        unseen -= orbit
        sizes.append(len(orbit))
    return sorted(sizes)


def symbolic_certificate() -> dict[str, object]:
    roots = zi_roots()
    determinants = [zi_det(triple) for triple in combinations(roots, 3)]
    nonzero = [value for value in determinants if value != ZI_ZERO]
    signatures = {
        tuple(k for k in range(15) if zi_det((roots[i], roots[j], roots[k])) == ZI_ZERO)
        for i, j in combinations(range(15), 2)
    }
    flat_counts = Counter(len(signature) for signature in signatures)
    assert len(determinants) == 455
    assert len(nonzero) == 385
    assert flat_counts == Counter({2: 15, 3: 10, 5: 6})
    norm_counts = Counter(abs(zi_norm(value)) for value in nonzero)
    assert norm_counts == Counter({16: 188, 4: 156, 1: 37, 64: 4})
    reflection_permutations: list[tuple[int, ...]] = []
    reflection_determinant_norms: Counter[int] = Counter()
    for root in roots:
        matrix = zi_scaled_reflection(root)
        reflection_determinant_norms[abs(zi_norm(zi_det(matrix)))] += 1
        permutation = []
        for other in roots:
            image = zi_matrix_vector(matrix, other)
            matches = [
                index for index, target in enumerate(roots) if zi_projectively_equal(image, target)
            ]
            assert len(matches) == 1
            permutation.append(matches[0])
        assert sorted(permutation) == list(range(15))
        reflection_permutations.append(tuple(permutation))
    projective_group = generated_permutation_group(reflection_permutations)
    assert len(projective_group) == 60
    assert reflection_determinant_norms == Counter({4096: 12, 1: 3})
    flat_orbits: dict[str, list[int]] = {}
    for multiplicity in (2, 3, 5):
        relevant = {signature for signature in signatures if len(signature) == multiplicity}
        orbit_sizes_for_stratum: list[int] = []
        while relevant:
            seed = min(relevant)
            orbit = {
                tuple(sorted(permutation[index] for index in seed))
                for permutation in projective_group
            }
            relevant -= orbit
            orbit_sizes_for_stratum.append(len(orbit))
        flat_orbits[str(multiplicity)] = sorted(orbit_sizes_for_stratum)
    assert flat_orbits == {"2": [15], "3": [10], "5": [6]}
    return {
        "rank_3_minor_count": len(determinants),
        "zero_rank_3_minor_count": len(determinants) - len(nonzero),
        "nonzero_rank_3_minor_count": len(nonzero),
        "nonzero_minor_absolute_norm_counts": {str(k): norm_counts[k] for k in sorted(norm_counts)},
        "rank_2_flat_multiplicity_counts": {str(k): flat_counts[k] for k in sorted(flat_counts)},
        "bad_prime_ideals_for_lattice": ["(2)"],
        "projective_reflection_group_order": len(projective_group),
        "projective_singular_stratum_orbit_sizes": flat_orbits,
        "scaled_reflection_determinant_absolute_norm_counts": {
            str(k): reflection_determinant_norms[k] for k in sorted(reflection_determinant_norms)
        },
    }


def field_certificate(name: str, field: Field, tau: Element) -> dict[str, object]:
    lines = reduced_roots(field, tau)
    spectrum, multiplicities = point_spectrum(field, lines)
    result: dict[str, object] = {
        "field": name,
        "characteristic": field.p,
        "field_order": field.order,
        "distinct_mirrors": len(lines),
        "projective_point_multiplicity_spectrum": {
            str(k): spectrum[k] for k in sorted(spectrum)
        },
    }
    if field.p == 2:
        assert len(lines) == 4
        result["projective_A5_action"] = "not_defined_on_this_degenerate_mirror_model"
        return result

    expected = {
        0: (field.order - 5) * (field.order - 9),
        1: 15 * (field.order - 5),
        2: 15,
        3: 10,
        5: 6,
    }
    assert spectrum == Counter({k: v for k, v in expected.items() if v > 0})
    group = projective_reflection_group(field, lines)
    strata_orbits = {
        str(multiplicity): orbit_sizes(
            field,
            group,
            [point for point, value in multiplicities.items() if value == multiplicity],
        )
        for multiplicity in (2, 3, 5)
    }
    assert strata_orbits == {"2": [15], "3": [10], "5": [6]}
    result.update(
        {
            "projective_reflection_group_order": len(group),
            "singular_stratum_orbit_sizes": strata_orbits,
        }
    )
    if field.degree == 2:
        frobenius_lines = {
            f_normalize(
                field,
                tuple(field.power(coordinate, field.p) for coordinate in line),  # type: ignore[arg-type]
            )
            for line in lines
        }
        result["fixed_by_prime_field_frobenius"] = sum(
            f_normalize(
                field,
                tuple(field.power(coordinate, field.p) for coordinate in line),  # type: ignore[arg-type]
            )
            == line
            for line in lines
        )
        result["mirror_set_prime_field_frobenius_stable"] = frobenius_lines == lines
        assert result["fixed_by_prime_field_frobenius"] == 3
        assert result["mirror_set_prime_field_frobenius_stable"] is False
    return result


def build_certificate() -> dict[str, object]:
    f5 = PrimeField(5)
    f11 = PrimeField(11)
    f4 = GoldenQuadraticField(2)
    f9 = GoldenQuadraticField(3)
    fields = [
        field_certificate("F4=tau quotient at (2)", f4, (0, 1)),
        field_certificate("F5, ramified tau=3", f5, (3,)),
        field_certificate("F9, inert characteristic 3", f9, (0, 1)),
        field_certificate("F11, split tau=4", f11, (4,)),
        field_certificate("F11, split tau=8", f11, (8,)),
    ]
    return {
        "schema": SCHEMA,
        "model": {
            "integer_ring": "Z[tau]/(tau^2-tau-1)",
            "mirrors": "coordinate axes plus cyclic permutations of (1,+/-tau,+/-(tau-1))",
        },
        "symbolic": symbolic_certificate(),
        "finite_field_replays": fields,
        "classification": {
            "lattice_good": "every prime ideal except (2)",
            "prime_field_rational": "ramified p=5 and split p congruent to +/-1 mod 5",
            "quadratic_field_only_in_fixed_model": "inert p congruent to +/-2 mod 5",
            "faithful_projective_A5": "every odd prime ideal, over its residue field",
        },
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    action = parser.add_mutually_exclusive_group()
    action.add_argument("--write", action="store_true", help="write the canonical JSON artifact")
    action.add_argument("--check", action="store_true", help="compare regeneration with the tracked artifact")
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()

    content = canonical_bytes(build_certificate())
    if args.write:
        args.output.write_bytes(content)
    elif args.check:
        tracked = args.output.read_bytes()
        assert tracked == content
    digest = hashlib.sha256(content).hexdigest()
    print(f"schema={SCHEMA}")
    print("lattice_good_prime_ideals=all_except_(2)")
    print("projective_A5=faithful_at_every_odd_prime_ideal")
    print(f"certificate_sha256={digest}")
    print("C346_GOOD_REDUCTION_PASS")


if __name__ == "__main__":
    main()
