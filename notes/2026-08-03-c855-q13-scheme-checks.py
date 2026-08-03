#!/usr/bin/env python3
"""Bounded computational confirmation for C855 / notes/2026-08-03-c855-q13-scheme-proofs.md.

Everything is built from scratch over F_13: the conic C: XZ - Y^2 = 0 in PG(2,13),
the invariant Delta(x,y,z) = y^2 - xz, its polarisation beta, the internal/external
split, the passant/secant/tangent line split, the six-class rho-scheme on the 78
internal points, the F_2 kernel K = ker M, and the minimum-weight layer of K.

Working notes (kept here rather than in extra files):

* Coordinates.  Points and lines of PG(2,13) are normalised triples (first nonzero
  entry 1); 183 of each.  beta(P,X) = 2 y_P y_X - x_P z_X - z_P x_X, so the polar of
  P = (x,y,z) is the line with coefficient triple (-z, 2y, -x), and the pole of a line
  (l0,l1,l2) is (-l2, l1/2, -l0).
* rho(P,Q) = beta(P,Q)^2 / (Delta(P) Delta(Q)) is a projective invariant of the
  unordered pair; on the diagonal it equals 4, which is why 4 is excluded from the
  relation values.
* Chart (star): for internal P (fixed representative, d = Delta(P)) and Q with
  beta(P,Q) != 0, rescale Q so that Q = P + w with beta(P,w) = 0.  Then u = Delta(w)/d
  satisfies beta(P,Q) = 2d, Delta(Q) = d(1+u), rho = 4/(1+u).  Checked for every
  ordered internal pair, not just one P.
* Gamma_r(P) = {X : beta(P,X)^2 - r Delta(P) Delta(X) = 0}; tangent lines are obtained
  from the polarisation of that quadratic form, and their poles w.r.t. C are compared
  against the note's Y_R = 2 beta(P,R) P - r Delta(P) R.
* Minimum-weight layer.  The 364 weight-12 words live in K = ker A_0 (dim 36, length
  78), not in the row space of M (A_0^3 = A_0 splits F_2^78 as im(A_0) + K).  The
  enumeration is EXHAUSTIVE, not a search: two disjoint information sets I1, I2 of K
  are found inside the 78 coordinates; any word of weight <= 12 has weight <= 6 on at
  least one of them, hence is a combination of at most 6 rows of the corresponding
  systematic generator.  Enumerating all C(36,<=6) combinations for both information
  sets therefore sees every word of weight <= 12.
* PGL(2,13) is realised on the conic by the symmetric square of its action on P^1:
  g = [[a,b],[c,d]] |-> [[a^2, 2ab, b^2], [ac, ad+bc, bd], [c^2, 2cd, d^2]].

Run:  python3 notes/2026-08-03-c855-q13-scheme-checks.py
No third-party dependencies; pure integer / bitmask F_2 arithmetic.
"""

import itertools
import sys
import time

Q = 13
SQUARES = frozenset((i * i) % Q for i in range(1, Q))          # {1,3,4,9,10,12}
NONSQUARES = frozenset(set(range(1, Q)) - SQUARES)             # {2,5,6,7,8,11}
INV = [0] + [pow(i, Q - 2, Q) for i in range(1, Q)]
RELS = [0, 1, 3, 9, 10, 12]

RESULTS = []


def check(name, ok, detail=""):
    RESULTS.append((name, bool(ok), detail))
    print(("PASS  " if ok else "FAIL  ") + name + (("   | " + detail) if detail else ""))


def info(name, detail):
    print("INFO  " + name + "   | " + detail)


# ---------------------------------------------------------------- geometry ----

def normalise(v):
    for c in v:
        if c % Q:
            s = INV[c % Q]
            return tuple((s * x) % Q for x in v)
    return None


def delta(P):
    x, y, z = P
    return (y * y - x * z) % Q


def beta(P, R):
    return (2 * P[1] * R[1] - P[0] * R[2] - P[2] * R[0]) % Q


POINTS = []
seen = set()
for x in range(Q):
    for y in range(Q):
        for z in range(Q):
            n = normalise((x, y, z))
            if n is not None and n not in seen:
                seen.add(n)
                POINTS.append(n)
