#!/usr/bin/env python3
"""Verify paper-local evidence paths and SHA-256 hashes."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
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
    if data.get("schema") != "ame-lu-evidence-manifest-v2":
        raise SystemExit("unexpected evidence-manifest schema")
    artifacts = data.get("artifacts")
    if not isinstance(artifacts, list):
        raise SystemExit("artifacts must be a list")
    for entry in artifacts:
        relative = entry.get("path")
        expected = entry.get("sha256")
        expected_bytes = entry.get("bytes")
        if (
            not isinstance(relative, str)
            or not isinstance(expected, str)
            or not isinstance(expected_bytes, int)
        ):
            raise SystemExit("each artifact needs path, sha256, and byte-count fields")
        path = (ROOT / relative).resolve()
        if ROOT not in path.parents:
            raise SystemExit(f"artifact escapes supplement root: {relative}")
        if not path.is_file():
            raise SystemExit(f"missing artifact: {relative}")
        if path.stat().st_size != expected_bytes:
            raise SystemExit(f"byte-count mismatch: {relative}")
        actual = sha256(path)
        if actual != expected:
            raise SystemExit(f"hash mismatch: {relative}")
    print(f"verified {len(artifacts)} evidence artifact(s)")
    if "--replay" in sys.argv[1:]:
        for replay in data.get("replays", []):
            if not (
                isinstance(replay, list)
                and replay
                and all(isinstance(part, str) for part in replay)
            ):
                raise SystemExit("invalid replay command")
            script = (ROOT / replay[0]).resolve()
            if ROOT not in script.parents:
                raise SystemExit(f"replay escapes supplement root: {replay[0]}")
            subprocess.run([sys.executable, str(script), *replay[1:]], check=True)
        print(f"replayed {len(data.get('replays', []))} evidence bundle(s)")


if __name__ == "__main__":
    main()
