#!/usr/bin/env python3
"""Record-matching attack on the exceptional code ladder.

Three independent lines, all exact and deterministic:

  1. The overextended E10 carrier.  Its 496 nonsingular classes split by a
     root hyperplane as 256 + 240; the link half is the E9 code and folds to
     the E8 code, so the root-link-and-fold step of C682 is uniform up the
     whole ladder.
  2. Symmetry obstructions.  No O_8^+(2)-invariant code of dimension ten
     contains the E8 code, and no invariant code of dimension eleven contains
     the E9 code, so the record dimension at [120,10] and any invariant
     enlargement at the affine level are both unreachable with full symmetry.
  3. The Plotkin ceiling at [240,10], and the canonical Eisenstein F4 model of
     E8/2E8 that the distance-five quantum question needs.
"""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c867-ladder-record-attack.json"
E9_SOURCE = HERE / "2026-08-05-c865-e9-affine-level-code.py"

# codetables.de, read 2026-08-05.
SOTA = {
    "[120,9]": {"lower": 56, "upper": 56, "exact": True},
    "[120,10]": {"lower": 56, "upper": 56, "exact": True},
    "[240,10]": {"lower": 114, "upper": 116, "exact": False},
    "[256,10]": {"lower": 124, "upper": 124, "exact": True},
}


def parity(value):
    return value.bit_count() & 1


# ------------------------------------------------------------ linear algebra


def reduced_pivots(vectors):
    pivots = {}
    for vector in vectors:
        value = vector
        for pivot in sorted(pivots, reverse=True):
            if (value >> pivot) & 1:
                value ^= pivots[pivot]
        if value:
            pivot = value.bit_length() - 1
            for other in list(pivots):
                if (pivots[other] >> pivot) & 1:
                    pivots[other] ^= value
            pivots[pivot] = value
    return pivots


def nullspace(generators, width):
    pivots = reduced_pivots(generators)
    basis = []
    for free in range(width):
        if free in pivots:
            continue
        vector = 1 << free
        for pivot, row in pivots.items():
            if (row >> free) & 1:
                vector |= 1 << pivot
        basis.append(vector)
    for vector in basis:
        for generator in generators:
            assert (vector & generator).bit_count() % 2 == 0
    return basis


def span(rows):
    words = set()
    for coefficients in range(1 << len(rows)):
        word = 0
        for index, row in enumerate(rows):
            if (coefficients >> index) & 1:
                word ^= row
        words.add(word)
    return tuple(sorted(words))


def enumerator(words):
    return {
        str(weight): count
        for weight, count in sorted(Counter(word.bit_count() for word in words).items())
    }


def affine_rows(points, dimension):
    rows = [(1 << len(points)) - 1]
    for bit in range(dimension):
        rows.append(
            sum(((point >> bit) & 1) << index for index, point in enumerate(points))
        )
    return rows


def parameters(points, words):
    weights = [word.bit_count() for word in words if word]
    return [len(points), len(words).bit_length() - 1, min(weights)]


# ------------------------------------------------------- quadratic spaces


def plus_form(half):
    mask = (1 << half) - 1

    def quadratic(vector):
        return parity((vector & mask) & (vector >> half))

    def bilinear(left, right):
        return parity((left & mask) & (right >> half)) ^ parity(
            (left >> half) & (right & mask)
        )

    return quadratic, bilinear


# --------------------------------------------------- invariance obstruction


def invariant_dimension(points, rows, permutations):
    width = len(points)
    dual = nullspace(rows, width)
    constraints = []
    for permutation in permutations:
        for check in dual:
            image = 0
            for index in range(width):
                if (check >> permutation[index]) & 1:
                    image |= 1 << index
            difference = image ^ check
            if difference:
                constraints.append(difference)
    return len(nullspace(constraints, width)), len(dual)


def reflection_permutations(points, quadratic, bilinear, mask, extra=()):
    index_of = {point: index for index, point in enumerate(points)}
    generators = []
    for axis in points:
        base = axis & mask
        if quadratic(base) != 1:
            continue
        generators.append(
            [
                index_of[point ^ (base if bilinear(base, point & mask) else 0)]
                for point in points
            ]
        )
    generators.extend(extra)
    for permutation in generators:
        assert sorted(permutation) == list(range(len(points)))
    return generators


