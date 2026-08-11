#!/usr/bin/env sage
"""Test the first semisimplicity pattern for dyadic graph gluings.

This is a bounded exact census in graph charts only.  It reuses the complete
integral-lattice routines from the committed arbitrary-Lagrangian certificate
and groups the minimal-class divisor-product order by squarefreeness of the
slope's minimal polynomial.
"""

from collections import Counter
from itertools import product


source = open(
    "notes/2026-08-11-c904-arbitrary-lagrangian-minimal-class.sage"
).read().split("def main():")[0]
exec(preparse(source))


def graph_census(rank):
    field = GF(2)
    positions = [(i, j) for i in range(rank) for j in range(i, rank)]
    histogram = Counter()
    polynomial_histogram = Counter()
    for values in product(field, repeat=len(positions)):
        slope = zero_matrix(field, rank)
        for value, (i, j) in zip(values, positions):
            slope[i, j] = value
            slope[j, i] = value
        graph = block_matrix(field, [[identity_matrix(field, rank), slope]])
        basis, principal = principal_lattice(2, graph)
        coefficient_positions, lattice = ns_lattice(basis)
        order, _, _ = minimal_order(
            basis, principal, coefficient_positions, lattice
        )
        minimal_polynomial = slope.minimal_polynomial()
        squarefree = minimal_polynomial.is_squarefree()
        histogram[(squarefree, int(order))] += 1
        polynomial_histogram[(str(minimal_polynomial), int(order))] += 1
    return histogram, polynomial_histogram


def deterministic_sample(prime, rank, per_class):
    """Take the first exact graph slopes in each semisimplicity class."""
    field = GF(prime)
    positions = [(i, j) for i in range(rank) for j in range(i, rank)]
    histogram = Counter()
    selected = Counter()
    for values in product(field, repeat=len(positions)):
        slope = zero_matrix(field, rank)
        for value, (i, j) in zip(values, positions):
            slope[i, j] = value
            slope[j, i] = value
        squarefree = slope.minimal_polynomial().is_squarefree()
        if selected[squarefree] >= per_class:
            continue
        graph = block_matrix(field, [[identity_matrix(field, rank), slope]])
        basis, principal = principal_lattice(prime, graph)
        coefficient_positions, lattice = ns_lattice(basis)
        order, _, _ = minimal_order(
            basis, principal, coefficient_positions, lattice
        )
        histogram[(squarefree, int(order))] += 1
        selected[squarefree] += 1
        if selected[True] == per_class and selected[False] == per_class:
            break
    assert selected[True] == per_class and selected[False] == per_class
    return histogram


print("C904 dyadic graph semisimplicity census")
for rank in (3, 4):
    histogram, polynomial_histogram = graph_census(rank)
    print(f"g={rank} total={sum(histogram.values())}")
    for key in sorted(histogram):
        print(f"  squarefree={key[0]} order={key[1]} count={histogram[key]}")
    if rank == 3:
        for key in sorted(polynomial_histogram):
            print(f"  minpoly={key[0]} order={key[1]} count={polynomial_histogram[key]}")
sample = deterministic_sample(2, 5, 8)
print("p=2 g=5 deterministic_sample_per_class=8")
for key in sorted(sample):
    print(f"  squarefree={key[0]} order={key[1]} count={sample[key]}")
sample = deterministic_sample(3, 4, 8)
print("p=3 g=4 deterministic_sample_per_class=8")
for key in sorted(sample):
    print(f"  squarefree={key[0]} order={key[1]} count={sample[key]}")
print("PASS")
