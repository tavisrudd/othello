#!/usr/bin/env python3
"""Private compact Eulerian-witness backend for C880 attachment separation."""

from __future__ import annotations

import json
import sys
import time

import gurobipy as gp
from gurobipy import GRB

from c880_alignment_gurobi import CUTS, KNOWN_G8, TRIPLES, violated_clause


def main() -> None:
    output = sys.argv[1] if len(sys.argv) > 1 else None
    model = gp.Model("c880-alignment-compact")
    model.Params.Threads = 16
    selected = model.addVars(len(TRIPLES), vtype=GRB.BINARY, name="triple")
    for index, triple in enumerate(TRIPLES):
        selected[index].Start = int(triple in KNOWN_G8)
    model.addConstr(selected[0] == 1, name="point_transitive_anchor")
    model.addConstr(selected.sum() >= 15, name="proved_weight_mask_lower_bound")

    witness_variables = 0
    parity_constraints = 0
    for cut_index, (_cut, pairs, edge_count) in enumerate(CUTS):
        crossing = [index for index, pair in enumerate(pairs) if pair is not None]
        witness = model.addVars(crossing, vtype=GRB.BINARY, name=f"cycle_{cut_index}")
        witness_variables += len(crossing)
        for triple in crossing:
            model.addConstr(witness[triple] <= selected[triple])
        for edge in range(edge_count):
            incident = [
                witness[triple]
                for triple in crossing
                if edge in pairs[triple]
            ]
            half_degree = model.addVar(
                vtype=GRB.INTEGER,
                lb=0,
                ub=len(incident) // 2,
                name=f"half_degree_{cut_index}_{edge}",
            )
            model.addConstr(gp.quicksum(incident) == 2 * half_degree)
            parity_constraints += 1
        half_size = model.addVar(
            vtype=GRB.INTEGER,
            lb=0,
            ub=(len(crossing) - 1) // 2,
            name=f"half_size_{cut_index}",
        )
        model.addConstr(witness.sum() == 2 * half_size + 1)
        parity_constraints += 1

    model.setObjective(selected.sum(), GRB.MINIMIZE)
    started = time.perf_counter()
    model.optimize()
    if model.Status != GRB.OPTIMAL:
        raise RuntimeError(f"unexpected Gurobi status {model.Status}")
    family = [selected[index].X > 0.5 for index in range(len(TRIPLES))]
    if violated_clause(family) is not None:
        raise RuntimeError("compact Gurobi incumbent failed exact replay")
    record = {
        "points": 8,
        "optimum": int(round(model.ObjVal)),
        "family_indices": [index for index, keep in enumerate(family) if keep],
        "family_triples": [TRIPLES[index] for index, keep in enumerate(family) if keep],
        "witness_variables": witness_variables,
        "parity_constraints": parity_constraints,
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
