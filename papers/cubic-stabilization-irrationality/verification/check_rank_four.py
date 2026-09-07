#!/usr/bin/env python3
"""Independent rational/integer check, with no symbolic-algebra dependency.

Determinants are computed in the ambient rank-five lattice by the Leibniz
formula, rather than in a chosen quotient by SymPy. Input matrices and Cox
weights are reconstructed independently. All finite domains are exhausted.
"""
from collections import Counter
from fractions import Fraction
from functools import reduce
from hashlib import sha256
from itertools import combinations, permutations, product
import json
from math import gcd
from pathlib import Path
import sys

if sys.flags.optimize:
    raise RuntimeError("assertions must be enabled")

HERE = Path(__file__).resolve().parent


def mv(a, v):
    return [sum(x*y for x, y in zip(row, v)) for row in a]


def sub(x, y):
    return [a-b for a, b in zip(x, y)]


def rank(a):
    a = [[Fraction(x) for x in row] for row in a]
    pivot = 0
    for col in range(len(a[0])):
        found = next((i for i in range(pivot, len(a)) if a[i][col]), None)
        if found is None:
            continue
        a[pivot], a[found] = a[found], a[pivot]
        d = a[pivot][col]
        a[pivot] = [x/d for x in a[pivot]]
        for i in range(pivot+1, len(a)):
            d = a[i][col]
            a[i] = [x-d*y for x, y in zip(a[i], a[pivot])]
        pivot += 1
    return pivot


SIGNED_PERMUTATIONS = [
    (p, (-1)**sum(p[i] > p[j] for i in range(5) for j in range(i+1, 5)))
    for p in permutations(range(5))
]


def det_columns(columns):
    total = 0
    for p, sign in SIGNED_PERMUTATIONS:
        term = sign
        for j in range(5):
            term *= columns[j][p[j]]
        total += term
    return total


def main():
    c = json.loads((HERE / "rank-four-certificate.json").read_text())
    assert c["schema"] == "cox-rank-four-v1"
    assert c["input_sha256"] == "89eee9a9d04cb555e45c8b4f461bbf20ccb6b1d38cfabdad2b8ce67c1ff42373"
    assert sha256((HERE / "derive_slice_cover.py").read_bytes()).hexdigest() == c["input_sha256"]
    generators = [
        [[-1,0,0,-1,-1],[1,1,1,0,2],[0,0,-1,-1,-1],[0,0,0,0,1],[0,0,0,1,0]],
        [[0,1,1,1,2],[-1,-1,0,0,-1],[0,0,1,0,0],[0,0,0,1,0],[0,0,-1,-1,-1]],
    ]
    assert c["character_generators"] == generators
    systems = []
    for signs in product((-1, 1), repeat=2):
        stacked = [[x - s*(i == j) for j, x in enumerate(row)]
                   for a, s in zip(generators, signs) for i, row in enumerate(a)]
        systems.append({"signs": list(signs), "rank": rank(stacked)})
    assert c["sign_systems"] == systems
    assert [s["rank"] for s in systems] == [5,4,5,5]
    m = c["primitive_character"]
    assert m == [-1,-1,-3,-3,3]
    primitive = lambda v: reduce(gcd, v) == 1
    assert primitive(m) and not primitive([2*x for x in m])
    assert mv(generators[0], m) == [-x for x in m]
    assert mv(generators[1], m) == m
    q = c["quotient_matrix"]
    assert mv(q, m) == [0]*4
    assert [row[1:] for row in q] == [[int(i == j) for j in range(4)] for i in range(4)]
    names = [f"E{i+1}" for i in range(5)]
    full = [[int(i == j) for j in range(5)] for i in range(4)] + [[0]*5]
    for i, j in combinations(range(5), 2):
        names.append(f"L{i+1}{j+1}")
        full.append([-int(h == i)-int(h == j) for h in range(4)]+[1])
    names.append("Q")
    full.append([-1,-1,-1,-1,2])
    assert c["names"] == names and c["full_weights"] == full
    restricted = [mv(q, w) for w in full]
    assert restricted == c["restricted_weights"]
    assert len(set(map(tuple, restricted))) == 16
    permutations_checked = []
    linear_without_shift_fails = []
    for a, record in zip(generators, c["affine_actions"]):
        perm = record["permutation"]
        assert sorted(perm) == list(range(16))
        # Check the full affine action first, without quotient coordinates.
        shifts = [sub(full[perm[i]], mv(a, full[i])) for i in range(16)]
        assert all(s == shifts[0] for s in shifts)
        assert mv(q, shifts[0]) == record["translation"]
        for i, w in enumerate(full):
            assert mv(record["linear"], mv(q, w)) == mv(q, mv(a, w))
            assert sub(restricted[perm[i]], mv(record["linear"], restricted[i])) == record["translation"]
        linear_without_shift_fails.append(
            set(tuple(mv(record["linear"], w)) for w in restricted) != set(map(tuple, restricted)))
        permutations_checked.append(perm)
    assert any(linear_without_shift_fails), "negative control must detect omitted translations"
    reachable = [{i} for i in range(16)]
    for _ in range(16):
        reachable = [s | {p[i] for p in permutations_checked for i in s} for s in reachable]
    orbits = sorted({tuple(sorted(s)) for s in reachable})
    assert [list(s) for s in orbits] == c["orbits"]
    assert sorted(map(len, orbits)) == [4,12]
    assert [names[i] for s in orbits if len(s) == 4 for i in s] == ["E3","E4","L34","Q"]
    histogram = Counter()
    descended = 0
    for chosen in combinations(range(16), 5):
        # det[m, w1-w0, ..., w4-w0] measures the integral quotient index.
        d = abs(det_columns([m] + [sub(full[i], full[chosen[0]]) for i in chosen[1:]]))
        histogram[str(d)] += 1
        descended += all({p[i] for i in chosen} == set(chosen) for p in permutations_checked)
    assert dict(histogram) == c["absolute_determinant_histogram"]
    assert sum(histogram.values()) == c["five_subset_count"] == 4368
    assert histogram["1"] == 1992 and descended == 0
    # Negative saturation control: replacing m by 2m doubles every determinant.
    example = next(t for t in combinations(range(16), 5)
                   if abs(det_columns([m]+[sub(full[i], full[t[0]]) for i in t[1:]])) == 1)
    assert abs(det_columns([[2*x for x in m]]+[sub(full[i], full[example[0]]) for i in example[1:]])) == 2
    blocks = {}
    for name, w in zip(names, full):
        blocks.setdefault(tuple(w[2:]), []).append(name)
    assert c["rank_three_blocks"] == [{"weight": list(w), "names": blocks[w]} for w in sorted(blocks)]
    triples = [set(v) for v in blocks.values() if len(v) == 3]
    assert len(triples) == 4
    large_orbit = {names[i] for s in orbits if len(s) == 12 for i in s}
    assert set.union(*triples) == large_orbit
    for p in permutations_checked:
        for block in triples:
            assert {names[p[names.index(n)]] for n in block} in triples
    print("independent rank-four check: all 4368 subsets; 1992 unimodular; "
          "0 descended five-subsets; saturation and translation controls passed")


if __name__ == "__main__":
    main()
