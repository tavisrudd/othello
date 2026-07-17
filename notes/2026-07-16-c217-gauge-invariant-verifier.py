#!/usr/bin/env python3
"""Finite GF(9) replay for C217's circuit-incidence holonomies.

The coefficient on an incidence (circuit, coordinate) changes by a circuit scalar and the inverse
coordinate scalar.  Normalizing a spanning tree therefore leaves one invariant value per chord.
This script checks that construction on every size-three/four circuit of the completed q=9 seed
and verifies that the axis four-cycles recover the projective cross-ratio formula.
"""

from __future__ import annotations

import argparse
from collections import Counter, deque
import hashlib
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
C203_VERIFIER = HERE / "2026-07-15-c203-q9-coefficient-verifier.py"

if not __debug__:
    raise RuntimeError("this verifier requires assertions; do not run Python with -O")


def load_c203():
    spec = importlib.util.spec_from_file_location("c203_coefficient_verifier", C203_VERIFIER)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def div(field, numerator, denominator):
    return field.mul(numerator, field.inv(denominator))


def primitive_element(field):
    for candidate in range(1, field.q):
        if {field.pow(candidate, exponent) for exponent in range(field.q - 1)} == set(
            range(1, field.q)
        ):
            return candidate
    raise AssertionError("finite-field multiplicative group has no enumerated generator")


def anharmonic_orbit(field, value):
    return {
        value,
        field.inv(value),
        field.sub(1, value),
        field.inv(field.sub(1, value)),
        div(field, value, field.sub(value, 1)),
        div(field, field.sub(value, 1), value),
    }


