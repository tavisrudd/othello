#!/usr/bin/env python3
"""Exact parameter checks for the C945 higher-arc defect bound."""

from __future__ import annotations

import argparse
import hashlib
import json
from functools import lru_cache
from math import comb
from pathlib import Path


ROOT = Path(__file__).resolve().parent
OUTPUT = ROOT / "2026-08-22-c945-higher-arc-defect.json"
CHECKSUMS = ROOT / "2026-08-22-c945-higher-arc-defect.sha256"
Q_VALUES = (4, 5, 7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 31, 32, 49, 64, 81, 125, 128, 243, 256)
LAMBDA_VALUES = (1, 2, 3)


def first_moment_minimum(q: int, s: int, lam: int = 1) -> int:
    """Smallest k not excluded by the Alabdullah--Hirschfeld inequality."""
    for k in range(s + 1, (s - 1) * q + s + 1):
        lhs = lam * (q * q + q + 1 - k) * s * (s - 1)
        rhs = k * (k - 1) * (q + 1 - s)
        if lhs <= rhs:
            return k
    raise AssertionError((q, s))


def convex_degree_maximum(k: int, degree_cap: int, degree_sum: int) -> int:
    full, remainder = divmod(degree_sum, degree_cap)
    if full > k or (full == k and remainder):
        raise ValueError("infeasible degree sum")
    return full * comb(degree_cap, 2) + comb(remainder, 2)


def capacity_numerator(q: int, k: int, s: int, lam: int, t: int) -> tuple[int, int]:
    matching_cap = k // s
    degree_cap = (k - 1) // (s - 1)
    degree_sum = s * t
    max_internal_pairs = convex_degree_maximum(k, degree_cap, degree_sum)
    second_moment_lower = max(0, comb(t, 2) - max_internal_pairs)
    numerator = (matching_cap + lam - 1) * t * (q + 1 - s) - 2 * second_moment_lower
    denominator = lam * matching_cap
    return numerator, denominator


def second_moment_minimum(q: int, s: int, lam: int = 1) -> int | None:
    """Smallest k not excluded by the exact one-variable degree envelope."""
    start = first_moment_minimum(q, s, lam)
    for k in range(start, (s - 1) * q + s + 1):
        matching_cap = k // s
        if matching_cap < lam:
            continue
        degree_cap = (k - 1) // (s - 1)
        t_max = min(k * (k - 1) // (s * (s - 1)), k * degree_cap // s)
        feasible_t = (t_max,) if s == 2 else range(1, t_max + 1)
        max_num = None
        common_den = lam * matching_cap
        for t in feasible_t:
            numerator, denominator = capacity_numerator(q, k, s, lam, t)
            assert denominator == common_den
            if max_num is None or numerator > max_num:
                max_num = numerator
        required = q * q + q + 1 - k
        if max_num is not None and common_den * required <= max_num:
            return k
    return None


def spectral_minimum(q: int, s: int, lam: int = 1) -> int | None:
    """Complementary threshold from Bishnoi--Mattheus--Schillewaert, Theorem 8.1."""
    point_count = q * q + q + 1
    blocking_order = q + 1 - s
    for k in range(s + 1, (s - 1) * q + s + 1):
        blocking_size = point_count - k
        quadratic = (
            lam * blocking_size * blocking_size
            - (2 * lam * blocking_order * (q + 1) - (lam + blocking_order) * q)
            * blocking_size
            - blocking_order * (q - lam * blocking_order) * point_count
        )
        if quadratic <= 0:
            return k
    return None


@lru_cache(maxsize=None)
def dp_degree_maximum(vertices: int, cap: int, total: int) -> int | None:
    """Independent small dynamic program for the convex-envelope check."""
    if vertices == 0:
        return 0 if total == 0 else None
    best = None
    for degree in range(min(cap, total) + 1):
        tail = dp_degree_maximum(vertices - 1, cap, total - degree)
        if tail is not None:
            value = comb(degree, 2) + tail
            best = value if best is None else max(best, value)
    return best


def run_checks() -> dict[str, object]:
    checked_envelopes = 0
    for k in range(3, 21):
        for s in range(2, min(6, k)):
            cap = (k - 1) // (s - 1)
            max_total = k * cap
            for total in range(max_total + 1):
                direct = dp_degree_maximum(k, cap, total)
                formula = convex_degree_maximum(k, cap, total)
                assert direct == formula, (k, s, total, direct, formula)
                checked_envelopes += 1

    checked_arc_specializations = 0
    for k in range(4, 41):
        t = comb(k, 2)
        cap = k - 1
        lower = comb(t, 2) - convex_degree_maximum(k, cap, 2 * t)
        assert lower == 3 * comb(k, 4), (k, lower, 3 * comb(k, 4))
        checked_arc_specializations += 1

    rows = []
    for q in Q_VALUES:
        for s in range(2, min(8, q) + 1):
            for lam in LAMBDA_VALUES:
                first = first_moment_minimum(q, s, lam)
                second = second_moment_minimum(q, s, lam)
                spectral = spectral_minimum(q, s, lam)
                assert second is None or second >= first
                assert spectral is None or spectral >= s + 1
                hybrid = None if second is None or spectral is None else max(second, spectral)
                rows.append(
                    {
                        "q": q,
                        "s": s,
                        "lambda": lam,
                        "first_moment_minimum": first,
                        "second_moment_minimum": second,
                        "spectral_minimum": spectral,
                        "hybrid_minimum": hybrid,
                        "improvement": None if second is None else second - first,
                        "excluded_through_universal_arc_maximum": second is None,
                    }
                )

    return {
        "schema": "c945-higher-arc-defect-v3",
        "meaning": "Necessary-bound thresholds only; projective-plane or arc existence is not asserted.",
        "parameters": {"lambda_values": list(LAMBDA_VALUES), "holes": 0, "q_values": list(Q_VALUES), "s_max": 8},
        "independent_checks": {
            "convex_envelope_instances": checked_envelopes,
            "ordinary_arc_specializations": checked_arc_specializations,
        },
        "rows": rows,
    }


def canonical_bytes(payload: dict[str, object]) -> bytes:
    return (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()


def checksum_line(path: Path, data: bytes) -> str:
    return f"{hashlib.sha256(data).hexdigest()}  {path.name}\n"


def generate() -> None:
    payload_bytes = canonical_bytes(run_checks())
    OUTPUT.write_bytes(payload_bytes)
    script_bytes = Path(__file__).read_bytes()
    CHECKSUMS.write_text(
        checksum_line(Path(__file__), script_bytes) + checksum_line(OUTPUT, payload_bytes),
        encoding="utf-8",
    )


def check() -> None:
    expected = canonical_bytes(run_checks())
    if OUTPUT.read_bytes() != expected:
        raise SystemExit("generated JSON is stale")
    expected_manifest = checksum_line(Path(__file__), Path(__file__).read_bytes()) + checksum_line(OUTPUT, expected)
    if CHECKSUMS.read_text(encoding="utf-8") != expected_manifest:
        raise SystemExit("checksum manifest is stale")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=("generate", "check"))
    args = parser.parse_args()
    if args.mode == "generate":
        generate()
    else:
        check()


if __name__ == "__main__":
    main()
