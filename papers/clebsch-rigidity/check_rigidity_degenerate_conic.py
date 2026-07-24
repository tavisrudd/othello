#!/usr/bin/env python3
"""
Audits the degenerate-conic boundary of the rigidity theorem and independently
recomputes the |U| extension-count histogram of PG(2,11) six-arcs.

Condition (i) of the TFAE allows a DEGENERATE conic (line-pair / double line).
The exact replay verifies that:
  - the ONLY 6-arcs whose extension locus U lies on ANY conic (degenerate
    allowed) are the Clebsch class (|U| = 12), and
  - for that class the conic is NONDEGENERATE and U is exactly its 12 points,
    i.e. no 6-arc has U supported on a degenerate conic only.

Enumeration: every 6-arc has an ordered 4-subset in general position; the
unique PGL(3,11) mapping it to the standard frame (e1,e2,e3,e4=(1,1,1)) sends
the other two points to (p5,p6). Sweeping (p5,p6) over all legal completions
therefore meets every projective class of 6-arc.  The resulting 1548 point
sets are frame-normalized representatives, NOT 1548 projective classes: one
PGL class generally occurs through several choices of ordered frame.
"Conic through U" is decided by the rank over F_11 of the |U| x 6
quadratic-monomial evaluation matrix.

Run: uv run python check_rigidity_degenerate_conic.py    (no third-party deps)
"""

P = 11

EXPECTED_U_HISTOGRAM = {
    12: 6, 16: 30, 18: 150, 19: 300, 20: 630, 21: 360, 22: 72,
}
EXPECTED_CONCYCLIC_U_HISTOGRAM = {18: 30, 19: 60, 20: 90, 22: 72}

def points():
    """Canonical reps of PG(2,11): first nonzero coordinate = 1. (133 points)"""
    pts = []
    for z in range(P):
        for y in range(P):
            pts.append((1, y, z))            # x = 1
    for z in range(P):
        pts.append((0, 1, z))                # x = 0, y = 1
    pts.append((0, 0, 1))                    # x = 0, y = 0, z = 1
    return pts

PTS = points()
assert len(PTS) == 133

def det3(a, b, c):
    return (
        a[0]*(b[1]*c[2]-b[2]*c[1])
        - a[1]*(b[0]*c[2]-b[2]*c[0])
        + a[2]*(b[0]*c[1]-b[1]*c[0])
    ) % P

def collinear(a, b, c):
    return det3(a, b, c) == 0

def rank_mod_p(rows, ncols):
    """Row-rank over F_p of a list of length-ncols rows."""
    M = [list(r) for r in rows]
    rank = 0
    col = 0
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
        inv = pow(M[rank][col], P-2, P)
        M[rank] = [(v*inv) % P for v in M[rank]]
        for r in range(nrows):
            if r != rank and M[r][col] % P != 0:
                f = M[r][col]
                M[r] = [(M[r][k]-f*M[rank][k]) % P for k in range(ncols)]
        rank += 1
        if rank == nrows:
            break
    return rank

def kernel_vec(rows, ncols):
    """Return one nonzero kernel vector of the (nrows x ncols) matrix, or None."""
    M = [list(r) for r in rows]
    nrows = len(M)
    where = [-1]*ncols
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
        inv = pow(M[rank][col], P-2, P)
        M[rank] = [(v*inv) % P for v in M[rank]]
        for r in range(nrows):
            if r != rank and M[r][col] % P != 0:
                f = M[r][col]
                M[r] = [(M[r][k]-f*M[rank][k]) % P for k in range(ncols)]
        where[col] = rank
        rank += 1
    if rank == ncols:
        return None  # trivial kernel
    # free column
    free = next(c for c in range(ncols) if where[c] == -1)
    x = [0]*ncols
    x[free] = 1
    for c in range(ncols):
        if where[c] != -1:
            x[c] = (-M[where[c]][free]) % P
    return x

def monomial(p):
    x, y, z = p
    return [ (x*x)%P, (x*y)%P, (x*z)%P, (y*y)%P, (y*z)%P, (z*z)%P ]

def conic_matrix_of_coeffs(c):
    # Q = a x^2 + b xy + c xz + d y^2 + e yz + f z^2  ->  symmetric 3x3 (2 invertible mod 11)
    a, b, cc, d, e, f = c
    half = pow(2, P-2, P)
    return [
        [a,            (b*half)%P,  (cc*half)%P],
        [(b*half)%P,   d,           (e*half)%P ],
        [(cc*half)%P,  (e*half)%P,  f          ],
    ]

