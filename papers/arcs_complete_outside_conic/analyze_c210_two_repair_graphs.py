#!/usr/bin/env python3
"""Certify bounded degree for the C210 two-repair collision graphs.

For a fixed repair parameter r and one of the two seed layers, collinearity
of repair points r,s with a seed point t gives two GF(8)-coordinate equations.
Both equations are linear in s.  Their compatibility polynomial in
x=t+eta_0 is cubic with leading coefficient a_1, while their two s
coefficients can never vanish together.  Hence each seed-colored graph has
maximum degree at most three over every admissible coefficient extension.
"""

from __future__ import annotations

import json
from pathlib import Path

from probe_c210_two_layer_parabolas import QuadraticField


def main() -> None:
    field = QuadraticField.for_subfield_order(8)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    beta = 2
    tau = field.add(beta, field.power(beta, 8))
    omega = field.div(field.add(beta, 1), tau)
    assert field.add(field.add(field.mul(omega, omega), omega), 1) == 0

    def omega_coordinates(value: int) -> tuple[int, int]:
        for v in subfield:
            u = field.add(value, field.mul(v, omega))
            if field.in_subfield(u):
                return u, v
        raise AssertionError(value)

    def tau_exponent(value: int) -> int | None:
        if value == 0:
            return None
        for exponent in range(7):
            if field.power(tau, exponent) == value:
                return exponent
        raise AssertionError(value)

    source_path = Path(__file__).with_name(
        "probe_c210_quadratic_coset_repairs_output.txt"
    )
    source = json.loads(source_path.read_text().splitlines()[-1])
    representatives = [
        row[:4] for row in source["nonlinear_legal_parameters"]
    ][::4]
    assert len(representatives) == 3

    rows = []
    for orbit, (eta, a, b, c) in enumerate(representatives, start=1):
        eta0, eta1 = omega_coordinates(eta)
        a0, a1 = omega_coordinates(a)
        b0, b1 = omega_coordinates(b)
        c0, c1 = omega_coordinates(c)
        assert a0 == b0 == 0
        assert a1 != 0 and eta1 != 0

        # If C_F and C_omega are the coefficients of s in the two
        # coordinate equations, then C_F=0 forces x=r+eta1*a1.  At that x,
        # C_omega=eta1*(a1^2+a1+1), which is nonzero.  (GF(8) has no GF(4)
        # subfield, so X^2+X+1 has no root.)
        coefficient_separation = field.mul(
            eta1,
            field.add(field.add(field.mul(a1, a1), a1), 1),
        )
        assert coefficient_separation != 0

        seed_rows = []
        for seed_name, seed_height in (("A", 1), ("B", beta)):
            seed0, seed1 = omega_coordinates(seed_height)
            assert seed0 == 1
            degrees = {r: set() for r in subfield}
            checked_triples = 0
            for r in subfield:
                for s in subfield:
                    if s == r:
                        continue
                    p = field.add(r, s)
                    q = field.mul(r, s)
                    for t in subfield:
                        x = field.add(t, eta0)
                        v = field.add(field.mul(a1, p), b1)
                        f_equation = field.add(
                            field.add(
                                field.add(field.mul(x, x), field.mul(eta1, eta1)),
                                field.mul(x, p),
                            ),
                            field.add(
                                field.add(field.mul(eta1, v), c0),
                                field.add(q, seed0),
                            ),
                        )
                        omega_equation = field.add(
                            field.add(
                                field.add(field.mul(eta1, eta1), field.mul(x, v)),
                                field.add(field.mul(eta1, p), field.mul(eta1, v)),
                            ),
                            field.add(
                                field.add(c1, field.mul(a1, q)), seed1
                            ),
                        )

                        # Independent direct evaluation of
                        # T^2+T*((a+1)*p+b)+c+(a+1)*q+seed_height.
                        big_t = field.add(eta, t)
                        capital_a = field.add(a, 1)
                        direct = field.add(
                            field.add(
                                field.mul(big_t, big_t),
                                field.mul(
                                    big_t,
                                    field.add(field.mul(capital_a, p), b),
                                ),
                            ),
                            field.add(
                                field.add(c, field.mul(capital_a, q)),
                                seed_height,
                            ),
                        )
                        direct0, direct1 = omega_coordinates(direct)
                        assert direct0 == f_equation
                        assert direct1 == omega_equation
                        checked_triples += 1
                        if direct == 0:
                            degrees[r].add(s)

            # The q=64 representatives are full arcs, so the bounded base
            # field has no such collision.  This is only an independent
            # formula check; the uniform degree-three proof is symbolic.
            max_q64_degree = max(map(len, degrees.values()))
            assert max_q64_degree == 0
            seed_rows.append({
                "seed": seed_name,
                "checked_q64_ordered_triples": checked_triples,
                "q64_max_degree": max_q64_degree,
                "uniform_degree_bound": 3,
                "compatibility_polynomial_degree": 3,
                "compatibility_leading_coefficient_tau_exponent":
                    tau_exponent(a1),
            })

        rows.append({
            "orbit": orbit,
            "a1_tau_exponent": tau_exponent(a1),
            "coefficient_separation_tau_exponent":
                tau_exponent(coefficient_separation),
            "seed_graphs": seed_rows,
            "union_maximum_degree_bound": 6,
        })

    print(json.dumps({
        "base_field": "GF(8)",
        "coordinate_equations": {
            "F":
                "x^2+e1^2+x*p+e1*(a1*p+b1)+c0+q+1=0",
            "omega":
                "e1^2+x*(a1*p+b1)+e1*p+e1*(a1*p+b1)+"
                "c1+a1*q+seed1=0",
            "variables": "p=r+s, q=r*s, x=t+eta0",
        },
        "nondegeneracy":
            "the two s-coefficients cannot vanish together because "
            "e1*(a1^2+a1+1)!=0",
        "elimination":
            "cross-multiplying the two s-linear equations gives a cubic "
            "in x with leading coefficient a1!=0",
        "orbits": rows,
        "one_repair_domain_size": "11*s/120+O(sqrt(s))",
        "additional_conic_deletions": "at most 2 roots of g(r)",
        "independent_domain_lower_bound": "11*s/840-O(sqrt(s))",
        "reason": "a graph of maximum degree 6 has an independent set of size at least |V|/7",
        "status":
            "a linear-size conic-disjoint arc repair domain survives every "
            "collision gate; affine coverage is next",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
