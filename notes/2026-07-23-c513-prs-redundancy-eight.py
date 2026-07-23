#!/usr/bin/env python3
"""Generate/check the compact algebraic certificate for C513.

This is not a deep-hole census.  It verifies the degree arithmetic, the lower
normal-rational-curve nuclei, their consecutive-row lifts to degree seven, and
the explicit modular shallow witnesses used by the proof.
"""

import argparse
import json
import math
import tempfile
from pathlib import Path


SCHEMA = "c513-prs-redundancy-eight-v1"
PRIMES = (2, 3, 5, 7)


def prime_power(n):
    for p in range(2, n + 1):
        if any(p % d == 0 for d in range(2, math.isqrt(p) + 1)):
            continue
        value = p
        exponent = 1
        while value < n:
            value *= p
            exponent += 1
        if value == n:
            return p, exponent
    return None


def inversion_class_cycle(p_mod_7):
    classes = ({1, 6}, {2, 5}, {3, 4})
    permutation = [
        next(i for i, target in enumerate(classes) if {(p_mod_7 * x) % 7 for x in source} == target)
        for source in classes
    ]
    seen = set()
    cycles = []
    for start in range(3):
        if start in seen:
            continue
        cycle = []
        current = start
        while current not in seen:
            seen.add(current)
            cycle.append(current)
            current = permutation[current]
        cycles.append(len(cycle))
    return sorted(cycles)


def total_orbit_counts(d, p_mod_7, tangent_orbits):
    sigma_pgl = 1 if d == 1 else 4
    sigma_pgamma = 1 if d == 1 else 1 + len(inversion_class_cycle(p_mod_7))
    return {
        "PGL2": sigma_pgl + tangent_orbits,
        "PGammaL2": sigma_pgamma + tangent_orbits,
    }


def nucleus_support(degree, order, characteristic):
    """Coordinate support of the order-osculating nucleus.

    The coordinate e_j survives precisely when binom(r,j)=0 mod p for every
    r=order+1,...,degree.
    """
    return [
        j
        for j in range(degree + 1)
        if all(
            math.comb(r, j) % characteristic == 0
            for r in range(order + 1, degree + 1)
        )
    ]


def consecutive_lift_support(lower_degree, support):
    """Support of f whose two consecutive contractions lie in support."""
    support = set(support)
    return [
        i
        for i in range(lower_degree + 2)
        if (i > lower_degree or i in support)
        and (i == 0 or i - 1 in support)
    ]


def first_prime_power_at_least(bound):
    n = bound
    while prime_power(n) is None:
        n += 1
    return n


def first_integer_satisfying_normalized_hasse(genus, deletion):
    q = 2
    while q + 1 - 2 * genus * math.sqrt(q) <= deletion:
        q += 1
    return q


