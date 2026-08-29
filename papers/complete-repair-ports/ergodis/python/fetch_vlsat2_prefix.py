#!/usr/bin/env python3
"""Fetch and stream-decompress the pinned first-ten VLSAT-2 prefix."""

from __future__ import annotations

import argparse
import bz2
import json
import urllib.request
from pathlib import Path

from run_satcomp24_portfolio import sha256


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--manifest", type=Path, required=True)
    parser.add_argument("--cache-dir", type=Path, required=True)
    args = parser.parse_args()
    manifest = json.loads(args.manifest.read_text())
    args.cache_dir.mkdir(parents=True, exist_ok=True)
    for index, entry in enumerate(manifest["instances"], 1):
        archive = args.cache_dir / entry["archive"]
        cnf = args.cache_dir / entry["filename"]
        if not archive.exists():
            partial = archive.with_suffix(archive.suffix + ".partial")
            print(f"[{index}/{len(manifest['instances'])}] fetch {archive.name}")
            with urllib.request.urlopen(entry["official_url"]) as response, partial.open(
                "wb"
            ) as output:
                while block := response.read(1 << 20):
                    output.write(block)
            partial.replace(archive)
        if not cnf.exists():
            partial = cnf.with_suffix(cnf.suffix + ".partial")
            with bz2.open(archive, "rb") as compressed, partial.open("wb") as output:
                while block := compressed.read(1 << 20):
                    output.write(block)
            partial.replace(cnf)
        print(
            json.dumps(
                {
                    "archive": archive.name,
                    "archive_sha256": sha256(archive),
                    "cnf": cnf.name,
                    "cnf_sha256": sha256(cnf),
                },
                sort_keys=True,
            )
        )


if __name__ == "__main__":
    main()
