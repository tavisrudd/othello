#!/usr/bin/env python3
"""Derive the normalized gauge of the small even cubic block reduction.

The small even horizontal system of a smooth cubic threefold, in the ordered
classical basis 1, P, P^2, P^3, is

    z^2 d/dz S = (K + z G) S,

with K the doubled Euler multiplication matrix and G the grading matrix
diag(3, 1, -1, -3)/2.  Writing q = r^2/3 for a square root r of 3q, this script

  * conjugates K and G by the constant matrix C that separates the two nonzero
    Euler eigenvalues from the rank-two zero block,
  * solves, order by order, for the block-off-diagonal gauge coefficients A1 and
    A2 that make the first and second coefficients of the transformed system
    block diagonal for the partition {0}, {1}, {2, 3}, and
  * prints those coefficients together with the resulting reduced coefficients.

Its role is to exhibit how the gauge coefficients are obtained.  It is not the
evidence for the reduction: the identities it produces are stated and proved by
exact matrix arithmetic in the Lean module

    TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CubicSmallEvenBlockReduction

whose theorems cubicBlockBasis_det, cubicEulerMatrix_mul_blockBasis,
cubicGradingMatrix_mul_blockBasis, cubicReduction_first_order, and
cubicReduction_second_order are checked by the Lean kernel and do not depend on
this script.

Replay:

    uv run --with sympy python3 verification/small_even_block_reduction.py
"""

from __future__ import annotations

import sympy as sp

BLOCKS = [[0], [1], [2, 3]]


def block_index(i: int) -> int:
    for position, block in enumerate(BLOCKS):
        if i in block:
            return position
    raise ValueError(i)


def is_off_diagonal(i: int, j: int) -> bool:
    return block_index(i) != block_index(j)


def solve_gauge(euler_block_form: sp.Matrix, source: sp.Matrix) -> sp.Matrix:
    """Return the block-off-diagonal X with (B X - X B + source) block diagonal."""
    unknowns = []
    candidate = sp.zeros(4, 4)
    for i in range(4):
        for j in range(4):
            if is_off_diagonal(i, j):
                symbol = sp.Symbol(f"x{i}{j}")
                unknowns.append(symbol)
                candidate[i, j] = symbol
    commutator = euler_block_form * candidate - candidate * euler_block_form
    equations = [
        sp.Eq(sp.expand(commutator[i, j] + source[i, j]), 0)
        for i in range(4)
        for j in range(4)
        if is_off_diagonal(i, j)
    ]
    solutions = sp.solve(equations, unknowns, dict=True)
    if len(solutions) != 1:
        raise RuntimeError("the Sylvester system is not uniquely solvable")
    return sp.simplify(candidate.subs(solutions[0]))


def main() -> None:
    r = sp.symbols("r", nonzero=True)
    q = r**2 / 3
    euler = 2 * sp.Matrix(
        [[0, 6 * q, 0, 36 * q**2], [1, 0, 15 * q, 0], [0, 1, 0, 6 * q], [0, 0, 1, 0]]
    )
    grading = sp.Rational(1, 2) * sp.diag(3, 1, -1, -3)
    basis = sp.Matrix(
        [
            [6 * r**3, -6 * r**3, 0, -7 * r**2],
            [7 * r**2, 7 * r**2, -2 * r**2, 0],
            [3 * r, -3 * r, 0, 1],
            [1, 1, 1, 0],
        ]
    )
    inverse = basis.inv()
    euler_block_form = sp.simplify(inverse * euler * basis)
    grading_block_form = sp.simplify(inverse * grading * basis)
    first_gauge = solve_gauge(euler_block_form, grading_block_form)
    reduced_first = sp.simplify(
        euler_block_form * first_gauge - first_gauge * euler_block_form + grading_block_form
    )
    second_source = sp.simplify(
        grading_block_form * first_gauge - first_gauge * reduced_first - first_gauge
    )
    second_gauge = solve_gauge(euler_block_form, second_source)
    reduced_second = sp.simplify(
        euler_block_form * second_gauge - second_gauge * euler_block_form + second_source
    )
    for name, matrix in (
        ("determinant of the separating basis", sp.simplify(basis.det())),
        ("Euler matrix in the separated basis", euler_block_form),
        ("grading matrix in the separated basis", grading_block_form),
        ("first gauge coefficient", first_gauge),
        ("first reduced coefficient", reduced_first),
        ("second gauge coefficient", second_gauge),
        ("second reduced coefficient", reduced_second),
    ):
        print(f"{name}:")
        print(sp.pretty(matrix))
        print()


if __name__ == "__main__":
    main()
