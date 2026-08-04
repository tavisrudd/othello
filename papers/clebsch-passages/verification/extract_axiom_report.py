#!/usr/bin/env python3
"""Rebuild a gate's axiom report from the live Lean build stdout.

The three ``*_axioms.txt`` files in this directory are byte-compared by the
paper-local verifiers, so they must never be edited by hand.  This tool
reproduces one of them from the stdout of the gate build that produced it:
it keeps the ``#print axioms`` diagnostics in emission order, strips the
``info: <file>:<line>:<col>: `` prefix that Lake prepends to the first line of
each diagnostic, and rejoins the continuation lines so that every declaration
occupies exactly one line.  Rejoining matters: Lean's pretty-printer wraps the
axiom list at a width that depends on the invoking environment, so an
unnormalized report would differ byte for byte between two builds of identical
sources and defeat the very comparison the verifiers perform.

Replay:

    python3 papers/clebsch-passages/verification/extract_axiom_report.py \
        --stdout <run-dir>/logs/<gate>.quiet/*/*/stdout.log \
        --output papers/clebsch-passages/verification/<gate>_axioms.txt
"""

from __future__ import annotations

import argparse
import re
from pathlib import Path


INFO_RE = re.compile(r"^info: [^:]+\.lean:\d+:\d+: (?='.* (?:depends on axioms|does not depend))")
CONTINUATION_RE = re.compile(r"^ ")


def extract(text: str) -> str:
    if "error:" in text:
        raise SystemExit(
            "extract_axiom_report: the build log reports an error; an axiom report "
            "may only be taken from a clean gate build"
        )
    lines: list[str] = []
    inside = False
    for line in text.splitlines():
        stripped = INFO_RE.sub("", line)
        if stripped != line:
            lines.append(stripped)
            inside = True
            continue
        if inside and CONTINUATION_RE.match(line):
            lines[-1] = lines[-1] + " " + line.strip()
            continue
        inside = False
    if not lines:
        raise SystemExit("extract_axiom_report: no #print axioms diagnostics found")
    for line in lines:
        if "does not depend on any axioms" in line:
            continue
        if not line.rstrip().endswith("]"):
            raise SystemExit(
                f"extract_axiom_report: truncated axiom list: {line!r}"
            )
    return "\n".join(lines) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--stdout", required=True, type=Path)
    parser.add_argument("--output", required=True, type=Path)
    args = parser.parse_args()
    report = extract(args.stdout.read_text(encoding="utf-8"))
    args.output.write_text(report, encoding="utf-8")
    print(f"extract_axiom_report: {report.count(chr(10))} lines -> {args.output}")


if __name__ == "__main__":
    main()
