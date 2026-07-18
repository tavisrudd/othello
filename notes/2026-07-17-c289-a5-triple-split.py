#!/usr/bin/env python3
"""C289 verification: the A5 (3,5,5) split.

Checks, against exhaustive enumeration and against the committed C284 bundle
(notes/2026-07-17-c284-dihedral-polyhedral-coset-templates.json):

  1. common-order lemma: for every unordered involution triple in S4 and A5,
     the six ordered three-generator products have a common order (rho);
  2. the (sigma,rho) class census for S4 and A5 matches C284;
  3. class discriminator: for A5 sigma=(3,5,5), rho=5 iff the two order-5
     pair products are A5-conjugate; in that case the triple product lies in
     the OTHER order-5 class; rho=3 iff the pair products are non-conjugate;
  4. Fricke identity tr(ABC)^2 = 4 - x^2 - y^2 - z^2 - xyz for trace-0
     A,B,C in SL2 (exact rational instances);
  5. icosahedral model: the 15 involution axes of the icosahedral rotation
     group I (exact Q(sqrt5) quaternions), axis-angle <-> pair-product class
     dictionary, and the angle configurations (60,36,36)/(60,72,72) for
     rho=5 (30+30 triples) versus (60,36,72) for rho=3 (60 triples);
  6. orbit structure: each rho class is one Aut(A5)=S5 orbit; the rho=5
     class splits into two inner A5-orbits of 30 fused by the outer
     automorphism, with an even (inner) triple stabilizer; the rho=3 class
     is a single inner orbit with an odd (outer) stabilizer;
  7. Cayley graphs of the two classes are non-isomorphic: closed-walk
     counts tr(A^k) differ (certificate: first differing k);
  8. mirror pairings: search the color-respecting automorphism group
     {g -> tau(g)h : tau in Stab_{S5}(T), h in A5} of Cay(A5,T) for an
     involution phi that is fixed-point-free with phi(g) never adjacent
     to g; such a pairing proves regular nimber 0;
  9. independent replay of the C284 residual nimbers for the (3,5,5) rows
     (K = C2, C3, C5, both rho classes) with a separate Python solver, and
     reconstruction of the residual coset graphs from scratch (left cosets
     G/K, edges gK - tgK, delete cosets fixed by a pair product) with
     isomorphism checks against the C284 edge lists.

Deterministic: fixed enumeration order, no randomness, no timestamps.
Output: canonical JSON on stdout (sorted keys).

Run (from repo root):
  python3 notes/2026-07-17-c289-a5-triple-split.py > notes/2026-07-17-c289-a5-triple-split.json
"""

import json
import sys
from fractions import Fraction
from itertools import combinations, permutations

C284_JSON = "notes/2026-07-17-c284-dihedral-polyhedral-coset-templates.json"

# ---------------------------------------------------------------- permutations


def mul(p, q):
    return tuple(p[q[i]] for i in range(len(q)))


def inv(p):
    r = [0] * len(p)
    for i, x in enumerate(p):
        r[x] = i
    return tuple(r)


def order(p):
    e = tuple(range(len(p)))
    x, n = p, 1
    while x != e:
        x = mul(x, p)
        n += 1
    return n


def parity(p):
    return sum(1 for i in range(len(p)) for j in range(i + 1, len(p)) if p[i] > p[j]) % 2


def conj(a, x):
    return mul(mul(a, x), inv(a))


def closure(gens):
    e = tuple(range(len(gens[0])))
    seen = {e}
    frontier = [e]
    while frontier:
        nf = []
        for x in frontier:
            for g in gens:
                y = mul(g, x)
                if y not in seen:
                    seen.add(y)
                    nf.append(y)
        frontier = nf
    return seen


def group(n, even_only):
    return [p for p in permutations(range(n)) if not even_only or parity(p) == 0]


# ------------------------------------------------- sigma/rho and lemma checks


