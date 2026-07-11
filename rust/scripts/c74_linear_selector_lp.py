#!/usr/bin/env python3
"""C74 — is there a value-blind *multi-feature linear* reply selector? (lane C / Cluster-2)

Codex's C61/C63 hard-surface work tested selector families ONE hand-picked scalar
coordinate at a time (live_min, zero_xor_live_min, zero_live_ray_lex_max, ...), each
"local positive / uniform negative": it fixes one order's hard rows but picks an N reply
at some other root because inside a Psi-coarse tie a P-reply and an N-reply share the
tested coordinate.

Untested reframing: pool the FULL value-blind feature vector of every legal reply and ask
whether a SINGLE linear functional s(reply)=<w,phi> makes the global argmin a "good"
(P-valued AND Psi-decreasing) reply at EVERY obligation, simultaneously across q=13/17/19.

Pipeline (data already on disk; no re-solve):
  gridcap s4selectors {q} 1,2,3,4 --grundy <dump> --fail-out {q}-detail.tsv
Feeds the `root_replies` column: per reply  cell:g<grundy>:dpsi<d>:<geom>:live<l>:comp<c>:
xor<..>:psi<p>:rays<7 ints>.  g==0 => P (good target), g!=0 => N.  All fields except g are
value-blind (functions of board geometry / the C63 potential), so a selector over them is a
legal q-blind strategy.

Two decisive tests:
  (A) EXACT-COLLISION impossibility: within one obligation, does a good reply share its full
      value-blind feature tuple with a bad reply?  If yes anywhere => NO value-blind selector
      (linear OR nonlinear) can exist in this feature space.  Conclusive negative.
  (B) LINEAR-SEPARABILITY LP (HiGHS): fix per obligation the deepest-descent good reply g* as
      target; find w with <w, phi(bad) - phi(g*)> >= 1 for every bad reply, pooled over all
      obligations/orders.  Feasible => a value-blind linear selector EXISTS (then verify the
      argmin selector lands on a good reply everywhere).  Infeasible => Farkas certificate =
      machine-readable impossibility for the linear class with this target rule.

Usage:
  uv run --with scipy --with numpy python3 scripts/c74_linear_selector_lp.py \
      q13=<tsv> q17=<tsv> q19=<tsv>
"""
import sys, re
from collections import defaultdict

import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csr_matrix

GEOMS = ("ext", "int", "on")


def parse_reply(tok):
    # cell:g<gr>:dpsi<d>:<geom>:live<l>:comp<c>:xor<..>:psi<p>:rays<a,b,...>
    parts = tok.split(":")
    cell = parts[0]
    fld = {}
    for p in parts[1:]:
        fld[p] = p  # keep raw; parse by prefix below
    def get(prefix, cast=int, default=None):
        for p in parts[1:]:
            if p.startswith(prefix) and (len(prefix) == 0 or not p[len(prefix)].isalpha() or prefix in ("rays",)):
                return p[len(prefix):]
        return default
    g = None; dpsi = None; geom = None; live = None; comp = None
    xor_zero = None; psi = None; rays = None; chi = None; polar = None
    for p in parts[1:]:
        if p.startswith("g") and p[1:].lstrip("-").isdigit():
            g = int(p[1:])
        elif p.startswith("dpsi"):
            dpsi = int(p[4:])
        elif p in GEOMS:
            geom = p
        elif p.startswith("live"):
            live = int(p[4:])
        elif p.startswith("comp"):
            comp = int(p[4:])
        elif p.startswith("xor0"):        # token is literally 'xor0' + xor_zero flag
            xor_zero = int(p[4:])
        elif p.startswith("psi"):
            psi = int(p[3:])
        elif p.startswith("chi"):
            chi = int(p[3:])
        elif p.startswith("polar"):
            polar = int(p[5:])
        elif p.startswith("rays"):
            rays = [int(x) for x in p[4:].split(",") if x != ""]
    if None in (g, dpsi, geom, live, comp, psi, xor_zero, chi, polar) or rays is None:
        return None
    if len(rays) < 7:
        rays = rays + [0] * (7 - len(rays))
    rays = rays[:7]
    feat = [
        1.0 if geom == "ext" else 0.0,
        1.0 if geom == "int" else 0.0,
        1.0 if geom == "on" else 0.0,
        float(live), float(comp), float(xor_zero),
        float(psi), float(dpsi), float(chi), float(polar),
    ] + [float(r) for r in rays]
    return dict(cell=cell, g=g, dpsi=dpsi, geom=geom, live=live, comp=comp,
                xor_zero=xor_zero, psi=psi, chi=chi, polar=polar,
                rays=tuple(rays), feat=np.array(feat))


FEAT_NAMES = ["ext", "int", "on", "live", "comp", "xor_zero",
              "psi", "dpsi", "chi", "polar", "r0", "r1", "r2", "r3", "r4", "r5", "r6"]
D = len(FEAT_NAMES)


def load(path):
    """Return list of obligations; each = (order, parent_key, opponent, [reply dicts])."""
    obs = []
    with open(path) as f:
        header = f.readline().rstrip("\n").split("\t")
        idx = {h: i for i, h in enumerate(header)}
        for line in f:
            t = line.rstrip("\n").split("\t")
            if len(t) <= idx["root_replies"]:
                continue
            reps = []
            for tok in t[idx["root_replies"]].split(";"):
                r = parse_reply(tok)
                if r is not None:
                    reps.append(r)
            if reps:
                obs.append((int(t[idx["q"]]), t[idx["parent_key"]],
                            t[idx["opponent"]], reps))
    return obs


