#!/usr/bin/env python3
"""Run the paper-local aggregate verification gate."""

from __future__ import annotations

import argparse
import subprocess
import json
import re
from pathlib import Path


PAPER = Path(__file__).resolve().parents[1]

def run(name: str, command: list[str], cwd: Path = PAPER) -> None:
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
        raise SystemExit(f"clebsch-passages release: FAIL [{name}]\n{tail}")
    print(f"clebsch-passages release: PASS [{name}]")


def check_release_files() -> None:
    allowlist_path = PAPER / "release_files.json"
    allowlist = json.loads(allowlist_path.read_text(encoding="utf-8"))
    files = allowlist.get("files", [])
    if not files or len(files) != len(set(files)):
        raise SystemExit("clebsch-passages release: FAIL [invalid release allowlist]")
    forbidden_parts = {"notes", "lean", "WORKPLAN.md"}
    for relative in files:
        path = Path(relative)
        if path.is_absolute() or ".." in path.parts:
            raise SystemExit(
                f"clebsch-passages release: FAIL [unsafe allowlist path {relative}]"
            )
        if forbidden_parts.intersection(path.parts):
            raise SystemExit(
                f"clebsch-passages release: FAIL [forbidden allowlist path {relative}]"
            )
        if not (PAPER / path).is_file():
            raise SystemExit(
                f"clebsch-passages release: FAIL [missing allowlist file {relative}]"
            )
    print(f"clebsch-passages release: PASS [release allowlist: {len(files)} files]")


def check_public_vocabulary() -> None:
    patterns = {
        "numbered workflow identifier": re.compile(r"\bC" + r"[0-9]{3,}\b"),
        "superseded paper name": re.compile("Paper" + r"\s+III", re.IGNORECASE),
        "parent-notes reference": re.compile(r"\.\./" + "notes" + "/"),
        "repository-notes reference": re.compile(
            r"(^|[^A-Za-z])" + "notes" + "/", re.MULTILINE
        ),
    }
    allowlist = json.loads(
        (PAPER / "release_files.json").read_text(encoding="utf-8")
    )["files"]
    text_suffixes = {".md", ".tex", ".json", ".py", ".sha256"}
    for relative in allowlist:
        path = PAPER / relative
        if path.suffix not in text_suffixes and path.name != "Makefile":
            continue
        source = path.read_text(encoding="utf-8")
        for name, pattern in patterns.items():
            if pattern.search(source):
                raise SystemExit(
                    f"clebsch-passages release: FAIL [{name} in {relative}]"
                )
    print("clebsch-passages release: PASS [public vocabulary]")


def check_lean_gates(lean_root: Path | None) -> None:
    """Replay the three import-only Lean gates against their pinned sources.

    Without a Lean tree the pinned closures cannot be hashed, so the gates are
    reported as unchecked by name rather than silently passed over: a release
    run that cannot reach the Lean sources has verified strictly less than one
    that can.
    """
    verifiers = (
        ("passages", "verify_passages_lean.py"),
        ("golden return", "verify_golden_return_lean.py"),
        ("four shadow", "verify_four_shadow_lean.py"),
    )
    if lean_root is None:
        names = ", ".join(name for name, _ in verifiers)
        print(
            "clebsch-passages release: UNCHECKED [Lean gates: "
            f"{names}] pass --lean-root to replay them"
        )
        return False
    for name, script in verifiers:
        run(
            f"{name} Lean gate",
            [
                "python3",
                f"verification/{script}",
                "--lean-root",
                str(lean_root),
                "--source-only",
            ],
            PAPER,
        )
    return True


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--lean-root",
        type=Path,
        help="Lean tree holding the pinned gate closures",
    )
    args = parser.parse_args()
    check_release_files()
    check_public_vocabulary()
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
    # FORMAL_COMPANION.json is the single declaration of the optional formal companion.
    # This checks it is well formed and internally consistent.  It runs without
    # --lean-root because the deeper check resolves the pinned companion repository,
    # which is a different repository from the Lean root this verifier is given.
    run(
        "formal companion pin",
        ["python3", "verification/verify_formal_companion.py"],
        PAPER,
    )

    for stem, label in (
        ("arithmetic_cover", "arithmetic cover"),
        ("orientation_source", "orientation source"),
        ("harmonic_clebsch", "harmonic bridge"),
    ):
        evidence = PAPER / "verification" / "evidence"
        run(
            f"{label} hashes",
            [
                "sha256sum",
                "-c",
                f"verification/evidence/{stem}.sha256",
            ],
            PAPER,
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
            raise SystemExit("clebsch-passages release: FAIL [missing evidence directory]")

    lean_checked = check_lean_gates(
        args.lean_root.resolve() if args.lean_root else None
    )

    run(
        "spacing lint",
        ["python3", "../scripts/lint_tex_spacing.py", "clebsch_passages.tex", "sections"],
        PAPER,
    )
    # Deterministic rebuild in a scratch directory, compared byte for byte against the
    # tracked PDF.  This replaces an in-place `make` that rebuilt the tracked PDF and so
    # could never detect a manuscript edit committed without refreshing it.
    run(
        "manuscript build",
        ["python3", "verification/check_manuscript_build.py"],
        PAPER,
    )
    if lean_checked:
        print("clebsch-passages release: ALL CHECKS PASS")
    else:
        print(
            "clebsch-passages release: ALL CHECKS PASS EXCEPT THE LEAN GATES "
            "(rerun with --lean-root for a complete release check)"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
