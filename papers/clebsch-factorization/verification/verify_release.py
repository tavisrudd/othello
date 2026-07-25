#!/usr/bin/env python3
"""Aggregate release check for the factorization-memory paper."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def check_checksum_manifest(repo_root: Path, relative: str) -> None:
    manifest = repo_root / relative
    for line_number, line in enumerate(
        manifest.read_text(encoding="utf-8").splitlines(), start=1
    ):
        if not line:
            continue
        expected, path_text = line.split(maxsplit=1)
        path = repo_root / path_text.strip().lstrip("*")
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


def main() -> int:
    paper_root = Path(__file__).resolve().parents[1]
    repo_root = paper_root.parents[1]
    parser = argparse.ArgumentParser()
    parser.add_argument("--metadata-only", action="store_true")
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
    statement_labels = {
        statement["label"] for statement in identity["statements"]
    }
    claim_labels = {claim["label"] for claim in manifest["claims"]}
    if statement_labels != claim_labels or len(manifest["claims"]) != len(
        statement_labels
    ):
        raise ValueError("trust manifest does not partition the statement identity")
    evidence = manifest["evidence"]
    for claim in manifest["claims"]:
        unknown = set(claim["evidence"]) - set(evidence)
        if unknown:
            raise ValueError(f"{claim['label']}: unknown evidence {sorted(unknown)}")
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
