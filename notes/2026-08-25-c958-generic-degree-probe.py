#!/usr/bin/env python3
"""Probe one-variable rational degrees of modular C958 inverse coefficients."""

import argparse
import collections
import importlib.util
import json
from pathlib import Path


PRIME = 1_000_003


def load_search():
    path = Path(__file__).with_name("2026-08-25-c958-type-i1-tangent-inverse-search.py")
    spec = importlib.util.spec_from_file_location("c958_inverse_search", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def normalized_vectors(path, axis):
    data = json.loads(path.read_text())
    assert data["prime"] == PRIME
    answer = []
    for sparse in data["vectors"]:
        vector = {term["index"]: term["value"] for term in sparse}
        denominator_indices = sorted(index for index in vector if index >= 126)
        pivot = denominator_indices[0]
        scale = pow(vector[pivot], -1, PRIME)
        answer.append({index: value * scale % PRIME for index, value in vector.items()})
    return data["specialization"][axis], answer


def evaluate(coefficients, value):
    return sum(coefficient * pow(value, exponent, PRIME)
               for exponent, coefficient in enumerate(coefficients)) % PRIME


def fit(search, samples, holdouts, numerator_degree, denominator_degree):
    rows = []
    for x, value in samples:
        rows.append(
            [pow(x, exponent, PRIME) for exponent in range(numerator_degree + 1)]
            + [(-value * pow(x, exponent, PRIME)) % PRIME
               for exponent in range(denominator_degree + 1)]
        )
    basis = search.nullspace(rows)
    if len(basis) != 1:
        return False
    vector = basis[0]
    numerator = vector[:numerator_degree + 1]
    denominator = vector[numerator_degree + 1:]
    return all(
        evaluate(denominator, x) != 0
        and evaluate(numerator, x) == value * evaluate(denominator, x) % PRIME
        for x, value in holdouts
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("samples", type=Path, nargs="+")
    parser.add_argument("--training", type=int, default=8)
    parser.add_argument("--exclude-a", type=int, action="append", default=[])
    parser.add_argument("--axis", choices=("a", "b"), default="a")
    parser.add_argument("--write", type=Path)
    arguments = parser.parse_args()
    search = load_search()
    loaded = sorted((normalized_vectors(path, arguments.axis) for path in arguments.samples),
                    key=lambda item: item[0])
    loaded = [item for item in loaded if item[0] not in arguments.exclude_a]
    assert len(loaded) > arguments.training
    assert len({tuple(vector) for _, vectors in loaded for vector in vectors}) == 4

    histogram = collections.Counter()
    unresolved = []
    records = []
    for target in range(4):
        support = sorted(loaded[0][1][target])
        assert all(sorted(vectors[target]) == support for _, vectors in loaded)
        for index in support:
            values = [(a, vectors[target][index]) for a, vectors in loaded]
            found = None
            for total_degree in range(arguments.training):
                for numerator_degree in range(total_degree + 1):
                    denominator_degree = total_degree - numerator_degree
                    if fit(search, values[:arguments.training], values[arguments.training:],
                           numerator_degree, denominator_degree):
                        found = (numerator_degree, denominator_degree)
                        break
                if found:
                    break
            if found:
                histogram[found] += 1
                records.append({"target": target, "index": index,
                                "numerator_degree": found[0],
                                "denominator_degree": found[1]})
            else:
                unresolved.append((target, index))
    print("degree_histogram", sorted(histogram.items()))
    print("unresolved_count", len(unresolved))
    print("unresolved_first", unresolved[:20])
    if arguments.write:
        arguments.write.write_text(json.dumps({"axis": arguments.axis, "records": records},
                                              indent=2, sort_keys=True) + "\n")


if __name__ == "__main__":
    main()
