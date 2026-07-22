#!/usr/bin/env python3
"""Generate/check the bounded C453 continuation-law prediction certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "notes/2026-07-21-c453-continuation-laws.json"
INPUTS = [
    "notes/2026-07-21-c440-conventions-freeze.md",
    "notes/2026-07-21-c440-conventions-freeze.json",
    "notes/2026-07-21-c440-conventions-freeze.sha256",
    "notes/2026-07-21-c442-antipodal-singleton-reduction.md",
    "notes/2026-07-21-c442-antipodal-singleton-reduction.json",
    "notes/2026-07-21-c442-antipodal-singleton-reduction.sha256",
    "notes/2026-07-21-c442-m2-fable-review.md",
    "notes/2026-07-20-c395-clebsch-ame-pencil-arithmetic.md",
    "notes/2026-07-20-c395-clebsch-ame-pencil-arithmetic.json",
    "notes/2026-07-20-c395-clebsch-ame-pencil-arithmetic.sha256",
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def legendre(a: int, p: int) -> int:
    v = pow(a % p, (p - 1) // 2, p)
    return -1 if v == p - 1 else v


def factor(n: int) -> dict[str, int]:
    ans: dict[str, int] = {}
    d = 2
    while d * d <= n:
        while n % d == 0:
            ans[str(d)] = ans.get(str(d), 0) + 1
            n //= d
        d += 1
    if n > 1:
        ans[str(n)] = ans.get(str(n), 0) + 1
    return ans


def phi_roots(p: int) -> list[int]:
    return [x for x in range(p) if (x * x - x - 1) % p == 0]


def psl_order(p: int) -> int:
    return p * (p * p - 1) // 2


def natural_fixed_points(p: int, order: int) -> int:
    """Fixed points on P^1(F_p) for a nonidentity PSL2 element of given order.

    The calls below are only for semisimple orders prime to p.  Such an element is
    split (two fixed eigenlines) when its order divides (p-1)/2, and nonsplit
    (no F_p eigenline) when it divides (p+1)/2.
    """
    split = ((p - 1) // 2) % order == 0
    nonsplit = ((p + 1) // 2) % order == 0
    assert split != nonsplit
    return 2 if split else 0


# Exact Q(sqrt(5)) arithmetic, represented by a + b*sqrt(5).
Q5 = tuple[Fraction, Fraction]


def q5add(x: Q5, y: Q5) -> Q5:
    return (x[0] + y[0], x[1] + y[1])


def q5mul(x: Q5, y: Q5) -> Q5:
    return (x[0] * y[0] + 5 * x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def q5scale(n: int, x: Q5) -> Q5:
    return (n * x[0], n * x[1])


def a5_character_multiplicities(values: list[int]) -> dict[str, int]:
    """Decompose an A5 character on classes 1A,2A,3A,5A,5B."""
    z: Q5 = (Fraction(0), Fraction(0))
    one: Q5 = (Fraction(1), Fraction(0))
    phi: Q5 = (Fraction(1, 2), Fraction(1, 2))
    phibar: Q5 = (Fraction(1, 2), Fraction(-1, 2))
    chars: dict[str, list[Q5]] = {
        "1": [one, one, one, one, one],
        "3": [q5scale(3, one), q5scale(-1, one), z, phi, phibar],
        "3prime": [q5scale(3, one), q5scale(-1, one), z, phibar, phi],
        "4": [q5scale(4, one), z, one, q5scale(-1, one), q5scale(-1, one)],
        "5": [q5scale(5, one), one, q5scale(-1, one), z, z],
    }
    sizes = [1, 15, 20, 12, 12]
    answer: dict[str, int] = {}
    for name, row in chars.items():
        total = z
        for size, value, char_value in zip(sizes, values, row, strict=True):
            total = q5add(total, q5scale(size * value, char_value))
        total = (total[0] / 60, total[1] / 60)
        assert total[1] == 0 and total[0].denominator == 1
        answer[name] = int(total[0])
    return answer


def prime_row(p: int) -> dict[str, object]:
    roots = phi_roots(p)
    split = len(roots) == 2
    assert split == (legendre(5, p) == 1)
    two = legendre(2, p)
    if not split:
        sheet = "no two F_p golden reductions (golden field inert)"
    elif two == -1:
        sheet = "two golden reductions are PSL2(p)-distinct"
    else:
        sheet = "two golden reductions are fused by an element of PSL2(p)"
    return {
        "p": p,
        "p_mod_5": p % 5,
        "p_mod_8": p % 8,
        "legendre_5_over_p": legendre(5, p),
        "golden_field_behavior": "split" if split else "inert",
        "phi_roots_mod_p": roots,
        "Z_phi_prime_factors": (
            [f"({p}, phi-{root})" for root in roots]
            if split
            else [f"({p}) remains prime in Z[phi]"]
        ),
        "legendre_2_over_p": two,
        "conditional_H3_sheet_prediction": sheet,
        "PSL2_order": psl_order(p),
        "PSL2_order_factorization": factor(psl_order(p)),
        "A5_order_divides_PSL2_order": psl_order(p) % 60 == 0,
    }


def build() -> dict[str, object]:
    rows = {str(p): prime_row(p) for p in (13, 19, 31)}
    assert rows["13"]["phi_roots_mod_p"] == []
    assert rows["19"]["phi_roots_mod_p"] == [5, 15]
    assert rows["31"]["phi_roots_mod_p"] == [13, 19]
    assert [rows[str(p)]["legendre_2_over_p"] for p in (13, 19, 31)] == [-1, -1, 1]

    chars: dict[str, object] = {}
    for p in (19, 31):
        values = [p + 1] + [natural_fixed_points(p, n) for n in (2, 3, 5, 5)]
        chars[str(p)] = {
            "A5_classes": ["1A", "2A", "3A", "5A", "5B"],
            "class_sizes": [1, 15, 20, 12, 12],
            "P1_restricted_permutation_character": values,
            "number_of_A5_orbits_by_Burnside": sum(
                s * v for s, v in zip([1, 15, 20, 12, 12], values, strict=True)
            ) // 60,
            "complex_irrep_multiplicities": a5_character_multiplicities(values),
        }

    # Since the involution class fixes no point, every point stabilizer has odd
    # order.  The odd subgroup orders of A5 are 1, 3, and 5, hence possible
    # orbit sizes are 60, 20, and 12.  Burnside's orbit count then forces these
    # decompositions uniquely.
    def forced_orbits(degree: int, count: int) -> list[int]:
        candidates = [12, 20, 60]
        solutions: list[list[int]] = []

        def rec(prefix: list[int], start: int) -> None:
            if len(prefix) == count:
                if sum(prefix) == degree:
                    solutions.append(prefix)
                return
            for i in range(start, len(candidates)):
                rec(prefix + [candidates[i]], i)

        rec([], 0)
        assert len(solutions) == 1
        return solutions[0]

    chars["19"]["forced_orbit_sizes"] = forced_orbits(20, 1)
    chars["19"]["point_stabilizer_order"] = 3
    chars["31"]["forced_orbit_sizes"] = forced_orbits(32, 2)
    chars["31"]["point_stabilizer_orders"] = [5, 3]

    h4_orders = {
        "full_reflection_group_W_H4": 14400,
        "orientation_preserving_group_Wplus_H4": 7200,
        "projective_orientation_group_Wplus_mod_central_inversion": 3600,
        "oriented_vertex_marker_stabilizer_H3plus_is_A5": 60,
        "oriented_vertex_orbit_size": 120,
        "projective_vertex_axis_orbit_size": 60,
        "PSL2_31": psl_order(31),
    }
    h4_div = {
        name: psl_order(31) % order == 0
        for name, order in h4_orders.items()
        if name not in {"PSL2_31", "oriented_vertex_orbit_size", "projective_vertex_axis_orbit_size"}
    }
    assert h4_div == {
        "full_reflection_group_W_H4": False,
        "orientation_preserving_group_Wplus_H4": False,
        "projective_orientation_group_Wplus_mod_central_inversion": False,
        "oriented_vertex_marker_stabilizer_H3plus_is_A5": True,
    }

    input_hashes = {
        rel: {"bytes": (ROOT / rel).stat().st_size, "sha256": sha256(ROOT / rel)}
        for rel in INPUTS
    }
    return {
        "schema": "c453-continuation-laws-v1",
        "task": "C453 / T6",
        "status": "conditional predictions only; no construction, existence, or continuation claim",
        "inputs": input_hashes,
        "law": {
            "golden_split_condition": "(5/p)=+1, equivalently p congruent to +/-1 mod 5",
            "sheet_visibility_given_split": (
                "for the frozen rational transporter Rz of spinor norm 2, the two golden "
                "A5 reductions are PSL2(p)-distinct iff (2/p)=-1"
            ),
            "important_scope": (
                "the (2/p) clause is evaluated only after a quadratic sheet field, two reductions, "
                "and a transporter squareclass have been supplied"
            ),
        },
        "prime_predictions": rows,
        "parent_and_spin_field_requirements": {
            "13": {
                "h_equals_p_minus_1": 12,
                "exceptional_parents_with_h_12": ["F4", "E6"],
                "warning": "h=12 does not determine a parent; classical and dihedral types also occur",
                "standard_root_datum_field": "Q for F4 and E6",
                "required_before_any_sheet_prediction": [
                    "choose and exhibit the parent and marker action",
                    "supply a nontrivial quadratic spin/label field K_13 if two sheets are intended",
                    "supply the transporter spinor squareclass delta_13",
                    "prove K_13 splits at 13 and the marker subgroup embeds in PSL2(13)",
                ],
                "golden_H3_specialization": "blocked: Q(sqrt(5)) is inert and 60 does not divide |PSL2(13)|",
            },
            "19": {
                "h_equals_p_minus_1": 18,
                "exceptional_parent_with_h_18": "E7",
                "warning": "h=18 does not determine a parent; classical and dihedral types also occur",
                "standard_root_datum_field": "Q for E7",
                "required_before_a_non_golden_sheet_prediction": [
                    "exhibit the parent and marker action",
                    "supply the quadratic spin/label field K_19",
                    "supply the transporter spinor squareclass delta_19",
                ],
                "conditional_golden_H3_marker": (
                    "K=Q(sqrt(5)) and delta=2 give two PSL-distinct A5 sheets; "
                    "each A5 is transitive on P1(F_19) with point stabilizer C3"
                ),
            },
            "31": {
                "h_equals_p_minus_1": 30,
                "exceptional_parents_with_h_30": ["H4", "E8"],
                "warning": "h=30 does not determine a parent; classical and dihedral types also occur",
                "H4_field_and_transporter": "K=Q(sqrt(5)), delta=2",
                "E8_boundary": "the rational E8 root datum does not itself supply the H4 golden sheet law",
                "conditional_H4_marker": "the canonical oriented vertex-marker stabilizer is H3+=A5",
            },
        },
        "A5_natural_action_character_arithmetic": chars,
        "H4_marker_bound_in_PSL2_31": {
            "orders": h4_orders,
            "order_divisibility_into_PSL2_31": h4_div,
            "gcds_with_PSL2_31": {
                name: math.gcd(order, psl_order(31))
                for name, order in h4_orders.items()
                if name != "PSL2_31"
            },
            "literal_bound": (
                "PSL2(31) cannot contain the full, oriented, or projective-oriented H4 group.  "
                "It can contain the canonical local H4 vertex-marker stabilizer A5.  In the natural "
                "32-point action that A5 has forced orbits 12+20, not an H4 60-axis orbit."
            ),
            "sheet_consequence": (
                "because (2/31)=+1, the two golden-conjugate A5 marker sheets are PSL-fused; "
                "no H3 sheet bit remains available to label an H4 marker"
            ),
        },
        "boundary": [
            "No H4, E8, E7, E6, or F4 object is constructed.",
            "No subgroup of PSL2(p) beyond the frozen golden A5 reductions is constructed.",
            "No law is inferred from q=h+1 alone.",
            "The table predicts only splitting and sheet visibility after its stated parent, field, marker, and transporter hypotheses.",
        ],
        "trusted_boundary": [
            "Python integer and Fraction arithmetic",
            "quadratic reciprocity via Euler's criterion",
            "the exact A5 character table encoded in this checker",
            "standard semisimple split/nonsplit torus fixed-point criterion for PSL2(p) on P1(F_p)",
            "frozen C440/C442 spin-field and transporter conventions",
            "C395's certified characteristic-31 A5 enhancement as an overlapping control only",
        ],
        "independent_cross_checks": [
            "phi roots are enumerated directly and agree with Euler's-criterion splitting symbols",
            "A5 orbit counts are recovered independently from Burnside averages and stabilizer orders",
            "all H4 exclusions are checked by exact order divisibility and gcd arithmetic",
        ],
    }


def canonical_bytes(obj: object) -> bytes:
    return (json.dumps(obj, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(build())
    if args.write:
        OUT.write_bytes(generated)
        print(f"wrote {OUT.relative_to(ROOT)} ({len(generated)} bytes)")
        return
    tracked = OUT.read_bytes()
    if tracked != generated:
        raise SystemExit("certificate differs from deterministic regeneration")
    print("PASS C453 deterministic certificate")


if __name__ == "__main__":
    main()
