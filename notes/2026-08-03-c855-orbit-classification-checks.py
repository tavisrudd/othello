#!/usr/bin/env python3
"""C855 — computational corroboration for notes/2026-08-03-c855-orbit-classification-proofs.md.

Checks, in order:

  Part 1  A5 <= PGL(3,11) from the Clebsch parity-check columns: group order, determinant-one
          lift, enveloping-algebra rank (Burnside criterion for absolute irreducibility),
          elementwise projective fixed-point counts, the Cauchy-Frobenius orbit count, the
          orbit-length multiset, the subgroup fixed-point table, and the identification of the
          orbits of lengths 6, 10, 15, 12 with the arc, the Brianchon points, the fifteen
          triangle vertices, and the uncovered locus.

  Part 2  Balanced Seidel matrices on six points: the count, the number of switching classes,
          the gauge/pentagon bijection, S6-transitivity, and the stabilizer orders 60 and 120.

  Part 3  The five-valent orbital graph on Omega = A5/C5: suborbit lengths, self-pairing,
          connectivity, the two sign values, and the pentagon gauge with B^2 = 5I.

  Part 4  The golden operator over Q(sqrt 5): U(t_pm) eigenvectors, orthogonality, det(Phi_x)
          = -C(x), the four-dimensional trace annihilator Psi_z, det(Psi_z), the invariant-cubic
          dimension on the four-dimensional representation, and a point count identifying the
          determinant cubic with the Clebsch diagonal cubic over F_11.

  Part 5  The fibre-odd module L^- : rank six, no invariants, B^2 = 5I, tr(rB) = 5, the 3+3
          eigenspace split, rational commutant of dimension two, and the integral commutant.

Replay:  uv run --with sympy python3 notes/2026-08-03-c855-orbit-classification-checks.py
"""

import itertools
import sys
from fractions import Fraction

Q = 11
COLS = [(1, 10, 0), (1, 9, 1), (1, 4, 7), (1, 8, 5), (0, 1, 4), (1, 1, 7)]

OK = []


def check(name, cond, detail=""):
    OK.append(bool(cond))
    print(f"[{'ok ' if cond else 'FAIL'}] {name}{(' — ' + detail) if detail else ''}")


# ---------------------------------------------------------------- projective plane over F_11

def norm(p):
    for c in p:
        if c % Q:
            inv = pow(c % Q, Q - 2, Q)
            return tuple((x * inv) % Q for x in p)
    return None


POINTS = []
seen = set()
for v in itertools.product(range(Q), repeat=3):
    if any(v):
        n = norm(v)
        if n not in seen:
            seen.add(n)
            POINTS.append(n)
POINTS.sort()
PIDX = {p: i for i, p in enumerate(POINTS)}


def det3(a, b, c):
    return (a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])) % Q


def matmul(A, B):
    return tuple(tuple(sum(A[i][k] * B[k][j] for k in range(3)) % Q for j in range(3))
                 for i in range(3))


def act(A, v):
    return norm(tuple(sum(A[i][j] * v[j] for j in range(3)) % Q for i in range(3)))


def detM(A):
    return det3(A[0], A[1], A[2])


def frame_matrix(fr):
    """Matrix sending (e0,e1,e2,e0+e1+e2) to the four points of fr."""
    p0, p1, p2, p3 = fr
    M = [[p0[i], p1[i], p2[i]] for i in range(3)]
    # solve M * lam = p3
    lam = solve3(M, list(p3))
    return tuple(tuple((M[i][j] * lam[j]) % Q for j in range(3)) for i in range(3))


def solve3(M, b):
    A = [row[:] + [b[i]] for i, row in enumerate(M)]
    for c in range(3):
        piv = next(r for r in range(c, 3) if A[r][c] % Q)
        A[c], A[piv] = A[piv], A[c]
        inv = pow(A[c][c] % Q, Q - 2, Q)
        A[c] = [(x * inv) % Q for x in A[c]]
        for r in range(3):
            if r != c and A[r][c] % Q:
                f = A[r][c]
                A[r] = [(A[r][k] - f * A[c][k]) % Q for k in range(4)]
    return [A[i][3] for i in range(3)]


