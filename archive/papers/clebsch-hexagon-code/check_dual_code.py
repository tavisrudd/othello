#!/usr/bin/env python3
"""
Companion run 1 (Section 8): the projective syndrome geometry of the DUAL
[6,3]_11 code.

The primal code C has parity-check matrix H (3x6, columns = the Clebsch hexagon A).
Its dual code C^perp has, as ITS OWN parity-check matrix, any generator matrix G of C
(3x6, since dim C = dim C^perp = 3 here). Reading the 6 columns of G as points of
PG(2,11) gives the "dual arc" B associated with C^perp; the same arc--coset
dictionary applies to B exactly as it does to A. This script builds G from H by exact
nullspace computation, reads off B, and computes B's extension locus. Since the
locus is nonempty, it is also the projective deep-hole syndrome locus.

Run: uv run python check_dual_code.py    (no third-party deps)
"""

P = 11

def points():
    pts = []
    for y in range(P):
        for z in range(P):
            pts.append((1, y, z))
    for z in range(P):
        pts.append((0, 1, z))
    pts.append((0, 0, 1))
    return pts

PTS = points()
assert len(PTS) == 133

def det3(a, b, c):
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    ) % P

def collinear(a, b, c):
    return det3(a, b, c) == 0

def canon(v):
    for x in v:
        if x % P != 0:
            inv = pow(x, P - 2, P)
            return tuple((c * inv) % P for c in v)
    return tuple(v)

def rref_nullspace(rows, ncols):
    """Return a basis of the right nullspace of the (nrows x ncols) matrix `rows` over F_P."""
    M = [list(r) for r in rows]
    nrows = len(M)
    where = [-1] * ncols
    rank = 0
    for col in range(ncols):
        piv = None
        for r in range(rank, nrows):
            if M[r][col] % P != 0:
                piv = r
                break
        if piv is None:
            continue
        M[rank], M[piv] = M[piv], M[rank]
        inv = pow(M[rank][col], P - 2, P)
        M[rank] = [(v * inv) % P for v in M[rank]]
        for r in range(nrows):
            if r != rank and M[r][col] % P != 0:
                f = M[r][col]
                M[r] = [(M[r][k] - f * M[rank][k]) % P for k in range(ncols)]
        where[col] = rank
        rank += 1
        if rank == nrows:
            break
    free_cols = [c for c in range(ncols) if where[c] == -1]
    basis = []
    for free in free_cols:
        v = [0] * ncols
        v[free] = 1
        for c in range(ncols):
            if where[c] != -1:
                v[c] = (-M[where[c]][free]) % P
        basis.append(v)
    return basis, rank

def line_points(a, b):
    return [p for p in PTS if collinear(a, b, p)]

def extension_locus(arc):
    covered = set(map(tuple, arc))
    n = len(arc)
    for i in range(n):
        for j in range(i + 1, n):
            for p in line_points(arc[i], arc[j]):
                covered.add(tuple(p))
    return [p for p in PTS if tuple(p) not in covered]

def is_arc(pts):
    n = len(pts)
    for i in range(n):
        for j in range(i + 1, n):
            for k in range(j + 1, n):
                if collinear(pts[i], pts[j], pts[k]):
                    return False
    return True

def monomial(p):
    x, y, z = p
    return [(x * x) % P, (x * y) % P, (x * z) % P, (y * y) % P, (y * z) % P, (z * z) % P]

def rank_mod_p(rows, ncols):
    M = [list(r) for r in rows]
    rank = 0
    nrows = len(M)
    for col in range(ncols):
        piv = None
        for r in range(rank, nrows):
            if M[r][col] % P != 0:
                piv = r
                break
        if piv is None:
            continue
        M[rank], M[piv] = M[piv], M[rank]
        inv = pow(M[rank][col], P - 2, P)
        M[rank] = [(v * inv) % P for v in M[rank]]
        for r in range(nrows):
            if r != rank and M[r][col] % P != 0:
                f = M[r][col]
                M[r] = [(M[r][k] - f * M[rank][k]) % P for k in range(ncols)]
        rank += 1
        if rank == nrows:
            break
    return rank

def kernel_vec(rows, ncols):
    M = [list(r) for r in rows]
    nrows = len(M)
    where = [-1] * ncols
    rank = 0
    for col in range(ncols):
        piv = None
        for r in range(rank, nrows):
            if M[r][col] % P != 0:
                piv = r
                break
        if piv is None:
            continue
        M[rank], M[piv] = M[piv], M[rank]
        inv = pow(M[rank][col], P - 2, P)
        M[rank] = [(v * inv) % P for v in M[rank]]
        for r in range(nrows):
            if r != rank and M[r][col] % P != 0:
                f = M[r][col]
                M[r] = [(M[r][k] - f * M[rank][k]) % P for k in range(ncols)]
        where[col] = rank
        rank += 1
    if rank == ncols:
        return None
    free = next(c for c in range(ncols) if where[c] == -1)
    x = [0] * ncols
    x[free] = 1
    for c in range(ncols):
        if where[c] != -1:
            x[c] = (-M[where[c]][free]) % P
    return x

