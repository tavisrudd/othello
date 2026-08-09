#!/usr/bin/env python3
"""Reject recurrent TeX source-hygiene failures."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


MALFORMED_SPACING = re.compile(r",\s*q{1,2}uad\b")
LITERAL_RESULT_REFERENCE = re.compile(
    r"\b(?:Theorem|Proposition|Lemma|Corollary)~?\s*\d+(?:\.\d+)*\b"
)
CITE_COMMAND = re.compile(r"\\cite(?:\[[^]]*\])?\{[^}]*\}")


def tex_files(paths: list[Path]) -> list[Path]:
    files: set[Path] = set()
    for path in paths:
        if path.is_dir():
            files.update(
                candidate for candidate in path.rglob("*.tex") if candidate.is_file()
            )
        elif path.is_file():
            files.add(path)
        else:
            raise FileNotFoundError(path)
    return sorted(files)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("paths", nargs="+", type=Path)
    args = parser.parse_args()

    findings: list[str] = []
    files = tex_files(args.paths)
    for path in files:
        source = path.read_text(encoding="utf-8")
        for match in MALFORMED_SPACING.finditer(source):
            line = source.count("\n", 0, match.start()) + 1
            column = match.start() - source.rfind("\n", 0, match.start())
            findings.append(f"{path}:{line}:{column}: {match.group()!r}")
        citation_spans = [match.span() for match in CITE_COMMAND.finditer(source)]
        for match in LITERAL_RESULT_REFERENCE.finditer(source):
            if any(start <= match.start() < end for start, end in citation_spans):
                continue
            line = source.count("\n", 0, match.start()) + 1
            column = match.start() - source.rfind("\n", 0, match.start())
            findings.append(
                f"{path}:{line}:{column}: literal rendered result reference "
                f"{match.group()!r}; use a stable semantic label"
            )
    if findings:
        parser.error("TeX source-hygiene failure:\n" + "\n".join(findings))
    noun = "file" if len(files) == 1 else "files"
    print(f"TeX source-hygiene lint: {len(files)} {noun}: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
