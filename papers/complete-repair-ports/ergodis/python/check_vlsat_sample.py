#!/usr/bin/env python3
"""Check VLSAT-2 sample evidence and its censored speedup claims."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import statistics
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("evidence", type=Path)
    parser.add_argument("--cnf", type=Path)
    parser.add_argument("--ergodis", type=Path)
    parser.add_argument("--kissat", type=Path)
    parser.add_argument("--z3", type=Path)
    args = parser.parse_args()
    document = json.loads(args.evidence.read_text())
    assert document["schema"] == "ergodis-vlsat2-structured-sample-v1"
    rounds = document["ergodis_rounds"]
    assert len(rounds) == document["method"]["rounds"] >= 3
    semantic = [{key: value for key, value in item.items() if key != "elapsed_ns"} for item in rounds]
    assert all(item == semantic[0] for item in semantic)
    assert semantic[0]["status"] == "unsat"
    assert semantic[0]["parts"] > semantic[0]["colors"]
    assert len(semantic[0]["clique_vertices"]) == semantic[0]["parts"]
    median_ns = statistics.median(item["elapsed_ns"] for item in rounds)
    assert median_ns == document["ergodis_median_ns"]
    timeout_ns = document["method"]["timeout_s"] * 1_000_000_000
    for solver in ("kissat", "z3"):
        result = document[solver]
        if result["status"] == "timeout":
            expected = timeout_ns / median_ns
            assert math.isclose(
                document[f"{solver}_speedup_lower_bound"], expected, rel_tol=1e-12
            )
    for path, key in (
        (args.cnf, "cnf_sha256"),
        (args.ergodis, "ergodis_sha256"),
        (args.kissat, "kissat_sha256"),
        (args.z3, "z3_sha256"),
    ):
        if path is not None:
            assert sha256(path) == document["artifacts"][key]
    print(
        f"ok: median {median_ns / 1e6:.6g} ms; "
        f"Kissat >={document['kissat_speedup_lower_bound']:.6g}x; "
        f"Z3 >={document['z3_speedup_lower_bound']:.6g}x"
    )


if __name__ == "__main__":
    main()
