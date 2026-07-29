#!/usr/bin/env sage
"""Reduce the degree-two q=121 filtered-transgression domain.

Write the modular-Hermite filtration of F as

    gr(F) = C0 + M + C2.

The only possible differential capable of erasing the degree-one traced
pullback class starts on

    Hom_H(L(6), (C0 tensor C2) + Sym^2(M)).

Each of C0, M, and C2 is multiplicity-free semisimple.  This checker
computes the Hom space separately on every small direct summand, without
constructing Sym^2(F), and records the nonsquare-dilation eigenspaces.
"""

import argparse
import importlib.machinery
import importlib.util
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-07-28-c665-q121-affine-socle.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-transgression-domain.json"


def load_module(name, path):
    loader = importlib.machinery.SourceFileLoader(name, str(path))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


base = load_module("c665_q121_transgression_base", BASE_PATH)
FIELD = base.FIELD
P = base.P
A = base.A
MODULUS = base.TORUS_MODULUS
NONSQUARE = FIELD.multiplicative_generator()
PARAMETERS = (FIELD.one(), A)

C0_FACTORS = (
    (8, 10), (8, 6), (8, 2),
    (4, 10), (4, 6), (4, 2),
    (0, 10), (0, 6), (0, 2),
    (6, 8), (6, 4), (6, 0),
    (2, 8), (2, 4), (2, 0),
)
M_FACTORS = tuple(
    (left, right)
    for left in (9, 7, 5, 3, 1)
    for right in (9, 7, 5, 3, 1)
)
C2_FACTORS = (
    (10, 8), (10, 4), (10, 0),
    (6, 8), (6, 4), (6, 0),
    (2, 8), (2, 4), (2, 0),
    (8, 6), (8, 2),
    (4, 6), (4, 2),
    (0, 6), (0, 2),
)


