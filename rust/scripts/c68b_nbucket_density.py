#!/usr/bin/env python3
"""C68 follow-on (A5 lane) — N-bucket density nu(q) and the min-witness suppression.

C68 measured D(q) and min-witness per size-3 CLASS. This measures the GLOBAL on-conic
S4 bucket structure that drives them:

  nu(q) = state-weighted fraction of on-conic S4 states that are N-valued,
          weighting each PGL bucket by its fiber = the number of raw 4-subset
          completions {t1,t2,t3,t4} that canonicalize into it (sizes sum to C(q-1,4)).

Input: `s4arena <q> --all` bucket censuses (S4ARENA-BUCKET lines: idx, size, rep, value).

Then compares min-witness (from C68 feat data) against a random null model: if a size-3
class's q-4 on-conic completions landed in P/N buckets independently with P(N)=nu(q), how
many classes would be fully-N (min-witness 0)? The gap between the null prediction and the
observed 0 fully-N classes measures how hard the conic geometry works to keep min-witness >= 1.
"""

import re
from math import comb
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
DATA = REPO / "notes" / "data"

BUCKET_RE = re.compile(r"S4ARENA-BUCKET q=(\d+) idx=(\d+) size=(\d+) .* value=([PN-]) ")

# C68 per-class results (from scripts/c68_depletion_fraction.py): onP orbit-types per q.
# (onP value -> #classes with that onP). min-witness = min onP.
C68_ONP_TYPES = {
    5:  {1: 1},
    7:  {3: 3},
    9:  {5: 5},
    11: {2: 2, 5: 6},
    13: {9: 12},
    17: {1: 3, 3: 18},
    19: {15: 27},
}


def parse_buckets(q):
    f = DATA / f"c68b-onconic-buckets-q{q}.txt"
    rows = []
    for line in f.read_text().splitlines():
        m = BUCKET_RE.search(line)
        if m and int(m.group(1)) == q:
            rows.append({"idx": int(m.group(2)), "size": int(m.group(3)), "val": m.group(4)})
    return rows


def main():
    qs = [5, 7, 9, 11, 13, 17, 19]
    print("=" * 92)
    print("C68 follow-on — on-conic S4 bucket structure and the min-witness suppression")
    print("=" * 92)
    hdr = (f"{'q':>3} {'buckets':>7} {'#P':>3} {'#N':>3} "
           f"{'configs':>8} {'N-configs':>9} {'nu(q)':>7} "
           f"{'#cls':>5} {'onP-types':>12} {'min-wit':>7} "
           f"{'null E[fullyN]':>13} {'obs fullyN':>10}")
    print(hdr)
    print("-" * len(hdr))
    seq = []
    for q in qs:
        rows = parse_buckets(q)
        nb = len(rows)
        nP = sum(1 for r in rows if r["val"] == "P")
        nN = sum(1 for r in rows if r["val"] == "N")
        total = sum(r["size"] for r in rows)
        nconf = sum(r["size"] for r in rows if r["val"] == "N")
        nu = nconf / total if total else 0.0
        onp = C68_ONP_TYPES[q]
        ncls = sum(onp.values())
        min_wit = min(onp)
        # null model: each of a class's (q-4) completions is N indep. w.p. nu.
        # P(class fully N) = nu^(q-4). Expected fully-N classes = ncls * nu^(q-4).
        k = q - 4
        null_fullyN = ncls * (nu ** k)
        obs_fullyN = onp.get(0, 0)
        seq.append((q, nu, min_wit, null_fullyN))
        onp_str = ",".join(f"{v}x{onp[v]}" for v in sorted(onp))  # onP value x #classes
        print(f"{q:>3} {nb:>7} {nP:>3} {nN:>3} {total:>8} {nconf:>9} {nu:>7.3f} "
              f"{ncls:>5} {onp_str:>12} {min_wit:>7} {null_fullyN:>13.3f} {obs_fullyN:>10}")
    print()
    print("nu(q) sequence (orbit-weighted N-bucket density):")
    for q, nu, mw, nf in seq:
        tag = "  DEPLETED" if nu > 0 else ""
        print(f"  q={q:>2}  nu={nu:.4f}  min-witness={mw}  null E[fully-N classes]={nf:.3f}{tag}")
    print()
    print("Reading: nu(q)=0 at every non-depleted order; positive & ~doubling across the two")
    print("depleted orders (q=11 -> q=17). At q=17 the random null predicts ~1 fully-N class")
    print("(min-witness 0); the geometry delivers 0 — a MARGINAL suppression, not a robust bound.")


if __name__ == "__main__":
    main()