# ------------------------------------------------------ Eisenstein F4 model


ADD_TABLE = {
    (0, 0): 0, (0, 1): 1, (0, 2): 2, (0, 3): 3,
    (1, 1): 0, (1, 2): 3, (1, 3): 2,
    (2, 2): 0, (2, 3): 1,
    (3, 3): 0,
}


def field_add(left, right):
    return ADD_TABLE[(min(left, right), max(left, right))]


def field_mul(left, right):
    if left == 0 or right == 0:
        return 0
    return ((left - 1) + (right - 1)) % 3 + 1


def trace(value):
    return 0 if value in (0, 1) else 1


def eisenstein_model():
    vectors = list(itertools.product(range(4), repeat=4))

    def quadratic(vector):
        return sum(1 for entry in vector if entry) % 2

    def hermitian(left, right):
        total = 0
        for a, b in zip(left, right):
            total = field_add(total, field_mul(a, field_mul(b, b)))
        return total

    def scale(vector):
        return tuple(field_mul(2, entry) for entry in vector)

    nonsingular = [vector for vector in vectors if quadratic(vector) == 1]
    assert len(nonsingular) == 120
    weight_profile = Counter(
        sum(1 for entry in vector if entry) for vector in nonsingular
    )
    assert dict(weight_profile) == {1: 12, 3: 108}
    assert all(quadratic(scale(vector)) == quadratic(vector) for vector in vectors)
    orbits = {
        min([vector, scale(vector), scale(scale(vector))])
        for vector in nonsingular
    }
    assert len(orbits) == 40
    assert all(
        len({vector, scale(vector), scale(scale(vector))}) == 3
        for vector in nonsingular
    )

    def add_vectors(left, right):
        return tuple(field_add(a, b) for a, b in zip(left, right))

    for left in vectors:
        for right in vectors:
            assert quadratic(add_vectors(left, right)) == (
                quadratic(left) + quadratic(right) + trace(hermitian(left, right))
            ) % 2
    return {
        "space": "E8/2E8 = F4^4 with Q(v) = sum v_i^3 = (number of nonzero F4 coordinates) mod 2",
        "nonsingular": len(nonsingular),
        "f4_weight_profile": {str(key): value for key, value in sorted(weight_profile.items())},
        "omega_orbits": len(orbits),
        "all_orbits_free": True,
        "quadratic_form_identity": "Q(v+w) = Q(v) + Q(w) + Tr(h(v,w))",
    }


# ------------------------------------------------------------- certificate