def dilation_entries(digits):
    weights = base.digit_simple_actions((), digits)[1]
    return tuple(NONSQUARE ** (weight // 2) for weight in weights)


class SimpleModule:
    def __init__(self, digits):
        self.label = tuple(digits)
        self.actions, self.weights = base.digit_simple_actions(
            PARAMETERS, digits
        )
        self.dimension = len(self.weights)
        self.dilation = dilation_entries(digits)
        self._columns = {}

    def action_column(self, generator, source):
        key = (generator, source)
        if key not in self._columns:
            column = self.actions[generator].column(source)
            self._columns[key] = tuple(
                (int(target), coefficient)
                for target, coefficient in column.dict().items()
            )
        return self._columns[key]


class TensorModule:
    def __init__(self, left, right):
        self.left = left
        self.right = right
        self.dimension = left.dimension * right.dimension
        self.weights = tuple(
            left_weight + right_weight
            for left_weight in left.weights
            for right_weight in right.weights
        )
        self.dilation = tuple(
            left_value * right_value
            for left_value in left.dilation
            for right_value in right.dilation
        )

    def action_column(self, generator, source):
        left_source, right_source = divmod(source, self.right.dimension)
        return tuple(
            (
                left_target * self.right.dimension + right_target,
                left_value * right_value,
            )
            for left_target, left_value in self.left.action_column(
                generator, left_source
            )
            for right_target, right_value in self.right.action_column(
                generator, right_source
            )
        )


class SymmetricSquareModule:
    def __init__(self, underlying):
        self.underlying = underlying
        self.pairs = tuple(
            (left, right)
            for left in range(underlying.dimension)
            for right in range(left, underlying.dimension)
        )
        self.pair_index = {
            pair: index for index, pair in enumerate(self.pairs)
        }
        self.dimension = len(self.pairs)
        self.weights = tuple(
            underlying.weights[left] + underlying.weights[right]
            for left, right in self.pairs
        )
        self.dilation = tuple(
            underlying.dilation[left] * underlying.dilation[right]
            for left, right in self.pairs
        )

    def action_column(self, generator, source):
        left, right = self.pairs[source]
        left_column = self.underlying.action_column(generator, left)
        right_column = self.underlying.action_column(generator, right)
        answer = {}
        for left_target, left_value in left_column:
            for right_target, right_value in right_column:
                target_pair = tuple(sorted((left_target, right_target)))
                target = self.pair_index[target_pair]
                answer[target] = (
                    answer.get(target, FIELD.zero())
                    + left_value * right_value
                )
        return tuple(
            (target, value) for target, value in answer.items() if value
        )


def add_entry(row, column, value):
    if not value:
        return
    row[column] = row.get(column, FIELD.zero()) + value
    if not row[column]:
        del row[column]


class StreamingRank:
    """Sparse row rank with storage bounded by the variable count."""

    def __init__(self, variable_count):
        self.variable_count = variable_count
        self.pivots = {}
        self.equations = 0

    def add(self, original):
        self.equations += 1
        row = dict(original)
        while row:
            pivot_column = min(row)
            coefficient = row[pivot_column]
            pivot = self.pivots.get(pivot_column)
            if pivot is None:
                inverse = coefficient**-1
                self.pivots[pivot_column] = {
                    column: value * inverse
                    for column, value in row.items()
                }
                return
            for column, value in pivot.items():
                updated = row.get(column, FIELD.zero()) - coefficient * value
                if updated:
                    row[column] = updated
                else:
                    row.pop(column, None)

    @property
    def rank(self):
        return len(self.pivots)


def hom_record(source, target):
    variables = {}
    for target_row, target_weight in enumerate(target.weights):
        for source_column, source_weight in enumerate(source.weights):
            if (target_weight - source_weight) % MODULUS == 0:
                variables[(target_row, source_column)] = len(variables)
    rank = StreamingRank(len(variables))
    plus_rank = StreamingRank(len(variables))
    minus_rank = StreamingRank(len(variables))
    for (target_row, source_column), variable in variables.items():
        factor = (
            target.dilation[target_row] / source.dilation[source_column]
        )
        if factor != 1:
            plus_rank.add({variable: factor - 1})
        if factor != -1:
            minus_rank.add({variable: factor + 1})
    relation_count = 0
    for generator in range(3):
        for source_column in range(source.dimension):
            equations = {}
            for target_source in range(target.dimension):
                variable = variables.get((target_source, source_column))
                if variable is None:
                    continue
                for target_row, coefficient in target.action_column(
                    generator, target_source
                ):
                    equation = equations.setdefault(target_row, {})
                    add_entry(equation, variable, coefficient)
            for source_row, coefficient in source.action_column(
                generator, source_column
            ):
                for target_row in range(target.dimension):
                    variable = variables.get((target_row, source_row))
                    if variable is not None:
                        equation = equations.setdefault(target_row, {})
                        add_entry(equation, variable, -coefficient)
            for equation in equations.values():
                if equation:
                    relation_count += 1
                    rank.add(equation)
                    plus_rank.add(equation)
                    minus_rank.add(equation)
    dimension = len(variables) - rank.rank
    plus = len(variables) - plus_rank.rank
    minus = len(variables) - minus_rank.rank
    assert plus + minus == dimension
    result = {
        "target_dimension": target.dimension,
        "torus_block_variables": len(variables),
        "equations": relation_count,
        "rank": rank.rank,
        "hom_dimension": dimension,
        "outer_plus_dimension": plus,
        "outer_minus_dimension": minus,
    }
    return result


def calculate():
    simples = {
        digits: SimpleModule(digits)
        for digits in set(C0_FACTORS + M_FACTORS + C2_FACTORS)
    }
    nonzero = []
    totals = {
        "summands": 0,
        "hom_dimension": 0,
        "outer_plus_dimension": 0,
        "outer_minus_dimension": 0,
    }

    source_simple = SimpleModule((6,))

    def consume(kind, labels, source, target):
        record = hom_record(source, target)
        totals["summands"] += 1
        totals["hom_dimension"] += record["hom_dimension"]
        totals["outer_plus_dimension"] += record.get(
            "outer_plus_dimension", 0
        )
        totals["outer_minus_dimension"] += record.get(
            "outer_minus_dimension", 0
        )
        if record["hom_dimension"]:
            nonzero.append(
                {"kind": kind, "factors": [list(label) for label in labels]}
                | record
            )
        if totals["summands"] % 25 == 0:
            print(
                f"checked {totals['summands']}/550 summands",
                file=sys.stderr,
                flush=True,
            )

    for left_digits in C0_FACTORS:
        for right_digits in C2_FACTORS:
            consume(
                "C0_tensor_C2",
                (left_digits, right_digits),
                TensorModule(source_simple, simples[left_digits]),
                simples[right_digits],
            )
    for left_index, left_digits in enumerate(M_FACTORS):
        consume(
            "Sym2_M_factor",
            (left_digits,),
            source_simple,
            SymmetricSquareModule(simples[left_digits]),
        )
        for right_digits in M_FACTORS[left_index + 1:]:
            consume(
                "M_factor_tensor",
                (left_digits, right_digits),
                TensorModule(source_simple, simples[left_digits]),
                simples[right_digits],
            )
    assert totals["summands"] == 225 + 25 + 300
    adjunction_cross_checks = []
    for left_digits, right_digits in (
        ((6, 0), (6, 0)),
        ((0, 2), (0, 2)),
    ):
        direct = hom_record(
            source_simple,
            TensorModule(simples[left_digits], simples[right_digits]),
        )
        adjoint = hom_record(
            TensorModule(source_simple, simples[left_digits]),
            simples[right_digits],
        )
        for key in (
            "hom_dimension",
            "outer_plus_dimension",
            "outer_minus_dimension",
        ):
            assert direct[key] == adjoint[key]
        adjunction_cross_checks.append(
            {
                "factors": [list(left_digits), list(right_digits)],
                "direct": direct,
                "adjoint": adjoint,
            }
        )
    return {
        "schema": 1,
        "q": base.Q,
        "p": P,
        "field_modulus": str(FIELD.modulus()),
        "source": "L(6)",
        "degree_two_graded_piece": "(C0 tensor C2) + Sym^2(M)",
        "totals": totals,
        "nonzero_summands": nonzero,
        "adjunction_cross_checks": adjunction_cross_checks,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = calculate()
    encoded = json.dumps(result, default=int, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(encoded)
        print(f"wrote {CERTIFICATE.name}")
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print(f"checked {CERTIFICATE.name}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
