#!/usr/bin/env python3
"""Exact q=53 all-passant sixteen-center check for C756."""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-08-09-c756-aligned-node-clique.py"
BASE_CERTIFICATE = HERE / "2026-08-09-c756-aligned-node-clique.json"
BASE_SHA256 = "bf3c2fe00f9b09e2889532da697f9ef09d9ecffdfac2785d232541f164b79bbb"
BASE_CERTIFICATE_SHA256 = (
    "2b49dd98d42fe5686a646ffb4bb42505624cc11e821fdf9eb7b0975068e53422"
)


def load_base():
    script_digest = hashlib.sha256(BASE_PATH.read_bytes()).hexdigest()
    certificate_digest = hashlib.sha256(BASE_CERTIFICATE.read_bytes()).hexdigest()
    if script_digest != BASE_SHA256:
        raise SystemExit(
            f"base script hash mismatch: expected {BASE_SHA256}, got {script_digest}"
        )
    if certificate_digest != BASE_CERTIFICATE_SHA256:
        raise SystemExit(
            "base certificate hash mismatch: "
            f"expected {BASE_CERTIFICATE_SHA256}, got {certificate_digest}"
        )
    specification = importlib.util.spec_from_file_location(
        "c756_all_passant_geometry", BASE_PATH
    )
    if specification is None or specification.loader is None:
        raise SystemExit(f"cannot load {BASE_PATH}")
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


BASE = load_base()
Q = BASE.Q
NU = BASE.NONSQUARE


def normal(direction):
    return BASE.ALPHA0 * BASE.TORUS[direction]


def linear_coefficients(direction):
    alpha = normal(direction)
    return 2 * alpha.a % Q, 2 * BASE.NONSQUARE * alpha.b % Q


def affine_nodes(chosen):
    nodes = []
    for i, left in enumerate(chosen):
        a_i, b_i = linear_coefficients(left.direction)
        for right in chosen[:i]:
            a_j, b_j = linear_coefficients(right.direction)
            determinant = (a_i * b_j - a_j * b_i) % Q
            inverse = pow(determinant, -1, Q)
            nodes.append(
                (
                    (-left.s * b_j + right.s * b_i) * inverse % Q,
                    (-a_i * right.s + a_j * left.s) * inverse % Q,
                )
            )
    if len(nodes) != 55:
        raise AssertionError(len(nodes))
    return nodes


def projection_profile(nodes, direction, d):
    a, b = linear_coefficients(direction)
    values = [(a * x + b * y) % Q for x, y in nodes]
    counts = Counter(values)

    support_mask = 0
    for value in values:
        support_mask |= 1 << value
    if support_mask.bit_count() != len(counts):
        raise AssertionError("projection support implementations disagree")

    span = len(counts)
    if span != Q:
        return span, None, None

    residual = []
    for value, multiplicity in sorted(counts.items()):
        residual.extend([value] * (multiplicity - 1))
    if len(residual) != 2:
        raise AssertionError(residual)

    # For an anisotropic distinguished line, positive discriminant character
    # is a passant, whose pole is internal.  Hence point type is its negative.
    characters = [
        -BASE.chi(value * value - 4 * d * NU)
        for value in residual
    ]
    if 0 in characters:
        raise AssertionError("a residual point lies on the conic")
    weight = sum(characters)
    norm = characters[0] * characters[1]
    if weight * weight != 2 * (1 + norm):
        raise AssertionError("defect-two trace/norm identity failed")
    return span, weight, norm


def covariance_class(nodes):
    inverse_count = pow(len(nodes), -1, Q)
    center = [
        sum(point[coordinate] for point in nodes) * inverse_count % Q
        for coordinate in range(2)
    ]
    matrix = [
        [
            sum(
                (point[i] - center[i]) * (point[j] - center[j])
                for point in nodes
            )
            % Q
            for j in range(2)
        ]
        for i in range(2)
    ]
    determinant = (
        matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    ) % Q
    if determinant == 0:
        rank = 0 if all(entry == 0 for row in matrix for entry in row) else 1
        return f"rank-{rank}"
    return "split" if BASE.chi(determinant) == 1 else "anisotropic"


