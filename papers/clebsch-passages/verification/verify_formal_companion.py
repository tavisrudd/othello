#!/usr/bin/env python3
"""Validate the optional finitegeom companion pin and its declared boundary."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


PAPER = Path(__file__).resolve().parents[1]
PIN_PATH = PAPER / "FORMAL_COMPANION.json"
EXPECTED_KEYS = {
    "axiom_audit",
    "commit",
    "concept_doi",
    "gate",
    "manifest",
    "relationship",
    "repository",
    "schema",
}


def fail(message: str) -> None:
    raise SystemExit(f"formal companion: FAIL [{message}]")


def load_pin() -> dict[str, str]:
    pin = json.loads(PIN_PATH.read_text(encoding="utf-8"))
    if set(pin) != EXPECTED_KEYS:
        fail("metadata fields")
    if pin["schema"] != "clebsch-passages-formal-companion-v1":
        fail("schema")
    if not re.fullmatch(r"[0-9a-f]{40}", pin["commit"]):
        fail("commit")
    if pin["repository"] != "https://github.com/tavisrudd/finitegeom":
        fail("repository")
    if pin["concept_doi"] != "10.5281/zenodo.21650878":
        fail("concept DOI")
    if pin["relationship"] != (
        "optional formal companion; no manuscript claim depends on Lean"
    ):
        fail("relationship")
    return pin


def check_flake(pin: dict[str, str]) -> None:
    source = (PAPER / "flake.nix").read_text(encoding="utf-8")
    revision = f"github:tavisrudd/finitegeom?rev={pin['commit']}"
    if source.count(revision) != 1:
        fail("flake revision")


def check_lock(pin: dict[str, str]) -> None:
    lock_path = PAPER / "flake.lock"
    if not lock_path.is_file():
        fail("missing flake.lock")
    lock = json.loads(lock_path.read_text(encoding="utf-8"))
    try:
        node_name = lock["nodes"]["root"]["inputs"]["finitegeom"]
        locked = lock["nodes"][node_name]["locked"]
    except (KeyError, TypeError):
        fail("flake lock structure")
    if locked.get("type") != "github":
        fail("flake lock source type")
    if locked.get("owner") != "tavisrudd" or locked.get("repo") != "finitegeom":
        fail("flake lock repository")
    if locked.get("rev") != pin["commit"]:
        fail("flake lock revision")


def check_lean_root(pin: dict[str, str], lean_root: Path) -> None:
    manifest_path = lean_root / pin["manifest"]
    audit_path = lean_root / pin["axiom_audit"]
    gate_path = lean_root / (pin["gate"].replace(".", "/") + ".lean")
    for path in (manifest_path, audit_path, gate_path):
        if not path.is_file():
            fail(f"missing {path.relative_to(lean_root)}")

    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    if manifest.get("roots") != [pin["gate"]]:
        fail("manifest root")
    if manifest.get("module_count") != len(manifest.get("sources", [])):
        fail("manifest count")
    for row in manifest["sources"]:
        path = lean_root / row["path"]
        if not path.is_file():
            fail(f"missing manifest source {row['path']}")
        payload = path.read_bytes()
        if len(payload) != row["bytes"]:
            fail(f"size {row['path']}")
        if hashlib.sha256(payload).hexdigest() != row["sha256"]:
            fail(f"hash {row['path']}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lean-root", type=Path)
    args = parser.parse_args()

    pin = load_pin()
    check_flake(pin)
    check_lock(pin)
    if args.lean_root is not None:
        check_lean_root(pin, args.lean_root.resolve())
    print("formal companion: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
