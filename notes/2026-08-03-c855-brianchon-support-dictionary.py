#!/usr/bin/env python3
"""C855 — corroboration for the Brianchon-support dictionary, the invariant support
bipartition, the deep-hole orbit theorem, and the monomial automorphism extension.

Replay:
    python3 notes/2026-08-03-c855-brianchon-support-dictionary.py

Everything below is a check of a human structural proof recorded in
notes/2026-08-03-c855-support-bipartition-proofs.md; nothing here is a deliverable
on its own.
"""

from itertools import combinations, permutations
import sys

q = 11
COLS = [(1, 10, 0), (1, 9, 1), (1, 4, 7), (1, 8, 5), (0, 1, 4), (1, 1, 7)]
N = 6


# ---------- projective plane helpers over F_q ----------

def norm(p):
    for c in p:
        if c % q:
            inv = pow(c % q, q - 2, q)
            return tuple((x * inv) % q for x in p)
    return None


def cross(u, v):
    return (u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0])


def det3(a, b, c):
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])) % q


# ---------- the arc, its chords and concurrences ----------

pts = [norm(c) for c in COLS]
assert len(set(pts)) == 6
assert all(det3(pts[i], pts[j], pts[k]) for i, j, k in combinations(range(6), 3)), "not an arc"

EDGES = list(combinations(range(6), 2))
line = {e: norm(cross(pts[e[0]], pts[e[1]])) for e in EDGES}


def perfect_matchings(vs):
    vs = sorted(vs)
    if not vs:
        yield ()
        return
    a = vs[0]
    for b in vs[1:]:
        rest = [x for x in vs[1:] if x != b]
        for m in perfect_matchings(rest):
            yield ((a, b),) + m


ONE_FACTORS = [tuple(sorted(m)) for m in perfect_matchings(list(range(6)))]
assert len(ONE_FACTORS) == 15


def meet(e, f):
    return norm(cross(line[e], line[f]))


def concurrent(m):
    a, b, c = m
    p = meet(a, b)
    return p == meet(a, c) == meet(b, c)


CONC = [m for m in ONE_FACTORS if concurrent(m)]
NONCONC = [m for m in ONE_FACTORS if not concurrent(m)]
print(f"concurrent one-factors: {len(CONC)}   non-concurrent: {len(NONCONC)}")
assert len(CONC) == 10

# the five non-concurrent one-factors form a one-factorization
assert sorted(e for m in NONCONC for e in m) == sorted(EDGES), "T is not a one-factorization"
T = NONCONC
print("T (the five self-polar triangles):",
      ["|".join(f"{a}{b}" for a, b in t) for t in T])

BRIANCHON = {m: meet(m[0], m[1]) for m in CONC}
assert len(set(BRIANCHON.values())) == 10, "Brianchon points not distinct"

# the fifteen simple intersections of disjoint chords
simple = {}
for e, f in combinations(EDGES, 2):
    if set(e) & set(f):
        continue
    third = tuple(sorted(set(range(6)) - set(e) - set(f)))
    m = tuple(sorted([e, f, third]))
    if m in NONCONC:
        simple.setdefault(meet(e, f), []).append((e, f))
assert len(simple) == 15 and all(len(v) == 1 for v in simple.values())
print("secant-index-2 points from disjoint chord pairs:", len(simple))


# ---------- the alternating six-cycle construction ----------

def cycle_of(t1, t2):
    """Vertex order of the 6-cycle t1 U t2."""
    adj = {v: [] for v in range(6)}
    for a, b in list(t1) + list(t2):
        adj[a].append(b)
        adj[b].append(a)
    assert all(len(adj[v]) == 2 for v in range(6))
    order = [0, adj[0][0]]
    while len(order) < 6:
        nxt = [x for x in adj[order[-1]] if x != order[-2]][0]
        order.append(nxt)
    assert adj[order[-1]].count(order[0]) == 1
    return order


