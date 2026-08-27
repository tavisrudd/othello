#!/usr/bin/env python3
"""Generate the exact marked-root quotient for the GF(32) R11 Lucas carrier."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "c973-r11-gf16-pointed-quotient.py"
DEFAULT_BINARY = (
    ROOT
    / "papers/high_weight_grs_cosets/software/projective-reed-solomon/target/release/projective-reed-solomon"
)
DEFAULT_OUTPUT = HERE / "c973-r11-gf32-pointed-quotient.json"
SCHEMA = "c973-r11-gf32-pointed-quotient-v1"
Q = 32
MODULUS = 0b100101

SPEC = importlib.util.spec_from_file_location("c973_gf16_generator", BASE_PATH)
assert SPEC is not None and SPEC.loader is not None
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)
BASE.Q = Q
BASE.MODULUS = MODULUS


def request_for(representative: tuple[int, ...]) -> dict[str, object]:
    return {
        "schema": "projective-reed-solomon-request-v1",
        "field": {
            "p": 2,
            "degree": 5,
            "modulus": [1, 0, 1, 0, 0, 1],
            "encoding": "polynomial-basis-base-p-integer-v1",
        },
        "redundancy": 11,
        "evaluation": "full-projective-nrc-v1",
        "syndrome": BASE.syndrome(representative),
    }


def public_pointed_locator(
    binary: Path, representative: tuple[int, ...], candidate_limit: int
) -> tuple[dict[str, object] | None, str | None]:
    request = request_for(representative)
    try:
        result = BASE.run_json(
            [
                str(binary),
                "--candidate-limit",
                str(candidate_limit),
                "--compact",
                "simultaneous-locator",
                "--forbid-infinity",
            ],
            request,
        )
    except RuntimeError as error:
        message = str(error)
        if "no split locator avoiding the prescribed roots was found through degree 9" in message:
            return None, "NO_DEGREE_NINE_LOCATOR"
        if "candidate limit" in message.lower():
            return None, "CANDIDATE_LIMIT"
        raise RuntimeError(f"representative {representative}: {error}") from error
    if result.get("schema") != "projective-reed-solomon-simultaneous-locator-v1":
        raise RuntimeError("unexpected locator-result schema")
    certificate = result["certificate"]
    verified = BASE.run_json([str(binary), "--compact", "verify"], certificate)
    if verified.get("status") != "VALID":
        raise RuntimeError("public verifier rejected generated certificate")
    support = certificate["support"]
    if "infinity" in support or len(support) != 9:
        raise RuntimeError("locator is not a finite squarefree nonic")
    return (
        {
            "representative": list(representative),
            "status": "WITNESS",
            "support": [root["finite"] for root in support],
            "candidates_examined": certificate["candidates_examined"],
        },
        None,
    )


def generate(binary: Path, candidate_limit: int, max_orbits: int | None) -> dict[str, object]:
    representatives = BASE.orbit_representatives()
    selected = representatives if max_orbits is None else representatives[:max_orbits]
    records = []
    for representative in selected:
        record, failure = public_pointed_locator(binary, representative, candidate_limit)
        if record is None:
            records.append(
                {
                    "representative": list(representative),
                    "status": failure,
                }
            )
        else:
            records.append(record)
    witnesses = [record for record in records if record["status"] == "WITNESS"]
    return {
        "schema": SCHEMA,
        "scope": "complete" if max_orbits is None else f"first {len(selected)} calibration orbits",
        "field": "GF(2)[x]/(x^5+x^2+1)",
        "field_order": Q,
        "modulus_integer": MODULUS,
        "carrier_support": list(BASE.CARRIER_SUPPORT),
        "marked_root": "infinity",
        "borel_generators": [
            [1, 1, 0, 1],
            [BASE.C531.primitive_element(Q, MODULUS), 0, 0, 1],
        ],
        "projective_carrier_points": (Q**5 - 1) // (Q - 1),
        "orbit_count": len(representatives),
        "tested_orbits": len(records),
        "witness_orbits": len(witnesses),
        "unresolved_orbits": len(records) - len(witnesses),
        "candidate_limit": candidate_limit,
        "maximum_candidates_examined": max(
            (record["candidates_examined"] for record in witnesses), default=0
        ),
        "base_source_sha256": hashlib.sha256(BASE_PATH.read_bytes()).hexdigest(),
        "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
        "records": records,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary", type=Path, default=DEFAULT_BINARY)
    parser.add_argument("--candidate-limit", type=int, default=2_000_000)
    parser.add_argument("--max-orbits", type=int)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate(args.binary, args.candidate_limit, args.max_orbits)
    encoded = json.dumps(result, sort_keys=True, separators=(",", ":")) + "\n"
    if args.check:
        if args.max_orbits is not None:
            raise SystemExit("--check requires the complete quotient")
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit("tracked output differs from deterministic regeneration")
        print(f"C973 GF(32) pointed quotient: PASS ({result['orbit_count']} orbits)")
    elif args.max_orbits is not None:
        print(
            json.dumps(
                {key: value for key, value in result.items() if key != "records"},
                sort_keys=True,
            )
        )
    else:
        args.output.write_text(encoded)
        print(
            json.dumps(
                {
                    "output": str(args.output),
                    "orbit_count": result["orbit_count"],
                    "witness_orbits": result["witness_orbits"],
                    "unresolved_orbits": result["unresolved_orbits"],
                    "maximum_candidates_examined": result["maximum_candidates_examined"],
                },
                sort_keys=True,
            )
        )


if __name__ == "__main__":
    main()
