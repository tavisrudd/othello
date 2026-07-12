#!/usr/bin/env python3
"""C77: test complete affine mirror strategies for balanced pencil roots.

Grid-cap legality is preserved by independent affine row/column maps and by
their compositions with coordinate swap.  A simple affine pairing strategy
must at least stabilize the S4 root, have no fixed legal move, and make every
initial response pair root+x+g(x) legal.  This probe tests those necessary
root-safety conditions.  A survivor would still need a deeper interference
audit before it became a full-depth pairing proof.

This probe is value-blind while constructing candidates.  Exact P/N labels are
joined only for the final control table.
"""
from collections import Counter
import argparse
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from c73_secant_algebra import DATA, PRIME_FILES, analyze, parse  # noqa: E402
from c77_intruder_reply_graph import legal_moves  # noqa: E402
from c77_pencil_value_probe import legal_after, rows_for  # noqa: E402


def apply_transform(q, transform, cell):
    swap, a, b, d, e = transform
    r, c = cell
    if swap:
        r, c = c, r
    return ((a * r + b) % q, (d * c + e) % q)


def is_involution(q, transform):
    probes = ((0, 0), (1, 0), (0, 1))
    return all(apply_transform(q, transform, apply_transform(q, transform, z)) == z
               for z in probes)


def transformations(q):
    for swap in (False, True):
        for a in range(1, q):
            for b in range(q):
                for d in range(1, q):
                    for e in range(q):
                        transform = (swap, a, b, d, e)
                        if is_involution(q, transform):
                            yield transform


def root_safe_mirrors_for(q, root, transforms):
    root_set = set(root)
    legal = legal_moves(q, root)
    out = []
    for transform in transforms:
        if {apply_transform(q, transform, z) for z in root} != root_set:
            continue
        if any(apply_transform(q, transform, z) == z for z in legal):
            continue
        if any(not legal_after(q, list(root) + [z],
                               apply_transform(q, transform, z))
               for z in legal):
            continue
        out.append(transform)
    return out


def run(q, details=False):
    recs = analyze(q, parse(os.path.join(DATA, PRIME_FILES[q])))
    rows, pencils = rows_for(q)
    del rows
    roots = {}
    for _q0, cls, _key, d, pencil in pencils:
        target = tuple(sorted((d, 5, 5, 6, 6)))
        for row in pencil:
            key = (cls, row["cell"])
            datum = roots.setdefault(key, {"value": row["value"], "balanced": False})
            assert datum["value"] == row["value"]
            datum["balanced"] |= row["spoke_defects"] == target

    transforms = list(transformations(q))
    hist = Counter()
    failures = []
    false_positive = []
    for (cls, cell), datum in sorted(roots.items()):
        root = tuple(recs[cls]["S3"] + [cell])
        mirrors = root_safe_mirrors_for(q, root, transforms)
        tag = (datum["balanced"], datum["value"], bool(mirrors))
        hist[tag] += 1
        if datum["balanced"] and not mirrors:
            failures.append((cls, cell))
        if datum["value"] == "N" and mirrors:
            false_positive.append((cls, cell, mirrors[0]))
        if details and (datum["balanced"] or mirrors):
            print(
                f"BALANCED-MIRROR-ROOT q={q} cls={cls} cell={cell} "
                f"balanced={int(datum['balanced'])} value={datum['value']} "
                f"mirrors={len(mirrors)} examples={mirrors[:3]}"
            )
    print(
        f"BALANCED-MIRROR q={q} involutions={len(transforms)} "
        f"hist={dict(sorted(hist.items()))} failures={failures[:10]} "
        f"false-positive={false_positive[:10]}"
    )
    assert not false_positive
    return failures


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="*", default=[11])
    ap.add_argument("--details", action="store_true")
    args = ap.parse_args()
    for q in args.q:
        run(q, args.details)
