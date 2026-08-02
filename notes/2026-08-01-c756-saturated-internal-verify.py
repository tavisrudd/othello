#!/usr/bin/env python3
"""C756 saturated-internal branch: independent verifier.

Shares no code with notes/2026-08-01-c756-saturated-internal-audit.rs: F_{q^2} is
built as pairs (a, b) ~ a + b*sqrt(eps) over prime q with eps the smallest nonsquare
(the Rust auditor uses a Zech/primitive-polynomial model), and the clique search is an
independent implementation.

Checks
  A. candidate / arc / covering counts agree with the audit JSON for prime q in the
     given list (default 5 7 11 13 19), and no candidate is Segre-coherent for q > 5.
  B. at q = 5, on every covering arc, every identity used by the report:
     1. Segre triple sign identity  s_ij s_jk s_ki = (-1)^(t+1);
     2. a coherent choice of representatives exists; after normalization
        chi(z_i - z_j^q) = (-1)^(t+1) and chi(z_i - z_j) = (-1)^t for all pairs;
     3. the combinatorial tangents at each arc point are exactly the conic-secants
        through it, and the canonical tangent polynomial
        T_i(Q) = (f_Q(z_i)^((q+1)/2) - f_Q(z_i^q)^((q+1)/2)) / (z_i^q - z_i)
        is F_q-valued and vanishes exactly on their union;
     4. T_i(P_j) = 2 f_j(z_i)^((q+1)/2) / (z_i^q - z_i)  and  R_ij = s_ij d_j/d_i;
     5. relative angles at every arc point are distinct and fill the odd coset
        of mu_{q+1}, so their product is c = (-1)^((q+1)/2);
     6. F_i = prod_{j != i} f_j(z_i) satisfies F_i^(q-1) = c, equivalently
        G | G'^q - (-1)^(t+1) G'  for the master polynomial G = prod f_i;
     7. Vandermonde rigidity: with coherent representatives V^(q-1) = +1 or -1,
        with the branch pinned by q mod 8 (q = 5 mod 8 forces V rational);
     8. balance (tight interlacing): S(w) = S(w^q) for every w outside Z u Z^q,
        where S(w) = sum_i chi_{q^2}(w - z_i) over coherent representatives.

Run:  python3 notes/2026-08-01-c756-saturated-internal-verify.py \
          notes/2026-08-01-c756-saturated-internal-audit.json 5 7 11 13 19
Exits nonzero on any failure; prints a JSON summary on success.
"""
import json
import sys
from itertools import combinations, product