POINTS.sort()
PIDX = {p: i for i, p in enumerate(POINTS)}

CONIC = [p for p in POINTS if delta(p) == 0]
INTERNAL = [p for p in POINTS if delta(p) in NONSQUARES]
EXTERNAL = [p for p in POINTS if delta(p) in SQUARES]
IIDX = {p: i for i, p in enumerate(INTERNAL)}
NI = len(INTERNAL)

LINES = list(POINTS)                                  # same normalised triples
def on(line, pt):
    return (line[0] * pt[0] + line[1] * pt[1] + line[2] * pt[2]) % Q == 0

LINE_CONIC = {L: sum(1 for p in CONIC if on(L, p)) for L in LINES}
PASSANT = [L for L in LINES if LINE_CONIC[L] == 0]
TANGENT = [L for L in LINES if LINE_CONIC[L] == 1]
SECANT = [L for L in LINES if LINE_CONIC[L] == 2]


def polar(P):
    return normalise((-P[2] % Q, 2 * P[1] % Q, -P[0] % Q))


def pole(L):
    return normalise((-L[2] % Q, (L[1] * INV[2]) % Q, -L[0] % Q))


print("=" * 78)
print("C855 q=13 passant-scheme confirmation")
print("=" * 78)

check("point counts 183 = 14 conic + 78 internal + 91 external",
      len(POINTS) == 183 and len(CONIC) == 14 and NI == 78 and len(EXTERNAL) == 91,
      "%d / %d / %d / %d" % (len(POINTS), len(CONIC), NI, len(EXTERNAL)))
check("line counts 183 = 14 tangent + 78 passant + 91 secant",
      len(TANGENT) == 14 and len(PASSANT) == 78 and len(SECANT) == 91,
      "%d / %d / %d" % (len(TANGENT), len(PASSANT), len(SECANT)))

# (G1)/(G2)
g1 = all((delta(pole(L)) in NONSQUARES) for L in PASSANT) and \
     all((delta(pole(L)) in SQUARES) for L in SECANT) and \
     all(delta(pole(L)) == 0 for L in TANGENT)
check("(G2) pole of passant internal, pole of secant external", g1)

pass_counts = set()
sec_int = set()
for L in PASSANT:
    pass_counts.add((sum(1 for p in INTERNAL if on(L, p)),
                     sum(1 for p in EXTERNAL if on(L, p))))
for L in SECANT:
    sec_int.add(sum(1 for p in INTERNAL if on(L, p)))
tan_int = set(sum(1 for p in INTERNAL if on(L, p)) for L in TANGENT)
check("(G2) passant carries 7 internal + 7 external", pass_counts == {(7, 7)}, str(sorted(pass_counts)))
check("(G2) secant carries 6 internal", sec_int == {6}, str(sorted(sec_int)))
check("(G2) internal points lie on no tangent", tan_int == {0}, str(sorted(tan_int)))
check("polar of an internal point is passant",
      all(LINE_CONIC[polar(P)] == 0 for P in INTERNAL))

# ---------------------------------------------------- target 1: rho and chart --

def rho(P, R):
    b = beta(P, R)
    return (b * b * INV[(delta(P) * delta(R)) % Q]) % Q


RHO = [[0] * NI for _ in range(NI)]
for i, P in enumerate(INTERNAL):
    for j, R in enumerate(INTERNAL):
        RHO[i][j] = rho(P, R)

offdiag = set()
for i in range(NI):
    for j in range(NI):
        if i != j:
            offdiag.add(RHO[i][j])
diag = set(RHO[i][i] for i in range(NI))
check("target 1(a): six relation values {0,1,3,9,10,12}", offdiag == set(RELS), str(sorted(offdiag)))
check("target 1(a): rho = 4 only on the diagonal", diag == {4} and 4 not in offdiag)

