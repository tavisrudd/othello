#!/usr/bin/env python3
"""Eliminate the mixed-seed chord variables for the C210 partial repairs.

For the three GF(8)-coefficient repair orbits, write E=F(omega),
omega^2+omega+1=0, beta=1+tau*omega, and

    eta=e0+e1*omega,
    g(r)=g0+(a1*r^2+b1*r+c1)*omega.

After eliminating the first seed parameter, a repair point at parameter r is
on an A--B chord exactly when M(r,d)=0 for some d in F^*.  The checker derives
M, compares it to the original chord formula over GF(64)/GF(8), and records
the additive-polynomial data used by the geometric irreducibility argument.
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
    assert field.add(field.add(field.power(tau, 3), tau), 1) == 0

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

    def poly_add(left: list[int], right: list[int]) -> list[int]:
        size = max(len(left), len(right))
        return [
            field.add(
                left[i] if i < len(left) else 0,
                right[i] if i < len(right) else 0,
            )
            for i in range(size)
        ]

    def poly_scale(poly: list[int], scalar: int) -> list[int]:
        return [field.mul(scalar, coefficient) for coefficient in poly]

    def poly_value(poly: list[int], value: int) -> int:
        out = 0
        for coefficient in reversed(poly):
            out = field.add(field.mul(out, value), coefficient)
        return out

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
        assert eta1 != 0 and a1 != 0 and b1 != 0

        # h(r)=g_omega(r)+eta1^2.  The r-dependent coefficient of d^3
        # in M is h(r)^2+tau*h(r), a separable linearized quartic plus a
        # constant.
        h = [field.add(c1, field.mul(eta1, eta1)), b1, a1]
        h_squared = [0] * 5
        h_squared[0] = field.mul(h[0], h[0])
        h_squared[2] = field.mul(h[1], h[1])
        h_squared[4] = field.mul(h[2], h[2])
        linearized = poly_add(h_squared, poly_scale(h, tau))

        k = field.add(c0, 1)
        d_coefficients = [
            [field.mul(field.power(tau, 3), eta1)],
            [field.mul(k, field.mul(tau, tau))],
            [field.mul(eta1, field.mul(tau, tau))],
            linearized,
            [field.mul(eta1, tau)],
            [field.mul(eta1, eta1)],
        ]

        mixed_collisions = 0
        for r in subfield:
            repair_height = field.add(
                field.add(field.mul(a, field.mul(r, r)), field.mul(b, r)), c
            )
            y = field.add(eta, r)
            for d in subfield:
                if d == 0:
                    continue
                m_value = 0
                d_power = 1
                for coefficient in d_coefficients:
                    m_value = field.add(
                        m_value,
                        field.mul(poly_value(coefficient, r), d_power),
                    )
                    d_power = field.mul(d_power, d)

                # The omega-coordinate equation uniquely recovers the first
                # seed parameter t for fixed (r,d).
                h_value = poly_value(h, r)
                x0 = field.add(
                    eta1,
                    field.div(
                        field.mul(d, field.add(h_value, field.mul(d, eta1))),
                        tau,
                    ),
                )
                t = field.add(x0, field.add(eta0, r))
                assert field.in_subfield(t)
                lam = field.div(field.add(y, t), d)
                chord_height = field.add(
                    1,
                    field.add(
                        field.mul(lam, field.add(beta, 1)),
                        field.mul(
                            field.mul(d, d),
                            field.mul(lam, field.add(1, lam)),
                        ),
                    ),
                )
                direct_collision = chord_height == repair_height
                assert (m_value == 0) == direct_collision
                mixed_collisions += int(direct_collision)

        # The coefficient of r in h^2+tau*h is tau*b1, so the additive
        # quartic is separable.  Dividing M by d^3 gives a right side with a
        # pole of exact odd order three at d=0, because the constant term is
        # tau^3*eta1 != 0.
        assert linearized[1] == field.mul(tau, b1) != 0
        assert d_coefficients[0][0] != 0
        assert mixed_collisions == 0  # the known q=64 full arcs

        rows.append({
            "orbit": orbit,
            "eta_omega_coefficient": tau_exponent(eta1),
            "h_coefficients": [tau_exponent(x) for x in h],
            "linearized_r_coefficients": [
                tau_exponent(x) for x in linearized
            ],
            "M_d_coefficients_low_to_high": [
                [tau_exponent(x) for x in coefficient]
                for coefficient in d_coefficients
            ],
            "q64_mixed_collision_pairs": mixed_collisions,
            "separable_r_coefficient": tau_exponent(linearized[1]),
            "d_zero_pole_order_after_dividing_by_d3": 3,
        })

    print(json.dumps({
        "field": "GF(64)/GF(8)",
        "relations": ["omega^2+omega+1=0", "tau^3+tau+1=0"],
        "equation":
            "M(r,d)=e1^2*d^5+e1*tau*d^4+"
            "(h(r)^2+tau*h(r))*d^3+e1*tau^2*d^2+"
            "(g0+1)*tau^2*d+tau^3*e1",
        "quantifier": "mixed collision iff M(r,d)=0 for some d in F^*",
        "orbits": rows,
        "geometric_certificate":
            "as a polynomial in r, M/d^3 is a separable additive quartic "
            "equal to a rational function with an odd order-3 pole at d=0; "
            "the Artin-Schreier quotient pole criterion gives geometric "
            "irreducibility",
        "status":
            "mixed equation eliminated; joint density with the two "
            "same-seed trace constraints remains open",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
