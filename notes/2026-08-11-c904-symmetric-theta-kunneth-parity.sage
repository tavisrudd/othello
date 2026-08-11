"""Exact Lefschetz-lattice replay for the C904 symmetric-theta gate."""

from itertools import combinations
from collections import Counter


def wedge_theta_matrix(source_degree):
    """Matrix of theta wedge: exterior^k Z^10 -> exterior^(k+2) Z^10."""
    ambient_rank = 10
    source = list(combinations(range(ambient_rank), source_degree))
    target = list(combinations(range(ambient_rank), source_degree + 2))
    target_index = {basis: row for row, basis in enumerate(target)}
    matrix_l = matrix(ZZ, len(target), len(source))
    for column, basis in enumerate(source):
        for pair_index in range(5):
            left, right = 2 * pair_index, 2 * pair_index + 1
            if left in basis or right in basis:
                continue
            word = list(basis) + [left, right]
            inversions = sum(
                1
                for i in range(len(word))
                for j in range(i + 1, len(word))
                if word[i] > word[j]
            )
            row = target_index[tuple(sorted(word))]
            matrix_l[row, column] += (-1) ** inversions
    return matrix_l


def nonzero_smith_counts(matrix_l):
    return Counter(entry for entry in matrix_l.elementary_divisors() if entry)


l_1 = wedge_theta_matrix(1)
l_2 = wedge_theta_matrix(2)
l_4 = wedge_theta_matrix(4)
l_5 = wedge_theta_matrix(5)

assert l_5.rank() == 120
assert nonzero_smith_counts(l_5) == Counter({1: 110, 2: 10})
assert l_4.rank() == 210
assert nonzero_smith_counts(l_4) == Counter({1: 166, 2: 43, 6: 1})

assert (l_5.change_ring(GF(2)).rank(), l_1.change_ring(GF(2)).rank()) == (110, 10)
assert (l_4.change_ring(GF(2)).rank(), l_2.change_ring(GF(2)).rank()) == (166, 44)
assert 110 + 10 == 120
assert 166 + 44 == 210

print("L: exterior^5 -> exterior^7: Smith 1^110 2^10")
print("mod-2 residual pairing: rank(im L_1)=10, corank(im L_5)=10")
print("L: exterior^4 -> exterior^6: Smith 1^166 2^43 6^1")
print("mod-2 residual pairing: rank(im L_2)=44, corank(im L_4)=44")
print("p=3/3: both Gysin factors contain theta, so theta^2 forces even degree")
