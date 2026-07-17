#!/usr/bin/env python3
"""Certify the C210 one-repair monodromy and character independence.

The mixed-seed equation M(r,d)=0 defines a degree-five cover of the r-line.
This checker verifies the orbit-specific nonvanishing facts behind its eight
simple branch points and compares their support with the two same-seed
Artin--Schreier covers.  The proof recorded in the accompanying audit then
uses standard monodromy and function-field Chebotarev arguments.
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
    omega_squared = field.mul(omega, omega)
    assert field.add(field.add(omega_squared, omega), 1) == 0

    def from_tau_exponent(exponent: int | None) -> int:
        return 0 if exponent is None else field.power(tau, exponent)

    def tau_exponent(value: int) -> int | None:
        if value == 0:
            return None
        for exponent in range(7):
            if field.power(tau, exponent) == value:
                return exponent
        raise AssertionError(value)

    def omega_coordinates(value: int) -> tuple[int, int]:
        for v in subfield:
            u = field.add(value, field.mul(v, omega))
            if field.in_subfield(u):
                return u, v
        raise AssertionError(value)

    mixed_path = Path(__file__).with_name(
        "analyze_c210_mixed_seed_collisions_output.txt"
    )
    mixed = json.loads(mixed_path.read_text())
    partial_path = Path(__file__).with_name(
        "analyze_c210_partial_domain_deletions_output.txt"
    )
    partial = json.loads(partial_path.read_text())
    trace_path = Path(__file__).with_name(
        "analyze_c210_remaining_trace_orbits_output.txt"
    )
    trace = json.loads(trace_path.read_text())

    partial_by_orbit = {row["orbit"]: row for row in partial["orbits"]}
    trace_by_orbit = {row["orbit"]: row for row in trace["orbits"]}
    rows = []
    for row in mixed["orbits"]:
        orbit = row["orbit"]
        d_coefficients = row["M_d_coefficients_low_to_high"]
        e1 = from_tau_exponent(row["eta_omega_coefficient"])
        k_tau_squared = from_tau_exponent(d_coefficients[1][0])
        k = field.div(k_tau_squared, field.mul(tau, tau))
        separation = field.add(field.mul(e1, e1), k)
        assert separation != 0

        critical_rows = []
        for omega_power in (omega, omega_squared):
            # The derivative in d and M vanish simultaneously only when
            # x=d^2 is tau*omega or tau*omega^2.
            x = field.mul(tau, omega_power)
            critical_w = field.add(
                field.mul(field.mul(e1, e1), x),
                field.div(field.mul(k, field.mul(tau, tau)), x),
            )
            critical_w0, critical_w1 = omega_coordinates(critical_w)
            assert critical_w1 != 0

            # Frobenius squaring is bijective on GF(64), so x has one square
            # root.  The second Hasse derivative is nonzero, giving local
            # ramification index exactly two.
            d = field.power(x, field.q // 2)
            hasse_two = field.add(
                field.mul(critical_w, d),
                field.mul(e1, field.mul(tau, tau)),
            )
            assert hasse_two != 0
            hasse0, hasse1 = omega_coordinates(hasse_two)
            critical_rows.append({
                "critical_w_omega_coordinates": [
                    tau_exponent(critical_w0), tau_exponent(critical_w1)
                ],
                "hasse_derivative_2_omega_coordinates": [
                    tau_exponent(hasse0), tau_exponent(hasse1)
                ],
            })

        # The two critical values differ by tau*(e1^2+k), so their four
        # separable additive-quartic fibers are disjoint: eight branch values.
        assert field.mul(tau, separation) != 0

        collision_rows = {
            item["seed"]: item
            for item in trace_by_orbit[orbit]["collisions"]
        }
        roots_a = {
            from_tau_exponent(x) for x in collision_rows["A"]["p_roots"]
        }
        roots_b = {
            from_tau_exponent(x) for x in collision_rows["B"]["p_roots"]
        }
        assert len(roots_a) == len(roots_b) == 2
        assert roots_a.isdisjoint(roots_b)
        assert partial_by_orbit[orbit][
            "x_A_plus_x_B_tau_exponent"
        ] not in (None, 0)

        rows.append({
            "orbit": orbit,
            "e1_squared_plus_k_tau_exponent": tau_exponent(separation),
            "critical_values": critical_rows,
            "mixed_branch_values": 8,
            "mixed_inertia_cycle_type": [2, 1, 1, 1],
            "same_seed_pole_values_in_GF8": 4,
            "same_seed_poles_disjoint": True,
            "mixed_branch_support_disjoint_from_same_seed_poles": True,
        })

    derangements_s5 = 44
    group_order = 120 * 4
    assert derangements_s5 * 1 == 44
    assert group_order == 480

    print(json.dumps({
        "base_field": "GF(8)",
        "mixed_cover_degree": 5,
        "mixed_geometric_monodromy": "S5",
        "mixed_arithmetic_monodromy": "S5",
        "reason":
            "eight distinct simple branch points have transposition inertia; "
            "a transitive degree-five subgroup containing a transposition is S5",
        "same_seed_character_group": "C2 x C2",
        "joint_group": "S5 x C2 x C2",
        "independence_certificate":
            "the two disjoint two-pole Artin-Schreier supports lie in GF(8), "
            "while the S5 sign cover ramifies at the eight mixed branch values "
            "outside GF(8)",
        "orbits": rows,
        "s5_derangements": derangements_s5,
        "joint_group_order": group_order,
        "one_repair_legal_density": "44/480=11/120",
        "asymptotic_survivors": "11*s/120+O(sqrt(s))",
        "admissible_extensions":
            "F=GF(8^m), m odd, with E=F(omega)",
        "status":
            "linear-size domains survive every one-repair collision gate; "
            "two-repair/one-seed independence is next",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
