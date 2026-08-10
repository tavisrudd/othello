#!/usr/bin/env python3
"""Exact finite check for the marked E6--E10 residue construction in C906.

This is deliberately independent of the manuscript and of Lean.  It verifies
the quadratic-set, evaluation-code, shortening, link, and fold assertions used
in notes/2026-08-10-c906-exceptional-tower-judo.md.
"""

from collections import Counter


def bit(x: int, i: int) -> int:
    return (x >> i) & 1


def q_anisotropic2(x: int) -> int:
    u, v = bit(x, 0), bit(x, 1)
    return u ^ v ^ (u & v)


def q_minus6(x: int) -> int:
    return (
        (bit(x, 0) & bit(x, 1))
        ^ (bit(x, 2) & bit(x, 3))
        ^ q_anisotropic2(x >> 4)
    )


def q_plus8(x: int) -> int:
    return q_anisotropic2(x) ^ q_minus6(x >> 2)


def polar(q, x: int, y: int) -> int:
    return q(x) ^ q(y) ^ q(x ^ y)


def dot(x: int, y: int) -> int:
    return (x & y).bit_count() & 1


def eval_words(points: list[int], ambient_dim: int, affine: bool) -> set[int]:
    words = set()
    constants = (0, 1) if affine else (0,)
    for linear in range(1 << ambient_dim):
        for constant in constants:
            word = 0
            for i, point in enumerate(points):
                word |= (dot(linear, point) ^ constant) << i
            words.add(word)
    return words


def parameters(words: set[int], length: int) -> tuple[int, int, Counter]:
    size = len(words)
    assert size and size & (size - 1) == 0
    dimension = size.bit_length() - 1
    enumerator = Counter(word.bit_count() for word in words)
    distance = min(weight for weight in enumerator if weight)
    assert max(enumerator) <= length
    return dimension, distance, enumerator


def folded_constant_words(
    words: set[int], pairs: list[tuple[int, int]]
) -> set[int]:
    folded = set()
    for word in words:
        if all(bit(word, i) == bit(word, j) for i, j in pairs):
            quotient = 0
            for k, (i, _j) in enumerate(pairs):
                quotient |= bit(word, i) << k
            folded.add(quotient)
    return folded


def assert_code(
    label: str,
    words: set[int],
    length: int,
    dimension: int,
    distance: int,
) -> None:
    got_dimension, got_distance, enumerator = parameters(words, length)
    assert (got_dimension, got_distance) == (dimension, distance)
    print(f"{label}: [{length},{dimension},{distance}], weights {dict(sorted(enumerator.items()))}")


def main() -> None:
    # E6 is the linear evaluation code on the 27 nonzero singular vectors of
    # a six-dimensional minus space.  Adjoining zero and constants gives E7.
    singular6 = [x for x in range(1 << 6) if q_minus6(x) == 0]
    assert len(singular6) == 28 and singular6[0] == 0
    e6_points = singular6[1:]
    e6 = eval_words(e6_points, 6, affine=False)
    e7 = eval_words(singular6, 6, affine=True)
    assert_code("E6", e6, 27, 6, 12)
    assert_code("E7", e7, 28, 7, 12)

    shortened = {
        sum(bit(word, i) << (i - 1) for i in range(1, 28))
        for word in e7
        if bit(word, 0) == 0
    }
    assert shortened == e6

    # An anisotropic plane plus the minus six-space is plus eight-space.
    # The link of a=(1,0) is paired by beta <-> a+beta and is indexed by
    # the 28 singular vectors s via {b+s,a+b+s}.
    a8, b8 = 1, 2
    assert q_plus8(a8) == q_plus8(b8) == polar(q_plus8, a8, b8) == 1
    roots8 = [x for x in range(1 << 8) if q_plus8(x) == 1]
    assert len(roots8) == 120
    e8 = eval_words(roots8, 8, affine=True)
    assert_code("E8", e8, 120, 9, 56)

    link8 = [x for x in roots8 if q_plus8(a8 ^ x) == 1]
    assert len(link8) == 56
    link8_index = {x: i for i, x in enumerate(link8)}
    pairs8 = []
    seen8 = set()
    for s in singular6:
        beta, gamma = b8 | (s << 2), a8 | b8 | (s << 2)
        assert beta in link8_index and gamma == (a8 ^ beta)
        pair = tuple(sorted((link8_index[beta], link8_index[gamma])))
        assert pair not in seen8
        seen8.add(pair)
        pairs8.append(pair)
    assert len(pairs8) == 28

    restricted8 = set()
    root8_index = {x: i for i, x in enumerate(roots8)}
    for word in e8:
        restricted8.add(
            sum(bit(word, root8_index[x]) << i for i, x in enumerate(link8))
        )
    folded8 = folded_constant_words(restricted8, pairs8)
    # Pair ordering follows singular6, so this is literal equality, not only
    # code equivalence.
    assert folded8 == e7

    # Twist plus eight-space at the marked nonsingular vector t=a.  Translation
    # by t identifies its 120 singular vectors with the E8 root set.
    t8 = a8

    def q_twisted8(x: int) -> int:
        return q_plus8(x) ^ polar(q_plus8, t8, x)

    singular_twisted8 = [x for x in range(1 << 8) if q_twisted8(x) == 0]
    assert len(singular_twisted8) == 120
    assert {s ^ t8 for s in singular_twisted8} == set(roots8)

    # Suspend by another anisotropic plane.  The result is plus ten-space.
    def q_plus10(x: int) -> int:
        return q_anisotropic2(x) ^ q_twisted8(x >> 2)

    a10, b10 = 1, 2
    roots10 = [x for x in range(1 << 10) if q_plus10(x) == 1]
    assert len(roots10) == 496
    e10 = eval_words(roots10, 10, affine=True)
    assert_code("E10", e10, 496, 11, 240)

    link10 = [x for x in roots10 if q_plus10(a10 ^ x) == 1]
    assert len(link10) == 240
    root10_index = {x: i for i, x in enumerate(roots10)}
    restricted10 = {
        sum(bit(word, root10_index[x]) << i for i, x in enumerate(link10))
        for word in e10
    }
    assert_code("E9 link", restricted10, 240, 10, 112)

    link10_index = {x: i for i, x in enumerate(link10)}
    pairs10 = []
    for s in singular_twisted8:
        beta, gamma = b10 | (s << 2), a10 | b10 | (s << 2)
        assert beta in link10_index and gamma == (a10 ^ beta)
        pairs10.append((link10_index[beta], link10_index[gamma]))
    assert len({tuple(sorted(pair)) for pair in pairs10}) == 120

    folded10 = folded_constant_words(restricted10, pairs10)
    # The pair indexed by s corresponds to the E8 root y=s+t.
    target_order = [s ^ t8 for s in singular_twisted8]
    target_e8 = eval_words(target_order, 8, affine=True)
    assert folded10 == target_e8

    flag_counts = {"E6": 1, "E7": 28, "E8": 120 * 28, "E9": 120 * 28,
                   "E10": 496 * 120 * 28}
    marking_counts = {"golden": 432, "operator": 864, "Paper V": 1728}
    print("labelled residue-flag fibres:", flag_counts)
    for label, marking in marking_counts.items():
        print(label, {level: marking * count for level, count in flag_counts.items()})
    print("PASS")


if __name__ == "__main__":
    main()
