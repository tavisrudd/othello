#!/usr/bin/env python3
"""Refresh or check the stable finite-evidence source manifest."""

from __future__ import annotations

import argparse
import hashlib
from pathlib import Path


HERE = Path(__file__).resolve().parent
MANIFEST = HERE / "source_manifest.sha256"
EXCLUDED = {MANIFEST.name, Path(__file__).name}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def rendered() -> str:
    files = sorted(
        path for path in HERE.iterdir()
        if path.is_file() and path.name not in EXCLUDED
    )
    return "".join(f"{digest(path)}  {path.name}\n" for path in files)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    expected = rendered()
    if args.write:
        MANIFEST.write_text(expected, encoding="utf-8")
        print(f"wrote {MANIFEST}")
        return 0
    if not MANIFEST.is_file() or MANIFEST.read_text(encoding="utf-8") != expected:
        raise SystemExit("stable finite-evidence manifest is stale")
    print("stable finite-evidence manifest: CHECK OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
