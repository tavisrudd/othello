#!/usr/bin/env python3
"""C77 (opening experiment) — does the C76 frame-augmented, orbit-injective feature
space admit a UNIFORM value-blind reply selector?

C75: pointwise selector impossible — winning/losing replies feature-identical.
C76: adding frame-relative characters separates all 48 twins (orbit-injective on
the witnesses). That LIFTS the C75 impossibility. This script asks the next
question at the root-frame obligation layer (the only layer with full reply dumps
in the C75 TSVs):

  (A_local) within each obligation, is any winning reply still feature-identical to
            a losing one in the AUGMENTED space? (expect 0 — C76 separation.)
  (A_same_q) across obligations of the same q, does any winner share its augmented
            vector with a loser? (a same-q, position-dependent collision => a uniform
            selector cannot be a pure function of the augmented features even at fixed q.)
  (B_linear) is there a single linear functional whose per-obligation argmax is a
            winning (P & Psi-descending) reply at EVERY root obligation across
            q=13/17/19 simultaneously? (a genuine uniform linear selector.)

If B_linear is feasible AND its argmax lands a winner everywhere -> a uniform linear
selector exists at the root layer (huge; then patch the solver to test all plies).
If A_same_q collides or B fails -> even orbit-injective features give no uniform
pointwise selector; the amortized/ledger bank is required. Either way decisive.
"""
import sys
from itertools import combinations
from collections import defaultdict

import numpy as np
from scipy.optimize import linprog
from scipy.sparse import csr_matrix

GEOMS = ("ext", "int", "on")
FRAME = (1, 2, 3, 4)


def parse_reply(tok):
    parts = tok.split(":")
    d = {"cell": parts[0]}
    r, c = parts[0].split(",")
    d["r"], d["c"] = int(r), int(c)
    for p in parts[1:]:
        if p.startswith("g") and p[1:].lstrip("-").isdigit():
            d["g"] = int(p[1:])
        elif p.startswith("dpsi"):
            d["dpsi"] = int(p[4:])
        elif p in GEOMS:
            d["geom"] = p
        elif p.startswith("live"):
            d["live"] = int(p[4:])
        elif p.startswith("comp"):
            d["comp"] = int(p[4:])
        elif p.startswith("xor0"):
            d["xor_zero"] = int(p[4:])
        elif p.startswith("psi"):
            d["psi"] = int(p[3:])
        elif p.startswith("chi"):
            d["chi"] = int(p[3:])
        elif p.startswith("polar"):
            d["polar"] = int(p[5:])
        elif p.startswith("rays"):
            d["rays"] = tuple(int(x) for x in p[4:].split(",") if x != "")
    d.setdefault("rays", ())
    return d


def good(r):
    return r["g"] == 0 and r["dpsi"] < 0


def inv(a, q):
    return pow(a % q, q - 2, q)


