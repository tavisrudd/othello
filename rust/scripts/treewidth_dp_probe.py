#!/usr/bin/env python3
"""Tier-C2 go/no-go: does a treewidth/separator DP beat the subtree it replaces?

Premise already CONFIRMED (n14+n16: deep-tail Node-Kayles graphs are tree-like, min-fill
treewidth ~7-10 at the high-mass pc18-22 bands). This probe answers the *constant-factor* risk:

  For each sampled deep-tail graph G (from a QUEENS_HITKEY dump), compare
    (A) the SUBTREE the DP would replace = distinct positions a memoized alpha-beta search
        visits below G (the search's own work, with cutoffs + exact-availset transposition merge), and
    (B) the DP COST upper bound = s^(w+1) for a width-w tree-decomposition DP, s = per-vertex states.

  Any correct treewidth DP for Node-Kayles costs <= s^(w+1) * poly.  If (A) >> s^(w+1) for the
  bulk of tail graphs, the lever is GO regardless of which exact DP we build.  If (A) <~ s^(w+1),
  the search already merges as well as the DP could -> no win.

Node-Kayles move semantics (queen game = Node-Kayles on the queen-attack graph): pick an available
vertex v, remove its CLOSED neighborhood N[v]; last player to move wins (normal play).

Usage: tw_dp_probe.py /tmp/qhk-n14.bin [--cap 4000000] [--sample 4000] [--selftest]
"""
import sys, struct, math, random
from collections import defaultdict

REC = 68

# ---------------------------------------------------------------- dump loader
def load(path):
    with open(path, "rb") as f:
        data = f.read()
    assert data[:4] == b"QHK1", "bad magic"
    n = struct.unpack_from("<I", data, 4)[0]
    count = struct.unpack_from("<Q", data, 8)[0]
    off, recs = 16, []
    for _ in range(count):
        key = struct.unpack_from("<4Q", data, off)
        avail = struct.unpack_from("<4Q", data, off + 32)
        pc, hit, _pad = struct.unpack_from("<HBB", data, off + 64)
        off += REC
        recs.append((key, avail, pc, bool(hit)))
    return n, recs

def bits_to_squares(words):
    sq = []
    for w_i, w in enumerate(words):
        base = w_i * 64
        while w:
            b = w & -w
            sq.append(base + b.bit_length() - 1)
            w ^= b
    return sq

# ---------------------------------------------------------------- graph build
def build_graph(avail, n):
    """Return adjacency as a list of int bitmasks over LOCAL vertex indices [0..m).
    Edge between two available squares iff they attack as queens (same row/col/diag/anti)."""
    sq = bits_to_squares(avail)
    m = len(sq)
    by_row, by_col, by_diag, by_anti = (defaultdict(list) for _ in range(4))
    for i, s in enumerate(sq):
        r, c = divmod(s, n)
        by_row[r].append(i); by_col[c].append(i)
        by_diag[r - c].append(i); by_anti[r + c].append(i)
    adj = [0] * m
    for buckets in (by_row, by_col, by_diag, by_anti):
        for group in buckets.values():
            mask = 0
            for i in group:
                mask |= (1 << i)
            for i in group:
                adj[i] |= mask & ~(1 << i)
    return m, adj

# ---------------------------------------------------------------- min-fill treewidth upper bound
def treewidth_minfill(m, adj):
    """Min-fill elimination -> (treewidth upper bound, elimination ordering).
    Operates on a copy of the adjacency; eliminates the vertex whose elimination adds the fewest
    fill edges, tie-broken by current degree.  Returns max bag size - 1 over the run."""
    nb = [set() for _ in range(m)]
    for i in range(m):
        a = adj[i]
        while a:
            b = a & -a; nb[i].add(b.bit_length() - 1); a ^= b
    alive = set(range(m))
    order = []
    width = 0
    while alive:
        # pick min-fill vertex
        best, best_fill, best_deg = None, None, None
        for v in alive:
            ns = nb[v]
            d = len(ns)
            # fill = non-adjacent pairs among neighbors
            fill = 0
            nslist = list(ns)
            for ai in range(len(nslist)):
                a = nslist[ai]; na = nb[a]
                for bi in range(ai + 1, len(nslist)):
                    if nslist[bi] not in na:
                        fill += 1
            if best is None or (fill, d) < (best_fill, best_deg):
                best, best_fill, best_deg = v, fill, d
        v = best
        ns = nb[v]
        width = max(width, len(ns))         # bag = v + its current neighbors; treewidth = bag-1 = len(ns)
        # make neighbors a clique, remove v
        nslist = list(ns)
        for a in nslist:
            nb[a].discard(v)
            nb[a].update(x for x in ns if x != a)
        alive.discard(v); order.append(v)
    return width, order

