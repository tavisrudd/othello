#!/usr/bin/env python3
"""Verify the finite theta, Fourier, code-transport, and fixed-party certificates."""

from __future__ import annotations

import hashlib
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CHECKS = (
    ("quantum-state-equivalence.py", "--check"),
    ("quantum-family-classification.py", "--check"),
    ("theta-matching.py", "--check"),
    ("fourier-weil.py", "--check"),
    ("quantum-chirality.py", "--check"),
    ("fixed-party-equivalence.py", "--check"),
)


def verify_hashes() -> None:
    for line in (ROOT / "manifest.sha256").read_text(encoding="utf-8").splitlines():
        digest, name = line.split("  ", 1)
        actual = hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        if actual != digest:
            raise SystemExit(f"hash mismatch: {name}")


def main() -> None:
    verify_hashes()
    for script, mode in CHECKS:
        subprocess.run(
            [sys.executable, script, mode],
            cwd=ROOT,
            check=True,
            timeout=300,
        )
    print("passage-interface evidence verified")


if __name__ == "__main__":
    main()
