#!/usr/bin/env python3
"""Independent SymPy replay of the C904 Fano-sum support index."""

import importlib.util
from itertools import combinations, combinations_with_replacement
from math import factorial, lcm
from pathlib import Path

from sympy import Matrix
from sympy.matrices.normalforms import hermite_normal_form


SOURCE = Path(__file__).with_name("2026-08-10-c904-minimal-class-divisor-replay.py")
SPEC = importlib.util.spec_from_file_location("c904_minimal_replay", SOURCE)
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def denominator_lcm(values):
    result = 1
    for value in values:
        result = lcm(result, int(value.q))
    return result


def main():
    divisor_forms = BASE.divisor_forms()
    theta = BASE.two_form(BASE.PRINCIPAL_SYMPLECTIC)
    eight_indices = list(combinations(range(10), 8))

    image_rows = []
    for monomial in combinations_with_replacement(range(15), 3):
        value = BASE.wedge(
            BASE.wedge(divisor_forms[monomial[0]],
                       divisor_forms[monomial[1]]),
            divisor_forms[monomial[2]],
        )
        image = BASE.wedge(value, theta)
        image_rows.append([
            3 * image.get(indices, 0) for indices in eight_indices
        ])
    # The Sage certificate proves independently that the 680 triple products
    # generate the full saturated rank-50 source.  Compute their image HNF
    # directly; this avoids an unnecessarily large 210-by-680 source HNF.
    image_hnf = hermite_normal_form(Matrix(image_rows).T)
    assert image_hnf.shape == (45, 15)

    theta_squared = BASE.wedge(theta, theta)
    theta_fourth = BASE.wedge(theta_squared, theta_squared)
    minimal = Matrix([
        theta_fourth.get(indices, 0) // factorial(4)
        for indices in eight_indices
    ])

    coordinates = image_hnf.gauss_jordan_solve(minimal)[0]
    order = denominator_lcm(coordinates)
    assert order == 6
    assert all(value.q == 1 for value in order * coordinates)

    theta_image_hnf = hermite_normal_form(
        Matrix([[value // 3 for value in row] for row in image_rows]).T
    )
    theta_coordinates = theta_image_hnf.gauss_jordan_solve(minimal)[0]
    theta_order = denominator_lcm(theta_coordinates)
    assert theta_order == 2

    print("independent SymPy HNF replay")
    print(f"source generators={len(image_rows)}; image rank={image_hnf.cols}")
    print(f"order modulo theta image={theta_order}")
    print(f"order modulo 3theta=[F+F] image={order}")
    print("PASS")


if __name__ == "__main__":
    main()
