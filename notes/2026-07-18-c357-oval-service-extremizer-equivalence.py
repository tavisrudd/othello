#!/usr/bin/env python3
"""Exact q=5,7,9 falsifier for the C357 oval recovery classification."""

from __future__ import annotations

import argparse
import hashlib
import json
from functools import lru_cache
from pathlib import Path


class Field:
    def __init__(self, q: int):
        if q not in (5, 7, 9):
            raise ValueError("the certificate supports exactly q=5,7,9")
        self.q = q
        self.p = 3 if q == 9 else q

    def add(self, x: int, y: int) -> int:
        if self.q != 9:
            return (x + y) % self.p
        return ((x % 3 + y % 3) % 3) + 3 * ((x // 3 + y // 3) % 3)

    def neg(self, x: int) -> int:
        return self.mul(self.p - 1, x)

    def sub(self, x: int, y: int) -> int:
        return self.add(x, self.neg(y))

    def mul(self, x: int, y: int) -> int:
        if self.q != 9:
            return (x * y) % self.p
        a, b = x % 3, x // 3
        c, d = y % 3, y // 3
        # F_9 = F_3[u]/(u^2+1), so u^2=2.
        return ((a * c + 2 * b * d) % 3) + 3 * ((a * d + b * c) % 3)

    def inv(self, x: int) -> int:
        if x == 0:
            raise ZeroDivisionError
        for y in range(1, self.q):
            if self.mul(x, y) == 1:
                return y
        raise AssertionError("finite-field inverse missing")

    def div(self, x: int, y: int) -> int:
        return self.mul(x, self.inv(y))


Point = tuple[int, int, int]


def normalize(field: Field, point: Point) -> Point:
    for x in point:
        if x:
            z = field.inv(x)
            return tuple(field.mul(z, y) for y in point)  # type: ignore[return-value]
    raise ValueError("zero is not a projective point")


def projective_plane(field: Field) -> list[Point]:
    points = {
        normalize(field, (x, y, z))
        for x in range(field.q)
        for y in range(field.q)
        for z in range(field.q)
        if (x, y, z) != (0, 0, 0)
    }
    return sorted(points)


def conic(field: Field) -> list[Point]:
    return [(1, t, field.mul(t, t)) for t in range(field.q)] + [(0, 0, 1)]


def det(field: Field, a: Point, b: Point, c: Point) -> int:
    pos = field.add(
        field.add(field.mul(a[0], field.mul(b[1], c[2])), field.mul(a[1], field.mul(b[2], c[0]))),
        field.mul(a[2], field.mul(b[0], c[1])),
    )
    neg = field.add(
        field.add(field.mul(a[2], field.mul(b[1], c[0])), field.mul(a[1], field.mul(b[0], c[2]))),
        field.mul(a[0], field.mul(b[2], c[1])),
    )
    return field.sub(pos, neg)


def secant_pairs(field: Field, carrier: list[Point], target: Point) -> list[tuple[int, int]]:
    return [
        (i, j)
        for i in range(len(carrier))
        for j in range(i + 1, len(carrier))
        if det(field, carrier[i], carrier[j], target) == 0
    ]


@lru_cache(maxsize=None)
def exact_vote_packing(m: int, pair_edges: tuple[tuple[int, int], ...]) -> int:
    """Maximum disjoint recovery groups: secant pairs and arbitrary triples."""
    groups = [sum(1 << i for i in edge) for edge in pair_edges]
    groups += [
        (1 << i) | (1 << j) | (1 << k)
        for i in range(m)
        for j in range(i + 1, m)
        for k in range(j + 1, m)
    ]

    @lru_cache(maxsize=None)
    def dp(mask: int) -> int:
        if not mask:
            return 0
        first = (mask & -mask).bit_length() - 1
        best = dp(mask & ~(1 << first))
        for group in groups:
            if group & (1 << first) and group & mask == group:
                best = max(best, 1 + dp(mask ^ group))
        return best

    return dp((1 << m) - 1)


def canonical_vote_packing(m: int, r: int) -> int:
    edges = tuple((2 * i, 2 * i + 1) for i in range(r))
    return exact_vote_packing(m, edges)


def analyze(q: int) -> dict[str, object]:
    field = Field(q)
    oval = conic(field)
    oval_set = set(oval)
    targets = [p for p in projective_plane(field) if p not in oval_set]
    n = len(oval)
    full_rows = []
    shortened_cases = 0
    shortened_cases_with_pair = 0
    pair_partition_cases = 0
    decoder_bound_equal_cases = 0
    decoder_equal_without_partition = 0
    formula_checks: set[tuple[int, int]] = set()

    for target in targets:
        edges = secant_pairs(field, oval, target)
        if any(set(x) & set(y) for i, x in enumerate(edges) for y in edges[i + 1 :]):
            raise AssertionError("secants through a target must induce a matching")
        r_full = len(edges)
        internal = 2 * r_full == n
        votes = r_full + (n - 2 * r_full) // 3
        full_rows.append((internal, r_full, votes, (votes - 1) // 2))

        for mask in range(1 << n):
            m = mask.bit_count()
            if m < 4 or m % 2:
                continue
            shortened_cases += 1
            r = sum(bool(mask & (1 << i)) and bool(mask & (1 << j)) for i, j in edges)
            shortened_cases_with_pair += r > 0
            partition = 2 * r == m
            votes_formula = r + (m - 2 * r) // 3
            formula_checks.add((m, r))
            # The Oval Strikes Back, Thm. 20 uses s=2, so its bound is relevant
            # exactly when at least one two-server recovery exists.
            decoder_equal = r > 0 and (votes_formula - 1) // 2 == (m - 2) // 4
            pair_partition_cases += partition
            decoder_bound_equal_cases += decoder_equal
            decoder_equal_without_partition += decoder_equal and not partition

    formula_replay = []
    for m, r in sorted(formula_checks):
        exact = canonical_vote_packing(m, r)
        predicted = r + (m - 2 * r) // 3
        if exact != predicted:
            raise AssertionError((q, m, r, exact, predicted))
        formula_replay.append({"m": m, "pair_count": r, "max_votes": exact})

    internal_count = sum(row[0] for row in full_rows)
    external_count = len(full_rows) - internal_count
    return {
        "q": q,
        "oval_size": n,
        "off_oval_targets": len(targets),
        "full_oval": {
            "internal_targets": internal_count,
            "external_targets": external_count,
            "internal_signature": sorted({row[1:] for row in full_rows if row[0]}),
            "external_signature": sorted({row[1:] for row in full_rows if not row[0]}),
        },
        "shortened_even_arc_cases": shortened_cases,
        "shortened_even_arc_cases_with_secant_pair": shortened_cases_with_pair,
        "pair_partition_cases": pair_partition_cases,
        "decoder_bound_equal_cases": decoder_bound_equal_cases,
        "decoder_equal_without_pair_partition": decoder_equal_without_partition,
        "vote_formula_replay": formula_replay,
    }


def payload() -> dict[str, object]:
    return {
        "schema": "c357-oval-service-extremizer-equivalence-v1",
        "fields": [analyze(q) for q in (5, 7, 9)],
        "claims_checked": [
            "secant pairs through an off-conic target form a matching",
            "pair-partition iff every selected carrier point lies in a selected secant pair",
            "max disjoint recovery votes = r + floor((m-2r)/3)",
            "majority-logic radius equality can occur without pair-partition extremality",
        ],
    }


def encoded(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    if bool(args.write) == bool(args.check):
        parser.error("choose exactly one of --write or --check")
    output = encoded(payload())
    if args.write:
        args.write.write_bytes(output)
        print(f"wrote {args.write} {len(output)} bytes sha256={hashlib.sha256(output).hexdigest()}")
    else:
        tracked = args.check.read_bytes()
        if tracked != output:
            raise SystemExit("certificate mismatch")
        print(f"checked {args.check} {len(output)} bytes sha256={hashlib.sha256(output).hexdigest()}")


if __name__ == "__main__":
    main()
