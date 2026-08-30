#!/usr/bin/env python3
"""Compress the C973 GF(27) extremal switch witnesses into torus orbits.

The input is the frozen 78-row ``e3-good78.tsv`` certificate.  This adapter
independently rebuilds GF(27), verifies every nine-set against the two Hankel
equations for e_3, and quotients the supports by nonzero scalar multiplication.
The resulting three representatives are a small structural proof target: one
representative for each conjugate plane label, plus torus equivariance.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
import os
from pathlib import Path
from typing import Iterable


def _digits(a: int) -> tuple[int, int, int]:
    return (a % 3, (a // 3) % 3, (a // 9) % 3)


def _undigits(d: Iterable[int]) -> int:
    x = tuple(d)
    return x[0] % 3 + 3 * (x[1] % 3) + 9 * (x[2] % 3)


def add(a: int, b: int) -> int:
    x, y = _digits(a), _digits(b)
    return _undigits((x[0] + y[0], x[1] + y[1], x[2] + y[2]))


def neg(a: int) -> int:
    x = _digits(a)
    return _undigits((-x[0], -x[1], -x[2]))


def mul(a: int, b: int) -> int:
    x, y = _digits(a), _digits(b)
    c = [0] * 5
    for i in range(3):
        for j in range(3):
            c[i + j] = (c[i + j] + x[i] * y[j]) % 3
    return _undigits((c[0] + c[3], c[1] + c[3] + c[4], c[2] + c[4]))


def polynomial_from_roots(roots: Iterable[int]) -> list[int]:
    polynomial = [1]
    for root in roots:
        nxt = [0] * (len(polynomial) + 1)
        for index, coefficient in enumerate(polynomial):
            nxt[index + 1] = add(nxt[index + 1], coefficient)
            nxt[index] = add(nxt[index], neg(mul(coefficient, root)))
        polynomial = nxt
    return polynomial


def scale_support(support: tuple[int, ...], scalar: int) -> tuple[int, ...]:
    return tuple(sorted(mul(scalar, point) for point in support))


def canonical_support(support: tuple[int, ...]) -> tuple[int, ...]:
    return min(scale_support(support, scalar) for scalar in range(1, 27))


def extract(source: Path) -> dict[str, object]:
    source_bytes = source.read_bytes()
    rows: list[tuple[str, tuple[int, ...]]] = []
    with source.open(newline="", encoding="utf-8") as handle:
        for row in csv.DictReader(handle, delimiter="\t"):
            support = tuple(sorted(int(value) for value in row["nine_set"].split(",")))
            if len(support) != 9 or len(set(support)) != 9:
                raise ValueError("certificate row is not a nine-point set")
            polynomial = polynomial_from_roots(support)
            if polynomial[2] != 0 or polynomial[3] != 0:
                raise ValueError("certificate row does not close e_3")
            rows.append((row["lambda_label"], support))

    support_set = {support for _, support in rows}
    if len(support_set) != len(rows):
        raise ValueError("certificate contains duplicate supports")

    groups: dict[tuple[int, ...], list[tuple[str, tuple[int, ...]]]] = {}
    for label, support in rows:
        groups.setdefault(canonical_support(support), []).append((label, support))

    orbits: list[dict[str, object]] = []
    for representative, members in sorted(groups.items()):
        expected = {scale_support(representative, scalar) for scalar in range(1, 27)}
        observed = {support for _, support in members}
        labels = sorted({label for label, _ in members})
        if observed != expected:
            raise ValueError("input does not contain a complete torus orbit")
        if len(labels) != 1:
            raise ValueError("lambda label is not constant on a torus orbit")
        orbits.append(
            {
                "lambda_label": labels[0],
                "representative": list(representative),
                "orbit_size": len(expected),
                "input_members": len(members),
            }
        )

    return {
        "schema": "ergodis.semantic-orbit-core.v1",
        "problem": "C973 GF(27) extremal e3 switch witnesses",
        "source": os.fspath(source),
        "source_sha256": hashlib.sha256(source_bytes).hexdigest(),
        "field": "GF(3)[x]/(x^3-x-1)",
        "observable": "monic split degree-nine locator has g_2=g_3=0",
        "input_witnesses": len(rows),
        "torus_orbits": len(orbits),
        "compression_ratio": len(rows) / len(orbits),
        "orbits": orbits,
        "proof_target": (
            "verify the three representative switch identities and prove that nonzero "
            "scalar multiplication preserves admissibility and closure"
        ),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("source", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    result = extract(args.source)
    rendered = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.output is None:
        print(rendered, end="")
        return
    with args.output.open("x", encoding="utf-8") as handle:
        handle.write(rendered)


if __name__ == "__main__":
    main()