# ---------------------------------------------------------------- Node-Kayles solver (ground truth)
def nk_solve(m, adj, cap, nimber_thresh=60_000):
    """Memoized Node-Kayles over the available-set bitmask.
    Returns (win, nimber, n_full, n_ab, ab_overflow, g_skip) where
      win    = first player wins from the full graph (normal play)
      nimber = Grundy value of the full graph (None if not computed / capped)
      n_full = distinct positions visited computing the FULL nimber (None if skipped)
      n_ab   = distinct positions visited by alpha-beta win/loss (with cutoff) = subtree-it-replaces
    The alpha-beta pass is the load-bearing metric (the subtree the DP replaces) and is always run,
    capped at `cap`.  The full-nimber pass (expensive, no cutoff) is only run as a validation when the
    alpha-beta subtree is small (<= nimber_thresh) so the run stays fast on the big tail graphs."""
    full = (1 << m) - 1
    closed = [adj[i] | (1 << i) for i in range(m)]   # N[v]

    # ---- alpha-beta win/loss, count distinct positions (the search's real work) ----
    ab_memo = {}
    ab_overflow = [False]
    sys.setrecursionlimit(1 << 20)
    def winloss(A):
        if A == 0:
            return False                     # no move -> player to move loses
        v = ab_memo.get(A)
        if v is not None:
            return v
        if len(ab_memo) >= cap:
            ab_overflow[0] = True
            return False
        res = False
        rem = A
        while rem:
            b = rem & -rem; rem ^= b
            i = b.bit_length() - 1
            child = A & ~closed[i]
            if not winloss(child):           # child is a loss for opponent -> we win; cutoff
                res = True
                break
        ab_memo[A] = res
        return res
    win = winloss(full)
    n_ab = len(ab_memo) if not ab_overflow[0] else cap

    # ---- full nimber (no cutoff): only as a cheap validation on small graphs ----
    nimber, n_full = None, None
    if not ab_overflow[0] and n_ab <= nimber_thresh:
        g_memo = {}
        def grundy(A):
            if A == 0:
                return 0
            v = g_memo.get(A)
            if v is not None:
                return v
            s = set()
            rem = A
            while rem:
                b = rem & -rem; rem ^= b
                i = b.bit_length() - 1
                s.add(grundy(A & ~closed[i]))
            g = 0
            while g in s:
                g += 1
            g_memo[A] = g
            return g
        nimber = grundy(full)
        n_full = len(g_memo)
    return win, nimber, n_full, n_ab, ab_overflow[0], (nimber is None)

# ---------------------------------------------------------------- self-test
def selftest():
    def g_of(adj):
        m = len(adj)
        return nk_solve(m, adj, 1 << 24)
    # single vertex K1: nimber 1 (win)
    assert g_of([0])[1] == 1
    # single edge K2: one move clears both -> nimber 1 (win)
    assert g_of([0b10, 0b01])[1] == 1
    # two isolated: K1+K1 -> 1 xor 1 = 0 (second player wins)
    assert g_of([0, 0])[1] == 0
    # three isolated: 1 xor 1 xor 1 = 1
    assert g_of([0, 0, 0])[1] == 1
    # path P3 a-b-c: moves: play b -> empty (0); play a -> removes a,b leaves c (G=1); play c -> leaves a (1).
    #   options {0,1,1} -> mex = 2
    P3 = [0b010, 0b101, 0b010]
    assert g_of(P3)[1] == 2, g_of(P3)[1]
    # triangle K3: any move clears all -> options {0} -> mex 1
    K3 = [0b110, 0b101, 0b011]
    assert g_of(K3)[1] == 1
    # Node-Kayles on a path P_n = Dawson's Chess (octal .137): Grundy seq 0,1,1,2,0,3,...
    P4 = [0b0010, 0b0101, 0b1010, 0b0100]
    assert g_of(P4)[1] == 0, g_of(P4)[1]            # G(P4)=0
    P5 = [0b00010, 0b00101, 0b01010, 0b10100, 0b01000]
    assert g_of(P5)[1] == 3, g_of(P5)[1]            # G(P5)=3
    # cross-check alpha-beta win == (nimber!=0) on a batch of random graphs
    rnd = random.Random(12345)
    for _ in range(300):
        k = rnd.randint(1, 11)
        adj = [0] * k
        for i in range(k):
            for j in range(i + 1, k):
                if rnd.random() < 0.35:
                    adj[i] |= 1 << j; adj[j] |= 1 << i
        win, nim, nf, nab, *_ = g_of(adj)
        assert win == (nim != 0), (adj, win, nim)
    print("selftest OK (nimbers + alpha-beta/nimber agreement on 300 random graphs)")

