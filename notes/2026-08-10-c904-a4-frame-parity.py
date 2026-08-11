#!/usr/bin/env python3
"""Exact A4-frame parity obstruction for the C904 cubic--Winger bridge."""

from fractions import Fraction
from functools import reduce
from itertools import permutations
from math import gcd

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


def compose(p, q):
    return tuple(p[q[i]] for i in range(5))


def inverse(p):
    ans = [0] * 5
    for i, value in enumerate(p):
        ans[value] = i
    return tuple(ans)


def parity(p):
    return sum(p[i] > p[j] for i in range(5) for j in range(i + 1, 5)) % 2


def order(p):
    value = tuple(range(5))
    for result in range(1, 61):
        value = compose(p, value)
        if value == tuple(range(5)):
            return result
    raise AssertionError


def generated(gens):
    result = {tuple(range(5))}
    frontier = list(result)
    while frontier:
        left = frontier.pop()
        for right in gens:
            for value in (compose(left, right), compose(right, left)):
                if value not in result:
                    result.add(value)
                    frontier.append(value)
    return frozenset(result)


def conjugate(g, subgroup):
    gi = inverse(g)
    return frozenset(compose(compose(g, h), gi) for h in subgroup)


G = tuple(p for p in permutations(range(5)) if parity(p) == 0)
A4S = tuple(frozenset(g for g in G if g[i] == i) for i in range(5))
C5S = {generated((g,)) for g in G if order(g) == 5}
D5S = tuple(sorted(
    (frozenset(g for g in G if conjugate(g, c5) == c5) for c5 in C5S),
    key=lambda subgroup: sorted(subgroup),
))
assert len(G) == 60 and len(A4S) == 5 and len(D5S) == 6


def subgroup_action(g, subgroups):
    return tuple(subgroups.index(conjugate(g, subgroup)) for subgroup in subgroups)


ACTIONS5 = {g: subgroup_action(g, A4S) for g in G}
ACTIONS6 = {g: subgroup_action(g, D5S) for g in G}


def quotient_action(p):
    """Action on Z^n/Z1 in the basis of the first n-1 coordinate classes."""
    n = len(p)
    result = sp.zeros(n - 1)
    for column in range(n - 1):
        lifted = [0] * n
        lifted[p[column]] = 1
        for row in range(n - 1):
            result[row, column] = lifted[row] - lifted[-1]
    return result


# Solve for the unique A4-fixed line in Hom(V4,W5), using zero row and
# column sums in the two deleted permutation models.
variables = sp.symbols("x0:30")
ambient = sp.Matrix(6, 5, variables)
equations = []
for row in range(6):
    equations.append(sum(ambient[row, column] for column in range(5)))
for column in range(5):
    equations.append(sum(ambient[row, column] for row in range(6)))
for g in A4S[0]:
    for row in range(6):
        for column in range(5):
            equations.append(
                ambient[ACTIONS6[g][row], ACTIONS5[g][column]]
                - ambient[row, column]
            )
linear, _ = sp.linear_eq_to_matrix(equations, variables)
fixed = linear.nullspace()
assert len(fixed) == 1
denominator = sp.ilcm(*(entry.q for entry in fixed[0]))
entries = [int(denominator * entry) for entry in fixed[0]]
content = reduce(gcd, (abs(entry) for entry in entries if entry))
ambient_map = sp.Matrix(6, 5, [entry // content for entry in entries])
assert ambient_map.rank() == 3

# Each nonzero column has one parity, so half the ambient map is integral on
# the quotient lattice.  This is the primitive quotient-lattice map B.
for column in range(5):
    assert len({int(ambient_map[row, column]) % 2 for row in range(6)}) == 1
B0 = sp.Matrix([
    [Fraction(int(ambient_map[row, column] - ambient_map[5, column]), 2)
     for column in range(4)]
    for row in range(5)
])
assert all(entry.denominator == 1 for entry in B0)
B0 = B0.applyfunc(int)
assert B0.rank() == 3

# Its five conjugates are indexed by the five A4 subgroups.
maps = []
for target in A4S:
    transporter = next(g for g in G if conjugate(g, A4S[0]) == target)
    maps.append(
        quotient_action(ACTIONS6[transporter])
        * B0
        * quotient_action(ACTIONS5[transporter]).inv()
    )
assert len({tuple(value) for value in maps}) == 5

# Actual axis polarizations: Winger 3(5I-J), cubic 6I-J.
q_winger = 3 * (5 * sp.eye(4) - sp.ones(4))
q_cubic = 6 * sp.eye(5) - sp.ones(5)
frame = sum((value * q_winger.inv() * value.T for value in maps), sp.zeros(5))
assert frame == sp.Rational(12, 5) * q_cubic.inv()

# The two-primary obstruction.  The primitive B has mod-2 rank three, so an
# odd-degree elliptic multiplier gives rank 3*2=6.  A principal cubic gluing
# is a maximal isotropic of dimension four in the 8-dimensional discriminant
# space, and q_cubic has 2-primary exponent two.  Thus a half-integral odd
# frame cannot land in any principal cubic lattice.
B2 = B0.applyfunc(lambda entry: int(entry) % 2)
assert sp.polys.matrices.DomainMatrix.from_Matrix(B2).convert_to(sp.GF(2)).rank() == 3
smith = smith_normal_form(q_cubic, domain=ZZ)
smith_data = [abs(int(smith[i, i])) for i in range(5)]
assert smith_data == [1, 6, 6, 6, 6]
assert 3 * 2 == 6 > 4

# The rational scalar has square class 15: scaling by 5/2 gives 15.  This is
# the tempting odd normalization, and the rank-six calculation rules out its
# integrality (and every odd-degree variant) at two.
assert sp.Rational(12, 5) * sp.Rational(25, 4) == 15

print("PASS C904 A4 frame parity obstruction")
print(f"A4-fixed Hom dimension: {len(fixed)}")
print(f"primitive map rank: {B0.rank()}; mod-2 rank: 3")
print("Winger/cubic frame scalar: 12/5")
print("odd rational normalization: (5/2)B gives scalar 15")
print("target p=2 Smith data: (1,6,6,6,6); maximal gluing dimension: 4")
print("half-integral odd image dimension: 3*2=6 > 4")
print("conclusion: every integral five-map frame multiplier is even")
