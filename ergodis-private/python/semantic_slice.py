#!/usr/bin/env python3
"""Select semantic clause groups from a provenance-annotated DIMACS file."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from semantic_core import dimacs_clauses


def parse_selector(text: str) -> dict[str, object]:
    selector: dict[str, object] = {}
    for field in text.split(","):
        key, separator, value = field.partition("=")
        if not separator or not key or not value:
            raise ValueError(f"invalid selector: {text}")
        selector[key] = int(value) if value.isdecimal() else value
    return selector


def matches(group: dict[str, object], selector: dict[str, object]) -> bool:
    return all(group.get(key) == value for key, value in selector.items())


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--cnf", type=Path, required=True)
    parser.add_argument("--provenance", type=Path, required=True)
    parser.add_argument("--select", action="append", required=True)
    parser.add_argument("--out", type=Path, required=True)
    parser.add_argument("--report", type=Path)
    arguments = parser.parse_args()
    provenance = json.loads(arguments.provenance.read_text(encoding="utf-8"))
    clauses = dimacs_clauses(arguments.cnf)
    selectors = [parse_selector(text) for text in arguments.select]
    keep = bytearray(len(clauses))
    matched_groups = 0
    selected_by_rule = [0] * len(selectors)
    for group in provenance["groups"]:
        for rule, selector in enumerate(selectors):
            if not matches(group, selector):
                continue
            begin = int(group["clause_begin"])
            end = int(group["clause_end"])
            keep[begin:end] = b"\x01" * (end - begin)
            matched_groups += 1
            selected_by_rule[rule] += 1
            break
    selected = sum(keep)
    variables = int(provenance["cnf"]["variables"])
    with arguments.out.open("x", encoding="ascii", buffering=1 << 20) as stream:
        stream.write(f"p cnf {variables} {selected}\n")
        for retain, clause in zip(keep, clauses, strict=True):
            if retain:
                stream.write(" ".join(map(str, clause)))
                stream.write(" 0\n")
    report = {
        "schema": "ergodis-semantic-slice/v1",
        "source_clauses": len(clauses),
        "selected_clauses": selected,
        "matched_groups": matched_groups,
        "selectors": [
            {"selector": selector, "matched_groups": selected_by_rule[index]}
            for index, selector in enumerate(selectors)
        ],
    }
    text = json.dumps(report, indent=2, sort_keys=True) + "\n"
    if arguments.report is None:
        print(text, end="")
    else:
        with arguments.report.open("x", encoding="utf-8") as stream:
            stream.write(text)


if __name__ == "__main__":
    main()
