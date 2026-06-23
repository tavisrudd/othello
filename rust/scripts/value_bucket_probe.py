#!/usr/bin/env python3
"""Offline GO/NO-GO: does a cheap game-value-correlated invariant phi merge TT entries
better than the ~3.4x full-iso ceiling at near-perfect value purity?

Reuses treewidth_dp_probe.load / build_graph / nk_solve (validated exact Node-Kayles).

For every DISTINCT deep-tail graph (by avail tuple, restricted to pc in [18,28]):
  - exact value via nk_solve  -> nimber + win/loss (= nimber != 0)
  - a menu of cheap structural invariants phi (degree-seq hash, k-round WL hashes,
    a feature tuple, and a couple of combos)
For each phi:
  - merge ratio   = #distinct graphs / #distinct phi values
  - win/loss purity (per-bucket, unweighted AND member-weighted)
  - nimber purity  (per-bucket, unweighted AND member-weighted)
  - a cost class

Verdict GO iff some cheap phi beats 3.4x merge at >=99.5% member-weighted win/loss purity
while costing << iso canon.

NOTE on weighting: "member-weighted" weights each bucket by its member count (= the number
of distinct graphs that map to that phi). The deep tail has re-exp ~1.0x so each distinct
graph ~ one TT query, making member-weighting a good proxy for the actual TT-query mass.
We also tried weighting by raw record multiplicity (how many times each avail appears in the
dump) as a second mass proxy; reported as "record-weighted".
"""
import sys, struct, time, hashlib
from collections import defaultdict, Counter

sys.path.insert(0, "/home/tavis/src/othello/rust/scripts")
import treewidth_dp_probe as T

ISO_CEILING = 3.4


# ---------------------------------------------------------------- adjacency helpers
def neighbor_lists(m, adj):
    nb = [[] for _ in range(m)]
    for i in range(m):
        a = adj[i]
        while a:
            b = a & -a
            nb[i].append(b.bit_length() - 1)
            a ^= b
    return nb


def degrees(m, adj):
    return [bin(adj[i]).count("1") for i in range(m)]


# ---------------------------------------------------------------- cheap invariants (phi)
def phi_degseq(m, adj, nb, deg):
    """Sorted degree sequence. O(m). The cheapest non-trivial graph invariant."""
    return tuple(sorted(deg))


def _stable_hash(obj):
    """Deterministic cross-graph-stable hash of a (color, sorted-neighbor-colors) signature.
    Python's built-in hash() is salted per-process but stable within one run, and -- crucially --
    we need the SAME signature in two different graphs to map to the SAME color. Using a content
    hash (sha) keyed only on the signature value guarantees that, independent of vertex order."""
    h = hashlib.blake2b(repr(obj).encode(), digest_size=8)
    return h.digest()


def wl_hashes(m, adj, nb, deg, rounds):
    """k rounds of 1-WL color refinement; return the sorted MULTISET OF FINAL COLOR VALUES.
    Each round: new color = stable_hash(old color, sorted multiset of neighbor old colors).
    The fingerprint is the sorted multiset of final color values -- NOT remapped to a dense
    per-graph range (that would destroy cross-graph comparability and leave only |V|). Two
    graphs share this phi iff they are 1-WL-indistinguishable after `rounds` rounds. The color
    values are content-hashes so identical local structure in two graphs yields identical colors.
    O(rounds * (m + E))."""
    # initial color = degree (a content value, stable across graphs)
    col = [_stable_hash(("init", deg[i])) for i in range(m)]
    for _ in range(rounds):
        newcol = []
        for i in range(m):
            sig = (col[i], tuple(sorted(col[j] for j in nb[i])))
            newcol.append(_stable_hash(sig))
        col = newcol
    # fingerprint = sorted multiset of final color values (content-stable across graphs)
    return tuple(sorted(Counter(col).items()))


def phi_wl1(m, adj, nb, deg):
    return wl_hashes(m, adj, nb, deg, 1)


def phi_wl2(m, adj, nb, deg):
    return wl_hashes(m, adj, nb, deg, 2)


def phi_wl3(m, adj, nb, deg):
    return wl_hashes(m, adj, nb, deg, 3)