def det3x3(M):
    return (
        M[0][0]*(M[1][1]*M[2][2]-M[1][2]*M[2][1])
        - M[0][1]*(M[1][0]*M[2][2]-M[1][2]*M[2][0])
        + M[0][2]*(M[1][0]*M[2][1]-M[1][1]*M[2][0])
    ) % P

FRAME = [(1,0,0),(0,1,0),(0,0,1),(1,1,1)]

def line_points(a, b):
    return [r for r in PTS if collinear(a, b, r)]

def is_six_arc(pts6):
    n = len(pts6)
    for i in range(n):
        for j in range(i+1, n):
            for k in range(j+1, n):
                if collinear(pts6[i], pts6[j], pts6[k]):
                    return False
    return True

def extension_locus(arc):
    covered = set(map(tuple, arc))
    for i in range(6):
        for j in range(i+1, 6):
            for r in line_points(arc[i], arc[j]):
                covered.add(tuple(r))
    return [p for p in PTS if tuple(p) not in covered]

def main():
    from collections import Counter
    hist = Counter()
    # (arc, |U|, evaluation rank, degenerate?, U==full conic?, conic size)
    u_conic = []
    concyclic_hist = Counter()
    concyclic_degenerate = 0
    seen = set()
    frameset = set(map(tuple, FRAME))

    for p5 in PTS:
        if tuple(p5) in frameset:
            continue
        for p6 in PTS:
            if tuple(p6) in frameset or p6 == p5:
                continue
            arc = FRAME + [p5, p6]
            key = frozenset(map(tuple, arc))
            if key in seen:
                continue
            if not is_six_arc(arc):
                continue
            seen.add(key)
            U = extension_locus(arc)
            hist[len(U)] += 1
            M = [monomial(u) for u in U]
            rank_u = rank_mod_p(M, 6)
            if rank_u < 6:          # some conic (degenerate allowed) contains U
                cvec = kernel_vec(M, 6)
                sym = conic_matrix_of_coeffs(cvec)
                degenerate = (det3x3(sym) % P == 0)
                # does U equal the full F_11 point set of that conic?
                on_conic = [p for p in PTS
                            if sum(monomial(p)[t]*cvec[t] for t in range(6)) % P == 0]
                u_conic.append((
                    arc, len(U), rank_u, degenerate,
                    set(map(tuple,U)) == set(map(tuple,on_conic)), len(on_conic),
                ))

            # This is a distinct condition: the six vertices of A, rather
            # than its extension locus U(A), lie on a conic.  A six-arc cannot
            # lie on a line-pair or double line (each line contains at most two
            # arc vertices), and the exact rank/determinant checks below make
            # that geometric observation durable.
            arc_matrix = [monomial(point) for point in arc]
            arc_rank = rank_mod_p(arc_matrix, 6)
            if arc_rank < 6:
                arc_conic = kernel_vec(arc_matrix, 6)
                arc_degenerate = (
                    det3x3(conic_matrix_of_coeffs(arc_conic)) % P == 0
                )
                assert arc_rank == 5       # unique projective conic
                concyclic_degenerate += int(arc_degenerate)
                concyclic_hist[len(U)] += 1

    assert len(seen) == 1548
    assert sum(hist.values()) == 1548
    assert hist == Counter(EXPECTED_U_HISTOGRAM)

    # Exactly six normalized representatives have U contained in any
    # quadratic.  Rank five makes that containing conic unique; its determinant
    # is nonzero and its full 12-point locus is exactly U.
    assert len(u_conic) == 6
    assert all(record[1] == 12 for record in u_conic)
    assert all(record[2] == 5 for record in u_conic)
    assert all(not record[3] for record in u_conic)
    assert all(record[4] and record[5] == 12 for record in u_conic)

    assert sum(concyclic_hist.values()) == 252
    assert concyclic_hist == Counter(EXPECTED_CONCYCLIC_U_HISTOGRAM)
    assert concyclic_degenerate == 0

    print("enumeration_unit=frame-normalized_representatives_not_classes")
    print(f"normalized_representatives={sum(hist.values())}")
    print(f"U_histogram={dict(sorted(hist.items()))}")
    print(f"U_on_any_conic_representatives={len(u_conic)}")
    print("U_containing_conic_ranks={5: 6}")
    print("U_degenerate_containing_conics=0")
    print("U_full_nonsingular_conic_representatives=6")
    print(f"concyclic_normalized_representatives={sum(concyclic_hist.values())}")
    print(f"concyclic_U_histogram={dict(sorted(concyclic_hist.items()))}")
    print(f"concyclic_U_size_spectrum={sorted(concyclic_hist)}")
    print(f"concyclic_degenerate_conics={concyclic_degenerate}")
    print("all assertions passed")

if __name__ == "__main__":
    main()
