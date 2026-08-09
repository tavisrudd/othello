#!/usr/bin/env python3
"""Exact q=47 external-deletion geometry, octic-window, and center audit."""

from __future__ import annotations

import argparse
from collections import Counter
import hashlib
import json
import multiprocessing
from pathlib import Path
import sys
import types


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-08-09-c756-aligned-split-mixed-search.py"
BASE_SHA256 = "f1c11decc6df8c5e9bc0a57a5e98dfd35c9fdd2c4ce8fabaa3db5b115ab9249f"
Q = 47
NONSQUARE = 5
TARGET_SIZE = 11


def load_base():
    if hashlib.sha256(BASE_PATH.read_bytes()).hexdigest() != BASE_SHA256:
        raise SystemExit("base geometry script hash mismatch")
    source = BASE_PATH.read_text()
    replacements = (
        ("\nQ = 53\n", f"\nQ = {Q}\n"),
        ("\nNONSQUARE = 2\n", f"\nNONSQUARE = {NONSQUARE}\n"),
    )
    for old, new in replacements:
        if source.count(old) != 1:
            raise SystemExit(f"expected one source marker: {old!r}")
        source = source.replace(old, new)
    module = types.ModuleType("c756_q47_split_geometry")
    module.__file__ = str(BASE_PATH)
    sys.modules[module.__name__] = module
    exec(compile(source, str(BASE_PATH), "exec"), module.__dict__)
    if module.Q != Q or module.NONSQUARE != NONSQUARE:
        raise AssertionError((module.Q, module.NONSQUARE))
    return module


BASE = load_base()
INTERNAL_NODE_CHARACTER = -1


def geometry_graph():
    vertices = BASE.vertices(NONSQUARE)
    adjacency = [0] * len(vertices)
    for i, left in enumerate(vertices):
        for j, right in enumerate(vertices[:i]):
            if left.direction == right.direction:
                continue
            if BASE.chi(BASE.node_q(left, right, NONSQUARE)) == INTERNAL_NODE_CHARACTER:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return vertices, adjacency


def direct_model_check():
    if BASE.chi(NONSQUARE) != -1:
        raise AssertionError(NONSQUARE)
    if BASE.chi(4 * NONSQUARE) != -1:
        raise AssertionError("unexpected tangent offset")
    for direction in range(len(BASE.DIRECTIONS)):
        u = BASE.DIRECTIONS[direction]
        point_u, point_v = pow(u, -1, Q), -u % Q
        point_q = point_u * point_v % Q
        if BASE.chi(point_q) != INTERNAL_NODE_CHARACTER:
            raise AssertionError((direction, point_q))
    if len(BASE.vertices(NONSQUARE)) != len(BASE.DIRECTIONS) * Q:
        raise AssertionError("the internal-direction pencils should have no tangents")


def enumerate_seed(seed_s: int):
    vertices, adjacency = geometry_graph()
    forbidden = BASE.concurrency_forbidden_masks(vertices)
    full = (1 << len(vertices)) - 1
    search_nodes = 0
    records = []

    def search(chosen, candidates):
        nonlocal search_nodes
        search_nodes += 1
        if len(chosen) == TARGET_SIZE:
            selected = sorted(vertices[index] for index in chosen)
            records.append([[vertex.direction, vertex.s] for vertex in selected])
            return
        order, bounds = BASE.color_sort(candidates, adjacency)
        for position in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[position] < TARGET_SIZE:
                return
            vertex = order[position]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & adjacency[vertex]
            for prior in chosen:
                next_candidates &= ~forbidden(prior, vertex)
            chosen.append(vertex)
            search(chosen, next_candidates)
            chosen.pop()
            candidates ^= bit

    for seed, vertex in enumerate(vertices):
        if vertex.direction == 0 and vertex.s == seed_s:
            search([seed], full & adjacency[seed])
    return search_nodes, records


def affine_nodes(chosen):
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
    inverse_count = pow(len(nodes), -1, Q)
    center_u = sum(node[0] for node in nodes) * inverse_count % Q
    center_v = sum(node[1] for node in nodes) * inverse_count % Q
    centered = [
        ((u - center_u) % Q, (v - center_v) % Q)
        for u, v in nodes
    ]
    if any(sum(node[axis] for node in centered) % Q for axis in range(2)):
        raise AssertionError("centering failed")
    return nodes, centered


def elementary_forms(nodes, maximum_degree=11):
    forms = [dict() for _ in range(maximum_degree + 1)]
    forms[0][(0, 0)] = 1
    factors = 0
    for u, v in nodes:
        factors += 1
        for degree in range(min(factors, maximum_degree), 0, -1):
            for (left, right), coefficient in forms[degree - 1].items():
                first = (left + 1, right)
                second = (left, right + 1)
                forms[degree][first] = (
                    forms[degree].get(first, 0) + coefficient * u
                ) % Q
                forms[degree][second] = (
                    forms[degree].get(second, 0) + coefficient * v
                ) % Q
    return [
        {monomial: coefficient for monomial, coefficient in form.items()
         if coefficient}
        for form in forms
    ]


def projection_spans(nodes, chosen):
    used = {vertex.direction for vertex in chosen}
    missing = set(range(len(BASE.DIRECTIONS))) - used
    if len(missing) != 12:
        raise AssertionError(missing)
    spans = []
    for direction in sorted(missing):
        u = BASE.DIRECTIONS[direction]
        inverse = pow(u, -1, Q)
        values = [(u * x + inverse * y) % Q for x, y in nodes]
        support = set(values)
        mask = sum(1 << value for value in support)
        if mask.bit_count() != len(support):
            raise AssertionError("projection support mismatch")
        spans.append(len(support))
    return spans


