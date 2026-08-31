#!/usr/bin/env python3
"""C1018 independent verifier for PRS deep-hole / normal-rational-curve rank.

Deliberately independent of the Rust driver
(`ergodis-private/src/bin/c1018_prs_deephole.rs`) in three ways:

1.  the finite field is built from a *different* irreducible polynomial
    (highest-code rather than lowest-code monic irreducible), so the element
    labelling differs;
2.  the coset weight is computed from its *definition* -- minimum number of
    parity-check columns whose F_q-span contains the syndrome, decided by
    Gaussian rank -- rather than through the Hankel/apolarity criterion the
    Rust driver uses;
3.  no orbit machinery is used; sets are enumerated directly.

Subcommands
-----------
  census   q r          exhaustive PG(r-1,q) census (small parameters only)
  verify   q r file     re-check the orbit representatives of a driver JSON
"""

import itertools
import json
import sys


# --------------------------------------------------------------------------
# GF(p^h) built from the *last* monic irreducible in lexicographic code order
# --------------------------------------------------------------------------


def prime_power(q):
    p = 2
    while p * p <= q:
        if q % p == 0:
            break
        p += 1
    if p * p > q:
        return q, 1
    h, m = 0, q
    while m % p == 0:
        m //= p
        h += 1
    assert m == 1, f"{q} is not a prime power"
    return p, h


def poly_rem(a, b, p):
    a = list(a)
    db = len(b) - 1
    while len(a) > db:
        da = len(a) - 1
        c = a[da]
        if c:
            for i in range(db + 1):
                a[da - db + i] = (a[da - db + i] - c * b[i]) % p
        a.pop()
    while len(a) > 1 and a[-1] == 0:
        a.pop()
    return a


