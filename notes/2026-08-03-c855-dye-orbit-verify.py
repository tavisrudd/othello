"""C855: verify the equality-case normal form and its projective uniqueness.

The symbolic solve (notes/2026-08-03-c855-dye-orbit-solve.py) reduces the
Brianchon-equality system to  x = y,  x + z = 2,  x*y*z = 1, i.e. to
x^3 - 2x^2 + 1 = (x-1)(x^2 - x - 1) = 0 with x = 1 excluded, so x = y is a
golden root and z = 2 - x.  This script, for each odd prime power q, builds
both arcs from the two roots, checks the arc property, recomputes the
Brianchon count, and tests whether the two arcs are PGL(3,q)-equivalent.

Replay:  python3 notes/2026-08-03-c855-dye-orbit-verify.py 5 11 19 29 31 41 59 61
"""
import sys, itertools

def sqrt_mod(a, p):
    return [r for r in range(p) if (r * r - a) % p == 0]

def norm(P, p):
    for c in P:
        if c % p:
            inv = pow(c, p - 2, p)
            return tuple((v * inv) % p for v in P)
    return None

def cross(a, b, p):
    return ((a[1]*b[2]-a[2]*b[1]) % p, (a[2]*b[0]-a[0]*b[2]) % p, (a[0]*b[1]-a[1]*b[0]) % p)

def det3(a, b, c, p):
    return (a[0]*(b[1]*c[2]-b[2]*c[1]) - a[1]*(b[0]*c[2]-b[2]*c[0]) + a[2]*(b[0]*c[1]-b[1]*c[0])) % p

def arc_from_root(x, p):
    z = (2 - x) % p
    pts = [(1,0,0), (x,1,1), (0,1,0), (1,x,1), (0,0,1), (1,1,z)]
    return [norm(P, p) for P in pts]

def is_arc(pts, p):
    if len(set(pts)) != 6: return False
    return all(det3(*t, p) % p for t in itertools.combinations(pts, 3))

def brianchon_count(pts, p):
    n = 0
    for f in [((0,1),(2,3),(4,5)), ((0,1),(2,4),(3,5)), ((0,1),(2,5),(3,4)),
              ((0,2),(1,3),(4,5)), ((0,2),(1,4),(3,5)), ((0,2),(1,5),(3,4)),
              ((0,3),(1,2),(4,5)), ((0,3),(1,4),(2,5)), ((0,3),(1,5),(2,4)),
              ((0,4),(1,2),(3,5)), ((0,4),(1,3),(2,5)), ((0,4),(1,5),(2,3)),
              ((0,5),(1,2),(3,4)), ((0,5),(1,3),(2,4)), ((0,5),(1,4),(2,3))]:
        L = [cross(pts[i], pts[j], p) for i, j in f]
        if det3(*L, p) % p == 0: n += 1
    return n

def pgl_equivalent(A, B, p):
    """A,B are 6-point arcs.  Try to map an ordered frame of A onto an ordered
    frame of B; a projectivity is determined by 4 points in general position."""
    import itertools as it
    def matrix_from_frame(frame, p):
        import fractions
        (a, b, c, d) = frame
        # solve M * e_i ~ frame_i, M columns = l1*a, l2*b, l3*c with sum = d
        M = [[a[i], b[i], c[i]] for i in range(3)]
        # solve M l = d over F_p
        aug = [row[:] + [d[i]] for i, row in enumerate(M)]
        for col in range(3):
            piv = next((r for r in range(col, 3) if aug[r][col] % p), None)
            if piv is None: return None
            aug[col], aug[piv] = aug[piv], aug[col]
            inv = pow(aug[col][col], p - 2, p)
            aug[col] = [(v * inv) % p for v in aug[col]]
            for r in range(3):
                if r != col and aug[r][col] % p:
                    f = aug[r][col]
                    aug[r] = [(aug[r][k] - f * aug[col][k]) % p for k in range(4)]
        l = [aug[r][3] % p for r in range(3)]
        if any(v == 0 for v in l): return None
        return [[(l[0]*a[i]) % p, (l[1]*b[i]) % p, (l[2]*c[i]) % p] for i in range(3)]
    def apply(M, P, p):
        return norm(tuple(sum(M[i][k]*P[k] for k in range(3)) % p for i in range(3)), p)
    frameB = None
    for cand in it.permutations(B, 4):
        if all(det3(*t, p) % p for t in it.combinations(cand, 3)):
            frameB = cand; break
    MB = matrix_from_frame(frameB, p)
    setB = set(B)
    for cand in it.permutations(A, 4):
        if not all(det3(*t, p) % p for t in it.combinations(cand, 3)): continue
        MA = matrix_from_frame(cand, p)
        if MA is None: continue
        # M = MB * MA^{-1};  test by mapping A through MA^{-1} then MB
        # invert MA
        import copy
        aug = [MA[i][:] + [1 if j == i else 0 for j in range(3)] for i in range(3)]
        ok = True
        for col in range(3):
            piv = next((r for r in range(col, 3) if aug[r][col] % p), None)
            if piv is None: ok = False; break
            aug[col], aug[piv] = aug[piv], aug[col]
            inv = pow(aug[col][col], p - 2, p)
            aug[col] = [(v * inv) % p for v in aug[col]]
            for r in range(3):
                if r != col and aug[r][col] % p:
                    f = aug[r][col]
                    aug[r] = [(aug[r][k] - f * aug[col][k]) % p for k in range(6)]
        if not ok: continue
        MAi = [[aug[i][3+j] for j in range(3)] for i in range(3)]
        M = [[sum(MB[i][k]*MAi[k][j] for k in range(3)) % p for j in range(3)] for i in range(3)]
        if set(apply(M, P, p) for P in A) == setB:
            return True
    return False

for q in [int(a) for a in sys.argv[1:]]:
    roots = sqrt_mod(5, q)
    if not roots:
        print(f"q={q}: 5 is a non-square, no golden root, equality case impossible"); continue
    inv2 = pow(2, q - 2, q)
    xs = sorted(set(((1 + r) * inv2) % q for r in roots))
    arcs = []
    for x in xs:
        if x == 1 % q:
            print(f"q={q}: root x=1 is degenerate, skipped"); continue
        A = arc_from_root(x, q)
        ok = is_arc(A, q)
        n3 = brianchon_count(A, q) if ok else None
        print(f"q={q}: x={x}, arc={ok}, brianchon count={n3}")
        if ok and n3 == 10: arcs.append(A)
    if len(arcs) == 2:
        print(f"q={q}: two roots -> PGL-equivalent? {pgl_equivalent(arcs[0], arcs[1], q)}")
    elif len(arcs) == 1:
        print(f"q={q}: single root gives a single arc")
    if q == 11:
        W = [norm(t, 11) for t in
             [(1,10,0), (1,9,1), (1,4,7), (1,8,5), (0,1,4), (1,1,7)]]
        print(f"q=11: Examples.q11Witness is an arc={is_arc(W, 11)}, "
              f"brianchon count={brianchon_count(W, 11)}")
        for A in arcs:
            print("q=11: normal form equivalent to q11Witness?",
                  pgl_equivalent(A, W, 11))
