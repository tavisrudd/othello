#!/usr/bin/env python3
"""Classify common components in the C210 seed--repair coverage cubics.

The calculation is uniform over every odd-degree extension of GF(8).  The
checker specializes it to the three frozen q=64 orbit normal forms and audits
all affine targets.  It also verifies that a repair-point target has precisely
the closed neighborhood of its parameter in the two-colored repair collision
graph as its candidate hyperedge.
"""

from __future__ import annotations

import itertools
import json
from pathlib import Path

from analyze_c210_q64_quadratic_orbits import repair_points
from probe_c210_two_layer_parabolas import QuadraticField, layer


def main() -> None:
    field = QuadraticField.for_subfield_order(8)
    subfield = tuple(x for x in range(field.q) if field.in_subfield(x))
    beta = 2
    tau = field.add(beta, field.power(beta, 8))
    omega = field.div(field.add(beta, 1), tau)
    assert field.add(field.add(field.mul(omega, omega), omega), 1) == 0

    def coordinates(value: int) -> tuple[int, int]:
        for second in subfield:
            first = field.add(value, field.mul(second, omega))
            if field.in_subfield(first):
                return first, second
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
    for orbit, (eta, a_big, b_big, c_big) in enumerate(
        representatives, start=1
    ):
        eta0, eta1 = coordinates(eta)
        a0, a1 = coordinates(a_big)
        b0, b1 = coordinates(b_big)
        c0, c1 = coordinates(c_big)
        assert a0 == b0 == 0
        nonquadratic_coefficient = field.add(
            field.add(field.mul(a1, a1), a1), 1
        )
        assert eta1 != 0 and a1 != 0 and nonquadratic_coefficient != 0

        repair_by_parameter = {
            r: (
                field.add(eta0, r),
                eta1,
                c0,
                field.add(
                    field.add(field.mul(a1, field.mul(r, r)),
                              field.mul(b1, r)),
                    c1,
                ),
            )
            for r in subfield
        }
        assert len(repair_points(
            field, subfield, eta, a_big, b_big, c_big
        )) == len(subfield)

        seed_rows = []
        collision_neighbors = {r: set() for r in subfield}
        for seed_name, seed_height in (("A", 1), ("B", beta)):
            seed0, seed1 = coordinates(seed_height)
            vertical_targets = set()
            horizontal_targets = set()
            quadratic_candidates = 0

            # Necessary coefficient comparisons for a common quadratic
            # Q=rt+u*r+v*t+w.  From the F-coordinate quotient one gets
            # u=Y0+a1*Y1.  From the omega-coordinate quotient one gets
            # a1*u=a1*(Y0+Y1)+Y1, hence
            # Y1*(a1^2+a1+1)=0.  Its t^2 coefficient independently gives
            # Y1+eta1=0.  These conditions are incompatible.
            for y0, y1, h0, h1 in itertools.product(subfield, repeat=4):
                first_u = field.add(y0, field.mul(a1, y1))
                second_au = field.add(
                    field.mul(a1, field.add(y0, y1)), y1
                )
                if (
                    field.mul(a1, first_u) == second_au
                    and field.add(y1, eta1) == 0
                ):
                    quadratic_candidates += 1

                r = field.add(y0, eta0)
                if y1 == eta1 and (y0, y1, h0, h1) == (
                    *repair_by_parameter[r][:2],
                    *repair_by_parameter[r][2:],
                ):
                    vertical_targets.add((y0, y1, h0, h1))

                if y1 == 0 and h0 == seed0 and h1 == seed1:
                    horizontal_targets.add((y0, y1, h0, h1))

            assert quadratic_candidates == 0
            assert len(vertical_targets) == len(subfield)
            assert len(horizontal_targets) == len(subfield)

            # Audit the colored collision graph directly.  For s != r,
            # seed--repair coverage of the target R(r) is exactly the
            # two-repair/one-seed collision relation.
            seed_points = layer(field, seed_height, subfield)
            repair_projective = {
                r: (
                    1,
                    field.add(eta, r),
                    field.add(
                        field.mul(field.add(eta, r), field.add(eta, r)),
                        field.add(
                            field.add(field.mul(a_big, field.mul(r, r)),
                                      field.mul(b_big, r)),
                            c_big,
                        ),
                    ),
                )
                for r in subfield
            }
            colored_edges = set()
            for r, s in itertools.combinations(subfield, 2):
                line = field.cross(repair_projective[r], repair_projective[s])
                if any(incident(field, line, point) for point in seed_points):
                    colored_edges.add((r, s))
                    collision_neighbors[r].add(s)
                    collision_neighbors[s].add(r)
            assert not colored_edges  # the full q=64 representative is an arc

            seed_rows.append({
                "seed": seed_name,
                "vertical_repair_components": len(vertical_targets),
                "horizontal_seed_components": len(horizontal_targets),
                "quadratic_components": quadratic_candidates,
                "q64_colored_collision_edges": len(colored_edges),
            })

        q64_repair_hyperedges = {
            r: sorted({r} | collision_neighbors[r]) for r in subfield
        }
        assert all(values == [r]
                   for r, values in q64_repair_hyperedges.items())
        rows.append({
            "orbit": orbit,
            "nonquadratic_coefficient": nonquadratic_coefficient,
            "seed_components": seed_rows,
            "q64_repair_target_hyperedges": q64_repair_hyperedges,
        })

    print(json.dumps({
        "base_constants": "GF(8), extended through GF(8^m) with m odd",
        "coverage_equation_degrees": [3, 3],
        "leading_forms": ["r*t*(r+t)", "a1*r^2*t"],
        "common_component_classification": {
            "vertical": "target equals the repair point R(rho)",
            "horizontal": "target equals the seed point S(theta)",
            "quadratic": "impossible because Y1=0 and Y1=eta1!=0",
        },
        "generic_per_seed_candidate_bound": 9,
        "repair_target_hyperedge": "{r} union N_A(r) union N_B(r)",
        "repair_target_consequence":
            "on the one-repair survivor set, a maximal independent set in "
            "the induced collision graph hits every required repair-target "
            "hyperedge",
        "orbits": rows,
        "status":
            "common components classified; the remaining generic small "
            "hyperedges still require an independent hitting argument",
    }, sort_keys=True))


def incident(field: QuadraticField, line: tuple[int, int, int],
             point: tuple[int, int, int]) -> bool:
    value = 0
    for coefficient, coordinate in zip(line, point, strict=True):
        value = field.add(value, field.mul(coefficient, coordinate))
    return value == 0


if __name__ == "__main__":
    main()
