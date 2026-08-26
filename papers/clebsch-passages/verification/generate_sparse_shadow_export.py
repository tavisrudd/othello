#!/usr/bin/env python3
"""Generate the paper-owned sparse-shadow export for the Clebsch passages."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import deque
from pathlib import Path


HERE = Path(__file__).resolve().parent
EVIDENCE = HERE / "evidence"
ORIENTATION_PATH = EVIDENCE / "orientation_source.json"
ALIGNED_PATH = EVIDENCE / "aligned_faithfulness.json"
REQUIRED_EXPORT = "verification/sparse_shadow_export.json"


def compose(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[index]] for index in range(len(left)))


def closure(generators: list[tuple[int, ...]], degree: int) -> set[tuple[int, ...]]:
    identity = tuple(range(degree))
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


def rational(numerator: int, denominator: int = 1) -> dict[str, int]:
    return {"denominator": denominator, "numerator": numerator}


def triangle_product(matrix: list[list[int]], triple: tuple[int, int, int]) -> int:
    left, middle, right = triple
    return matrix[left][middle] * matrix[middle][right] * matrix[right][left]


def aligned_four_sets(matrix: list[list[int]]) -> list[list[int]]:
    result = []
    for four_set in itertools.combinations(range(len(matrix)), 4):
        products = {
            triangle_product(matrix, triple)
            for triple in itertools.combinations(four_set, 3)
        }
        if len(products) == 1:
            result.append(list(four_set))
    return result


def compute() -> dict[str, object]:
    orientation = json.loads(ORIENTATION_PATH.read_text(encoding="utf-8"))
    aligned = json.loads(ALIGNED_PATH.read_text(encoding="utf-8"))
    matrix = orientation["conference"]
    assert len(matrix) == 6 and all(len(row) == 6 for row in matrix)
    assert all(
        sum(matrix[i][k] * matrix[k][j] for k in range(6))
        == (5 if i == j else 0)
        for i in range(6)
        for j in range(6)
    )
    four_sets = aligned_four_sets(matrix)
    assert four_sets == []
    assert orientation["triangle_coefficients"]["012"] == -1
    assert orientation["harmonic_input"]["witness"]["y"] == [4, -1, -1, -1, -1]
    assert orientation["golden_field"]["polynomial"] == "t^2-t-1"

    action_generators = [
        (1, 0, 2, 3, 4, 5),
        (1, 2, 3, 4, 5, 0),
    ]
    assert len(closure(action_generators, 6)) == 720

    witness = aligned["six_point_witness"]
    shared = witness["shared_aligned_family"]
    assert witness["distinct_two_graphs"] and witness["not_complementary"]
    assert shared == [[0, 1, 2, 5], [0, 1, 3, 4]]

    return {
        "schema": "sparse-shadow/v1",
        "profile": {
            "adapter": "paper_iii_four_shadow",
            "input": {
                "gate": {
                    "enabled": True,
                    "reason": "paper-owned branch-fibre and aligned-four-set export frozen",
                    "required_export": REQUIRED_EXPORT,
                },
                "source": {
                    "paper": "III",
                    "theorem": "arithmetic descent, four-shadow recognition, and calibrated two-graph return",
                    "artifact": "verification/evidence/orientation_source.json",
                    "sha256": hashlib.sha256(ORIENTATION_PATH.read_bytes()).hexdigest(),
                },
                "branch_sextic": "J_0=0",
                "rational_fibre_point": [rational(value, 5) for value in [4, -1, -1, -1, -1]],
                "fibre_quadratic_algebra": "Q[t]/(t^2-t-1)",
                "vertex_count": 6,
                "aligned_four_sets": four_sets,
                "action": {
                    "kind": "vertex_permutations",
                    "degree": 6,
                    "generators": [list(value) for value in action_generators],
                },
                "recovered_twist": "z^2=5J_0",
                "recovered_two_graph": "the order-six conference switching class recovered by four-shadow proportionality",
                "twist_ambiguity": {
                    "kind": "homogeneous_fibre",
                    "numerator": "Q^times",
                    "denominator": "(Q^times)^2",
                },
                "complement_ambiguity": {"kind": "orientation_c2"},
                "calibrated_triangle_product": -1,
                "minimality_collisions": [
                    {
                        "boundary": "six_vertices_aligned_family",
                        "left_artifact": "aligned_faithfulness.six_point_witness.graph_G",
                        "right_artifact": "aligned_faithfulness.six_point_witness.graph_H",
                        "common_restricted_shadow_blake3": "c7bcc87f15491ddc26ab3eb04aaca0dc4b2a6961aa6d15f0e1a2b75d24718a87",
                        "distinguishing_datum": "four-shadow conference proportionality plus calibrated triangle product",
                    }
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
        print("Clebsch-passages sparse-shadow export: PASS")


if __name__ == "__main__":
    main()
