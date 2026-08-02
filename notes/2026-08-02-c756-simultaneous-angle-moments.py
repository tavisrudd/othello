#!/usr/bin/env python3
"""Bounded C756 probe for the simultaneous angle-coset moment identities."""

from __future__ import annotations

import argparse
from collections import Counter
from importlib.util import module_from_spec, spec_from_file_location
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "2026-08-01-c756-probability-cheap-tests.py"
AUDIT = HERE / "2026-08-01-c756-saturated-internal-audit.json"
OUTPUT = HERE / "2026-08-02-c756-simultaneous-angle-moments.json"
FIELDS = (5, 7, 11, 19, 23, 31, 43)

spec = spec_from_file_location("c756_probability", SOURCE)
source = module_from_spec(spec)
spec.loader.exec_module(source)


def angle(field, q, zi, zj):
    """f_j(z_i)^(1-q), using the positive exponent modulo q^2-1."""
    sub, mul, conj, fpow = (
        field["sub"], field["mul"], field["conj"], field["fpow"]
    )
    value = mul(sub(zi, zj), sub(zi, conj(zj)))
    return fpow(value, q * q - q)


def add_values(values, q):
    return tuple(sum(value[coordinate] for value in values) % q
                 for coordinate in (0, 1))


def row_diagnostics(candidate, field, q, index):
    fpow = field["fpow"]
    half = (q + 1) // 2
    angles = [angle(field, q, candidate[index], candidate[j])
              for j in range(len(candidate)) if j != index]
    assert len(angles) == half
    moments = {
        exponent: add_values([fpow(value, exponent) for value in angles], q)
        for exponent in range(1, half)
    }
    first_failure = next((exponent for exponent, value in moments.items()
                          if value != (0, 0)), None)
    full_odd_coset = (
        len(set(angles)) == half
        and all(fpow(value, half) == ((q - 1) % q, 0) for value in angles)
    )
    assert full_odd_coset == (first_failure is None)
    return {
        "first_moment": list(moments.get(1, (0, 0))),
        "first_failing_moment": first_failure,
        "full_odd_coset": full_odd_coset,
    }


def field_row(q, expected_candidates):
    candidates, field = source.saturated_candidates(q)
    assert len(candidates) == expected_candidates
    candidate_rows = []
    for candidate in candidates:
        rows = [row_diagnostics(candidate, field, q, index)
                for index in range(len(candidate))]
        candidate_rows.append({
            "all_rows_first_moment_zero": all(
                row["first_moment"] == [0, 0] for row in rows
            ),
            "all_rows_full_odd_coset": all(row["full_odd_coset"] for row in rows),
            "failing_first_moment_rows": sum(
                row["first_moment"] != [0, 0] for row in rows
            ),
            "minimum_failing_moment": min(
                (row["first_failing_moment"] for row in rows
                 if row["first_failing_moment"] is not None),
                default=None,
            ),
        })
    if q == 5:
        assert all(row["all_rows_full_odd_coset"] for row in candidate_rows)
    else:
        assert not any(row["all_rows_first_moment_zero"] for row in candidate_rows)
    return {
        "q": q,
        "candidate_count": len(candidates),
        "all_rows_first_moment_zero_candidates": sum(
            row["all_rows_first_moment_zero"] for row in candidate_rows
        ),
        "all_rows_full_odd_coset_candidates": sum(
            row["all_rows_full_odd_coset"] for row in candidate_rows
        ),
        "failing_first_moment_row_count_profile": dict(sorted(Counter(
            row["failing_first_moment_rows"] for row in candidate_rows
        ).items())),
        "minimum_failing_moment_profile": dict(sorted(Counter(
            row["minimum_failing_moment"] for row in candidate_rows
            if row["minimum_failing_moment"] is not None
        ).items())),
    }


def generate():
    expected = {
        row["q"]: row["candidates"]
        for row in json.loads(AUDIT.read_text())["rows"]
    }
    rows = [field_row(q, expected[q]) for q in FIELDS]
    return {
        "schema": "c756-simultaneous-angle-moments-v1",
        "scope": (
            "every normalized pairwise-character candidate in the audited prime "
            "fields q in {5,7,11,19,23,31,43}; every base-point row"
        ),
        "identity": (
            "a genuine saturated-internal arc has angle polynomial "
            "product_{j!=i}(X-alpha_ij)=X^((q+1)/2)+1 at every i"
        ),
        "inputs": [SOURCE.name, AUDIT.name],
        "rows": rows,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write and --check")
    rendered = json.dumps(generate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
    else:
        assert OUTPUT.read_text() == rendered
        print(f"verified {OUTPUT}")


if __name__ == "__main__":
    main()
