#!/usr/bin/env python3
"""C64 -- completion-poset (extremal / Erdos-lens) correlate of the flip.

Companion to C55 (group-theoretic side-switch).  Tests whether the
"arc-depleted-orders dichotomy" -- the 119 on-conic size-4 children that are N at
the arc-depleted orders q in {11,17} and P at the full orders q in {13,19} -- is
tracked by a property of the *completion poset*: the maximal legal caps (complete
arcs of PG(2,q)) that contain the played 6-point configuration {a,b} u T4.

Model (reused verbatim from c55_intruder_skeleton.Conic):
  * a=(1:0:0), b=(0:1:0) are the two burned points at infinity (they lie on the
    projective conic xy=z^2, so the conic is an oval a,b,{(t,1/t)}).
  * A residual-grid legal position = a partial permutation with no 3 collinear
    = an arc of PG(2,q) that contains a,b.  Collinearity with a  <=> same row (v);
    with b  <=> same column (u).  No 3 affine cells collinear otherwise.
  * A COMPLETION of T4 = a maximal such arc (complete arc) containing the 4 cells
    of T4.  The completion SPECTRUM = sizes / count / parity of these completions.

Because the residual game is normal play (last legal move wins) and every move
adds exactly one cell, a completion of cell-size s costs s-4 moves; if every
completion has the same move-parity the value is forced (N iff #moves odd).  The
conic itself is always a completion of cell-size q-1 (an even number of moves for
all four q), so an N verdict at a depleted order must come from an odd, shorter
completion -- this is the geometric intuition C64 puts to the test.

Enumeration: the "no 3 collinear" constraint is NOT pairwise (three new cells can
be pairwise-legal yet collinear), so we do NOT use plain graph-clique enumeration.
We enumerate maximal arcs by incremental legal extension (a Bron-Kerbosch
recursion over the *independence system* of arcs, whose maximality test is
"no single cell is addable" and whose add-test rechecks the full triple
constraint).  Cells are bit-indexed; kill-masks precompute, per candidate, exactly
which ground cells its addition forbids (row/col lines + affine collinear triples),
so each recursion node is a few big-int ops.  A per-config node/time cap guards
blowup; a truncated config is flagged and its count/parity are treated as unknown
(never silently capped).  Min completion size is found by an exact branch-and-bound
(prune when the partial arc can no longer beat the best), which stays cheap even
where the full count explodes.

Run from repo root:
    python3 rust/scripts/c64_completion_poset.py            # full report
    python3 rust/scripts/c64_completion_poset.py --quick    # 11/13 only, small
"""

from __future__ import annotations

import os
import random
import sys
import time
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import c55_side_switch as c55  # noqa: E402  (corpus, gate, cohorts)
from c55_intruder_skeleton import Conic, params_at  # noqa: E402

SEED = 20260709  # deterministic sampling of q=17/19 configs


def cellpt(c):
    return (c[0], c[1], 1)


def ground_set(C, T4cells):
    """All grid cells legal to add to the arc {a,b} u T4 individually (on or off
    conic), i.e. not sharing a row/col with T4 and not collinear with any two of
    the six base points."""
    q = C.q
    base = [C.A, C.B] + [cellpt(c) for c in T4cells]
    T4set = set(T4cells)
    G = []
    for u in range(q):
        for v in range(q):
            if (u, v) in T4set:
                continue
            x = (u, v, 1)
            ok = True
            for i in range(len(base)):
                for j in range(i + 1, len(base)):
                    if C.collinear(x, base[i], base[j]):
                        ok = False
                        break
                if not ok:
                    break
            if ok:
                G.append((u, v))
    return G


