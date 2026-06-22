#!/usr/bin/env python3
"""Offline structural study of the deep-tail (pc>=17) entry-probe captures dumped by the queens
solver's M_HITKEY tap (QUEENS_HITKEY=1).

Goal (the user's question): the deep tail is ~99.8% COLD — only ~0.2% of pc>=17 entry probes HIT
(a transposition: the node was already solved and is re-probed warm). Those rare hits are
high-value (each skips a subtree). Can we PREDICT which nodes will be hit using ONLY features
computable from a node's own state at first visit (its available-set / conflict graph) — never the
verdict or the future probe stream? If yes, that predictor drives a pin/prefetch/move-order lever.

Method: compare the feature distribution of the HITs (nodes that DID recur) against a random
sample of MISSes (mostly first-visit/non-recurring). A feature that separates them is a predictor.

Binary format (little-endian), written by IsoFlat::write_hitkey_file:
  header: magic b"QHK1", n (u32), count (u64)
  record (68 bytes): key (4xu64) | avail (4xu64) | pc (u16) | hit (u8) | pad (u8)
`avail` is a board-square bitset: bit r*n+c is set iff square (r,c) is still placeable.

Usage: hitkey_study.py /tmp/qhk-n16.bin [--pv "H8 K6 J9 ..."]
"""
import sys, struct, math
from collections import defaultdict, Counter

REC = 68


def load(path):
    with open(path, "rb") as f:
        data = f.read()
    assert data[:4] == b"QHK1", "bad magic"
    n = struct.unpack_from("<I", data, 4)[0]
    count = struct.unpack_from("<Q", data, 8)[0]
    off = 16
    recs = []
    for _ in range(count):
        key = struct.unpack_from("<4Q", data, off)
        avail = struct.unpack_from("<4Q", data, off + 32)
        pc, hit, _pad = struct.unpack_from("<HBB", data, off + 64)
        off += REC
        recs.append((key, avail, pc, bool(hit)))
    return n, recs


def bits_to_squares(words):
    """List of set bit indices (board square indices) from a 4xu64 bitset."""
    sq = []
    for w_i, w in enumerate(words):
        base = w_i * 64
        while w:
            b = w & -w
            sq.append(base + b.bit_length() - 1)
            w ^= b
    return sq


def squares_to_words(squares):
    w = [0, 0, 0, 0]
    for s in squares:
        w[s >> 6] |= 1 << (s & 63)
    return tuple(w)


def d4_images(squares, n):
    """The 8 dihedral images of a square set on an n x n board, each as a sorted tuple of
    square indices. Square s -> (r,c) = (s//n, s%n); index = r*n + c."""
    out = []
    for t in range(8):
        img = []
        for s in squares:
            r, c = divmod(s, n)
            if t == 0:
                rr, cc = r, c
            elif t == 1:
                rr, cc = c, n - 1 - r        # rot90
            elif t == 2:
                rr, cc = n - 1 - r, n - 1 - c  # rot180
            elif t == 3:
                rr, cc = n - 1 - c, r        # rot270
            elif t == 4:
                rr, cc = r, n - 1 - c        # flip horiz
            elif t == 5:
                rr, cc = n - 1 - r, c        # flip vert
            elif t == 6:
                rr, cc = c, r                # transpose
            else:
                rr, cc = n - 1 - c, n - 1 - r  # anti-transpose
            img.append(rr * n + cc)
        out.append(squares_to_words(img))
    return out


def canon(words, n):
    """Canonical id of a square set: lexicographically-smallest of its 8 D4 word-tuples."""
    squares = bits_to_squares(words)
    return min(d4_images(squares, n))


def attacks(s1, s2, n):
    r1, c1 = divmod(s1, n)
    r2, c2 = divmod(s2, n)
    return r1 == r2 or c1 == c2 or (r1 - c1) == (r2 - c2) or (r1 + c1) == (r2 + c2)


def features(avail, n):
    """Cheating-free conflict-graph features of the available-set (no verdict used)."""
    sq = bits_to_squares(avail)
    m = len(sq)
    # adjacency by queen-attack among available squares
    adj = [0] * m
    edges = 0
    # bucket by row/col/diag/anti to find edges in ~O(m) per line rather than O(m^2)
    # (m can be ~200; O(m^2)=40k per record x millions of records is too slow, so bucket)
    by_row, by_col, by_diag, by_anti = (defaultdict(list) for _ in range(4))
    for i, s in enumerate(sq):
        r, c = divmod(s, n)
        by_row[r].append(i); by_col[c].append(i)
        by_diag[r - c].append(i); by_anti[r + c].append(i)
    nbr = [set() for _ in range(m)]
    for buckets in (by_row, by_col, by_diag, by_anti):
        for group in buckets.values():
            for a in range(len(group)):
                for b in range(a + 1, len(group)):
                    nbr[group[a]].add(group[b]); nbr[group[b]].add(group[a])
    deg = [len(x) for x in nbr]
    edges = sum(deg) // 2
    # connected components
    seen = [False] * m
    comps = 0
    largest = 0
    for i in range(m):
        if seen[i]:
            continue
        comps += 1
        stack = [i]; seen[i] = True; sz = 0
        while stack:
            u = stack.pop(); sz += 1
            for v in nbr[u]:
                if not seen[v]:
                    seen[v] = True; stack.append(v)
        largest = max(largest, sz)
    mean_deg = sum(deg) / m if m else 0
    var = sum((d - mean_deg) ** 2 for d in deg) / m if m else 0
    density = 2 * edges / (m * (m - 1)) if m > 1 else 0
    return {
        "pc": m,
        "edges": edges,
        "comps": comps,
        "largest_comp": largest,
        "mean_deg": mean_deg,
        "max_deg": max(deg) if deg else 0,
        "min_deg": min(deg) if deg else 0,
        "std_deg": math.sqrt(var),
        "density": density,
        "iso_verts": sum(1 for d in deg if d == 0),  # isolated available squares
    }


