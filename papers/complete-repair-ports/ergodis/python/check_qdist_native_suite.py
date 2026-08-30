#!/usr/bin/env python3
"""Independently check a completed Ergodis QDistSAT suite sweep."""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def one_json_line(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as stream:
        lines = [line for line in stream if line.strip()]
    if len(lines) != 1:
        raise RuntimeError(f"{path}: expected one nonempty JSON line")
    value = json.loads(lines[0])
    if not isinstance(value, dict):
        raise RuntimeError(f"{path}: expected a JSON object")
    return value


def replay_witness(problem: dict[str, Any], native: dict[str, Any]) -> None:
    result = native["result"]
    distance = result["distance"]
    witness = result["witness"]
    if distance is None:
        if witness:
            raise RuntimeError("a null distance has a nonempty witness")
        return
    if len(witness) != distance or witness != sorted(set(witness)):
        raise RuntimeError("witness weight or canonical ordering is invalid")
    coordinates = problem["coordinate_count"]
    if any(coordinate < 0 or coordinate >= coordinates for coordinate in witness):
        raise RuntimeError("witness coordinate is out of range")
    support = set(witness)
    if any(sum(coordinate in support for coordinate in row) % 2 for row in problem["physical_checks"]):
        raise RuntimeError("witness violates a physical check")
    if not any(
        sum(coordinate in support for coordinate in row) % 2
        for row in problem["logical_observations"]
    ):
        raise RuntimeError("witness has zero logical observation")


def quantum_distance_is_exact(pair: list[dict[str, Any]]) -> bool:
    if any(record["status"] != "ok" for record in pair):
        return False
    distances = [
        record["native"]["result"]["distance"]
        for record in pair
        if record["native"]["result"]["distance"] is not None
    ]
    if not distances:
        return False
    distance = min(distances)
    return all(
        record["native"]["result"]["distance"] is not None
        or record["native"]["result"]["searched_maximum_weight"] >= distance
        for record in pair
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--root", type=Path, required=True)
    args = parser.parse_args()

    manifest = json.loads((args.root / "manifest.json").read_text(encoding="utf-8"))
    if manifest.get("schema") not in {
        "ergodis-qdist-native-suite-v1",
        "ergodis-qdist-native-suite-v2",
        "ergodis-qdist-native-suite-v3",
    }:
        raise RuntimeError("unexpected suite manifest schema")
    records: list[dict[str, Any]] = []
    with (args.root / "summary.jsonl").open("r", encoding="utf-8") as stream:
        for line in stream:
            if line.strip():
                records.append(json.loads(line))
    expected_count = manifest["direction_count"]
    if len(records) != expected_count:
        raise RuntimeError(f"expected {expected_count} result records, found {len(records)}")
    keys = [(record["stem"], record["direction"]) for record in records]
    if len(set(keys)) != expected_count:
        raise RuntimeError("duplicate stem/direction records")
    by_stem: dict[str, list[dict[str, Any]]] = defaultdict(list)
    statuses: Counter[str] = Counter()
    wall_seconds: list[float] = []
    maximum_rss_kib = 0
    witness_count = 0
    for record in records:
        stem = record["stem"]
        direction = record["direction"]
        if record.get("schema") not in {
            "ergodis-qdist-native-suite-result-v1",
            "ergodis-qdist-native-suite-result-v2",
            "ergodis-qdist-native-suite-result-v3",
        }:
            raise RuntimeError(f"{stem}/{direction}: unexpected result schema")
        canonical_input_path = args.root / "inputs" / f"{stem}--{direction}.json"
        input_path = args.root / record.get(
            "input_relative_path", f"inputs/{stem}--{direction}.json"
        )
        if sha256(input_path) != record["input_sha256"]:
            raise RuntimeError(f"{stem}/{direction}: input hash mismatch")
        if "canonical_input_sha256" in record and (
            sha256(canonical_input_path) != record["canonical_input_sha256"]
        ):
            raise RuntimeError(f"{stem}/{direction}: canonical input hash mismatch")
        problem = json.loads(input_path.read_text(encoding="utf-8"))
        if problem["coordinate_count"] != record["coordinate_count"]:
            raise RuntimeError(f"{stem}/{direction}: coordinate-count mismatch")
        if len(problem["anchors"]) != record["anchor_count"]:
            raise RuntimeError(f"{stem}/{direction}: anchor-count mismatch")
        status = record["status"]
        statuses[status] += 1
        by_stem[stem].append(record)
        metrics = record["metrics"]
        maximum_rss_kib = max(maximum_rss_kib, metrics.get("maximum_rss_kib", 0))
        if "wall_seconds" in metrics:
            wall_seconds.append(metrics["wall_seconds"])
        ris = record.get("ris")
        if ris is not None:
            ris_evidence_path = args.root / "ris" / f"{stem}--{direction}.evidence.jsonl"
            if sha256(ris_evidence_path) != record["ris_evidence_sha256"]:
                raise RuntimeError(f"{stem}/{direction}: RIS evidence hash mismatch")
            if one_json_line(ris_evidence_path) != ris:
                raise RuntimeError(f"{stem}/{direction}: RIS evidence differs from stdout")
            if ris["result"] is not None:
                replay_witness(
                    problem,
                    {
                        "result": {
                            "distance": ris["result"]["distance_upper_bound"],
                            "witness": ris["result"]["witness"],
                        }
                    },
                )
        if status != "ok":
            if record["native"] is not None:
                raise RuntimeError(f"{stem}/{direction}: failed run retained a native record")
            continue
        native = record["native"]
        if native["schema"] != "ergodis-css-distance-native-v3":
            raise RuntimeError(f"{stem}/{direction}: unexpected native schema")
        if native["coordinate_count"] != record["coordinate_count"]:
            raise RuntimeError(f"{stem}/{direction}: native coordinate-count mismatch")
        if native["maximum_weight"] != record["maximum_weight"]:
            raise RuntimeError(f"{stem}/{direction}: native maximum-weight mismatch")
        if native["threads"] != manifest["threads"]:
            raise RuntimeError(f"{stem}/{direction}: thread-count mismatch")
        evidence_path = args.root / "evidence" / f"{stem}--{direction}.jsonl"
        if sha256(evidence_path) != record["evidence_sha256"]:
            raise RuntimeError(f"{stem}/{direction}: evidence hash mismatch")
        if one_json_line(evidence_path) != native:
            raise RuntimeError(f"{stem}/{direction}: streamed evidence differs from stdout")
        replay_witness(problem, native)
        witness_count += native["result"]["distance"] is not None
    if len(by_stem) != manifest["instance_count"]:
        raise RuntimeError("suite does not contain the expected number of stems")
    if any({record["direction"] for record in pair} != {"hx-gz", "hz-gx"} for pair in by_stem.values()):
        raise RuntimeError("a stem does not contain both CSS directions")
    complete_stems = sum(all(record["status"] == "ok" for record in pair) for pair in by_stem.values())
    exact_stems = sum(quantum_distance_is_exact(pair) for pair in by_stem.values())
    output = {
        "schema": "ergodis-qdist-native-suite-check-v2",
        "records": len(records),
        "stems": len(by_stem),
        "statuses": dict(sorted(statuses.items())),
        "complete_stems": complete_stems,
        "exact_stems": exact_stems,
        "witness_directions": witness_count,
        "maximum_rss_kib": maximum_rss_kib,
        "geometric_mean_wall_seconds": math.exp(
            math.fsum(math.log(value) for value in wall_seconds if value > 0) / len(wall_seconds)
        ),
    }
    print(json.dumps(output, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
