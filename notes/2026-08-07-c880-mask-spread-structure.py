#!/usr/bin/env python3
"""C880: what the difference masks are, and why the exact bound is 30.

The integer program of `2026-08-07-c880-mask-ilp.py` returns 30 at seven and at
eight points.  This script checks the structural reason, which needs no search.

Write a *split* for an unordered partition of the eight points into two
four-sets.  There are 35 of them.  Two splits {A,A'} and {B,B'} either cross
evenly, |A n B| = 2, or unevenly, |A n B| in {1,3}.

  (1) At eight points, every weight-four difference mask is the set of four
      four-sets of two evenly crossing splits, and every such pair of splits
      occurs.  There are 35 * 18 / 2 = 315 of them, one for each edge of the
      even-crossing graph, which is 18-regular.

  (2) At seven points, adjoining an eighth point to the complement identifies
      the 35 four-subsets of the seven-set with the 35 splits, and under that
      identification the 315 weight-two masks are the same 315 pairs of splits.
      The two point sizes therefore carry one and the same constraint family.

  (3) A family of tests hits every mask exactly when the splits none of whose
      two four-sets is chosen are pairwise unevenly crossing.  Even crossing is
      perpendicularity for the quadratic form q(X) = |X|/2 mod 2 on the even
      subsets modulo complement -- a hyperbolic quadric in PG(5,2) whose
      singular points are the 35 splits -- so an unevenly crossing family is a
      set of pairwise non-perpendicular singular points, which the Klein
      correspondence carries to pairwise skew lines of PG(3,2).  Five disjoint
      three-point lines already fill the 15 points of PG(3,2), so there are at
      most five, and a spread attains five.  Hence at least 35 - 5 = 30 splits
      are touched and each costs a test:  minimum hitting set = 30.

Every step above is checked here on the committed mask certificates, including
the maximum independent set by exhaustive search over the 35 splits.

Usage:
    uv run --with numpy python3 2026-08-07-c880-mask-spread-structure.py \
        --masks7 masks7w2.json --masks8 masks8w4.json --out structure.json
"""

import argparse
import itertools
import json
import sys


def load(path, artifact="c880-difference-masks"):
    with open(path) as fh:
        cert = json.load(fh)
    if cert.get("artifact") != artifact:
        raise SystemExit(f"{path}: not a difference-mask certificate")
    fs = [tuple(f) for f in cert["foursets"]]
    masks = [frozenset(r["tests"]) for r in cert["masks"]]
    return cert["n"], fs, masks


def splits(n=8):
    """The 35 partitions of {0..7} into two four-sets, keyed by the half of 0."""
    return [frozenset(s) for s in itertools.combinations(range(n), 4) if 0 in s]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--masks7", required=True)
    ap.add_argument("--masks8", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    n8, fs8, masks8 = load(args.masks8)
    n7, fs7, masks7 = load(args.masks7)
    if (n8, n7) != (8, 7):
        raise SystemExit("expected the eight-point and seven-point certificates")

    sp = splits()
    all8 = frozenset(range(8))
    # tests of a split: the four-set containing 0 and its complement
    index8 = {frozenset(f): k for k, f in enumerate(fs8)}
    split_tests = {s: frozenset({index8[s], index8[all8 - s]}) for s in sp}

    # (1) the eight-point masks are exactly the evenly crossing pairs of splits
    even_pairs = [
        (a, b) for a, b in itertools.combinations(sp, 2) if len(a & b) == 2
    ]
    from_splits = {split_tests[a] | split_tests[b] for a, b in even_pairs}
    ok_masks8 = from_splits == set(masks8)

    degrees = {
        sum(1 for b in sp if b != a and len(a & b) == 2) for a in sp
    }

    # (2) the seven-point masks are the same family, under X -> {X, X' u {oo}}
    #     with the seven points relabelled 1..7 and the eighth point 0
    index7 = {frozenset(f): k for k, f in enumerate(fs7)}
    lift = {}
    for f in fs7:  # f is a four-subset of {0..6}; relabel to {1..7}
        x = frozenset(p + 1 for p in f)
        s = x if 0 in x else all8 - x
        lift[index7[frozenset(f)]] = s
    if len(set(lift.values())) != 35:
        raise SystemExit("the seven-to-eight point map is not a bijection")
    lifted7 = {
        frozenset().union(*[split_tests[lift[t]] for t in m]) for m in masks7
    }
    ok_masks7 = lifted7 == set(masks8)

    # (3) maximum set of pairwise unevenly crossing splits, exhaustively
    best = []

    def grow(chosen, cand):
        nonlocal best
        if len(chosen) > len(best):
            best = list(chosen)
        for i, s in enumerate(cand):
            grow(chosen + [s], [t for t in cand[i + 1:] if len(s & t) != 2])

    grow([], sp)
    alpha = len(best)

    # every maximum family, to be compared with the 56 optimal seven-point
    # separating families of the predecessor report
    maxima = []

    def collect(chosen, cand):
        if len(chosen) == alpha:
            maxima.append(frozenset(chosen))
            return
        if len(chosen) + len(cand) < alpha:
            return
        for i, s in enumerate(cand):
            collect(chosen + [s], [t for t in cand[i + 1:] if len(s & t) != 2])

    collect([], sp)

    # orbits of the maximum families under the stabiliser of the eighth point,
    # which is the seven-point symmetry group of the predecessor report
    def act(perm, family):
        out = []
        for s in family:
            t = frozenset(perm[p] for p in s)
            out.append(t if 0 in t else all8 - t)
        return frozenset(out)

    seen, orbits = set(), []
    perms = [
        dict(zip(range(1, 8), p)) | {0: 0}
        for p in itertools.permutations(range(1, 8))
    ]
    for f in maxima:
        if f in seen:
            continue
        orbit = {act(p, f) for p in perms}
        seen |= orbit
        orbits.append(len(orbit))
    orbits.sort()
    # a maximum family is a spread: its 5 splits use each point evenly and are
    # pairwise unevenly crossing
    spread_ok = all(len(a & b) != 2 for a, b in itertools.combinations(best, 2))

    doc = {
        "artifact": "c880-mask-spread-structure",
        "schema": 1,
        "splits": len(sp),
        "even_crossing_pairs": len(even_pairs),
        "even_crossing_degrees": sorted(degrees),
        "eight_point_masks_are_split_pairs": ok_masks8,
        "seven_point_masks_lift_to_the_same_family": ok_masks7,
        "max_unevenly_crossing_family": alpha,
        "maximum_families": len(maxima),
        "maximum_family_orbit_sizes_under_the_point_stabiliser": orbits,
        "max_family_is_pairwise_uneven": spread_ok,
        "max_family": [sorted(s) for s in best],
        "minimum_hitting_set_from_structure": len(sp) - alpha,
    }
    if not (ok_masks8 and ok_masks7 and spread_ok):
        raise SystemExit("structural identification failed: " + json.dumps(doc))
    with open(args.out, "w") as fh:
        json.dump(doc, fh, sort_keys=True)
        fh.write("\n")
    print(json.dumps(doc, sort_keys=True), file=sys.stderr)


if __name__ == "__main__":
    main()
