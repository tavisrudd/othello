#!/usr/bin/env python3
"""C210 structured probe: two parallel subfield parabolas in PG(2,s^2).

For c != 0 put P_c(t) = [1:t:t^2+c], t in GF(s).  If beta-alpha is not in
GF(s), the union of the alpha and beta layers is a 2s-arc disjoint from the
standard conic XZ=Y^2.  This script exhausts the offset pairs, not arbitrary
arcs, and measures the remaining ordinary and off-conic uncovered loci.
"""

from __future__ import annotations

import argparse
import itertools
import json
from dataclasses import dataclass
from math import comb

Point = tuple[int, int, int]


@dataclass(frozen=True)
class QuadraticField:
    s: int
    modulus: int | None = None
    nonsquare: int | None = None

    @property
    def q(self) -> int:
        return self.s * self.s

    @classmethod
    def for_subfield_order(cls, s: int) -> "QuadraticField":
        if s == 3:
            return cls(s=3, nonsquare=2)
        if s == 5:
            return cls(s=5, nonsquare=2)
        if s == 7:
            return cls(s=7, nonsquare=3)
        if s == 4:
            return cls(s=4, modulus=0b10011)  # x^4+x+1
        if s == 8:
            return cls(s=8, modulus=0b1000011)  # x^6+x+1
        raise ValueError(f"unsupported subfield order: {s}")

    def add(self, a: int, b: int) -> int:
        if self.modulus is not None:
            return a ^ b
        return ((a % self.s + b % self.s) % self.s
                + self.s * ((a // self.s + b // self.s) % self.s))

    def neg(self, a: int) -> int:
        if self.modulus is not None:
            return a
        return ((-a % self.s) + self.s * (-(a // self.s) % self.s))

    def sub(self, a: int, b: int) -> int:
        return self.add(a, self.neg(b))

    def mul(self, a: int, b: int) -> int:
        if self.modulus is not None:
            out = 0
            x, y = a, b
            while y:
                if y & 1:
                    out ^= x
                y >>= 1
                x <<= 1
                if x & self.q:
                    x ^= self.modulus
            return out
        assert self.nonsquare is not None
        a0, a1 = a % self.s, a // self.s
        b0, b1 = b % self.s, b // self.s
        return ((a0 * b0 + self.nonsquare * a1 * b1) % self.s
                + self.s * ((a0 * b1 + a1 * b0) % self.s))

    def power(self, a: int, n: int) -> int:
        out = 1
        while n:
            if n & 1:
                out = self.mul(out, a)
            a = self.mul(a, a)
            n >>= 1
        return out

    def inv(self, a: int) -> int:
        if not a:
            raise ZeroDivisionError
        return self.power(a, self.q - 2)

    def div(self, a: int, b: int) -> int:
        return self.mul(a, self.inv(b))

    def in_subfield(self, a: int) -> bool:
        return self.power(a, self.s) == a

    def normalize(self, point: Point) -> Point:
        pivot = next(x for x in point if x)
        scale = self.inv(pivot)
        return tuple(self.mul(scale, x) for x in point)  # type: ignore[return-value]

    def cross(self, x: Point, y: Point) -> Point:
        return self.normalize((
            self.sub(self.mul(x[1], y[2]), self.mul(x[2], y[1])),
            self.sub(self.mul(x[2], y[0]), self.mul(x[0], y[2])),
            self.sub(self.mul(x[0], y[1]), self.mul(x[1], y[0])),
        ))


def projective_points(field: QuadraticField) -> set[Point]:
    q = field.q
    return ({(0, 0, 1)}
            | {(0, 1, z) for z in range(q)}
            | {(1, y, z) for y in range(q) for z in range(q)})


def line_points(field: QuadraticField, line: Point) -> set[Point]:
    a, b, c = line
    q = field.q
    if c:
        affine = {
            (1, y, field.neg(field.div(field.add(a, field.mul(b, y)), c)))
            for y in range(q)
        }
        return affine | {(0, 1, field.neg(field.div(b, c)))}
    if b:
        y = field.neg(field.div(a, b))
        return {(1, y, z) for z in range(q)} | {(0, 0, 1)}
    return {(0, 0, 1)} | {(0, 1, z) for z in range(q)}


def layer(field: QuadraticField, offset: int, subfield: tuple[int, ...]) -> tuple[Point, ...]:
    return tuple((1, t, field.add(field.mul(t, t), offset)) for t in subfield)


def covered_points(field: QuadraticField, arc: tuple[Point, ...]) -> set[Point]:
    lines = {field.cross(x, y) for x, y in itertools.combinations(arc, 2)}
    assert len(lines) == comb(len(arc), 2)
    covered: set[Point] = set()
    for line in lines:
        covered.update(line_points(field, line))
    return covered


def profile(field: QuadraticField, arc: tuple[Point, ...], all_points: set[Point],
            conic: set[Point]) -> tuple[int, int]:
    covered = covered_points(field, arc)
    uncovered = all_points - covered
    return len(uncovered - conic), len(uncovered)


def greedy_relative_completion(field: QuadraticField, seed: tuple[Point, ...],
                               all_points: set[Point], conic: set[Point]) -> tuple[Point, ...]:
    """Add the legal off-conic point with maximum new required coverage."""
    arc = seed
    covered = covered_points(field, arc)
    required = all_points - conic - covered
    while required:
        best_point: Point | None = None
        best_cover: set[Point] = set()
        for point in sorted(required):
            new_cover: set[Point] = set()
            for old in arc:
                new_cover.update(line_points(field, field.cross(point, old)))
            gain = required & new_cover
            if len(gain) > len(best_cover):
                best_point, best_cover = point, gain
        assert best_point is not None and best_cover
        # A required-uncovered point lies on no old secant, hence is a legal arc extension.
        arc = (*arc, best_point)
        covered.update(best_cover)
        required -= best_cover
    assert set(arc).isdisjoint(conic)
    assert len({field.cross(x, y) for x, y in itertools.combinations(arc, 2)}) == comb(len(arc), 2)
    return arc


def run(s: int) -> dict[str, object]:
    field = QuadraticField.for_subfield_order(s)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    assert len(subfield) == s
    all_points = projective_points(field)
    conic = ({(0, 0, 1)}
             | {(1, t, field.mul(t, t)) for t in range(field.q)})
    assert len(all_points) == field.q * field.q + field.q + 1
    assert len(conic) == field.q + 1

    candidates = 0
    complete = 0
    best: tuple[int, int, int, int] | None = None
    offsets = range(1, field.q)
    for alpha, beta in itertools.combinations(offsets, 2):
        if field.in_subfield(field.sub(beta, alpha)):
            continue
        candidates += 1
        arc = layer(field, alpha, subfield) + layer(field, beta, subfield)
        assert len(set(arc)) == 2 * s
        assert set(arc).isdisjoint(conic)
        required_uncovered, ordinary_uncovered = profile(field, arc, all_points, conic)
        if required_uncovered == 0:
            complete += 1
        result = (required_uncovered, ordinary_uncovered, alpha, beta)
        if best is None or result < best:
            best = result
    assert best is not None
    best_seed = layer(field, best[2], subfield) + layer(field, best[3], subfield)
    completed = greedy_relative_completion(field, best_seed, all_points, conic)
    completed_required, completed_ordinary = profile(field, completed, all_points, conic)
    assert completed_required == 0
    return {
        "s": s,
        "q": field.q,
        "k": 2 * s,
        "candidates": candidates,
        "relative_complete": complete,
        "best_required_uncovered": best[0],
        "best_ordinary_uncovered": best[1],
        "best_offsets": [best[2], best[3]],
        "greedy_completed_k": len(completed),
        "greedy_added": [list(point) for point in completed[2 * s:]],
        "greedy_final_ordinary_uncovered": completed_ordinary,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("s", nargs="*", type=int, default=[3, 4, 5, 7, 8])
    args = parser.parse_args()
    for s in args.s:
        print(json.dumps(run(s), sort_keys=True))


if __name__ == "__main__":
    main()