def analyze_record(record):
    chosen = [BASE.Vertex(*pair) for pair in record]
    for i, left in enumerate(chosen):
        if BASE.line_character(left, NONSQUARE) == 0:
            raise AssertionError(left)
        for j, right in enumerate(chosen[:i]):
            if (
                BASE.chi(BASE.node_q(left, right, NONSQUARE))
                != INTERNAL_NODE_CHARACTER
            ):
                raise AssertionError((left, right))
            for third in chosen[:j]:
                a_i, b_i = BASE.coefficients(left)
                a_j, b_j = BASE.coefficients(right)
                a_k, b_k = BASE.coefficients(third)
                determinant = (
                    left.s * (a_j * b_k - a_k * b_j)
                    - right.s * (a_i * b_k - a_k * b_i)
                    + third.s * (a_i * b_j - a_j * b_i)
                ) % Q
                if determinant == 0:
                    raise AssertionError((left, right, third))
    nodes, centered = affine_nodes(chosen)
    forms = elementary_forms(centered)
    if forms[1]:
        raise AssertionError(forms[1])
    forced_zero = {degree: not forms[degree] for degree in (9, 10, 11)}
    spans = projection_spans(nodes, chosen)
    return {
        "secants": sum(
            BASE.line_character(vertex, NONSQUARE) == 1 for vertex in chosen
        ),
        "passants": sum(
            BASE.line_character(vertex, NONSQUARE) == -1 for vertex in chosen
        ),
        "e9_zero": forced_zero[9],
        "e10_zero": forced_zero[10],
        "e11_zero": forced_zero[11],
        "forced_window": all(forced_zero.values()),
        "complete_centers": sum(span == Q for span in spans),
        "minimum_span": min(spans),
        "maximum_span": max(spans),
    }


def exact_output(workers):
    direct_model_check()
    seeds = tuple(range((Q + 1) // 2))
    if workers == 1:
        pieces = [enumerate_seed(seed) for seed in seeds]
    else:
        with multiprocessing.get_context("fork").Pool(workers) as pool:
            pieces = pool.map(enumerate_seed, seeds, chunksize=1)
    records = sorted(record for _, batch in pieces for record in batch)
    if len(records) != len({json.dumps(record) for record in records}):
        raise AssertionError("duplicate normalized records")
    analyses = [analyze_record(record) for record in records]

    def histogram(key):
        counts = Counter(analysis[key] for analysis in analyses)
        return [
            {key: value, "count": counts[value]}
            for value in sorted(counts)
        ]

    best_record = min(
        records,
        key=lambda record: (
            -analyze_record(record)["complete_centers"],
            -analyze_record(record)["maximum_span"],
            record,
        ),
    ) if records else None
    return {
        "schema": "c756-q47-external-deletion-v1",
        "q": Q,
        "conic": "UV=5W^2",
        "distinguished_line": "W=0 (secant)",
        "direction_count": len(BASE.DIRECTIONS),
        "vertex_count": len(BASE.vertices(NONSQUARE)),
        "internal_node_character": INTERNAL_NODE_CHARACTER,
        "normalized_seed_offsets": list(seeds),
        "search_nodes": sum(nodes for nodes, _ in pieces),
        "normalized_geometric_stars": len(records),
        "type_profiles": [
            {
                "secants": secants,
                "passants": passants,
                "count": count,
            }
            for (secants, passants), count in sorted(
                Counter(
                    (analysis["secants"], analysis["passants"])
                    for analysis in analyses
                ).items()
            )
        ],
        "e9_zero_stars": sum(analysis["e9_zero"] for analysis in analyses),
        "e10_zero_stars": sum(analysis["e10_zero"] for analysis in analyses),
        "e11_zero_stars": sum(analysis["e11_zero"] for analysis in analyses),
        "full_forced_window_stars": sum(
            analysis["forced_window"] for analysis in analyses
        ),
        "stars_with_any_complete_center": sum(
            analysis["complete_centers"] > 0 for analysis in analyses
        ),
        "stars_with_all_twelve_complete_centers": sum(
            analysis["complete_centers"] == 12 for analysis in analyses
        ),
        "maximum_complete_centers": max(
            (analysis["complete_centers"] for analysis in analyses), default=-1
        ),
        "minimum_span_histogram": histogram("minimum_span"),
        "maximum_span_histogram": histogram("maximum_span"),
        "best_witness": best_record,
        "base_geometry_script": BASE_PATH.name,
        "base_geometry_script_sha256": BASE_SHA256,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    parser.add_argument("--workers", type=int, default=1)
    arguments = parser.parse_args()
    if arguments.exact == (arguments.check is not None):
        parser.error("select exactly one of --exact or --check FILE")
    rendered = json.dumps(
        exact_output(arguments.workers), indent=2, sort_keys=True
    ) + "\n"
    if arguments.check is not None:
        if rendered != arguments.check.read_text():
            raise SystemExit(f"certificate mismatch: {arguments.check}")
        print(f"certificate ok: {arguments.check}")
    elif arguments.output is not None:
        arguments.output.write_text(rendered)
        print(f"wrote {arguments.output}")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