def six_product_orders(a, b, c):
    return [order(mul(mul(x, y), z)) for (x, y, z) in permutations((a, b, c))]


def sigma(a, b, c):
    return tuple(sorted((order(mul(a, b)), order(mul(a, c)), order(mul(b, c)))))


def census(G, deg):
    """(sigma,rho) -> list of generating involution triples (frozensets)."""
    invs = [p for p in G if order(p) == 2]
    out = {}
    lemma_all = True
    for a, b, c in combinations(invs, 3):
        six = six_product_orders(a, b, c)
        if len(set(six)) != 1:
            lemma_all = False
        if len(closure([a, b, c])) != len(G):
            continue
        key = (sigma(a, b, c), six[0])
        out.setdefault(key, []).append(frozenset((a, b, c)))
    return invs, out, lemma_all


# ------------------------------------------------------------ exact Q(sqrt5)

HALF = Fraction(1, 2)
QUAR = Fraction(1, 4)


def r5add(x, y):
    return (x[0] + y[0], x[1] + y[1])


def r5sub(x, y):
    return (x[0] - y[0], x[1] - y[1])


def r5mul(x, y):
    return (x[0] * y[0] + 5 * x[1] * y[1], x[0] * y[1] + x[1] * y[0])


def r5neg(x):
    return (-x[0], -x[1])


def r5float(x):
    return float(x[0]) + float(x[1]) * 5 ** 0.5


R5_ZERO = (Fraction(0), Fraction(0))
R5_ONE = (Fraction(1), Fraction(0))


def qmul(u, v):
    a1, b1, c1, d1 = u
    a2, b2, c2, d2 = v
    def s(*ts):
        acc = R5_ZERO
        for sign, x, y in ts:
            t = r5mul(x, y)
            acc = r5add(acc, t if sign > 0 else r5neg(t))
        return acc
    return (
        s((1, a1, a2), (-1, b1, b2), (-1, c1, c2), (-1, d1, d2)),
        s((1, a1, b2), (1, b1, a2), (1, c1, d2), (-1, d1, c2)),
        s((1, a1, c2), (-1, b1, d2), (1, c1, a2), (1, d1, b2)),
        s((1, a1, d2), (1, b1, c2), (-1, c1, b2), (1, d1, a2)),
    )


def qneg(u):
    return tuple(r5neg(x) for x in u)


def qclosure(gens):
    idq = (R5_ONE, R5_ZERO, R5_ZERO, R5_ZERO)
    seen = {idq}
    frontier = [idq]
    while frontier:
        nf = []
        for x in frontier:
            for g in gens:
                y = qmul(g, x)
                if y not in seen:
                    seen.add(y)
                    nf.append(y)
        frontier = nf
    return seen


def rot_order_and_class(re_abs_float):
    """|Re q| -> (order in I, trace-class tag). tr_{SU2} = 2 Re."""
    table = ((1.0, 1, "id"), (0.0, 2, "tr0"), (0.5, 3, "tr1"),
             (0.8090169943749475, 5, "trPhi"),
             (0.3090169943749474, 5, "trPhi-1"))
    for val, o, tag in table:
        if abs(re_abs_float - val) < 1e-9:
            return (o, tag)
    raise ValueError(f"unexpected |Re| = {re_abs_float}")


def angle_tag(dot_abs_float):
    for val, tag in ((0.0, 90), (0.5, 60), (0.8090169943749475, 36), (0.3090169943749474, 72)):
        if abs(dot_abs_float - val) < 1e-9:
            return tag
    raise ValueError(f"unexpected |axis dot| = {dot_abs_float}")


# --------------------------------------------------------------- game solver


