#!/usr/bin/env python3
"""Dependency-free exact replay of the six Golden cubic nodes and Hessians."""

from __future__ import annotations

import json
import math
from fractions import Fraction
from itertools import combinations
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CERTIFICATE = ROOT / "2026-08-01-c757-golden-determinantal-cubic-nodes.json"
BASE_C = (
    (0, 1, 1, 1, -1, -1),
    (1, 0, -1, -1, -1, -1),
    (1, -1, 0, 1, 1, -1),
    (1, -1, 1, 0, -1, 1),
    (-1, -1, 1, -1, 0, -1),
    (-1, -1, -1, 1, -1, 0),
)
Poly = dict[tuple[int, ...], Fraction]


def add(left: Poly, right: Poly) -> Poly:
    result = left.copy()
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, Fraction(0)) + coefficient
    return {m: c for m, c in result.items() if c}


def mul(left: Poly, right: Poly) -> Poly:
    result: Poly = {}
    for lm, lc in left.items():
        for rm, rc in right.items():
            monomial = tuple(lm[i] + rm[i] for i in range(5))
            result[monomial] = result.get(monomial, Fraction(0)) + lc * rc
    return {m: c for m, c in result.items() if c}


def derivative(poly: Poly, index: int) -> Poly:
    return {
        tuple(e - int(i == index) for i, e in enumerate(monomial)): coefficient * monomial[index]
        for monomial, coefficient in poly.items()
        if monomial[index]
    }


def evaluate(poly: Poly, point: tuple[Fraction, ...]) -> Fraction:
    return sum(
        coefficient * math.prod(point[i] ** monomial[i] for i in range(5))
        for monomial, coefficient in poly.items()
    )


def determinant(matrix: list[list[Fraction]]) -> Fraction:
    if not matrix:
        return Fraction(1)
    return sum(
        (-1) ** j * matrix[0][j] * determinant([row[:j] + row[j + 1 :] for row in matrix[1:]])
        for j in range(len(matrix))
    )


def cubic() -> Poly:
    variables = [{tuple(int(i == j) for j in range(5)): Fraction(1)} for i in range(5)]
    variables.append({tuple(int(i == j) for j in range(5)): Fraction(-1) for i in range(5)})
    result: Poly = {}
    for i, j, k in combinations(range(6), 3):
        sign = BASE_C[i][j] * BASE_C[j][k] * BASE_C[k][i]
        term = mul(mul(variables[i], variables[j]), variables[k])
        result = add(result, {m: sign * c for m, c in term.items()})
    return result


def text(value: Fraction) -> str:
    return str(value.numerator) if value.denominator == 1 else f"{value.numerator}/{value.denominator}"


def main() -> None:
    certificate = json.loads(CERTIFICATE.read_text())
    poly = cubic()
    encoded = [
        {"exponents": list(m), "coefficient": text(c)} for m, c in sorted(poly.items())
    ]
    assert encoded == certificate["cubic_terms"]
    gradient = [derivative(poly, i) for i in range(5)]
    hessian = [[derivative(gradient[i], j) for j in range(4)] for i in range(4)]
    nodes = []
    determinants = []
    for exceptional in range(6):
        point6 = tuple(-5 if i == exceptional else 1 for i in range(6))
        nodes.append(list(point6))
        point = tuple(Fraction(point6[i], point6[4]) for i in range(5))
        assert evaluate(poly, point) == 0
        assert all(evaluate(partial, point) == 0 for partial in gradient)
        matrix = [[evaluate(hessian[i][j], point) for j in range(4)] for i in range(4)]
        determinants.append(text(determinant(matrix)))
    assert nodes == certificate["projective_nodes"]
    assert determinants == certificate["dehomogenized_hessian_determinants"]
    assert all(Fraction(value) != 0 for value in determinants)
    print("golden cubic node replay: six rational ordinary double points verified")


if __name__ == "__main__":
    main()

