#!/usr/bin/env sage
"""Independent replay of the dyadic semisimplicity census.

The primary census constructs each principal overlattice and recovers its
complete integral Neron--Severi lattice by an ambient integrality kernel.
This replay instead uses the graph-chart centralizer congruence directly,

    C = pD,  DA = AD (mod p),

and recomputes the divisor-product Smith order from the resulting forms.
"""

from collections import Counter
from itertools import product


source = open(
    "notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class-replay.sage"
).read().split("def main():")[0]
exec(preparse(source))


def census(rank):
    field = GF(2)
    positions = symmetric_positions(rank)
    histogram = Counter()
    for values in product(field, repeat=len(positions)):
        slope = symmetric_matrix(vector(field, values), rank)
        squarefree = slope.minimal_polynomial().is_squarefree()
        order, _, _, _ = minimal_order(2, slope)
        histogram[(squarefree, order)] += 1
    return histogram


print("C904 independent dyadic graph semisimplicity census")
expected = {
    3: {(False, 2): 30, (True, 1): 34},
    4: {(False, 2): 526, (True, 1): 498},
}
for rank in (3, 4):
    histogram = census(rank)
    assert dict(histogram) == expected[rank]
    print(f"g={rank} total={sum(histogram.values())}")
    for key in sorted(histogram):
        print(f"  squarefree={key[0]} order={key[1]} count={histogram[key]}")
print("PASS")
