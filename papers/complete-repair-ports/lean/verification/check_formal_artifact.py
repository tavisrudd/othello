#!/usr/bin/env python3
"""Check the paper-local recovery-structure Lean companion.

The source-only mode verifies the claim partition, reviewer-terminal coverage,
and forbidden-token boundary. Supplying an axiom log additionally checks the
kernel-reported axiom set of every reviewer terminal.
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
PAPER_ROOT = ROOT.parent
SOURCE_ROOT = ROOT / "TavisRuddFiniteGeom" / "Papers" / "RecoveryStructures"
CLAIMS = ROOT / "verification" / "claims.json"
EXPECTED_AXIOMS = ROOT / "verification" / "expected_axioms.txt"
PREFIX = "TavisRuddFiniteGeom.Papers.RecoveryStructures."
ALLOWED_STATUSES = {"complete", "conditional_deduction", "fragment", "absent"}
FORBIDDEN = re.compile(r"\b(?:axiom|sorry|admit|native_decide|unsafe)\b")
THEOREM = re.compile(r"^theorem\s+([A-Za-z0-9_']+)", re.MULTILINE)
MANUSCRIPT_ENV = re.compile(
    r"\\begin\{(theorem|proposition|corollary|lemma)\}(.*?)\\end\{\1\}",
    re.DOTALL,
)
PROOF_ENV = re.compile(r"\\begin\{proof\}(.*?)\\end\{proof\}", re.DOTALL)
STATEMENTS_WITHOUT_DETACHED_PROOF = {"thm:main"}


def load_claims() -> dict:
    data = json.loads(CLAIMS.read_text())
    if data.get("schema_version") != 1 or not isinstance(data.get("claims"), list):
        raise SystemExit("invalid claims schema")
    return data


def source_terminals() -> set[str]:
    result: set[str] = set()
    for path in sorted(SOURCE_ROOT.rglob("*.lean")):
        if "Verification" in path.parts:
            continue
        text = path.read_text()
        match = FORBIDDEN.search(text)
        if match:
            raise SystemExit(f"forbidden token {match.group(0)!r} in {path.relative_to(ROOT)}")
        for name in THEOREM.findall(text):
            result.add(PREFIX + name)
    return result


def claimed_terminals(data: dict) -> set[str]:
    result: set[str] = set()
    ids: set[str] = set()
    for row in data["claims"]:
        claim_id = row.get("id")
        if not isinstance(claim_id, str) or claim_id in ids:
            raise SystemExit(f"invalid or repeated claim id: {claim_id!r}")
        ids.add(claim_id)
        if row.get("status") not in ALLOWED_STATUSES:
            raise SystemExit(f"invalid status for {claim_id}")
        terminals = row.get("terminals")
        if not isinstance(terminals, list) or len(terminals) != len(set(terminals)):
            raise SystemExit(f"invalid terminal list for {claim_id}")
        if row["status"] == "absent" and terminals:
            raise SystemExit(f"absent claim {claim_id} has terminals")
        overlap = result.intersection(terminals)
        if overlap:
            raise SystemExit(f"reviewer terminal appears twice: {sorted(overlap)}")
        result.update(terminals)
    return result


def manuscript_environments() -> dict[str, str]:
    paths = [PAPER_ROOT / "complete_repair_ports.tex"]
    paths.extend(sorted((PAPER_ROOT / "sections").glob("*.tex")))
    result: dict[str, str] = {}
    for path in paths:
        text = path.read_text()
        for _, body in MANUSCRIPT_ENV.findall(text):
            labels = [
                label
                for label in re.findall(r"\\label\{([^}]+)\}", body)
                if label.startswith(("thm:", "prop:", "cor:", "lem:"))
            ]
            if len(labels) != 1:
                raise SystemExit(
                    f"theorem-like environment in {path.relative_to(PAPER_ROOT)} "
                    f"has {len(labels)} labels"
                )
            label = labels[0]
            if label in result:
                raise SystemExit(f"repeated manuscript label: {label}")
            result[label] = body
    return result


def tex_annotation(label: str, body: str, macro: str) -> list[str]:
    matches = re.findall(rf"\\{macro}\{{([^}}]*)\}}", body, re.DOTALL)
    if len(matches) > 1:
        raise SystemExit(f"{label} carries multiple \\{macro} annotations")
    if not matches:
        return []
    payload = matches[0].replace("%", "")
    return [item.strip() for item in payload.split(",") if item.strip()]


def check_manuscript_annotations(data: dict) -> None:
    environments = manuscript_environments()
    rows: dict[str, dict] = {}
    for row in data["claims"]:
        label = row.get("manuscript_label")
        if not isinstance(label, str) or label in rows:
            raise SystemExit(f"invalid or repeated manuscript label in claims: {label!r}")
        rows[label] = row
    if set(rows) != set(environments):
        raise SystemExit(
            f"manuscript claim partition mismatch; "
            f"unclaimed={sorted(set(environments) - set(rows))}, "
            f"unknown={sorted(set(rows) - set(environments))}"
        )

    for label, body in environments.items():
        coverage = tex_annotation(label, body, "coverage")
        if len(coverage) != 1:
            raise SystemExit(f"{label} must carry exactly one \\coverage annotation")
        status = rows[label]["status"]
        if coverage[0] != status:
            raise SystemExit(
                f"{label} annotates coverage {coverage[0]!r} but claims records {status!r}"
            )
        lean = tex_annotation(label, body, "lean")
        annotated = {PREFIX + name for name in lean}
        recorded = set(rows[label]["terminals"])
        if annotated != recorded:
            raise SystemExit(
                f"{label} Lean annotation mismatch; "
                f"annotated={sorted(annotated)}, recorded={sorted(recorded)}"
            )

    known_labels = set(environments)
    all_text = (PAPER_ROOT / "complete_repair_ports.tex").read_text()
    all_text += "\n".join(
        path.read_text() for path in sorted((PAPER_ROOT / "sections").glob("*.tex"))
    )
    proved: set[str] = set()
    for body in PROOF_ENV.findall(all_text):
        matches = re.findall(r"\\proves\{([^}]*)\}", body, re.DOTALL)
        if len(matches) != 1:
            raise SystemExit(
                f"detached proof carries {len(matches)} \\proves annotations"
            )
        label = matches[0].strip()
        if label not in known_labels:
            raise SystemExit(f"detached proof names unknown statement: {label}")
        if label in proved:
            raise SystemExit(f"multiple detached proofs name {label}")
        proved.add(label)
    expected_proved = known_labels - STATEMENTS_WITHOUT_DETACHED_PROOF
    if proved != expected_proved:
        raise SystemExit(
            f"detached-proof partition mismatch; "
            f"missing={sorted(expected_proved - proved)}, "
            f"unexpected={sorted(proved - expected_proved)}"
        )
    for payload in re.findall(r"\\uses\{([^}]*)\}", all_text, re.DOTALL):
        for used in (item.strip() for item in payload.replace("%", "").split(",")):
            if used and used not in known_labels:
                raise SystemExit(f"unknown manuscript dependency in \\uses: {used}")


def expected_axioms() -> dict[str, set[str]]:
    result: dict[str, set[str]] = {}
    for raw in EXPECTED_AXIOMS.read_text().splitlines():
        if not raw.strip():
            continue
        name, values = raw.split(":", 1)
        result[name.strip()] = {item.strip() for item in values.split(",") if item.strip()}
    return result


def observed_axioms(path: Path) -> dict[str, set[str]]:
    text = path.read_text()
    pattern = re.compile(r"'([^']+)' depends on axioms: \[([^\]]*)\]", re.MULTILINE)
    return {
        name: {item.strip() for item in body.replace("\n", " ").split(",") if item.strip()}
        for name, body in pattern.findall(text)
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source-only", action="store_true")
    parser.add_argument("--axiom-log", type=Path)
    args = parser.parse_args()
    if not args.source_only and args.axiom_log is None:
        parser.error("choose --source-only or --axiom-log")

    data = load_claims()
    check_manuscript_annotations(data)
    source = source_terminals()
    claimed = claimed_terminals(data)
    if source != claimed:
        raise SystemExit(
            f"claim partition mismatch; unclaimed={sorted(source - claimed)}, "
            f"unknown={sorted(claimed - source)}"
        )

    expected = expected_axioms()
    if set(expected) != source:
        raise SystemExit("expected-axiom names do not equal the reviewer-terminal set")

    if args.axiom_log is not None:
        observed = observed_axioms(args.axiom_log)
        if observed != expected:
            raise SystemExit(f"axiom mismatch; expected={expected}, observed={observed}")

    print(
        f"PASS claims={len(data['claims'])} reviewer_terminals={len(source)} "
        f"axioms_checked={args.axiom_log is not None}"
    )


if __name__ == "__main__":
    main()
