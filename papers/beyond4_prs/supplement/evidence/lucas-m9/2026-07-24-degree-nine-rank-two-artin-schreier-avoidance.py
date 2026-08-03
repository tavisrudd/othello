#!/usr/bin/env python3
"""Generate/check the compact degree-nine rank-two certificate.

The structural theorem is proved in the accompanying manuscript.  This program checks
the only new bounded field, F_64: the five rational A5 twists, their complete
orbit mass, Frobenius fusion, and one split squarefree divisor per twist.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import deque
from pathlib import Path


HERE = Path(__file__).resolve().parent
STEM = "2026-07-24-degree-nine-rank-two-artin-schreier-avoidance"
LUCAS_ACTION = HERE / "2026-07-23-degree-nine-lucas-carrier-pgl2-strata.py"
OUTPUT = HERE / f"{STEM}.json"


def load_lucas_action():
    spec = importlib.util.spec_from_file_location("lucas_action_frozen", LUCAS_ACTION)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


TWISTS = (
    {
        "label": "1A",
        "representative": (1, 0, 1, 1),
        "centralizer_order": 60,
        "roots": (6, 31, 50, 51, 52, 56, 61, 63),
    },
    {
        "label": "2A",
        "representative": (1, 0, 0, 1),
        "centralizer_order": 4,
        "roots": (7, 18, 30, 32, 37, 48, 51, 64),
    },
    {
        "label": "3A",
        "representative": (1, 0, 1, 3),
        "centralizer_order": 3,
        "roots": (6, 7, 9, 32, 39, 41, 44, 45),
    },
    {
        "label": "5A",
        "representative": (1, 0, 1, 6),
        "centralizer_order": 5,
        "roots": (0, 6, 12, 28, 29, 44, 58, 59),
    },
    {
        "label": "5B",
        "representative": (1, 0, 1, 11),
        "centralizer_order": 5,
        "roots": (3, 12, 13, 18, 26, 30, 53, 62),
    },
)


def orbit(seed, generators, module, modulus):
    seen = {seed}
    queue = deque([seed])
    while queue:
        point = queue.popleft()
        for generator in generators:
            image = module.matrix_action(point, generator, modulus)
            if image not in seen:
                seen.add(image)
                queue.append(image)
    return seen


def generate() -> dict[str, object]:
    module = load_lucas_action()
    q = 64
    modulus = module.first_irreducible(6)
    primitive = module.primitive_element(q, modulus)
    generators = (
        (1, 1, 0, 1),
        (primitive, 0, 0, 1),
        (0, 1, 1, 0),
    )
    group_order = q * (q * q - 1)
    occupied: set[tuple[int, int, int, int]] = set()
    records = []
    orbit_sets = {}
    for item in TWISTS:
        representative = item["representative"]
        assert module.determinant(representative, modulus) != 0
        points = orbit(representative, generators, module, modulus)
        assert occupied.isdisjoint(points)
        occupied.update(points)
        expected_size = group_order // item["centralizer_order"]
        assert len(points) == expected_size
        orbit_sets[item["label"]] = points

        finite_roots = tuple(root for root in item["roots"] if root != q)
        assert len(set(item["roots"])) == 8
        coefficients = module.roots_to_polynomial(finite_roots, modulus)
        assert module.in_kernel(representative, coefficients, modulus)
        records.append(
            {
                "label": item["label"],
                "representative_hex": [hex(x) for x in representative],
                "centralizer_order": item["centralizer_order"],
                "orbit_size": len(points),
                "roots_hex": ["inf" if x == q else hex(x) for x in item["roots"]],
                "coefficients_low_to_high_hex": [hex(x) for x in coefficients],
            }
        )
    assert len(occupied) == group_order

    frobenius = lambda point: module.canonical(
        tuple(module.gf_mul(x, x, modulus) for x in point), modulus
    )
    assert frobenius(TWISTS[0]["representative"]) in orbit_sets["1A"]
    assert frobenius(TWISTS[1]["representative"]) in orbit_sets["2A"]
    assert frobenius(TWISTS[2]["representative"]) in orbit_sets["3A"]
    assert frobenius(TWISTS[3]["representative"]) in orbit_sets["5B"]
    assert frobenius(TWISTS[4]["representative"]) in orbit_sets["5A"]

    lucas_action_sha256 = hashlib.sha256(LUCAS_ACTION.read_bytes()).hexdigest()
    return {
        "schema": "degree-nine-rank-two-avoidance-v1",
        "structural_bound": {
            "five_root_bad_degree": 102,
            "first_theorem_power_of_two": 128,
            "fiber_genus_upper_bound": 1,
            "deleted_x_values_upper_bound": 23,
            "deleted_curve_points_upper_bound": 48,
            "hasse_lower_at_q64": 49,
        },
        "frozen_input": {
            "path": LUCAS_ACTION.name,
            "sha256": lucas_action_sha256,
        },
        "bounded_field": {
            "q": q,
            "modulus_hex": hex(modulus),
            "primitive_hex": hex(primitive),
            "PGL2_order": group_order,
            "rank_two_partition_size": len(occupied),
            "twists": records,
            "coefficient_frobenius": {
                "fixed": ["1A", "2A", "3A"],
                "swapped_pair": ["5A", "5B"],
            },
        },
    }


def canonical_bytes(data: dict[str, object]) -> bytes:
    return (json.dumps(data, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = canonical_bytes(generate())
    if args.check:
        assert OUTPUT.read_bytes() == rendered
    else:
        OUTPUT.write_bytes(rendered)


if __name__ == "__main__":
    main()
