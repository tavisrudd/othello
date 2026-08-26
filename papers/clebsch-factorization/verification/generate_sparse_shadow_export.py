#!/usr/bin/env python3
"""Generate the paper-owned sparse-shadow export for Paper II."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from collections import deque
from pathlib import Path


HERE = Path(__file__).resolve().parent
EVIDENCE = HERE / "evidence"
PROFILE_PATH = EVIDENCE / "profile_incidence.json"
MATCHING_PATH = EVIDENCE / "matching_module.py"
REQUIRED_EXPORT = "papers/clebsch-factorization/verification/evidence/sparse_shadow_export.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MATCHING = load_module("sparse_shadow_matching", MATCHING_PATH)


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def closure(generators: list[tuple[int, ...]]) -> set[tuple[int, ...]]:
    identity = tuple(range(len(generators[0])))
    seen = {identity}
    pending = deque([identity])
    while pending:
        element = pending.popleft()
        for generator in generators:
            product = compose(generator, element)
            if product not in seen:
                seen.add(product)
                pending.append(product)
    return seen


def small_generating_set(group: list[tuple[int, ...]]) -> list[tuple[int, ...]]:
    generators: list[tuple[int, ...]] = []
    generated = {tuple(range(len(group[0])))}
    for candidate in group:
        if candidate not in generated:
            generators.append(candidate)
            generated = closure(generators)
            if len(generated) == len(group):
                break
    assert len(generated) == len(group) == 1320
    return generators


def edge_code(pair: tuple[int, int]) -> int:
    left, right = sorted(pair)
    return left * 12 + right


def compute() -> dict[str, object]:
    profile = json.loads(PROFILE_PATH.read_text(encoding="utf-8"))
    scout = json.loads((EVIDENCE / "matching_orbit_scout.json").read_text(encoding="utf-8"))
    scout_h3 = next(record for record in scout["types"] if record["type"] == "H3")

    conic, parameters = MATCHING.COXETER.conic_parameterization(11)
    full_group, psl_group = MATCHING.full_pgl(11, parameters)
    base = tuple(tuple(pair) for pair in scout_h3["coxeter_invariant_matching"])
    matchings = sorted({MATCHING.matching_image(element, base) for element in full_group})
    plus = {MATCHING.matching_image(element, base) for element in psl_group}
    minus = set(matchings) - plus
    assert len(matchings) == 22 and len(plus) == len(minus) == 11

    permutations = sorted(full_group)
    generators = small_generating_set(permutations)

    def blocks(sheet, sign):
        return [
            {"sign": sign, "support": sorted(edge_code(pair) for pair in matching), "weight": 1}
            for matching in sorted(sheet)
        ]

    cubic = profile["compressed_trade"]
    assert cubic["moments"][0]["nonzero"] is False
    assert cubic["moments"][1]["nonzero"] is False
    assert cubic["moments"][2]["nonzero"] is True
    assert cubic["cubic_first_coordinate_witness_mod_11"] == 6
    cubic_support = [
        index for index, value in enumerate(cubic["moments"][2]["coordinates"]) if value
    ]
    assert cubic_support == [0, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19]

    return {
        "schema": "sparse-shadow/v1",
        "profile": {
            "adapter": "paper_ii_trade",
            "input": {
                "gate": {
                    "enabled": True,
                    "reason": "paper-owned sparse-shadow export frozen",
                    "required_export": REQUIRED_EXPORT,
                },
                "source": {
                    "paper": "II",
                    "theorem": "quadratic trade, carrier gate, and cubic orientation",
                    "artifact": "papers/clebsch-factorization/verification/evidence/profile_incidence.json",
                    "sha256": hashlib.sha256(PROFILE_PATH.read_bytes()).hexdigest(),
                },
                "field": {
                    "characteristic": 11,
                    "degree": 1,
                    "modulus_coefficients_low_to_high": [],
                    "element_encoding": "least_nonnegative_residue",
                },
                "matching_count": 22,
                "trade_halves": [blocks(plus, 1), blocks(minus, -1)],
                "action": {
                    "kind": "vertex_permutations",
                    "degree": 12,
                    "generators": [list(generator) for generator in generators],
                },
                "carrier_hypothesis": "complete splitting into secants",
                "recovered_carrier": "the 22 H3 matching configurations on P1(F11)",
                "ambiguity": {"kind": "orientation_c2"},
                "odd_calibration": {
                    "name": "cubic_first_coordinate_mod_11",
                    "support": cubic_support,
                    "value": 6,
                },
                "minimality_collisions": [
                    {
                        "boundary": "degree_1",
                        "left_artifact": "positive_sheet_linear_moment",
                        "right_artifact": "negative_sheet_linear_moment",
                        "common_restricted_shadow_blake3": "d308a2f201977287aaea705410e4a01696c24728ed0dbd30e44ea43dcbd9dd5b",
                        "distinguishing_datum": "degree_3_cubic_orientation",
                    },
                    {
                        "boundary": "degree_2",
                        "left_artifact": "positive_sheet_quadratic_moment",
                        "right_artifact": "negative_sheet_quadratic_moment",
                        "common_restricted_shadow_blake3": "596b8c429d1cb24e8d9ba9a1ebd4ee76702f21953611482eb0a1e5d7e1fb4734",
                        "distinguishing_datum": "degree_3_cubic_orientation",
                    },
                ],
            },
        },
    }


def render(value: dict[str, object]) -> str:
    return json.dumps(value, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", type=Path)
    mode.add_argument("--check", type=Path)
    args = parser.parse_args()
    content = render(compute())
    if args.write:
        args.write.write_text(content, encoding="utf-8")
    else:
        assert args.check.read_text(encoding="utf-8") == content
        print("Paper II sparse-shadow export: PASS")


if __name__ == "__main__":
    main()