def inv3(A):
    d = detM(A)
    dinv = pow(d, Q - 2, Q)
    cof = [[0] * 3 for _ in range(3)]
    for i in range(3):
        for j in range(3):
            m = [[A[r][c] for c in range(3) if c != j] for r in range(3) if r != i]
            cof[j][i] = ((-1) ** (i + j) * (m[0][0] * m[1][1] - m[0][1] * m[1][0])) % Q
    return tuple(tuple((cof[i][j] * dinv) % Q for j in range(3)) for i in range(3))


def scale_to_det_one(A):
    d = detM(A)
    # cube roots: gcd(3,10)=1 so cubing is a bijection on F_11^*
    for s in range(1, Q):
        if (pow(s, 3, Q) * d) % Q == 1:
            return tuple(tuple((s * A[i][j]) % Q for j in range(3)) for i in range(3))
    raise RuntimeError


print("== Part 1: the A5 point orbits on PG(2,11) ==")

base = COLS[:4]
assert det3(*base[:3]) and det3(base[0], base[1], base[3])
Mbase = frame_matrix(base)
Minv = inv3(Mbase)

group = []
colset = set(norm(c) for c in COLS)
for tgt in itertools.permutations(COLS, 4):
    if det3(*tgt[:3]) == 0 or det3(tgt[0], tgt[1], tgt[3]) == 0:
        continue
    if det3(tgt[0], tgt[2], tgt[3]) == 0 or det3(tgt[1], tgt[2], tgt[3]) == 0:
        continue
    A = matmul(frame_matrix(tgt), Minv)
    if set(act(A, c) for c in COLS) == colset:
        group.append(scale_to_det_one(A))
group = sorted(set(group))
check("projective stabilizer has order 60", len(group) == 60, f"got {len(group)}")
check("determinant-one lift", all(detM(A) == 1 for A in group))
check("closed under multiplication", all(matmul(A, B) in set(group) for A in group[:10] for B in group[:10]))


def order_of(A):
    n, P = 1, A
    I = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    while P != I:
        P = matmul(P, A)
        n += 1
    return n


orders = {}
for A in group:
    orders.setdefault(order_of(A), []).append(A)
check("element order profile 1,2,3,5", sorted((k, len(v)) for k, v in orders.items()) ==
      [(1, 1), (2, 15), (3, 20), (5, 24)], str(sorted((k, len(v)) for k, v in orders.items())))

# enveloping algebra rank (Burnside criterion)
rows = [[A[i][j] for i in range(3) for j in range(3)] for A in group]


def rank_mod(rows, m=Q):
    rows = [r[:] for r in rows]
    r = 0
    ncol = len(rows[0])
    for c in range(ncol):
        piv = next((i for i in range(r, len(rows)) if rows[i][c] % m), None)
        if piv is None:
            continue
        rows[r], rows[piv] = rows[piv], rows[r]
        inv = pow(rows[r][c] % m, m - 2, m)
        rows[r] = [(x * inv) % m for x in rows[r]]
        for i in range(len(rows)):
            if i != r and rows[i][c] % m:
                f = rows[i][c]
                rows[i] = [(rows[i][k] - f * rows[r][k]) % m for k in range(ncol)]
        r += 1
    return r


check("enveloping algebra spans M_3(F_11) (absolute irreducibility)", rank_mod(rows) == 9)


def fixed_points(A):
    return [p for p in POINTS if act(A, p) == p]


fixcount = {A: len(fixed_points(A)) for A in group}
by_order = {}
for A in group:
    by_order.setdefault(order_of(A), set()).add(fixcount[A])
check("fixed-point counts 133/13/1/3", by_order == {1: {133}, 2: {13}, 3: {1}, 5: {3}}, str(by_order))

burnside = sum(fixcount[A] for A in group)
check("Cauchy-Frobenius gives 7 orbits", burnside % 60 == 0 and burnside // 60 == 7,
      f"sum={burnside}")

# orbits
gset = group
orbits = []
left = set(POINTS)
while left:
    p = next(iter(left))
    orb = set()
    frontier = [p]
    while frontier:
        x = frontier.pop()
        if x in orb:
            continue
        orb.add(x)
        for A in gset:
            y = act(A, x)
            if y not in orb:
                frontier.append(y)
    orbits.append(orb)
    left -= orb
lengths = sorted(len(o) for o in orbits)
check("orbit lengths 6,10,12,15,30,30,30", lengths == [6, 10, 12, 15, 30, 30, 30], str(lengths))


