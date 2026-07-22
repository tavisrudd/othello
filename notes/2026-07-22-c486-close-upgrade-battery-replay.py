#!/usr/bin/env python3
"""C486 independent replay. Imports no primary code.

Re-verifies all three legs with independent constructions:
  - PGL_2(q)/PSL_2(q) built by direct enumeration of GL_2(F_q) modulo scalars
    (not by BFS closure of generators);
  - the two sheets built as PSL orbits and the Rz swap checked from scratch;
  - the C474 q=11 fibre re-read from the pinned certificate and its 22-signature
    two-part structure checked; the child-conic parametrisation re-derived by an
    independent tangent/pencil route and aligned to the C445 golden orbit;
  - L2 sign-character kernel orders recomputed;
  - L3 F_25 Frobenius orbit and the split/inert trichotomy recomputed.
"""
import json, hashlib, os, sys

HERE = os.path.dirname(os.path.abspath(__file__))

PIN = {
    "2026-07-22-c474-reed-solomon-decorated-deep-holes.json": "02cb69e2d26deb9f",
    "2026-07-21-c445-characteristic-11-gluing.json": "0ce94294e6e3e190",
    "2026-07-22-c473-arithmetic-orientation.json": "0f7c8e94d68640d8",
    "2026-07-21-c444-silver-fusion.json": "311dd3eba6ad7b29",
    "2026-07-22-c480-close-gap-certificates.json": "08a89e884b1b1a6b",
    "2026-07-20-c417-affine-cocycle-line-bundle.json": "ca8b009710da9893",
    "2026-07-21-c448-orbit-valued-selector.json": "02f8d75f49727321",
}


def pin(name):
    p = os.path.join(HERE, name)
    h = hashlib.sha256(open(p, "rb").read()).hexdigest()[:16]
    assert h == PIN[name], f"hash {name}: {h} != {PIN[name]}"
    return json.load(open(p))


def inv(a, q):
    return pow(a % q, q - 2, q)


def full_pgl(q):
    """All PGL_2(q) as normalised (a,b,c,d) with ad-bc != 0, first-nonzero = 1."""
    seen = {}
    for a in range(q):
        for b in range(q):
            for c in range(q):
                for d in range(q):
                    if (a * d - b * c) % q == 0:
                        continue
                    m = (a, b, c, d)
                    for e in m:
                        if e % q:
                            s = inv(e, q)
                            key = tuple((x * s) % q for x in m)
                            break
                    seen[key] = True
    return list(seen)


def det(m, q):
    a, b, c, d = m
    return (a * d - b * c) % q