def count_triangles(m, adj, nb):
    """Triangle count. O(sum deg^2) worst case but tail is sparse."""
    tri = 0
    for i in range(m):
        ai = adj[i]
        # neighbors j>i, then common neighbors k>j
        rem = ai >> (i + 1)
        base = i + 1
        while rem:
            b = rem & -rem
            j = base + (b.bit_length() - 1)
            rem ^= b
            common = adj[i] & adj[j] & ~((1 << (j + 1)) - 1)
            tri += bin(common).count("1")
        # NOTE: the >>(i+1) shift above only iterates j>i; counts each triangle once
    return tri


def count_simplicial(m, adj, nb, deg):
    """Number of simplicial vertices (neighborhood is a clique). O(sum deg^2)."""
    cnt = 0
    for i in range(m):
        ns = nb[i]
        ok = True
        for x in range(len(ns)):
            a = ns[x]
            aa = adj[a]
            for y in range(x + 1, len(ns)):
                if not (aa >> ns[y]) & 1:
                    ok = False
                    break
            if not ok:
                break
        if ok:
            cnt += 1
    return cnt


def phi_feat(m, adj, nb, deg):
    """Feature tuple: (|V|,|E|,#iso,#leaf,#deg2,#simplicial,#triangles,max-deg). O(m^2)-ish."""
    E = sum(deg) // 2
    n_iso = sum(1 for d in deg if d == 0)
    n_leaf = sum(1 for d in deg if d == 1)
    n_deg2 = sum(1 for d in deg if d == 2)
    n_simp = count_simplicial(m, adj, nb, deg)
    n_tri = count_triangles(m, adj, nb)
    maxd = max(deg) if deg else 0
    return (m, E, n_iso, n_leaf, n_deg2, n_simp, n_tri, maxd)


def phi_degseq_wl2(m, adj, nb, deg):
    return (phi_degseq(m, adj, nb, deg), phi_wl2(m, adj, nb, deg))


def phi_feat_wl2(m, adj, nb, deg):
    return (phi_feat(m, adj, nb, deg), phi_wl2(m, adj, nb, deg))


# cost class per phi
PHI_MENU = [
    ("degseq",        phi_degseq,      "cheap O(m log m)"),
    ("WL-1round",     phi_wl1,         "cheap O(m+E)"),
    ("WL-2round",     phi_wl2,         "cheap O(m+E)"),
    ("WL-3round",     phi_wl3,         "cheap O(m+E)"),
    ("feat8",         phi_feat,        "medium O(sum d^2)"),
    ("degseq+WL2",    phi_degseq_wl2,  "cheap O(m+E)"),
    ("feat8+WL2",     phi_feat_wl2,    "medium O(sum d^2)"),
]


# ---------------------------------------------------------------- purity computation
def purity(buckets, value_of, weight_of):
    """buckets: dict phi -> list of graph-ids.
    value_of: gid -> value (win/loss bool, or nimber int).
    weight_of: gid -> instance weight.
    Returns (merge_ratio, n_buckets, n_graphs,
             unweighted_purity, member_weighted_purity, record_weighted_purity).
    A bucket is 'pure' iff all its members share the same value.
    Member-weighted purity = (#graphs in pure buckets) / (#graphs).
    Record-weighted = (sum weight in pure buckets) / (total weight)."""
    n_graphs = sum(len(v) for v in buckets.values())
    n_buckets = len(buckets)
    pure_buckets = 0
    pure_members = 0
    pure_weight = 0
    total_weight = 0
    for phi, gids in buckets.items():
        vals = set(value_of[g] for g in gids)
        w = sum(weight_of[g] for g in gids)
        total_weight += w
        if len(vals) == 1:
            pure_buckets += 1
            pure_members += len(gids)
            pure_weight += w
    return (
        n_graphs / n_buckets if n_buckets else 0.0,
        n_buckets,
        n_graphs,
        pure_buckets / n_buckets if n_buckets else 0.0,
        pure_members / n_graphs if n_graphs else 0.0,
        pure_weight / total_weight if total_weight else 0.0,
    )