def nimber(n, edges):
    adj = [0] * n
    for u, v in edges:
        adj[u] |= 1 << v
        adj[v] |= 1 << u
    closed = [adj[v] | (1 << v) for v in range(n)]
    memo = {}

    def components(mask):
        comps, rem = [], mask
        while rem:
            v = (rem & -rem).bit_length() - 1
            seen = frontier = 1 << v
            while frontier:
                nxt = 0
                f = frontier
                while f:
                    u = (f & -f).bit_length() - 1
                    f &= f - 1
                    nxt |= adj[u] & mask
                frontier = nxt & ~seen
                seen |= frontier
            comps.append(seen)
            rem &= ~seen
        return comps

    def g(mask):
        if mask == 0:
            return 0
        if mask in memo:
            return memo[mask]
        comps = components(mask)
        if len(comps) > 1:
            r = 0
            for c in comps:
                r ^= g(c)
        else:
            seen = set()
            m = mask
            while m:
                v = (m & -m).bit_length() - 1
                m &= m - 1
                seen.add(g(mask & ~closed[v]))
            r = 0
            while r in seen:
                r += 1
        memo[mask] = r
        return r

    sys.setrecursionlimit(200000)
    return g((1 << n) - 1)


def graph_isomorphic(n, edgesA, edgesB):
    adjA = [set() for _ in range(n)]
    adjB = [set() for _ in range(n)]
    for u, v in edgesA:
        adjA[u].add(v)
        adjA[v].add(u)
    for u, v in edgesB:
        adjB[u].add(v)
        adjB[v].add(u)
    if sorted(map(len, adjA)) != sorted(map(len, adjB)):
        return False
    orderv = sorted(range(n), key=lambda v: -len(adjA[v]))
    mapping, used = {}, set()

    def bt(i):
        if i == n:
            return True
        v = orderv[i]
        for w in range(n):
            if w in used or len(adjB[w]) != len(adjA[v]):
                continue
            ok = True
            for u, wu in mapping.items():
                if (u in adjA[v]) != (wu in adjB[w]):
                    ok = False
                    break
            if ok:
                mapping[v] = w
                used.add(w)
                if bt(i + 1):
                    return True
                del mapping[v]
                used.remove(w)
        return False

    return bt(0)


# -------------------------------------------------------------------- main