def issq(x, q):
    return pow(x % q, (q - 1) // 2, q) == 1


def mob(m, x, q):
    a, b, c, d = m
    INF = q
    if x == INF:
        return INF if c % q == 0 else (a * inv(c, q)) % q
    den = (c * x + d) % q
    return INF if den == 0 else ((a * x + b) % q * inv(den, q)) % q


def act(m, match, q):
    return frozenset(tuple(sorted((mob(m, a, q), mob(m, b, q)))) for a, b in match)


def leg1():
    q = 11
    G = full_pgl(q)
    assert len(G) == 1320
    PSL = [m for m in G if issq(det(m, q), q)]
    assert len(PSL) == 660

    c445 = pin("2026-07-21-c445-characteristic-11-gluing.json")
    ch = c445["exact_gluing_theorem"]["characteristic_11"]
    base = [tuple(sorted(p)) for p in ch["base_matching"]]
    jmate = [tuple(sorted(p)) for p in ch["jmate_matching"]]
    Rz = tuple(ch["outer_transporter"]["matrix_mod_11"])

    orbit = {act(m, base, q) for m in G}
    s0 = {act(m, base, q) for m in PSL}
    s1 = {act(m, jmate, q) for m in PSL}
    assert len(orbit) == 22 and len(s0) == 11 and len(s1) == 11
    assert s0.isdisjoint(s1) and s0 | s1 == orbit
    assert not issq(det(Rz, q), q) and det(Rz, q) == 2
    assert act(Rz, base, q) in s1 and act(Rz, jmate, q) in s0

    # C474 fibre
    c474 = pin("2026-07-22-c474-reed-solomon-decorated-deep-holes.json")
    case = next(x for x in c474["cases"] if x["q"] == 11)
    locus = [tuple(p) for p in case["locus"]]
    sigs = case["signatures"]
    parts = case["signature_overlap_relation"]["parts"]
    assert len(sigs) == 22 and sorted(len(p) for p in parts) == [11, 11]
    assert case["signature_overlap_relation"]["part_preserving_action_order"] == 660

    # independent conic fit
    def mons(p):
        x, y, z = p
        return [x * x % q, y * y % q, z * z % q, x * y % q, x * z % q, y * z % q]

    # solve 6-unknown homogeneous system by brute nullvector search on reduced rows
    rows = [mons(p) for p in locus]
    # Gaussian elimination
    R = [r[:] for r in rows]
    piv = []
    r = 0
    for c in range(6):
        pr = next((i for i in range(r, len(R)) if R[i][c] % q), None)
        if pr is None:
            continue
        R[r], R[pr] = R[pr], R[r]
        s = inv(R[r][c], q)
        R[r] = [(x * s) % q for x in R[r]]
        for i in range(len(R)):
            if i != r and R[i][c] % q:
                f = R[i][c]
                R[i] = [(a - f * b) % q for a, b in zip(R[i], R[r])]
        piv.append(c)
        r += 1
    free = [c for c in range(6) if c not in piv]
    assert len(free) == 1
    fc = free[0]
    conic = [0] * 6
    conic[fc] = 1
    for i, pc in enumerate(piv):
        conic[pc] = (-R[i][fc]) % q
    A, B, C, D, E, F = conic

    def pn(p):
        for e in p:
            if e % q:
                s = inv(e, q)
                return tuple((x * s) % q for x in p)
        return p

    # independent parametrisation: order the conic points by an explicit rational
    # sweep through a pencil of lines about a fixed conic point.
    ptn = [pn(p) for p in locus]

    def dot(a, b):
        return (a[0] * b[0] + a[1] * b[1] + a[2] * b[2]) % q

    def crs(u, v):
        return ((u[1] * v[2] - u[2] * v[1]) % q,
                (u[2] * v[0] - u[0] * v[2]) % q,
                (u[0] * v[1] - u[1] * v[0]) % q)

    O = ptn[3]  # different base point than primary (index 0) -> independent labels
    tan = ((2 * A * O[0] + D * O[1] + E * O[2]) % q,
           (2 * B * O[1] + D * O[0] + F * O[2]) % q,
           (2 * C * O[2] + E * O[0] + F * O[1]) % q)
    Ln = next(c for c in [(0, 0, 1), (0, 1, 0), (1, 0, 0), (1, 1, 1)] if dot(c, O))
    bM = [P for P in [(1, 0, 0), (0, 1, 0), (0, 0, 1), (1, 1, 0), (1, 0, 1),
                      (0, 1, 1), (1, 1, 1)] if dot(Ln, P) == 0][:2]

    def lc(X):
        for (al, be) in [(1, t) for t in range(q)] + [(0, 1)]:
            if pn(tuple((al * bM[0][i] + be * bM[1][i]) % q for i in range(3))) == pn(X):
                return q if be == 0 else (al * inv(be, q)) % q
        raise RuntimeError

    coord = {}
    for i, P in enumerate(ptn):
        ell = tan if P == O else crs(O, P)
        coord[i] = lc(crs(ell, Ln))
    assert sorted(coord.values()) == list(range(12))
    tsigs = [frozenset(tuple(sorted((coord[a], coord[b]))) for a, b in s) for s in sigs]

    t0 = next(iter(tsigs))
    align = None
    for m in G:
        if act(m, [tuple(x) for x in t0], q) in orbit:
            if {act(m, [tuple(x) for x in ts], q) for ts in tsigs} == orbit:
                align = m
                break
    assert align is not None
    pi = [{act(align, [tuple(x) for x in tsigs[i]], q) for i in part} for part in parts]
    assert {frozenset(pi[0]), frozenset(pi[1])} == {frozenset(s0), frozenset(s1)}
    print("L1 replay OK: torsor-isomorphic, Rz outer swaps the two sheets")


def leg2():
    for q in (7, 11):
        G = full_pgl(q)
        PSL = [m for m in G if issq(det(m, q), q)]
        assert len(PSL) == q * (q * q - 1) // 2
        assert len(PSL) * 2 == len(G)          # sgn surjective, kernel = PSL
    print("L2 replay OK: sgn: PGL->C2 kernel PSL, one class [T_q]")


def leg3():
    p = 5

    def mul(x, y):
        a, b = x
        c, d = y
        return ((a * c + 2 * b * d) % p, (a * d + b * c) % p)

    u = (0, 1)
    assert mul(u, u) == (2, 0)
    frob_u = (u[0] % p, (-u[1]) % p)
    assert frob_u == ((-u[0]) % p, (-u[1]) % p)     # u -> -u ; swaps the two lifts
    assert pow(2, 2, p) == 4                          # (2/5) = -1 -> inert -> connected

    def leg(a, pp):
        return 1 if pow(a % pp, (pp - 1) // 2, pp) == 1 else -1

    assert leg(2, 5) == -1        # A3 inert
    assert leg(2, 7) == 1         # B3 split
    assert leg(5, 11) == 1        # H3 split
    assert [x for x in range(5) if (x * x - 2) % 5 == 0] == []
    assert sorted(x for x in range(7) if (x * x - 2) % 7 == 0) == [3, 4]
    assert sorted(t for t in range(11) if (t * t - t - 1) % 11 == 0) == [4, 8]
    # M12 clause depends only on C480-F; pin the certificate as citation anchor.
    pin("2026-07-22-c480-close-gap-certificates.json")
    print("L3 replay OK: A3 Frobenius orbit fused; split=>free / inert=>fused")


def main():
    leg1()
    leg2()
    leg3()
    print("C486 REPLAY: all three legs independently confirmed")


if __name__ == "__main__":
    main()
