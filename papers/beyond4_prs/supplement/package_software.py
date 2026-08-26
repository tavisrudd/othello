#!/usr/bin/env python3
"""Record or verify the paper-local companion-software boundary."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


SUPPLEMENT = Path(__file__).resolve().parent
PAPER = SUPPLEMENT.parent
SOFTWARE = PAPER / "software/projective-reed-solomon"
MANIFEST = SUPPLEMENT / "SOFTWARE-MANIFEST.json"
EXCLUDED_PARTS = {"target", ".git"}


def digest(path: Path) -> tuple[str, int]:
    data = path.read_bytes()
    return hashlib.sha256(data).hexdigest(), len(data)


def entries() -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for path in sorted(SOFTWARE.rglob("*")):
        relative = path.relative_to(PAPER)
        if not path.is_file() or EXCLUDED_PARTS.intersection(relative.parts):
            continue
        sha256, size = digest(path)
        rows.append(
            {
                "path": relative.as_posix(),
                "sha256": sha256,
                "bytes": size,
            }
        )
    if not rows:
        raise SystemExit("companion-software tree is empty")
    return rows


def expected_text() -> str:
    payload = {
        "schema": "beyond-four-prs-software-manifest-v1",
        "hash": "sha256",
        "path_base": "paper",
        "entries": entries(),
    }
    return json.dumps(payload, indent=2, sort_keys=True) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    expected = expected_text()
    if args.write:
        MANIFEST.write_text(expected, encoding="utf-8")
        print(f"wrote {MANIFEST.relative_to(PAPER)}")
        return
    if not MANIFEST.is_file() or MANIFEST.read_text(encoding="utf-8") != expected:
        raise SystemExit("stale companion-software manifest")
    print(f"verified {len(entries())} companion-software artifacts")


if __name__ == "__main__":
    main()
