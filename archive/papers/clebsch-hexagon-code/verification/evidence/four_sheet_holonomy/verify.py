#!/usr/bin/env python3
"""Verify the four-sheet cover-holonomy evidence bundle."""

from __future__ import annotations

import hashlib
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CHECKS = (
    "contraction_rank_drop.py",
    "cover_holonomy.py",
)


def verify_hashes() -> None:
    for line in (ROOT / "manifest.sha256").read_text(encoding="utf-8").splitlines():
        digest, name = line.split("  ", 1)
        actual = hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        if actual != digest:
            raise SystemExit(f"hash mismatch: {name}")


def main() -> None:
    verify_hashes()
    for script in CHECKS:
        subprocess.run(
            [sys.executable, script, "--check"],
            cwd=ROOT,
            check=True,
            timeout=300,
        )
    print("four-sheet cover-holonomy evidence verified")


if __name__ == "__main__":
    main()
