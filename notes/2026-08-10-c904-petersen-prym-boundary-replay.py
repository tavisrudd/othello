#!/usr/bin/env python3
"""Independent orbit replay for the C904 Petersen boundary certificate."""

from itertools import combinations, product


vertices = list(combinations(range(5), 2))
edges = [pair for pair in combinations(range(10), 2)
         if set(vertices[pair[0]]).isdisjoint(vertices[pair[1]])]
edge_index = {edge: i for i, edge in enumerate(edges)}


def coboundary(vertex_bits):
    return tuple(vertex_bits[u] ^ vertex_bits[v] for u, v in edges)


coboundaries = {coboundary(bits) for bits in product(range(2), repeat=10)}
assert len(coboundaries) == 2 ** 9


def permute_voltage(permutation, voltage):
    vi = {v: i for i, v in enumerate(vertices)}
    answer = [0] * 15
    for i, (u, v) in enumerate(edges):
        uu = vi[tuple(sorted(permutation[x] for x in vertices[u]))]
        vv = vi[tuple(sorted(permutation[x] for x in vertices[v]))]
        answer[edge_index[tuple(sorted((uu, vv)))]] = voltage[i]
    return tuple(answer)


# Build H^1 directly as the 64 cosets of the 512 coboundaries, without a
# spanning-tree gauge.  This is independent of the primary classification.
unseen = set(product(range(2), repeat=15))
representatives = []
while unseen:
    representative = min(unseen)
    coset = {tuple(x ^ y for x, y in zip(representative, boundary))
             for boundary in coboundaries}
    unseen.difference_update(coset)
    representatives.append(representative)
assert len(representatives) == 64


def same_class(a, b):
    return tuple(x ^ y for x, y in zip(a, b)) in coboundaries


cycle = (1, 2, 3, 4, 0)
three_cycle = (1, 2, 0, 3, 4)
odd = (1, 0, 2, 3, 4)
fixed = [v for v in representatives
         if same_class(permute_voltage(cycle, v), v)
         and same_class(permute_voltage(three_cycle, v), v)]
assert len(fixed) == 4
zero = next(v for v in fixed if v in coboundaries)
nonzero = [v for v in fixed if v != zero]
odd_fixed = [v for v in nonzero if same_class(permute_voltage(odd, v), v)]
odd_pair = [v for v in nonzero if v not in odd_fixed]
assert len(odd_fixed) == 1 and len(odd_pair) == 2
assert same_class(permute_voltage(odd, odd_pair[0]), odd_pair[1])

print("INDEPENDENT REPLAY PASS")
print("H^1(Petersen,F2)=64 classes; A5 invariants=4")
print("nonzero invariants split under S5 as 1+2")
