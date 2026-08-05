#!/usr/bin/env python3
"""Exact affine E9 level code and its level fold onto the E8 root-pair code.

The carrier is the mod-2 reduction of the affine root lattice
E9 = Q(E8) + Z.delta with delta isotropic and in the radical.  The real
affine roots alpha + n.delta reduce to the 240 nonsingular vectors of
E9/2E9, and affine linear functions restricted there give [240,10,112]_2.
Everything is built from an integral E8 root basis first, then transported
to the packed x.y model used by 2026-08-05-c682-e8-root-pair-ladder.py by an
explicitly constructed isometry.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from fractions import Fraction
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c865-e9-affine-level-code.json"
E8_SOURCE = HERE / "2026-08-05-c682-e8-root-pair-ladder.py"

# Best-known bounds for a binary [240,10] code, read from
# https://www.codetables.de/BKLC/BKLC.php?q=2&n=240&k=10 on 2026-08-05.
CODETABLES_240_10 = {"lower": 114, "upper": 116, "exact": False}


def parity(value):
    return value.bit_count() & 1


# ---------------------------------------------------------------- E8 lattice


def simple_roots():
    half = Fraction(1, 2)
    unit = [[Fraction(0)] * 8 for _ in range(8)]
    for index in range(8):
        unit[index][index] = Fraction(1)

    def combine(*terms):
        vector = [Fraction(0)] * 8
        for coefficient, basis_index in terms:
            for slot in range(8):
                vector[slot] += coefficient * unit[basis_index][slot]
        return tuple(vector)

    alpha1 = tuple(
        half * sign
        for sign in (1, -1, -1, -1, -1, -1, -1, 1)
    )
    return (
        alpha1,
        combine((Fraction(1), 0), (Fraction(1), 1)),
        combine((Fraction(1), 1), (Fraction(-1), 0)),
        combine((Fraction(1), 2), (Fraction(-1), 1)),
        combine((Fraction(1), 3), (Fraction(-1), 2)),
        combine((Fraction(1), 4), (Fraction(-1), 3)),
        combine((Fraction(1), 5), (Fraction(-1), 4)),
        combine((Fraction(1), 6), (Fraction(-1), 5)),
    )


def all_roots():
    roots = []
    for left, right in combinations(range(8), 2):
        for left_sign in (1, -1):
            for right_sign in (1, -1):
                vector = [Fraction(0)] * 8
                vector[left] = Fraction(left_sign)
                vector[right] = Fraction(right_sign)
                roots.append(tuple(vector))
    for pattern in range(256):
        if parity(pattern):
            continue
        roots.append(
            tuple(
                Fraction(-1, 2) if (pattern >> slot) & 1 else Fraction(1, 2)
                for slot in range(8)
            )
        )
    assert len(roots) == 240
    return tuple(roots)


def dot(left, right):
    return sum(a * b for a, b in zip(left, right))


def solve(matrix_columns, target):
    """Solve sum_j c_j * column_j = target over Q by Gaussian elimination."""
    size = len(target)
    rows = [
        [matrix_columns[column][row] for column in range(len(matrix_columns))]
        + [target[row]]
        for row in range(size)
    ]
    width = len(matrix_columns)
    pivot_row = 0
    pivots = []
    for column in range(width):
        selected = None
        for row in range(pivot_row, size):
            if rows[row][column] != 0:
                selected = row
                break
        if selected is None:
            continue
        rows[pivot_row], rows[selected] = rows[selected], rows[pivot_row]
        scale = rows[pivot_row][column]
        rows[pivot_row] = [entry / scale for entry in rows[pivot_row]]
        for row in range(size):
            if row == pivot_row or rows[row][column] == 0:
                continue
            factor = rows[row][column]
            rows[row] = [
                entry - factor * pivot
                for entry, pivot in zip(rows[row], rows[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
    solution = [Fraction(0)] * width
    for index, column in enumerate(pivots):
        solution[column] = rows[index][width]
    for row in range(size):
        if all(entry == 0 for entry in rows[row][:width]) and rows[row][width] != 0:
            raise AssertionError("target outside the lattice basis span")
    return tuple(solution)


def root_coordinates():
    basis = simple_roots()
    gram = [[dot(left, right) for right in basis] for left in basis]
    assert all(gram[index][index] == 2 for index in range(8))
    coordinates = []
    for root in all_roots():
        raw = solve(basis, root)
        assert all(value.denominator == 1 for value in raw)
        coordinates.append(tuple(int(value) % 2 for value in raw))
    return basis, gram, tuple(coordinates)


# ------------------------------------------------- intrinsic mod-2 E9 model


def pack(bits):
    return sum(bit << index for index, bit in enumerate(bits))


def intrinsic_forms(gram):
    """Quadratic form q(x)=x.x/2 mod 2 and its polarization on E9/2E9."""

    extended = [row + [0] for row in [list(entry) for entry in gram]]
    extended.append([0] * 9)

    def quadratic(vector):
        bits = [(vector >> index) & 1 for index in range(9)]
        total = Fraction(0)
        for i in range(9):
            for j in range(9):
                total += Fraction(bits[i] * bits[j]) * extended[i][j]
        half = total / 2
        assert half.denominator == 1
        return int(half) % 2

    def bilinear(left, right):
        left_bits = [(left >> index) & 1 for index in range(9)]
        right_bits = [(right >> index) & 1 for index in range(9)]
        total = 0
        for i in range(9):
            for j in range(9):
                total += left_bits[i] * right_bits[j] * int(extended[i][j])
        return total % 2

    return quadratic, bilinear


# --------------------------------------------------------------- packed model


def packed_quadratic(vector):
    return parity((vector & 15) & (vector >> 4))


def packed_bilinear(left, right):
    left_x, left_y = left & 15, (left >> 4) & 15
    right_x, right_y = right & 15, (right >> 4) & 15
    return parity(left_x & right_y) ^ parity(left_y & right_x)


def hyperbolic_basis(dimension, quadratic, bilinear, ambient):
    """Deterministic symplectic-hyperbolic basis of a plus-type F_2 space."""
    pairs = []
    used = []

    def independent(candidate):
        return all(bilinear(candidate, vector) == 0 for vector in used)

    for _ in range(dimension // 2):
        singular = [
            vector
            for vector in range(1, ambient)
            if quadratic(vector) == 0 and independent(vector)
        ]
        first = None
        second = None
        for candidate in singular:
            partners = [
                other
                for other in singular
                if bilinear(candidate, other) == 1
            ]
            if partners:
                first, second = candidate, partners[0]
                break
        assert first is not None
        pairs.append((first, second))
        used.extend((first, second))
    return tuple(pairs)


def transport(pairs_source, pairs_target, dimension):
    """Linear map sending one hyperbolic basis to another, as a bit table."""
    source_basis = []
    target_basis = []
    for (source_e, source_f), (target_e, target_f) in zip(pairs_source, pairs_target):
        source_basis.append(source_e)
        target_basis.append(target_e)
        source_basis.append(source_f)
        target_basis.append(target_f)
    size = len(source_basis)
    assert size == dimension
    # Invert the source basis to read off coordinates of an arbitrary vector.
    rows = [
        (source_basis[index], 1 << index) for index in range(size)
    ]
    pivots = {}
    for vector, tag in rows:
        value, label = vector, tag
        for pivot in sorted(pivots, reverse=True):
            if (value >> pivot) & 1:
                other_value, other_label = pivots[pivot]
                value ^= other_value
                label ^= other_label
        assert value, "source basis is dependent"
        pivots[value.bit_length() - 1] = (value, label)

    def coordinates(vector):
        value, label = vector, 0
        for pivot in sorted(pivots, reverse=True):
            if (value >> pivot) & 1:
                other_value, other_label = pivots[pivot]
                value ^= other_value
                label ^= other_label
        assert value == 0, "vector outside the basis span"
        return label

    def apply(vector):
        label = coordinates(vector)
        image = 0
        for index in range(size):
            if (label >> index) & 1:
                image ^= target_basis[index]
        return image

    return apply


# ------------------------------------------------------------------- codes


def affine_code(points, dimension):
    rows = [(1 << len(points)) - 1]
    for bit in range(dimension):
        rows.append(
            sum(((point >> bit) & 1) << index for index, point in enumerate(points))
        )
    words = []
    for coefficients in range(1 << len(rows)):
        word = 0
        for index, row in enumerate(rows):
            if (coefficients >> index) & 1:
                word ^= row
        words.append(word)
    assert len(set(words)) == 1 << len(rows), "affine restriction is not injective"
    return tuple(rows), tuple(sorted(words))


def enumerator(words):
    return {
        str(weight): count
        for weight, count in sorted(Counter(word.bit_count() for word in words).items())
    }


def four_subset_count(points):
    """Unordered 4-subsets of distinct points summing to zero."""
    sums = Counter()
    for left, right in combinations(points, 2):
        sums[left ^ right] += 1
    total = sum(count * (count - 1) // 2 for value, count in sums.items() if value)
    assert total % 3 == 0
    return total // 3


# ------------------------------------------------------------- certificate


def certificate():
    basis, gram, coordinates = root_coordinates()
    classes = {pack(vector) for vector in coordinates}
    assert len(classes) == 120

    quadratic, bilinear = intrinsic_forms(gram)
    delta = 1 << 8
    assert quadratic(delta) == 0
    assert all(bilinear(delta, vector) == 0 for vector in range(1 << 9))

    intrinsic_points = tuple(
        vector for vector in range(1 << 9) if quadratic(vector) == 1
    )
    assert len(intrinsic_points) == 240

    # The nonsingular set is exactly the mod-2 image of the real affine roots.
    affine_root_images = {
        pack(vector) ^ (level << 8)
        for vector in coordinates
        for level in (0, 1)
    }
    assert affine_root_images == set(intrinsic_points)

    # Transport the intrinsic E8 part onto the packed x.y model of C682.
    def restricted_quadratic(vector):
        return quadratic(vector)

    def restricted_bilinear(left, right):
        return bilinear(left, right)

    source_pairs = hyperbolic_basis(8, restricted_quadratic, restricted_bilinear, 256)
    target_pairs = hyperbolic_basis(8, packed_quadratic, packed_bilinear, 256)
    isometry = transport(source_pairs, target_pairs, 8)
    for left in range(256):
        assert packed_quadratic(isometry(left)) == quadratic(left)
        for right in range(0, 256, 7):
            assert packed_bilinear(isometry(left), isometry(right)) == bilinear(
                left, right
            )
    packed_classes = {isometry(vector) for vector in classes}
    assert packed_classes == {
        vector for vector in range(256) if packed_quadratic(vector) == 1
    }

    # E9 code on the intrinsic carrier.
    rows, code = affine_code(intrinsic_points, 9)
    assert len(rows) == 10
    assert len(code) == 1024
    weight_enumerator = enumerator(code)
    assert weight_enumerator == {
        "0": 1,
        "112": 255,
        "120": 512,
        "128": 255,
        "240": 1,
    }
    minimum_distance = min(word.bit_count() for word in code if word)
    assert minimum_distance == 112
    assert all(word.bit_count() % 8 == 0 for word in code)
    assert all(
        (left & right).bit_count() % 2 == 0 for left in rows for right in rows
    )

    # Level fold: pair each point with its delta translate and fold.
    index_of = {point: index for index, point in enumerate(intrinsic_points)}
    level_pairs = tuple(
        sorted(
            {
                tuple(sorted((point, point ^ delta)))
                for point in intrinsic_points
            }
        )
    )
    assert len(level_pairs) == 120
    folded = []
    for word in code:
        values = [
            ((word >> index_of[low]) & 1, (word >> index_of[high]) & 1)
            for low, high in level_pairs
        ]
        if all(low == high for low, high in values):
            folded.append(sum(low << index for index, (low, _) in enumerate(values)))
    folded = tuple(sorted(set(folded)))
    assert len(folded) == 512
    assert enumerator(folded) == {"0": 1, "56": 255, "64": 255, "120": 1}

    # The folded coordinates are the 120 E8 root pairs; compare word for word
    # against the packed C682 construction on the transported labelling.
    packed_points = tuple(
        sorted(isometry(low & 255) for low, _ in level_pairs)
    )
    assert len(set(packed_points)) == 120
    _, packed_code = affine_code(packed_points, 8)
    fold_labels = [isometry(low & 255) for low, _ in level_pairs]
    permutation = [packed_points.index(label) for label in fold_labels]
    relabelled = set()
    for word in folded:
        image = 0
        for index, target in enumerate(permutation):
            if (word >> index) & 1:
                image |= 1 << target
        relabelled.add(image)
    assert relabelled == set(packed_code)

    # Plotkin |u|u+v| identity against the E8 code and the repetition code.
    level_zero = tuple(
        index for index, point in enumerate(intrinsic_points) if not (point >> 8) & 1
    )
    level_one = tuple(
        index for index, point in enumerate(intrinsic_points) if (point >> 8) & 1
    )
    assert len(level_zero) == len(level_one) == 120
    order_zero = sorted(level_zero, key=lambda index: intrinsic_points[index])
    order_one = sorted(
        level_one, key=lambda index: intrinsic_points[index] ^ delta
    )
    plotkin = set()
    for word in code:
        low = sum(((word >> index) & 1) << slot for slot, index in enumerate(order_zero))
        high = sum(((word >> index) & 1) << slot for slot, index in enumerate(order_one))
        plotkin.add((low, high ^ low))
    e8_words = {low for low, _ in plotkin}
    difference_words = {high for _, high in plotkin}
    assert len(e8_words) == 512
    assert enumerator(tuple(e8_words)) == {"0": 1, "56": 255, "64": 255, "120": 1}
    assert difference_words == {0, (1 << 120) - 1}
    assert plotkin == {
        (low, high) for low in e8_words for high in difference_words
    }

    # Dual code and CSS parameters.
    dual_tetrads = four_subset_count(intrinsic_points)
    assert len(set(intrinsic_points)) == 240
    assert dual_tetrads > 0

    return {
        "e9_code": {
            "carrier": (
                "240 nonsingular vectors of E9/2E9, the mod-2 images of the real "
                "affine roots alpha + n.delta of the affine E8 root system"
            ),
            "parameters": [240, 10, 112],
            "weight_enumerator": weight_enumerator,
            "doubly_even": True,
            "self_orthogonal": True,
            "radical_generator_is_isotropic": True,
            "dual_parameters": [240, 230, 4],
            "dual_tetrad_count": dual_tetrads,
            "css_parameters": [240, 220, 4],
        },
        "plotkin_identity": {
            "form": "|u|u+v| with u in the E8 code and v in the repetition code",
            "components": [[120, 9, 56], [120, 1, 120]],
            "distance": min(2 * 56, 120),
            "exact_set_equality": True,
        },
        "level_fold": {
            "pairs": len(level_pairs),
            "folded_parameters": [120, 9, 56],
            "folded_weight_enumerator": enumerator(folded),
            "matches_c682_packed_code": True,
        },
        "optimality": {
            "codetables_240_10": CODETABLES_240_10,
            "attains_best_known": False,
            "gap_to_best_known_lower_bound": CODETABLES_240_10["lower"] - 112,
            "note": (
                "the affine level step does not preserve unrestricted optimality; "
                "the Plotkin partner [120,1,120] over-delivers while the doubled "
                "E8 distance 112 falls below the [240,10] record range 114-116"
            ),
        },
        "series_ladder": [
            "E9 [240,10,112] affine real-root code",
            "E8 [120,9,56] root-pair code by the level fold",
            "E7 [28,7,12] bitangent code by the root-link antipodal fold",
            "E6 [27,6,12] tritangent code by shortening",
        ],
        "input_sha256": {
            E8_SOURCE.name: hashlib.sha256(E8_SOURCE.read_bytes()).hexdigest()
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