# subgroup fixed-point table
def gen_subgroup(elts):
    I = ((1, 0, 0), (0, 1, 0), (0, 0, 1))
    S = {I}
    frontier = list(elts)
    while frontier:
        x = frontier.pop()
        if x in S:
            continue
        S.add(x)
        for y in list(S):
            for z in (matmul(x, y), matmul(y, x)):
                if z not in S:
                    frontier.append(z)
    return frozenset(S)


subs = set()
for A in group:
    subs.add(gen_subgroup([A]))
for A, B in itertools.combinations(group, 2):
    subs.add(gen_subgroup([A, B]))
by_size = {}
for S in subs:
    by_size.setdefault(len(S), []).append(S)


def subgroup_fixed(S):
    return [p for p in POINTS if all(act(A, p) == p for A in S)]


table = {}
for size in sorted(by_size):
    if size in (1, 60):
        continue
    reps = by_size[size]
    fixed = sorted(set(len(subgroup_fixed(S)) for S in reps))
    table[size] = (len(reps), fixed)
print("    subgroup orders -> (#conjugates, fixed-point counts):", table)
check("D5(10): 6 subgroups, 1 fixed point", table.get(10) == (6, [1]))
check("C5(5): 6 subgroups, 3 fixed points", table.get(5) == (6, [3]))
check("S3(6): 10 subgroups, 1 fixed point", table.get(6) == (10, [1]))
check("C3(3): 10 subgroups, 1 fixed point", table.get(3) == (10, [1]))
check("V4(4): 5 subgroups, 3 fixed points", table.get(4) == (5, [3]))
check("A4(12): 5 subgroups, 0 fixed points", table.get(12) == (5, [0]))
check("C2(2): 15 subgroups, 13 fixed points", table.get(2) == (15, [13]))

# exact stabilizer counts
exact = {}
for p in POINTS:
    st = frozenset(A for A in group if act(A, p) == p)
    exact.setdefault(len(st), 0)
    exact[len(st)] += 1
check("exact stabilizer census {10:6, 5:12, 6:10, 4:15, 2:90}",
      exact == {10: 6, 5: 12, 6: 10, 4: 15, 2: 90}, str(exact))

# identify the small orbits
arcpts = set(norm(c) for c in COLS)
chords = []
for i, j in itertools.combinations(range(6), 2):
    a, b = COLS[i], COLS[j]
    line = tuple(((a[1] * b[2] - a[2] * b[1]) % Q, (a[2] * b[0] - a[0] * b[2]) % Q,
                  (a[0] * b[1] - a[1] * b[0]) % Q))
    chords.append(((i, j), norm(line)))


def on_line(p, L):
    return sum(p[i] * L[i] for i in range(3)) % Q == 0


covered = set(arcpts)
for _, L in chords:
    covered |= set(p for p in POINTS if on_line(p, L))
uncovered = set(POINTS) - covered
brianchon = set()
triangle_vertices = set()
for p in POINTS:
    if p in arcpts:
        continue
    thru = [e for e, L in chords if on_line(p, L)]
    if len(thru) == 3:
        brianchon.add(p)
    elif len(thru) == 2:
        triangle_vertices.add(p)
orbsets = [frozenset(o) for o in orbits]
check("uncovered locus is the 12-orbit", frozenset(uncovered) in orbsets and len(uncovered) == 12)
check("arc is the 6-orbit", frozenset(arcpts) in orbsets)
check("Brianchon points are the 10-orbit", frozenset(brianchon) in orbsets and len(brianchon) == 10)
check("triangle vertices are the 15-orbit",
      frozenset(triangle_vertices) in orbsets and len(triangle_vertices) == 15)

print()
print("== Part 2: balanced Seidel matrices on six points ==")

pairs = list(itertools.combinations(range(6), 2))


def build(signs):
    B = [[0] * 6 for _ in range(6)]
    for (i, j), s in zip(pairs, signs):
        B[i][j] = B[j][i] = s
    return tuple(tuple(r) for r in B)


def sq(B):
    return tuple(tuple(sum(B[i][k] * B[k][j] for k in range(6)) for j in range(6)) for i in range(6))


balanced = []
for signs in itertools.product((1, -1), repeat=15):
    B = build(signs)
    S = sq(B)
    if all(S[i][j] == (5 if i == j else 0) for i in range(6) for j in range(6)):
        balanced.append(B)
