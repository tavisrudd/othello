#!/usr/bin/env python3
"""Exact q=49 all-passant internal-star geometry audit for C756."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
FIELD_PATH = HERE / "2026-08-09-c756-q49-external-deletion-search.py"
FIELD_SHA256 = "7ec51984ce230f4129cc51a0bd82137923ae90661326074667b5b4c25e7533ad"


def load_field():
    if hashlib.sha256(FIELD_PATH.read_bytes()).hexdigest() != FIELD_SHA256:
        raise SystemExit("field engine hash mismatch")
    specification = importlib.util.spec_from_file_location(
        "c756_q49_field", FIELD_PATH
    )
    if specification is None or specification.loader is None:
        raise SystemExit(f"cannot load {FIELD_PATH}")
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


F = load_field()
Q = F.Q
NU = F.NU
INTERNAL_CHARACTER = 1
TARGET_SIZE = 11


def projective_directions():
    points = [(1, 0)] + [(x, 1) for x in range(Q)]
    internal = []
    for x, y in points:
        value = F.SUB[F.MUL[x][x]][F.MUL[NU][F.MUL[y][y]]]
        if F.CHI[value] == INTERNAL_CHARACTER:
            internal.append((x, y))
    if len(internal) != 25:
        raise AssertionError(len(internal))
    return internal


DIRECTION_POINTS = projective_directions()


def normal(direction):
    x, y = DIRECTION_POINTS[direction]
    if y == 0:
        return 0, 1
    return 1, F.MUL[F.NEG[x]][F.INV[y]]


NORMALS = [normal(direction) for direction in range(len(DIRECTION_POINTS))]
INV_NU = F.INV[NU]


def dual_q(a, b, s):
    return F.SUB[
        F.SUB[F.MUL[a][a]][F.MUL[INV_NU][F.MUL[b][b]]]
    ][F.MUL[s][s]]


VERTICES = [
    (direction, s)
    for direction, (a, b) in enumerate(NORMALS)
    for s in range(Q)
    if F.CHI[dual_q(a, b, s)] == 1
]
VERTEX_INDEX = {vertex: index for index, vertex in enumerate(VERTICES)}


def node_coordinates(left, right):
    a_i, b_i = NORMALS[left[0]]
    a_j, b_j = NORMALS[right[0]]
    determinant = F.SUB[F.MUL[a_i][b_j]][F.MUL[a_j][b_i]]
    if determinant == 0:
        raise AssertionError((left, right))
    x = F.MUL[
        F.SUB[F.MUL[F.NEG[left[1]]][b_j]][F.MUL[F.NEG[right[1]]][b_i]]
    ][F.INV[determinant]]
    y = F.MUL[
        F.SUB[F.MUL[a_i][F.NEG[right[1]]]][F.MUL[a_j][F.NEG[left[1]]]]
    ][F.INV[determinant]]
    return x, y


def node_q(left, right):
    x, y = node_coordinates(left, right)
    return F.SUB[
        F.SUB[F.MUL[x][x]][F.MUL[NU][F.MUL[y][y]]]
    ][1]


def graph():
    adjacency = [0] * len(VERTICES)
    for i, left in enumerate(VERTICES):
        for j, right in enumerate(VERTICES[:i]):
            if left[0] == right[0]:
                continue
            if F.CHI[node_q(left, right)] == INTERNAL_CHARACTER:
                adjacency[i] |= 1 << j
                adjacency[j] |= 1 << i
    return adjacency


ADJACENCY = None


def color_sort(candidates):
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


def enumerate_stars():
    global ADJACENCY
    ADJACENCY = graph()
    full = (1 << len(VERTICES)) - 1
    search_nodes = 0
    records = []
    forbidden_cache = {}

    def forbidden(i, j):
        key = (min(i, j), max(i, j))
        if key in forbidden_cache:
            return forbidden_cache[key]
        left, right = VERTICES[i], VERTICES[j]
        a_i, b_i = NORMALS[left[0]]
        a_j, b_j = NORMALS[right[0]]
        determinant = F.SUB[F.MUL[a_i][b_j]][F.MUL[a_j][b_i]]
        mask = 0
        for direction, (a_k, b_k) in enumerate(NORMALS):
            if direction in (left[0], right[0]):
                continue
            first_minor = F.SUB[F.MUL[a_j][b_k]][F.MUL[a_k][b_j]]
            second_minor = F.SUB[F.MUL[a_i][b_k]][F.MUL[a_k][b_i]]
            numerator = F.SUB[
                F.MUL[left[1]][first_minor]
            ][F.MUL[right[1]][second_minor]]
            value = F.MUL[F.NEG[numerator]][F.INV[determinant]]
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

    for seed, vertex in enumerate(VERTICES):
        if vertex[0] == 0:
            search([seed], full & ADJACENCY[seed])
    return search_nodes, sorted(records)


def direct_model_check():
    if F.CHI[F.NEG[1]] != 1 or F.CHI[NU] != -1:
        raise AssertionError((F.CHI[F.NEG[1]], F.CHI[NU]))
    if len(DIRECTION_POINTS) != 25 or len(VERTICES) != 600:
        raise AssertionError((len(DIRECTION_POINTS), len(VERTICES)))
    conic_points = []
    for x in range(Q):
        for y in range(Q):
            value = F.SUB[F.MUL[x][x]][F.MUL[NU][F.MUL[y][y]]]
            if value == 1:
                conic_points.append((x, y))
    if len(conic_points) != Q + 1:
        raise AssertionError(len(conic_points))
    projective_norm_one_orbit = {
        (1, 0) if y == 0 else (F.MUL[x][F.INV[y]], 1)
        for x, y in conic_points
    }
    if projective_norm_one_orbit != set(DIRECTION_POINTS):
        raise AssertionError("anisotropic torus is not transitive")
    for direction, s in VERTICES:
        a, b = NORMALS[direction]
        intersections = sum(
            F.ADD[F.ADD[F.MUL[a][x]][F.MUL[b][y]]][s] == 0
            for x, y in conic_points
        )
        if intersections != 0:
            raise AssertionError(((direction, s), intersections))


def exact_output():
    direct_model_check()
    search_nodes, records = enumerate_stars()
    return {
        "schema": "c756-q49-all-passant-v1",
        "field_model": "F_7[w]/(w^2-3), encoded a+7b",
        "q": Q,
        "nonsquare": NU,
        "conic": f"X^2-{NU}Y^2=W^2",
        "distinguished_line": "W=0 (passant)",
        "internal_node_character": INTERNAL_CHARACTER,
        "direction_count": len(DIRECTION_POINTS),
        "vertex_count": len(VERTICES),
        "search_nodes": search_nodes,
        "normalized_geometric_stars": len(records),
        "field_engine": FIELD_PATH.name,
        "field_engine_sha256": FIELD_SHA256,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--exact", action="store_true")
    parser.add_argument("--check", type=Path)
    parser.add_argument("--output", type=Path)
    arguments = parser.parse_args()
    if arguments.exact == (arguments.check is not None):
        parser.error("select exactly one of --exact or --check FILE")
    rendered = json.dumps(exact_output(), indent=2, sort_keys=True) + "\n"
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
