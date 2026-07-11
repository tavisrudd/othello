#!/usr/bin/env python3
"""C76 — automated search for a value-blind scalar invariant that separates the
C75 P/N feature-twins WITH A CONSISTENT DIRECTION (the real bar for a selector
coordinate: an argmin/argmax selector needs the P reply strictly on one side of
its N twin at EVERY obligation).

Generates a broad family of frame-aware, x-aware projective invariants of a
reply cell z (conic xy=1, frame params {1,2,3,4}, opponent x), all Stab(F u {x})-
invariant (symmetric in the frame, character-valued so PGL-invariant). For each
candidate scalar it reports:
  sep   = # of the 48 twins where value(P) != value(N)
  dir   = 'P<N' / 'P>N' / 'MIXED' over the separated twins
A candidate with sep==48 and a consistent dir is a selector-coordinate hit.
"""
import sys
from collections import defaultdict
from itertools import combinations

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


FEAT_KEYS = ("geom", "live", "comp", "xor_zero", "psi", "dpsi", "chi", "polar", "rays")


def feat_tuple(r):
    return tuple(r[k] for k in FEAT_KEYS)


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


def tangent_params(r, c, q):
    """finite tangent params of z=(r,c); plus infinity markers. Returns (fin, infs)."""
    fin, infs = [], []
    if c == 0:
        infs.append("inf_r")
    if r == 0:
        infs.append("inf_c")
    if c % q != 0:
        disc = (4 - 4 * c * r) % q
        s = sqrt_mod(disc, q)
        if s is not None:
            ic = inv(2 * c, q)
            fin = [((2 + s) * ic) % q, ((2 - s) * ic) % q]
    else:
        fin = [(r * inv(2, q)) % q]
    return fin, infs


def cross_ratio(a, b, c, d, q):
    """(a-c)(b-d)/((a-d)(b-c)) in GF(q); None if degenerate."""
    num = ((a - c) * (b - d)) % q
    den = ((a - d) * (b - c)) % q
    if den == 0:
        return None
    return (num * inv(den, q)) % q


def load_twins(paths):
    twins = []
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
                goods = {feat_tuple(r): r for r in reps if good(r)}
                for b in reps:
                    if good(b):
                        continue
                    ft = feat_tuple(b)
                    if ft in goods:
                        twins.append((q, (xr, xc), goods[ft], b))
    return twins


def candidate_features(q, x, z):
    """Return a dict name->scalar of value-blind Stab-invariant candidates."""
    r, c = z["r"], z["c"]
    xr, xc = x
    out = {}
    disc_z = (1 - r * c) % q
    out["chi_disc"] = chi(disc_z, q)
    Tz_fin, Tz_inf = tangent_params(r, c, q)
    Tx_fin, Tx_inf = tangent_params(xr, xc, q)
    out["n_tan_inf"] = len(Tz_inf)

    # involution partner of frame f under z: m_z(f) = (f - r)/(c f - 1)
    def part_z(f):
        den = (c * f - 1) % q
        if den == 0:
            return None  # infinity
        return ((f - r) * inv(den, q)) % q

    # --- symmetric character sums over the frame ---
    # T1: char of the tangent-pair quadratic (f-u)(f-v) at each frame f, summed
    if len(Tz_fin) == 2:
        u, v = Tz_fin
        vals = [chi(((f - u) % q) * ((f - v) % q), q) for f in FRAME]
        out["sum_chi_tanquad_frame"] = sum(vals)
        out["nzero_tanquad_frame"] = sum(1 for f in FRAME if ((f-u)%q)*((f-v)%q) % q == 0)
        out["prod_chi_tanquad_frame"] = 1
        for w in vals:
            out["prod_chi_tanquad_frame"] *= (w if w != 0 else 1)
    # T2: partner-in-frame count and char sum of (f - partner)
    pin = 0
    csum = 0
    for f in FRAME:
        p = part_z(f)
        if p is None:
            continue
        if p in FRAME:
            pin += 1
        csum += chi((f - p) % q, q) if (f - p) % q != 0 else 0
    out["n_partner_in_frame"] = pin
    out["sum_chi_f_minus_partner"] = csum

    # T3: cross-ratio characters CR(fi,fj; u,v) over frame pairs, symmetric sum
    if len(Tz_fin) == 2:
        u, v = Tz_fin
        crs = []
        for a, bb in combinations(FRAME, 2):
            cr = cross_ratio(a, bb, u, v, q)
            if cr is not None:
                crs.append(chi(cr, q))
        out["sum_chi_cr_framepair_tan"] = sum(crs)

    # T4: relation to opponent x. line x-z meets conic where? param roots of
    # points on line xz that are on conic. Use secant/tangent/external of xz.
    # direction (dr,dc) = (r-xr, c-xc); conic point (p,1/p) on line xz iff
    # (p - xr)*dc - (1/p - xc)*dr = 0 -> dc p^2 - (xr dc - xc dr + dr) p + dr = 0
    dr, dc = (r - xr) % q, (c - xc) % q
    if dc != 0:
        A = dc % q
        B = (-(xr * dc - xc * dr + dr)) % q
        C = dr % q
        disc_line = (B * B - 4 * A * C) % q
        out["chi_xz_line_conic"] = chi(disc_line, q)  # +1 secant,-1 ext,0 tangent
    else:
        out["chi_xz_line_conic"] = 9  # sentinel (dc==0)

    # T5: char of disc_z * disc_x   (relative character to opponent)
    disc_x = (1 - xr * xc) % q
    out["chi_disc_times_discx"] = chi((disc_z * disc_x) % q, q)

    # T6: char of "power of z wrt frame chords" — product over frame pairs of
    #     the value of the secant-line evaluated at z, symmetric.
    #     secant through conic pts fi,fj: line X/? ; the conic-chord fi--fj has
    #     equation x + fi fj y = fi + fj (since points (fi,1/fi),(fj,1/fj)).
    #     evaluate at z: L = r + fi*fj*c - (fi+fj); char summed over pairs.
    chord_chars = []
    for a, bb in combinations(FRAME, 2):
        L = (r + a * bb * c - (a + bb)) % q
        chord_chars.append(chi(L, q))
    out["sum_chi_frame_chord_at_z"] = sum(chord_chars)
    out["prod_sign_frame_chord_at_z"] = 1
    for w in chord_chars:
        out["prod_sign_frame_chord_at_z"] *= (w if w != 0 else 1)
    out["n_on_frame_chord"] = sum(1 for a, bb in combinations(FRAME, 2)
                                  if (r + a * bb * c - (a + bb)) % q == 0)

    # T7: tangent-line-of-z evaluated ... char of product over frame of
    #     (tangent from z touches near f) already in T1; add polar of z:
    #     polar of z=(r,c) wrt xy=1 is line: c*X + r*Y = 2. eval at frame pt
    #     (f,1/f): c f + r/f - 2; count zeros / char sum.
    pol = []
    for f in FRAME:
        val = (c * f + r * inv(f, q) - 2) % q
        pol.append(chi(val, q))
    out["sum_chi_polar_at_frame"] = sum(pol)
    out["n_frame_on_polar_z"] = sum(
        1 for f in FRAME if (c * f + r * inv(f, q) - 2) % q == 0)
    return out


