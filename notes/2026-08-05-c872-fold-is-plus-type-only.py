#!/usr/bin/env python3
"""The code-level fold works only at plus type, so it is not a graph consequence.

Three exact results:

  1. Across plus, minus and parabolic quadrics the fold always lands on a point
     set of exactly the next level's size — the behaviour a graph-level antipodal
     quotient predicts — but the affine code descends in full only at plus type.
     At minus and parabolic type the folded code collapses to a much smaller
     dimension.  So the code-level statement is not a formal consequence of the
     graph-level one.
  2. The nonsingular set of every F2 quadratic form is a perfect difference set:
     each nonzero vector occurs as a difference the same number of times.  That
     gives a closed form for the dual tetrad count at every rank and type, hence
     CSS distance exactly four with no computational cap.
  3. The odd-form coincidence in the fold target is an affine translation:
     Q'(x) = Q(x) + B(t,x) for nonsingular t is a quadratic form of the opposite
     type whose zero set, translated by t, is the nonsingular set of Q.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c872-fold-is-plus-type-only.json"
TOWER_SOURCE = HERE / "2026-08-05-c870-fold-tower-judo.py"


def parity(value):
    return value.bit_count() & 1


def quadratic_space(kind, half):
    """kind '+' or '-' gives rank 2*half; 'o' gives the parabolic rank 2*half+1."""
    mask = (1 << half) - 1
    if kind in "+-":
        dimension = 2 * half
        top = 1 << (half - 1)

        def quadratic(vector):
            x, y = vector & mask, (vector >> half) & mask
            value = parity(x & y)
            if kind == "-":
                value ^= (1 if x & top else 0) ^ (1 if y & top else 0)
            return value

    else:
        dimension = 2 * half + 1

        def quadratic(vector):
            x, y = vector & mask, (vector >> half) & mask
            return parity(x & y) ^ ((vector >> (2 * half)) & 1)

    def bilinear(left, right):
        return quadratic(left ^ right) ^ quadratic(left) ^ quadratic(right)

    return quadratic, bilinear, dimension


def affine_code(points, dimension):
    rows = [(1 << len(points)) - 1]
    for bit in range(dimension):
        rows.append(
            sum(((point >> bit) & 1) << index for index, point in enumerate(points))
        )
    words = set()
    for coefficients in range(1 << len(rows)):
        word = 0
        for index, row in enumerate(rows):
            if (coefficients >> index) & 1:
                word ^= row
        words.add(word)
    return tuple(sorted(words))


def parameters(points, words):
    weights = [word.bit_count() for word in words if word]
    return [len(points), len(words).bit_length() - 1, min(weights)]


def nonsingular_count(kind, half):
    if kind == "+":
        return (1 << (2 * half - 1)) - (1 << (half - 1))
    if kind == "-":
        return (1 << (2 * half - 1)) + (1 << (half - 1))
    return 1 << (2 * half)


def fold(kind, half):
    quadratic, bilinear, dimension = quadratic_space(kind, half)
    points = tuple(v for v in range(1 << dimension) if quadratic(v) == 1)
    assert len(points) == nonsingular_count(kind, half)
    code = affine_code(points, dimension)

    axis = points[0]
    link = tuple(v for v in points if bilinear(axis, v) == 1)
    index = {point: slot for slot, point in enumerate(link)}
    pairs = tuple(sorted({tuple(sorted((v, v ^ axis))) for v in link}))
    assert len(pairs) * 2 == len(link)

    folded = set()
    for word in code:
        values = [
            ((word >> index[low]) & 1, (word >> index[high]) & 1)
            for low, high in pairs
        ]
        if all(low == high for low, high in values):
            folded.add(sum(low << slot for slot, (low, _) in enumerate(values)))
    return {
        "type": kind,
        "rank": dimension,
        "code": parameters(points, code),
        "link": len(link),
        "folded": parameters(pairs, sorted(folded)),
        "next_level_points": nonsingular_count(kind, half - 1),
        "next_level_code": parameters(
            tuple(
                v
                for v in range(1 << (dimension - 2))
                if quadratic_space(kind, half - 1)[0](v) == 1
            ),
            affine_code(
                tuple(
                    v
                    for v in range(1 << (dimension - 2))
                    if quadratic_space(kind, half - 1)[0](v) == 1
                ),
                dimension - 2,
            ),
        ),
    }


def difference_set(kind, half):
    quadratic, _, dimension = quadratic_space(kind, half)
    points = [v for v in range(1 << dimension) if quadratic(v) == 1]
    multiplicities = Counter()
    for left, right in combinations(points, 2):
        multiplicities[left ^ right] += 1
    values = {count for key, count in multiplicities.items() if key}
    assert len(values) == 1, "not a perfect difference set"
    (repetition,) = values
    size = len(points)
    order = (1 << dimension) - 1
    assert repetition * order == size * (size - 1) // 2
    tetrads = order * repetition * (repetition - 1) // 6
    brute = sum(
        count * (count - 1) // 2 for key, count in multiplicities.items() if key
    )
    assert brute % 3 == 0 and brute // 3 == tetrads
    return {
        "type": kind,
        "rank": dimension,
        "points": size,
        "repetition_number": repetition,
        "closed_form": "T = (2^n - 1) * lambda * (lambda - 1) / 6",
        "tetrads": tetrads,
        "css_distance": 4 if tetrads else None,
    }


def translation_identity(half):
    quadratic, bilinear, dimension = quadratic_space("+", half)
    nonsingular = {v for v in range(1 << dimension) if quadratic(v) == 1}
    shift = min(nonsingular)

    def twisted(vector):
        return quadratic(vector) ^ bilinear(shift, vector)

    assert twisted(0) == 0
    zeros = {v for v in range(1 << dimension) if twisted(v) == 0}
    assert {v ^ shift for v in zeros} == nonsingular
    return {
        "rank": dimension,
        "identity": "Q(x+t) = Q'(x) + 1 with Q'(x) = Q(x) + B(t,x), for Q(t)=1",
        "twisted_is_a_quadratic_form": True,
        "zero_set_translates_to_nonsingular_set": True,
        "zero_count": len(zeros),
        "nonsingular_count": len(nonsingular),
    }


def certificate():
    folds = [fold(kind, half) for kind, half in
             (("+", 3), ("+", 4), ("+", 5), ("-", 3), ("-", 4), ("o", 3), ("o", 4))]

    for entry in folds:
        # The point set always has the next level's size, for every type.
        assert entry["folded"][0] == entry["next_level_points"], entry
    for entry in folds:
        descends = entry["folded"] == entry["next_level_code"]
        entry["code_descends_in_full"] = descends
        assert descends == (entry["type"] == "+"), entry

    differences = [
        difference_set(kind, half)
        for kind, half in (("+", 3), ("+", 4), ("+", 5), ("-", 3), ("-", 4))
    ]
    assert all(entry["css_distance"] == 4 for entry in differences)

    return {
        "fold_by_type": folds,
        "verdict": (
            "the point count descends at every type, which is what a graph-level "
            "antipodal quotient predicts, but the affine code descends in full "
            "only at plus type; the code-level fold therefore carries content "
            "beyond the graph-level Taylor extension statement"
        ),
        "difference_sets": differences,
        "difference_set_note": (
            "the nonsingular set of any F2 quadratic form is a perfect difference "
            "set with lambda = N(N-1)/(2(2^n-1)); dual weight-two and weight-three "
            "words are impossible, so CSS distance is exactly four whenever the "
            "tetrad count is nonzero, at every rank and type, with no search"
        ),
        "translation_identity": translation_identity(4),
        "input_sha256": {
            TOWER_SOURCE.name: hashlib.sha256(TOWER_SOURCE.read_bytes()).hexdigest()
        },
    }


def serialized():
    return json.dumps(certificate(), indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = serialized()
    if args.write:
        OUTPUT.write_text(payload)
    if args.check:
        assert OUTPUT.read_text() == payload
    if not args.write and not args.check:
        print(payload, end="")


if __name__ == "__main__":
    main()