def chi(a, q):
    a %= q
    if a == 0:
        return 0
    return 1 if pow(a, (q - 1) // 2, q) == 1 else -1


def sqrt_mod(a, q):
    a %= q
    if a == 0:
        return 0
    if chi(a, q) != 1:
        return None
    for x in range(1, q):
        if (x * x) % q == a:
            return x
    return None


def tan_fin(r, c, q):
    if c % q == 0:
        return [(r * inv(2, q)) % q]
    disc = (4 - 4 * c * r) % q
    s = sqrt_mod(disc, q)
    if s is None:
        return []
    ic = inv(2 * c, q)
    return [((2 + s) * ic) % q, ((2 - s) * ic) % q]


def cross_ratio(a, b, c, d, q):
    den = ((a - d) * (b - c)) % q
    if den == 0:
        return None
    return (((a - c) * (b - d)) % q * inv(den, q)) % q


def aug_profiles(q, x, z):
    """The C76 frame-relative character profiles (sorted => Stab-invariant)."""
    r, c = z["r"], z["c"]
    pol = tuple(sorted(chi((c * f + r * inv(f, q) - 2) % q, q) for f in FRAME))
    chord = tuple(sorted(chi((r + a * b * c - (a + b)) % q, q)
                         for a, b in combinations(FRAME, 2)))
    T = tan_fin(r, c, q)
    if len(T) == 2:
        u, v = T
        crt = tuple(sorted(chi(cr, q) for a, b in combinations(FRAME, 2)
                           if (cr := cross_ratio(a, b, u, v, q)) is not None))
    else:
        crt = ("na",)

    def part(f):
        den = (c * f - 1) % q
        return None if den == 0 else ((f - r) * inv(den, q)) % q
    # encode: infinity=-3, partner-in-frame=2, else chi(partner) in {-1,0,1}
    invol = tuple(sorted((-3 if part(f) is None else
                          (2 if part(f) in FRAME else chi(part(f), q))) for f in FRAME))
    return pol, chord, crt, invol


BASE_KEYS = ("geom", "live", "comp", "xor_zero", "psi", "dpsi", "chi", "polar", "rays")


def base_tuple(r):
    return tuple(r[k] for k in BASE_KEYS)


def aug_tuple(q, x, r):
    return base_tuple(r) + aug_profiles(q, x, r)


def load_obligations(paths):
    obs = []  # (q, opponent, [replies])
    for q, path in paths.items():
        with open(path) as f:
            header = f.readline().rstrip("\n").split("\t")
            idx = {h: i for i, h in enumerate(header)}
            for line in f:
                t = line.rstrip("\n").split("\t")
                if len(t) <= idx["root_replies"] or t[idx["root_replies"]] == "":
                    continue
                xr, xc = (int(v) for v in t[idx["opponent"]].split(","))
                reps = [parse_reply(tok) for tok in t[idx["root_replies"]].split(";")]
                reps = [r for r in reps if "g" in r]
                obs.append((q, (xr, xc), reps))
    return obs


def profile_vec(q, x, r):
    """Numeric feature vector: base numeric feats + frame-relative char profiles."""
    v = []
    g = r["geom"]
    v += [1.0 if g == "ext" else 0.0, 1.0 if g == "int" else 0.0, 1.0 if g == "on" else 0.0]
    v += [float(r["live"]), float(r["comp"]), float(r["xor_zero"]),
          float(r["psi"]), float(r["dpsi"]), float(r["chi"]), float(r["polar"])]
    rays = list(r["rays"]) + [0] * (7 - len(r["rays"]))
    v += [float(x) for x in rays[:7]]
    pol, chord, crt, invol = aug_profiles(q, x, r)
    v += [float(a) for a in pol]                       # 4
    v += [float(a) for a in chord]                     # 6
    crtn = [a for a in crt if a != "na"]
    crtn = crtn + [0.0] * (6 - len(crtn))
    v += [float(a) for a in crtn[:6]]                  # 6
    v += [float(a) for a in invol]                     # 4 (already int-encoded)
    return np.array(v)


def main():
    paths = {13: sys.argv[1], 17: sys.argv[2], 19: sys.argv[3]}
    obs = load_obligations(paths)
    print(f"[load] {len(obs)} root-frame obligations "
          f"({sum(len(r) for _,_,r in obs)} replies)\n")

    # ---- A_local: within-obligation augmented collisions ----
    local_col = 0
    obl_with_winner = 0
    for (q, x, reps) in obs:
        winners = {aug_tuple(q, x, r): r for r in reps if good(r)}
        if not winners:
            continue
        obl_with_winner += 1
        for r in reps:
            if not good(r) and aug_tuple(q, x, r) in winners:
                local_col += 1
    print(f"[A_local] within-obligation augmented winner==loser collisions: {local_col} "
          f"(C75 base space had 48) over {obl_with_winner} coverable obligations")

    # ---- A_same_q: cross-obligation, same-q augmented collisions ----
    for q in sorted(paths):
        winners = defaultdict(list)
        losers = defaultdict(list)
        for (qq, x, reps) in obs:
            if qq != q:
                continue
            for r in reps:
                key = aug_tuple(qq, x, r)
                (winners if good(r) else losers)[key].append((x, r["cell"]))
        clash = [k for k in winners if k in losers]
        print(f"[A_same_q] q={q}: {len(clash)} augmented feature vectors that are a winner "
              f"in one obligation and a loser in another")

    # ---- B_linear: uniform linear selector over augmented numeric features ----
    # target = deepest-descent winner per obligation; want <w, phi(loser)-phi(target)> >= 1.
    rows = []
    cov = [(q, x, reps) for (q, x, reps) in obs if any(good(r) for r in reps)]
    for (q, x, reps) in cov:
        winners = [r for r in reps if good(r)]
        losers = [r for r in reps if not good(r)]
        gstar = min(winners, key=lambda r: r["dpsi"])
        pv = profile_vec(q, x, gstar)
        for b in losers:
            rows.append(profile_vec(q, x, b) - pv)
    d = len(profile_vec(*[(13,), (0, 0)][0:0]) if False else profile_vec(13, (0, 0), obs[0][2][0]))
    if rows:
        A = csr_matrix(np.vstack(rows))
        res = linprog(c=np.zeros(d), A_ub=(-A).tocsc(),
                      b_ub=-np.ones(A.shape[0]), bounds=[(-1e4, 1e4)] * d,
                      method="highs")
        print(f"\n[B_linear] {A.shape[0]} margin constraints, d={d} augmented features")
        if res.success:
            w = res.x
            # verify argmax(=argmin of score) selector lands a winner everywhere
            okc = badc = 0
            for (q, x, reps) in cov:
                sc = [(float(np.dot(w, profile_vec(q, x, r))), r) for r in reps]
                pick = min(sc, key=lambda s: (s[0], 0 if good(s[1]) else 1))[1]
                if good(pick):
                    okc += 1
                else:
                    badc += 1
            print(f"[B_linear] LP FEASIBLE. argmin selector: good={okc} bad={badc} "
                  f"over {len(cov)} obligations")
            print("    => uniform LINEAR value-blind selector exists at the ROOT layer"
                  if badc == 0 else
                  "    => LP feasible but argmin ties slip; near-selector")
        else:
            print(f"[B_linear] LP INFEASIBLE (status {res.status}). "
                  "No uniform linear selector with the deepest-descent target rule "
                  "even in the augmented space at the root layer.")


if __name__ == "__main__":
    main()