def M_of(t1, t2):
    c = cycle_of(t1, t2)
    return tuple(sorted(tuple(sorted((c[i], c[i + 3]))) for i in range(3)))


def beta_of(t1, t2):
    c = cycle_of(t1, t2)
    s = frozenset(c[0::2])
    return frozenset({s, frozenset(set(range(6)) - s)})


pairs = list(combinations(range(5), 2))
Mmap, Bmap = {}, {}
for i, j in pairs:
    m = M_of(T[i], T[j])
    b = beta_of(T[i], T[j])
    Mmap[(i, j)] = m
    Bmap[(i, j)] = b
    assert m not in T, "opposite matching landed inside T"
    assert concurrent(m), "opposite matching is not concurrent"
    hit = [k for k in range(5) if set(m) & set(T[k])]
    assert sorted(hit) == sorted(set(range(5)) - {i, j}), "edges of M not one per other triangle"
    assert all(len(set(m) & set(T[k])) == 1 for k in hit)

assert len(set(Mmap.values())) == 10 == len(set(ONE_FACTORS) - set(T) & set(Mmap.values()))
assert set(Mmap.values()) == set(CONC), "M is not a bijection onto the concurrent matchings"
assert len(set(Bmap.values())) == 10
print("M and beta are bijections from the ten triangle pairs; M hits exactly the ten Brianchon "
      "matchings")

# crossing-count lemma: exactly two members of T cross any 3-set
for S in combinations(range(6), 3):
    S = set(S)
    crossing = [k for k in range(5)
                if all(len({a, b} & S) == 1 for a, b in T[k])]
    assert len(crossing) == 2, (S, crossing)
    assert Bmap[tuple(sorted(crossing))] == frozenset(
        {frozenset(S), frozenset(set(range(6)) - S)})
print("crossing-count lemma verified for all twenty 3-subsets; beta inverts by crossing")


# ---------- the projective stabilizer A5 and the support orbits ----------

def stabilizer_perms():
    """Permutations of the six columns induced by a projectivity."""
    out = []
    base = [0, 1, 2, 3]
    for images in permutations(range(6), 4):
        # a projectivity is determined by the image of the frame 0,1,2,3
        src = [pts[i] for i in base]
        dst = [pts[i] for i in images]
        A = matrix_from_frame(src, dst)
        if A is None:
            continue
        img = [norm(apply(A, p)) for p in pts]
        if set(img) == set(pts):
            out.append(tuple(pts.index(x) for x in img))
    return out


def apply(A, v):
    return tuple(sum(A[r][c] * v[c] for c in range(3)) % q for r in range(3))


def solve3(M, b):
    M = [row[:] + [b[i]] for i, row in enumerate(M)]
    for col in range(3):
        piv = next((r for r in range(col, 3) if M[r][col] % q), None)
        if piv is None:
            return None
        M[col], M[piv] = M[piv], M[col]
        inv = pow(M[col][col] % q, q - 2, q)
        M[col] = [(x * inv) % q for x in M[col]]
        for r in range(3):
            if r != col and M[r][col] % q:
                f = M[r][col]
                M[r] = [(M[r][c] - f * M[col][c]) % q for c in range(4)]
    return [M[r][3] % q for r in range(3)]


def frame_matrix(fr):
    """Matrix sending e0,e1,e2,(1,1,1) to the four given points."""
    B = [[fr[c][r] for c in range(3)] for r in range(3)]
    lam = solve3(B, fr[3])
    if lam is None or any(x == 0 for x in lam):
        return None
    return [[B[r][c] * lam[c] % q for c in range(3)] for r in range(3)]


def matmul(A, B):
    return [[sum(A[r][k] * B[k][c] for k in range(3)) % q for c in range(3)] for r in range(3)]


def inv3(A):
    cols = [solve3(A, [1 if i == j else 0 for i in range(3)]) for j in range(3)]
    if any(c is None for c in cols):
        return None
    return [[cols[j][i] for j in range(3)] for i in range(3)]


