#!/usr/bin/env python3
"""Extract exact theorem-like statements from the Clebsch manuscript.

The extractor recognizes the theorem, proposition, lemma, and corollary
environments used by the manuscript.  It emits a deterministic JSON inventory
whose statement text is copied byte-for-byte (apart from the trailing newline)
from the TeX source.  Each row includes its source line and a SHA-256 digest.

This is an identity inventory, not a proof checker: it identifies the paper
statement that a trust manifest must compare semantically with a formal
terminal, certificate, replay, or cited mathematical input.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from dataclasses import dataclass
from pathlib import Path


ENVIRONMENTS = ("theorem", "proposition", "lemma", "corollary")
BEGIN_RE = re.compile(
    r"^\\begin\{(" + "|".join(ENVIRONMENTS) + r")\}(?:\[(.*)\])?\s*$"
)
LABEL_RE = re.compile(r"^\s*\\label\{([^}]+)\}\s*$")


@dataclass(frozen=True)
class Statement:
    environment: str
    title: str | None
    label: str | None
    source_line: int
    tex: str

    def as_json(self) -> dict[str, object]:
        digest = hashlib.sha256(self.tex.encode("utf-8")).hexdigest()
        return {
            "claim_key": self.label or f"{self.environment}:{digest[:16]}",
            "environment": self.environment,
            "title": self.title,
            "label": self.label,
            "source_line": self.source_line,
            "sha256": digest,
            "tex": self.tex,
        }


def extract(source: Path) -> list[Statement]:
    lines = source.read_text(encoding="utf-8").splitlines(keepends=True)
    statements: list[Statement] = []
    active_environment: str | None = None
    active_title: str | None = None
    active_line = 0
    active_lines: list[str] = []

    for line_number, line in enumerate(lines, start=1):
        if active_environment is None:
            match = BEGIN_RE.match(line.rstrip("\n"))
            if match is None:
                continue
            active_environment = match.group(1)
            active_title = match.group(2)
            active_line = line_number
            active_lines = [line]
            continue

        active_lines.append(line)
        if line.rstrip("\n") != rf"\end{{{active_environment}}}":
            continue

        labels = [
            match.group(1)
            for statement_line in active_lines
            if (match := LABEL_RE.match(statement_line)) is not None
        ]
        if len(labels) > 1:
            raise ValueError(
                f"{source}:{active_line}: expected at most one label in "
                f"{active_environment} statement, found {len(labels)}"
            )
        tex = "".join(active_lines).rstrip("\n")
        statements.append(
            Statement(
                environment=active_environment,
                title=active_title,
                label=labels[0] if labels else None,
                source_line=active_line,
                tex=tex,
            )
        )
        active_environment = None
        active_title = None
        active_line = 0
        active_lines = []

    if active_environment is not None:
        raise ValueError(
            f"{source}:{active_line}: unterminated {active_environment} statement"
        )

    labels = [
        statement.label for statement in statements if statement.label is not None
    ]
    duplicates = sorted({label for label in labels if labels.count(label) > 1})
    if duplicates:
        raise ValueError(f"duplicate statement labels: {', '.join(duplicates)}")
    return statements


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract theorem-like statements for identity comparison."
    )
    parser.add_argument(
        "source",
        nargs="?",
        type=Path,
        default=Path(__file__).resolve().parents[1] / "clebsch_hexagon_code.tex",
        help="manuscript TeX source",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="write the deterministic JSON inventory to this path",
    )
    args = parser.parse_args()

    source = args.source.resolve()
    statements = extract(source)
    payload = {
        "schema": "clebsch-statement-identity-v1",
        "source": source.name,
        "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "statement_count": len(statements),
        "statements": [statement.as_json() for statement in statements],
    }
    rendered = json.dumps(payload, indent=2, ensure_ascii=False, sort_keys=True) + "\n"
    if args.output is None:
        print(rendered, end="")
    else:
        args.output.write_text(rendered, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
