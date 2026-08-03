"""C855: structure of the equality case (Brianchon count ten) for six-arcs.

Builds the one-factor / one-factorization dictionary of K6, singles out the
five non-concurrent one-factors as one one-factorization F0, normalizes a
hexagonal ordering whose synthetic triangle avoids F0, and solves the
resulting concurrence system symbolically in the triple-perspective
coordinates P1=e1,P3=e2,P5=e3, P2=(x:1:1), P4=(1:y:1), P6=(1:1:z).

Replay:  uv run --with sympy python3 notes/2026-08-03-c855-dye-orbit-solve.py
"""
import itertools, sys

V = list(range(6))

def one_factors():
    res = []
    def rec(rem, acc):
        if not rem:
            res.append(frozenset(acc)); return
        a = rem[0]
        for b in rem[1:]:
            rec([v for v in rem[1:] if v != b], acc + [frozenset((a, b))])
    rec(V, [])
    return res

OF = one_factors()
assert len(OF) == 15

def one_factorizations():
    res = []
    for combo in itertools.combinations(OF, 5):
        edges = set()
        ok = True
        for f in combo:
            for e in f:
                if e in edges: ok = False; break
                edges.add(e)
            if not ok: break
        if ok and len(edges) == 15:
            res.append(frozenset(combo))
    return res

OFZ = one_factorizations()
assert len(OFZ) == 6, len(OFZ)

# synthetic label of each one-factor = the pair of one-factorizations containing it
syn = {}
for f in OF:
    pair = frozenset(i for i, F in enumerate(OFZ) if f in F)
    assert len(pair) == 2
    syn[f] = pair
assert len(set(syn.values())) == 15

F0 = 0                      # the singleton class of the 5+1 partition
M = [f for f in OF if F0 not in syn[f]]     # concurrent one-factors
NC = [f for f in OF if F0 in syn[f]]        # the five non-concurrent ones
assert len(M) == 10 and len(NC) == 5
assert frozenset(NC) == OFZ[F0]

def hexagon_factors(order):
    a, b, c, d, e, f = order
    return [frozenset({frozenset((a,b)), frozenset((c,d)), frozenset((e,f))}),
            frozenset({frozenset((b,c)), frozenset((d,e)), frozenset((f,a))}),
            frozenset({frozenset((a,d)), frozenset((b,e)), frozenset((c,f))})]

# find a hexagonal ordering whose synthetic triangle lies wholly in M
order = None
for perm in itertools.permutations(V):
    if perm[0] != 0: continue
    tri = hexagon_factors(perm)
    if all(t in M for t in tri):
        order = perm; break
assert order is not None
relabel = {order[i]: i for i in range(6)}   # order -> 0..5 = arc labels P1..P6

Mlab = [frozenset(frozenset(relabel[v] for v in e) for e in f) for f in M]
NClab = [frozenset(frozenset(relabel[v] for v in e) for e in f) for f in NC]

def show(fs):
    return sorted(''.join(str(v+1) for v in sorted(e)) for e in fs)

print("hexagonal ordering used (original labels):", order)
print("concurrent one-factors (arc labels P1..P6):")
for f in sorted(Mlab, key=lambda f: show(f)):
    print("   ", show(f))
print("non-concurrent (the one-factorization F0):")
for f in sorted(NClab, key=lambda f: show(f)):
    print("   ", show(f))

# ---------------- symbolic solve ----------------
import sympy as sp
x, y, z = sp.symbols('x y z')
P = {0: sp.Matrix([1,0,0]), 1: sp.Matrix([x,1,1]), 2: sp.Matrix([0,1,0]),
     3: sp.Matrix([1,y,1]), 4: sp.Matrix([0,0,1]), 5: sp.Matrix([1,1,z])}

def line(i, j):
    return P[i].cross(P[j])

def conc(f):
    (a,b),(c,d),(e,g) = [tuple(sorted(e2)) for e2 in sorted(f, key=lambda s: sorted(s))]
    return sp.factor(sp.Matrix.hstack(line(a,b), line(c,d), line(e,g)).det())

