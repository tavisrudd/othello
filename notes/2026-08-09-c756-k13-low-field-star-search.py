#!/usr/bin/env python3
"""Exact k=13 geometric star gates at q=47,49,53 for C756."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import multiprocessing
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
FILES = {
    "q47_external": (
        "2026-08-09-c756-q47-external-deletion-search.py",
        "75aa40736cb3fb2442115760b7a35d99e010172d7a58769a6a237079b818de8b",
    ),
    "q49_external": (
        "2026-08-09-c756-q49-external-deletion-search.py",
        "7ec51984ce230f4129cc51a0bd82137923ae90661326074667b5b4c25e7533ad",
    ),
    "q53_external": (
        "2026-08-09-c756-aligned-split-mixed-search.py",
        "f1c11decc6df8c5e9bc0a57a5e98dfd35c9fdd2c4ce8fabaa3db5b115ab9249f",
    ),
    "q53_internal": (
        "2026-08-09-c756-aligned-node-clique.py",
        "bf3c2fe00f9b09e2889532da697f9ef09d9ecffdfac2785d232541f164b79bbb",
    ),
}
CERTIFICATES = {
    "q47_internal_no_size_11": (
        "2026-08-09-c756-q47-all-passant-search.json",
        "4d56e438a115b3db56a7ec32e17b6d10b4568d66c0b1a2050fb9a7e92fc52e2e",
    ),
    "q49_internal_no_size_11": (
        "2026-08-09-c756-q49-all-passant-search.json",
        "3abca4f2973b3c4a5c2f0e9c8cb78c2ef355861894abed53ae39b2444da4f419",
    ),
}
TARGET_SIZE = 12


def verify_hashes():
    for filename, expected in list(FILES.values()) + list(CERTIFICATES.values()):
        actual = hashlib.sha256((HERE / filename).read_bytes()).hexdigest()
        if actual != expected:
            raise SystemExit(f"hash mismatch for {filename}: {actual}")


def load(name):
    filename, _ = FILES[name]
    path = HERE / filename
    specification = importlib.util.spec_from_file_location(
        f"c756_k13_{name}", path
    )
    if specification is None or specification.loader is None:
        raise SystemExit(f"cannot load {path}")
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


def enumerate_sharded(module, seeds, workers):
    module.TARGET_SIZE = TARGET_SIZE
    if hasattr(module, "initialize_graph"):
        module.initialize_graph()
    if workers == 1:
        pieces = [module.enumerate_seed(seed) for seed in seeds]
    else:
        with multiprocessing.get_context("fork").Pool(workers) as pool:
            pieces = pool.map(module.enumerate_seed, seeds, chunksize=1)
    return {
        "search_nodes": sum(nodes for nodes, _ in pieces),
        "normalized_geometric_stars": sum(len(records) for _, records in pieces),
    }


def q53_internal():
    module = load("q53_internal")
    vertices, adjacency = module.graph(1, module.NONSQUARE, 1)
    forbidden = module.concurrency_forbidden_masks(vertices)
    full = (1 << len(vertices)) - 1
    search_nodes = 0
    leaves = 0

    def search(chosen, candidates):
        nonlocal search_nodes, leaves
        search_nodes += 1
        if len(chosen) == TARGET_SIZE:
            leaves += 1
            return
        order, bounds = module.color_sort(candidates, adjacency)
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
        if vertex.direction == 0:
            search([seed], full & adjacency[seed])
    return {
        "vertex_count": len(vertices),
        "search_nodes": search_nodes,
        "normalized_geometric_stars": leaves,
    }


def exact_output(workers):
    verify_hashes()

    q47 = load("q47_external")
    q47_result = enumerate_sharded(
        q47, tuple(range((q47.Q + 1) // 2)), workers
    )
    q47_result.update(
        {
            "q": 47,
            "external_vertex_count": len(q47.BASE.vertices(q47.NONSQUARE)),
            "all_internal_no_size_11": True,
        }
    )

    q49 = load("q49_external")
    q49_result = enumerate_sharded(
        q49,
        sorted({q49.canonical_sign(value) for value in range(q49.Q)}),
        workers,
    )
    q49_result.update(
        {
            "q": 49,
            "external_vertex_count": len(q49.VERTICES),
            "all_internal_no_size_11": True,
        }
    )

    q53_external = load("q53_external")
    q53_external.TARGET_SIZE = TARGET_SIZE
    external_result = q53_external.enumerate_parallel(
        q53_external.NONSQUARE, workers
    )
    q53_internal_result = q53_internal()
    q53_result = {
        "q": 53,
        "external_vertex_count": int(external_result["vertex_count"]),
        "external_search_nodes": int(external_result["search_nodes"]),
        "external_normalized_geometric_stars": int(
            external_result["normalized_candidates"]
        ),
        "internal_vertex_count": q53_internal_result["vertex_count"],
        "internal_search_nodes": q53_internal_result["search_nodes"],
        "internal_normalized_geometric_stars": q53_internal_result[
            "normalized_geometric_stars"
        ],
    }

    if any(
        (
            q47_result["normalized_geometric_stars"],
            q49_result["normalized_geometric_stars"],
            q53_result["external_normalized_geometric_stars"],
            q53_result["internal_normalized_geometric_stars"],
        )
    ):
        raise AssertionError("unexpected twelve-line star")

    return {
        "schema": "c756-k13-low-field-star-v1",
        "k": 13,
        "arrangement_line_count": TARGET_SIZE,
        "fields": [q47_result, q49_result, q53_result],
        "pinned_files": {
            key: {"filename": value[0], "sha256": value[1]}
            for key, value in {**FILES, **CERTIFICATES}.items()
        },
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
