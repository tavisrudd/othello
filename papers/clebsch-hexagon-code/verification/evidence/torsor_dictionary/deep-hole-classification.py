#!/usr/bin/env python3
"""Exact semilinear census for deep_hole_classification's six-arc conic deep-hole transform."""

from __future__ import annotations

import argparse
import hashlib
import json
import tempfile
from collections import Counter
from itertools import combinations, permutations, product
from pathlib import Path


STEM = "deep-hole-classification"
SCHEMA = "deep_hole_classification-conic-deep-hole-classification-v1"
FIELDS = (4, 5, 7, 8, 9, 11, 13)
Point = tuple[int, int, int]
Arc = tuple[Point, ...]
Form = tuple[int, int, int, int, int, int]


class FiniteField:
    """Deterministic polynomial-basis models for every prime power in FIELDS."""

    DATA = {
        4: (2, 2, (1, 1)),       # x^2+x+1
        5: (5, 1, ()),
        7: (7, 1, ()),
        8: (2, 3, (1, 1, 0)),    # x^3+x+1
        9: (3, 2, (1, 0)),       # x^2+1
        11: (11, 1, ()),
        13: (13, 1, ()),
    }

    def __init__(self, q: int) -> None:
        self.q = q
        self.p, self.degree, self.modulus = self.DATA[q]
        assert self.p**self.degree == q
        self._add_table = tuple(tuple(self._add_raw(a, b) for b in range(q)) for a in range(q))
        self._mul_table = tuple(tuple(self._mul_raw(a, b) for b in range(q)) for a in range(q))
        self._neg_table = tuple(self._neg_raw(a) for a in range(q))

    def coefficients(self, value: int) -> tuple[int, ...]:
        answer = []
        for _ in range(self.degree):
            answer.append(value % self.p)
            value //= self.p
        return tuple(answer)

    def encode(self, coefficients: list[int] | tuple[int, ...]) -> int:
        answer = 0
        place = 1
        for coefficient in coefficients[: self.degree]:
            answer += (coefficient % self.p) * place
            place *= self.p
        return answer

    def _add_raw(self, left: int, right: int) -> int:
        return self.encode([a + b for a, b in zip(self.coefficients(left), self.coefficients(right))])

    def add(self, left: int, right: int) -> int:
        return self._add_table[left][right]

    def _neg_raw(self, value: int) -> int:
        return self.encode([-a for a in self.coefficients(value)])

    def neg(self, value: int) -> int:
        return self._neg_table[value]

    def sub(self, left: int, right: int) -> int:
        return self.add(left, self.neg(right))

    def _mul_raw(self, left: int, right: int) -> int:
        if self.degree == 1:
            return left * right % self.p
        a = self.coefficients(left)
        b = self.coefficients(right)
        coefficients = [0] * (2 * self.degree - 1)
        for i, x in enumerate(a):
            for j, y in enumerate(b):
                coefficients[i + j] = (coefficients[i + j] + x * y) % self.p
        for exponent in range(2 * self.degree - 2, self.degree - 1, -1):
            leading = coefficients[exponent] % self.p
            if not leading:
                continue
            shift = exponent - self.degree
            for i, coefficient in enumerate(self.modulus):
                coefficients[shift + i] -= leading * coefficient
        return self.encode(coefficients)

    def mul(self, left: int, right: int) -> int:
        return self._mul_table[left][right]

    def pow(self, value: int, exponent: int) -> int:
        answer = 1
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, value)
            value = self.mul(value, value)
            exponent >>= 1
        return answer

    def inverse(self, value: int) -> int:
        assert value
        return self.pow(value, self.q - 2)

    def div(self, left: int, right: int) -> int:
        return self.mul(left, self.inverse(right))

    def frobenius(self, value: int, power: int = 1) -> int:
        return self.pow(value, self.p**power)


def normalize(field: FiniteField, vector: tuple[int, ...]) -> tuple[int, ...]:
    scale = field.inverse(next(entry for entry in vector if entry))
    return tuple(field.mul(scale, entry) for entry in vector)


def projective_points(field: FiniteField) -> tuple[Point, ...]:
    return tuple(sorted({normalize(field, vector) for vector in product(range(field.q), repeat=3) if any(vector)}))  # type: ignore[return-value]


