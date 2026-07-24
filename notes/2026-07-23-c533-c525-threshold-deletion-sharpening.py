#!/usr/bin/env python3
"""Generate the compact C533 exact-algebra certificate."""

from __future__ import annotations

import argparse
import json
from pathlib import Path


def add(*polys: int) -> int:
    out = 0
    for poly in polys:
        out ^= poly
    return out


def mul(left: int, right: int) -> int:
    out = 0
    while right:
        if right & 1:
            out ^= left
        left <<= 1
        right >>= 1
    return out


def degree(poly: int) -> int:
    return poly.bit_length() - 1


def plucker_pencil(a: int, b: int, c: int) -> list[int]:
    """Pluecker coordinates of <A+rB,B+rC> over F_2[r]."""
    av = [((a >> i) & 1) ^ (((b >> i) & 1) << 1) for i in range(4)]
    bv = [((b >> i) & 1) ^ (((c >> i) & 1) << 1) for i in range(4)]
    return [
        add(mul(av[i], bv[j]), mul(av[j], bv[i]))
        for i in range(4)
        for j in range(i + 1, 4)
    ]


def sigma_quadrics(z: list[int]) -> list[int]:
    z0, z1, z2, z3, z4, z5 = z
    return [
        add(mul(z0, z2), mul(z0, z3), mul(z1, z1)),
        add(mul(z0, z4), mul(z1, z2)),
        add(mul(z1, z4), mul(z2, z2), mul(z2, z3)),
        add(mul(z0, z5), mul(z2, z2)),
        add(mul(z1, z5), mul(z2, z4)),
        add(mul(z2, z5), mul(z3, z5), mul(z4, z4)),
    ]


def n_linears(z: list[int]) -> list[int]:
    return [z[0], z[5], add(z[2], z[3])]


def first_sharp_witness() -> dict[str, object]:
    for a in range(1, 16):
        for b in range(1, 16):
            for c in range(1, 16):
                if len({a, b, c}) < 3:
                    continue
                z = plucker_pencil(a, b, c)
                fs = sigma_quadrics(z)
                gs = n_linears(z)
                for fi, f in enumerate(fs):
                    for gi, g in enumerate(gs):
                        if degree(f) == 4 and degree(g) == 2 and degree(mul(f, g)) == 6:
                            return {
                                "A_bits": f"{a:04b}",
                                "B_bits": f"{b:04b}",
                                "C_bits": f"{c:04b}",
                                "sigma_generator": f"q{fi}",
                                "n_generator": f"g{gi}",
                                "degrees": [4, 2, 6],
                            }
    raise AssertionError("no sharp separate-degree witness")


def hasse_ok(q: int, deletion: int) -> bool:
    margin = q + 1 - deletion
    return margin > 0 and margin * margin > 4 * q


def first_binary_q(base: int, deletion: int) -> int:
    q = 2
    while q < base or not hasse_ok(q, deletion):
        q *= 2
    return q


def threshold_row(n: int) -> dict[str, int]:
    m = n - 4
    before_base = min(m * (m + 15) // 2 + 1, 9 * m)
    after_base = min(m * (m + 11) // 2 + 1, 7 * m)
    before_deletion = 3 * n - 4
    after_deletion = 3 * n - 6
    return {
        "n": n,
        "before_base": before_base,
        "after_base": after_base,
        "before_deletion": before_deletion,
        "after_deletion": after_deletion,
        "before_first_binary_q": first_binary_q(before_base, before_deletion),
        "after_first_binary_q": first_binary_q(after_base, after_deletion),
    }


def certificate() -> dict[str, object]:
    # On N=[0:s^2:st:st:t^2:0], q_i restrict respectively to
    # s^4,s^3t,s^2t^2,s^2t^2,st^3,t^4.
    restrictions = ["s^4", "s^3*t", "s^2*t^2", "s^2*t^2", "s*t^3", "t^4"]
    return {
        "schema": "c533-threshold-deletion-v1",
        "field": "characteristic two",
        "union_covariant": {
            "sigma_generators": [
                "z0*z2+z0*z3+z1^2",
                "z0*z4+z1*z2",
                "z1*z4+z2^2+z2*z3",
                "z0*z5+z2^2",
                "z1*z5+z2*z4",
                "z2*z5+z3*z5+z4^2",
            ],
            "N_linear_generators_on_Grassmannian": ["z0", "z5", "z2+z3"],
            "sigma_restrictions_to_N": restrictions,
            "quadratic_kernel": ["q2+q3"],
            "quadratic_kernel_identity": "z0*z5+z1*z4+z2*z3 (Pluecker)",
            "minimum_nontrivial_common_degree_in_plucker_coordinates": 3,
            "root_separate_degrees": {
                "plucker": 2,
                "sigma_quadric": 4,
                "N_linear": 2,
                "union_product": 6,
            },
            "sharp_degree_witness": first_sharp_witness(),
        },
        "deletion": {
            "before": "3*n-4",
            "after": "3*n-6",
            "overlap": "after sending one fixed root to [0:1], D=0 is that fixed-root incidence divisor",
            "remaining_degrees": {
                "moving_fixed_diagonal": "n-4",
                "inseparability_Ns": 2,
                "residual_fixed_union_including_D": "2*(n-4)",
                "residual_moving": 4,
            },
        },
        "threshold": {
            "before": "min((n-4)*(n+11)/2+1,9*(n-4))",
            "after": "min((n-4)*(n+7)/2+1,7*(n-4))",
            "representative_table": [
                threshold_row(n) for n in [5, 6, 7, 8, 9, 10, 12, 16, 20, 24, 32]
            ],
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit(f"certificate mismatch: {args.output}")
    else:
        args.output.write_text(encoded)


if __name__ == "__main__":
    main()