check("number of balanced Seidel matrices is 384", len(balanced) == 384, str(len(balanced)))


def switch(B, d):
    return tuple(tuple(d[i] * B[i][j] * d[j] for j in range(6)) for i in range(6))


def relabel(B, s):
    return tuple(tuple(B[s[i]][s[j]] for j in range(6)) for i in range(6))


classes = []
seenB = set()
for B in balanced:
    if B in seenB:
        continue
    cl = set()
    for d in itertools.product((1, -1), repeat=6):
        cl.add(switch(B, d))
    classes.append(frozenset(cl))
    seenB |= cl
check("12 switching classes, each of size 32",
      len(classes) == 12 and all(len(c) == 32 for c in classes), str(len(classes)))

# gauge/pentagon bijection
pentagons = set()
for B in balanced:
    d = [1] + [B[0][i] for i in range(1, 6)]
    Bg = switch(B, d)
    assert all(Bg[0][i] == 1 for i in range(1, 6))
    edges = frozenset(frozenset((i, j)) for i, j in itertools.combinations(range(1, 6), 2)
                      if Bg[i][j] == 1)
    deg = [sum(1 for e in edges if i in e) for i in range(1, 6)]
    assert set(deg) == {2} and len(edges) == 5
    pentagons.add(edges)
check("gauge yields exactly the 12 labelled pentagons", len(pentagons) == 12, str(len(pentagons)))

classset = {frozenset(c) for c in classes}
img = set()
for s in itertools.permutations(range(6)):
    B0 = classes[0]
    Bm = relabel(next(iter(B0)), s)
    img.add(next(c for c in classset if Bm in c))
check("S6 is transitive on the 12 switching classes", len(img) == 12, str(len(img)))
stab = sum(1 for s in itertools.permutations(range(6))
           if relabel(next(iter(classes[0])), s) in classes[0])
check("switching-class stabilizer in S6 has order 60", stab == 60, str(stab))
negcl = next(c for c in classset if tuple(tuple(-x for x in r) for r in next(iter(classes[0]))) in c)
check("negation moves the switching class", negcl != frozenset(classes[0]))
pairstab = sum(1 for s in itertools.permutations(range(6))
               if relabel(next(iter(classes[0])), s) in (set(classes[0]) | set(negcl)))
check("stabilizer of the unordered pair {[B],[-B]} has order 120", pairstab == 120, str(pairstab))

print()
print("== Part 3: the five-valent orbital graph on Omega = A5/C5 ==")

A5 = [p for p in itertools.permutations(range(5)) if
      sum(1 for i, j in itertools.combinations(range(5), 2) if p[i] > p[j]) % 2 == 0]


def comp(p, q):
    return tuple(p[q[i]] for i in range(5))


r5 = (1, 2, 3, 4, 0)  # the 5-cycle (0 1 2 3 4)
C5 = [tuple(range(5))]
x = r5
while x != C5[0]:
    C5.append(x)
    x = comp(x, r5)
C5 = set(C5)
cosets = []
for g in A5:
    c = frozenset(comp(g, h) for h in C5)
    if c not in cosets:
        cosets.append(c)
check("Omega has 12 points", len(cosets) == 12)
cidx = {c: i for i, c in enumerate(cosets)}


def act_coset(g, i):
    return cidx[frozenset(comp(g, x) for x in cosets[i])]


base = cidx[frozenset(C5)]
stabbase = [g for g in A5 if act_coset(g, base) == base]
suborb = {}
for i in range(12):
    key = frozenset(act_coset(g, i) for g in stabbase)
    suborb.setdefault(key, None)
sub_lengths = sorted(len(k) for k in suborb)
check("suborbit lengths 1,1,5,5", sub_lengths == [1, 1, 5, 5], str(sub_lengths))

five = [k for k in suborb if len(k) == 5]
G1 = {i: set() for i in range(12)}
orb0 = sorted(five[0])
for g in A5:
    gi = act_coset(g, base)
    for w in orb0:
        G1[gi].add(act_coset(g, w))
check("orbital graph is 5-regular", all(len(v) == 5 for v in G1.values()))
check("orbital graph is symmetric (self-paired)",
      all(i in G1[j] for i in range(12) for j in G1[i]))
