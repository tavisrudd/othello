#!/usr/bin/env python3
"""Aggregate the independent C++ q=73 mixed-star shards and test E6."""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
GEOMETRY_SOURCE = HERE / "2026-08-10-c756-mixed-star-geometry.cpp"
PYTHON_REFERENCE = HERE / "2026-08-09-c756-q59-k13-star-search.py"
EXPECTED_GEOMETRY_SHA256 = (
    "44d881d50dd9fa4c2d73be99cae907956094c2cf2472aa7d13b5777aaaa45f02"
)
EXPECTED_REFERENCE_SHA256 = (
    "f5d0d53cf687bd44fda0f8e89584930983eac4d22905807d22901e4ee105c3d6"
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_reference():
    if sha256(GEOMETRY_SOURCE) != EXPECTED_GEOMETRY_SHA256:
        raise SystemExit("C++ geometry source hash mismatch")
    if sha256(PYTHON_REFERENCE) != EXPECTED_REFERENCE_SHA256:
        raise SystemExit("Python reference hash mismatch")
    saved_argv = sys.argv
    try:
        sys.argv = [str(PYTHON_REFERENCE), "--q", "73", "--target-size", "13"]
        spec = importlib.util.spec_from_file_location(
            "c756_q73_python_reference", PYTHON_REFERENCE
        )
        if spec is None or spec.loader is None:
            raise RuntimeError("cannot load Python reference")
        module = importlib.util.module_from_spec(spec)
        sys.modules[spec.name] = module
        spec.loader.exec_module(module)
    finally:
        sys.argv = saved_argv
    return module


def canonical_witness(witness):
    result = sorted([int(direction), int(offset)] for direction, offset in witness)
    if len(result) != 13 or len({tuple(pair) for pair in result}) != 13:
        raise ValueError("malformed witness")
    return result


def aggregate(shard_directory: Path):
    reference = load_reference()
    model = reference.mixed_model()
    shard_paths = sorted(
        shard_directory.glob("c756-q73-mixed-seed-*.json"),
        key=lambda path: int(path.stem.rsplit("-", 1)[1]),
    )
    if len(shard_paths) != 37:
        raise SystemExit(f"expected 37 shards, found {len(shard_paths)}")

    search_nodes = 0
    geometric_stars = 0
    forced_window_stars = 0
    any_complete_center = 0
    all_complete_centers = 0
    first_nonzero = Counter()
    type_profiles = Counter()
    witnesses = []
    shards = []

    for expected_seed, path in enumerate(shard_paths):
        data = json.loads(path.read_text())
        if data.get("q") != 73 or data.get("seed_s") != expected_seed:
            raise SystemExit(f"shard metadata mismatch: {path}")
        raw_witnesses = data.get("witnesses")
        if data.get("geometric_stars") != len(raw_witnesses):
            raise SystemExit(f"leaf count mismatch: {path}")
        search_nodes += int(data["search_nodes"])
        geometric_stars += len(raw_witnesses)
        shards.append(
            {
                "bytes": path.stat().st_size,
                "file": path.name,
                "geometric_stars": len(raw_witnesses),
                "search_nodes": int(data["search_nodes"]),
                "sha256": sha256(path),
            }
        )

        for raw_witness in raw_witnesses:
            witness = canonical_witness(raw_witness)
            if witness[0] != [0, expected_seed]:
                raise SystemExit(f"seed normalization mismatch: {path}")
            selected = [reference.MIXED.Vertex(*pair) for pair in witness]
            for i, left in enumerate(selected):
                for right in selected[:i]:
                    if (
                        reference.MIXED.chi(
                            reference.MIXED.node_q(left, right, reference.NONSQUARE)
                        )
                        != reference.INTERNAL_NODE_CHARACTER
                    ):
                        raise SystemExit(f"noninternal node in {path}")
            analysis = reference.analyze_leaf(model, selected)
            degree = analysis["first_nonzero_forced_degree"]
            first_nonzero[degree] += 1
            forced_window_stars += int(analysis["forced_window"])
            any_complete_center += int(analysis["complete_centers"] > 0)
            all_complete_centers += int(
                analysis["complete_centers"] == analysis["required_centers"]
            )
            type_profiles[(analysis["secants"], analysis["passants"])] += 1
            witnesses.append(
                {
                    "complete_centers": analysis["complete_centers"],
                    "first_nonzero_forced_degree": degree,
                    "maximum_span": analysis["maximum_span"],
                    "minimum_span": analysis["minimum_span"],
                    "passants": analysis["passants"],
                    "secants": analysis["secants"],
                    "vertices": witness,
                }
            )

    witnesses.sort(key=lambda item: item["vertices"])
    if len({tuple(map(tuple, item["vertices"])) for item in witnesses}) != len(witnesses):
        raise SystemExit("duplicate canonical witness")

    return {
        "first_nonzero_forced_degree": [
            {"count": count, "degree": degree}
            for degree, count in sorted(
                first_nonzero.items(), key=lambda item: 23 if item[0] is None else item[0]
            )
        ],
        "forced_degrees": [6, 22],
        "forced_window_stars": forced_window_stars,
        "geometric_stars": geometric_stars,
        "k": 14,
        "mode": "mixed-external-deletion",
        "normalization": (
            "central inversion sends seed offset s to -s; representatives 0..36"
        ),
        "pinned_files": {
            GEOMETRY_SOURCE.name: EXPECTED_GEOMETRY_SHA256,
            PYTHON_REFERENCE.name: EXPECTED_REFERENCE_SHA256,
        },
        "q": 73,
        "schema": "c756-q73-k14-mixed-cpp-aggregate-v1",
        "search_nodes": search_nodes,
        "seed_representatives": list(range(37)),
        "shards": shards,
        "stars_with_all_complete_centers": all_complete_centers,
        "stars_with_any_complete_center": any_complete_center,
        "target_size": 13,
        "type_profiles": [
            {"count": count, "passants": key[1], "secants": key[0]}
            for key, count in sorted(type_profiles.items())
        ],
        "witnesses": witnesses,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--shard-directory", type=Path, required=True)
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--output", type=Path)
    group.add_argument("--check", type=Path)
    arguments = parser.parse_args()
    rendered = json.dumps(
        aggregate(arguments.shard_directory), indent=2, sort_keys=True
    ) + "\n"
    if arguments.check is not None:
        if rendered != arguments.check.read_text():
            raise SystemExit(f"certificate mismatch: {arguments.check}")
        print(f"certificate ok: {arguments.check}")
    else:
        arguments.output.write_text(rendered)
        print(f"wrote {arguments.output}")


if __name__ == "__main__":
    main()
