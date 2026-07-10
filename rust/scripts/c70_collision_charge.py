#!/usr/bin/env python3
"""C70: exact reservoir-slack collision charge.

Untruncates Psi's reservoir term.  The current C63 coordinate is

    R_code(S) = reservoir_slack_total
              = max(0, zone_v - (q-k) * max(0, q-k-C(k,2)-1))     (two truncations)

C70 replaces it by the untruncated collision-multiplicity charge

    M(S) = zone_v - (q-k) * (q-k-C(k,2)-1)                         (no truncation)

which is a genuine incidence quantity: over the q-k unoccupied columns, the
nominal blocker incidences are k (played rows) + C(k,2) (secants) + 1 (conic
trace) per column, so (q-k)(q-k-C(k,2)-1) = (cells in unused columns) - (nominal
incidences), and

    M(S) = (nominal incidences) - (distinct non-live cells)
         = collision multiplicity surplus  +  delta0col

where delta0col = 1 iff column 0 is unoccupied (col 0 carries no conic point, so
the "1 conic per column" nominal over-counts there by exactly 1).  See
verify_identity() for the machine proof of this decomposition.

Subcommands:
  verify   -- item 1: reconstruct geometry, confirm zone_v and M = E + delta0col.
  replay   -- item 3: replay Psi_exact over q13/q17/q19; reproduce original Psi too.
  splits   -- item 4: the 12 q19 fixed-C31 failures under the exact charge.
  averaging-- item 5: mean dPsi_exact over reply families (from a per-obligation dump).
"""
from __future__ import annotations

import argparse
import csv
import glob
import os
import sys
from math import comb

# ---- original promoted Psi (C63) ----------------------------------------------------
W_ORIG = {
    "reservoir_slack_total": 1,
    "defect_components": 6,
    "interface_intruders": -4,
    "conic_xor_zero": -2,
}


def floor_poly(q: int, k: int) -> int:
    """Untruncated reservoir floor (q-k)(q-k-C(k,2)-1); may be negative."""
    return (q - k) * (q - k - comb(k, 2) - 1)


def m_charge(q: int, k: int, zone_v: int) -> int:
    return zone_v - floor_poly(q, k)


# ---- geometry (prime q only: GF(q) = integers mod q) --------------------------------
def inv_table(q: int) -> list[int]:
    t = [0] * q
    for x in range(1, q):
        t[x] = pow(x, q - 2, q)
    return t


def on_conic(r: int, c: int, inv: list[int]) -> bool:
    return r != 0 and c == inv[r]


def line_cells(q: int, p1: tuple[int, int], p2: tuple[int, int]):
    (r1, c1), (r2, c2) = p1, p2
    dr = (r2 - r1) % q
    dc = (c2 - c1) % q
    return [((r1 + t * dr) % q, (c1 + t * dc) % q) for t in range(q)]


def reconstruct(q: int, cells: list[tuple[int, int]], inv: list[int]):
    """Return (zone_v, forbidden_set, chosen_set)."""
    chosen = set(cells)
    forbidden: set[tuple[int, int]] = set()
    for (r, c) in cells:
        for cc in range(q):
            forbidden.add((r, cc))
        for rr in range(q):
            forbidden.add((rr, c))
    for i in range(len(cells)):
        for j in range(i + 1, len(cells)):
            for cell in line_cells(q, cells[i], cells[j]):
                forbidden.add(cell)
    zone_v = 0
    for r in range(q):
        for c in range(q):
            if (r, c) in chosen:
                continue
            if (r, c) in forbidden:
                continue
            if on_conic(r, c, inv):
                continue
            zone_v += 1
    return zone_v, forbidden, chosen


def collision_surplus(q: int, cells: list[tuple[int, int]], inv: list[int]):
    """Exact collision multiplicity E over unoccupied columns, plus delta0col.

    Nominal blockers claiming a cell in an unoccupied column:
      - played-row lines: cell (rp, c) for each played point (rp,cp);
      - secant lines through each played pair (crosses each unused column once);
      - the conic trace: cell (inv[c], c) for unused column c != 0.
    E = sum over unused-column cells of max(0, mult-1).
    """
    used_cols = {c for (_, c) in cells}
    unused_cols = [c for c in range(q) if c not in used_cols]
    mult: dict[tuple[int, int], int] = {}

    def bump(cell):
        mult[cell] = mult.get(cell, 0) + 1

    # played rows
    for (rp, _cp) in cells:
        for c in unused_cols:
            bump((rp, c))
    # secants
    for i in range(len(cells)):
        for j in range(i + 1, len(cells)):
            for (r, c) in line_cells(q, cells[i], cells[j]):
                if c in used_cols:
                    continue
                bump((r, c))
    # conic trace (one per unused column, except column 0)
    for c in unused_cols:
        if c == 0:
            continue
        bump((inv[c], c))
    E = sum(max(0, v - 1) for v in mult.values())
    delta0col = 1 if 0 not in used_cols else 0
    return E, delta0col


