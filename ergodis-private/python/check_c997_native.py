#!/usr/bin/env python3
"""Privately replay and compare retained C997 native-distance evidence."""

from __future__ import annotations

import argparse
import importlib.util
import json
import statistics
from pathlib import Path

import numpy as np


def load_c997(path: Path):
    spec = importlib.util.spec_from_file_location("c997_gross_source", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load C997 source: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def read_native(path: Path) -> dict:
    records = [json.loads(line) for line in path.read_text(encoding="utf-8").splitlines()]
    if len(records) != 1:
        raise ValueError("native evidence must contain exactly one completed record")
    return records[0]


def gurobi_wall(path: Path) -> tuple[float, int]:
    solves = []
    threads = None
    for line in path.read_text(encoding="utf-8").splitlines():
        record = json.loads(line)
        if record.get("kind") == "header":
            threads = record.get("threads")
        if record.get("kind") == "solve":
            if record["status_name"] != "OPTIMAL" or record["objective"] != 12.0:
                raise ValueError("Gurobi control is not an exact distance-12 solve")
            solves.append(record)
    if len(solves) != 2:
        raise ValueError("Gurobi control does not contain both anchored solves")
    if not isinstance(threads, int) or threads < 1:
        raise ValueError("Gurobi control has no valid thread count")
    return sum(record["wall_seconds"] for record in solves), threads


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--c997-source", type=Path, required=True)
    parser.add_argument("--native", type=Path, required=True)
    parser.add_argument("--gurobi", type=Path, required=True)
    args = parser.parse_args()
    record = read_native(args.native)
    if record["schema"] not in {
        "ergodis-css-distance-native-v1",
        "ergodis-css-distance-native-v2",
        "ergodis-css-distance-native-v3",
    }:
        raise ValueError("native schema mismatch")
    if record["mode"] != "certify-incumbent" or record["maximum_weight"] != 12:
        raise ValueError("native run did not certify the supplied incumbent")
    result = record["result"]
    if result["distance"] != 12 or result["searched_maximum_weight"] != 10:
        raise ValueError("native run did not close the even lower-weight domain")
    if result["stats"]["nontrivial_supports"] != 0:
        raise ValueError("native lower-bound search found an unexpected logical support")

    c997 = load_c997(args.c997_source.resolve())
    hx, _, lx, _, _, _ = c997.build_gross_code()
    hx = np.asarray(hx, dtype=np.uint8) & 1
    lx = np.asarray(lx, dtype=np.uint8) & 1
    witness = np.zeros(hx.shape[1], dtype=np.uint8)
    support = result["witness"]
    if len(support) != len(set(support)) or len(support) != 12:
        raise ValueError("native witness support is malformed")
    witness[support] = 1
    if np.any((hx @ witness) & 1) or not np.any((lx @ witness) & 1):
        raise ValueError("native witness failed independent GF(2) replay")

    native_median = statistics.median(record["search_seconds"])
    if record["schema"] == "ergodis-css-distance-native-v1":
        preparation_mode = "compile"
        preparation = record["compile_seconds"]
        artifact_payload_blake3 = None
    else:
        preparation_mode = record["preparation_mode"]
        preparation = record["preparation_seconds"]
        artifact_payload_blake3 = record["artifact_payload_blake3"]
        if preparation_mode == "artifact-load" and (
            not isinstance(artifact_payload_blake3, str)
            or len(artifact_payload_blake3) != 64
        ):
            raise ValueError("loaded artifact is not bound by a payload checksum")
    cold = preparation + native_median
    native_threads = record.get("threads", 1)
    gurobi, gurobi_threads = gurobi_wall(args.gurobi)
    if native_threads != gurobi_threads:
        raise ValueError("native and Gurobi evidence use different thread counts")
    output = {
        "native_rounds": len(record["search_seconds"]),
        "native_preparation_mode": preparation_mode,
        "native_preparation_seconds": preparation,
        "artifact_payload_blake3": artifact_payload_blake3,
        "native_search_median_seconds": native_median,
        "native_cold_seconds": cold,
        "gurobi_anchored_wall_seconds": gurobi,
        "matched_threads": native_threads,
        "warm_search_speedup_over_gurobi": gurobi / native_median,
        "cold_speedup_over_gurobi": gurobi / cold,
        "candidate_supports": result["stats"]["candidates"],
    }
    print(json.dumps(output, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
