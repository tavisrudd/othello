#!/usr/bin/env python3
"""Derive and test the C210 two-repair-coset legality gate.

After the single quadratic graph is closed, the smallest new transversal
mechanism adds a second repair coset.  For two quadratic graphs this checker
derives the exact cross-layer collision test.  A point on the second graph at
parameter ``s`` lies on a chord through two points of the first graph iff one
explicit quadratic ``X^2+p(s)X+q(s)`` splits distinctly over the subfield.

The bounded test is deliberately restricted to the twelve already-certified
q=64 repair blocks.  It does not reopen the quadratic coefficient census.
"""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path

from analyze_c210_exceptional_quadratic_locus import (
    line_key,
    repair_points,
)
from analyze_c210_residue_hypergraph import build_context


def main() -> None:
    context = build_context(1)
    field = context.ambient
    base = context.base_values

    source = json.loads(Path(__file__).with_name(
        "analyze_c210_exceptional_quadratic_locus_output.txt"
    ).read_text())

    def decode(row: list[int | None]) -> tuple[int, ...]:
        return tuple(
            0 if exponent is None else field.power(context.tau, exponent)
            for exponent in row
        )

    encoded_rows = source["legal_affine_rows_tau_exponents"]
    rows = [decode(row) for row in encoded_rows]
    assert len(rows) == 12

    add = field.add
    mul = field.mul
    square = lambda value: mul(value, value)

    def absolute_trace(value: int) -> int:
        result = 0
        conjugate = value
        for _ in range(3):
            result = add(result, conjugate)
            conjugate = square(conjugate)
        assert result in (0, 1)
        return result

    def cross_pair_sum_product(
        left: tuple[int, ...], right: tuple[int, ...], s: int
    ) -> tuple[int, int]:
        """Return the forced pair sum/product on ``left`` for ``right[s]``."""

        e, a, b, c0, c1 = left
        e_other, a_other, b_other, c0_other, c1_other = right
        delta = add(e_other, e)
        assert delta != 0
        norm = add(add(square(a), a), 1)
        assert norm != 0

        # For Y=s+delta*omega, put
        # T=g_right(s)+C_left+Y^2+B_left*Y = T0+T1*omega.
        t0 = add(
            add(add(c0_other, c0), square(s)),
            add(square(delta), mul(b, delta)),
        )
        t1 = add(
            add(
                add(
                    add(mul(a_other, square(s)), mul(add(b_other, b), s)),
                    c1_other,
                ),
                c1,
            ),
            add(square(delta), mul(b, delta)),
        )
        pair_sum = field.div(
            add(t1, mul(a, t0)), mul(delta, norm)
        )
        pair_product = add(
            t0, mul(pair_sum, add(s, mul(a, delta)))
        )
        return pair_sum, pair_product

    def formula_collision(
        left: tuple[int, ...], right: tuple[int, ...], s: int
    ) -> bool:
        pair_sum, pair_product = cross_pair_sum_product(left, right, s)
        if pair_sum == 0:
            return False
        normalized = field.div(pair_product, square(pair_sum))
        return absolute_trace(normalized) == 0

    ordered_profile: Counter[tuple[int, int, int]] = Counter()
    unordered_profile: Counter[tuple[int, int]] = Counter()
    cross_coset_pairs = 0
    direct_triples_checked = 0
    unequal_quadratic_orientations = 0

    for left_index, right_index in itertools.combinations(range(len(rows)), 2):
        left = rows[left_index]
        right = rows[right_index]
        if left[0] == right[0]:
            continue
        cross_coset_pairs += 1
        orientation_bad_counts = []

        for first, second in ((left, right), (right, left)):
            # The s^2 coefficient of p(s) is
            # (a_second+a_first)/(delta*(a_first^2+a_first+1)).
            # Every bounded certified pair lies off the only possible
            # Artin--Schreier exceptional locus a_second=a_first.
            assert first[1] != second[1]
            unequal_quadratic_orientations += 1
            first_points = dict(zip(base, repair_points(context, *first)))
            second_points = dict(zip(base, repair_points(context, *second)))
            zero_pair_sums = 0
            bad_parameters = 0

            for s in base:
                pair_sum, _pair_product = cross_pair_sum_product(
                    first, second, s
                )
                zero_pair_sums += int(pair_sum == 0)
                predicted = formula_collision(first, second, s)
                direct_pairs = []
                for r, u in itertools.combinations(base, 2):
                    direct_triples_checked += 1
                    if line_key(
                        context, first_points[r], first_points[u]
                    ) == line_key(
                        context, first_points[r], second_points[s]
                    ):
                        direct_pairs.append((r, u))
                assert len(direct_pairs) == int(predicted)
                if direct_pairs:
                    assert add(*direct_pairs[0]) == pair_sum
                    bad_parameters += 1

            trace_one_parameters = len(base) - zero_pair_sums - bad_parameters
            ordered_profile[
                (zero_pair_sums, bad_parameters, trace_one_parameters)
            ] += 1
            orientation_bad_counts.append(bad_parameters)

        unordered_profile[tuple(orientation_bad_counts)] += 1

    assert cross_coset_pairs == 48
    assert unequal_quadratic_orientations == 96
    assert unordered_profile == Counter({(2, 2): 24, (4, 4): 24})
    assert ordered_profile == Counter({(0, 2, 6): 48, (2, 4, 2): 48})

    print(json.dumps({
        "field": "GF(64)/GF(8)",
        "input": "the twelve certified legal affine-complete repair blocks",
        "two_coset_unordered_pairs": cross_coset_pairs,
        "cross_collision_reduction": {
            "left_graph":
                "eta=e*omega, g(r)=c0+omega*(a*r^2+b*r+c1)",
            "right_graph":
                "eta'=e'*omega, h(s)=c0'+omega*(a'*s^2+b'*s+c1')",
            "delta": "e'+e",
            "T": "h(s)+C+Y^2+B*Y=T0+T1*omega, Y=s+delta*omega",
            "pair_sum": "p=(T1+a*T0)/(delta*(a^2+a+1))",
            "pair_product": "q=T0+p*(s+a*delta)",
            "collision_criterion": "p!=0 and Tr(q/p^2)=0",
            "reason":
                "X^2+pX+q then has two distinct subfield roots, the two "
                "left repair parameters whose chord contains right[s]",
        },
        "ordered_orientation_profiles": {
            "(p_zero, trace_zero_collision, trace_one_safe)": {
                str(key): count for key, count in sorted(ordered_profile.items())
            },
        },
        "unordered_pair_collision_profiles": {
            str(key): count for key, count in sorted(unordered_profile.items())
        },
        "direct_cross_triples_checked": direct_triples_checked,
        "arc_legal_two_coset_pairs": 0,
        "artin_schreier_classification": {
            "p_coefficients":
                "P2=(a'+a)/(delta*N), P1=(b'+b)/(delta*N), "
                "N=a^2+a+1",
            "q_coefficients":
                "Q3=P2, Q2=1+P1+a*delta*P2, "
                "Q1=P0+a*delta*P1, Q0=T0(0)+a*delta*P0",
            "a_prime_not_equal_a":
                "P2!=0; q/p^2 tends to zero at infinity, so an "
                "Artin-Schreier-equivalent constant has trace zero; "
                "trace-zero collisions occur over every sufficiently "
                "large field",
            "a_prime_equal_a_b_prime_not_equal_b":
                "P2=0, P1!=0; equivalence to a constant requires "
                "T0(0)=a^2*delta^2, and that constant is "
                "P1^(-2)+P1^(-1)=z^2+z, again of trace zero",
            "a_prime_equal_a_b_prime_equal_b":
                "p=P0 is constant in both orientations; this is the only "
                "collision-avoidance locus, requiring either P0=0 or "
                "Tr((T0(0)+a*delta*P0)/P0^2)=1",
            "conclusion":
                "two full quadratic repair cosets can avoid all 2+1 "
                "cross-repair triples over infinitely many fields only "
                "when they share the same ordered coefficient pair (a,b)",
        },
        "certified_pair_orientations_with_a_prime_not_equal_a":
            unequal_quadratic_orientations,
        "next_gate":
            "test the shared-(a,b) exceptional locus against seed--cross-"
            "repair collisions and affine coverage; the twelve q=64 "
            "blocks provide no point on this locus",
        "status":
            "all q=64 pairs of certified repair blocks fail cross-coset "
            "arc legality; the infinite two-coset route is reduced to the "
            "shared-(a,b) Artin-Schreier exceptional locus",
    }, sort_keys=True))


if __name__ == "__main__":
    main()
