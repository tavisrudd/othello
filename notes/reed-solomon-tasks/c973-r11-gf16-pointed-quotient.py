#!/usr/bin/env python3
"""Generate the exact pointed GF(16) R11 Lucas-carrier quotient certificate."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import subprocess
from itertools import combinations, product
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
HERE = Path(__file__).resolve().parent
C531_PATH = ROOT / "notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py"
DEFAULT_BINARY = (
    ROOT
    / "papers/high_weight_grs_cosets/software/projective-reed-solomon/target/release/projective-reed-solomon"
)
DEFAULT_OUTPUT = HERE / "c973-r11-gf16-pointed-quotient.json"
SCHEMA = "c973-r11-gf16-pointed-quotient-v1"
Q = 16
MODULUS = 0b10011
CARRIER_SUPPORT = tuple(range(3, 8))

SPEC = importlib.util.spec_from_file_location("c531", C531_PATH)
assert SPEC is not None and SPEC.loader is not None
C531 = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(C531)


def gf_sum_product(total: int, left: int, right: int) -> int:
    return total ^ C531.gf_mul(left, right, MODULUS)


def evaluate_action_entry(
    source: int, target: int, matrix: tuple[int, int, int, int]
) -> int:
    a, b, c, d = matrix
    total = 0
    for ea, eb, ec, ed in C531.action_entry(source, target):
        term = C531.gf_pow(a, ea, MODULUS)
        term = C531.gf_mul(term, C531.gf_pow(b, eb, MODULUS), MODULUS)
        term = C531.gf_mul(term, C531.gf_pow(c, ec, MODULUS), MODULUS)
        term = C531.gf_mul(term, C531.gf_pow(d, ed, MODULUS), MODULUS)
        total ^= term
    return total


def carrier_matrix(
    matrix: tuple[int, int, int, int]
) -> tuple[tuple[int, ...], ...]:
    return tuple(
        tuple(evaluate_action_entry(source, target, matrix) for target in CARRIER_SUPPORT)
        for source in CARRIER_SUPPORT
    )


def canonical(point: tuple[int, ...]) -> tuple[int, ...]:
    return C531.canonical(point, MODULUS)


def act(
    point: tuple[int, ...], matrix: tuple[tuple[int, ...], ...]
) -> tuple[int, ...]:
    out = []
    for target in range(len(CARRIER_SUPPORT)):
        value = 0
        for source in range(len(CARRIER_SUPPORT)):
            value = gf_sum_product(value, point[source], matrix[source][target])
        out.append(value)
    return canonical(tuple(out))


def projective_points() -> set[tuple[int, ...]]:
    points: set[tuple[int, ...]] = set()
    width = len(CARRIER_SUPPORT)
    for pivot in range(width):
        for tail in product(range(Q), repeat=width - pivot - 1):
            points.add((0,) * pivot + (1,) + tail)
    return points


def orbit_representatives() -> list[tuple[int, ...]]:
    primitive = C531.primitive_element(Q, MODULUS)
    generators = [(1, 1, 0, 1), (primitive, 0, 0, 1)]
    matrices = [carrier_matrix(generator) for generator in generators]
    unseen = projective_points()
    representatives: list[tuple[int, ...]] = []
    while unseen:
        representative = min(unseen)
        orbit = {representative}
        frontier = [representative]
        while frontier:
            point = frontier.pop()
            for matrix in matrices:
                image = act(point, matrix)
                if image not in orbit:
                    orbit.add(image)
                    frontier.append(image)
        unseen.difference_update(orbit)
        representatives.append(representative)
    return representatives


def syndrome(point: tuple[int, ...]) -> list[int]:
    out = [0] * 11
    for index, coefficient in zip(CARRIER_SUPPORT, point):
        out[index] = coefficient
    return out


def root_polynomial(roots: tuple[int, ...]) -> list[int]:
    coefficients = [1]
    for root in roots:
        extended = [0] * (len(coefficients) + 1)
        for index, coefficient in enumerate(coefficients):
            extended[index] ^= C531.gf_mul(coefficient, root, MODULUS)
            extended[index + 1] ^= coefficient
        coefficients = extended
    return coefficients


def dot(point: tuple[int, ...], row: list[int]) -> int:
    value = 0
    for left, right in zip(point, row):
        value ^= C531.gf_mul(left, right, MODULUS)
    return value


def is_locator(point: tuple[int, ...], roots: tuple[int, ...]) -> bool:
    degree = len(roots)
    coefficients = root_polynomial(roots)
    first_shift = 3 - (11 - degree - 1)
    for shift in range(first_shift, 4):
        padded = [0] * max(0, -shift) + coefficients
        start = max(shift, 0)
        row = padded[start : start + 5]
        row += [0] * (5 - len(row))
        if dot(point, row) != 0:
            return False
    return True


def find_finite_locator(point: tuple[int, ...]) -> tuple[tuple[int, ...] | None, int]:
    examined = 0
    for degree in range(1, 10):
        for roots in combinations(range(Q), degree):
            examined += 1
            if is_locator(point, roots):
                return roots, examined
    return None, examined


def run_json(command: list[str], payload: dict[str, object]) -> dict[str, object]:
    completed = subprocess.run(
        command,
        input=json.dumps(payload, sort_keys=True),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError(completed.stderr.strip())
    return json.loads(completed.stdout)


def generate(binary: Path, candidate_limit: int) -> dict[str, object]:
    records = []
    for representative in orbit_representatives():
        request = {
            "schema": "projective-reed-solomon-request-v1",
            "field": {
                "p": 2,
                "degree": 4,
                "modulus": [1, 1, 0, 0, 1],
                "encoding": "polynomial-basis-base-p-integer-v1",
            },
            "redundancy": 11,
            "evaluation": "full-projective-nrc-v1",
            "syndrome": syndrome(representative),
        }
        try:
            result = run_json(
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
            if "no split locator avoiding the prescribed roots was found through degree 9" not in message:
                raise RuntimeError(f"representative {representative}: {error}") from error
            classified = run_json([str(binary), "--compact", "classify"], request)
            certificate = classified.get("locator_certificate")
            if classified.get("status") != "NOT_DEEP" or certificate is None:
                records.append(
                    {
                        "representative": list(representative),
                        "status": "NO_POINTED_LOCATOR",
                    }
                )
                continue
            support = certificate["support"]
            if "infinity" in support:
                finite_support, examined = find_finite_locator(representative)
                if finite_support is None:
                    records.append(
                        {
                            "representative": list(representative),
                            "status": "NO_POINTED_LOCATOR",
                        }
                    )
                else:
                    records.append(
                        {
                            "representative": list(representative),
                            "status": "EXHAUSTIVE_LOWER_DEGREE_WITNESS",
                            "support": list(finite_support),
                            "candidates_examined": examined,
                        }
                    )
                continue
            verified = run_json([str(binary), "--compact", "verify"], certificate)
            if verified.get("status") != "VALID":
                raise RuntimeError("public verifier rejected fallback certificate")
            records.append(
                {
                    "representative": list(representative),
                    "status": "LOWER_DEGREE_WITNESS",
                    "support": [root["finite"] for root in support],
                    "candidates_examined": certificate["candidates_examined"],
                }
            )
            continue
        if result.get("schema") != "projective-reed-solomon-simultaneous-locator-v1":
            raise RuntimeError("unexpected locator-result schema")
        certificate = result["certificate"]
        verified = run_json([str(binary), "--compact", "verify"], certificate)
        if verified.get("status") != "VALID":
            raise RuntimeError("public verifier rejected generated certificate")
        support = certificate["support"]
        if "infinity" in support or len(support) != 9:
            raise RuntimeError("locator is not a finite squarefree nonic")
        records.append(
            {
                "representative": list(representative),
                "status": "WITNESS",
                "support": [root["finite"] for root in support],
                "candidates_examined": certificate["candidates_examined"],
            }
        )
    return {
        "schema": SCHEMA,
        "field": "GF(2)[x]/(x^4+x+1)",
        "field_order": Q,
        "modulus_integer": MODULUS,
        "carrier_support": list(CARRIER_SUPPORT),
        "marked_root": "infinity",
        "borel_generators": [
            [1, 1, 0, 1],
            [C531.primitive_element(Q, MODULUS), 0, 0, 1],
        ],
        "projective_carrier_points": (Q**5 - 1) // (Q - 1),
        "orbit_count": len(records),
        "candidate_limit": candidate_limit,
        "witness_orbits": sum(
            record["status"]
            in {"WITNESS", "LOWER_DEGREE_WITNESS", "EXHAUSTIVE_LOWER_DEGREE_WITNESS"}
            for record in records
        ),
        "degree_nine_witness_orbits": sum(
            record["status"] == "WITNESS" for record in records
        ),
        "lower_degree_witness_orbits": sum(
            record["status"] in {"LOWER_DEGREE_WITNESS", "EXHAUSTIVE_LOWER_DEGREE_WITNESS"}
            for record in records
        ),
        "no_pointed_locator_orbits": sum(
            record["status"] == "NO_POINTED_LOCATOR" for record in records
        ),
        "maximum_candidates_examined": max(
            record["candidates_examined"]
            for record in records
            if record["status"]
            in {"WITNESS", "LOWER_DEGREE_WITNESS", "EXHAUSTIVE_LOWER_DEGREE_WITNESS"}
        ),
        "c531_source_sha256": hashlib.sha256(C531_PATH.read_bytes()).hexdigest(),
        "binary_sha256": hashlib.sha256(binary.read_bytes()).hexdigest(),
        "records": records,
    }


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
        print(f"C973 GF(16) pointed quotient: PASS ({result['orbit_count']} orbits)")
    else:
        args.output.write_text(encoded)
        print(
            json.dumps(
                {
                    "output": str(args.output),
                    "orbit_count": result["orbit_count"],
                    "maximum_candidates_examined": result["maximum_candidates_examined"],
                },
                sort_keys=True,
            )
        )


if __name__ == "__main__":
    main()
