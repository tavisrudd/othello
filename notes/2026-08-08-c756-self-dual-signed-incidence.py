#!/usr/bin/env sage-python
"""Exact Sage checks for self-duality and Smith data of C756 signed incidence."""

from __future__ import annotations

import argparse
import collections
import importlib.util
import json
from pathlib import Path

from sage.all import ZZ, identity_matrix, matrix


SOURCE = Path(__file__).with_name("2026-08-08-c756-signed-elliptic-fusion.py")
OUTPUT = Path(__file__).with_suffix(".json")


def load_source():
    spec = importlib.util.spec_from_file_location("c756_signed_fusion", SOURCE)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def switched_matrix(z_rows: list[list[int]], delta: int):
    size = len(z_rows)
    switches = [0] * size
    for root in range(size):
        if switches[root]:
            continue
        switches[root] = 1
        stack = [root]
        while stack:
            i = stack.pop()
            for j, value in enumerate(z_rows[i]):
                if value == 0:
                    continue
                required = delta * switches[i] * value * z_rows[j][i]
                if switches[j] == 0:
                    switches[j] = required
                    stack.append(j)
                elif switches[j] != required:
                    raise AssertionError("self-dual switching is inconsistent")
    return matrix(
        ZZ,
        size,
        size,
        lambda i, j: switches[i] * z_rows[i][j],
    )


def certify(q: int, source) -> dict[str, object]:
    d, points, fusion_rows = source.matrix_for(q)
    z_rows = source.signed_passant_incidence(q, d, points, fusion_rows)
    fusion = matrix(ZZ, fusion_rows)
    size = len(points)
    m = (q + 1) // 2
    epsilon = source.chi(-1, q)
    delta = -source.chi(-2, q)
    w = switched_matrix(z_rows, delta)
    target = m * identity_matrix(ZZ, size) - epsilon * fusion
    symmetry_failures = sum(
        w[j, i] != delta * w[i, j]
        for i in range(size)
        for j in range(size)
    )
    square_failures = sum(value != 0 for value in (w * w - delta * target).list())
    if symmetry_failures or square_failures:
        raise AssertionError(f"q={q}: self-dual identity failed")

    smith = w.smith_form()[0]
    nonzero = [abs(int(smith[i, i])) for i in range(size) if smith[i, i]]
    invariant_counts = collections.Counter(nonzero)
    expected_rank = (q * q - 1) // 4
    if len(nonzero) != expected_rank:
        raise AssertionError(f"q={q}: wrong Smith rank")
    return {
        "q": q,
        "vertices": size,
        "self_dual_sign": delta,
        "self_dual_type": "symmetric" if delta == 1 else "skew-symmetric",
        "symmetry_failures": symmetry_failures,
        "square_identity_failures": square_failures,
        "rank": len(nonzero),
        "expected_rank": expected_rank,
        "nonzero_smith_invariant_counts": {
            str(value): count for value, count in sorted(invariant_counts.items())
        },
        "torsion_order_of_cokernel_on_image": 1,
    }


def certificate() -> dict[str, object]:
    source = load_source()
    return {
        "schema": "c756-self-dual-signed-incidence-v1",
        "dependency": "SageMath 10.7",
        "source": SOURCE.name,
        "claimed_range": list(source.PRIMES),
        "cases": [certify(q, source) for q in source.PRIMES],
    }


def serialized() -> str:
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    actual = serialized()
    if args.write:
        OUTPUT.write_text(actual, encoding="utf-8")
        return
    expected = OUTPUT.read_text(encoding="utf-8")
    if actual != expected:
        raise SystemExit("certificate mismatch: regenerate with --write")
    print("ok: 7 self-dual signed-incidence and Smith-form cases")


if __name__ == "__main__":
    main()
