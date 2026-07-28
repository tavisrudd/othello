#!/usr/bin/env python3
"""Build the manuscript in a temporary directory and reject TeX warnings."""

from __future__ import annotations

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
EXPECTED_PAGES = 15


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    source = paper_root / "clebsch_rigidity.tex"
    with tempfile.TemporaryDirectory(prefix="clebsch-rigidity-build-") as directory:
        build_root = Path(directory)
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
        )
        if completed.returncode != 0:
            detail = (completed.stderr or completed.stdout).splitlines()
            raise RuntimeError("manuscript build failed:\n" + "\n".join(detail[-20:]))
        log = (build_root / "clebsch_rigidity.log").read_text(
            encoding="utf-8", errors="replace"
        )
        warnings = WARNING_RE.findall(log)
        if warnings:
            raise RuntimeError(f"manuscript log contains {len(warnings)} warnings")
        match = PAGES_RE.search(log)
        if match is None:
            raise RuntimeError("manuscript log contains no page count")
        pages = int(match.group(1))
        if pages != EXPECTED_PAGES:
            raise RuntimeError(f"manuscript page count changed: {pages}")
        built_pdf = build_root / "clebsch_rigidity.pdf"
        if not built_pdf.is_file() or built_pdf.stat().st_size == 0:
            raise RuntimeError("manuscript build produced no PDF")
    print(f"manuscript_pages={EXPECTED_PAGES} warnings=0 pdf=produced")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, RuntimeError, UnicodeError) as error:
        print(f"manuscript-build check failed: {error}")
        raise SystemExit(1)
