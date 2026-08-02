#!/usr/bin/env python3
"""Exact small-order fibres of the aligned-four-set functor on two-graphs."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter, defaultdict
from pathlib import Path


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-08-02-c794-aligned-design-fibres.json"


def edge_tables(n: int):
    edges = list(itertools.combinations(range(1, n), 2))
    return edges, {edge: i for i, edge in enumerate(edges)}


def edge(mask: int, positions: dict[tuple[int, int], int], i: int, j: int) -> int:
    if i == 0 or j == 0:
        return 0
    if i > j:
        i, j = j, i
    return (mask >> positions[(i, j)]) & 1


def triple_bit(mask: int, positions: dict[tuple[int, int], int], triple) -> int:
    i, j, k = triple
    return edge(mask, positions, i, j) ^ edge(mask, positions, i, k) ^ edge(mask, positions, j, k)


def direct_aligned(mask: int, positions, four) -> bool:
    bits = [triple_bit(mask, positions, triple) for triple in itertools.combinations(four, 3)]
    return bits.count(bits[0]) == 4


def switched_aligned(mask: int, positions, four) -> bool:
    """Independent test: switch the first vertex isolated inside the four-set."""
    a, b, c, d = four
    residual = []
    for i, j in ((b, c), (b, d), (c, d)):
        residual.append(
            edge(mask, positions, i, j)
            ^ edge(mask, positions, a, i)
            ^ edge(mask, positions, a, j)
        )
    return residual[0] == residual[1] == residual[2]


def census(n: int) -> dict:
    edges, positions = edge_tables(n)
    triples = list(itertools.combinations(range(n), 3))
    fours = list(itertools.combinations(range(n), 4))
    fibres: dict[int, list[int]] = defaultdict(list)

    for graph_mask in range(1 << len(edges)):
        two_graph = sum(
            triple_bit(graph_mask, positions, triple) << i
            for i, triple in enumerate(triples)
        )
        aligned = 0
        for i, four in enumerate(fours):
            direct = direct_aligned(graph_mask, positions, four)
            switched = switched_aligned(graph_mask, positions, four)
            if direct != switched:
                raise AssertionError((n, graph_mask, four, direct, switched))
            aligned |= direct << i
        fibres[aligned].append(two_graph)

    fibre_histogram = Counter(map(len, fibres.values()))
    complement_pairs = sum(
        len(values) == 2 and values[0] ^ values[1] == (1 << len(triples)) - 1
        for values in fibres.values()
    )
    return {
        "vertices": n,
        "normalized_graphs": 1 << len(edges),
        "aligned_images": len(fibres),
        "fibre_size_histogram": {
            str(size): count for size, count in sorted(fibre_histogram.items())
        },
        "complement_pair_fibres": complement_pairs,
    }


def generate() -> dict:
    return {
        "schema": "c794-aligned-design-fibres-v1",
        "normalization": "vertex 0 isolated in the graph representative",
        "range": {"minimum_vertices": 4, "maximum_vertices": 7},
        "results": [census(n) for n in range(4, 8)],
    }


def canonical_bytes(value: dict) -> bytes:
    return (json.dumps(value, indent=2, sort_keys=True) + "\n").encode()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    if args.check == args.write:
        parser.error("choose exactly one of --check and --write")

    payload = canonical_bytes(generate())
    if args.write:
        CERTIFICATE.write_bytes(payload)
        print(f"wrote {CERTIFICATE.name} sha256={hashlib.sha256(payload).hexdigest()}")
        return

    tracked = CERTIFICATE.read_bytes()
    if tracked != payload:
        raise SystemExit(f"certificate mismatch: regenerate with {Path(__file__).name} --write")
    print(f"C794 aligned-design fibre check: OK sha256={hashlib.sha256(payload).hexdigest()}")


if __name__ == "__main__":
    main()
