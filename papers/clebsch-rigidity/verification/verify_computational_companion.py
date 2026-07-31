#!/usr/bin/env python3
"""Validate, and optionally replay, the computational companion trust ledger."""

from __future__ import annotations

import argparse
import json
import subprocess
from pathlib import Path


SCHEMA = "clebsch-computational-companion-trust-v1"
CLAIM_IDS = {
    "chord-defect-and-window",
    "q11-geometric-rigidity",
    "fifteen-class-census-and-gap",
    "low-degree-rigidity",
    "q9-sylvester-obstruction",
    "seven-arc-exclusion",
    "q13-tangent-code-distance-and-minimum-layer-classification",
    "q13-minimum-orbit-spans-and-automorphism-group",
    "passant-arc-bound-q13-q17-q19",
}


def relative_file(root: Path, value: object, where: str) -> Path:
    if not isinstance(value, str) or not value:
        raise ValueError(f"{where} must be a nonempty path")
    relative = Path(value)
    if relative.is_absolute() or ".." in relative.parts:
        raise ValueError(f"{where} must be relative to the paper root")
    path = root / relative
    if not path.is_file():
        raise ValueError(f"{where} is missing: {path}")
    return path


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--run", action="store_true", help="run every exact replay after validation"
    )
    args = parser.parse_args()

    ledger_path = Path(__file__).with_name("computational_companion_trust.json")
    ledger = json.loads(ledger_path.read_text(encoding="utf-8"))
    if ledger.get("schema") != SCHEMA:
        raise ValueError("unexpected companion trust schema")
    manuscript_path = relative_file(
        paper_root, ledger.get("manuscript"), "manuscript"
    )
    manuscript = manuscript_path.read_text(encoding="utf-8")

    claims = ledger.get("claims")
    if not isinstance(claims, list):
        raise ValueError("claims must be a list")
    ids = [claim.get("id") for claim in claims if isinstance(claim, dict)]
    if len(ids) != len(claims) or set(ids) != CLAIM_IDS or len(ids) != len(set(ids)):
        raise ValueError("claim IDs do not match the companion claim surface")

    commands: list[Path] = []
    for index, claim in enumerate(claims):
        if not isinstance(claim, dict):
            raise ValueError(f"claims[{index}] must be an object")
        if "source" in claim:
            relative_file(paper_root, claim["source"], f"claims[{index}].source")
        for key in ("checks", "certificates"):
            values = claim.get(key, [])
            if not isinstance(values, list):
                raise ValueError(f"claims[{index}].{key} must be a list")
            for item_index, value in enumerate(values):
                path = relative_file(
                    paper_root, value, f"claims[{index}].{key}[{item_index}]"
                )
                if key == "checks":
                    if f"\\path{{{value}}}" not in manuscript:
                        raise ValueError(f"check is absent from manuscript ledger: {value}")
                    if path not in commands:
                        commands.append(path)

    if args.run:
        for command in commands:
            subprocess.run(
                ["python3", str(command.relative_to(paper_root))],
                cwd=paper_root,
                check=True,
            )
    print(f"companion_claims={len(claims)} checks={len(commands)} status=ok")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, json.JSONDecodeError, subprocess.CalledProcessError) as error:
        print(f"companion trust verification failed: {error}")
        raise SystemExit(1)
