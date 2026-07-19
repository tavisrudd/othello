#!/usr/bin/env python3
"""Deterministic small-field falsifier for C348's layered arc family."""

from __future__ import annotations

import argparse
import hashlib
import json
from array import array
from dataclasses import dataclass
from itertools import combinations
from pathlib import Path


@dataclass(frozen=True)
class GF2m:
    degree: int
    modulus: int

    @property
    def size(self) -> int:
        return 1 << self.degree

    def mul(self, a: int, b: int) -> int:
        out = 0
        while b:
            if b & 1:
                out ^= a
            b >>= 1
            a <<= 1
            if a & self.size:
                a ^= self.modulus
        return out

    def square(self, a: int) -> int:
        return self.mul(a, a)

    def pow(self, a: int, exponent: int) -> int:
        out = 1
        while exponent:
            if exponent & 1:
                out = self.mul(out, a)
            a = self.square(a)
            exponent >>= 1
        return out

    def inv(self, a: int) -> int:
        if not a:
            raise ZeroDivisionError
        return self.pow(a, self.size - 2)


class QuadraticTower:
    """E=F(omega), omega^2+omega+1=0, for odd [F:F_2]."""

    def __init__(self, base: GF2m):
        if base.degree % 2 != 1:
            raise ValueError("the quadratic polynomial is irreducible only for odd base degree")
        self.base = base
        self.q = base.size
        self.size = self.q * self.q
        self._inverses = [0] + [self.pow(x, self.size - 2) for x in range(1, self.size)]

    def pair(self, x: int) -> tuple[int, int]:
        return x % self.q, x // self.q

    def elt(self, a: int, b: int = 0) -> int:
        return a + self.q * b

    def add(self, x: int, y: int) -> int:
        return x ^ y

    def mul(self, x: int, y: int) -> int:
        a, b = self.pair(x)
        c, d = self.pair(y)
        ac = self.base.mul(a, c)
        bd = self.base.mul(b, d)
        omega = self.base.mul(a, d) ^ self.base.mul(b, c) ^ bd
        return self.elt(ac ^ bd, omega)

    def square(self, x: int) -> int:
        return self.mul(x, x)

    def pow(self, x: int, exponent: int) -> int:
        out = 1
        while exponent:
            if exponent & 1:
                out = self.mul(out, x)
            x = self.square(x)
            exponent >>= 1
        return out

    def inv(self, x: int) -> int:
        if not x:
            raise ZeroDivisionError
        return self._inverses[x]

    def div(self, x: int, y: int) -> int:
        return self.mul(x, self.inv(y))


Point = tuple[int, int, int]
LineKey = tuple[int, int]


def cross(e: QuadraticTower, p: Point, q: Point) -> Point:
    return (
        e.mul(p[1], q[2]) ^ e.mul(p[2], q[1]),
        e.mul(p[2], q[0]) ^ e.mul(p[0], q[2]),
        e.mul(p[0], q[1]) ^ e.mul(p[1], q[0]),
    )


def normalize(e: QuadraticTower, p: Point) -> Point:
    pivot = next(x for x in p if x)
    scale = e.inv(pivot)
    return tuple(e.mul(scale, x) for x in p)  # type: ignore[return-value]


def incident(e: QuadraticTower, line: Point, point: Point) -> bool:
    return not (
        e.mul(line[0], point[0])
        ^ e.mul(line[1], point[1])
        ^ e.mul(line[2], point[2])
    )


def conic_point(e: QuadraticTower, x: int, height: int) -> Point:
    return (1, x, e.square(x) ^ height)


def layered_points(e: QuadraticTower, rho: int, a: int, b: int) -> tuple[Point, ...]:
    omega = e.elt(0, 1)
    rho_omega = e.mul(e.elt(rho), omega)
    points = []
    for t in range(e.q):
        points.append(conic_point(e, e.elt(t), a))
        points.append(conic_point(e, e.elt(t), b))
        points.append(conic_point(e, omega ^ e.elt(t), 0))
        points.append(conic_point(e, rho_omega ^ e.elt(t), 0))
    return tuple(points)


def affine_line(e: QuadraticTower, p: Point, q: Point) -> LineKey:
    dx = p[1] ^ q[1]
    if not dx:
        return (-1, p[1])
    slope = e.div(p[2] ^ q[2], dx)
    return (slope, p[2] ^ e.mul(slope, p[1]))


