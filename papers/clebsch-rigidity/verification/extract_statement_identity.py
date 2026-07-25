#!/usr/bin/env python3
"""Extract the nineteen published claims of the Clebsch rigidity paper.

Seventeen rows are theorem-like environments.  The other two rows identify
the introductory headline and the sentence that declares the scope of the
complete fifteen-class census.  The output is deterministic and preserves
the selected TeX byte-for-byte apart from its trailing newline.
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

ROW_LABELS = {
    11: "prop:a5-point-orbits",
    12: "prop:deep-holes-conic",
    13: "cor:named-variety",
    14: "prop:deep-hole-orbit",
    15: "prop:decoding-oracle",
    16: "lem:six-arc-line-bound",
    17: "thm:rigidity",
    18: "prop:low-degree-rigidity",
    19: "cor:monomial-characterization",
    20: "thm:gap",
    21: "prop:brianchon-support",
    22: "cor:decoder-brianchon",
    23: "prop:invariant-support-bipartition",
    24: (
        "lem:chord-defect",
        "cor:conic-filling-window",
        "lem:q9-polarity",
    ),
    25: "thm:why11",
    26: "prop:clebsch-family-uncovered",
    29: "thm:small-k-conic-filling",
}

HEADLINE = (
    "Its maximum-distance syndrome directions form a\n"
    "conic, and that coarse locus already determines the projective code: its six\n"
    "parity-check columns are projectively equivalent to the Clebsch hexagon,\n"
    "with the associated polarity and $A_5$ symmetry.  No conic, polarity, group\n"
    "action, or classical hexagon structure is assumed."
)
CENSUS = (
    "Table~\\ref{tab:fifteen-classes} prints the complete census at the level\n"
    "used by the rigidity and low-degree arguments."
)


@dataclass(frozen=True)
class Statement:
    environment: str
    title: str | None
    label: str
    source_line: int
    tex: str


def digest(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def extract_environments(source: Path) -> list[Statement]:
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
        if len(labels) != 1:
            raise ValueError(
                f"{source}:{active_line}: expected exactly one statement label"
            )
        statements.append(
            Statement(
                environment=active_environment,
                title=active_title,
                label=labels[0],
                source_line=active_line,
                tex="".join(active_lines).rstrip("\n"),
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
    return statements


def unique_snippet(text: str, snippet: str, name: str) -> int:
    if text.count(snippet) != 1:
        raise ValueError(f"{name} snippet must occur exactly once")
    return text[: text.index(snippet)].count("\n") + 1


def build_payload(source: Path) -> dict[str, object]:
    text = source.read_text(encoding="utf-8")
    by_label = {statement.label: statement for statement in extract_environments(source)}
    expected_labels = [
        label
        for labels in ROW_LABELS.values()
        for label in (labels if isinstance(labels, tuple) else (labels,))
    ]
    if set(by_label) != set(expected_labels) or len(by_label) != len(expected_labels):
        raise ValueError(
            "the theorem-like statements do not match the published claim map"
        )

    claims: list[dict[str, object]] = [
        {
            "row": 2,
            "id": "rigidity-headline",
            "kind": "verbatim",
            "source_line": unique_snippet(text, HEADLINE, "headline"),
            "sha256": digest(HEADLINE),
            "tex": HEADLINE,
        }
    ]
    for row, labels in ROW_LABELS.items():
        group = labels if isinstance(labels, tuple) else (labels,)
        statements = [by_label[label] for label in group]
        statement = statements[0]
        statement_tex = "\n\n".join(item.tex for item in statements)
        claims.append(
            {
                "row": row,
                "id": "+".join(group),
                "kind": "theorem-environment",
                "environment": (
                    statement.environment if len(group) == 1 else "statement-group"
                ),
                "title": (
                    statement.title
                    if len(group) == 1
                    else "; ".join(item.title or item.label for item in statements)
                ),
                "source_line": statement.source_line,
                "sha256": digest(statement_tex),
                "tex": statement_tex,
            }
        )
    claims.append(
        {
            "row": 58,
            "id": "fifteen-class-census-table",
            "kind": "verbatim",
            "source_line": unique_snippet(text, CENSUS, "census"),
            "sha256": digest(CENSUS),
            "tex": CENSUS,
        }
    )
    return {
        "schema": "clebsch-rigidity-statement-identity-v1",
        "source": source.name,
        "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "claim_count": len(claims),
        "claims": claims,
    }


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(
        description="Extract the nineteen published Clebsch rigidity claims."
    )
    parser.add_argument(
        "source",
        nargs="?",
        type=Path,
        default=paper_root / "clebsch_rigidity.tex",
    )
    parser.add_argument("--output", type=Path)
    parser.add_argument(
        "--check",
        action="store_true",
        help="compare generated content with --output instead of writing it",
    )
    args = parser.parse_args()

    rendered = (
        json.dumps(
            build_payload(args.source.resolve()),
            indent=2,
            ensure_ascii=False,
            sort_keys=True,
        )
        + "\n"
    )
    if args.check:
        if args.output is None:
            raise ValueError("--check requires --output")
        if args.output.read_text(encoding="utf-8") != rendered:
            raise ValueError(f"stale statement identity: {args.output}")
    elif args.output is None:
        print(rendered, end="")
    else:
        args.output.write_text(rendered, encoding="utf-8")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, UnicodeError, ValueError) as error:
        print(f"statement extraction failed: {error}")
        raise SystemExit(1)