class CompletionModel:
    """Precomputed kill-masks for fast maximal-arc enumeration above T4."""

    def __init__(self, C, T4cells):
        self.C = C
        self.q = C.q
        self.T4cells = list(T4cells)
        self.b0 = len(T4cells)
        self.G = ground_set(C, T4cells)
        self.m = len(self.G)
        self.full = (1 << self.m) - 1
        self._precompute()

    def _precompute(self):
        C = self.C
        G = self.G
        m = self.m
        pts = [(g[0], g[1], 1) for g in G]
        T4pts = [(c[0], c[1], 1) for c in self.T4cells]
        # kill_self[i]: cells forbidden the moment i is added, regardless of the
        # rest of the arc -- row/col line through a-i / b-i, and affine triples
        # {T4cell, i, .}.
        kill_self = [0] * m
        for i in range(m):
            gi = G[i]
            pi = pts[i]
            mask = 0
            for j in range(m):
                if j == i:
                    continue
                gj = G[j]
                if gi[0] == gj[0] or gi[1] == gj[1]:
                    mask |= (1 << j)
                    continue
                pj = pts[j]
                for t in T4pts:
                    if C.collinear(pi, pj, t):
                        mask |= (1 << j)
                        break
            kill_self[i] = mask
        # kill_tri[i][j]: cells forbidden by the affine secant of the pair (i,j)
        # once BOTH i and j are in the arc.
        kill_tri = [[0] * m for _ in range(m)]
        for i in range(m):
            pi = pts[i]
            for j in range(i + 1, m):
                pj = pts[j]
                mask = 0
                for k in range(m):
                    if k == i or k == j:
                        continue
                    if C.collinear(pi, pj, pts[k]):
                        mask |= (1 << k)
                kill_tri[i][j] = mask
                kill_tri[j][i] = mask
        self.kill_self = kill_self
        self.kill_tri = kill_tri

    # -- exact minimum completion size (branch and bound) -------------------
    def min_size(self, node_cap=4_000_000):
        ks = self.kill_self
        kt = self.kill_tri
        b0 = self.b0
        best = [b0 + self.m + 1]
        nodes = [0]
        trunc = [False]

        def rec(chosen, A):
            nodes[0] += 1
            if nodes[0] > node_cap:
                trunc[0] = True
                return
            cur = b0 + len(chosen)
            if A == 0:
                if cur < best[0]:
                    best[0] = cur
                return
            if cur + 1 >= best[0]:
                return
            vv = A
            cand = []
            while vv:
                low = vv & (-vv)
                i = low.bit_length() - 1
                vv ^= low
                killed = ks[i]
                for j in chosen:
                    killed |= kt[i][j]
                newA = A & ~killed & ~(1 << i)
                cand.append((bin(newA).count("1"), i, newA))
            cand.sort(key=lambda t: t[0])  # most-restrictive first -> small arcs first
            for _, i, newA in cand:
                if trunc[0]:
                    return
                rec(chosen + [i], newA)

        rec([], self.full)
        return best[0], nodes[0], trunc[0]

    # -- full maximal-arc enumeration (Bron-Kerbosch over the arc system) ---
    def enum_all(self, node_cap=3_000_000, time_cap=8.0):
        ks = self.kill_self
        kt = self.kill_tri
        b0 = self.b0
        sizes = Counter()
        nodes = [0]
        trunc = [False]
        t0 = time.time()

        def expand(chosen, P, X):
            nodes[0] += 1
            if nodes[0] > node_cap or ((nodes[0] & 8191) == 0 and time.time() - t0 > time_cap):
                trunc[0] = True
                return
            if P == 0 and X == 0:
                sizes[b0 + len(chosen)] += 1
                return
            vv = P
            while vv:
                if trunc[0]:
                    return
                low = vv & (-vv)
                i = low.bit_length() - 1
                vv ^= low
                killed = ks[i]
                for j in chosen:
                    killed |= kt[i][j]
                bit = 1 << i
                expand(chosen + [i], P & ~killed & ~bit, X & ~killed & ~bit)
                P &= ~bit
                X |= bit

        expand([], self.full, 0)
        return sizes, sum(sizes.values()), nodes[0], trunc[0]


# ---------------------------------------------------------------------------
# sanity: brute-force arc / maximality check (independent of kill-mask logic)
# ---------------------------------------------------------------------------

def is_arc_bruteforce(C, cells):
    pts = [C.A, C.B] + [cellpt(c) for c in cells]
    n = len(pts)
    for i in range(n):
        for j in range(i + 1, n):
            for k in range(j + 1, n):
                if C.collinear(pts[i], pts[j], pts[k]):
                    return False
    return True


def is_maximal_bruteforce(C, cells):
    q = C.q
    cellset = set(cells)
    for u in range(q):
        for v in range(q):
            if (u, v) in cellset:
                continue
            if is_arc_bruteforce(C, list(cells) + [(u, v)]):
                return False  # a cell can be added -> not maximal
    return True


