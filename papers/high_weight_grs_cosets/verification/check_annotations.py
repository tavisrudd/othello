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
LINKS: dict[str, dict[str, list[str]]] = {
    "prop:r5-radius": {"imports": ["duer", "seroussi-roth"]},
    "cor:r5-binary-shallow": {"imports": ["aubry-perret"]},
    "lem:s3": {"imports": ["aubry-perret"]},
    "prop:upper-radius": {"imports": ["duer", "seroussi-roth"]},
    "prop:reduced-terminal-carrier": {
        "evidence": ["certificate-stable-components"]
    },
    "prop:maximal-lucas-union": {"imports": ["wang-wu-hu"]},
    "prop:linearized": {"imports": ["wang-wu-hu"]},
    "thm:r5": {
        "evidence": ["certificate-r5"],
        "proves": ["redundancy-five-classification"],
    },
    "thm:r6": {
        "evidence": ["certificate-r6"],
        "uses": ["thm:r5"],
        "proves": ["redundancy-six-classification"],
    },
    "thm:r7": {
        "evidence": ["certificate-r7"],
        "uses": ["thm:r6", "cor:one-column-extensions"],
        "imports": [
            "ball-de-beule-mds",
            "duer",
            "seroussi-roth",
            "wu-ding-chen",
        ],
        "proves": ["redundancy-seven-classification"],
    },
    "thm:r8": {
        "evidence": ["certificate-r8"],
        "uses": ["thm:recursive-carrier"],
        "proves": ["redundancy-eight-classification"],
    },
    "thm:r9": {
        "evidence": ["certificate-r9"],
        "uses": ["thm:r8"],
        "proves": ["redundancy-nine-classification"],
    },
    "cor:r10": {
        "evidence": ["certificate-r10"],
        "uses": ["prop:r10-escape"],
        "proves": ["redundancy-ten-classification"],
    },
    "thm:recursive-carrier": {
        "evidence": ["certificate-stable-components"],
        "uses": ["thm:simultaneous-marker-escape"],
        "proves": ["recursive-carrier-classification"],
    },
    "thm:m9-shallow": {
        "evidence": ["certificate-lucas-m9"],
        "uses": ["prop:linearized"],
        "proves": ["degree-nine-lucas-shallowness"],
    },
    "thm:main": {
        "uses": ["thm:simultaneous-marker-escape", "prop:recursive-component-selection"],
        "proves": ["main-fixed-level-classification-package"],
    },
}


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
            **LINKS.get(label, {}),
        }
    return {"schema_version": 1, "claims": claims}


def annotation(label: str, claim: dict[str, object]) -> str:
    lines = [f"\\label{{{label}}}%", f"\\coverage{{{claim['coverage']}}}%"]
    identifiers = claim["lean"]
    if identifiers:
        lines.append(f"\\lean{{{','.join(identifiers)}}}%")
    for macro in ("uses", "imports", "evidence", "proves"):
        values = claim.get(macro, [])
        if values:
            lines.append(f"\\{macro}{{{','.join(values)}}}%")
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
                rf"(?:\n\\uses\{{[^}}]+\}}%?)?"
                rf"(?:\n\\imports\{{[^}}]+\}}%?)?"
                rf"(?:\n\\evidence\{{[^}}]+\}}%?)?"
                rf"(?:\n\\proves\{{[^}}]+\}}%?)?"
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
    manifest_entries: dict[Path, list[str]] = {}
    for identifier, row in evidence.items():
        manifest = PAPER / row["checksum_manifest"]
        if not manifest.is_file() or not row.get("commands"):
            raise SystemExit(f"incomplete evidence contract: {identifier}")
        paths = manifest_entries.setdefault(
            manifest,
            [item["path"] for item in json.loads(manifest.read_text(encoding="utf-8"))["entries"]],
        )
        prefixes = row.get("manifest_prefixes", [])
        if not prefixes or any(not any(path.startswith(prefix) for path in paths) for prefix in prefixes):
            raise SystemExit(f"evidence manifest rows do not resolve: {identifier}")
    joined = "\n".join(texts.values())
    for macro, registry in (("imports", imported), ("evidence", evidence)):
        for body in re.findall(rf"\\{macro}\{{([^}}]+)\}}", joined):
            for identifier in body.split(","):
                if identifier not in registry:
                    raise SystemExit(f"unknown {macro} identifier: {identifier}")
    for macro, registry in (("imports", imported), ("evidence", evidence)):
        referenced = {
            identifier
            for body in re.findall(rf"\\{macro}\{{([^}}]+)\}}", joined)
            for identifier in body.split(",")
        }
        if referenced != set(registry):
            raise SystemExit(f"unwired {macro} registry entries: {sorted(set(registry) - referenced)}")
    for body in re.findall(r"\\uses\{([^}]+)\}", joined):
        for label in body.split(","):
            if label not in claims:
                raise SystemExit(f"unknown claim dependency: {label}")
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
