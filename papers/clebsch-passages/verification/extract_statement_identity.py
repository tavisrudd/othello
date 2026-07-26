#!/usr/bin/env python3
"""Extract the theorem-like statements of the Clebsch cubic paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


ENVIRONMENTS = ("theorem", "proposition", "lemma", "corollary")
BEGIN_RE = re.compile(
    r"^\\begin\{(" + "|".join(ENVIRONMENTS) + r")\}(?:\[(.*)\])?"
)
LABEL_RE = re.compile(r"\\label\{([^}]+)\}")
INPUT_RE = re.compile(r"\\input\{([^}]+)\}")
EXPECTED_LABELS = (
    "thm:arithmetic-main",
    "thm:harmonic-main",
    "prop:golden-fibre",
    "prop:spinor-specialization",
)


def sha256_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def section_paths(main: Path) -> list[Path]:
    source = main.read_text(encoding="utf-8")
    return [main.parent / f"{relative}.tex" for relative in INPUT_RE.findall(source)]


def extract(main: Path) -> dict[str, object]:
    statements: list[dict[str, object]] = []
    source_hashes: dict[str, str] = {}

    for source in section_paths(main):
        relative = source.relative_to(main.parent).as_posix()
        source_hashes[relative] = hashlib.sha256(source.read_bytes()).hexdigest()
        lines = source.read_text(encoding="utf-8").splitlines(keepends=True)
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
            else:
                active_lines.append(line)

            if line.rstrip("\n") != rf"\end{{{active_environment}}}":
                continue
            tex = "".join(active_lines).rstrip("\n")
            labels = LABEL_RE.findall(tex)
            if len(labels) != 1:
                raise ValueError(
                    f"{source}:{active_line}: expected exactly one statement label"
                )
            statements.append(
                {
                    "label": labels[0],
                    "environment": active_environment,
                    "title": active_title,
                    "source": relative,
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
        "schema": "clebsch-orientation-statement-identity-v2",
        "main_source": main.name,
        "main_source_sha256": hashlib.sha256(main.read_bytes()).hexdigest(),
        "section_sha256": source_hashes,
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
        default=paper_root / "clebsch_passages.tex",
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
        print("Paper III statement identity: CHECK OK")
        return 0
    args.output.write_text(rendered, encoding="utf-8")
    print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
