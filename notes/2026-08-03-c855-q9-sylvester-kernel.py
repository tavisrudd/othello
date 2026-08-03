#!/usr/bin/env python3
"""C855 target 4: bounded check of the q=9 polarity-graph package of lem:q9-polarity.

Purpose: decide which clauses of the q=9 Sylvester package have short structural proofs
and what the minimal finite kernel is for the clique clause.  Bounded conjecture test only;
not a paper-facing certificate.

Replay:  python3 notes/2026-08-03-c855-q9-sylvester-kernel.py
"""

from itertools import combinations

# ---- GF(9) = F_3[i]/(i^2 + 1) as pairs (a, b) meaning a + b*i -------------------------
F = [(a, b) for a in range(3) for b in range(3)]


def add(u, v):
    return ((u[0] + v[0]) % 3, (u[1] + v[1]) % 3)


def mul(u, v):
    # (a+bi)(c+di) = (ac - bd) + (ad + bc)i
    return ((u[0] * v[0] - u[1] * v[1]) % 3, (u[0] * v[1] + u[1] * v[0]) % 3)


ZERO, ONE = (0, 0), (1, 0)


def inv(u):
    for v in F:
        if mul(u, v) == ONE:
            return v
    raise ValueError("no inverse")


def normalize(t):
    """Projective normalization of a nonzero triple: scale so the first nonzero entry is 1."""
    for c in t:
        if c != ZERO:
            s = inv(c)
            return tuple(mul(s, x) for x in t)
    raise ValueError("zero triple")


PTS = sorted({normalize((x, y, z)) for x in F for y in F for z in F
              if (x, y, z) != (ZERO, ZERO, ZERO)})
assert len(PTS) == 91
LINES = PTS  # a line [a:b:c] is the same normalized data


def incident(p, l):
    s = ZERO
    for a, b in zip(p, l):
        s = add(s, mul(a, b))
    return s == ZERO


# ---- the conic XZ - Y^2 = 0 and the induced polarity ---------------------------------
def on_conic(p):
    return add(mul(p[0], p[2]), tuple((-c) % 3 for c in mul(p[1], p[1]))) == ZERO


CONIC = [p for p in PTS if on_conic(p)]
assert len(CONIC) == 10

# XZ - Y^2 has matrix M = [[0,0,1/2],[0,-1,0],[1/2,0,0]]; scale by 2 to avoid halves:
# 2M = [[0,0,1],[0,-2,0],[1,0,0]] = [[0,0,1],[0,1,0],[1,0,0]] over F_3.
MAT = [[ZERO, ZERO, ONE], [ZERO, ONE, ZERO], [ONE, ZERO, ZERO]]


def polar(p):
    out = []
    for row in MAT:
        s = ZERO
        for a, b in zip(row, p):
            s = add(s, mul(a, b))
        out.append(s)
    return normalize(tuple(out))


LINE_TYPE = {}
for l in LINES:
    LINE_TYPE[l] = sum(1 for p in CONIC if incident(p, l))  # 0 passant, 1 tangent, 2 secant

INTERNAL = [p for p in PTS if not on_conic(p) and LINE_TYPE[polar(p)] == 0]
EXTERNAL = [p for p in PTS if not on_conic(p) and LINE_TYPE[polar(p)] == 2]
assert len(INTERNAL) == 36 and len(EXTERNAL) == 45, (len(INTERNAL), len(EXTERNAL))

# cross-check the internal characterization "lies on no tangent"
for p in INTERNAL:
    assert all(LINE_TYPE[l] != 1 for l in LINES if incident(p, l))

IDX = {p: i for i, p in enumerate(INTERNAL)}


def join(p, q):
    """The line through two distinct points, as the cross product."""
    def m(a, b):
        return mul(a, b)
    x = add(m(p[1], q[2]), tuple((-c) % 3 for c in m(p[2], q[1])))
    y = add(m(p[2], q[0]), tuple((-c) % 3 for c in m(p[0], q[2])))
    z = add(m(p[0], q[1]), tuple((-c) % 3 for c in m(p[1], q[0])))
    return normalize((x, y, z))


