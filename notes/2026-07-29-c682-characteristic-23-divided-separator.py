#!/usr/bin/env python3
"""Exact local-order certificate for the C682 prime-23 divided separator."""

from __future__ import annotations

import argparse
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-29-c682-characteristic-23-divided-separator.json"

A = 54781
B = 24288
D = 820125
GOLDEN_RADICAND = 5
COLLISION_PRIMES = (11, 23)


def factor(n: int) -> dict[str, int]:
    result: dict[str, int] = {}
    divisor = 2
    while divisor * divisor <= n:
        while n % divisor == 0:
            key = str(divisor)
            result[key] = result.get(key, 0) + 1
            n //= divisor
        divisor += 1
    if n > 1:
        result[str(n)] = result.get(str(n), 0) + 1
    return result


def legendre(a: int, p: int) -> int:
    value = pow(a % p, (p - 1) // 2, p)
    return -1 if value == p - 1 else value


def fp2_mul(
    left: tuple[int, int], right: tuple[int, int], p: int
) -> tuple[int, int]:
    a, b = left
    c, d = right
    return ((a * c + GOLDEN_RADICAND * b * d) % p, (a * d + b * c) % p)


def fp2_pow(value: tuple[int, int], exponent: int, p: int) -> tuple[int, int]:
    result = (1, 0)
    while exponent:
        if exponent & 1:
            result = fp2_mul(result, value, p)
        value = fp2_mul(value, value, p)
        exponent //= 2
    return result


def prime_record(p: int) -> dict[str, object]:
    assert B % p == 0 and B % (p * p) != 0
    assert math.gcd(D, p) == 1
    unit = B // p
    collision_value = A * pow(D, -1, p) % p
    divided_coefficient = unit % p
    divided_square = GOLDEN_RADICAND * divided_coefficient**2 % p
    divided_norm = -divided_square % p
    root_character = legendre(GOLDEN_RADICAND, p)

    record: dict[str, object] = {
        "prime": p,
        "golden_character": root_character,
        "golden_fibre": "split" if root_character == 1 else "inert",
        "cross_gram_collision_value": collision_value,
        "v_p_cross_gram_odd_coefficient": 1,
        "normalization_index_exponent": 1,
        "conductor": f"{p} O_{p}",
        "scalar_image_special_fibre": f"F_{p}[epsilon]/(epsilon^2)",
        "divided_trace_zero_coefficient": divided_coefficient,
        "divided_trace_zero_square": divided_square,
        "divided_trace_zero_norm": divided_norm,
    }
    if root_character == -1:
        eta = (0, divided_coefficient)
        record.update(
            {
                "normalized_special_fibre": f"F_{p**2}",
                "divided_minimal_polynomial": (
                    f"T^2 + {(-divided_square) % p}"
                ),
                "frobenius_on_divided_separator": list(fp2_pow(eta, p, p)),
                "negative_divided_separator": [0, (-divided_coefficient) % p],
            }
        )
    else:
        roots = [x for x in range(p) if x * x % p == GOLDEN_RADICAND]
        record.update(
            {
                "normalized_special_fibre": f"F_{p} x F_{p}",
                "golden_roots": roots,
                "divided_values_on_sheets": sorted(
                    divided_coefficient * root % p for root in roots
                ),
            }
        )
    return record


def certificate() -> dict[str, object]:
    assert math.gcd(A, B) == 1
    assert factor(B) == {"2": 5, "3": 1, "11": 1, "23": 1}
    assert factor(D) == {"3": 8, "5": 3}

    records = [prime_record(p) for p in COLLISION_PRIMES]
    p23 = records[1]
    assert p23["cross_gram_collision_value"] == 21
    assert p23["golden_character"] == -1
    assert p23["divided_trace_zero_coefficient"] == 21
    assert p23["divided_trace_zero_square"] == 20
    assert p23["divided_trace_zero_norm"] == 3
    assert p23["frobenius_on_divided_separator"] == [0, 2]
    assert p23["negative_divided_separator"] == [0, 2]

    return {
        "schema": "c682-characteristic-23-divided-separator-v1",
        "cross_gram": {
            "lambda": "(A +/- B sqrt(5))/D",
            "A": A,
            "B": B,
            "D": D,
            "factor_B": factor(B),
            "factor_D": factor(D),
        },
        "global_scalar_image_order": {
            "base": "R = Z[1/30]",
            "normalization": "O = R[s]/(s^2-5)",
            "scalar_image": "R[chi] = R + 253 R s",
            "index_ideal": "(253) = (11*23)",
            "conductor": "253 O",
            "normalization_quotient": "O/R[chi] = R/(253) as an R-module",
        },
        "local_order_theorem": {
            "normalization": "O_p = Z_p[s]/(s^2-5)",
            "scalar_image_order": "B_p = Z_p + p Z_p s",
            "index": "p",
            "conductor": "p O_p",
            "normalization_quotient": "O_p/B_p = F_p",
            "special_fibre_map": (
                "F_p[epsilon]/(epsilon^2) -> O_p/pO_p sends epsilon to 0"
            ),
            "divided_separator": "eta_p=(D chi-A)/p=(B/p)s",
        },
        "collision_primes": records,
        "characteristic_23_conclusion": [
            "The normalized golden cover is the inert etale algebra F_529.",
            "The coarse cross-Gram image is the nonreduced doubled point F_23[epsilon]/(epsilon^2).",
            "The divided separator eta_23=-2 sqrt(5) has eta_23^2=-3, trace 0, norm 3, and Frobenius eta_23^23=-eta_23.",
            "Adjoining eta_23 normalizes the scalar-image order and recovers the full golden cover.",
            "There is no F_23-rational choice of incidence sheet; the two complementary sheets appear over F_529 and Frobenius exchanges them.",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    rendered = json.dumps(certificate(), indent=2, sort_keys=True) + "\n"
    if arguments.check:
        assert CERTIFICATE.read_text(encoding="utf-8") == rendered
        print("PASS: C682 characteristic-23 divided-separator certificate")
    else:
        CERTIFICATE.write_text(rendered, encoding="utf-8")
        print(f"WROTE: {CERTIFICATE}")


if __name__ == "__main__":
    main()
