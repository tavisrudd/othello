#!/usr/bin/env python3
"""Validate the Paper III source and trust-ledger scaffold."""

from __future__ import annotations

import json
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
PAPER = ROOT / "papers" / "clebsch-passages"
MAIN = PAPER / "clebsch_passages.tex"
MANIFEST = PAPER / "verification" / "trust_manifest.json"

ALLOWED_STATUSES = {
    "proven",
    "certified",
    "literature-backed",
    "gated",
    "conditional",
    "inventory",
}
CLAIM_RE = re.compile(r"^[A-Z]+-[0-9]+$")
OWNER_RE = re.compile(r"^C[0-9]+$")
INPUT_RE = re.compile(r"\\input\{([^}]+)\}")
CLAIM_USE_RE = re.compile(r"\\claimid\{([^}]+)\}")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(f"Paper III scaffold: FAIL: {message}")


def main() -> None:
    source = MAIN.read_text(encoding="utf-8")
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))

    inputs = INPUT_RE.findall(source)
    require(len(inputs) == len(set(inputs)), "duplicate section input")
    require(inputs, "no section inputs")
    for relative in inputs:
        require((PAPER / f"{relative}.tex").is_file(), f"missing {relative}.tex")

    claims = manifest.get("claims", [])
    ids = [claim.get("id", "") for claim in claims]
    require(len(ids) == len(set(ids)), "duplicate claim identifier")
    require(all(CLAIM_RE.fullmatch(item) for item in ids), "malformed claim identifier")

    for claim in claims:
        require(claim.get("status") in ALLOWED_STATUSES, f"bad status for {claim['id']}")
        require(OWNER_RE.fullmatch(claim.get("owner", "")) is not None,
                f"bad owner for {claim['id']}")
        require(bool(claim.get("statement")), f"empty statement for {claim['id']}")
        require(bool(claim.get("modes")), f"empty proof modes for {claim['id']}")
        if claim["status"] == "certified":
            require(bool(claim.get("evidence")), f"certified claim {claim['id']} has no evidence")
        for evidence in claim.get("evidence", []):
            require((ROOT / evidence).exists(), f"missing evidence {evidence}")

    section_text = "\n".join(
        (PAPER / f"{relative}.tex").read_text(encoding="utf-8")
        for relative in inputs
    )
    used = set(CLAIM_USE_RE.findall(section_text))
    require(used == set(ids),
            f"claim-ID mismatch: undeclared={sorted(used - set(ids))}, "
            f"unused={sorted(set(ids) - used)}")

    open_statuses = {"gated", "conditional"}
    has_open = any(claim["status"] in open_statuses for claim in claims)
    require(not (manifest.get("release_ready") and has_open),
            "release_ready is true with open claims")

    counts = {status: 0 for status in sorted(ALLOWED_STATUSES)}
    for claim in claims:
        counts[claim["status"]] += 1
    summary = ", ".join(f"{key}={value}" for key, value in counts.items() if value)
    print(
        f"Paper III scaffold: OK ({len(inputs)} sections, "
        f"{len(claims)} claims; {summary}; release_ready=false)"
    )


if __name__ == "__main__":
    main()
