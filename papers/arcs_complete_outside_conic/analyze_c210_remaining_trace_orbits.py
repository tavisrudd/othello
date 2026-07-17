#!/usr/bin/env python3
"""Normalize all q=64 C210 repair orbits and reduce their seed collisions.

For each of the three nonlinear quadratic-repair orbits and each seed layer,
the forced pair-sum polynomial p(r) has two roots in GF(8).  After sending
those roots to 0 and 1, this checker reduces the split-polynomial trace test
to tr(1/(x^2+x))=0.  Thus every direct GF(8)-coefficient scalar extension has
the same reciprocal-trace obstruction found for the first orbit.
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
            field.add(left[i] if i < len(left) else 0,
                      right[i] if i < len(right) else 0)
            for i in range(size)
        ]

    def poly_mul(left: list[int], right: list[int]) -> list[int]:
        out = [0] * (len(left) + len(right) - 1)
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                out[i + j] = field.add(out[i + j], field.mul(a, b))
        return out

    def poly_scale(poly: list[int], scalar: int) -> list[int]:
        return [field.mul(scalar, coefficient) for coefficient in poly]

    def poly_value(poly: list[int], value: int) -> int:
        out = 0
        for coefficient in reversed(poly):
            out = field.add(field.mul(out, value), coefficient)
        return out

    def cubic_substitute(poly: list[int], origin: int, scale: int) -> list[int]:
        """Coefficients of poly(origin + scale*x), for degree at most three."""
        coefficients = poly + [0] * (4 - len(poly))
        c0, c1, c2, c3 = coefficients
        origin_squared = field.mul(origin, origin)
        scale_squared = field.mul(scale, scale)
        return [
            field.add(
                field.add(c0, field.mul(c1, origin)),
                field.add(field.mul(c2, origin_squared),
                          field.mul(c3, field.mul(origin_squared, origin))),
            ),
            field.add(field.mul(c1, scale),
                      field.mul(c3, field.mul(origin_squared, scale))),
            field.add(field.mul(c2, scale_squared),
                      field.mul(c3, field.mul(origin, scale_squared))),
            field.mul(c3, field.mul(scale_squared, scale)),
        ]

    output_path = Path(__file__).with_name(
        "probe_c210_quadratic_coset_repairs_output.txt"
    )
    record = json.loads(output_path.read_text().splitlines()[-1])
    representatives = [row[:4] for row in record["nonlinear_legal_parameters"]][::4]
    assert len(representatives) == 3

    rows = []
    for orbit, (eta, a, b, c) in enumerate(representatives, start=1):
        eta0, eta1 = omega_coordinates(eta)
        a0, a1 = omega_coordinates(a)
        b0, b1 = omega_coordinates(b)
        c0, c1 = omega_coordinates(c)
        assert a0 == b0 == 0

        normalized = {
            "eta": [tau_exponent(eta0), tau_exponent(eta1)],
            "a": [None, tau_exponent(a1)],
            "b": [None, tau_exponent(b1)],
            "c": [tau_exponent(c0), tau_exponent(c1)],
        }
        collision_rows = []
        for seed_name, seed_height in (("A", 1), ("B", beta)):
            seed0, seed1 = omega_coordinates(seed_height)

            # q = g(r) + seed_height + y^2 + p*y must lie in GF(8),
            # where y=eta+r.  Its omega coefficient uniquely determines p.
            v_poly = [
                field.add(field.add(field.mul(eta1, eta1), c1), seed1),
                b1,
                a1,
            ]
            p_poly = poly_scale(v_poly, field.inv(eta1))
            u_poly = [
                field.add(
                    field.add(field.add(field.mul(eta0, eta0),
                                        field.mul(eta1, eta1)), c0),
                    seed0,
                ),
                0,
                1,
            ]
            q_poly = poly_add(u_poly, poly_mul(p_poly, [eta0, 1]))
            while q_poly[-1] == 0:
                q_poly.pop()

            roots = [r for r in subfield if poly_value(p_poly, r) == 0]
            assert len(roots) == 2
            origin, other = roots
            scale = field.add(origin, other)
            leading = p_poly[2]
            kappa = field.mul(leading, field.mul(scale, scale))
            # With r=origin+scale*x, p=kappa*(x^2+x).
            transformed_q = cubic_substitute(q_poly, origin, scale)
            normalized_q = poly_scale(
                transformed_q, field.inv(field.mul(kappa, kappa))
            )

            # Partial fractions of N/[x^2(x+1)^2].  Under absolute trace,
            # A/x^2 may be replaced by sqrt(A)/x.  The two resulting simple
            # pole coefficients are both one in every case.
            pole_zero_2 = normalized_q[0]
            pole_zero_1 = normalized_q[1]
            pole_one_2 = poly_value(normalized_q, 1)
            pole_one_1 = field.add(normalized_q[1], normalized_q[3])
            reduced_zero = field.add(
                pole_zero_1, field.power(pole_zero_2, field.q // 2)
            )
            reduced_one = field.add(
                pole_one_1, field.power(pole_one_2, field.q // 2)
            )
            assert reduced_zero == reduced_one == 1

            # Independent bounded check of the trace equivalence.
            for x in subfield:
                if x in (0, 1):
                    continue
                r = field.add(origin, field.mul(scale, x))
                p = poly_value(p_poly, r)
                q = poly_value(q_poly, r)
                ratio = field.div(q, field.mul(p, p))
                z = field.add(field.mul(x, x), x)
                assert sum_trace(field, ratio, 3) == sum_trace(
                    field, field.inv(z), 3
                )

            collision_rows.append({
                "seed": seed_name,
                "p_coefficients": [tau_exponent(x) for x in p_poly],
                "p_roots": [tau_exponent(x) for x in roots],
                "normalized_q_coefficients": [
                    tau_exponent(x) for x in normalized_q
                ],
                "reduced_pole_coefficients": [reduced_zero, reduced_one],
            })
        rows.append({
            "orbit": orbit,
            "omega_basis_coefficients": normalized,
            "collisions": collision_rows,
        })

    print(json.dumps({
        "field": "GF(64)/GF(8)",
        "relations": ["omega^2+omega+1=0", "tau^3+tau+1=0"],
        "orbits": rows,
        "uniform_trace_gate": "tr(z)=tr(z^-1)=0, z=x^2+x nonzero",
        "status": "all three direct scalar extensions obstructed",
    }, sort_keys=True))


def sum_trace(field: QuadraticField, value: int, degree: int) -> int:
    out = 0
    conjugate = value
    for _ in range(degree):
        out = field.add(out, conjugate)
        conjugate = field.mul(conjugate, conjugate)
    return out


if __name__ == "__main__":
    main()
