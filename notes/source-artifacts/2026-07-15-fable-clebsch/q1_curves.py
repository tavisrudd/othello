"""Q1: for every six-arc class of PG(2,11), what algebraic curves contain U(A)?
Tests degrees 2, 3, 4; reports kernel dimensions and exact-zero-set matches."""
from itertools import combinations, permutations
from collections import Counter

p = 11

def norm(v):
    for c in v:
        if c % p:
            inv = pow(c % p, p - 2, p)
            return tuple((x * inv) % p for x in v)
    return None

def cross(a, b):
    return norm((a[1]*b[2]-a[2]*b[1], a[2]*b[0]-a[0]*b[2], a[0]*b[1]-a[1]*b[0]))

def dot(a, b):
    return (a[0]*b[0]+a[1]*b[1]+a[2]*b[2]) % p

def det3(P, Q, R):
    return (P[0]*(Q[1]*R[2]-Q[2]*R[1]) - P[1]*(Q[0]*R[2]-Q[2]*R[0])
            + P[2]*(Q[0]*R[1]-Q[1]*R[0])) % p

POINTS = []
seen = set()
for a in range(p):
    for b in range(p):
        for c in range(p):
            if (a,b,c) == (0,0,0): continue
            n = norm((a,b,c))
            if n not in seen:
                seen.add(n); POINTS.append(n)
assert len(POINTS) == 133
PINDEX = {P: i for i, P in enumerate(POINTS)}
LINES = POINTS  # dual plane has the same normalized reps

E1, E2, E3, U = (1,0,0), (0,1,0), (0,0,1), (1,1,1)
FRAME = [E1, E2, E3, U]

# candidate 5th/6th points: off the six frame lines
cands = []
for P in POINTS:
    x, y, z = P
    if x and y and z and x != y and y != z and x != z:
        cands.append(P)
assert len(cands) == 72

# frame-normalized six-arcs
arcs = []
for P, Q in combinations(cands, 2):
    ok = all(det3(F, P, Q) % p for F in FRAME)
    if ok:
        arcs.append(FRAME + [P, Q])
print("frame-normalized representatives:", len(arcs))
assert len(arcs) == 1548

# --- canonical form under PGL(3,11) ---
def solve_frame(F):
    P1, P2, P3, P4 = F
    Mm = [[P1[r], P2[r], P3[r]] for r in range(3)]
    m = [Mm[r][:] + [P4[r]] for r in range(3)]
    r = 0
    for col in range(3):
        pr = next((i for i in range(r,3) if m[i][col] % p), None)
        if pr is None: return None
        m[r], m[pr] = m[pr], m[r]
        inv = pow(m[r][col], p-2, p)
        m[r] = [(x*inv) % p for x in m[r]]
        for i in range(3):
            if i != r and m[i][col] % p:
                f = m[i][col]
                m[i] = [(m[i][j]-f*m[r][j]) % p for j in range(4)]
        r += 1
    x = [m[i][3] for i in range(3)]
    if any(v % p == 0 for v in x): return None
    return tuple(tuple((Mm[r][c]*x[c]) % p for c in range(3)) for r in range(3))

def inv3(M):
    a,b,c = M[0]; d,e,f = M[1]; g,h,i = M[2]
    det = (a*(e*i-f*h) - b*(d*i-f*g) + c*(d*h-e*g)) % p
    dinv = pow(det, p-2, p)
    adj = [[(e*i-f*h),(c*h-b*i),(b*f-c*e)],
           [(f*g-d*i),(a*i-c*g),(c*d-a*f)],
           [(d*h-e*g),(b*g-a*h),(a*e-b*d)]]
    return tuple(tuple((adj[r][cc]*dinv)%p for cc in range(3)) for r in range(3))

def apply(M, P):
    return norm(tuple(sum(M[r][c]*P[c] for c in range(3)) % p for r in range(3)))

def canon(arc):
    best = None
    for T in permutations(arc, 4):
        MT = solve_frame(list(T))
        if MT is None: continue
        G = inv3(MT)
        key = tuple(sorted(apply(G, P) for P in arc))
        if best is None or key < best:
            best = key
    return best

classes = {}
for arc in arcs:
    k = canon(arc)
    classes.setdefault(k, []).append(arc)
print("projective classes:", len(classes))
assert len(classes) == 15

# --- per-class analysis ---
def uncovered(arc):
    marked = set(arc)
    for P, Q in combinations(arc, 2):
        L = cross(P, Q)
        for R in POINTS:
            if dot(L, R) == 0:
                marked.add(R)
    return sorted(P for P in POINTS if P not in marked)

def monomials(d):
    out = []
    for i in range(d+1):
        for j in range(d+1-i):
            out.append((i, j, d-i-j))
    return out

def evalmono(P, m):
    return (pow(P[0], m[0], p) * pow(P[1], m[1], p) * pow(P[2], m[2], p)) % p