def irreducible(p, h):
    if h == 1:
        return [0, 1]
    found = None
    for code in range(p**h):
        f, c = [0] * h + [1], code
        for i in range(h):
            f[i] = c % p
            c //= p
        ok = True
        for m in range(1, h // 2 + 1):
            for gc in range(p**m):
                g, c = [0] * m + [1], gc
                for i in range(m):
                    g[i] = c % p
                    c //= p
                if poly_rem(f, g, p) == [0]:
                    ok = False
                    break
            if not ok:
                break
        if ok:
            found = f  # keep the LAST one: differs from the Rust driver
    assert found is not None
    return found


class GF:
    def __init__(self, q, poly=None):
        """`poly` overrides the defining polynomial.

        `census` leaves it None and picks its own (last-in-code-order) monic
        irreducible, so the field model is independent of the Rust driver.
        `verify` must pass the driver's polynomial: syndrome coordinates are
        element *labels*, and labels are only comparable inside one model.  The
        independence that matters there is the method -- definition-level span
        rank instead of the Hankel criterion -- not the labelling.
        """
        self.q = q
        self.p, self.h = prime_power(q)
        self.f = list(poly) if poly is not None else irreducible(self.p, self.h)
        p, h = self.p, self.h

        def digits(x):
            return [(x // p**i) % p for i in range(h)]

        def pack(v):
            return sum(v[i] % p * p**i for i in range(h))

        self.add = [[0] * q for _ in range(q)]
        self.mul = [[0] * q for _ in range(q)]
        for a in range(q):
            da = digits(a)
            for b in range(q):
                db = digits(b)
                self.add[a][b] = pack([(da[i] + db[i]) % p for i in range(h)])
                prod = [0] * (2 * h)
                for i in range(h):
                    if da[i]:
                        for j in range(h):
                            prod[i + j] = (prod[i + j] + da[i] * db[j]) % p
                while len(prod) > 1 and prod[-1] == 0:
                    prod.pop()
                rem = poly_rem(prod, self.f, p)
                self.mul[a][b] = pack([rem[i] if i < len(rem) else 0 for i in range(h)])
        self.neg = [next(b for b in range(q) if self.add[a][b] == 0) for a in range(q)]
        self.inv = [0] * q
        for a in range(1, q):
            self.inv[a] = next(b for b in range(1, q) if self.mul[a][b] == 1)

    def curve(self, d):
        """The q+1 parity-check columns: NRC of degree d in PG(d,q)."""
        pts = []
        for a in range(self.q):
            row, x = [], 1
            for _ in range(d + 1):
                row.append(x)
                x = self.mul[x][a]
            pts.append(tuple(row))
        pts.append(tuple([0] * d + [1]))
        return pts

    def rank(self, rows):
        rows = [list(r) for r in rows]
        cols = len(rows[0]) if rows else 0
        piv = 0
        for c in range(cols):
            sel = next((i for i in range(piv, len(rows)) if rows[i][c]), None)
            if sel is None:
                continue
            rows[piv], rows[sel] = rows[sel], rows[piv]
            iv = self.inv[rows[piv][c]]
            rows[piv] = [self.mul[x][iv] for x in rows[piv]]
            for i in range(len(rows)):
                if i != piv and rows[i][c]:
                    fac = rows[i][c]
                    rows[i] = [
                        self.add[rows[i][j]][self.neg[self.mul[fac][rows[piv][j]]]]
                        for j in range(cols)
                    ]
            piv += 1
            if piv == len(rows):
                break
        return piv


def coset_weight(gf, curve, s, dmax):
    """Definition-level weight: least |T| with s in span{curve[t] : t in T}."""
    for j in range(1, dmax + 2):
        for T in itertools.combinations(range(len(curve)), j):
            base = [curve[t] for t in T]
            if gf.rank(base) == gf.rank(base + [list(s)]):
                return j, T
    return dmax + 2, None


def projective_points(gf, d):
    q = gf.q
    for lead in range(d + 1):
        for tail in itertools.product(range(q), repeat=d - lead):
            yield tuple([0] * lead + [1] + list(tail))


# --------------------------------------------------------------------------
# structure of a single PGL(2,q)-orbit in PG(d,q)
# --------------------------------------------------------------------------


def sym_power(gf, d, a, b, c, e):
    """S[i][j] = coefficient of x^{d-j} y^j in (a x + b y)^{d-i} (c x + e y)^i."""

    def binom(n, k):
        acc = 1
        for i in range(k):
            acc = acc * (n - i) // (i + 1)
        return acc

    def powf(x, n):
        acc = 1
        for _ in range(n):
            acc = gf.mul[acc][x]
        return acc

    s = [[0] * (d + 1) for _ in range(d + 1)]
    for i in range(d + 1):
        av = [
            gf.mul[gf.mul[binom(d - i, k) % gf.p][powf(a, d - i - k)]][powf(b, k)]
            for k in range(d - i + 1)
        ]
        bv = [
            gf.mul[gf.mul[binom(i, k) % gf.p][powf(c, i - k)]][powf(e, k)]
            for k in range(i + 1)
        ]
        for ka, x in enumerate(av):
            if not x:
                continue
            for kb, y in enumerate(bv):
                if y:
                    s[i][ka + kb] = gf.add[s[i][ka + kb]][gf.mul[x][y]]
    return s


def act(gf, m, v):
    out = []
    for row in m:
        acc = 0
        for x, y in zip(row, v):
            if x and y:
                acc = gf.add[acc][gf.mul[x][y]]
        out.append(acc)
    return tuple(out)


def normalize(gf, v):
    lead = next(i for i, x in enumerate(v) if x)
    iv = gf.inv[v[lead]]
    return tuple(gf.mul[x][iv] for x in v)


def pgl_elements(gf):
    """All of PGL(2,q) as normalized (a,b,c,d) with ad-bc != 0."""
    q = gf.q
    out = []
    for t in itertools.product(range(q), repeat=4):
        a, b, c, e = t
        det = gf.add[gf.mul[a][e]][gf.neg[gf.mul[b][c]]]
        if det == 0:
            continue
        lead = next(i for i, x in enumerate(t) if x)
        iv = gf.inv[t[lead]]
        if gf.mul[t[lead]][iv] == 1 and t[lead] == 1:
            out.append(t)
    return out


def kernel_basis(gf, rows, cols, data):
    """Reduced row echelon form, then an explicit null-space basis."""
    m = [list(data[i * cols : (i + 1) * cols]) for i in range(rows)]
    piv_cols, piv = [], 0
    for c in range(cols):
        sel = next((i for i in range(piv, rows) if m[i][c]), None)
        if sel is None:
            continue
        m[piv], m[sel] = m[sel], m[piv]
        iv = gf.inv[m[piv][c]]
        m[piv] = [gf.mul[x][iv] for x in m[piv]]
        for i in range(rows):
            if i != piv and m[i][c]:
                f = m[i][c]
                m[i] = [
                    gf.add[m[i][j]][gf.neg[gf.mul[f][m[piv][j]]]] for j in range(cols)
                ]
        piv_cols.append(c)
        piv += 1
        if piv == rows:
            break
    free = [c for c in range(cols) if c not in piv_cols]
    basis = []
    for fc in free:
        v = [0] * cols
        v[fc] = 1
        for ri, pc in enumerate(piv_cols):
            v[pc] = gf.neg[m[ri][fc]]
        basis.append(tuple(v))
    return basis


def form_roots(gf, l, j):
    """Root multiset of the binary form sum l_u X^u Y^{j-u} over PG(1,q).

    Returns (root_list, is_split_squarefree); the entry `q` denotes infinity.
    """
    roots = []
    for a in range(gf.q):
        val, powa = 0, 1
        for u in range(j + 1):
            if l[u]:
                val = gf.add[val][gf.mul[l[u]][powa]]
            powa = gf.mul[powa][a]
        if val == 0:
            roots.append(a)
    deg = max((u for u in range(j + 1) if l[u]), default=0)
    inf_mult = j - deg
    if inf_mult:
        roots.append(gf.q)
    total = len(roots) + (inf_mult - 1 if inf_mult else 0)
    return roots, (inf_mult <= 1 and len(roots) == j)


def cmd_structure(q, r, rep):
    d = r - 1
    gf = GF(q)
    s0 = normalize(gf, tuple(rep))
    curve = gf.curve(d)

    g = next(x for x in range(2, q) if _order(gf, x) == q - 1) if q > 3 else q - 1
    gens = [
        sym_power(gf, d, 1, 0, 1, 1),
        sym_power(gf, d, 1, 0, 0, g),
        sym_power(gf, d, 0, 1, 1, 0),
    ]

    # orbit
    seen, queue = {s0}, [s0]
    while queue:
        cur = queue.pop()
        for m in gens:
            nxt = normalize(gf, act(gf, m, cur))
            if nxt not in seen:
                seen.add(nxt)
                queue.append(nxt)
    orbit = sorted(seen)
    pgl_order = (q * q - 1) * q
    stab_order = pgl_order // len(orbit)

    # sparsest representatives
    best = min(sum(1 for x in v if x) for v in orbit)
    sparse = [v for v in orbit if sum(1 for x in v if x) == best]

    # stabilizer of the sparsest representative, with element orders
    sref = sparse[0]
    stab = []
    for a, b, c, e in pgl_elements(gf):
        m = sym_power(gf, d, a, b, c, e)
        if normalize(gf, act(gf, m, sref)) == sref:
            stab.append((a, b, c, e))
    orders = []
    for t in stab:
        m = sym_power(gf, 1, *t)
        cur, k = m, 1
        ident = [[1, 0], [0, 1]]
        while normalize(gf, tuple(cur[0] + cur[1])) != normalize(
            gf, tuple(ident[0] + ident[1])
        ):
            cur = [
                [
                    _dot(gf, cur[i], [m[0][j], m[1][j]])
                    for j in range(2)
                ]
                for i in range(2)
            ]
            k += 1
            if k > pgl_order:
                break
        orders.append(k)

    # apolar structure
    apolar = {}
    e_level = None
    for j in range(1, d + 1):
        rows, cols = d - j + 1, j + 1
        data = [s0[u + v] for v in range(rows) for u in range(cols)]
        basis = kernel_basis(gf, rows, cols, data)
        if basis:
            e_level = j
            members = []
            for coeffs in itertools.product(range(q), repeat=len(basis)):
                if not any(coeffs):
                    continue
                lead = next(i for i, x in enumerate(coeffs) if x)
                if coeffs[lead] != 1:
                    continue
                l = [0] * (j + 1)
                for ci, bv in zip(coeffs, basis):
                    if ci:
                        for u in range(j + 1):
                            l[u] = gf.add[l[u]][gf.mul[ci][bv[u]]]
                members.append(tuple(l))
            profile = collections_counter(
                _root_type(gf, l, j) for l in members
            )
            apolar = {
                "apolar_degree": j,
                "kernel_dim": len(basis),
                "kernel_basis": [list(b) for b in basis],
                "members": len(members),
                "root_type_profile": profile,
                "split_squarefree_members": sum(
                    1 for l in members if form_roots(gf, l, j)[1]
                ),
            }
            break

    w, T = coset_weight(gf, curve, s0, d)
    print(
        json.dumps(
            {
                "q": q,
                "r": r,
                "d": d,
                "rep": list(s0),
                "orbit_size": len(orbit),
                "pgl_order": pgl_order,
                "stabilizer_order": stab_order,
                "stabilizer_element_orders": sorted(orders),
                "sparsest_support_size": best,
                "sparsest_reps": [list(v) for v in sparse[:6]],
                "sparsest_rep_count": len(sparse),
                "weight": w,
                "min_spanning_set": list(T) if T else None,
                **apolar,
            }
        )
    )


def cmd_stratum(q, r, m, a):
    """Exact weight census of the arithmetic-progression stratum.

    The stratum is { s : s_i = 0 unless i ≡ a (mod m) } ⊂ PG(d,q), the fixed
    locus of the order-m diagonal torus element t ↦ ζ_m t.  It is a projective
    subspace, so it can be swept exactly at field orders far beyond the reach
    of a full PG(d,q) census.  A deep point here with consecutive three-row
    catalecticant rank ≥ 3 is an exceptional deep hole.
    """
    d = r - 1
    gf = GF(q)
    curve = gf.curve(d)
    idx = [i for i in range(d + 1) if i % m == a % m]
    hist, deep, exc = {}, [], []
    rho = None
    for tail in itertools.product(range(q), repeat=len(idx)):
        if not any(tail):
            continue
        lead = next(i for i, x in enumerate(tail) if x)
        if tail[lead] != 1:
            continue
        s = [0] * (d + 1)
        for i, v in zip(idx, tail):
            s[i] = v
        w, _ = coset_weight(gf, curve, tuple(s), d)
        hist[w] = hist.get(w, 0) + 1
        rho = w if rho is None else max(rho, w)
    # second pass now that the stratum maximum is known
    for tail in itertools.product(range(q), repeat=len(idx)):
        if not any(tail):
            continue
        lead = next(i for i, x in enumerate(tail) if x)
        if tail[lead] != 1:
            continue
        s = [0] * (d + 1)
        for i, v in zip(idx, tail):
            s[i] = v
        w, _ = coset_weight(gf, curve, tuple(s), d)
        if w != d:  # d = r-1 is the covering radius in every non-exceptional cell
            continue
        cat = [[s[i + j] for j in range(d - 1)] for i in range(3)]
        deep.append(s)
        if gf.rank(cat) >= 3:
            exc.append(s)
    print(
        json.dumps(
            {
                "q": q,
                "r": r,
                "d": d,
                "stratum": f"support ⊆ {{i ≡ {a} mod {m}}} = {idx}",
                "stratum_points": (q ** len(idx) - 1) // (q - 1),
                "weight_histogram": {str(k): v for k, v in sorted(hist.items())},
                "stratum_max_weight": rho,
                "deep_in_stratum": len(deep),
                "exceptional_in_stratum": len(exc),
                "exceptional_examples": exc[:4],
            }
        )
    )


def _order(gf, x):
    cur, k = x, 1
    while cur != 1:
        cur = gf.mul[cur][x]
        k += 1
    return k


def _dot(gf, u, v):
    acc = 0
    for a, b in zip(u, v):
        if a and b:
            acc = gf.add[acc][gf.mul[a][b]]
    return acc


def _root_type(gf, l, j):
    """Partition of j given by the root multiplicities over PG(1,q), plus the
    non-rational remainder recorded as 'i<k>'."""
    mults = []
    poly = list(l)
    deg = max((u for u in range(j + 1) if poly[u]), default=0)
    inf_mult = j - deg
    if inf_mult:
        mults.append(inf_mult)
    work = poly[: deg + 1]
    for a in range(gf.q):
        m = 0
        while len(work) > 1:
            val, powa = 0, 1
            for u in range(len(work)):
                if work[u]:
                    val = gf.add[val][gf.mul[work[u]][powa]]
                powa = gf.mul[powa][a]
            if val != 0:
                break
            # synthetic division by (x - a)
            out = [0] * (len(work) - 1)
            carry = 0
            for u in range(len(work) - 1, 0, -1):
                out[u - 1] = gf.add[work[u]][carry]
                carry = gf.mul[out[u - 1]][a]
            work = out
            m += 1
        if m:
            mults.append(m)
    rem = j - sum(mults)
    key = "+".join(str(x) for x in sorted(mults, reverse=True)) or "-"
    if rem:
        key += f"+i{rem}"
    return key


def collections_counter(it):
    out = {}
    for x in it:
        out[x] = out.get(x, 0) + 1
    return dict(sorted(out.items()))


def cmd_census(q, r):
    d = r - 1
    gf = GF(q)
    curve = gf.curve(d)
    hist = {}
    for s in projective_points(gf, d):
        w, _ = coset_weight(gf, curve, s, d)
        hist[w] = hist.get(w, 0) + 1
    rho = max(hist)
    print(
        json.dumps(
            {
                "method": "definition/rank",
                "q": q,
                "r": r,
                "d": d,
                "defining_poly": gf.f,
                "projective_points": sum(hist.values()),
                "covering_radius": rho,
                "deep_hole_projective_points": hist[rho],
                "weight_histogram": {str(k): v for k, v in sorted(hist.items())},
            }
        )
    )


def cmd_verify(q, r, path):
    d = r - 1
    data = json.load(open(path))
    assert data["q"] == q and data["r"] == r
    gf = GF(q, poly=data["defining_poly"])
    curve = gf.curve(d)
    rho = data["covering_radius"]
    persistent = q * (q + 1) ** 2 // 2
    total = 0
    bad = []
    # `c1018_prs_deephole` emits every retained representative under "orbits";
    # `c1018_prs_census` emits only the deep ones, under "deep_orbits".
    orbits = data.get("orbits")
    if orbits is None:
        orbits = data["deep_orbits"]
    data["orbits"] = orbits
    for rec in data["orbits"]:
        s = tuple(rec["rep"])
        w, _ = coset_weight(gf, curve, s, d)
        agree = w == rec["w"]
        if not agree:
            bad.append((s, rec["w"], w))
        if rec["w"] == rho:
            total += rec["size"]
        # persistence test: consecutive three-row Hankel of rank <= 2
        cat = [[s[i + j] for j in range(d - 1)] for i in range(3)]
        rec["cat2_rank"] = gf.rank(cat)
    print(
        json.dumps(
            {
                "method": "definition/rank",
                "q": q,
                "r": r,
                "defining_poly": gf.f,
                "representatives_checked": len(data["orbits"]),
                "weight_disagreements": bad,
                "listed_deep_orbit_size_sum": total,
                "driver_deep_points": data["deep_hole_projective_points"],
                "persistent_locus_size": persistent,
                "deep_rep_cat2_ranks": sorted(
                    {rec["cat2_rank"] for rec in data["orbits"] if rec["w"] == rho}
                ),
            }
        )
    )


if __name__ == "__main__":
    if sys.argv[1] == "census":
        cmd_census(int(sys.argv[2]), int(sys.argv[3]))
    elif sys.argv[1] == "verify":
        cmd_verify(int(sys.argv[2]), int(sys.argv[3]), sys.argv[4])
    elif sys.argv[1] == "stratum":
        cmd_stratum(
            int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5])
        )
    elif sys.argv[1] == "structure":
        cmd_structure(
            int(sys.argv[2]),
            int(sys.argv[3]),
            [int(x) for x in sys.argv[4].split(",")],
        )
    else:
        raise SystemExit(__doc__)
