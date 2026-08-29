#!/usr/bin/env python3
"""Fetch selected SATComp instances into an explicit non-tmpfs cache."""

from __future__ import annotations

import argparse
import hashlib
import json
import urllib.request
from pathlib import Path


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--cache-dir", type=Path, required=True)
    parser.add_argument("--family", action="append", default=[])
    parser.add_argument("--limit", type=int)
    args = parser.parse_args()
    if args.limit is not None and args.limit < 1:
        raise SystemExit("--limit must be positive")

    manifest = json.loads(args.manifest.read_text())
    selected = manifest["instances"]
    if args.family:
        selected = [entry for entry in selected if entry["family"] in args.family]
    if args.limit is not None:
        selected = selected[: args.limit]
    args.cache_dir.mkdir(parents=True, exist_ok=True)

    for index, entry in enumerate(selected, 1):
        target = args.cache_dir / entry["filename"]
        if not target.exists():
            partial = target.with_suffix(target.suffix + ".partial")
            url = manifest["official_instance_url_template"].format(**entry)
            print(f"[{index}/{len(selected)}] fetch {entry['filename']}", flush=True)
            with urllib.request.urlopen(url) as response, partial.open("wb") as output:
                while block := response.read(1 << 20):
                    output.write(block)
            partial.replace(target)
        print(
            json.dumps(
                {
                    "filename": entry["filename"],
                    "bytes": target.stat().st_size,
                    "sha256": sha256(target),
                },
                sort_keys=True,
            ),
            flush=True,
        )


if __name__ == "__main__":
    main()
