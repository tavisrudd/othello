#!/usr/bin/env python3
"""Exact finite-group certificate for the cubic--Winger correspondence carrier.

The script uses only exact integer/rational arithmetic.  It certifies the A5
subgroup geometry, permutation characters, the representation obstruction to
a scalar invariant correspondence, and the integral double-augmentation
lattice carried by the 6 x 5 subgroup-pair orbit.
"""

from fractions import Fraction
from itertools import permutations

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


def compose(p, q):
    """p after q, permutations represented by image tuples."""
    return tuple(p[q[i]] for i in range(5))


def inverse(p):
    ans = [0] * 5
    for i, j in enumerate(p):
        ans[j] = i
    return tuple(ans)


def parity(p):
    inv = sum(p[i] > p[j] for i in range(5) for j in range(i + 1, 5))
    return inv % 2


def order(p):
    q = tuple(range(5))
    for n in range(1, 61):
        q = compose(p, q)
        if q == tuple(range(5)):
            return n
    raise AssertionError("order exceeds 60")


G = tuple(p for p in permutations(range(5)) if parity(p) == 0)
assert len(G) == 60


def subgroup_generated(gens):
    H = {tuple(range(5))}
    changed = True
    while changed:
        changed = False
        for a in tuple(H):
            for b in gens:
                for c in (compose(a, b), compose(b, a)):
                    if c not in H:
                        H.add(c)
                        changed = True
    return frozenset(H)


def conjugate_subgroup(g, H):
    gi = inverse(g)
    return frozenset(compose(compose(g, h), gi) for h in H)


# Five A4 point stabilizers.
A4s = tuple(
    frozenset(g for g in G if g[i] == i)
    for i in range(5)
)
assert len(set(A4s)) == 5 and all(len(H) == 12 for H in A4s)

# Six D5 normalizers of the six Sylow-5 subgroups.
C5s = set()
for g in G:
    if order(g) == 5:
        C5s.add(subgroup_generated((g,)))
assert len(C5s) == 6
D5s = []
for C5 in C5s:
    normalizer = frozenset(g for g in G if conjugate_subgroup(g, C5) == C5)
    assert len(normalizer) == 10
    D5s.append(normalizer)
D5s = tuple(sorted(set(D5s), key=lambda H: sorted(H)))
assert len(D5s) == 6


def permute_subgroup_index(g, subgroups, i):
    target = conjugate_subgroup(g, subgroups[i])
    return subgroups.index(target)


actions6 = {g: tuple(permute_subgroup_index(g, D5s, i) for i in range(6)) for g in G}
actions5 = {g: tuple(permute_subgroup_index(g, A4s, i) for i in range(5)) for g in G}

# The diagonal action on the 30 subgroup pairs is transitive, with stabilizer C2.
pair_orbit = {(actions6[g][0], actions5[g][0]) for g in G}
assert len(pair_orbit) == 30
intersection_orders = {len(H.intersection(K)) for H in D5s for K in A4s}
assert intersection_orders == {2}
pair_stabilizer = D5s[0].intersection(A4s[0])
pair_stabilizer_normalizer = frozenset(
    g for g in G if conjugate_subgroup(g, pair_stabilizer) == pair_stabilizer
)
assert len(pair_stabilizer) == 2
assert len(pair_stabilizer_normalizer) == 4


# Conjugacy classes are keyed by element order, with the two order-5 classes
# irrelevant here because both relevant characters vanish on them.
class_sizes = {n: sum(order(g) == n for g in G) for n in (1, 2, 3, 5)}
assert class_sizes == {1: 1, 2: 15, 3: 20, 5: 24}


def fixed_points(action, g):
    return sum(action[g][i] == i for i in range(len(action[g])))


perm5_char = {n: fixed_points(actions5, next(g for g in G if order(g) == n)) for n in (1, 2, 3, 5)}
perm6_char = {n: fixed_points(actions6, next(g for g in G if order(g) == n)) for n in (1, 2, 3, 5)}
assert perm5_char == {1: 5, 2: 1, 3: 2, 5: 0}
assert perm6_char == {1: 6, 2: 2, 3: 0, 5: 1}

V4_char = {n: perm5_char[n] - 1 for n in perm5_char}
W5_char = {n: perm6_char[n] - 1 for n in perm6_char}
assert V4_char == {1: 4, 2: 0, 3: 1, 5: -1}
assert W5_char == {1: 5, 2: 1, 3: -1, 5: 0}


