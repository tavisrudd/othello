#!/usr/bin/env python3
"""Check the static trust boundary of the paper-bundled Lean companion."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_ROOT = ROOT / "TavisRuddFiniteGeom"
CLAIMS = ROOT / "verification" / "claims.json"

FORBIDDEN = {
    "sorry": re.compile(r"\bsorry\b"),
    "admit": re.compile(r"\badmit\b"),
    "project axiom": re.compile(r"(?m)^\s*axiom\s+"),
    "unsafe": re.compile(r"\bunsafe\b"),
    "native_decide": re.compile(r"\bnative_decide\b"),
    "implemented_by": re.compile(r"\bimplemented_by\b"),
    "task identifier": re.compile(r"\bC[0-9]{2,}\b"),
}


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    sources = sorted(SOURCE_ROOT.rglob("*.lean"))
    if not sources:
        fail("no Lean sources found")
    declarations: set[str] = set()
    namespace = "TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue"
    for source in sources:
        text = source.read_text(encoding="utf-8")
        for label, pattern in FORBIDDEN.items():
            if pattern.search(text):
                fail(f"{source.relative_to(ROOT)} contains forbidden {label}")
        for match in re.finditer(r"(?m)^theorem\s+([A-Za-z0-9_']+)", text):
            declarations.add(f"{namespace}.{match.group(1)}")

    manifest = json.loads(CLAIMS.read_text(encoding="utf-8"))
    if manifest.get("schema") != "cubic-stabilization-lean-claims-v1":
        fail("unexpected claims schema")
    for claim in manifest.get("claims", []):
        if claim.get("status") not in {"partial", "complete"}:
            fail(f"invalid status for {claim.get('manuscript_label')}")
        for declaration in claim.get("declarations", []):
            if declaration not in declarations:
                fail(f"unresolved declaration {declaration}")
    print(f"PASS sources={len(sources)} registered_claims={len(manifest['claims'])}")


if __name__ == "__main__":
    main()
