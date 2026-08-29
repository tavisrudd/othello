#!/usr/bin/env python3
"""Generate the exact marked-root quotient for the GF(32) R11 Lucas carrier.

Repair, 2026-08-28.  This generator delegates every step to the repaired
GF(16) generator with the field constants rebound, so it inherits the
degree-ten divided-power upper-Borel action and the fail-closed 1000-pair
equivariance gate.  The superseded v1 quotient used an earlier degree-nine R10
action truncated to the non-invariant slice ``e_3..e_7``; see the sibling file
for the full diagnosis.  Do not validate a future change against the orbit
count 1129: the discarded wrong group has the same number of orbits.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


PAPER = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-08-28-r11-gf16-pointed-quotient.py"
DEFAULT_BINARY = (
    PAPER
    / "software/projective-reed-solomon/target/release/projective-reed-solomon"
)
DEFAULT_OUTPUT = HERE / "2026-08-28-r11-gf32-pointed-quotient.json"
SCHEMA = "prs-r11-gf32-pointed-quotient-v2"
REPAIR = (
    "2026-08-28: rebuilt on the degree-ten divided-power upper-Borel action; "
    "the superseded v1 quotient used an earlier degree-nine R10 action truncated "
    "to a non-invariant slice"
)
Q = 32
MODULUS = 0b100101

SPEC = importlib.util.spec_from_file_location("prs_gf16_generator", BASE_PATH)
assert SPEC is not None and SPEC.loader is not None
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)

BASE.Q = Q
BASE.MODULUS = MODULUS
BASE.SCHEMA = SCHEMA
BASE.REPAIR = REPAIR
BASE.FIELD_NAME = "GF(2)[x]/(x^5+x^2+1)"
BASE.FIELD_REQUEST = {
    "p": 2,
    "degree": 5,
    "modulus": [1, 0, 1, 0, 0, 1],
    "encoding": "polynomial-basis-base-p-integer-v1",
}


def generate(binary: Path, candidate_limit: int) -> dict:
    result = BASE.generate(binary, candidate_limit)
    result["scope"] = "complete"
    result["base_source_sha256"] = hashlib.sha256(BASE_PATH.read_bytes()).hexdigest()
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary", type=Path, default=DEFAULT_BINARY)
    parser.add_argument("--candidate-limit", type=int, default=2_000_000)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate(args.binary, args.candidate_limit)
    encoded = json.dumps(result, sort_keys=True, separators=(",", ":")) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit("tracked output differs from deterministic regeneration")
        print(f"GF(32) pointed quotient: PASS ({result['orbit_count']} orbits)")
    else:
        args.output.write_text(encoded)
        print(
            json.dumps(
                {
                    "output": str(args.output),
                    "orbit_count": result["orbit_count"],
                    "witness_orbits": result["witness_orbits"],
                    "witness_degree_histogram": result["witness_degree_histogram"],
                    "witness_source_histogram": result["witness_source_histogram"],
                    "maximum_candidates_examined": result["maximum_candidates_examined"],
                },
                sort_keys=True,
            )
        )


if __name__ == "__main__":
    main()
