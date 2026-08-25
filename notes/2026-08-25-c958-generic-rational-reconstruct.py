#!/usr/bin/env python3
"""Reconstruct all generic C958 inverse coefficients in F_p(a,b)."""

import argparse
import importlib.util
import json
from pathlib import Path


SEARCH_PATH = Path(__file__).with_name("2026-08-25-c958-type-i1-tangent-inverse-search.py")


def load_search():
    spec = importlib.util.spec_from_file_location("c958_inverse_search", SEARCH_PATH)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def monomials(a_value, b_value, a_degree, b_degree, prime):
    return [pow(a_value, i, prime) * pow(b_value, j, prime) % prime
            for i in range(a_degree + 1) for j in range(b_degree + 1)]


def evaluate(coefficients, values, prime):
    return sum(left * right for left, right in zip(coefficients, values)) % prime


def normalized_vectors(sample, prime):
    answer = []
    for sparse in sample["vectors"]:
        vector = {term["index"]: term["value"] for term in sparse}
        pivot = min(index for index in vector if index >= 126)
        scale = pow(vector[pivot], -1, prime)
        answer.append({index: value * scale % prime for index, value in vector.items()})
    return answer


def degree_map(path):
    data = json.loads(path.read_text())
    return {(item["target"], item["index"]):
            (item["numerator_degree"], item["denominator_degree"])
            for item in data["records"]}


def sparse(coefficients, a_degree, b_degree):
    return [
        {"coefficient": value, "parameter_exponents": [i, j]}
        for (i, j), value in zip(
            ((i, j) for i in range(a_degree + 1) for j in range(b_degree + 1)),
            coefficients,
        ) if value
    ]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("grid", type=Path)
    parser.add_argument("--a-degrees", type=Path, required=True)
    parser.add_argument("--b-degrees", type=Path, required=True)
    parser.add_argument("--write", type=Path, required=True)
    arguments = parser.parse_args()
    data = json.loads(arguments.grid.read_text())
    prime = data["prime"]
    search = load_search()
    search.PRIME = prime
    a_degrees = degree_map(arguments.a_degrees)
    b_degrees = degree_map(arguments.b_degrees)
    samples = [
        (sample["specialization"]["a"], sample["specialization"]["b"],
         normalized_vectors(sample, prime))
        for sample in data["samples"]
    ]
    supports = [sorted(samples[0][2][target]) for target in range(4)]
    assert all(sorted(vectors[target]) == supports[target]
               for _, _, vectors in samples for target in range(4))

    reconstructed = []
    for target, support in enumerate(supports):
        coefficients = []
        for index in support:
            numerator_a, denominator_a = a_degrees[(target, index)]
            numerator_b, denominator_b = b_degrees[(target, index)]
            rows = []
            cached = []
            for a_value, b_value, vectors in samples:
                numerator_values = monomials(a_value, b_value, numerator_a, numerator_b, prime)
                denominator_values = monomials(a_value, b_value, denominator_a, denominator_b, prime)
                value = vectors[target][index]
                rows.append(numerator_values
                            + [(-value * item) % prime for item in denominator_values])
                cached.append((value, numerator_values, denominator_values))
            basis = search.nullspace(rows)
            assert len(basis) == 1, (
                f"target={target} index={index} nullity={len(basis)} "
                f"degrees={(numerator_a, numerator_b, denominator_a, denominator_b)}"
            )
            numerator_width = (numerator_a + 1) * (numerator_b + 1)
            numerator = basis[0][:numerator_width]
            denominator = basis[0][numerator_width:]
            pivot = next(value for value in denominator if value)
            scale = pow(pivot, -1, prime)
            numerator = [value * scale % prime for value in numerator]
            denominator = [value * scale % prime for value in denominator]
            assert all(
                evaluate(numerator, numerator_values, prime)
                == value * evaluate(denominator, denominator_values, prime) % prime
                and evaluate(denominator, denominator_values, prime)
                for value, numerator_values, denominator_values in cached
            )
            coefficients.append({
                "inverse_vector_index": index,
                "numerator_degree_bounds": [numerator_a, numerator_b],
                "denominator_degree_bounds": [denominator_a, denominator_b],
                "numerator": sparse(numerator, numerator_a, numerator_b),
                "denominator": sparse(denominator, denominator_a, denominator_b),
            })
        reconstructed.append(coefficients)
        print(f"target={target} coefficients={len(coefficients)}")

    payload = {
        "schema": "c958-generic-rational-inverse-modular-v1",
        "prime": prime,
        "inverse_degree": 5,
        "normalization": "first common-denominator monomial coefficient equals one",
        "vectors": reconstructed,
        "validated_samples": len(samples),
    }
    arguments.write.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
