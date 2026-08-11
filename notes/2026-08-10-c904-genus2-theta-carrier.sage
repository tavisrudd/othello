#!/usr/bin/env sage
"""Polarization on the anti-invariant surface of an A5 involution.

The actual exotic principal homology lattice is imported from the C904
minimal-class certificate.  For every involution in the six-axis A5 action,
we compute the saturated anti-invariant homology lattice and the elementary
divisors of the restricted principal symplectic form.
"""

from contextlib import redirect_stdout
from io import StringIO
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def matrix_order(value):
    identity = identity_matrix(ZZ, value.nrows())
    power = identity
    for order in range(1, 61):
        power *= value
        if power == identity:
            return order
    raise AssertionError("axis action has order larger than 60")


def saturated_left_kernel(value):
    """Integral row vectors killed by value, returned as a row basis."""
    kernel = value.transpose().right_kernel_matrix()
    assert kernel.base_ring() == ZZ
    return kernel


def main():
    _, _, basis, principal_form = principal_lattice("omega", 1)
    identity_five = identity_matrix(ZZ, 5)
    involutions = [value for value in generated_axis_group()
                   if value != identity_five and matrix_order(value) == 2]
    assert len(involutions) == 15

    types = set()
    for action in involutions:
        # axis_action acts on columns.  Rows in the source homology lattice
        # therefore transform by action^t on each multiplicity copy.
        source_action = block_diagonal_matrix(action.transpose(), action.transpose())
        principal_action = basis * source_action * basis.inverse()
        assert principal_action.denominator() == 1
        principal_action = principal_action.change_ring(ZZ)
        assert principal_action * principal_form * principal_action.transpose() == principal_form

        anti_basis = saturated_left_kernel(principal_action + 1)
        plus_basis = saturated_left_kernel(principal_action - 1)
        assert anti_basis.nrows() == 4
        assert plus_basis.nrows() == 6

        restricted = anti_basis * principal_form * anti_basis.transpose()
        smith = restricted.smith_form()[0]
        diagonal = tuple(abs(ZZ(smith[i, i])) for i in range(4))
        assert diagonal[0] == diagonal[1]
        assert diagonal[2] == diagonal[3]
        assert diagonal[2] % diagonal[0] == 0
        types.add((diagonal[0], diagonal[2]))

    assert len(types) == 1
    polarization_type = next(iter(types))
    print("C904 genus-two anti-invariant theta carrier")
    print(f"involutions checked: {len(involutions)}")
    print("anti-invariant homology rank: 4")
    print(f"restricted polarization type: {polarization_type}")


main()
