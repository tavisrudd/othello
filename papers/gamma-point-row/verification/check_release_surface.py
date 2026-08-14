#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEX = [ROOT / "gamma_point_row.tex", *sorted((ROOT / "sections").glob("*.tex"))]
PUBLIC = [
    *TEX,
    ROOT / "README.md",
    ROOT / ".zenodo.json",
]

errors: list[str] = []

for path in PUBLIC:
    if not path.is_file():
        errors.append(f"missing public file: {path.relative_to(ROOT)}")

for path in TEX:
    text = path.read_text(encoding="utf-8")
    for pattern, label in [
        (r"(?i)go" + r"ld", "prohibited internal ladder term"),
        (r"\bC\d{3}\b", "internal task id"),
        (r"(?i)TODO|FIXME", "unfinished marker"),
        (r"(?i)to our knowledge|first ever|previously unknown", "unaudited priority phrase"),
        (r"notes" + r"/|task card|handoff", "private repository coupling"),
    ]:
        if re.search(pattern, text):
            errors.append(f"{path.relative_to(ROOT)}: {label}")

all_tex = "\n".join(path.read_text(encoding="utf-8") for path in TEX)
required_labels = {
    "def:point-row",
    "thm:intro-cubic-stable",
    "thm:intro-birational-point-primary",
    "thm:simple-wall-point-column",
    "hyp:one-wall-sectorial",
    "cor:simple-wall-rank",
    "thm:ordinary-flop-point-row",
    "prop:incomplete-gamma",
    "prop:punctual-corner",
    "hyp:rank-zero-target",
    "thm:rank-zero-target",
    "eq:blockwise-boundary-marking",
    "prop:support-collapse",
    "thm:complete-neutral",
    "thm:birational-point-primary",
    "prop:cubic-endpoint",
}
found = set(re.findall(r"\\label\{([^}]+)\}", all_tex))
for label in sorted(required_labels - found):
    errors.append(f"missing semantic theorem label: {label}")

conditional_text = (ROOT / "sections/07-two-wall-criterion.tex").read_text(encoding="utf-8")
if "Under Hypothesis~\\ref{hyp:rank-zero-target}" not in conditional_text:
    errors.append("two-wall theorem is not visibly conditional")
if "This implication is \\emph{not} proved here" not in conditional_text:
    errors.append("global signed-punctual shadow is not visibly open")

scope_text = (ROOT / "sections/08-scope.tex").read_text(encoding="utf-8")
if "They are not asserted to arise from smooth projective quantum connections" not in scope_text:
    errors.append("analytic countermodel scope boundary missing")
if "Cai enters only Proposition" not in scope_text:
    errors.append("Cai endpoint dependency is not visibly isolated")

endpoint_text = (ROOT / "sections/09-cubic-endpoint.tex").read_text(encoding="utf-8")
if "The transport theorem and its" not in endpoint_text or "do not use Cai" not in endpoint_text:
    errors.append("transport theorem is not visibly separated from the Cai endpoint")

metadata = json.loads((ROOT / ".zenodo.json").read_text(encoding="utf-8"))
if metadata.get("title") != (
    "The Point-Class Rank Functional under Birational Wall Crossing: "
    "Irrationality of X × P^m for Every Cubic Threefold"
):
    errors.append("Zenodo title does not match the manuscript")
if metadata.get("license") != "cc-by-4.0":
    errors.append("Zenodo license must be cc-by-4.0")

if errors:
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"release surface: {len(TEX)} TeX files: CHECK OK")
