#!/usr/bin/env python3
"""Verify the pinned Lean sources and axiom audit for cubic-shadow recognition."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
MANIFEST = HERE / "four_shadow_formal.json"
AXIOM_REPORT = HERE / "four_shadow_axioms.txt"
CLOSURE_INVENTORY = HERE / "four_shadow_source_closure.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_axioms(text: str) -> dict[str, list[str]]:
    pattern = re.compile(
        r"'([^']+)' (does not depend on any axioms|depends on axioms: \[(.*?)\])",
        re.DOTALL,
    )
    result: dict[str, list[str]] = {}
    for match in pattern.finditer(text):
        declaration = match.group(1)
        if declaration in result:
            raise SystemExit(
                "four-shadow formal replay: FAIL "
                f"[duplicate axiom output for {declaration}]"
            )
        body = match.group(3)
        result[declaration] = (
            []
            if body is None
            else [part.strip() for part in body.replace("\n", " ").split(",")]
        )
    return result


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lean-root", type=Path, required=True)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument(
        "--source-only",
        action="store_true",
        help="check the pinned transitive source closure without a live gate",
    )
    mode.add_argument(
        "--axiom-log",
        type=Path,
        help="stdout from elaborating the focused import-only gate",
    )
    args = parser.parse_args()

    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    lean_root = args.lean_root.resolve()
    toolchain = (lean_root / "lean-toolchain").read_text(encoding="utf-8").strip()
    if toolchain != manifest["lean_toolchain"]:
        raise SystemExit(f"four-shadow formal replay: FAIL [toolchain {toolchain!r}]")
    if sha256(AXIOM_REPORT) != manifest["axiom_report_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [axiom report hash]")
    if sha256(Path(__file__).resolve()) != manifest["verifier_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [verifier hash]")
    if sha256(CLOSURE_INVENTORY) != manifest["source_closure_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [source closure hash]")

    inventory = json.loads(CLOSURE_INVENTORY.read_text(encoding="utf-8"))
    if inventory.get("roots") != [manifest["gate_module"]]:
        raise SystemExit("four-shadow formal replay: FAIL [source closure root]")
    observed_sources = {
        item["path"]: item["sha256"] for item in inventory.get("sources", [])
    }
    if observed_sources != manifest["source_sha256"]:
        raise SystemExit("four-shadow formal replay: FAIL [source closure inventory]")

    forbidden = re.compile(r"^\s*(?:axiom|unsafe\s+(?:def|theorem))\b", re.MULTILINE)
    # Mechanisms that would move a proof outside the kernel without introducing
    # an axiom the gate's `#print axioms` lines would show.  This gate
    # claims no compiled evaluation at all, so `native_decide` is refused outright
    # alongside the other escapes.
    mechanisms = re.compile(
        r"\bnative_decide\b"
        r"|@\[[^\]]*(?:implemented_by|extern)"
        r"|\bofReduceBool\b"
        r"|^\s*(?:opaque|partial)\b",
        re.MULTILINE,
    )
    workflow_id = re.compile(r"\bC[0-9]{3,}\b")
    workflow_prose = re.compile(
        r"\b(?:TODO|FIXME|pending|temporary|fallback|agent|lane)\b",
        re.IGNORECASE,
    )
    for relative, expected in manifest["source_sha256"].items():
        source = lean_root / relative
        if not source.is_file():
            raise SystemExit(f"four-shadow formal replay: FAIL [missing {relative}]")
        if sha256(source) != expected:
            raise SystemExit(f"four-shadow formal replay: FAIL [hash {relative}]")
        text = source.read_text(encoding="utf-8")
        if (
            "sorry" in text
            or forbidden.search(text)
            or mechanisms.search(text)
            or workflow_id.search(text)
            or workflow_prose.search(text)
        ):
            raise SystemExit(f"four-shadow formal replay: FAIL [source policy {relative}]")

    expected = parse_axioms(AXIOM_REPORT.read_text(encoding="utf-8"))
    declarations = set(manifest["audited_declarations"])
    if set(expected) != declarations:
        raise SystemExit(
            "four-shadow formal replay: FAIL [manifest/report declaration mismatch]"
        )
    if args.axiom_log is not None:
        observed = parse_axioms(args.axiom_log.read_text(encoding="utf-8"))
        if observed != expected:
            raise SystemExit("four-shadow formal replay: FAIL [axiom report mismatch]")
        print("four-shadow formal replay: PASS [pinned sources and axiom audit]")
    else:
        print("four-shadow formal replay: PASS [pinned sources and toolchain]")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
