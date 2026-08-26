#!/usr/bin/env python3
"""Check or refresh the manuscript's formal-coverage annotations."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


PAPER = Path(__file__).resolve().parents[1]
STATEMENTS = PAPER / "supplement" / "LEAN-STATEMENTS.md"
CLAIM_MAP = PAPER / "verification" / "claim-map.json"
ROW_RE = re.compile(
    r"^\| `((?:lem|prop|thm|cor):[^`]+)` \| (.*?) \| (.*?) \|$",
    re.MULTILINE,
)
IDENTIFIER_RE = re.compile(r"^[A-Za-z][A-Za-z0-9_.]*$")


def coverage(boundary: str, status: str) -> str:
    text = f"{boundary} {status}".lower()
    if "no direct declaration" in text or "external certificate" in text:
        return "absent"
    if "conditional" in text or "derived manuscript aggregation" in text:
        return "conditional_deduction"
    return "fragment"


def lean_identifiers(boundary: str) -> list[str]:
    return [
        item
        for item in re.findall(r"`([^`]+)`", boundary)
        if IDENTIFIER_RE.fullmatch(item)
    ]


def source_files() -> list[Path]:
    return sorted((PAPER / "sections").glob("*.tex")) + sorted(
        (PAPER / "appendices").glob("*.tex")
    )


def expected_map() -> dict[str, object]:
    rows = ROW_RE.findall(STATEMENTS.read_text(encoding="utf-8"))
    claims: dict[str, dict[str, object]] = {}
    sources: dict[str, str] = {}
    for path in source_files():
        text = path.read_text(encoding="utf-8")
        for label in re.findall(r"\\label\{((?:lem|prop|thm|cor):[^}]+)\}", text):
            if label in sources:
                raise SystemExit(f"duplicate manuscript label: {label}")
            sources[label] = path.relative_to(PAPER).as_posix()
    for label, boundary, status in rows:
        if label not in sources:
            raise SystemExit(f"statement-map label is absent from TeX: {label}")
        claims[label] = {
            "coverage": coverage(boundary, status),
            "lean": lean_identifiers(boundary),
            "source": sources[label],
            "status": status,
        }
    return {"schema_version": 1, "claims": claims}


def annotation(label: str, claim: dict[str, object]) -> str:
    lines = [f"\\label{{{label}}}%", f"\\coverage{{{claim['coverage']}}}%"]
    identifiers = claim["lean"]
    if identifiers:
        lines.append(f"\\lean{{{','.join(identifiers)}}}%")
    return "\n".join(lines)


def refresh(expected: dict[str, object]) -> None:
    claims = expected["claims"]
    assert isinstance(claims, dict)
    by_source: dict[str, list[str]] = {}
    for label, claim in claims.items():
        assert isinstance(claim, dict)
        by_source.setdefault(str(claim["source"]), []).append(label)
    for relative, labels in by_source.items():
        path = PAPER / relative
        text = path.read_text(encoding="utf-8")
        for label in labels:
            claim = claims[label]
            pattern = re.compile(
                rf"\\label\{{{re.escape(label)}\}}%?"
                rf"(?:\n\\coverage\{{[^}}]+\}}%?)?"
                rf"(?:\n\\lean\{{[^}}]+\}}%?)?"
            )
            rendered = annotation(label, claim)
            text, count = pattern.subn(lambda _match: rendered, text, count=1)
            if count != 1:
                raise SystemExit(f"could not refresh annotation for {label}")
        path.write_text(text, encoding="utf-8")
    CLAIM_MAP.write_text(
        json.dumps(expected, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )


def check(expected: dict[str, object]) -> None:
    actual = json.loads(CLAIM_MAP.read_text(encoding="utf-8"))
    if actual != expected:
        raise SystemExit("verification/claim-map.json is stale; run with --update")
    claims = expected["claims"]
    assert isinstance(claims, dict)
    texts = {path.relative_to(PAPER).as_posix(): path.read_text(encoding="utf-8") for path in source_files()}
    for label, claim in claims.items():
        assert isinstance(claim, dict)
        if annotation(label, claim) not in texts[str(claim["source"])]:
            raise SystemExit(f"missing or stale TeX annotation: {label}")
    imported = json.loads(
        (PAPER / "verification" / "imported-sources.json").read_text(encoding="utf-8")
    )
    evidence = json.loads(
        (PAPER / "verification" / "evidence.json").read_text(encoding="utf-8")
    )
    bibliography = (PAPER / "refs.bib").read_text(encoding="utf-8")
    for identifier, row in imported.items():
        if f"{{{row['citation']}," not in bibliography:
            raise SystemExit(f"unknown bibliography key for import {identifier}")
        if not row.get("pinpoint") or not row.get("conventions"):
            raise SystemExit(f"incomplete imported-source contract: {identifier}")
    for identifier, row in evidence.items():
        manifest = PAPER / row["checksum_manifest"]
        if not manifest.is_file() or not row.get("commands"):
            raise SystemExit(f"incomplete evidence contract: {identifier}")
    joined = "\n".join(texts.values())
    for macro, registry in (("imports", imported), ("evidence", evidence)):
        for body in re.findall(rf"\\{macro}\{{([^}}]+)\}}", joined):
            for identifier in body.split(","):
                if identifier not in registry:
                    raise SystemExit(f"unknown {macro} identifier: {identifier}")
    print(f"verified {len(claims)} formal-coverage annotations")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--update", action="store_true")
    args = parser.parse_args()
    expected = expected_map()
    if args.update:
        refresh(expected)
    check(expected)


if __name__ == "__main__":
    main()
