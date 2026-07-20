#!/usr/bin/env python3
"""Exact input certificate for C430's symbolic balanced-half theorem."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


SCHEMA = "c430-conceptual-balanced-half-rigidity-v1"
HERE = Path(__file__).resolve().parent
OUTPUT = Path(__file__).with_suffix(".json")
C406_PATH = HERE / "2026-07-20-c406-matching-module.py"
C406_CERT_PATH = HERE / "2026-07-20-c406-matching-module.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


C406 = load_module("c430_c406", C406_PATH)


def canonical_vector(vector, prime):
    pivot = next(value for value in vector if value % prime)
    inverse = pow(pivot, -1, prime)
    return [value * inverse % prime for value in vector]


def projectively_equal(left, right, prime):
    left = canonical_vector(left, prime)
    right = canonical_vector(right, prime)
    return left == right


def moment_matrix(vectors, prime):
    dimension = len(vectors[0])
    return [
        [
            sum(vector[row] * vector[column] for vector in vectors) % prime
            for column in range(dimension)
        ]
        for row in range(dimension)
    ]


def case_certificate(record):
    name = record["type"]
    prime = record["field_order"]
    conic, parameters = C406.C399.conic_parameterization(prime)
    endpoints = tuple(parameters)
    full_group, psl_group = C406.full_pgl(prime, parameters)
    base_matching = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted(
        {C406.matching_image(element, base_matching) for element in full_group}
    )
    assert len(orbit) == 2 * prime
    orbit_index = {matching: index for index, matching in enumerate(orbit)}

    base_product = C406.matching_product(base_matching, endpoints, prime)
    quotient_vectors = []
    for matching in orbit:
        product = C406.matching_product(matching, endpoints, prime)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0))
            % prime
            for exponent in set(product) | set(base_product)
        }
        quotient_vectors.append(
            C406.quotient_by_conic(difference, (prime + 1) // 2 - 2, prime)
        )

    _reduced, coordinate_pivots = C406.rref(quotient_vectors, prime)
    assert len(coordinate_pivots) == prime - 1
    vectors = [
        [vector[index] for index in coordinate_pivots]
        for vector in quotient_vectors
    ]

    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {
            C406.matching_image(element, representative) for element in psl_group
        }
        unseen -= sheet
        sheets.append(sorted(orbit_index[matching] for matching in sheet))
    sheets.sort()
    assert [len(sheet) for sheet in sheets] == [prime, prime]
    sign = [1 if index in set(sheets[0]) else -1 % prime for index in range(2 * prime)]

    sheet_vectors = [[vectors[index] for index in sheet] for sheet in sheets]
    sheet_first_moments = [
        [sum(vector[index] for vector in items) % prime for index in range(prime - 1)]
        for items in sheet_vectors
    ]
    assert all(not any(moment) for moment in sheet_first_moments)

    sheet_second_moments = [moment_matrix(items, prime) for items in sheet_vectors]
    assert sheet_second_moments[0] == sheet_second_moments[1]
    total_second_moment = moment_matrix(vectors, prime)
    second_moment_rank = C406.rank(total_second_moment, prime)
    radical = C406.nullspace(total_second_moment, prime)
    assert second_moment_rank == prime - 2 and len(radical) == 1
    radical_covector = canonical_vector(radical[0], prime)
    radical_values = [
        sum(coefficient * value for coefficient, value in zip(radical_covector, vector))
        % prime
        for vector in vectors
    ]
    radical_sheet_values = [
        sorted({radical_values[index] for index in sheet}) for sheet in sheets
    ]
    assert all(len(values) == 1 for values in radical_sheet_values)
    assert radical_sheet_values[0] != radical_sheet_values[1]

    affine_features = [[1] + vector for vector in vectors]
    affine_rank = C406.column_rank(affine_features, prime)
    restriction_ranks = [
        C406.column_rank([affine_features[index] for index in sheet], prime)
        for sheet in sheets
    ]
    assert affine_rank == prime
    assert restriction_ranks == [prime - 1, prime - 1]

    degree_two_features = [
        [1] + vector + C406.symmetric_power(vector, 2, prime)
        for vector in vectors
    ]
    direct_degree_two_rank = C406.column_rank(degree_two_features, prime)
    trade_kernel = C406.nullspace(C406.transpose(degree_two_features), prime)
    assert direct_degree_two_rank == 2 * prime - 1
    assert len(trade_kernel) == 1
    assert projectively_equal(trade_kernel[0], sign, prime)

    for degree in (0, 1, 2):
        signed_moment = []
        for coefficient, vector in zip(sign, vectors):
            feature = [1] if degree == 0 else C406.symmetric_power(vector, degree, prime)
            if not signed_moment:
                signed_moment = [0] * len(feature)
            signed_moment = [
                (left + coefficient * right) % prime
                for left, right in zip(signed_moment, feature)
            ]
        assert not any(signed_moment)

    return {
        "type": name,
        "field_order": prime,
        "orbit_size": len(orbit),
        "sheet_sizes": [len(sheet) for sheet in sheets],
        "quotient_dimension": len(vectors[0]),
        "affine_evaluation_rank": affine_rank,
        "sheet_restriction_ranks": restriction_ranks,
        "sheet_first_moments_zero": True,
        "sheet_second_moments_equal": True,
        "second_moment_rank": second_moment_rank,
        "second_moment_radical_dimension": len(radical),
        "radical_covector": radical_covector,
        "radical_sheet_values": radical_sheet_values,
        "radical_separates_sheets": True,
        "zero_sum_space_dimension_per_sheet": prime - 1,
        "nondegenerate_zero_sum_quotient_dimension": prime - 2,
        "symbolically_predicted_degree_two_rank": 2 * prime - 1,
        "direct_degree_two_rank_crosscheck": direct_degree_two_rank,
        "direct_trade_kernel_dimension_crosscheck": len(trade_kernel),
        "direct_trade_kernel_is_sheet_sign_crosscheck": True,
        "exhaustive_half_search_used": False,
    }


def file_record(path):
    payload = path.read_bytes()
    return {"bytes": len(payload), "sha256": hashlib.sha256(payload).hexdigest()}


def build_certificate():
    scout = json.loads(C406.SCOUT_PATH.read_text())
    records = [record for record in scout["types"] if record["type"] in ("B3", "H3")]
    cases = [case_certificate(record) for record in records]
    assert [case["type"] for case in cases] == ["B3", "H3"]
    return {
        "schema": SCHEMA,
        "verdict": "SYMBOLIC_RADICAL_HADAMARD_RIGIDITY_REPLACES_HALF_EXHAUSTION",
        "theorem": {
            "name": "radical_hadamard_trade_rigidity",
            "degree_at_most_two_evaluation_space": "equal_sheet_sum_hyperplane",
            "orthogonal_trade_space": "sheet_sign_line",
            "scope": "any two-sheet field configuration satisfying the certified first/second-moment, restriction-surjectivity, and radical-separation hypotheses",
        },
        "cases": cases,
        "summary": {
            "b3_and_h3_inputs_satisfy_symbolic_hypotheses": True,
            "all_degree_at_most_two_signed_trades_are_scalar_sheet_signs": True,
            "equal_half_sign_trade_is_unique_up_to_complement": True,
            "finite_subset_exhaustion_is_not_load_bearing": True,
        },
        "inputs": {
            path.name: file_record(path)
            for path in (
                C406_PATH,
                C406_CERT_PATH,
                C406.SCOUT_PATH,
                C406.C399_PATH,
            )
        },
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    certificate = build_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered)
        print(f"wrote {OUTPUT.name}")
    else:
        if not OUTPUT.exists() or OUTPUT.read_text() != rendered:
            raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
        print("C430 conceptual balanced-half certificate OK")


if __name__ == "__main__":
    main()
