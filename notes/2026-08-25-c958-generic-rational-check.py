#!/usr/bin/env python3
"""Independent stdlib holdout checker for the generic C958 inverse coefficients."""

import argparse
import json
from fractions import Fraction
from pathlib import Path


def residue(text, prime):
    value = Fraction(text)
    return value.numerator * pow(value.denominator, -1, prime) % prime


def evaluate(terms, a_value, b_value, prime):
    return sum(
        residue(term["coefficient"], prime)
        * pow(a_value, term["parameter_exponents"][0], prime)
        * pow(b_value, term["parameter_exponents"][1], prime)
        for term in terms
    ) % prime


def normalize(sparse, prime):
    vector = {term["index"]: term["value"] for term in sparse}
    pivot = min(index for index in vector if index >= 126)
    scale = pow(vector[pivot], -1, prime)
    return {index: value * scale % prime for index, value in vector.items()}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", type=Path)
    parser.add_argument("holdouts", type=Path)
    arguments = parser.parse_args()
    certificate = json.loads(arguments.certificate.read_text())
    holdouts = json.loads(arguments.holdouts.read_text())
    assert certificate["schema"] == "c958-generic-rational-inverse-v1"
    assert holdouts["schema"] == "c958-generic-modular-grid-v1"
    prime = holdouts["prime"]
    assert prime not in certificate["reconstruction_primes"]
    checked = 0
    for sample in holdouts["samples"]:
        a_value = sample["specialization"]["a"]
        b_value = sample["specialization"]["b"]
        observed = [normalize(vector, prime) for vector in sample["vectors"]]
        for target, coefficients in enumerate(certificate["vectors"]):
            assert len(coefficients) == len(observed[target])
            for coefficient in coefficients:
                index = coefficient["inverse_vector_index"]
                denominator = evaluate(coefficient["denominator"], a_value, b_value, prime)
                assert denominator
                expected = evaluate(coefficient["numerator"], a_value, b_value, prime)
                expected = expected * pow(denominator, -1, prime) % prime
                assert expected == observed[target][index]
                checked += 1
    print(f"prime={prime} samples={len(holdouts['samples'])} coefficient_values={checked}")


if __name__ == "__main__":
    main()
