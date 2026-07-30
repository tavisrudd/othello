#!/usr/bin/env python3
"""Independent replay of the C611 q=17,19 orbit certificate."""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CERTIFICATE = ROOT / "notes" / "2026-07-29-c611-q17-q19-coherent-certificates.json"
GENERATOR = ROOT / "notes" / "2026-07-29-c611-q17-q19-coherent-certificates.py"


def load_generator():
    spec = importlib.util.spec_from_file_location("c611_generator", GENERATOR)
    if spec is None or spec.loader is None:
        raise RuntimeError("cannot load generator")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def replay_field(module, record: dict[str, object]) -> dict[str, int]:
    q = record["q"]
    all_points = module.points(q)
    conic = {
        point for point in all_points if (point[0] * point[2] - point[1] ** 2) % q == 0
    }
    off = [point for point in all_points if point not in conic]
    index = {point: i for i, point in enumerate(off)}
    neighbors = [0] * len(off)
    for left in range(len(off)):
        for right in range(left + 1, len(off)):
            if module.passant(off[left], off[right], q):
                neighbors[left] |= 1 << right
                neighbors[right] |= 1 << left

    matrices = list(module.pgl2(q))
    permutations = [
        [index[module.act(matrix, point, q)] for point in off] for matrix in matrices
    ]
    listed = {
        tuple(index[tuple(point)] for point in orbit["representative"])
        for orbit in record["orbits"]
    }
    triple_types = [
        tuple(index[tuple(point)] for point in triple)
        for triple in record["triple_orbit_types"]
    ]
    triple_type_index = {triple: i for i, triple in enumerate(triple_types)}
    covered: set[tuple[int, ...]] = set()
    orbit_by_arc = {
        tuple(index[tuple(point)] for point in orbit["representative"]): orbit
        for orbit in record["orbits"]
    }
    for arc, orbit_record in orbit_by_arc.items():
        if len(set(arc)) != 6:
            raise AssertionError("repeated point in representative")
        for i in range(6):
            for j in range(i + 1, 6):
                if not module.passant(off[arc[i]], off[arc[j]], q):
                    raise AssertionError("nonpassant chord in representative")
                for k in range(j + 1, 6):
                    if module.dot(
                        module.cross(off[arc[i]], off[arc[j]], q), off[arc[k]], q
                    ) == 0:
                        raise AssertionError("collinear triple in representative")
        for vertex in range(len(off)):
            if vertex in arc:
                continue
            if all(module.passant(off[x], off[vertex], q) for x in arc) and all(
                module.dot(module.cross(off[arc[i]], off[arc[j]], q), off[vertex], q)
                != 0
                for i in range(6)
                for j in range(i + 1, 6)
            ):
                raise AssertionError("listed six-arc extends")
        covered.update(
            tuple(sorted(permutation[x] for x in arc)) for permutation in permutations
        )
        signature = [0] * len(triple_types)
        for triple in itertools.combinations(arc, 3):
            canonical = min(
                tuple(sorted(permutation[x] for x in triple))
                for permutation in permutations
            )
            signature[triple_type_index[canonical]] += 1
        sparse = [[i, count] for i, count in enumerate(signature) if count]
        if sparse != orbit_record["triple_orbit_signature"]:
            raise AssertionError("triple-orbit signature mismatch")

    old = json.loads((ROOT / record["input"]["path"]).read_text())
    roots = [
        module.edge_key(*(index[tuple(point)] for point in item["representative"]))
        for item in old["roots"]
    ]
    rooted: set[tuple[int, ...]] = set()
    for root in roots:
        rooted |= module.rooted_arcs(root, off, neighbors, q, 6)
    if not rooted <= covered:
        raise AssertionError("listed orbits do not cover every rooted six-arc")
    if len(covered) != record["total_labelled_six_arcs"]:
        raise AssertionError("labelled orbit union has wrong size")
    if len(listed) != record["six_arc_orbits"]:
        raise AssertionError("orbit count mismatch")
    return {
        "q": q,
        "listed_orbits": len(listed),
        "covered_labelled_six_arcs": len(covered),
        "rooted_six_arcs_checked": len(rooted),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("certificate", nargs="?", type=Path, default=DEFAULT_CERTIFICATE)
    args = parser.parse_args()
    module = load_generator()
    data = json.loads(args.certificate.read_text())
    if data["schema"] != "c611-q17-q19-coherent-certificates-v1":
        raise AssertionError("unexpected certificate schema")
    result = [replay_field(module, record) for record in data["fields"]]
    print(json.dumps(result, sort_keys=True, separators=(",", ":")))


if __name__ == "__main__":
    main()
