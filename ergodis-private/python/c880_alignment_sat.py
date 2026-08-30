#!/usr/bin/env python3
"""Emit the exact C880 attachment problem as a compact CNF.

For each nontrivial cut, selected triples form a graph on the crossing
point-pairs.  That graph is non-bipartite iff it contains an odd-cardinality
Eulerian subgraph.  The latter has a linear-size existential XOR encoding.
"""

from __future__ import annotations

import argparse
import itertools
import json
from pathlib import Path


def side(cut: int, point: int) -> int:
    return 0 if point == 0 else (cut >> (point - 1)) & 1


TRIPLES = list(itertools.combinations(range(8), 3))
CUTS: list[tuple[int, list[tuple[int, int] | None], int]] = []
for cut in range(1, 1 << 7):
    crossing = [
        (left, right)
        for left in range(8)
        for right in range(left + 1, 8)
        if side(cut, left) != side(cut, right)
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
    for _cut, pairs, edge_count in CUTS:
        adjacency = [[] for _ in range(edge_count)]
        for keep, pair in zip(selected, pairs, strict=True):
            if keep and pair is not None:
                left, right = pair
                adjacency[left].append(right)
                adjacency[right].append(left)
        colors = [-1] * edge_count
        separated = False
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
                        separated = True
                        break
                if separated:
                    break
            if separated:
                break
        if separated:
            continue
        clause = 0
        for index, pair in enumerate(pairs):
            if pair is not None and colors[pair[0]] == colors[pair[1]]:
                clause |= 1 << index
        if clause == 0:
            raise RuntimeError("complete family failed to distinguish a cut context")
        return clause
    return None


class Cnf:
    def __init__(self) -> None:
        self.variables = len(TRIPLES)
        self.clauses: list[tuple[int, ...]] = []

    def variable(self) -> int:
        self.variables += 1
        return self.variables

    def add(self, *literals: int) -> None:
        self.clauses.append(tuple(literals))

    def xor(self, left: int, right: int) -> int:
        """Return a fresh variable equivalent to ``left XOR right``."""
        output = self.variable()
        self.add(left, right, -output)
        self.add(-left, -right, -output)
        self.add(-left, right, output)
        self.add(left, -right, output)
        return output

    def parity(self, variables: list[int], odd: bool) -> None:
        assert len(variables) >= 2
        accumulator = variables[0]
        for variable in variables[1:]:
            accumulator = self.xor(accumulator, variable)
        self.add(accumulator if odd else -accumulator)

    def at_most(self, variables: list[int], bound: int) -> None:
        """Sinz sequential-counter encoding of ``sum(variables) <= bound``."""
        assert 0 < bound < len(variables)
        rows = [
            [self.variable() for _ in range(bound)]
            for _ in range(len(variables) - 1)
        ]
        self.add(-variables[0], rows[0][0])
        for threshold in range(1, bound):
            self.add(-rows[0][threshold])
        for index in range(1, len(variables) - 1):
            self.add(-variables[index], rows[index][0])
            self.add(-rows[index - 1][0], rows[index][0])
            for threshold in range(1, bound):
                self.add(-variables[index], -rows[index - 1][threshold - 1], rows[index][threshold])
                self.add(-rows[index - 1][threshold], rows[index][threshold])
            self.add(-variables[index], -rows[index - 1][bound - 1])
        self.add(-variables[-1], -rows[-1][bound - 1])

    def lex_leq(self, left: list[int], right: list[int]) -> None:
        """Require ``left <= right`` lexicographically, with False < True."""
        assert len(left) == len(right)
        prefix_equal = self.variable()
        self.add(prefix_equal)
        for left_bit, right_bit in zip(left, right, strict=True):
            if left_bit == right_bit:
                continue
            self.add(-prefix_equal, -left_bit, right_bit)
            next_equal = self.variable()
            self.add(-next_equal, prefix_equal)
            self.add(-next_equal, -left_bit, right_bit)
            self.add(-next_equal, left_bit, -right_bit)
            self.add(-prefix_equal, -left_bit, -right_bit, next_equal)
            self.add(-prefix_equal, left_bit, right_bit, next_equal)
            prefix_equal = next_equal


def compile_problem(
    bound: int,
    lower: int,
    mask_path: Path | None,
    lex_symmetry: bool,
    direct_contexts: bool,
) -> Cnf:
    cnf = Cnf()
    selected = list(range(1, len(TRIPLES) + 1))
    cnf.add(selected[0])  # Point transitivity fixes one selected triple.
    cnf.at_most(selected, bound)
    if lower > 0:
        cnf.at_most([-variable for variable in selected], len(selected) - lower)
    if mask_path is not None:
        document = json.loads(mask_path.read_text(encoding="utf-8"))
        expected_triples = [list(triple) for triple in TRIPLES]
        if (
            document.get("m") != 8
            or document.get("triples") != len(TRIPLES)
            or document.get("triple_list") != expected_triples
        ):
            raise ValueError("incompatible attachment-mask artifact")
        for mask in document["masks"]:
            cnf.add(*(selected[index] for index in mask))
    if lex_symmetry:
        triple_index = {triple: index for index, triple in enumerate(TRIPLES)}
        identity = tuple(range(8))
        for permutation in itertools.permutations(range(8)):
            if (
                permutation == identity
                or {permutation[0], permutation[1], permutation[2]} != {0, 1, 2}
            ):
                continue
            mapping = [
                triple_index[tuple(sorted(permutation[point] for point in triple))]
                for triple in TRIPLES
            ]
            cnf.lex_leq(selected, [selected[mapping[index]] for index in range(len(TRIPLES))])

    if direct_contexts:
        return cnf
    for _cut, pairs, edge_count in CUTS:
        crossing = [index for index, pair in enumerate(pairs) if pair is not None]
        witness = {index: cnf.variable() for index in crossing}
        for index in crossing:
            cnf.add(-witness[index], selected[index])
        for edge in range(edge_count):
            incident = [witness[index] for index in crossing if edge in pairs[index]]
            assert len(incident) == 8 - 2
            cnf.parity(incident, odd=False)
        cnf.parity(list(witness.values()), odd=True)
    return cnf


def write_dimacs(cnf: Cnf, path: Path, direct_contexts: bool) -> None:
    context_count = (
        sum(1 << (edge_count - 1) for _cut, _pairs, edge_count in CUTS)
        if direct_contexts
        else 0
    )
    with path.open("x", encoding="ascii", buffering=1 << 20) as stream:
        stream.write(f"p cnf {cnf.variables} {len(cnf.clauses) + context_count}\n")
        for clause in cnf.clauses:
            stream.write(" ".join(map(str, clause)))
            stream.write(" 0\n")
        if direct_contexts:
            for _cut, pairs, edge_count in CUTS:
                for colors_without_zero in range(1 << (edge_count - 1)):
                    colors = colors_without_zero << 1
                    clause = [
                        index + 1
                        for index, pair in enumerate(pairs)
                        if pair is not None
                        and ((colors >> pair[0]) & 1) == ((colors >> pair[1]) & 1)
                    ]
                    assert clause
                    stream.write(" ".join(map(str, clause)))
                    stream.write(" 0\n")


def read_model(path: Path) -> list[bool] | None:
    literals: list[int] = []
    satisfiable = None
    for line in path.read_text(encoding="ascii").splitlines():
        if line.startswith("s "):
            satisfiable = "UNSATISFIABLE" not in line
        elif line.startswith("v "):
            literals.extend(int(value) for value in line[2:].split() if value != "0")
    if satisfiable is not True:
        return None
    positive = {literal for literal in literals if literal > 0}
    return [index + 1 in positive for index in range(len(TRIPLES))]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bound", type=int, choices=range(1, len(TRIPLES)))
    parser.add_argument("--lower", type=int, default=0, choices=range(len(TRIPLES)))
    parser.add_argument("--cnf", type=Path)
    parser.add_argument("--masks", type=Path)
    parser.add_argument("--lex-symmetry", action="store_true")
    parser.add_argument("--direct-contexts", action="store_true")
    parser.add_argument("--model", type=Path)
    parser.add_argument("--result", type=Path)
    arguments = parser.parse_args()
    if arguments.model is not None:
        family = read_model(arguments.model)
        if family is None:
            raise SystemExit("model file does not contain a SAT assignment")
        violation = violated_clause(family)
        if violation is not None or sum(family) > arguments.bound:
            raise SystemExit("SAT assignment failed independent attachment replay")
        record = {
            "bound": arguments.bound,
            "family_indices": [index for index, keep in enumerate(family) if keep],
            "family_triples": [TRIPLES[index] for index, keep in enumerate(family) if keep],
        }
        text = json.dumps(record, indent=2) + "\n"
        if arguments.result is None:
            print(text, end="")
        else:
            with arguments.result.open("x", encoding="utf-8") as stream:
                stream.write(text)
        return
    if arguments.cnf is None:
        parser.error("--cnf is required when --model is absent")
    if arguments.lower > arguments.bound:
        parser.error("--lower must not exceed --bound")
    cnf = compile_problem(
        arguments.bound,
        arguments.lower,
        arguments.masks,
        arguments.lex_symmetry,
        arguments.direct_contexts,
    )
    write_dimacs(cnf, arguments.cnf, arguments.direct_contexts)
    context_count = (
        sum(1 << (edge_count - 1) for _cut, _pairs, edge_count in CUTS)
        if arguments.direct_contexts
        else 0
    )
    print(json.dumps({"variables": cnf.variables, "clauses": len(cnf.clauses) + context_count}))


if __name__ == "__main__":
    main()
