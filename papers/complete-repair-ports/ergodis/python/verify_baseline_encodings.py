#!/usr/bin/env python3
"""Exhaustive small checks for the SAT cardinality controls."""

from __future__ import annotations

from itertools import product

from graphillion import setset
from pycryptosat import Solver

from benchmark_python import add_at_most, add_exactly_small, ceph_zdd_supports


def assumptions(bits: tuple[bool, ...]) -> list[int]:
    return [index + 1 if bit else -(index + 1) for index, bit in enumerate(bits)]


def check_at_most() -> int:
    checked = 0
    for width in range(1, 8):
        literals = list(range(1, width + 1))
        for bound in range(width):
            solver = Solver(threads=1)
            add_at_most(solver, literals, bound, width + 1)
            for bits in product((False, True), repeat=width):
                satisfiable, _ = solver.solve(assumptions(bits))
                assert satisfiable == (sum(bits) <= bound)
                checked += 1
    return checked


def check_exactly() -> int:
    checked = 0
    for width in range(1, 8):
        literals = list(range(1, width + 1))
        for count in range(width + 1):
            solver = Solver(threads=1)
            add_exactly_small(solver, literals, count, width + 1)
            for bits in product((False, True), repeat=width):
                satisfiable, _ = solver.solve(assumptions(bits))
                assert satisfiable == (sum(bits) == count)
                checked += 1
    return checked


def check_ceph_zdd() -> int:
    checked = 0
    for levels in range(1, 8):
        family, _ = ceph_zdd_supports(setset, levels)
        actual = {frozenset(support) for support in family}
        expected = {
            frozenset(
                [levels]
                + [levels + 1 + 2 * level + branch for level, branch in enumerate(bits)]
            )
            for bits in product(range(2), repeat=levels)
        }
        assert actual == expected
        checked += len(expected)
    return checked


def main() -> None:
    at_most = check_at_most()
    exactly = check_exactly()
    ceph = check_ceph_zdd()
    print(
        f"verified {at_most} at-most, {exactly} exact, "
        f"and {ceph} ZDD support cases"
    )


if __name__ == "__main__":
    main()
