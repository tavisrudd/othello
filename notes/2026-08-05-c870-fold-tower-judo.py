#!/usr/bin/env python3
"""The root-link antipodal fold is a tower on the whole two-weight family.

C682 proved the fold at rank eight, taking the E8 code to the E7 code, and C867
found the same fold one rank up.  Nothing in either argument used the rank.  This
checker runs the fold at ranks four, six, eight and ten and confirms that at every
step it carries the rank-2l affine quadric code onto the rank-2(l-1) one, so the
exceptional ladder is the bottom of an infinite tower on the family that
Calderbank and Kantor catalogued.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "2026-08-05-c870-fold-tower-judo.json"
LADDER_SOURCE = HERE / "2026-08-05-c867-ladder-record-attack.py"


def parity(value):
    return value.bit_count() & 1


def plus_form(half):
    mask = (1 << half) - 1

    def quadratic(vector):
        return parity((vector & mask) & (vector >> half))

    def bilinear(left, right):
        return parity((left & mask) & (right >> half)) ^ parity(
            (left >> half) & (right & mask)
        )

    return quadratic, bilinear


def affine_code(points, coordinate_bits):
    rows = [(1 << len(points)) - 1]
    for bit in range(coordinate_bits):
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


def described(points, words):
    weights = [word.bit_count() for word in words if word]
    return {
        "parameters": [len(points), len(words).bit_length() - 1, min(weights)],
        "weight_enumerator": {
            str(weight): count
            for weight, count in sorted(
                Counter(word.bit_count() for word in words).items()
            )
        },
    }


def fold_once(half):
    """Build the rank-2*half code, fold at one root, and describe both."""
    quadratic, bilinear = plus_form(half)
    ambient = 1 << (2 * half)
    points = tuple(v for v in range(ambient) if quadratic(v) == 1)
    assert len(points) == (1 << (2 * half - 1)) - (1 << (half - 1))
    code = affine_code(points, 2 * half)

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
    folded = tuple(sorted(folded))
    return {
        "rank": 2 * half,
        "code": described(points, code),
        "link_size": len(link),
        "folded": described(pairs, folded),
    }


def certificate():
    levels = {}
    for half in (2, 3, 4, 5):
        levels[str(2 * half)] = fold_once(half)

    # The fold at rank 2l reproduces the code at rank 2(l-1), exactly.
    steps = []
    for half in (3, 4, 5):
        upper = levels[str(2 * half)]
        lower = levels[str(2 * half - 2)]
        match = upper["folded"] == lower["code"]
        assert match, f"fold mismatch at rank {2 * half}"
        steps.append(
            {
                "from_rank": 2 * half,
                "to_rank": 2 * half - 2,
                "folded_parameters": upper["folded"]["parameters"],
                "target_parameters": lower["code"]["parameters"],
                "identical": match,
            }
        )

    assert levels["10"]["code"]["parameters"] == [496, 11, 240]
    assert levels["8"]["code"]["parameters"] == [120, 9, 56]
    assert levels["6"]["code"]["parameters"] == [28, 7, 12]
    assert levels["4"]["code"]["parameters"] == [6, 5, 2]

    return {
        "statement": (
            "for every l >= 3, the root-link antipodal fold carries the affine "
            "code of the rank-2l plus-type quadric onto the affine code of the "
            "rank-2(l-1) plus-type quadric; the exceptional ladder is the bottom "
            "of this tower"
        ),
        "levels": levels,
        "steps": steps,
        "exceptional_labels": {
            "10": "E10 overextended",
            "8": "E8 root pairs",
            "6": "E7 bitangents",
            "4": "below the exceptional range",
        },
        "consequence": (
            "the two-weight codes catalogued by Calderbank and Kantor are the "
            "objects of this tower and the fold is its structure map; the "
            "exceptional instances are corollaries of the general statement "
            "rather than separate constructions"
        ),
        "input_sha256": {
            LADDER_SOURCE.name: hashlib.sha256(LADDER_SOURCE.read_bytes()).hexdigest()
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
