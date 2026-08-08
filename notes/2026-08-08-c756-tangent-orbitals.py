#!/usr/bin/env python3
"""Exact stabilizer-orbital census for the C756 local tangent graphs.

The conic stabilizer is PGL(2,q) acting on binary quadratic forms.  This script
enumerates the subgroup fixing the pointed internal vertex, transports it to the
local tangent graph, and counts its vertex, edge, and nonedge orbits.  The result is
a bounded discriminator for the complexity of symmetry-averaged PSD completions.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
GRAPH_SOURCE = HERE / "2026-08-08-c756-passant-code-equality.py"
OUTPUT = HERE / "2026-08-08-c756-tangent-orbitals.json"


def load_graph_module():
    spec = importlib.util.spec_from_file_location("c756_passant_equality", GRAPH_SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {GRAPH_SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


GRAPH = load_graph_module()


def canonical_projective(F, vector):
    pivot = next(value for value in vector if value != 0)
    inverse = F.inv(pivot)
    return tuple(F.mul(value, inverse) for value in vector)


def determinant(F, matrix):
    a, b, c, d = matrix
    return F.add(F.mul(a, d), F.neg(F.mul(b, c)))


def canonical_matrix(F, matrix):
    return canonical_projective(F, matrix)


def pgl2(F):
    matrices = set()
    for a in range(F.q):
        for b in range(F.q):
            for c in range(F.q):
                for d in range(F.q):
                    matrix = (a, b, c, d)
                    if determinant(F, matrix) != 0:
                        matrices.add(canonical_matrix(F, matrix))
    expected = F.q * (F.q * F.q - 1)
    assert len(matrices) == expected
    return sorted(matrices)


def act_on_quadratic(F, matrix, point):
    """Substitute (aX+bY,cX+dY) into xX^2+yXY+wY^2."""
    a, b, c, d = matrix
    x, y, w = point
    add, mul = F.add, F.mul
    two = add(1, 1)
    first = add(add(mul(x, mul(a, a)), mul(y, mul(a, c))), mul(w, mul(c, c)))
    middle = add(
        add(mul(two, mul(x, mul(a, b))), mul(y, add(mul(a, d), mul(b, c)))),
        mul(two, mul(w, mul(c, d))),
    )
    last = add(add(mul(x, mul(b, b)), mul(y, mul(b, d))), mul(w, mul(d, d)))
    return canonical_projective(F, (first, middle, last))


def orbit_partition(items, permutations, pair=False):
    remaining = set(items)
    sizes = []
    while remaining:
        seed = min(remaining)
        if pair:
            orbit = {tuple(sorted((permutation[seed[0]], permutation[seed[1]])))
                     for permutation in permutations}
        else:
            orbit = {permutation[seed] for permutation in permutations}
        assert orbit <= remaining | (set(items) - remaining)
        remaining -= orbit
        sizes.append(len(orbit))
    return sorted(sizes)


def field_census(p, exponent):
    F = GRAPH.INV.GF(p, exponent)
    plane = GRAPH.INV.Plane(F)
    points, gamma_neighbors = plane.graph()
    point_index = {point: index for index, point in enumerate(points)}
    base_index = 0
    base = points[base_index]
    local_global = [index for index in range(len(points))
                    if (gamma_neighbors[base_index] >> index) & 1]
    local_index = {global_index: index for index, global_index in enumerate(local_global)}
    q, tangent_neighbors, tangent_sign = GRAPH.build_tangent_graph(p, exponent)
    assert q == F.q and len(tangent_neighbors) == len(local_global)

    stabilizer = []
    for matrix in pgl2(F):
        if act_on_quadratic(F, matrix, base) != base:
            continue
        global_permutation = [point_index[act_on_quadratic(F, matrix, point)]
                              for point in points]
        local_permutation = tuple(local_index[global_permutation[index]]
                                  for index in local_global)
        assert sorted(local_permutation) == list(range(len(local_global)))
        assert all(
            ((tangent_neighbors[i] >> j) & 1)
            == ((tangent_neighbors[local_permutation[i]] >> local_permutation[j]) & 1)
            for i in range(len(local_global))
            for j in range(i + 1, len(local_global))
        )
        stabilizer.append(local_permutation)

    assert len(stabilizer) == 2 * (q + 1)
    assert len(set(stabilizer)) == len(stabilizer)
    vertices = list(range(len(local_global)))
    edges = [(i, j) for i in vertices for j in range(i + 1, len(vertices))
             if (tangent_neighbors[i] >> j) & 1]
    nonedges = [(i, j) for i in vertices for j in range(i + 1, len(vertices))
                if not ((tangent_neighbors[i] >> j) & 1)]
    vertex_orbits = orbit_partition(vertices, stabilizer)
    edge_orbits = orbit_partition(edges, stabilizer, pair=True)
    nonedge_orbits = orbit_partition(nonedges, stabilizer, pair=True)
    return {
        "q": q,
        "vertices": len(vertices),
        "required_tangent_holonomy": tangent_sign,
        "point_stabilizer_order": len(stabilizer),
        "vertex_orbit_count": len(vertex_orbits),
        "vertex_orbit_sizes": vertex_orbits,
        "edge_orbit_count": len(edge_orbits),
        "edge_orbit_sizes": edge_orbits,
        "nonedge_orbit_count": len(nonedge_orbits),
        "nonedge_orbit_sizes": nonedge_orbits,
        "symmetric_completion_variable_count": 1 + len(nonedge_orbits),
    }


def generate():
    fields = [(5, 1), (7, 1), (3, 2), (11, 1), (13, 1), (17, 1), (19, 1)]
    return {
        "schema": "c756-tangent-orbitals-v1",
        "graph_source": {
            "path": "notes/2026-08-08-c756-passant-code-equality.py",
            "bytes": GRAPH_SOURCE.stat().st_size,
            "sha256": hashlib.sha256(GRAPH_SOURCE.read_bytes()).hexdigest(),
        },
        "fields": [field_census(p, exponent) for p, exponent in fields],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(generate(), indent=1, sort_keys=True) + "\n"
    if args.check:
        if OUTPUT.read_text() != rendered:
            raise SystemExit(f"generated output differs from {OUTPUT}")
        print(f"ok: {OUTPUT.name}")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
