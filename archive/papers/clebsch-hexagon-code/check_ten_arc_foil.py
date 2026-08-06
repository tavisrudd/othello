#!/usr/bin/env python3
"""
Companion run 3 (Section 8): Storme-Van Maldeghem's other A5-orbit at q=11
(Prop.11), a 10-arc with EMPTY extension/weight-three syndrome locus --
the clean foil to the Clebsch hexagon's exact 12-point conic phenomenon.

Method: rather than re-derive Dye/SVM's explicit icosahedral coordinates for the
second orbit, this script computes the arc stabilizer Stab(A) < PGL(3,11) of the
Clebsch hexagon A directly (60 explicit 3x3 matrices, verified order 60 = A5), then
lets that SAME concrete A5 act on every point of PG(2,11) and looks at the resulting
orbits. A5 has a natural action on 10 objects (the icosahedron's ten 3-fold/face
axes, i.e. its ten antipodal face-center chords, complementing the six 5-fold/vertex
axes already used for the hexagon); a size-10 orbit under this A5 is exactly the
face-axis-pole arc, i.e. SVM's second A5-orbit.

Run: uv run python check_ten_arc_foil.py    (no third-party deps)
"""

from itertools import permutations

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

def is_arc(pts):
    n = len(pts)
    for i in range(n):
        for j in range(i + 1, n):
            for k in range(j + 1, n):
                if collinear(pts[i], pts[j], pts[k]):
                    return False
    return True

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

# ---- 3x3 linear algebra over F_11 ----

def mat_vec(M, v):
    return tuple(sum(M[i][j] * v[j] for j in range(3)) % P for i in range(3))

def mat_mul(M, N):
    return [[sum(M[i][k] * N[k][j] for k in range(3)) % P for j in range(3)] for i in range(3)]

def mat_det(M):
    return (
        M[0][0] * (M[1][1] * M[2][2] - M[1][2] * M[2][1])
        - M[0][1] * (M[1][0] * M[2][2] - M[1][2] * M[2][0])
        + M[0][2] * (M[1][0] * M[2][1] - M[1][1] * M[2][0])
    ) % P

def mat_inv(M):
    d = mat_det(M)
    dinv = pow(d, P - 2, P)
    a, b, c = M[0]
    dd, e, f = M[1]
    g, h, i = M[2]
    cof = [
        [(e * i - f * h) % P, (c * h - b * i) % P, (b * f - c * e) % P],
        [(f * g - dd * i) % P, (a * i - c * g) % P, (c * dd - a * f) % P],
        [(dd * h - e * g) % P, (b * g - a * h) % P, (a * e - b * dd) % P],
    ]
    return [[(cof[i][j] * dinv) % P for j in range(3)] for i in range(3)]

def solve_lambdas(p1, p2, p3, p4):
    """Solve lambda1*p1+lambda2*p2+lambda3*p3 = p4 (as columns)."""
    Mcols = [p1, p2, p3]
    M = [[Mcols[j][i] for j in range(3)] for i in range(3)]  # rows
    Minv = mat_inv(M)
    return mat_vec(Minv, p4)

def frame_transform(target4):
    p1, p2, p3, p4 = target4
    l1, l2, l3 = solve_lambdas(p1, p2, p3, p4)
    col1 = tuple((l1 * x) % P for x in p1)
    col2 = tuple((l2 * x) % P for x in p2)
    col3 = tuple((l3 * x) % P for x in p3)
    # matrix with these as columns -> rows
    return [[col1[i], col2[i], col3[i]] for i in range(3)]

def canon_mat(M):
    flat = [M[i][j] for i in range(3) for j in range(3)]
    for x in flat:
        if x % P != 0:
            inv = pow(x, P - 2, P)
            flat = [(c * inv) % P for c in flat]
            break
    return tuple(flat)

def apply_mat(flatmat, v):
    M = [[flatmat[0], flatmat[1], flatmat[2]],
         [flatmat[3], flatmat[4], flatmat[5]],
         [flatmat[6], flatmat[7], flatmat[8]]]
    return canon(mat_vec(M, v))

