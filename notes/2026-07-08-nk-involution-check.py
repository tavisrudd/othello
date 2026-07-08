#!/usr/bin/env python3
"""Machine gate for the session-11 claim: the conic residual is NODE-KAYLES on the
involution graph, and the two-intruder spectrum is Dawson arithmetic on ord(sigma_x sigma_x').

Setup (as 2026-07-07-onconic-intrusion-check.py): grid game = arc game on PG(2,q) from
pre-played a=(1:0:0), b=(0:1:0); conic C: r*c=1, cells P_t=(t,1/t), t in F_q^*; C passes
through a,b with parameters INF, 0. On-conic S4 = 4 conic cells; played = {a,b}+S4 (c=6).

Claims:
 NK1 (kill-set law). At any position played = conic points + intruder set X, playing a live
     conic cell p makes illegal EXACTLY {sigma_x(p) : x in X} among live conic cells
     (plus p itself). No other conic cell dies.
 NK2 (spectrum). For two simultaneous legal intruders x,x': the graph M_x u M_x' on ALL of
     P^1 (edges s~sigma(s), tangency fixed points excluded as edges) has components that are
     cycles of length exactly 2d, d = ord(sigma_x sigma_x') in PGL(2,q), plus paths whose
     endpoints are tangency params; multi-edges collapse to K2 (the d=2 pair case).
 NK3 (Grundy = Dawson XOR). The conic-restricted residual game value (both players play only
     conic cells) at a position with intruders X equals the XOR of Node-Kayles Grundy values
     of the live-component paths/cycles (Dawson 0.137 arithmetic), for |X| in {1,2}.
 NK4 (mechanism census, q=11 full game). For every on-conic S4 that is a P-position and
     every legal intrusion x (child is N), classify P2's winning replies:
     conic cell / second intruder; for intruder replies record d = ord(sigma_x sigma_y),
     whether a d=2 (self-polar) winning reply exists, and whether a conic winning reply
     exists. For N-valued S4, classify the winning moves themselves.
     Guard: per-S4 P/N census must match C15 (q=11: raw on-conic children 56 N=... buckets
     1 N + 3 P) at the value level: report the P/N counts for cross-check.

Output: tables + FAILS count; ALL OK iff zero failures. Single-core, small memory.
"""
import itertools, sys
from functools import lru_cache

INF = 'INF'

def dawson_tables(maxn):
    """Node-Kayles Grundy on paths P_n and cycles C_n by direct DP (no recalled constants)."""
    gp = [0]*(maxn+1)
    for n in range(1, maxn+1):
        opts = set()
        # play vertex i (0-indexed) of a path with n vertices: removes i-1,i,i+1
        for i in range(n):
            left = max(i-1, 0)          # vertices 0..left-1 remain
            right = n - (i+2)           # vertices i+2..n-1 remain
            opts.add(gp[left] ^ gp[max(right, 0)])
        g = 0
        while g in opts: g += 1
        gp[n] = g
    gc = [0]*(maxn+1)
    for n in range(3, maxn+1):
        # play any vertex of C_n: leaves P_{n-3}
        opts = {gp[n-3]}
        g = 0
        while g in opts: g += 1
        gc[n] = g
    return gp, gc

