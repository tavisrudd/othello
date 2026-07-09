#!/usr/bin/env python3
"""On-conic child type-alignment test for the projective-cap odd-q program.

For every legal size-3 residual class S3 and every on-conic size-4 child, this
reconstructs the 6-point conic-parameter configuration

    {inf, 0, t1, t2, t3, t4}  subset  P^1(F_q)

where {0, inf} are the two burned directions (asymptotes), {t1,t2,t3} are the
selected S3 cells and t4 is the on-conic child.  The P/N value is read directly
from the feat `X ... val= pos=on` line (no re-solve).

It then canonicalizes each configuration two ways and builds a q-INDEPENDENT
type signature, to test whether the P/N value is a function of type:

  (A) full PGL(2,q)   -- the fixed-q transport grouping (what C5/C15 used).
      Roles are NOT distinguished (value = function of the abstract 6-set orbit).
  (B) burned-pair stabilizer -- a finer diagnostic/refinement.  Subgroup fixing
      {0,inf} setwise: t -> a*t and t -> a/t, order 2(q-1).  Roles ARE
      distinguished (burned pair {0,inf} interchangeable; S3 points
      interchangeable; child distinguished).

q-independent signatures (finite alphabet, computed identically in every field):
  * ratio-character vector (stabilizer): chi(t4/ti) and chi(ti/tj) among S3.
    chi(x) = Legendre symbol; chi(ratio) is invariant under t->a*t and t->a/t,
    so it is a genuine stabilizer invariant, and its alphabet {+1,-1} is field
    independent.
  * cross-ratio quadratic-character multiset over the 15 four-subsets.  For each
    4-subset the multiset {chi(lambda_k)} over the 6 anharmonic cross-ratio
    values depends only on the unordered 4-subset and is PGL-invariant; we tag
    each subset by its role composition (B/S/C) for the stabilizer signature and
    drop the tags for the PGL signature.
  * integral type (the primary cross-q signature): the 6-point config as a subset
    of P^1(Z u inf) -- signed-integer S3 params + signed-integer child.  Because
    the S3 cells and hyperbola gauge are identical across q, the S3 params come
    out as the same signed integers at every q, so two children match iff their
    integer parameter data is identical.  Collision-free q-independent id (no
    rational reconstruction, which is unreliable at small q), and a refinement of
    the stabiliser orbit -- so any cross-q value split it exhibits is a true split
    of the same rational configuration under any q-independent type notion.

Run from repo root:
    python3 rust/scripts/onconic_child_type_alignment.py
"""

from __future__ import annotations

import ast
import os
import re
import sys
from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations

INF = "inf"
X_RE = re.compile(r"^X q=(\d+) cls=(\d+) x=(\d+),(\d+) val=([PN]) pos=(\w+)$")
CLS_RE = re.compile(r"^CLS q=(\d+) cls=(\d+) S3=(\[.*\]) escape=")

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
DATA = os.path.join(REPO, "notes", "data")
FEAT_FILES = {
    5: "codex-feat5.out",
    7: "codex-feat7.out",
    9: "codex-feat9.out",
    11: "codex-feat11-c15.out",
    13: "codex-feat13-c15.out",
    17: "codex-feat17.out",
    19: "codex-feat19-c15.out",
}

# ---------------------------------------------------------------------------
# field helpers (prime fields only; q=9 handled separately below)
# ---------------------------------------------------------------------------

def inv(q: int, x: int) -> int:
    return pow(x % q, q - 2, q)


@lru_cache(maxsize=None)
def qr_set(q: int) -> frozenset:
    return frozenset((x * x) % q for x in range(1, q))


def chi(q: int, x: int) -> int:
    """Legendre symbol over the prime field F_q (x != 0)."""
    x %= q
    assert x != 0
    return 1 if x in qr_set(q) else -1


def param_key(x):
    return 10**9 if x == INF else int(x)

# ---------------------------------------------------------------------------
# conic reconstruction (adapted from 2026-07-07-pgl2-orbit-census.py)
# ---------------------------------------------------------------------------

