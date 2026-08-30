#!/usr/bin/env python3
"""Recover semantic clause ranges for the frozen C880 CNF compiler.

This is deliberately separate from the proof-producing compiler: it checks the
compiler's layout rather than changing the certified generator after the fact.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path

from c880_alignment_sat import CUTS, TRIPLES


class ClauseLedger:
    def __init__(self) -> None:
        self.clause = 0
        self.variable = len(TRIPLES)
        self.groups: list[dict[str, object]] = []

    def add(
        self,
        kind: str,
        clauses: int,
        variables: int = 0,
        **metadata: object,
    ) -> None:
        clause_begin = self.clause
        variable_begin = self.variable
        self.clause += clauses
        self.variable += variables
        self.groups.append(
            {
                "kind": kind,
                "clause_begin": clause_begin,
                "clause_end": self.clause,
                "variable_begin": variable_begin,
                "variable_end": self.variable,
                **metadata,
            }
        )

    def span(
        self,
        kind: str,
        clause_begin: int,
        variable_begin: int,
        **metadata: object,
    ) -> None:
        self.groups.append(
            {
                "kind": kind,
                "clause_begin": clause_begin,
                "clause_end": self.clause,
                "variable_begin": variable_begin,
                "variable_end": self.variable,
                **metadata,
            }
        )


def counter_clauses(items: int, bound: int) -> int:
    return bound + (items - 2) * (2 * bound + 1) + 1


def read_dimacs_header(path: Path) -> tuple[int, int]:
    with path.open("r", encoding="ascii") as stream:
        for line in stream:
            if line.startswith("p cnf "):
                _p, _cnf, variables, clauses = line.split()
                return int(variables), int(clauses)
    raise ValueError("DIMACS header not found")


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def locate_mask_contexts(masks: list[list[int]]) -> dict[int, tuple[int, int]]:
    targets = {sum(1 << index for index in mask): index for index, mask in enumerate(masks)}
    if len(targets) != len(masks):
        raise ValueError("low-weight mask artifact contains duplicate masks")
    located: dict[int, tuple[int, int]] = {}
    for cut, pairs, edge_count in CUTS:
        for colors_without_zero in range(1 << (edge_count - 1)):
            colors = colors_without_zero << 1
            mask = 0
            for triple, pair in enumerate(pairs):
                if pair is not None and ((colors >> pair[0]) & 1) == ((colors >> pair[1]) & 1):
                    mask |= 1 << triple
            index = targets.get(mask)
            if index is not None:
                located[index] = (cut, colors)
        if len(located) == len(targets):
            break
    if len(located) != len(targets):
        raise ValueError("a low-weight mask has no cut-colouring context")
    return located


def build_ledger(
    bound: int,
    lower: int,
    mask_path: Path,
    index_mask_contexts: bool,
) -> ClauseLedger:
    ledger = ClauseLedger()
    ledger.add("anchor", 1, triple=0)
    ledger.add(
        "cardinality_upper",
        counter_clauses(len(TRIPLES), bound),
        (len(TRIPLES) - 1) * bound,
        bound=bound,
    )
    complement_bound = len(TRIPLES) - lower
    ledger.add(
        "cardinality_lower",
        counter_clauses(len(TRIPLES), complement_bound),
        (len(TRIPLES) - 1) * complement_bound,
        lower=lower,
    )

    document = json.loads(mask_path.read_text(encoding="utf-8"))
    if document["m"] != 8 or document["triple_list"] != [list(t) for t in TRIPLES]:
        raise ValueError("incompatible low-weight mask artifact")
    mask_contexts = (
        locate_mask_contexts(document["masks"]) if index_mask_contexts else {}
    )
    for index, mask in enumerate(document["masks"]):
        metadata: dict[str, object] = {"mask": index, "weight": len(mask)}
        if index_mask_contexts:
            cut, colors = mask_contexts[index]
            side_size = cut.bit_count()
            metadata.update(
                cut=cut,
                side_size=min(side_size, 8 - side_size),
                colors=colors,
            )
        ledger.add("context_mask", 1, **metadata)

    triple_index = {triple: index for index, triple in enumerate(TRIPLES)}
    identity = tuple(range(8))
    symmetry = 0
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
        moved = sum(index != image for index, image in enumerate(mapping))
        ledger.add(
            "lex_symmetry",
            1 + 6 * moved,
            1 + moved,
            symmetry=symmetry,
            permutation=list(permutation),
            moved_triples=moved,
        )
        symmetry += 1
    if symmetry != 719:
        raise AssertionError("anchor stabilizer enumeration drifted")

    for cut, pairs, edge_count in CUTS:
        cut_clause_begin = ledger.clause
        cut_variable_begin = ledger.variable
        crossing = [index for index, pair in enumerate(pairs) if pair is not None]
        ledger.add(
            "cut_witness_link",
            len(crossing),
            len(crossing),
            cut=cut,
            crossing_triples=len(crossing),
        )
        for edge in range(edge_count):
            ledger.add(
                "cut_vertex_parity",
                21,
                5,
                cut=cut,
                edge=edge,
                edge_count=edge_count,
            )
        ledger.add(
            "cut_total_parity",
            4 * (len(crossing) - 1) + 1,
            len(crossing) - 1,
            cut=cut,
            crossing_triples=len(crossing),
        )
        side_size = cut.bit_count()
        ledger.span(
            "cut",
            cut_clause_begin,
            cut_variable_begin,
            cut=cut,
            side_size=min(side_size, 8 - side_size),
            edge_count=edge_count,
            crossing_triples=len(crossing),
        )
    return ledger


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--cnf", type=Path, required=True)
    parser.add_argument("--bound", type=int, required=True)
    parser.add_argument("--lower", type=int, required=True)
    parser.add_argument("--masks", type=Path, required=True)
    parser.add_argument("--index-mask-contexts", action="store_true")
    parser.add_argument("--out", type=Path, required=True)
    arguments = parser.parse_args()
    ledger = build_ledger(
        arguments.bound,
        arguments.lower,
        arguments.masks,
        arguments.index_mask_contexts,
    )
    variables, clauses = read_dimacs_header(arguments.cnf)
    if (variables, clauses) != (ledger.variable, ledger.clause):
        raise SystemExit(
            f"compiler layout drift: DIMACS={(variables, clauses)} "
            f"ledger={(ledger.variable, ledger.clause)}"
        )
    document = {
        "schema": "ergodis-semantic-clause-provenance/v1",
        "cnf": {
            "path": arguments.cnf.name,
            "bytes": arguments.cnf.stat().st_size,
            "sha256": sha256(arguments.cnf),
            "variables": variables,
            "clauses": clauses,
            "semantic_variables": list(range(1, len(TRIPLES) + 1)),
        },
        "parameters": {
            "bound": arguments.bound,
            "lower": arguments.lower,
            "mask_sha256": sha256(arguments.masks),
        },
        "groups": ledger.groups,
    }
    with arguments.out.open("x", encoding="utf-8") as stream:
        json.dump(document, stream, sort_keys=True, separators=(",", ":"))
        stream.write("\n")


if __name__ == "__main__":
    main()