comp_set = {base}
frontier = [base]
while frontier:
    x = frontier.pop()
    for y in G1[x]:
        if y not in comp_set:
            comp_set.add(y)
            frontier.append(y)
check("orbital graph is connected", len(comp_set) == 12, str(len(comp_set)))

# deck involution: right multiplication by an involution of D5 normalising C5
t = None
for g in A5:
    if comp(g, g) == tuple(range(5)) and g != tuple(range(5)):
        if set(comp(g, comp(h, g)) for h in C5) == C5:
            t = g
            break
check("D5 normaliser gives a deck involution", t is not None)


def deck(i):
    return cidx[frozenset(comp(x, t) for x in cosets[i])]


check("deck is a fixed-point-free involution",
      all(deck(deck(i)) == i and deck(i) != i for i in range(12)))
check("deck is A5-equivariant",
      all(deck(act_coset(g, i)) == act_coset(g, deck(i)) for g in A5 for i in range(12)))
check("antipode is not adjacent", all(deck(i) not in G1[i] for i in range(12)))

lifts = [base] + sorted(G1[base])
axes = {}
for a, w in enumerate(lifts):
    axes[w] = (a, 1)
    axes[deck(w)] = (a, -1)
check("the six lifts cover all six axes", len(axes) == 12)
Bo = [[0] * 6 for _ in range(6)]
for a, w in enumerate(lifts):
    for u in G1[w]:
        b, s = axes[u]
        Bo[a][b] = s
check("B has zero diagonal and unit entries",
      all(Bo[i][i] == 0 for i in range(6)) and
      all(abs(Bo[i][j]) == 1 for i in range(6) for j in range(6) if i != j))
check("B is symmetric", all(Bo[i][j] == Bo[j][i] for i in range(6) for j in range(6)))
check("B_{0i} = 1 gauge", all(Bo[0][i] == 1 for i in range(1, 6)))
Bt = tuple(tuple(r) for r in Bo)
check("B^2 = 5I", sq(Bt) == tuple(tuple(5 if i == j else 0 for j in range(6)) for i in range(6)))
inner = [[Bo[i][j] for j in range(1, 6)] for i in range(1, 6)]
vals = set(inner[i][j] for i in range(5) for j in range(5) if i != j)
check("both signs occur among the inner entries", vals == {1, -1})
posedges = frozenset(frozenset((i, j)) for i, j in itertools.combinations(range(1, 6), 2)
                     if Bo[i][j] == 1)
check("positive inner edges form a pentagon",
      len(posedges) == 5 and all(sum(1 for e in posedges if v in e) == 2 for v in range(1, 6)))

print()
print("== Part 4: golden operator, trace annihilator, invariant cubic ==")

import sympy as sp

# the manuscript's displayed gauge; Part 3 derived a pentagon gauge from the orbital, and the two
# are switching-and-relabelling equivalent by Target 2.
BPAPER = ((0, 1, 1, 1, 1, 1),
          (1, 0, 1, 1, -1, -1),
          (1, 1, 0, -1, 1, -1),
          (1, 1, -1, 0, -1, 1),
          (1, -1, 1, -1, 0, 1),
          (1, -1, -1, 1, 1, 0))
equivalent = any(relabel(switch(Bt, d), s) == BPAPER
                 for d in itertools.product((1, -1), repeat=6)
                 for s in itertools.permutations(range(6)))
check("orbital-derived B is equivalent to the manuscript gauge", equivalent)

s5 = sp.sqrt(5)
Bs = sp.Matrix(6, 6, lambda i, j: BPAPER[i][j])
check("sympy B^2 = 5I", sp.simplify(Bs * Bs - 5 * sp.eye(6)) == sp.zeros(6, 6))
Cco = {}
for i, j, k in itertools.combinations(range(6), 3):
    Cco[(i, j, k)] = BPAPER[i][j] * BPAPER[j][k] * BPAPER[k][i]
check("triangle products are +-1 and not constant", set(Cco.values()) == {1, -1})
check("complementary triples have opposite products",
      all(Cco[tri] == -Cco[tuple(sorted(set(range(6)) - set(tri)))]
          for tri in Cco))