def main():
    result = {"schema": "c289-a5-triple-split-v1"}

    # ---- S4 and A5 census + common-order lemma over ALL involution triples
    S4 = group(4, even_only=False)
    A5 = group(5, even_only=True)
    invS4, cenS4, lemS4 = census(S4, 4)
    invA5, cenA5, lemA5 = census(A5, 5)
    assert lemS4 and lemA5, "common-order lemma FAILED"
    result["lemma_common_order_all_involution_triples"] = {
        "S4_triples_checked": len(list(combinations(invS4, 3))),
        "A5_triples_checked": len(list(combinations(invA5, 3))),
        "all_six_orders_equal": True,
    }
    result["census_S4"] = sorted(
        [[list(s), r, len(v)] for (s, r), v in cenS4.items()])
    result["census_A5"] = sorted(
        [[list(s), r, len(v)] for (s, r), v in cenA5.items()])
    assert result["census_S4"] == [[[2, 3, 3], 4, 12], [[2, 3, 4], 3, 24],
                                   [[3, 3, 3], 4, 4], [[3, 4, 4], 3, 12]]
    assert result["census_A5"] == [[[2, 3, 5], 5, 120], [[2, 5, 5], 3, 60],
                                   [[3, 3, 5], 3, 60], [[3, 5, 5], 3, 60],
                                   [[3, 5, 5], 5, 60], [[5, 5, 5], 5, 20]]

    # ---- order-5 conjugacy classes in A5, class discriminator
    s0 = (1, 2, 3, 4, 0)
    clsA = frozenset(conj(g, s0) for g in A5)
    assert len(clsA) == 12

    def label5(x):
        assert order(x) == 5
        return "A" if x in clsA else "B"

    T3 = cenA5[((3, 5, 5), 3)]
    T5 = cenA5[((3, 5, 5), 5)]
    disc_ok, opp_ok = True, True
    config_counts = {}
    for rho, triples in ((3, T3), (5, T5)):
        for T in triples:
            a, b, c = sorted(T)
            prods = [mul(a, b), mul(a, c), mul(b, c)]
            labs = sorted(label5(p) for p in prods if order(p) == 5)
            # inverse pair product must have the same label (5-cycles real in A5)
            for p in prods:
                if order(p) == 5:
                    assert label5(inv(p)) == label5(p)
            same = labs[0] == labs[1]
            if (rho == 5) != same:
                disc_ok = False
            if rho == 5:
                if label5(mul(mul(a, b), c)) == labs[0]:
                    opp_ok = False
            config_counts[(rho, "".join(labs))] = config_counts.get(
                (rho, "".join(labs)), 0) + 1
    assert disc_ok and opp_ok
    result["class_discriminator"] = {
        "rho5_iff_pair_products_conjugate": disc_ok,
        "rho5_triple_product_in_opposite_class": opp_ok,
        "counts": {f"rho{r}_{l}": n for (r, l), n in sorted(config_counts.items())},
    }
    assert result["class_discriminator"]["counts"] == {
        "rho3_AB": 60, "rho5_AA": 30, "rho5_BB": 30}

    # ---- orbit structure under Inn(A5)=A5 and Aut(A5)=S5
    S5 = group(5, even_only=False)

    def orbit(T, gens):
        seen = {T}
        frontier = [T]
        while frontier:
            nf = []
            for X in frontier:
                for g in gens:
                    Y = frozenset(conj(g, x) for x in X)
                    if Y not in seen:
                        seen.add(Y)
                        nf.append(Y)
            frontier = nf
        return seen

    orbinfo = {}
    for rho, triples in ((3, T3), (5, T5)):
        tset = set(triples)
        rep = sorted(triples, key=lambda T: sorted(T))[0]
        aut_orb = orbit(rep, S5)
        assert aut_orb == tset, "Aut-orbit != rho class"
        inner_orbs = []
        rem = set(tset)
        while rem:
            r0 = sorted(rem, key=lambda T: sorted(T))[0]
            o = orbit(r0, A5)
            inner_orbs.append(len(o))
            rem -= o
        stab = [al for al in S5 if frozenset(conj(al, t) for t in rep) == rep]
        stab_par = sorted(parity(al) for al in stab if al != tuple(range(5)))
        orbinfo[f"rho{rho}"] = {
            "is_single_Aut_orbit": True,
            "inner_orbit_sizes": sorted(inner_orbs),
            "stabilizer_order": len(stab),
            "nontrivial_stabilizer_parities": stab_par,  # 0=even(inner),1=odd(outer)
        }
    assert orbinfo["rho5"]["inner_orbit_sizes"] == [30, 30]
    assert orbinfo["rho3"]["inner_orbit_sizes"] == [60]
    assert orbinfo["rho5"]["nontrivial_stabilizer_parities"] == [0]
    assert orbinfo["rho3"]["nontrivial_stabilizer_parities"] == [1]
    result["orbit_structure"] = orbinfo

    # ---- Fricke identity on exact rational trace-0 SL2 instances
    fricke_checked = 0
    for a1 in (Fraction(1), Fraction(2), Fraction(1, 2)):
        for b1 in (Fraction(1), Fraction(3)):
            for a2 in (Fraction(1), Fraction(-2)):
                for b2 in (Fraction(2), Fraction(1, 3)):
                    for a3 in (Fraction(3), Fraction(-1, 2)):
                        b3 = Fraction(1)
                        M = []
                        for aa, bb in ((a1, b1), (a2, b2), (a3, b3)):
                            cc = -(1 + aa * aa) / bb
                            M.append(((aa, bb), (cc, -aa)))

                        def mm(X, Y):
                            return tuple(
                                tuple(sum(X[i][k] * Y[k][j] for k in range(2))
                                      for j in range(2)) for i in range(2))

                        def tr(X):
                            return X[0][0] + X[1][1]

                        A, B, C = M
                        x, y, z = tr(mm(A, B)), tr(mm(B, C)), tr(mm(C, A))
                        tabc = tr(mm(mm(A, B), C))
                        tacb = tr(mm(mm(A, C), B))
                        assert tacb == -tabc
                        assert tabc * tabc == 4 - x * x - y * y - z * z - x * y * z
                        fricke_checked += 1
    result["fricke_identity_exact_instances"] = fricke_checked

    # ---- icosahedral quaternion model (exact Q(sqrt5))
    PHI = (HALF, HALF)          # (1+sqrt5)/2
    PHI1 = (-HALF, HALF)        # phi - 1 = 1/phi
    g1 = ((HALF, Fraction(0)),) * 4
    g2 = (R5_ZERO, (HALF, Fraction(0)),
          tuple(x / 2 for x in PHI), tuple(x / 2 for x in PHI1))
    g2 = (R5_ZERO, (HALF, Fraction(0)), (QUAR, QUAR), (-QUAR, QUAR))
    twoI = qclosure([g1, g2])
    assert len(twoI) == 120
    pure = [q for q in twoI if q[0] == R5_ZERO]
    assert len(pure) == 30
    axes = []
    seen = set()
    for q in pure:
        if q in seen:
            continue
        seen.add(q)
        seen.add(qneg(q))
        axes.append(q)
    assert len(axes) == 15

    def axdot(u, v):
        acc = R5_ZERO
        for i in (1, 2, 3):
            acc = r5add(acc, r5mul(u[i], v[i]))
        return abs(r5float(acc))

    # dictionary: axis angle <-> pair-product order and trace class
    dict_ok = True
    for u, v in combinations(axes, 2):
        ang = angle_tag(axdot(u, v))
        w = qmul(u, v)
        o, tag = rot_order_and_class(abs(r5float(w[0])))
        expect = {90: (2, "tr0"), 60: (3, "tr1"),
                  36: (5, "trPhi"), 72: (5, "trPhi-1")}[ang]
        if (o, tag) != expect:
            dict_ok = False
    assert dict_ok
    result["axis_angle_dictionary"] = {
        "deg90_order2": True, "deg60_order3": True,
        "deg36_order5_trPhi": True, "deg72_order5_trPhi-1": True}

    cfg = {}
    for u, v, w in combinations(axes, 3):
        angs = tuple(sorted((angle_tag(axdot(u, v)), angle_tag(axdot(u, w)),
                             angle_tag(axdot(v, w)))))
        po = tuple(sorted((rot_order_and_class(abs(r5float(qmul(u, v)[0])))[0],
                           rot_order_and_class(abs(r5float(qmul(u, w)[0])))[0],
                           rot_order_and_class(abs(r5float(qmul(v, w)[0])))[0])))
        if po != (3, 5, 5):
            continue
        if len(qclosure([u, v, w])) != 120:
            continue
        rho = rot_order_and_class(abs(r5float(qmul(qmul(u, v), w)[0])))[0]
        cfg[(angs, rho)] = cfg.get((angs, rho), 0) + 1
    result["icosahedral_configs_355"] = {
        f"angles{list(k[0])}_rho{k[1]}": n for k, n in sorted(cfg.items())}
    assert result["icosahedral_configs_355"] == {
        "angles[36, 36, 60]_rho5": 30,
        "angles[36, 60, 72]_rho3": 60,
        "angles[60, 72, 72]_rho5": 30}

    # ---- Cayley graphs: closed-walk moments, non-isomorphism certificate
    idx = {g: i for i, g in enumerate(A5)}

    def cayley_moments(T, kmax=16):
        n = len(A5)
        Am = [[0] * n for _ in range(n)]
        for g in A5:
            for t in T:
                Am[idx[g]][idx[mul(t, g)]] = 1
        tr_list = []
        P = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
        for _ in range(kmax):
            P = [[sum(P[i][k] * Am[k][j] for k in range(n))
                  for j in range(n)] for i in range(n)]
            tr_list.append(sum(P[i][i] for i in range(n)))
        return tr_list

    rep3 = sorted(T3, key=lambda T: sorted(T))[0]
    rep5 = sorted(T5, key=lambda T: sorted(T))[0]
    m3 = cayley_moments(sorted(rep3))
    m5 = cayley_moments(sorted(rep5))
    first_diff = next((k + 1 for k in range(len(m3)) if m3[k] != m5[k]), None)
    result["cayley_walk_moments"] = {
        "rho3_tr_Ak_k1_16": m3, "rho5_tr_Ak_k1_16": m5,
        "first_differing_k": first_diff,
        "graphs_isomorphic": False if first_diff else "undetermined"}
    assert first_diff is not None

    # ---- mirror pairing search in the color group {g -> tau(g) h}
    e5 = tuple(range(5))

    def pairing_search(T):
        Tf = frozenset(T)
        stab = [al for al in S5 if frozenset(conj(al, t) for t in Tf) == Tf]
        found = []
        for al in stab:
            for h in A5:
                if conj(al, h) != inv(h):
                    continue  # phi^2 != id
                ok = True
                for g in A5:
                    ph = mul(conj(al, g), h)
                    if ph == g:
                        ok = False
                        break
                    bad = False
                    for t in Tf:
                        if ph == mul(t, g):
                            bad = True
                            break
                    if bad:
                        ok = False
                        break
                if ok:
                    found.append({"tau_parity": parity(al),
                                  "tau_is_identity": al == e5,
                                  "tau": list(al), "h": list(h),
                                  "h_order": order(h)})
        return found

    pair_res = {}
    for (sig, rho), triples in sorted(cenA5.items()):
        rep = sorted(triples, key=lambda T: sorted(T))[0]
        found = pairing_search(rep)
        pair_res[f"{list(sig)}_rho{rho}"] = {
            "rep_triple": [list(t) for t in sorted(rep)],
            "pairings_found": len(found),
            "example": found[0] if found else None}
    result["regular_mirror_pairings"] = pair_res

    # ---- direct mirror criterion: involution w in G\T with w T w^-1 = T
    # (Lemma: such w makes g -> wg a free non-adjacent involutive automorphism
    #  of Cay(G,T) with edges {g,tg}, so the regular value is 0.)
    known_t1 = {  # C260/C284/AppendixA regular values
        ("S4", (2, 3, 3), 4): 0, ("S4", (2, 3, 4), 3): 0,
        ("S4", (3, 3, 3), 4): 0, ("S4", (3, 4, 4), 3): 0,
        ("A5", (2, 3, 5), 5): 1, ("A5", (2, 5, 5), 3): 1,
        ("A5", (3, 3, 5), 3): 0, ("A5", (3, 5, 5), 3): 0,
        ("A5", (3, 5, 5), 5): 0, ("A5", (5, 5, 5), 5): 0}
    mirror = {}
    for gname, G, cen in (("S4", S4, cenS4), ("A5", A5, cenA5)):
        for (sig, rho), triples in sorted(cen.items()):
            rep = sorted(triples, key=lambda T: sorted(T))[0]
            ws = [w for w in G if order(w) == 2 and w not in rep
                  and frozenset(conj(w, t) for t in rep) == rep]
            mirror[f"{gname}_{list(sig)}_rho{rho}"] = {
                "mirror_w_count": len(ws),
                "example_w": list(ws[0]) if ws else None,
                "regular_value": known_t1[(gname, sig, rho)],
                "mirror_forces_zero": bool(ws)}
            if ws:
                assert known_t1[(gname, sig, rho)] == 0, \
                    "mirror lemma contradicts computed regular value"
    result["mirror_criterion"] = mirror

    # ---- C284 residual replay + from-scratch reconstruction
    with open(C284_JSON) as f:
        c284 = json.load(f)
    rows = {}
    for r in c284["abstract_templates"]:
        if r["group"] == "A5" and r["pair_orders"] == [3, 5, 5]:
            rows[(r["triple_product_orders"][0], r["K"])] = r

    def build_residual(T, K):
        Klist = sorted(K)
        cosets = {}
        for g in A5:
            cs = frozenset(mul(g, k) for k in Klist)
            cosets.setdefault(cs, len(cosets))
        vlist = sorted(cosets, key=cosets.get)

        def cid(g):
            return cosets[frozenset(mul(g, k) for k in Klist)]

        reps = [sorted(cs)[0] for cs in vlist]
        a, b, c = sorted(T)
        prods = [mul(a, b), mul(a, c), mul(b, c)]
        dead = set()
        for i, g in enumerate(reps):
            for h in prods:
                if cid(mul(h, g)) == i:
                    dead.add(i)
                    break
        alive = [i for i in range(len(reps)) if i not in dead]
        remap = {v: i for i, v in enumerate(alive)}
        edges = set()
        for i in alive:
            for t in (a, b, c):
                j = cid(mul(t, reps[i]))
                if j != i and j in remap:
                    edges.add((min(remap[i], remap[j]), max(remap[i], remap[j])))
        return len(reps), len(dead), len(alive), sorted(edges), reps, prods, Klist, cid

    z2 = next(p for p in A5 if order(p) == 2)
    z3 = next(p for p in A5 if order(p) == 3)
    Ks = {"C2": closure([z2]), "C3": closure([z3]), "C5": closure([s0])}
    replay = {}
    for rho, triples in ((3, T3), (5, T5)):
        reps_to_try = sorted(triples, key=lambda T: sorted(T))
        for Kname, K in Ks.items():
            row = rows[(rho, Kname)]
            n_try = {"C5": 60, "C3": 3, "C2": 1}[Kname]
            iso_all = True
            for T in reps_to_try[:n_try]:
                ncos, ndead, nalive, edges, reps, prods, Klist, cid = \
                    build_residual(T, K)
                assert ncos == row["coset_size"] and ndead == row["deleted"] \
                    and nalive == row["residual_vertices"]
                if not graph_isomorphic(nalive, edges, row["edges"]):
                    iso_all = False
            # deleted-coset provenance for C5: 2+2 from the two order-5 products
            prov = None
            if Kname == "C5":
                ncos, ndead, nalive, edges, reps, prods, Klist, cid = \
                    build_residual(reps_to_try[0], K)
                per = []
                for h in prods:
                    if order(h) == 5:
                        per.append(sum(1 for i, g in enumerate(reps)
                                       if cid(mul(h, g)) == i))
                prov = sorted(per)
                assert prov == [2, 2]
            nim = nimber(row["residual_vertices"], row["edges"])
            assert nim == row["nimber"], (rho, Kname, nim, row["nimber"])
            replay[f"rho{rho}_{Kname}"] = {
                "coset_size": row["coset_size"], "deleted": row["deleted"],
                "reconstruction_isomorphic_to_c284": iso_all,
                "reps_reconstructed": n_try,
                "independent_nimber_replay": nim,
                "c284_nimber": row["nimber"],
                "deleted_per_order5_rotation_subgroup": prov}
    result["c284_residual_replay"] = replay

    # residual degree data for the report's structural description
    desc = {}
    for rho in (3, 5):
        for Kname in ("C5", "C3"):
            row = rows[(rho, Kname)]
            n = row["residual_vertices"]
            deg = [0] * n
            for u, v in row["edges"]:
                deg[u] += 1
                deg[v] += 1
            desc[f"rho{rho}_{Kname}"] = {
                "vertices": n, "edges": len(row["edges"]),
                "degree_multiset": sorted(deg)}
    result["residual_descriptions"] = desc

    print(json.dumps(result, indent=1, sort_keys=True))
    print("ALL CHECKS PASSED", file=sys.stderr)


if __name__ == "__main__":
    main()
