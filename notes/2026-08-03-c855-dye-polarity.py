"""C855: the unique polarity associated with a Brianchon-equality six-arc.

Golden normal form (see notes/2026-08-03-c855-dye-orbit-uniqueness.md):

    P1=(1:0:0)  P2=(x:1:1)  P3=(0:1:0)  P4=(1:x:1)  P5=(0:0:1)  P6=(1:1:2-x)

with x^2 = x + 1.  The equality case singles out one one-factorization of the
complete graph on the six vertices, whose five one-factors are the
non-concurrent ones; each cuts a genuine triangle out of the plane.  This
script shows there is exactly one polarity making those triangles self-polar.

All arithmetic is exact in the ring Z[x]/(x^2 - x - 1), so every conclusion
below is an identity valid over any field of odd characteristic containing a
golden root; the only divisions used are by powers of two.

Replay:  python3 notes/2026-08-03-c855-dye-polarity.py
"""
import itertools, functools

# ---- exact arithmetic in Z[x]/(x^2 - x - 1); (a,b) means a + b*x -----------
def mul(u, v):
    a, b = u; c, d = v
    return (a*c + b*d, a*d + b*c + b*d)
def add(u, v): return (u[0]+v[0], u[1]+v[1])
def sub(u, v): return (u[0]-v[0], u[1]-v[1])
def neg(u): return (-u[0], -u[1])
def sc(n): return (n, 0)
Z, O, X = (0, 0), (1, 0), (0, 1)
norm = lambda u: u[0]*u[0] + u[0]*u[1] - u[1]*u[1]      # N(a+b*phi) = a^2+ab-b^2
def show(u):
    a, b = u
    if b == 0: return str(a)
    t = ("x" if b == 1 else "-x" if b == -1 else f"{b}x")
    if a == 0: return t
    return f"{a}+{t}" if b > 0 else f"{a}{t}"

def cross(A, B):
    return [sub(mul(A[1],B[2]), mul(A[2],B[1])),
            sub(mul(A[2],B[0]), mul(A[0],B[2])),
            sub(mul(A[0],B[1]), mul(A[1],B[0]))]
def det(M):
    n = len(M)
    if n == 1: return M[0][0]
    tot = Z
    for j in range(n):
        if M[0][j] == Z: continue
        t = mul(M[0][j], det([[M[i][k] for k in range(n) if k != j] for i in range(1, n)]))
        tot = add(tot, t) if j % 2 == 0 else sub(tot, t)
    return tot

# ---- the configuration ----------------------------------------------------
P = {1:[O,Z,Z], 2:[X,O,O], 3:[Z,O,Z], 4:[O,X,O], 5:[Z,Z,O], 6:[O,O,sub(sc(2),X)]}
line = lambda i, j: cross(P[i], P[j])

NC = [((1,2),(3,6),(4,5)), ((1,3),(2,4),(5,6)), ((1,4),(2,6),(3,5)),
      ((1,5),(2,3),(4,6)), ((1,6),(2,5),(3,4))]           # non-concurrent
M10 = [((1,2),(3,4),(5,6)), ((1,2),(3,5),(4,6)), ((1,3),(2,5),(4,6)),
       ((1,3),(2,6),(4,5)), ((1,4),(2,3),(5,6)), ((1,4),(2,5),(3,6)),
       ((1,5),(2,4),(3,6)), ((1,5),(2,6),(3,4)), ((1,6),(2,3),(4,5)),
       ((1,6),(2,4),(3,5))]                                # concurrent

def triangle(f):
    L = [line(*e) for e in f]
    return [cross(L[0],L[1]), cross(L[1],L[2]), cross(L[2],L[0])]

def conjugacy_row(U, V):
    """coefficients of (s11,s12,s13,s22,s23,s33) in U^T S V for symmetric S."""
    return [mul(U[0],V[0]),
            add(mul(U[0],V[1]), mul(U[1],V[0])),
            add(mul(U[0],V[2]), mul(U[2],V[0])),
            mul(U[1],V[1]),
            add(mul(U[1],V[2]), mul(U[2],V[1])),
            mul(U[2],V[2])]

