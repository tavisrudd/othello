#!/usr/bin/env python3
"""Second-prime replay for the C682 all-weight corner frontier."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIMARY = HERE / "2026-07-29-c682-all-weight-corner-search.py"
PRIME = 1_000_000_009


def main() -> None:
    completed = subprocess.run(
        [
            sys.executable,
            str(PRIMARY),
            "--replay",
            "--workers",
            "4",
            "--prime",
            str(PRIME),
        ],
        check=True,
        capture_output=True,
        text=True,
    )
    assert completed.stdout.strip() == (
        "PASS: C682 all-weight corner frontier replay"
    )
    assert completed.stderr == ""
    print("PASS: second-prime all-weight corner frontier")


if __name__ == "__main__":
    main()
