#!/usr/bin/env python3
"""C1025 certificate builder.

Folds the per-cell JSON emitted by `c1025_prs_stratum` into one compact,
canonical, committed record.  Bulk output stays outside the repository under
`~/.cache/ergodis/c1025/`; this file is the git-visible evidence.

Canonicity: cells sorted by (M, r, m, class, q), keys sorted, no timestamps or
host paths, and every record carries the SHA-256 and byte count of the file it
was folded from.

Usage
-----
  build  <cache-dir> <out.json>
  check  <cache-dir> <out.json>
"""

import hashlib
import json
import os
import sys

FIELDS = [
    "driver", "q", "p", "h", "defining_poly", "n", "k", "r", "d",
    "stratum_mod", "stratum_class", "stratum_indices", "stratum_points",
    "trials", "deep_in_stratum", "exceptional_in_stratum", "phase2_points",
]


def digest(path):
    raw = open(path, "rb").read()
    return hashlib.sha256(raw).hexdigest(), len(raw)


def fold(path):
    data = json.load(open(path))
    rec = {key: data[key] for key in FIELDS if key in data}
    rec["M"] = len(data["stratum_indices"])
    rec["exceptional_examples"] = sorted(
        e["point"] for e in data.get("exceptional_examples", [])
    )
    sha, size = digest(path)
    rec["source"] = {"name": os.path.basename(path), "sha256": sha, "bytes": size}
    return rec


def build(cache):
    cells = []
    for name in sorted(os.listdir(cache)):
        if not name.endswith(".json"):
            continue
        cells.append(fold(os.path.join(cache, name)))
    cells.sort(key=lambda c: (c["M"], c["r"], c["stratum_mod"],
                              c["stratum_class"], c["q"]))
    fired = [c for c in cells if c["exceptional_in_stratum"] > 0]
    return {
        "task": "C1025",
        "wave": "2026-08-31",
        "schema": 1,
        "summary": {
            "cells": len(cells),
            "cells_with_exceptional_deep_holes": len(fired),
            "firing_cells": sorted(
                [c["r"], c["stratum_mod"], c["q"], c["exceptional_in_stratum"]]
                for c in fired
            ),
            "r_range": [min(c["r"] for c in cells), max(c["r"] for c in cells)],
            "q_range": [min(c["q"] for c in cells), max(c["q"] for c in cells)],
            "m_range": [min(c["stratum_mod"] for c in cells),
                        max(c["stratum_mod"] for c in cells)],
            "M_range": [min(c["M"] for c in cells), max(c["M"] for c in cells)],
        },
        "cells": cells,
    }


def render(doc):
    head = {k: doc[k] for k in doc if k != "cells"}
    lines = ["{"]
    for k in sorted(head):
        lines.append(f' {json.dumps(k)}: {json.dumps(head[k], sort_keys=True)},')
    lines.append(' "cells": [')
    lines.append(",\n".join(
        "  " + json.dumps(c, sort_keys=True, separators=(",", ":"))
        for c in doc["cells"]
    ))
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
        if open(sys.argv[3]).read() == text:
            print("certificate matches the cache")
        else:
            raise SystemExit("certificate does NOT match the cache")