print("\nconcurrence determinants for the ten concurrent factors:")
eqs = []
for f in sorted(Mlab, key=lambda f: show(f)):
    d = sp.expand(conc(f))
    eqs.append(sp.factor(d))
    print("   ", show(f), "->", sp.factor(d))

print("\nnon-concurrent factors' determinants (must be nonzero):")
for f in sorted(NClab, key=lambda f: show(f)):
    print("   ", show(f), "->", sp.factor(sp.expand(conc(f))))

# ---------------- which relabellings swap the two golden roots ----------------
# For each permutation of the arc labels preserving the concurrent set Mlab, the
# relabelled arc admits the same normalization; read off its parameter.
def stabilizer(Mset):
    out = []
    for s in itertools.permutations(range(6)):
        img = frozenset(frozenset(frozenset(s[v] for v in e) for e in f) for f in Mset)
        if img == frozenset(Mset):
            out.append(s)
    return out

STAB = stabilizer(Mlab)
print("\n|stabilizer of the concurrence pattern in S6| =", len(STAB))

def param_after(s, xval, p):
    """Relabel the normal-form arc by s, renormalize, return the new parameter."""
    zval = (2 - xval) % p
    base = [(1,0,0), (xval,1,1), (0,1,0), (1,xval,1), (0,0,1), (1,1,zval)]
    Q = [None]*6
    for i in range(6):
        Q[s[i]] = base[i]          # new label s[i] carries old point i
    # normalize: Q0,Q2,Q4 -> e1,e2,e3 and the concurrency point of Q0Q1,Q2Q3,Q4Q5 -> (1:1:1)
    import sympy as sp2
    Mmat = sp2.Matrix([[Q[0][k], Q[2][k], Q[4][k]] for k in range(3)])
    if Mmat.det() % p == 0: return None
    Minv = Mmat.inv_mod(p)
    R = [tuple((Minv*sp2.Matrix(list(q))) % p) for q in Q]
    L = [sp2.Matrix(list(R[0])).cross(sp2.Matrix(list(R[1]))),
         sp2.Matrix(list(R[2])).cross(sp2.Matrix(list(R[3]))),
         sp2.Matrix(list(R[4])).cross(sp2.Matrix(list(R[5])))]
    A = sp2.Matrix.hstack(*L)
    if A.det() % p != 0: return None            # not concurrent: ordering inadmissible
    # concurrency point = null space of the transpose
    for cand in range(p):
        pass
    # solve L1 . v = 0, L2 . v = 0
    v = sp2.Matrix(3,1, lambda i,j: 0)
    Lm = sp2.Matrix([[int(L[0][k]) % p for k in range(3)], [int(L[1][k]) % p for k in range(3)]])
    sol = None
    for a in range(p):
        for b in range(p):
            for c in range(p):
                if (a,b,c) == (0,0,0): continue
                if all(sum(Lm[r,k]*[a,b,c][k] for k in range(3)) % p == 0 for r in range(2)):
                    sol = (a,b,c); break
            if sol: break
        if sol: break
    D = sp2.diag(*[pow(int(sol[k]) % p, p-2, p) for k in range(3)])
    S = [tuple((D*sp2.Matrix(list(r))) % p) for r in R]
    # now S[0]=e1, S[2]=e2, S[4]=e3 and S[1]=(x:1:1) after scaling by its last coord
    s1 = [int(c) % p for c in S[1]]
    if s1[2] % p == 0: return None
    return (s1[0] * pow(s1[2], p - 2, p)) % p

import sys as _s
p = 11
xval = 4
seen = {}
for s in STAB:
    v = param_after(s, xval, p)
    seen.setdefault(v, []).append(s)
print("parameters reached from x=%d over F_%d:" % (xval, p),
      {k: len(v) for k, v in seen.items()})
for k, v in seen.items():
    print("   parameter", k, "example relabelling", v[0])