# ---- Sigma (conjugacy) and Sigma_2 (passant join) -----------------------------------
n = 36
SIG = [[False] * n for _ in range(n)]
PAS = [[False] * n for _ in range(n)]
for p, q in combinations(INTERNAL, 2):
    i, j = IDX[p], IDX[q]
    if incident(q, polar(p)):
        SIG[i][j] = SIG[j][i] = True
    if LINE_TYPE[join(p, q)] == 0:
        PAS[i][j] = PAS[j][i] = True

deg = [sum(r) for r in SIG]
print("Sigma degrees:", sorted(set(deg)))
print("Sigma_2 degrees:", sorted({sum(r) for r in PAS}))
print("triangles in Sigma:", sum(1 for a, b, c in combinations(range(n), 3)
                                 if SIG[a][b] and SIG[b][c] and SIG[a][c]))

# distance distribution in Sigma
import collections
def dists(src):
    d = {src: 0}
    frontier = [src]
    while frontier:
        nxt = []
        for u in frontier:
            for v in range(n):
                if SIG[u][v] and v not in d:
                    d[v] = d[u] + 1
                    nxt.append(v)
        frontier = nxt
    return d

D = [dists(v) for v in range(n)]
print("distance profile from vertex 0:",
      sorted(collections.Counter(D[0].values()).items()))
# passant <=> distance two
print("passant == distance 2 :",
      all((D[i][j] == 2) == PAS[i][j] for i in range(n) for j in range(n) if i != j))

# intersection array
b = {}
c = {}
ok = True
for i in range(n):
    for j in range(n):
        if i == j:
            continue
        k = D[i][j]
        nb_up = sum(1 for v in range(n) if SIG[j][v] and D[i][v] == k + 1)
        nb_dn = sum(1 for v in range(n) if SIG[j][v] and D[i][v] == k - 1)
        if k in b and (b[k], c[k]) != (nb_up, nb_dn):
            ok = False
        b[k], c[k] = nb_up, nb_dn
print("distance-regular:", ok, " b:", [b[i] for i in sorted(b)], " c:", [c[i] for i in sorted(c)])


# ---- clique numbers ------------------------------------------------------------------
def max_clique(adj, verts):
    best = []

    def expand(cur, cand):
        nonlocal best
        if len(cur) + len(cand) <= len(best):
            return
        if not cand:
            if len(cur) > len(best):
                best = list(cur)
            return
        for idx, v in enumerate(cand):
            if len(cur) + len(cand) - idx <= len(best):
                return
            expand(cur + [v], [w for w in cand[idx + 1:] if adj(v, w)])

    expand([], list(verts))
    return best


w = max_clique(lambda i, j: PAS[i][j], range(n))
print("omega(Sigma_2) =", len(w), " witness:", sorted(w))
print("  witness collinear?", LINE_TYPE[join(INTERNAL[w[0]], INTERNAL[w[1]])] == 0
      and len({join(INTERNAL[a], INTERNAL[b]) for a, b in combinations(w, 2)}) == 1)

# arc-restricted clique number: pairwise passant AND no three collinear
def collinear(i, j, k):
    return incident(INTERNAL[k], join(INTERNAL[i], INTERNAL[j]))

best_arc = []
def expand_arc(cur, cand):
    global best_arc
    if len(cur) + len(cand) <= len(best_arc):
        return
    if len(cur) > len(best_arc):
        best_arc = list(cur)
    for idx, v in enumerate(cand):
        if len(cur) + len(cand) - idx <= len(best_arc):
            return
        nxt = [w for w in cand[idx + 1:]
               if PAS[v][w] and all(not collinear(v, w, u) for u in cur)]
        expand_arc(cur + [v], nxt)

expand_arc([], list(range(n)))
print("max pairwise-passant ARC of internal points =", len(best_arc))

