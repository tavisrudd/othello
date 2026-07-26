#!/usr/bin/env python3
"""Aggregate release check for the factorization-memory paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import platform
import subprocess
import sys
from pathlib import Path, PurePosixPath


EXPECTED_SCHEMA = "clebsch-factorization-trust-manifest-v1"
EXPECTED_IDENTITY = "verification/statement_identity.json"
FINGERPRINT = "verification/evidence_fingerprint.json"
ALLOWED_MODES = {"conceptual", "classical-input", "certificate", "lean"}
EXPECTED_EVIDENCE = {
    "matching-module": {
        "checksum_manifest": "notes/2026-07-20-c406-matching-module.sha256",
        "commands": [
            ["python3", "notes/2026-07-20-c406-matching-module.py", "--check"],
            ["python3", "notes/2026-07-20-c406-matching-module-replay.py"],
        ],
    },
    "balanced-sheet": {
        "checksum_manifest":
            "notes/2026-07-20-c430-conceptual-balanced-half-rigidity.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-20-c430-conceptual-balanced-half-rigidity.py",
                "--check",
            ],
            [
                "python3",
                "notes/2026-07-20-c430-conceptual-balanced-half-rigidity-replay.py",
                "--check",
            ],
        ],
    },
    "profile-incidence": {
        "checksum_manifest": "notes/2026-07-20-c411-double-coset-hecke.sha256",
        "commands": [
            ["python3", "notes/2026-07-20-c411-double-coset-hecke.py", "--check"],
            ["python3", "notes/2026-07-20-c411-double-coset-hecke-replay.py"],
        ],
    },
    "decorated-parent": {
        "checksum_manifest":
            "notes/2026-07-19-c379-clebsch-deep-hole-extension.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-19-c379-clebsch-deep-hole-extension.py",
                "--check",
            ],
            ["python3", "notes/2026-07-19-c379-clebsch-deep-hole-extension-replay.py"],
        ],
    },
    "relative-cubic-depth": {
        "checksum_manifest":
            "notes/2026-07-20-c412-relative-cubic-depth-plane.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-20-c412-relative-cubic-depth-plane.py",
                "--check",
            ],
            ["python3", "notes/2026-07-20-c412-relative-cubic-depth-plane-replay.py"],
        ],
    },
    "arithmetic-gluing": {
        "checksum_manifest":
            "notes/2026-07-22-c503-clebsch-arithmetic-gluing-lean.sha256",
        "commands": [
            [
                "python3",
                "notes/2026-07-22-c503-clebsch-arithmetic-gluing-lean.py",
                "--check",
            ]
        ],
    },
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def check_checksum_manifest(repo_root: Path, relative: str) -> None:
    relative_path = PurePosixPath(relative)
    if relative_path.is_absolute() or ".." in relative_path.parts:
        raise ValueError(f"unsafe checksum-manifest path: {relative}")
    manifest = repo_root / relative
    seen: set[str] = set()
    for line_number, line in enumerate(
        manifest.read_text(encoding="utf-8").splitlines(), start=1
    ):
        if not line:
            continue
        expected, path_text = line.split(maxsplit=1)
        if len(expected) != 64 or any(character not in "0123456789abcdef"
                                      for character in expected):
            raise ValueError(f"{manifest}:{line_number}: invalid SHA-256")
        normalized = path_text.strip().lstrip("*")
        artifact_path = PurePosixPath(normalized)
        if artifact_path.is_absolute() or ".." in artifact_path.parts:
            raise ValueError(f"{manifest}:{line_number}: unsafe artifact path")
        if normalized in seen:
            raise ValueError(f"{manifest}:{line_number}: duplicate artifact path")
        seen.add(normalized)
        path = repo_root / normalized
        if not path.is_file():
            raise ValueError(f"{manifest}:{line_number}: missing {path_text}")
        actual = sha256(path)
        if actual != expected:
            raise ValueError(
                f"{manifest}:{line_number}: checksum mismatch for {path_text}"
            )


def run(command: list[str], cwd: Path) -> None:
    completed = subprocess.run(
        command,
        cwd=cwd,
        check=False,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    if completed.returncode != 0:
        sys.stdout.write(completed.stdout)
        raise SystemExit(
            f"command failed ({completed.returncode}): {' '.join(command)}"
        )
    summary = completed.stdout.strip().splitlines()
    tail = summary[-1] if summary else "OK"
    print(f"{' '.join(command)}: {tail}")


def build_fingerprint(
    repo_root: Path, paper_root: Path, manifest: dict[str, object]
) -> dict[str, object]:
    bundle_fingerprints = {}
    for name, item in manifest["evidence"].items():
        checksum_manifest = repo_root / item["checksum_manifest"]
        bundle_fingerprints[name] = {
            "checksum_manifest": item["checksum_manifest"],
            "checksum_manifest_sha256": sha256(checksum_manifest),
            "commands": item["commands"],
        }
    environment_paths = {
        "lean_toolchain": repo_root / "lean" / "lean-toolchain",
        "lake_manifest": repo_root / "lean" / "lake-manifest.json",
        "nix_lock": repo_root / "lean" / "flake.lock",
    }
    return {
        "schema": "clebsch-factorization-evidence-fingerprint-v1",
        "python": platform.python_version(),
        "lean_toolchain": environment_paths["lean_toolchain"]
        .read_text(encoding="utf-8")
        .strip(),
        "mathlib_revision": next(
            package["rev"]
            for package in json.loads(
                environment_paths["lake_manifest"].read_text(encoding="utf-8")
            )["packages"]
            if package["name"] == "mathlib"
        ),
        "environment_sha256": {
            name: sha256(path) for name, path in environment_paths.items()
        },
        "trust_manifest_sha256": sha256(
            paper_root / "verification" / "trust_manifest.json"
        ),
        "runner_sha256": sha256(Path(__file__).resolve()),
        "evidence": bundle_fingerprints,
        "expected_success": {
            "metadata": "metadata: 17 statements, 6 evidence bundles: CHECK OK",
            "release": "clebsch factorization release: CHECK OK",
        },
    }


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    repo_root = paper_root.parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument("--metadata-only", action="store_true")
    parser.add_argument("--update-fingerprint", action="store_true")
    args = parser.parse_args()

    run(
        [
            "python3",
            str(paper_root / "verification" / "extract_statement_identity.py"),
            "--check",
        ],
        repo_root,
    )
    identity = json.loads(
        (paper_root / "verification" / "statement_identity.json").read_text(
            encoding="utf-8"
        )
    )
    manifest = json.loads(
        (paper_root / "verification" / "trust_manifest.json").read_text(
            encoding="utf-8"
        )
    )
    fingerprint_path = paper_root / FINGERPRINT
    fingerprint = build_fingerprint(repo_root, paper_root, manifest)
    fingerprint_rendered = json.dumps(fingerprint, indent=2) + "\n"
    if args.update_fingerprint:
        fingerprint_path.write_text(fingerprint_rendered, encoding="utf-8")
        print(f"wrote {fingerprint_path}")
    elif (
        not fingerprint_path.exists()
        or fingerprint_path.read_text(encoding="utf-8") != fingerprint_rendered
    ):
        raise ValueError("evidence fingerprint is stale")
    if manifest.get("schema") != EXPECTED_SCHEMA:
        raise ValueError("unexpected trust-manifest schema")
    if manifest.get("statement_identity") != EXPECTED_IDENTITY:
        raise ValueError("unexpected statement-identity path")
    statement_labels = {
        statement["label"] for statement in identity["statements"]
    }
    claim_labels = {claim["label"] for claim in manifest["claims"]}
    if statement_labels != claim_labels or len(manifest["claims"]) != len(
        statement_labels
    ):
        raise ValueError("trust manifest does not partition the statement identity")
    evidence = manifest["evidence"]
    if set(evidence) != set(EXPECTED_EVIDENCE):
        raise ValueError("evidence-bundle set changed")
    for name, expected in EXPECTED_EVIDENCE.items():
        actual = evidence[name]
        for field in ("checksum_manifest", "commands"):
            if actual.get(field) != expected[field]:
                raise ValueError(f"{name}: unexpected {field}")
        if not isinstance(actual.get("role"), str) or not actual["role"].strip():
            raise ValueError(f"{name}: missing semantic role")
    for claim in manifest["claims"]:
        unknown = set(claim["evidence"]) - set(evidence)
        if unknown:
            raise ValueError(f"{claim['label']}: unknown evidence {sorted(unknown)}")
        modes = set(claim["modes"])
        if not modes or not modes <= ALLOWED_MODES:
            raise ValueError(f"{claim['label']}: invalid proof modes")
        if "certificate" in modes and not claim["evidence"]:
            raise ValueError(f"{claim['label']}: certificate mode has no evidence")
        if "lean" in modes and "arithmetic-gluing" not in claim["evidence"]:
            raise ValueError(f"{claim['label']}: Lean mode has no Lean evidence")
    for item in evidence.values():
        check_checksum_manifest(repo_root, item["checksum_manifest"])
    print(
        f"metadata: {len(statement_labels)} statements, "
        f"{len(evidence)} evidence bundles: CHECK OK"
    )

    if args.metadata_only:
        return 0
    for item in evidence.values():
        for command in item["commands"]:
            run(command, repo_root)
    run(["make", "-B", "clebsch-factorization"], repo_root / "papers")
    print("clebsch factorization release: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
