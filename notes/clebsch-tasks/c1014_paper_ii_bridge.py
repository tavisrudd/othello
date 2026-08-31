#!/usr/bin/env python3
"""C1014 bridge check: Paper II (clebsch-factorization) quadratic trade vs the
m = 2 Gram-shadow coloring chi(G_{4,4}) = chi(I), I = lambda^2 - lambda + 1.

Sections
  A  switch-constant identity   I = u^2 - u v + v^2  on a 4-set (symbolic + F_q)
  B  B_3/F_7 and H_3/F_11 matching orbits: sheets, edge-product square class,
     m=2 colour profiles, switch adjacency inside the orbit
  C  q = 13 (m odd): the edge-product square class *is* the sheet sign
  D  q = 9 Baer/Miquelian contact with the C1015 exceptional K_10 factorization

Replay:  uv run --with sympy python3 notes/clebsch-tasks/c1014_paper_ii_bridge.py
Writes a JSON summary next to this file.
"""

import itertools
import json
import os
from fractions import Fraction

# ---------------------------------------------------------------- finite fields


class GF:
    """GF(p^e) as F_p[x]/(f).  Elements are tuples of length e over F_p."""

    def __init__(self, p, e=1, modulus=None):
        self.p, self.e = p, e
        self.q = p ** e
        if e == 1:
            self.mod = None
        else:
            assert modulus is not None and len(modulus) == e
            self.mod = modulus  # x^e = sum modulus[i] x^i
        self.elts = [tuple(t) for t in itertools.product(range(p), repeat=e)]
        self.zero = tuple([0] * e)
        self.one = tuple([1] + [0] * (e - 1))

    def add(self, a, b):
        return tuple((x + y) % self.p for x, y in zip(a, b))

    def neg(self, a):
        return tuple((-x) % self.p for x in a)

    def sub(self, a, b):
        return tuple((x - y) % self.p for x, y in zip(a, b))

    def mul(self, a, b):
        p, e = self.p, self.e
        if e == 1:
            return ((a[0] * b[0]) % p,)
        c = [0] * (2 * e - 1)
        for i, x in enumerate(a):
            if x:
                for j, y in enumerate(b):
                    c[i + j] = (c[i + j] + x * y) % p
        for k in range(2 * e - 2, e - 1, -1):
            t = c[k]
            if t:
                c[k] = 0
                for i, m in enumerate(self.mod):
                    c[k - e + i] = (c[k - e + i] + t * m) % p
        return tuple(c[:e])

    def inv(self, a):
        assert a != self.zero
        for b in self.elts:
            if self.mul(a, b) == self.one:
                return b
        raise ArithmeticError

    def pow(self, a, n):
        r = self.one
        b = a
        while n:
            if n & 1:
                r = self.mul(r, b)
            b = self.mul(b, b)
            n >>= 1
        return r

    def chi(self, a):
        """Quadratic character: 0, +1, -1."""
        if a == self.zero:
            return 0
        return 1 if self.pow(a, (self.q - 1) // 2) == self.one else -1

    def from_int(self, n):
        return tuple([n % self.p] + [0] * (self.e - 1))


def bracket(F, u, v):
    return F.sub(F.mul(u[0], v[1]), F.mul(u[1], v[0]))


def points(F):
    """P^1(F_q) with the Paper II representatives: a -> (1,a), infinity -> (0,1)."""
    pts = [("a", x) for x in F.elts] + [("inf", None)]
    rep = {}
    for lab in pts:
        rep[lab] = (F.one, lab[1]) if lab[0] == "a" else (F.zero, F.one)
    return pts, rep


def gram4(F, vs, d):
    """Hollow 4x4 determinant det([v_i,v_j]^d), diagonal 0."""
    m = [[F.zero] * 4 for _ in range(4)]
    for i in range(4):
        for j in range(4):
            if i != j:
                m[i][j] = F.pow(bracket(F, vs[i], vs[j]), d)
    # Leibniz over the 24 permutations (4x4, cheap)
    tot = F.zero
    for perm in itertools.permutations(range(4)):
        sgn = 1
        pl = list(perm)
        for i in range(4):
            for j in range(i + 1, 4):
                if pl[i] > pl[j]:
                    sgn = -sgn
        t = F.one
        for i in range(4):
            t = F.mul(t, m[i][perm[i]])
        tot = F.add(tot, t) if sgn > 0 else F.sub(tot, t)
    return tot


# ---------------------------------------------------------------- PGL_2 action


def pgl2(F):
    """PGL_2(F_q) as normalised 2x2 matrices (first nonzero entry = 1)."""
    seen, out = set(), []
    for a, b, c, d in itertools.product(F.elts, repeat=4):
        det = F.sub(F.mul(a, d), F.mul(b, c))
        if det == F.zero:
            continue
        for e in (a, b, c, d):
            if e != F.zero:
                s = F.inv(e)
                break
        key = tuple(F.mul(s, x) for x in (a, b, c, d))
        if key not in seen:
            seen.add(key)
            out.append((key, F.chi(det)))
    return out


def act_point(F, g, lab, rep):
    a, b, c, d = g
    v = rep[lab]
    w = (F.add(F.mul(a, v[0]), F.mul(b, v[1])), F.add(F.mul(c, v[0]), F.mul(d, v[1])))
    if w[0] == F.zero:
        return ("inf", None)
    return ("a", F.mul(F.inv(w[0]), w[1]))


def orbit(F, base, G, rep):
    """Orbit of a matching (frozenset of frozensets of labels) plus PSL flag."""
    orb, sheet = {}, {}
    for g, chidet in G:
        img = frozenset(
            frozenset(act_point(F, g, p, rep) for p in edge) for edge in base
        )
        orb.setdefault(img, [])
        orb[img].append(chidet)
    for m, cs in orb.items():
        sheet[m] = set(cs)
    return orb, sheet


def _key(F, lb):
    return F.q if lb[0] == "inf" else F.elts.index(lb[1])


def edge_product_class(F, M, rep, reverse=False):
    """chi(prod over edges of [rep(lo), rep(hi)]) for a FIXED total order on
    P^1(F_q).  When chi(-1) = -1 the value depends on that order, which is the
    point of the `reverse` control."""
    prod = F.one
    for edge in M:
        p, r = sorted(edge, key=lambda x: _key(F, x), reverse=reverse)
        prod = F.mul(prod, bracket(F, rep[p], rep[r]))
    return F.chi(prod)


def colour_profile(F, M, rep, d=4):
    """Multiset of m=2 colours of the 4-sets spanned by pairs of matching edges."""
    prof = {0: 0, 1: 0, -1: 0}
    for e1, e2 in itertools.combinations(sorted(M, key=lambda s: sorted(map(str, s))), 2):
        vs = [rep[p] for p in list(e1) + list(e2)]
        prof[F.chi(gram4(F, vs, d))] += 1
    return prof


# ---------------------------------------------------------------- section A


def section_A():
    import sympy as sp

    lam = sp.symbols("lam")
    # points (inf,0,1,lambda) with Paper II vectors
    v = {"inf": (1, 0), "0": (0, 1), "1": (1, 1), "l": (lam, 1)}

    def br(x, y):
        return sp.expand(x[0] * y[1] - x[1] * y[0])

    u = sp.expand(br(v["inf"], v["0"]) * br(v["1"], v["l"]))  # {inf,0}{1,l}
    w2 = sp.expand(br(v["inf"], v["1"]) * br(v["0"], v["l"]))  # {inf,1}{0,l}
    w3 = sp.expand(br(v["inf"], v["l"]) * br(v["0"], v["1"]))  # {inf,l}{0,1}
    I = lam ** 2 - lam + 1
    res = {
        "u": str(u),
        "v": str(w2),
        "w": str(w3),
        "plucker u - v + w == 0": bool(sp.simplify(u - w2 + w3) == 0),
        "I == u^2-uv+v^2": bool(sp.simplify(u ** 2 - u * w2 + w2 ** 2 - I) == 0),
        "2I == u^2+v^2+w^2": bool(sp.simplify(u ** 2 + w2 ** 2 + w3 ** 2 - 2 * I) == 0),
    }
    # numeric cross-check over F_q: chi(G_{4,4}) == chi(u^2-uv+v^2) on all 4-sets
    checks = {}
    for (p, e, mod) in [(7, 1, None), (11, 1, None), (13, 1, None), (3, 2, (2, 0))]:
        F = GF(p, e, mod)
        pts, rep = points(F)
        bad = 0
        for S in itertools.combinations(pts, 4):
            vs = [rep[s] for s in S]
            g = gram4(F, vs, 4)
            uu = F.mul(bracket(F, vs[0], vs[1]), bracket(F, vs[2], vs[3]))
            vv = F.mul(bracket(F, vs[0], vs[2]), bracket(F, vs[1], vs[3]))
            nf = F.add(F.sub(F.mul(uu, uu), F.mul(uu, vv)), F.mul(vv, vv))
            if F.chi(g) != F.chi(nf):
                bad += 1
        checks[f"q={F.q}"] = {"4sets": len(list(itertools.combinations(pts, 4))), "mismatches": bad}
    res["chi(G_44) == chi(u^2-uv+v^2) over F_q"] = checks
    return res


# ---------------------------------------------------------------- section B

BASES = {
    "A3/F5": (5, 1, None, [(0, "inf"), (1, 4), (2, 3)]),
    "B3/F7": (7, 1, None, [(0, 2), (1, 4), (3, "inf"), (5, 6)]),
    "H3/F11": (11, 1, None, [(0, 1), (2, 5), (3, 7), (4, 9), (6, 8), (10, "inf")]),
}


def lab(F, x):
    return ("inf", None) if x == "inf" else ("a", F.from_int(x))


def section_B():
    out = {}
    for name, (p, e, mod, base_edges) in BASES.items():
        F = GF(p, e, mod)
        pts, rep = points(F)
        G = pgl2(F)
        base = frozenset(frozenset(lab(F, x) for x in ed) for ed in base_edges)
        orb, sheet = orbit(F, base, G, rep)
        # sheets: matchings reachable by chi(det)=+1 elements
        plus = [m for m in orb if 1 in sheet[m]]
        minus = [m for m in orb if -1 in sheet[m]]
        both = [m for m in orb if len(sheet[m]) == 2]
        m_edges = len(base_edges)
        sclasses = sorted({edge_product_class(F, M, rep) for M in orb})
        profs = {}
        for M in orb:
            key = json.dumps(colour_profile(F, M, rep), sort_keys=True)
            profs[key] = profs.get(key, 0) + 1
        # single-switch adjacency inside the orbit
        adj = 0
        ol = list(orb)
        for i in range(len(ol)):
            for j in range(i + 1, len(ol)):
                if len(ol[i] - ol[j]) == 2:
                    adj += 1
        out[name] = {
            "m (edges)": m_edges,
            "orbit size": len(orb),
            "splits into two PSL sheets": len(both) == 0,
            "sheet sizes": [len(plus), len(minus)] if not both else None,
            "chi(prod of edge brackets) values on orbit": sclasses,
            "m=2 colour profiles (profile -> #matchings)": profs,
            "pairs differing by exactly one switch": adj,
        }
    return out


# ---------------------------------------------------------------- section C


def section_C():
    """q = 13: m = 7 odd, so chi(prod edge brackets) has odd det-weight."""
    F = GF(13)
    pts, rep = points(F)
    G = pgl2(F)
    # a matching with trivial-ish stabiliser: pair 0-1, 2-3, ..., 10-11, 12-inf
    base_edges = [(0, 1), (2, 3), (4, 5), (6, 7), (8, 9), (10, 11), (12, "inf")]
    base = frozenset(frozenset(lab(F, x) for x in ed) for ed in base_edges)
    orb, sheet = orbit(F, base, G, rep)
    both = [m for m in orb if len(sheet[m]) == 2]
    plus = [m for m in orb if 1 in sheet[m] and len(sheet[m]) == 1]
    minus = [m for m in orb if -1 in sheet[m] and len(sheet[m]) == 1]
    res = {
        "m (edges)": len(base_edges),
        "orbit size": len(orb),
        "splits into two PSL sheets": len(both) == 0,
        "sheet sizes": [len(plus), len(minus)],
    }
    if not both:
        cp = {edge_product_class(F, M, rep) for M in plus}
        cm = {edge_product_class(F, M, rep) for M in minus}
        res["chi(prod) on sheet +"] = sorted(cp)
        res["chi(prod) on sheet -"] = sorted(cm)
        res["edge-product class equals sheet sign"] = (
            len(cp) == 1 and len(cm) == 1 and cp != cm
        )
    # control: an even-m orbit at q = 13 is impossible (2m = q+1 = 14 forces m = 7)
    return res


# ---------------------------------------------------------------- section D


def section_D():
    """q = 9 Baer/Miquelian coloring vs the C1015 exceptional K_10 factorization."""
    F = GF(3, 2, (2, 0))  # x^2 = 2 = -1, i.e. F_9 = F_3[i]
    pts, rep = points(F)
    d = 4  # r = 2m mod (q-1) = 4 = p+1 : the Baer stratum
    colours = {}
    for S in itertools.combinations(pts, 4):
        colours[S] = F.chi(gram4(F, [rep[s] for s in S], d))
    n0 = sum(1 for c in colours.values() if c == 0)
    npos = sum(1 for c in colours.values() if c == 1)
    nneg = sum(1 for c in colours.values() if c == -1)
    inf = ("inf", None)
    # circles (colour-0 4-sets) through infinity
    circ_inf = [S for S, c in colours.items() if c == 0 and inf in S]
    # AG(2,3) lines on F_9: triples summing to zero
    fin = [("a", x) for x in F.elts]
    lines = [
        T
        for T in itertools.combinations(fin, 3)
        if F.add(F.add(T[0][1], T[1][1]), T[2][1]) == F.zero
    ]
    line_sets = {frozenset(T) for T in lines}
    circ_inf_res = {frozenset(s for s in S if s != inf) for S in circ_inf}
    # C1015 exceptional factorization  M_a = {{inf,a}} u {{x,y}: x+y = -a}
    facs = {}
    for a in F.elts:
        edges = [frozenset({inf, ("a", a)})]
        used = {a}
        for x in F.elts:
            if x in used:
                continue
            y = F.sub(F.neg(a), x)
            if y == x or y in used:
                continue
            edges.append(frozenset({("a", x), ("a", y)}))
            used |= {x, y}
        facs[a] = frozenset(edges)
    ok_fact = all(len(fs) == 5 for fs in facs.values()) and len(
        {e for fs in facs.values() for e in fs}
    ) == 45
    # colour profile of the 4-sets spanned by pairs of edges within one factor
    prof = {}
    for a, fs in facs.items():
        pr = {0: 0, 1: 0, -1: 0}
        for e1, e2 in itertools.combinations(sorted(fs, key=lambda s: sorted(map(str, s))), 2):
            S = tuple(sorted(set(e1) | set(e2), key=lambda s: str(s)))
            pr[F.chi(gram4(F, [rep[s] for s in S], d))] += 1
        prof[json.dumps(pr, sort_keys=True)] = prof.get(json.dumps(pr, sort_keys=True), 0) + 1
    # collinear factor triples of C1015 <-> circles through infinity
    fac_triples = [T for T in itertools.combinations(F.elts, 3)
                   if F.add(F.add(T[0], T[1]), T[2]) == F.zero]
    match = all(
        colours[tuple(sorted({inf, ("a", T[0]), ("a", T[1]), ("a", T[2])}, key=lambda s: str(s)))]
        == 0
        if tuple(sorted({inf, ("a", T[0]), ("a", T[1]), ("a", T[2])}, key=lambda s: str(s))) in colours
        else colours[tuple(sorted({inf, ("a", T[0]), ("a", T[1]), ("a", T[2])}, key=str))] == 0
        for T in fac_triples
    )
    # stabiliser of the exceptional factorization inside PGL_2(9)
    G = pgl2(F)
    fset = {facs[a] for a in F.elts}
    stab, stab_psl = 0, 0
    for g, chidet in G:
        img = {
            frozenset(
                frozenset(act_point(F, g, p, rep) for p in edge) for edge in fs
            )
            for fs in fset
        }
        if img == fset:
            stab += 1
            if chidet == 1:
                stab_psl += 1
    return {
        "4-sets": len(colours),
        "colour counts (0,+,-)": [n0, npos, nneg],
        "circles through infinity": len(circ_inf),
        "AG(2,3) lines on F_9": len(lines),
        "circles thru inf == {inf} u AG(2,3) line": circ_inf_res == line_sets,
        "C1015 factorization well formed": ok_fact,
        "colour profile of within-factor 4-sets": prof,
        "collinear factor triples give colour-0 4-sets with inf": bool(match),
        "|Stab_{PGL_2(9)}(factorization)|": stab,
        "|Stab_{PSL_2(9)}(factorization)|": stab_psl,
    }


# ---------------------------------------------------------------- section E


def section_E():
    """(i) chi(prod_{a in P^1} c_a(g)) = chi(det g);  (ii) s = sheet sign for
    q = 3 mod 4;  (iii) the q=9 inversive one-factorization rooted at a point."""
    res = {}
    # (i) the representative-cocycle character lemma
    lem = {}
    for (p, e, mod) in [(7, 1, None), (11, 1, None), (13, 1, None), (3, 2, (2, 0))]:
        F = GF(p, e, mod)
        pts, rep = points(F)
        bad = 0
        for g, chidet in pgl2(F):
            a, b, c, d = g
            prod = F.one
            for lb in pts:
                v = rep[lb]
                w = (F.add(F.mul(a, v[0]), F.mul(b, v[1])),
                     F.add(F.mul(c, v[0]), F.mul(d, v[1])))
                img = act_point(F, g, lb, rep)
                # c_lb with  g.rep(lb) = c_lb * rep(img)
                r = rep[img]
                cl = F.mul(w[0], F.inv(r[0])) if r[0] != F.zero else F.mul(w[1], F.inv(r[1]))
                prod = F.mul(prod, cl)
            if F.chi(prod) != chidet:
                bad += 1
        lem[f"q={F.q}"] = {"group elements": len(pgl2(F)), "mismatches": bad}
    res["chi(prod c_a(g)) == chi(det g)"] = lem

    # (ii) s is exactly the sheet sign on B_3 and H_3
    sheets = {}
    for name in ("B3/F7", "H3/F11"):
        p, e, mod, base_edges = BASES[name]
        F = GF(p, e, mod)
        pts, rep = points(F)
        G = pgl2(F)
        base = frozenset(frozenset(lab(F, x) for x in ed) for ed in base_edges)
        orb, sh = orbit(F, base, G, rep)
        row = {"m": len(base_edges),
               "chi(-1)": F.chi(F.neg(F.one)),
               "q mod 4": F.q % 4}
        for tag, rv in (("fwd", False), ("rev", True)):
            plus = {edge_product_class(F, M, rep, rv) for M in orb if sh[M] == {1}}
            minus = {edge_product_class(F, M, rep, rv) for M in orb if sh[M] == {-1}}
            row[f"s[{tag}] on sheet +"] = sorted(plus)
            row[f"s[{tag}] on sheet -"] = sorted(minus)
            row[f"s[{tag}] == sheet sign"] = (
                len(plus) == 1 and len(minus) == 1 and plus != minus)
        sheets[name] = row
    res["edge-product square class vs sheet sign"] = sheets

    # (iii) inversive one-factorization at q = 9
    F = GF(3, 2, (2, 0))
    pts, rep = points(F)
    colours = {}
    for S in itertools.combinations(pts, 4):
        colours[frozenset(S)] = F.chi(gram4(F, [rep[s] for s in S], 4))
    circles = [S for S, c in colours.items() if c == 0]

    def rooted(P):
        facs = {}
        for Q in pts:
            if Q == P:
                continue
            resid = [frozenset(S - {P, Q}) for S in circles if P in S and Q in S]
            facs[Q] = frozenset([frozenset({P, Q})] + resid)
        return facs

    checks = {}
    for P in pts:
        facs = rooted(P)
        good = all(len(f) == 5 and len({x for e in f for x in e}) == 10
                   for f in facs.values())
        allE = [e for f in facs.values() for e in f]
        checks[str(P)] = {"one-factorization": good and len(set(allE)) == 45
                          and len(allE) == 45}
    res["q=9 rooted inversive one-factorizations"] = {
        "circles": len(circles),
        "every root gives a one-factorization": all(v["one-factorization"]
                                                    for v in checks.values()),
        "roots tested": len(checks),
    }
    # equality with the C1015 affine factorization at root infinity
    inf = ("inf", None)
    facs_inf = rooted(inf)
    c1015 = set()
    for a in F.elts:
        edges = [frozenset({inf, ("a", a)})]
        used = {a}
        for x in F.elts:
            if x in used:
                continue
            y = F.sub(F.neg(a), x)
            if y == x or y in used:
                continue
            edges.append(frozenset({("a", x), ("a", y)}))
            used |= {x, y}
        c1015.add(frozenset(edges))
    res["q=9 rooted-at-infinity == C1015 exceptional factorization"] = (
        set(facs_inf.values()) == c1015
    )
    # cycle types of factor pairs (exceptional class has 4+6 for every pair)
    types = {}
    fl = sorted(facs_inf.values(), key=lambda f: sorted(map(str, f)))
    for f1, f2 in itertools.combinations(fl, 2):
        adjm = {}
        for e in list(f1) + list(f2):
            x, y = tuple(e)
            adjm.setdefault(x, []).append(y)
            adjm.setdefault(y, []).append(x)
        seen, cyc = set(), []
        for v in adjm:
            if v in seen:
                continue
            n, cur, prev = 0, v, None
            while True:
                seen.add(cur)
                n += 1
                nxt = [w for w in adjm[cur] if w != prev]
                nxt = nxt[0] if len(nxt) == 1 else (nxt[0] if nxt[0] != prev else nxt[1])
                prev, cur = cur, nxt
                if cur == v:
                    break
            cyc.append(n)
        key = tuple(sorted(cyc))
        types[str(key)] = types.get(str(key), 0) + 1
    res["q=9 factor-pair cycle types"] = types
    return res


def main():
    out = {}
    out["A_switch_identity"] = section_A()
    out["B_orbits"] = section_B()
    out["C_q13_odd_m"] = section_C()
    out["D_q9_baer"] = section_D()
    out["E_followups"] = section_E()
    here = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(here, "c1014_paper_ii_bridge.json")
    with open(path, "w") as fh:
        json.dump(out, fh, indent=1, default=str)
    A = out["A_switch_identity"]
    print("A identity:", A["plucker u - v + w == 0"], A["I == u^2-uv+v^2"],
          A["2I == u^2+v^2+w^2"], A["chi(G_44) == chi(u^2-uv+v^2) over F_q"])
    for k, v in out["B_orbits"].items():
        print("B", k, "| orbit", v["orbit size"], "| splits", v["splits into two PSL sheets"],
              "| sheets", v["sheet sizes"], "| chi(prod)", v["chi(prod of edge brackets) values on orbit"],
              "| #profiles", len(v["m=2 colour profiles (profile -> #matchings)"]),
              "| switch-adjacent pairs", v["pairs differing by exactly one switch"])
    print("C q=13:", out["C_q13_odd_m"])
    D = out["D_q9_baer"]
    for k in D:
        print("D", k, ":", D[k])
    for k, v in out["E_followups"].items():
        print("E", k, ":", v)
    print("json:", path)


if __name__ == "__main__":
    main()
