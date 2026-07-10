#!/usr/bin/env python3
"""C69 follow-up (Fable steering correction 3): does the C63 amortized potential Psi
-- the program's only VALIDATED dynamic quantity -- discriminate the flipping configs
from matched controls, where the three static Cluster-1 candidates (C55 group / C64
extremal / C69 algebraic) all failed?

All three dead candidates tested STATIC invariants of the 6-point configuration.  Psi is
a coupled dynamic ledger (reservoir slack, live-conic defect skeleton, conic/zone
interface, xor) and postdates all three (levers compound).  This probe computes Psi on
the actual on-conic S4 cells via the convention-safe `s4potentialprobecells` mode (no
param translation trusted) and, per depleted/full pair, compares:

  flip    : N at the depleted order qd, P at the full order qf (the value flip).
  control : present at both qd,qf with the SAME value (matched non-flipping config).

Discriminating question (the dynamic analogue of C64/C69): does Psi at qd, Psi at qf, or
the per-config jump delta = Psi(qf) - Psi(qd) SEPARATE flip from control (disjoint
ranges) -- the separation the static invariants never achieved?

Run from repo root:  python3 rust/scripts/c69_psi_flip_probe.py [binary]
"""
from __future__ import annotations

import os
import subprocess
import sys
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import c55_side_switch as c55  # noqa: E402  corpus + value_table + cohorts

BINARY = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "target", "gridcap-c63")
CORPUS_QS = [5, 7, 11, 13, 17, 19]


def cells_by_key_q(recs):
    """(sig_int key, q) -> representative 4 played cells (s3 U {x})."""
    out = {}
    for r in recs:
        out.setdefault((r.sig_int, r.q), tuple(r.s3) + (r.x,))
    return out


def probe(q, cell_tuple):
    args = [BINARY, "s4potentialprobecells", str(q)] + [f"{r},{c}" for (r, c) in cell_tuple]
    out = subprocess.run(args, capture_output=True, text=True, check=True).stdout.strip()
    feats = {}
    for tok in out.split():
        name, _, v = tok.partition("=")
        if _ and v.lstrip("-").isdigit():
            feats[name] = int(v)
    return feats


FEATS = ["c63_candidate", "reservoir_slack_total", "defect_components",
         "interface_intruders", "conic_xor_zero", "live_on", "zone_v"]

# The coupled/dynamic core of Psi (what the static candidates could NOT see).  A separation
# on these is a genuine flip mechanism.  reservoir_slack_total / zone_v / live_on are size
# terms that at the ply-4 root track (q, value), so a separation there at qd is confounded
# by the value if the controls are not value-matched at qd (they are P@qd here) -- it is the
# within-order N-vs-P correlate C55 already saw, not a cross-q dictionary.
COUPLED = {"defect_components", "interface_intruders", "conic_xor_zero"}


def stat(xs):
    return f"n={len(xs):3d} range=[{min(xs)},{max(xs)}] mean={sum(xs)/len(xs):6.2f}" if xs else "n=0"


def separates(a, b):
    """True iff the two value-lists occupy disjoint ranges (a clean threshold exists)."""
    if not a or not b:
        return False
    return max(a) < min(b) or max(b) < min(a)


def main():
    recs = c55.load_corpus(CORPUS_QS)
    table = c55.value_table(recs)
    coh = c55.cohorts(table)
    cells = cells_by_key_q(recs)

    # cache probe results: (q, key) -> feats
    cache = {}

    def feats_of(q, key):
        if (q, key) not in cache:
            cache[(q, key)] = probe(q, cells[(key, q)])
        return cache[(q, key)]

    coupled_hits = []  # (pair, feat, where) -- genuine flip mechanism if non-empty
    for name, (qd, qf, lat, flip, ctrl) in coh.items():
        from collections import Counter
        cvd = Counter(table[k][qd] for k in ctrl)
        matched = sum(1 for k in ctrl if table[k][qd] == "N")
        print(f"\n########## pair {name}  (depleted qd={qd} N-flip -> full qf={qf} P)  "
              f"flip={len(flip)} control={len(ctrl)} ##########")
        print(f"  control value@q{qd} = {dict(cvd)}  -> value-matched (N@qd) controls: "
              f"{matched}/{len(ctrl)}  (0 => qd separations are value-confounded)")
        # per feature: gather qd, qf, and delta for each cohort
        for feat in FEATS:
            fd = [feats_of(qd, k)[feat] for k in flip]
            ff = [feats_of(qf, k)[feat] for k in flip]
            cd = [feats_of(qd, k)[feat] for k in ctrl]
            cf = [feats_of(qf, k)[feat] for k in ctrl]
            f_delta = [feats_of(qf, k)[feat] - feats_of(qd, k)[feat] for k in flip]
            c_delta = [feats_of(qf, k)[feat] - feats_of(qd, k)[feat] for k in ctrl]
            sep_qd = separates(fd, cd)
            sep_qf = separates(ff, cf)
            sep_delta = separates(f_delta, c_delta)
            flag = "  <== SEPARATES" if (sep_qd or sep_qf or sep_delta) else ""
            print(f"  {feat:22s}{flag}")
            print(f"     flip    q{qd}: {stat(fd)}   q{qf}: {stat(ff)}   delta: {stat(f_delta)}")
            print(f"     control q{qd}: {stat(cd)}   q{qf}: {stat(cf)}   delta: {stat(c_delta)}")
            if sep_qd or sep_qf or sep_delta:
                where = [w for w, s in ((f"q{qd}", sep_qd), (f"q{qf}", sep_qf), ("delta", sep_delta)) if s]
                print(f"     >>> disjoint flip/control ranges on: {', '.join(where)}")
                # a coupled-feature separation, or ANY separation on the value-neutral jump
                # or at qf (both P), is a genuine (non-value-confounded) mechanism signal
                if feat in COUPLED or sep_delta or sep_qf:
                    coupled_hits.append((name, feat, ",".join(where)))

    print("\n=== VERDICT ===")
    if coupled_hits:
        print("GENUINE flip/control separations (coupled feature, or on the value-neutral jump/qf):")
        for pair, feat, where in coupled_hits:
            print(f"  pair {pair}: {feat} on {where}")
        print("Psi encodes part of the arc-depleted dichotomy -- hand to the proof lane.")
    else:
        print("NEGATIVE: no coupled feature (defect/intruders/xor) separates, and no separation")
        print("survives on the value-neutral jump (delta) or at qf (both cohorts P).  Every")
        print("'SEPARATES' is on a size term (reservoir/zone) at the depleted order qd only,")
        print("where controls are P and flips are N -- the within-order N-vs-P value correlate")
        print("C55 already reported, NOT a cross-q config->value mechanism.  The negative extends")
        print("to the dynamic Psi ledger; hardens the A5-only conclusion.")


if __name__ == "__main__":
    main()
