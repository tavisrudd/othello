#!/usr/bin/env python3
"""Exact symbolic and finite-field certificate for the C395 AME pencil theorem."""

from __future__ import annotations

import argparse
import collections
import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path
from typing import Callable, Iterable, Sequence


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-07-20-c395-clebsch-ame-pencil-arithmetic.json"
Poly = tuple[int, ...]  # coefficients in ascending order
RatMatrix = tuple[tuple[Fraction, ...], ...]
Permutation = tuple[int, ...]


def trim(a: Sequence[int]) -> Poly:
    out = list(a)
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return tuple(out)


def padd(a: Poly, b: Poly) -> Poly:
    out = [0] * max(len(a), len(b))
    for i, x in enumerate(a):
        out[i] += x
    for i, x in enumerate(b):
        out[i] += x
    return trim(out)


def pneg(a: Poly) -> Poly:
    return tuple(-x for x in a)


def pmul(a: Poly, b: Poly) -> Poly:
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return trim(out)


def ppow(a: Poly, n: int) -> Poly:
    out = (1,)
    while n:
        if n & 1:
            out = pmul(out, a)
        a = pmul(a, a)
        n //= 2
    return out


def pderivative(a: Poly) -> Poly:
    return trim(tuple(i * a[i] for i in range(1, len(a))) or (0,))


def permutation_sign(perm: Sequence[int]) -> int:
    inversions = sum(
        perm[i] > perm[j]
        for i in range(len(perm))
        for j in range(i + 1, len(perm))
    )
    return -1 if inversions & 1 else 1


def polynomial_determinant(matrix: Sequence[Sequence[Poly]]) -> Poly:
    n = len(matrix)
    result = (0,)
    for perm in itertools.permutations(range(n)):
        term = (1,)
        for i, j in enumerate(perm):
            term = pmul(term, matrix[i][j])
        result = padd(result, term if permutation_sign(perm) == 1 else pneg(term))
    return result


def bareiss_determinant(matrix: Sequence[Sequence[int]]) -> int:
    a = [list(row) for row in matrix]
    n = len(a)
    sign = 1
    previous = 1
    for col in range(n - 1):
        pivot = next((i for i in range(col, n) if a[i][col]), None)
        if pivot is None:
            return 0
        if pivot != col:
            a[col], a[pivot] = a[pivot], a[col]
            sign *= -1
        value = a[col][col]
        for i in range(col + 1, n):
            for j in range(col + 1, n):
                numerator = a[i][j] * value - a[i][col] * a[col][j]
                if numerator % previous:
                    raise AssertionError("Bareiss division was not exact")
                a[i][j] = numerator // previous
        previous = value
    return sign * a[-1][-1]


def resultant(a: Poly, b: Poly) -> int:
    m, n = len(a) - 1, len(b) - 1
    ah, bh = list(reversed(a)), list(reversed(b))
    rows: list[list[int]] = []
    for shift in range(n):
        rows.append([0] * shift + ah + [0] * (n - 1 - shift))
    for shift in range(m):
        rows.append([0] * shift + bh + [0] * (m - 1 - shift))
    return bareiss_determinant(rows)


