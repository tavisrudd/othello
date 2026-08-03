#!/usr/bin/env python3
"""Replay the structural Lean gate for the current Clebsch paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
MANIFEST = HERE / "passages_formal.json"
AXIOM_REPORT = HERE / "passages_axioms.txt"
CLOSURE_INVENTORY = HERE / "passages_source_closure.json"


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
        body = match.group(3)
        if declaration in result:
            raise SystemExit(
                "passages formal replay: FAIL "
                f"[duplicate axiom output for {declaration}]"
            )
        result[declaration] = (
            []
            if body is None
            else [part.strip() for part in body.replace("\n", " ").split(",")]
        )
    return result


def check_sources(lean_root: Path, manifest: dict[str, object]) -> None:
    toolchain = (lean_root / "lean-toolchain").read_text(encoding="utf-8").strip()
    if toolchain != manifest["lean_toolchain"]:
        raise SystemExit(f"passages formal replay: FAIL [toolchain {toolchain!r}]")
    if sha256(AXIOM_REPORT) != manifest["axiom_report_sha256"]:
        raise SystemExit("passages formal replay: FAIL [axiom report hash]")
    if sha256(Path(__file__).resolve()) != manifest["verifier_sha256"]:
        raise SystemExit("passages formal replay: FAIL [verifier hash]")
    if sha256(CLOSURE_INVENTORY) != manifest["source_closure_sha256"]:
        raise SystemExit("passages formal replay: FAIL [source closure hash]")

    inventory = json.loads(CLOSURE_INVENTORY.read_text(encoding="utf-8"))
    if inventory.get("roots") != [manifest["gate_module"]]:
        raise SystemExit("passages formal replay: FAIL [source closure root]")
    observed_sources = {
        item["path"]: item["sha256"] for item in inventory.get("sources", [])
    }
    if observed_sources != manifest["source_sha256"]:
        raise SystemExit("passages formal replay: FAIL [source closure inventory]")

    forbidden = re.compile(r"^\s*(?:axiom|unsafe\s+(?:def|theorem))\b", re.MULTILINE)
    workflow_id = re.compile(r"\bC[0-9]{3,}\b")
    workflow_prose = re.compile(
        r"\b(?:TODO|FIXME|pending|temporary|fallback|agent|lane)\b",
        re.IGNORECASE,
    )
    for relative, expected in manifest["source_sha256"].items():
        source = lean_root / relative
        if not source.is_file():
            raise SystemExit(f"passages formal replay: FAIL [missing {relative}]")
        if sha256(source) != expected:
            raise SystemExit(f"passages formal replay: FAIL [hash {relative}]")
        text = source.read_text(encoding="utf-8")
        if (
            "sorry" in text
            or forbidden.search(text)
            or workflow_id.search(text)
            or workflow_prose.search(text)
        ):
            raise SystemExit(f"passages formal replay: FAIL [source policy {relative}]")
    print("passages formal replay: PASS [pinned sources and toolchain]")


def check_axiom_log(manifest: dict[str, object], axiom_log: Path) -> None:
    expected = parse_axioms(AXIOM_REPORT.read_text(encoding="utf-8"))
    observed = parse_axioms(axiom_log.read_text(encoding="utf-8"))
    declarations = set(manifest["audited_declarations"])
    if set(expected) != declarations:
        raise SystemExit(
            "passages formal replay: FAIL [manifest/report declaration mismatch]"
        )
    if observed != expected:
        raise SystemExit("passages formal replay: FAIL [axiom report mismatch]")
    print("passages formal replay: PASS [pinned sources and supplied axiom audit]")


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
        help="stdout from a guarded elaboration of the import-only gate",
    )
    args = parser.parse_args()
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    lean_root = args.lean_root.resolve()
    check_sources(lean_root, manifest)
    if args.axiom_log is not None:
        check_axiom_log(manifest, args.axiom_log.resolve())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