def solve3(q: int, rows):
    m = [list(r) for r in rows]
    for col in range(3):
        piv = next(i for i in range(col, 3) if m[i][col] % q)
        m[col], m[piv] = m[piv], m[col]
        scale = inv(q, m[col][col])
        for j in range(col, 4):
            m[col][j] = (m[col][j] * scale) % q
        for i in range(3):
            if i == col:
                continue
            f = m[i][col] % q
            if f:
                for j in range(col, 4):
                    m[i][j] = (m[i][j] - f * m[col][j]) % q
    return m[0][3], m[1][3], m[2][3]


def conic_params(q: int, cells):
    rows = [[r % q, c % q, 1, (-(r * c)) % q] for r, c in cells]
    eps, zeta, gamma = solve3(q, rows)
    rho = (-zeta) % q
    a_param = (-eps) % q
    b_param = (rho * a_param - gamma) % q
    assert b_param != 0, (q, cells)
    return eps, zeta, gamma, rho, a_param, b_param


def fval(q, eps, zeta, gamma, r, c):
    return (r * c + eps * r + zeta * c + gamma) % q


def params_with_roles(q, s3, x):
    """Return (t_s3 tuple of 3, t_child) parameters of S3 cells and child."""
    eps, zeta, gamma, rho, a_param, b_param = conic_params(q, s3)
    ts = []
    for r, c in s3:
        assert fval(q, eps, zeta, gamma, r, c) == 0
        t = (r - rho) % q
        assert t != 0
        assert (c - a_param) % q == (b_param * inv(q, t)) % q
        ts.append(t)
    r, c = x
    assert fval(q, eps, zeta, gamma, r, c) == 0
    t4 = (r - rho) % q
    assert t4 != 0
    assert (c - a_param) % q == (b_param * inv(q, t4)) % q
    allp = [*ts, t4]
    assert 0 not in allp and len(set(allp)) == 4  # 4 distinct finite nonzero params
    return tuple(ts), t4

# ---------------------------------------------------------------------------
# Mobius maps + group canonicalisation
# ---------------------------------------------------------------------------

def mobius(q, m, x):
    a, b, c, d = m
    if x == INF:
        return INF if c % q == 0 else (a * inv(q, c)) % q
    den = (c * x + d) % q
    if den == 0:
        return INF
    return ((a * x + b) * inv(q, den)) % q


@lru_cache(maxsize=None)
def pgl_maps(q):
    seen = set()
    maps = []
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    entries = (a, b, c, d)
                    first = next(v for v in entries if v % q)
                    scale = inv(q, first)
                    norm = tuple((v * scale) % q for v in entries)
                    if norm not in seen:
                        seen.add(norm)
                        maps.append(norm)
    assert len(maps) == q * (q * q - 1), (q, len(maps))
    return tuple(maps)


@lru_cache(maxsize=None)
def stab_maps(q):
    """Stabiliser of {0,inf} in PGL(2,q): t->a*t and t->a/t, a in F_q^*."""
    maps = []
    for a in range(1, q):
        maps.append((a, 0, 0, 1))  # t -> a t
        maps.append((0, a, 1, 0))  # t -> a / t
    assert len(maps) == 2 * (q - 1)
    return tuple(maps)


def canon_set(q, six, maps):
    """Lex-min image of the unordered 6-set under the given map list."""
    best = None
    for m in maps:
        img = tuple(sorted((mobius(q, m, x) for x in six), key=param_key))
        k = tuple(param_key(v) for v in img)
        if best is None or k < best[0]:
            best = (k, img)
    return best[1]

# ---------------------------------------------------------------------------
# cross ratios + quadratic-character signatures
# ---------------------------------------------------------------------------

def cross_ratio(q, a, b, c, d):
    """cr(a,b;c,d) = (a-c)(b-d) / (a-d)(b-c) with inf handled by limits.
    Points are distinct; result is a nonzero field element != 1 (and != inf)."""
    def sub(x, y):  # x - y as a nonzero field elt or the symbol INF if one is inf
        if x == INF and y == INF:
            raise ValueError
        if x == INF or y == INF:
            return INF
        return (x - y) % q

    def collect(pairs):
        num_inf = 0
        prod = 1
        for x, y in pairs:
            d_ = sub(x, y)
            if d_ == INF:
                num_inf += 1
            else:
                prod = (prod * d_) % q
        return num_inf, prod

    ni, pnum = collect([(a, c), (b, d)])
    di, pden = collect([(a, d), (b, c)])
    # inf factors cancel between numerator and denominator (each variable appears
    # once in num and once in den), so ni == di whenever inf is among the points.
    assert ni == di, (a, b, c, d)
    val = (pnum * inv(q, pden)) % q
    assert val not in (0,)  # distinct points
    return val