class FiniteField:
    """Tiny deterministic F_p[x]/(modulus), sufficient for the replay fields."""

    def __init__(self, p: int, modulus: Sequence[int]) -> None:
        self.p = p
        self.modulus = tuple(x % p for x in modulus)
        if self.modulus[-1] != 1:
            raise ValueError("modulus must be monic")
        self.degree = len(self.modulus) - 1
        self.order = p**self.degree
        self.zero = (0,) * self.degree
        self.one = (1,) + (0,) * (self.degree - 1)

    def element(self, value: int) -> tuple[int, ...]:
        return (value % self.p,) + (0,) * (self.degree - 1)

    def elements(self) -> Iterable[tuple[int, ...]]:
        return itertools.product(range(self.p), repeat=self.degree)

    def add(self, a: Sequence[int], b: Sequence[int]) -> tuple[int, ...]:
        return tuple((x + y) % self.p for x, y in zip(a, b))

    def neg(self, a: Sequence[int]) -> tuple[int, ...]:
        return tuple(-x % self.p for x in a)

    def sub(self, a: Sequence[int], b: Sequence[int]) -> tuple[int, ...]:
        return self.add(a, self.neg(b))

    def mul(self, a: Sequence[int], b: Sequence[int]) -> tuple[int, ...]:
        out = [0] * (2 * self.degree - 1)
        for i, x in enumerate(a):
            for j, y in enumerate(b):
                out[i + j] = (out[i + j] + x * y) % self.p
        for k in range(len(out) - 1, self.degree - 1, -1):
            coefficient = out[k]
            for j in range(self.degree):
                out[k - self.degree + j] = (
                    out[k - self.degree + j] - coefficient * self.modulus[j]
                ) % self.p
        return tuple(out[: self.degree])

    def pow(self, a: Sequence[int], n: int) -> tuple[int, ...]:
        result = self.one
        base = tuple(a)
        while n:
            if n & 1:
                result = self.mul(result, base)
            base = self.mul(base, base)
            n //= 2
        return result

    def inv(self, a: Sequence[int]) -> tuple[int, ...]:
        if tuple(a) == self.zero:
            raise ZeroDivisionError("zero has no inverse")
        return self.pow(a, self.order - 2)

    def chi(self, a: Sequence[int]) -> int:
        if tuple(a) == self.zero:
            return 0
        value = self.pow(a, (self.order - 1) // 2)
        if value == self.one:
            return 1
        if value == self.neg(self.one):
            return -1
        raise AssertionError("Euler criterion failed")

    def peval(self, polynomial: Poly, t: Sequence[int]) -> tuple[int, ...]:
        result = self.zero
        for coefficient in reversed(polynomial):
            result = self.add(self.mul(result, t), self.element(coefficient))
        return result


def ff_det3(field: FiniteField, columns: Sequence[Sequence[tuple[int, ...]]]) -> tuple[int, ...]:
    a, b, c = columns
    return field.add(
        field.sub(
            field.mul(a[0], field.sub(field.mul(b[1], c[2]), field.mul(b[2], c[1]))),
            field.mul(b[0], field.sub(field.mul(a[1], c[2]), field.mul(a[2], c[1]))),
        ),
        field.mul(c[0], field.sub(field.mul(a[1], b[2]), field.mul(a[2], b[1]))),
    )


def ff_determinant(field: FiniteField, rows: Sequence[Sequence[tuple[int, ...]]]) -> tuple[int, ...]:
    a = [[tuple(x) for x in row] for row in rows]
    result = field.one
    for col in range(len(a)):
        pivot = next((i for i in range(col, len(a)) if a[i][col] != field.zero), None)
        if pivot is None:
            return field.zero
        if pivot != col:
            a[col], a[pivot] = a[pivot], a[col]
            result = field.neg(result)
        value = a[col][col]
        result = field.mul(result, value)
        inverse = field.inv(value)
        a[col] = [field.mul(inverse, x) for x in a[col]]
        for i in range(col + 1, len(a)):
            factor = a[i][col]
            a[i] = [field.sub(x, field.mul(factor, y)) for x, y in zip(a[i], a[col])]
    return result


def ff_points(field: FiniteField, t: Sequence[int]) -> tuple[tuple[tuple[int, ...], ...], ...]:
    z, o = field.zero, field.one
    return (
        (z, o, field.sub(o, t)),
        (z, o, field.sub(t, o)),
        (o, field.sub(o, t), z),
        (o, field.sub(t, o), z),
        (o, z, field.neg(t)),
        (o, z, tuple(t)),
    )


def finite_field_replay(p: int, modulus: Sequence[int]) -> dict[str, object]:
    field = FiniteField(p, modulus)
    q1, q2 = (1, -1, 1), (1, -3, 1)
    quartic = (1, -4, 7, -4, 1)
    valid: list[tuple[int, ...]] = []
    grs: list[tuple[int, ...]] = []
    direct_quartic: list[tuple[int, ...]] = []
    for t in field.elements():
        points = ff_points(field, t)
        arc = all(
            ff_det3(field, tuple(points[i] for i in triple)) != field.zero
            for triple in itertools.combinations(range(6), 3)
        )
        formula = all(
            field.peval(poly, t) != field.zero for poly in ((0, 1), (-1, 1), q1, q2)
        )
        if arc != formula:
            raise AssertionError(f"arc formula failed over F_{field.order}")
        conic_rows = []
        for x, y, z in points:
            conic_rows.append(
                [
                    field.mul(x, x), field.mul(y, y), field.mul(z, z),
                    field.mul(x, y), field.mul(x, z), field.mul(y, z),
                ]
            )
        conic_zero = ff_determinant(field, conic_rows) == field.zero
        quartic_zero = field.peval(quartic, t) == field.zero
        if arc and conic_zero != quartic_zero:
            raise AssertionError(f"GRS formula failed over F_{field.order}")
        if arc:
            valid.append(tuple(t))
            if conic_zero:
                grs.append(tuple(t))
        if quartic_zero:
            direct_quartic.append(tuple(t))
    predicted_arc_count = field.order - 4 - field.chi(field.element(-3)) - field.chi(field.element(5))
    root_count = sum(
        1 + field.chi(field.add(field.mul(s, s), field.mul(field.element(4), s)))
        for s in field.elements()
        if field.mul(s, s) == field.element(-1)
    )
    if len(valid) != predicted_arc_count:
        raise AssertionError("quadratic-character arc count failed")
    if len(grs) != root_count or len(direct_quartic) != root_count:
        raise AssertionError("quadratic-character reciprocal-quartic count failed")
    return {
        "order": field.order,
        "characteristic": p,
        "modulus_ascending": list(modulus),
        "arc_count": len(valid),
        "predicted_arc_count": predicted_arc_count,
        "grs_count": len(grs),
        "reciprocal_quartic_character_count": root_count,
    }


RationalPoint = tuple[Fraction, Fraction, Fraction]
RATIONAL_POINTS: tuple[RationalPoint, ...] = tuple(
    tuple(Fraction(x) for x in point)
    for point in ((0, 1, 2), (0, 1, -2), (1, 2, 0), (1, -2, 0), (1, 0, 1), (1, 0, -1))
)


def rat_matmul(a: RatMatrix, b: RatMatrix) -> RatMatrix:
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(3)) for j in range(3)) for i in range(3))


