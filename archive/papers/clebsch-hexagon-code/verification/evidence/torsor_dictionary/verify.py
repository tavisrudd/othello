#!/usr/bin/env python3
"""Verify the finite and arithmetic certificates used by the torsor dictionary."""

from __future__ import annotations

import hashlib
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent
CHECKS = (
    ("deep-hole-classification.py", "--check"),
    ("common-duality.py", "--check"),
    ("matching-module.py", "--check"),
    ("matching-module-replay.py",),
    ("affine-cocycle.py", "--check"),
    ("affine-cocycle-replay.py",),
    ("orbit-selector.py", "--check"),
    ("arithmetic-orientation.py", "--check"),
    ("arithmetic-orientation-replay.py",),
    ("fixed-child.py", "--check"),
    ("fixed-child-replay.py",),
    ("design-fourier-hinge.py", "--check"),
    ("design-fourier-hinge-replay.py",),
    ("torsor-trichotomy.py", "--check"),
    ("torsor-trichotomy-replay.py",),
    ("characteristic-zero.py", "--check"),
    ("characteristic-zero-replay.py",),
)


def verify_hashes() -> None:
    for line in (ROOT / "manifest.sha256").read_text(encoding="utf-8").splitlines():
        digest, name = line.split("  ", 1)
        actual = hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
        if actual != digest:
            raise SystemExit(f"hash mismatch: {name}")


def main() -> None:
    verify_hashes()
    for command in CHECKS:
        subprocess.run(
            [sys.executable, *command],
            cwd=ROOT,
            check=True,
            timeout=600,
        )
    print("torsor-dictionary evidence verified")


if __name__ == "__main__":
    main()