def one_completion(model):
    """Return the cell-set of one maximal completion (greedy) for spot-checking."""
    ks = model.kill_self
    kt = model.kill_tri
    chosen = []
    A = model.full
    while A:
        i = (A & (-A)).bit_length() - 1
        killed = ks[i]
        for j in chosen:
            killed |= kt[i][j]
        chosen.append(i)
        A = A & ~killed & ~(1 << i)
    return model.T4cells + [model.G[i] for i in chosen]


# ---------------------------------------------------------------------------
# driver
# ---------------------------------------------------------------------------

def build_context():
    recs = c55.load_corpus([5, 7, 11, 13, 17, 19])
    table = c55.value_table(recs)
    obstr, aligned, ok = c55.gate(recs, table)
    coh = c55.cohorts(table)
    rec_by = {}
    for r in recs:
        rec_by[(r.q, r.sig_int)] = r
    return recs, table, coh, rec_by, ok


def spectrum_for(C, T4cells, exhaustive, node_cap, time_cap):
    """Return dict of spectrum properties for one config at one order."""
    model = CompletionModel(C, T4cells)
    minsz, mn_nodes, mn_trunc = model.min_size()
    out = {
        "q": C.q,
        "ground": model.m,
        "min_size": minsz,
        "min_moves": minsz - 4,
        "min_move_parity": (minsz - 4) % 2,
        "min_trunc": mn_trunc,
        "max_size": C.q - 1,  # the conic; verified below
    }
    if exhaustive:
        sizes, count, nodes, trunc = model.enum_all(node_cap=node_cap, time_cap=time_cap)
        out["count"] = None if trunc else count
        out["count_parity"] = None if trunc else count % 2
        out["dist"] = dict(sorted(sizes.items()))
        out["enum_trunc"] = trunc
        out["has_odd"] = None if trunc else any((s - 4) % 2 == 1 for s in sizes)
        out["has_even"] = None if trunc else any((s - 4) % 2 == 0 for s in sizes)
        if not trunc:
            # min from full enum must agree with the branch-and-bound min
            fullmin = min(sizes) if sizes else None
            out["minmatch"] = (fullmin == minsz)
    else:
        out["count"] = None
        out["count_parity"] = None
        out["dist"] = None
        out["enum_trunc"] = None
    return out, model


def main():
    quick = "--quick" in sys.argv
    recs, table, coh, rec_by, gate_ok = build_context()
    print(f"\nGATE ok = {gate_ok}\n")

    print("=== sanity: spot-check completions are genuine maximal arcs ===")
    checks = 0
    for pair in ("11/13", "17/19"):
        qd, qf, lat, flip, ctrl = coh[pair]
        for q in (qd,):  # cheap orders for the brute-force maximality check
            for k in (flip[:1] + ctrl[:1]):
                r = rec_by[(q, k)]
                C = Conic(q)
                T4cells = [C.cell(t) for t in params_at(r, q)]
                model = CompletionModel(C, T4cells)
                comp = one_completion(model)
                a = is_arc_bruteforce(C, comp)
                mx = is_maximal_bruteforce(C, comp)
                conic_cells = [C.cell(t) for t in range(1, q)]
                conic_ok = is_arc_bruteforce(C, conic_cells) and is_maximal_bruteforce(C, conic_cells)
                print(f"  q={q:2d} key={k}: sample completion size={len(comp)} "
                      f"is_arc={a} is_maximal={mx} | whole-conic complete arc(size {q-1})={conic_ok}")
                assert a and mx and conic_ok
                checks += 1
    print(f"  ({checks} spot-checks passed)\n")

    # sampling for the heavy orders (q=17/19 are exhaustive per config with the
    # bit-mask enumerator -- ~0.15 s at q=17, ~2.2 s at q=19 -- so we take a
    # deterministic seeded sample of configs to bound total runtime, but each
    # sampled config is fully enumerated, not truncated).
    rng = random.Random(SEED)
    FLIP_SAMPLE_1719 = 40
    CTRL_SAMPLE_1719 = 30

    results = {}  # (pair, cohort, key) -> {q: spectrum}
    order_exhaustive = {11: True, 13: True, 17: True, 19: True}
    node_caps = {11: 3_000_000, 13: 3_000_000, 17: 5_000_000, 19: 20_000_000}
    time_caps = {11: 8.0, 13: 8.0, 17: 20.0, 19: 60.0}

    for pair in ("11/13", "17/19"):
        qd, qf, lat, flip, ctrl = coh[pair]
        if pair == "11/13":
            fl_keys, ct_keys = flip, ctrl
        else:
            fl_keys = sorted(flip)
            ct_keys = sorted(ctrl)
            rng.shuffle(fl_keys)
            rng.shuffle(ct_keys)
            fl_keys = fl_keys[:FLIP_SAMPLE_1719]
            ct_keys = ct_keys[:CTRL_SAMPLE_1719]
        print(f"=== pair {pair}: enumerating flip={len(fl_keys)} control={len(ct_keys)} "
              f"(orders {qd},{qf}) ===")
        for cohname, keys in (("flip", fl_keys), ("control", ct_keys)):
            t0 = time.time()
            for k in keys:
                per_q = {}
                for q in (qd, qf):
                    if quick and q in (17, 19):
                        continue
                    r = rec_by[(q, k)]
                    C = Conic(q)
                    T4cells = [C.cell(t) for t in params_at(r, q)]
                    spec, _ = spectrum_for(
                        C, T4cells,
                        exhaustive=order_exhaustive[q],
                        node_cap=node_caps[q], time_cap=time_caps[q])
                    spec["val"] = r.val
                    per_q[q] = spec
                results[(pair, cohname, k)] = per_q
            print(f"    {cohname:7s} done in {time.time()-t0:.1f}s")
        print()

    report(coh, results, quick)
    verdict(coh, results, quick)
    return 0


