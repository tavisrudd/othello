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


def affine_normalize(x, x0, x1, q):
    """The unique affine map taking x0 to 0 and x1 to 1 (prime q)."""
    return (x - x0) * pow((x1 - x0) % q, -1, q) % q


def canonical_root(q, root):
    """Canonical S4 representative under the full prime-field grid group."""
    forms = []
    for swap in (False, True):
        points = tuple((c, r) if swap else (r, c) for r, c in root)
        for p0 in points:
            for p1 in points:
                if p0[0] == p1[0]:
                    continue
                for z0 in points:
                    for z1 in points:
                        if z0[1] == z1[1]:
                            continue
                        forms.append(tuple(sorted(
                            (affine_normalize(r, p0[0], p1[0], q),
                             affine_normalize(c, z0[1], z1[1], q))
                            for r, c in points
                        )))
    return min(forms)


def residual_signature(q, root):
    """Coarse invariant of the capacity-1 graph and surviving triple lines."""
    vertices = legal_moves(q, root)
    adj = {z: set() for z in vertices}
    for i, x in enumerate(vertices):
        for y in vertices[i + 1:]:
            pair_conflict = x[0] == y[0] or x[1] == y[1]
            pair_conflict |= any(
                ((x[0] - s[0]) * (y[1] - s[1])
                 - (x[1] - s[1]) * (y[0] - s[0])) % q == 0
                for s in root
            )
            if pair_conflict:
                adj[x].add(y)
                adj[y].add(x)

    unseen = set(vertices)
    components = []
    while unseen:
        todo = [unseen.pop()]
        size = 0
        while todo:
            x = todo.pop()
            size += 1
            fresh = adj[x] & unseen
            unseen -= fresh
            todo.extend(fresh)
        components.append(size)

    # Horizontal/vertical lines already have residual capacity zero because of
    # the two burned direction points.  The remaining slope lines with no root
    # point retain capacity two and contribute genuine triple constraints.
    triple_loads = []
    for slope in range(1, q):
        root_intercepts = {(c - slope * r) % q for r, c in root}
        loads = Counter((c - slope * r) % q for r, c in vertices)
        triple_loads.extend(
            load for intercept, load in loads.items()
            if intercept not in root_intercepts and load >= 3
        )
    return (
        len(vertices),
        sum(map(len, adj.values())) // 2,
        tuple(sorted(Counter(map(len, adj.values())).items())),
        tuple(sorted(components)),
        tuple(sorted(Counter(triple_loads).items())),
    )


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


def run(q, details=False, root_orbits=False, residual_signatures=False):
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

    if root_orbits:
        orbits = {}
        for (cls, cell), datum in sorted(roots.items()):
            root = tuple(recs[cls]["S3"] + [cell])
            canon = canonical_root(q, root)
            orbit = orbits.setdefault(canon, Counter())
            orbit[(datum["balanced"], datum["value"])] += 1
        balanced = [
            (canon, hist) for canon, hist in orbits.items()
            if any(flag for flag, _value in hist)
        ]
        print(
            f"BALANCED-ROOT-ORBITS q={q} roots={len(roots)} "
            f"orbits={len(orbits)} balanced-orbits={len(balanced)}"
        )
        for i, (canon, hist) in enumerate(sorted(balanced)):
            print(f"BALANCED-ROOT-ORBIT q={q} i={i} hist={dict(hist)} canon={canon}")
        return balanced

    if residual_signatures:
        signatures = Counter()
        examples = {}
        seen = set()
        for (cls, cell), datum in sorted(roots.items()):
            if not datum["balanced"]:
                continue
            root = tuple(recs[cls]["S3"] + [cell])
            canon = canonical_root(q, root)
            if canon in seen:
                continue
            seen.add(canon)
            signature = residual_signature(q, root)
            signatures[signature] += 1
            examples.setdefault(signature, canon)
        print(
            f"BALANCED-RESIDUAL q={q} root-orbits={len(seen)} "
            f"coarse-signatures={len(signatures)}"
        )
        for i, (signature, count) in enumerate(sorted(signatures.items())):
            print(
                f"BALANCED-RESIDUAL-SIGNATURE q={q} i={i} count={count} "
                f"signature={signature} example={examples[signature]}"
            )
        return signatures

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
    ap.add_argument("--root-orbits", action="store_true")
    ap.add_argument("--residual-signatures", action="store_true")
    args = ap.parse_args()
    for q in args.q:
        run(q, args.details, args.root_orbits, args.residual_signatures)
