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
WIDE_DEGREE_Q_VALUES = (7, 8, 9, 11, 13, 16, 17, 19, 23, 25, 27, 31, 32)
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


def convex_degree_minimum(vertices: int, degree_sum: int) -> int:
    """Minimum pair count for a fixed nonnegative integer degree sum."""
    quotient, remainder = divmod(degree_sum, vertices)
    return (vertices - remainder) * comb(quotient, 2) + remainder * comb(quotient + 1, 2)


def bounded_degree_maximum(vertices: int, lower: int, upper: int, degree_sum: int) -> int:
    """Maximum pair count with a common lower and upper degree bound."""
    excess = degree_sum - vertices * lower
    capacity = upper - lower
    if excess < 0 or excess > vertices * capacity:
        raise ValueError("infeasible bounded degree sum")
    if capacity == 0:
        return vertices * comb(lower, 2)
    return (
        vertices * comb(lower, 2)
        + lower * excess
        + convex_degree_maximum(vertices, capacity, excess)
    )


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


def paired_moment_minimum(q: int, s: int, lam: int = 1, spectral: bool = False) -> int | None:
    """Threshold from overlapping the internal and external pair-count intervals."""
    point_count = q * q + q + 1
    blocking_order = q + 1 - s
    start = first_moment_minimum(q, s, lam)
    for k in range(start, (s - 1) * q + s + 1):
        matching_cap = k // s
        if matching_cap < lam:
            continue
        external_points = point_count - k
        degree_cap = (k - 1) // (s - 1)
        t_max = min(k * (k - 1) // (s * (s - 1)), k * degree_cap // s)
        feasible_t = (t_max,) if s == 2 else range(1, t_max + 1)
        for t in feasible_t:
            external_degree_sum = blocking_order * t
            if not lam * external_points <= external_degree_sum <= matching_cap * external_points:
                continue

            internal_minimum = convex_degree_minimum(k, s * t)
            internal_maximum = convex_degree_maximum(k, degree_cap, s * t)
            pair_total = comb(t, 2)
            internal_external_minimum = pair_total - internal_maximum
            internal_external_maximum = pair_total - internal_minimum

            external_minimum = convex_degree_minimum(external_points, external_degree_sum)
            external_maximum = bounded_degree_maximum(
                external_points, lam, matching_cap, external_degree_sum
            )
            if max(internal_external_minimum, external_minimum) > min(
                internal_external_maximum, external_maximum
            ):
                continue

            if spectral:
                gap = point_count * blocking_order - (q + 1) * external_points
                if t * gap * gap > q * external_points * k * (point_count - t):
                    continue
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


@lru_cache(maxsize=None)
def dp_degree_minimum(vertices: int, cap: int, total: int) -> int | None:
    """Independent small dynamic program for the balanced-minimum check."""
    if vertices == 0:
        return 0 if total == 0 else None
    best = None
    for degree in range(min(cap, total) + 1):
        tail = dp_degree_minimum(vertices - 1, cap, total - degree)
        if tail is not None:
            value = comb(degree, 2) + tail
            best = value if best is None else min(best, value)
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

    checked_bounded_envelopes = 0
    for vertices in range(1, 9):
        for lower in range(4):
            for upper in range(lower, 6):
                for total in range(vertices * lower, vertices * upper + 1):
                    shifted = dp_degree_maximum(vertices, upper - lower, total - vertices * lower)
                    assert shifted is not None
                    direct_maximum = vertices * comb(lower, 2) + lower * (
                        total - vertices * lower
                    ) + shifted
                    formula_maximum = bounded_degree_maximum(vertices, lower, upper, total)
                    assert direct_maximum == formula_maximum
                    direct_minimum = dp_degree_minimum(vertices, upper, total)
                    formula_minimum = convex_degree_minimum(vertices, total)
                    assert direct_minimum == formula_minimum
                    checked_bounded_envelopes += 1

    checked_arc_specializations = 0
    for k in range(4, 41):
        t = comb(k, 2)
        cap = k - 1
        lower = comb(t, 2) - convex_degree_maximum(k, cap, 2 * t)
        assert lower == 3 * comb(k, 4), (k, lower, 3 * comb(k, 4))
        checked_arc_specializations += 1

    checked_spectral_equivalences = 0
    for q in range(3, 17):
        point_count = q * q + q + 1
        for s in range(2, q + 1):
            blocking_order = q + 1 - s
            for lam in LAMBDA_VALUES:
                for k in range(s + 1, (s - 1) * q + s + 1):
                    blocking_size = point_count - k
                    cleared_cauchy = (
                        lam * blocking_size * s * s
                        + lam * k * blocking_order * blocking_order
                        - lam * k * blocking_size
                        - q * blocking_order * k
                    )
                    bms_quadratic = (
                        lam * blocking_size * blocking_size
                        - (
                            2 * lam * blocking_order * (q + 1)
                            - (lam + blocking_order) * q
                        )
                        * blocking_size
                        - blocking_order
                        * (q - lam * blocking_order)
                        * point_count
                    )
                    assert cleared_cauchy == bms_quadratic
                    checked_spectral_equivalences += 1

    checked_infinite_family_instances = 0
    for q in range(16, 97, 8):
        s = q // 2 + 1
        spectral = spectral_minimum(q, s, 2)
        paired = paired_moment_minimum(q, s, 2)
        assert spectral == s * s
        assert paired == s * s + q // 8 - 1
        checked_infinite_family_instances += 1

    checked_ordinary_resonance_instances = 0
    for n in range(3, 33):
        q = 3 * n
        s = 2 * n + 1
        spectral = spectral_minimum(q, s, 1)
        paired = paired_moment_minimum(q, s, 1)
        spectral_formula = 3 * n * n + 3 * n + 1
        paired_formula = spectral_formula + (3 * n - 2) // 5
        assert spectral == spectral_formula
        assert paired == paired_formula
        checked_ordinary_resonance_instances += 1

    checked_conjugate_resonance_instances = 0
    for m in range(2, 65):
        q = 8 * m
        s = 6 * m + 1
        spectral_offset = (52 * m + 9) // 5
        spectral_polynomial = lambda ell: (
            ell * ell
            - (40 * m * m + 20 * m + 2) * ell
            + 416 * m**3
            + 132 * m * m
            + 20 * m
            + 1
        )
        assert spectral_polynomial(spectral_offset - 1) > 0
        assert spectral_polynomial(spectral_offset) <= 0

        paired_bound = 32 * m * m + 12 * m - 1
        excluded_k = paired_bound - 1
        point_count = q * q + q + 1
        complement_size = point_count - excluded_k
        blocking_order = q + 1 - s
        t_min = (2 * complement_size + blocking_order - 1) // blocking_order
        obstruction = (
            convex_degree_minimum(excluded_k, s * t_min)
            + convex_degree_minimum(complement_size, blocking_order * t_min)
            - comb(t_min, 2)
        )
        assert obstruction > 0
        checked_conjugate_resonance_instances += 1

    rows = []
    for q in Q_VALUES:
        for s in range(2, min(8, q) + 1):
            for lam in LAMBDA_VALUES:
                first = first_moment_minimum(q, s, lam)
                second = second_moment_minimum(q, s, lam)
                spectral = spectral_minimum(q, s, lam)
                paired = paired_moment_minimum(q, s, lam)
                paired_spectral = paired_moment_minimum(q, s, lam, spectral=True)
                assert second is None or second >= first
                assert spectral is None or spectral >= s + 1
                hybrid = None if second is None or spectral is None else max(second, spectral)
                assert paired is None or hybrid is None or paired >= hybrid
                assert paired_spectral == paired
                rows.append(
                    {
                        "q": q,
                        "s": s,
                        "lambda": lam,
                        "first_moment_minimum": first,
                        "second_moment_minimum": second,
                        "spectral_minimum": spectral,
                        "hybrid_minimum": hybrid,
                        "paired_moment_minimum": paired,
                        "paired_spectral_minimum": paired_spectral,
                        "improvement": None if second is None else second - first,
                        "excluded_through_universal_arc_maximum": second is None,
                    }
                )

    wide_degree_rows = []
    for q in WIDE_DEGREE_Q_VALUES:
        for s in range(2, q + 1):
            for lam in LAMBDA_VALUES:
                second = second_moment_minimum(q, s, lam)
                spectral = spectral_minimum(q, s, lam)
                hybrid = None if second is None or spectral is None else max(second, spectral)
                paired = paired_moment_minimum(q, s, lam)
                wide_degree_rows.append(
                    {
                        "q": q,
                        "s": s,
                        "lambda": lam,
                        "hybrid_minimum": hybrid,
                        "paired_moment_minimum": paired,
                        "gain_over_hybrid": None
                        if paired is None or hybrid is None
                        else paired - hybrid,
                        "degree_regime": "below_sqrt_q"
                        if s * s < q
                        else ("intermediate" if 2 * s < q else "at_least_half_q"),
                    }
                )

    return {
        "schema": "c945-higher-arc-defect-v7",
        "meaning": "Necessary-bound thresholds only; projective-plane or arc existence is not asserted.",
        "parameters": {"lambda_values": list(LAMBDA_VALUES), "holes": 0, "q_values": list(Q_VALUES), "s_max": 8},
        "independent_checks": {
            "convex_envelope_instances": checked_envelopes,
            "bounded_convex_envelope_instances": checked_bounded_envelopes,
            "ordinary_arc_specializations": checked_arc_specializations,
            "spectral_quadratic_equivalences": checked_spectral_equivalences,
            "infinite_family_formula_instances": checked_infinite_family_instances,
            "ordinary_resonance_formula_instances": checked_ordinary_resonance_instances,
            "conjugate_resonance_bound_instances": checked_conjugate_resonance_instances,
        },
        "rows": rows,
        "wide_degree_rows": wide_degree_rows,
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
