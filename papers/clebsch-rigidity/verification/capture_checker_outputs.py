#!/usr/bin/env python3
"""Capture canonical stdout identities for the eleven exact Paper I replays."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


CHECKERS = (
    "check_rigidity_degenerate_conic.py",
    "check_decoding.py",
    "check_chirality.py",
    "check_code_automorphisms.py",
    "check_global_conic_gap.py",
    "check_perturbation_gap.py",
    "check_low_degree_loci.py",
    "check_small_q_uniqueness.py",
    "check_q19_nonexample.py",
    "check_small_k_conic_filling.py",
    "verification/c605_verify.py",
)


def capture(paper_root: Path) -> dict[str, object]:
    results: dict[str, object] = {}
    for checker in CHECKERS:
        completed = subprocess.run(
            [sys.executable, checker],
            cwd=paper_root,
            check=False,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        if completed.returncode != 0:
            detail = completed.stderr.decode("utf-8", errors="replace").splitlines()
            raise RuntimeError(
                f"{checker} failed with exit {completed.returncode}: "
                + "\n".join(detail[-10:])
            )
        stdout = completed.stdout
        results[checker] = {
            "bytes": len(stdout),
            "lines": len(stdout.splitlines()),
            "sha256": hashlib.sha256(stdout).hexdigest(),
        }
    return {
        "schema": "clebsch-rigidity-checker-output-v1",
        "checks": results,
    }


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check",
        type=Path,
        help="compare the fresh canonical identities with this tracked JSON file",
    )
    args = parser.parse_args()
    rendered = json.dumps(capture(paper_root), indent=2, sort_keys=True) + "\n"
    if args.check is not None:
        if args.check.read_text(encoding="utf-8") != rendered:
            raise RuntimeError(f"stale checker-output certificate: {args.check}")
    else:
        print(rendered, end="")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, UnicodeError, RuntimeError) as error:
        print(f"checker-output capture failed: {error}", file=sys.stderr)
        raise SystemExit(1)
