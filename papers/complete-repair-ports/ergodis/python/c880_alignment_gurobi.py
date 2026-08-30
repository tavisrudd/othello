#!/usr/bin/env python3
"""Lazy exact backend for the theorem-reduced C880 attachment problem."""

from __future__ import annotations

import itertools
import json
import os
import sys
import time

import gurobipy as gp
from gurobipy import GRB


def side(cut: int, point: int) -> int:
    return 0 if point == 0 else (cut >> (point - 1)) & 1


TRIPLES = list(itertools.combinations(range(8), 3))
TRIPLE_INDEX = {triple: index for index, triple in enumerate(TRIPLES)}
ANCHOR_STABILIZER_MAPS = [
    [TRIPLE_INDEX[tuple(sorted(permutation[point] for point in triple))] for triple in TRIPLES]
    for permutation in itertools.permutations(range(8))
    if {permutation[0], permutation[1], permutation[2]} == {0, 1, 2}
]
KNOWN_G8 = {
    (0, 1, 2), (0, 1, 4), (0, 1, 5), (0, 2, 4), (0, 2, 5), (0, 4, 5),
    (1, 2, 3), (1, 2, 5), (1, 2, 6), (1, 2, 7), (1, 3, 6), (1, 3, 7),
    (1, 4, 5), (1, 6, 7), (2, 3, 6), (2, 3, 7), (2, 5, 6),
}
CUTS: list[tuple[int, list[tuple[int, int] | None], int]] = []
for cut in range(1, 1 << 7):
    crossing = [
        (a, b)
        for a in range(8)
        for b in range(a + 1, 8)
        if side(cut, a) != side(cut, b)
    ]
    edge_index = {edge: index for index, edge in enumerate(crossing)}
    pairs: list[tuple[int, int] | None] = []
    for a, b, c in TRIPLES:
        if side(cut, a) == side(cut, b) != side(cut, c):
            center, left, right = c, a, b
        elif side(cut, a) == side(cut, c) != side(cut, b):
            center, left, right = b, a, c
        elif side(cut, b) == side(cut, c) != side(cut, a):
            center, left, right = a, b, c
        else:
            pairs.append(None)
            continue
        pairs.append(
            (
                edge_index[tuple(sorted((center, left)))],
                edge_index[tuple(sorted((center, right)))],
            )
        )
    CUTS.append((cut, pairs, len(crossing)))


def violated_clause(selected: list[bool]) -> int | None:
    best: int | None = None
    for _cut, pairs, edge_count in CUTS:
        adjacency = [[] for _ in range(edge_count)]
        for keep, pair in zip(selected, pairs, strict=True):
            if keep and pair is not None:
                left, right = pair
                adjacency[left].append(right)
                adjacency[right].append(left)
        colors = [-1] * edge_count
        bipartite = True
        for root in range(edge_count):
            if colors[root] >= 0:
                continue
            colors[root] = 0
            queue = [root]
            for vertex in queue:
                for neighbor in adjacency[vertex]:
                    if colors[neighbor] < 0:
                        colors[neighbor] = colors[vertex] ^ 1
                        queue.append(neighbor)
                    elif colors[neighbor] == colors[vertex]:
                        bipartite = False
                        break
                if not bipartite:
                    break
            if not bipartite:
                break
        if not bipartite:
            continue
        clause = 0
        for index, pair in enumerate(pairs):
            if pair is not None and colors[pair[0]] == colors[pair[1]]:
                clause |= 1 << index
        if clause == 0:
            raise RuntimeError("complete family failed to distinguish a cut context")
        if best is None or clause.bit_count() < best.bit_count():
            best = clause
    return best


def main() -> None:
    output = sys.argv[1] if len(sys.argv) > 1 else None
    orbit_batch = int(os.environ.get("ERGODIS_ALIGNMENT_ORBIT_BATCH", "16"))
    if not 1 <= orbit_batch <= len(ANCHOR_STABILIZER_MAPS):
        raise ValueError("ERGODIS_ALIGNMENT_ORBIT_BATCH must lie in [1, 720]")
    model = gp.Model("c880-alignment-attachment")
    model.Params.OutputFlag = 1
    model.Params.Threads = 16
    model.Params.LazyConstraints = 1
    variables = model.addVars(len(TRIPLES), vtype=GRB.BINARY, name="triple")
    for index, triple in enumerate(TRIPLES):
        variables[index].Start = int(triple in KNOWN_G8)
    model.addConstr(variables[0] == 1, name="point_transitive_anchor")
    model.addConstr(variables.sum() >= 15, name="proved_weight_mask_lower_bound")
    model.setObjective(variables.sum(), GRB.MINIMIZE)
    lazy_count = 0
    added_clauses: set[int] = set()
    started = time.perf_counter()

    def callback(active: gp.Model, where: int) -> None:
        nonlocal lazy_count
        if where != GRB.Callback.MIPSOL:
            return
        values = active.cbGetSolution(variables)
        selected = [values[index] > 0.5 for index in range(len(TRIPLES))]
        clause = violated_clause(selected)
        if clause is None:
            return
        support = [index for index in range(len(TRIPLES)) if clause >> index & 1]
        for mapping in ANCHOR_STABILIZER_MAPS[:orbit_batch]:
            image = 0
            for index in support:
                image |= 1 << mapping[index]
            if image in added_clauses:
                continue
            added_clauses.add(image)
            active.cbLazy(
                gp.quicksum(
                    variables[index] for index in range(len(TRIPLES)) if image >> index & 1
                )
                >= 1
            )
            lazy_count += 1

    model.optimize(callback)
    if model.Status != GRB.OPTIMAL:
        raise RuntimeError(f"unexpected Gurobi status {model.Status}")
    selected = [variables[index].X > 0.5 for index in range(len(TRIPLES))]
    if violated_clause(selected) is not None:
        raise RuntimeError("Gurobi incumbent failed exact replay")
    record = {
        "points": 8,
        "optimum": int(round(model.ObjVal)),
        "family_indices": [index for index, keep in enumerate(selected) if keep],
        "family_triples": [TRIPLES[index] for index, keep in enumerate(selected) if keep],
        "lazy_constraints": lazy_count,
        "orbit_batch": orbit_batch,
        "nodes": model.NodeCount,
        "work": model.Work,
        "elapsed_seconds": time.perf_counter() - started,
    }
    text = json.dumps(record, indent=2) + "\n"
    if output is None:
        print(text, end="")
    else:
        with open(output, "x", encoding="utf-8") as stream:
            stream.write(text)


if __name__ == "__main__":
    main()
