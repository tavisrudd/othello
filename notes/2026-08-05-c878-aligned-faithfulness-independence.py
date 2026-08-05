#!/usr/bin/env python3
"""Aligned-design faithfulness, checked independently, and its relation to
graph four-hypomorphy.

C876 found that the closest literature benchmark for Clebsch III's four-local
two-graph reconstruction theorem is not the size-five hypergraph result the
manuscript names, but Dammak, Lopez, Pouzet and Si Kaddour's graph result, which
reconstructs up to complementation for 4 <= k <= v-3 and so already reads four
from seven points.  Before the manuscript is revised, the mathematics has to say
whether our theorem is a corollary of theirs or an independent statement that
happens to carry the same two numbers.

Two exact results here:

  1. The theorem and its sharpness, verified by direct enumeration of the space
     of two-graphs rather than through the Lean proof: the aligned family
     determines the two-graph up to complement for |V| = 7 and 8, and fails for
     |V| = 5 and 6.
  2. Independence.  The two hypotheses are incomparable.  Ours is one bit per
     four-set, derived from the two-graph; theirs is the isomorphism type of an
     induced four-vertex graph.  Graphs in one switching class always share our
     hypothesis and generally fail theirs, so their theorem cannot be restricted
     to give ours.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import defaultdict
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c878-aligned-faithfulness-independence.json"


def two_graph_space(size):
    """All two-graphs on `size` points, as bitmasks over the triples."""
    triples = list(combinations(range(size), 3))
    index = {triple: slot for slot, triple in enumerate(triples)}
    generators = []
    for pair in combinations(range(size), 2):
        mask = 0
        for triple in triples:
            if pair[0] in triple and pair[1] in triple:
                mask |= 1 << index[triple]
        generators.append(mask)
    space = {0}
    for generator in generators:
        space |= {value ^ generator for value in space}
    assert len(space) == 1 << ((size - 1) * (size - 2) // 2)
    return triples, index, sorted(space)


def aligned_family(tau, index, quads):
    """Four-sets on which the two-graph is constant."""
    family = 0
    for slot, quad in enumerate(quads):
        values = [(tau >> index[triple]) & 1 for triple in combinations(quad, 3)]
        if len(set(values)) == 1:
            family |= 1 << slot
    return family


def faithfulness(size):
    triples, index, space = two_graph_space(size)
    quads = list(combinations(range(size), 4))
    everything = (1 << len(triples)) - 1
    grouped = defaultdict(list)
    for tau in space:
        grouped[aligned_family(tau, index, quads)].append(tau)
    witness = None
    for family, members in grouped.items():
        for left in members:
            for right in members:
                if right != left and right != (left ^ everything):
                    witness = [left, right]
                    break
            if witness:
                break
        if witness:
            break
    return {
        "points": size,
        "two_graphs": len(space),
        "aligned_families": len(grouped),
        "class_sizes": sorted({len(v) for v in grouped.values()}),
        "determines_up_to_complement": witness is None,
        "counterexample": witness,
    }


def induced_type(edges, quad):
    """Isomorphism type of the induced four-vertex graph, as a sorted degree list
    refined by edge count — enough to separate the cases used below."""
    inner = [
        (a, b)
        for a, b in combinations(quad, 2)
        if (min(a, b), max(a, b)) in edges
    ]
    degrees = sorted(
        sum(1 for e in inner if vertex in e) for vertex in quad
    )
    return (len(inner), tuple(degrees))


def switching_independence(size):
    """Two graphs in one switching class share the aligned family but differ on
    induced four-vertex isomorphism types, so graph four-hypomorphy fails."""
    triples, index, _ = two_graph_space(size)
    quads = list(combinations(range(size), 4))

    def two_graph_of(edges):
        mask = 0
        for triple in triples:
            count = sum(
                1 for pair in combinations(triple, 2) if pair in edges
            )
            if count % 2:
                mask |= 1 << index[triple]
        return mask

    empty = set()
    star = {(0, other) for other in range(1, size)}  # switch at vertex 0
    assert two_graph_of(empty) == two_graph_of(star)
    assert aligned_family(two_graph_of(empty), index, quads) == aligned_family(
        two_graph_of(star), index, quads
    )
    differing = [
        quad
        for quad in quads
        if induced_type(empty, quad) != induced_type(star, quad)
    ]
    assert differing, "expected the switching to change some induced type"
    return {
        "points": size,
        "same_two_graph": True,
        "same_aligned_family": True,
        "four_sets_with_different_induced_type": len(differing),
        "total_four_sets": len(quads),
        "graph_four_hypomorphic": False,
    }


def certificate():
    levels = [faithfulness(size) for size in (5, 6, 7, 8)]
    for entry in levels:
        assert entry["determines_up_to_complement"] == (entry["points"] >= 7)
    seven = next(e for e in levels if e["points"] == 7)
    assert seven["class_sizes"] == [2]
    assert seven["aligned_families"] * 2 == seven["two_graphs"]

    return {
        "theorem": (
            "for |V| >= 7 the aligned family determines the two-graph up to "
            "complement; five and six points fail, so seven is sharp"
        ),
        "faithfulness": levels,
        "independence": switching_independence(7),
        "verdict": (
            "our hypothesis is one derived bit per four-set and theirs is the "
            "isomorphism type of an induced four-vertex graph; graphs in one "
            "switching class always satisfy ours and generally fail theirs, so "
            "the graph theorem cannot be restricted to give the two-graph one, "
            "and the shared numbers four and seven are not a shared mechanism"
        ),
        "source_sha256": {
            "05-golden-operator.tex": hashlib.sha256(
                (HERE.parent / "papers/clebsch-passages/sections/05-golden-operator.tex").read_bytes()
            ).hexdigest()
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.write:
        OUTPUT.write_text(payload)
    if args.check:
        assert OUTPUT.read_text() == payload
    if not args.write and not args.check:
        print(payload, end="")


if __name__ == "__main__":
    main()
