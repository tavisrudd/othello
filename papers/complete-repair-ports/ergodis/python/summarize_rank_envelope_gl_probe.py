#!/usr/bin/env python3
"""Reduce Criterion output for rank envelopes and binary GL probes."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
BENCHMARKS = {
    "envelope_cached_scan": "rank_stratified_envelope_query/A_cached_subspace_scan",
    "envelope_lookup": "rank_stratified_envelope_query/B_precomputed_restriction_envelope",
    "lazy_compile_16": "rank_stratified_envelope_compile_batch/A_lazy_cache_all_contexts",
    "envelope_compile_16": "rank_stratified_envelope_compile_batch/B_compile_envelope_then_query",
    "gl_2x8_verified": "binary_gl_probe_rank2_width8/compile_and_verify",
    "gl_2x8_deferred": "binary_gl_probe_rank2_width8/compile_deferred_verification",
    "gl_3x6_verified": "binary_gl_probe_rank3_width6/compile_and_verify",
    "gl_3x6_deferred": "binary_gl_probe_rank3_width6/compile_deferred_verification",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--criterion-root", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    measurements = {}
    for name, relative in BENCHMARKS.items():
        directory = args.criterion_root / relative / "new"
        estimates = json.loads((directory / "estimates.json").read_text())
        sample = json.loads((directory / "sample.json").read_text())
        measurements[name] = {
            "slope_ns": estimates["slope"],
            "sample": sample,
        }
    slope = lambda name: measurements[name]["slope_ns"]["point_estimate"]
    output = {
        "schema": "ergodis-rank-envelope-gl-probe-v1",
        "protocol": {
            "cpu_affinity": 2,
            "criterion_sample_size": {"envelope": 30, "gl_probe": 20},
            "warmup_seconds": 1,
            "measurement_seconds": 2,
        },
        "rank_envelope": {
            "field": 2,
            "ambient_dimension": 5,
            "target_rank": 2,
            "maximum_context_rank": 4,
            "contexts_per_batch": 16,
            "states": 307,
            "restriction_edges": 1530,
            "payload_bytes": 18406,
            "full_span_candidates": 930,
            "query_speedup": slope("envelope_cached_scan") / slope("envelope_lookup"),
            "first_batch_compile_ratio": slope("envelope_compile_16")
            / slope("lazy_compile_16"),
        },
        "gl_probe": {
            "rank2_width8": {
                "points": 65536,
                "generators": 3,
                "orbits": 11051,
                "compression": 65536 / 11051,
                "quotient_bytes": 306348,
                "certificate_bytes": 786432,
                "deferred_speedup": slope("gl_2x8_verified") / slope("gl_2x8_deferred"),
            },
            "rank3_width6": {
                "points": 262144,
                "generators": 6,
                "orbits": 2110,
                "compression": 262144 / 2110,
                "quotient_bytes": 1057016,
                "certificate_bytes": 3145728,
                "deferred_speedup": slope("gl_3x6_verified") / slope("gl_3x6_deferred"),
            },
        },
        "measurements": measurements,
        "artifacts": {
            "git_head": subprocess.run(
                ["git", "rev-parse", "HEAD"],
                cwd=ROOT,
                check=True,
                text=True,
                stdout=subprocess.PIPE,
            ).stdout.strip(),
            "contextual_source_sha256": sha256(ROOT / "src" / "contextual.rs"),
            "group_action_source_sha256": sha256(ROOT / "src" / "group_action.rs"),
            "runner_sha256": sha256(Path(__file__).resolve()),
        },
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(output, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
