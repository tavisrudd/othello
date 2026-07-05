"""Game (a): graph Node-Kayles on Cay^+(Z_n, S) for general symmetric S.

Engine reused from notes/2026-07-04-arith-cayley.py (boolean P/N short-circuit,
valid since circulants are vertex-transitive => G(root) in {0,1}).

This sweep:
  1. Full enumeration of symmetric S (S=-S, 0 not in S) for each n, computing G.
  2. Tests L1 coverage (n even, n/2 not in S => G=0) and L2 coverage
     (n odd, 2S=S => G=1) -- counts agreement + any violations.
  3. Characterizes the RESIDUAL cases the two lemmas do NOT cover, hunting a law.
  4. The clean interval family C_n^k (S = {+-1..+-k}) as a 2D table.
"""

import sys

sys.setrecursionlimit(1_000_000)

MEMO_CAP = 800_000


class MemoCap(Exception):
    pass


def cayley_adj_mod(n, S):
    adj = []
    for v in range(n):
        m = 1 << v
        for d in S:
            m |= 1 << ((v + d) % n)
        adj.append(m)
    return adj


def outcome(live, adj, memo, cap):
    if live == 0:
        return True
    r = memo.get(live)
    if r is not None:
        return r
    res = True
    m = live
    while m:
        v = (m & -m).bit_length() - 1
        m &= m - 1
        if outcome(live & ~adj[v], adj, memo, cap):
            res = False
            break
    memo[live] = res
    if cap and len(memo) > cap:
        raise MemoCap()
    return res


def game_G(n, S, cap=MEMO_CAP):
    """Return (G in {0,1} or None if capped, memo_size)."""
    adj = cayley_adj_mod(n, S)
    memo = {}
    full = (1 << n) - 1
    try:
        childP = outcome(full & ~adj[0], adj, memo, cap)
    except MemoCap:
        return None, len(memo)
    return (1 if childP else 0), len(memo)


def sym_sets(n):
    """Yield every symmetric connection set S (S=-S, 0 not in S) as a frozenset."""
    pairs = []
    self_paired = []
    seen = set()
    for d in range(1, n):
        if d in seen:
            continue
        nd = (n - d) % n
        seen.add(d)
        seen.add(nd)
        if nd == d:
            self_paired.append(d)  # d = n/2, n even
        else:
            pairs.append((d, nd))
    elems = [set(p) for p in pairs] + [{s} for s in self_paired]
    for bits in range(1 << len(elems)):
        S = set()
        for i, e in enumerate(elems):
            if (bits >> i) & 1:
                S |= e
        yield frozenset(S)


def halving_closed(n, S):
    return {(2 * d) % n for d in S} == set(S)


def gcd(a, b):
    while b:
        a, b = b, a % b
    return a


def connected(n, S):
    g = n
    for d in S:
        g = gcd(g, d)
    return g == 1


def sweep_n(n, cap=MEMO_CAP):
    """Full enumeration; return classification counts + violation lists."""
    even = n % 2 == 0
    half = n // 2
    stats = {
        "n": n,
        "total": 0,
        "G0": 0,
        "G1": 0,
        "capped": 0,
        # L1 (even): n/2 not in S
        "L1_applies": 0,
        "L1_ok": 0,
        "L1_viol": [],
        # among even n with n/2 in S:
        "even_half_in_G0": 0,
        "even_half_in_G1": 0,
        # L2 (odd): 2S=S
        "L2_applies": 0,
        "L2_ok": 0,
        "L2_viol": [],
        # residual (lemma-not-covered) G distribution
        "resid_G0": [],
        "resid_G1": [],
    }
    for S in sym_sets(n):
        # skip empty set (no edges, all isolated => G = n mod 2 trivially; and
        # it is not "vertex-transitive game" in the interesting sense). Keep it
        # actually: empty S means no moves delete neighbors, pure isolated =>
        # game = n independent vertices => G = n mod 2. game_G handles it.
        g, msz = game_G(n, S, cap)
        stats["total"] += 1
        if g is None:
            stats["capped"] += 1
            continue
        if g == 0:
            stats["G0"] += 1
        else:
            stats["G1"] += 1
        Sset = set(S)
        if even:
            if half not in Sset:
                stats["L1_applies"] += 1
                if g == 0:
                    stats["L1_ok"] += 1
                else:
                    stats["L1_viol"].append((sorted(Sset), g))
            else:
                if g == 0:
                    stats["even_half_in_G0"] += 1
                    stats["resid_G0"].append(sorted(Sset))
                else:
                    stats["even_half_in_G1"] += 1
                    stats["resid_G1"].append(sorted(Sset))
        else:
            hc = halving_closed(n, Sset) and len(Sset) > 0
            if hc:
                stats["L2_applies"] += 1
                if g == 1:
                    stats["L2_ok"] += 1
                else:
                    stats["L2_viol"].append((sorted(Sset), g))
            else:
                if g == 0:
                    stats["resid_G0"].append(sorted(Sset))
                else:
                    stats["resid_G1"].append(sorted(Sset))
    return stats


