#!/usr/bin/env python3
"""C71 three-involution transition analysis.

Independent, stdlib-only cross-check of the Rust `s4triple` mode
(notes/2026-07-06-grid-cap-solver.rs).  Reads one or more rows TSVs emitted by
`gridcap-c71 s4triple ... --rows <tsv>` and reproduces:

  1. The FUNCTION test: is the after-skeleton a function of (before-shape,
     three-center geometry)?  Tested at three key resolutions
       K1 = before-shape + collinear + #conjugate-pairs(d==2)
       K2 = K1 + sorted order-triple {d_xy,d_xz,d_yz}
       K3 = K2 + sorted line-type triple.
     A key mapping to >1 distinct after-shape is a residual-dependence violation.
  2. The coefficient check: dPsi decomposition and the dC histogram, confirming
     dPsi = dReservoir + 6*dC - 4*dI - 2*dXor0 with dI=+1 for every 2->3 move.

Usage:  c71_transition_analysis.py <rows.tsv> [rows2.tsv ...]

Only a rows TSV that was written UNCAPPED (--cap >= transitions) reproduces the
Rust totals exactly; a capped file reproduces the aggregates over its prefix.
The authoritative full-corpus aggregates are the S4TRIPLE-* lines the Rust mode
prints (it streams every transition; the TSV is a capped convenience sample).
"""
import sys
from collections import defaultdict

# column layout of the s4triple rows TSV
COLS = [
    "q", "parent_key", "parent_ply", "parent_g", "child_g",
    "x", "y", "z", "xgeom", "ygeom", "zgeom",
    "collinear", "d_xy", "d_xz", "d_yz", "lt_xy", "lt_xz", "lt_yz",
    "before_shape", "after_shape", "dC", "dReservoir", "dPsi",
]


def load(paths):
    rows = []
    for p in paths:
        with open(p) as f:
            header = f.readline().rstrip("\n").split("\t")
            assert header == COLS, f"{p}: unexpected header {header}"
            for line in f:
                parts = line.rstrip("\n").split("\t")
                rows.append(dict(zip(COLS, parts)))
    return rows


def geom_keys(r):
    ds = sorted(int(r[k]) for k in ("d_xy", "d_xz", "d_yz"))
    lts = sorted(int(r[k]) for k in ("lt_xy", "lt_xz", "lt_yz"))
    conj = sum(1 for k in ("d_xy", "d_xz", "d_yz") if int(r[k]) == 2)
    before = r["before_shape"]
    col = r["collinear"]
    k1 = f"{before}|col{col}|conj{conj}"
    k2 = f"{k1}|d{ds}"
    k3 = f"{k2}|lt{lts}"
    return k1, k2, k3


def function_test(rows):
    maps = [defaultdict(lambda: defaultdict(int)) for _ in range(3)]
    for r in rows:
        after = r["after_shape"]
        for m, k in zip(maps, geom_keys(r)):
            m[k][after] += 1
    out = []
    for name, m in zip(("K1", "K2", "K3"), maps):
        keys = len(m)
        viol = sum(1 for h in m.values() if len(h) > 1)
        vt = sum(sum(h.values()) for h in m.values() if len(h) > 1)
        out.append((name, keys, viol, vt))
    return out, maps[2]


def coef_check(rows):
    dc_hist = defaultdict(int)
    psi_le = 0
    skel_le = 0
    decomp_ok = 0
    psi_up = []
    for r in rows:
        dC = int(r["dC"])
        dRes = int(r["dReservoir"])
        dPsi = int(r["dPsi"])
        dc_hist[dC] += 1
        if dPsi <= 0:
            psi_le += 1
        else:
            psi_up.append(r)
        if 6 * dC - 4 <= 0:
            skel_le += 1
        # dPsi = dRes + 6dC - 4 - 2*dXor0  => dXor0 recovered as an integer in {-1,0,1}
        implied_2dx = dRes + 6 * dC - 4 - dPsi
        if implied_2dx % 2 == 0 and -1 <= implied_2dx // 2 <= 1:
            decomp_ok += 1
    return dc_hist, psi_le, skel_le, decomp_ok, psi_up


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    rows = load(sys.argv[1:])
    n = len(rows)
    print(f"C71-ANALYSIS files={len(sys.argv)-1} transitions={n}")
    ft, k3map = function_test(rows)
    for name, keys, viol, vt in ft:
        print(f"  {name} keys={keys} violations={viol} viol_trans={vt} "
              f"({100.0*vt/max(n,1):.1f}% of transitions)")
    dc_hist, psi_le, skel_le, decomp_ok, psi_up = coef_check(rows)
    print("  dC_hist " + " ".join(f"{k}:{dc_hist[k]}" for k in sorted(dc_hist)))
    print(f"  decomposition dPsi=dRes+6dC-4-2dXor0 holds: {decomp_ok}/{n}")
    print(f"  skel(6dC-4)<=0: {skel_le}/{n}   dPsi<=0: {psi_le}/{n}   dPsi>0: {len(psi_up)}")
    # distinct after-shapes on the worst (max fan-out) K3 key
    worst = max(k3map.items(), key=lambda kv: len(kv[1]), default=(None, {}))
    if worst[0] is not None:
        print(f"  worst K3 key fan-out={len(worst[1])}: {worst[0]}")
        for after, c in sorted(worst[1].items(), key=lambda kv: -kv[1]):
            print(f"      after={after} count={c}")


if __name__ == "__main__":
    main()