# chart (star): every ordered pair with beta != 0
chart_ok = True
u_to_rho = {}
for P in INTERNAL:
    d = delta(P)
    for R in INTERNAL:
        b = beta(P, R)
        if b == 0 or R == P:            # w = 0 (u = 0, rho = 4) is the diagonal
            continue
        a = (b * INV[(2 * d) % Q]) % Q                    # P-coefficient of R
        Rs = tuple((INV[a] * c) % Q for c in R)           # rescaled: Rs = P + w
        w = tuple((Rs[k] - P[k]) % Q for k in range(3))
        if beta(P, w) != 0:
            chart_ok = False
        u = (delta(w) * INV[d]) % Q
        if beta(P, Rs) != (2 * d) % Q:
            chart_ok = False
        if delta(Rs) != (d * (1 + u)) % Q:
            chart_ok = False
        if (1 + u) % Q == 0 or (4 * INV[(1 + u) % Q]) % Q != rho(P, R):
            chart_ok = False
        u_to_rho.setdefault(u, set()).add(rho(P, R))
check("target 1: chart (star) beta=2d, Delta(Q)=d(1+u), rho=4/(1+u) for all off-polar pairs",
      chart_ok)
u_map = {u: sorted(v)[0] for u, v in sorted(u_to_rho.items())}
check("target 1(b): u in {2,3,8,9,11} with rho = 10,1,12,3,9",
      u_map == {2: 10, 3: 1, 8: 12, 9: 3, 11: 9} and all(len(v) == 1 for v in u_to_rho.values()),
      str(u_map))

VAL = {r: None for r in RELS}
val_ok = True
for r in RELS:
    ks = set(sum(1 for j in range(NI) if RHO[i][j] == r) for i in range(NI))
    if len(ks) != 1:
        val_ok = False
    VAL[r] = sorted(ks)[0]
check("target 1(c): valencies (k_0,k_1,k_3,k_9,k_10,k_12) = (7,14,14,14,14,14)",
      val_ok and [VAL[r] for r in RELS] == [7, 14, 14, 14, 14, 14],
      str([VAL[r] for r in RELS]) + ", sum+1 = %d" % (1 + sum(VAL.values())))

# rho = 0 <=> Q on the polar of P
zero_ok = all(((RHO[i][j] == 0) == on(polar(INTERNAL[i]), INTERNAL[j]))
              for i in range(NI) for j in range(NI))
check("target 1(c): rho = 0 <=> incidence with the passant polar", zero_ok)


def line_through(P, R):
    l = ((P[1] * R[2] - P[2] * R[1]) % Q,
         (P[2] * R[0] - P[0] * R[2]) % Q,
         (P[0] * R[1] - P[1] * R[0]) % Q)
    return normalise(l)


join_type = {r: set() for r in RELS}
for i in range(NI):
    for j in range(NI):
        if i == j:
            continue
        L = line_through(INTERNAL[i], INTERNAL[j])
        join_type[RHO[i][j]].add(LINE_CONIC[L])
check("target 1(d): secant-type relations {0,1,3}, passant-type {9,10,12}",
      all(join_type[r] == {2} for r in (0, 1, 3)) and all(join_type[r] == {0} for r in (9, 10, 12)),
      str({r: sorted(join_type[r]) for r in RELS}))
check("target 1(d): rho-4 square <=> secant join",
      all((((r - 4) % Q) in SQUARES) == (sorted(join_type[r])[0] == 2) for r in RELS),
      str({r: (r - 4) % Q for r in RELS}))

# ------------------------------------------------------- F_2 linear algebra ----

def mat_mul(A, B, n):
    out = []
    for row in A:
        acc = 0
        rr = row
        j = 0
        while rr:
            if rr & 1:
                acc ^= B[j]
            rr >>= 1
            j += 1
        out.append(acc)
    return out


def rref(rows, n):
    rows = list(rows)
    piv = []
    r = 0
    for c in range(n):
        bit = 1 << c
        sel = None
        for k in range(r, len(rows)):
            if rows[k] & bit:
                sel = k
                break
        if sel is None:
            continue
        rows[r], rows[sel] = rows[sel], rows[r]
        for k in range(len(rows)):
            if k != r and (rows[k] & bit):
                rows[k] ^= rows[r]
        piv.append(c)
        r += 1
        if r == len(rows):
            break
    return rows[:r], piv


def rank2(rows, n):
    return len(rref(rows, n)[1])


