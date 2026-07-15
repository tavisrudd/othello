"""Q4: decoding consequences of the Clebsch hexagon code.
Exact verification over F_11. Exits nonzero on any mismatch."""
from itertools import combinations, product

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
    return (a[0]*b[0] + a[1]*b[1] + a[2]*b[2]) % p

POINTS = []
seen = set()
for a in range(p):
    for b in range(p):
        for c in range(p):
            if (a, b, c) == (0, 0, 0):
                continue
            n = norm((a, b, c))
            if n not in seen:
                seen.add(n)
                POINTS.append(n)
assert len(POINTS) == 133

A = [norm(v) for v in [(1,10,0),(1,9,1),(1,4,7),(1,8,5),(0,1,4),(1,1,7)]]
CONIC = sorted(P for P in POINTS if (P[0]*P[2] - P[1]*P[1]) % p == 0)
assert len(CONIC) == 12
assert not set(A) & set(CONIC)

def det3(P, Q, R):
    return (P[0]*(Q[1]*R[2]-Q[2]*R[1]) - P[1]*(Q[0]*R[2]-Q[2]*R[0])
            + P[2]*(Q[0]*R[1]-Q[1]*R[0])) % p

# six-arc check
for T in combinations(A, 3):
    assert det3(*T) != 0

# ---- secant-index census: n1, n2, n3 and Brianchon points ----
secants = [cross(P, Q) for P, Q in combinations(A, 2)]
assert len(set(secants)) == 15
idx = {}
for P in POINTS:
    if P in A:
        continue
    idx[P] = sum(1 for L in secants if dot(L, P) == 0)
n = {i: sum(1 for v in idx.values() if v == i) for i in range(4)}
print("secant-index census n0..n3:", n)
assert n == {0: 12, 1: 90, 2: 15, 3: 10}
assert sorted(P for P, v in idx.items() if v == 0) == CONIC
BRIANCHON = sorted(P for P, v in idx.items() if v == 3)

# ---- exhaustive syndrome table: min weight and leaders per coset ----
H = list(zip(*A))  # 3x6 over F11, columns = arc points

def syndrome(e):
    return tuple(sum(H[r][i]*e[i] for i in range(6)) % p for r in range(3))

best = {}      # syndrome -> min weight
leaders = {}   # syndrome -> list of leader supports (at min weight)
for w in (1, 2, 3):
    for supp in combinations(range(6), w):
        for vals in product(range(1, p), repeat=w):
            e = [0]*6
            for i, v in zip(supp, vals):
                e[i] = v
            s = syndrome(e)
            if s == (0, 0, 0):
                continue
            if s not in best or w < best[s]:
                best[s] = w
                leaders[s] = [supp]
            elif w == best[s]:
                leaders[s].append(supp)

assert len(best) == p**3 - 1  # every nonzero syndrome reached within weight 3
# coset-leader weight distribution (1, 60, 1150, 120)
from collections import Counter
wdist = Counter(best.values())
print("coset weight distribution:", dict(wdist))
assert wdist == {1: 60, 2: 1150, 3: 120}

# ---- Claim 1: O(1) distance decision tree ----
for s in best:
    q = (s[0]*s[2] - s[1]*s[1]) % p
    d = best[s]
    if d == 3:
        assert q == 0
    else:
        assert q != 0 or s == (0,0,0)
# and conversely every nonzero syndrome with q=0 has weight 3
for s in best:
    if (s[0]*s[2] - s[1]*s[1]) % p == 0:
        assert best[s] == 3
print("Claim 1 OK: d(v,C)=3  <=>  s!=0 and s0*s2 - s1^2 = 0 (mod 11)")

# weight-1 vs weight-2 discrimination: [s] in A
Aset = set(A)
for s in best:
    if best[s] == 1:
        assert norm(s) in Aset
    if best[s] == 2:
        assert norm(s) not in Aset
