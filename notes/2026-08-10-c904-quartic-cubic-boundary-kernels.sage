#!/usr/bin/env sage
"""Exact cusp kernel tables for the C904 quartic--cubic 2-isogeny."""

from contextlib import redirect_stdout
from io import StringIO
from itertools import product
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def integral_matrix(value):
    assert value.denominator() == 1
    return value.change_ring(ZZ)


def cusp_nilpotent(a, c, width):
    gcd_value, s, t = xgcd(ZZ(a), ZZ(c))
    assert gcd_value == 1
    # Rows (a,c), (b,d) form an SL_2 matrix.
    b, d = -t, s
    change = matrix(ZZ, [[a, c], [b, d]])
    assert change.det() == 1
    standard = matrix(ZZ, [[0, 0], [width, 0]])
    nilpotent_two = change.inverse() * standard * change
    identity = identity_matrix(ZZ, 5)
    return block_matrix(ZZ, [
        [nilpotent_two[0, 0] * identity, nilpotent_two[0, 1] * identity],
        [nilpotent_two[1, 0] * identity, nilpotent_two[1, 1] * identity],
    ])


def isotropic_intersection(basis, a, c):
    identity = identity_matrix(ZZ, 5)
    condition = basis * block_matrix(QQ, [[c * identity], [-a * identity]])
    denominator = lcm(value.denominator() for value in condition.list())
    integral_condition = (denominator * condition).change_ring(ZZ)
    coefficients = integral_condition.transpose().right_kernel().basis_matrix()
    assert coefficients.nrows() == 5
    result = coefficients * basis
    assert result.rank() == 5
    return coefficients, result


def quotient_map(coefficients_q, coefficients_x, map_matrix):
    diagonal_q, left_q, right_q = coefficients_q.transpose().smith_form()
    diagonal_x, left_x, right_x = coefficients_x.transpose().smith_form()
    assert diagonal_q == left_q * coefficients_q.transpose() * right_q
    assert diagonal_x == left_x * coefficients_x.transpose() * right_x
    assert all(diagonal_q[i, i] == diagonal_x[i, i] == 1 for i in range(5))
    transformed = integral_matrix(
        left_x * map_matrix.transpose() * left_q.inverse()
    )
    assert transformed.matrix_from_rows_and_columns(
        range(5, 10), range(5)
    ).is_zero()
    quotient = transformed.matrix_from_rows_and_columns(
        range(5, 10), range(5, 10)
    )
    return [value for value in quotient.elementary_divisors() if value > 1]


def row_coordinates(rows, target_basis):
    pivots = target_basis.pivots()
    assert len(pivots) == target_basis.nrows()
    target_square = target_basis.matrix_from_columns(pivots)
    rows_square = rows.matrix_from_columns(pivots)
    coordinates = rows_square * target_square.inverse()
    assert coordinates * target_basis == rows
    return integral_matrix(coordinates)


def component_coordinates(nilpotent):
    diagonal, left, right = nilpotent.transpose().smith_form()
    assert diagonal == left * nilpotent.transpose() * right
    invariants = [abs(ZZ(diagonal[i, i]))
                  for i in range(diagonal.nrows()) if diagonal[i, i]]
    return invariants, left


def two_group_invariants(elements, moduli):
    order = len(elements)
    if order == 1:
        return []
    assert order == 2 ** valuation(order, 2)
    killed_logs = [0]
    power = 2
    while True:
        count = sum(1 for element in elements
                    if all((power * value) % modulus == 0
                           for value, modulus in zip(element, moduli)))
        killed_logs.append(valuation(count, 2))
        if count == order:
            break
        power *= 2
    at_least = [killed_logs[k] - killed_logs[k - 1]
                for k in range(1, len(killed_logs))]
    exact = []
    for exponent in range(1, len(at_least) + 1):
        next_value = at_least[exponent] if exponent < len(at_least) else 0
        exact.extend([2 ** exponent] * (at_least[exponent - 1] - next_value))
    assert prod(exact) == order
    return exact


