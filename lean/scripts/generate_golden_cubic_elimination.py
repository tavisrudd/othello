#!/usr/bin/env python3
"""Generate kernel-checkable elimination identities for the Golden cubic."""

from __future__ import annotations

import argparse
from fractions import Fraction
from itertools import combinations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "RelativeConicArcs" / "GoldenCubicNodeElimination.lean"

Poly = dict[tuple[int, ...], Fraction]

CONFERENCE = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)


def add(*polys: Poly) -> Poly:
    result: Poly = {}
    for poly in polys:
        for monomial, coefficient in poly.items():
            result[monomial] = result.get(monomial, Fraction(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def scale(poly: Poly, scalar: int | Fraction) -> Poly:
    scalar = Fraction(scalar)
    return {m: scalar * c for m, c in poly.items() if scalar * c}


def mul(left: Poly, right: Poly) -> Poly:
    result: Poly = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(a + b for a, b in zip(lm, rm, strict=True))
            result[monomial] = result.get(monomial, Fraction(0)) + lc * rc
    return {m: c for m, c in result.items() if c}


def derivative(poly: Poly, index: int) -> Poly:
    result: Poly = {}
    for monomial, coefficient in poly.items():
        if monomial[index]:
            reduced = list(monomial)
            power = reduced[index]
            reduced[index] -= 1
            result[tuple(reduced)] = coefficient * power
    return result


def variable(count: int, index: int) -> Poly:
    return {tuple(int(i == index) for i in range(count)): Fraction(1)}


def constant(count: int, value: int | Fraction) -> Poly:
    value = Fraction(value)
    return {} if not value else {(0,) * count: value}


def golden_gradient() -> list[Poly]:
    xs = [variable(5, i) for i in range(5)]
    xs.append(scale(add(*xs), -1))
    cubic: Poly = {}
    for i, j, k in combinations(range(6), 3):
        sign = CONFERENCE[i][j] * CONFERENCE[j][k] * CONFERENCE[k][i]
        cubic = add(cubic, scale(mul(mul(xs[i], xs[j]), xs[k]), sign))
    return [derivative(cubic, i) for i in range(5)]


def substitute_last(poly: Poly, value: int) -> Poly:
    result: Poly = {}
    for monomial, coefficient in poly.items():
        reduced = monomial[:4]
        coefficient *= Fraction(value) ** monomial[4]
        result[reduced] = result.get(reduced, Fraction(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def monomials(count: int, degree: int) -> list[tuple[int, ...]]:
    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, slots: int) -> None:
        if slots == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, slots - 1)

    for total in range(degree + 1):
        visit((), total, count)
    return result


def solve_membership(generators: list[Poly], target: Poly) -> list[Poly]:
    for degree in range(6):
        multiplier_monomials = monomials(4, degree)
        columns = [
            mul(generator, {monomial: Fraction(1)})
            for generator in generators
            for monomial in multiplier_monomials
        ]
        rows = sorted(set(target).union(*(set(column) for column in columns)))
        matrix = [
            [column.get(row, Fraction(0)) for column in columns]
            + [target.get(row, Fraction(0))]
            for row in rows
        ]
        pivot_columns: list[int] = []
        pivot_row = 0
        for column in range(len(columns)):
            pivot = next(
                (row for row in range(pivot_row, len(matrix)) if matrix[row][column]),
                None,
            )
            if pivot is None:
                continue
            matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
            factor = matrix[pivot_row][column]
            matrix[pivot_row] = [entry / factor for entry in matrix[pivot_row]]
            for row in range(len(matrix)):
                if row != pivot_row and matrix[row][column]:
                    factor = matrix[row][column]
                    matrix[row] = [
                        a - factor * b
                        for a, b in zip(matrix[row], matrix[pivot_row], strict=True)
                    ]
            pivot_columns.append(column)
            pivot_row += 1
            if pivot_row == len(matrix):
                break
        if any(not any(row[:-1]) and row[-1] for row in matrix):
            continue
        solution = [Fraction(0) for _ in columns]
        for row, column in enumerate(pivot_columns):
            solution[column] = matrix[row][-1]
        multipliers: list[Poly] = []
        width = len(multiplier_monomials)
        for generator_index in range(len(generators)):
            polynomial = {
                monomial: solution[generator_index * width + monomial_index]
                for monomial_index, monomial in enumerate(multiplier_monomials)
                if solution[generator_index * width + monomial_index]
            }
            multipliers.append(polynomial)
        check = add(
            *[mul(multiplier, generator)
              for multiplier, generator in zip(multipliers, generators, strict=True)]
        )
        if check != target:
            raise AssertionError("internal membership reconstruction failed")
        return multipliers
    raise ValueError("no bounded ideal-membership certificate found")


def linear(*coefficients: int) -> Poly:
    result = constant(4, coefficients[-1])
    for index, coefficient in enumerate(coefficients[:-1]):
        result = add(result, scale(variable(4, index), coefficient))
    return result


def product(*polys: Poly) -> Poly:
    result = constant(4, 1)
    for poly in polys:
        result = mul(result, poly)
    return result


def lean_fraction(value: Fraction) -> str:
    if value.denominator == 1:
        return str(value.numerator)
    return f"({value.numerator} / {value.denominator} : K)"


def lean_poly(poly: Poly) -> str:
    if not poly:
        return "0"
    terms: list[str] = []
    for monomial, coefficient in sorted(poly.items(), reverse=True):
        factors = [
            f"x{index}" if exponent == 1 else f"x{index}^{exponent}"
            for index, exponent in enumerate(monomial)
            if exponent
        ]
        body = " * ".join(factors) if factors else "1"
        terms.append(f"({lean_fraction(coefficient)}) * {body}")
    return " + ".join(terms)


def render_theorem(
    name: str, target: Poly, branches: list[Poly], chart_gradient: list[Poly]
) -> str:
    generators = chart_gradient + branches
    multipliers = solve_membership(generators, target)
    gradient_names = [
        f"{'' if multipliers[index] else '_'}h{index}" for index in range(5)
    ]
    branch_names = [
        f"{'' if multipliers[5 + index] else '_'}hb{index}"
        for index in range(len(branches))
    ]
    assumptions = "\n".join(
        f"    ({branch_names[index]} : {lean_poly(branch)} = 0)"
        for index, branch in enumerate(branches)
    )
    combination = " +\n      ".join(
        f"({lean_poly(multiplier)}) * "
        + (gradient_names[index] if index < 5 else branch_names[index - 5])
        for index, multiplier in enumerate(multipliers)
        if multiplier
    )
    changes = ("  simp [chartGradient, GoldenCubicNodesBase.gradient] at "
               + " ".join(gradient_names))
    return f"""/-- Exact ideal-membership identity for one branch of the
centered Golden gradient scheme. -/
theorem {name} {{K : Type*}} [Field K] [CharZero K] (x0 x1 x2 x3 : K)
    ({gradient_names[0]} : chartGradient x0 x1 x2 x3 0 = 0)
    ({gradient_names[1]} : chartGradient x0 x1 x2 x3 1 = 0)
    ({gradient_names[2]} : chartGradient x0 x1 x2 x3 2 = 0)
    ({gradient_names[3]} : chartGradient x0 x1 x2 x3 3 = 0)
    ({gradient_names[4]} : chartGradient x0 x1 x2 x3 4 = 0)
{assumptions} :
    {lean_poly(target)} = 0 := by
{changes}
  linear_combination
      {combination}
"""


def generated_source() -> str:
    gradient = golden_gradient()
    chart_gradient = [substitute_last(polynomial, 1) for polynomial in gradient]
    x0, x1, x2, x3 = [variable(4, i) for i in range(4)]
    one = constant(4, 1)
    specs = [
        ("x3_factor", product(add(x3, scale(one, -1)), add(x3, scale(one, 5)),
          add(scale(x3, 5), one)), []),
        ("x2_factor_of_x3_eq_one",
          product(add(x2, scale(one, -1)), add(x2, scale(one, 5))),
          [add(x3, scale(one, -1))]),
        ("x1_factor_of_x3_x2_eq_one",
          product(add(x1, scale(one, -1)), add(x1, scale(one, 5))),
          [add(x3, scale(one, -1)), add(x2, scale(one, -1))]),
        ("x0_factor_of_x3_x2_x1_eq_one",
          product(add(x0, scale(one, -1)), add(x0, scale(one, 5))),
          [add(x3, scale(one, -1)), add(x2, scale(one, -1)),
           add(x1, scale(one, -1))]),
    ]
    specs.extend([
        ("x1_eq_one_of_x3_one_x2_neg_five", add(x1, scale(one, -1)),
         [add(x3, scale(one, -1)), add(x2, scale(one, 5))]),
        ("x0_eq_one_of_x3_one_x2_neg_five", add(x0, scale(one, -1)),
         [add(x3, scale(one, -1)), add(x2, scale(one, 5))]),
        ("x2_eq_one_of_x3_neg_five", add(x2, scale(one, -1)),
         [add(x3, scale(one, 5))]),
        ("x1_eq_one_of_x3_neg_five", add(x1, scale(one, -1)),
         [add(x3, scale(one, 5))]),
        ("x0_eq_one_of_x3_neg_five", add(x0, scale(one, -1)),
         [add(x3, scale(one, 5))]),
        ("five_x2_add_one_of_five_x3_add_one", add(scale(x2, 5), one),
         [add(scale(x3, 5), one)]),
        ("five_x1_add_one_of_five_x3_add_one", add(scale(x1, 5), one),
         [add(scale(x3, 5), one)]),
        ("five_x0_add_one_of_five_x3_add_one", add(scale(x0, 5), one),
         [add(scale(x3, 5), one)]),
        ("x0_eq_one_of_x3_x2_one_x1_neg_five", add(x0, scale(one, -1)),
         [add(x3, scale(one, -1)), add(x2, scale(one, -1)),
          add(x1, scale(one, 5))]),
    ])
    boundary_gradient = [substitute_last(polynomial, 0) for polynomial in gradient]
    boundary_theorems = []
    for coordinate in range(4):
        target = product(*([variable(4, coordinate)] * 3))
        multipliers = solve_membership(boundary_gradient, target)
        names = [
            f"{'' if multiplier else '_'}h{index}"
            for index, multiplier in enumerate(multipliers)
        ]
        combination = " +\n      ".join(
            f"({lean_poly(multiplier)}) * {names[index]}"
            for index, multiplier in enumerate(multipliers)
            if multiplier
        )
        boundary_theorems.append(f"""/-- On the boundary chart, the cube of
coordinate {coordinate} belongs to the Golden gradient ideal. -/
theorem boundary_x{coordinate}_cube {{K : Type*}} [Field K] [CharZero K]
    (x0 x1 x2 x3 : K)
    ({names[0]} : gradient ![x0, x1, x2, x3, 0] 0 = 0)
    ({names[1]} : gradient ![x0, x1, x2, x3, 0] 1 = 0)
    ({names[2]} : gradient ![x0, x1, x2, x3, 0] 2 = 0)
    ({names[3]} : gradient ![x0, x1, x2, x3, 0] 3 = 0)
    ({names[4]} : gradient ![x0, x1, x2, x3, 0] 4 = 0) :
    x{coordinate}^3 = 0 := by
  simp [gradient] at {" ".join(names)}
  linear_combination
      {combination}
""")
    theorems = "\n".join(
        render_theorem(name, target, branches, chart_gradient)
        for name, target, branches in specs
    )
    return f"""import RelativeConicArcs.GoldenCubicNodesBase

/-!
# Elimination identities for the centered Golden cubic

This file is generated by scripts/generate_golden_cubic_elimination.py.
It contains exact rational ideal-membership identities for the five gradient
quadrics.  Lean rechecks every identity with linear_combination; the
generator and its linear algebra are not part of the trusted proof.
-/

namespace RelativeConicArcs.GoldenCubicNodeElimination

open GoldenCubicNodesBase

set_option maxRecDepth 100000

/-- The five gradient quadrics on the affine chart whose last centered
coordinate equals one. -/
def chartGradient {{K : Type*}} [CommRing K] (x0 x1 x2 x3 : K) : Fin 5 → K :=
  gradient ![x0, x1, x2, x3, 1]

{theorems}

{"".join(boundary_theorems)}

end RelativeConicArcs.GoldenCubicNodeElimination
"""


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    source = generated_source()
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_text() != source:
            raise SystemExit(f"stale generated source: {OUTPUT}")
        print(f"ok: {OUTPUT.relative_to(ROOT)}")
    else:
        OUTPUT.write_text(source)
        print(f"wrote {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