x = sp.symbols('x0:6')
Cpoly = sum(Cco[t] * x[t[0]] * x[t[1]] * x[t[2]] for t in Cco)
tt = sp.symbols('t')
Dx = sp.diag(*x)
pencil = sp.expand((Bs + Dx).det())
e = [sp.expand(sp.Poly(sp.prod([1 + tt * xi for xi in x]), tt).coeff_monomial(tt ** k))
     for k in range(7)]
rhs = sp.expand(e[6] - e[4] + 5 * e[2] - 125 - 2 * Cpoly)
check("det(B + diag x) = e6 - e4 + 5e2 - 125 - 2C", sp.expand(pencil - rhs) == 0)

# the eigenvector blocks
tp = (1 + s5) / 2
tm = (1 - s5) / 2


def U(t):
    return sp.Matrix([[t, t, -1], [t, 1, -t], [1, t, -t], [1, 0, 0], [0, 1, 0], [0, 0, 1]])


Up, Um = U(tp), U(tm)
check("B U(t+) = +sqrt5 U(t+)", sp.simplify(Bs * Up - s5 * Up) == sp.zeros(6, 3))
check("B U(t-) = -sqrt5 U(t-)", sp.simplify(Bs * Um + s5 * Um) == sp.zeros(6, 3))
check("U(t-)^T U(t+) = 0", sp.simplify(Um.T * Up) == sp.zeros(3, 3))

Phi = sp.simplify(Um.T * Dx * Up)
check("det(Phi_x) = -C(x)", sp.expand(sp.simplify(Phi.det() + Cpoly)) == 0)
Phi1 = sp.simplify(Phi.subs({xi: 1 for xi in x}))
check("Phi is translation invariant", Phi1 == sp.zeros(3, 3))

z = sp.symbols('z0:4')
a_z = (s5 - 1) * z[0] + sp.Rational(1, 1) * (3 - s5) / 2 * z[1] + (s5 - 5) / 2 * z[2] + (s5 - 1) * z[3]
b_z = (s5 - 5) / 2 * z[0] + (1 - s5) * z[1] + (s5 - 1) * z[2] + (s5 - 3) / 2 * z[3]
Psi = sp.Matrix([[0, a_z, b_z], [z[0], 0, z[1]], [z[2], z[3], 0]])
tr = sp.expand(sp.simplify((Psi * Phi).trace()))
check("tr(Psi_z Phi_x) vanishes identically", sp.simplify(tr) == 0)
detPsi = sp.expand(sp.simplify(Psi.det() - (a_z * z[1] * z[2] + b_z * z[0] * z[3])))
check("det(Psi_z) = a z1 z2 + b z0 z3", detPsi == 0)
val = sp.simplify(Psi.det().subs({z[0]: 1, z[1]: 0, z[2]: 0, z[3]: 1}))
check("det at z=(1,0,0,1) equals sqrt5 - 4", sp.simplify(val - (s5 - 4)) == 0)

# the annihilator has dimension exactly four
basis9 = [sp.Matrix(3, 3, lambda i, j: 1 if (i, j) == (r, c) else 0)
          for r in range(3) for c in range(3)]
rows = []
for M in basis9:
    tr_M = sp.expand(sp.simplify((M * Phi).trace()))
    rows.append([sp.simplify(tr_M.coeff(xi)) for xi in x])
Amat = sp.Matrix(rows)
check("trace-annihilator has dimension four", 9 - Amat.rank() == 4, f"rank={Amat.rank()}")

# invariant cubics on the standard four-dimensional representation
gens5 = [(1, 2, 0, 3, 4), (0, 2, 3, 4, 1)]  # a 3-cycle and a 5-cycle, both even
y = sp.symbols('y0:4')
subsmap = {}
# coordinates: w_i = y_i for i<4, w_4 = -(y0+..+y3) on the hyperplane sum = 0
w = list(y) + [-sum(y)]
monos = [m for m in itertools.combinations_with_replacement(range(4), 3)]
check("Sym^3 of a four-space has dimension 20", len(monos) == 20)


