#!/usr/bin/env python3
"""Rebuild each manuscript deterministically and reject TeX warnings and stale PDFs.

Each source is built in a temporary directory from a clean state, so the build
depends on the tracked source alone and not on leftover auxiliary files. The
build is made byte-reproducible by pinning ``SOURCE_DATE_EPOCH`` and setting
``FORCE_SOURCE_DATE``, which fixes the timestamps TeX and the PDF writer would
otherwise embed. The pinned epoch is a build-normalization constant chosen so
that repeated builds agree; it is not a claim about when the manuscript was
written or released.

Determinism turns PDF staleness into an exact check. The rebuilt PDF must equal
the tracked PDF byte for byte, which holds exactly when the tracked PDF is the
build of the tracked source. A manuscript edit committed without refreshing the
tracked PDF therefore fails here rather than being certified downstream.

Run with ``--update`` to refresh the tracked PDFs from the same deterministic
build. That is the supported way to regenerate them: building by hand without
the pinned epoch produces a PDF that differs from a fresh build in its embedded
timestamps and fails this check.
"""

from __future__ import annotations

import argparse
import hashlib
import os
import re
import shutil
import subprocess
import tempfile
from pathlib import Path


WARNING_RE = re.compile(
    r"(LaTeX Warning|Package .* Warning|Overfull|Underfull|undefined references)",
    re.IGNORECASE,
)
PAGES_RE = re.compile(r"Output written on .+ \((\d+) pages?,")
EXPECTED_PAGES = {
    "clebsch_rigidity.tex": 26,
    "clebsch_rigidity_computational_companion.tex": 13,
}
# 2026-01-01T00:00:00Z. Fixed so that independent builds of one source agree.
DETERMINISTIC_EPOCH = "1767225600"


def deterministic_environment() -> dict[str, str]:
    environment = dict(os.environ)
    environment["SOURCE_DATE_EPOCH"] = DETERMINISTIC_EPOCH
    environment["FORCE_SOURCE_DATE"] = "1"
    return environment


def build_pdf(source: Path, build_root: Path, expected_pages: int) -> bytes:
    """Build one manuscript from a clean directory and return its PDF bytes."""
    shutil.copy2(source, build_root / source.name)
    completed = subprocess.run(
        [
            "latexmk",
            "-xelatex",
            "-interaction=nonstopmode",
            "-halt-on-error",
            source.name,
        ],
        cwd=build_root,
        check=False,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        env=deterministic_environment(),
    )
    if completed.returncode != 0:
        detail = (completed.stderr or completed.stdout).splitlines()
        raise RuntimeError(
            f"{source.name} build failed:\n" + "\n".join(detail[-20:])
        )
    log = (build_root / source.with_suffix(".log").name).read_text(
        encoding="utf-8", errors="replace"
    )
    warnings = WARNING_RE.findall(log)
    if warnings:
        raise RuntimeError(f"{source.name} log contains {len(warnings)} warnings")
    match = PAGES_RE.search(log)
    if match is None:
        raise RuntimeError(f"{source.name} log contains no page count")
    pages = int(match.group(1))
    if pages != expected_pages:
        raise RuntimeError(f"{source.name} page count changed: {pages}")
    built_pdf = build_root / source.with_suffix(".pdf").name
    if not built_pdf.is_file() or built_pdf.stat().st_size == 0:
        raise RuntimeError(f"{source.name} build produced no PDF")
    return built_pdf.read_bytes()


def check_source(paper_root: Path, source_name: str, expected_pages: int, update: bool) -> str:
    source = paper_root / source_name
    tracked_pdf = paper_root / source.with_suffix(".pdf").name
    with tempfile.TemporaryDirectory(prefix="clebsch-rigidity-build-") as directory:
        data = build_pdf(source, Path(directory), expected_pages)
    digest = hashlib.sha256(data).hexdigest()
    if update:
        tracked_pdf.write_bytes(data)
        return digest
    if not tracked_pdf.is_file():
        raise RuntimeError(f"{tracked_pdf.name} is absent; rerun with --update")
    tracked = tracked_pdf.read_bytes()
    if tracked != data:
        raise RuntimeError(
            f"{tracked_pdf.name} is stale: it does not match a fresh build of "
            f"{source.name} (tracked {hashlib.sha256(tracked).hexdigest()}, "
            f"rebuilt {digest}); rerun with --update"
        )
    return digest


def main() -> int:
    parser = argparse.ArgumentParser(description="Check or refresh the manuscript PDFs.")
    parser.add_argument(
        "--update",
        action="store_true",
        help="refresh the tracked PDFs from the deterministic build",
    )
    args = parser.parse_args()
    paper_root = Path(__file__).resolve().parents[1]
    digests = {
        source_name: check_source(paper_root, source_name, expected_pages, args.update)
        for source_name, expected_pages in EXPECTED_PAGES.items()
    }
    page_summary = ",".join(
        f"{Path(name).stem}:{pages}" for name, pages in EXPECTED_PAGES.items()
    )
    pdf_state = "refreshed" if args.update else "current"
    pdf_summary = ",".join(
        f"{Path(name).stem}:{digest[:16]}" for name, digest in digests.items()
    )
    print(
        f"manuscript_pages={page_summary} warnings=0 "
        f"pdfs={pdf_state} pdf_sha256={pdf_summary}"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, UnicodeError) as error:
        print(f"manuscript-build check failed: {error}")
        raise SystemExit(1)