def main():
    # H = the 3x6 parity-check matrix of the primal code C (its columns are the six
    # Clebsch-hexagon arc points, Section 2's explicit representative).
    A = [(1, 10, 0), (1, 9, 1), (1, 4, 7), (1, 8, 5), (0, 1, 4), (1, 1, 7)]
    H = [[A[j][i] for j in range(6)] for i in range(3)]   # 3 rows (x,y,z), 6 columns

    basis, rank = rref_nullspace(H, 6)
    print(f"rank(H) = {rank} (expect 3, confirming H has full row rank)")
    print(f"nullspace dimension = {len(basis)} (expect 3 = dim C)")
    assert rank == 3 and len(basis) == 3

    G = basis  # 3x6 generator matrix of C; also serves as parity-check matrix of C^perp
    # Sanity: H . G^T = 0
    for row_h in H:
        for row_g in G:
            s = sum(row_h[k] * row_g[k] for k in range(6)) % P
            assert s == 0
    print("sanity check H . G^T = 0: OK")

    # Dual arc B = columns of G, canonicalized to PG(2,11) representatives.
    B = [canon(tuple(G[i][j] for i in range(3))) for j in range(6)]
    print(f"\ndual arc B (columns of G, canonical reps): {B}")
    assert B == [
        (1, 5, 5), (1, 4, 9), (1, 9, 3),
        (1, 0, 0), (0, 1, 0), (0, 0, 1),
    ]

    distinct = len(set(B))
    print(f"distinct points: {distinct} / 6")
    assert distinct == 6

    arc_ok = is_arc(B)
    print(f"B is a six-arc (no 3 collinear): {arc_ok}")
    assert arc_ok

    def on_standard_conic(p):
        x, y, z = p
        return (x * z - y * y) % P == 0

    on_C = [p for p in B if on_standard_conic(p)]
    print(f"points of B lying on the primal conic XZ=Y^2: {len(on_C)} of 6 -> {on_C}")
    assert on_C == [(1, 0, 0), (0, 0, 1)]

    if arc_ok:
        U = extension_locus(B)
        print(f"\nextension/projective deep-hole syndrome locus U(B): |U(B)| = {len(U)}")
        assert len(U) == 12

        # Does U(B) lie on some conic (possibly degenerate)?
        M = [monomial(u) for u in U]
        conic_rank = rank_mod_p(M, 6)
        contained = conic_rank < 6 if U else None
        print(f"U(B) lies on some conic (degenerate allowed): {contained}")
        assert conic_rank == 5
        assert contained
        if U and contained:
            cvec = kernel_vec(M, 6)
            print(f"  quadratic form coefficients (a,b,c,d,e,f) for aX^2+bXY+cXZ+dY^2+eYZ+fZ^2: {cvec}")
            assert cvec == [4, 7, 10, 5, 2, 1]
            on_that_conic = [p for p in PTS
                              if sum(monomial(p)[t] * cvec[t] for t in range(6)) % P == 0]
            print(f"  full F_11-point count of that conic: {len(on_that_conic)}")
            assert len(on_that_conic) == 12
            assert set(U) == set(on_that_conic)
            same_as_std = on_standard_conic
            matches_std_conic = set(on_that_conic) == set(p for p in PTS if same_as_std(p))
            print(f"  identical (as a point set) to the standard conic XZ=Y^2: {matches_std_conic}")
            assert not matches_std_conic

            half = pow(2, P - 2, P)
            a, b, c, d, e, f = cvec
            sym = [
                [a, (b * half) % P, (c * half) % P],
                [(b * half) % P, d, (e * half) % P],
                [(c * half) % P, (e * half) % P, f],
            ]
            det_sym = (
                sym[0][0] * (sym[1][1] * sym[2][2] - sym[1][2] * sym[2][1])
                - sym[0][1] * (sym[1][0] * sym[2][2] - sym[1][2] * sym[2][0])
                + sym[0][2] * (sym[1][0] * sym[2][1] - sym[1][1] * sym[2][0])
            ) % P
            print(f"  conic nonsingular (det of symmetric 3x3 form != 0): {det_sym != 0}")
            assert det_sym != 0
    else:
        print("\nB is NOT an arc (some three columns of G are collinear) -- the dual code's")
        print("parity-check description degenerates; the syndrome/arc dictionary as stated")
        print("for six-arcs does not apply directly to B in this form.")

    print("\n=== VERDICT ===")
    if arc_ok:
        print("  The dual [6,3,4]_11 code's arc B is a genuine six-arc; its")
        print(f"  projective deep-hole syndrome locus has size {len(U)}.")
        if len(U) == 12 and contained:
            print("  |U(B)|=12 and U(B) lies on a nonsingular conic: by the rigidity theorem")
            print("  (Section 4), |U|=12 together with conic containment happens for exactly")
            print("  one PGL(3,11)-orbit of six-arcs -- the Clebsch-hexagon class. So B is")
            print("  itself PGL(3,11)-equivalent to the primal arc A: the dual code of the")
            print("  Clebsch hexagon code is again a Clebsch hexagon code (for a different")
            print("  conic than the fixed standard one), not a structurally new arc.")
    else:
        print("  The dual arc is degenerate (collinear triple); reporting as-is, no forced claim.")
    print("all assertions passed")

if __name__ == "__main__":
    main()
