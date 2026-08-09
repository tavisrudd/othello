#!/usr/bin/env python3
"""Exact genuine all-passant geometry row for C756 at q=47."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import sys
import types


HERE = Path(__file__).resolve().parent
BASE_PATH = HERE / "2026-08-09-c756-aligned-node-clique.py"
BASE_SHA256 = "bf3c2fe00f9b09e2889532da697f9ef09d9ecffdfac2785d232541f164b79bbb"
Q = 47
D = 1
INTERNAL_NODE_CHARACTER = -1


def load_base():
    if hashlib.sha256(BASE_PATH.read_bytes()).hexdigest() != BASE_SHA256:
        raise SystemExit("base geometry script hash mismatch")
    source = BASE_PATH.read_text()
    marker = "\nQ = 53\n"
    if source.count(marker) != 1:
        raise SystemExit("q marker mismatch in base geometry script")
    source = source.replace(marker, f"\nQ = {Q}\n")
    module = types.ModuleType("c756_q47_all_passant_geometry")
    module.__file__ = str(BASE_PATH)
    sys.modules[module.__name__] = module
    exec(compile(source, str(BASE_PATH), "exec"), module.__dict__)
    if module.Q != Q:
        raise AssertionError(module.Q)
    return module


BASE = load_base()


def direct_geometry_check(vertices):
    nu = BASE.NONSQUARE
    conic_points = [
        (x, y)
        for x in range(Q)
        for y in range(Q)
        if (x * x - nu * y * y) % Q == D
    ]
    if len(conic_points) != Q + 1:
        raise AssertionError(len(conic_points))
    for vertex in vertices:
        alpha = BASE.ALPHA0 * BASE.TORUS[vertex.direction]
        a = 2 * alpha.a % Q
        b = 2 * nu * alpha.b % Q
        intersections = sum(
            (a * x + b * y + vertex.s) % Q == 0
            for x, y in conic_points
        )
        if intersections != 0:
            raise AssertionError((vertex, intersections))
    # The kernel of a normal alpha=(a,b) is represented by (nu*b,-a).
    # For d=1 and q=47 its conic value is nonsquare, the internal character.
    alpha = BASE.ALPHA0
    direction_q = (
        (BASE.NONSQUARE * alpha.b) ** 2
        - BASE.NONSQUARE * alpha.a ** 2
    ) % Q
    if BASE.chi(direction_q) != INTERNAL_NODE_CHARACTER:
        raise AssertionError((direction_q, BASE.chi(direction_q)))


def exact_output():
    vertices, adjacency = BASE.graph(
        D, BASE.NONSQUARE, INTERNAL_NODE_CHARACTER
    )
    direct_geometry_check(vertices)
    records, search_nodes = BASE.enumerate_arc_cliques(vertices, adjacency)
    if records:
        raise AssertionError("unexpected q=47 all-passant star")
    return {
        "schema": "c756-q47-all-passant-v1",
        "q": Q,
        "quadratic_extension_nonsquare": BASE.NONSQUARE,
        "conic": "N(x)=W^2",
        "distinguished_line": "W=0 (passant)",
        "normal_norm_character": BASE.chi(BASE.ALPHA0.norm()),
        "internal_node_character": INTERNAL_NODE_CHARACTER,
        "direction_count": len(BASE.TORUS),
        "vertex_count": len(vertices),
        "search_nodes": search_nodes,
        "normalized_geometric_stars": len(records),
        "base_geometry_script": BASE_PATH.name,
        "base_geometry_script_sha256": BASE_SHA256,
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