def nullspace(rows, n):
    red, piv = rref(rows, n)
    pivset = set(piv)
    basis = []
    for f in range(n):
        if f in pivset:
            continue
        v = 1 << f
        for idx, c in enumerate(piv):
            if red[idx] & (1 << f):
                v |= 1 << c
        basis.append(v)
    return basis


IDENT = [1 << i for i in range(NI)]
A = {}
for r in RELS:
    A[r] = [sum(1 << j for j in range(NI) if RHO[i][j] == r) for i in range(NI)]

# M : internal points x passant lines.  Relabelling each passant line by its
# (internal) pole turns M into A_0 on the nose.
M = [sum(1 << k for k, L in enumerate(PASSANT) if on(L, P)) for P in INTERNAL]
Mrelab = [sum(1 << IIDX[pole(L)] for L in PASSANT if on(L, P)) for P in INTERNAL]
check("A_0 = M after relabelling passant lines by their poles (polarity identification)",
      Mrelab == A[0])

# ---------------------------------------------- target 2: mod-2 intersection ---

A0 = A[0]
A0sq = mat_mul(A0, A0, NI)
rhs = [IDENT[i] ^ A[9][i] ^ A[10][i] ^ A[12][i] for i in range(NI)]
check("2.1  A_0^2 = I + A_9 + A_10 + A_12", A0sq == rhs)

for r in (9, 10, 12):
    check("2.2  A_0 A_%d = 0 over F_2" % r, mat_mul(A0, A[r], NI) == [0] * NI)

law_ok = True
law_detail = []
for r in RELS:
    if r == 0:
        continue
    t = ((r - 2) * (r - 2)) % Q
    sq = mat_mul(A[r], A[r], NI)
    ok = (sq == A[t])
    law_ok &= ok
    law_detail.append("A_%d^2=A_%d:%s" % (r, t, "ok" if ok else "NO"))
check("2.3  general law A_r^2 = A_{(r-2)^2} for every r != 0", law_ok, " ".join(law_detail))
check("2.3  Frobenius 3-cycle A_9^2=A_10, A_10^2=A_12, A_12^2=A_9",
      mat_mul(A[9], A[9], NI) == A[10] and mat_mul(A[10], A[10], NI) == A[12]
      and mat_mul(A[12], A[12], NI) == A[9])
check("2.3  bonus A_1^2 = A_1 and A_3^2 = A_1",
      mat_mul(A[1], A[1], NI) == A[1] and mat_mul(A[3], A[3], NI) == A[1])
check("2.4  A_0^3 = A_0", mat_mul(A0sq, A0, NI) == A0)

rank_M = rank2(M, len(PASSANT))
K = nullspace(A0, NI)
dimK = len(K)
check("rank_2 M = 42", rank_M == 42, "computed %d" % rank_M)
check("dim_F2 ker M = 36", dimK == 36, "computed %d" % dimK)
check("rank_2 A_0 = rank_2 M", rank2(A0, NI) == rank_M)
ranks = {r: rank2(A[r], NI) for r in (9, 10, 12)}
check("rank_2 A_9 = rank_2 A_10 = rank_2 A_12 = dim K = 36",
      set(ranks.values()) == {dimK}, str(ranks))
check("F_2^78 = im(A_0) + ker(A_0) (direct sum)", rank_M + dimK == NI)

# K_1 = ker(B+I) restricted to K, B = A_9
Bpl = [A[9][i] ^ IDENT[i] for i in range(NI)]
kerBI = nullspace(Bpl, NI)
Krows, _ = rref(K, NI)
Kset_rank = rank2(K, NI)
inter = rank2(Krows + kerBI, NI)
dim_K1 = Kset_rank + len(kerBI) - inter          # dim of K cap ker(B+I)
check("2.4  K_1 = ker(B+I) cap K is zero (hidden-field hypothesis)", dim_K1 == 0,
      "dim K_1 = %d, dim ker(B+I) = %d" % (dim_K1, len(kerBI)))
