#!/usr/bin/env python3
"""C76 — invariant hunt: find a PGL-invariant coordinate separating the C75
value-blind P/N feature-twins.

For each root-frame obligation in the C75 detail TSVs, re-find the P/N feature
twins (a winning g0/dpsi<0 reply and a losing g!=0 reply with byte-identical
17-feature vectors), then compute a battery of *frame-aware* projective
invariants of each reply cell z relative to (conic xy=1, frame params {1,2,3,4},
opponent x). The current feature space involves only the pair (x,z); it never
references the frame conic points. The hypothesis: a frame-aware invariant
separates the twins.

q=13/17/19 are all prime, so GF(q)=Z/q and arithmetic is plain modular.
"""
import sys
from collections import defaultdict

GEOMS = ("ext", "int", "on")


def parse_reply(tok):
    parts = tok.split(":")
    cell = parts[0]
    d = {"cell": cell}
    r, c = cell.split(",")
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
    if "rays" not in d:
        d["rays"] = ()
    return d


FEAT_KEYS = ("geom", "live", "comp", "xor_zero", "psi", "dpsi", "chi", "polar", "rays")


def feat_tuple(r):
    return tuple(r[k] for k in FEAT_KEYS)


def good(r):
    return r["g"] == 0 and r["dpsi"] < 0


# ---- GF(q) helpers (q prime) ----
def inv(a, q):
    return pow(a % q, q - 2, q)


