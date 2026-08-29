#!/usr/bin/env python3
"""Solve minimum-cost accepted traces with Z3 and an independent oracle."""

from __future__ import annotations

import argparse
import heapq
import json
import time
from pathlib import Path

import z3


def parse_mata(path: Path) -> tuple[int, int, set[int], list[str], list[list[int]]]:
    initial: int | None = None
    finals: set[int] = set()
    triples: list[tuple[int, str, int]] = []
    symbols: list[str] = []
    symbol_ids: dict[str, int] = {}
    maximum = -1
    for raw in path.read_text().splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or line.startswith("@") or line.startswith("%Alphabet"):
            continue
        if line.startswith("%Initial"):
            words = line.split()
            if len(words) != 2 or initial is not None:
                raise ValueError("expected exactly one initial state")
            initial = int(words[1].removeprefix("q"))
            maximum = max(maximum, initial)
            continue
        if line.startswith("%Final"):
            for word in line.split()[1:]:
                state = int(word.removeprefix("q"))
                finals.add(state)
                maximum = max(maximum, state)
            continue
        source_word, symbol, target_word = line.split()
        source = int(source_word.removeprefix("q"))
        target = int(target_word.removeprefix("q"))
        maximum = max(maximum, source, target)
        if symbol not in symbol_ids:
            symbol_ids[symbol] = len(symbols)
            symbols.append(symbol)
        triples.append((source, symbol, target))
    if initial is None or maximum < 0 or not symbols:
        raise ValueError("malformed or empty explicit DFA")
    original_states = maximum + 1
    partial = [[-1] * len(symbols) for _ in range(original_states)]
    for source, symbol, target in triples:
        slot = symbol_ids[symbol]
        previous = partial[source][slot]
        if previous not in (-1, target):
            raise ValueError("input is nondeterministic")
        partial[source][slot] = target
    missing = any(target < 0 for row in partial for target in row)
    state_count = original_states + int(missing)
    sink = original_states
    transitions = [[sink] * len(symbols) for _ in range(state_count)]
    for state, row in enumerate(partial):
        for symbol, target in enumerate(row):
            if target >= 0:
                transitions[state][symbol] = target
    return state_count, initial, finals, symbols, transitions


def symbol_cost(symbol: str) -> int:
    if not symbol or any(bit not in "01" for bit in symbol):
        raise ValueError(f"expected bit-vector symbol, got {symbol!r}")
    return 1 + symbol.count("1")


def collapse_edges(
    transitions: list[list[int]], costs: list[int]
) -> list[list[tuple[int, int, int]]]:
    collapsed: list[list[tuple[int, int, int]]] = []
    for row in transitions:
        best: dict[int, tuple[int, int]] = {}
        for generator, target in enumerate(row):
            candidate = (costs[generator], generator)
            if target not in best or candidate < best[target]:
                best[target] = candidate
        collapsed.append(
            [(target, cost, generator) for target, (cost, generator) in sorted(best.items())]
        )
    return collapsed


def dijkstra(
    edges: list[list[tuple[int, int, int]]], initial: int, finals: set[int]
) -> tuple[int, list[int]]:
    distances = [2**63 - 1] * len(edges)
    parents = [(-1, -1)] * len(edges)
    distances[initial] = 0
    heap = [(0, initial)]
    while heap:
        distance, state = heapq.heappop(heap)
        if distance != distances[state]:
            continue
        if state in finals:
            word: list[int] = []
            while state != initial:
                state, generator = parents[state]
                word.append(generator)
            word.reverse()
            return distance, word
        for target, cost, generator in edges[state]:
            candidate = distance + cost
            if candidate < distances[target]:
                distances[target] = candidate
                parents[target] = (state, generator)
                heapq.heappush(heap, (candidate, target))
    raise ValueError("accepting output is unreachable")


def integer_value(value: z3.ArithRef) -> int:
    simplified = z3.simplify(value)
    if not z3.is_int_value(simplified):
        raise ValueError(f"non-integral optimization bound: {simplified}")
    return simplified.as_long()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("dfa", type=Path)
    parser.add_argument("--timeout-ms", type=int, default=10_000)
    args = parser.parse_args()
    state_count, initial, finals, symbols, transitions = parse_mata(args.dfa)
    costs = [symbol_cost(symbol) for symbol in symbols]
    edges = collapse_edges(transitions, costs)
    oracle_optimum, oracle_word = dijkstra(edges, initial, finals)

    build_start = time.perf_counter_ns()
    if initial in finals:
        result = {
            "status": "optimal",
            "states": state_count,
            "symbols": len(symbols),
            "uncollapsed_edges": state_count * len(symbols),
            "collapsed_edges": sum(map(len, edges)),
            "optimum": 0,
            "oracle_optimum": oracle_optimum,
            "oracle_word_length": len(oracle_word),
            "build_ns": time.perf_counter_ns() - build_start,
            "solve_ns": 0,
        }
        print(json.dumps(result, sort_keys=True))
        return

    optimizer = z3.Optimize()
    optimizer.set(timeout=args.timeout_ms)
    variables: list[list[z3.BoolRef]] = []
    incoming: list[list[z3.BoolRef]] = [[] for _ in range(state_count)]
    objective_terms: list[z3.ArithRef] = []
    for source, outgoing in enumerate(edges):
        row: list[z3.BoolRef] = []
        for edge_index, (target, cost, _generator) in enumerate(outgoing):
            variable = z3.Bool(f"e_{source}_{edge_index}")
            row.append(variable)
            incoming[target].append(variable)
            objective_terms.append(z3.If(variable, cost, 0))
        variables.append(row)
    finish = {state: z3.Bool(f"finish_{state}") for state in sorted(finals)}
    optimizer.add(z3.PbEq([(variable, 1) for variable in finish.values()], 1))
    for state in range(state_count):
        outgoing_flow = z3.Sum([z3.If(variable, 1, 0) for variable in variables[state]])
        incoming_flow = z3.Sum([z3.If(variable, 1, 0) for variable in incoming[state]])
        if state == initial:
            optimizer.add(outgoing_flow - incoming_flow == 1)
        elif state in finals:
            optimizer.add(incoming_flow - outgoing_flow == z3.If(finish[state], 1, 0))
        else:
            optimizer.add(incoming_flow - outgoing_flow == 0)
    objective = z3.Sum(objective_terms)
    handle = optimizer.minimize(objective)
    build_ns = time.perf_counter_ns() - build_start
    solve_start = time.perf_counter_ns()
    status = optimizer.check()
    solve_ns = time.perf_counter_ns() - solve_start

    record: dict[str, object] = {
        "states": state_count,
        "symbols": len(symbols),
        "uncollapsed_edges": state_count * len(symbols),
        "collapsed_edges": sum(map(len, edges)),
        "oracle_optimum": oracle_optimum,
        "oracle_word_length": len(oracle_word),
        "build_ns": build_ns,
        "solve_ns": solve_ns,
    }
    if status == z3.sat:
        model_optimum = integer_value(optimizer.model().eval(objective, model_completion=True))
        lower = integer_value(handle.lower())
        upper = integer_value(handle.upper())
        record.update(
            status="optimal" if lower == upper == model_optimum else "incomplete",
            optimum=model_optimum,
            lower_bound=lower,
            upper_bound=upper,
        )
        if record["status"] == "optimal" and model_optimum != oracle_optimum:
            raise ValueError("Z3 optimum disagrees with independent Dijkstra oracle")
    else:
        record.update(status=str(status), reason=optimizer.reason_unknown())
    print(json.dumps(record, sort_keys=True))


if __name__ == "__main__":
    main()