def main():
    A = [(1, 10, 0), (1, 9, 1), (1, 4, 7), (1, 8, 5), (0, 1, 4), (1, 1, 7)]
    A_set = set(A)

    ref = A[:4]
    T_ref = frame_transform(ref)
    T_ref_inv = mat_inv(T_ref)

    stab = set()
    for quad in permutations(A, 4):
        T_x = frame_transform(quad)
        g = mat_mul(T_x, T_ref_inv)
        gflat = [g[i][j] for i in range(3) for j in range(3)]
        gA = set(apply_mat(gflat, p) for p in A)
        if gA == A_set:
            stab.add(canon_mat(g))

    print(f"|Stab(A)| in PGL(3,11) = {len(stab)} (expect 60 = |A5|)")
    assert len(stab) == 60

    # Orbits of Stab(A) acting on all 133 points of PG(2,11).
    remaining = set(PTS)
    orbits = []
    while remaining:
        p = min(remaining)
        orb = set(apply_mat(g, p) for g in stab)
        orbits.append(orb)
        remaining -= orb

    sizes = sorted(len(o) for o in orbits)
    print(f"orbit sizes of Stab(A)=A5 on PG(2,11) (133 points): {sizes}")
    assert sizes == [6, 10, 12, 15, 30, 30, 30]

    standard_conic = {p for p in PTS if (p[0] * p[2] - p[1] * p[1]) % P == 0}
    assert len(standard_conic) == 12
    assert any(orb == A_set for orb in orbits)
    assert any(orb == standard_conic for orb in orbits)

    ten_orbits = [o for o in orbits if len(o) == 10]
    print(f"number of size-10 orbits: {len(ten_orbits)}")
    assert len(ten_orbits) == 1

    expected_ten_arc = {
        (1, 0, 3), (1, 0, 9), (1, 3, 3), (1, 3, 7), (1, 5, 4),
        (1, 5, 7), (1, 6, 4), (1, 6, 6), (1, 7, 9), (1, 7, 10),
    }
    assert ten_orbits[0] == expected_ten_arc
    assert is_arc(sorted(ten_orbits[0]))
    assert ten_orbits[0].isdisjoint(standard_conic)
    assert extension_locus(sorted(ten_orbits[0])) == []

    def on_standard_conic(p):
        x, y, z = p
        return (x * z - y * y) % P == 0

    for idx, orb in enumerate(ten_orbits):
        pts = sorted(orb)
        print(f"\n--- size-10 orbit #{idx} ---")
        print(f"  points: {pts}")
        arc_ok = is_arc(pts)
        print(f"  is a 10-arc (no 3 collinear): {arc_ok}")
        on_c = [p for p in pts if on_standard_conic(p)]
        print(f"  points on the standard conic XZ=Y^2: {len(on_c)} of 10")
        if arc_ok:
            U = extension_locus(pts)
            print(f"  extension/weight-three syndrome locus size |U| = {len(U)}")
            if U:
                print(f"    U = {U}")

    print("\n=== VERDICT ===")
    if not ten_orbits:
        print("  No size-10 orbit of this A5 exists on PG(2,11); SVM's second orbit is not")
        print("  realized by the SAME concrete A5 (stabilizer of the hexagon) acting on the")
        print("  ambient plane in this way -- reporting as an open discrepancy, not forcing a match.")
    else:
        clean = [o for o in ten_orbits if is_arc(sorted(o)) and len(extension_locus(sorted(o))) == 0]
        if clean:
            print(f"  Found {len(clean)} size-10 A5-orbit(s) that ARE ten-arcs with EMPTY")
            print("  extension locus: a clean complete-arc foil, confirming SVM's Prop.11")
            print("  companion result (covering radius 2; deep holes have distance 2).")
        else:
            print("  Size-10 orbit(s) exist but are not both a clean arc and complete; reporting")
            print("  the per-orbit data above rather than forcing the foil claim.")
    print("all assertions passed")

if __name__ == "__main__":
    main()
