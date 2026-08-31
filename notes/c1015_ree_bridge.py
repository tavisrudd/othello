#!/usr/bin/env python3
"""Exact finite checks for the C1015 Hamilton-pair Ree bridge.

The script independently enumerates the one-factorizations contained in each
tracked MATCH(10,5,1) class, counts Hamilton pairs in each factorization by two
equivalent tests, and checks the more general two-point-overlap closure.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
INPUT = ROOT / "papers/arcs_complete_outside_conic/check_match10_rank_three.json"
OUTPUT = ROOT / "notes/c1015_ree_bridge.json"
MANIFEST = ROOT / "notes/c1015_ree_bridge.sha256"


def digest(value) -> str:
    payload = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(payload).hexdigest()


def one_factorizations(design):
    edges = tuple(itertools.combinations(range(10), 2))
    edge_index = {edge: index for index, edge in enumerate(edges)}
    masks = tuple(sum(1 << edge_index[edge] for edge in block) for block in design)
    through = tuple(
        tuple(index for index, mask in enumerate(masks) if mask & (1 << edge_index[edge]))
        for edge in edges
    )
    full = (1 << len(edges)) - 1
    answer = []

    def extend(used, chosen):
        if used == full:
            answer.append(tuple(chosen))
            return
        choices = []
        for edge_number in range(len(edges)):
            if used & (1 << edge_number):
                continue
            candidates = tuple(
                block for block in through[edge_number] if not (masks[block] & used)
            )
            if not candidates:
                return
            choices.append((len(candidates), candidates))
        for block in min(choices)[1]:
            extend(used | masks[block], chosen + (block,))

    extend(0, ())
    return tuple(sorted(answer))


def component_sizes(first, second):
    adjacency = {vertex: [] for vertex in range(10)}
    for left, right in first + second:
        adjacency[left].append(right)
        adjacency[right].append(left)
    unseen = set(adjacency)
    sizes = []
    while unseen:
        stack = [min(unseen)]
        component = set()
        while stack:
            vertex = stack.pop()
            if vertex in component:
                continue
            component.add(vertex)
            stack.extend(adjacency[vertex])
        unseen -= component
        sizes.append(len(component))
    return tuple(sorted(sizes))


def is_hamilton_by_product(first, second):
    involutions = []
    for matching in (first, second):
        permutation = {}
        for left, right in matching:
            permutation[left] = right
            permutation[right] = left
        involutions.append(permutation)
    product = {vertex: involutions[1][involutions[0][vertex]] for vertex in range(10)}
    orbit = []
    vertex = 0
    while vertex not in orbit:
        orbit.append(vertex)
        vertex = product[vertex]
    # An alternating Hamilton 10-cycle gives two 5-cycles in the product.
    return len(orbit) == 5


def overlap_closure(factors):
    by_zero_partner = {}
    for matching in factors:
        edge = next(edge for edge in matching if 0 in edge)
        partner = edge[0] if edge[1] == 0 else edge[1]
        by_zero_partner[partner] = matching
    parts = [
        {colour, left, right}
        for colour, matching in by_zero_partner.items()
        for left, right in matching
        if left != 0 and right != 0
    ]
    changed = True
    while changed:
        changed = False
        for left in range(len(parts)):
            for right in range(left + 1, len(parts)):
                if len(parts[left] & parts[right]) >= 2:
                    parts[left] |= parts[right]
                    parts.pop(right)
                    changed = True
                    break
            if changed:
                break
    return tuple(sorted(len(part) for part in parts))


def build_report():
    raw = json.loads(INPUT.read_text())
    classes = {}
    for entry in raw["classes"]:
        design = tuple(
            tuple(tuple(edge) for edge in block) for block in entry["matching_design"]
        )
        factorizations = one_factorizations(design)
        hamilton_counts = []
        closures = []
        for factorization in factorizations:
            factors = tuple(design[index] for index in factorization)
            count = 0
            for left, right in itertools.combinations(factors, 2):
                first_test = component_sizes(left, right) == (10,)
                second_test = is_hamilton_by_product(left, right)
                assert first_test == second_test
                count += first_test
            hamilton_counts.append(count)
            closures.append(overlap_closure(factors))
        classes[entry["name"]] = {
            "one_factorization_count": len(factorizations),
            "one_factorizations_sha256": digest(factorizations),
            "hamilton_pair_count_distribution": {
                str(count): hamilton_counts.count(count)
                for count in sorted(set(hamilton_counts))
            },
            "overlap_closure_distribution": {
                "+".join(map(str, closure)): closures.count(closure)
                for closure in sorted(set(closures))
            },
            "all_have_hamilton_pair": all(count > 0 for count in hamilton_counts),
        }
    assert classes["classical-hyperoval"]["one_factorization_count"] == 28
    assert classes["classical-hyperoval"]["hamilton_pair_count_distribution"] == {"27": 28}
    assert classes["classical-hyperoval"]["overlap_closure_distribution"] == {"9": 28}
    assert classes["mathon-nonhyperoval"]["one_factorization_count"] == 1
    assert classes["mathon-nonhyperoval"]["hamilton_pair_count_distribution"] == {"0": 1}
    assert classes["mathon-nonhyperoval"]["overlap_closure_distribution"] == {"9": 1}
    return {
        "schema": "c1015-ree-bridge-v1",
        "input_sha256": hashlib.sha256(INPUT.read_bytes()).hexdigest(),
        "classes": classes,
        "trusted_boundary": (
            "exact enumeration and finite graph checks only; the automatic-pencil theorem is human"
        ),
    }


def rendered_report():
    return (json.dumps(build_report(), indent=2, sort_keys=True) + "\n").encode()


def rendered_manifest(output_bytes):
    rows = []
    for path, payload in (
        (Path(__file__), Path(__file__).read_bytes()),
        (INPUT, INPUT.read_bytes()),
        (OUTPUT, output_bytes),
    ):
        rows.append(f"{hashlib.sha256(payload).hexdigest()}  {path.relative_to(ROOT)}")
    return ("\n".join(rows) + "\n").encode()


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    output = rendered_report()
    manifest = rendered_manifest(output)
    if args.write:
        OUTPUT.write_bytes(output)
        MANIFEST.write_bytes(manifest)
    else:
        assert OUTPUT.read_bytes() == output
        assert MANIFEST.read_bytes() == manifest
    print("C1015 Ree-bridge checks passed")


if __name__ == "__main__":
    main()
