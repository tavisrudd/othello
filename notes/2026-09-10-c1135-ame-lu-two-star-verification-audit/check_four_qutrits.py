from collections import Counter
from fractions import Fraction
from itertools import combinations, product
import json


def check_four_qutrits():
    coefficients = tuple(product(range(3), repeat=4))
    labels = tuple(
        tuple(zip((x, y, (x+y) % 3, (x+2*y) % 3),
                  ((-u-v) % 3, (-u-2*v) % 3, u, v)))
        for x, y, u, v in coefficients
    )
    assert len(set(labels)) == 81
    assert min(sum(a != (0, 0) for a in label) for label in labels[1:]) == 3
    assert all(sum(a*d-b*c for (a,b),(c,d) in zip(v,w)) % 3 == 0
               for v, w in combinations(labels, 2))
    supports = ({0,1,2}, {0,1,3}, {0,2,3}, {1,2,3})
    groups = tuple(tuple(c for c,v in zip(coefficients, labels)
                         if all(v[j] == (0,0) for j in range(4) if j not in S))
                   for S in supports)
    assert all(len(g) == 9 for g in groups)
    for a, b in combinations(groups, 2):
        sums = {tuple((x+y) % 3 for x,y in zip(v,w)) for v in a for w in b}
        assert len(sums) == 81
    failures = {
        chi: tuple(any(sum(a*b for a,b in zip(chi,c)) % 3 for c in g) for g in groups)
        for chi in coefficients[1:]
    }
    histogram = Counter(sum(f) for f in failures.values())
    assert histogram == {3: 32, 4: 48}
    for s in range(1, 5):
        for selection in combinations(range(4), s):
            observed = min(Fraction(sum(f[i] for i in selection), s) for f in failures.values())
            assert observed == Fraction(s-1, s)
    weights = tuple(Fraction(i,6) for i in range(4))
    assert min(sum(w*b for w,b in zip(weights,f)) for f in failures.values()) == sum(sorted(weights)[:3])
    z1_character = (2,0,0,0)
    assert failures[z1_character] == (True, True, True, False)
    return {
        'state': 'AME(4,3) from revised manuscript, four-qutrit example',
        'label_count': len(labels),
        'pairwise_symplectic_commutation': True,
        'minimum_nonzero_support': 3,
        'each_triple_support_subgroup_size': 9,
        'every_pair_of_test_subgroups_spans': True,
        'nontrivial_character_failure_histogram': dict(histogram),
        'all_15_nonempty_test_subsets_match_tradeoff': True,
        'weighted_gap_check': True,
        'Z1_shift_failure_pattern': list(failures[z1_character]),
        'Z1_shift_rejection_probability': '3/4',
    }


if __name__ == '__main__':
    print(json.dumps(check_four_qutrits(), indent=2))
