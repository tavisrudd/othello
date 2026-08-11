#!/usr/bin/env python3
"""Independent SymPy replay of the C904 quartic--cubic cusp table."""

from itertools import product
from math import gcd, prod

from sympy import Matrix, Rational, ZZ
from sympy.matrices.normalforms import smith_normal_decomp


def matrix_from_text(text):
    return Matrix([[Rational(token) for token in line.split()]
                   for line in text.strip().splitlines()])


BASIS_Q = matrix_from_text(r"""
1/6 0 0 0 5/6 2/3 0 0 0 1/3
0 1/6 0 0 5/6 0 2/3 0 0 1/3
0 0 1/6 0 5/6 0 0 2/3 0 1/3
0 0 0 1/6 5/6 0 0 0 2/3 1/3
0 0 0 0 1 0 0 0 0 0
0 0 0 0 0 1 0 0 0 0
0 0 0 0 0 0 1 0 0 0
0 0 0 0 0 0 0 1 0 0
0 0 0 0 0 0 0 0 1 0
0 0 0 0 0 0 0 0 0 1
""")

BASIS_X = matrix_from_text(r"""
1/6 0 0 0 5/6 2/3 1/2 0 1/2 1/3
0 1/6 0 0 5/6 0 1/6 1/2 1/2 5/6
0 0 1/6 0 5/6 1/2 1/2 1/6 0 5/6
0 0 0 1/6 5/6 1/2 0 1/2 2/3 1/3
0 0 0 0 1 0 0 0 0 0
0 0 0 0 0 1 0 0 0 0
0 0 0 0 0 0 1 0 0 0
0 0 0 0 0 0 0 1 0 0
0 0 0 0 0 0 0 0 1 0
0 0 0 0 0 0 0 0 0 1
""")


EXPECTED = {
    "infinity": ((2,), (2, 12, 12, 12, 12), (1, 3, 3, 3, 6),
                 (2, 4, 4, 4, 4), (2, 4, 4, 4, 4), 1024),
    "1/3": ((2, 2, 2, 2, 2), (1, 3, 3, 3, 6), (1, 3, 3, 3, 6),
            (2,), (2, 2, 2, 2, 2), 64),
    "1/2": ((2,), (2, 4, 4, 4, 12), (1, 1, 1, 1, 6),
            (2, 4, 4, 4, 4), (2, 4, 4, 4, 4), 1024),
    "0": ((2, 2, 2, 2, 2), (1, 1, 1, 1, 6), (1, 1, 1, 1, 6),
          (2,), (2, 2, 2, 2, 2), 64),
}


def integral(value):
    assert all(entry.q == 1 for entry in value)
    return value.applyfunc(int)


def diagonal_invariants(value):
    diagonal, _, _ = smith_normal_decomp(integral(value), domain=ZZ)
    return tuple(abs(int(diagonal[i, i]))
                 for i in range(min(diagonal.shape)) if diagonal[i, i])


def bezout(a, c):
    old_r, r = abs(a), abs(c)
    old_s, s = 1, 0
    old_t, t = 0, 1
    while r:
        quotient = old_r // r
        old_r, r = r, old_r - quotient * r
        old_s, s = s, old_s - quotient * s
        old_t, t = t, old_t - quotient * t
    old_s *= 1 if a >= 0 else -1
    old_t *= 1 if c >= 0 else -1
    assert old_s * a + old_t * c == 1
    return old_s, old_t


def cusp_nilpotent(a, c, width):
    s, t = bezout(a, c)
    change = Matrix([[a, c], [-t, s]])
    assert change.det() == 1
    nilpotent = change.inv() * Matrix([[0, 0], [width, 0]]) * change
    identity = Matrix.eye(5)
    top = (nilpotent[0, 0] * identity).row_join(
        nilpotent[0, 1] * identity
    )
    bottom = (nilpotent[1, 0] * identity).row_join(
        nilpotent[1, 1] * identity
    )
    return top.col_join(bottom)


def integer_left_kernel(value):
    denominator = 1
    for entry in value:
        denominator = denominator * int(entry.q) // gcd(denominator, int(entry.q))
    equation = integral(denominator * value.T)
    diagonal, _, right = smith_normal_decomp(equation, domain=ZZ)
    rank = sum(diagonal[i, i] != 0 for i in range(min(diagonal.shape)))
    coefficients = right[:, rank:].T
    assert coefficients.shape == (5, 10)
    assert equation * coefficients.T == Matrix.zeros(5, 5)
    return coefficients


def isotropic_intersection(basis, a, c):
    identity = Matrix.eye(5)
    condition = basis * (c * identity).col_join(-a * identity)
    coefficients = integer_left_kernel(condition)
    return coefficients, coefficients * basis


