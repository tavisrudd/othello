#!/usr/bin/env python3
"""Generate an independently checked bounded Z[t] certificate fixture."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


def trim(coefficients: list[int]) -> list[int]:
    while len(coefficients) > 1 and coefficients[-1] == 0:
        coefficients.pop()
    return coefficients


def add(left: list[int], right: list[int], *, subtract: bool = False) -> list[int]:
    result = [0] * max(len(left), len(right))
    for index, coefficient in enumerate(left):
        result[index] += coefficient
    sign = -1 if subtract else 1
    for index, coefficient in enumerate(right):
        result[index] += sign * coefficient
    return trim(result)


def multiply(left: list[int], right: list[int]) -> list[int]:
    result = [0] * (len(left) + len(right) - 1)
    for left_index, left_coefficient in enumerate(left):
        for right_index, right_coefficient in enumerate(right):
            result[left_index + right_index] += left_coefficient * right_coefficient
    return trim(result)


def evaluate(coefficients: list[int], parameter: int) -> int:
    value = 0
    for coefficient in reversed(coefficients):
        value = value * parameter + coefficient
    return value


def main() -> None:
    scale = 1 << 80
    nodes: list[dict[str, object]] = [
        {"op": "literal", "coefficients": ["0", "2"]},
        {"op": "literal", "coefficients": ["0", str(scale)]},
        {"op": "literal", "coefficients": [str(scale)]},
        {"op": "multiply", "left": 0, "right": 2},
        {"op": "literal", "coefficients": ["2"]},
        {"op": "multiply", "left": 1, "right": 4},
        {"op": "subtract", "left": 3, "right": 5},
    ]

    values: list[list[int]] = []
    for index, node in enumerate(nodes):
        operation = node["op"]
        if operation == "literal":
            value = [int(coefficient) for coefficient in node["coefficients"]]
        else:
            left = int(node["left"])
            right = int(node["right"])
            assert left < index and right < index
            if operation == "multiply":
                value = multiply(values[left], values[right])
            elif operation == "subtract":
                value = add(values[left], values[right], subtract=True)
            else:
                raise AssertionError(f"unsupported operation {operation}")
        values.append(trim(value))

    assert values[0] == [0, 2]
    assert values[6] == [0]
    assert all(coefficient >= 0 for coefficient in values[1])
    assert evaluate(values[1], 1) >= 1

    cover_modulus = 6
    exceptional = [1, 3, 5]
    covered = [
        residue
        for residue in range(cover_modulus)
        if residue in exceptional or residue % 2 == 0
    ]
    assert covered == list(range(cover_modulus))

    payload = b"independent bounded polynomial fixture\n"
    fixture = {
        "schema": "ergodis-parametric-certificate-v1",
        "payload_hex": payload.hex(),
        "payload_sha256": hashlib.sha256(payload).hexdigest(),
        "family": {
            "name": "even-scaled",
            "modulus": 2,
            "residue": 0,
            "parameter_minimum": 1,
            "class_node": 0,
            "identity_roots": [6],
            "positive_roots": [1],
            "nodes": nodes,
        },
        "cover": {
            "claim_minimum": 2,
            "modulus": cover_modulus,
            "exceptional_residues": exceptional,
        },
        "expected": {
            "identity_coefficients": ["0"],
            "family_count": 1,
            "payload_count": 1,
            "composition_nodes": 4,
        },
    }
    output = Path(__file__).resolve().parents[1] / "tests/fixtures/parametric_certificate.json"
    output.write_text(json.dumps(fixture, indent=2, sort_keys=True) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