def secant_lines(e: QuadraticTower, points: tuple[Point, ...]) -> tuple[LineKey, ...] | None:
    lines = tuple(affine_line(e, p, q) for p, q in combinations(points, 2))
    return lines if len(set(lines)) == len(lines) else None


def direction_images(e: QuadraticTower, rho: int, a: int, b: int) -> set[int]:
    omega = e.elt(0, 1)
    d_omega = e.mul(e.elt(1 ^ rho), omega)
    rho_omega = e.mul(e.elt(rho), omega)
    images = {e.elt(t) for t in range(1, e.q)}
    families = [
        (d_omega, 0),
        (omega, a),
        (omega, b),
        (rho_omega, a),
        (rho_omega, b),
    ]
    for offset, delta in families:
        for t in range(e.q):
            p = offset ^ e.elt(t)
            images.add(p ^ e.div(delta, p))
    for t in range(1, e.q):
        p = e.elt(t)
        images.add(p ^ e.div(a ^ b, p))
    return images


def classify_fixture(
    e: QuadraticTower, rho: int, a: int, b: int
) -> dict[str, object]:
    points = layered_points(e, rho, a, b)
    lines = secant_lines(e, points)
    if lines is None:
        raise ValueError("fixture is not an arc")
    plane_order = e.size
    affine_count = plane_order * plane_order
    multiplicity = array("H", [0]) * (affine_count + plane_order + 1)
    for slope, intercept in lines:
        if slope == -1:
            for z in range(plane_order):
                multiplicity[intercept * plane_order + z] += 1
            multiplicity[affine_count + plane_order] += 1
        else:
            for x in range(plane_order):
                multiplicity[x * plane_order + (e.mul(slope, x) ^ intercept)] += 1
            multiplicity[affine_count + slope] += 1
    point_ids = {x * plane_order + z for _, x, z in points}
    hole_ids = [i for i, count in enumerate(multiplicity) if not count and i not in point_ids]
    affine_holes = sum(i < affine_count for i in hole_ids)
    infinity_holes = {m for m in range(plane_order) if not multiplicity[affine_count + m]}
    expected_infinity = set(range(e.size)) - direction_images(e, rho, a, b)
    if infinity_holes != expected_infinity:
        raise AssertionError("C330 direction-image mismatch")
    deep_holes = affine_holes + len(infinity_holes)
    q_plane = e.size
    n = len(points)
    secants = n * (n - 1) // 2
    base_weight_two = q_plane * q_plane + q_plane + 1 - n - deep_holes
    histogram: dict[int, int] = {}
    for i, count in enumerate(multiplicity):
        if i not in point_ids:
            histogram[count] = histogram.get(count, 0) + 1
    first_moment = sum(j * count for j, count in histogram.items())
    second_moment = sum(j * (j - 1) // 2 * count for j, count in histogram.items())
    if first_moment != secants * (q_plane - 1):
        raise AssertionError("secant first-moment mismatch")
    expected_second = secants * (secants - 1) // 2 - n * (n - 1) * (n - 2) // 2
    if second_moment != expected_second:
        raise AssertionError("secant second-moment mismatch")

    def decode(point_id: int) -> Point:
        if point_id < affine_count:
            return (1, point_id // plane_order, point_id % plane_order)
        if point_id < affine_count + plane_order:
            return (0, 1, point_id - affine_count)
        return (0, 0, 1)

    invalid_pairs = 0
    decoded_holes = [decode(i) for i in hole_ids]
    for arc_point in points:
        pencil: dict[Point, int] = {}
        for hole in decoded_holes:
            line = normalize(e, cross(e, arc_point, hole))
            pencil[line] = pencil.get(line, 0) + 1
        invalid_pairs += sum(count * (count - 1) // 2 for count in pencil.values())
    all_pairs = deep_holes * (deep_holes - 1) // 2
    valid_pairs = all_pairs - invalid_pairs
    infinity_pairs = len(infinity_holes) * (len(infinity_holes) - 1) // 2
    return {
        "rho": rho,
        "a": list(e.pair(a)),
        "b": list(e.pair(b)),
        "arc_points": n,
        "secants": secants,
        "projective_deep_holes": deep_holes,
        "affine_deep_holes": affine_holes,
        "infinity_deep_holes": len(infinity_holes),
        "base_projective_weight_two": base_weight_two,
        "secant_multiplicity_histogram": {str(j): count for j, count in sorted(histogram.items())},
        "secant_moment_checks": {"first": first_moment, "second": second_moment},
        "extension_directions": {
            "one_column": deep_holes,
            "two_column": valid_pairs,
            "infinity_one_column": len(infinity_holes),
            "infinity_two_column": infinity_pairs,
            "infinity_three_column": 0,
        },
        "enumerator": {
            "a1(T)": str(n),
            "a2(T)": f"{secants}*(T-{q_plane})+{base_weight_two}",
            "a3(T)": f"T^2+T+1-a1(T)-a2(T)",
            "alpha_i(T)": "alpha_0=1; alpha_i=(T-1)*a_i(T) for i=1,2,3",
        },
    }


def find_fixtures(
    e: QuadraticTower, limit: int, candidate_limit: int | None = None
) -> tuple[list[tuple[int, int, int]], int]:
    fixtures = []
    tested = 0
    for rho in range(2, e.q):
        for a in range(1, e.size):
            for b in range(a + 1, e.size):
                if (a ^ b) < e.q:  # C329 requires Gamma_alpha+Gamma_beta outside F.
                    continue
                points = layered_points(e, rho, a, b)
                if secant_lines(e, points) is not None:
                    fixtures.append((rho, a, b))
                    if len(fixtures) == limit:
                        return fixtures, tested + 1
                tested += 1
                if candidate_limit is not None and tested == candidate_limit:
                    return fixtures, tested
    return fixtures, tested


def find_lcg_fixtures(
    e: QuadraticTower, limit: int, candidate_limit: int
) -> tuple[list[tuple[int, int, int]], int]:
    fixtures = []
    state = 1
    tested = 0
    for _ in range(candidate_limit):
        state = (1103515245 * state + 12345) & 0x7FFFFFFF
        rho = 2 + state % (e.q - 2)
        state = (1103515245 * state + 12345) & 0x7FFFFFFF
        a = 1 + state % (e.size - 1)
        state = (1103515245 * state + 12345) & 0x7FFFFFFF
        b = 1 + state % (e.size - 1)
        if a == b or (a ^ b) < e.q:
            continue
        tested += 1
        a, b = sorted((a, b))
        if secant_lines(e, layered_points(e, rho, a, b)) is not None:
            fixture = (rho, a, b)
            if fixture not in fixtures:
                fixtures.append(fixture)
                if len(fixtures) == limit:
                    break
    return fixtures, tested


def generate() -> dict[str, object]:
    small = QuadraticTower(GF2m(3, 0b1011))  # x^3+x+1
    small_fixtures, small_tested = find_fixtures(small, 1)
    base = GF2m(5, 0b100101)  # x^5+x^2+1
    extension = QuadraticTower(base)
    fixtures, tested = find_lcg_fixtures(extension, 4, 4096)
    results = [classify_fixture(extension, *fixture) for fixture in fixtures]
    return {
        "schema": "c348-layered-deep-hole-falsifier-v1",
        "exceptional_field_ledger": {
            "Q=8": {
                "search": "complete normalized parameter scan",
                "normalized_candidates_tested": small_tested,
                "arcs": len(small_fixtures),
            }
        },
        "field": {"F": 32, "E": 1024, "F_modulus": "x^5+x^2+1", "omega": "omega^2+omega+1=0"},
        "search": {
            "order": "fixed ANSI-C LCG seed 1",
            "candidate_draws": 4096,
            "normalized_candidates_tested": tested,
            "fixture_limit": 4,
            "fixtures_found": len(fixtures),
        },
        "fixtures": results,
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = generate()
    payload = canonical_bytes(data)
    if args.check:
        tracked = Path(__file__).with_suffix(".json")
        if tracked.read_bytes() != payload:
            raise SystemExit("tracked JSON does not match deterministic regeneration")
        print(f"ok {hashlib.sha256(payload).hexdigest()} {len(payload)}")
    elif args.output:
        args.output.write_bytes(payload)
    else:
        print(payload.decode(), end="")


if __name__ == "__main__":
    main()
