#!/usr/bin/env python3
"""Scalar of the Poincare-cube correspondence restricted to F x F.

In a standard symplectic rank-ten lattice, [F]=theta^3/3! and the
Poincare form is m*theta-theta_1-theta_2.  The script computes the pairing
on H^1(F) induced by (a x a)^*(P^3/3!).
"""


def wedge_sign(left, right):
    if set(left) & set(right):
        return 0
    inversions = sum(a > b for a in left for b in right)
    return -1 if inversions % 2 else 1


def wedge(left, right):
    result = {}
    for left_indices, left_value in left.items():
        for right_indices, right_value in right.items():
            sign = wedge_sign(left_indices, right_indices)
            if not sign:
                continue
            indices = tuple(sorted(left_indices + right_indices))
            result[indices] = result.get(indices, 0) + sign * left_value * right_value
    return {indices: value for indices, value in result.items() if value}


def power(value, exponent):
    result = {(): 1}
    for _ in range(exponent):
        result = wedge(result, value)
    return result


def divided_power(value, exponent, divisor):
    result = power(value, exponent)
    assert all(coefficient % divisor == 0 for coefficient in result.values())
    return {indices: coefficient // divisor for indices, coefficient in result.items()}


def main():
    theta_first = {(2 * i, 2 * i + 1): 1 for i in range(5)}
    theta_second = {(10 + 2 * i, 10 + 2 * i + 1): 1 for i in range(5)}
    poincare = {}
    for i in range(5):
        # e_1 f_2 + e_2 f_1, written in increasing exterior order.
        for left, right in ((2 * i, 10 + 2 * i + 1),
                            (10 + 2 * i, 2 * i + 1)):
            indices = tuple(sorted((left, right)))
            poincare[indices] = (poincare.get(indices, 0)
                                 + wedge_sign((left,), (right,)))

    fano_first = divided_power(theta_first, 3, 6)
    fano_second = divided_power(theta_second, 3, 6)
    poincare_cube = divided_power(poincare, 3, 6)
    kernel = wedge(wedge(fano_first, fano_second), poincare_cube)
    top = tuple(range(20))

    pairing = []
    for first in range(10):
        row = []
        for second in range(10):
            value = wedge(kernel, {(first,): 1})
            value = wedge(value, {(10 + second,): 1})
            row.append(value.get(top, 0))
        pairing.append(row)

    principal = [[0] * 10 for _ in range(10)]
    for i in range(5):
        principal[2 * i][2 * i + 1] = 1
        principal[2 * i + 1][2 * i] = -1
    assert pairing == [[4 * value for value in row] for row in principal]

    print("C904 Poincare-cube Fano scalar")
    print("minimal surface normalization: [F]=theta^3/3!")
    print("integral Fourier component: S=P^3/3!")
    print("induced H1(F) pairing: 4 times principal")
    print("universal-line composite on H3(X): +/-4 times identity")


if __name__ == "__main__":
    main()
