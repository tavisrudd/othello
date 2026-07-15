"""Q2 step 2: does any 7-arc in PG(2,q), q in {11,13}, have U(A) = C(F_q)?
Exhaustive frame-normalized enumeration. Every 7-arc contains an ordered
4-frame, so frame + {P,Q,R} meets every class; these arise exactly as
(six-arc representative) + (a point of its extension locus U)."""
from itertools import combinations

def run(q, expected_six_reps, expected_hist=None):
    def norm(v):
        for c in v:
            if c % q:
                inv = pow(c % q, q-2, q)
                return tuple((x*inv) % q for x in v)
    pts, seen = [], set()
    for a in range(q):
        for b in range(q):
            for c in range(q):
                if (a,b,c)==(0,0,0): continue
                n = norm((a,b,c))
                if n not in seen: seen.add(n); pts.append(n)
    assert len(pts) == q*q+q+1
    PI = {P:i for i,P in enumerate(pts)}

    def cross(a,b):
        return norm((a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2],
                     a[0]*b[1]-a[1]*b[0]))
    def det3(P,Q,R):
        return (P[0]*(Q[1]*R[2]-Q[2]*R[1]) - P[1]*(Q[0]*R[2]-Q[2]*R[0])
                + P[2]*(Q[0]*R[1]-Q[1]*R[0])) % q

    # cache: line -> tuple of point indices
    line_pts = {}
    def points_on(L):
        if L not in line_pts:
            line_pts[L] = tuple(PI[P] for P in pts
                                if (L[0]*P[0]+L[1]*P[1]+L[2]*P[2]) % q == 0)
        return line_pts[L]

    FRAME = [(1,0,0),(0,1,0),(0,0,1),(1,1,1)]
    cands = [P for P in pts if P[0] and P[1] and P[2]
             and P[0]!=P[1] and P[1]!=P[2] and P[0]!=P[2]]
    assert len(cands) == (q-2)*(q-3)

    six = [FRAME+[P,Q] for P,Q in combinations(cands,2)
           if all(det3(F,P,Q) % q for F in FRAME)]
    print(f"q={q}: six-arc representatives: {len(six)}")
    assert len(six) == expected_six_reps

    def U_of(arc):
        cov = bytearray(len(pts))
        for i in arc_idx(arc): cov[i] = 1
        for P,Q in combinations(arc,2):
            for i in points_on(cross(P,Q)): cov[i] = 1
        return [i for i in range(len(pts)) if not cov[i]]
    def arc_idx(arc): return [PI[P] for P in arc]

    hist = {}
    hits = []
    n7 = 0
    seen7 = set()
    for A6 in six:
        U6 = U_of(A6)
        hist[len(U6)] = hist.get(len(U6),0)+1
        base = frozenset(arc_idx(A6))
        for ri in U6:
            key = base | {ri}
            if key in seen7: continue
            seen7.add(key)
            n7 += 1
            A7 = A6 + [pts[ri]]
            U7 = U_of(A7)
            if len(U7) != q+1:
                continue
            # conic test on U7: rank of 6-monomial evaluation
            monos = [(2,0,0),(1,1,0),(1,0,1),(0,2,0),(0,1,1),(0,0,2)]
            rows = []
            for i in U7:
                P = pts[i]
                rows.append([ (P[0]**m[0] * P[1]**m[1] * P[2]**m[2]) % q
                              for m in monos])
            # gaussian elim
            m = [r[:] for r in rows]; r0 = 0; piv=[]
            for col in range(6):
                pr = next((i for i in range(r0,len(m)) if m[i][col] % q), None)
                if pr is None: continue
                m[r0],m[pr] = m[pr],m[r0]
                inv = pow(m[r0][col], q-2, q)
                m[r0] = [(x*inv)%q for x in m[r0]]
                for i in range(len(m)):
                    if i != r0 and m[i][col] % q:
                        f = m[i][col]
                        m[i] = [(m[i][j]-f*m[r0][j])%q for j in range(6)]
                piv.append(col); r0 += 1
            if r0 < 6:
                hits.append((A7, len(U7)))
    print(f"q={q}: distinct frame-normalized 7-arcs examined: {n7}")
    print(f"q={q}: six-arc |U| histogram: {dict(sorted(hist.items()))}")
    if expected_hist:
        assert hist == expected_hist, "census mismatch vs paper table"
    print(f"q={q}: 7-arcs with |U| = q+1 AND U on a conic: {len(hits)}")
    # also report how close anything came: min |U| over all 7-arcs
    return hits

hits11 = run(11, 1548,
              {12:6, 16:30, 18:150, 19:300, 20:630, 21:360, 22:72})
hits13 = run(13, 4015,
              {36:85, 38:210, 39:480, 40:1080, 41:1800, 42:360})
print()
print("CONCLUSION: conic-filling 7-arcs at q=11:", len(hits11),
      "; at q=13:", len(hits13))
