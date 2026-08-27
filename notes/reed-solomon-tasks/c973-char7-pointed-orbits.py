#!/usr/bin/env python3
"""Generate the seven pointed-orbit certificates for the R11/R12 p=7 carriers."""

import argparse
import hashlib
import json
import subprocess
from dataclasses import dataclass
from enum import Enum
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_BINARY = (
    ROOT
    / "papers/beyond4_prs/software/projective-reed-solomon/target/release/projective-reed-solomon"
)
DEFAULT_OUTPUT = Path(__file__).with_name("c973-char7-pointed-orbits.json")
SCHEMA = "c973-char7-pointed-orbits-v1"
RESULT_SCHEMA = "projective-reed-solomon-simultaneous-locator-v1"
SOFTWARE_AUTHORITY_COMMIT = "f26d751b8339c81cdc3f28ddbcd1f019e264f866"

FIELD = {
    "p": 7,
    "degree": 2,
    "modulus": [1, 0, 1],
    "encoding": "polynomial-basis-base-p-integer-v1",
}

class RootKind(Enum):
    FINITE = "finite"
    INFINITY = "infinity"


@dataclass(frozen=True)
class OrbitCase:
    orbit: str
    redundancy: int
    carrier_indices: tuple[int, ...]
    coefficients: tuple[int, ...]
    root_kind: RootKind
    root_value: int | None = None


# At R11, coordinates are on (e_4,e_5,e_6).  In the equivariant quadratic
# basis (f_0,f_1,f_2)=(e_4,5e_5,e_6), the first five rows are the two pointed
# double-root orbits, two pointed split orbits, and one pointed nonsplit orbit.
# At R12, (e_5,6e_6) is the standard module, giving equal and distinct pairs.
ORBITS = (
    OrbitCase("r11-double-root-marked", 11, (4, 5, 6), (1, 0, 0), RootKind.FINITE, 0),
    OrbitCase("r11-double-root-unmarked", 11, (4, 5, 6), (1, 0, 0), RootKind.INFINITY),
    OrbitCase("r11-split-root-marked", 11, (4, 5, 6), (1, 0, 6), RootKind.FINITE, 1),
    OrbitCase("r11-split-root-unmarked", 11, (4, 5, 6), (1, 0, 6), RootKind.FINITE, 0),
    # 15 encodes 1+2x.  Its norm is 5, a nonsquare in F_7, so -15 is
    # genuinely nonsquare in F_49; base-field nonsquares are squares here.
    OrbitCase("r11-nonsplit", 11, (4, 5, 6), (1, 0, 15), RootKind.FINITE, 0),
    OrbitCase("r12-equal", 12, (5, 6), (1, 0), RootKind.FINITE, 0),
    OrbitCase("r12-distinct", 12, (5, 6), (1, 0), RootKind.INFINITY),
)


def run_json(command, stdin):
    completed = subprocess.run(
        command,
        input=json.dumps(stdin, sort_keys=True),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr.strip())
    return json.loads(completed.stdout)


def request_for(case):
    syndrome = [0] * case.redundancy
    for index, coefficient in zip(case.carrier_indices, case.coefficients):
        syndrome[index] = coefficient
    return {
        "schema": "projective-reed-solomon-request-v1",
        "field": FIELD,
        "redundancy": case.redundancy,
        "evaluation": "full-projective-nrc-v1",
        "syndrome": syndrome,
    }


def generate(binary, candidate_limit):
    records = []
    for case in ORBITS:
        request = request_for(case)
        command = [
            str(binary),
            "--compact",
            "--candidate-limit",
            str(candidate_limit),
            "simultaneous-locator",
        ]
        if case.root_kind is RootKind.INFINITY:
            command.append("--forbid-infinity")
        else:
            if case.root_value is None:
                raise RuntimeError("finite forbidden root lacks a value")
            command.extend(["--forbid-root", str(case.root_value)])
        result = run_json(command, request)
        if result.get("schema") != RESULT_SCHEMA:
            raise RuntimeError("unexpected simultaneous-locator result schema")
        if len(result["forbidden"]) != 1:
            raise RuntimeError("expected exactly one typed forbidden root")
        certificate = result["certificate"]
        if any(root in certificate["support"] for root in result["forbidden"]):
            raise RuntimeError("returned support contains the forbidden root")
        verified = run_json([str(binary), "--compact", "verify"], certificate)
        if verified.get("status") != "VALID":
            raise RuntimeError("certificate replay failed")
        records.append(
            {
                "orbit": case.orbit,
                "redundancy": case.redundancy,
                "carrier_indices": case.carrier_indices,
                "carrier_coefficients": case.coefficients,
                "forbidden": result["forbidden"],
                "candidates_examined": certificate["candidates_examined"],
                "support": certificate["support"],
                "locator_sha256": hashlib.sha256(
                    json.dumps(certificate["locator"], separators=(",", ":")).encode()
                ).hexdigest(),
                "certificate": certificate,
            }
        )
    return {
        "schema": SCHEMA,
        "authority_commit": SOFTWARE_AUTHORITY_COMMIT,
        "field": FIELD,
        "candidate_limit": candidate_limit,
        "orbit_count": len(records),
        "all_verified": True,
        "max_candidates_examined": max(row["candidates_examined"] for row in records),
        "records": records,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary", type=Path, default=DEFAULT_BINARY)
    parser.add_argument("--candidate-limit", type=int, default=2_000_000)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate(args.binary, args.candidate_limit)
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit("tracked output differs from deterministic regeneration")
        print("characteristic-seven pointed orbit certificates: PASS")
    else:
        args.output.write_text(encoded)


if __name__ == "__main__":
    main()
