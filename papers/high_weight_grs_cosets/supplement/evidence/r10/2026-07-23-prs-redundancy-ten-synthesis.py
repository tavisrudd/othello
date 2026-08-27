#!/usr/bin/env python3
"""Generate the compact arithmetic certificate for R10."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path


STEM = Path(__file__).with_suffix("")
OUTPUT = STEM.with_suffix(".json")


def is_prime(n: int) -> bool:
    if n < 2:
        return False
    for d in range(2, math.isqrt(n) + 1):
        if n % d == 0:
            return False
    return True


def is_prime_power(n: int) -> bool:
    for p in range(2, n + 1):
        if not is_prime(p):
            continue
        x = p
        while x < n:
            x *= p
        if x == n:
            return True
    return False


def inversion_orbits(d: int, multiplier: int | None = None) -> list[list[int]]:
    unseen = set(range(d))
    answer: list[list[int]] = []
    while unseen:
        seed = min(unseen)
        orbit = {seed}
        frontier = [seed]
        while frontier:
            x = frontier.pop()
            images = {-x % d}
            if multiplier is not None:
                images.add(multiplier * x % d)
            for y in images:
                if y not in orbit:
                    orbit.add(y)
                    frontier.append(y)
        unseen -= orbit
        answer.append(sorted(orbit))
    return answer


def first_prime_power(delta: int, start: int = 2) -> int:
    for q in range(start, 10000):
        if is_prime_power(q) and q + 1 - 2 * math.sqrt(q) > delta:
            return q
    raise AssertionError("search bound too small")


def build() -> dict[str, object]:
    generic_deletion = 12 + 5 * 6
    generic_transverse = 3 + 2
    collision = 2 * 9 - 4
    char2_base = min((9 - 4) * (9 + 11) // 2 + 1, 9 * (9 - 4))
    char2_deletion = 3 * 9 - 4

    orbit_rows = [
        {"case": "p=3", "d": 1, "pgl": 3, "pgamma": 3},
        {"case": "p!=2,3; d=1", "d": 1, "pgl": 2, "pgamma": 2},
        {"case": "p!=2,3; d=3", "d": 3, "pgl": 3, "pgamma": 3},
        {"case": "p!=2,3; d=9; p mod 9 = 8", "d": 9, "pgl": 6, "pgamma": 6},
        {"case": "p!=2,3; d=9; p mod 9 in {2,5}", "d": 9, "pgl": 6, "pgamma": 4},
        {"case": "p=2; m even", "d": 1, "pgl": 2, "pgamma": 2},
        {"case": "p=2; m mod 6 in {1,5}", "d": 3, "pgl": 3, "pgamma": 3},
        {"case": "p=2; m mod 6 = 3", "d": 9, "pgl": 6, "pgamma": 4},
    ]

    assert generic_deletion == 42
    assert generic_transverse + collision == 19
    assert first_prime_power(generic_deletion) == 59
    assert char2_base == 45
    assert char2_deletion == 23
    assert min(2**m for m in range(1, 20) if 2**m >= char2_base
               and 2**m + 1 - 2 * math.sqrt(2**m) > char2_deletion) == 64
    assert [len(inversion_orbits(d)) for d in (1, 3, 9)] == [1, 2, 5]
    assert len(inversion_orbits(9, 8)) == 5
    assert len(inversion_orbits(9, 2)) == 3
    assert len(inversion_orbits(9, 5)) == 3

    return {
        "schema": "r10-redundancy-ten-synthesis-v1",
        "syndrome_degree": 9,
        "kernel_member_degree": 8,
        "generic_spine": {
            "genus_bound": 1,
            "base_deletion": 12,
            "marker_count": 5,
            "deletion_per_marker": 6,
            "deletion_total": generic_deletion,
            "persistent_transverse_degree": 3,
            "modular_transverse_degree_bound": 2,
            "transverse_total_bound": generic_transverse,
            "collision_degree": collision,
            "transverse_plus_collision": generic_transverse + collision,
            "first_prime_power": first_prime_power(generic_deletion),
        },
        "characteristic_two_slice": {
            "base_selection_threshold": char2_base,
            "deletion_degrees": {
                "moving_fixed_diagonal": 5,
                "residual_determinant": 2,
                "inseparability_branch": 2,
                "residual_through_fixed_root": 10,
                "residual_through_moving_root": 4,
            },
            "deletion_total": char2_deletion,
            "first_power_of_two": 64,
        },
        "persistent": {
            "cardinality": "q*(q+1)^2/2",
            "sigma_cardinality": "q*(q^2-1)/2",
            "tangent_cardinality": "q*(q+1)",
            "sigma_law": "C_gcd(9,q+1) modulo inversion and multiplication by p",
            "tangent_law": "z -> z + 9*u",
            "orbit_rows": orbit_rows,
        },
        "characteristic_two_residue_bound": {
            "rank_two_U_points": "q*(q^2-1)",
            "outside_U_points": "q^4*(q+1)",
            "candidate_upper_bound": "q*(q^2-1)+q^4*(q+1)",
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--output", type=Path, default=OUTPUT)
    args = parser.parse_args()
    rendered = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if args.check:
        if args.output.read_text() != rendered:
            raise SystemExit(f"certificate mismatch: {args.output}")
    else:
        args.output.write_text(rendered)


if __name__ == "__main__":
    main()