def kernel(rows, ncols):
    """rows: list of vectors over F_p; return basis of null space of the matrix."""
    m = [r[:] for r in rows]
    nrows = len(m)
    pivcols = []
    r = 0
    for col in range(ncols):
        pr = next((i for i in range(r, nrows) if m[i][col] % p), None)
        if pr is None: continue
        m[r], m[pr] = m[pr], m[r]
        inv = pow(m[r][col], p-2, p)
        m[r] = [(x*inv) % p for x in m[r]]
        for i in range(nrows):
            if i != r and m[i][col] % p:
                f = m[i][col]
                m[i] = [(m[i][j]-f*m[r][j]) % p for j in range(ncols)]
        pivcols.append(col)
        r += 1
        if r == nrows: break
    free = [c for c in range(ncols) if c not in pivcols]
    basis = []
    for fc in free:
        v = [0]*ncols
        v[fc] = 1
        for ri, pc in enumerate(pivcols):
            v[pc] = (-m[ri][fc]) % p
        basis.append(v)
    return basis

def zeroset_size(coeffs, monos):
    cnt = 0
    for P in POINTS:
        s = 0
        for c, m in zip(coeffs, monos):
            if c: s += c * evalmono(P, m)
        if s % p == 0: cnt += 1
    return cnt

def all_kernel_forms(basis):
    """enumerate nonzero forms in span(basis), projectively (first nonzero = 1)."""
    from itertools import product as iproduct
    k = len(basis)
    seenf = set()
    forms = []
    for coefs in iproduct(range(p), repeat=k):
        if all(c == 0 for c in coefs): continue
        v = [0]*len(basis[0])
        for c, b in zip(coefs, basis):
            if c:
                v = [(vi + c*bi) % p for vi, bi in zip(v, b)]
        n = None
        for x in v:
            if x % p:
                inv = pow(x, p-2, p); n = tuple((y*inv) % p for y in v); break
        if n in seenf: continue
        seenf.add(n)
        forms.append(list(n))
    return forms

def line_in_zeroset(coeffs, monos):
    """does the zero set contain a full line? (=> reducible with linear factor)"""
    Z = set()
    for P in POINTS:
        s = sum(c*evalmono(P, m) for c, m in zip(coeffs, monos) if c) % p
        if s == 0: Z.add(P)
    for L in LINES:
        pts = [P for P in POINTS if dot(L, P) == 0]
        if all(P in Z for P in pts):
            return True
    return False

print()
print(f"{'class':>5} {'reps':>5} {'|Stab|':>6} {'|U|':>4} {'ker2':>4} {'ker3':>4} "
      f"{'ker4':>4}  exact matches (degree: count of forms with Z(F)=U)")
results = []
for ci, (key, members) in enumerate(sorted(classes.items(),
                                           key=lambda kv: len(uncovered(kv[1][0])))):
    arc = members[0]
    Uset = uncovered(arc)
    stab_order = 360 // len(members)
    row = {"class": ci, "reps": len(members), "stab": stab_order, "U": len(Uset)}
    exact = {}
    kdims = {}
    for d in (2, 3, 4):
        monos = monomials(d)
        rows = [[evalmono(P, m) for m in monos] for P in Uset]
        basis = kernel(rows, len(monos))
        kdims[d] = len(basis)
        cnt = 0
        if 0 < len(basis) <= 4:
            for f in all_kernel_forms(basis):
                if zeroset_size(f, monos) == len(Uset):
                    cnt += 1
        exact[d] = cnt
    row["ker"] = kdims
    row["exact"] = exact
    results.append((row, Uset, arc))
    print(f"{ci:>5} {len(members):>5} {stab_order:>6} {len(Uset):>4} "
          f"{kdims[2]:>4} {kdims[3]:>4} {kdims[4]:>4}  {exact}")

# headline booleans
cubic_classes = [r for r, _, _ in results if r["ker"][3] > 0 and r["U"] > 12]
print()
print("non-Clebsch classes with U on a conic :",
      sum(1 for r, _, _ in results if r["ker"][2] > 0 and r["U"] > 12))
print("non-Clebsch classes with U on a cubic :", len(cubic_classes))
quartic_only = [r["class"] for r, _, _ in results if r["ker"][4] > 0 and r["ker"][3] == 0]
print("classes with U on a quartic but no cubic:", quartic_only)
exact_any = [(r["class"], d) for r, _, _ in results for d in (2, 3, 4)
             if r["exact"].get(d, 0) > 0]
print("classes where U IS the full zero set of some degree-d form:", exact_any)

# for any cubic containments found, report reducibility
for r, Uset, arc in results:
    if r["ker"][3] > 0 and r["U"] > 12:
        monos = monomials(3)
        rows = [[evalmono(P, m) for m in monos] for P in Uset]
        basis = kernel(rows, len(monos))
        for f in all_kernel_forms(basis):
            zs = zeroset_size(f, monos)
            lin = line_in_zeroset(f, monos)
            print(f"  class {r['class']} (|U|={r['U']}): cubic zero-set size {zs}, "
                  f"contains a line: {lin}")
