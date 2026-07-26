#!/usr/bin/env python3
"""Extract the theorem-like statements of the factorization-memory paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


ENVIRONMENTS = ("theorem", "proposition", "lemma", "corollary")
BEGIN_RE = re.compile(
    r"^\\begin\{(" + "|".join(ENVIRONMENTS) + r")\}(?:\[(.*)\])?\s*$"
)
LABEL_RE = re.compile(r"^\s*\\label\{([^}]+)\}\s*$")
EXPECTED_LABELS = (
    "thm:factorization-recovery",
    "prop:matching-secant-quotient",
    "thm:rank-three-quotients",
    "cor:h3-middle-layer",
    "prop:radical-hadamard",
    "thm:balanced-cubic",
    "cor:graded-evaluation",
    "cor:secant-product-syzygies",
    "thm:six-profile-reconstruction",
    "cor:decorated-sheet-classifier",
    "cor:profile-ray-weights",
    "prop:modular-depth-quotient",
    "lem:split-inert-frames",
    "thm:rank-three-arithmetic-gluing",
    "lem:three-ray-cubic",
    "cor:mass-zero-cubic",
    "prop:relative-cubic-tate-plane",
)


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def extract(source: Path) -> dict[str, object]:
    lines = source.read_text(encoding="utf-8").splitlines(keepends=True)
    statements: list[dict[str, object]] = []
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
        tex = "".join(active_lines).rstrip("\n")
        statements.append(
            {
                "label": labels[0],
                "environment": active_environment,
                "title": active_title,
                "source_line": active_line,
                "sha256": sha256_text(tex),
                "tex": tex,
            }
        )
        active_environment = None
        active_title = None
        active_line = 0
        active_lines = []

    if active_environment is not None:
        raise ValueError(
            f"{source}:{active_line}: unterminated {active_environment} statement"
        )
    labels = tuple(statement["label"] for statement in statements)
    if labels != EXPECTED_LABELS:
        raise ValueError(f"statement labels changed: {labels!r}")
    return {
        "schema": "clebsch-factorization-statement-identity-v1",
        "source": source.name,
        "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
        "statement_count": len(statements),
        "statements": statements,
    }


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "source",
        nargs="?",
        type=Path,
        default=paper_root / "clebsch_factorization.tex",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=paper_root / "verification" / "statement_identity.json",
    )
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    rendered = json.dumps(extract(args.source.resolve()), indent=2) + "\n"
    if args.check:
        if not args.output.exists() or args.output.read_text(encoding="utf-8") != rendered:
            raise SystemExit("statement identity is stale")
        print("statement identity: CHECK OK")
        return 0
    args.output.write_text(rendered, encoding="utf-8")
    print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