# ---- size of the reduced kernel -----------------------------------------------------
# fix one vertex; the search collapses to a max clique in its Sigma_2-neighborhood.
v0 = 0
nbrs = [v for v in range(n) if PAS[v0][v]]
print("Sigma_2-neighborhood of a fixed internal point:", len(nbrs), "vertices")
print("max clique inside that neighborhood:", len(max_clique(lambda i, j: PAS[i][j], nbrs)))

# fix an edge; the search collapses further.
v1 = nbrs[0]
common = [v for v in nbrs if PAS[v1][v]]
print("common Sigma_2-neighbors of a fixed passant-joined pair:", len(common))
print("max clique inside that common neighborhood:",
      len(max_clique(lambda i, j: PAS[i][j], common)))

# ---- group reduction: PGL(2,9) acting as the conic stabilizer -------------------------
# M = [[al,be],[ga,de]] acts on (a:b); the conic point (a^2 : ab : b^2) transforms by the
# symmetric square, which is the projective stabilizer of XZ = Y^2.
def sym_square(al, be, ga, de):
    # a -> al a + be b, b -> ga a + de b
    # X = a^2 -> (al a + be b)^2 = al^2 X + 2 al be Y + be^2 Z
    # Y = ab  -> (al a + be b)(ga a + de b) = al ga X + (al de + be ga) Y + be de Z
    # Z = b^2 -> ga^2 X + 2 ga de Y + de^2 Z
    two = (2, 0)
    return [
        [mul(al, al), mul(two, mul(al, be)), mul(be, be)],
        [mul(al, ga), add(mul(al, de), mul(be, ga)), mul(be, de)],
        [mul(ga, ga), mul(two, mul(ga, de)), mul(de, de)],
    ]


def apply(M, p):
    out = []
    for row in M:
        s = ZERO
        for a, b in zip(row, p):
            s = add(s, mul(a, b))
        out.append(s)
    return normalize(tuple(out))


GROUP = []
seen = set()
for al in F:
    for be in F:
        for ga in F:
            for de in F:
                if add(mul(al, de), tuple((-c) % 3 for c in mul(be, ga))) == ZERO:
                    continue
                M = sym_square(al, be, ga, de)
                key = tuple(normalize(tuple(x for row in M for x in row)[i:i + 3])
                            for i in (0, 3, 6))
                sig = tuple(apply(M, p) for p in INTERNAL)
                if sig in seen:
                    continue
                seen.add(sig)
                GROUP.append(M)
print("conic stabilizer acting faithfully on internal points, order:", len(GROUP))

orb0 = {apply(M, INTERNAL[0]) for M in GROUP}
print("orbit of one internal point:", len(orb0))
STAB = [M for M in GROUP if apply(M, INTERNAL[0]) == INTERNAL[0]]
print("stabilizer of an internal point, order:", len(STAB))

nbrs0 = [v for v in range(n) if PAS[0][v]]
reps = []
covered = set()
for v in nbrs0:
    if v in covered:
        continue
    reps.append(v)
    covered |= {IDX[apply(M, INTERNAL[v])] for M in STAB}
print("Stab-orbits on the 20 passant-neighbors of the fixed point:", len(reps),
      "sizes:", [len({IDX[apply(M, INTERNAL[v])] for M in STAB}) for v in reps])

# the saturated-pencil kernel: after fixing V1, each other vertex is one of the 4 further
# internal points on one of the 5 passants through V1.
pencil = []
for l in LINES:
    if LINE_TYPE[l] == 0 and incident(INTERNAL[0], l):
        pencil.append([IDX[p] for p in INTERNAL if incident(p, l) and p != INTERNAL[0]])
print("passants through the fixed internal point:", len(pencil),
      "further internal points on each:", [len(x) for x in pencil])
from itertools import product as iproduct
tot = 0
good = 0
for choice in iproduct(*pencil):
    tot += 1
    if all(PAS[a][b] for a, b in combinations(choice, 2)):
        good += 1
print("candidate 6-tuples in the saturated-pencil kernel:", tot,
      " surviving pairwise-passant:", good)
