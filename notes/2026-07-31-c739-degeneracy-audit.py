#!/usr/bin/env python3
"""Generate/check the canonical certificate for the C739 Singular audit."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
REPOSITORY = ROOT.parent
SINGULAR_INPUT = ROOT / "2026-07-31-c739-degeneracy-audit.sing"
OUTPUT = ROOT / "2026-07-31-c739-degeneracy-audit.json"
EXPECTED_LINES = (
    "C739_DEGENERACY_AUDIT_OK",
    "rank_drop_scheme=reduced_top_components_plus_lower_dimensional_nilpotents",
    "rank_drop_radical=20_codimension_two_linear_spaces",
    "rank_drop_projective_degree=20",
    "nilpotent_defect_support=10_projective_points",
    "simultaneous_pfaffian_base=distinct_reduced_15_projective_lines",
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
        raise SystemExit(f"unexpected Singular certificate output: {lines!r}")
    return {
        "schema": "c739-degeneracy-audit-v1",
        "singular_version": match.group(1),
        "translation_gauge": "x5=0",
        "top_coordinates": "Pf([D_x,C_T])=4*Z_T",
        "rank_drop": {
            "ideal": "4-by-4 minors of the 6-by-5 Jacobian",
            "is_reduced": False,
            "projective_degree": 20,
            "radical_components": 20,
            "radical_component_type": "projective planes",
            "nilpotent_defect_support_components": 10,
            "nilpotent_defect_support_type": "projective points",
        },
        "simultaneous_pfaffian_base": {
            "is_reduced": True,
            "projective_degree": 15,
            "components": 15,
            "component_type": "projective lines",
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
            raise SystemExit("tracked degeneracy audit is stale")
        print("degeneracy audit: OK")
    else:
        OUTPUT.write_bytes(generated)
        print(OUTPUT)


if __name__ == "__main__":
    main()
