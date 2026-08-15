#!/usr/bin/env python3
"""W5 as the monomial representation Ind_{A4}^{A5}(omega), and its cubic invariants.

A5 acts on the five cosets of A4; the induced representation of a nontrivial
cubic character of A4 is five-dimensional and contains W5, hence equals it.
The matrices are monomial with cube-root-of-unity entries, so the Fermat form
y1^3 + ... + y5^3 is invariant.  This script verifies the character of the
representation, computes the space of invariant cubics, and checks that the
Fermat form lies in it.
"""

from itertools import permutations, combinations_with_replacement

LET = [1, 2, 3, 4, 5]


def sign(p):
    s = 1
    p = list(p)
    for i in range(len(p)):
        for j in range(i + 1, len(p)):
            if p[i] > p[j]:
                s = -s
    return s


def as_map(p):
    return {i + 1: p[i] for i in range(5)}


A5 = [as_map(p) for p in permutations(LET) if sign(p) == 1]
assert len(A5) == 60

IDENT = {i: i for i in LET}


def mul(g, h):          # (g*h)(i) = g(h(i))
    return {i: g[h[i]] for i in LET}


def inv(g):
    return {v: k for k, v in g.items()}


CYC = {1: 2, 2: 3, 3: 4, 4: 5, 5: 1}


def power(g, n):
    r = IDENT
    for _ in range(n):
        r = mul(r, g)
    return r


# coset representatives: r_i sends 5 to i
REP = {i: power(CYC, i % 5) for i in LET}
for i in LET:
    assert REP[i][5] == i

V4 = [IDENT,
      {1: 2, 2: 1, 3: 4, 4: 3, 5: 5},
      {1: 3, 2: 4, 3: 1, 4: 2, 5: 5},
      {1: 4, 2: 3, 3: 2, 4: 1, 5: 5}]
T = {1: 2, 2: 3, 3: 1, 4: 4, 5: 5}          # the 3-cycle (1 2 3), generates A4/V4


def chi(h):
    """exponent k with h in T^k V4, i.e. the cubic character of A4 = Stab(5)."""
    assert h[5] == 5
    for k in range(3):
        tk = power(T, k)
        for v in V4:
            if mul(tk, v) == h:
                return k
    raise ValueError("not in A4")


def matrix(g):
    """monomial matrix of Ind(omega): entry (j, i) nonzero iff j = g(i)."""
    cols = {}
    for i in LET:
        j = g[i]
        h = mul(inv(REP[j]), mul(g, REP[i]))
        cols[i] = (j, chi(h))
    return cols


def trace_exponents(g):
    cols = matrix(g)
    return sorted(k for i, (j, k) in cols.items() if j == i)


# character check: W5 has chi(1)=5, chi(2A)=1, chi(3A)=-1, chi(5A)=chi(5B)=0.
# The diagonal entries are powers of omega; 1 + omega + omega^2 = 0.
def char_value(g):
    ks = trace_exponents(g)
    counts = [ks.count(k) for k in range(3)]
    # value = counts[0] + counts[1]*w + counts[2]*w^2, with w^2 = -1-w
    a = counts[0] - counts[2]
    b = counts[1] - counts[2]
    return (a, b)          # value = a + b*w


tests = {
    "identity": IDENT,
    "double transposition (12)(34)": {1: 2, 2: 1, 3: 4, 4: 3, 5: 5},
    "three-cycle (123)": T,
    "five-cycle (12345)": CYC,
}
for name, g in tests.items():
    print(f"character at {name}: {char_value(g)}   (a + b*omega)")

# invariant cubics: monomials carry a power of omega, so work with exponents mod 3
MONS = list(combinations_with_replacement(LET, 3))
IDX = {m: n for n, m in enumerate(MONS)}


def act_on_monomial(g, m):
    """y_i -> sum_j M(g)_{j,i} y_j is monomial: y_i -> omega^k y_{g(i)}."""
    cols = matrix(g)
    k = 0
    img = []
    for i in m:
        j, e = cols[i]
        k = (k + e) % 3
        img.append(j)
    return tuple(sorted(img)), k


GENS = [CYC, {1: 2, 2: 1, 3: 4, 4: 3, 5: 5}]

# orbit analysis: an invariant is a choice of coefficient per orbit, consistent
# with the cocycle; the orbit contributes a dimension iff every loop is trivial.
seen = {}
dim = 0
orbits = []
for m in MONS:
    if m in seen:
        continue
    # BFS assigning exponents
    lab = {m: 0}
    stack = [m]
    good = True
    members = []
    while stack:
        cur = stack.pop()
        members.append(cur)
        for g in GENS:
            img, k = act_on_monomial(g, cur)
            want = (lab[cur] + k) % 3
            if img in lab:
                if lab[img] != want:
                    good = False
            else:
                lab[img] = want
                stack.append(img)
    for x in lab:
        seen[x] = True
    if good:
        dim += 1
        orbits.append((sorted(set(members)), lab))

print(f"dimension of the space of A5-invariant cubics: {dim}")

fermat = [(i, i, i) for i in LET]
for mem, lab in orbits:
    keys = set(lab)
    if set(fermat) <= keys:
        pure = all(lab[f] == lab[fermat[0]] for f in fermat)
        print("Fermat monomials lie in one invariant orbit; "
              f"coefficients equal: {pure}; orbit size {len(keys)}")
