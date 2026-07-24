#!/usr/bin/env python3
"""
Prints the exact projective weight-three syndrome-direction count of the
icosahedral six-arc at q=19 used by the Clebsch-family formula.

The paper's q=19 non-example is quoted from a counting bound (381 points - 15 secants
x 18 covered points each - 6 arc points >= 105), which is only a lower bound. This
script builds the arc and enumerates its extension locus directly. Since it is
nonempty, the covering radius is three and this is also the projective deep-hole
syndrome locus.

Construction (the q=11 Definition 2.1 recipe, transplanted):
  * conic C: XZ = Y^2 in PG(2,19), parametrized by [u:v] -> (u^2, uv, v^2);
  * an icosahedral A5 < PSL2(19) found as <a,b> with |a|=2, |b|=3, |ab|=5 (the (2,3,5)
    triangle presentation), verified to have order 60;
  * the six subgroups of order 5 in A5 give six 5-fold axes; the arc is their poles.

Note the arithmetic differs from q=11: there 5 | q-1, so an order-5 element splits and
fixes two RATIONAL conic points. At q=19, 5 | q+1, so order-5 elements lie in a
non-split torus and fix no rational point of the conic -- their two fixed points are a
conjugate pair over F_361. The chord joining that pair is still Galois-stable, hence a
rational line, so its pole is still a rational point of PG(2,19). The script verifies
this rather than assuming it: each order-5 element is checked to have exactly ONE
rational fixed point in PG(2,19) (the pole), and no fixed point on the conic.

Run: uv run python check_q19_nonexample.py    (no third-party deps)
"""

Q = 19


# --- PG(2,19) ---

def pg2_points():
    """Canonical reps of PG(2,19): first nonzero coordinate = 1. (381 points)"""
    pts = [(1, y, z) for y in range(Q) for z in range(Q)]
    pts += [(0, 1, z) for z in range(Q)]
    pts.append((0, 0, 1))
    return pts


PTS = pg2_points()
assert len(PTS) == Q * Q + Q + 1 == 381


def normalize(p):
    """Scale a projective point so its first nonzero coordinate is 1."""
    for c in p:
        if c % Q:
            inv = pow(c, Q - 2, Q)
            return tuple((inv * x) % Q for x in p)
    raise ValueError("zero vector is not a projective point")


def det3(a, b, c):
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % Q


def collinear(a, b, c):
    return det3(a, b, c) == 0


def is_arc(pts):
    n = len(pts)
    return not any(
        collinear(pts[i], pts[j], pts[k])
        for i in range(n)
        for j in range(i + 1, n)
        for k in range(j + 1, n)
    )


def on_conic(p):
    x, y, z = p
    return (x * z - y * y) % Q == 0


CONIC = [p for p in PTS if on_conic(p)]
assert len(CONIC) == Q + 1 == 20


# --- PGL2(19), and its Sym^2 action on PG(2,19) preserving XZ=Y^2 ---

def mat_mul(m, n):
    return tuple(
        tuple(sum(m[i][k] * n[k][j] for k in range(len(n))) % Q for j in range(len(n[0])))
        for i in range(len(m))
    )


def pgl2_normalize(m):
    """Scale a 2x2 matrix so its first nonzero entry (row-major) is 1."""
    flat = [m[0][0], m[0][1], m[1][0], m[1][1]]
    for c in flat:
        if c % Q:
            inv = pow(c, Q - 2, Q)
            return tuple(tuple((inv * x) % Q for x in row) for row in m)
    raise ValueError("zero matrix")


def pgl2_elements():
    els = []
    for a in range(Q):
        for b in range(Q):
            for c in range(Q):
                for d in range(Q):
                    if (a * d - b * c) % Q == 0:
                        continue
                    m = ((a, b), (c, d))
                    if pgl2_normalize(m) == m:
                        els.append(m)
    return els


ID2 = ((1, 0), (0, 1))


def pgl2_order(m):
    k, cur = 1, m
    while pgl2_normalize(cur) != ID2:
        cur = mat_mul(cur, m)
        k += 1
    return k