def run(q, s4_sample=None, pair_sample=None, do_census=False):
    inv = {t: pow(t, q-2, q) for t in range(1, q)}
    A, B = (1, 0, 0), (0, 1, 0)
    params = [INF, 0] + list(range(1, q))          # all q+1 conic parameters
    def pt(s):
        if s == INF: return A
        if s == 0:   return B
        return (s % q, inv[s % q], 1)
    def cell(s):                                    # affine cell for finite nonzero param
        return (s, inv[s])
    def det(p, r, s):
        return (p[0]*(r[1]*s[2]-r[2]*s[1]) - p[1]*(r[0]*s[2]-r[2]*s[0])
                + p[2]*(r[0]*s[1]-r[1]*s[0])) % q
    def collinear(p, r, s): return det(p, r, s) == 0

    fails = []

    def sigma(x_pt, s):
        """Involution image of conic param s under projection from off-conic point x."""
        hits = [s2 for s2 in params if s2 != s and collinear(x_pt, pt(s), pt(s2))]
        if len(hits) > 1:
            fails.append((q, 'line thru x meets C in >2', x_pt, s)); return None
        return hits[0] if hits else s

    def perm_sigma(x_pt):
        return {s: sigma(x_pt, s) for s in params}

    def prod_order(pa, pb):
        """Order of the composition pa o pb as a permutation of params."""
        seen_max = 1
        comp = {s: pa[pb[s]] for s in params}
        # order = lcm of cycle lengths
        from math import gcd
        order = 1
        seen = set()
        for s in params:
            if s in seen: continue
            l, t = 0, s
            while True:
                t = comp[t]; l += 1; seen.add(t)
                if t == s: break
            order = order*l // gcd(order, l)
        return order

    # ---------- generic legality on the full grid ----------
    all_cells = [(u, v) for u in range(q) for v in range(q)]
    def legal(c, played_pts, played_cells):
        if c in played_cells: return False
        x = (c[0], c[1], 1)
        n = len(played_pts)
        for i in range(n):
            for j in range(i+1, n):
                if collinear(x, played_pts[i], played_pts[j]): return False
        return True

    # ---------- full-game solver (memo on frozenset of cells; a,b implicit) ----------
    memo = {}
    def value(played_cells):
        """True = N (mover wins)."""
        key = frozenset(played_cells)
        if key in memo: return memo[key]
        ppts = [A, B] + [(c[0], c[1], 1) for c in played_cells]
        res = False
        for c in all_cells:
            if legal(c, ppts, key):
                if not value(key | {c}): res = True; break
        memo[key] = res
        return res

    def moves(played_cells):
        key = frozenset(played_cells)
        ppts = [A, B] + [(c[0], c[1], 1) for c in played_cells]
        return [c for c in all_cells if legal(c, ppts, key)]

    # ---------- restricted (conic-only) solver ----------
    def restricted_win(live, sigmas):
        """live: frozenset of live conic params (finite, nonzero). Mover wins?"""
        return restricted_grundy(live, sigmas) != 0

    def restricted_grundy(live, sigmas, _memo=None):
        if _memo is None: _memo = {}
        def g(l):
            if l in _memo: return _memo[l]
            opts = set()
            for s in l:
                dead = {s} | {sg[s] for sg in sigmas}
                opts.add(g(l - dead))
            r = 0
            while r in opts: r += 1
            _memo[l] = r
            return r
        return g(live)

    # ---------- component spectrum ----------
    def spectrum(live, sigmas):
        """Components of the union-matching graph on live params.
        Returns list of ('path'|'cycle', n_vertices)."""
        adj = {s: set() for s in live}
        for sg in sigmas:
            for s in live:
                t = sg[s]
                if t != s and t in live:
                    adj[s].add(t)
        comps, seen = [], set()
        for s in live:
            if s in seen: continue
            stack, comp = [s], set()
            while stack:
                u = stack.pop()
                if u in comp: continue
                comp.add(u); seen.add(u)
                stack.extend(adj[u] - comp)
            nedges = sum(len(adj[u] & comp) for u in comp) // 2
            n = len(comp)
            if nedges == n: comps.append(('cycle', n))
            elif nedges == n - 1: comps.append(('path', n))
            else: fails.append((q, 'component not path/cycle', n, nedges))
        return comps

    GP, GC = dawson_tables(q + 2)
    def dawson_xor(comps):
        r = 0
        for kind, n in comps:
            r ^= GP[n] if kind == 'path' else GC[n]
        return r

    # ================= NK1 + NK3 over sampled positions =================
    finite_params = list(range(1, q))
    s4_iter = itertools.combinations(finite_params, 4)
    if s4_sample: s4_iter = itertools.islice(s4_iter, s4_sample)
    s4_list = list(s4_iter)

    nk1_checked = nk3_checked = nk2_checked = 0
    pair_d_hist = {}
    for T4 in s4_list:
        base_cells = frozenset(cell(t) for t in T4)
        ppts6 = [A, B] + [pt(t) for t in T4]
        intruders = [c for c in all_cells
                     if (c[0]*c[1]) % q != 1 and legal(c, ppts6, base_cells)]
        # single- and double-intruder positions
        for k, xs in [(1, [(x,) for x in intruders]),
                      (2, list(itertools.combinations(intruders, 2)))]:
            cfgs = xs
            if k == 2 and pair_sample:
                cfgs = xs[:pair_sample]
            for X in cfgs:
                pc = base_cells | set(X)
                ppts = [A, B] + [(c[0], c[1], 1) for c in pc]
                # X must be simultaneously legal (x' legal after x)
                if k == 2:
                    if not legal(X[1], [A, B] + [pt(t) for t in T4] + [(X[0][0], X[0][1], 1)],
                                 base_cells | {X[0]}):
                        continue
                sigmas = [perm_sigma((x[0], x[1], 1)) for x in X]
                live = frozenset(s for s in finite_params
                                 if s not in T4 and legal(cell(s), ppts, pc))
                # NK1: playing each live cell kills exactly the sigma-images
                for s in live:
                    pc2 = pc | {cell(s)}
                    ppts2 = ppts + [pt(s)]
                    newlive = {t for t in live
                               if t != s and legal(cell(t), ppts2, pc2)}
                    expect = live - {s} - {sg[s] for sg in sigmas}
                    if newlive != expect:
                        fails.append((q, 'NK1 kill-set mismatch', T4, X, s,
                                      sorted(newlive ^ expect)))
                    nk1_checked += 1
                # NK3: restricted Grundy == Dawson XOR of spectrum
                comps = spectrum(live, sigmas)
                gx = dawson_xor(comps)
                gd = restricted_grundy(live, sigmas)
                if gx != gd:
                    fails.append((q, 'NK3 grundy mismatch', T4, X, comps, gx, gd))
                nk3_checked += 1
                # NK2: two-intruder full-P^1 spectrum vs d
                if k == 2:
                    d = prod_order(sigmas[0], sigmas[1])
                    pair_d_hist[d] = pair_d_hist.get(d, 0) + 1
                    full_comps = spectrum(frozenset(params), sigmas)
                    for kind, n in full_comps:
                        if kind == 'cycle' and n not in (2, 2*d):
                            # length-2 = the xx'-secant pair (rho-fixed); else full orbit 2d
                            fails.append((q, 'NK2 cycle len not in {2,2d}', d, n, T4, X))
                    nk2_checked += 1

    print(f"q={q}: NK1 kill-set checks={nk1_checked}, NK3 grundy checks={nk3_checked}, "
          f"NK2 pair checks={nk2_checked}, pair d-histogram={dict(sorted(pair_d_hist.items()))}")

    # ================= NK4: q=11 full-game mechanism census =================
    if do_census:
        n_s4_P = n_s4_N = 0
        h1_fail = []      # (S4, x) where NO winning reply is a d=2 intruder
        h2_fail = []      # (S4, x) where NO winning reply is conic
        win_reply_d = {}  # d histogram over winning intruder replies
        n_moves_conic_win = n_moves_intr_win = 0
        for T4 in s4_list:
            base = frozenset(cell(t) for t in T4)
            v = value(base)                     # True = N
            if v:
                n_s4_N += 1
                # classify the winning MOVES of an N-valued on-conic S4
                for m in moves(base):
                    if not value(base | {m}):
                        if (m[0]*m[1]) % q == 1: n_moves_conic_win += 1
                        else: n_moves_intr_win += 1
                continue
            n_s4_P += 1
            ppts6 = [A, B] + [pt(t) for t in T4]
            for x in moves(base):
                if (x[0]*x[1]) % q == 1: continue     # intrusions only
                child = base | {x}
                # S4 is P => child is N => winning replies exist
                sx = perm_sigma((x[0], x[1], 1))
                found_conic = found_selfpolar = False
                for y in moves(child):
                    if value(child | {y}): continue    # not winning
                    if (y[0]*y[1]) % q == 1:
                        found_conic = True
                    else:
                        sy = perm_sigma((y[0], y[1], 1))
                        d = prod_order(sx, sy)
                        win_reply_d[d] = win_reply_d.get(d, 0) + 1
                        if d == 2: found_selfpolar = True
                if not found_selfpolar: h1_fail.append((T4, x))
                if not found_conic: h2_fail.append((T4, x))
        print(f"q={q} census: S4 P-valued={n_s4_P}, N-valued={n_s4_N}; "
              f"N-S4 winning moves: conic={n_moves_conic_win}, intruder={n_moves_intr_win}")
        print(f"  winning intruder-reply d-histogram={dict(sorted(win_reply_d.items()))}")
        print(f"  H1 (self-polar winning reply exists) fails: {len(h1_fail)}"
              + (f" e.g. {h1_fail[:3]}" if h1_fail else ""))
        print(f"  H2 (conic winning reply exists) fails: {len(h2_fail)}"
              + (f" e.g. {h2_fail[:3]}" if h2_fail else ""))

    for f in fails[:10]: print("  FAIL:", f)
    return len(fails)

if __name__ == '__main__':
    total = 0
    total += run(11, s4_sample=None, pair_sample=25, do_census=True)   # exhaustive S4
    total += run(13, s4_sample=40, pair_sample=10, do_census=False)    # sample
    print("ALL OK" if total == 0 else f"TOTAL FAILURES: {total}")
