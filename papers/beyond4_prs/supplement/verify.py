#!/usr/bin/env python3
"""Verify the paper-local supplement from one entry point."""

from __future__ import annotations

import argparse
import hashlib
import re
import subprocess
import sys
import tempfile
from pathlib import Path


SUPPLEMENT = Path(__file__).resolve().parent
PAPER = SUPPLEMENT.parent


def digest(path: Path) -> tuple[str, int]:
    data = path.read_bytes()
    return hashlib.sha256(data).hexdigest(), len(data)


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


def check_release_manifest() -> None:
    manifest = (SUPPLEMENT / "RELEASE-MANIFEST.md").read_text(encoding="utf-8")

    def field(label: str) -> str:
        match = re.search(
            rf"^\| {re.escape(label)} \| `([^`]+)` \|$",
            manifest,
            flags=re.MULTILINE,
        )
        if match is None:
            raise SystemExit(f"missing release-manifest field: {label}")
        return match.group(1)

    pdf_name = field("PDF artifact")
    pdf = PAPER / pdf_name
    pdf_hash, pdf_bytes = digest(pdf)
    if field("Local built PDF SHA-256") != pdf_hash:
        raise SystemExit("release manifest has stale local PDF SHA-256")
    if int(field("Local built PDF bytes")) != pdf_bytes:
        raise SystemExit("release manifest has stale local PDF byte count")

    for relative in (
        "EVIDENCE-MANIFEST.json",
        "EVIDENCE-ROWS.md",
        "package_evidence_bundle.py",
        "verify.py",
    ):
        match = re.search(
            rf"^\| `{re.escape(relative)}` \| `([0-9a-f]{{64}})` \| ([0-9]+) \|$",
            manifest,
            flags=re.MULTILINE,
        )
        if match is None:
            raise SystemExit(f"missing release-manifest artifact row: {relative}")
        actual_hash, actual_bytes = digest(SUPPLEMENT / relative)
        if match.group(1) != actual_hash or int(match.group(2)) != actual_bytes:
            raise SystemExit(f"stale release-manifest artifact row: {relative}")
    print("verified release-manifest local artifact rows")


def check_public_release_gate() -> None:
    manifest = (SUPPLEMENT / "RELEASE-MANIFEST.md").read_text(encoding="utf-8")
    signoff = (SUPPLEMENT / "FINAL-READER-SIGNOFF.md").read_text(encoding="utf-8")
    main = (PAPER / "main.tex").read_text(encoding="utf-8")

    def field(label: str) -> str:
        match = re.search(
            rf"^\| {re.escape(label)} \| (.+) \|$",
            manifest,
            flags=re.MULTILINE,
        )
        if match is None:
            raise SystemExit(f"missing release-manifest field: {label}")
        return match.group(1).strip().strip("`")

    required_patterns = {
        "Paper-export repository URL": r"https://.+",
        "Release tag": r"\S+",
        "Release commit": r"[0-9a-f]{40}",
        "Public Lean revision": r"[0-9a-f]{40}",
        "Public Q25 certificate revision": r"[0-9a-f]{40}",
        "Archive identifier": r"\S+",
        "DOI": r"10\.\d{4,9}/\S+",
        "Source archive SHA-256": r"[0-9a-f]{64}",
        "Source archive bytes": r"[1-9]\d*",
        "PDF SHA-256": r"[0-9a-f]{64}",
        "PDF bytes": r"[1-9]\d*",
    }
    for label, pattern in required_patterns.items():
        if re.fullmatch(pattern, field(label)) is None:
            raise SystemExit(f"public release gate is unresolved: {label}")

    if field("PDF SHA-256") != field("Local built PDF SHA-256"):
        raise SystemExit("public PDF hash differs from the reviewed local candidate")
    if field("PDF bytes") != field("Local built PDF bytes"):
        raise SystemExit("public PDF byte count differs from the reviewed local candidate")
    if "pending" in signoff.lower() or signoff.lower().count("verdict: green.") != 2:
        raise SystemExit("independent final-reader signoff is incomplete")
    if "Unrefereed preprint" not in main:
        raise SystemExit("the manuscript is not visibly labelled as an unrefereed preprint")
    print("verified public release metadata and final-reader gate")


def check_bundle() -> None:
    run([sys.executable, "supplement/package_evidence_bundle.py", "--check"])
    run([sys.executable, "supplement/build_classification_records.py", "--check"])
    check_classification_hashes()
    check_release_manifest()


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
    parser.add_argument(
        "--release",
        action="store_true",
        help="require immutable public metadata and two independent reader signoffs",
    )
    args = parser.parse_args()
    check_bundle()
    if args.replay:
        replay()
    if args.release:
        check_public_release_gate()


if __name__ == "__main__":
    main()
