#!/usr/bin/env python3
"""C1018 certificate builder for the 2026-08-31 PRS deep-hole wave.

Collects the per-cell JSON emitted by `c1018_prs_census` (and, where a cell was
also run through the 2026-08-30 driver, by `c1018_prs_deephole`) from the bulk
output directory and folds it into one compact, canonical, committed
certificate.  Bulk JSON stays outside the repository; this file is the
git-visible record.

Canonicity: records are sorted by (mode, r, q, stratum_mod, stratum_class),
keys are sorted, no timestamps and no host paths are written, and each record
carries the SHA-256 and byte count of the source file it was folded from.

Usage
-----
  build  <cache-dir> <out.json>   rebuild the certificate from the cache
  check  <cache-dir> <out.json>   rebuild into memory and diff against the file
"""

import hashlib
import json
import os
import sys

CENSUS_FIELDS = [
    "driver",
    "q",
    "p",
    "h",
    "defining_poly",
    "n",
    "k",
    "r",
    "d",
    "group",
    "projective_points",
    "covering_radius",
    "regime",
    "deep_hole_projective_points",
    "deep_hole_syndromes",
    "deep_hole_orbits",
    "deep_persistent_points",
    "deep_exceptional_points",
    "deep_exceptional_orbits",
    "persistent_predicted",
    "total_orbits",
]

STRATUM_FIELDS = [
    "driver",
    "mode",
    "q",
    "p",
    "h",
    "defining_poly",
    "n",
    "k",
    "r",
    "d",
    "stratum_mod",
    "stratum_class",
    "stratum_indices",
    "stratum_points",
    "stratum_max_weight",
    "deep_in_stratum",
    "exceptional_in_stratum",
]


def digest(path):
    raw = open(path, "rb").read()
    return hashlib.sha256(raw).hexdigest(), len(raw)


FIX_FIELDS = [
    "driver",
    "mode",
    "q",
    "p",
    "h",
    "defining_poly",
    "n",
    "k",
    "r",
    "d",
    "swept_points",
    "deep_in_fixed_locus",
    "exceptional_in_fixed_locus",
]


def fold(path):
    data = json.load(open(path))
    mode = data.get("mode", "census")
    if mode == "fix_sweep":
        rec = {key: data[key] for key in FIX_FIELDS if key in data}
        rec["mode"] = "fix_sweep"
        rec["loci"] = sorted(
            [
                loc["order"],
                loc["kind"],
                loc["eigenvalue"],
                loc["dim"],
                loc["points"],
                loc["deep"],
                loc["exceptional"],
            ]
            for loc in data["loci"]
            if loc["deep"] or loc["exceptional"]
        )
        rec["exceptional_examples"] = sorted(
            pt for loc in data["loci"] for pt in loc.get("examples", [])
        )
        sha, size = digest(path)
        rec["source"] = {"name": os.path.basename(path), "sha256": sha, "bytes": size}
        return rec
    stratum = mode == "stratum"
    fields = STRATUM_FIELDS if stratum else CENSUS_FIELDS
    rec = {key: data[key] for key in fields if key in data}
    rec["mode"] = "stratum" if stratum else "census"
    rec["weight_histogram"] = [
        [h["w"], h["points"]] for h in data["weight_histogram"] if h["points"]
    ]
    if stratum:
        rec["exceptional_examples"] = sorted(
            e["point"] for e in data.get("exceptional_examples", [])
        )
    else:
        rec["deep_orbits"] = sorted(
            [
                o["size"],
                o["rep"],
                o["apolar_degree"],
                o["apolar_kernel_dim"],
                o["apolar_type"],
            ]
            for o in data.get("deep_orbits", data.get("orbits", []))
            if o["w"] == data["covering_radius"]
        )
    sha, size = digest(path)
    rec["source"] = {"name": os.path.basename(path), "sha256": sha, "bytes": size}
    return rec


def build(cache):
    records = []
    for name in sorted(os.listdir(cache)):
        if not name.endswith(".json"):
            continue
        records.append(fold(os.path.join(cache, name)))
    records.sort(
        key=lambda rec: (
            rec["mode"],
            rec["r"],
            rec["q"],
            rec.get("stratum_mod", 0),
            rec.get("stratum_class", 0),
        )
    )
    return {
        "task": "C1018",
        "wave": "2026-08-31",
        "schema": 1,
        "cells": records,
    }


def render(doc):
    """One compact line per cell, so the file stays diffable and small."""
    head = {key: doc[key] for key in doc if key != "cells"}
    lines = ["{"]
    for key in sorted(head):
        lines.append(f' {json.dumps(key)}: {json.dumps(head[key])},')
    lines.append(' "cells": [')
    body = [
        "  " + json.dumps(cell, sort_keys=True, separators=(",", ":"))
        for cell in doc["cells"]
    ]
    lines.append(",\n".join(body))
    lines.append(" ]")
    lines.append("}")
    return "\n".join(lines) + "\n"


if __name__ == "__main__":
    if len(sys.argv) != 4 or sys.argv[1] not in ("build", "check"):
        raise SystemExit(__doc__)
    text = render(build(sys.argv[2]))
    if sys.argv[1] == "build":
        open(sys.argv[3], "w").write(text)
        print(f"wrote {sys.argv[3]} ({len(text)} bytes)")
    else:
        current = open(sys.argv[3]).read()
        if current == text:
            print("certificate matches the cache")
        else:
            raise SystemExit("certificate does NOT match the cache")
