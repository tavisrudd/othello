#!/usr/bin/env sage
"""Test whether the minimal curve class is supported on theta ambiently.

The source lattice is the full integral divisor-cube Hodge lattice from the
C904 exotic principal quotient.  We multiply it by theta and compute the
order of the minimal curve class in the resulting integral lattice.
"""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations, combinations_with_replacement
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def main():
    _, _, basis, symplectic = principal_lattice("omega", 1)
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)

    zero = zero_matrix(QQ, 5)
    divisors = []
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        alternating = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        integral_form = basis * alternating * basis.transpose()
        assert integral_form.denominator() == 1
        divisors.append(two_form(integral_form.change_ring(ZZ)))

    degree_two = {}
    for i, j in combinations_with_replacement(range(len(divisors)), 2):
        degree_two[(i, j)] = wedge(divisors[i], divisors[j])

    theta = two_form(symplectic)
    eight_indices = list(combinations(range(10), 8))
    image_rows = []
    for i, j, k in combinations_with_replacement(range(len(divisors)), 3):
        cube = wedge(degree_two[(i, j)], divisors[k])
        image = wedge(theta, cube)
        image_rows.append(vector(ZZ, [image.get(indices, 0) for indices in eight_indices]))

    theta_squared = wedge(theta, theta)
    theta_fourth = wedge(theta_squared, theta_squared)
    minimal = vector(ZZ, [theta_fourth.get(indices, 0) // factorial(4)
                          for indices in eight_indices])
    image_lattice = span(ZZ, image_rows)
    rational_span = span(QQ, image_rows)
    assert minimal in rational_span
    coordinates = image_lattice.coordinate_vector(minimal)
    order = lcm(value.denominator() for value in coordinates)
    assert order == 2
    assert minimal not in image_lattice
    assert 2 * minimal in image_lattice

    (_, hodge_lattice, _, _, _, _, _, _, _) = divisor_product_lattice(
        basis, symplectic, positions, ns_lattice, find_identity=False
    )
    assert image_lattice.is_submodule(hodge_lattice)
    quotient_matrix = matrix(ZZ, [hodge_lattice.coordinate_vector(row)
                                  for row in image_lattice.basis_matrix().rows()])
    smith = quotient_matrix.smith_form()[0]
    quotient_invariants = tuple(abs(ZZ(smith[i, i]))
                                for i in range(smith.nrows())
                                if abs(ZZ(smith[i, i])) > 1)
    assert quotient_invariants == (2,)

    print("C904 ambient theta-support lattice")
    print(f"divisor-cube products: {len(image_rows)}")
    print(f"theta-image rank: {image_lattice.rank()}")
    print(f"Hodge-lattice quotient invariants: {quotient_invariants}")
    print(f"minimal-class order modulo theta image: {order}")
    print("minimal supported by ambient divisor cubes: no")
    print("twice minimal supported by ambient divisor cubes: yes")


main()