def is_square_det(m):
    """PSL2(19) = the index-2 subgroup of PGL2(19) whose det is a square."""
    d = (m[0][0] * m[1][1] - m[0][1] * m[1][0]) % Q
    return pow(d, (Q - 1) // 2, Q) == 1


def sym2(m):
    """The Sym^2 image of a 2x2 matrix: the induced PGL(3,19) map preserving XZ=Y^2."""
    (a, b), (c, d) = m
    return (
        (a * a % Q, 2 * a * b % Q, b * b % Q),
        (a * c % Q, (a * d + b * c) % Q, b * d % Q),
        (c * c % Q, 2 * c * d % Q, d * d % Q),
    )


def apply3(m3, p):
    return normalize(tuple(sum(m3[i][j] * p[j] for j in range(3)) % Q for i in range(3)))


def generate(gens):
    """Closure of <gens> in PGL2(19)."""
    seen = {pgl2_normalize(g) for g in gens}
    frontier = list(seen)
    while frontier:
        nxt = []
        for x in frontier:
            for g in gens:
                y = pgl2_normalize(mat_mul(x, g))
                if y not in seen:
                    seen.add(y)
                    nxt.append(y)
        frontier = nxt
    return seen


def find_a5():
    """Find <a,b> = A5 < PSL2(19) via the (2,3,5) triangle presentation."""
    els = pgl2_elements()
    assert len(els) == Q * (Q - 1) * (Q + 1) == 6840, len(els)
    psl = [m for m in els if is_square_det(m)]
    ord2 = [m for m in psl if pgl2_order(m) == 2]
    ord3 = [m for m in psl if pgl2_order(m) == 3]
    for a in ord2:
        for b in ord3:
            if pgl2_order(mat_mul(a, b)) != 5:
                continue
            grp = generate([a, b])
            if len(grp) == 60:
                return grp
    raise RuntimeError("no A5 found in PSL2(19)")


def fixed_points(m3):
    return [p for p in PTS if apply3(m3, p) == p]


def extension_locus(arc):
    covered = set(arc)
    n = len(arc)
    for i in range(n):
        for j in range(i + 1, n):
            covered.update(p for p in PTS if collinear(arc[i], arc[j], p))
    return [p for p in PTS if p not in covered]


def conic_containment_rank(pts):
    """Rank over F_19 of the quadratic-monomial evaluation matrix of `pts`.

    Rank < 6 means some nonzero quadratic form (degenerate or not) vanishes on all of
    `pts`, i.e. the set lies on a conic.
    """
    rows = [
        [x * x % Q, x * y % Q, x * z % Q, y * y % Q, y * z % Q, z * z % Q]
        for (x, y, z) in pts
    ]
    rank, col = 0, 0
    while rank < len(rows) and col < 6:
        piv = next((r for r in range(rank, len(rows)) if rows[r][col]), None)
        if piv is None:
            col += 1
            continue
        rows[rank], rows[piv] = rows[piv], rows[rank]
        inv = pow(rows[rank][col], Q - 2, Q)
        rows[rank] = [(v * inv) % Q for v in rows[rank]]
        for r in range(len(rows)):
            if r != rank and rows[r][col]:
                f = rows[r][col]
                rows[r] = [(rows[r][j] - f * rows[rank][j]) % Q for j in range(6)]
        rank += 1
        col += 1
    return rank


def main():
    print("=== The icosahedral six-arc at q=19 (Definition 2.1 recipe, transplanted) ===")
    a5 = find_a5()
    print(f"  found A5 < PSL2(19): |A5| = {len(a5)}")
    assert len(a5) == 60

    ord5 = [m for m in a5 if pgl2_order(m) == 5]
    print(f"  elements of order 5: {len(ord5)} (expected 24, in 6 cyclic subgroups)")
    assert len(ord5) == 24

    subgroups5 = {frozenset(generate([m])) for m in ord5}
    print(f"  subgroups of order 5 (the 5-fold axes): {len(subgroups5)}")
    assert len(subgroups5) == 6

    # Each axis contributes the unique rational fixed point of its Sym^2 image: the pole.
    poles = []
    for sub in subgroups5:
        g = next(m for m in sub if pgl2_normalize(m) != ID2)
        fix = fixed_points(sym2(g))
        on_c = [p for p in fix if on_conic(p)]
        assert len(fix) == 1, f"expected a unique rational fixed point, got {fix}"
        assert not on_c, f"order-5 element unexpectedly fixes a rational conic point: {on_c}"
        poles.append(fix[0])

    arc = sorted(set(poles))
    print(f"  poles of the six 5-fold axes: {arc}")
    print(f"  distinct poles: {len(arc)}")
    assert len(arc) == 6
    assert arc == [
        (1, 2, 2), (1, 4, 2), (1, 6, 5),
        (1, 7, 8), (1, 10, 16), (1, 16, 10),
    ]

    arc_ok = is_arc(arc)
    disjoint_from_conic = all(not on_conic(p) for p in arc)
    print(f"  is a six-arc (no 3 collinear): {arc_ok}")
    assert arc_ok
    print(f"  disjoint from the conic XZ=Y^2: {disjoint_from_conic}")
    assert disjoint_from_conic

    U = extension_locus(arc)
    print()
    print("=== Extension / projective weight-three syndrome locus ===")
    print(f"  |PG(2,19)| = {len(PTS)}, |conic| = {len(CONIC)}")
    print(f"  EXACT |U| = {len(U)}")
    print(f"  counting lower bound 381 - 6 - 15*18 = {381 - 6 - 15 * 18}")
    conic_intersection = sum(1 for p in U if on_conic(p))
    print(f"  |U n conic| = {conic_intersection}")
    rank = conic_containment_rank(U)
    print(f"  quadratic-monomial rank of U = {rank}/6 -> U lies on a conic: {rank < 6}")
    assert len(U) == 140
    assert conic_intersection == 20
    assert set(CONIC) <= set(U)
    assert len(set(U) - set(CONIC)) == 120
    assert rank == 6

    print()
    print("=== VERDICT ===")
    print(f"  At q=19 the icosahedral six-arc has exactly {len(U)} projective")
    print(f"  weight-three syndrome directions, versus the {Q + 1} points of any conic;")
    print("  U lies on no conic at all.")
    print("  The conic-filling phenomenon does not survive at q=19.")
    print("all assertions passed")


if __name__ == "__main__":
    main()
