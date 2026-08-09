#!/usr/bin/env python3
"""Exact q=53 external-deletion star search across every covariance class.

This reuses, by pinned hash, the geometry engine of the aligned split search.
That engine's graph enumerates every normalized eleven-line star for an
external deleted point: the fixed conic is UV=2W^2, the distinguished polar
line is W=0, every arrangement direction is internal, every pairwise node is
internal, and triple concurrency is forbidden.

The new layer checks the condition that all fifteen remaining internal
directions are complete projection centers.  It also records the residual
degree-two character trace and resultant norm at every complete center.
"""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import importlib.util
import json
import multiprocessing
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-08-09-c756-aligned-split-mixed-search.py"
BASE_SHA256 = "f1c11decc6df8c5e9bc0a57a5e98dfd35c9fdd2c4ce8fabaa3db5b115ab9249f"


def load_base():
    digest = hashlib.sha256(BASE_PATH.read_bytes()).hexdigest()
    if digest != BASE_SHA256:
        raise SystemExit(
            f"base script hash mismatch: expected {BASE_SHA256}, got {digest}"
        )
    specification = importlib.util.spec_from_file_location(
        "c756_aligned_split_geometry", BASE_PATH
    )
    if specification is None or specification.loader is None:
        raise SystemExit(f"cannot load {BASE_PATH}")
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


BASE = load_base()
Q = BASE.Q
D = BASE.NONSQUARE
TARGET_SIZE = BASE.TARGET_SIZE


def affine_nodes(chosen):
    """Return the 55 affine intersections of the eleven chosen lines."""
    nodes = []
    for i, left in enumerate(chosen):
        a_i, b_i = BASE.coefficients(left)
        for right in chosen[:i]:
            a_j, b_j = BASE.coefficients(right)
            determinant = (a_i * b_j - a_j * b_i) % Q
            inverse = pow(determinant, -1, Q)
            nodes.append(
                (
                    (b_i * right.s - b_j * left.s) * inverse % Q,
                    (a_j * left.s - a_i * right.s) * inverse % Q,
                )
            )
    if len(nodes) != 55:
        raise AssertionError(len(nodes))
    return nodes


def projection_profile(nodes, direction):
    """Return span, residual character trace, and norm for one center."""
    a, b = BASE.coefficients(BASE.Vertex(direction, 0))
    counts = Counter((a * u + b * v) % Q for u, v in nodes)

    # Independent bit-mask replay of the support count.
    support_mask = 0
    for value in ((a * u + b * v) % Q for u, v in nodes):
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

    characters = [BASE.chi(value * value - 4 * D) for value in residual]
    if 0 in characters:
        raise AssertionError("a residual point lies on the conic")
    weight = sum(characters)
    norm = characters[0] * characters[1]
    if weight * weight != 2 * (1 + norm):
        raise AssertionError("defect-two trace/norm identity failed")
    return span, weight, norm


def covariance_class(nodes):
    """Classify the actual centered second-moment form of a geometric star."""
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
    # For q = 53, -1 is a square, so square determinant is split.
    return "split" if BASE.chi(determinant) == 1 else "anisotropic"


def analyze_candidate(chosen):
    chosen = sorted(chosen)
    nodes = affine_nodes(chosen)
    used_directions = {vertex.direction for vertex in chosen}
    missing_directions = [
        direction
        for direction in range(len(BASE.DIRECTIONS))
        if direction not in used_directions
    ]
    if len(missing_directions) != 15:
        raise AssertionError(missing_directions)

    spans = []
    weights = Counter()
    norms = Counter()
    for direction in missing_directions:
        span, weight, norm = projection_profile(nodes, direction)
        spans.append(span)
        if weight is not None:
            weights[weight] += 1
            norms[norm] += 1

    return {
        "complete_centers": sum(span == Q for span in spans),
        "minimum_span": min(spans),
        "maximum_span": max(spans),
        "weight_counts": weights,
        "norm_counts": norms,
        "covariance_class": covariance_class(nodes),
    }


