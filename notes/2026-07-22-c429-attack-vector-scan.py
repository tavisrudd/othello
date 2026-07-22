#!/usr/bin/env python3
"""Exact C429 carrier/phase certificate (standard library only)."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-07-22-c429-attack-vector-scan.json"
UPSTREAM = {
    "c377": ROOT / "2026-07-19-c377-clebsch-golden-descent.json",
    "c430": ROOT / "2026-07-20-c430-conceptual-balanced-half-rigidity.json",
    "c459": ROOT / "2026-07-21-c459-golden-six-arc-q-forms.json",
    "c486": ROOT / "2026-07-22-c486-close-upgrade-battery.json",
    "c487": ROOT / "2026-07-22-c487-char-zero-realization-row.json",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class Quad:
    """Element a+b*t of F_p[t]/(t^2-t-1)."""

    __slots__ = ("a", "b", "p")

    def __init__(self, a: int, b: int, p: int):
        self.a, self.b, self.p = a % p, b % p, p

    def __add__(self, other: Quad) -> Quad:
        assert self.p == other.p
        return Quad(self.a + other.a, self.b + other.b, self.p)

    def __neg__(self) -> Quad:
        return Quad(-self.a, -self.b, self.p)

    def __sub__(self, other: Quad) -> Quad:
        return self + (-other)

    def __mul__(self, other: Quad) -> Quad:
        assert self.p == other.p
        return Quad(
            self.a * other.a + self.b * other.b,
            self.a * other.b + self.b * other.a + self.b * other.b,
            self.p,
        )

    def __pow__(self, exponent: int) -> Quad:
        result, base = Quad(1, 0, self.p), self
        while exponent:
            if exponent & 1:
                result = result * base
            base = base * base
            exponent //= 2
        return result

    def sigma(self) -> Quad:
        return Quad(self.a + self.b, -self.b, self.p)

    def pair(self) -> list[int]:
        return [self.a, self.b]

    def __eq__(self, other: object) -> bool:
        return isinstance(other, Quad) and (self.a, self.b, self.p) == (other.a, other.b, other.p)


def points(t: Quad) -> list[list[Quad]]:
    z, o = Quad(0, 0, t.p), Quad(1, 0, t.p)
    return [
        [z, o, o - t],
        [z, o, t - o],
        [o, o - t, z],
        [o, t - o, z],
        [o, z, -t],
        [o, z, t],
    ]


PI = [1, 0, 4, 5, 2, 3]


def j(vector: list[Quad]) -> list[Quad]:
    return [vector[0], -vector[2], -vector[1]]


def scale(scalar: Quad, vector: list[Quad]) -> list[Quad]:
    return [scalar * entry for entry in vector]


def column_identity(p: int) -> bool:
    t = Quad(0, 1, p)
    ps, conjugate = points(t), points(t.sigma())
    one = Quad(1, 0, p)
    lambdas = [t - one, one - t, one, one, one, one]
    return all(j(ps[i]) == scale(lambdas[i], conjugate[PI[i]]) for i in range(6))


def roots(p: int) -> list[int]:
    return [x for x in range(p) if (x * x - x - 1) % p == 0]


def rank2_mod(matrix: list[list[int]], p: int) -> int:
    if all(value % p == 0 for row in matrix for value in row):
        return 0
    determinant = matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    return 2 if determinant % p else 1


def validate_upstream(data: dict[str, dict]) -> None:
    c377, c430, c459, c486, c487 = (data[key] for key in UPSTREAM)
    assert c377["symbolic_intertwiner"]["label_permutation"] == PI
    assert c377["symbolic_intertwiner"]["cocycle_square"] == "identity"
    assert c377["chirality"]["three_subset_orbit_sizes"] == [10, 10]
    assert c377["chirality"]["descent_exchanges_orbits"] is True
    assert c377["code_and_scheme"]["monomial_code_equivalence"] is True
    assert c377["ring"]["bad_characteristic_excluded"] == 2
    assert c430["summary"]["h3_trade_line_is_the_outer_odd_c412_socle_line"] is True
    assert "descended_conic_gram" in c459["representative"]
    assert c486["L2"]["verdict"] == "ONE TORSOR CLASS, THREE CERTIFICATES"
    assert c487["outer_swap"]["sigma_corresponds_to_outer_coset"] is True


def certificate() -> dict:
    upstream_data = {key: json.loads(path.read_text()) for key, path in UPSTREAM.items()}
    validate_upstream(upstream_data)

    ledger = upstream_data["c377"]["pluecker"]["ledger"]
    product = (1, 0)
    half_norms = []
    for entry in ledger:
        a, b = entry["source_minor"]
        assert a % 2 == 0 and b % 2 == 0
        half = (a // 2, b // 2)
        half_norms.append(half[0] * half[0] + half[0] * half[1] - half[1] * half[1])
        product = (
            product[0] * a + product[1] * b,
            product[0] * b + product[1] * a + product[1] * b,
        )
    assert set(half_norms) == {-1, 1}
    assert product == (-93323264, 57671680) == (-89 * 2**20, 55 * 2**20)
    product_norm = product[0] ** 2 + product[0] * product[1] - product[1] ** 2
    assert product_norm == 2**40

    multiplication_delta = [[-1, 2], [2, 1]]
    trace_pairing = [[2, 1], [1, 3]]
    assert math.gcd(*(abs(x) for row in multiplication_delta for x in row)) == 1
    assert abs(multiplication_delta[0][0] * multiplication_delta[1][1]
               - multiplication_delta[0][1] * multiplication_delta[1][0]) == 5
    assert abs(trace_pairing[0][0] * trace_pairing[1][1]
               - trace_pairing[0][1] * trace_pairing[1][0]) == 5

    split_roots = roots(19)
    assert split_roots == [5, 15]
    assert sorted((1 - x) % 19 for x in split_roots) == split_roots

    t13 = Quad(0, 1, 13)
    assert roots(13) == []
    assert t13**13 == t13.sigma()
    assert (t13**13)**13 == t13

    t5, delta5 = Quad(0, 1, 5), Quad(-1, 2, 5)
    assert delta5 != Quad(0, 0, 5)
    assert delta5 * delta5 == Quad(0, 0, 5)
    assert rank2_mod(multiplication_delta, 5) == 1

    for p in (5, 13, 19):
        assert column_identity(p)

    # In characteristic two the six columns collapse pairwise, explaining the realization prime.
    p2 = points(Quad(0, 1, 2))
    assert p2[0] == p2[1] and p2[2] == p2[3] and p2[4] == p2[5]

    return {
        "schema": "c429-outer-phase-v1",
        "carrier": {
            "ring": "Z[tau]/(tau^2-tau-1)",
            "involution": "sigma(tau)=1-tau",
            "odd_generator": "delta=2tau-1",
            "different_generator": "f'(tau)=2tau-1=delta",
            "different_ideal": ["delta"],
            "odd_lattice": "R^{sigma=-1}=Z*delta",
            "delta_square": 5,
        },
        "orientation_line": {
            "determinant_line": "det_Z(R)=Z*(1 wedge tau)",
            "orientation_quotient": "R/Z = Z*[tau]",
            "quotient_to_determinant": "[x] |-> 1 wedge x (integral isomorphism)",
            "difference_to_odd": "[x] |-> x-sigma(x); [tau] |-> delta (integral isomorphism)",
            "determinant_to_odd": "1 wedge tau |-> delta (integral isomorphism)",
            "discriminant_quadratic_form": "q(1 wedge tau)=delta^2=5",
            "noninverse_wedge_map": "delta |-> 1 wedge delta = 2*(1 wedge tau)",
            "noninverse_wedge_map_smith_invariants": [2],
            "prime_2_mechanism": "the determinant line stays flat, but its sign action becomes trivial and cannot distinguish orientations",
            "prime_5_mechanism": "odd line specializes to the cotangent/conormal line of the ramified point",
        },
        "smith_fitting": {
            "multiplication_by_delta_basis_1_tau": multiplication_delta,
            "smith_invariants": [1, 5],
            "trace_pairing_basis_1_tau": trace_pairing,
            "trace_pairing_smith_invariants": [1, 5],
            "fitting_ideal_cokernel_m_delta": [5],
            "carrier_bad_prime": [5],
            "realization_excluded_prime": [2],
            "carrier_at_2": "F_4 (unramified/inert); delta=1",
            "base_for_six_arc_family": "Spec Z[1/2]",
        },
        "phase_pilots": {
            "split_p19": {
                "roots": split_roots,
                "sigma_swaps_roots": True,
                "column_identity": True,
                "phase": "two F_19 sheets",
            },
            "inert_p13": {
                "roots": [],
                "frobenius_tau": t13.sigma().pair(),
                "frobenius_equals_sigma": True,
                "J_after_frobenius_is_involutive": True,
                "column_identity": True,
                "phase": "one connected F_169 point with Frobenius-semilinear swap",
            },
            "ramified_p5": {
                "root_support": 3,
                "delta_mod_5": delta5.pair(),
                "delta_is_nonzero_nilpotent": True,
                "multiplication_rank": 1,
                "image_equals_kernel_equals_nilradical": True,
                "nilradical_equals_cotangent_line": True,
                "column_identity": True,
                "phase": "nonreduced length-two fibre; swap internalizes",
            },
        },
        "common_datum": {
            "representation_exchange": "C377 exact J/sigma column square",
            "arc_chirality_exchange": "the same odd pi swaps the certified 10+10 orbits",
            "code_exchange": "the same J, pi and unit column scalars give monomial equivalence",
            "scheme_exchange": "sigma is the structural swap of C459/C487 Spec Q(sqrt5)",
            "normalization_verdict": "compatible: the first three legs use the identical J/pi/lambda datum; the fourth is sigma",
            "categorical_caveat": "compatibility is a common C2-action/naturality square, not a literal isomorphism of all realization objects with the rank-one odd lattice",
        },
        "recovery_hierarchy": {
            "faithful_readouts": {
                "A5_character_pair": "the unordered 5-cycle values have polynomial X^2-X-1 and discriminant 5",
                "S3_resolvent": "Spec Z[tau]/(tau^2-tau-1) retains the quadratic algebra itself",
            },
            "sign_shadow_readouts": {
                "arc_chirality": "a bare two-sheet C2 torsor",
                "code_obstruction": "a bare monomial-equivalence C2 obstruction",
            },
            "fixed_good_fibre_limit": "a one-dimensional quadratic form over F_p remembers only the Legendre square class",
            "q11_isometry": "<5> is isometric to <1> via x |-> 4x because 4^2=5 mod 11",
            "global_recovery_gate": "retain the character algebra or resolvent, or retain the all-prime Frobenius law together with ramification support",
            "c434_boundary": "the finite q=11 rung can preserve sign/square class, not the global integral discriminant form",
        },
        "code_determinantal_content": {
            "checked_maximal_minors": len(ledger),
            "each_minor": "2 times a unit of norm +/-1",
            "pluecker_content_ideal": [2],
            "product_pair_a_plus_b_tau": list(product),
            "product_formula": "-2^20*tau^(-10)",
            "product_norm": product_norm,
            "product_norm_formula": "2^40",
            "code_rank_bad_prime": [2],
            "orientation_discriminant_bad_prime": [5],
            "conclusion": "maximal-minor content detects the realization prime 2 and is blind to the carrier prime 5",
        },
        "upstream": {
            key: {"file": path.name, "sha256": sha256(path)} for key, path in UPSTREAM.items()
        },
        "verdict": "S1 survives in corrected common-action form; exact bad sets are carrier {5}, six-arc realization {2}",
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
    elif args.check:
        assert OUTPUT.read_text() == rendered, f"stale certificate: {OUTPUT}"
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
