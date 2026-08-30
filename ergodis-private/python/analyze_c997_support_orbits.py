#!/usr/bin/env python3
"""Privately audit whole-support translation orbits after C997 anchoring."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
from pathlib import Path

import numpy as np


def load_c997(path: Path):
    spec = importlib.util.spec_from_file_location("c997_gross_source", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load C997 source: {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def read_solves(path: Path) -> tuple[dict, list[dict]]:
    header = None
    solves = []
    with path.open(encoding="utf-8") as stream:
        for line in stream:
            record = json.loads(line)
            if record.get("kind") == "header":
                if header is not None:
                    raise ValueError("evidence contains multiple headers")
                header = record
            elif record.get("kind") == "solve":
                solves.append(record)
    if header is None or not solves:
        raise ValueError("evidence contains no complete solve records")
    return header, solves


def support_digest(support: tuple[int, ...], n: int) -> str:
    bits = np.zeros(n, dtype=np.uint8)
    bits[list(support)] = 1
    return hashlib.sha256(np.packbits(bits, bitorder="little").tobytes()).hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--c997-source", type=Path, required=True)
    parser.add_argument("--evidence", type=Path, required=True)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    c997 = load_c997(args.c997_source.resolve())
    hx, _, lx, _, _, _ = c997.build_gross_code()
    hx = np.asarray(hx, dtype=np.uint8) & 1
    lx = np.asarray(lx, dtype=np.uint8) & 1
    header, solves = read_solves(args.evidence)
    anchors = tuple(header["semantic_checks"]["anchor_cover"])
    records = []
    for solve in solves:
        support = tuple(solve["witness"]["support"])
        images_with_multiplicity = []
        for u in range(c997.ELL):
            for v in range(c997.M):
                permutation = c997.translation_perm(u, v)
                image = tuple(
                    sorted(int(permutation[coordinate]) for coordinate in support)
                )
                images_with_multiplicity.append(image)
        images = sorted(set(images_with_multiplicity))
        canonical = images[0]
        for image in images:
            witness = np.zeros(hx.shape[1], dtype=np.uint8)
            witness[list(image)] = 1
            if np.any((hx @ witness) & 1) or not np.any((lx @ witness) & 1):
                raise RuntimeError("translated support failed exact semantic replay")
        anchor_counts = {
            str(anchor): sum(anchor in image for image in images) for anchor in anchors
        }
        stabilizer_order = sum(image == support for image in images_with_multiplicity)
        if len(images) * stabilizer_order != c997.ELL * c997.M:
            raise RuntimeError("support orbit-stabilizer identity failed")
        anchored_representatives = sum(anchor_counts.values())
        records.append(
            {
                "source_anchor": solve["anchor"],
                "weight": len(support),
                "orbit_size": len(images),
                "stabilizer_order": stabilizer_order,
                "anchor_representatives": anchor_counts,
                "anchored_representatives_total": anchored_representatives,
                "canonical_support": list(canonical),
                "canonical_support_sha256": support_digest(canonical, hx.shape[1]),
                "source_is_canonical": support == canonical,
            }
        )
    output = {
        "schema": "ergodis-c997-support-orbits-v1",
        "c997_source_sha256": header["c997_source_sha256"],
        "source_evidence": str(args.evidence.resolve()),
        "source_runner_sha256": header["runner_sha256"],
        "group_order": int(c997.ELL * c997.M),
        "anchors": list(anchors),
        "records": records,
    }
    args.out.parent.mkdir(parents=True, exist_ok=True)
    with args.out.open("x", encoding="utf-8") as stream:
        json.dump(output, stream, indent=2, sort_keys=True)
        stream.write("\n")
    print(json.dumps(output, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