def _fmt_counter(c):
    return "{" + ", ".join(f"{k}:{v}" for k, v in sorted(c.items(), key=lambda kv: (str(type(kv[0])), kv[0] if kv[0] is not None else -1))) + "}"


def report(coh, results, quick):
    print("\n########################################################################")
    print("# COMPLETION-SPECTRUM CONTINGENCY TABLES (verbatim)")
    print("########################################################################")

    for pair in ("11/13", "17/19"):
        qd, qf, lat, flip, ctrl = coh[pair]
        if quick and pair == "17/19":
            continue
        print(f"\n==================== PAIR {pair}  (depleted q={qd} -> full q={qf}) ====================")

        # gather per-cohort
        cohorts_here = {}
        for (p, cohname, k), per_q in results.items():
            if p != pair:
                continue
            cohorts_here.setdefault(cohname, []).append((k, per_q))

        # ---- min completion size (exact at all four orders) ----
        print(f"\n-- (A) MIN completion cell-size  paired (dep q={qd}, full q={qf}) --")
        for cohname in ("flip", "control"):
            paired = Counter()
            minmoveparity = Counter()
            for k, per_q in cohorts_here.get(cohname, []):
                if qd in per_q and qf in per_q:
                    md = per_q[qd]["min_size"]
                    mf = per_q[qf]["min_size"]
                    paired[(md, mf)] += 1
                    minmoveparity[(per_q[qd]["min_move_parity"], per_q[qf]["min_move_parity"])] += 1
            n = sum(paired.values())
            print(f"   {cohname:7s} n={n:3d}  (min_dep,min_full)-> count : {_fmt_counter(paired)}")
            print(f"   {cohname:7s}         (minMoveParity_dep,_full)   : {_fmt_counter(minmoveparity)}")

        # ---- distribution of min size per order (marginal) ----
        print(f"\n-- (B) MIN size marginal by order --")
        for q in (qd, qf):
            for cohname in ("flip", "control"):
                dist = Counter()
                for k, per_q in cohorts_here.get(cohname, []):
                    if q in per_q:
                        dist[per_q[q]["min_size"]] += 1
                print(f"   q={q:2d} {cohname:7s} min_size dist: {_fmt_counter(dist)}")

        # ---- number of completions + parity (exhaustive orders only) ----
        print(f"\n-- (C) #completions and parity (exhaustive orders only; None=truncated) --")
        for q in (qd, qf):
            for cohname in ("flip", "control"):
                cnts = Counter()
                pars = Counter()
                truncs = 0
                for k, per_q in cohorts_here.get(cohname, []):
                    if q not in per_q:
                        continue
                    sp = per_q[q]
                    if sp.get("enum_trunc"):
                        truncs += 1
                        pars["TRUNC"] += 1
                    else:
                        cnts[sp["count"]] += 1
                        pars[sp["count_parity"]] += 1
                print(f"   q={q:2d} {cohname:7s} count-parity dist: {_fmt_counter(pars)}   "
                      f"(distinct counts: {_fmt_counter(cnts)})  truncated={truncs}")

        # ---- paired count-parity where both orders exhaustive ----
        both_exhaustive = order_exhaustive_pair(qd, qf)
        if both_exhaustive:
            print(f"\n-- (D) PAIRED count-parity (dep,full) [both exhaustive] --")
            for cohname in ("flip", "control"):
                paired = Counter()
                for k, per_q in cohorts_here.get(cohname, []):
                    if qd in per_q and qf in per_q:
                        pd = per_q[qd].get("count_parity")
                        pf = per_q[qf].get("count_parity")
                        paired[(pd, pf)] += 1
                print(f"   {cohname:7s} (parity_dep,parity_full)->count : {_fmt_counter(paired)}")

        # ---- size distributions (a few representative, exhaustive orders) ----
        print(f"\n-- (E) representative full size-distributions (exhaustive orders) --")
        for q in (qd, qf):
            for cohname in ("flip", "control"):
                seen = set()
                reps = []
                for k, per_q in cohorts_here.get(cohname, []):
                    if q not in per_q:
                        continue
                    d = per_q[q].get("dist")
                    tr = per_q[q].get("enum_trunc")
                    key = (tuple(sorted(d.items())) if d else None, tr)
                    if key not in seen:
                        seen.add(key)
                        reps.append((d, tr))
                summary = "; ".join(
                    (f"{_fmt_counter(Counter(d))}{'[TRUNC]' if tr else ''}") for d, tr in reps[:6])
                print(f"   q={q:2d} {cohname:7s} distinct dists({len(reps)}): {summary}")


