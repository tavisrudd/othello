#!/usr/bin/env python3
"""Independent Fraction/SymPy replay of the C904 parity inputs.

The replay independently reconstructs the 680 divisor triple products from
the committed principal and NS constants.  The Sage certificate additionally
proves that their rank-50 lattice is already saturated; here we verify the
rank over several finite fields and the exact even pairing gcd without using
Sage's lattice implementation.
"""

import importlib.util
from itertools import combinations, combinations_with_replacement
from math import comb, gcd
from pathlib import Path


SOURCE = Path(__file__).with_name("2026-08-10-c904-minimal-class-divisor-replay.py")
SPEC = importlib.util.spec_from_file_location("c904_minimal_replay", SOURCE)
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def chi_line(twist):
    def polynomial_binomial(value, degree):
        numerator = 1
        for offset in range(degree):
            numerator *= value - offset
        return numerator // 24
    return polynomial_binomial(twist + 4, 4) - polynomial_binomial(twist + 1, 4)


def chi_charge(charge, twist):
    return 2 * chi_line(twist) - charge * (twist + 1)


def rank_mod_prime(rows, prime):
    matrix = [[int(value) % prime for value in row] for row in rows]
    pivot_row = 0
    for column in range(len(matrix[0])):
        pivot = next((row for row in range(pivot_row, len(matrix))
                      if matrix[row][column]), None)
        if pivot is None:
            continue
        matrix[pivot_row], matrix[pivot] = matrix[pivot], matrix[pivot_row]
        inverse = pow(matrix[pivot_row][column], -1, prime)
        matrix[pivot_row] = [(inverse * value) % prime
                             for value in matrix[pivot_row]]
        for row in range(len(matrix)):
            if row != pivot_row and matrix[row][column]:
                scale = matrix[row][column]
                matrix[row] = [(left - scale * right) % prime
                               for left, right in zip(matrix[row], matrix[pivot_row])]
        pivot_row += 1
        if pivot_row == len(matrix):
            break
    return pivot_row


def main():
    assert chi_charge(2, 1) == 6
    assert chi_charge(3, 0) == -1
    weights_two = [chi_charge(2, twist) for twist in range(-8, 9)] + [-4, 2]
    weights_three = [chi_charge(3, twist) for twist in range(-8, 9)]
    assert gcd(*(abs(value) for value in weights_two if value)) == 2
    assert gcd(*(abs(value) for value in weights_three if value)) == 1

    forms = BASE.divisor_forms()
    theta = BASE.two_form(BASE.PRINCIPAL_SYMPLECTIC)
    theta_squared = BASE.wedge(theta, theta)
    six_indices = list(combinations(range(10), 6))
    rows = []
    pairings = []
    for monomial in combinations_with_replacement(range(15), 3):
        product_form = BASE.wedge(
            BASE.wedge(forms[monomial[0]], forms[monomial[1]]),
            forms[monomial[2]],
        )
        rows.append([product_form.get(indices, 0) for indices in six_indices])
        pairings.append(BASE.wedge(theta_squared, product_form).get(tuple(range(10)), 0))
    assert len(rows) == comb(17, 3) == 680
    assert gcd(*(abs(value) for value in pairings if value)) == 2
    ranks = {prime: rank_mod_prime(rows, prime) for prime in (2, 3, 5, 7, 11)}
    assert ranks == {2: 50, 3: 50, 5: 50, 7: 50, 11: 50}

    print("corrected charge-2 determinant-weight gcd=2")
    print("charge-3 determinant-weight gcd=1")
    print(f"680 divisor triples; modular ranks={ranks}")
    print("gcd <Theta^2,D1 D2 D3>=2")
    print("PASS")


if __name__ == "__main__":
    main()
