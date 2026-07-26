#!/usr/bin/env python3
"""Run the aggregate verification gate for the Clebsch orientation paper."""

from __future__ import annotations

import hashlib
import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
PAPER = ROOT / "papers" / "clebsch-passages"
PAPERS = ROOT / "papers"

C651_HASHES = {
    "notes/2026-07-26-c651-hitchin-tensor-bridge.py":
        "dfb2993b072bfd4eceab77aaad8cfe760771b654d8e4c0d05c065ef9f386e041",
    "notes/2026-07-26-c651-hitchin-tensor-bridge-replay.py":
        "0ee0d31d189cb69872b8996329fc289c829724de090fe1846073ea0a402311fb",
    "notes/2026-07-26-c651-hitchin-tensor-bridge.json":
        "9f93ccdc80c757eb78078e479c8107c0108980fb8b4daca5d1ba389072aa17e9",
}


def run(name: str, command: list[str], cwd: Path = ROOT) -> None:
    completed = subprocess.run(
        command,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if completed.returncode:
        tail = "\n".join(completed.stdout.splitlines()[-12:])
        raise SystemExit(f"Paper III release: FAIL [{name}]\n{tail}")
    print(f"Paper III release: PASS [{name}]")


def check_c651_hashes() -> None:
    for relative, expected in C651_HASHES.items():
        actual = hashlib.sha256((ROOT / relative).read_bytes()).hexdigest()
        if actual != expected:
            raise SystemExit(
                f"Paper III release: FAIL [C651 hashes] {relative}: {actual}"
            )
    print(f"Paper III release: PASS [C651 hashes: {len(C651_HASHES)} files]")


def check_latex_log() -> None:
    log = (PAPER / "clebsch_passages.log").read_text(
        encoding="utf-8", errors="replace"
    )
    forbidden = (
        "LaTeX Warning:",
        "Package rerunfilecheck Warning:",
        "Overfull \\hbox",
        "Underfull \\hbox",
        "undefined references",
        "undefined citations",
    )
    found = [marker for marker in forbidden if marker in log]
    if found:
        raise SystemExit(f"Paper III release: FAIL [LaTeX warnings] {found}")
    if "Output written on clebsch_passages.xdv" not in log:
        raise SystemExit("Paper III release: FAIL [LaTeX output missing]")
    print("Paper III release: PASS [warning-free manuscript build]")


def main() -> int:
    run(
        "statement identity",
        ["python3", "verification/extract_statement_identity.py", "--check"],
        PAPER,
    )
    run(
        "trust manifest",
        ["python3", "verification/verify_scaffold.py"],
        PAPER,
    )

    check_c651_hashes()
    run(
        "finite tensor primary",
        ["python3", "notes/2026-07-26-c651-hitchin-tensor-bridge.py", "--check"],
    )
    run(
        "finite tensor independent replay",
        ["python3", "notes/2026-07-26-c651-hitchin-tensor-bridge-replay.py"],
    )
    for stem, label in (
        ("arithmetic_cover", "arithmetic cover"),
        ("harmonic_clebsch", "harmonic bridge"),
    ):
        evidence = PAPER / "verification" / "evidence"
        run(
            f"{label} hashes",
            [
                "sha256sum",
                "-c",
                f"papers/clebsch-passages/verification/evidence/{stem}.sha256",
            ],
            ROOT,
        )
        run(
            f"{label} primary",
            ["python3", f"verification/evidence/{stem}.py", "--check"],
            PAPER,
        )
        run(
            f"{label} independent replay",
            ["python3", f"verification/evidence/{stem}_replay.py"],
            PAPER,
        )
        if not evidence.is_dir():
            raise SystemExit("Paper III release: FAIL [missing evidence directory]")

    run("manuscript build", ["make", "-B", "clebsch-passages"], PAPERS)
    check_latex_log()
    print("Paper III release: ALL CHECKS PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