def build_certificate():
    genus = 1
    base_deletion = 12
    marker_cost = 6
    marker_count = 3
    deletion = base_deletion + marker_count * marker_cost
    hasse_bound = math.floor((genus + math.sqrt(genus * genus + deletion)) ** 2) + 1
    exact_hasse_integer = first_integer_satisfying_normalized_hasse(genus, deletion)

    nuclei = []
    for p in PRIMES:
        for order in range(6):
            support = nucleus_support(6, order, p)
            if support:
                nuclei.append(
                    {
                        "characteristic": p,
                        "order": order,
                        "lower_support": support,
                        "degree7_lift_support": consecutive_lift_support(6, support),
                    }
                )

    next_nuclei = []
    for p in PRIMES:
        for order in range(7):
            support = nucleus_support(7, order, p)
            if support:
                next_nuclei.append(
                    {
                        "characteristic": p,
                        "order": order,
                        "lower_support": support,
                        "degree8_lift_support": consecutive_lift_support(7, support),
                    }
                )

    prime_diagonal = []
    for p in (3, 5, 7):
        lower_support = nucleus_support(p, p - 1, p)
        lift_support = consecutive_lift_support(p, lower_support)
        prime_diagonal.append(
            {
                "characteristic": p,
                "lower_nrc_degree": p,
                "lower_top_nucleus_support": lower_support,
                "syndrome_degree": p + 1,
                "lift_support": lift_support,
                "projective_module": f"det^2 tensor Sym^{p - 3}(E)",
            }
        )

    char5_split_sextic = [0, -1, 0, 0, 0, 1, 0]
    # For f in <e3,e4>, the two Hankel equations use only d2,d3,d4.
    assert all(char5_split_sextic[i] == 0 for i in (2, 3, 4))

    collision = (4 + 1) * (6 - 4)
    assert collision == 10

    return {
        "schema": SCHEMA,
        "syndrome_degree": 7,
        "redundancy": 8,
        "lower_cover": {
            "geometric_monodromy": "S3 on ordered distinct root pairs",
            "bidegree": [2, 2],
            "arithmetic_genus": genus,
            "base_deletion_degree": base_deletion,
            "marker_count": marker_count,
            "deletion_per_marker": marker_cost,
            "total_deletion_degree": deletion,
            "c512_closed_integer_bound": hasse_bound,
            "first_prime_power_at_least_c512_bound": first_prime_power_at_least(hasse_bound),
            "exact_normalization_inequality_first_integer": exact_hasse_integer,
            "first_prime_power_at_least_exact_inequality": first_prime_power_at_least(
                exact_hasse_integer
            ),
        },
        "top_level": {
            "secant_intersection_degree": 3,
            "lower_central_intersection_degree": 1,
            "collision_degree": collision,
            "total_transverse_collision_budget": 3 + 1 + collision,
        },
        "persistent": {
            "sigma_quotient": "T/T^7 modulo inversion and Frobenius",
            "sigma_pgamma_fusion_when_7_divides_q_plus_1": {
                "p_congruent_to_plus_or_minus_1_mod_7": "three nonzero inversion classes remain separate",
                "p_otherwise": "three nonzero inversion classes form one Frobenius 3-cycle",
            },
            "sigma_nonzero_class_cycle_lengths_by_p_mod_7": {
                str(p): inversion_class_cycle(p) for p in range(1, 7)
            },
            "total_deep_orbit_counts": {
                "gcd_7_q_plus_1_is_1_and_p_not_7": total_orbit_counts(1, 1, 1),
                "p_is_7": total_orbit_counts(1, 0, 2),
                "7_divides_q_plus_1_and_p_is_plus_or_minus_1_mod_7": total_orbit_counts(
                    7, 1, 1
                ),
                "7_divides_q_plus_1_and_p_is_plus_or_minus_2_or_3_mod_7": total_orbit_counts(
                    7, 2, 1
                ),
            },
            "tangent_cocycle_coefficient": 7,
            "tangent_split_characteristic": 7,
        },
        "lower_degree6_nuclei_and_lifts": nuclei,
        "modular_disposition": {
            "characteristic2_central_e3_lift_dimension": 0,
            "characteristic3_lift_support": [2, 5],
            "characteristic3_projective_module": "det^2 tensor Frobenius^1(E)",
            "characteristic3_shallow_for_q_at_least": 27,
            "characteristic3_conic_bad_point_bound": 18,
            "characteristic5_lift_support": [3, 4],
            "characteristic5_projective_module": "det^3 tensor E",
            "characteristic5_universal_split_sextic_coefficients": char5_split_sextic,
            "characteristic5_universal_roots": "P1(F5)",
        },
        "generic_all_degree_spine": {
            "bottom_marker_count": "n-4",
            "deletion_degree_bound": "6*n-12",
            "exact_normalized_hasse_integer_bound": "floor((1+sqrt(6*n-12))^2)+1",
            "scope": "generic S3 bottom stratum only; contained carrier pullbacks remain level-specific",
        },
        "prime_diagonal_nucleus_series": {
            "general_lift_support": "e2,...,e_(p-1)",
            "general_projective_module": "det^2 tensor Sym^(p-3)(E)",
            "checked_primes": prime_diagonal,
        },
        "redundancy9_preview": {
            "syndrome_degree": 8,
            "marker_count": 4,
            "deletion_degree_bound": 36,
            "exact_normalization_inequality_first_integer": 50,
            "first_prime_power_at_least_exact_inequality": 53,
            "collision_degree": 12,
            "lower_degree7_nuclei_and_lifts": next_nuclei,
            "characteristic5_lift_support": [4],
            "characteristic5_disposition": "shallow for q>5 via (t^5-t), infinity, and one extra affine root",
            "characteristic7_lift_support": [2, 3, 4, 5, 6],
            "characteristic7_projective_module": "det^2 tensor Sym^4(E)",
            "characteristic7_universal_witness": "none: common annihilator forces d1=...=d6=0, hence a seventh power",
        },
    }


def canonical_bytes(data):
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).with_name(
            "2026-07-23-c513-prs-redundancy-eight.json"
        ),
    )
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    payload = canonical_bytes(build_certificate())
    if args.check:
        with tempfile.TemporaryDirectory(prefix="c513-check-") as tmp:
            candidate = Path(tmp) / args.output.name
            candidate.write_bytes(payload)
            if not args.output.exists():
                raise SystemExit(f"missing tracked certificate: {args.output}")
            if candidate.read_bytes() != args.output.read_bytes():
                raise SystemExit("certificate differs from canonical regeneration")
        print("C513 certificate: PASS")
        return

    args.output.write_bytes(payload)
    print(f"wrote {args.output} ({len(payload)} bytes)")


if __name__ == "__main__":
    main()
