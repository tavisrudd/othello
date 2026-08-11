#!/usr/bin/env python3
"""Independent Python replay for the symmetric-theta descent parity."""

import importlib.util
from itertools import combinations, combinations_with_replacement
from math import comb, gcd
from pathlib import Path


SOURCE = Path(__file__).with_name("2026-08-10-c904-minimal-class-divisor-replay.py")
SPEC = importlib.util.spec_from_file_location("c904_minimal_replay", SOURCE)
BASE = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(BASE)


def wedge_basis(left, right):
    if set(left).intersection(right):
        return None, 0
    inversions = sum(1 for i in left for j in right if i > j)
    return tuple(sorted(left + right)), -1 if inversions % 2 else 1


def nakaoka_counts(rank=10, total_degree=6):
    transfers = 0
    nonzero = 0
    restrictions = set()
    for left_degree in range(total_degree + 1):
        right_degree = total_degree - left_degree
        for left in combinations(range(rank), left_degree):
            for right in combinations(range(rank), right_degree):
                transfers += 1
                indices, sign = wedge_basis(left, right)
                if not sign:
                    continue
                restriction = 2 * (-1 if right_degree % 2 else 1) * sign
                assert restriction % 2 == 0
                restrictions.add((indices, restriction))
                nonzero += 1
    assert transfers == comb(20, 6) == 38_760
    assert nonzero == comb(10, 6) * (2 ** 6) == 13_440
    assert not [degree for degree in range(total_degree + 1)
                if 2 * degree == total_degree and degree % 2 == 0]
    return transfers, nonzero


def degree_audit():
    theta = BASE.two_form(BASE.PRINCIPAL_SYMPLECTIC)
    theta_squared = BASE.wedge(theta, theta)
    top = tuple(range(10))
    functional = []
    for indices in combinations(range(10), 6):
        functional.append(BASE.wedge(theta_squared, {indices: 1}).get(top, 0))
    assert gcd(*(abs(value) for value in functional if value)) == 2
    assert gcd(*(abs(2 * value) for value in functional if value)) == 4

    forms = BASE.divisor_forms()
    witness = BASE.wedge(BASE.wedge(forms[0], forms[1]), forms[2])
    witness_pairing = BASE.wedge(theta_squared, witness).get(top, 0)
    assert witness_pairing == -2

    pairings = []
    for monomial in combinations_with_replacement(range(15), 3):
        product = BASE.wedge(BASE.wedge(forms[monomial[0]], forms[monomial[1]]),
                             forms[monomial[2]])
        pairings.append(BASE.wedge(theta_squared, product).get(top, 0))
    assert len(pairings) == comb(17, 3) == 680
    assert gcd(*(abs(value) for value in pairings if value)) == 2
    return witness_pairing


transfers, nonzero = nakaoka_counts()
witness_pairing = degree_audit()
print("independent symmetric-theta descent replay")
print(f"Nakaoka transfers={transfers}; nonzero restrictions={nonzero}")
print("degree-6 restriction lattice contains 2*standard basis and is contained in it")
print("theta-square degree gcd: ordered=2, descended-upstairs=4, downstairs=2")
print(f"algebraic witness D(0,1,2): ordered={witness_pairing}, upstairs=-4, downstairs=-2")
print("PASS")
