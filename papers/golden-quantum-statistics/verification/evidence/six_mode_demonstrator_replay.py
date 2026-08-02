#!/usr/bin/env python3
"""Independent standard-library replay for the six-mode design certificate."""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
PATH = HERE / "six_mode_demonstrator.json"


def mm(a, b):
    return [[sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
            for i in range(len(a))]


def givens(a, b, theta):
    result = [[float(i == j) for j in range(6)] for i in range(6)]
    c, s = math.cos(theta), math.sin(theta)
    result[a][a], result[a][b] = c, s
    result[b][a], result[b][b] = -s, c
    return result


def main() -> None:
    data = json.loads(PATH.read_text())
    assert data["schema"] == "golden-six-mode-demonstrator-v1"

    network = data["logical_network"]
    reconstruction = [[float(network["base_O_input_phase_signs"][i] if i == j else 0)
                       for j in range(6)] for i in range(6)]
    for item in network["base_O_input_to_output_givens"]:
        reconstruction = mm(givens(*item["modes_zero_based"], item["theta_radians"]), reconstruction)
    target = network["base_O_numeric"]
    assert max(abs(target[i][j] - reconstruction[i][j]) for i in range(6) for j in range(6)) < 2e-14

    kappa = Fraction(72, 455)
    charges = (11, -10, -8, 5, 4, -2)
    expected = [kappa * kappa * q * q / 500 for q in charges]
    observed = [Fraction(item["probability"]) for item in data["controls"]["chiral"]["fermion_probabilities"]]
    assert observed == expected
    assert sum(charges) == sum(q ** 3 for q in charges) == 0
    assert Fraction(data["controls"]["balanced"]["fermion_probability"]["probability"]) == Fraction(16, 125)
    assert Fraction(data["controls"]["balanced"]["intrinsic_uniform_boson_average"]) == Fraction(313, 1250)

    words = [tuple(word) for word in data["simplex_decoder"]["six_words"]]
    assert len(set(words)) == 6
    for left, right in itertools.combinations(words, 2):
        assert sum(a != b for a, b in zip(left, right)) == 6
    triple = data["simplex_decoder"]["example_three_cut_classifier_zero_based"]
    cycle = data["simplex_decoder"]["example_five_cycle_zero_based"]
    assert len({tuple(word[i] for i in triple) for word in words}) == 6
    assert len({tuple(word[i] for i in cycle) for word in words}) == 6

    digest = hashlib.sha256(PATH.read_bytes()).hexdigest()
    print(f"ok: independent six-mode replay ({PATH.name}, sha256={digest})")


if __name__ == "__main__":
    main()