def certificate():
    # --- E10 carrier and the uniform root-link-and-fold step.
    quadratic10, bilinear10 = plus_form(5)
    e10_points = tuple(v for v in range(1 << 10) if quadratic10(v) == 1)
    assert len(e10_points) == 496
    e10_code = span(affine_rows(e10_points, 10))
    assert parameters(e10_points, e10_code) == [496, 11, 240]
    assert enumerator(e10_code) == {"0": 1, "240": 1023, "256": 1023, "496": 1}

    axis = e10_points[0]
    hyperplane = tuple(p for p in e10_points if bilinear10(axis, p) == 0)
    link = tuple(p for p in e10_points if bilinear10(axis, p) == 1)
    assert (len(hyperplane), len(link)) == (256, 240)

    hyper_code = span(affine_rows(hyperplane, 10))
    assert parameters(hyperplane, hyper_code) == [256, 10, 120]
    assert enumerator(hyper_code) == {
        "0": 1, "120": 256, "128": 510, "136": 256, "256": 1
    }

    link_code = span(affine_rows(link, 10))
    assert parameters(link, link_code) == [240, 10, 112]
    assert enumerator(link_code) == {
        "0": 1, "112": 255, "120": 512, "128": 255, "240": 1
    }

    link_index = {point: index for index, point in enumerate(link)}
    pairs = tuple(sorted({tuple(sorted((p, p ^ axis))) for p in link}))
    assert len(pairs) == 120
    folded = set()
    for word in link_code:
        values = [
            ((word >> link_index[low]) & 1, (word >> link_index[high]) & 1)
            for low, high in pairs
        ]
        if all(low == high for low, high in values):
            folded.add(sum(low << index for index, (low, _) in enumerate(values)))
    folded = tuple(sorted(folded))
    assert parameters(pairs, folded) == [120, 9, 56]
    assert enumerator(folded) == {"0": 1, "56": 255, "64": 255, "120": 1}

    # --- Symmetry obstruction at the E8 and E9 levels.
    quadratic8, bilinear8 = plus_form(4)
    e8_points = tuple(v for v in range(256) if quadratic8(v) == 1)
    e8_rows = affine_rows(e8_points, 8)
    e8_generators = reflection_permutations(e8_points, quadratic8, bilinear8, 255)
    e8_invariant, e8_dual = invariant_dimension(e8_points, e8_rows, e8_generators)
    assert e8_invariant == 9 and e8_dual == 111

    e9_points = tuple(v for v in range(1 << 9) if quadratic8(v & 255) == 1)
    assert len(e9_points) == 240
    e9_rows = affine_rows(e9_points, 9)
    e9_index = {point: index for index, point in enumerate(e9_points)}
    level_shift = [e9_index[point ^ 256] for point in e9_points]
    e9_generators = reflection_permutations(
        e9_points, quadratic8, bilinear8, 255, extra=[level_shift]
    )
    e9_invariant, e9_dual = invariant_dimension(e9_points, e9_rows, e9_generators)
    assert e9_invariant == 10 and e9_dual == 230

    # --- Plotkin ceiling at [240,10].
    # Any |u|u+v| code of length 240 and dimension 10 with length-120 halves has
    # d = min(2 d1, d2) with k1 + k2 = 10.  The binary Plotkin bound gives
    # d2 <= 120 * 2^(k2-1) / (2^k2 - 1), so k2 >= 2 already forces d <= 80, and
    # k2 = 1 forces d <= 2 * 56 = 112 because 56 is the exact [120,9] optimum.
    plotkin_ceiling = {}
    for k2 in range(1, 10):
        k1 = 10 - k2
        d2 = (120 * (1 << (k2 - 1))) // ((1 << k2) - 1)
        d1 = 56 if k1 == 9 else 120 * (1 << (k1 - 1)) // ((1 << k1) - 1)
        plotkin_ceiling[str(k2)] = min(2 * d1, d2)
    assert max(plotkin_ceiling.values()) == 112
    assert plotkin_ceiling["1"] == 112

    return {
        "e10_ladder": {
            "carrier": "496 nonsingular classes of E10/2E10 = (E8 + U)/2, plus type of rank ten",
            "parameters": [496, 11, 240],
            "weight_enumerator": enumerator(e10_code),
            "root_hyperplane": {
                "points": len(hyperplane),
                "parameters": [256, 10, 120],
                "weight_enumerator": enumerator(hyper_code),
            },
            "root_link": {
                "points": len(link),
                "parameters": [240, 10, 112],
                "weight_enumerator": enumerator(link_code),
                "matches_e9_affine_root_code": True,
            },
            "link_fold": {
                "pairs": len(pairs),
                "parameters": [120, 9, 56],
                "weight_enumerator": enumerator(folded),
            },
        },
        "symmetry_obstruction": {
            "e8": {
                "group": "O_8^+(2) generated by all 120 reflections in nonsingular vectors",
                "code_dimension": 9,
                "largest_invariant_code_containing_it": e8_invariant,
                "invariant_extension_exists": e8_invariant > 9,
            },
            "e9": {
                "group": "O_8^+(2) together with the level translation by delta",
                "code_dimension": 10,
                "largest_invariant_code_containing_it": e9_invariant,
                "invariant_extension_exists": e9_invariant > 10,
            },
        },
        "plotkin_ceiling_240_10": {
            "by_second_component_dimension": plotkin_ceiling,
            "maximum": max(plotkin_ceiling.values()),
            "note": (
                "no |u|u+v| code of length 240 and dimension 10 with length-120 "
                "halves exceeds distance 112"
            ),
        },
        "eisenstein_f4_model": eisenstein_model(),
        "sota_comparison": {
            "codetables_read": "2026-08-05",
            "bounds": SOTA,
            "ours": {
                "[120,9]": 56,
                "[240,10]": 112,
                "[256,10]": 120,
                "[496,11]": 240,
            },
        },
        "input_sha256": {
            E9_SOURCE.name: hashlib.sha256(E9_SOURCE.read_bytes()).hexdigest()
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
