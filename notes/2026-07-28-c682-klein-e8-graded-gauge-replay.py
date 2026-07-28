#!/usr/bin/env python3
"""Independent finite-field replay of the C682 E8 graded gauge."""

from __future__ import annotations


def matmul(left, right, modulus):
    return [
        [
            sum(
                left[row][index] * right[index][column]
                for index in range(len(right))
            )
            % modulus
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def diagonal(entries):
    return [
        [entries[row] if row == column else 0 for column in range(len(entries))]
        for row in range(len(entries))
    ]


def reverse(matrix):
    return [list(reversed(row)) for row in reversed(matrix)]


def inverse(value, modulus):
    return pow(value % modulus, -1, modulus)


def check_point(F, h, modulus):
    A = [
        [-10 * h, 120 * F, 0],
        [0, 2 * h, 12 * F],
        [240 * F**3, 0, 10 * h],
    ]
    B = [
        [10 * h**2, -600 * F * h, 720 * F**2],
        [1440 * F**4, -50 * h**2, 60 * F * h],
        [-240 * F**3 * h, 14400 * F**4, -10 * h**2],
    ]
    A = [[entry % modulus for entry in row] for row in A]
    B = [[entry % modulus for entry in row] for row in B]

    Y = -h * inverse(12, modulus) % modulus
    Z = F % modulus
    phi = [
        [-Y**2, -Z**4, -Y * Z**3],
        [-Y * Z, Y**2, -Z**4],
        [-Z**2, Y * Z, Y**2],
    ]
    psi = [
        [Y, 0, Z**3],
        [Z, -Y, 0],
        [0, Z, -Y],
    ]
    phi = [[entry % modulus for entry in row] for row in phi]
    psi = [[entry % modulus for entry in row] for row in psi]

    L = diagonal([1, -10 % modulus, -2 % modulus])
    R = diagonal(
        [
            -inverse(120, modulus) % modulus,
            -inverse(240, modulus) % modulus,
            inverse(240, modulus),
        ]
    )
    L_inverse = diagonal([1, -inverse(10, modulus) % modulus, -inverse(2, modulus) % modulus])
    R_inverse = diagonal([-120 % modulus, -240 % modulus, 240 % modulus])

    gauged_A = matmul(matmul(L, reverse(A), modulus), R, modulus)
    gauged_B = matmul(
        matmul(R_inverse, reverse(B), modulus),
        L_inverse,
        modulus,
    )
    if gauged_A != psi:
        raise AssertionError(("A gauge", modulus, F, h))
    if gauged_B != [
        [(-172800 * entry) % modulus for entry in row] for row in phi
    ]:
        raise AssertionError(("B gauge", modulus, F, h))

    t_squared = (1728 * F**5 - h**3) % modulus
    expected = diagonal([100 * t_squared % modulus] * 3)
    if matmul(A, B, modulus) != expected or matmul(B, A, modulus) != expected:
        raise AssertionError(("C682 potential", modulus, F, h))
    g = (Y**3 + Z**5) % modulus
    negative_g = diagonal([-g % modulus] * 3)
    if matmul(phi, psi, modulus) != negative_g:
        raise AssertionError(("standard potential", modulus, F, h))
    if matmul(psi, phi, modulus) != negative_g:
        raise AssertionError(("standard reverse potential", modulus, F, h))


def main():
    checked = 0
    for modulus in (101, 103):
        for F in range(modulus):
            for h in range(modulus):
                check_point(F, h, modulus)
                checked += 1
    print(
        "independent graded gauge replay: PASS "
        f"({checked} finite-field points over F_101 and F_103)"
    )


if __name__ == "__main__":
    main()
