#!/usr/bin/env python3
"""Validate the ergodis release surface."""

from __future__ import annotations

import re
from fnmatch import fnmatch
from pathlib import Path

PAPER = Path(__file__).resolve().parents[1]
ROOT = PAPER / "ergodis"

EXCLUDED_DIRS = {"__pycache__", "target"}
EXCLUDED_FILE_PATTERNS = {"A?ENTS.md"}
TEXT_SUFFIXES = {".json", ".lock", ".md", ".py", ".rs", ".svg", ".toml", ".txt"}
TEXT_NAMES = {"SHA256SUMS"}

FORBIDDEN = (
    (re.compile(r"\bC\d{3}\b"), "reserved identifier"),
    (
        re.compile(
            "(?i)\\b(?:"
            + "task "
            + "card|lane "
            + "handoff|private "
            + "working memo)\\b"
        ),
        "development-only phrase",
    ),
    (re.compile(r"(?i)(?:^|[\\/])notes[\\/]"), "non-release notes path"),
    (re.compile("(?i)\\b" + "A" + "GENTS\\.md\\b"), "local instruction reference"),
    (re.compile(r"(?i)performance playbook"), "non-release tuning guide"),
    (re.compile(r"(?i)\bmonorepo\b"), "non-release repository role"),
    (
        re.compile(
            "(?:/" + "home/|~/" + "src/|/" + "Users/|[A-Za-z]:\\\\" + "Users\\\\)"
        ),
        "machine-local filesystem path",
    ),
)

FORBIDDEN_SUFFIXES = {
    ".aux",
    ".data",
    ".fdb_latexmk",
    ".fls",
    ".log",
    ".profraw",
    ".pyc",
}


def fail(message: str) -> None:
    raise SystemExit(f"ergodis public-surface check: FAIL [{message}]")


def candidate_paths() -> list[Path]:
    paths: list[Path] = []
    for path in ROOT.rglob("*"):
        relative = path.relative_to(ROOT)
        if any(part in EXCLUDED_DIRS for part in relative.parts):
            continue
        if any(fnmatch(relative.as_posix(), pattern) for pattern in EXCLUDED_FILE_PATTERNS):
            continue
        if path.is_symlink():
            fail(f"symlink is not permitted: {relative.as_posix()}")
        if not path.is_file():
            continue
        if path.suffix in FORBIDDEN_SUFFIXES:
            fail(f"generated or local artifact is present: {relative.as_posix()}")
        paths.append(path)
    return sorted(paths)


def scan_text(path: Path) -> None:
    relative = path.relative_to(ROOT).as_posix()
    try:
        text = path.read_text()
    except UnicodeDecodeError as error:
        fail(f"declared text file is not UTF-8: {relative}: {error}")
    for pattern, description in FORBIDDEN:
        match = pattern.search(relative) or pattern.search(text)
        if match is not None:
            fail(f"{description} in {relative}: {match.group(0)!r}")


def main() -> None:
    paths = candidate_paths()
    if not paths:
        fail("ergodis tree is empty")
    scanned = 0
    for path in paths:
        if path.suffix in TEXT_SUFFIXES or path.name in TEXT_NAMES:
            scan_text(path)
            scanned += 1
    cargo = (ROOT / "Cargo.toml").read_text()
    if 'exclude = ["A?ENTS.md"' not in cargo:
        fail("Cargo package does not explicitly exclude its local instruction file")
    print(f"ergodis public-surface check: PASS ({scanned} text files)")


if __name__ == "__main__":
    main()