def det3(field: FiniteField, a: Point, b: Point, c: Point) -> int:
    positive = field.add(
        field.add(field.mul(a[0], field.mul(b[1], c[2])), field.mul(a[1], field.mul(b[2], c[0]))),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    negative = field.add(
        field.add(field.mul(a[2], field.mul(b[1], c[0])), field.mul(a[1], field.mul(b[0], c[2]))),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(positive, negative)


def is_arc(field: FiniteField, points: Arc) -> bool:
    return len(set(points)) == len(points) and all(det3(field, *triple) for triple in combinations(points, 3))


def mat_vec(field: FiniteField, matrix: tuple[int, ...], point: Point) -> Point:
    values = []
    for row in range(3):
        value = 0
        for column in range(3):
            value = field.add(value, field.mul(matrix[3 * row + column], point[column]))
        values.append(value)
    return tuple(values)  # type: ignore[return-value]


def inverse3(field: FiniteField, columns: tuple[Point, Point, Point]) -> tuple[int, ...]:
    a, b, c = columns
    determinant = det3(field, a, b, c)
    assert determinant
    # Rows of the adjugate of the matrix with columns a,b,c.
    rows = (
        (field.sub(field.mul(b[1], c[2]), field.mul(c[1], b[2])),
         field.sub(field.mul(c[0], b[2]), field.mul(b[0], c[2])),
         field.sub(field.mul(b[0], c[1]), field.mul(c[0], b[1]))),
        (field.sub(field.mul(c[1], a[2]), field.mul(a[1], c[2])),
         field.sub(field.mul(a[0], c[2]), field.mul(c[0], a[2])),
         field.sub(field.mul(c[0], a[1]), field.mul(a[0], c[1]))),
        (field.sub(field.mul(a[1], b[2]), field.mul(b[1], a[2])),
         field.sub(field.mul(b[0], a[2]), field.mul(a[0], b[2])),
         field.sub(field.mul(a[0], b[1]), field.mul(b[0], a[1]))),
    )
    scale = field.inverse(determinant)
    return tuple(field.mul(scale, entry) for row in rows for entry in row)


FRAME: Arc = ((1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 1))


def frame_normalize(field: FiniteField, ordered_frame: tuple[Point, Point, Point, Point], arc: Arc) -> Arc:
    inverse = inverse3(field, ordered_frame[:3])
    fourth = mat_vec(field, inverse, ordered_frame[3])
    assert all(fourth)
    diagonal = tuple(field.inverse(entry) for entry in fourth)
    transformed = []
    for point in arc:
        coordinates = mat_vec(field, inverse, point)
        transformed.append(normalize(field, tuple(field.mul(diagonal[i], coordinates[i]) for i in range(3))))
    return tuple(sorted(transformed))  # type: ignore[return-value]


def canonical_arc(field: FiniteField, arc: Arc) -> Arc:
    images = []
    for power in range(field.degree):
        twisted = tuple(tuple(field.frobenius(x, power) for x in point) for point in arc)
        for ordered in permutations(twisted, 4):
            images.append(frame_normalize(field, ordered, twisted))
    return min(images)


def semilinear_images(field: FiniteField, arc: Arc) -> set[Arc]:
    images = set()
    for power in range(field.degree):
        twisted = tuple(tuple(field.frobenius(x, power) for x in point) for point in arc)
        for ordered in permutations(twisted, 4):
            images.add(frame_normalize(field, ordered, twisted))
    return images


def normalized_arcs(field: FiniteField) -> tuple[tuple[Arc, int], ...]:
    points = projective_points(field)
    candidates = tuple(point for point in points if is_arc(field, FRAME + (point,)))
    remaining = {tuple(sorted(FRAME + pair)) for pair in combinations(candidates, 2) if is_arc(field, FRAME + pair)}
    universe = set(remaining)
    representatives = []
    while remaining:
        seed = min(remaining)
        images = semilinear_images(field, seed)
        assert images <= universe
        orbit = images & remaining
        assert orbit
        representatives.append((min(images), len(images)))
        remaining.difference_update(orbit)
    assert sum(size for _, size in representatives) == len(universe)
    return tuple(sorted(representatives))


def line_points(field: FiniteField, a: Point, b: Point, points: tuple[Point, ...]) -> set[Point]:
    return {point for point in points if not det3(field, a, b, point)}


def uncovered_locus(field: FiniteField, arc: Arc, points: tuple[Point, ...]) -> tuple[Point, ...]:
    covered: set[Point] = set()
    for a, b in combinations(arc, 2):
        covered.update(line_points(field, a, b, points))
    return tuple(point for point in points if point not in covered)


def support_three_locus(field: FiniteField, arc: Arc, points: tuple[Point, ...]) -> tuple[Point, ...]:
    answer = []
    arc_set = set(arc)
    secants = tuple(combinations(arc, 2))
    for point in points:
        if point in arc_set:
            weight = 1
        elif any(not det3(field, a, b, point) for a, b in secants):
            weight = 2
        else:
            assert det3(field, arc[0], arc[1], arc[2])
            weight = 3
        if weight == 3:
            answer.append(point)
    return tuple(answer)


def quadratic_row(field: FiniteField, point: Point) -> tuple[int, ...]:
    x, y, z = point
    return (field.mul(x, x), field.mul(y, y), field.mul(z, z), field.mul(x, y), field.mul(x, z), field.mul(y, z))


def nullspace(field: FiniteField, rows: list[tuple[int, ...]], width: int = 6) -> tuple[tuple[int, ...], ...]:
    matrix = [list(row) for row in rows]
    pivots: list[int] = []
    pivot_row = 0
    for column in range(width):
        found = next((row for row in range(pivot_row, len(matrix)) if matrix[row][column]), None)
        if found is None:
            continue
        matrix[pivot_row], matrix[found] = matrix[found], matrix[pivot_row]
        scale = field.inverse(matrix[pivot_row][column])
        matrix[pivot_row] = [field.mul(scale, value) for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row == pivot_row or not matrix[row][column]:
                continue
            factor = matrix[row][column]
            matrix[row] = [field.sub(x, field.mul(factor, y)) for x, y in zip(matrix[row], matrix[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    free = [column for column in range(width) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * width
        vector[free_column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = field.neg(matrix[row][free_column])
        basis.append(tuple(vector))
    return tuple(basis)


def evaluate_form(field: FiniteField, form: Form, point: Point) -> int:
    value = 0
    for coefficient, monomial in zip(form, quadratic_row(field, point)):
        value = field.add(value, field.mul(coefficient, monomial))
    return value


def nonsingular(field: FiniteField, form: Form, points: tuple[Point, ...]) -> bool:
    a, b, c, d, e, f = form
    two = 2 % field.p
    for x, y, z in points:
        if evaluate_form(field, form, (x, y, z)):
            continue
        dx = field.add(field.add(field.mul(field.mul(two, a), x), field.mul(d, y)), field.mul(e, z))
        dy = field.add(field.add(field.mul(field.mul(two, b), y), field.mul(d, x)), field.mul(f, z))
        dz = field.add(field.add(field.mul(field.mul(two, c), z), field.mul(e, x)), field.mul(f, y))
        if not (dx or dy or dz):
            return False
    return True


def containing_conics(field: FiniteField, locus: tuple[Point, ...], points: tuple[Point, ...]) -> tuple[Form, ...]:
    basis = nullspace(field, [quadratic_row(field, point) for point in locus])
    if not basis:
        return ()
    forms = set()
    for coefficients in product(range(field.q), repeat=len(basis)):
        if not any(coefficients):
            continue
        values = []
        for column in range(6):
            value = 0
            for coefficient, vector in zip(coefficients, basis):
                value = field.add(value, field.mul(coefficient, vector[column]))
            values.append(value)
        normalized = normalize(field, tuple(values))
        forms.add(normalized)
    answer = []
    for form in sorted(forms):
        typed = tuple(form)  # type: ignore[assignment]
        if nonsingular(field, typed, points):
            answer.append(typed)
    return tuple(answer)


def containing_conic(field: FiniteField, locus: tuple[Point, ...], points: tuple[Point, ...]) -> Form | None:
    conics = containing_conics(field, locus, points)
    return conics[0] if conics else None


def lies_on_conic(field: FiniteField, arc: Arc, points: tuple[Point, ...]) -> bool:
    return containing_conic(field, arc, points) is not None


def automorphism_order(field: FiniteField, arc: Arc) -> int:
    count = 0
    for power in range(field.degree):
        twisted = tuple(tuple(field.frobenius(x, power) for x in point) for point in arc)
        for ordered in permutations(twisted, 4):
            image = frame_normalize(field, ordered, twisted)
            if image == arc:
                count += 1
    # Each semilinear automorphism is counted once for each ordered target frame, hence once.
    return count


def field_record(q: int) -> dict[str, object]:
    field = FiniteField(q)
    points = projective_points(field)
    arc_orbits = normalized_arcs(field)
    stabilizers = {}
    for arc, presentation_orbit_size in arc_orbits:
        stabilizer_order = automorphism_order(field, arc)
        assert presentation_orbit_size * stabilizer_order == 360 * field.degree
        stabilizers[arc] = stabilizer_order
    stabilizer_histogram = Counter(stabilizers.values())
    grs_orbits = sum(lies_on_conic(field, arc, points) for arc, _ in arc_orbits)
    survivors = []
    for arc, presentation_orbit_size in arc_orbits:
        if lies_on_conic(field, arc, points):
            continue
        locus = uncovered_locus(field, arc, points)
        if not locus:
            continue
        conics = containing_conics(field, locus, points)
        if not conics:
            continue
        form = conics[0]
        stabilizer_order = stabilizers[arc]
        assert locus == support_three_locus(field, arc, points)
        conic_points = tuple(point for point in points if not evaluate_form(field, form, point))
        assert len(conic_points) == q + 1
        assert set(locus) <= set(conic_points)
        assert is_arc(field, locus)
        survivors.append(
            {
                "arc": [list(point) for point in arc],
                "automorphism_order": stabilizer_order,
                "conic_form": list(form),
                "containing_nonsingular_conics": len(conics),
                "full_conic": locus == conic_points,
                "locus": [list(point) for point in locus],
                "locus_size": len(locus),
                "normalized_presentation_orbit_size": presentation_orbit_size,
            }
        )
    normalized_presentations = sum(size for _, size in arc_orbits)
    return {
        "q": q,
        "projective_points": len(points),
        "normalized_six_arc_presentations": normalized_presentations,
        "grs_six_arc_orbits": grs_orbits,
        "non_grs_six_arc_orbits": len(arc_orbits) - grs_orbits,
        "semilinear_six_arc_orbits": len(arc_orbits),
        "semilinear_stabilizer_histogram": {
            str(order): count for order, count in sorted(stabilizer_histogram.items())
        },
        "survivor_count": len(survivors),
        "survivors": survivors,
    }


def build_certificate(fields: tuple[int, ...] = FIELDS) -> dict[str, object]:
    return {
        "schema": SCHEMA,
        "field_size_reduction": {
            "inequality": "q^2 <= 15(q+1)",
            "largest_integer_q": 15,
            "fields_with_six_arcs": list(FIELDS),
        },
        "fields": [field_record(q) for q in fields],
    }


def canonical_bytes(certificate: dict[str, object]) -> bytes:
    return (json.dumps(certificate, indent=2, sort_keys=True) + "\n").encode()


def check_tracked(root: Path) -> None:
    tracked = root / f"{STEM}.json"
    expected = tracked.read_bytes()
    with tempfile.TemporaryDirectory(prefix="deep-hole-classification-check-") as directory:
        generated = Path(directory) / tracked.name
        generated.write_bytes(canonical_bytes(build_certificate()))
        actual = generated.read_bytes()
    if actual != expected:
        raise SystemExit(f"generated certificate differs from {tracked}")
    print(f"checked {tracked.relative_to(root)} ({len(expected)} bytes, sha256 {hashlib.sha256(expected).hexdigest()})")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--fields", nargs="*", type=int, choices=FIELDS)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    if args.check:
        check_tracked(root)
        return
    output = args.output or root / f"{STEM}.json"
    fields = tuple(args.fields) if args.fields else FIELDS
    output.write_bytes(canonical_bytes(build_certificate(fields)))
    print(output)


if __name__ == "__main__":
    main()