def component_kernel(nilpotent_q, nilpotent_x, map_matrix):
    invariants_q, left_q = component_coordinates(nilpotent_q)
    invariants_x, left_x = component_coordinates(nilpotent_x)
    rank_q = len(invariants_q)
    rank_x = len(invariants_x)
    assert rank_q == rank_x == 5
    transformed = integral_matrix(
        left_x * map_matrix.transpose() * left_q.inverse()
    )
    assert transformed.matrix_from_rows_and_columns(
        range(rank_x, 10), range(rank_q)
    ).is_zero()
    finite_map = transformed.matrix_from_rows_and_columns(
        range(rank_x), range(rank_q)
    )

    kernel = []
    for element in product(*(range(value) for value in invariants_q)):
        image = finite_map * vector(ZZ, element)
        if all(image[i] % invariants_x[i] == 0 for i in range(rank_x)):
            kernel.append(element)
    return (invariants_q, invariants_x,
            two_group_invariants(kernel, invariants_q), len(kernel))


def main():
    _, _, basis_q, _ = principal_lattice("zero", 1)
    _, _, basis_x, _ = principal_lattice("omega", 1)
    global_map = integral_matrix(2 * basis_q * basis_x.inverse())
    assert tuple(global_map.elementary_divisors()) == (1, 1, 1, 1, 2, 2, 4, 4, 4, 4)

    # The selected common three-primary slope conjugates the standard
    # Gamma_0(6) cusp vectors by [[1,0],[4,1]].
    cusps = [
        ("infinity", 1, 4, 2),
        ("1/3", 1, 7, 2),
        ("1/2", 1, 6, 6),
        ("0", 0, 1, 6),
    ]
    expected = {
        "infinity": ((2,), (2, 12, 12, 12, 12), (1, 3, 3, 3, 6),
                     (2, 4, 4, 4, 4), (2, 4, 4, 4, 4), 1024),
        "1/3": ((2, 2, 2, 2, 2), (1, 3, 3, 3, 6), (1, 3, 3, 3, 6),
                (2,), (2, 2, 2, 2, 2), 64),
        "1/2": ((2,), (2, 4, 4, 4, 12), (1, 1, 1, 1, 6),
                (2, 4, 4, 4, 4), (2, 4, 4, 4, 4), 1024),
        "0": ((2, 2, 2, 2, 2), (1, 1, 1, 1, 6), (1, 1, 1, 1, 6),
              (2,), (2, 2, 2, 2, 2), 64),
    }
    print("cusp width | torus kernel | Phi_Q -> Phi_X | component kernel")
    for name, a, c, width in cusps:
        coefficients_q, isotropic_q = isotropic_intersection(basis_q, a, c)
        coefficients_x, isotropic_x = isotropic_intersection(basis_x, a, c)
        torus_map = row_coordinates(2 * isotropic_q, isotropic_x)
        torus_kernel = [value for value in torus_map.elementary_divisors()
                        if value > 1]
        lattice_cokernel = quotient_map(coefficients_q, coefficients_x,
                                        global_map)

        nilpotent_v = cusp_nilpotent(a, c, width)
        nilpotent_q = integral_matrix(basis_q * nilpotent_v * basis_q.inverse())
        nilpotent_x = integral_matrix(basis_x * nilpotent_v * basis_x.inverse())
        assert nilpotent_q * global_map == global_map * nilpotent_x
        inv_q, inv_x, kernel_inv, kernel_order = component_kernel(
            nilpotent_q, nilpotent_x, global_map
        )
        ordinary_total = prod(torus_kernel) * kernel_order
        assert prod(inv_x) * kernel_order == 2 * prod(inv_q)
        observed = (tuple(torus_kernel), tuple(inv_q), tuple(inv_x),
                    tuple(kernel_inv), tuple(lattice_cokernel), ordinary_total)
        assert observed == expected[name]
        print(f"{name:8s} {width}: {tuple(torus_kernel)} | "
              f"{tuple(inv_q)} -> {tuple(inv_x)} | {tuple(kernel_inv)} | "
              f"log-lattice={tuple(lattice_cokernel)} | "
              f"total={ordinary_total}")
        assert prod(torus_kernel) * prod(lattice_cokernel) == 2 ** 10
    print("PASS")


if __name__ == "__main__":
    main()
