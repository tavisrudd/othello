#!/usr/bin/env python3
"""Derive the universal bad-parameter sets for C210 partial repairs.

The preceding trace-orbit certificate records the two roots of the forced
pair-sum polynomial for each orbit and seed layer.  This checker verifies that
the two root pairs have the same difference and computes the translation
between their normalized parameters.  Hence legality against both same-seed
secant classes requires deleting one union B union (B+delta).
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

    def from_tau_exponent(exponent: int | None) -> int:
        return 0 if exponent is None else field.power(tau, exponent)

    def tau_exponent(value: int) -> int:
        assert value != 0
        for exponent in range(7):
            if field.power(tau, exponent) == value:
                return exponent
        raise AssertionError(value)

    def absolute_trace(value: int) -> int:
        out = 0
        conjugate = value
        for _ in range(3):
            out = field.add(out, conjugate)
            conjugate = field.mul(conjugate, conjugate)
        return out

    source_path = Path(__file__).with_name(
        "analyze_c210_remaining_trace_orbits_output.txt"
    )
    source = json.loads(source_path.read_text())
    orbit_rows = []
    for orbit in source["orbits"]:
        by_seed = {row["seed"]: row for row in orbit["collisions"]}
        roots_a = [
            from_tau_exponent(value) for value in by_seed["A"]["p_roots"]
        ]
        roots_b = [
            from_tau_exponent(value) for value in by_seed["B"]["p_roots"]
        ]
        scale_a = field.add(*roots_a)
        scale_b = field.add(*roots_b)
        assert scale_a == scale_b != 0

        # x_A=(r+r_A0)/scale and x_B=(r+r_B0)/scale in characteristic two.
        delta = field.div(field.add(roots_a[0], roots_b[0]), scale_a)
        assert delta not in (0, 1)
        orbit_rows.append({
            "orbit": orbit["orbit"],
            "x_A_plus_x_B_tau_exponent": tau_exponent(delta),
        })

    bad = {
        x for x in subfield if x not in (0, 1)
        if absolute_trace(field.inv(field.add(field.mul(x, x), x))) == 0
    }
    assert not bad  # GF(8) is the exceptional reciprocal-trace-free field.

    print(json.dumps({
        "universal_bad_set":
            "B_s={x in F\\{0,1}: tr(1/(x^2+x))=0}",
        "single_seed_size": "|B_s|=(s-3+K_s)/2",
        "two_seed_deletions": "D_delta=|B_s union (B_s+delta)|",
        "intersection_formula":
            "|B_s intersect (B_s+delta)|="
            "1/4 sum_{x notin {0,1,delta,delta+1}} "
            "(1+chi(f(x)))(1+chi(f(x+delta))), f(x)=1/(x^2+x)",
        "fixed_delta_asymptotics":
            "|B_s|=s/2+O(sqrt(s)); D_delta=3s/4+O(sqrt(s)); "
            "survivors=s/4+O(sqrt(s))",
        "orbits": orbit_rows,
        "q64_bad_set": sorted(bad),
        "status":
            "same-seed deletion floor quantified; other collisions and coverage remain open",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