print("Claim 1b OK: d=1 <=> [s] in A;  d=2 otherwise (off conic, off A)")

# ---- Claim 2: ambiguity enumerator ----
amb = Counter(len(set(leaders[s])) for s in best)
print("ambiguity enumerator {#leaders: #cosets}:", dict(sorted(amb.items())))
assert amb == {1: 960, 2: 150, 3: 100, 20: 120}

# weight-2 cosets: #leaders == secant index of the direction
for s in best:
    if best[s] == 2:
        assert len(leaders[s]) == idx[norm(s)]
print("Claim 2 OK: weight-2 cosets have exactly (secant index) leaders; "
      "triple ambiguity occurs exactly over the 10 Brianchon directions")

# deep-hole cosets: leader supports are ALL 20 triples
all_triples = set(combinations(range(6), 3))
for s in best:
    if best[s] == 3:
        assert set(leaders[s]) == all_triples
print("Claim 2b OK: every deep-hole coset has all 20 supports as leader supports")

# ---- Claim 3: Brianchon triple-ambiguity supports form a perfect matching ----
matchings_at_brianchon = {}
for s in best:
    if best[s] == 2 and len(leaders[s]) == 3:
        supps = sorted(set(leaders[s]))
        # three pairs, pairwise disjoint => perfect matching of {0..5}
        allc = [c for pair in supps for c in pair]
        assert sorted(allc) == list(range(6)), supps
        matchings_at_brianchon.setdefault(norm(s), frozenset(supps))
assert len(matchings_at_brianchon) == 10
assert set(matchings_at_brianchon) == set(BRIANCHON)
M10 = set(matchings_at_brianchon.values())
assert len(M10) == 10
# the 5 remaining matchings form the synthematic total (pairwise edge-disjoint)
def perfect_matchings():
    out = []
    for a in range(1, 6):
        rest = [i for i in range(1, 6) if i != a]
        for b, c in [(rest[0], rest[1]), (rest[0], rest[2]), (rest[1], rest[2])]:
            d = [i for i in rest if i not in (b, c)]
            m = frozenset([(0, a), tuple(sorted((b, c))), tuple(sorted((d[0], d[1])))])
            out.append(m)
    return set(out)
M15 = perfect_matchings()
assert len(M15) == 15
TOTAL = M15 - M10
assert len(TOTAL) == 5
edges = [e for m in TOTAL for e in m]
assert len(set(edges)) == 15  # pairwise edge-disjoint: a synthematic total
print("Claim 3 OK: the 10 triple-ambiguity matchings are the 10 outside one "
      "synthematic total; the total (= 5 self-polar triangles) is their complement")

# ---- stabilizer, chirality orbits, and the equivariance limit ----
def solve_frame(F):
    # projectivity M with M(e1)=F0, M(e2)=F1, M(e3)=F2, M(1,1,1)=F3 (cols scaled)
    P1, P2, P3, P4 = F
    Mm = [[P1[r], P2[r], P3[r]] for r in range(3)]
    # solve Mm x = P4 mod p
    Maug = [row[:] + [P4[r]] for r, row in enumerate(Mm)]
    m = [row[:] for row in Maug]
    piv = []
    r = 0
    for col in range(3):
        pr = next((i for i in range(r, 3) if m[i][col] % p), None)
        if pr is None:
            return None
        m[r], m[pr] = m[pr], m[r]
        inv = pow(m[r][col], p - 2, p)
        m[r] = [(x * inv) % p for x in m[r]]
        for i in range(3):
            if i != r and m[i][col] % p:
                f = m[i][col]
                m[i] = [(m[i][j] - f * m[r][j]) % p for j in range(4)]
        r += 1
    x = [m[i][3] for i in range(3)]
    if any(v % p == 0 for v in x):
        return None
    return tuple(tuple((Mm[r][c] * x[c]) % p for c in range(3)) for r in range(3))

