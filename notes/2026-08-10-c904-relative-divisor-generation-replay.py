#!/usr/bin/env python3
"""Independent SymPy replay of the C904 relative divisor-product defect.

The primary certificate constructs the full endomorphism order in Sage.  This
replay starts from its exported index-16 divisor basis and independently checks
the two paper-facing consequences using only Fraction arithmetic and SymPy:
the degree-four product index is 2^16 and the minimal class has order four.
"""

from fractions import Fraction
import importlib.util
from math import prod
from pathlib import Path

from sympy import Matrix
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


SOURCE = Path(__file__).with_name("2026-08-10-c904-minimal-class-divisor-replay.py")
SPEC = importlib.util.spec_from_file_location("c904_minimal_replay", SOURCE)
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


RELATIVE_COORDINATES = [
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, -1, 0, 0, 0, 0, 0, 0, 0, -1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0],
]

PROJECTION = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 16, 17]


def multiply(left, right):
    return [[sum(a * b for a, b in zip(row, column))
             for column in zip(*right)] for row in left]


def relative_ns_coefficients():
    return multiply(RELATIVE_COORDINATES, BASE.NS_BASIS)


def divisor_forms(coefficients):
    basis_t = BASE.transpose(BASE.PRINCIPAL_BASIS)
    forms = []
    for coordinates in coefficients:
        source = BASE.block_alternating(BASE.coefficient_matrix(coordinates))
        pulled = BASE.matmul(BASE.matmul(BASE.PRINCIPAL_BASIS, source), basis_t)
        assert all(value.denominator == 1 for row in pulled for value in row)
        forms.append(BASE.two_form(pulled))
    return forms


def lattice_index(rows):
    smith = smith_normal_form(Matrix(rows), domain=ZZ)
    diagonal = [abs(int(smith[i, i])) for i in range(15)]
    assert all(diagonal)
    return prod(diagonal), diagonal


def main():
    relative_matrix = Matrix(RELATIVE_COORDINATES)
    relative_smith = smith_normal_form(relative_matrix, domain=ZZ)
    relative_ns_diagonal = [abs(int(relative_smith[i, i])) for i in range(15)]
    assert relative_ns_diagonal == [1] * 11 + [2] * 4

    full_forms = BASE.divisor_forms()
    eight_indices, full_rows, _ = BASE.all_products(full_forms)
    minimal = BASE.minimal_vector(eight_indices)
    full_projected = [[row[column] for column in PROJECTION] for row in full_rows]
    full_index, full_diagonal = lattice_index(full_projected)
    assert full_index == 7

    relative_forms = divisor_forms(relative_ns_coefficients())
    relative_indices, relative_rows, _ = BASE.all_products(relative_forms)
    assert relative_indices == eight_indices
    relative_projected = [
        [row[column] for column in PROJECTION] for row in relative_rows
    ]
    relative_index, relative_product_diagonal = lattice_index(relative_projected)
    assert relative_index == 7 * 2**16

    minimal_projected = [minimal[column] for column in PROJECTION]
    enlarged_index, enlarged_diagonal = lattice_index(
        relative_projected + [minimal_projected]
    )
    minimal_order = relative_index // enlarged_index
    assert minimal_order == 4

    print("relative NS smith=", relative_ns_diagonal)
    print("full product projection smith=", full_diagonal,
          "index=", full_index)
    print("relative product projection smith=", relative_product_diagonal,
          "index=", relative_index)
    print("adjoin minimal projection smith=", enlarged_diagonal,
          "index=", enlarged_index)
    print("relative/full product index=", relative_index // full_index)
    print("minimal-class order=", minimal_order)
    print("PASS")


if __name__ == "__main__":
    main()
