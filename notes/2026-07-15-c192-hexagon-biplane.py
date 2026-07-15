#!/usr/bin/env python3
"""C192 — Do Edge's 22 Clebsch hexagons over a fixed conic in PG(2,11) carry the Paley biplane?

Cell: (Edge's 22 hexagons over a fixed conic, conic-incidence -> binary LDPC / design theory,
       "what code / design is this?")

NULL, declared before looking (method rule 3): the two systems of 11 meet in a generic 6-regular
bipartite graph with no name; the hexagon parity-check code is its [66,45]_2 cycle code; boring.

RESULT: the null is refuted. The 11x11 system-A-by-system-B incidence is a symmetric 2-(11,6,3)
design, verified isomorphic to the complement of the Paley biplane 2-(11,5,2), |Aut| = 660 =
|PSL(2,11)|.

Everything is fail-closed: each structural claim is asserted, so a regression aborts the run.
Run: python3 notes/2026-07-15-c192-hexagon-biplane.py     (stdlib only, no network, ~1 min)

Guard against this lane's own 759-numerology failure (novelty tables sec 4): parameter agreement is
NOT identity. The design property is checked directly (all 55 pairs, both ways) and the biplane
identification is by explicit isomorphism search, not by matching (v,k,lambda).

Robustness: the whole pipeline is run against TWO different conics. The block sets it produces are
label-dependent -- for y^2=xz they coincide with the Paley complement's on the nose, for
x^2+y^2+z^2 they do not -- but the design is isomorphic to the Paley complement either way. The
identity witness at y^2=xz is a labelling coincidence of the standard P^1(F_11) parametrization and
is NOT load-bearing for any claim here.
"""
from itertools import combinations, permutations

q = 11


def norm(p):
    for i in range(3):
        if p[i] % q:
            inv = pow(p[i], q - 2, q)
            return tuple((x * inv) % q for x in p)
    return None


def build():
    """Points of PG(2,11) as normalized reps; the same list doubles as the lines."""
    out, seen = [], set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                if (a, b, c) != (0, 0, 0):
                    t = norm((a, b, c))
                    if t not in seen:
                        seen.add(t)
                        out.append(t)
    return out


POINTS = build()
LINES = build()
inc = lambda p, l: (p[0] * l[0] + p[1] * l[1] + p[2] * l[2]) % q == 0
join = lambda a, b: norm(((a[1] * b[2] - a[2] * b[1]) % q,
                          (a[2] * b[0] - a[0] * b[2]) % q,
                          (a[0] * b[1] - a[1] * b[0]) % q))


def hexagons(Q):
    """The Clebsch hexagons over the conic Q=0: 6 external points, all 15 joins passant, an arc."""
    conic = [p for p in POINTS if Q(p) == 0]
    assert len(conic) == q + 1, f"conic must have {q+1} points, got {len(conic)}"
    lc = {l: sum(1 for p in conic if inc(p, l)) for l in LINES}
    ext = [p for p in POINTS if Q(p)
           and sum(1 for l in LINES if inc(p, l) and lc[l] == 1) == 2]
    internal = [p for p in POINTS if Q(p)
                and sum(1 for l in LINES if inc(p, l) and lc[l] == 1) == 0]
    assert len(ext) == 66 and len(internal) == 55, (len(ext), len(internal))

    n = len(ext)
    adj = [0] * n
    for i in range(n):
        for j in range(i + 1, n):
            if lc[join(ext[i], ext[j])] == 0:          # join is passant / skew to the conic
                adj[i] |= 1 << j
                adj[j] |= 1 << i

    cliques = []

    def rec(cur, cand):
        if len(cur) == 6:
            cliques.append(tuple(cur))
            return
        c = cand
        while c:
            v = (c & -c).bit_length() - 1
            c &= c - 1
            rec(cur + [v], c & adj[v])

    for v in range(n):
        rec([v], adj[v] & ~((1 << (v + 1)) - 1))

    hexes = [h for h in cliques
             if not any(inc(ext[c], join(ext[a], ext[b])) for a, b, c in combinations(h, 3))]
    return ext, hexes, adj


def systems(hexes):
    """The two systems of 11. H (hexagons adjacent iff they share a point) is bipartite; its
    parts ARE the systems, because within a system the hexagons are disjoint."""
    sets = [set(h) for h in hexes]
    m = len(hexes)
    H = [[j for j in range(m) if j != i and sets[i] & sets[j]] for i in range(m)]
    assert all(len(H[i]) == 6 for i in range(m)), "H must be 6-regular"
    col = [-1] * m
    col[0] = 0
    st = [0]
    while st:
        u = st.pop()
        for w in H[u]:
            if col[w] == -1:
                col[w] = 1 - col[u]
                st.append(w)
            else:
                assert col[w] != col[u], "H must be bipartite"
    assert -1 not in col, "H must be connected"
    A = [i for i in range(m) if col[i] == 0]
    B = [i for i in range(m) if col[i] == 1]
    return sets, A, B


