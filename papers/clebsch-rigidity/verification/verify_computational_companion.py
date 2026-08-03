#!/usr/bin/env python3
"""Validate, and optionally replay, the computational companion trust ledger."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from pathlib import Path


SCHEMA = "clebsch-computational-companion-trust-v2"
PROOF_MODES = {
    "human-structural-proof",
    "published-theorem",
    "lean-theorem",
    "finite-certificate",
    "trusted-execution",
}
CLAIM_IDS = {
    "chord-defect-window-and-q11-rigidity",
    "q9-sylvester-obstruction",
    "formal-chord-q9-small-k-terminals",
    "q11-six-arc-orbit-ledger",
    "q11-low-degree-rigidity",
    "q13-weight-eight-exclusion",
    "q13-weight-ten-profile-exclusions",
    "q13-minimum-layer-classification",
    "q13-minimum-orbit-spans-and-automorphism-group",
    "q11-q13-seven-arc-exclusions",
    "q13-q17-q19-maximum-passant-arc-size-six",
    "q17-q19-terminal-projective-classification",
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


def verify_pinned_path(
    root: Path, record: dict[str, object], path_key: str, hash_key: str, where: str
) -> None:
    path = relative_file(root, record.get(path_key), f"{where}.{path_key}")
    expected = record.get(hash_key)
    if not isinstance(expected, str) or hashlib.sha256(path.read_bytes()).hexdigest() != expected:
        raise ValueError(f"{where}.{hash_key} is stale")


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
    modes = ledger.get("proof_modes")
    if not isinstance(modes, list) or set(modes) != PROOF_MODES or len(modes) != 5:
        raise ValueError("proof_modes must list exactly the five admitted modes")
    manuscript_path = relative_file(
        paper_root, ledger.get("manuscript"), "manuscript"
    )
    manuscript = manuscript_path.read_text(encoding="utf-8")

    artifact_paths: set[str] = set()
    artifacts = ledger.get("artifacts")
    if not isinstance(artifacts, list):
        raise ValueError("artifacts must be a list")
    for index, artifact in enumerate(artifacts):
        if not isinstance(artifact, dict):
            raise ValueError(f"artifacts[{index}] must be an object")
        path = relative_file(
            paper_root, artifact.get("path"), f"artifacts[{index}].path"
        )
        expected = artifact.get("sha256")
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        if not isinstance(expected, str) or actual != expected:
            raise ValueError(f"artifacts[{index}] has stale sha256")
        artifact_paths.add(str(path.relative_to(paper_root)))

    checks = ledger.get("checks")
    if not isinstance(checks, list) or not checks:
        raise ValueError("checks must be a nonempty list")
    commands: dict[str, list[str]] = {}
    for index, check in enumerate(checks):
        if not isinstance(check, dict):
            raise ValueError(f"checks[{index}] must be an object")
        check_id = check.get("id")
        argv = check.get("argv")
        if not isinstance(check_id, str) or not check_id or check_id in commands:
            raise ValueError(f"checks[{index}].id is invalid or duplicate")
        if (
            not isinstance(argv, list)
            or len(argv) < 2
            or argv[0] != "python3"
            or any(not isinstance(item, str) or not item for item in argv)
        ):
            raise ValueError(f"checks[{index}].argv must be a direct Python command")
        script = relative_file(paper_root, argv[1], f"checks[{index}].argv[1]")
        if f"\\path{{{argv[1]}}}" not in manuscript:
            raise ValueError(f"check is absent from manuscript ledger: {argv[1]}")
        commands[check_id] = [argv[0], str(script.relative_to(paper_root)), *argv[2:]]

    claims = ledger.get("claims")
    if not isinstance(claims, list):
        raise ValueError("claims must be a list")
    ids = [claim.get("id") for claim in claims if isinstance(claim, dict)]
    if len(ids) != len(claims) or set(ids) != CLAIM_IDS or len(ids) != len(set(ids)):
        raise ValueError("claim IDs do not match the companion claim surface")

    used_modes: set[str] = set()
    used_checks: set[str] = set()
    for index, claim in enumerate(claims):
        if not isinstance(claim, dict):
            raise ValueError(f"claims[{index}] must be an object")
        mode = claim.get("mode")
        if not isinstance(mode, str) or mode not in PROOF_MODES:
            raise ValueError(f"claims[{index}].mode is invalid")
        used_modes.add(mode)
        for key in ("statement", "reduction", "invariant", "residual_finite_leaf", "replay"):
            if not isinstance(claim.get(key), str) or not claim[key]:
                raise ValueError(f"claims[{index}].{key} must be nonempty")
        if "source" in claim:
            relative_file(paper_root, claim["source"], f"claims[{index}].source")
        claim_checks = claim.get("checks", [])
        if not isinstance(claim_checks, list):
            raise ValueError(f"claims[{index}].checks must be a list")
        for check_id in claim_checks:
            if not isinstance(check_id, str) or check_id not in commands:
                raise ValueError(f"claims[{index}] cites an unknown check")
            used_checks.add(check_id)
        claim_artifacts = claim.get("artifacts", [])
        if not isinstance(claim_artifacts, list):
            raise ValueError(f"claims[{index}].artifacts must be a list")
        for artifact in claim_artifacts:
            if not isinstance(artifact, str) or artifact not in artifact_paths:
                raise ValueError(f"claims[{index}] cites an unpinned artifact")

    if used_modes != PROOF_MODES:
        raise ValueError("every admitted proof mode must occur in the claim map")
    if used_checks != set(commands):
        raise ValueError("every admitted executable check must support a claim")

    boundary_path = Path(__file__).with_name("c725_finite_boundary_manifest.json")
    boundary = json.loads(boundary_path.read_text(encoding="utf-8"))
    boundary_claims = boundary.get("claims")
    if not isinstance(boundary_claims, list) or len(boundary_claims) != 7:
        raise ValueError("finite boundary manifest must contain seven claims")
    for index, claim in enumerate(boundary_claims):
        if not isinstance(claim, dict):
            raise ValueError(f"finite boundary claims[{index}] must be an object")
        artifact = claim.get("artifact")
        if artifact is not None:
            verify_pinned_path(
                paper_root, claim, "artifact", "sha256", f"finite boundary claims[{index}]"
            )
        independent = claim.get("independent_artifact")
        if independent is not None:
            verify_pinned_path(
                paper_root,
                claim,
                "independent_artifact",
                "independent_sha256",
                f"finite boundary claims[{index}]",
            )
        legacy_inputs = claim.get("legacy_inputs", [])
        if not isinstance(legacy_inputs, list):
            raise ValueError(f"finite boundary claims[{index}].legacy_inputs must be a list")
        for input_index, legacy in enumerate(legacy_inputs):
            if not isinstance(legacy, dict):
                raise ValueError("finite boundary legacy input must be an object")
            verify_pinned_path(
                paper_root,
                legacy,
                "path",
                "sha256",
                f"finite boundary claims[{index}].legacy_inputs[{input_index}]",
            )

    if args.run:
        for command in commands.values():
            subprocess.run(
                command,
                cwd=paper_root,
                check=True,
            )
    print(
        f"companion_claims={len(claims)} modes={len(used_modes)} "
        f"checks={len(commands)} artifacts={len(artifact_paths)} "
        f"finite_boundary_claims={len(boundary_claims)} status=ok"
    )
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, json.JSONDecodeError, subprocess.CalledProcessError) as error:
        print(f"companion trust verification failed: {error}")
        raise SystemExit(1)