def order_exhaustive_pair(qd, qf):
    return qd in (11, 13, 17, 19) and qf in (11, 13, 17, 19)


ROLE = {11: "dep", 17: "dep", 13: "full", 19: "full"}


def verdict(coh, results, quick):
    """Strict mechanism test, pooling flip / control configs across BOTH pairs by
    order-role: depleted {11,17} vs full {13,19}.  A viable completion-spectrum
    mechanism must be (i) constant within the depleted orders, (ii) constant within
    the full orders, (iii) different across, FOR the flip cohort, and this pattern
    must NOT be reproduced by the control cohort (else it is not the flip's cause)."""
    print("\n########################################################################")
    print("# VERDICT: strict constant-within / differ-across test")
    print("#   (flip configs pooled over depleted {11,17} vs full {13,19};")
    print("#    q=17/19 restricted to the sampled configs)")
    print("########################################################################")
    props = ["count_parity", "min_size", "min_move_parity", "has_odd", "has_even"]
    any_viable = False
    for prop in props:
        print(f"\n-- property: {prop} --")
        pattern = {}
        for cohname in ("flip", "control"):
            byrole = {"dep": Counter(), "full": Counter()}
            for (p, cn, k), per_q in results.items():
                if cn != cohname:
                    continue
                for q, spec in per_q.items():
                    if quick and q in (17, 19):
                        continue
                    byrole[ROLE[q]][spec.get(prop)] += 1
            dep_vals = set(v for v in byrole["dep"] if v is not None)
            full_vals = set(v for v in byrole["full"] if v is not None)
            dep_const = len(dep_vals) == 1
            full_const = len(full_vals) == 1
            differ = dep_const and full_const and dep_vals != full_vals
            print(f"   {cohname:7s} depleted{{11,17}} dist={_fmt_counter(byrole['dep'])}"
                  f"  full{{13,19}} dist={_fmt_counter(byrole['full'])}")
            print(f"   {cohname:7s} const-within-dep={dep_const} const-within-full={full_const} "
                  f"differ-across={differ}")
            pattern[cohname] = differ
        viable = pattern.get("flip") and not pattern.get("control")
        any_viable = any_viable or viable
        print(f"   => VIABLE MECHANISM (flip differs-across AND control does not): {viable}")
    print("\n########################################################################")
    if any_viable:
        print("# C64 RESULT: a completion-spectrum property is a viable mechanism (see above).")
    else:
        print("# C64 RESULT: NEGATIVE. No completion-spectrum property is constant-within /")
        print("#   differ-across for flip while sparing control. Combined with a C55 negative,")
        print("#   promote S1 (Segre-style envelope invariants) as the remaining candidate.")
    print("########################################################################")


if __name__ == "__main__":
    raise SystemExit(main())
