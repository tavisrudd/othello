#!/usr/bin/env python3
"""Deterministic pointed R11 probe through the public toolkit CLI."""

import argparse
import hashlib
import json
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
DEFAULT_BINARY = ROOT / "papers/beyond4_prs/software/projective-reed-solomon/target/release/projective-reed-solomon"
DEFAULT_OUTPUT = Path(__file__).with_name("c974-pointed-r11-probe.json")
SCHEMA = "c974-pointed-r11-probe-v1"


FIELDS = [
    ("gf16", {"p": 2, "degree": 4, "modulus": [1, 1, 0, 0, 1], "encoding": "polynomial-basis-base-p-integer-v1"}, [3, 4, 5, 6, 7]),
    ("gf27", {"p": 3, "degree": 3, "modulus": [1, 2, 0, 1], "encoding": "polynomial-basis-base-p-integer-v1"}, [2, 3, 4, 5, 6, 7, 8]),
    ("gf49", {"p": 7, "degree": 2, "modulus": [1, 0, 1], "encoding": "polynomial-basis-base-p-integer-v1"}, [4, 5, 6]),
]


def representative_vectors(q, support):
    width = len(support)
    vectors = [
        ("dense-one", [1] * width),
        ("dense-deterministic", [1 + ((3 * i + 1) % (q - 1)) for i in range(width)]),
    ]
    for position in sorted({0, width // 2, width - 1}):
        vector = [0] * width
        vector[position] = 1
        vectors.append((f"basis-{support[position]}", vector))
    return vectors


def syndrome_from_carrier(support, coefficients):
    syndrome = [0] * 11
    for index, coefficient in zip(support, coefficients):
        syndrome[index] = coefficient
    return syndrome


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
        return None, completed.stderr.strip()
    return json.loads(completed.stdout), None


def generate(binary, candidate_limit, selected_fields, representative_count):
    commit = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=ROOT,
        text=True,
        stdout=subprocess.PIPE,
        check=True,
    ).stdout.strip()
    records = []
    fields = [entry for entry in FIELDS if not selected_fields or entry[0] in selected_fields]
    for field_name, field, carrier_support in fields:
        q = field["p"] ** field["degree"]
        representatives = representative_vectors(q, carrier_support)[:representative_count]
        for representative, coefficients in representatives:
            request = {
                "schema": "projective-reed-solomon-request-v1",
                "field": field,
                "redundancy": 11,
                "evaluation": "full-projective-nrc-v1",
                "syndrome": syndrome_from_carrier(carrier_support, coefficients),
            }
            for forbidden in list(range(q)) + ["infinity"]:
                command = [
                    str(binary),
                    "--candidate-limit",
                    str(candidate_limit),
                    "--compact",
                    "simultaneous-locator",
                ]
                if forbidden == "infinity":
                    command.append("--forbid-infinity")
                else:
                    command.extend(["--forbid-root", str(forbidden)])
                certificate, error = run_json(command, request)
                record = {
                    "field": field_name,
                    "representative": representative,
                    "syndrome": request["syndrome"],
                    "forbidden": forbidden,
                }
                if certificate is None:
                    record.update({"status": "NO_WITNESS_WITHIN_LIMIT", "error": error})
                else:
                    support = certificate["support"]
                    forbidden_json = "Infinity" if forbidden == "infinity" else {"Finite": forbidden}
                    if forbidden_json in support:
                        raise RuntimeError("returned support contains the forbidden root")
                    verified, verify_error = run_json(
                        [str(binary), "--compact", "verify"], certificate
                    )
                    if verify_error or verified.get("status") != "VALID":
                        raise RuntimeError(f"certificate replay failed: {verify_error}")
                    record.update(
                        {
                            "status": "WITNESS",
                            "candidates_examined": certificate["candidates_examined"],
                            "support": support,
                            "locator_sha256": hashlib.sha256(
                                json.dumps(certificate["locator"], separators=(",", ":")).encode()
                            ).hexdigest(),
                        }
                    )
                records.append(record)
    summary = {}
    for field_name, _, _ in fields:
        field_records = [record for record in records if record["field"] == field_name]
        witnesses = [record for record in field_records if record["status"] == "WITNESS"]
        summary[field_name] = {
            "probes": len(field_records),
            "witnesses": len(witnesses),
            "failures": len(field_records) - len(witnesses),
            "max_candidates_examined": max(
                (record["candidates_examined"] for record in witnesses), default=0
            ),
        }
    return {
        "schema": SCHEMA,
        "authority_commit": commit,
        "candidate_limit": candidate_limit,
        "scope": f"{representative_count} deterministic dense carrier representatives times every projective forbidden root in {','.join(name for name, _, _ in fields)}",
        "summary": summary,
        "records": records,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--binary", type=Path, default=DEFAULT_BINARY)
    parser.add_argument("--candidate-limit", type=int, default=1_000_000)
    parser.add_argument("--field", action="append", choices=[name for name, _, _ in FIELDS])
    parser.add_argument("--representatives", type=int, default=2)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = generate(args.binary, args.candidate_limit, args.field, args.representatives)
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text() != encoded:
            raise SystemExit("tracked output differs from deterministic regeneration")
        print("pointed R11 probe: PASS")
    else:
        args.output.write_text(encoded)


if __name__ == "__main__":
    main()
