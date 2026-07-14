#!/usr/bin/env python3
"""
Closes the q=9 exclusion step of the "why q=11" counting lemma (Section 6).

q=9=3^2 passes the icosahedral-rationality filter (9 = -1 mod 10), so the counting
bound q<=14 alone does not exclude it; SVM 1995 Prop.13 records, by computer search,
that the analogous A5-invariant six-arc at q=9 is COMPLETE (unlike at q=11), so its
deep-hole locus is empty and the phenomenon is vacuous there. This script verifies
that completeness independently, using the q=9 witness arc already frozen in the Lean
formalization (RelativeConicArcs/Examples.lean: q9Witness), over the GF9 field whose
add/mul/inv tables are the ones certified in RelativeConicArcs/FiniteFields.lean
(elements encoded as n = x + 3y in {0,...,8}, representing x + y*alpha with alpha^2=2).

Run: uv run python check_q9_exclusion.py    (no third-party deps)
"""

# --- GF9 arithmetic, verbatim encoding from FiniteFields.lean (GF9.ofNat/encode/mul/inv) ---

def gf9_ofnat(n):
    return n % 9

def gf9_encode(x, y):
    return gf9_ofnat((x % 3) + 3 * (y % 3))

def gf9_add(a, b):
    return gf9_encode(a % 3 + b % 3, a // 3 + b // 3)

def gf9_neg(a):
    return gf9_encode(3 - a % 3, 3 - a // 3)

def gf9_sub(a, b):
    return gf9_add(a, gf9_neg(b))

def gf9_mul(a, b):
    return gf9_encode(
        (a % 3) * (b % 3) + 2 * ((a // 3) * (b // 3)),
        (a % 3) * (b // 3) + (a // 3) * (b % 3),
    )

GF9_INV = [0, 1, 2, 6, 5, 4, 3, 8, 7]  # matches FiniteFields.lean GF9.inv table

def gf9_inv(a):
    return GF9_INV[a]

ZERO, ONE = 0, 1

def gf9_points():
    """Canonical reps of PG(2,9): first nonzero coordinate = 1. (91 points)"""
    pts = []
    for y in range(9):
        for z in range(9):
            pts.append((ONE, y, z))          # x = 1
    for z in range(9):
        pts.append((ZERO, ONE, z))            # x = 0, y = 1
    pts.append((ZERO, ZERO, ONE))              # x = 0, y = 0, z = 1
    return pts

PTS = gf9_points()
assert len(PTS) == 91

def det3(a, b, c):
    t1 = gf9_mul(a[0], gf9_sub(gf9_mul(b[1], c[2]), gf9_mul(b[2], c[1])))
    t2 = gf9_mul(a[1], gf9_sub(gf9_mul(b[0], c[2]), gf9_mul(b[2], c[0])))
    t3 = gf9_mul(a[2], gf9_sub(gf9_mul(b[0], c[1]), gf9_mul(b[1], c[0])))
    return gf9_sub(gf9_add(t1, t3), t2)

def collinear(a, b, c):
    return det3(a, b, c) == 0

def is_six_arc(pts6):
    n = len(pts6)
    for i in range(n):
        for j in range(i + 1, n):
            for k in range(j + 1, n):
                if collinear(pts6[i], pts6[j], pts6[k]):
                    return False
    return True

def line_points(a, b):
    return [p for p in PTS if collinear(a, b, p)]

def deep_hole_locus(arc):
    covered = set(map(tuple, arc))
    n = len(arc)
    for i in range(n):
        for j in range(i + 1, n):
            for p in line_points(arc[i], arc[j]):
                covered.add(tuple(p))
    return [p for p in PTS if tuple(p) not in covered]

def on_conic(p):
    # XZ = Y^2, same conic shape used throughout the paper
    x, y, z = p
    return gf9_mul(x, z) == gf9_mul(y, y)

def main():
    # q9Witness, RelativeConicArcs/Examples.lean lines 33-39 (v9 x y z := GF9.ofNat x,y,z;
    # GF9.ofNat is literally "mod 9", so these integers ARE the GF9-encoded values directly).
    arc = [
        (1, 0, 4),
        (1, 0, 5),
        (1, 1, 0),
        (1, 1, 2),
        (1, 2, 3),
        (1, 2, 4),
    ]

    print("=== q=9 analogue of the Clebsch hexagon (Examples.lean: q9Witness) ===")
    print(f"  arc points: {arc}")

    six_arc = is_six_arc(arc)
    print(f"  is a six-arc (no 3 collinear): {six_arc}")
    assert six_arc

    off_conic = all(not on_conic(p) for p in arc)
    print(f"  disjoint from the conic XZ=Y^2: {off_conic}")

    U = deep_hole_locus(arc)
    print(f"  |PG(2,9)| = {len(PTS)}")
    print(f"  deep-hole locus U (points off arc and off all 15 secants): |U| = {len(U)}")
    if U:
        print(f"    U = {U}")

    print()
    print("=== VERDICT ===")
    if len(U) == 0:
        print("  U is EMPTY: the q=9 six-arc is COMPLETE, so it has no deep holes at all.")
        print("  The phenomenon ('deep holes = a conic') is vacuous at q=9, confirming")
        print("  SVM 1995 Prop.13 and excluding q=9 from Theorem (Uniqueness of q=11).")
    else:
        print("  U is NONEMPTY -- this does NOT match the expected q=9 completeness claim;")
        print("  treat the q=9 exclusion as open pending re-examination.")

if __name__ == "__main__":
    main()