def analyze_case(case):
    d = int(case["d"])
    complete_center_histogram = Counter()
    minimum_span_histogram = Counter()
    maximum_span_histogram = Counter()
    residual_weight_counts = Counter()
    residual_norm_counts = Counter()
    covariance_classes = Counter()
    full_cover_candidates = 0
    maximum_complete_centers = -1
    best_witness = None

    records = case["normalized_direction_zero_candidates"]
    for record in records:
        chosen = [BASE.Vertex(*pair) for pair in record["vertices"]]
        nodes = affine_nodes(chosen)
        used_directions = {vertex.direction for vertex in chosen}
        missing_directions = [
            direction
            for direction in range(len(BASE.TORUS))
            if direction not in used_directions
        ]
        if len(missing_directions) != 16:
            raise AssertionError(missing_directions)

        spans = []
        weights = Counter()
        norms = Counter()
        for direction in missing_directions:
            span, weight, norm = projection_profile(nodes, direction, d)
            spans.append(span)
            if weight is not None:
                weights[weight] += 1
                norms[norm] += 1

        complete = sum(span == Q for span in spans)
        complete_center_histogram[complete] += 1
        minimum_span_histogram[min(spans)] += 1
        maximum_span_histogram[max(spans)] += 1
        residual_weight_counts.update(weights)
        residual_norm_counts.update(norms)
        covariance_classes[covariance_class(nodes)] += 1
        full_cover_candidates += int(complete == 16)
        witness = record["vertices"]
        if (
            complete > maximum_complete_centers
            or complete == maximum_complete_centers
            and (best_witness is None or witness < best_witness)
        ):
            maximum_complete_centers = complete
            best_witness = witness

    def rows(counter, label="value"):
        return [
            {label: key, "count": counter[key]}
            for key in sorted(counter)
        ]

    return {
        "name": case["name"],
        "d": d,
        "node_character": int(case["node_character"]),
        "vertex_count": int(case["vertex_count"]),
        "search_nodes": int(case["search_nodes"]),
        "geometric_candidates": len(records),
        "full_cover_candidates": full_cover_candidates,
        "maximum_complete_centers": maximum_complete_centers,
        "best_witness": best_witness,
        "complete_center_histogram": rows(complete_center_histogram),
        "minimum_span_histogram": rows(minimum_span_histogram),
        "maximum_span_histogram": rows(maximum_span_histogram),
        "residual_weight_counts": rows(residual_weight_counts),
        "residual_norm_counts": rows(residual_norm_counts),
        "covariance_classes": rows(covariance_classes, "class"),
    }


def exact_output():
    certificate = BASE.exact_certificate()
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if rendered != BASE_CERTIFICATE.read_text():
        raise AssertionError("regenerated base certificate mismatch")
    BASE.direct_invariant_check(certificate)
    return {
        "schema": "c756-all-passant-center-v1",
        "q": Q,
        "quadratic_extension_nonsquare": BASE.NONSQUARE,
        "required_center_count": 16,
        "base_script": BASE_PATH.name,
        "base_script_sha256": BASE_SHA256,
        "base_certificate": BASE_CERTIFICATE.name,
        "base_certificate_sha256": BASE_CERTIFICATE_SHA256,
        "cases": [analyze_case(case) for case in certificate["cases"]],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()
    if arguments.exact == (arguments.check is not None):
        parser.error("select exactly one of --exact or --check FILE")

    serialized = json.dumps(exact_output(), indent=2, sort_keys=True) + "\n"
    if arguments.check is not None:
        if serialized != arguments.check.read_text():
            raise SystemExit(f"certificate mismatch: {arguments.check}")
        print(f"certificate ok: {arguments.check}")
    elif arguments.output is not None:
        arguments.output.write_text(serialized)
        print(f"wrote {arguments.output}")
    else:
        print(serialized, end="")


if __name__ == "__main__":
    main()
