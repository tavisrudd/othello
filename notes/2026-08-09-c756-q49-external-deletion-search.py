#!/usr/bin/env python3
"""Exact q=49 external-deletion geometry and divided E_7 audit for C756."""

from __future__ import annotations

import argparse
from collections import Counter
import json
import multiprocessing
from pathlib import Path


P = 7
Q = 49
TARGET_SIZE = 11


def raw_add(x, y):
    return ((x % P + y % P) % P) + P * ((x // P + y // P) % P)


def raw_neg(x):
    return ((-x % P) % P) + P * ((-(x // P) % P) % P)


def raw_mul(x, y):
    a, b = x % P, x // P
    c, d = y % P, y // P
    return ((a * c + 3 * b * d) % P) + P * ((a * d + b * c) % P)


ADD = [[raw_add(x, y) for y in range(Q)] for x in range(Q)]
NEG = [raw_neg(x) for x in range(Q)]
SUB = [[ADD[x][NEG[y]] for y in range(Q)] for x in range(Q)]
MUL = [[raw_mul(x, y) for y in range(Q)] for x in range(Q)]


def field_pow(x, exponent):
    result = 1
    while exponent:
        if exponent & 1:
            result = MUL[result][x]
        x = MUL[x][x]
        exponent >>= 1
    return result


INV = [0] + [field_pow(x, Q - 2) for x in range(1, Q)]
CHI = [0] + [1 if field_pow(x, (Q - 1) // 2) == 1 else -1
             for x in range(1, Q)]
NU = next(x for x in range(2, Q) if CHI[x] == -1)
FOUR_NU = MUL[4][NU]
INTERNAL_NODE_CHARACTER = 1


def canonical_sign(x):
    return min(x, NEG[x])


DIRECTIONS = sorted({canonical_sign(x) for x in range(1, Q)})
COEFFICIENTS = [(u, INV[u]) for u in DIRECTIONS]
VERTICES = [
    (direction, s)
    for direction in range(len(DIRECTIONS))
    for s in range(Q)
    if SUB[MUL[s][s]][FOUR_NU] != 0
]
VERTEX_INDEX = {vertex: index for index, vertex in enumerate(VERTICES)}


def node_coordinates(left, right):
    a_i, b_i = COEFFICIENTS[left[0]]
    a_j, b_j = COEFFICIENTS[right[0]]
    determinant = SUB[MUL[a_i][b_j]][MUL[a_j][b_i]]
    if determinant == 0:
        raise AssertionError((left, right))
    u = MUL[
        SUB[MUL[b_i][right[1]]][MUL[b_j][left[1]]]
    ][INV[determinant]]
    v = MUL[
        SUB[MUL[a_j][left[1]]][MUL[a_i][right[1]]]
    ][INV[determinant]]
    return u, v


def node_q(left, right):
    u, v = node_coordinates(left, right)
    return SUB[MUL[u][v]][NU]


def geometry_graph():
    adjacency = [0] * len(VERTICES)
    for i, left in enumerate(VERTICES):
        for j, right in enumerate(VERTICES[:i]):
            if left[0] == right[0]:
                continue
            if CHI[node_q(left, right)] == INTERNAL_NODE_CHARACTER:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return adjacency


ADJACENCY = None


def initialize_graph():
    global ADJACENCY
    if ADJACENCY is None:
        ADJACENCY = geometry_graph()


def color_sort(candidates):
    if ADJACENCY is None:
        raise AssertionError("graph is not initialized")
    order = []
    bounds = []
    remaining = candidates
    color = 0
    while remaining:
        color += 1
        available = remaining
        while available:
            bit = available & -available
            vertex = bit.bit_length() - 1
            order.append(vertex)
            bounds.append(color)
            remaining ^= bit
            available ^= bit
            available &= ~ADJACENCY[vertex]
    return order, bounds


def enumerate_seed(seed_s):
    if ADJACENCY is None:
        raise AssertionError("graph is not initialized")
    full = (1 << len(VERTICES)) - 1
    search_nodes = 0
    records = []
    forbidden_cache = {}

    def forbidden(i, j):
        key = (min(i, j), max(i, j))
        if key in forbidden_cache:
            return forbidden_cache[key]
        left, right = VERTICES[i], VERTICES[j]
        a_i, b_i = COEFFICIENTS[left[0]]
        a_j, b_j = COEFFICIENTS[right[0]]
        determinant = SUB[MUL[a_i][b_j]][MUL[a_j][b_i]]
        mask = 0
        for direction, (a_k, b_k) in enumerate(COEFFICIENTS):
            if direction in (left[0], right[0]):
                continue
            first_minor = SUB[MUL[a_j][b_k]][MUL[a_k][b_j]]
            second_minor = SUB[MUL[a_i][b_k]][MUL[a_k][b_i]]
            numerator = SUB[
                MUL[left[1]][first_minor]
            ][MUL[right[1]][second_minor]]
            value = MUL[NEG[numerator]][INV[determinant]]
            vertex = VERTEX_INDEX.get((direction, value))
            if vertex is not None:
                mask |= 1 << vertex
        forbidden_cache[key] = mask
        return mask

    def search(chosen, candidates):
        nonlocal search_nodes
        search_nodes += 1
        if len(chosen) == TARGET_SIZE:
            records.append([list(VERTICES[index]) for index in sorted(chosen)])
            return
        order, bounds = color_sort(candidates)
        for position in range(len(order) - 1, -1, -1):
            if len(chosen) + bounds[position] < TARGET_SIZE:
                return
            vertex = order[position]
            bit = 1 << vertex
            if not candidates & bit:
                continue
            next_candidates = candidates & ADJACENCY[vertex]
            for prior in chosen:
                next_candidates &= ~forbidden(prior, vertex)
            chosen.append(vertex)
            search(chosen, next_candidates)
            chosen.pop()
            candidates ^= bit

    seed = VERTEX_INDEX.get((0, seed_s))
    if seed is not None:
        search([seed], full & ADJACENCY[seed])
    return search_nodes, records


def affine_nodes(chosen):
    nodes = [
        node_coordinates(left, right)
        for i, left in enumerate(chosen)
        for right in chosen[:i]
    ]
    if len(nodes) != 55:
        raise AssertionError(len(nodes))
    inverse_count = INV[55 % P]
    center_u = 0
    center_v = 0
    for u, v in nodes:
        center_u = ADD[center_u][u]
        center_v = ADD[center_v][v]
    center_u = MUL[center_u][inverse_count]
    center_v = MUL[center_v][inverse_count]
    centered = [(SUB[u][center_u], SUB[v][center_v]) for u, v in nodes]
    if any(
        value
        for axis in range(2)
        for value in [
            __import__("functools").reduce(
                lambda total, node: ADD[total][node[axis]], centered, 0
            )
        ]
    ):
        raise AssertionError("centering failed")
    return nodes, centered


def elementary_forms(nodes, maximum_degree=13):
    forms = [dict() for _ in range(maximum_degree + 1)]
    forms[0][(0, 0)] = 1
    factors = 0
    for u, v in nodes:
        factors += 1
        for degree in range(min(factors, maximum_degree), 0, -1):
            for (left, right), coefficient in forms[degree - 1].items():
                first = (left + 1, right)
                second = (left, right + 1)
                forms[degree][first] = ADD[
                    forms[degree].get(first, 0)
                ][MUL[coefficient][u]]
                forms[degree][second] = ADD[
                    forms[degree].get(second, 0)
                ][MUL[coefficient][v]]
    return [
        {monomial: coefficient for monomial, coefficient in form.items()
         if coefficient}
        for form in forms
    ]


def evaluate_form(form, left, right):
    total = 0
    for (left_degree, right_degree), coefficient in form.items():
        value = MUL[
            MUL[coefficient][field_pow(left, left_degree)]
        ][field_pow(right, right_degree)]
        total = ADD[total][value]
    return total


def scalar_elementary_seven(values):
    coefficients = [1] + [0] * 7
    factors = 0
    for value in values:
        factors += 1
        for degree in range(min(factors, 7), 0, -1):
            coefficients[degree] = ADD[
                coefficients[degree]
            ][MUL[coefficients[degree - 1]][value]]
    return coefficients[7]


def check_e7_evaluations(centered, form):
    projective_dual_points = [(1, 0)] + [(left, 1) for left in range(Q)]
    for left, right in projective_dual_points:
        values = [
            ADD[MUL[left][u]][MUL[right][v]]
            for u, v in centered
        ]
        direct = scalar_elementary_seven(values)
        expanded = evaluate_form(form, left, right)
        if direct != expanded:
            raise AssertionError(((left, right), direct, expanded))


def projection_spans(nodes, chosen):
    used = {vertex[0] for vertex in chosen}
    missing = set(range(len(DIRECTIONS))) - used
    if len(missing) != 13:
        raise AssertionError(missing)
    spans = []
    for direction in sorted(missing):
        u, inverse = COEFFICIENTS[direction]
        support = {
            ADD[MUL[u][x]][MUL[inverse][y]]
            for x, y in nodes
        }
        mask = sum(1 << value for value in support)
        if mask.bit_count() != len(support):
            raise AssertionError("projection support mismatch")
        spans.append(len(support))
    return spans


def line_character(vertex):
    discriminant = SUB[MUL[vertex[1]][vertex[1]]][FOUR_NU]
    return CHI[discriminant]


def analyze(record):
    chosen = [tuple(pair) for pair in record]
    nodes, centered = affine_nodes(chosen)
    forms = elementary_forms(centered)
    if forms[1]:
        raise AssertionError(forms[1])
    check_e7_evaluations(centered, forms[7])
    spans = projection_spans(nodes, chosen)
    return {
        "secants": sum(line_character(vertex) == 1 for vertex in chosen),
        "passants": sum(line_character(vertex) == -1 for vertex in chosen),
        "e7_zero": not forms[7],
        "e8_zero": not forms[8],
        "e9_zero": not forms[9],
        "e10_zero": not forms[10],
        "e11_zero": not forms[11],
        "e12_zero": not forms[12],
        "forced_window": all(not forms[degree] for degree in range(7, 13)),
        "complete_centers": sum(span == Q for span in spans),
        "minimum_span": min(spans),
        "maximum_span": max(spans),
    }


def direct_model_check():
    if MUL[7][7] != 3:
        raise AssertionError("field polynomial mismatch")
    for value in range(1, Q):
        if MUL[value][INV[value]] != 1:
            raise AssertionError((value, INV[value]))
    if CHI[NU] != -1 or CHI[NEG[1]] != 1:
        raise AssertionError((NU, CHI[NEG[1]]))
    if CHI[FOUR_NU] != -1:
        raise AssertionError(FOUR_NU)
    if len(DIRECTIONS) != 24 or len(VERTICES) != 24 * 49:
        raise AssertionError((len(DIRECTIONS), len(VERTICES)))
    for u, inverse in COEFFICIENTS:
        if CHI[MUL[inverse][NEG[u]]] != INTERNAL_NODE_CHARACTER:
            raise AssertionError((u, inverse))
    conic_points = (
        [(u, MUL[NU][INV[u]], 1) for u in range(1, Q)]
        + [(1, 0, 0), (0, 1, 0)]
    )
    if len(conic_points) != Q + 1:
        raise AssertionError(len(conic_points))
    two_nu = MUL[2][NU]
    for x in range(Q):
        for y in range(Q):
            value = SUB[MUL[x][y]][NU]
            if value == 0:
                continue
            tangent_count = 0
            for tangent_u, tangent_v, tangent_w in conic_points:
                incidence = SUB[
                    ADD[MUL[tangent_v][x]][MUL[tangent_u][y]]
                ][MUL[two_nu][tangent_w]]
                tangent_count += incidence == 0
            expected = 0 if CHI[value] == INTERNAL_NODE_CHARACTER else 2
            if tangent_count != expected:
                raise AssertionError(((x, y), value, tangent_count, expected))


def histogram(analyses, key):
    counts = Counter(analysis[key] for analysis in analyses)
    return [{key: value, "count": counts[value]} for value in sorted(counts)]


def exact_output(workers):
    direct_model_check()
    initialize_graph()
    seeds = sorted({canonical_sign(s) for s in range(Q)})
    if workers == 1:
        pieces = [enumerate_seed(seed) for seed in seeds]
    else:
        with multiprocessing.get_context("fork").Pool(workers) as pool:
            pieces = pool.map(enumerate_seed, seeds, chunksize=1)
    records = sorted(record for _, batch in pieces for record in batch)
    if len(records) != len({json.dumps(record) for record in records}):
        raise AssertionError("duplicate normalized records")
    analyses = [analyze(record) for record in records]
    return {
        "schema": "c756-q49-external-deletion-v1",
        "field_model": "F_7[w]/(w^2-3), encoded a+7b",
        "q": Q,
        "nonsquare": NU,
        "conic": f"UV={NU}W^2",
        "distinguished_line": "W=0 (secant)",
        "internal_node_character": INTERNAL_NODE_CHARACTER,
        "direction_count": len(DIRECTIONS),
        "vertex_count": len(VERTICES),
        "normalized_seed_offsets": seeds,
        "search_nodes": sum(nodes for nodes, _ in pieces),
        "normalized_geometric_stars": len(records),
        "type_profiles": [
            {"secants": key[0], "passants": key[1], "count": count}
            for key, count in sorted(Counter(
                (analysis["secants"], analysis["passants"])
                for analysis in analyses
            ).items())
        ],
        "e7_zero_stars": sum(analysis["e7_zero"] for analysis in analyses),
        "full_forced_window_stars": sum(
            analysis["forced_window"] for analysis in analyses
        ),
        "stars_with_any_complete_center": sum(
            analysis["complete_centers"] > 0 for analysis in analyses
        ),
        "stars_with_all_thirteen_complete_centers": sum(
            analysis["complete_centers"] == 13 for analysis in analyses
        ),
        "maximum_complete_centers": max(
            (analysis["complete_centers"] for analysis in analyses), default=-1
        ),
        "minimum_span_histogram": histogram(analyses, "minimum_span"),
        "maximum_span_histogram": histogram(analyses, "maximum_span"),
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
