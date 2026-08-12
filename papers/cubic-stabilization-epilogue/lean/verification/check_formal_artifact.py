#!/usr/bin/env python3
"""Check the static trust boundary of the paper-bundled Lean companion."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
SOURCE_ROOT = ROOT / "TavisRuddFiniteGeom"
CLAIMS = ROOT / "verification" / "claims.json"
EXPECTED_AXIOMS = ROOT / "verification" / "expected_axioms.txt"
SECTIONS = ROOT.parent / "sections"
PAPER_INTERFACE = (
    SOURCE_ROOT / "Papers" / "CubicStabilizationEpilogue" / "PaperInterface.lean"
)
AXIOM_AUDIT = (
    SOURCE_ROOT
    / "Papers"
    / "CubicStabilizationEpilogue"
    / "Verification"
    / "AxiomAudit.lean"
)

FORBIDDEN = {
    "sorry": re.compile(r"\bsorry\b"),
    "admit": re.compile(r"\badmit\b"),
    "project axiom": re.compile(r"(?m)^\s*axiom\s+"),
    "unsafe": re.compile(r"\bunsafe\b"),
    "native_decide": re.compile(r"\bnative_decide\b"),
    "implemented_by": re.compile(r"\bimplemented_by\b"),
    "kernel skipping": re.compile(r"\bdebug\.skipKernelTC\b"),
    "task identifier": re.compile(r"\bC[0-9]{2,}\b"),
}

THEOREM_ENVIRONMENTS = ("theorem", "proposition", "lemma", "corollary", "definition")
ALLOWED_COVERAGE = {"absent", "fragment", "conditional_deduction", "complete"}


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def manuscript_labels() -> set[str]:
    labels: set[str] = set()
    environment_pattern = re.compile(
        r"\\begin\{(" + "|".join(THEOREM_ENVIRONMENTS) + r")\}"
        r"(?:\[[^\]]*\])?(.*?)\\end\{\1\}",
        re.DOTALL,
    )
    for section in sorted(SECTIONS.glob("*.tex")):
        text = section.read_text(encoding="utf-8")
        for match in environment_pattern.finditer(text):
            found = re.findall(
                r"\\label\{((?:thm|prop|lem|cor|def):[^}]+)\}", match.group(2)
            )
            if len(found) != 1:
                fail(
                    f"{section.relative_to(ROOT.parent)} has a {match.group(1)} "
                    f"environment with {len(found)} semantic labels"
                )
            label = found[0]
            if label in labels:
                fail(f"duplicate manuscript label {label}")
            labels.add(label)
    return labels


def expected_axioms() -> dict[str, tuple[str, ...]]:
    result: dict[str, tuple[str, ...]] = {}
    for line_number, raw in enumerate(EXPECTED_AXIOMS.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            fail(f"expected_axioms.txt:{line_number} has no colon")
        declaration, payload = (part.strip() for part in line.split(":", 1))
        if declaration in result:
            fail(f"duplicate expected-axiom row for {declaration}")
        result[declaration] = () if payload == "none" else tuple(
            part.strip() for part in payload.split(",") if part.strip()
        )
    return result


def observed_axioms(path: Path) -> dict[str, tuple[str, ...]]:
    text = path.read_text(encoding="utf-8")
    result: dict[str, tuple[str, ...]] = {}
    pattern = re.compile(
        r"'([^']+)' (does not depend on any axioms|depends on axioms:\s*\[([^\]]*)\])",
        re.DOTALL,
    )
    for match in pattern.finditer(text):
        declaration = match.group(1)
        payload = match.group(3)
        axioms = () if payload is None else tuple(
            part.strip() for part in payload.replace("\n", " ").split(",") if part.strip()
        )
        if declaration in result:
            fail(f"axiom log repeats {declaration}")
        result[declaration] = axioms
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--source-only", action="store_true")
    mode.add_argument("--axiom-log", type=Path)
    args = parser.parse_args()

    sources = sorted(SOURCE_ROOT.rglob("*.lean"))
    if not sources:
        fail("no Lean sources found")
    namespace = "TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue"
    for source in sources:
        text = source.read_text(encoding="utf-8")
        for label, pattern in FORBIDDEN.items():
            if pattern.search(text):
                fail(f"{source.relative_to(ROOT)} contains forbidden {label}")

    interface_text = PAPER_INTERFACE.read_text(encoding="utf-8")
    terminals = {
        f"{namespace}.{match.group(1)}"
        for match in re.finditer(
            r"(?m)^theorem\s+([A-Za-z0-9_']+)", interface_text
        )
    }
    audited = set(
        re.findall(r"(?m)^#print axioms\s+(\S+)\s*$", AXIOM_AUDIT.read_text(encoding="utf-8"))
    )
    if audited != terminals:
        fail(
            "axiom audit terminal mismatch: "
            f"missing={sorted(terminals - audited)} extra={sorted(audited - terminals)}"
        )

    manifest = json.loads(CLAIMS.read_text(encoding="utf-8"))
    if manifest.get("schema") != "cubic-stabilization-lean-claims-v2":
        fail("unexpected claims schema")
    claims = manifest.get("claims", [])
    labels = [claim.get("manuscript_label") for claim in claims]
    if len(labels) != len(set(labels)):
        fail("duplicate manuscript labels in claim map")
    expected_labels = manuscript_labels()
    if set(labels) != expected_labels:
        fail(
            "manuscript claim-map mismatch: "
            f"missing={sorted(expected_labels - set(labels))} "
            f"extra={sorted(set(labels) - expected_labels)}"
        )
    registered: set[str] = set()
    for claim in claims:
        label = claim.get("manuscript_label")
        coverage = claim.get("coverage")
        if coverage not in ALLOWED_COVERAGE:
            fail(f"invalid coverage for {label}")
        for field in ("objects", "hypotheses", "conclusion", "cautions"):
            if not isinstance(claim.get(field), str) or not claim[field].strip():
                fail(f"{label} has no nonempty {field}")
        declarations = claim.get("declarations")
        if not isinstance(declarations, list):
            fail(f"{label} has no declaration list")
        if coverage == "absent" and declarations:
            fail(f"absent claim {label} registers declarations")
        if coverage != "absent" and not declarations:
            fail(f"covered claim {label} registers no declarations")
        for declaration in declarations:
            if declaration not in terminals:
                fail(f"unresolved declaration {declaration}")
            if declaration in registered:
                fail(f"terminal registered more than once: {declaration}")
            registered.add(declaration)
    if registered != terminals:
        fail(
            "claim-map terminal mismatch: "
            f"missing={sorted(terminals - registered)} extra={sorted(registered - terminals)}"
        )
    expected = expected_axioms()
    if set(expected) != terminals:
        fail(
            "expected-axiom terminal mismatch: "
            f"missing={sorted(terminals - set(expected))} extra={sorted(set(expected) - terminals)}"
        )
    if args.axiom_log is not None:
        observed = observed_axioms(args.axiom_log)
        if observed != expected:
            fail(
                "axiom output mismatch: "
                f"expected={expected} observed={observed}"
            )
    mode_name = "axiom-log" if args.axiom_log is not None else "source-only"
    print(
        f"PASS mode={mode_name} sources={len(sources)} terminals={len(terminals)} "
        f"manuscript_claims={len(claims)}"
    )


if __name__ == "__main__":
    main()
