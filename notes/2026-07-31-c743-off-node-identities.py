#!/usr/bin/env python3
"""Generate or check the C743 off-node cofactor-identity certificate."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
REPOSITORY = ROOT.parent
SINGULAR_INPUT = ROOT / "2026-07-31-c743-off-node-identities.sing"
OUTPUT = ROOT / "2026-07-31-c743-off-node-identities.json"
EXPECTED_LINES = (
    "C743_OFF_NODE_IDENTITIES_OK",
    "basis=5_noncrossing_matchings",
    "charts=4+1+1,4+2,5+1",
    "local_generators=unit_times_Specht_orbits",
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
    output = run(
        "nix",
        "shell",
        "nixpkgs#singular",
        "--command",
        "Singular",
        "-q",
        str(SINGULAR_INPUT.relative_to(REPOSITORY)),
    )
    lines = tuple(line.strip() for line in output.splitlines() if line.strip())
    if lines != EXPECTED_LINES:
        raise SystemExit(f"unexpected Singular output: {lines!r}")
    return {
        "schema": "c743-off-node-identities-v1",
        "singular_version": match.group(1),
        "field": "Q",
        "basis": "five noncrossing perfect-matching cubics",
        "minor_order": "four-column subsets then four-row subsets, lexicographic",
        "charts": {
            "4+1+1": "(1,1+a,1+b,1+c,-1+d,0)",
            "4+2": "(1,1+a,1+b,1+c,d,0)",
            "5+1": "(1,1+a,1+b,1+c,1+d,0)",
        },
        "claim": "named Jacobian-cofactor combinations are unit multiples of generators whose symmetric orbits generate the reduced local three-equals ideals",
        "independent_replay": {
            "method": "dependency-free automatic differentiation and exact integer interpolation grid",
            "grid": "{-2,-1,0,1,2,3,4,5,6,7}^4",
            "degree_bound_per_variable": 9,
        },
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
            raise SystemExit("tracked off-node identity certificate is stale")
        print("off-node identity audit: OK")
    else:
        OUTPUT.write_bytes(generated)
        print(OUTPUT)


if __name__ == "__main__":
    main()
