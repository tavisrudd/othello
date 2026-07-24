#!/usr/bin/env python3
"""Verify the paper-local supplement from one entry point."""

from __future__ import annotations

import argparse
import hashlib
import subprocess
import sys
import tempfile
from pathlib import Path


SUPPLEMENT = Path(__file__).resolve().parent
PAPER = SUPPLEMENT.parent


def run(command: list[str], cwd: Path = PAPER) -> None:
    print(f"+ {' '.join(command)}", flush=True)
    subprocess.run(command, cwd=cwd, check=True)


def check_classification_hashes() -> None:
    checksum_file = SUPPLEMENT / "CLASSIFICATION-RECORDS.sha256"
    for line in checksum_file.read_text(encoding="utf-8").splitlines():
        expected, relative = line.split(maxsplit=1)
        path = SUPPLEMENT / relative
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        if actual != expected:
            raise SystemExit(f"SHA-256 mismatch: {path}")
    print("verified classification-record hashes")


def check_bundle() -> None:
    run([sys.executable, "supplement/package_evidence_bundle.py", "--check"])
    run([sys.executable, "supplement/build_classification_records.py", "--check"])
    check_classification_hashes()


def replay() -> None:
    python_jobs = (
        (
            "r5",
            [
                "2026-07-22-c491-prs-deep-hole-replay.py",
                "--json",
                "2026-07-22-c491-prs-deep-hole-census.json",
            ],
        ),
        (
            "r6",
            [
                "2026-07-22-c498-prs-deep-hole-replay.py",
                "--json",
                "2026-07-22-c498-prs-deep-hole-census.json",
            ],
        ),
        (
            "r6-normal-forms",
            ["2026-07-23-c498-small-exceptional-normal-forms.py", "--summary"],
        ),
        ("r7", ["2026-07-23-c509-prs-deep-hole-calibration-replay.py"]),
        ("r8", ["2026-07-23-c513-prs-redundancy-eight-replay.py"]),
        ("r9", ["2026-07-23-c516-prs-redundancy-nine-replay.py"]),
        ("hessian", ["2026-07-23-c525-ordered-hessian-arf-pullback-replay.py"]),
        (
            "lucas",
            ["2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic-replay.py"],
        ),
        ("e7", ["2026-07-23-c530-degree-nine-lucas-e7-quotient-cover-replay.py"]),
    )
    for directory, arguments in python_jobs:
        run(
            [sys.executable, *arguments],
            SUPPLEMENT / "evidence" / directory,
        )

    source = (
        SUPPLEMENT
        / "evidence/r9-q49/2026-07-23-c516-prs-redundancy-nine-q49.rs"
    )
    expected = (
        SUPPLEMENT
        / "evidence/r9-q49/2026-07-23-c516-prs-redundancy-nine-q49.txt"
    )
    with tempfile.TemporaryDirectory(prefix="prs-r9-q49-") as temporary:
        executable = Path(temporary) / "r9-q49"
        output = Path(temporary) / "r9-q49.txt"
        run(["rustc", "-O", str(source), "-o", str(executable)])
        with output.open("wb") as stream:
            subprocess.run([str(executable)], check=True, stdout=stream)
        if output.read_bytes() != expected.read_bytes():
            raise SystemExit("Certificate R9-49 replay differs from expected output")
    print("verified Certificate R9-49 replay")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--replay",
        action="store_true",
        help="also run every paper-local replay, including the R9-49 Rust replay",
    )
    args = parser.parse_args()
    check_bundle()
    if args.replay:
        replay()


if __name__ == "__main__":
    main()