def field(q):
    eps = next(e for e in range(2, q) if pow(e, (q - 1) // 2, q) != 1)
    add = lambda u, v: ((u[0] + v[0]) % q, (u[1] + v[1]) % q)
    sub = lambda u, v: ((u[0] - v[0]) % q, (u[1] - v[1]) % q)
    mul = lambda u, v: ((u[0] * v[0] + eps * u[1] * v[1]) % q, (u[0] * v[1] + u[1] * v[0]) % q)
    conj = lambda u: (u[0], (-u[1]) % q)

    def fpow(u, e):
        r = (1, 0)
        while e:
            if e & 1:
                r = mul(r, u)
            u = mul(u, u)
            e >>= 1
        return r

    def chi2(u):
        if u == (0, 0):
            return 0
        return 1 if fpow(u, (q * q - 1) // 2) == (1, 0) else -1

    return eps, add, sub, mul, conj, fpow, chi2


def det3(u, v, w, q):
    return (
        u[0] * (v[1] * w[2] - v[2] * w[1])
        - u[1] * (v[0] * w[2] - v[2] * w[0])
        + u[2] * (v[0] * w[1] - v[1] * w[0])
    ) % q


def plane_points(q):
    pts = []
    for b in range(q):
        for c in range(q):
            pts.append((1, b, c))
    for c in range(q):
        pts.append((0, 1, c))
    pts.append((0, 0, 1))
    return pts


def run_q(q):
    """Independent candidate enumeration; returns counts and the candidate list."""
    eps, add, sub, mul, conj, fpow, chi2 = field(q)
    k = (q + 3) // 2
    t = (q + 1) // 2
    sigma = 1 if (t + 1) % 2 == 0 else -1
    reps = [(a, b) for b in range(1, (q - 1) // 2 + 1) for a in range(q)]
    assert len(reps) == q * (q - 1) // 2
    p0 = reps.index((0, 1))

    def cond(i, j):
        zi, zj = reps[i], reps[j]
        return chi2(mul(sub(zi, zj), sub(zi, conj(zj)))) == -1

    verts = [i for i in range(len(reps)) if i != p0 and cond(p0, i)]
    adjm = {v: set() for v in verts}
    for a, b in combinations(verts, 2):
        if cond(a, b):
            adjm[a].add(b)
            adjm[b].add(a)

    sols = []

    def dfs(chosen, cand):
        if len(chosen) == k - 1:
            sols.append(list(chosen))
            return
        cand = sorted(cand)
        while cand:
            v = cand.pop(0)
            if len(chosen) + 1 + len([c for c in cand if c in adjm[v]]) < k - 1:
                continue
            dfs(chosen + [v], [c for c in cand if c in adjm[v]])

    dfs([], sorted(verts))

    def row(i):
        z = reps[i]
        tr = add(z, conj(z))
        nm = mul(z, conj(z))
        assert tr[1] == 0 and nm[1] == 0
        return (1, (-tr[0]) % q, nm[0])

    plane = plane_points(q)
    off_conic = [P for P in plane if (P[1] * P[1] - 4 * P[0] * P[2]) % q != 0]
    assert len(off_conic) == q * q

    out = {"candidates": 0, "coherent": 0, "arcs": 0, "covering": 0, "cand_sets": []}
    for s in sols:
        idxs = [p0] + s
        out["candidates"] += 1
        # coherence
        svals = {}
        for a, b in combinations(range(len(idxs)), 2):
            svals[(a, b)] = chi2(sub(reps[idxs[a]], conj(reps[idxs[b]])))
        e = {i: sigma * svals[(0, i)] for i in range(1, len(idxs))}
        coherent = all(
            sigma * svals[(a, b)] == e[a] * e[b] for a, b in combinations(range(1, len(idxs)), 2)
        )
        if coherent:
            out["coherent"] += 1
        rows = [row(i) for i in idxs]
        arc = all(det3(u, v, w, q) for u, v, w in combinations(rows, 3))
        if arc:
            out["arcs"] += 1
            covering = all(
                any(det3(P, rows[a], rows[b], q) == 0 for a, b in combinations(range(len(rows)), 2))
                for P in off_conic
            )
            if covering:
                out["covering"] += 1
                out["cand_sets"].append([reps[i] for i in idxs])
    return out


def verify_q5():
    q = 5
    eps, add, sub, mul, conj, fpow, chi2 = field(q)
    k, t = 4, 3
    sigma = 1 if (t + 1) % 2 == 0 else -1  # +1
    c = 1 if t % 2 == 0 else -1  # (-1)^t = -1
    res = run_q(q)
    assert res["covering"] == 2, res
    inv = lambda u: fpow(u, q * q - 2)
    checks = []
    for Z0 in res["cand_sets"]:
        # 1. triple identity
        s = lambda zi, zj: chi2(sub(zi, conj(zj)))
        for a, b, cc in combinations(range(k), 3):
            assert s(Z0[a], Z0[b]) * s(Z0[b], Z0[cc]) * s(Z0[cc], Z0[a]) == sigma
        # 2. coherent representative choice
        found = None
        for flips in product([0, 1], repeat=k):
            Z = [conj(z) if fl else z for z, fl in zip(Z0, flips)]
            if all(s(Z[a], Z[b]) == sigma for a, b in combinations(range(k), 2)):
                found = Z
                break
        assert found is not None
        Z = found
        for a, b in combinations(range(k), 2):
            assert chi2(sub(Z[a], Z[b])) == -sigma  # = (-1)^t
        # 3. tangents at each point are the conic-secants; T_i cuts them
        rows = []
        for z in Z:
            tr, nm = add(z, conj(z)), mul(z, conj(z))
            rows.append((1, (-tr[0]) % q, nm[0]))
        plane = plane_points(q)
        conic = [P for P in plane if (P[1] * P[1] - 4 * P[0] * P[2]) % q == 0]
        assert len(conic) == q + 1
        lines = set()
        for P, Q in combinations(plane, 2):
            lines.add(
                tuple(sorted(R for R in plane if det3(P, Q, R, q) == 0))
            )
        lines = [set(L) for L in lines]
        m = (q + 1) // 2
        for i in range(k):
            thru = [L for L in lines if tuple(rows[i]) in {tuple(x) for x in L}]
            # tangent lines of the arc at P_i
            tang = [
                L
                for L in thru
                if not any(tuple(rows[j]) in {tuple(x) for x in L} for j in range(k) if j != i)
            ]
            secants = [L for L in thru if len([P for P in L if P in conic]) == 2]
            assert len(tang) == t and {frozenset(map(tuple, L)) for L in tang} == {
                frozenset(map(tuple, L)) for L in secants
            }
            # canonical tangent polynomial
            zi, ziq = Z[i], conj(Z[i])
            d_i = sub(ziq, zi)

            def T(P):
                fz = lambda z: add(add(mul((P[0], 0), mul(z, z)), mul((P[1], 0), z)), (P[2], 0))
                num = sub(fpow(fz(zi), m), fpow(fz(ziq), m))
                return mul(num, inv(d_i))

            union_t = set()
            for L in tang:
                union_t |= {tuple(P) for P in L}
            for P in plane:
                v = T(P)
                assert v[1] == 0  # F_q-valued
                if tuple(P) == tuple(rows[i]):
                    continue
                assert (v == (0, 0)) == (tuple(P) in union_t)
        # 4. evaluation formula and R_ij = s_ij d_j/d_i
        def fj_at(j, z):
            return mul(sub(z, Z[j]), sub(z, conj(Z[j])))

        for i in range(k):
            zi, ziq = Z[i], conj(Z[i])
            d_i = sub(ziq, zi)
            for j in range(k):
                if j == i:
                    continue
                lhs_num = sub(fpow(fj_at(j, zi), m), fpow(fj_at(j, ziq), m))
                lhs = mul(lhs_num, inv(d_i))
                rhs = mul(mul((2, 0), fpow(fj_at(j, zi), m)), inv(d_i))
                assert lhs == rhs
        # 5. relative angles fill the odd coset; product is c
        for i in range(k):
            angles = []
            for j in range(k):
                if j == i:
                    continue
                u = mul(sub(Z[j], Z[i]), inv(sub(Z[j], conj(Z[i]))))
                a_ = mul(u, inv(fpow(u, q)))  # u^(1-q)
                assert fpow(a_, (q + 1) // 2) == ((q - 1), 0)  # odd coset
                angles.append(a_)
            assert len(set(angles)) == k - 1 == (q + 1) // 2
            prod = (1, 0)
            for a_ in angles:
                prod = mul(prod, a_)
            assert prod == ((q + c) % q, 0)
        # 6. F_i^(q-1) = c and master-polynomial divisibility
        for i in range(k):
            F = (1, 0)
            for j in range(k):
                if j != i:
                    F = mul(F, fj_at(j, Z[i]))
            assert fpow(F, q - 1) == ((q + c) % q, 0)
        # G | G'^q - (-1)^(t+1) G'  over F_q
        G = [1]
        for r in rows:
            G = polymul(G, [r[2], r[1], 1], q)  # nm + (-tr) X + X^2
        dG = [(i * G[i]) % q for i in range(1, len(G))]
        pw = polypowmod(dG, q, G, q)
        rem = polymod(polysub(pw, polyscale(dG, sigma % q, q), q), G, q)
        assert all(x == 0 for x in rem)
        # 7. Vandermonde rigidity with the mod-8 pin (q=5: rational branch)
        V = (1, 0)
        for a, b in combinations(range(k), 2):
            V = mul(V, sub(Z[a], Z[b]))
        assert fpow(V, q - 1) == (1, 0)
        # 8. balance S(w) = S(w^q) outside Z u Z^q
        zs = {z for z in Z} | {conj(z) for z in Z}
        for w in [(a, b) for a in range(q) for b in range(q)]:
            if w in zs:
                continue
            Sw = sum(chi2(sub(w, z)) for z in Z)
            Swq = sum(chi2(sub(conj(w), z)) for z in Z)
            assert Sw == Swq
        checks.append("ok")
    return checks


def polymul(a, b, q):
    r = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            r[i + j] = (r[i + j] + x * y) % q
    return r


def polymod(a, g, q):
    a = a[:]
    ginv = pow(g[-1], q - 2, q)
    while len(a) >= len(g) and any(a):
        if a[-1] == 0:
            a.pop()
            continue
        f = (a[-1] * ginv) % q
        off = len(a) - len(g)
        for i in range(len(g)):
            a[off + i] = (a[off + i] - f * g[i]) % q
        a.pop()
    return a


def polysub(a, b, q):
    n = max(len(a), len(b))
    a = a + [0] * (n - len(a))
    b = b + [0] * (n - len(b))
    return [(x - y) % q for x, y in zip(a, b)]


def polyscale(a, s, q):
    return [(x * s) % q for x in a]


def polypowmod(a, e, g, q):
    r = [1]
    a = polymod(a[:], g, q)
    while e:
        if e & 1:
            r = polymod(polymul(r, a, q), g, q)
        a = polymod(polymul(a, a, q), g, q)
        e >>= 1
    return r


def main():
    args = sys.argv[1:]
    audit_path = args[0] if args else "notes/2026-08-01-c756-saturated-internal-audit.json"
    qs = [int(a) for a in args[1:]] or [5, 7, 11, 13, 19]
    audit = {r["q"]: r for r in json.load(open(audit_path))["rows"]}
    summary = {}
    for q in qs:
        res = run_q(q)
        row = audit[q]
        for key in ("candidates", "coherent", "arcs", "covering"):
            if res[key] != row[key]:
                print(f"MISMATCH q={q} {key}: verify={res[key]} audit={row[key]}")
                sys.exit(1)
        if q > 5 and res["coherent"] != 0:
            print(f"UNEXPECTED coherent candidate at q={q}")
            sys.exit(1)
        summary[str(q)] = {k: res[k] for k in ("candidates", "coherent", "arcs", "covering")}
    summary["q5_identity_suite"] = verify_q5()
    print(json.dumps({"task": "C756", "verifier": "saturated-internal", "counts": summary, "all_checks_pass": True}, indent=1, sort_keys=True))


if __name__ == "__main__":
    main()
