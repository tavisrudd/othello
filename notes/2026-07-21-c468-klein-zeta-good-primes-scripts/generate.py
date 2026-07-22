#!/usr/bin/env python3
"""Generate and check the canonical C468 good-prime zeta certificate."""

import argparse
import hashlib
import json
import math
import subprocess
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE.parent / "2026-07-21-c468-klein-zeta-good-primes.json"


def run_rust(source: str) -> str:
    with tempfile.TemporaryDirectory(prefix="c468-") as td:
        binary = Path(td) / source.removesuffix(".rs")
        subprocess.run(["rustc", "-O", str(HERE / source), "-o", str(binary)], check=True)
        return subprocess.run([str(binary)], check=True, text=True, capture_output=True).stdout


def mul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def quotient(monic, divisor):
    rem = monic[:]
    out = [0] * (len(monic) - len(divisor) + 1)
    for degree in range(len(monic) - 1, len(divisor) - 2, -1):
        coeff = rem[degree]
        shift = degree - len(divisor) + 1
        out[shift] = coeff
        for j, value in enumerate(divisor):
            rem[shift + j] -= coeff * value
    assert all(v == 0 for v in rem)
    return out


def elliptic_trace(p):
    # E_11: y^2+y=x^3-x^2-7x+10, j=-32768, Delta=-11^3.
    points = 1
    for x in range(p):
        disc = (1 + 4 * (x**3 - x**2 - 7 * x + 10)) % p
        points += 1 if disc == 0 else 2 if pow(disc, (p - 1) // 2, p) == 1 else 0
    return p + 1 - points


def certificate():
    low = run_rust("low_checks.rs")
    trace31 = run_rust("trace31k5.rs")
    required_low = {
        "p=31 smooth_base_singular=0 N1=30784 k2_T=-1 N2=888428164",
        "p=41 smooth_base_singular=0 N1=70644 k2_T=-1 N2=4752931684",
        "p=61 smooth_base_singular=0 N1=230764 k2_T=-1 N2=51534223924",
    }
    assert required_low <= set(low.splitlines())
    assert "p=31 strata_affine N5=783870 each_N4=26100 each_consecutive_N3=900 each_split_N3=0 each_adjacent_N2=0 each_nonadjacent_N2=900 each_N1=30" in low
    assert "curve q=28629151 log_minus4=8588745 contributing_d=2604834 T=38874 trace=-1112958245125" in trace31
    assert "gauss product_sum=31863049656378638875 trace=-1112958245125" in trace31

    records = []
    for p, fusion in [(31, "fused"), (41, "fused"), (61, "visible")]:
        a_e = elliptic_trace(p)
        assert a_e == {31: -5, 41: 0, 61: 0}[p]
        s0, s1 = 2, a_e
        powers = [s0, s1]
        for _ in range(2, 6):
            powers.append(a_e * powers[-1] - p * powers[-2])
        trace5 = 5 * p**5 * powers[5]
        if p == 31:
            assert trace5 == -1112958245125
        else:
            assert trace5 == 0
        traces = [0, 0, 0, 0, trace5]
        c5 = -trace5 // 5
        charpoly_asc = [p**15] + [0] * 4 + [c5] + [0] * 4 + [1]
        quadratic = [p**3, -p * a_e, 1]
        octic = quotient(charpoly_asc, quadratic)
        assert mul(quadratic, octic) == charpoly_asc
        counts = []
        for k, trace in enumerate(traces, 1):
            q = p**k
            base = 1 + q + q**2 + q**3
            counts.append({"k": k, "q": q, "trace_h3": trace, "points": base - trace})
        split_field = "Q(zeta_5, sqrt(-11))" if p == 31 else f"Q(zeta_5, sqrt(-{p}))"
        records.append({
            "p": p,
            "class_mod_40": p % 40,
            "c453_label": fusion,
            "smooth": True,
            "smoothness_certificate": "coordinate-zero chain plus det(circulant(2,1,0,0,0))=33 nonzero mod p",
            "counts": counts,
            "characteristic_polynomial_det_X_minus_F_coefficients_desc": list(reversed(charpoly_asc)),
            "zeta_numerator_det_1_minus_FT_coefficients_asc": charpoly_asc,
            "factorization_over_Q_coefficients_desc": [list(reversed(quadratic)), list(reversed(octic))],
            "c5_isotypic_factorization": {
                "quadratic_trivial_character": f"X^2-({p*a_e})*X+{p**3}",
                "octic_nontrivial_characters": f"Norm_Q(zeta_5)/Q(X^2-({p*a_e})*zeta_5*X+{p**3}*zeta_5^2)",
                "full_product": "product over j=0..4 of X^2-p*a_p*zeta_5^j*X+p^3*zeta_5^(2j)",
            },
            "splitting_field": split_field,
            "splitting_field_structure": {
                "galois_group": "C4 x C2",
                "golden_gauss_intersection": "Q",
                "quadratic_root_orbit_size": 2,
                "octic_root_orbit_size": 8,
                "octic_orbit_is_regular": True,
            },
            "contains": {
                "zeta_5": True,
                "sqrt_minus_11": p == 31,
                "sqrt_minus_p": p != 31,
                "sqrt_p_star": False,
            },
            "closed_under_multiplication_by_zeta_5": True,
            "all_extension_trace_recurrence": {
                "rule": "trace(F^k)=0 if 5 does not divide k; trace(F^(5m))=5*u_m",
                "initial_values": {"u_0": 2, "u_1": -c5},
                "recurrence": f"u_m={-c5}*u_(m-1)-{p**15}*u_(m-2)",
            },
            "frobenius_power_relation": f"F^10+{c5}*F^5+{p**15}*I=0",
            "quasi_scalarity": (
                f"F^10=-{p**15}*I"
                if c5 == 0
                else "F^5 has two Q(sqrt(-11))-conjugate eigenvalues, each with multiplicity 5"
            ),
            "newton_polygon": {
                "h3_slopes": ([1] * 5 + [2] * 5) if p == 31 else (["3/2"] * 10),
                "weight_one_tate_untwist_slopes": ([0] * 5 + [1] * 5) if p == 31 else (["1/2"] * 10),
                "type": "ordinary" if p == 31 else "supersingular",
                "weight_one_p_rank": 5 if p == 31 else 0,
                "a_number_determined": False,
            },
            "inert_extremal_tower": (
                None
                if p == 31
                else {
                    "trace_rule": f"trace(F^(10r))=10*(-{p**15})^r",
                    "weil_bound_saturated": True,
                    "point_count_side": "above P3 for odd r; below P3 for even r",
                }
            ),
            "elliptic_cm_cross_check": {
                "curve": "y^2+y=x^3-x^2-7x+10",
                "trace_at_p": a_e,
                "eigenvalues_description": "p times an elliptic Frobenius eigenvalue times zeta_5^j (j=0..4)",
            },
        })
    joint = {"fused_cm_split": 0, "fused_cm_inert": 0, "visible_cm_split": 0, "visible_cm_inert": 0}
    squares11 = {1, 3, 4, 5, 9}
    for residue in range(1, 440):
        if math.gcd(residue, 440) != 1 or residue % 5 not in {1, 4}:
            continue
        fusion = "fused" if residue % 8 in {1, 7} else "visible"
        cm = "cm_split" if residue % 11 in squares11 else "cm_inert"
        joint[f"{fusion}_{cm}"] += 1
    assert joint == {"fused_cm_split": 20, "fused_cm_inert": 20, "visible_cm_split": 20, "visible_cm_inert": 20}

    return {
        "schema": "othello.c468.klein_zeta_good_primes.v1",
        "equation": "x0^2*x1+x1^2*x2+x2^2*x3+x3^2*x4+x4^2*x0",
        "primes": records,
        "delsarte": {
            "character_order": 11,
            "quintic_character_claim": False,
            "reason": "the exponent-lattice determinant is 33; projectivity kills its 3-torsion, leaving order-11 tuples",
            "p31_k5_exact_gauss_product_sum": 31863049656378638875,
            "p31_k5_trace_from_gauss_products": -1112958245125,
            "p31_direct_strata_affine": {"N5": 783870, "each_N4": 26100, "each_consecutive_N3": 900, "each_split_N3": 0, "each_adjacent_N2": 0, "each_nonadjacent_N2": 900, "each_N1": 30},
        },
        "headline": {
            "golden_and_gauss_fields_meet": True,
            "sharp_instance": "at p=31 the splitting field is Q(zeta_5,sqrt(-11)), and the exact order-11 Gauss-product calculation gives the nonzero fifth trace",
            "fusion_verdict": "blind: p=41 (fused) and p=61 (visible) have the same inert shape, while the two fused primes p=31 and p=41 differ",
        },
        "joint_mod_440_classifier": {
            "domain": "the 80 reduced residue classes modulo 440 with (5/p)=+1",
            "fusion_character": "(2/p): +1=fused, -1=visible",
            "cm_character": "(p/11): +1=split/ordinary candidate, -1=inert/supersingular candidate",
            "cell_counts": joint,
            "conditional_density_each_cell": "1/4",
            "geometric_common_carrier_proved": False,
        },
    }


def canonical_bytes(value):
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    data = canonical_bytes(certificate())
    if args.check:
        tracked = OUT.read_bytes()
        assert tracked == data, f"stale certificate: expected sha256 {hashlib.sha256(data).hexdigest()}"
        print(f"ok {OUT.name} {len(data)} bytes sha256={hashlib.sha256(data).hexdigest()}")
    else:
        OUT.write_bytes(data)
        print(f"wrote {OUT} {len(data)} bytes sha256={hashlib.sha256(data).hexdigest()}")


if __name__ == "__main__":
    main()