def cubic_action(g):
    """matrix of g acting on cubics in y, via permutation of the five w-coordinates"""
    # g permutes positions: new w_i = w_{g^{-1}(i)}; express y_i' in terms of y
    ginv = [0] * 5
    for i, gi in enumerate(g):
        ginv[gi] = i
    wnew = [w[ginv[i]] for i in range(5)]
    ymap = {y[i]: sp.expand(wnew[i]) for i in range(4)}
    rows = []
    for m in monos:
        p = sp.expand(sp.prod([ymap[y[i]] for i in m]))
        pd = sp.Poly(p, *y).as_dict()
        col = []
        for mm in monos:
            expo = [0, 0, 0, 0]
            for i in mm:
                expo[i] += 1
            col.append(pd.get(tuple(expo), 0))
        rows.append(col)
    return sp.Matrix(rows).T


Mg = [cubic_action(g) for g in gens5]
stackrows = []
for M in Mg:
    D = M - sp.eye(20)
    stackrows.extend(D.tolist())
Inv = sp.Matrix(stackrows)
check("invariant cubics on the four-dimensional representation form a line",
      20 - Inv.rank() == 1, f"dim={20 - Inv.rank()}")

# Clebsch identification over F_11 (sqrt 5 = 4)
r5f = 4
assert (r5f * r5f) % 11 == 5


def a_f(zz):
    return ((r5f - 1) * zz[0] + (3 - r5f) * pow(2, 9, 11) * zz[1]
            + (r5f - 5) * pow(2, 9, 11) * zz[2] + (r5f - 1) * zz[3]) % 11


def b_f(zz):
    return ((r5f - 5) * pow(2, 9, 11) * zz[0] + (1 - r5f) * zz[1]
            + (r5f - 1) * zz[2] + (r5f - 3) * pow(2, 9, 11) * zz[3]) % 11


cnt = 0
for zz in itertools.product(range(11), repeat=4):
    if not any(zz):
        continue
    if (a_f(zz) * zz[1] * zz[2] + b_f(zz) * zz[0] * zz[3]) % 11 == 0:
        cnt += 1
cnt //= 10
cl = 0
for zz in itertools.product(range(11), repeat=5):
    if not any(zz) or sum(zz) % 11:
        continue
    if sum(v ** 3 for v in zz) % 11 == 0:
        cl += 1
cl //= 10
check("determinant cubic and Clebsch diagonal cubic have the same F_11 point count",
      cnt == cl == 11 * 11 + 7 * 11 + 1, f"{cnt} vs {cl}")

print()
print("== Part 5: the fibre-odd module L^- ==")

rho = {}
for g in A5:
    M = [[0] * 6 for _ in range(6)]
    for b, wl in enumerate(lifts):
        img = act_coset(g, wl)
        aa, ss = axes[img]
        M[aa][b] = ss
    rho[g] = sp.Matrix(M)
check("rho is a homomorphism",
      all(rho[comp(g, h)] == rho[g] * rho[h] for g in A5[:12] for h in A5[:12]))
Borb0 = sp.Matrix(6, 6, lambda i, j: Bt[i][j])
check("B commutes with the action", all(rho[g] * Borb0 == Borb0 * rho[g] for g in A5))
inv_dim = 6 - sp.Matrix([row for g in A5 for row in (rho[g] - sp.eye(6)).tolist()]).rank()
check("L^- has no invariants", inv_dim == 0, f"dim={inv_dim}")
rr = next(g for g in A5 if comp(comp(comp(comp(g, g), g), g), g) == tuple(range(5))
          and g != tuple(range(5)))
Borb = sp.Matrix(6, 6, lambda i, j: Bt[i][j])
trrb = sp.simplify((rho[rr] * Borb).trace())
check("tr(rB) = +-5 for r of order five (nonzero away from characteristic five)",
      abs(trrb) == 5, str(trrb))
ep = (Borb - s5 * sp.eye(6)).rank()
check("the two golden eigenspaces are three-dimensional", 6 - ep == 3, f"dim={6 - ep}")

# rational commutant dimension
E = [sp.Matrix(6, 6, lambda i, j: 1 if (i, j) == (r, c) else 0) for r in range(6) for c in range(6)]
cols = []
for M in E:
    col = []
    for g in A5:
        D = M * rho[g] - rho[g] * M
        col.extend(D.reshape(36, 1).T.tolist()[0])
    cols.append(col)
Cm = sp.Matrix(cols).T
check("rational commutant has dimension two", 36 - Cm.rank() == 2, f"dim={36 - Cm.rank()}")

print()
print(f"{sum(OK)}/{len(OK)} checks passed")
sys.exit(0 if all(OK) else 1)
