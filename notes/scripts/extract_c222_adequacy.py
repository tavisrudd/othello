#!/usr/bin/env python3
"""Extract C222 theorem signatures and load-bearing Lean definitions deterministically."""

from __future__ import annotations

import argparse
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
SOURCES = [
    ROOT / "lean/RelativeConicArcs/ReflectionArrangements.lean",
    ROOT / "lean/RelativeConicArcs/ReflectionArrangementDecoding.lean",
]
DEFINITIONS = [
    "SameDirection", "ProjectivelyInjective", "cross", "dot", "tau11", "h3FivefoldPoint", "h3Join",
    "h3RootDirection", "h3Projectivity", "h3DualProjectivity",
    "h3ProjectivityInverse", "projectiveIndex11", "h3ProjectiveIndex",
    "h3Multiplicity", "h3PointsOfMultiplicity", "h3FivefoldIndex", "tau5",
    "projectiveVec5", "h3RootDirection5", "h3Multiplicity5",
    "h3PointsOfMultiplicity5", "a3FramePoint", "a3Join", "a3RootDirection",
    "a3Joins", "a3RootDirections", "a3Multiplicity", "a3PointsOfMultiplicity",
    "h3AffineSyndrome", "h3AffineSyndromeNonzero", "h3AffineSyndromesOfMultiplicity",
    "h3OneLeaderSyndromes",
]


def declaration_block(text: str, name: str) -> str:
    match = re.search(rf"^(?:def|abbrev|theorem) {re.escape(name)}\b", text, re.MULTILINE)
    if match is None:
        raise ValueError(f"declaration not found: {name}")
    tail = text[match.start():]
    block = tail.split("\n\n", 1)[0].rstrip()
    if block.startswith("theorem "):
        block = re.sub(r"\s*:= by[\s\S]*$", "", block).rstrip()
    return block


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="verify extraction without printing")
    args = parser.parse_args()
    texts = {path: path.read_text(encoding="utf-8") for path in SOURCES}
    theorem_names = []
    for text in texts.values():
        theorem_names.extend(re.findall(r"^#print axioms (\w+)$", text, re.MULTILINE))
    names = DEFINITIONS + theorem_names
    blocks = []
    for name in names:
        matches = [declaration_block(text, name) for text in texts.values()
                   if re.search(rf"^(?:def|abbrev|theorem) {re.escape(name)}\b", text, re.MULTILINE)]
        if len(matches) != 1:
            raise ValueError(f"expected one declaration for {name}, found {len(matches)}")
        blocks.append(matches[0])
    if not args.check:
        print("\n\n".join(blocks))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
