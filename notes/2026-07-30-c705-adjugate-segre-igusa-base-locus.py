#!/usr/bin/env python3
"""Canonical wrapper for the C705 Singular base-locus certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parent
SCRIPT = ROOT / "2026-07-30-c705-adjugate-segre-igusa-base-locus.sing"
OUTPUT = ROOT / "2026-07-30-c705-adjugate-segre-igusa-base-locus.json"


def run_singular() -> dict:
    command = [
        "nix",
        "shell",
        "nixpkgs#singular",
        "--command",
        "Singular",
        "-q",
        str(SCRIPT),
    ]
    result = subprocess.run(command, check=True, text=True, capture_output=True)
    assert not result.stderr
    output = result.stdout
    required = (
        "reduced_support=intersection of 15 four-equal lines",
        "scheme_is_reduced=1",
        "minimal_components=15",
        "primary_components=15",
        "affine_dimension=2",
        "// dimension (proj.)  = 1",
        "// degree (proj.)   = 15",
        "joubert_matching_span_generators=6",
        "polar_base_reduced_support=20 triple-equal planes",
        "polar_base_scheme_is_reduced=1",
        "polar_base_minimal_components=20",
        "polar_base_primary_components=20",
        "// dimension (proj.)  = 2",
        "// degree (proj.)   = 20",
        "inverse_exceptional_divisor=e5=0 is the reduced union of 15 Segre planes",
        "igusa_singular_scheme=reduced union of 15 matching lines",
        "status=verified",
    )
    for line in required:
        assert line in output
    assert "failure=" not in output
    return {
        "schema": "c705-adjugate-segre-igusa-base-locus-v1",
        "computer_algebra_system": "Singular 4.4.1 via nixpkgs#singular",
        "joubert_base_scheme": {
            "reduced": True,
            "components": 15,
            "component_type": "projective line",
            "description": "four specified axis coordinates coincide",
            "degree": 15,
        },
        "pulled_back_polar_base_scheme": {
            "reduced": True,
            "components": 20,
            "component_type": "projective plane",
            "description": "three specified axis coordinates coincide",
            "degree": 20,
        },
        "inverse_polar_exceptional_divisor": {
            "equation_on_segre": "e5(z)=0",
            "reduced": True,
            "components": 15,
            "component_type": "Segre plane",
            "degree": 15,
        },
        "igusa_singular_scheme": {
            "reduced": True,
            "components": 15,
            "component_type": "matching line",
            "degree": 15,
        },
        "method": (
            "exact ideal equality with intersections of linear prime ideals; "
            "radical and primary-decomposition cross-checks"
        ),
    }


def canonical_bytes(data: dict) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.write == args.check:
        parser.error("choose exactly one of --write or --check")
    encoded = canonical_bytes(run_singular())
    if args.write:
        OUTPUT.write_bytes(encoded)
    else:
        assert OUTPUT.read_bytes() == encoded
    print(
        json.dumps(
            {
                "certificate": OUTPUT.name,
                "bytes": len(encoded),
                "sha256": hashlib.sha256(encoded).hexdigest(),
                "status": "written" if args.write else "verified",
            },
            sort_keys=True,
        )
    )


if __name__ == "__main__":
    main()
