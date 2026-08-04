#!/usr/bin/env python3
"""Rebuild a gate's transitive source-closure inventory from the Lean tree.

Each ``*_source_closure.json`` in this directory pins the exact bytes of every
project-local module a gate imports, transitively, together with the external
imports that closure reaches.  The paper-local verifiers compare the file
against its recorded hash and against the per-path hashes in the matching
``*_formal.json``, so the inventory must be regenerated rather than edited by
hand whenever a module in the closure changes.

Replay:

    python3 papers/clebsch-passages/verification/extract_source_closure.py \
        --lean-root lean \
        --root RelativeConicArcs.Gates.FourShadowRecognition \
        --output papers/clebsch-passages/verification/four_shadow_source_closure.json
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


IMPORT_RE = re.compile(r"^import\s+(\S+)\s*$", re.MULTILINE)
LOCAL_PREFIX = "RelativeConicArcs"


def module_path(lean_root: Path, module: str) -> Path:
    return lean_root / (module.replace(".", "/") + ".lean")


def walk(lean_root: Path, root: str) -> tuple[list[str], set[str]]:
    local: list[str] = []
    external: set[str] = set()
    pending = [root]
    seen: set[str] = set()
    while pending:
        module = pending.pop()
        if module in seen:
            continue
        seen.add(module)
        local.append(module)
        source = module_path(lean_root, module)
        if not source.is_file():
            raise SystemExit(f"extract_source_closure: missing source for {module}")
        for imported in IMPORT_RE.findall(source.read_text(encoding="utf-8")):
            if imported == LOCAL_PREFIX or imported.startswith(LOCAL_PREFIX + "."):
                pending.append(imported)
            else:
                external.add(imported)
    return sorted(local), external


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lean-root", required=True, type=Path)
    parser.add_argument("--root", required=True)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    lean_root = args.lean_root.resolve()
    modules, external = walk(lean_root, args.root)
    sources = []
    for module in modules:
        source = module_path(lean_root, module)
        sources.append(
            {
                "bytes": source.stat().st_size,
                "module": module,
                "path": str(source.relative_to(lean_root)),
                "sha256": sha256(source),
            }
        )
    inventory = {
        "external_imports": sorted(external),
        "module_count": len(sources),
        "roots": [args.root],
        "schema_version": 1,
        "sources": sources,
    }
    args.output.write_text(
        json.dumps(inventory, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print(f"extract_source_closure: {len(sources)} modules -> {args.output}")


if __name__ == "__main__":
    main()
