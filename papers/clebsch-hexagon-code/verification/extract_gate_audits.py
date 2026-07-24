#!/usr/bin/env python3
"""Extract the declared axiom-audit surface of import-only Lean gates.

This tool records the exact gate bytes, imports, and any explicit
``#print axioms`` terminal names in deterministic JSON.  A gate without an
embedded audit is reported as such, so release validation can require a
separate audit module or reject the gap.  The Lean build remains responsible
for elaboration and for producing the actual axiom lists.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path


IMPORT_RE = re.compile(r"^import\s+(\S+)\s*$")
AXIOM_RE = re.compile(r"^#print\s+axioms\s+(\S+)\s*$")


def extract_gate(path: Path) -> dict[str, object]:
    raw = path.read_bytes()
    text = raw.decode("utf-8")
    imports = [
        match.group(1)
        for line in text.splitlines()
        if (match := IMPORT_RE.match(line)) is not None
    ]
    terminals = [
        match.group(1)
        for line in text.splitlines()
        if (match := AXIOM_RE.match(line)) is not None
    ]
    if not imports:
        raise ValueError(f"{path}: gate has no imports")
    if len(terminals) != len(set(terminals)):
        raise ValueError(f"{path}: duplicate #print axioms terminal")
    return {
        "audit_embedded": bool(terminals),
        "gate": path.stem,
        "imports": imports,
        "path": path.as_posix(),
        "sha256": hashlib.sha256(raw).hexdigest(),
        "terminal_count": len(terminals),
        "terminals": terminals,
    }


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Extract imports and axiom-audit terminals from Lean gates."
    )
    parser.add_argument("gates", nargs="+", type=Path)
    args = parser.parse_args()

    gates = [extract_gate(path) for path in args.gates]
    gate_names = [str(gate["gate"]) for gate in gates]
    if len(gate_names) != len(set(gate_names)):
        raise ValueError("gate basenames must be unique")
    payload = {
        "schema": "clebsch-gate-audit-surface-v1",
        "gate_count": len(gates),
        "gates": gates,
    }
    print(json.dumps(payload, indent=2, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