def enumerate_seed(seed_s):
    """Exhaust one normalized root-offset shard."""
    vertices, adjacency = BASE.graph(D)
    forbidden = BASE.concurrency_forbidden_masks(vertices)
    full = (1 << len(vertices)) - 1
    roots = [
        index
        for index, vertex in enumerate(vertices)
        if vertex.direction == 0 and vertex.s == seed_s
    ]
    if len(roots) != 1:
        raise AssertionError((seed_s, roots))

    search_nodes = 0
    leaves = 0
    full_cover = 0
    complete_center_histogram = Counter()
    minimum_span_histogram = Counter()
    maximum_span_histogram = Counter()
    residual_weight_counts = Counter()
    residual_norm_counts = Counter()
    covariance_classes = Counter()
    maximum_complete_centers = -1
    best_witness = None

    def search(chosen_indices, candidates):
        nonlocal search_nodes, leaves, full_cover
        nonlocal maximum_complete_centers, best_witness
        search_nodes += 1
        if len(chosen_indices) == TARGET_SIZE:
            leaves += 1
            chosen = sorted(vertices[index] for index in chosen_indices)
            analysis = analyze_candidate(chosen)
            complete = analysis["complete_centers"]
            complete_center_histogram[complete] += 1
            minimum_span_histogram[analysis["minimum_span"]] += 1
            maximum_span_histogram[analysis["maximum_span"]] += 1
            residual_weight_counts.update(analysis["weight_counts"])
            residual_norm_counts.update(analysis["norm_counts"])
            covariance_classes[analysis["covariance_class"]] += 1
            full_cover += int(complete == 15)
            witness = [[vertex.direction, vertex.s] for vertex in chosen]
            if (
                complete > maximum_complete_centers
                or complete == maximum_complete_centers
                and (best_witness is None or witness < best_witness)
            ):
                maximum_complete_centers = complete
                best_witness = witness
            return

        order, bounds = BASE.color_sort(candidates, adjacency)
        for position in range(len(order) - 1, -1, -1):
            if len(chosen_indices) + bounds[position] < TARGET_SIZE:
                return
            vertex = order[position]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & adjacency[vertex]
            for prior in chosen_indices:
                next_candidates &= ~forbidden(prior, vertex)
            chosen_indices.append(vertex)
            search(chosen_indices, next_candidates)
            chosen_indices.pop()
            candidates ^= bit

    root = roots[0]
    search([root], full & adjacency[root])
    return {
        "seed_s": seed_s,
        "search_nodes": search_nodes,
        "geometric_candidates": leaves,
        "full_cover_candidates": full_cover,
        "maximum_complete_centers": maximum_complete_centers,
        "best_witness": best_witness,
        "complete_center_histogram": dict(complete_center_histogram),
        "minimum_span_histogram": dict(minimum_span_histogram),
        "maximum_span_histogram": dict(maximum_span_histogram),
        "residual_weight_counts": dict(residual_weight_counts),
        "residual_norm_counts": dict(residual_norm_counts),
        "covariance_classes": dict(covariance_classes),
    }


def merge_counter(pieces, field):
    total = Counter()
    for piece in pieces:
        total.update({int(key): value for key, value in piece[field].items()})
    return [
        {"value": key, "count": total[key]}
        for key in sorted(total)
    ]


def merge_named_counter(pieces, field):
    total = Counter()
    for piece in pieces:
        total.update(piece[field])
    return [
        {"class": key, "count": total[key]}
        for key in sorted(total)
    ]


def enumerate_all(workers):
    seeds = list(range((Q + 1) // 2))
    if workers == 1:
        pieces = [enumerate_seed(seed) for seed in seeds]
    else:
        with multiprocessing.get_context("fork").Pool(workers) as pool:
            pieces = pool.map(enumerate_seed, seeds, chunksize=1)

    best_piece = max(
        pieces,
        key=lambda piece: (
            piece["maximum_complete_centers"],
            [] if piece["best_witness"] is None else [
                [-entry for entry in pair] for pair in piece["best_witness"]
            ],
        ),
    )
    best_count = best_piece["maximum_complete_centers"]
    best_witness = min(
        piece["best_witness"]
        for piece in pieces
        if piece["maximum_complete_centers"] == best_count
        and piece["best_witness"] is not None
    )
    return {
        "searched_seed_offsets": seeds,
        "vertex_count": len(BASE.vertices(D)),
        "search_nodes": sum(piece["search_nodes"] for piece in pieces),
        "geometric_candidates": sum(
            piece["geometric_candidates"] for piece in pieces
        ),
        "full_cover_candidates": sum(
            piece["full_cover_candidates"] for piece in pieces
        ),
        "maximum_complete_centers": best_count,
        "best_witness": best_witness,
        "complete_center_histogram": merge_counter(
            pieces, "complete_center_histogram"
        ),
        "minimum_span_histogram": merge_counter(
            pieces, "minimum_span_histogram"
        ),
        "maximum_span_histogram": merge_counter(
            pieces, "maximum_span_histogram"
        ),
        "residual_weight_counts": merge_counter(
            pieces, "residual_weight_counts"
        ),
        "residual_norm_counts": merge_counter(
            pieces, "residual_norm_counts"
        ),
        "covariance_classes": merge_named_counter(
            pieces, "covariance_classes"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--enumerate", action="store_true")
    parser.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--workers", type=int, default=1)
    arguments = parser.parse_args()
    if arguments.enumerate == (arguments.check is not None):
        parser.error("select exactly one of --enumerate or --check FILE")
    if arguments.workers < 1:
        parser.error("--workers must be positive")

    output = {
        "schema": "c756-external-deletion-all-covariance-v1",
        "q": Q,
        "conic_normal_form": "UV=2W^2",
        "distinguished_line": "W=0 (secant)",
        "required_center_count": 15,
        "base_script": BASE_PATH.name,
        "base_script_sha256": BASE_SHA256,
        "result": enumerate_all(arguments.workers),
    }
    serialized = json.dumps(output, indent=2, sort_keys=True) + "\n"
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
