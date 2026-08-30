#!/usr/bin/env python3
"""Lift a checked DIMACS input core back to semantic compiler groups."""

from __future__ import annotations

import argparse
import bisect
import collections
import hashlib
import json
from pathlib import Path


def dimacs_clauses(path: Path) -> list[tuple[int, ...]]:
    clauses: list[tuple[int, ...]] = []
    pending: list[int] = []
    with path.open("r", encoding="ascii") as stream:
        for line in stream:
            if not line or line[0] in "cp":
                continue
            for token in line.split():
                literal = int(token)
                if literal == 0:
                    clauses.append(tuple(sorted(pending)))
                    pending.clear()
                else:
                    pending.append(literal)
    if pending:
        raise ValueError("unterminated DIMACS clause")
    return clauses


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        while chunk := stream.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def integer_ranges(values: list[int]) -> list[list[int]]:
    if not values:
        return []
    ranges: list[list[int]] = []
    begin = previous = values[0]
    for value in values[1:]:
        if value != previous + 1:
            ranges.append([begin, previous])
            begin = value
        previous = value
    ranges.append([begin, previous])
    return ranges


def locate_core(original: list[tuple[int, ...]], core: list[tuple[int, ...]]) -> list[int]:
    locations: dict[tuple[int, ...], collections.deque[int]] = {}
    for index, clause in enumerate(original):
        locations.setdefault(clause, collections.deque()).append(index)
    indices: list[int] = []
    for clause in core:
        candidates = locations.get(clause)
        if not candidates:
            raise ValueError(f"core clause is absent from original CNF: {clause[:8]}")
        indices.append(candidates.popleft())
    indices.sort()
    return indices


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--cnf", type=Path, required=True)
    parser.add_argument("--core", type=Path, required=True)
    parser.add_argument("--provenance", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    arguments = parser.parse_args()
    provenance = json.loads(arguments.provenance.read_text(encoding="utf-8"))
    if provenance["cnf"]["sha256"] != sha256(arguments.cnf):
        raise SystemExit("provenance does not match the supplied CNF")
    original = dimacs_clauses(arguments.cnf)
    core = dimacs_clauses(arguments.core)
    indices = locate_core(original, core)

    by_kind: dict[str, dict[str, object]] = {}
    used_cuts: dict[int, dict[str, int]] = {}
    used_masks: dict[int, list[int]] = collections.defaultdict(list)
    used_mask_cut_types: collections.Counter[int] = collections.Counter()
    used_mask_cuts: collections.Counter[int] = collections.Counter()
    used_symmetries: list[int] = []
    for group in provenance["groups"]:
        begin = int(group["clause_begin"])
        end = int(group["clause_end"])
        used = bisect.bisect_left(indices, end) - bisect.bisect_left(indices, begin)
        kind = str(group["kind"])
        summary = by_kind.setdefault(
            kind,
            {"groups": 0, "used_groups": 0, "clauses": 0, "core_clauses": 0},
        )
        summary["groups"] = int(summary["groups"]) + 1
        summary["clauses"] = int(summary["clauses"]) + end - begin
        if used == 0:
            continue
        summary["used_groups"] = int(summary["used_groups"]) + 1
        summary["core_clauses"] = int(summary["core_clauses"]) + used
        if kind == "cut":
            used_cuts[int(group["cut"])] = {
                "side_size": int(group["side_size"]),
                "core_clauses": used,
            }
        elif kind == "context_mask":
            used_masks[int(group["weight"])].append(int(group["mask"]))
            if "side_size" in group:
                used_mask_cut_types[int(group["side_size"])] += 1
                used_mask_cuts[int(group["cut"])] += 1
        elif kind == "lex_symmetry":
            used_symmetries.append(int(group["symmetry"]))

    cut_type_histogram: dict[int, int] = collections.Counter(
        record["side_size"] for record in used_cuts.values()
    )
    document = {
        "schema": "ergodis-semantic-input-core/v1",
        "cnf_sha256": sha256(arguments.cnf),
        "core_sha256": sha256(arguments.core),
        "input_clauses": len(original),
        "core_clauses": len(core),
        "core_clause_index_ranges": integer_ranges(indices),
        "by_kind": dict(sorted(by_kind.items())),
        "cuts": {
            "used": len(used_cuts),
            "type_histogram": {
                str(key): value for key, value in sorted(cut_type_histogram.items())
            },
            "records": {str(key): value for key, value in sorted(used_cuts.items())},
        },
        "masks": {
            "by_weight": {
                str(weight): {
                    "used": len(mask_indices),
                    "index_ranges": integer_ranges(sorted(mask_indices)),
                }
                for weight, mask_indices in sorted(used_masks.items())
            },
            "by_cut_type": {
                str(key): value for key, value in sorted(used_mask_cut_types.items())
            },
            "by_cut": {
                str(key): value for key, value in sorted(used_mask_cuts.items())
            },
        },
        "symmetry": {
            "used": len(used_symmetries),
            "index_ranges": integer_ranges(sorted(used_symmetries)),
        },
    }
    with arguments.out.open("x", encoding="utf-8") as stream:
        json.dump(document, stream, indent=2, sort_keys=True)
        stream.write("\n")


if __name__ == "__main__":
    main()