def matrix_from_frame(src, dst):
    P, Q_ = frame_matrix(src), frame_matrix(dst)
    if P is None or Q_ is None:
        return None
    Pi = inv3(P)
    return matmul(Q_, Pi)


A5 = sorted(set(stabilizer_perms()))
print("projective stabilizer of the six columns has order", len(A5))
assert len(A5) == 60


def parity(p):
    seen, s = [False] * 6, 0
    for i in range(6):
        if not seen[i]:
            j, ln = i, 0
            while not seen[j]:
                seen[j] = True
                j = p[j]
                ln += 1
            s += ln - 1
    return s % 2


assert all(parity(p) == 0 for p in A5), "stabilizer is not inside A6"
cyc_types = {}
for p in A5:
    seen, t = [False] * 6, []
    for i in range(6):
        if not seen[i]:
            j, ln = i, 0
            while not seen[j]:
                seen[j] = True
                j = p[j]
                ln += 1
            t.append(ln)
    cyc_types[tuple(sorted(t))] = cyc_types.get(tuple(sorted(t)), 0) + 1
print("cycle types on the six columns:", cyc_types)
assert (2, 2, 2) not in cyc_types, "a fixed-point-free involution exists"

supports = [frozenset(s) for s in combinations(range(6), 3)]
orb = {}
for s in supports:
    if s in orb:
        continue
    o = frozenset(frozenset(p[i] for i in s) for p in A5)
    for x in o:
        orb[x] = o
orbits = sorted({frozenset(o) for o in orb.values()}, key=lambda o: sorted(map(sorted, o)))
print("support orbit sizes:", sorted(len(o) for o in orbits))
assert sorted(len(o) for o in orbits) == [10, 10]
O_plus, O_minus = orbits
assert all(frozenset(set(range(6)) - s) in O_minus for s in O_plus), "complementation not swapping"

# the pair stabilizer in A5 preserves the alternating classes
S0 = next(iter(O_plus))
stab = [p for p in A5 if frozenset(p[i] for i in S0) == S0]
print("stabilizer of one 3-support has order", len(stab))
assert len(stab) == 6


# ---------- Petersen adjacency ----------

def rel(p1, p2):
    m1, m2 = Mmap[p1], Mmap[p2]
    shared = len(set(m1) & set(m2))
    b1 = sorted(sorted(x) for x in Bmap[p1])
    b2 = sorted(sorted(x) for x in Bmap[p2])
    inter = min(len(set(a) & set(b)) for a in b1 for b in b2)
    return shared, inter


adj_shared = {True: set(), False: set()}
for p1, p2 in combinations(pairs, 2):
    disjoint = not (set(p1) & set(p2))
    adj_shared[disjoint].add(rel(p1, p2))
print("adjacent (disjoint index pairs)  -> (shared M edges, min support meet):", adj_shared[True])
print("non-adjacent (meeting index pairs) ->", adj_shared[False])

# chord reading of Petersen adjacency on the Brianchon points
coll = {True: set(), False: set()}
for p1, p2 in combinations(pairs, 2):
    disjoint = not (set(p1) & set(p2))
    b1, b2 = BRIANCHON[Mmap[p1]], BRIANCHON[Mmap[p2]]
    onchord = [e for e in EDGES
               if det3(pts[e[0]], pts[e[1]], b1) == 0 and det3(pts[e[0]], pts[e[1]], b2) == 0]
    assert set(onchord) == set(Mmap[p1]) & set(Mmap[p2])
    coll[disjoint].add(len(onchord))
print("chords containing both Brianchon points, adjacent:", coll[True],
      " non-adjacent:", coll[False])

# each edge lies in exactly two of the ten Brianchon matchings
for e in EDGES:
    assert sum(1 for m in CONC if e in m) == 2
print("every chord carries exactly two Brianchon points")


# ---------- the code, its deep holes, and the leader split ----------

def syndrome(v):
    return tuple(sum(v[i] * COLS[i][r] for i in range(6)) % q for r in range(3))


