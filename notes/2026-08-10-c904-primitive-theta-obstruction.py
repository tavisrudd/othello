#!/usr/bin/env python3
"""Integral Lefschetz obstruction for the primitive curve class on theta.

The symplectic lattice has five ordered hyperbolic pairs.  The script checks
that multiplication by theta from exterior degree 6 to degree 8 has mod-2
rank 44, that the minimal curve class is the missing mod-2 coset, and that a
five-cycle of triple-pair monomials maps integrally to twice that class.
"""

from itertools import combinations


RANK = 10
PAIRS = ((0, 1), (2, 3), (4, 5), (6, 7), (8, 9))


def wedge_sign(left, right):
    if set(left) & set(right):
        return 0
    inversions = sum(a > b for a in left for b in right)
    return -1 if inversions % 2 else 1


def wedge(left, right):
    answer = {}
    for left_indices, left_value in left.items():
        for right_indices, right_value in right.items():
            sign = wedge_sign(left_indices, right_indices)
            if sign:
                indices = tuple(sorted(left_indices + right_indices))
                answer[indices] = answer.get(indices, 0) + sign * left_value * right_value
    return {indices: value for indices, value in answer.items() if value}


def gaussian_rank_and_membership(rows, target):
    pivots = {}
    inconsistent = False
    for mask, value in zip(rows, target):
        while mask:
            pivot = mask.bit_length() - 1
            if pivot in pivots:
                mask ^= pivots[pivot][0]
                value ^= pivots[pivot][1]
            else:
                pivots[pivot] = (mask, value)
                break
        if not mask and value:
            inconsistent = True
    return len(pivots), not inconsistent


def main():
    theta = {pair: 1 for pair in PAIRS}

    degree_six = list(combinations(range(RANK), 6))
    degree_eight = list(combinations(range(RANK), 8))
    target_index = {indices: index for index, indices in enumerate(degree_eight)}

    rows = [0] * len(degree_eight)
    for column, indices in enumerate(degree_six):
        image = wedge(theta, {indices: 1})
        for output, coefficient in image.items():
            if coefficient % 2:
                rows[target_index[output]] ^= 1 << column

    minimal = {}
    pair_labels = range(5)
    for chosen in combinations(pair_labels, 4):
        indices = tuple(sorted(value for label in chosen for value in PAIRS[label]))
        minimal[indices] = 1
    target = [minimal.get(indices, 0) % 2 for indices in degree_eight]
    rank, lies_in_image = gaussian_rank_and_membership(rows, target)
    assert rank == 44
    assert not lies_in_image

    # A 5-cycle in K_5 has degree two at every vertex.  A triple of pair
    # labels is indexed by the complementary edge.  Hence its sum maps to
    # twice every four-pair monomial.
    cycle_edges = {(0, 1), (1, 2), (2, 3), (3, 4), (0, 4)}
    half_source = {}
    for edge in cycle_edges:
        chosen = [label for label in pair_labels if label not in edge]
        indices = tuple(sorted(value for label in chosen for value in PAIRS[label]))
        half_source[indices] = 1
    assert wedge(theta, half_source) == {
        indices: 2 * coefficient for indices, coefficient in minimal.items()
    }

    top = tuple(range(RANK))
    theta_degree = wedge(theta, minimal)[top]
    assert theta_degree == 5

    print("C904 primitive-theta integral obstruction")
    print(f"mod-2 Lefschetz rank: {rank}/45")
    print("minimal class in integral Lefschetz image: no")
    print("twice minimal class in image: yes (five-cycle witness)")
    print(f"theta degree of minimal class: {theta_degree}")


if __name__ == "__main__":
    main()
