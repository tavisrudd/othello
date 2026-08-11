#!/usr/bin/env sage
"""Divisor-cut degrees on the unordered theta-pair fibre.

The computation uses the certified exotic principal lattice and its integral
rank-15 Neron--Severi lattice.  On A x A it forms the 30 swap-invariant
divisors obtained by putting each NS form on both diagonal blocks or on the
two cross blocks.  It computes the degree of every triple product on the
generic fibre of Sym^2(Theta) -> A.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations_with_replacement
from math import gcd
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def block_two_form(diagonal_left, cross, diagonal_right):
    """Alternating 20 by 20 block matrix as an exterior two-form."""
    matrix = block_matrix(QQ, [
        [diagonal_left, cross],
        [-cross.transpose(), diagonal_right],
    ])
    assert matrix + matrix.transpose() == 0
    assert matrix.denominator() == 1
    return two_form(matrix.change_ring(ZZ))


def main():
    _, _, basis, symplectic = principal_lattice("omega", 1)
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)

    source_zero = zero_matrix(QQ, 5)
    ns_matrices = []
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source_form = block_matrix(QQ, [
            [source_zero, coefficient],
            [-coefficient, source_zero],
        ])
        principal_form = basis * source_form * basis.transpose()
        assert principal_form.denominator() == 1
        principal_form = principal_form.change_ring(ZZ)
        assert principal_form + principal_form.transpose() == 0
        ns_matrices.append(principal_form)
    assert len(ns_matrices) == 15

    zero = zero_matrix(ZZ, 10)
    theta_left = block_two_form(symplectic, zero, zero)
    theta_right = block_two_form(zero, zero, symplectic)
    theta_sum = block_two_form(symplectic, symplectic, symplectic)

    invariant_divisors = []
    labels = []
    for index, form in enumerate(ns_matrices):
        invariant_divisors.append(block_two_form(form, zero, form))
        labels.append(("diag", index))
    for index, form in enumerate(ns_matrices):
        invariant_divisors.append(block_two_form(zero, form, zero))
        labels.append(("cross", index))

    base = wedge(theta_left, theta_right)
    for _ in range(5):
        base = wedge(base, theta_sum)

    top = tuple(range(20))
    first_wedges = [wedge(base, divisor) for divisor in invariant_divisors]
    second_wedges = {}
    for first in range(30):
        for second in range(first, 30):
            second_wedges[(first, second)] = wedge(
                first_wedges[first], invariant_divisors[second])

    degrees = []
    witnesses = []
    for monomial in combinations_with_replacement(range(30), 3):
        value = wedge(second_wedges[monomial[:2]],
                      invariant_divisors[monomial[2]])
        ordered_numerator = ZZ(value.get(top, 0))
        assert ordered_numerator % factorial(5) == 0
        ordered_degree = ordered_numerator // factorial(5)
        assert ordered_degree % 2 == 0
        quotient_degree = ordered_degree // 2
        degrees.append(quotient_degree)
        if abs(quotient_degree) == 1:
            witnesses.append((tuple(labels[i] for i in monomial), quotient_degree))

    nonzero = [abs(int(value)) for value in degrees if value]
    degree_gcd = gcd(*nonzero)
    print("C904 symmetric-theta divisor-index audit")
    print(f"invariant divisor rank used: {len(invariant_divisors)}")
    print(f"triple products: {len(degrees)}")
    print(f"quotient-degree gcd: {degree_gcd}")
    print(f"unit witnesses: {len(witnesses)}")
    for witness in witnesses[:10]:
        print(witness)


main()
