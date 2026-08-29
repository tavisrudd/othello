#!/usr/bin/env python3
"""Export the C997 Gross matrices to the native Ergodis sparse JSON interface."""

from __future__ import annotations

import argparse
import importlib.util
import json
from pathlib import Path

import numpy as np


def load_c997(path: Path):
    spec = importlib.util.spec_from_file_location("c997_gross_source", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load C997 source: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def sparse_rows(matrix: np.ndarray) -> list[list[int]]:
    return [[int(value) for value in np.flatnonzero(row)] for row in matrix]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--c997-source", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--evidence", type=Path, required=True)
    args = parser.parse_args()
    c997 = load_c997(args.c997_source.resolve())
    hx, _, lx, _, _, _ = c997.build_gross_code()
    hx = np.asarray(hx, dtype=np.uint8) & 1
    lx = np.asarray(lx, dtype=np.uint8) & 1
    incumbent = None
    with args.evidence.open(encoding="utf-8") as stream:
        for line in stream:
            record = json.loads(line)
            if record.get("kind") == "solve" and record.get("objective") == 12.0:
                incumbent = record["witness"]["support"]
                break
    if incumbent is None:
        raise RuntimeError("evidence contains no replayed weight-12 incumbent")
    output = {
        "label": "C997 Gross [[144,12,12]]",
        "coordinate_count": int(hx.shape[1]),
        "physical_checks": sparse_rows(hx),
        "logical_observations": sparse_rows(lx),
        "anchors": [0, int(c997.ELL * c997.M)],
        "maximum_weight": 12,
        "incumbent_support": incumbent,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, separators=(",", ":"), sort_keys=True)
        stream.write("\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