check("2.4  3 | dim K, so K = F_8^12", dimK % 3 == 0 and dimK // 3 == 12)

# every x in K has even weight, so Jx = 0 and hence (A_1+A_3)x = 0
A13 = [A[1][i] ^ A[3][i] for i in range(NI)]
check("2.4  every x in K has even weight (J x = 0)",
      all(bin(v).count("1") % 2 == 0 for v in K))
check("2.4  (A_1 + A_3) x = 0 for all x in K",
      all(mat_mul([v], A13, NI) == [0] for v in K))

# ------------------------------------- targets 4/5: intersection numbers, group -

def p_number(r, s, t):
    """p^r_{s,t}: for a fixed pair (P,Q) with rho = r, the number of R with
    rho(P,R) = s and rho(Q,R) = t.  Returns the set of observed values."""
    vals = set()
    for i in range(NI):
        for j in range(NI):
            if i != j and RHO[i][j] == r:
                vals.add(sum(1 for k in range(NI)
                             if k != i and k != j and RHO[i][k] == s and RHO[j][k] == t))
    return vals


p1039 = p_number(10, 3, 9)
check("target 4: p^10_{3,9} is well defined (scheme) and equals 2",
      p1039 == {2}, "observed %s" % sorted(p1039))

triples = 0
for i in range(NI):
    for j in range(NI):
        if RHO[i][j] != 10:
            continue
        for k in range(NI):
            if RHO[i][k] == 3 and RHO[j][k] == 9:
                triples += 1
check("target 4(A): 2184 ordered triples with pattern (10,3,9)", triples == 2184,
      "computed %d = 1092 * %s" % (triples, triples / 1092))


def mat3_mul(X, Y):
    return tuple(tuple(sum(X[i][k] * Y[k][j] for k in range(3)) % Q for j in range(3))
                 for i in range(3))


def mat3_norm(X):
    flat = [X[i][j] for i in range(3) for j in range(3)]
    for c in flat:
        if c % Q:
            s = INV[c % Q]
            return tuple(tuple((s * X[i][j]) % Q for j in range(3)) for i in range(3))
    return None


def act(X, P):
    return normalise(tuple(sum(X[i][k] * P[k] for k in range(3)) % Q for i in range(3)))


GROUP = []
seen_g = set()
for a in range(Q):
    for b in range(Q):
        for c in range(Q):
            for d in range(Q):
                if (a * d - b * c) % Q == 0:
                    continue
                # normalise the 2x2 matrix projectively
                flat = (a, b, c, d)
                s = None
                for e in flat:
                    if e % Q:
                        s = INV[e % Q]
                        break
                nf = tuple((s * e) % Q for e in flat)
                if nf in seen_g:
                    continue
                seen_g.add(nf)
                aa, bb, cc, dd = nf
                GROUP.append(((aa * aa % Q, 2 * aa * bb % Q, bb * bb % Q),
                              (aa * cc % Q, (aa * dd + bb * cc) % Q, bb * dd % Q),
                              (cc * cc % Q, 2 * cc * dd % Q, dd * dd % Q)))
check("|PGL(2,13)| = 2184 acting on the conic", len(GROUP) == 2184, "%d" % len(GROUP))

GPERM = []
for g in GROUP:
    perm = [IIDX[act(g, P)] for P in INTERNAL]
    GPERM.append(perm)
check("PGL(2,13) permutes the 78 internal points",
      all(sorted(p) == list(range(NI)) for p in GPERM))

# generators of PGL(2,13): x -> x+1, x -> 2x (2 is primitive mod 13), x -> 1/x
GEN2 = [((1, 1), (0, 1)), ((2, 0), (0, 1)), ((0, 1), (1, 0))]
GENPERM = []
for (aa, bb), (cc, dd) in GEN2:
    g = ((aa * aa % Q, 2 * aa * bb % Q, bb * bb % Q),
         (aa * cc % Q, (aa * dd + bb * cc) % Q, bb * dd % Q),
         (cc * cc % Q, 2 * cc * dd % Q, dd * dd % Q))
    GENPERM.append([IIDX[act(g, P)] for P in INTERNAL])
check("rho is PGL(2,13)-invariant (checked on all pairs for the three generators)",
      all(RHO[p[i]][p[j]] == RHO[i][j] for p in GENPERM for i in range(NI) for j in range(NI)))
gen_closure = {tuple(range(NI))}
frontier = [tuple(range(NI))]
while frontier:
    y = frontier.pop()
    for p in GENPERM:
        z = tuple(p[y[i]] for i in range(NI))
        if z not in gen_closure:
            gen_closure.add(z)
            frontier.append(z)
check("the three generators generate the full image of PGL(2,13) on internal points",
      len(gen_closure) == 2184, "%d" % len(gen_closure))

stab0 = [p for p in GPERM if p[0] == 0]
check("point stabiliser has order 28 (D_28, normaliser of a nonsplit torus)",
      len(stab0) == 28, "%d" % len(stab0))
orb_sizes = []
unseen = set(range(NI))
while unseen:
    x = min(unseen)
    orb = {x}
    frontier = [x]
    while frontier:
        y = frontier.pop()
        for p in stab0:
            z = p[y]
            if z not in orb:
                orb.add(z)
                frontier.append(z)
    orb_sizes.append(len(orb))
    unseen -= orb
check("target 4/5: rank 7 -- stabiliser orbits are 1, 7, 14, 14, 14, 14, 14",
      sorted(orb_sizes) == [1, 7, 14, 14, 14, 14, 14], str(sorted(orb_sizes)))

# ------------------------------- tangent-pole lemma / Gamma_r(P) rational points

P0 = INTERNAL[0]
d0 = delta(P0)
gamma_ok = True
tangent_ok = True
pole_formula_ok = True
gamma_sizes = {}
for r in RELS:
    if r == 0:
        continue
    pts = [X for X in POINTS if (beta(P0, X) ** 2 - r * d0 * delta(X)) % Q == 0]
    gamma_sizes[r] = len(pts)
    if len(pts) != 14 or any(delta(X) not in NONSQUARES for X in pts):
        gamma_ok = False
    if set(IIDX[X] for X in pts) != set(j for j in range(NI) if RHO[0][j] == r):
        gamma_ok = False
    for R in pts:
        # tangent line to Gamma_r at R via the polarisation of F
        def F(X):
            return (beta(P0, X) ** 2 - r * d0 * delta(X)) % Q
        coeffs = []
        for e in ((1, 0, 0), (0, 1, 0), (0, 0, 1)):
            RE = tuple((R[k] + e[k]) % Q for k in range(3))
            coeffs.append((F(RE) - F(R) - F(e)) % Q)
        L = normalise(tuple(coeffs))
        YR = normalise(tuple((2 * beta(P0, R) * P0[k] - r * d0 * R[k]) % Q for k in range(3)))
        if pole(L) != YR:
            pole_formula_ok = False
        want_passant = r in (1, 3)
        if (LINE_CONIC[L] == 0) != want_passant:
            tangent_ok = False
check("Gamma_r(P) has exactly 14 rational points = the r-neighbourhood, all internal",
      gamma_ok, str(gamma_sizes))
check("tangent-pole lemma: pole of the tangent at R equals 2 beta(P,R) P - r Delta(P) R",
      pole_formula_ok)
check("tangent-pole lemma: tangents of Gamma_r passant iff r in {1,3}, secant iff r in {9,10,12}",
      tangent_ok)

# ------------------------------------------- minimum-weight layer of K (exhaustive)

def systematic(basis, order):
    """Row-reduce `basis` choosing pivot columns in the given order.
    Returns (pivot columns, rows in systematic form w.r.t. those pivots)."""
    rows = list(basis)
    piv = []
    r = 0
    for c in order:
        bit = 1 << c
        sel = None
        for k in range(r, len(rows)):
            if rows[k] & bit:
                sel = k
                break
        if sel is None:
            continue
        rows[r], rows[sel] = rows[sel], rows[r]
        for k in range(len(rows)):
            if k != r and (rows[k] & bit):
                rows[k] ^= rows[r]
        piv.append(c)
        r += 1
    return piv, rows[:r]


I1, G1 = systematic(K, list(range(NI)))
rest = [c for c in range(NI) if c not in set(I1)]
I2, G2 = systematic(K, rest + I1)
disjoint = len(I1) == dimK and len(I2) == dimK and not (set(I1) & set(I2))
check("two disjoint information sets of K exist (exhaustive weight-12 enumeration valid)",
      disjoint, "|I1|=%d |I2|=%d overlap=%d" % (len(I1), len(I2), len(set(I1) & set(I2))))


def enum_le6(G, target):
    """All codewords that are combinations of at most 6 rows of G; returns
    (min nonzero weight seen, set of words of weight == target)."""
    n = len(G)
    minw = 10 ** 9
    found = set()
    for i1 in range(n):
        v1 = G[i1]
        w = bin(v1).count("1")
        if w < minw:
            minw = w
        if w == target:
            found.add(v1)
        for i2 in range(i1 + 1, n):
            v2 = v1 ^ G[i2]
            w = bin(v2).count("1")
            if w < minw:
                minw = w
            if w == target:
                found.add(v2)
            for i3 in range(i2 + 1, n):
                v3 = v2 ^ G[i3]
                w = bin(v3).count("1")
                if w < minw:
                    minw = w
                if w == target:
                    found.add(v3)
                for i4 in range(i3 + 1, n):
                    v4 = v3 ^ G[i4]
                    w = bin(v4).count("1")
                    if w < minw:
                        minw = w
                    if w == target:
                        found.add(v4)
                    for i5 in range(i4 + 1, n):
                        v5 = v4 ^ G[i5]
                        w = bin(v5).count("1")
                        if w < minw:
                            minw = w
                        if w == target:
                            found.add(v5)
                        for i6 in range(i5 + 1, n):
                            v6 = v5 ^ G[i6]
                            w = bin(v6).count("1")
                            if w < minw:
                                minw = w
                            if w == target:
                                found.add(v6)
    return minw, found


t0 = time.time()
m1, w1 = enum_le6(G1, 12)
m2, w2 = enum_le6(G2, 12)
words = sorted(w1 | w2)
info("exhaustive weight enumeration", "%.1f s, min weight seen %d" % (time.time() - t0, min(m1, m2)))
check("minimum weight of K = ker M is 12 (exhaustive over two disjoint info sets)",
      min(m1, m2) == 12, "min weight %d" % min(m1, m2))
check("exactly 364 minimum-weight words", len(words) == 364, "%d" % len(words))
check("every minimum-weight word lies in K = ker A_0",
      all(mat_mul([w], A0, NI) == [0] for w in words) or
      all(all(bin(A0[i] & w).count("1") % 2 == 0 for i in range(NI)) for w in words))

# membership in the passant-line span on all 183 points
C183 = [sum(1 << PIDX[p] for p in POINTS if on(L, p)) for L in PASSANT]
red183, piv183 = rref(C183, 183)
dim183 = len(piv183)


def in_span(v, red, piv):
    for idx, c in enumerate(piv):
        if v & (1 << c):
            v ^= red[idx]
    return v == 0


emb = [sum(1 << PIDX[INTERNAL[i]] for i in range(NI) if w & (1 << i)) for w in words]
in_c183 = sum(1 for v in emb if in_span(v, red183, piv183))
orth = sum(1 for v in emb if all(bin(v & c).count("1") % 2 == 0 for c in C183))
info("framing", "the F_2 span of the 78 passant lines inside F_2^183 has full dimension %d "
     "and contains %d of the 364 words: the minimum-weight layer lives in the DUAL "
     "(kernel) side, i.e. in K = ker M on the 78 internal coordinates, not in the span"
     % (dim183, in_c183))
check("the 364 words are orthogonal to every passant line (they lie in the dual code on "
      "183 coordinates)", orth == 364, "%d of 364" % orth)

# orbits under PGL(2,13)
wordset = set(words)


def apply_perm(perm, w):
    out = 0
    x = w
    j = 0
    while x:
        if x & 1:
            out |= 1 << perm[j]
        x >>= 1
        j += 1
    return out


orbits = []
remaining = set(words)
while remaining:
    seed = min(remaining)
    orb = set()
    frontier = [seed]
    orb.add(seed)
    while frontier:
        y = frontier.pop()
        for perm in GENPERM:
            z = apply_perm(perm, y)
            if z not in orb:
                orb.add(z)
                frontier.append(z)
    orbits.append(orb)
    remaining -= orb
check("the 364 words split into 4 PGL(2,13)-orbits of size 91",
      len(orbits) == 4 and all(len(o) == 91 for o in orbits),
      str(sorted(len(o) for o in orbits)))


def element_order(g):
    X = g
    k = 1
    while mat3_norm(X) != mat3_norm(((1, 0, 0), (0, 1, 0), (0, 0, 1))):
        X = mat3_mul(X, g)
        k += 1
        if k > 200:
            return None
    return k


types = []
for orb in orbits:
    rep = min(orb)
    stab = [GROUP[i] for i, perm in enumerate(GPERM) if apply_perm(perm, rep) == rep]
    orders = sorted(element_order(g) for g in stab)
    cnt = {o: orders.count(o) for o in sorted(set(orders))}
    if len(stab) == 24 and 12 in cnt:
        types.append("D_24")
    elif len(stab) == 24 and set(cnt) == {1, 2, 3, 4} and cnt.get(2) == 9:
        types.append("S_4")
    else:
        types.append("order%d:%s" % (len(stab), cnt))
check("orbit stabilisers: one S_4 and three D_24 (all of order 24)",
      sorted(types) == ["D_24", "D_24", "D_24", "S_4"], str(types))

# incidence statistics of the minimum-weight layer
pt_count = [sum(1 for w in words if w & (1 << i)) for i in range(NI)]
check("each internal point lies in 56 minimum-weight words (14 per orbit)",
      set(pt_count) == {56} and all(set(sum(1 for w in o if w & (1 << i)) for i in range(NI)) == {14}
                                    for o in orbits),
      str(sorted(set(pt_count))))

conc = {r: set() for r in RELS}
for i in range(NI):
    for j in range(NI):
        if i == j:
            continue
        m = (1 << i) | (1 << j)
        conc[RHO[i][j]].add(sum(1 for w in words if (w & m) == m))
c_vals = {r: (sorted(conc[r])[0] if len(conc[r]) == 1 else sorted(conc[r])) for r in RELS}
check("pair concurrence is constant on each relation (N^T N in the Bose-Mesner algebra)",
      all(len(conc[r]) == 1 for r in RELS), str(c_vals))
check("target 3: (c_0,c_1,c_3) = (8,6,6) and {c_9,c_10,c_12} = {12,7,9}",
      c_vals.get(0) == 8 and c_vals.get(1) == 6 and c_vals.get(3) == 6
      and sorted([c_vals.get(9), c_vals.get(10), c_vals.get(12)]) == [7, 9, 12],
      str(c_vals))
mass = 273 * c_vals[0] + 546 * sum(c_vals[r] for r in RELS if r != 0)
check("target 3: mass identity 273 c_0 + 546 sum c_r = 24024", mass == 24024, "%d" % mass)

gram_types = []
for orb in orbits:
    N = sorted(orb)
    G = []
    for i in range(NI):
        row = 0
        for j in range(NI):
            m = (1 << i) | (1 << j)
            if sum(1 for w in N if (w & m) == m) % 2:
                row |= 1 << j
        G.append(row)
    match = [r for r in RELS if G == A[r]]
    gram_types.append(match[0] if match else "none")
check("target 3: per-orbit Gram N_i^T N_i mod 2 gives (A_9, A_9, A_12, A_10) as a multiset",
      sorted(str(t) for t in gram_types) == sorted(["9", "9", "12", "10"]),
      str(gram_types))

# --------------------------------------------------------------------- summary --
print("=" * 78)
npass = sum(1 for _, ok, _ in RESULTS if ok)
nfail = len(RESULTS) - npass
print("SUMMARY: %d checks, %d PASS, %d FAIL" % (len(RESULTS), npass, nfail))
if nfail:
    for name, ok, detail in RESULTS:
        if not ok:
            print("  FAILED: %s   | %s" % (name, detail))
print("key numbers: rank_2 M = %d, dim K = %d, p^10_{3,9} = %s, min weight = %d, words = %d"
      % (rank_M, dimK, sorted(p1039), min(m1, m2), len(words)))
sys.exit(1 if nfail else 0)