def main():
    paths = {13: sys.argv[1], 17: sys.argv[2], 19: sys.argv[3]}
    twins = load_twins(paths)
    print(f"[twins] {len(twins)} P/N feature-twin pairs\n")

    # collect candidate names
    names = set()
    rows = []
    for (q, x, P, N) in twins:
        fp = candidate_features(q, x, P)
        fn = candidate_features(q, x, N)
        names |= set(fp) & set(fn)
        rows.append((q, x, P, N, fp, fn))

    results = []
    for nm in sorted(names):
        sep = 0
        pl = 0  # P<N
        pg = 0  # P>N
        missing = 0
        for (q, x, P, N, fp, fn) in rows:
            if nm not in fp or nm not in fn:
                missing += 1
                continue
            a, b = fp[nm], fn[nm]
            if a == b:
                continue
            sep += 1
            if a < b:
                pl += 1
            else:
                pg += 1
        direction = ("P<N" if pg == 0 else "P>N" if pl == 0 else "MIXED")
        results.append((sep, direction, pl, pg, missing, nm))

    results.sort(key=lambda t: (-t[0], t[1] == "MIXED"))
    print(f"{'candidate':>30} {'sep':>4} {'dir':>6} {'P<N':>4} {'P>N':>4} {'miss':>4}")
    for sep, direction, pl, pg, missing, nm in results:
        flag = "  <== CLEAN DIRECTIONAL" if direction != "MIXED" and sep > 0 else ""
        print(f"{nm:>30} {sep:>4} {direction:>6} {pl:>4} {pg:>4} {missing:>4}{flag}")

    print("\n[clean-directional candidates]:",
          [nm for sep, d, pl, pg, m, nm in results if d != "MIXED" and sep > 0])

    # ---- profile closure: sorted frame-relative CHARACTER PROFILES (Stab-invariant,
    # not scalar-reduced) — do they restore orbit-injectivity on the twins? ----
    def profiles(q, x, z):
        r, c = z["r"], z["c"]
        pol = tuple(sorted(chi((c * f + r * inv(f, q) - 2) % q, q) for f in FRAME))
        chord = tuple(sorted(chi((r + a * b * c - (a + b)) % q, q)
                             for a, b in combinations(FRAME, 2)))
        Tz, _ = tangent_params(r, c, q)
        if len(Tz) == 2:
            u, v = Tz
            crt = tuple(sorted(chi(cr, q) for a, b in combinations(FRAME, 2)
                               if (cr := cross_ratio(a, b, u, v, q)) is not None))
        else:
            crt = ("na",)
        return pol, chord, crt

    for label, keep in [("polar-at-frame", (0,)),
                        ("frame-chord-at-z", (1,)),
                        ("polar + chord", (0, 1)),
                        ("polar + chord + tangent-CR", (0, 1, 2))]:
        sep = 0
        for (q, x, P, N) in twins:
            pP = tuple(profiles(q, x, P)[i] for i in keep)
            pN = tuple(profiles(q, x, N)[i] for i in keep)
            if pP != pN:
                sep += 1
        print(f"[profile closure] {label:<28}: {sep}/{len(twins)} twins separated")


if __name__ == "__main__":
    main()