# ---------------------------------------------------------------- main
def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "/tmp/qhk-n14.bin"
    pc_lo = int(sys.argv[sys.argv.index("--lo") + 1]) if "--lo" in sys.argv else 18
    pc_hi = int(sys.argv[sys.argv.index("--hi") + 1]) if "--hi" in sys.argv else 28
    cap = int(sys.argv[sys.argv.index("--cap") + 1]) if "--cap" in sys.argv else 4_000_000

    n, recs = T.load(path)
    # distinct graphs by avail, restricted to pc band; track record multiplicity (mass proxy)
    mult = Counter()
    first_pc = {}
    for key, avail, pc, hit in recs:
        if pc_lo <= pc <= pc_hi:
            mult[avail] += 1
            if avail not in first_pc:
                first_pc[avail] = pc
    distinct = list(mult.keys())
    print(f"# value-bucketing probe  file={path}")
    print(f"# n={n}  records={len(recs)}  pc-band=[{pc_lo},{pc_hi}]  "
          f"distinct_graphs={len(distinct):,}  total_records_in_band={sum(mult.values()):,}")

    # ---- spot-check nk_solve on 3 graphs (skeptic check) ----
    print("\n# spot-check nk_solve (nimber + win/loss; cross-checked win==(nimber!=0)):")
    chk = sorted(distinct, key=lambda a: first_pc[a])
    for a in [chk[0], chk[len(chk) // 2], chk[-1]]:
        m, adj = T.build_graph(a, n)
        win, nim, nf, nab, ovf, _ = T.nk_solve(m, adj, cap)
        ok = (win == (nim != 0)) if nim is not None else "n/a"
        print(f"    m={m:3} pc={first_pc[a]:3}  win={win!s:5} nimber={nim}  "
              f"n_ab={nab} n_full={nf}  win==(nim!=0)? {ok}")

    # ---- solve all distinct graphs: exact value + build phi buckets ----
    t0 = time.time()
    winloss = {}      # gid -> bool
    nimber = {}       # gid -> int or None
    nim_skipped = 0
    overflow = 0
    # phi buckets: per phi name -> dict(phi_value -> list of gid)
    buckets = {name: defaultdict(list) for name, _, _ in PHI_MENU}

    for idx, a in enumerate(distinct):
        m, adj = T.build_graph(a, n)
        nb = neighbor_lists(m, adj)
        deg = degrees(m, adj)
        win, nim, nf, nab, ovf, _ = T.nk_solve(m, adj, cap)
        winloss[a] = win
        nimber[a] = nim
        if nim is None:
            nim_skipped += 1
        if ovf:
            overflow += 1
        for name, fn, _ in PHI_MENU:
            buckets[name][fn(m, adj, nb, deg)].append(a)
        if (idx + 1) % 5000 == 0:
            print(f"    ... {idx+1}/{len(distinct)} solved  ({time.time()-t0:.1f}s)",
                  flush=True)
    dt = time.time() - t0
    print(f"\n# solved all {len(distinct):,} distinct graphs in {dt:.1f}s  "
          f"(nimber-skipped={nim_skipped}, ab-overflow={overflow})")

    # value distribution sanity
    n_win = sum(1 for a in distinct if winloss[a])
    n_loss = len(distinct) - n_win
    nimdist = Counter(nimber[a] for a in distinct if nimber[a] is not None)
    print(f"# win/loss split: WIN={n_win:,} ({n_win/len(distinct):.1%})  "
          f"LOSS={n_loss:,} ({n_loss/len(distinct):.1%})")
    print(f"# nimber distribution: " +
          "  ".join(f"g{k}={v:,}" for k, v in sorted(nimdist.items())))

    # ---- baseline: what does the EXACT-value bucketing (the ideal) achieve? ----
    # merge ratio if we bucketed by win/loss alone (the theoretical TT-merge ceiling for
    # a perfectly value-pure invariant) -- this is the upper bound a phi could reach.
    print(f"\n# reference: a perfect win/loss invariant would merge "
          f"{len(distinct)/2:.0f}x (all -> 2 buckets); the iso ceiling is {ISO_CEILING}x.")

    # ---- compute purity table for each phi ----
    weight = mult  # record-multiplicity weight (mass proxy 2)
    rows = []
    for name, fn, cost in PHI_MENU:
        b = buckets[name]
        # win/loss purity
        mr, nb_cnt, ng, wl_pb, wl_pm, wl_pw = purity(b, winloss, weight)
        # nimber purity (skip graphs with None nimber by treating None as its own value;
        # but here none are skipped in practice)
        nm_value = {a: (nimber[a] if nimber[a] is not None else -1) for a in distinct}
        _, _, _, nm_pb, nm_pm, nm_pw = purity(b, nm_value, weight)
        rows.append({
            "name": name, "cost": cost, "merge": mr, "buckets": nb_cnt,
            "wl_pb": wl_pb, "wl_pm": wl_pm, "wl_pw": wl_pw,
            "nm_pb": nm_pb, "nm_pm": nm_pm, "nm_pw": nm_pw,
        })

    # ---- print ranked table ----
    # rank by member-weighted win/loss "efficient" score = merge * purity (gated >=99.5%)
    print("\n" + "=" * 110)
    print("RANKED phi TABLE  (sorted by member-weighted win/loss purity, then merge ratio)")
    print("=" * 110)
    hdr = (f"{'phi':<13} {'cost':<18} {'merge':>7} {'#buck':>7} | "
           f"{'WL pur(buk)':>11} {'WL pur(mem)':>11} {'WL pur(rec)':>11} | "
           f"{'nim(mem)':>9}")
    print(hdr)
    print("-" * 110)

    def sortkey(r):
        return (-round(r["wl_pw"], 5), -r["merge"])

    for r in sorted(rows, key=sortkey):
        beats = "*" if (r["merge"] > ISO_CEILING and r["wl_pw"] >= 0.995) else " "
        print(f"{r['name']:<13} {r['cost']:<18} {r['merge']:>6.2f}x {r['buckets']:>7,} | "
              f"{r['wl_pb']:>10.2%} {r['wl_pw']:>10.2%} {r['wl_pw']:>10.2%} | "
              f"{r['nm_pw']:>8.2%} {beats}")

    print("-" * 110)
    print("WL pur(buk)=unweighted per-bucket  WL pur(mem)=member-weighted  "
          "WL pur(rec)=record-multiplicity-weighted  nim(mem)=member-wtd nimber purity")
    print("(* = beats 3.4x iso ceiling at >=99.5% member-weighted win/loss purity)")

    # ---- separately print member vs record weighting for the WL purity (they differ slightly) ----
    print("\n# member- vs record-weighted win/loss purity (the two mass proxies):")
    print(f"{'phi':<13} {'merge':>7} {'mem-wtd':>9} {'rec-wtd':>9}")
    for r in sorted(rows, key=sortkey):
        print(f"{r['name']:<13} {r['merge']:>6.2f}x {r['wl_pm']:>8.2%} {r['wl_pw']:>8.2%}")

    # ---- verdict ----
    print("\n" + "=" * 110)
    print("VERDICT")
    print("=" * 110)
    winners = [r for r in rows if r["merge"] > ISO_CEILING and r["wl_pw"] >= 0.995]
    cheap_winners = [r for r in winners if r["cost"].startswith("cheap")]
    if winners:
        best = max(winners, key=lambda r: r["merge"])
        kind = "cheap" if cheap_winners else "medium"
        print(f"GO: phi='{best['name']}' ({best['cost']}) merges {best['merge']:.2f}x "
              f"(> {ISO_CEILING}x iso ceiling) at {best['wl_pw']:.3%} member-weighted "
              f"win/loss purity.")
        print(f"    Recommended 2nd-tier TT key candidate: {best['name']}.")
    else:
        # explain why no-go
        hp = [r for r in rows if r["wl_pw"] >= 0.995]
        bm = [r for r in rows if r["merge"] > ISO_CEILING]
        print("NO-GO.")
        if hp:
            print(f"    High-purity (>=99.5% mem-wtd WL) phi exist but none beat {ISO_CEILING}x merge: "
                  + ", ".join(f"{r['name']}({r['merge']:.2f}x)" for r in hp))
        if bm:
            print(f"    Phi that beat {ISO_CEILING}x merge all fall below 99.5% purity: "
                  + ", ".join(f"{r['name']}({r['wl_pw']:.2%})" for r in bm))


if __name__ == "__main__":
    main()
