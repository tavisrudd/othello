#!/usr/bin/env python3
"""Parallel aggregate replay for the q=121 C665 Borel contraction scan."""

import argparse
import concurrent.futures
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
CHECKER = HERE / "2026-07-29-c665-q121-borel-stream.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-borel-stream.json"


def run_order(order):
    completed = subprocess.run(
        [
            sys.executable,
            str(CHECKER),
            "--orders",
            str(order),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    result = json.loads(completed.stdout)
    assert result["ordinary_contraction_orders"] == [order]
    assert len(result["channels"]) == 1
    return result


def calculate(jobs):
    with concurrent.futures.ThreadPoolExecutor(max_workers=jobs) as executor:
        results = list(executor.map(run_order, range(1, 11)))
    results.sort(key=lambda result: result["ordinary_contraction_orders"][0])
    first = results[0]
    channels = [result["channels"][0] for result in results]
    detecting = next(
        (record for record in channels if not record["solvable"]), None
    )
    for result in results:
        for key in (
            "q",
            "p",
            "field_modulus",
            "subgroup",
            "subgroup_index_mod_p",
        ):
            assert result[key] == first[key]
    return {
        "schema": 1,
        "q": first["q"],
        "p": first["p"],
        "field_modulus": first["field_modulus"],
        "subgroup": first["subgroup"],
        "subgroup_index_mod_p": first["subgroup_index_mod_p"],
        "ordinary_contraction_orders": list(range(1, 11)),
        "channels": channels,
        "detecting_contraction_order": (
            None if detecting is None else detecting["contraction_order"]
        ),
        "conclusion": (
            "a valid ordinary contraction detects the restricted pullback"
            if detecting is not None
            else "all valid ordinary contractions are Borel-blind"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--jobs", type=int, default=4)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.jobs < 1:
        raise ValueError("--jobs must be positive")
    result = calculate(args.jobs)
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(encoded)
        print(f"wrote {CERTIFICATE.name}")
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print(f"checked {CERTIFICATE.name}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