def rat_matvec(a: RatMatrix, v: Sequence[Fraction]) -> tuple[Fraction, ...]:
    return tuple(sum(a[i][k] * v[k] for k in range(3)) for i in range(3))


def rat_inverse(a: RatMatrix) -> RatMatrix:
    rows = [list(row) + [Fraction(i == j) for j in range(3)] for i, row in enumerate(a)]
    for col in range(3):
        pivot = next(i for i in range(col, 3) if rows[i][col])
        rows[col], rows[pivot] = rows[pivot], rows[col]
        value = rows[col][col]
        rows[col] = [x / value for x in rows[col]]
        for i in range(3):
            if i != col:
                value = rows[i][col]
                rows[i] = [x - value * y for x, y in zip(rows[i], rows[col])]
    return tuple(tuple(row[3:]) for row in rows)


def rat_frame_transform(frame: Sequence[int]) -> RatMatrix:
    basis = tuple(tuple(RATIONAL_POINTS[frame[j]][i] for j in range(3)) for i in range(3))
    coordinates = rat_matvec(rat_inverse(basis), RATIONAL_POINTS[frame[3]])
    scaled = tuple(tuple(basis[i][j] * coordinates[j] for j in range(3)) for i in range(3))
    return rat_inverse(scaled)


def cross(a: Sequence[Fraction], b: Sequence[Fraction]) -> tuple[Fraction, ...]:
    return (
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    )


def prime_factors(value: int) -> tuple[int, ...]:
    value = abs(value)
    result: list[int] = []
    divisor = 2
    while divisor * divisor <= value:
        if value % divisor == 0:
            result.append(divisor)
            while value % divisor == 0:
                value //= divisor
        divisor += 1
    if value > 1:
        result.append(value)
    return tuple(result)


def stabilizer_obstructions(source_frame: Sequence[int]) -> list[tuple[Permutation, RatMatrix, int]]:
    source_transform = rat_frame_transform(source_frame)
    records = []
    for perm in itertools.permutations(range(6)):
        target_frame = tuple(perm[i] for i in source_frame)
        matrix = rat_matmul(rat_inverse(rat_frame_transform(target_frame)), source_transform)
        residuals = tuple(
            value
            for i, point in enumerate(RATIONAL_POINTS)
            for value in cross(rat_matvec(matrix, point), RATIONAL_POINTS[perm[i]])
        )
        if all(value == 0 for value in residuals):
            obstruction = 0
        else:
            denominator = math.lcm(*(value.denominator for value in residuals))
            obstruction = abs(math.gcd(*(int(value * denominator) for value in residuals)))
        records.append((perm, matrix, obstruction))
    return records


def matrix_mod_p(matrix: RatMatrix, p: int) -> tuple[tuple[int, ...], ...]:
    reduced = tuple(
        tuple(value.numerator * pow(value.denominator, -1, p) % p for value in row)
        for row in matrix
    )
    first = next(value for row in reduced for value in row if value)
    scale = pow(first, -1, p)
    return tuple(tuple(value * scale % p for value in row) for row in reduced)


def compose(left: Permutation, right: Permutation) -> Permutation:
    return tuple(left[right[i]] for i in range(6))


def generated_group(generators: Sequence[Permutation]) -> set[Permutation]:
    identity = tuple(range(6))
    group = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            product = compose(generator, current)
            if product not in group:
                group.add(product)
                frontier.append(product)
    return group