def parse_cells(text: str) -> list[tuple[int, int]]:
    out = []
    for tok in text.split(";"):
        r, c = tok.split(",")
        out.append((int(r), int(c)))
    return out


# ---- item 1: verify -----------------------------------------------------------------
def cmd_verify(args):
    paths = sorted(glob.glob(os.path.join(args.data, "q13-bucket*.transitions.tsv")))
    paths += sorted(glob.glob(os.path.join(args.data, "q17-bucket0[0-2]*.transitions.tsv")))
    checked = 0
    zone_mismatch = 0
    identity_mismatch = 0
    seen_keys: set[str] = set()
    examples = []
    delta0_hist = {0: 0, 1: 0}
    invs: dict[int, list[int]] = {}
    for path in paths:
        with open(path, newline="") as f:
            for row in csv.DictReader(f, delimiter="\t"):
                q = int(row["q"])
                if q not in invs:
                    invs[q] = inv_table(q)
                inv = invs[q]
                for side in ("parent", "child"):
                    key = row[f"{side}_key"]
                    if key in seen_keys:
                        continue
                    seen_keys.add(key)
                    cells = parse_cells(row[f"{side}_cells"])
                    zone_tsv = int(row[f"{side}_zone_v"])
                    k = int(row[f"{side}_ply"])
                    zone_v, _forb, _ch = reconstruct(q, cells, inv)
                    if zone_v != zone_tsv:
                        zone_mismatch += 1
                        if len(examples) < 5:
                            examples.append(("ZONE", key, zone_v, zone_tsv))
                    M = m_charge(q, k, zone_v)
                    E, d0 = collision_surplus(q, cells, inv)
                    delta0_hist[d0] += 1
                    if M != E + d0:
                        identity_mismatch += 1
                        if len(examples) < 10:
                            examples.append(("IDENT", key, M, E, d0))
                    checked += 1
                    if checked >= args.limit:
                        break
            if checked >= args.limit:
                break
    print(f"C70-VERIFY states={checked} zone_mismatch={zone_mismatch} "
          f"identity_mismatch={identity_mismatch} delta0col_hist={delta0_hist}")
    print("  claim: reconstructed zone_v == TSV zone_v, and "
          "M = zone_v-(q-k)(q-k-C(k,2)-1) == collision_surplus E + delta0col")
    for ex in examples:
        print("  EX", ex)
    if zone_mismatch == 0 and identity_mismatch == 0:
        print("  PASS: geometry and collision identity hold on all sampled states.")


# ---- item 3: replay -----------------------------------------------------------------
def corpus_paths(data: str, q: int) -> list[str]:
    if q == 13:
        return sorted(glob.glob(os.path.join(data, "c63", "q13-bucket*.transitions.tsv")))
    if q == 17:
        return sorted(glob.glob(os.path.join(data, "c63", "q17-bucket*.transitions.tsv")))
    if q == 19:
        return [os.path.join(data, "c63-q19", "q19-root-1234.transitions.tsv")]
    raise ValueError(q)


def row_deltas(row):
    q = int(row["q"])
    pk = int(row["parent_ply"])
    ck = int(row["child_ply"])
    pz = int(row["parent_zone_v"])
    cz = int(row["child_zone_v"])
    # original Psi delta
    d_orig = sum(
        w * (int(row[f"child_{n}"]) - int(row[f"parent_{n}"]))
        for n, w in W_ORIG.items()
    )
    # exact Psi delta: swap reservoir_slack_total -> M
    dM = m_charge(q, ck, cz) - m_charge(q, pk, pz)
    d_slack = int(row["child_reservoir_slack_total"]) - int(row["parent_reservoir_slack_total"])
    d_exact = d_orig - d_slack + dM
    return d_orig, d_exact


def replay_corpus(paths, label):
    rows = 0
    fo = fe = 0
    ro = [None, None]
    re = [None, None]
    worst_o = None
    worst_e = None
    for path in paths:
        with open(path, newline="") as f:
            for row in csv.DictReader(f, delimiter="\t"):
                d_orig, d_exact = row_deltas(row)
                rows += 1
                if d_orig >= 0:
                    fo += 1
                    if worst_o is None or d_orig > worst_o[0]:
                        worst_o = (d_orig, row["parent_key"], row["parent_ply"],
                                   row["opponent"], row["reply"])
                if d_exact >= 0:
                    fe += 1
                    if worst_e is None or d_exact > worst_e[0]:
                        worst_e = (d_exact, row["parent_key"], row["parent_ply"],
                                   row["opponent"], row["reply"])
                ro[0] = d_orig if ro[0] is None else min(ro[0], d_orig)
                ro[1] = d_orig if ro[1] is None else max(ro[1], d_orig)
                re[0] = d_exact if re[0] is None else min(re[0], d_exact)
                re[1] = d_exact if re[1] is None else max(re[1], d_exact)
    print(f"C70-REPLAY {label} rows={rows}")
    print(f"  original Psi : failures={fo} delta_range=[{ro[0]},{ro[1]}]"
          + (f" worst={worst_o}" if worst_o else ""))
    print(f"  exact   Psi : failures={fe} delta_range=[{re[0]},{re[1]}]"
          + (f" worst={worst_e}" if worst_e else ""))
    return rows, fo, fe


