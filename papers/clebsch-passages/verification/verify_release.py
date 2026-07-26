#!/usr/bin/env python3
"""Run the aggregate verification gate for the Clebsch orientation paper."""

from __future__ import annotations

import subprocess
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
PAPER = ROOT / "papers" / "clebsch-passages"
PAPERS = ROOT / "papers"

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