# ---------------------------------------------------------------- main
def main():
    args = sys.argv[1:]
    if "--selftest" in args:
        selftest()
        if len(args) == 1:
            return
        args = [a for a in args if a != "--selftest"]
    path = args[0] if args else "/tmp/qhk-n14.bin"
    cap = int(args[args.index("--cap") + 1]) if "--cap" in args else 4_000_000
    sample = int(args[args.index("--sample") + 1]) if "--sample" in args else 3000

    n, recs = load(path)
    # unique graphs by avail tuple, restrict to the mass tail pc18..28 (and a bit around)
    seen = set()
    pool = []
    for key, avail, pc, hit in recs:
        if avail in seen:
            continue
        seen.add(avail)
        pool.append((avail, pc))
    rnd = random.Random(999)
    rnd.shuffle(pool)
    # bucket sample evenly across pc bands so deep bands are represented
    bands = defaultdict(list)
    for avail, pc in pool:
        bands[pc].append(avail)
    chosen = []
    per_band = max(1, sample // max(1, len(bands)))
    for pc in sorted(bands):
        for avail in bands[pc][:per_band]:
            chosen.append((avail, pc))
    print(f"n={n} records={len(recs)} unique_graphs={len(pool)} sampled={len(chosen)} cap={cap:,}")
    print(f"{'pc':>3} {'tw':>3} {'nimber':>6} {'win':>3} {'subtree(n_ab)':>14} {'n_full':>10} "
          f"{'2^w':>10} {'3^w':>12} {'ratio_ab/3^w':>12}")
    # per-band aggregates
    band_stats = defaultdict(lambda: {"tw": [], "nab": [], "r3": [], "capped": 0, "cnt": 0})
    done = 0
    for avail, pc in chosen:
        m, adj = build_graph(avail, n)
        w, _order = treewidth_minfill(m, adj)
        win, nimber, n_full, n_ab, ab_of, nim_skip = nk_solve(m, adj, cap)
        c3 = 3 ** (w + 1)
        c2 = 2 ** (w + 1)
        ratio = n_ab / c3 if c3 else 0
        st = band_stats[pc]
        st["tw"].append(w); st["cnt"] += 1
        st["nab"].append(n_ab); st["r3"].append(ratio)   # n_ab is the cap sentinel when overflowed -> conservative
        if ab_of:
            st["capped"] += 1
        nb = str(nimber) if nimber is not None else "-"
        nabs = f">{cap:,}" if ab_of else f"{n_ab:,}"
        nfs = f"{n_full:,}" if n_full is not None else "-"
        print(f"{pc:>3} {w:>3} {nb:>6} {('Y' if win else '.'):>3} {nabs:>14} "
              f"{nfs:>10} {c2:>10,} {c3:>12,} {ratio:>12.1f}", flush=True)
        done += 1

    def med(xs):
        if not xs: return float('nan')
        xs = sorted(xs); return xs[len(xs)//2]
    print("\n=== per-pc-band summary (median over sampled unique graphs) ===")
    print(f"{'pc':>3} {'cnt':>5} {'capped':>6} {'med_tw':>6} {'med_subtree':>12} {'med_3^(w+1)':>12} {'med_ratio':>10}")
    for pc in sorted(band_stats):
        st = band_stats[pc]
        print(f"{pc:>3} {st['cnt']:>5} {st['capped']:>6} {med(st['tw']):>6} "
              f"{med(st['nab']):>12,.0f} {3**(med(st['tw'])+1):>12,} {med(st['r3']):>10.2f}")

if __name__ == "__main__":
    main()
