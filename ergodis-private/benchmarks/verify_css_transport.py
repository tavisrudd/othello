#!/usr/bin/env python3
"""Independent replay of CSS shard coverage transported across an equivalence."""

from __future__ import annotations

import argparse
import json
import struct
import subprocess
from pathlib import Path
from typing import Any

from verify_css_isomorphism_admission import (
    canonical_basis,
    load_object,
    permute_rows,
    sparse_rows,
)


def blake3_bytes(data: bytes) -> str:
    return subprocess.run(
        ["b3sum", "--no-names"],
        input=data,
        check=True,
        capture_output=True,
    ).stdout.decode().strip()


def blake3_file(path: Path) -> str:
    return blake3_bytes(path.read_bytes())


def compact_json(value: object) -> bytes:
    return json.dumps(value, ensure_ascii=False, separators=(",", ":")).encode()


def rust_canonical_basis(rows: list[int], columns: int) -> list[int]:
    data = list(rows)
    pivot_row = 0
    for column in range(columns):
        found = next(
            (row for row in range(pivot_row, len(data)) if data[row] >> column & 1),
            None,
        )
        if found is None:
            continue
        data[pivot_row], data[found] = data[found], data[pivot_row]
        for row in range(len(data)):
            if row != pivot_row and data[row] >> column & 1:
                data[row] ^= data[pivot_row]
        pivot_row += 1
        if pivot_row == len(data):
            break
    return data[:pivot_row]


def semantic_digest(problem: dict[str, Any]) -> str:
    columns = problem["coordinate_count"]
    physical = sparse_rows(problem["physical_checks"], columns)
    logical = sparse_rows(problem["logical_observations"], columns)
    physical_basis = rust_canonical_basis(physical, columns)
    observable_basis = rust_canonical_basis(physical + logical, columns)
    transcript = bytearray(b"ergodis-css-search-semantics-v1\0")
    transcript.extend(struct.pack("<Q", columns))
    for tag, basis in ((b"P", physical_basis), (b"O", observable_basis)):
        transcript.extend(tag)
        transcript.extend(struct.pack("<QQ", len(basis), columns))
        for row in basis:
            transcript.extend((row >> column & 1) for column in range(columns))
    return blake3_bytes(bytes(transcript))


def replay_admission(
    source_path: Path, target_path: Path, admission_path: Path
) -> tuple[dict[str, Any], dict[str, Any], dict[str, Any]]:
    source = load_object(source_path)
    target = load_object(target_path)
    admission = load_object(admission_path)
    if admission.get("schema") != "ergodis-css-isomorphism-admission-v1":
        raise ValueError("unsupported coordinate-equivalence admission")
    if admission.get("source_blake3") != blake3_file(source_path):
        raise ValueError("source input fingerprint mismatch")
    if admission.get("target_blake3") != blake3_file(target_path):
        raise ValueError("target input fingerprint mismatch")
    columns = source.get("coordinate_count")
    images = admission.get("coordinate_images")
    if (
        not isinstance(columns, int)
        or columns <= 0
        or target.get("coordinate_count") != columns
        or not isinstance(images, list)
        or sorted(images) != list(range(columns))
    ):
        raise ValueError("coordinate map is not a compatible permutation")
    source_physical = sparse_rows(source.get("physical_checks"), columns)
    source_logical = sparse_rows(source.get("logical_observations"), columns)
    target_physical = sparse_rows(target.get("physical_checks"), columns)
    target_logical = sparse_rows(target.get("logical_observations"), columns)
    mapped_physical = canonical_basis(permute_rows(source_physical, images))
    target_physical_basis = canonical_basis(target_physical)
    mapped_observable = canonical_basis(
        permute_rows(source_physical + source_logical, images)
    )
    target_observable = canonical_basis(target_physical + target_logical)
    if mapped_physical != target_physical_basis:
        raise ValueError("physical row spaces differ")
    if mapped_observable != target_observable:
        raise ValueError("observable row spaces differ")
    if admission.get("physical_rank") != len(mapped_physical):
        raise ValueError("physical rank mismatch")
    if admission.get("observable_rank") != len(mapped_observable):
        raise ValueError("observable rank mismatch")
    return source, target, admission


def replay_witness(problem: dict[str, Any], witness: list[int]) -> None:
    columns = problem["coordinate_count"]
    if len(set(witness)) != len(witness) or any(not 0 <= value < columns for value in witness):
        raise ValueError("invalid witness support")
    support = set(witness)
    physical = problem["physical_checks"]
    logical = problem["logical_observations"]
    if any(sum(coordinate in support for coordinate in row) % 2 for row in physical):
        raise ValueError("witness violates a physical check")
    if not any(sum(coordinate in support for coordinate in row) % 2 for row in logical):
        raise ValueError("witness has zero logical observation")