def anharmonic_qr_count(q, four):
    """# of QRs among the 6 anharmonic cross-ratio values of an unordered
    4-subset -- a PGL-invariant, relabel-invariant, q-independent integer 0..6."""
    a, b, c, d = four
    lam = cross_ratio(q, a, b, c, d)
    orbit = set()
    x = lam
    # anharmonic group generated by x->1/x and x->1-x
    frontier = {x}
    while frontier:
        nf = set()
        for y in frontier:
            for z in ((inv(q, y)) % q, (1 - y) % q):
                if z not in orbit and z not in frontier:
                    nf.add(z)
        orbit |= frontier
        frontier = nf
    # orbit has <=6 distinct values; count QRs weighting by multiplicity=6/|orbit|
    mult = 6 // len(orbit)
    return sum(mult for v in orbit if chi(q, v) == 1)


def stab_ratio_sig(q, ts, t4):
    """Stabiliser ratio-character signature (burned-pair anchored).
    chi(t4/ti) over S3, and chi(ti/tj) among S3.  Roles distinguished."""
    sc = tuple(sorted(chi(q, (t4 * inv(q, t)) % q) for t in ts))
    ss = tuple(sorted(chi(q, (a * inv(q, b)) % q) for a, b in combinations(ts, 2)))
    return ("SC", sc, "SS", ss)


def role_of(pt, ts_set, t4):
    if pt == INF or pt == 0:
        return "B"
    if pt == t4:
        return "C"
    return "S"


def crprofile_sig(q, six, ts, t4, tagged):
    """Multiset over 15 four-subsets of (role-tag, qr_count).
    tagged=True -> stabiliser (roles kept); tagged=False -> PGL (roles dropped)."""
    ts_set = set(ts)
    prof = Counter()
    for four in combinations(six, 4):
        cnt = anharmonic_qr_count(q, four)
        if tagged:
            tag = tuple(sorted(role_of(p, ts_set, t4) for p in four))
        else:
            tag = None
        prof[(tag, cnt)] += 1
    return tuple(sorted(prof.items()))


def stab_sig(q, six, ts, t4):
    return (stab_ratio_sig(q, ts, t4), crprofile_sig(q, six, ts, t4, tagged=True))


def pgl_sig(q, six, ts, t4):
    return crprofile_sig(q, six, ts, t4, tagged=False)

# Note on why there is no rational-reconstruction signature here: recognising a
# cross-ratio as "the same rational" across fields via rational reconstruction is
# unreliable at these small q -- distinct rationals of moderate height collide
# mod q (e.g. 8/5 == 1/2 (mod 11)).  The integral type below is the collision-
# free q-independent identification and is what the analysis uses.  GF(9) (q=9)
# would need a separate GF(9) reconstruction (its parameters are GF(9) elements,
# not integers) and is left as a documented scope gap; it is all-P on the conic
# and cannot overturn the negative verdict.

# ---------------------------------------------------------------------------
# parsing
# ---------------------------------------------------------------------------

def parse_feat(q, path):
    s3_by_cls = {}
    on_children = defaultdict(list)  # cls -> [(cell, val)]
    with open(path, encoding="utf-8") as f:
        for raw in f:
            line = raw.strip()
            m = CLS_RE.match(line)
            if m:
                qq, ci, s3 = m.groups()
                if int(qq) == q:
                    s3_by_cls[int(ci)] = ast.literal_eval(s3)
                continue
            m = X_RE.match(line)
            if m:
                qq, ci, r, c, val, pos = m.groups()
                if int(qq) == q and pos == "on":
                    on_children[int(ci)].append(((int(r), int(c)), val))
    return s3_by_cls, on_children

# ---------------------------------------------------------------------------
# main analysis (prime q only in this driver; q=9 handled by gf9 driver)
# ---------------------------------------------------------------------------

