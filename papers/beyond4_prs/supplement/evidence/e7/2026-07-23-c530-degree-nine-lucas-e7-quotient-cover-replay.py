#!/usr/bin/env python3
"""Independent structural replay for the C530 certificate."""

from __future__ import annotations

import json
from itertools import product
from math import comb
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-23-c530-degree-nine-lucas-e7-quotient-cover"


def action_terms(j: int) -> list[tuple[int, int, int, int]]:
    out = []
    for rx, sy in product(range(3), repeat=2):
        if rx + sy != 2 or rx > 9 - j or sy > j:
            continue
        if comb(9 - j, rx) % 2 and comb(j, sy) % 2:
            out.append((rx, 9 - j - rx, sy, j - sy))
    return out


def polynomial_times_linear(coeffs: list[int], root: int, mul) -> list[int]:
    out = [0] * (len(coeffs) + 1)
    for i, value in enumerate(coeffs):
        out[i] ^= mul(value, root)
        out[i + 1] ^= value
    return out


def replay_witness(row: dict[str, object]) -> None:
    m = int(row["m"])
    q = 1 << m
    modulus = int(str(row["modulus_hex"]), 16)
    numerator = (q - 1) * (q - 2) * (q - 4)
    assert numerator % 168 == 0
    three_spaces = numerator // 168
    assert row["three_space_count"] == three_spaces
    assert row["additive_affine_witness_count"] == (q // 8) * three_spaces
    expected_f8 = q * (q - 1) // 56 if m % 3 == 0 else 0
    assert row["F8_affine_witness_count"] == expected_f8

    def reduce_poly(f: int) -> int:
        while f.bit_length() - 1 >= m:
            f ^= modulus << (f.bit_length() - 1 - m)
        return f

    def mul(a: int, b: int) -> int:
        raw = 0
        for i in range(m):
            if (b >> i) & 1:
                raw ^= a << i
        return reduce_poly(raw)

    roots = [int(str(x), 16) for x in row["roots_hex"]]
    coeffs = [1]
    for root in roots:
        coeffs = polynomial_times_linear(coeffs, root, mul)
    expected = [int(str(x), 16) for x in row["coefficients_low_to_high_hex"]]
    assert coeffs == expected
    assert coeffs[6:8] == [0, 0]
    for root in roots:
        value = 0
        for i in range(9):
            term = coeffs[i] if i == 0 else mul(
                coeffs[i], pow_in_field(root, i, mul)
            )
            value ^= term
        assert value == 0


def pow_in_field(a: int, n: int, mul) -> int:
    out = 1
    while n:
        if n & 1:
            out = mul(out, a)
        a = mul(a, a)
        n >>= 1
    return out


def main() -> None:
    data = json.loads((HERE / f"{STEM}.json").read_text())
    support = {
        j: action_terms(j)
        for j in range(10)
        if action_terms(j)
    }
    assert sorted(support) == [2, 3, 6, 7]
    expected = data["e7_action"]["nonzero_target_coordinates"]
    assert {
        str(j): [
            {"a": a, "b": b, "c": c, "d": d}
            for a, b, c, d in terms
        ]
        for j, terms in support.items()
    } == expected

    # Direct rank count, independent of the generator's column-span test.
    gl3 = 0
    for entries in product(range(2), repeat=9):
        a, b, c, d, e, f, g, h, i = entries
        det = (
            a * e * i
            + a * f * h
            + b * d * i
            + b * f * g
            + c * d * h
            + c * e * g
        ) % 2
        gl3 += det
    assert gl3 == data["ordering_groups"]["GL3_F2"] == 168
    assert 8 * gl3 == data["ordering_groups"]["AGL3_F2"] == 1344

    for row in data["bounded_subspace_controls"]:
        replay_witness(row)
    print(f"OK {STEM}: {len(data['bounded_subspace_controls'])} field controls")


if __name__ == "__main__":
    main()