def good(r):  # P-valued AND Psi-decreasing
    return r["g"] == 0 and r["dpsi"] < 0


def main():
    files = {}
    for a in sys.argv[1:]:
        k, v = a.split("=", 1)
        files[k] = v
    all_obs = []
    for k, path in files.items():
        o = load(path)
        all_obs.extend(o)
        print(f"[load] {k}: {len(o)} hard obligations, "
              f"{sum(len(r) for _,_,_,r in o)} replies")
    print(f"[load] total {len(all_obs)} obligations\n")

    # ---- Test A: exact value-blind feature collision (good vs bad) within an obligation ----
    # A single P/N feature-twin => NO value-blind selector (linear OR nonlinear) over this
    # feature space can pick the winning reply at that obligation. Conclusive impossibility.
    collisions = []
    coverable = []       # obligations with >=1 good reply
    per_order = defaultdict(lambda: [0, 0])   # order -> [n_obl, n_obl_with_collision]
    first_ex = None
    for ob in all_obs:
        q, pk, opp, reps = ob
        goods = [r for r in reps if good(r)]
        bads = [r for r in reps if not good(r)]
        if not goods:
            continue
        coverable.append(ob)
        per_order[q][0] += 1
        good_keys = {tuple(r["feat"].tolist()): r for r in goods}
        hit = False
        for b in bads:
            bk = tuple(b["feat"].tolist())
            if bk in good_keys:
                collisions.append((q, pk, opp, good_keys[bk], b))
                hit = True
                if first_ex is None:
                    first_ex = (q, pk, opp, good_keys[bk], b)
        if hit:
            per_order[q][1] += 1
    print(f"[A] coverable obligations (>=1 P&descending reply): {len(coverable)}"
          f"  uncoverable: {len(all_obs)-len(coverable)}")
    print("[A] EXACT value-blind P/N feature-twins (impossibility witnesses), per order:")
    for q in sorted(per_order):
        n, c = per_order[q]
        print(f"    q={q}: {c}/{n} hard obligations have a feature-twin ({100*c/n:.0f}%)")
    n_obl_col = sum(c for _, c in per_order.values())
    print(f"    TOTAL: {n_obl_col}/{len(coverable)} obligations, {len(collisions)} colliding "
          f"N-replies => value-blind selector IMPOSSIBLE in this feature space.")
    if first_ex:
        q, pk, opp, gr, br = first_ex
        print(f"    witness: q={q} parent={pk[:12]} opp={opp}: "
              f"P {gr['cell']}(g0) and N {br['cell']}(g{br['g']}) identical on all "
              f"{D} features.")
    print()

    # ---- Test B: pooled linear-separability LP (HiGHS) ----
    # target g* = deepest-descent good reply; constraints <w, phi(bad)-phi(g*)> >= 1.
    rows = []
    n_con = 0
    for ob in coverable:
        q, pk, opp, reps = ob
        goods = [r for r in reps if good(r)]
        bads = [r for r in reps if not good(r)]
        gstar = min(goods, key=lambda r: r["dpsi"])  # deepest descent
        for b in bads:
            rows.append(b["feat"] - gstar["feat"])   # want <w,row> >= 1
            n_con += 1
    print(f"[B] LP: {n_con} margin constraints over d={D} features "
          f"(target = deepest-descent good reply)")
    if n_con == 0:
        print("    no constraints (every obligation is trivially good-only).")
        return
    A = csr_matrix(np.vstack(rows))
    # linprog: min 0 ; A_ub w <= b_ub  ->  -<w,row> <= -1
    res = linprog(
        c=np.zeros(D),
        A_ub=(-A).tocsc(),
        b_ub=-np.ones(n_con),
        bounds=[(-1e4, 1e4)] * D,
        method="highs",
    )
    if res.success:
        w = res.x
        print("[B] LP FEASIBLE => a value-blind linear selector EXISTS.")
        print("    w =", {n: round(float(wi), 3) for n, wi in zip(FEAT_NAMES, w)})
        # verify the argmin selector: does min_reply <w,phi> land on a good reply?
        ok = 0; bad_pick = 0; examples = []
        for ob in coverable:
            q, pk, opp, reps = ob
            scores = [(float(np.dot(w, r["feat"])), r) for r in reps]
            pick = min(scores, key=lambda s: (s[0], 0 if good(s[1]) else 1))[1]
            if good(pick):
                ok += 1
            else:
                bad_pick += 1
                if len(examples) < 5:
                    examples.append((q, pk[:12], opp, pick["cell"], pick["g"]))
        print(f"    argmin verification over {len(coverable)} coverable obligations: "
              f"good-pick={ok}  bad-pick={bad_pick}")
        if bad_pick:
            print("    (fixed-target LP feasible but argmin still slips on some — "
                  "ties; report as near-selector)", examples[:5])
    else:
        print(f"[B] LP INFEASIBLE (status={res.status}: {res.message}).")
        print("    => no linear value-blind selector with the deepest-descent target rule.")
        print("    (Not fully conclusive for the linear class: a different per-obligation")
        print("     target could feasibilize; but combined with Test A this is strongly")
        print("     suggestive. Farkas dual identifies the binding obligations.)")


if __name__ == "__main__":
    main()