def paley_complement():
    """Blocks of the 2-(11,6,3) design complementary to the Paley biplane 2-(11,5,2)."""
    QR = sorted({(i * i) % q for i in range(1, q)})
    assert QR == [1, 3, 4, 5, 9], QR
    biplane = [frozenset((r + i) % q for r in QR) for i in range(q)]
    return [frozenset(set(range(q)) - b) for b in biplane], biplane


def isomorphisms(Da, Db, first_only):
    """Bijections pi of the point set with {pi(B) : B in Da} == set(Db). Anchored on Da[0], so the
    cost is 11 * 6! * 5! rather than 11!."""
    Sb = set(Db)
    out = []
    B0 = sorted(Da[0])
    r0 = sorted(set(range(q)) - set(B0))
    for T in Db:
        for pb in permutations(sorted(T)):
            for pr in permutations(sorted(set(range(q)) - T)):
                pi = {}
                for x, y in zip(B0, pb):
                    pi[x] = y
                for x, y in zip(r0, pr):
                    pi[x] = y
                if all(frozenset(pi[x] for x in b) in Sb for b in Da):
                    out.append(tuple(pi[i] for i in range(q)))
                    if first_only:
                        return out
    return out


def lambdas(M, rows):
    rng = range(len(M)) if rows else range(len(M[0]))
    get = (lambda i, j: M[i][j]) if rows else (lambda i, j: M[j][i])
    other = range(len(M[0])) if rows else range(len(M))
    return {sum(get(i1, k) * get(i2, k) for k in other) for i1, i2 in combinations(rng, 2)}


def run(Q, label, D2):
    print(f"\n=== {label} ===")
    ext, hexes, _ = hexagons(Q)
    assert len(hexes) == 22, f"expected 22 Clebsch hexagons, got {len(hexes)}"
    print(f"  external points 66, internal 55, Clebsch hexagons {len(hexes)}")

    mult = {v: sum(1 for h in hexes if v in h) for v in range(len(ext))}
    assert set(mult.values()) == {2}, "each external point must lie on exactly 2 hexagons"
    print("  every external point lies on exactly 2 hexagons  [Edge 1956]")

    sets, A, B = systems(hexes)
    assert len(A) == len(B) == 11
    for nm, S in (("A", A), ("B", B)):
        cov = [v for i in S for v in hexes[i]]
        assert sorted(cov) == list(range(66)), f"system {nm} must partition the 66"
    print("  two systems of 11, each partitioning the 66 external points  [Edge 1956]")

    M = [[len(sets[i] & sets[j]) for j in B] for i in A]
    assert all(x in (0, 1) for r in M for x in r), "incidence must be 0/1, not a multigraph"
    assert {sum(r) for r in M} == {6}, "row sums must be 6"
    assert {sum(M[i][j] for i in range(11)) for j in range(11)} == {6}, "col sums must be 6"
    assert lambdas(M, True) == {3} and lambdas(M, False) == {3}, "must be 2-(11,6,3)"
    print("  11x11 incidence: 0/1, row/col sums 6, lambda=3 on all 55 pairs BOTH ways")
    print("  -> a symmetric 2-(11,6,3) design (property verified, not parameter-matched)")

    D1 = [frozenset(i for i, ai in enumerate(A) if sets[ai] & sets[bj]) for bj in B]
    w = isomorphisms(D1, D2, first_only=True)
    assert w, "must be isomorphic to the Paley biplane complement"
    print(f"  isomorphic to the Paley-biplane complement: YES, witness {w[0]}")
    print(f"  block sets coincide on the nose: {set(D1) == set(D2)}   (labelling artifact; not a claim)")

    aut = isomorphisms(D1, D1, first_only=False)
    assert len(aut) == 660, f"|Aut| should be 660, got {len(aut)}"
    print(f"  |Aut| = {len(aut)} = |PSL(2,11)|")

    rows = []
    for h in hexes:
        r = 0
        for v in h:
            r |= 1 << v
        rows.append(r)
    basis, rank = [], 0
    for r in rows:
        cur = r
        for b in basis:
            cur = min(cur, cur ^ b)
        if cur:
            basis.append(cur)
            basis.sort(reverse=True)
            rank += 1
    assert rank == 21, rank
    print(f"  F2 rank of the 22x66 hexagon parity-check matrix: {rank}")
    print(f"  -> null-space code [66, {66 - rank}]_2, the cycle code of the design's incidence graph")
    return D1


def main():
    D2, biplane = paley_complement()
    print(f"Paley biplane 2-(11,5,2): {len(biplane)} blocks of size 5")
    print(f"its complement 2-(11,6,3): {len(D2)} blocks of size 6")
    run(lambda p: (p[1] * p[1] - p[0] * p[2]) % q, "conic y^2 = xz", D2)
    run(lambda p: (p[0] * p[0] + p[1] * p[1] + p[2] * p[2]) % q, "conic x^2 + y^2 + z^2", D2)
    print("\nAll assertions passed against both conics.")


if __name__ == "__main__":
    main()
