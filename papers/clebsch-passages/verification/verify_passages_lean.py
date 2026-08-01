#!/usr/bin/env python3
"""Replay the structural Lean gate for the current Clebsch paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
MANIFEST = HERE / "passages_formal.json"
AXIOM_REPORT = HERE / "passages_axioms.txt"


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

    forbidden = re.compile(r"^\s*(?:axiom|unsafe\s+(?:def|theorem))\b", re.MULTILINE)
    workflow_id = re.compile(r"\bC[0-9]{3,}\b")
    for relative, expected in manifest["source_sha256"].items():
        source = lean_root / relative
        if not source.is_file():
            raise SystemExit(f"passages formal replay: FAIL [missing {relative}]")
        if sha256(source) != expected:
            raise SystemExit(f"passages formal replay: FAIL [hash {relative}]")
        text = source.read_text(encoding="utf-8")
        if "sorry" in text or forbidden.search(text) or workflow_id.search(text):
            raise SystemExit(f"passages formal replay: FAIL [source policy {relative}]")
    print("passages formal replay: PASS [pinned sources and toolchain]")


def run_gate(lean_root: Path, manifest: dict[str, object]) -> None:
    gate = manifest["gate_module"]
    build = subprocess.run(
        ["nix", "develop", "--command", "lake", "build", gate],
        cwd=lean_root,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if build.returncode:
        tail = "\n".join(build.stdout.splitlines()[-12:])
        raise SystemExit(f"passages formal replay: FAIL [build]\n{tail}")

    gate_path = Path(*gate.split(".")).with_suffix(".lean")
    audit = subprocess.run(
        ["nix", "develop", "--command", "lake", "env", "lean", str(gate_path)],
        cwd=lean_root,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if audit.returncode:
        tail = "\n".join(audit.stdout.splitlines()[-12:])
        raise SystemExit(f"passages formal replay: FAIL [axiom audit]\n{tail}")
    expected = parse_axioms(AXIOM_REPORT.read_text(encoding="utf-8"))
    observed = parse_axioms(audit.stdout)
    declarations = set(manifest["audited_declarations"])
    if set(expected) != declarations:
        raise SystemExit(
            "passages formal replay: FAIL [manifest/report declaration mismatch]"
        )
    if observed != expected:
        raise SystemExit("passages formal replay: FAIL [axiom report mismatch]")
    print("passages formal replay: PASS [gate and axiom audit]")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lean-root", type=Path, required=True)
    parser.add_argument(
        "--source-only",
        action="store_true",
        help="check pinned sources and toolchain without invoking Lean",
    )
    args = parser.parse_args()
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    lean_root = args.lean_root.resolve()
    check_sources(lean_root, manifest)
    if not args.source_only:
        run_gate(lean_root, manifest)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
