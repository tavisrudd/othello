#!/usr/bin/env python3
"""Shared validator for a paper's formal-companion pin.

``FORMAL_COMPANION.json`` is the single place a paper names an external formal
artifact. One schema serves every paper: a list of pinned artifacts, each with a
role, the repository it lives in, the immutable commit, and the gate, manifest
and axiom audit that commit is expected to carry. A paper that pins one artifact
lists one; a paper whose certificate package sits on a base library lists both
and links them with ``depends_on``.

A commit is a Git object name and therefore content-addressed: it identifies one
tree and cannot be made to denote another. Well-formedness is checked always.
Given a checkout of a pinned repository at its pinned commit, ``--resolve``
additionally resolves that artifact's gate, axiom audit and manifest, and
rehashes every source the manifest lists, so the pin is checked against the
artifact rather than only against itself.

The pin is also the *only* place a commit may be named. ``--no-loose-commits``
scans the paper's own files and rejects any Git object name that appears beside
the word ``finitegeom`` without matching a pinned commit. Prose that restates a
commit is how two declarations of one fact drift apart, so restating one is a
failure rather than a duplication.

This module is copied into each paper's ``verification`` directory by the paper
exporter, so every paper validates its pin the same way and a standalone mirror
carries the check with it.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path


SCHEMA = "formal-companion-v2"
COMMIT_RE = re.compile(r"\b[0-9a-f]{40}\b")
DOI_RE = re.compile(r"^10\.\d{4,9}/[-._;()/:a-zA-Z0-9]+$")
ARTIFACT_KEYS = {"role", "repository", "commit", "gate", "manifest"}
OPTIONAL_KEYS = {"axiom_audit", "depends_on", "coverage"}
# Text the guard reads. Binary artifacts and generated evidence are excluded:
# a commit named there is data under some other check, not a claim in prose.
GUARD_SUFFIXES = {".md", ".tex", ".json", ".txt", ".nix", ".toml"}
GUARD_SKIP_PARTS = {"evidence", "__pycache__", ".git", "lean-certificates"}


class CompanionError(SystemExit):
    def __init__(self, message: str) -> None:
        super().__init__(f"formal companion: FAIL [{message}]")


def load(paper: Path) -> dict:
    """Read and structurally validate the pin."""
    pin = json.loads((paper / "FORMAL_COMPANION.json").read_text(encoding="utf-8"))
    if pin.get("schema") != SCHEMA:
        raise CompanionError(f"schema, expected {SCHEMA}")
    doi = pin.get("concept_doi")
    if not isinstance(doi, str) or not DOI_RE.match(doi):
        raise CompanionError("concept DOI")
    if not isinstance(pin.get("relationship"), str) or not pin["relationship"].strip():
        raise CompanionError("relationship")
    artifacts = pin.get("artifacts")
    if not isinstance(artifacts, list) or not artifacts:
        raise CompanionError("artifacts")

    roles: set[str] = set()
    for entry in artifacts:
        missing = ARTIFACT_KEYS - set(entry)
        if missing:
            raise CompanionError(f"artifact fields {sorted(missing)}")
        unknown = set(entry) - ARTIFACT_KEYS - OPTIONAL_KEYS
        if unknown:
            raise CompanionError(f"unknown artifact fields {sorted(unknown)}")
        if entry["role"] in roles:
            raise CompanionError(f"duplicate role {entry['role']}")
        roles.add(entry["role"])
        if not re.fullmatch(r"[0-9a-f]{40}", entry["commit"]):
            raise CompanionError(f"commit for role {entry['role']}")
        if not entry["repository"].startswith("https://"):
            raise CompanionError(f"repository for role {entry['role']}")
    for entry in artifacts:
        depends = entry.get("depends_on")
        if depends is not None and depends not in roles:
            raise CompanionError(f"depends_on {depends} names no role")
    return pin


def pinned_commits(pin: dict) -> set[str]:
    return {entry["commit"] for entry in pin["artifacts"]}


def _git_commit_available(checkout: Path, commit: str) -> bool:
    result = subprocess.run(
        ["git", "-C", str(checkout), "rev-parse", "--verify", "--quiet", f"{commit}^{{commit}}"],
        capture_output=True,
        text=True,
        check=False,
    )
    return result.returncode == 0


def _read_at(checkout: Path, commit: str | None, relative: str) -> bytes | None:
    """Read one path, from the pinned commit when the checkout is a repository.

    Reading the working tree would compare the pinned manifest against whatever the
    checkout happens to be checked out at, which is a different question and passes
    or fails for the wrong reason.
    """
    if commit is None:
        path = checkout / relative
        return path.read_bytes() if path.is_file() else None
    result = subprocess.run(
        ["git", "-C", str(checkout), "show", f"{commit}:{relative}"],
        capture_output=True,
        check=False,
    )
    return result.stdout if result.returncode == 0 else None


def resolve(pin: dict, role: str, checkout: Path) -> None:
    """Check one pinned artifact against the tree its commit names.

    When the checkout is a repository containing the pinned commit, every file is
    read at that commit, so the check does not depend on the checkout's current
    state. An extracted tree without history is read directly.
    """
    entries = [e for e in pin["artifacts"] if e["role"] == role]
    if not entries:
        raise CompanionError(f"no artifact with role {role}")
    entry = entries[0]
    commit = entry["commit"] if _git_commit_available(checkout, entry["commit"]) else None

    required = {
        entry["manifest"]: "manifest",
        entry["gate"].replace(".", "/") + ".lean": "gate",
    }
    if "axiom_audit" in entry:
        required[entry["axiom_audit"]] = "axiom audit"
    payloads = {}
    for relative, label in required.items():
        payload = _read_at(checkout, commit, relative)
        if payload is None:
            raise CompanionError(f"{role}: missing {label} {relative}")
        payloads[relative] = payload

    manifest = json.loads(payloads[entry["manifest"]].decode("utf-8"))
    if manifest.get("roots") != [entry["gate"]]:
        raise CompanionError(f"{role}: manifest root")
    sources = manifest.get("sources", [])
    if manifest.get("module_count") != len(sources):
        raise CompanionError(f"{role}: manifest count")
    for row in sources:
        payload = _read_at(checkout, commit, row["path"])
        if payload is None:
            raise CompanionError(f"{role}: missing manifest source {row['path']}")
        if len(payload) != row["bytes"] or hashlib.sha256(payload).hexdigest() != row["sha256"]:
            raise CompanionError(f"{role}: source {row['path']} does not match the manifest")


def repository_names(pin: dict) -> set[str]:
    """Bare names of the repositories this pin points at."""
    return {entry["repository"].rstrip("/").rsplit("/", 1)[-1] for entry in pin["artifacts"]}


def check_current(pin: dict, role: str, checkout: Path) -> None:
    """Require the pinned commit to be the newest one that changed this companion.

    A companion is re-exported when the paper's formal surface grows. Nothing else
    then advances the paper's pin, so the pin silently comes to name an older export
    while the paper describes a newer one. Comparing the pin against the tip of the
    companion manifest's own history is what makes that visible.
    """
    entry = next((e for e in pin["artifacts"] if e["role"] == role), None)
    if entry is None:
        raise CompanionError(f"no artifact with role {role}")
    result = subprocess.run(
        ["git", "-C", str(checkout), "log", "-1", "--format=%H", "--", entry["manifest"]],
        capture_output=True,
        text=True,
        check=False,
    )
    if result.returncode != 0:
        raise CompanionError(f"{role}: cannot read the companion history")
    tip = result.stdout.strip()
    if not tip:
        raise CompanionError(f"{role}: {entry['manifest']} has no history")
    if tip != entry["commit"]:
        raise CompanionError(
            f"{role}: pin names {entry['commit'][:8]} but the companion was last "
            f"exported at {tip[:8]}; advance the pin or explain the difference"
        )


def check_no_loose_commits(paper: Path, pin: dict) -> None:
    """Reject a Git object name stated beside a pinned repository outside the pin.

    The repositories come from the pin, so a companion hosted anywhere is guarded
    and no project name is baked in.
    """
    allowed = pinned_commits(pin)
    names = repository_names(pin)
    offenders: list[str] = []
    for path in sorted(paper.rglob("*")):
        if not path.is_file() or path.suffix not in GUARD_SUFFIXES:
            continue
        if GUARD_SKIP_PARTS.intersection(path.relative_to(paper).parts):
            continue
        if path.name == "FORMAL_COMPANION.json":
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except (OSError, UnicodeDecodeError):
            continue
        if not any(name in text for name in names):
            continue
        for found in COMMIT_RE.findall(text):
            if found not in allowed:
                offenders.append(f"{path.relative_to(paper)}:{found[:8]}")
    if offenders:
        raise CompanionError(
            "commit named outside the pin: " + ", ".join(sorted(set(offenders))[:8])
        )


def main(paper: Path) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--resolve",
        action="append",
        default=[],
        metavar="ROLE=CHECKOUT",
        help="check one pinned artifact against a checkout of its repository",
    )
    parser.add_argument(
        "--require-current",
        action="append",
        default=[],
        metavar="ROLE=CHECKOUT",
        help="require the pin to be the newest export of that companion",
    )
    parser.add_argument(
        "--no-loose-commits",
        action="store_true",
        help="reject a commit named beside `finitegeom` anywhere but the pin",
    )
    args = parser.parse_args()

    pin = load(paper)
    for pair in args.resolve:
        role, _, location = pair.partition("=")
        if not location:
            raise CompanionError(f"--resolve expects ROLE=CHECKOUT, got {pair}")
        resolve(pin, role, Path(location).expanduser().resolve())
    for pair in args.require_current:
        role, _, location = pair.partition("=")
        if not location:
            raise CompanionError(f"--require-current expects ROLE=CHECKOUT, got {pair}")
        check_current(pin, role, Path(location).expanduser().resolve())
    if args.no_loose_commits:
        check_no_loose_commits(paper, pin)

    roles = ", ".join(entry["role"] for entry in pin["artifacts"])
    print(f"formal companion: PASS [{len(pin['artifacts'])} pinned: {roles}]")
    return 0