def report(stats):
    n = stats["n"]
    even = n % 2 == 0
    print(f"\n=== n={n} ({'even' if even else 'odd'}) ===  "
          f"total_sym_S={stats['total']}  G0={stats['G0']}  G1={stats['G1']}  "
          f"capped={stats['capped']}")
    if even:
        print(f"  L1 (n/2 not in S => G=0): applies={stats['L1_applies']}  "
              f"ok={stats['L1_ok']}  VIOLATIONS={len(stats['L1_viol'])}")
        for s, g in stats["L1_viol"][:10]:
            print(f"     !! L1 violated: S={s} -> G={g}")
        tot_half = stats["even_half_in_G0"] + stats["even_half_in_G1"]
        print(f"  among n/2 IN S (L1 silent): count={tot_half}  "
              f"G0={stats['even_half_in_G0']}  G1={stats['even_half_in_G1']}")
    else:
        print(f"  L2 (2S=S => G=1): applies={stats['L2_applies']}  "
              f"ok={stats['L2_ok']}  VIOLATIONS={len(stats['L2_viol'])}")
        for s, g in stats["L2_viol"][:10]:
            print(f"     !! L2 violated: S={s} -> G={g}")
        nres = len(stats["resid_G0"]) + len(stats["resid_G1"])
        print(f"  residual (2S!=S): count={nres}  "
              f"G0={len(stats['resid_G0'])}  G1={len(stats['resid_G1'])}")
    sys.stdout.flush()


def interval_table(n_max=30, k_max=6, cap=MEMO_CAP):
    print("\n\n########## Interval family C_n^k : S = {+-1..+-k} ##########")
    print("rows = n, cols = k;  value = G (. = capped/skip)")
    header = "  n\\k " + "".join(f"{k:>4}" for k in range(1, k_max + 1))
    print(header)
    for n in range(3, n_max + 1):
        row = f"{n:>4} "
        for k in range(1, k_max + 1):
            if k >= n - k:  # S would wrap to include n/2 spanning; still valid but
                # cap k at (n-1)//2 (beyond that S = all = complete graph)
                if k > (n - 1) // 2:
                    row += "   *"
                    continue
            S = set()
            for d in range(1, k + 1):
                S.add(d % n)
                S.add((n - d) % n)
            S.discard(0)
            g, _ = game_G(n, S, cap)
            row += f"{'.' if g is None else g:>4}"
        print(row)
        sys.stdout.flush()


if __name__ == "__main__":
    import argparse

    ap = argparse.ArgumentParser()
    ap.add_argument("--even-max", type=int, default=18)
    ap.add_argument("--odd-max", type=int, default=17)
    ap.add_argument("--intervals", action="store_true")
    ap.add_argument("--interval-nmax", type=int, default=30)
    args = ap.parse_args()

    print("Cay^+(Z_n, S) Node-Kayles outcome sweep  (G in {0,1}, boolean engine)")
    print(f"MEMO_CAP={MEMO_CAP}")

    ns = []
    for n in range(4, args.even_max + 1, 2):
        ns.append(n)
    for n in range(5, args.odd_max + 1, 2):
        ns.append(n)
    ns.sort()

    for n in ns:
        st = sweep_n(n)
        report(st)

    if args.intervals:
        interval_table(n_max=args.interval_nmax)

    print("\nCAYLEY_SWEEP_DONE")