def replay_cover(record_paths: list[Path], coverage: dict[str, Any]) -> None:
    records = [load_object(path) for path in record_paths]
    if not records:
        raise ValueError("no shard records")
    count = records[0].get("search_shard", {}).get("count")
    if not isinstance(count, int) or count <= 0 or len(records) != count:
        raise ValueError("shard count is incomplete")
    records.sort(key=lambda record: record["search_shard"]["index"])
    if [record["search_shard"]["index"] for record in records] != list(range(count)):
        raise ValueError("shard indices are incomplete or duplicated")
    identity_keys = (
        "input_blake3",
        "problem_semantics_blake3",
        "executable_blake3",
        "artifact_payload_blake3",
        "search_kernel",
        "check_presentation_seed",
        "maximum_weight",
    )
    identity = tuple(records[0].get(key) for key in identity_keys)
    total_candidates = 0
    for record in records:
        if (
            record.get("schema")
            not in {"ergodis-css-distance-native-v6", "ergodis-css-distance-native-v7"}
            or record.get("completion_status") != "complete"
            or record.get("mode") != "bounded-search-shard"
            or record.get("result_scope") != "partial-shard"
            or tuple(record.get(key) for key in identity_keys) != identity
        ):
            raise ValueError("incompatible shard record")
        rounds = record.get("round_stats")
        if not isinstance(rounds, list) or not rounds:
            raise ValueError("missing shard rounds")
        if record["result"]["stats"]["candidates"] != rounds[-1]["candidates"]:
            raise ValueError("final round count mismatch")
        total_candidates += sum(round_["candidates"] for round_ in rounds)

    first_frontiers = records[0]["shard_frontiers"]
    for position, first in enumerate(first_frontiers):
        anchor = first["anchor"]
        expected_branches = first["frontier_branches"]
        expected_digest = first["partition_blake3"]
        transcript = bytearray(b"ergodis-css-shard-frontier-v1\0")
        transcript.extend(struct.pack("<HI", anchor, count))
        branches = 0
        for index, record in enumerate(records):
            frontier = record["shard_frontiers"][position]
            if (
                frontier["anchor"] != anchor
                or frontier["frontier_branches"] != expected_branches
                or frontier["partition_blake3"] != expected_digest
            ):
                raise ValueError("frontier identity mismatch")
            shard_branches = frontier["shard_branches"]
            branches += shard_branches
            transcript.extend(struct.pack("<IQ", index, shard_branches))
            transcript.extend(bytes.fromhex(frontier["shard_sum_le"]))
            transcript.extend(bytes.fromhex(frontier["shard_xor_le"]))
        if branches != expected_branches or blake3_bytes(bytes(transcript)) != expected_digest:
            raise ValueError("frontier buckets do not reconstruct their commitment")

    if coverage.get("schema") not in {
        "ergodis-css-distance-shard-coverage-v3",
        "ergodis-css-distance-shard-coverage-v4",
    }:
        raise ValueError("unsupported coverage schema")
    if coverage.get("verdict") != "complete-compatible-cover":
        raise ValueError("coverage is not complete")
    if coverage.get("input_blake3") != identity[0]:
        raise ValueError("coverage input mismatch")
    if coverage.get("shard_count") != count or coverage.get("completed_shards") != count:
        raise ValueError("coverage shard count mismatch")
    if coverage.get("total_candidates") != total_candidates:
        raise ValueError("coverage candidate count mismatch")
    evidence = {entry["index"]: entry["evidence_blake3"] for entry in coverage["shards"]}
    for index, path in enumerate(record_paths):
        record_index = load_object(path)["search_shard"]["index"]
        if evidence.get(record_index) != blake3_file(path):
            raise ValueError(f"coverage evidence digest mismatch at shard {index}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--target", type=Path, required=True)
    parser.add_argument("--admission", type=Path, required=True)
    parser.add_argument("--coverage", type=Path, required=True)
    parser.add_argument("--transport", type=Path, required=True)
    parser.add_argument("records", type=Path, nargs="+")
    args = parser.parse_args()

    source, target, admission = replay_admission(args.source, args.target, args.admission)
    coverage = load_object(args.coverage)
    transport = load_object(args.transport)
    replay_cover(args.records, coverage)
    if coverage.get("input_blake3") != admission["source_blake3"]:
        raise ValueError("source coverage is not bound to the equivalence source")
    if coverage.get("problem_semantics_blake3") != semantic_digest(source):
        raise ValueError("source coverage semantic digest mismatch")
    if transport.get("schema") != "ergodis-css-distance-transport-v1":
        raise ValueError("unsupported transport schema")
    if transport.get("verdict") != "transported-complete-compatible-cover":
        raise ValueError("transport verdict is incomplete")
    expected = {
        "source_input_blake3": admission["source_blake3"],
        "target_input_blake3": admission["target_blake3"],
        "source_semantics_blake3": semantic_digest(source),
        "target_semantics_blake3": semantic_digest(target),
        "source_coverage_blake3": blake3_bytes(compact_json(coverage)),
        "coordinate_equivalence_blake3": blake3_file(args.admission),
        "coordinate_count": admission["coordinate_count"],
        "physical_rank": admission["physical_rank"],
        "observable_rank": admission["observable_rank"],
        "maximum_weight": coverage["maximum_weight"],
        "searched_maximum_weight": coverage["searched_maximum_weight"],
        "aggregate_distance": coverage["aggregate_distance"],
    }
    for key, value in expected.items():
        if transport.get(key) != value:
            raise ValueError(f"transport field {key} does not replay")

    source_witness = coverage["aggregate_witness"]
    target_witness = transport["aggregate_witness"]
    if coverage["aggregate_distance"] is None:
        if source_witness or target_witness:
            raise ValueError("negative cover carries a witness")
    else:
        replay_witness(source, source_witness)
        mapped = sorted(admission["coordinate_images"][coordinate] for coordinate in source_witness)
        if target_witness != mapped:
            raise ValueError("transported witness is not the coordinate image")
        replay_witness(target, target_witness)
    print(
        json.dumps(
            {
                "shards": coverage["completed_shards"],
                "total_candidates": coverage["total_candidates"],
                "transported_to": admission["target_blake3"],
                "status": "verified",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
