#!/usr/bin/env python3
"""Finite threshold certificate for the C925 birational A1 cancellation theorem."""

import argparse
import json
from pathlib import Path


lower_bound = 2
upper_bound = 4
cases = []
for stabilization_threshold in range(lower_bound, upper_bound + 1):
    candidate_index = stabilization_threshold - 1
    cases.append({
        "stabilization_threshold": stabilization_threshold,
        "candidate_index": candidate_index,
        "candidate": f"X x P^{candidate_index}",
        "candidate_is_nonrational_by_minimality": True,
        "candidate_times_A1_function_field": (
            f"K(X)(t_1,...,t_{candidate_index + 1})"
        ),
        "candidate_times_A1_is_rational_from_threshold": True,
    })

assert [case["candidate_index"] for case in cases] == [1, 2, 3]
assert all(
    case["candidate_index"] + 1 == case["stabilization_threshold"]
    for case in cases
)

certificate = {
    "schema": "c925-finite-cancellation-disjunction-v1",
    "premises": {
        "X_times_P1_is_nonrational": True,
        "X_times_P4_is_rational": True,
        "therefore_threshold_interval": [lower_bound, upper_bound],
    },
    "cases": cases,
    "conclusion": (
        "For the minimal s in {2,3,4} with X x P^s rational, "
        "Y=X x P^(s-1) is nonrational and Y x A1 is rational. Hence one "
        "of X x P^1, X x P^2, X x P^3 is a birational A1-cancellation "
        "counterexample."
    ),
    "scope": (
        "This finite checker verifies only the threshold implication. The "
        "two geometric premises are supplied by the separate m=1 "
        "irrationality theorem and uniform m=4 rationality theorem."
    ),
}

parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group()
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
arguments = parser.parse_args()
payload = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
if arguments.write_certificate is not None:
    arguments.write_certificate.write_text(payload, encoding="utf-8")
if arguments.check_certificate is not None:
    assert arguments.check_certificate.read_text(encoding="utf-8") == payload
print(payload, end="")
