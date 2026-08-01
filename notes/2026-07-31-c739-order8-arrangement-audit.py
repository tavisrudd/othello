#!/usr/bin/env python3
"""Exact finite audit for the C739 Paley hyperplane arrangement on M_8."""

from collections import Counter
from importlib.util import module_from_spec, spec_from_file_location
from itertools import combinations, permutations
from pathlib import Path


N = 8


def load_hafnian_audit():
    path = Path(__file__).with_name("2026-07-31-c739-order8-hafnian-audit.py")
    spec = spec_from_file_location("c739_order8_hafnian_audit", path)
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load_hafnian_audit()
SUBSETS = tuple(
    sum(1 << vertex for vertex in subset)
    for subset in combinations(range(N), N // 2)
)
SUBSET_INDEX = {subset: position for position, subset in enumerate(SUBSETS)}
PARTITIONS_4_4 = tuple(mask for mask in SUBSETS if mask & 1)


def canonical_line(vector):
    first_nonzero = next(entry for entry in vector if entry)
    return tuple(-entry if first_nonzero < 0 else entry for entry in vector)


def collapsed_polynomial(vector, blocks):
    """Collect coefficients after identifying the variables in each block."""
    answer = Counter()
    for subset, coefficient in zip(SUBSETS, vector):
        if not coefficient:
            continue
        exponent = tuple((subset & block).bit_count() for block in blocks)
        answer[exponent] += coefficient
    return Counter({monomial: coefficient for monomial, coefficient in answer.items() if coefficient})


def boundary_order_4_4(vector, cluster):
    """Order for x_i=t*u_i on one side of a 4|4 partition."""
    return min(
        (subset & cluster).bit_count()
        for subset, coefficient in zip(SUBSETS, vector)
        if coefficient
    )


def main():
    coefficients = BASE.hafnian_difference_coefficients(BASE.paley_skew_conference())
    primitive = tuple(coefficients[subset] // 8 for subset in SUBSETS)
    assert Counter(primitive) == Counter({0: 42, 1: 14, -1: 14})

    # No 2|6 or 3|5 collision stratum is a component of one Paley section.
    # The projective stabilizer is sharply 3-transitive, but checking every
    # labelled subset makes the finite assertion independent of that fact.
    all_vertices = (1 << N) - 1
    for size in (2, 3):
        for cluster_tuple in combinations(range(N), size):
            cluster = sum(1 << vertex for vertex in cluster_tuple)
            singleton_blocks = tuple(1 << vertex for vertex in range(N) if not cluster >> vertex & 1)
            assert collapsed_polynomial(primitive, (cluster,) + singleton_blocks)

    orbit = {
        canonical_line(BASE.permute_vector(primitive, SUBSETS, SUBSET_INDEX, permutation))
        for permutation in permutations(range(N))
    }
    assert len(orbit) == 120

    # A 4|4 GIT point evaluates a line by its coefficient on either side.
    # Each line misses 21 of the 35 points and is nonzero at the other 14.
    # On a missed point the first cluster term is linear, so the corresponding
    # boundary divisor on Mbar_0,8 occurs simply in that one section.
    per_line = Counter()
    per_partition = {partition: Counter() for partition in PARTITIONS_4_4}
    for line in orbit:
        line_orders = Counter()
        for partition in PARTITIONS_4_4:
            complement = all_vertices ^ partition
            value = line[SUBSET_INDEX[complement]]
            order = boundary_order_4_4(line, partition)
            assert (value == 0) == (order == 1)
            assert order in (0, 1)
            line_orders[order] += 1
            per_partition[partition][order] += 1
        per_line[tuple(sorted(line_orders.items()))] += 1

    assert per_line == Counter({((0, 14), (1, 21)): 120})
    assert set(tuple(sorted(counts.items())) for counts in per_partition.values()) == {
        ((0, 48), (1, 72))
    }

    print("order-eight Paley arrangement finite audit: OK")
    print("components=120 distinct hyperplane sections in one S_8 orbit")
    print("4|4 incidence per section: 14 nonzero, 21 simple zeros")
    print("4|4 incidence per boundary divisor: 48 nonzero, 72 simple zeros")
    print("Delta_120 boundary multiplicities: 0 on 2|6, 0 on 3|5, 72 on 4|4")


if __name__ == "__main__":
    main()