def cmd_replay(args):
    total = {}
    for q in args.q:
        paths = corpus_paths(args.data, q)
        total[q] = replay_corpus(paths, f"q={q}")
    print("C70-REPLAY-SUMMARY", {q: {"rows": v[0], "orig_fail": v[1], "exact_fail": v[2]}
                                  for q, v in total.items()})


# ---- item 4 + item 5: consolidated q19 pass -----------------------------------------
def cmd_q19(args):
    """One streaming pass over q19: item-3 naive-exact replay, item-4 hard-surface
    breakdown, item-5 per-parent reply-family averaging."""
    from collections import defaultdict
    path = os.path.join(args.data, "c63-q19", "q19-root-1234.transitions.tsv")
    hard = "0b7a91f6b96e82780d0fe4202f22b126"
    n = fo = fe = 0
    ro = [None, None]
    re = [None, None]
    psum_o: dict = defaultdict(float)
    psum_e: dict = defaultdict(float)
    pcnt: dict = defaultdict(int)
    hard_fail = []      # original failures at the hard parent
    hard_offsets = set()
    with open(path, newline="") as f:
        for row in csv.DictReader(f, delimiter="\t"):
            n += 1
            d_orig, d_exact = row_deltas(row)
            if d_orig >= 0:
                fo += 1
            if d_exact >= 0:
                fe += 1
            for r, d in ((ro, d_orig), (re, d_exact)):
                r[0] = d if r[0] is None else min(r[0], d)
                r[1] = d if r[1] is None else max(r[1], d)
            k = row["parent_key"]
            psum_o[k] += d_orig
            psum_e[k] += d_exact
            pcnt[k] += 1
            if k == hard:
                hard_offsets.add(d_exact - d_orig)
                if d_orig >= 0:
                    hard_fail.append((row["opponent"], row["reply"], d_orig, d_exact))
    print(f"C70-Q19 rows={n}")
    print(f"  [item3] original  Psi failures={fo} range=[{ro[0]},{ro[1]}]")
    print(f"  [item3] naive-exact Psi (w=1 on M) failures={fe} range=[{re[0]},{re[1]}]")
    print(f"  [item5] parents={len(pcnt)}  "
          f"mean(dPsi_orig)>=0: {sum(1 for k in pcnt if psum_o[k]/pcnt[k] >= 0)}  "
          f"mean(dPsi_exact_naive)>=0: {sum(1 for k in pcnt if psum_e[k]/pcnt[k] >= 0)}")
    print(f"  [item5] hard parent mean dPsi_orig={psum_o[hard]/pcnt[hard]:.3f} "
          f"mean dPsi_exact_naive={psum_e[hard]/pcnt[hard]:.3f} n={pcnt[hard]}")
    print(f"  [item4] hard-parent per-obligation offset (dPsi_exact - dPsi_orig) "
          f"distinct values across all its obligations: {sorted(hard_offsets)} "
          f"(constant => untruncation adds a reply-independent per-obligation constant)")
    print(f"  [item4] original failures at hard parent = {len(hard_fail)}:")
    for opp, rep, do, de in hard_fail:
        print(f"     opp={opp:>6} reply={rep:>6}  dPsi_orig={do:>+4} dPsi_exact_naive={de:>+4}")


# ---- item 3 (refit): LP over the exact charge ---------------------------------------
# Full V2 geometric span (C63 round-2), then M and E appended.
V2 = [
    "conic_xor", "conic_xor_zero", "zone_parity",
    "reservoir_slack_total", "reservoir_slack_min",
    "defect_components", "defect_paths", "defect_odd_components",
    "defect_max_path", "defect_path_sum_sq",
    "interface_intruders", "interface_endpoints", "interface_isolates",
]
AUG = V2 + ["M", "E"]

SPANS = {
    "A_baseline_slack": ["reservoir_slack_total", "defect_components",
                         "interface_intruders", "conic_xor_zero"],
    "B_exact_M":        ["M", "defect_components", "interface_intruders", "conic_xor_zero"],
    "C_collision_E":    ["E", "defect_components", "interface_intruders", "conic_xor_zero"],
    "D_v2_plus_M":      V2 + ["M"],
    "E_v2_plus_M_E":    V2 + ["M", "E"],
}


