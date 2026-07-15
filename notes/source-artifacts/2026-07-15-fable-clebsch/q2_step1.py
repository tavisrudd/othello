"""Q2 step 1: general-k chord-defect identities and the (4,5) instance.
(a) k=4, q=5: EVERY 4-arc has U = full point set of a nonsingular conic.
(b) k=5, any q: |U| = q^2-9q+21 exactly (no free parameter) -> never q+1.
(c) k=7: |U| = q^2-20q+120-n3; verified on samples at q=11,13."""
from itertools import combinations
import random
random.seed(1)

def make_plane(q):
    def norm(v):
        for c in v:
            if c % q:
                inv = pow(c % q, q-2, q)
                return tuple((x*inv) % q for x in v)
        return None
    pts, seen = [], set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                if (a,b,c)==(0,0,0): continue
                n = norm((a,b,c))
                if n not in seen: seen.add(n); pts.append(n)
    return pts, norm

def cross(a,b,q):
    v = (a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0])
    return v

def dot(a,b,q): return (a[0]*b[0]+a[1]*b[1]+a[2]*b[2]) % q

def det3(P,Q,R,q):
    return (P[0]*(Q[1]*R[2]-Q[2]*R[1]) - P[1]*(Q[0]*R[2]-Q[2]*R[0])
            + P[2]*(Q[0]*R[1]-Q[1]*R[0])) % q

def uncovered_and_n3(arc, pts, q):
    aset = set(arc)
    count = {}
    for P,Q in combinations(arc,2):
        L = cross(P,Q,q)
        for R in pts:
            if R in aset: continue
            if dot(L,R,q)==0:
                count[R] = count.get(R,0)+1
    U = [P for P in pts if P not in aset and P not in count]
    n3 = sum(1 for v in count.values() if v==3)
    return U, n3

# ---------- (a) k=4, q=5 ----------
q = 5
pts, norm = make_plane(q)
FR = [(1,0,0),(0,1,0),(0,0,1),(1,1,1)]
U4, _ = uncovered_and_n3(FR, pts, q)
print("k=4, q=5: |U| =", len(U4))
assert len(U4) == 6 == q+1
# conic through U: F = X^2+Y^2+Z^2+XY+XZ+YZ (claimed)
def F(P): return (P[0]**2+P[1]**2+P[2]**2+P[0]*P[1]+P[0]*P[2]+P[1]*P[2]) % q
Z = [P for P in pts if F(P)==0]
assert sorted(Z) == sorted(U4), "U is exactly the zero set of F"
# nonsingularity: matrix of the form, det != 0 (2 invertible mod 5)
half = pow(2, q-2, q)
M = [[1, half, half],[half, 1, half],[half, half, 1]]
d = (M[0][0]*(M[1][1]*M[2][2]-M[1][2]*M[2][1])
     - M[0][1]*(M[1][0]*M[2][2]-M[1][2]*M[2][0])
     + M[0][2]*(M[1][0]*M[2][1]-M[1][1]*M[2][0])) % q
assert d != 0
assert not (set(FR) & set(Z))
print("  U = Z(X^2+Y^2+Z^2+XY+XZ+YZ), nonsingular, disjoint from the arc: VERIFIED")
print("  (all 4-arcs are PGL-equivalent to the frame, so this holds for every 4-arc)")

# ---------- (b) k=5 identity ----------
for q in (5, 7, 9, 11):
    if q == 9:
        continue  # prime fields only in this quick check; 9 done via paper census
    pts, norm = make_plane(q)
    cands = [P for P in pts if P[0] and P[1] and P[2]
             and P[0]!=P[1] and P[1]!=P[2] and P[0]!=P[2]]
    checked = 0
    for P in cands:
        arc = FRAME = [(1,0,0),(0,1,0),(0,0,1),(1,1,1),P]
        ok = all(det3(*T,q) for T in combinations(arc,3))
        if not ok: continue
        U, n3 = uncovered_and_n3(arc, pts, q)
        assert n3 == 0, "5-arc concurrency > 2 impossible"
        assert len(U) == q*q - 9*q + 21, (q, P, len(U))
        checked += 1
    print(f"k=5, q={q}: |U| = q^2-9q+21 = {q*q-9*q+21} verified on all "
          f"{checked} frame-normalized 5-arcs")

# ---------- (c) k=7 identity, sampled ----------
for q in (11, 13):
    pts, norm = make_plane(q)
    cands = [P for P in pts if P[0] and P[1] and P[2]
             and P[0]!=P[1] and P[1]!=P[2] and P[0]!=P[2]]
    FRAME = [(1,0,0),(0,1,0),(0,0,1),(1,1,1)]
    found = 0
    tries = 0
    while found < 300 and tries < 200000:
        tries += 1
        trio = random.sample(cands, 3)
        arc = FRAME + trio
        if not all(det3(*T,q) for T in combinations(arc,3)):
            continue
        U, n3 = uncovered_and_n3(arc, pts, q)
        assert len(U) == q*q - 20*q + 120 - n3, (q, arc, len(U), n3)
        found += 1
    print(f"k=7, q={q}: |U| = q^2-20q+120-n3 verified on {found} random 7-arcs")

print("STEP 1 VERIFIED")