def inner_product(chi, psi):
    return Fraction(sum(class_sizes[n] * chi[n] * psi[n] for n in class_sizes), 60)


# Hom_A5(V4,W5)=0: no scalar diagonal-A5-equivariant bridge.
assert inner_product(V4_char, W5_char) == 0

# Fixed-line computations.  E6=3+3' has character (6,-2,0,1) on
# orders (1,2,3,5), and no A4 fixed vector.
E6_char = {1: 6, 2: -2, 3: 0, 5: 1}


def fixed_dimension(chi, H):
    return Fraction(sum(chi[order(h)] for h in H), len(H))


assert fixed_dimension(W5_char, D5s[0]) == 1
assert fixed_dimension(V4_char, A4s[0]) == 1
assert fixed_dimension(E6_char, A4s[0]) == 0

# The coefficient carrier has a suggestive full decomposition:
# W5 tensor V4 = (3+3') + V4 + 2 W5.  In particular, it already contains
# the six-dimensional rational representation governing the complementary
# Hilbert-modular Winger constituent.
carrier_char = {n: W5_char[n] * V4_char[n] for n in W5_char}
assert inner_product(carrier_char, E6_char) == 2  # one copy each of 3 and 3'
assert inner_product(carrier_char, V4_char) == 1
assert inner_product(carrier_char, W5_char) == 2
assert 6 + 4 + 2 * 5 == 20

# Double augmentation of one pair.  The 30 integral orbit matrices are
# (6e_i-1_6)(5e_j-1_5)^t.  Their rational span is the full rank-20
# Hom(V4,W5) carrier.
def seed_matrix(i, j):
    a = sp.Matrix([6 * (r == i) - 1 for r in range(6)])
    b = sp.Matrix([5 * (c == j) - 1 for c in range(5)])
    return a * b.T


orbit_matrices = [seed_matrix(i, j) for i, j in sorted(pair_orbit)]
flat = sp.Matrix.hstack(*(sp.Matrix(M).reshape(30, 1) for M in orbit_matrices))
assert flat.rank() == 20
assert all(sum(M[r, c] for c in range(5)) == 0 for M in orbit_matrices for r in range(6))
assert all(sum(M[r, c] for r in range(6)) == 0 for M in orbit_matrices for c in range(5))

# Coordinates in the standard integral lattice of 6 x 5 matrices with zero
# row and column sums are the upper-left 5 x 4 entries.
coords = sp.Matrix.hstack(*(
    sp.Matrix([M[r, c] for r in range(5) for c in range(4)])
    for M in orbit_matrices
))
assert coords.rank() == 20
S = smith_normal_form(coords, domain=ZZ)
snf_nonzero = sorted(abs(int(S[i, i])) for i in range(min(S.rows, S.cols)) if S[i, i] != 0)
assert snf_nonzero == [1] * 4 + [6] + [30] * 15
lattice_index = sp.prod(snf_nonzero)
assert lattice_index == 6**16 * 5**15

# Any invariant 6 x 5 matrix is constant because the pair orbit is transitive;
# double augmentation therefore kills every invariant matrix.
assert len(pair_orbit) == 30

print("PASS C904 cubic--Winger correspondence carrier")
print(f"A5 order: {len(G)}")
print(f"subgroups: D5={len(D5s)} A4={len(A4s)}")
print(f"pair orbit: {len(pair_orbit)}; all intersections have order {next(iter(intersection_orders))}")
print("pair-orbit equivariant involution: N(C2)/C2 has order 2")
print(f"Q[A5/A4] character: {perm5_char} = 1 + V4")
print(f"Q[A5/D5] character: {perm6_char} = 1 + W5")
print(f"<V4,W5> = {inner_product(V4_char, W5_char)}")
print(f"fixed dimensions: W5^D5={fixed_dimension(W5_char, D5s[0])}, "
      f"V4^A4={fixed_dimension(V4_char, A4s[0])}, "
      f"E6^A4={fixed_dimension(E6_char, A4s[0])}")
print("carrier decomposition: W5 tensor V4 = E6 + V4 + 2 W5")
print(f"double-augmentation orbit rank: {flat.rank()}")
print("double-augmentation SNF: 1^4, 6^1, 30^15")
print(f"double-augmentation saturation index: 6^16*5^15 = {lattice_index}")
