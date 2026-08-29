#!/usr/bin/env python3
"""Build the deterministic Ergodis SATComp-2024 commercial suite manifest."""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import defaultdict
from pathlib import Path


FULL_FAMILIES = {
    "hardware-miter": "target",
    "miter": "adjacent",
    "hardware-verification": "adjacent",
    "hardware-model-checking": "adjacent",
    "crafted-cec": "adjacent",
    "circuit-multiplier": "adjacent",
}
CONTROL_FAMILIES = {
    "minimum-disagreement-parity",
    "cryptography",
    "knights-tour",
    "random-circuits",
    "scheduling",
}
CONTROL_COUNT = 5
OFFICIAL_META_URL = "https://satcompetition.github.io/2024/downloads/meta.csv"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as source:
        while block := source.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--meta", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    by_family: dict[str, list[dict[str, str]]] = defaultdict(list)
    lines = args.meta.read_text().splitlines()
    if not lines or lines[0] != "hash filename family author":
        raise SystemExit("unexpected SATComp metadata header")
    for line in lines[1:]:
        digest, filename, family, author = line.split()
        by_family[family].append(
            {
                "gbd_hash": digest,
                "filename": filename,
                "family": family,
                "author": author,
            }
        )
    for entries in by_family.values():
        entries.sort(key=lambda entry: (entry["gbd_hash"], entry["filename"]))

    instances = []
    for family, stratum in sorted(FULL_FAMILIES.items()):
        for entry in by_family.get(family, []):
            instances.append({"stratum": stratum, **entry})
    for family in sorted(CONTROL_FAMILIES):
        for entry in by_family.get(family, [])[:CONTROL_COUNT]:
            instances.append({"stratum": "control", **entry})

    document = {
        "schema": "ergodis-satcomp24-commercial-suite-v1",
        "official_metadata_url": OFFICIAL_META_URL,
        "official_metadata_sha256": sha256(args.meta),
        "manifest_builder_sha256": sha256(Path(__file__)),
        "official_instance_url_template": (
            "https://benchmark-database.de/file/{gbd_hash}?context=cnf"
        ),
        "selection": {
            "full_families": FULL_FAMILIES,
            "controls": {
                "families": sorted(CONTROL_FAMILIES),
                "count_per_family": CONTROL_COUNT,
                "rule": "lowest GBD hashes after lexical sort",
            },
        },
        "official_metadata_instances": len(lines) - 1,
        "selected_instances": len(instances),
        "instances": instances,
    }
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(document, indent=2) + "\n")


if __name__ == "__main__":
    main()
