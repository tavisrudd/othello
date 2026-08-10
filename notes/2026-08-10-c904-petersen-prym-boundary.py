#!/usr/bin/env python3
"""Exact finite certificate for the Petersen Prym boundary in C904.

The vertices of the Petersen graph are the two-subsets of five letters and
its edges join disjoint subsets.  We classify A5-fixed classes in H^1(P,F2),
track the residual odd S5 action, and compute the integral signed-cycle
lattice of each connected graph double cover.
"""

from fractions import Fraction
from itertools import combinations, product


def determinant(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    ans = Fraction(1)
    for i in range(len(a)):
        pivot = next(j for j in range(i, len(a)) if a[j][i])
        if pivot != i:
            a[i], a[pivot] = a[pivot], a[i]
            ans = -ans
        value = a[i][i]
        ans *= value
        for k in range(i, len(a)):
            a[i][k] /= value
        for j in range(i + 1, len(a)):
            value = a[j][i]
            for k in range(i, len(a)):
                a[j][k] -= value * a[i][k]
    assert ans.denominator == 1
    return ans.numerator


vertices = list(combinations(range(5), 2))
vertex_index = {v: i for i, v in enumerate(vertices)}
edges = [(i, j) for i in range(10) for j in range(i + 1, 10)
         if set(vertices[i]).isdisjoint(vertices[j])]
edge_index = {edge: i for i, edge in enumerate(edges)}
assert len(edges) == 15

# A deterministic spanning tree and the six complementary edges give a
# gauge-fixed model of H^1(P,F2).
adjacency = [[] for _ in vertices]
for edge, (u, v) in enumerate(edges):
    adjacency[u].append((v, edge))
    adjacency[v].append((u, edge))
parent = [None] * 10
parent_edge = [None] * 10
parent[0] = 0
order = [0]
for u in order:
    for v, edge in adjacency[u]:
        if parent[v] is None:
            parent[v] = u
            parent_edge[v] = edge
            order.append(v)
tree = set(parent_edge[1:])
chords = [edge for edge in range(15) if edge not in tree]
assert len(chords) == 6


def gauge_class(voltage):
    switch = [0] * 10
    for v in order[1:]:
        switch[v] = switch[parent[v]] ^ voltage[parent_edge[v]]
    normalized = [bit ^ switch[u] ^ switch[v]
                  for bit, (u, v) in zip(voltage, edges)]
    assert all(normalized[edge] == 0 for edge in tree)
    return tuple(normalized[edge] for edge in chords)


def expand_class(bits):
    voltage = [0] * 15
    for edge, bit in zip(chords, bits):
        voltage[edge] = bit
    return tuple(voltage)


def act_on_class(permutation, bits):
    voltage = expand_class(bits)
    image = [0] * 15
    for edge, (u, v) in enumerate(edges):
        uu = vertex_index[tuple(sorted(permutation[x] for x in vertices[u]))]
        vv = vertex_index[tuple(sorted(permutation[x] for x in vertices[v]))]
        image[edge_index[tuple(sorted((uu, vv)))]] = voltage[edge]
    return gauge_class(image)


cycle = (1, 2, 3, 4, 0)
three_cycle = (1, 2, 0, 3, 4)
transposition = (1, 0, 2, 3, 4)
classes = list(product(range(2), repeat=6))
a5_fixed = [bits for bits in classes
            if act_on_class(cycle, bits) == bits
            and act_on_class(three_cycle, bits) == bits]
assert len(a5_fixed) == 4 and (0,) * 6 in a5_fixed
nonzero = [bits for bits in a5_fixed if any(bits)]
s5_fixed = [bits for bits in nonzero
            if act_on_class(transposition, bits) == bits]
exotic = [bits for bits in nonzero if bits not in s5_fixed]
assert len(s5_fixed) == 1 and len(exotic) == 2
assert act_on_class(transposition, exotic[0]) == exotic[1]


def signed_cycle_gram(bits):
    """Gram matrix on ker(signed incidence), with every lifted edge norm 1.

    Gauge fixing makes tree edges positive.  Conservation says that the sum
    of the negative chord coefficients is zero.  Positive chord units and
    differences of negative chord units are therefore an integral basis.
    Tree flows are then recovered by leaf elimination.
    """
    voltage = list(expand_class(bits))
    negative = [edge for edge in chords if voltage[edge]]
    assert negative
    chord_vectors = []
    for edge in chords:
        if not voltage[edge]:
            vector = [0] * 15
            vector[edge] = 1
            chord_vectors.append(vector)
    for edge in negative[:-1]:
        vector = [0] * 15
        vector[edge] = 1
        vector[negative[-1]] = -1
        chord_vectors.append(vector)
    assert len(chord_vectors) == 5

    cycles = []
    for vector in chord_vectors:
        divergence = [0] * 10
        for edge, (u, v) in enumerate(edges):
            sign = -1 if voltage[edge] else 1
            divergence[u] -= vector[edge]
            divergence[v] += sign * vector[edge]
        target = [-x for x in divergence]
        for v in reversed(order[1:]):
            edge = parent_edge[v]
            u0, v0 = edges[edge]
            coefficient = 1 if v == v0 else -1
            vector[edge] = coefficient * target[v]
            target[parent[v]] += target[v]
        assert target[0] == 0
        check = [0] * 10
        for edge, (u, v) in enumerate(edges):
            sign = -1 if voltage[edge] else 1
            check[u] -= vector[edge]
            check[v] += sign * vector[edge]
        assert check == [0] * 10
        cycles.append(vector)
    gram = [[sum(x * y for x, y in zip(a, b))
             for b in cycles] for a in cycles]
    return gram


grams = {bits: signed_cycle_gram(bits) for bits in nonzero}
assert {determinant(grams[bits]) for bits in exotic} == {6 ** 4}
assert determinant(grams[s5_fixed[0]]) == 1536

# An explicit unimodular change of basis identifies the first exotic lattice
# with 6 A5^vee, whose convenient Gram matrix is 6I-J.  Odd S5 conjugacy gives
# the same conclusion for the second exotic class.
change = [
    [-1, 0, 0, 0, 0],
    [0, -1, 0, 0, 1],
    [0, 0, -1, 1, 0],
    [0, 0, 0, 0, 1],
    [0, 0, 0, 1, -1],
]
assert abs(determinant(change)) == 1
gram = grams[exotic[0]]
transported = [[sum(change[k][i] * gram[k][ell] * change[ell][j]
                    for k in range(5) for ell in range(5))
                for j in range(5)] for i in range(5)]
six_weight = [[5 if i == j else -1 for j in range(5)] for i in range(5)]
assert transported == six_weight

print("Petersen graph: dim H^1=6")
print("A5-fixed classes: 4 total, 3 nonzero connected covers")
print("S5 action: 1 fixed cover plus 1 odd-conjugate pair")
print("fixed-cover signed-cycle determinant: 1536")
print("exotic-pair determinant: 6^4=1296")
print("exotic-pair Gram class: 6*A5^vee = 6I-J")
print("CHECK PASS")
