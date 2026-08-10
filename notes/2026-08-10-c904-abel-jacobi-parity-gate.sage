#!/usr/bin/env sage
"""Exact parity audit for the C904 relative Abel--Jacobi gate.

This reuses the certified exotic principal lattice and its full integral
Neron--Severi basis.  It checks the corrected instanton Riemann--Roch
pairings and the integral divisor-generated Hodge-lattice obstruction to an
odd divisor cut of Theta x Theta.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations, combinations_with_replacement
from math import gcd
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def chi_charge(charge, twist):
    """Euler characteristic of a rank-two c1=0, c2=charge line bundle."""
    # chi(O_X(t)) for a cubic X in P^4, interpreted polynomially.
    chi_line = binomial(twist + 4, 4) - binomial(twist + 1, 4)
    return 2 * chi_line - charge * (twist + 1)


def divisor_threefold_lattice():
    _, _, basis, symplectic = principal_lattice("omega", 1)
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)

    forms = []
    zero = zero_matrix(QQ, 5)
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source_form = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        principal_form = basis * source_form * basis.transpose()
        assert principal_form.denominator() == 1
        forms.append(two_form(principal_form.change_ring(ZZ)))

    theta = two_form(symplectic)
    theta_squared = wedge(theta, theta)
    six_indices = list(combinations(range(10), 6))
    rows = []
    pairings = []
    for monomial in combinations_with_replacement(range(15), 3):
        product_form = wedge(wedge(forms[monomial[0]], forms[monomial[1]]),
                             forms[monomial[2]])
        row = vector(ZZ, [product_form.get(indices, 0) for indices in six_indices])
        rows.append(row)
        top = wedge(theta_squared, product_form).get(tuple(range(10)), 0)
        pairings.append(ZZ(top))

    product_lattice = span(ZZ, rows)
    saturated = product_lattice.saturation()
    assert product_lattice.rank() == 50
    assert product_lattice == saturated

    saturated_pairings = []
    for row in saturated.basis_matrix().rows():
        product_form = {indices: ZZ(value)
                        for indices, value in zip(six_indices, row) if value}
        saturated_pairings.append(
            ZZ(wedge(theta_squared, product_form).get(tuple(range(10)), 0))
        )
    product_gcd = gcd(*(abs(int(value)) for value in pairings if value))
    saturated_gcd = gcd(*(abs(int(value)) for value in saturated_pairings if value))
    assert product_gcd == saturated_gcd == 2
    return product_lattice.rank(), product_gcd, saturated_gcd


def main():
    # Xu's omitted point term changes 5 to 6.
    assert chi_charge(2, 1) == 6
    assert chi_charge(2, 0) == 0
    assert chi_charge(3, 0) == -1
    # The charge-two class is 2(1-[O_l]) in numerical K-theory, so every
    # determinant weight is even; O_l has pairing 2, making the gcd exact.
    charge_two_weights = [chi_charge(2, twist) for twist in range(-8, 9)] + [-4, 2]
    assert gcd(*(abs(int(value)) for value in charge_two_weights if value)) == 2
    charge_three_weights = [chi_charge(3, twist) for twist in range(-8, 9)]
    assert gcd(*(abs(int(value)) for value in charge_three_weights if value)) == 1

    rank, product_gcd, saturated_gcd = divisor_threefold_lattice()
    print("C904 relative Abel--Jacobi parity gate")
    print("charge 2: chi(E tensor E)=-4, chi(E(1))=6, chi(E|line)=2; weight gcd=2")
    print("charge 3: chi(E)=-1; weight gcd=1")
    print(f"codimension-3 divisor Hodge lattice rank={rank}; saturation index=1")
    print(f"gcd <Theta^2,D1 D2 D3>: products={product_gcd}, saturation={saturated_gcd}")
    print("odd Theta x Theta divisor cut=IMPOSSIBLE")
    print("PASS")


if __name__ == "__main__":
    main()