def is_sq(a, q):
    a %= q
    if a == 0:
        return True
    return pow(a, (q - 1) // 2, q) == 1


def sqrt_mod(a, q):
    a %= q
    if a == 0:
        return 0
    if not is_sq(a, q):
        return None
    for x in range(1, q):
        if (x * x) % q == a:
            return x
    return None


FRAME = (1, 2, 3, 4)  # conic params of the root frame {(t, t^-1)}


def tangent_params(r, c, q):
    """Params p in GF(q) U {'inf_r','inf_c'} of conic points whose tangent
    passes through off-conic z=(r,c). Conic xy=1; tangent at (p,1/p) is
    p*Y + (1/p)*X = 2, i.e. contains (r,c) iff p*c + r/p = 2 -> c p^2 -2p + r=0.
    Infinite conic points: (r-axis dir) tangent = line c=0; (c-axis dir)
    tangent = line r=0."""
    tp = []
    # infinite tangents
    if c == 0:
        tp.append("inf_r")  # z lies on tangent c=0 (touches at r-axis infinity)
    if r == 0:
        tp.append("inf_c")
    if c % q != 0:
        # c p^2 - 2 p + r = 0
        disc = (4 - 4 * c * r) % q  # = 4(1-rc)
        s = sqrt_mod(disc, q)
        if s is not None:
            ic = inv(2 * c, q)
            p1 = ((2 + s) * ic) % q
            p2 = ((2 - s) * ic) % q
            tp.extend([p1, p2])
    else:
        # c==0: -2p + r = 0 -> p = r/2 (finite), plus inf_r above
        tp.append((r * inv(2, q)) % q)
    return tp


def involution_partner(a, r, c, q):
    """For conic point param a (a!=0), the *other* conic point param a'
    collinear with z=(r,c). Collinearity of (a,1/a),(a',1/a'),(r,c):
    det = 0. Returns a' in GF(q) U {'inf'} or None."""
    # line through (a,1/a) and (r,c): direction. Point (t,1/t) on it:
    # collinear <=> (1/t - 1/a)(r - a) = (c - 1/a)(t - a)   [slope match]
    # Solve for t. Cross-multiplying with a,t:
    # ( (a - t)/(a t) )(r - a) = (c - 1/a)(t - a)
    # (a-t)(r-a)/(a t) = (c-1/a)(t-a) = -(c-1/a)(a-t)
    # if a!=t: (r-a)/(a t) = -(c - 1/a)  -> (r-a) = -(c-1/a) a t
    # t = -(r-a) / ((c-1/a) a) = (a-r)/(a c - 1)
    denom = (a * c - 1) % q
    if denom == 0:
        return "inf"  # line is asymptote-parallel; other intersection at infinity
    return ((a - r) * inv(denom, q)) % q


def analyze(path, q, twins_out):
    n_ob = 0
    with open(path) as f:
        header = f.readline().rstrip("\n").split("\t")
        idx = {h: i for i, h in enumerate(header)}
        for line in f:
            t = line.rstrip("\n").split("\t")
            if len(t) <= idx["root_replies"] or t[idx["root_replies"]] == "":
                continue
            opp = t[idx["opponent"]]
            xr, xc = (int(v) for v in opp.split(","))
            reps = [parse_reply(tok) for tok in t[idx["root_replies"]].split(";")]
            reps = [r for r in reps if "g" in r]
            goods = {feat_tuple(r): r for r in reps if good(r)}
            for b in reps:
                if good(b):
                    continue
                ft = feat_tuple(b)
                if ft in goods:
                    twins_out.append((q, (xr, xc), goods[ft], b))
            n_ob += 1
    return n_ob


def main():
    files = {13: sys.argv[1], 17: sys.argv[2], 19: sys.argv[3]}
    twins = []
    for q, path in files.items():
        n = analyze(path, q, twins)
        print(f"[load] q={q}: {n} root obligations")
    print(f"[twins] {len(twins)} P/N feature-twin pairs total\n")

    # Battery of candidate frame-aware invariants; each maps a reply cell -> value.
    def cell_invariants(q, x, z):
        r, c = z["r"], z["c"]
        xr, xc = x
        T = tangent_params(r, c, q)
        Tfin = [p for p in T if isinstance(p, int)]
        n_tan_on_frame = sum(1 for p in Tfin if p in FRAME)
        # involution of z applied to frame params: which frame points pair
        # among themselves / land on frame
        partners = {}
        for a in FRAME:
            partners[a] = involution_partner(a, r, c, q)
        n_frame_partner_in_frame = sum(
            1 for a in FRAME if isinstance(partners[a], int) and partners[a] in FRAME
        )
        # how many frame points are collinear-paired to *another distinct* frame pt
        frame_pairs = set()
        for a in FRAME:
            p = partners[a]
            if isinstance(p, int) and p in FRAME and p != a:
                frame_pairs.add(frozenset((a, p)))
        # secant/tangent/external of line xz wrt conic
        return {
            "n_tan_on_frame": n_tan_on_frame,
            "tan_params": tuple(sorted(str(p) for p in T)),
            "n_frame_partner_in_frame": n_frame_partner_in_frame,
            "n_frame_pairs": len(frame_pairs),
            "involution_on_frame": tuple(
                (a, str(partners[a])) for a in FRAME
            ),
        }

    inv_names = ["n_tan_on_frame", "n_frame_partner_in_frame", "n_frame_pairs"]
    sep_count = {nm: 0 for nm in inv_names}
    sep_count["tan_params"] = 0
    sep_count["involution_on_frame"] = 0

    print("Per-twin invariant values (P-cell vs N-cell):")
    print(f"{'q':>3} {'opp':>7} {'Pcell':>6} {'Ncell':>6}  "
          f"{'ntanF(P/N)':>10} {'nFpartF(P/N)':>12} {'nFpairs(P/N)':>12}")
    for (q, x, P, N) in twins:
        ip = cell_invariants(q, x, P)
        inn = cell_invariants(q, x, N)
        for nm in inv_names + ["tan_params", "involution_on_frame"]:
            if ip[nm] != inn[nm]:
                sep_count[nm] += 1
        print(f"{q:>3} {str(x):>7} {P['cell']:>6} {N['cell']:>6}  "
              f"{str(ip['n_tan_on_frame'])+'/'+str(inn['n_tan_on_frame']):>10} "
              f"{str(ip['n_frame_partner_in_frame'])+'/'+str(inn['n_frame_partner_in_frame']):>12} "
              f"{str(ip['n_frame_pairs'])+'/'+str(inn['n_frame_pairs']):>12}")

    print("\n[separation] # of the 19 twins each invariant distinguishes:")
    for nm, cnt in sorted(sep_count.items(), key=lambda kv: -kv[1]):
        print(f"    {nm:>26}: {cnt}/{len(twins)}")


if __name__ == "__main__":
    main()
