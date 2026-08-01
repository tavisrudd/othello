#!/usr/bin/env python3
"""Validate the clebsch-passages source and trust ledger."""

from __future__ import annotations

import json
import hashlib
import re
from pathlib import Path


PAPER = Path(__file__).resolve().parents[1]
MAIN = PAPER / "clebsch_passages.tex"
MANIFEST = PAPER / "verification" / "trust_manifest.json"
IDENTITY = PAPER / "verification" / "statement_identity.json"

ALLOWED_STATUSES = {
    "proven",
    "certified",
    "literature-backed",
    "gated",
    "conditional",
    "inventory",
}
CLAIM_RE = re.compile(r"^[A-Z]+-[0-9]+$")
INPUT_RE = re.compile(r"\\input\{([^}]+)\}")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(f"clebsch-passages scaffold: FAIL: {message}")


def main() -> None:
    source = MAIN.read_text(encoding="utf-8")
    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    identity = json.loads(IDENTITY.read_text(encoding="utf-8"))

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
        require("owner" not in claim, f"workflow owner leaked into {claim['id']}")
        require(bool(claim.get("statement")), f"empty statement for {claim['id']}")
        require(bool(claim.get("modes")), f"empty proof modes for {claim['id']}")
        require(bool(claim.get("theorem_labels")),
                f"empty theorem labels for {claim['id']}")
        require(bool(claim.get("clauses")), f"empty clauses for {claim['id']}")
        require(bool(claim.get("proof_role")), f"empty proof role for {claim['id']}")
        if claim["status"] == "certified":
            require(bool(claim.get("evidence")), f"certified claim {claim['id']} has no evidence")
        for evidence in claim.get("evidence", []):
            require((PAPER / evidence).exists(), f"missing evidence {evidence}")

    frozen_labels = {
        statement["label"] for statement in identity.get("statements", [])
    }
    referenced_labels = {
        label
        for claim in claims
        for label in claim["theorem_labels"]
    }
    require(referenced_labels == frozen_labels,
            "trust rows do not cover exactly the frozen theorem labels")
    for label in frozen_labels:
        rows = [claim for claim in claims if label in claim["theorem_labels"]]
        require(rows, f"no trust row for {label}")
        if len(rows) > 1:
            require(all(claim["clauses"] for claim in rows),
                    f"overlapping rows for {label} lack clause boundaries")

    trust_rows = [
        {
            key: claim[key]
            for key in (
                "id",
                "theorem_labels",
                "clauses",
                "statement",
                "status",
                "modes",
                "proof_role",
                "evidence",
            )
        }
        for claim in claims
    ]
    trust_text = json.dumps(trust_rows, sort_keys=True, separators=(",", ":"))
    trust_hash = hashlib.sha256(trust_text.encode("utf-8")).hexdigest()
    require(identity.get("trust_rows") == trust_rows,
            "trust row prose, modes, or evidence drifted from frozen identity")
    require(identity.get("trust_rows_sha256") == trust_hash,
            "trust row digest drifted from frozen identity")

    section_text = "\n".join(
        (PAPER / f"{relative}.tex").read_text(encoding="utf-8")
        for relative in inputs
    )
    require("\\claimid" not in source + section_text,
            "internal claim identifier appears in manuscript source")

    formal_coverage = manifest.get("formal_coverage", {})
    require(
        formal_coverage.get("status") ==
        "partial mechanisms; no complete manuscript row claimed",
        "formal coverage boundary is missing or changed",
    )
    require(
        formal_coverage.get("gate") ==
        "RelativeConicArcs.Gates.ClebschPassages",
        "current-paper formal gate is missing or changed",
    )
    formal_map_path = PAPER / formal_coverage.get("map", "")
    require(formal_map_path.is_file(), "formal declaration map is missing")
    formal_map = json.loads(formal_map_path.read_text(encoding="utf-8"))
    require(
        set(formal_map.get("claim_map", {})) == {claim["id"] for claim in claims},
        "formal declaration map does not cover exactly the manuscript rows",
    )
    require(
        all(
            row.get("coverage") == "partial mechanism; no full row claim"
            and bool(row.get("declarations"))
            and bool(row.get("excluded"))
            for row in formal_map["claim_map"].values()
        ),
        "formal row boundary is incomplete",
    )
    require(bool(manifest.get("local_release_ready")),
            "local release gate is not ready")
    require(manifest.get("submission_ready") is False,
            "submission status must remain false without external metadata")
    require(bool(manifest.get("submission_blockers")),
            "submission blockers are not recorded")

    counts = {status: 0 for status in sorted(ALLOWED_STATUSES)}
    for claim in claims:
        counts[claim["status"]] += 1
    summary = ", ".join(f"{key}={value}" for key, value in counts.items() if value)
    print(
        f"clebsch-passages scaffold: OK ({len(inputs)} sections, "
        f"{len(claims)} claims; {summary}; local_release_ready=true; "
        "submission_ready=false)"
    )


if __name__ == "__main__":
    main()
