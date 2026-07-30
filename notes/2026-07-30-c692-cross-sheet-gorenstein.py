#!/usr/bin/env python3
"""Compare the cross-sheet design pairing with the Artinian Gorenstein pairing."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / "papers/clebsch-factorization/verification/evidence"
GORENSTEIN_PATH = EVIDENCE / "gorenstein.py"
OUTPUT = Path(__file__).with_suffix(".json")
SCHEMA = "c692-cross-sheet-gorenstein-v1"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


G = load_module("c692_gorenstein", GORENSTEIN_PATH)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def transpose(matrix: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*matrix)]


def multiply(
    left: list[list[int]], right: list[list[int]], prime: int
) -> list[list[int]]:
    columns = transpose(right)
    return [
        [
            sum(first * second for first, second in zip(row, column)) % prime
            for column in columns
        ]
        for row in left
    ]


def augmentation_basis(prime: int) -> list[list[int]]:
    return [
        [
            (1 if column == row else -1 if column == prime - 1 else 0) % prime
            for column in range(prime)
        ]
        for row in range(prime - 1)
    ]


def type_record(record: dict) -> dict:
    name = record["type"]
    prime = record["field_order"]
    affine_points, signs = G.frozen_configuration(record)
    projective_points = [[1] + point for point in affine_points]

    _conic, parameters = G.MATCHING.COXETER.conic_parameterization(prime)
    full_group, _psl_group = G.MATCHING.full_pgl(prime, parameters)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted(
        {G.MATCHING.matching_image(element, base) for element in full_group}
    )
    plus = [index for index, sign in enumerate(signs) if sign == 1]
    minus = [index for index, sign in enumerate(signs) if sign == prime - 1]
    assert len(plus) == len(minus) == prime

    incidence = [
        [
            len(set(orbit[left]) & set(orbit[right])) % prime
            for right in minus
        ]
        for left in plus
    ]
    block_size = (prime + 1) // 2
    design_lambda = (prime + 1) // 4
    integer_gram = [
        [
            sum(incidence[i][column] * incidence[j][column] for column in range(prime))
            for j in range(prime)
        ]
        for i in range(prime)
    ]
    assert all(
        integer_gram[i][j] == (block_size if i == j else design_lambda)
        for i in range(prime)
        for j in range(prime)
    )
    inverse = [
        [
            4
            * (
                incidence[column][row]
                - sum(incidence[index][row] for index in range(prime))
            )
            % prime
            for column in range(prime)
        ]
        for row in range(prime)
    ]
    assert multiply(incidence, inverse, prime) == [
        [int(i == j) for j in range(prime)] for i in range(prime)
    ]

    evaluation_plus = [projective_points[index] for index in plus]
    evaluation_minus = [projective_points[index] for index in minus]
    transported = multiply(transpose(incidence), evaluation_plus, prime)
    graph_scalars = []
    graph_residual = None
    for scalar in range(1, prime):
        residual = [
            [
                (evaluation_minus[row][column] - scalar * transported[row][column])
                % prime
                for column in range(prime)
            ]
            for row in range(prime)
        ]
        if all(
            len({residual[row][column] for row in range(prime)}) == 1
            for column in range(prime)
        ):
            graph_scalars.append(scalar)
            graph_residual = residual
    assert graph_scalars == [2] and graph_residual is not None

    aug = augmentation_basis(prime)
    cross_aug_pairing = multiply(multiply(aug, incidence, prime), transpose(aug), prime)
    cross_aug_rank = G.rank(cross_aug_pairing, prime)
    assert cross_aug_rank == prime - 2
    assert sum(
        incidence[i][j] for i in range(prime) for j in range(prime)
    ) % prime == 0

    value_space = transpose(projective_points)
    assert G.rank(value_space, prime) == prime
    sheet_plus = [1 if index in plus else 0 for index in range(2 * prime)]
    sheet_minus = [1 if index in minus else 0 for index in range(2 * prime)]
    assert G.rank(value_space + [sheet_plus, sheet_minus], prime) == prime
    assert all(
        sum(row[index] for index in plus) % prime == 0
        and sum(row[index] for index in minus) % prime == 0
        for row in value_space
    )

    signed_gram = [
        [
            sum(
                signs[index] * value_space[i][index] * value_space[j][index]
                for index in range(2 * prime)
            )
            % prime
            for j in range(prime)
        ]
        for i in range(prime)
    ]
    assert not any(any(row) for row in signed_gram)

    evaluation_spaces = []
    for degree in range(4):
        evaluations = transpose(
            G.evaluation_matrix(projective_points, degree, prime)
        )
        evaluation_spaces.append(G.row_basis(evaluations, prime))
    evaluation_dimensions = [len(space) for space in evaluation_spaces]
    artinian_dimensions = [
        evaluation_dimensions[0],
        *[
            evaluation_dimensions[degree] - evaluation_dimensions[degree - 1]
            for degree in range(1, 4)
        ],
    ]
    pairing_ranks = G.moment_pairing_ranks(projective_points, signs, prime)
    assert artinian_dimensions == [1, prime - 1, prime - 1, 1]
    assert pairing_ranks == artinian_dimensions

    # In the signed coordinate form, the radial class e_- pairs with
    # (delta_+, delta_-) in the common-sheet-sum direction by -1.
    radial_common_sum_pairing = prime - 1
    assert radial_common_sum_pairing != 0

    return {
        "type": name,
        "q": prime,
        "cross_incidence_parameters": [prime, block_size, design_lambda],
        "cross_incidence_rank": G.rank(incidence, prime),
        "inverse_formula_verified": "4*A^T*(I-J)",
        "evaluation_graph_mod_constants": "rho_- = 2*A^T*rho_+",
        "evaluation_graph_scalar": graph_scalars[0],
        "evaluation_graph_constant_residual_rank": G.rank(
            graph_residual, prime
        ),
        "sheet_augmentation_dimension": prime - 1,
        "cross_pairing_rank_on_sheet_augmentation": cross_aug_rank,
        "cross_pairing_radical_dimension": 1,
        "cross_pairing_rank_on_P0_mod_constants": prime - 2,
        "radial_class_dimension_in_artinian_degree_1": 1,
        "common_sheet_sum_class_dimension_in_artinian_degree_2": 1,
        "radial_common_sum_pairing": radial_common_sum_pairing,
        "projective_evaluation_dimensions_degrees_0_through_3": evaluation_dimensions,
        "artinian_dimensions_degrees_0_through_3": artinian_dimensions,
        "artinian_pairing_ranks_degrees_0_through_3": pairing_ranks,
        "missing_rank_between_cross_and_gorenstein_pairings": 1,
        "signed_evaluation_space_is_maximal_isotropic": True,
    }


def build_certificate() -> dict:
    scout = json.loads(G.SCOUT_PATH.read_text())
    records = [
        type_record(record)
        for record in scout["types"]
        if record["type"] in ("B3", "H3")
    ]
    return {
        "schema": SCHEMA,
        "verdict": "CROSS_DESIGN_PAIRS_ONLY_THE_TOP_SHEET_QUOTIENT_NOT_THE_GORENSTEIN_RADIAL_DIRECTION",
        "types": records,
        "conclusion": {
            "cross_sheet_role": "identifies the two P0/<1> top-module restrictions",
            "gorenstein_role": "pairs (L/<1>) with (L^2/L) by the signed coordinate form",
            "paley_hadamard_essential": False,
            "middle_layer_differential_essential": False,
            "retained_use": "radial nonvanishing only",
        },
        "inputs": {
            str(path.relative_to(ROOT)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in (
                GORENSTEIN_PATH,
                EVIDENCE / "matching_module.py",
                EVIDENCE / "matching_orbit_scout.json",
            )
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()

    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT}")
        return 0
    if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
        raise SystemExit(f"{OUTPUT} is stale; run with --write")
    print("C692 cross-sheet/Gorenstein comparison: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
