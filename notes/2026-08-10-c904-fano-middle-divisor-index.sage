#!/usr/bin/env sage
"""Degree ideal for the Fano middle-divisor carrier.

For D in the full Neron--Severi lattice of F x F, compute the degree of
F x D -> J, (a,b,c) |-> a+b-c.  The three copies of F have class
theta^3/3! in J.  The divisor lattice consists of two saturated rank-15
diagonal copies and the full rank-25 cross Hom lattice.  Each diagonal
restriction lattice is enlarged by the incidence class theta|F/2.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations
from math import gcd
import builtins
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def shift_form(value, offset):
    return {tuple(index + offset for index in indices): coefficient
            for indices, coefficient in value.items()}


def arbitrary_coefficient(coordinates):
    return matrix(ZZ, 5, 5, list(coordinates))


def cross_integrality_matrix(basis):
    """All Hodge cross forms, parametrized by an arbitrary 5 by 5 matrix."""
    columns = []
    zero = zero_matrix(QQ, 5)
    for i in range(5):
        for j in range(5):
            coefficient = zero_matrix(QQ, 5)
            coefficient[i, j] = 1
            # For arbitrary C, the Hodge cross block is [0,C;-C,0].
            source_cross = block_matrix(QQ, [
                [zero, coefficient],
                [-coefficient, zero],
            ])
            principal_cross = basis * source_cross * basis.transpose()
            columns.append(vector(QQ, principal_cross.list()))
    return matrix(QQ, columns).transpose()


def phi_top_coefficient(indices):
    """Coefficient in wedge_r(x_1r+x_2r-x_3r), indices sorted."""
    if len(indices) != 10:
        return 0
    chosen = [None] * 10
    for index in indices:
        residue = index % 10
        if chosen[residue] is not None:
            return 0
        chosen[residue] = index
    if any(value is None for value in chosen):
        return 0
    inversions = builtins.sum(chosen[i] > chosen[j]
                              for i in range(10) for j in range(i + 1, 10))
    coefficient = -1 if inversions % 2 else 1
    coefficient *= (-1) ** builtins.sum(index // 10 == 2 for index in chosen)
    return coefficient


def integrate_against_phi(base, divisor):
    universe = set(range(30))
    answer = ZZ.zero()
    prepared_base = [(indices, set(indices), coefficient)
                     for indices, coefficient in base.items()]
    for base_indices, base_set, base_coefficient in prepared_base:
        for divisor_indices, divisor_coefficient in divisor.items():
            if base_set.intersection(divisor_indices):
                continue
            indices = tuple(sorted(base_indices + divisor_indices))
            first_inversions = builtins.sum(left > right
                                            for left in base_indices
                                            for right in divisor_indices)
            first_sign = -1 if first_inversions % 2 else 1
            complement = tuple(sorted(universe.difference(indices)))
            phi_coefficient = phi_top_coefficient(complement)
            if not phi_coefficient:
                continue
            inversions = builtins.sum(left > right
                                      for left in indices for right in complement)
            wedge_coefficient = -1 if inversions % 2 else 1
            answer += (base_coefficient * divisor_coefficient * first_sign
                       * phi_coefficient * wedge_coefficient)
    return answer


def main():
    _, _, basis, symplectic = principal_lattice("omega", 1)
    standard_symplectic, symplectic_change = symplectic.symplectic_form()
    assert abs(symplectic_change.det()) == 1
    assert standard_symplectic == (symplectic_change * symplectic
                                   * symplectic_change.transpose())
    positions, ns_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(ns_map)

    zero = zero_matrix(QQ, 5)
    ns_forms = []
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        principal = basis * source * basis.transpose()
        assert principal.denominator() == 1
        principal = (symplectic_change * principal.change_ring(ZZ)
                     * symplectic_change.transpose())
        ns_forms.append(two_form(principal))
    assert len(ns_forms) == 15

    cross_map = cross_integrality_matrix(basis)
    _, cross_lattice = congruence_kernel_lattice(cross_map)
    assert cross_lattice.rank() == 25
    cross_forms = []
    for coordinates in cross_lattice.basis_matrix().LLL().rows():
        coefficient = arbitrary_coefficient(coordinates)
        source_cross = block_matrix(QQ, [
            [zero, coefficient],
            [-coefficient, zero],
        ])
        principal_cross = basis * source_cross * basis.transpose()
        assert principal_cross.denominator() == 1
        principal_cross = (symplectic_change
                           * principal_cross.change_ring(ZZ)
                           * symplectic_change.transpose())
        total = block_matrix(ZZ, [
            [zero_matrix(ZZ, 10), principal_cross],
            [-principal_cross.transpose(), zero_matrix(ZZ, 10)],
        ])
        cross_forms.append(shift_form(two_form(total), 10))

    theta = two_form(standard_symplectic)
    fano = wedge(wedge(theta, theta), theta)
    assert all(value % factorial(3) == 0 for value in fano.values())
    fano = {indices: value // factorial(3) for indices, value in fano.items()}
    base = wedge(wedge(shift_form(fano, 0), shift_form(fano, 10)),
                 shift_form(fano, 20))

    divisors = ([shift_form(value, 10) for value in ns_forms]
                + [shift_form(value, 20) for value in ns_forms]
                + cross_forms)
    assert len(divisors) == 55
    degrees = [integrate_against_phi(base, divisor) for divisor in divisors]
    nonzero = [abs(int(value)) for value in degrees if value]
    restriction_gcd = gcd(*nonzero)
    segment_gcds = tuple(gcd(*(abs(int(value)) for value in segment if value))
                         for segment in (degrees[:15], degrees[15:30], degrees[30:]))

    theta_second = shift_form(theta, 10)
    theta_third = shift_form(theta, 20)
    theta_degrees = (integrate_against_phi(base, theta_second),
                     integrate_against_phi(base, theta_third))
    assert all(value % 2 == 0 for value in theta_degrees)
    incidence_degrees = tuple(value // 2 for value in theta_degrees)
    degree_gcd = gcd(restriction_gcd, *(abs(int(value))
                                       for value in incidence_degrees))

    print("C904 Fano middle-divisor index")
    print(f"NS(F x F) rank: {len(divisors)} = 15+15+25")
    print(f"nonzero basis degrees: {len(nonzero)}")
    print(f"pullback theta degrees: {theta_degrees}")
    print(f"incidence half-theta degrees: {incidence_degrees}")
    print(f"diagonal/diagonal/cross gcds: {segment_gcds}")
    print(f"restriction-lattice gcd: {restriction_gcd}")
    print(f"full saturated degree gcd: {degree_gcd}")
    print(f"odd basis witnesses: {sum(value % 2 for value in degrees)}")


main()