def summarize(label, vals):
    if not vals:
        print(f"  {label:14} (none)")
        return
    vals = sorted(vals)
    n = len(vals)
    mean = sum(vals) / n
    p = lambda q: vals[min(n - 1, int(q * n))]
    print(f"  {label:14} mean={mean:8.3f}  p10={p(.10):8.3f}  p50={p(.50):8.3f}  "
          f"p90={p(.90):8.3f}  max={vals[-1]:8.3f}")


def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "/tmp/qhk-n16.bin"
    pv_line = None
    if "--pv" in sys.argv:
        pv_line = sys.argv[sys.argv.index("--pv") + 1]
    n, recs = load(path)
    hits = [r for r in recs if r[3]]
    misses = [r for r in recs if not r[3]]
    print(f"n={n}  records={len(recs)}  hits={len(hits)}  sampled_misses={len(misses)}")
    print(f"(sampled-miss count x64 ~= {len(misses)*64:,} true misses; "
          f"hit-rate ~= {len(hits)/(len(hits)+len(misses)*64):.4%})")

    # Recurrence: the solver's captured `key` is already the canonical (D4-merged) identity, so
    # grouping hits by `key` collapses re-probes of one node with no offline canonicalization.
    hit_key = Counter(r[0] for r in hits)
    distinct_hit_nodes = len(hit_key)
    multiplicity = Counter(hit_key.values())
    print(f"\nrecurrence (hits grouped by canonical key):")
    print(f"  distinct hit-nodes = {distinct_hit_nodes:,}  "
          f"(mean re-probes/node among hit set = {len(hits)/distinct_hit_nodes:.2f})")
    for mult in sorted(multiplicity)[:8]:
        print(f"    seen {mult}x in hit stream : {multiplicity[mult]:,} nodes")
    print(f"    max re-probes of one node = {max(multiplicity)}")

    # Feature comparison: hits vs a capped miss sample (features are O(pc^2)-ish, cap for speed).
    CAP = 40000
    hsamp = hits[:CAP]
    msamp = misses[:CAP]
    hf = [features(r[1], n) for r in hsamp]
    mf = [features(r[1], n) for r in msamp]
    keys = ["pc", "comps", "largest_comp", "edges", "mean_deg", "max_deg",
            "std_deg", "density", "iso_verts"]
    print(f"\nfeature distributions (hit sample={len(hf)}, miss sample={len(mf)}):")
    for k in keys:
        print(f" [{k}]")
        summarize("HIT", [f[k] for f in hf])
        summarize("MISS", [f[k] for f in mf])

    # pc distribution of hits vs misses (already have pc per record cheaply).
    print("\npc histogram (hit% by pc band = local hit propensity):")
    hpc = Counter(r[2] for r in hits)
    mpc = Counter(r[2] for r in misses)
    for pc in sorted(set(hpc) | set(mpc)):
        h = hpc.get(pc, 0); mm = mpc.get(pc, 0) * 64
        tot = h + mm
        if tot < 1000:
            continue
        print(f"  pc={pc:3}  hits={h:8,}  ~misses={mm:11,}  hit%={h/tot:.3%}")

    # PV overlap: are the optimal-line nodes among the recurring hits? Build the set of all hit
    # avail-tuples (the search's orientation at each hit); a PV node (in real orientation) matches
    # iff one of its 8 D4-images equals a stored hit avail. No canonicalization of the 881k hits.
    if pv_line:
        moves = pv_line.split()
        hit_avail_set = set(r[1] for r in hits)
        miss_avail_set = set(r[1] for r in misses)

        def sqidx(name):
            col = ord(name[0].upper()) - ord('A')
            row = int(name[1:]) - 1
            return row * n + col

        placed = []
        all_sq = list(range(n * n))
        print(f"\nPV overlap ({len(moves)} moves):")
        for mi, mv in enumerate(moves):
            placed.append(sqidx(mv))
            avail = [q for q in all_sq
                     if q not in placed and not any(attacks(q, p, n) for p in placed)]
            pc = len(avail)
            if pc < 17:
                print(f"  after move {mi+1} ({mv}): pc={pc:3}  (below pc17 capture floor)")
                continue
            imgs = set(d4_images(avail, n))
            in_hits = bool(imgs & hit_avail_set)
            in_miss = bool(imgs & miss_avail_set)
            tag = "IN HIT SET" if in_hits else ("in miss-sample" if in_miss else "not captured")
            print(f"  after move {mi+1} ({mv}): pc={pc:3}  {tag}")


if __name__ == "__main__":
    main()
