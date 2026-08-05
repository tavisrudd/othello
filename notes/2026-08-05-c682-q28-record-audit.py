#!/usr/bin/env python3
"""Exact finite audit of the public [[28,14,5]] GF(4) stabilizer code."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c682-q28-record-audit.json"
SOURCE_URL = "https://www.markus-grassl.de/QECC/circuits/28_14_5.html"
MATRIX_TEXT = """
1 0 0 0 0 0 0 a2 1 0 a2 0 1 a2 1 a2 a a2 a2 1 a 1 a a2 a a2 a a
0 1 0 0 0 0 0 a2 a2 1 0 a2 0 1 a 1 a2 a a2 a2 1 a 1 a a2 a a2 a
0 0 1 0 0 0 0 1 a2 a2 1 0 a2 0 1 a 1 a2 a a2 a2 a a 1 a a2 a a2
0 0 0 1 0 0 0 0 1 a2 a2 1 0 a2 a2 1 a 1 a2 a a2 a2 a a 1 a a2 a
0 0 0 0 1 0 0 a2 0 1 a2 a2 1 0 a2 a2 1 a 1 a2 a a a2 a a 1 a a2
0 0 0 0 0 1 0 0 a2 0 1 a2 a2 1 a a2 a2 1 a 1 a2 a2 a a2 a a 1 a
0 0 0 0 0 0 1 1 0 a2 0 1 a2 a2 a2 a a2 a2 1 a 1 a a2 a a2 a a 1
""".strip()


LOG = {1: 0, 2: 1, 3: 2}
EXP = (1, 2, 3)


def multiply(left, right):
    if not left or not right:
        return 0
    return EXP[(LOG[left] + LOG[right]) % 3]


def conjugate(value):
    return multiply(value, value)


def inverse(value):
    return EXP[(-LOG[value]) % 3]


def matrix():
    decode = {"0": 0, "1": 1, "a": 2, "a2": 3}
    rows = tuple(
        tuple(decode[token] for token in line.split())
        for line in MATRIX_TEXT.splitlines()
    )
    assert len(rows) == 7 and all(len(row) == 28 for row in rows)
    return rows


def inner(left, right):
    value = 0
    for x, y in zip(left, right, strict=True):
        value ^= multiply(x, conjugate(y))
    return value


def add_scaled(word, row, scale):
    return tuple(
        left ^ multiply(scale, right)
        for left, right in zip(word, row, strict=True)
    )


def codewords(rows):
    answer = []
    for packed in range(4 ** len(rows)):
        coefficients = []
        value = packed
        for _ in rows:
            coefficients.append(value & 3)
            value >>= 2
        word = (0,) * len(rows[0])
        for coefficient, row in zip(coefficients, rows, strict=True):
            word = add_scaled(word, row, coefficient)
        answer.append(word)
    return tuple(answer)


def rank_columns(rows, columns):
    work = [[row[column] for column in columns] for row in rows]
    rank = 0
    for column in range(len(columns)):
        pivot = next(
            (row for row in range(rank, len(rows)) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        scale = inverse(work[rank][column])
        work[rank] = [multiply(scale, value) for value in work[rank]]
        for row in range(len(rows)):
            if row == rank or not work[row][column]:
                continue
            scale = work[row][column]
            work[row] = [
                left ^ multiply(scale, right)
                for left, right in zip(work[row], work[rank], strict=True)
            ]
        rank += 1
    return rank


def dependent_supports(rows, weight):
    return tuple(
        columns
        for columns in itertools.combinations(range(28), weight)
        if rank_columns(rows, columns) < weight
    )


def trace(value):
    return value ^ conjugate(value)


def support_mask(word):
    return sum((value != 0) << index for index, value in enumerate(word))


def binary_e7_tetrads():
    points = tuple(
        (a, b) for a in range(8) for b in range(8) if (a & b).bit_count() & 1
    )
    columns = tuple(1 | (a << 1) | (b << 4) for a, b in points)
    return tuple(
        indices
        for indices in itertools.combinations(range(28), 4)
        if columns[indices[0]]
        ^ columns[indices[1]]
        ^ columns[indices[2]]
        ^ columns[indices[3]]
        == 0
    )


def certificate():
    rows = matrix()
    assert all(inner(left, right) == 0 for left in rows for right in rows)
    words = codewords(rows)
    weight_enumerator = Counter(
        sum(value != 0 for value in word) for word in words
    )
    assert weight_enumerator == Counter(
        {0: 1, 16: 756, 18: 2394, 20: 4725, 22: 5292, 24: 2835, 26: 378, 28: 3}
    )
    for weight in range(1, 5):
        assert not dependent_supports(rows, weight)
    minimum_supports = dependent_supports(rows, 5)
    assert len(minimum_supports) == 504
    point_degrees = tuple(
        sum(point in support for support in minimum_supports) for point in range(28)
    )
    assert Counter(point_degrees) == Counter({82: 7, 86: 7, 94: 7, 98: 7})
    pair_degrees = Counter(
        sum(left in support and right in support for support in minimum_supports)
        for left, right in itertools.combinations(range(28), 2)
    )
    shift = lambda point: 7 * (point // 7) + (point % 7 + 1) % 7
    support_set = set(minimum_supports)
    assert all(
        tuple(sorted(shift(point) for point in support)) in support_set
        for support in minimum_supports
    )

    subfield_words = tuple(
        word for word in words if all(value in (0, 1) for value in word)
    )
    assert len(subfield_words) == 1
    trace_words = {
        sum(trace(value) << index for index, value in enumerate(word))
        for word in words
    }
    assert len(trace_words) == 1 << 14
    trace_enumerator = Counter(word.bit_count() for word in trace_words)

    tetrads = binary_e7_tetrads()
    assert len(tetrads) == 315
    e7_point_degrees = tuple(
        sum(point in support for support in tetrads) for point in range(28)
    )
    assert set(e7_point_degrees) == {45}

    return {
        "source": {
            "url": SOURCE_URL,
            "frozen_matrix_sha256": hashlib.sha256(
                (MATRIX_TEXT + "\n").encode()
            ).hexdigest(),
        },
        "public_quantum_code": {
            "parameters": [28, 14, 5],
            "gf4_stabilizer_dimension": 7,
            "hermitian_self_orthogonal": True,
            "pure": True,
            "stabilizer_weight_enumerator": {
                str(weight): count for weight, count in sorted(weight_enumerator.items())
            },
            "minimum_logical_support_count": len(minimum_supports),
            "minimum_logical_word_count": 3 * len(minimum_supports),
            "minimum_support_point_degree_distribution": {
                str(degree): count for degree, count in sorted(Counter(point_degrees).items())
            },
            "minimum_support_pair_degree_distribution": {
                str(degree): count for degree, count in sorted(pair_degrees.items())
            },
            "coordinate_transitive": False,
            "order_7_support_automorphism": True,
            "displayed_subfield_subcode_dimension": 0,
            "trace_code_dimension": 14,
            "trace_weight_enumerator": {
                str(weight): count for weight, count in sorted(trace_enumerator.items())
            },
        },
        "e7_css_comparison": {
            "parameters": [28, 14, 4],
            "minimum_logical_support_count": len(tetrads),
            "minimum_support_point_degree": 45,
            "coordinate_transitive": True,
            "same_minimum_support_incidence_structure": False,
            "public_record_is_not_monomially_equivalent_to_a_coordinate_transitive_phase_lift": True,
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
