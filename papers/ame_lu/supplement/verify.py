#!/usr/bin/env python3
"""Verify paper-local evidence paths and SHA-256 hashes."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
MANIFEST = ROOT / "EVIDENCE-MANIFEST.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    data = json.loads(MANIFEST.read_text(encoding="utf-8"))
    if data.get("schema") != "ame-lu-evidence-manifest-v1":
        raise SystemExit("unexpected evidence-manifest schema")
    artifacts = data.get("artifacts")
    if not isinstance(artifacts, list):
        raise SystemExit("artifacts must be a list")
    for entry in artifacts:
        relative = entry.get("path")
        expected = entry.get("sha256")
        if not isinstance(relative, str) or not isinstance(expected, str):
            raise SystemExit("each artifact needs string path and sha256 fields")
        path = (ROOT / relative).resolve()
        if ROOT not in path.parents:
            raise SystemExit(f"artifact escapes supplement root: {relative}")
        if not path.is_file():
            raise SystemExit(f"missing artifact: {relative}")
        actual = sha256(path)
        if actual != expected:
            raise SystemExit(f"hash mismatch: {relative}")
    print(f"verified {len(artifacts)} evidence artifact(s)")


if __name__ == "__main__":
    main()