def nonzero_tuples(k):
    if k == 0:
        yield ()
        return
    for t in nonzero_tuples(k - 1):
        for x in range(1, q):
            yield t + (x,)


syn_weight = {}
syn_leaders = {}
for wt in range(0, 4):
    for supp in combinations(range(6), wt):
        for vals in nonzero_tuples(wt):
            v = [0] * 6
            for i, s in enumerate(supp):
                v[s] = vals[i]
            s_ = syndrome(v)
            if s_ not in syn_weight:
                syn_weight[s_] = wt
                syn_leaders[s_] = []
            if syn_weight[s_] == wt:
                syn_leaders[s_].append(tuple(v))

assert len(syn_weight) == q ** 3
dist = {}
for s_, w in syn_weight.items():
    dist[w] = dist.get(w, 0) + 1
print("coset-leader weight distribution:", [dist.get(w, 0) for w in range(4)])
assert [dist.get(w, 0) for w in range(4)] == [1, 60, 1150, 120]

deep = [s_ for s_, w in syn_weight.items() if w == 3]
assert len(deep) == 120
tot = {"plus": 0, "minus": 0}
for s_ in deep:
    L = syn_leaders[s_]
    assert len(L) == 20
    sup = [frozenset(i for i in range(6) if v[i]) for v in L]
    assert len(set(sup)) == 20
    tot["plus"] += sum(1 for x in sup if x in O_plus)
    tot["minus"] += sum(1 for x in sup if x in O_minus)
    assert sum(1 for x in sup if x in O_plus) == 10
print("global leader split:", tot)
assert tot == {"plus": 1200, "minus": 1200}

# the ten triple-ambiguity directions are the Brianchon points
trip = {}
for s_, w in syn_weight.items():
    if w == 2:
        trip.setdefault(norm(s_), []).append(s_)
amb = {}
for s_, w in syn_weight.items():
    if w == 2:
        amb[s_] = len(syn_leaders[s_])
by_dir = {}
for s_, k in amb.items():
    by_dir.setdefault(norm(s_), set()).add(k)
three = sorted(d for d, ks in by_dir.items() if ks == {3})
print("directions with three weight-two leaders:", len(three))
assert set(three) == set(BRIANCHON.values())
for d in three:
    s_ = next(s for s in amb if norm(s) == d)
    sup = [frozenset(i for i in range(6) if v[i]) for v in syn_leaders[s_]]
    assert sorted(sorted(x) for x in sup) == sorted(sorted(e) for e in
                                                   next(m for m in CONC if BRIANCHON[m] == d))
print("their three supports are exactly the Brianchon matching, in every case")


# ---------- monomial automorphisms and the deep-hole orbit ----------

MATS = {}
for sg in A5:
    A = matrix_from_frame([pts[i] for i in range(4)], [pts[sg[i]] for i in range(4)])
    assert A is not None
    assert all(norm(apply(A, pts[i])) == pts[sg[i]] for i in range(6))
    MATS[sg] = A
assert len(MATS) == 60
print("monomial automorphism group order:", 60 * (q - 1))

deep_dirs = sorted({norm(s_) for s_ in deep})
assert len(deep_dirs) == 12
orbit = {norm(apply(MATS[sg], deep_dirs[0])) for sg in A5}
assert orbit == set(deep_dirs), "A5 is not transitive on the twelve deep-hole directions"
print("A5 is transitive on the twelve deep-hole directions")

s0 = deep[0]
syn_orbit = {tuple((mu * x) % q for x in apply(MATS[sg], s0))
             for sg in A5 for mu in range(1, q)}
assert syn_orbit == set(deep)
print("the monomial group is transitive on all 120 maximum-distance syndromes")

stab = [(sg, mu) for sg in A5 for mu in range(1, q)
        if tuple((mu * x) % q for x in apply(MATS[sg], s0)) == s0]
print("stabilizer of one deep-hole received word has order", len(stab))
assert len(stab) == 5

print("\nALL CHECKS PASSED")