def signed(t, q):
    return t if t <= q // 2 else t - q


def integral_type(q, ts, t4):
    """q-INDEPENDENT integral type: the 6-point config as a subset of P^1(Z u inf).
    {inf,0} burned pair + signed-integer S3 params + signed-integer child.  Two
    children match iff their integer parameter data is identical -- a collision-
    free q-independent identification (no rational reconstruction), valid exactly
    when the signed integers coincide across the fields.  Child distinguished,
    S3 interchangeable (sorted).  This is a refinement of the stabiliser orbit,
    so any cross-q value split it exhibits is a true value split of the shared
    rational configuration."""
    return (tuple(sorted(signed(t, q) for t in ts)), signed(t4, q))


class Rec:
    __slots__ = ("q", "cls", "s3", "x", "val", "six", "ts", "t4",
                 "pgl_orbit", "stab_orbit", "sig_stab", "sig_pgl", "sig_int")

    def __init__(self, **kw):
        for k, v in kw.items():
            setattr(self, k, v)


def build_records_prime(q, path):
    s3_by_cls, on_children = parse_feat(q, path)
    recs = []
    for cls, kids in on_children.items():
        s3 = s3_by_cls[cls]
        for x, val in kids:
            ts, t4 = params_with_roles(q, s3, x)
            six = (INF, 0, *ts, t4)
            recs.append(Rec(
                q=q, cls=cls, s3=tuple(s3), x=x, val=val,
                six=six, ts=ts, t4=t4,
                pgl_orbit=canon_set(q, six, pgl_maps(q)),
                stab_orbit=canon_set(q, six, stab_maps(q)),
                sig_stab=stab_sig(q, six, ts, t4),
                sig_pgl=pgl_sig(q, six, ts, t4),
                sig_int=integral_type(q, ts, t4),
            ))
    return recs


def self_consistency(recs, keyfn, label):
    """Within each q, every record of a given key must share its P/N value."""
    viol = []
    by_q = defaultdict(lambda: defaultdict(Counter))
    for r in recs:
        by_q[r.q][keyfn(r)][r.val] += 1
    ok = True
    detail = {}
    for q in sorted(by_q):
        nkey = len(by_q[q])
        bad = [(k, dict(c)) for k, c in by_q[q].items() if len(c) > 1]
        detail[q] = (nkey, bad)
        if bad:
            ok = False
            for k, c in bad:
                viol.append((q, label, k, c))
    return ok, detail, viol


def cross_q_alignment(recs, keyfn):
    """Group by q-independent key across all q; report value(key) per q and the
    obstruction set (keys whose value is not q-constant among q where known)."""
    table = defaultdict(dict)  # key -> {q: set(values)}
    for r in recs:
        table[keyfn(r)].setdefault(r.q, set()).add(r.val)
    obstructions = []
    aligned = []
    for key, perq in table.items():
        known = {q: next(iter(v)) for q, v in perq.items() if len(v) == 1}
        # only meaningful if self-consistent per q (checked separately)
        vals = set(known.values())
        multi = len([q for q in perq if q in known]) >= 2
        if len(vals) > 1:
            obstructions.append((key, {q: known[q] for q in sorted(known)}))
        elif multi:
            aligned.append((key, sorted(known), next(iter(vals))))
    return table, aligned, obstructions


# ---------------------------------------------------------------------------
# anchor check: per-class on-conic P counts must match the heuristic report
# ---------------------------------------------------------------------------

def anchor_onP_hist(recs):
    by_q_cls = defaultdict(Counter)
    for r in recs:
        by_q_cls[(r.q, r.cls)][r.val] += 1
    out = {}
    for q in sorted({k[0] for k in by_q_cls}):
        hist = Counter()
        for (qq, cls), c in by_q_cls.items():
            if qq == q:
                hist[c["P"]] += 1
        out[q] = dict(sorted(hist.items()))
    return out