def tree_normalized_chords(field, circuit_count, coordinate_count, edges):
    """Gauge-normalize a deterministic spanning tree and return the chord labels."""

    coordinate_offset = circuit_count
    adjacency = [[] for _ in range(circuit_count + coordinate_count)]
    for edge_index, (circuit, coordinate, _coefficient) in enumerate(edges):
        coordinate_vertex = coordinate_offset + coordinate
        adjacency[circuit].append((coordinate_vertex, edge_index))
        adjacency[coordinate_vertex].append((circuit, edge_index))
    for neighbors in adjacency:
        neighbors.sort()

    parent_edge = [None] * len(adjacency)
    potential = [None] * len(adjacency)
    potential[0] = 1
    queue = deque([0])
    while queue:
        vertex = queue.popleft()
        for neighbor, edge_index in adjacency[vertex]:
            if potential[neighbor] is not None:
                continue
            circuit, _coordinate, coefficient = edges[edge_index]
            if vertex < coordinate_offset:
                assert vertex == circuit
                potential[neighbor] = field.mul(potential[vertex], coefficient)
            else:
                assert neighbor == circuit
                potential[neighbor] = div(field, potential[vertex], coefficient)
            parent_edge[neighbor] = edge_index
            queue.append(neighbor)

    assert all(value is not None for value in potential)
    tree_edges = {edge for edge in parent_edge if edge is not None}
    assert len(tree_edges) == len(adjacency) - 1

    normalized = []
    for circuit, coordinate, coefficient in edges:
        coordinate_vertex = coordinate_offset + coordinate
        value = field.mul(div(field, potential[circuit], potential[coordinate_vertex]), coefficient)
        normalized.append(value)
    assert all(normalized[edge] == 1 for edge in tree_edges)
    return tuple(normalized[index] for index in range(len(edges)) if index not in tree_edges)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    c203 = load_c203()
    base = c203.load_base()
    field = base.FIELDS[1]
    assert field.q == 9
    points, labels = base.completed_points(field)
    circuits = c203.enumerate_small_circuits(field, points)

    coefficient_by_support = {}
    edges = []
    for circuit_index, support in enumerate(circuits):
        coefficients = c203.kernel_generator(field, [points[index] for index in support])
        row = dict(zip(support, coefficients))
        coefficient_by_support[frozenset(support)] = row
        edges.extend((circuit_index, coordinate, row[coordinate]) for coordinate in support)

    circuit_count = len(circuits)
    coordinate_count = len(points)
    incidence_count = len(edges)
    cycle_rank = incidence_count - circuit_count - coordinate_count + 1
    chords = tree_normalized_chords(field, circuit_count, coordinate_count, edges)
    assert len(chords) == cycle_rank

    # An arbitrary nonzero gauge must leave every normalized chord unchanged.
    generator = primitive_element(field)
    circuit_scales = [field.pow(generator, (3 * index + 1) % 8) for index in range(circuit_count)]
    coordinate_scales = [field.pow(generator, (5 * index + 2) % 8) for index in range(coordinate_count)]
    gauged_edges = [
        (
            circuit,
            coordinate,
            field.mul(
                field.mul(circuit_scales[circuit], field.inv(coordinate_scales[coordinate])),
                coefficient,
            ),
        )
        for circuit, coordinate, coefficient in edges
    ]
    assert tree_normalized_chords(
        field, circuit_count, coordinate_count, gauged_edges
    ) == chords

    # For finite axis parameters a,b,c,d, compare the two-circuit holonomy with
    # (b-c)(d-a)/((c-a)(b-d)), the inverse of one standard cross-ratio convention.
    q = field.q
    axis_offset = q + 1
    cross_ratio_values = Counter()
    examples = []
    cross_ratio_checks = 0
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if len({a, b, c, d}) != 4:
                        continue
                    abc = coefficient_by_support[
                        frozenset((axis_offset + a, axis_offset + b, axis_offset + c))
                    ]
                    abd = coefficient_by_support[
                        frozenset((axis_offset + a, axis_offset + b, axis_offset + d))
                    ]
                    holonomy = field.mul(
                        div(field, abc[axis_offset + a], abd[axis_offset + a]),
                        div(field, abd[axis_offset + b], abc[axis_offset + b]),
                    )
                    expected = div(
                        field,
                        field.mul(field.sub(b, c), field.sub(d, a)),
                        field.mul(field.sub(c, a), field.sub(b, d)),
                    )
                    assert holonomy == expected
                    assert holonomy not in (0, 1)
                    cross_ratio_values[holonomy] += 1
                    cross_ratio_checks += 1
                    # These two values lie in different anharmonic (coordinate-permutation)
                    # orbits: 2 is fixed by all six transforms in characteristic three, while 3
                    # lies in the other six-element orbit of GF(9) \ {0,1}.
                    if (a, b, c, d) in ((0, 1, 3, 4), (0, 1, 2, 8)):
                        examples.append({"parameters": [a, b, c, d], "holonomy": holonomy})

    assert cross_ratio_checks == 9 * 8 * 7 * 6
    assert set(cross_ratio_values) == set(range(1, q)) - {1}
    assert len(examples) == 2 and examples[0]["holonomy"] != examples[1]["holonomy"]
    distinguishing_orbits = [
        sorted(anharmonic_orbit(field, example["holonomy"])) for example in examples
    ]
    assert set(distinguishing_orbits[0]).isdisjoint(distinguishing_orbits[1])

    certificate = {
        "task": "C217",
        "q": q,
        "field_encoding": "GF(3)[x]/(x^2+1), base-3 coefficient encoding",
        "c203_verifier_sha256": hashlib.sha256(C203_VERIFIER.read_bytes()).hexdigest(),
        "small_circuit_count": circuit_count,
        "coordinate_count": coordinate_count,
        "incidence_count": incidence_count,
        "incidence_graph_connected": True,
        "cycle_rank": cycle_rank,
        "fundamental_holonomy_count": len(chords),
        "fundamental_holonomy_histogram": {
            str(value): count for value, count in sorted(Counter(chords).items())
        },
        "arbitrary_full_gauge_replay": "passed",
        "finite_axis_ordered_cross_ratio_checks": cross_ratio_checks,
        "finite_axis_cross_ratio_histogram": {
            str(value): count for value, count in sorted(cross_ratio_values.items())
        },
        "distinguishing_examples": examples,
        "distinguishing_anharmonic_orbits": distinguishing_orbits,
    }
    rendered = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
