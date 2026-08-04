#!/usr/bin/env python3
"""Validate the optional finitegeom companion pin and its declared boundary.

``FORMAL_COMPANION.json`` is the single declaration of the companion. It names the
repository, the immutable commit, the gate module, the axiom audit and the source
manifest, and states the relationship the paper claims to that artifact.

The commit is a Git object name and therefore content-addressed: it identifies one
tree and cannot be made to denote another. Given ``--lean-root`` pointing at a
checkout of that repository at that commit, this also resolves the gate module,
the axiom audit and every source the manifest lists, and rehashes each one, so the
pin is checked against the artifact rather than merely being well-formed.

The pin was formerly restated in ``flake.nix`` and ``flake.lock`` and cross-checked
against them. It is not any more: one declaration cannot disagree with itself, and
the flake is shared build tooling rather than a place to record a companion.
"""

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
    parser.add_argument(
        "--lean-root",
        type=Path,
        help="checkout of the pinned companion repository, to resolve and rehash it",
    )
    args = parser.parse_args()

    pin = load_pin()
    if args.lean_root is not None:
        check_lean_root(pin, args.lean_root.resolve())
    print("formal companion: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