rows = []
for f in NC:
    V = triangle(f)
    for a, b in itertools.combinations(range(3), 2):
        rows.append(conjugacy_row(V[a], V[b]))

# ---- the polarity ---------------------------------------------------------
Sv = [sub(mul(sc(2),X), O), sc(-1), neg(X), sub(mul(sc(2),X), O), neg(X), add(mul(sc(3),X), O)]
Sm = [[Sv[0],Sv[1],Sv[2]], [Sv[1],Sv[3],Sv[4]], [Sv[2],Sv[4],Sv[5]]]
print("polarity matrix S (entries in Z[x]/(x^2-x-1), x the golden root):")
for r in Sm: print("   [", "  ".join(show(e).rjust(5) for e in r), "]")
print("det S =", show(det(Sm)), " (nonzero in every odd characteristic: 2 and x are units)")

bad = [i for i, r in enumerate(rows)
       if functools.reduce(add, [mul(r[k], Sv[k]) for k in range(6)], Z) != Z]
print("self-polarity conditions violated by S:", len(bad), "of", len(rows))

def quad(Pt):
    return functools.reduce(add,
        [mul(mul(Pt[i], Sm[i][j]), Pt[j]) for i in range(3) for j in range(3)], Z)
print("Q at the six vertices:", [show(quad(P[i])) for i in range(1, 7)])
bri = [cross(*[line(*e) for e in f][:2]) for f in M10]
print("Q at the ten Brianchon points:", sorted({show(quad(b)) for b in bri}))

# ---- uniqueness -----------------------------------------------------------
def best_minor(sub_rows):
    best = None
    for cs in itertools.combinations(range(6), 5):
        for rs in itertools.combinations(range(len(sub_rows)), 5):
            m = det([[sub_rows[r][c] for c in cs] for r in rs])
            if m != Z and (best is None or abs(norm(m)) < abs(norm(best[2]))):
                best = (rs, cs, m)
    return best
b2 = best_minor(rows[:6])
print("\nusing only the first two triangles, smallest nonzero 5x5 minor:",
      show(b2[2]), " norm", norm(b2[2]), " rows", b2[0], "cols", b2[1])
q = (b2[2][0] // 8, b2[2][1] // 8)
print("   that minor is 8 * (", show(q), ") and N(", show(q), ") =", norm(q),
      "-> a unit times a power of two, invertible in every odd characteristic")
print("   hence the fifteen conditions have rank exactly five and S spans the solution line")

# ---- order-eleven identification with the uncovered conic ------------------
p = 11
def toF(u): return (u[0] + u[1] * 4) % p          # x -> 4, a golden root mod 11
def nrm(V):
    for c in V:
        if c % p:
            i = pow(c, p-2, p); return tuple((v*i) % p for v in V)
Ap = [nrm(tuple(toF(c) for c in P[i])) for i in range(1, 7)]
allpts = sorted({nrm(t) for t in itertools.product(range(p), repeat=3) if any(t)})
chords = [nrm(tuple(toF(c) for c in line(i, j))) for i, j in itertools.combinations(range(1,7), 2)]
unc = [V for V in allpts if V not in Ap and all(sum(L[k]*V[k] for k in range(3)) % p for L in chords)]
Sp = [[toF(e) for e in r] for r in Sm]
Qp = lambda V: sum(V[i]*Sp[i][j]*V[j] for i in range(3) for j in range(3)) % p
conic = [V for V in allpts if Qp(V) == 0]
print(f"\nq=11: uncovered locus has {len(unc)} points, conic of S has {len(conic)} points;"
      f" equal: {set(conic) == set(unc)}")
def polar_meets(V):
    pol = tuple(sum(Sp[i][k]*V[k] for k in range(3)) % p for i in range(3))
    return sum(1 for C in conic if sum(pol[k]*C[k] for k in range(3)) % p == 0)
print("q=11: polar of each vertex meets the conic in", [polar_meets(V) for V in Ap],
      "points (two = external)")
brip = [nrm(tuple(toF(c) for c in b)) for b in bri]
print("q=11: polar of each Brianchon point meets the conic in",
      sorted({polar_meets(V) for V in brip}), "points (zero = internal)")
