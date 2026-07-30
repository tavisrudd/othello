#!/usr/bin/env python3
"""Independent replay of the C692 pairing-rank mismatch."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
EVIDENCE = ROOT / "papers/clebsch-factorization/verification/evidence"
REPLAY_PATH = EVIDENCE / "gorenstein_replay.py"
CERTIFICATE = Path(__file__).with_name(
    "2026-07-30-c692-cross-sheet-gorenstein.json"
)


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


R = load_module("c692_gorenstein_replay", REPLAY_PATH)


def transpose(matrix: list[list[int]]) -> list[list[int]]:
    return [list(column) for column in zip(*matrix)]


def product(
    left: list[list[int]], right: list[list[int]], prime: int
) -> list[list[int]]:
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % prime
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def rank(matrix: list[list[int]], prime: int) -> int:
    return len(R.rref(matrix, prime)[1])


def replay_record(scout: dict) -> dict:
    prime = scout["field_order"]
    points, signs = R.reconstruct(scout)
    projective = [[1] + point for point in points]
    endpoints, pgl, _psl = R.REPLAY.mobius_groups(prime)
    del endpoints
    base = tuple(tuple(pair) for pair in scout["coxeter_invariant_matching"])
    orbit = sorted({R.REPLAY.image_matching(element, base) for element in pgl})
    plus = [index for index, sign in enumerate(signs) if sign == 1]
    minus = [index for index, sign in enumerate(signs) if sign == prime - 1]
    incidence = [
        [
            int(bool(set(orbit[left]) & set(orbit[right])))
            for right in minus
        ]
        for left in plus
    ]

    eplus = [projective[index] for index in plus]
    eminus = [projective[index] for index in minus]
    transported = product(transpose(incidence), eplus, prime)
    residual = [
        [
            (eminus[i][j] - 2 * transported[i][j]) % prime
            for j in range(prime)
        ]
        for i in range(prime)
    ]
    assert all(
        len({residual[i][j] for i in range(prime)}) == 1
        for j in range(prime)
    )

    aug = [
        [
            (1 if j == i else -1 if j == prime - 1 else 0) % prime
            for j in range(prime)
        ]
        for i in range(prime - 1)
    ]
    cross_rank = rank(
        product(product(aug, incidence, prime), transpose(aug), prime),
        prime,
    )

    spaces = []
    for degree in range(4):
        evaluations = transpose(R.evaluations(projective, degree, prime))
        spaces.append(R.row_basis(evaluations, prime))
    dimensions = [len(space) for space in spaces]
    artinian = [
        dimensions[0],
        *[
            dimensions[degree] - dimensions[degree - 1]
            for degree in range(1, 4)
        ],
    ]

    return {
        "type": scout["type"],
        "q": prime,
        "evaluation_graph_scalar": 2,
        "cross_pairing_rank_on_sheet_augmentation": cross_rank,
        "artinian_dimensions_degrees_0_through_3": artinian,
        "missing_rank_between_cross_and_gorenstein_pairings": artinian[1]
        - cross_rank,
    }


def main() -> int:
    certificate = json.loads(CERTIFICATE.read_text())
    primary = {record["type"]: record for record in certificate["types"]}
    checked = 0
    for scout in R.SCOUT["types"]:
        if scout["type"] not in ("B3", "H3"):
            continue
        replay = replay_record(scout)
        expected = primary[replay["type"]]
        for key, value in replay.items():
            assert expected[key] == value
        checked += 1
    assert checked == 2
    print("C692 independent pairing-rank replay: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
