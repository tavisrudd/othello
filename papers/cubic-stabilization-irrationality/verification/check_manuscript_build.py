#!/usr/bin/env python3
"""Reject TeX warnings and a tracked PDF stale against manuscript sources.

The manuscript is rebuilt in a temporary directory containing only its source,
sections, and bibliography.  A pinned source date makes that build
byte-reproducible, so equality with the tracked PDF is an exact staleness test
that does not trust latexmk's auxiliary-file state.  Run with ``--update`` to
refresh the tracked PDF from this same isolated deterministic build.

Invoke through the paper's pinned manuscript environment, as the Makefile does.
"""

from __future__ import annotations

import argparse
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


PAPER = Path(__file__).resolve().parents[1]
SOURCE = "cubic_stabilization_irrationality.tex"
TRACKED_PDF = PAPER / "cubic_stabilization_irrationality.pdf"
EXPECTED_PAGES = 28
DETERMINISTIC_EPOCH = "1785888000"

WARNING_RE = re.compile(
    r"(LaTeX Warning|Package .* Warning|Overfull|Underfull|undefined references"
    r"|undefined citations)",
    re.IGNORECASE,
)
PAGES_RE = re.compile(r"Output written on .+ \((\d+) pages?,")


def fail(message: str) -> None:
    raise SystemExit(f"cubic-stabilization-irrationality manuscript: FAIL: {message}")


def deterministic_environment() -> dict[str, str]:
    environment = dict(os.environ)
    environment["SOURCE_DATE_EPOCH"] = DETERMINISTIC_EPOCH
    environment["FORCE_SOURCE_DATE"] = "1"
    return environment


def build_pdf(build_root: Path) -> bytes:
    """Build from a clean source copy and return the deterministic PDF."""
    shutil.copy2(PAPER / SOURCE, build_root / SOURCE)
    shutil.copytree(PAPER / "sections", build_root / "sections")
    for bibliography in PAPER.glob("*.bib"):
        shutil.copy2(bibliography, build_root / bibliography.name)

    completed = subprocess.run(
        ["latexmk", "-xelatex", "-interaction=nonstopmode", "-halt-on-error", SOURCE],
        cwd=build_root,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=deterministic_environment(),
    )
    if completed.returncode != 0:
        detail = (completed.stderr or completed.stdout).splitlines()
        fail("build failed:\n" + "\n".join(detail[-20:]))

    log = (build_root / Path(SOURCE).with_suffix(".log")).read_text(
        encoding="utf-8", errors="replace"
    )
    warnings = sorted({match.group(0) for match in WARNING_RE.finditer(log)})
    if warnings:
        fail(f"TeX warnings {warnings}")
    pages = PAGES_RE.search(log)
    if pages is None:
        fail("no page count in the TeX log")
    if int(pages.group(1)) != EXPECTED_PAGES:
        fail(f"page count {pages.group(1)}, expected {EXPECTED_PAGES}")
    return (build_root / Path(SOURCE).with_suffix(".pdf")).read_bytes()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--update",
        action="store_true",
        help="refresh the tracked PDF from the deterministic isolated build",
    )
    args = parser.parse_args()

    with tempfile.TemporaryDirectory(
        prefix="cubic-stabilization-irrationality-build-"
    ) as scratch:
        rebuilt = build_pdf(Path(scratch))

    if args.update:
        TRACKED_PDF.write_bytes(rebuilt)
        print(
            f"cubic-stabilization-irrationality manuscript: UPDATED "
            f"[{len(rebuilt)} bytes]"
        )
        return 0

    if not TRACKED_PDF.is_file():
        fail("tracked PDF is missing; rerun with `make manuscript-update`")
    if TRACKED_PDF.read_bytes() != rebuilt:
        fail(
            "tracked PDF differs from a deterministic build of the source; "
            "rerun with `make manuscript-update`"
        )
    print(
        f"cubic-stabilization-irrationality manuscript: PASS "
        f"[{EXPECTED_PAGES} pages, warning-free, tracked PDF current]"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
