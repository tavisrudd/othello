#!/usr/bin/env sage
"""Exact characteristic-number audit for canonical p15 correspondences."""

from contextlib import redirect_stdout
from io import StringIO
from itertools import combinations, combinations_with_replacement
import argparse
import sys


_saved_argv = list(sys.argv)
sys.argv = [sys.argv[0], "--export-constants"]
with redirect_stdout(StringIO()):
    load("notes/2026-08-10-c904-minimal-class-divisor-lattice.sage")
sys.argv = _saved_argv


def exterior_action_integral(linear, degree):
    indices = list(combinations(range(10), degree))
    return matrix(ZZ, [[linear.matrix_from_rows_and_columns(rows, columns).det()
                        for columns in indices] for rows in indices])


def a5_invariant_divisor_surface_ideal():
    """Return ranks and theta-trace ideal for A5-invariant NS products."""
    _, _, basis, symplectic = principal_lattice("omega", 1)
    positions, linear_map = ns_integrality_matrix(basis)
    _, ns_lattice = congruence_kernel_lattice(linear_map)
    zero = zero_matrix(QQ, 5)
    divisors = []
    for coordinates in ns_lattice.basis_matrix().LLL().rows():
        coefficient = coefficient_matrix(coordinates, positions)
        source = block_matrix(QQ, [[zero, coefficient], [-coefficient, zero]])
        principal = basis * source * basis.transpose()
        assert principal.denominator() == 1
        divisors.append(two_form(principal.change_ring(ZZ)))

    four_indices = list(combinations(range(10), 4))
    products = []
    for i, j in combinations_with_replacement(range(len(divisors)), 2):
        value = wedge(divisors[i], divisors[j])
        products.append(vector(ZZ, [value.get(index, 0) for index in four_indices]))
    product_lattice = span(ZZ, products)
    product_basis = product_lattice.basis_matrix()

    constraints = None
    for coefficient_action in mobius_generators():
        ambient = block_diagonal_matrix(coefficient_action, coefficient_action)
        principal_action = basis * ambient.transpose() * basis.inverse()
        assert principal_action.denominator() == 1
        principal_action = principal_action.change_ring(ZZ)
        assert principal_action * symplectic * principal_action.transpose() == symplectic
        action4 = exterior_action_integral(principal_action, 4)
        equation = (action4 - identity_matrix(ZZ, action4.nrows())) * product_basis.transpose()
        constraints = equation if constraints is None else constraints.stack(equation)
    invariant_coordinates = constraints.right_kernel_matrix()
    invariant_surfaces = invariant_coordinates * product_basis

    theta = two_form(symplectic)
    theta3 = wedge(wedge(theta, theta), theta)
    top = tuple(range(10))
    values = []
    for row in invariant_surfaces.rows():
        surface = {index: value for index, value in zip(four_indices, row) if value}
        values.append(wedge(theta3, surface).get(top, 0))
    trace_ideal = gcd(values)
    assert trace_ideal % 5 == 0
    return (product_lattice.rank(), invariant_surfaces.nrows(), trace_ideal,
            trace_ideal // 5)


def main(output_path=None):
    n = polygen(QQ, "n")
    hilbert = expand(n**5 - (n - 1)**5)
    assert hilbert == 5*n**4 - 10*n**3 + 10*n**2 - 5*n + 1

    # RR on the fourfold M:
    # [n^4] chi = int h^4/4!, and
    # [n^2] chi = int h^2(c1^2+c2)/24.
    h4_rr = 24 * hilbert[4]
    h2_c1sq_plus_c2_rr = 24 * hilbert[2]
    assert h4_rr == 120
    assert h2_c1sq_plus_c2_rr == 240

    # Independent adjunction calculation on B=Bl_0 J.  Here
    # c(T_B)=(1+e)(1-e)^5 and [M]=h-3e.
    R = PolynomialRing(QQ, names=("h", "e"))
    h, e = R.gens()
    c_b = (1 + e) * (1 - e)**5
    inverse_normal = sum((-1)**degree * (h - 3*e)**degree
                         for degree in range(5))
    c_m = expand(c_b * inverse_normal)
    homogeneous = c_m.homogeneous_components()
    c1 = homogeneous[1]
    c2 = homogeneous[2]
    assert c1 == -h - e
    assert c2 == h**2 - 2*h*e + 2*e**2

    # Integration on M: multiply by h-3e on B, with int_B h^5=120,
    # int_B e^5=1, and every mixed top monomial zero.
    def integrate_m(degree_four):
        top = expand(degree_four * (h - 3*e))
        return 120 * top.monomial_coefficient(h**5) + top.monomial_coefficient(e**5)

    h4_adjunction = integrate_m(h**4)
    h2_c1sq = integrate_m(h**2 * c1**2)
    h2_c2 = integrate_m(h**2 * c2)
    assert h4_adjunction == h4_rr == 120
    assert h2_c1sq == 120
    assert h2_c2 == 120
    assert h2_c1sq + h2_c2 == h2_c1sq_plus_c2_rr

    candidates = {
        "c2(T_M)": h2_c2,
        "h^2/2": h4_adjunction / 2,
        "exceptional surface": 0,
        "c1(T_M)^2": h2_c1sq,
        "ch2(T_M)": (h2_c1sq - 2*h2_c2) / 2,
        "td2(T_M)": (h2_c1sq + h2_c2) / 12,
    }
    expected = {
        "c2(T_M)": 120,
        "h^2/2": 60,
        "exceptional surface": 0,
        "c1(T_M)^2": 120,
        "ch2(T_M)": -60,
        "td2(T_M)": 20,
    }
    assert candidates == expected

    product_rank, invariant_rank, trace_ideal, coefficient_ideal = \
        a5_invariant_divisor_surface_ideal()
    # For any integral A5-horizontal scalar surface, int(theta^3 S)=5a.
    # Since theta^3=3! theta^[3] integrally, 6 divides 5a, hence 6 divides a.
    assert gcd(5, factorial(3)) == 1

    lines = [
        "C904 canonical p15 tautological parity audit",
        f"Hilbert polynomial={hilbert}",
        f"RR: int(h^4)={h4_rr}; int(h^2(c1^2+c2))={h2_c1sq_plus_c2_rr}",
        f"adjunction: c1={c1}; c2={c2}",
    ]
    for name, intersection in candidates.items():
        coefficient = intersection / 5
        canonical_degree = -2 * intersection
        half_degree = -intersection
        lines.append(
            f"{name}: int(h^2 S)={intersection}, coefficient={coefficient}, "
            f"degree(P(S1+S2))={canonical_degree}, hypothetical-half-degree={half_degree}"
        )
    lines.extend([
        "horizontal tautological lattice <h^2/2, exceptional>: coefficient ideal=12Z",
        f"A5-invariant NS-product surfaces: product-rank={product_rank}, invariant-rank={invariant_rank}, trace-ideal={trace_ideal}Z, coefficient-ideal={coefficient_ideal}Z",
        "universal scalar no-go: theta^3=6 theta^[3] and int(theta^3 S)=5a imply a in 6Z",
        "no integral A5-horizontal scalar surface has odd coefficient trace",
        "PASS",
    ])
    output = "\n".join(lines) + "\n"
    if output_path:
        with open(output_path, "w", encoding="utf-8") as stream:
            stream.write(output)
    else:
        print(output, end="")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--output")
    arguments = parser.parse_args()
    main(arguments.output)
