#!/usr/bin/env python3
"""Independent hard-coded replay for the C716 Golden-line certificate."""

from __future__ import annotations

import itertools
import json
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-07-31-c716-golden-two-u1-lines.json"
TRIPLES = tuple(itertools.combinations(range(6), 3))
CUBICS = (
    (-1, -1, 1, 1, 1, -1, 1, 1, -1, -1, 1, 1, -1, -1, 1, -1, -1, -1, 1, 1),
    (1, 1, -1, -1, -1, -1, 1, 1, -1, 1, -1, 1, -1, -1, 1, 1, 1, 1, -1, -1),
    (1, -1, 1, -1, 1, -1, -1, -1, 1, 1, -1, -1, 1, 1, 1, -1, 1, -1, 1, -1),
    (-1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1, 1, 1, -1, -1, -1, 1, -1, 1),
    (-1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1, -1, 1, -1, -1, 1, 1, -1, -1, 1),
    (1, -1, -1, 1, -1, 1, -1, 1, 1, -1, 1, -1, -1, 1, -1, 1, -1, 1, 1, -1),
)
COLLISION_MAP = {
    "01": ((0, 1), (2, 3), (4, 5)),
    "02": ((0, 5), (1, 3), (2, 4)),
    "03": ((0, 4), (1, 2), (3, 5)),
    "04": ((0, 3), (1, 4), (2, 5)),
    "05": ((0, 2), (1, 5), (3, 4)),
    "12": ((0, 2), (1, 4), (3, 5)),
    "13": ((0, 3), (1, 5), (2, 4)),
    "14": ((0, 5), (1, 2), (3, 4)),
    "15": ((0, 4), (1, 3), (2, 5)),
    "23": ((0, 1), (2, 5), (3, 4)),
    "24": ((0, 4), (1, 5), (2, 3)),
    "25": ((0, 3), (1, 2), (4, 5)),
    "34": ((0, 2), (1, 3), (4, 5)),
    "35": ((0, 5), (1, 4), (2, 3)),
    "45": ((0, 1), (2, 4), (3, 5)),
}


def amplitude(raw):
    return tuple(
        sum(
            coefficient * raw[i] * raw[j] * raw[k]
            for coefficient, (i, j, k) in zip(cubic, TRIPLES)
        )
        for cubic in CUBICS
    )


def anomaly_tuple(q, r):
    return (
        sum(q), sum(r), sum(value**3 for value in q),
        sum(q[i] ** 2 * r[i] for i in range(6)),
        sum(q[i] * r[i] ** 2 for i in range(6)), sum(value**3 for value in r),
    )


def parse_vector(values):
    return tuple(Fraction(value) for value in values)


def pfaffian(matrix):
    if not matrix:
        return 1
    return sum(
        (-1) ** (j + 1) * matrix[0][j]
        * pfaffian([
            [matrix[row][column] for column in range(len(matrix)) if column not in (0, j)]
            for row in range(len(matrix)) if row not in (0, j)
        ])
        for j in range(1, len(matrix))
    )


def check_component(record, plane):
    control = parse_vector(record["control_intercept"])
    direction = tuple(Fraction(value) for value in record["control_direction"])
    q = amplitude(control)
    endpoint = amplitude(tuple(control[i] + direction[i] for i in range(6)))
    r = tuple(endpoint[i] - q[i] for i in range(6))
    assert q == parse_vector(record["amplitude_intercept"])
    assert r == parse_vector(record["amplitude_direction"])
    assert anomaly_tuple(q, r) == (0, 0, 0, 0, 0, 0)
    witness = tuple(q[i] + r[i] / 2 for i in range(6))
    if plane:
        syntheme = tuple(tuple(pair) for pair in record["charge_syntheme"])
        assert syntheme == COLLISION_MAP["".join(map(str, record["collision_pair"]))]
        assert all(witness[i] + witness[j] == 0 for i, j in syntheme)
    else:
        assert all(witness)
        assert all(witness[i] + witness[j] for i, j in itertools.combinations(range(6), 2))


def main() -> None:
    data = json.loads(CERTIFICATE.read_text())
    assert data["schema"] == "c716-golden-two-u1-lines-v1"
    assert tuple(tuple(row) for row in data["frozen_c707_marking"]["outer_cubics"]) == CUBICS
    assert {
        key: tuple(tuple(pair) for pair in value)
        for key, value in data["collision_pair_to_charge_syntheme"].items()
    } == COLLISION_MAP
    assert data["source_2607_09879_to_c707_component"] == {
        "D0": 4, "D1": 1, "D2": 0, "D3": 2, "D4": 3, "D5": 5,
    }
    assert len(data["chiral_components"]) == 6
    assert len(data["plane_components"]) == 15
    for record in data["chiral_components"]:
        check_component(record, plane=False)
    for record in data["plane_components"]:
        check_component(record, plane=True)

    base_c = (
        (0, 1, 1, 1, -1, -1), (1, 0, -1, -1, -1, -1),
        (1, -1, 0, 1, 1, -1), (1, -1, 1, 0, -1, 1),
        (-1, -1, 1, -1, 0, -1), (-1, -1, -1, 1, -1, 0),
    )
    for raw in ((0, 1, 2, 3, 4, 5), (-3, -1, 0, 2, 4, 7), (1, 1, 2, 3, 5, 8)):
        commutator = [[(raw[i] - raw[j]) * base_c[i][j] for j in range(6)] for i in range(6)]
        assert pfaffian(commutator) == 4 * amplitude(raw)[0]
    print("ok: independent 21-family, marking, anomaly, chirality, and Pfaffian replay")


if __name__ == "__main__":
    main()