def main():
    prime_qs = [5, 7, 11, 13, 17, 19]
    if len(sys.argv) > 1:
        prime_qs = [int(x) for x in sys.argv[1:]]
    recs = []
    for q in prime_qs:
        recs.extend(build_records_prime(q, os.path.join(DATA, FEAT_FILES[q])))
    print(f"loaded records={len(recs)} from prime q={prime_qs}")

    print("\n=== ANCHOR: per-class on-conic P-count histogram (must match heuristic report) ===")
    for q, h in anchor_onP_hist(recs).items():
        print(f"  q={q:2d}  onP-hist(P:classes)={h}")

    # (1) actual-orbit self-consistency (MUST hold: orbit = game symmetry).
    #     Bucket counts here must match C5/C15 (q17->10 PGL, q11->4, q13->5, q19->13).
    print("\n=== (1) EXACT-ORBIT self-consistency within q (game-symmetry gate) ===")
    for label, kf in [("PGL orbit ", lambda r: r.pgl_orbit),
                      ("STAB orbit", lambda r: r.stab_orbit)]:
        ok, detail, viol = self_consistency(recs, kf, label)
        print(f"  {label}: {'PASS' if ok else 'FAIL'}  "
              + "  ".join(f"q{q}:{n}" for q, (n, _) in detail.items()))
        for q, lbl, k, c in viol:
            print(f"    VIOLATION q={q} {lbl} key={k} values={dict(c)}")

    # (2) coarse q-independent character signatures: are they even fine enough?
    print("\n=== (2) CHARACTER-signature self-consistency within q (are they valid types?) ===")
    for label, kf in [("STAB ratio-chi ", lambda r: r.sig_stab[0]),
                      ("STAB cr-profile", lambda r: r.sig_stab[1]),
                      ("PGL  cr-profile", lambda r: r.sig_pgl)]:
        ok, detail, viol = self_consistency(recs, kf, label)
        print(f"  {label}: {'PASS' if ok else 'FAIL (too coarse -- not a valid type)'}  "
              + "  ".join(f"q{q}:{n}" for q, (n, _) in detail.items()))

    # (3) integral type: exact, collision-free, q-independent.  MANDATORY gate then cross-q.
    print("\n=== (3) INTEGRAL-TYPE self-consistency within q (mandatory gate) ===")
    ok, detail, viol = self_consistency(recs, lambda r: r.sig_int, "integral")
    print(f"  integral type: {'PASS' if ok else 'FAIL'}  "
          + "  ".join(f"q{q}:{n}" for q, (n, _) in detail.items()))
    for q, lbl, k, c in viol:
        print(f"    VIOLATION q={q} key={k} values={dict(c)}")

    print("\n=== (4) CROSS-Q ALIGNMENT on the integral type (THE DELIVERABLE) ===")
    table, aligned, obstr = cross_q_alignment(recs, lambda r: r.sig_int)
    multi = [k for k, perq in table.items() if len({q for q in perq}) >= 2]
    print(f"  integral types total={len(table)}  appear at >=2 q={len(multi)}  "
          f"aligned(q-constant)={len(aligned)}  OBSTRUCTIONS={len(obstr)}")
    print("\n  --- OBSTRUCTION SET (same rational config, value not q-constant) ---")
    for key, perq in sorted(obstr, key=lambda t: repr(t[0])):
        s3p, ch = key
        vv = "  ".join(f"q{q}:{perq[q]}" for q in sorted(perq))
        print(f"    S3params={list(s3p)} child={ch:>3} :  {vv}")
    print("\n  --- ALIGNED (q-constant) integral types appearing at >=2 q ---")
    for key, qs, val in sorted(aligned, key=lambda t: (-len(t[1]), repr(t[0]))):
        s3p, ch = key
        print(f"    S3params={list(s3p)} child={ch:>3} : {val}  q={qs}")

    # (5) payoff: does a q-independent type->value function reproduce the onP counts?
    print("\n=== (5) PAYOFF: can a single q-independent type->value table reproduce onP? ===")
    # For each class present at >=2 q, count children whose integral type is
    # aligned-P vs obstructed vs q-specific.
    n_obstr_children = 0
    for r in recs:
        perq = table[r.sig_int]
        known = {q: next(iter(v)) for q, v in perq.items() if len(v) == 1}
        if len(set(known.values())) > 1:
            n_obstr_children += 1
    print(f"  on-conic children whose integral type is value-inconsistent across q: "
          f"{n_obstr_children} / {len(recs)}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
