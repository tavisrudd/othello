#!/usr/bin/env python3
"""Export a published bivariate-bicycle CSS code to Ergodis sparse JSON."""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path

import numpy as np
from bposd.css import css_code


@dataclass(frozen=True)
class CodeSpec:
    label: str
    ell: int
    m: int
    a_exp: tuple[int, int, int]
    b_exp: tuple[int, int, int]
    distance: int


SPECS = {
    "gross144": CodeSpec("Gross [[144,12,12]]", 12, 6, (3, 1, 2), (3, 1, 2), 12),
    "bb288": CodeSpec("BB [[288,12,18]]", 12, 12, (3, 2, 7), (3, 1, 2), 18),
    "bb360": CodeSpec("BB [[360,12,<=24]]", 30, 6, (9, 1, 2), (3, 25, 26), 24),
    "bb756": CodeSpec("BB [[756,16,<=34]]", 21, 18, (3, 10, 17), (5, 3, 19), 34),
}


def dense_binary(matrix) -> np.ndarray:
    dense = matrix.todense() if hasattr(matrix, "todense") else matrix
    return np.asarray(dense, dtype=np.uint8) & 1


def sparse_rows(matrix: np.ndarray) -> list[list[int]]:
    return [[int(value) for value in np.flatnonzero(row)] for row in matrix]


def build(spec: CodeSpec) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    identity_ell = np.identity(spec.ell, dtype=np.uint8)
    identity_m = np.identity(spec.m, dtype=np.uint8)
    x = {
        exponent: np.kron(np.roll(identity_ell, exponent, axis=1), identity_m)
        for exponent in range(spec.ell)
    }
    y = {
        exponent: np.kron(identity_ell, np.roll(identity_m, exponent, axis=1))
        for exponent in range(spec.m)
    }
    a1, a2, a3 = spec.a_exp
    b1, b2, b3 = spec.b_exp
    a = (x[a1] + y[a2] + y[a3]) & 1
    b = (y[b1] + x[b2] + x[b3]) & 1
    hx = np.hstack((a, b))
    hz = np.hstack((b.T, a.T))
    code = css_code(hx, hz)
    return hx, hz, dense_binary(code.lx)


def gf2_rank(matrix: np.ndarray) -> int:
    rows = [sum(int(bit) << index for index, bit in enumerate(row)) for row in matrix]
    pivots: dict[int, int] = {}
    for value in rows:
        while value:
            pivot = value.bit_length() - 1
            if pivot not in pivots:
                pivots[pivot] = value
                break
            value ^= pivots[pivot]
    return len(pivots)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--code", choices=sorted(SPECS), required=True)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    spec = SPECS[args.code]
    hx, hz, lx = build(spec)
    if np.any((hx @ hz.T) & 1):
        raise RuntimeError("published matrices do not define a commuting CSS code")
    block_size = spec.ell * spec.m
    output = {
        "label": spec.label,
        "coordinate_count": int(hx.shape[1]),
        "physical_checks": sparse_rows(hx),
        "logical_observations": sparse_rows(lx),
        "anchors": [0, block_size],
        "maximum_weight": spec.distance,
        "metadata": {
            "ell": spec.ell,
            "m": spec.m,
            "physical_rank": gf2_rank(hx),
            "stabilizer_rank": gf2_rank(hz),
            "logical_count": int(lx.shape[0]),
        },
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, separators=(",", ":"), sort_keys=True)
        stream.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
