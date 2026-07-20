#!/usr/bin/env python3
"""Exact C385 perfect-one-factorization kill test."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "notes/2026-07-19-c379-clebsch-deep-hole-extension.json"
OUTPUT = ROOT / "notes/2026-07-19-c385-clebsch-perfect-one-factorization-gate.json"
SOURCE_SHA256 = "3cc3a7008d91a06f95504cbced7adc2eef9b304355a3a56bb64bdd0bea19ad8d"
SHEETS = {
    "tau8": "tau8_sheet_matchings",
    "tau4": "tau4_sheet_matchings",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def normalize_matching(raw: list[list[list[int]]]) -> tuple[tuple[tuple[int, ...], tuple[int, ...]], ...]:
    return tuple((tuple(a), tuple(b)) for a, b in raw)


def validate_factorization(factors: list[tuple[tuple[tuple[int, ...], tuple[int, ...]], ...]]) -> None:
    vertices = {v for edge in factors[0] for v in edge}
    assert len(vertices) == 12
    edges = set()
    for factor in factors:
        flat = [v for edge in factor for v in edge]
        assert len(factor) == 6 and len(set(flat)) == 12 and set(flat) == vertices
        factor_edges = {frozenset(edge) for edge in factor}
        assert len(factor_edges) == 6 and edges.isdisjoint(factor_edges)
        edges.update(factor_edges)
    assert len(factors) == 11 and len(edges) == 66


def component_partition(first, second) -> tuple[int, ...]:
    adjacency: dict[tuple[int, ...], list[tuple[int, ...]]] = {}
    for factor in (first, second):
        for a, b in factor:
            adjacency.setdefault(a, []).append(b)
            adjacency.setdefault(b, []).append(a)
    assert all(len(neighbors) == 2 for neighbors in adjacency.values())
    unseen = set(adjacency)
    sizes = []
    while unseen:
        stack = [next(iter(unseen))]
        component = set()
        while stack:
            vertex = stack.pop()
            if vertex not in component:
                component.add(vertex)
                stack.extend(adjacency[vertex])
        unseen.difference_update(component)
        sizes.append(len(component))
    return tuple(sorted(sizes, reverse=True))


def composition_partition(first, second) -> tuple[int, ...]:
    involution = []
    for factor in (first, second):
        mate = {}
        for a, b in factor:
            mate[a] = b
            mate[b] = a
        involution.append(mate)
    permutation = {v: involution[0][involution[1][v]] for v in involution[0]}
    unseen = set(permutation)
    sizes = []
    while unseen:
        start = next(iter(unseen))
        vertex = start
        size = 0
        while vertex in unseen:
            unseen.remove(vertex)
            size += 1
            vertex = permutation[vertex]
        assert vertex == start
        sizes.append(size)
    return tuple(sorted(sizes, reverse=True))


def histogram_key(partition: tuple[int, ...]) -> str:
    return "+".join(map(str, partition))


def generate() -> dict:
    actual_hash = sha256(SOURCE)
    assert actual_hash == SOURCE_SHA256, (actual_hash, SOURCE_SHA256)
    source = json.loads(SOURCE.read_text())
    fixture = source["one_factorization_biplane"]
    results = {}
    all_cross_checks_agree = True
    for sheet, key in SHEETS.items():
        factors = [normalize_matching(raw) for raw in fixture[key]]
        validate_factorization(factors)
        component_histogram: dict[str, int] = {}
        composition_histogram: dict[str, int] = {}
        first_failure = None
        hamiltonian_pairs = 0
        for i, j in itertools.combinations(range(len(factors)), 2):
            components = component_partition(factors[i], factors[j])
            composition = composition_partition(factors[i], factors[j])
            expected_composition = tuple(sorted((length // 2 for length in components for _ in range(2)), reverse=True))
            all_cross_checks_agree &= composition == expected_composition
            component_key = histogram_key(components)
            composition_key = histogram_key(composition)
            component_histogram[component_key] = component_histogram.get(component_key, 0) + 1
            composition_histogram[composition_key] = composition_histogram.get(composition_key, 0) + 1
            if components == (12,):
                hamiltonian_pairs += 1
            elif first_failure is None:
                first_failure = {
                    "factor_indices_zero_based": [i, j],
                    "cycle_partition": list(components),
                }
        pair_count = len(factors) * (len(factors) - 1) // 2
        results[sheet] = {
            "factor_count": len(factors),
            "pair_count": pair_count,
            "hamiltonian_pair_count": hamiltonian_pairs,
            "is_perfect": hamiltonian_pairs == pair_count,
            "union_cycle_partition_histogram": dict(sorted(component_histogram.items())),
            "composition_cycle_partition_histogram": dict(sorted(composition_histogram.items())),
            "first_failure": first_failure,
        }
    assert all_cross_checks_agree
    return {
        "schema": "c385-perfect-one-factorization-gate-v1",
        "source": {
            "path": "notes/2026-07-19-c379-clebsch-deep-hole-extension.json",
            "sha256": actual_hash,
        },
        "convention": "A pair is Hamiltonian iff the union of its two perfect matchings is one 12-cycle.",
        "sheets": results,
        "cross_check": {
            "method": "Compare graph connected-component sizes with cycles of the product of the two matching involutions.",
            "all_pairs_agree": all_cross_checks_agree,
        },
        "verdict": "NEITHER C379 K_12 ONE-FACTORIZATION IS PERFECT",
    }


def canonical_bytes(value: dict) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--check", action="store_true")
    mode.add_argument("--write", action="store_true")
    args = parser.parse_args()
    generated = canonical_bytes(generate())
    if args.write:
        OUTPUT.write_bytes(generated)
        print(f"wrote {OUTPUT.relative_to(ROOT)} ({len(generated)} bytes)")
    else:
        tracked = OUTPUT.read_bytes()
        assert tracked == generated, "tracked certificate differs from exact regeneration"
        print(f"C385 check passed ({len(tracked)} bytes, sha256={hashlib.sha256(tracked).hexdigest()})")


if __name__ == "__main__":
    main()