def row_coordinates(rows, target):
    pivots = target.rref()[1]
    assert len(pivots) == 5
    result = rows[:, pivots] * target[:, pivots].inv()
    assert result * target == rows
    return integral(result)


def quotient_map(coefficients_q, coefficients_x, global_map):
    diagonal_q, left_q, _ = smith_normal_decomp(coefficients_q.T, domain=ZZ)
    diagonal_x, left_x, _ = smith_normal_decomp(coefficients_x.T, domain=ZZ)
    assert all(diagonal_q[i, i] == diagonal_x[i, i] == 1 for i in range(5))
    transformed = integral(left_x * global_map.T * left_q.inv())
    assert transformed[5:10, 0:5] == Matrix.zeros(5, 5)
    return tuple(value for value in diagonal_invariants(transformed[5:10, 5:10])
                 if value > 1)


def component_coordinates(nilpotent):
    diagonal, left, _ = smith_normal_decomp(nilpotent.T, domain=ZZ)
    invariants = tuple(abs(int(diagonal[i, i]))
                       for i in range(10) if diagonal[i, i])
    return invariants, left


def two_invariants(elements, moduli):
    if len(elements) == 1:
        return ()
    killed_logs = [0]
    power = 2
    while True:
        count = sum(all((power * entry) % modulus == 0
                        for entry, modulus in zip(element, moduli))
                    for element in elements)
        killed_logs.append(count.bit_length() - 1)
        assert 2 ** killed_logs[-1] == count
        if count == len(elements):
            break
        power *= 2
    at_least = [killed_logs[k] - killed_logs[k - 1]
                for k in range(1, len(killed_logs))]
    result = []
    for exponent in range(1, len(at_least) + 1):
        following = at_least[exponent] if exponent < len(at_least) else 0
        result.extend([2 ** exponent] * (at_least[exponent - 1] - following))
    return tuple(result)


def component_kernel(nilpotent_q, nilpotent_x, global_map):
    invariants_q, left_q = component_coordinates(nilpotent_q)
    invariants_x, left_x = component_coordinates(nilpotent_x)
    transformed = integral(left_x * global_map.T * left_q.inv())
    assert transformed[5:10, 0:5] == Matrix.zeros(5, 5)
    finite_map = transformed[0:5, 0:5]
    kernel = []
    for element in product(*(range(value) for value in invariants_q)):
        image = finite_map * Matrix(element)
        if all(int(image[i]) % invariants_x[i] == 0 for i in range(5)):
            kernel.append(element)
    return invariants_q, invariants_x, two_invariants(kernel, invariants_q), len(kernel)


def main():
    global_map = integral(2 * BASIS_Q * BASIS_X.inv())
    assert diagonal_invariants(global_map) == (1, 1, 1, 1, 2, 2, 4, 4, 4, 4)
    cusps = [
        ("infinity", 1, 4, 2),
        ("1/3", 1, 7, 2),
        ("1/2", 1, 6, 6),
        ("0", 0, 1, 6),
    ]
    print("independent SymPy cusp replay")
    for name, a, c, width in cusps:
        coefficients_q, isotropic_q = isotropic_intersection(BASIS_Q, a, c)
        coefficients_x, isotropic_x = isotropic_intersection(BASIS_X, a, c)
        torus_map = row_coordinates(2 * isotropic_q, isotropic_x)
        torus_kernel = tuple(value for value in diagonal_invariants(torus_map)
                             if value > 1)
        lattice_cokernel = quotient_map(coefficients_q, coefficients_x, global_map)
        nilpotent_v = cusp_nilpotent(a, c, width)
        nilpotent_q = integral(BASIS_Q * nilpotent_v * BASIS_Q.inv())
        nilpotent_x = integral(BASIS_X * nilpotent_v * BASIS_X.inv())
        assert nilpotent_q * global_map == global_map * nilpotent_x
        inv_q, inv_x, kernel_inv, kernel_order = component_kernel(
            nilpotent_q, nilpotent_x, global_map
        )
        ordinary_total = prod(torus_kernel) * kernel_order
        assert prod(inv_x) * kernel_order == 2 * prod(inv_q)
        observed = (torus_kernel, inv_q, inv_x, kernel_inv,
                    lattice_cokernel, ordinary_total)
        assert observed == EXPECTED[name]
        assert prod(torus_kernel) * prod(lattice_cokernel) == 2 ** 10
        print(f"{name}: torus={torus_kernel}; components={inv_q}->{inv_x}; "
              f"component-kernel={kernel_inv}; log-lattice={lattice_cokernel}; "
              f"ordinary-total={ordinary_total}")
    print("PASS")


if __name__ == "__main__":
    main()