def permutation_order(perm: Permutation) -> int:
    current = tuple(range(6))
    for n in range(1, 61):
        current = compose(perm, current)
        if current == tuple(range(6)):
            return n
    raise AssertionError("unexpected permutation order")


def primitive_integer_matrix(matrix: RatMatrix) -> tuple[tuple[int, ...], ...]:
    denominator = math.lcm(*(value.denominator for row in matrix for value in row))
    values = [int(value * denominator) for row in matrix for value in row]
    divisor = abs(math.gcd(*values))
    values = [value // divisor for value in values]
    if next(value for value in values if value) < 0:
        values = [-value for value in values]
    return tuple(tuple(values[3 * i + j] for j in range(3)) for i in range(3))


def stabilizer_certificate() -> dict[str, object]:
    records = stabilizer_obstructions((0, 1, 2, 4))
    replay = stabilizer_obstructions((0, 2, 3, 5))
    generic = {perm for perm, _, obstruction in records if obstruction == 0}
    if len(generic) != 12:
        raise AssertionError("generic stabilizer does not have order 12")
    generic_generators = (
        (1, 0, 2, 3, 5, 4),
        (2, 3, 4, 5, 0, 1),
    )
    if generated_group(generic_generators) != generic:
        raise AssertionError("displayed integral matrices do not generate the generic A4")
    obstruction_counts = collections.Counter(obstruction for _, _, obstruction in records if obstruction)
    enhancement_prime_counts: collections.Counter[int] = collections.Counter()
    for _, _, obstruction in records:
        for prime in prime_factors(obstruction):
            enhancement_prime_counts[prime] += 1
    if {prime for prime in enhancement_prime_counts if prime != 2} != {17, 31}:
        raise AssertionError("unexpected odd enhancement prime")
    groups = {}
    for p, expected_order, expected_profile, name in (
        (7, 12, {1: 1, 2: 3, 3: 8}, "A4"),
        (17, 24, {1: 1, 2: 9, 3: 8, 4: 6}, "S4"),
        (31, 60, {1: 1, 2: 15, 3: 20, 5: 24}, "A5"),
    ):
        selected = [(perm, matrix) for perm, matrix, obstruction in records if obstruction == 0 or obstruction % p == 0]
        replay_selected = {perm for perm, _, obstruction in replay if obstruction == 0 or obstruction % p == 0}
        permutations = {perm for perm, _ in selected}
        if len(permutations) != expected_order or permutations != replay_selected:
            raise AssertionError(f"stabilizer/replay mismatch in characteristic {p}")
        profile = collections.Counter(permutation_order(perm) for perm in permutations)
        if dict(profile) != expected_profile:
            raise AssertionError(f"unexpected element-order profile in characteristic {p}")
        generators = list(generic_generators)
        extra = None
        if p in (17, 31):
            extra = next((perm, matrix) for perm, matrix in selected if perm not in generic)
            generators.append(extra[0])
        if generated_group(generators) != permutations:
            raise AssertionError(f"displayed generators do not generate characteristic-{p} stabilizer")
        groups[str(p)] = {
            "abstract_group": name,
            "order": len(permutations),
            "element_order_profile": {str(k): profile[k] for k in sorted(profile)},
            "extra_generator_permutation": list(extra[0]) if extra else None,
            "extra_generator_matrix_mod_p": [list(row) for row in matrix_mod_p(extra[1], p)] if extra else None,
        }
    generic_matrices = {}
    by_permutation = {perm: matrix for perm, matrix, _ in records}
    for perm in generic_generators:
        generic_matrices[str(list(perm))] = [list(row) for row in primitive_integer_matrix(by_permutation[perm])]
    return {
        "permutations_checked": len(records),
        "generic_group": "A4",
        "generic_order": len(generic),
        "generic_generator_matrices_over_Z": generic_matrices,
        "nonzero_obstruction_gcd_counts": {str(k): obstruction_counts[k] for k in sorted(obstruction_counts)},
        "prime_divisor_permutation_counts": {str(k): enhancement_prime_counts[k] for k in sorted(enhancement_prime_counts)},
        "admissible_odd_enhancement_primes": [17, 31],
        "alternate_frame_replay": [0, 2, 3, 5],
        "full_stabilizers": groups,
    }


def symbolic_certificate() -> dict[str, object]:
    z, o, t = (0,), (1,), (0, 1)
    one_minus_t, t_minus_one = (1, -1), (-1, 1)
    points = (
        (z, o, one_minus_t), (z, o, t_minus_one),
        (o, one_minus_t, z), (o, t_minus_one, z),
        (o, z, pneg(t)), (o, z, t),
    )
    minors = []
    for triple in itertools.combinations(range(6), 3):
        matrix = tuple(tuple(points[j][i] for j in triple) for i in range(3))
        minors.append({"triple": list(triple), "coefficients_ascending": list(polynomial_determinant(matrix))})
    allowed_factors = ((0, 1), (-1, 1), (1, -1, 1), (1, -3, 1))
    product = (1,)
    for factor in allowed_factors:
        product = pmul(product, factor)
    # Every minor must divide a power of the radical product; direct labels make the union explicit.
    exact_polynomials = collections.Counter(tuple(record["coefficients_ascending"]) for record in minors)
    expected_polynomials = collections.Counter(
        {
            (-2, 2): 4, (-2, 4, -2): 1, (-1, 1, -1): 2, (-1, 3, -1): 2,
            (0, -2): 2, (0, -2, 2): 2, (0, 2, -2): 2, (1, -3, 1): 2,
            (1, -1, 1): 2, (2, -4, 2): 1,
        }
    )
    if exact_polynomials != expected_polynomials:
        raise AssertionError("symbolic three-minor ledger changed")
    conic_rows = []
    for x, y, zc in points:
        conic_rows.append((pmul(x, x), pmul(y, y), pmul(zc, zc), pmul(x, y), pmul(x, zc), pmul(y, zc)))
    conic = polynomial_determinant(conic_rows)
    quartic = (1, -4, 7, -4, 1)
    expected_conic = pmul((8,), pmul(t, pmul(ppow(t_minus_one, 2), quartic)))
    if conic != expected_conic:
        raise AssertionError("conic determinant factorization failed")
    resultants = {
        "t2_minus_t_plus_1": resultant(quartic, (1, -1, 1)),
        "t2_minus_3t_plus_1": resultant(quartic, (1, -3, 1)),
    }
    discriminant = resultant(quartic, pderivative(quartic))
    if resultants != {"t2_minus_t_plus_1": 4, "t2_minus_3t_plus_1": 4} or discriminant != 272:
        raise AssertionError("resultant/discriminant regression")
    reciprocal_identity = pmul(ppow(t, 2), padd(ppow(padd(padd(ppow(t, 2), (1,)), pmul((-2,), t)), 2), ppow(t, 2)))
    if reciprocal_identity != pmul(ppow(t, 2), quartic):
        raise AssertionError("reciprocal-quartic identity failed after clearing t^-1")
    return {
        "minor_count": len(minors),
        "three_column_minors": minors,
        "arc_radical_product_coefficients_ascending": list(product),
        "conic_determinant_coefficients_ascending": list(conic),
        "reciprocal_quartic_coefficients_ascending": list(quartic),
        "resultants": resultants,
        "quartic_discriminant": discriminant,
        "t_minus_one_specialization": {
            "arc_quadratic_values": [3, 5],
            "reciprocal_quartic_value": 17,
            "admissible_odd_characteristics_excluded": [3, 5],
            "grs_transition_characteristic": 17,
        },
    }


def build_certificate() -> dict[str, object]:
    field_specs = (
        (3, (1, 0, 1)),       # F_9, x^2+1
        (5, (2, 0, 1)),       # F_25, x^2+2
        (3, (2, 2, 0, 1)),    # F_27, x^3-x-1
        (7, (1, 0, 1)),       # F_49, x^2+1
        (7, (0, 1)), (11, (0, 1)), (13, (0, 1)), (17, (0, 1)),
        (19, (0, 1)), (23, (0, 1)), (29, (0, 1)), (31, (0, 1)), (37, (0, 1)),
    )
    return {
        "schema": "c395-clebsch-ame-pencil-arithmetic-v1",
        "symbolic": symbolic_certificate(),
        "finite_field_replays": [finite_field_replay(p, modulus) for p, modulus in field_specs],
        "tetrahedral_stabilizer": stabilizer_certificate(),
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="verify the tracked certificate")
    args = parser.parse_args()
    payload = canonical_bytes(build_certificate())
    digest = hashlib.sha256(payload).hexdigest()
    if args.check:
        tracked = OUTPUT.read_bytes()
        if payload != tracked:
            raise SystemExit(
                f"certificate mismatch: regenerated {digest} != tracked {hashlib.sha256(tracked).hexdigest()}"
            )
        print(f"ok {OUTPUT.name} {len(payload)} bytes sha256={digest}")
    else:
        OUTPUT.write_bytes(payload)
        print(f"wrote {OUTPUT.name} {len(payload)} bytes sha256={digest}")


if __name__ == "__main__":
    main()
