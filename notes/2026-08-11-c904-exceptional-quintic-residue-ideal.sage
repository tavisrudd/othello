#!/usr/bin/env sage
"""Residue-ideal obstruction for the exceptional-quintic Fano route.

On the certified exotic principal lattice, reconstruct the full integral
endomorphism order and the full saturated NS(F).  For a divisor C on the
Fano surface, its Rosati norm is tr(A) I - A; the extra incidence generator
has norm 2 I and vanishes modulo two.  Verify that all such norms generate a
codimension-one two-sided ideal modulo two, and that the quotient is the
residue character carrying the identity to one.
"""

from contextlib import redirect_stdout
from io import StringIO
import sys


saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = saved_argv


def integral_endomorphism_basis(principal_basis, symplectic_change, standard):
    zero = zero_matrix(QQ, 5)
    columns = []
    for i in range(5):
        for j in range(5):
            coefficient = zero_matrix(QQ, 5)
            coefficient[i, j] = 1
            source = block_matrix(QQ, [
                [zero, coefficient],
                [-coefficient, zero],
            ])
            columns.append(vector(QQ, (principal_basis * source
                                        * principal_basis.transpose()).list()))
    linear = matrix(QQ, columns).transpose()
    denominator = lcm(value.denominator() for value in linear.list())
    augmented = ((denominator * linear).change_ring(ZZ).augment(
        -denominator * identity_matrix(ZZ, 100)))
    kernel = augmented.right_kernel().basis_matrix()
    coefficient_lattice = span(ZZ, [
        vector(ZZ, row[:25]) for row in kernel.rows()
    ])
    assert coefficient_lattice.rank() == 25

    answer = []
    for coordinates in coefficient_lattice.basis_matrix().LLL().rows():
        coefficient = matrix(ZZ, 5, 5, list(coordinates))
        source = block_matrix(QQ, [
            [zero, coefficient],
            [-coefficient, zero],
        ])
        cross = principal_basis * source * principal_basis.transpose()
        assert cross.denominator() == 1
        cross = (symplectic_change * cross.change_ring(ZZ)
                 * symplectic_change.transpose())
        endomorphism = -standard * cross
        assert endomorphism.denominator() == 1
        answer.append(endomorphism.change_ring(ZZ))
    return answer


def fano_norm_basis(principal_basis, symplectic_change, standard):
    positions, ns_map = ns_integrality_matrix(principal_basis)
    _, ns_lattice = congruence_kernel_lattice(ns_map)
    assert ns_lattice.rank() == 15
    zero = zero_matrix(QQ, 5)
    answer = []
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source = block_matrix(QQ, [
            [zero, coefficient],
            [-coefficient, zero],
        ])
        divisor = principal_basis * source * principal_basis.transpose()
        assert divisor.denominator() == 1
        divisor = (symplectic_change * divisor.change_ring(ZZ)
                   * symplectic_change.transpose())
        operator = -standard * divisor
        assert operator.trace() % 2 == 0
        complex_trace = operator.trace() // 2
        norm = complex_trace * identity_matrix(ZZ, 10) - operator
        answer.append(norm)
    return answer


def main():
    _, _, principal_basis, symplectic = principal_lattice("omega", 1)
    standard, symplectic_change = symplectic.symplectic_form()
    assert standard == (symplectic_change * symplectic
                         * symplectic_change.transpose())

    field = GF(2)
    endomorphisms = [value.change_ring(field) for value in
                     integral_endomorphism_basis(principal_basis,
                                                 symplectic_change,
                                                 standard)]
    norms = [value.change_ring(field) for value in
             fano_norm_basis(principal_basis, symplectic_change, standard)]

    endomorphism_space = span(field, [
        vector(field, value.list()) for value in endomorphisms
    ])
    norm_space = span(field, [vector(field, value.list()) for value in norms])
    assert endomorphism_space.dimension() == 25
    assert norm_space.dimension() == 14

    product_coordinates = []
    for left in endomorphisms:
        for norm in norms:
            for right in endomorphisms:
                product_coordinates.append(
                    endomorphism_space.coordinate_vector(
                        vector(field, (left * norm * right).list())))
    residue_ideal = span(field, product_coordinates)
    assert residue_ideal.dimension() == 24

    annihilator = residue_ideal.basis_matrix().right_kernel()
    assert annihilator.dimension() == 1
    functional = annihilator.basis()[0]

    def epsilon(value):
        coordinates = endomorphism_space.coordinate_vector(
            vector(field, value.list()))
        return functional.dot_product(coordinates)

    identity = identity_matrix(field, 10)
    assert epsilon(identity) == 1
    assert all(epsilon(norm) == 0 for norm in norms)
    assert all(epsilon(left * right) == epsilon(left) * epsilon(right)
               for left in endomorphisms for right in endomorphisms)

    print("C904 exceptional-quintic residue ideal")
    print(f"endomorphism_order_mod2_dimension={endomorphism_space.dimension()}")
    print(f"fano_norm_span_mod2_dimension={norm_space.dimension()}")
    print(f"two_sided_norm_ideal_mod2_dimension={residue_ideal.dimension()}")
    print(f"residue_quotient_dimension={annihilator.dimension()}")
    print(f"epsilon_identity={int(epsilon(identity))}")
    print(f"epsilon_kills_all_norm_generators={all(epsilon(value) == 0 for value in norms)}")
    print("epsilon_multiplicative_on_order_basis=True")
    print("PASS")


main()
