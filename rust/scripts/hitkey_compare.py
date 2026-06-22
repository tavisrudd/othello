#!/usr/bin/env python3
"""Compare two M_HITKEY captures (large-TT baseline vs small-TT) to size the eviction prize:
how many shoulder-band (pc ~35-78) transpositions a tight TT destroys that a pc-banded
keep/pin policy could recover.

At a large TT (~no eviction) the by-pc hit% is the TRUE transposition rate (the ceiling).
At a small TT, evicted entries miss on re-probe -> the shoulder hit% drops and the node
re-expands. The hit% gap x the band's probe volume = the recurrences eviction killed.

Usage: hitkey_compare.py <big.bin> <small.bin>
"""
import sys, struct
from collections import Counter

REC = 68
MISS_SAMPLE = 64  # solver kept 1/MISS_SAMPLE misses


def load_pc(path):
    with open(path, "rb") as f:
        data = f.read()
    assert data[:4] == b"QHK1"
    count = struct.unpack_from("<Q", data, 8)[0]
    hpc, mpc = Counter(), Counter()
    off = 16
    for _ in range(count):
        pc, hit, _ = struct.unpack_from("<HBB", data, off + 64)
        off += REC
        if hit:
            hpc[pc] += 1
        else:
            mpc[pc] += 1
    return hpc, mpc


def band(hpc, mpc, lo, hi):
    h = sum(hpc.get(pc, 0) for pc in range(lo, hi + 1))
    m = sum(mpc.get(pc, 0) for pc in range(lo, hi + 1)) * MISS_SAMPLE
    return h, m


def main():
    big, small = sys.argv[1], sys.argv[2]
    bh, bm = load_pc(big)
    sh, sm = load_pc(small)
    print(f"{'pc':>4} | {'BIG hit%':>9} {'BIG probes':>13} | {'SMALL hit%':>10} "
          f"{'SMALL probes':>13} | {'hit% drop':>9}")
    print("-" * 78)
    bands = [(17, 24, "cold bulk"), (25, 34, "rise"), (35, 50, "shoulder-1"),
             (51, 63, "valley"), (64, 78, "shoulder-2"), (79, 300, "near-root")]
    tot_lost = 0
    for lo, hi, name in bands:
        bhh, bmm = band(bh, bm, lo, hi)
        shh, smm = band(sh, sm, lo, hi)
        bp, sp = bhh + bmm, shh + smm
        brate = bhh / bp if bp else 0
        srate = shh / sp if sp else 0
        # recurrences eviction destroyed in this band: at the big-TT rate, the small-TT
        # probe volume would have yielded brate*sp hits; it only got shh. The shortfall is
        # the extra re-expansions a keep-policy could recover (approx; sp itself grew from
        # eviction, so this is a within-band lower bound on the prize).
        lost = max(0.0, brate * sp - shh)
        tot_lost += lost
        print(f"{lo:>2}-{hi:<2}| {brate:>8.3%} {bp:>13,} | {srate:>9.3%} {sp:>13,} | "
              f"{brate - srate:>+8.3%}  [{name}] ~lost={lost:,.0f}")
    print("-" * 78)
    # total nodes proxy = total probes (one entry probe per expanded node).
    big_probes = sum(bh.values()) + sum(bm.values()) * MISS_SAMPLE
    small_probes = sum(sh.values()) + sum(sm.values()) * MISS_SAMPLE
    print(f"total probes (~nodes): BIG {big_probes:,}  SMALL {small_probes:,}  "
          f"(+{small_probes - big_probes:,} = +{small_probes/big_probes-1:.1%})")
    print(f"approx shoulder recurrences eviction destroyed: ~{tot_lost:,.0f}")


if __name__ == "__main__":
    main()
