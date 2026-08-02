#!/usr/bin/env python3
"""Reject TeX spacing commands whose leading backslash was dropped."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


MALFORMED_SPACING = re.compile(r",\s*q{1,2}uad\b")


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
    if findings:
        parser.error(
            "missing TeX command escape before quad/qquad:\n" + "\n".join(findings)
        )
    noun = "file" if len(files) == 1 else "files"
    print(f"TeX spacing-command lint: {len(files)} {noun}: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
