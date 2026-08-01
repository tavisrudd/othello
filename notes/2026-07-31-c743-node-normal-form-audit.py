#!/usr/bin/env python3
"""Generate or check the C743 node-normal-form certificate."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
REPOSITORY = ROOT.parent
SINGULAR_INPUT = ROOT / "2026-07-31-c743-node-normal-form-audit.sing"
OUTPUT = ROOT / "2026-07-31-c743-node-normal-form-audit.json"
EXPECTED_LINES = (
    "C743_NODE_NORMAL_FORM_OK",
    "representative=[1:1:1:0:0:0]",
    "critical_ideal=maximal_times_plane_crossing",
    "radical=two_transverse_planes",
    "defect=square_zero_length_4",
    "all_nodes=10_by_S6_symmetry",
)


def run(*arguments: str) -> str:
    completed = subprocess.run(
        arguments,
        cwd=REPOSITORY,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    if completed.stderr:
        raise SystemExit(f"unexpected stderr:\n{completed.stderr}")
    return completed.stdout


def compute() -> dict:
    version_output = run(
        "nix", "shell", "nixpkgs#singular", "--command", "Singular", "--version"
    )
    match = re.search(r"version\s+(\d+\.\d+\.\d+)", version_output)
    if not match:
        raise SystemExit("could not parse Singular version")
    audit_output = run(
        "nix",
        "shell",
        "nixpkgs#singular",
        "--command",
        "Singular",
        "-q",
        str(SINGULAR_INPUT.relative_to(REPOSITORY)),
    )
    lines = tuple(line.strip() for line in audit_output.splitlines() if line.strip())
    if lines != EXPECTED_LINES:
        raise SystemExit(f"unexpected Singular output: {lines!r}")
    return {
        "schema": "c743-node-normal-form-v1",
        "singular_version": match.group(1),
        "field": "Q",
        "representative": "[1:1:1:0:0:0]",
        "local_coordinates": {
            "x0": "1",
            "x1": "1+a",
            "x2": "1+b",
            "x3": "c",
            "x4": "d",
            "x5": "0",
        },
        "critical_ideal": "(a,b,c,d)*(a,b)*(c,d)",
        "radical": "(a,b) intersect (c,d)",
        "defect": {
            "module": "((a,b)*(c,d))/((a,b,c,d)*(a,b)*(c,d))",
            "is_square_zero": True,
            "length_per_node": 4,
            "nodes": 10,
        },
        "interpretation": "critical scheme of (u,v) -> u tensor v",
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(compute())
    if args.check:
        if not OUTPUT.exists() or OUTPUT.read_bytes() != generated:
            raise SystemExit("tracked node-normal-form certificate is stale")
        print("node normal-form audit: OK")
    else:
        OUTPUT.write_bytes(generated)
        print(OUTPUT)


if __name__ == "__main__":
    main()
