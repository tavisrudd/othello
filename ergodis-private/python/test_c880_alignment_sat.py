#!/usr/bin/env python3
"""Exhaustive unit checks for the C880 CNF primitives."""

from __future__ import annotations

import itertools
import unittest

from c880_alignment_sat import Cnf, TRIPLES, violated_clause


def extendable(cnf: Cnf, fixed: dict[int, bool]) -> bool:
    free = [variable for variable in range(1, cnf.variables + 1) if variable not in fixed]
    for values in itertools.product((False, True), repeat=len(free)):
        assignment = dict(fixed)
        assignment.update(zip(free, values, strict=True))
        if all(
            any(assignment[abs(literal)] == (literal > 0) for literal in clause)
            for clause in cnf.clauses
        ):
            return True
    return False


class CnfPrimitiveTests(unittest.TestCase):
    def test_xor(self) -> None:
        cnf = Cnf()
        cnf.variables = 2
        output = cnf.xor(1, 2)
        for left, right in itertools.product((False, True), repeat=2):
            for result in (False, True):
                self.assertEqual(
                    extendable(cnf, {1: left, 2: right, output: result}),
                    result == (left != right),
                )

    def test_at_most(self) -> None:
        cnf = Cnf()
        cnf.variables = 4
        cnf.at_most([1, 2, 3, 4], 2)
        for values in itertools.product((False, True), repeat=4):
            self.assertEqual(
                extendable(cnf, dict(enumerate(values, start=1))),
                sum(values) <= 2,
            )

    def test_lex_leq_with_fixed_coordinates(self) -> None:
        cnf = Cnf()
        cnf.variables = 4
        cnf.lex_leq([1, 2, 3], [1, 4, 2])
        for values in itertools.product((False, True), repeat=4):
            left = (values[0], values[1], values[2])
            right = (values[0], values[3], values[1])
            self.assertEqual(
                extendable(cnf, dict(enumerate(values, start=1))),
                left <= right,
            )

    def test_seventeen_triple_witness(self) -> None:
        indices = {0, 5, 9, 10, 24, 25, 35, 45, 46, 48, 49, 50, 51, 52, 53, 54, 55}
        selected = [index in indices for index in range(len(TRIPLES))]
        self.assertIsNone(violated_clause(selected))
        selected[0] = False
        self.assertIsNotNone(violated_clause(selected))


if __name__ == "__main__":
    unittest.main()
