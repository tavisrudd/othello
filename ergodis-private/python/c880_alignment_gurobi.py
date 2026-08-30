#!/usr/bin/env python3
"""Private lazy backend for the theorem-reduced C880 attachment problem."""

from __future__ import annotations

import itertools
import json
import os
import struct
import subprocess
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


def violated_clauses(selected: list[bool]) -> list[int]:
    clauses: list[int] = []
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
        clauses.append(clause)
    clauses.sort(key=int.bit_count)
    return clauses


def violated_clause(selected: list[bool]) -> int | None:
    clauses = violated_clauses(selected)
    return clauses[0] if clauses else None


def main() -> None:
    output = sys.argv[1] if len(sys.argv) > 1 else None
    orbit_batch = int(os.environ.get("ERGODIS_ALIGNMENT_ORBIT_BATCH", "16"))
    context_batch = int(os.environ.get("ERGODIS_ALIGNMENT_CONTEXT_BATCH", "4"))
    maximum = int(os.environ.get("ERGODIS_ALIGNMENT_MAXIMUM", "17"))
    target = float(os.environ.get("ERGODIS_ALIGNMENT_TARGET", "-inf"))
    if not 1 <= orbit_batch <= len(ANCHOR_STABILIZER_MAPS):
        raise ValueError("ERGODIS_ALIGNMENT_ORBIT_BATCH must lie in [1, 720]")
    if not 1 <= context_batch <= len(CUTS):
        raise ValueError("ERGODIS_ALIGNMENT_CONTEXT_BATCH must lie in [1, 127]")
    if maximum not in (16, 17):
        raise ValueError("ERGODIS_ALIGNMENT_MAXIMUM must be 16 or 17")
    model = gp.Model("c880-alignment-attachment")
    model.Params.OutputFlag = 1
    model.Params.Threads = 16
    model.Params.LazyConstraints = 1
    model.Params.PreCrush = 1
    if target > float("-inf"):
        model.Params.BestObjStop = target
    seconds = float(os.environ.get("ERGODIS_ALIGNMENT_SECONDS", "inf"))
    if seconds < float("inf"):
        model.Params.TimeLimit = seconds
    variables = model.addVars(len(TRIPLES), vtype=GRB.BINARY, name="triple")
    if maximum == len(KNOWN_G8):
        for index, triple in enumerate(TRIPLES):
            variables[index].Start = int(triple in KNOWN_G8)
    model.addConstr(variables[0] == 1, name="point_transitive_anchor")
    model.addConstr(variables.sum() >= 15, name="proved_weight_mask_lower_bound")
    model.addConstr(variables.sum() <= maximum, name="known_witness_upper_bound")
    for cut, pairs, _edge_count in CUTS:
        model.addConstr(
            gp.quicksum(
                variables[index] for index, pair in enumerate(pairs) if pair is not None
            )
            >= 3,
            name=f"odd_cycle_edge_floor_{cut}",
        )
    model.setObjective(variables.sum(), GRB.MINIMIZE)
    lazy_count = 0
    fractional_count = 0
    fractional_calls = 0
    last_fractional_node = -1.0
    orbit_cursor = 0
    added_clauses: set[int] = set()
    started = time.perf_counter()
    separator = None
    separator_path = os.environ.get("ERGODIS_ALIGNMENT_SEPARATOR")
    fractional_period = float(os.environ.get("ERGODIS_ALIGNMENT_FRACTIONAL_PERIOD", "100"))
    if separator_path:
        separator = subprocess.Popen(
            [separator_path],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            bufsize=0,
        )

    def read_exact(stream, length: int) -> bytes:
        chunks = bytearray(length)
        view = memoryview(chunks)
        offset = 0
        while offset < length:
            count = stream.readinto(view[offset:])
            if not count:
                raise RuntimeError("fractional separator closed its response stream")
            offset += count
        return bytes(chunks)

    def callback(active: gp.Model, where: int) -> None:
        nonlocal lazy_count, fractional_count, fractional_calls, last_fractional_node, orbit_cursor
        if where == GRB.Callback.MIPNODE and separator is not None:
            if active.cbGet(GRB.Callback.MIPNODE_STATUS) != GRB.OPTIMAL:
                return
            node = active.cbGet(GRB.Callback.MIPNODE_NODCNT)
            if node != last_fractional_node and node < last_fractional_node + fractional_period:
                return
            last_fractional_node = node
            values = active.cbGetNodeRel(variables)
            assert separator.stdin is not None and separator.stdout is not None
            separator.stdin.write(
                struct.pack(
                    "<56d",
                    *(max(0.0, min(1.0, values[index])) for index in range(len(TRIPLES))),
                )
            )
            separator.stdin.flush()
            count = struct.unpack("<I", read_exact(separator.stdout, 4))[0]
            response = read_exact(separator.stdout, 24 * count)
            for offset in range(count):
                _cut, clause, weight = struct.unpack_from("<QQd", response, 24 * offset)
                if weight >= 1.0 - 1e-8:
                    continue
                active.cbCut(
                    gp.quicksum(
                        variables[index]
                        for index in range(len(TRIPLES))
                        if clause >> index & 1
                    )
                    >= 1
                )
                fractional_count += 1
            fractional_calls += 1
            return
        if where != GRB.Callback.MIPSOL:
            return
        values = active.cbGetSolution(variables)
        selected = [values[index] > 0.5 for index in range(len(TRIPLES))]
        clauses = violated_clauses(selected)
        if not clauses:
            return
        for clause in clauses[:context_batch]:
            support = [index for index in range(len(TRIPLES)) if clause >> index & 1]
            mappings = [list(range(len(TRIPLES)))]
            for offset in range(orbit_batch - 1):
                index = (orbit_cursor + 223 * offset) % len(ANCHOR_STABILIZER_MAPS)
                mappings.append(ANCHOR_STABILIZER_MAPS[index])
            orbit_cursor = (orbit_cursor + max(1, orbit_batch - 1)) % len(ANCHOR_STABILIZER_MAPS)
            for mapping in mappings:
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

    replay_constraints = 0
    solution_replayed = False
    try:
        while True:
            added_clauses.clear()
            model.optimize(callback)
            if model.SolCount == 0:
                break
            selected = [variables[index].X > 0.5 for index in range(len(TRIPLES))]
            clauses = violated_clauses(selected)
            if not clauses:
                solution_replayed = True
                break

            # Gurobi can install a presolve heuristic incumbent without a
            # MIPSOL callback.  Never trust such an incumbent: replay it and
            # restart with ordinary constraints excluding every witnessed
            # contextual failure.  This outer proof boundary is deliberately
            # independent of callback delivery.
            for clause in clauses:
                model.addConstr(
                    gp.quicksum(
                        variables[index]
                        for index in range(len(TRIPLES))
                        if clause >> index & 1
                    )
                    >= 1
                )
                replay_constraints += 1
            if seconds < float("inf"):
                remaining = seconds - (time.perf_counter() - started)
                if remaining <= 0.0:
                    break
                model.Params.TimeLimit = remaining
    finally:
        if separator is not None:
            assert separator.stdin is not None
            separator.stdin.close()
            separator.wait(timeout=5)
    if model.Status != GRB.OPTIMAL or not solution_replayed:
        record = {
            "points": 8,
            "status": model.Status,
            "status_name": (
                "TIME_LIMIT"
                if model.Status == GRB.TIME_LIMIT
                else "INFEASIBLE"
                if model.Status == GRB.INFEASIBLE
                else "UNREPLAYED"
                if model.Status == GRB.OPTIMAL
                else "NONOPTIMAL"
            ),
            "incumbent": model.ObjVal if solution_replayed else None,
            "family_indices": (
                [index for index, keep in enumerate(selected) if keep]
                if solution_replayed
                else None
            ),
            "family_triples": (
                [TRIPLES[index] for index, keep in enumerate(selected) if keep]
                if solution_replayed
                else None
            ),
            "best_bound": model.ObjBound,
            "maximum": maximum,
            "lazy_constraints": lazy_count,
            "replay_constraints": replay_constraints,
            "fractional_calls": fractional_calls,
            "fractional_constraints": fractional_count,
            "orbit_batch": orbit_batch,
            "context_batch": context_batch,
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
        return
    selected = [variables[index].X > 0.5 for index in range(len(TRIPLES))]
    if violated_clause(selected) is not None:
        raise RuntimeError("Gurobi incumbent failed exact replay")
    record = {
        "points": 8,
        "optimum": int(round(model.ObjVal)),
        "maximum": maximum,
        "family_indices": [index for index, keep in enumerate(selected) if keep],
        "family_triples": [TRIPLES[index] for index, keep in enumerate(selected) if keep],
        "lazy_constraints": lazy_count,
        "replay_constraints": replay_constraints,
        "fractional_calls": fractional_calls,
        "fractional_constraints": fractional_count,
        "orbit_batch": orbit_batch,
        "context_batch": context_batch,
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