def apply(M, P):
    return norm(tuple(sum(M[r][c] * P[c] for c in range(3)) % p for r in range(3)))

from itertools import permutations
F0 = A[:4]
M0 = solve_frame(F0)
stab = []
for T in permutations(A, 4):
    MT = solve_frame(list(T))
    if MT is None:
        continue
    # g sends F0 -> T : g = MT * M0^{-1}; test g(A)=A by images of A under composite
    # compute M0 inverse via adjugate
    a,b,c = M0[0]; d,e,f = M0[1]; g_,h,i = M0[2]
    det = (a*(e*i-f*h) - b*(d*i-f*g_) + c*(d*h-e*g_)) % p
    dinv = pow(det, p-2, p)
    adj = [[(e*i-f*h), (c*h-b*i), (b*f-c*e)],
           [(f*g_-d*i), (a*i-c*g_), (c*d-a*f)],
           [(d*h-e*g_), (b*g_-a*h), (a*e-b*d)]]
    Minv = tuple(tuple((adj[r][cc]*dinv) % p for cc in range(3)) for r in range(3))
    G = tuple(tuple(sum(MT[r][k]*Minv[k][cc] for k in range(3)) % p for cc in range(3))
              for r in range(3))
    if set(apply(G, P) for P in A) == set(A):
        stab.append(G)
# dedupe projectively
def projkey(M):
    flat = [M[r][c] for r in range(3) for c in range(3)]
    for v in flat:
        if v % p:
            inv = pow(v, p-2, p)
            return tuple((x*inv) % p for x in flat)
stab = {projkey(G): G for G in stab}
stab = list(stab.values())
print("stabilizer order:", len(stab))
assert len(stab) == 60

# support-permutation action
def supp_perm(G):
    return tuple(A.index(apply(G, P)) for P in A)
perms = set(supp_perm(G) for G in stab)
assert len(perms) == 60

# orbits of A5 on 20 triples
def act(g, S):
    return tuple(sorted(g[i] for i in S))
orbs = []
left = set(all_triples)
while left:
    S = next(iter(left))
    O = set()
    stack = [S]
    while stack:
        T = stack.pop()
        if T in O: continue
        O.add(T)
        for g in perms:
            stack.append(act(g, T))
    orbs.append(frozenset(O))
    left -= O
print("triple-orbit sizes:", sorted(len(o) for o in orbs))
assert sorted(len(o) for o in orbs) == [10, 10]
Oplus, Ominus = orbs
for S in Oplus:
    assert tuple(sorted(set(range(6)) - set(S))) in Ominus
print("Claim 4a OK: chirality orbits O+/O- of size 10, swapped by complementation; "
      "'decode into O+' is a well-defined MAut-equivariant halving 20 -> 10")

# stabilizer of one conic direction inside A5, orbits on 20 supports
s0 = CONIC[0]
stab_dir = [G for G in stab if apply(G, s0) == s0]
print("direction-stabilizer order:", len(stab_dir))
assert len(stab_dir) == 5
pd = set(supp_perm(G) for G in stab_dir)
orbs5 = []
left = set(all_triples)
while left:
    S = next(iter(left))
    O = set()
    stack = [S]
    while stack:
        T = stack.pop()
        if T in O: continue
        O.add(T)
        for g in pd:
            stack.append(act(g, T))
    orbs5.append(frozenset(O))
    left -= O
sizes = sorted(len(o) for o in orbs5)
print("C5 orbits on the 20 leader supports of a deep-hole coset:", sizes)
assert sizes == [5, 5, 5, 5]
# each chirality class = union of exactly two C5-orbits
for o in orbs5:
    assert o <= Oplus or o <= Ominus
print("Claim 4b OK: any equivariant complete decoder must return >=5 codewords at "
      "a deep hole; the 20 leaders split as (O+ : 5+5) + (O- : 5+5)")

print("ALL Q4 CLAIMS VERIFIED")
