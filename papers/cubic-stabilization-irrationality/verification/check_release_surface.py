#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TEX = [
    ROOT / "cubic_stabilization_irrationality.tex",
    *sorted((ROOT / "sections").glob("*.tex")),
]
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
    "thm:intro-cubic-conditional",
    "thm:intro-birational-conditional",
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
    "prop:gamma-ratio-reduction",
    "hyp:tailwise-derived",
    "prop:clutching-tail-holonomicity",
    "hyp:marked-threshold",
    "lem:cyclic-row-support",
    "rem:neutral-boundary",
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
if "nonlinear virtual fixed graphs" not in scope_text:
    errors.append("global continuation boundary is not visibly conditional")

global_text = (ROOT / "sections/08-global-transport.tex").read_text(encoding="utf-8")
if "\\begin{hypothesis}[Tailwise derived identification]" not in global_text:
    errors.append("tailwise derived identification is not an explicit hypothesis")
if "\\begin{hypothesis}[Marked threshold compatibility]" not in global_text:
    errors.append("marked threshold compatibility is not an explicit hypothesis")
if "prove neither" not in scope_text:
    errors.append("Aleshkin--Liu nonlinear source boundary is missing")
if "the proposition does not construct the common realization" not in global_text:
    errors.append("support-collapse coefficient-field boundary is missing")

main_text = (ROOT / "cubic_stabilization_irrationality.tex").read_text(
    encoding="utf-8"
)
intro_text = (ROOT / "sections/01-introduction.tex").read_text(encoding="utf-8")
readme_text = (ROOT / "README.md").read_text(encoding="utf-8")
ledger_path = ROOT / "claim-proof-novelty-ledger.md"
export_manifest_path = ROOT / "export-manifest.json"
if not re.search(
    r"Assume that every smooth projective birational map.*?finite cyclic Rees.*?Gamma point row.*?We prove that",
    main_text,
    flags=re.DOTALL,
):
    errors.append("abstract does not lead with the conditional cubic theorem")
if "\\begin{theorem}[Conditional cubic stabilization criterion]" not in intro_text:
    errors.append("headline cubic theorem is not visibly conditional")
if "Hypotheses~\\ref{hyp:tailwise-derived}" not in intro_text:
    errors.append("headline theorem does not name the derived-tail hypothesis")
if "\\ref{hyp:marked-threshold}" not in intro_text:
    errors.append("headline theorem does not name the marked-threshold hypothesis")
if "Under these hypotheses" not in readme_text:
    errors.append("README cubic conclusion is not visibly conditional")
if ledger_path.is_file():
    ledger_text = ledger_path.read_text(encoding="utf-8")
    if "| conditional application |" not in ledger_text:
        errors.append("claim ledger does not mark the cubic application conditional")
elif not export_manifest_path.is_file():
    errors.append("claim ledger missing outside a guarded standalone export")

endpoint_text = (ROOT / "sections/09-cubic-endpoint.tex").read_text(encoding="utf-8")
if "conditional transport" not in endpoint_text or "does not use Cai" not in endpoint_text:
    errors.append("transport theorem is not visibly separated from the Cai endpoint")

metadata = json.loads((ROOT / ".zenodo.json").read_text(encoding="utf-8"))
if metadata.get("title") != (
    "Conditional Irrationality of All Projective Stabilizations of "
    "Cubic Threefolds: Point-Class Rank under Quantum Wall Crossing"
):
    errors.append("Zenodo title does not match the manuscript")
if metadata.get("license") != "cc-by-4.0":
    errors.append("Zenodo license must be cc-by-4.0")
if "Assuming the tailwise derived identification and marked threshold compatibility hypotheses" not in metadata.get(
    "description", ""
):
    errors.append("Zenodo description does not lead with the conditional hypothesis")

for boundary_path in [
    ROOT / "literature-audit.md",
    ROOT / "claim-proof-novelty-ledger.md",
    ROOT / "verification" / "README.md",
    ROOT / "verification" / "check_cubic_endpoint.py",
    ROOT / "verification" / "cubic_endpoint_certificate.json",
]:
    if boundary_path.is_file() and "complete-neutral" in boundary_path.read_text(
        encoding="utf-8"
    ):
        errors.append(
            f"{boundary_path.relative_to(ROOT)}: superseded continuation hypothesis"
        )

if errors:
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"release surface: {len(TEX)} TeX files: CHECK OK")