def state_M_E(row, side):
    q = int(row["q"])
    k = int(row[f"{side}_ply"])
    z = int(row[f"{side}_zone_v"])
    cells = parse_cells(row[f"{side}_cells"])
    M = z - floor_poly(q, k)
    delta0col = 1 if all(c != 0 for (_, c) in cells) else 0
    E = M - delta0col
    return M, E


def row_aug_delta(row):
    pM, pE = state_M_E(row, "parent")
    cM, cE = state_M_E(row, "child")
    d = {}
    for n in V2:
        d[n] = int(row[f"child_{n}"]) - int(row[f"parent_{n}"])
    d["M"] = cM - pM
    d["E"] = cE - pE
    return d


def cmd_refit(args):
    import numpy as np
    from scipy.optimize import linprog

    fit_paths = corpus_paths(args.data, 13) + corpus_paths(args.data, 17)
    uniq: set[tuple] = set()
    for path in fit_paths:
        with open(path, newline="") as f:
            for row in csv.DictReader(f, delimiter="\t"):
                d = row_aug_delta(row)
                uniq.add(tuple(d[n] for n in AUG))
    D = np.asarray(sorted(uniq), dtype=np.float64)
    idx = {n: i for i, n in enumerate(AUG)}
    print(f"C70-REFIT fit=q13+q17 unique_constraints={D.shape[0]} aug_features={len(AUG)}")

    results = {}
    for name, feats in SPANS.items():
        cols = [idx[f] for f in feats]
        Dm = D[:, cols]
        n = Dm.shape[1]
        res = linprog(
            np.ones(2 * n),
            A_ub=np.hstack((Dm, -Dm)),
            b_ub=-np.ones(Dm.shape[0]),
            bounds=(0, None),
            method="highs",
        )
        feasible = res.success
        w = None
        if feasible:
            wp = res.x[:n]
            wn = res.x[n:]
            w = wp - wn
        results[name] = {"feasible": feasible, "features": feats,
                         "weights": None if w is None else [round(float(x), 6) for x in w]}
        print(f"  span {name}: feasible={feasible}", end="")
        if feasible:
            wtxt = ", ".join(f"{f}={round(float(x),4)}" for f, x in zip(feats, w)
                             if abs(x) > 1e-9)
            print(f"  w=[{wtxt}]")
        else:
            print(f"  status={res.message}")

    # frozen q19 transfer for each feasible span
    q19 = corpus_paths(args.data, 19)
    print("C70-REFIT-Q19-TRANSFER (frozen fitted weights on q=19 fixed-selector)")
    for name, feats in SPANS.items():
        if not results[name]["feasible"]:
            continue
        w = np.asarray(results[name]["weights"], dtype=np.float64)
        cols = [idx[f] for f in feats]
        rows = fails = 0
        worst = None
        mind = maxd = None
        for path in q19:
            with open(path, newline="") as f:
                for row in csv.DictReader(f, delimiter="\t"):
                    d = row_aug_delta(row)
                    dv = sum(w[j] * d[feats[j]] for j in range(len(feats)))
                    rows += 1
                    if dv >= -1e-9:
                        fails += 1
                        if worst is None or dv > worst[0]:
                            worst = (dv, row["parent_key"], row["parent_ply"],
                                     row["opponent"], row["reply"])
                    mind = dv if mind is None else min(mind, dv)
                    maxd = dv if maxd is None else max(maxd, dv)
        print(f"  span {name}: q19 rows={rows} failures={fails} "
              f"delta_range=[{mind:.3f},{maxd:.3f}]"
              + (f" worst={worst}" if worst else ""))

    import json
    with open(args.out, "w") as f:
        json.dump({"results": results}, f, indent=2)
    print(f"C70-REFIT wrote {args.out}")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["verify", "replay", "q19", "refit"])
    ap.add_argument("--out", default="s4-dumps/2026-07-10/c70/refit-results.json")
    ap.add_argument("--data", default="s4-dumps/2026-07-10")
    ap.add_argument("--limit", type=int, default=100000)
    ap.add_argument("--q", type=int, nargs="+", default=[13, 17, 19])
    args = ap.parse_args()
    if args.cmd == "verify":
        # verify reads the c63 subdir
        args.data = os.path.join(args.data, "c63")
        cmd_verify(args)
    elif args.cmd == "replay":
        cmd_replay(args)
    elif args.cmd == "q19":
        cmd_q19(args)
    elif args.cmd == "refit":
        cmd_refit(args)


if __name__ == "__main__":
    main()
