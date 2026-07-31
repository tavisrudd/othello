#!/usr/bin/env python3
"""Independent Fraction-arithmetic replay of the C705 E6 first-jet identity."""

from fractions import Fraction as F


TARGET_CHANGE = (
    (0, 0, 0, 0, -2),
    (0, 2, 2, 0, 0),
    (2, 0, 0, 0, 0),
    (2, 0, 0, 2, -2),
    (2, 2, 0, 0, -2),
)


def segre_cubic(y):
    return (
        y[0] * y[1] * y[3]
        + y[0] * y[2] * y[4]
        - y[1] * y[2] * y[4]
        + y[1] * y[3] * y[4]
        + y[2] * y[2] * y[4]
        - y[2] * y[3] * y[4]
    )


def segre_gradient(y):
    return (
        y[1] * y[3] + y[2] * y[4],
        y[0] * y[3] - y[2] * y[4] + y[3] * y[4],
        y[0] * y[4] - y[1] * y[4] + 2 * y[2] * y[4] - y[3] * y[4],
        y[0] * y[1] + y[1] * y[4] - y[2] * y[4],
        y[0] * y[2] - y[1] * y[2] + y[1] * y[3] + y[2] * y[2] - y[2] * y[3],
    )


def matrix_vector(matrix, vector):
    return tuple(
        sum(F(entry) * vector[index] for index, entry in enumerate(row))
        for row in matrix
    )


samples = (
    (2, 7, 13),
    (3, 8, 15),
    (4, 9, 12),
    (5, 11, 16),
    (6, 10, 14),
    (7, 12, 17),
    (8, 13, 19),
    (9, 14, 18),
    (10, 16, 21),
    (11, 17, 20),
    (12, 19, 23),
    (13, 20, 24),
)

for a, b, c in samples:
    z1, z2, z3 = map(F, (a, b, c))
    x1 = (1 - z1) / (1 - z2)
    x2 = (1 - z1) / (1 - z3)
    x3 = z1 / z2
    x4 = z1 / z3
    d1 = x1 * x4 - x2 * x3
    d2 = x1 * x4 - x4 + x2 - x2 * x3 + x3 - x1
    q = -x2 * x3 * x1 - x2 * x3 * x4 + x2 * x3 + x1 * x4 * x2 + x1 * x4 * x3 - x1 * x4
    assert q == 0

    surviving_raw = (
        d1 * (x1 - 1) * (x2 - 1) * (x4 - x3),
        d1 * (x1 - 1) * (x3 - 1) * (x4 - x2),
        d1 * (x2 - 1) * (x4 - 1) * (x3 - x1),
        -d1 * x1 * (x2 - 1) * (x3 - 1),
        d2 * x2 * x3 * (x1 - 1),
    )
    segre = (
        -z1 * (z2 - z3),
        z1 - z2,
        z1 - z3,
        z3 * (z1 - 1),
        -z3 * (z1 - z2),
    )
    surviving_scale = (
        z1
        * (z1 - 1)
        * (z1 - z2)
        * (z1 - z3)
        * (z2 - z3)
        / (z2**2 * z3**2 * (z2 - 1) ** 2 * (z3 - 1) ** 2)
    )
    assert surviving_raw == tuple(surviving_scale * value for value in segre)
    assert segre_cubic(segre) == 0

    normal_raw = (d1, x2 - x1, x3 - x1, x4 - x2, x1 * (x4 - 1))
    normal_scale = z2 * z3 * (z2 - 1) * (z3 - 1)
    normal = tuple(normal_scale * value for value in normal_raw)
    transformed_gradient = matrix_vector(TARGET_CHANGE, segre_gradient(segre))
    assert transformed_gradient == tuple(-2 * value for value in normal)

# Directly replay the generic D_{456} boundary valuation with
# z_i=a+t*(u,v,w): all five coefficients have order exactly one.
def normal_coefficients(z1, z2, z3):
    return (
        -z1 * (z1 - 1) * (z2 - z3),
        z2 * z3 * (z1 - 1) * (z2 - z3),
        -(z1 - z2) * z3 * (z3 - 1),
        -(z1 - z3) * z2 * (z2 - 1),
        (z1 - 1) * (z1 - z3) * z2 * (z3 - 1),
    )


base = F(5)
directions = (F(2), F(3), F(7))
cluster_values = tuple(
    normal_coefficients(
        base + step * directions[0],
        base + step * directions[1],
        base + step * directions[2],
    )
    for step in map(F, range(5))
)
assert cluster_values[0] == (0, 0, 0, 0, 0)
# The five-point forward derivative is exact here because every coefficient
# has degree at most four in the cluster parameter.
weights = (F(-25, 12), F(4), F(-3), F(4, 3), F(-1, 4))
leading = tuple(
    sum(weights[step] * cluster_values[step][index] for step in range(5))
    for index in range(5)
)
assert all(value != 0 for value in leading)

print(
    "PASS independent Fraction replay at 12 boundary points: "
    "the ambient normal jet is the Segre-to-Igusa polar map with a B3 factor"
)
