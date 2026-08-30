#!/usr/bin/env python3
"""Run the canonical 27-instance QDistSAT suite through Ergodis.

The runner keeps all potentially large or long-lived output under an explicit
disk-backed output root.  Child stdout/stderr and native evidence stream
directly to files; only one compact summary record is retained in memory.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path
from typing import Any


PINNED_QDIST_COMMIT = "9fb224b0fa372161fb3933034016bc8dc423a5ab"
SUITE_DIRECTORIES = ("BB", "BB2", "LP", "LP2", "QT", "QT2")
DEFAULT_MAXIMUM_WEIGHT = 6
LITERATURE_BB_DISTANCES = {
    "BB_72_12_6": 6,
    "BB_90_8_10": 10,
    "BB_108_8_10": 10,
    "BB_144_12_12": 12,
    "BB_216_8_10": 10,
    "BB_144_14_14": 14,
    "BB_288_12_?": 18,
    "BB_360_12_?": 24,
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def git_commit(root: Path) -> str:
    return subprocess.run(
        ["git", "-C", str(root), "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    ).stdout.strip()


def discover_instances(root: Path) -> list[tuple[str, Path]]:
    instances: list[tuple[str, Path]] = []
    for directory in SUITE_DIRECTORIES:
        matrix_dir = root / "data" / directory
        for hx in sorted(matrix_dir.glob("*_Hx.txt")):
            stem = hx.name.removesuffix("_Hx.txt")
            required = [matrix_dir / f"{stem}_{suffix}.txt" for suffix in ("Hx", "Hz", "Gx", "Gz")]
            missing = [str(path) for path in required if not path.is_file()]
            if missing:
                raise RuntimeError(f"{stem}: missing required matrices: {missing}")
            instances.append((stem, matrix_dir))
    if len(instances) != 27:
        raise RuntimeError(f"expected canonical 27-instance suite, found {len(instances)}")
    return instances


def read_json(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as stream:
        value = json.load(stream)
    if not isinstance(value, dict):
        raise RuntimeError(f"{path}: expected one JSON object")
    return value


def one_json_line(path: Path) -> dict[str, Any]:
    with path.open("r", encoding="utf-8") as stream:
        lines = [line for line in stream if line.strip()]
    if len(lines) != 1:
        raise RuntimeError(f"{path}: expected one nonempty JSON line")
    value = json.loads(lines[0])
    if not isinstance(value, dict):
        raise RuntimeError(f"{path}: expected a JSON object")
    return value


def ensure_input(
    importer: Path,
    physical: Path,
    logical: Path,
    label: str,
    maximum_weight: int,
    output: Path,
) -> dict[str, Any]:
    if not output.exists():
        subprocess.run(
            [
                sys.executable,
                str(importer),
                "--physical",
                str(physical),
                "--logical",
                str(logical),
                "--label",
                label,
                "--maximum-weight",
                str(maximum_weight),
                "--auto-torus",
                "--out",
                str(output),
            ],
            check=True,
        )
    problem = read_json(output)
    metadata = problem.get("metadata", {})
    expected = {
        "label": label,
        "maximum_weight": maximum_weight,
        "physical_sha256": sha256(physical),
        "logical_sha256": sha256(logical),
    }
    actual = {
        "label": problem.get("label"),
        "maximum_weight": problem.get("maximum_weight"),
        "physical_sha256": metadata.get("physical_sha256"),
        "logical_sha256": metadata.get("logical_sha256"),
    }
    if actual != expected:
        raise RuntimeError(f"stale or mismatched cached input {output}: {actual} != {expected}")
    return problem


def parse_metrics(path: Path) -> dict[str, float | int]:
    metrics: dict[str, float | int] = {}
    if not path.exists():
        return metrics
    for line in path.read_text(encoding="utf-8").splitlines():
        key, separator, value = line.partition("=")
        if not separator:
            continue
        if key == "maximum_rss_kib":
            metrics[key] = int(value)
        elif key in {"wall_seconds", "user_seconds", "system_seconds"}:
            metrics[key] = float(value)
    return metrics


def completed_keys(summary: Path) -> set[tuple[str, str]]:
    completed: set[tuple[str, str]] = set()
    if not summary.exists():
        return completed
    with summary.open("r", encoding="utf-8") as stream:
        for line in stream:
            record = json.loads(line)
            completed.add((record["stem"], record["direction"]))
    return completed


def append_record(path: Path, record: dict[str, Any]) -> None:
    with path.open("a", encoding="utf-8", buffering=1) as stream:
        json.dump(record, stream, separators=(",", ":"), sort_keys=True)
        stream.write("\n")
        stream.flush()
        os.fsync(stream.fileno())


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--qdist-root", type=Path, required=True)
    parser.add_argument("--output-root", type=Path, required=True)
    parser.add_argument("--binary", type=Path, required=True)
    parser.add_argument("--random-binary", type=Path)
    parser.add_argument("--ris-trials", type=int, default=1_000_000)
    parser.add_argument("--ris-seed", type=int, default=98530)
    parser.add_argument("--threads", type=int, default=16)
    parser.add_argument("--worker-cpus", default="")
    parser.add_argument("--timeout", type=float, default=180.0)
    parser.add_argument("--maximum-weight", type=int)
    parser.add_argument("--resume", action="store_true")
    args = parser.parse_args()

    if args.threads <= 0 or args.timeout <= 0 or args.ris_trials <= 0:
        raise RuntimeError("threads, timeout, and RIS trials must be positive")
    if str(args.output_root.resolve()).startswith("/tmp/"):
        raise RuntimeError("--output-root must not use the RAM-backed /tmp filesystem")
    if git_commit(args.qdist_root) != PINNED_QDIST_COMMIT:
        raise RuntimeError("QDistSAT checkout is not at the pinned suite commit")
    timeout_program = shutil.which("timeout")
    time_program = shutil.which("time")
    if timeout_program is None or time_program is None:
        raise RuntimeError("the suite runner requires timeout and time executables")
    if not args.binary.is_file():
        raise RuntimeError(f"native binary does not exist: {args.binary}")
    if args.random_binary is not None and not args.random_binary.is_file():
        raise RuntimeError(f"random-search binary does not exist: {args.random_binary}")

    output_root = args.output_root
    inputs_dir = output_root / "inputs"
    logs_dir = output_root / "logs"
    evidence_dir = output_root / "evidence"
    ris_dir = output_root / "ris"
    search_inputs_dir = output_root / "search-inputs"
    for directory in (inputs_dir, logs_dir, evidence_dir, ris_dir, search_inputs_dir):
        directory.mkdir(parents=True, exist_ok=True)
    summary = output_root / "summary.jsonl"
    manifest_path = output_root / "manifest.json"
    instances = discover_instances(args.qdist_root)
    manifest = {
        "schema": "ergodis-qdist-native-suite-v2",
        "qdist_commit": PINNED_QDIST_COMMIT,
        "suite_directories": list(SUITE_DIRECTORIES),
        "instance_count": len(instances),
        "direction_count": 2 * len(instances),
        "timeout_seconds": args.timeout,
        "threads": args.threads,
        "worker_cpus": args.worker_cpus,
        "maximum_weight_override": args.maximum_weight,
        "default_non_bb_maximum_weight": DEFAULT_MAXIMUM_WEIGHT,
        "binary_sha256": sha256(args.binary),
        "random_binary_sha256": sha256(args.random_binary) if args.random_binary else None,
        "ris_trials": args.ris_trials,
        "ris_seed": args.ris_seed,
    }
    if manifest_path.exists():
        if read_json(manifest_path) != manifest:
            raise RuntimeError("existing suite manifest does not match this invocation")
    else:
        with manifest_path.open("x", encoding="utf-8") as stream:
            json.dump(manifest, stream, indent=2, sort_keys=True)
            stream.write("\n")

    completed = completed_keys(summary) if args.resume else set()
    if summary.exists() and not args.resume:
        raise RuntimeError("summary already exists; pass --resume to continue it")
    importer = Path(__file__).with_name("import_qdist_native.py")
    directions = (("hx-gz", "Hx", "Gz"), ("hz-gx", "Hz", "Gx"))
    for instance_index, (stem, matrix_dir) in enumerate(instances, 1):
        maximum_weight = args.maximum_weight
        if maximum_weight is None:
            maximum_weight = LITERATURE_BB_DISTANCES.get(stem, DEFAULT_MAXIMUM_WEIGHT)
        for direction, physical_suffix, logical_suffix in directions:
            key = (stem, direction)
            if key in completed:
                continue
            slug = f"{stem}--{direction}"
            physical = matrix_dir / f"{stem}_{physical_suffix}.txt"
            logical = matrix_dir / f"{stem}_{logical_suffix}.txt"
            input_path = inputs_dir / f"{slug}.json"
            problem = ensure_input(
                importer,
                physical,
                logical,
                f"QDistSAT {stem} {physical_suffix}/{logical_suffix}",
                maximum_weight,
                input_path,
            )
            budget_started = time.monotonic()
            search_input_path = input_path
            ris_record: dict[str, Any] | None = None
            ris_evidence_sha256: str | None = None
            if (
                args.random_binary is not None
                and maximum_weight >= 12
            ):
                ris_stdout_path = ris_dir / f"{slug}.stdout.jsonl"
                ris_stderr_path = ris_dir / f"{slug}.stderr.log"
                ris_evidence_path = ris_dir / f"{slug}.evidence.jsonl"
                ris_command = [
                    timeout_program,
                    "--signal=TERM",
                    "--kill-after=2s",
                    f"{args.timeout}s",
                    str(args.random_binary),
                    "--input",
                    str(input_path),
                    "--trials",
                    str(args.ris_trials),
                    "--target-weight",
                    str(maximum_weight),
                    "--threads",
                    str(args.threads),
                    "--seed",
                    str(args.ris_seed + 2 * instance_index + (direction == "hz-gx")),
                    "--evidence",
                    str(ris_evidence_path),
                ]
                with ris_stdout_path.open("xb") as stdout, ris_stderr_path.open("xb") as stderr:
                    ris_returncode = subprocess.run(
                        ris_command, stdout=stdout, stderr=stderr
                    ).returncode
                if ris_returncode == 0:
                    ris_record = one_json_line(ris_stdout_path)
                    ris_evidence_sha256 = sha256(ris_evidence_path)
                    result = ris_record.get("result")
                    if result is not None:
                        search_problem = dict(problem)
                        search_problem["incumbent_support"] = result["witness"]
                        search_input_path = search_inputs_dir / f"{slug}.json"
                        with search_input_path.open("x", encoding="utf-8") as stream:
                            json.dump(
                                search_problem,
                                stream,
                                separators=(",", ":"),
                                sort_keys=True,
                            )
                            stream.write("\n")
            stdout_path = logs_dir / f"{slug}.stdout.jsonl"
            stderr_path = logs_dir / f"{slug}.stderr.log"
            metrics_path = logs_dir / f"{slug}.time"
            evidence_path = evidence_dir / f"{slug}.jsonl"
            for path in (stdout_path, stderr_path, metrics_path, evidence_path):
                if path.exists():
                    raise RuntimeError(f"refusing to overwrite incomplete run artifact {path}")
            remaining_timeout = args.timeout - (time.monotonic() - budget_started)
            command = [
                time_program,
                "-f",
                "wall_seconds=%e\nuser_seconds=%U\nsystem_seconds=%S\nmaximum_rss_kib=%M",
                "-o",
                str(metrics_path),
                timeout_program,
                "--signal=TERM",
                "--kill-after=5s",
                f"{max(0.001, remaining_timeout)}s",
                str(args.binary),
                "--input",
                str(search_input_path),
                "--evidence",
                str(evidence_path),
                "--threads",
                str(args.threads),
            ]
            if args.worker_cpus:
                command += ["--worker-cpus", args.worker_cpus]
            with stdout_path.open("xb") as stdout, stderr_path.open("xb") as stderr:
                returncode = subprocess.run(command, stdout=stdout, stderr=stderr).returncode
            elapsed = time.monotonic() - budget_started
            status = "ok" if returncode == 0 else "timeout" if returncode == 124 else "error"
            native_record: dict[str, Any] | None = None
            if status == "ok":
                with stdout_path.open("r", encoding="utf-8") as stream:
                    lines = [line for line in stream if line.strip()]
                if len(lines) != 1:
                    raise RuntimeError(f"{slug}: expected one native JSON record")
                native_record = json.loads(lines[0])
            record = {
                "schema": "ergodis-qdist-native-suite-result-v2",
                "instance_index": instance_index,
                "stem": stem,
                "direction": direction,
                "maximum_weight": maximum_weight,
                "status": status,
                "returncode": returncode,
                "runner_elapsed_seconds": elapsed,
                "coordinate_count": problem["coordinate_count"],
                "physical_rows": len(problem["physical_checks"]),
                "logical_rows": len(problem["logical_observations"]),
                "anchor_count": len(problem["anchors"]),
                "torus_shape": problem["metadata"]["torus_shape"],
                "canonical_input_sha256": sha256(input_path),
                "input_relative_path": str(search_input_path.relative_to(output_root)),
                "input_sha256": sha256(search_input_path),
                "ris": ris_record,
                "ris_evidence_sha256": ris_evidence_sha256,
                "evidence_sha256": sha256(evidence_path) if evidence_path.exists() else None,
                "metrics": parse_metrics(metrics_path),
                "native": native_record,
            }
            append_record(summary, record)
            print(
                f"[{instance_index:02d}/27 {direction}] {stem}: {status} "
                f"{elapsed:.3f}s anchors={len(problem['anchors'])}",
                flush=True,
            )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
