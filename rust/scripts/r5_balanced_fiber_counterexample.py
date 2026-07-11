#!/usr/bin/env python3
"""Six-vertex Node-Kayles counterexample to balanced-cover sufficiency."""

from functools import lru_cache


# Indices: 0+, 1+, 0-, 1-, 2+, 2-.  The first four edges are the
# all-parallel (balanced) double cover of the base path 1--0--2.  The last
# two are fixed fiber edges at base vertices 0 and 1.
EDGES = ((0, 1), (2, 3), (0, 4), (2, 5), (0, 2), (1, 3))
N = 6
ADJACENCY = [0] * N
for x, y in EDGES:
    ADJACENCY[x] |= 1 << y
    ADJACENCY[y] |= 1 << x


@lru_cache(None)
def sg(mask):
    options = {
        sg(mask & ~((1 << vertex) | ADJACENCY[vertex]))
        for vertex in range(N) if (mask >> vertex) & 1
    }
    value = 0
    while value in options:
        value += 1
    return value


full = (1 << N) - 1
print("edges", EDGES)
print("adjacency", tuple(tuple(v for v in range(N) if ADJACENCY[u] >> v & 1) for u in range(N)))
print("option_sg", tuple(sg(full & ~((1 << v) | ADJACENCY[v])) for v in range(N)))
print("root_sg", sg(full))
