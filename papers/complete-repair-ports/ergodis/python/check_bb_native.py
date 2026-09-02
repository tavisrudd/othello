#!/usr/bin/env python3
"""Independently replay retained native bivariate-bicycle distance evidence."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


def parity(row: list[int], support: set[int]) -> int:
    return sum(coordinate in support for coordinate in row) & 1


def replay_witness(problem: dict[str, object], distance: int | None, witness: list[int]) -> list[int]:
    support = set(witness)
    if distance is None:
        if witness:
            raise RuntimeError("bounded miss unexpectedly retains a witness")
        return []
    if len(support) != len(witness) or len(witness) != distance:
        raise RuntimeError("witness is repeated or has the wrong weight")
    if not all(0 <= coordinate < problem["coordinate_count"] for coordinate in support):
        raise RuntimeError("witness coordinate is outside the code")
    if any(parity(row, support) for row in problem["physical_checks"]):
        raise RuntimeError("witness has nonzero physical syndrome")
    logical = [parity(row, support) for row in problem["logical_observations"]]
    if not any(logical):
        raise RuntimeError("witness has zero logical observation")
    return logical


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--evidence", type=Path, required=True)
    parser.add_argument("--minimum-rounds", type=int, default=3)
    args = parser.parse_args()
    input_bytes = args.input.read_bytes()
    problem = json.loads(input_bytes)
    records = [json.loads(line) for line in args.evidence.read_text(encoding="utf-8").splitlines()]
    if len(records) != 1:
        raise RuntimeError("expected exactly one retained evidence record")
    record = records[0]
    if record["schema"] == "ergodis-css-distance-random-is-v1":
        result = record["result"]
        distance = result["distance_upper_bound"]
        witness = result["witness"]
        logical = replay_witness(problem, distance, witness)
        if distance is not None and distance > record["target_weight"]:
            raise RuntimeError("random witness exceeds its target weight")
        if not 0 < record["completed_trials"] <= record["requested_trials"]:
            raise RuntimeError("random trial counts are invalid")
        if record["coordinate_count"] != problem["coordinate_count"]:
            raise RuntimeError("evidence/input coordinate mismatch")
        if record["input_sha256"] != hashlib.sha256(input_bytes).hexdigest():
            raise RuntimeError("random evidence input hash mismatch")
        output = {
            "schema": "ergodis-bb-native-check-v1",
            "label": problem["label"],
            "distance": distance,
            "searched_maximum_weight": None,
            "physical_syndrome_zero": True,
            "logical_observation": logical,
            "rounds": record["completed_trials"],
            "candidate_span": None,
        }
        print(json.dumps(output, separators=(",", ":"), sort_keys=True))
        return 0
    if record["schema"] == "ergodis-private-css-bp-osd-spike-v2":
        distance = record["best_weight"]
        witness = record["best_support"]
        logical = replay_witness(problem, distance, witness)
        if record["label"] != problem["label"]:
            raise RuntimeError("BP+OSD evidence/input label mismatch")
        if record["coordinate_count"] != problem["coordinate_count"]:
            raise RuntimeError("BP+OSD evidence/input coordinate mismatch")
        if record["physical_checks"] != len(problem["physical_checks"]):
            raise RuntimeError("BP+OSD physical-check count mismatch")
        if record["logical_observations"] != len(problem["logical_observations"]):
            raise RuntimeError("BP+OSD logical-observation count mismatch")
        attempted = record["attempted"]
        replayed = record["independently_replayed"]
        if attempted <= 0 or not 0 < replayed <= attempted:
            raise RuntimeError("BP+OSD replay counts are invalid")
        if record["best_target"] is None or not 0 <= record["best_target"] < len(
            problem["logical_observations"]
        ):
            raise RuntimeError("BP+OSD target index is invalid")
        output = {
            "schema": "ergodis-bp-osd-check-v1",
            "label": problem["label"],
            "distance_upper_bound": distance,
            "physical_syndrome_zero": True,
            "logical_observation": logical,
            "attempted": attempted,
            "independently_replayed": replayed,
        }
        print(json.dumps(output, separators=(",", ":"), sort_keys=True))
        return 0
    native_schema = record["schema"]
    if native_schema not in {
        "ergodis-css-distance-native-v3",
        "ergodis-css-distance-native-v6",
        "ergodis-css-distance-native-v7",
    }:
        raise RuntimeError("unknown evidence schema")
    result = record["result"]
    if native_schema in {"ergodis-css-distance-native-v6", "ergodis-css-distance-native-v7"}:
        if record.get("completion_status") != "complete":
            raise RuntimeError("native evidence is not a completed search")
        if record.get("result_scope") != "global":
            raise RuntimeError("a shard-local result is not a global distance certificate")
        verification = record.get("anchor_verification")
        anchors = record["anchors"]
        if verification == "verified-orbit-transversal":
            if record.get("coordinate_orbits") != len(anchors):
                raise RuntimeError("verified anchor/orbit counts disagree")
        elif verification == "trusted-input":
            if anchors != list(range(problem["coordinate_count"])):
                raise RuntimeError("unverified anchors do not exhaust the coordinates")
        else:
            raise RuntimeError("unknown anchor verification mode")
        if native_schema == "ergodis-css-distance-native-v7":
            semantic_digest = record.get("problem_semantics_blake3")
            if not isinstance(semantic_digest, str) or len(semantic_digest) != 64:
                raise RuntimeError("v7 evidence has no semantic problem digest")
    distance = result["distance"]
    witness = result["witness"]
    logical = replay_witness(problem, distance, witness)
    if record["coordinate_count"] != problem["coordinate_count"]:
        raise RuntimeError("evidence/input coordinate mismatch")
    if record["label"] != problem["label"]:
        raise RuntimeError("evidence/input label mismatch")
    if record["physical_checks"] != len(problem["physical_checks"]):
        raise RuntimeError("evidence/input physical-check count mismatch")
    if record["logical_observations"] != len(problem["logical_observations"]):
        raise RuntimeError("evidence/input logical-observation count mismatch")
    if result["searched_maximum_weight"] > problem["maximum_weight"]:
        raise RuntimeError("evidence exceeds the input's authorized search radius")
    if result["searched_maximum_weight"] > record["maximum_weight"]:
        raise RuntimeError("result exceeds the evidence search radius")
    if distance is not None and distance > result["searched_maximum_weight"]:
        raise RuntimeError("witness lies outside the searched radius")
    candidates = [stats["candidates"] for stats in record["round_stats"]]
    if args.minimum_rounds <= 0:
        raise RuntimeError("minimum round count must be positive")
    if (
        len(candidates) != len(record["search_seconds"])
        or len(candidates) < args.minimum_rounds
    ):
        raise RuntimeError("multi-round evidence is incomplete")
    if any(seconds <= 0 for seconds in record["search_seconds"]):
        raise RuntimeError("round timing is invalid")
    if record["threads"] == 1 and len(set(candidates)) != 1:
        raise RuntimeError("single-threaded round work is nondeterministic")
    worker_cpus = record.get("worker_cpus", [])
    if worker_cpus and (
        len(worker_cpus) != record["threads"]
        or len(set(worker_cpus)) != len(worker_cpus)
        or any(cpu < 0 for cpu in worker_cpus)
    ):
        raise RuntimeError("worker affinity is incomplete, repeated, or invalid")
    search_kernel = record.get("search_kernel")
    if search_kernel is not None and search_kernel not in {
        "portable-compact",
        "portable-wide",
        "x86-64-avx2-bmi-popcnt",
    }:
        raise RuntimeError("evidence names an unknown native search kernel")
    output = {
        "schema": "ergodis-bb-native-check-v1",
        "label": problem["label"],
        "distance": distance,
        "searched_maximum_weight": result["searched_maximum_weight"],
        "physical_syndrome_zero": True,
        "logical_observation": logical,
        "rounds": len(candidates),
        "candidate_span": [min(candidates), max(candidates)],
    }
    print(json.dumps(output, separators=(",", ":"), sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
