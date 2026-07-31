#!/usr/bin/env python3
"""Independent direct replay of the C730 involution and Petersen identities."""

from __future__ import annotations

import itertools
import json
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CERTIFICATE = ROOT / "notes" / "2026-07-31-c730-orientation-source.json"


def add(x: tuple[Fraction, Fraction], y: tuple[Fraction, Fraction]):
    return x[0] + y[0], x[1] + y[1]


def multiply(x: tuple[Fraction, Fraction], y: tuple[Fraction, Fraction]):
    # t^2=t+1
    return x[0] * y[0] + x[1] * y[1], x[0] * y[1] + x[1] * y[0] + x[1] * y[1]


def scalar(value: int):
    return Fraction(value), Fraction(0)


def negate(x: tuple[Fraction, Fraction]):
    return -x[0], -x[1]


def conjugate(x: tuple[Fraction, Fraction]):
    return x[0] + x[1], -x[1]


def vector_scale(c, vector):
    return tuple(multiply(c, value) for value in vector)


def main() -> int:
    payload = json.loads(CERTIFICATE.read_text())
    conference = payload["conference"]
    permutation = payload["golden_exchanger"]["old_axis_to_conjugate_axis"]
    switches = payload["golden_exchanger"]["representative_switches"]

    zero = scalar(0)
    one = scalar(1)
    t = Fraction(0), Fraction(1)
    axes = (
        (zero, t, one),
        (zero, t, negate(one)),
        (one, zero, t),
        (negate(one), zero, t),
        (t, negate(one), zero),
        (negate(t), negate(one), zero),
    )
    conjugates = tuple(tuple(conjugate(value) for value in axis) for axis in axes)

    def exchange(vector):
        return vector[0], negate(vector[2]), vector[1]

    for index, axis in enumerate(axes):
        factor = t if switches[index] == 1 else negate(t)
        assert exchange(axis) == vector_scale(factor, conjugates[permutation[index]])

    transported = [
        [
            switches[i]
            * switches[j]
            * conference[permutation[i]][permutation[j]]
            for j in range(6)
        ]
        for i in range(6)
    ]
    assert transported == [[-entry for entry in row] for row in conference]

    for triple in itertools.combinations(range(6), 3):
        i, j, k = triple
        old = conference[i][j] * conference[j][k] * conference[k][i]
        new = transported[i][j] * transported[j][k] * transported[k][i]
        assert new == -old

    labels = tuple(itertools.combinations(range(5), 2))
    for distinguished in range(4):
        y = [0] * 5
        y[distinguished] = 1
        y[4] = -1
        a = [y[i] + y[j] for i, j in labels]
        image = [
            sum(
                a[column]
                for column, other in enumerate(labels)
                if set(pair).isdisjoint(other)
            )
            for pair in labels
        ]
        assert image == [-2 * value for value in a]
        assert sum(value * value for value in a) == 3 * sum(value * value for value in y)
        assert [
            sum(a[column] for column, pair in enumerate(labels) if i in pair)
            for i in range(5)
        ] == [3 * value for value in y]

    assert payload["incidence_pullback"]["equation"] == "z^2=80*sigma3^2"
    assert payload["harmonic_input"]["gaunt_scalar"] == "-784000/1247103"
    print("C730 independent replay: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
