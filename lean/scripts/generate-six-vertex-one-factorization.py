#!/usr/bin/env python3
"""Enumerate labelled K6 one-factorizations and relabelling witnesses.

This is a source generator/audit helper for SixVertexOneFactorization.lean.  It uses only exact
finite combinatorics and prints the six factorization totals as indices into the lexicographically
sorted list of perfect matchings, together with a vertex permutation carrying each total to the
standard one.
"""

from itertools import combinations, permutations


VERTICES = range(6)
EDGES = tuple(combinations(VERTICES, 2))


def matching_key(matching):
    return tuple(sorted(tuple(sorted(edge)) for edge in matching))


def perfect_matchings(vertices):
    vertices = tuple(vertices)
    if not vertices:
        yield ()
        return
    first = vertices[0]
    for i in range(1, len(vertices)):
        second = vertices[i]
        rest = vertices[1:i] + vertices[i + 1 :]
        for tail in perfect_matchings(rest):
            yield matching_key(((first, second),) + tail)


MATCHINGS = tuple(sorted(set(perfect_matchings(tuple(VERTICES)))))
EDGE_SET = frozenset(EDGES)
FACTORIZATIONS = tuple(
    factorization
    for factorization in combinations(range(len(MATCHINGS)), 5)
    if frozenset(edge for i in factorization for edge in MATCHINGS[i]) == EDGE_SET
)

STANDARD_MATCHINGS = (
    matching_key(((0, 1), (2, 3), (4, 5))),
    matching_key(((0, 2), (1, 4), (3, 5))),
    matching_key(((0, 3), (1, 5), (2, 4))),
    matching_key(((0, 4), (1, 3), (2, 5))),
    matching_key(((0, 5), (1, 2), (3, 4))),
)
STANDARD = frozenset(MATCHINGS.index(m) for m in STANDARD_MATCHINGS)


def relabel_matching(matching, permutation):
    return matching_key((permutation[a], permutation[b]) for a, b in matching)


def witness(factorization):
    for permutation in permutations(VERTICES):
        image = frozenset(
            MATCHINGS.index(relabel_matching(MATCHINGS[i], permutation))
            for i in factorization
        )
        if image == STANDARD:
            return permutation
    raise AssertionError(f"no relabelling witness for {factorization}")


def main():
    assert len(MATCHINGS) == 15
    assert len(FACTORIZATIONS) == 6
    assert tuple(sorted(STANDARD)) in FACTORIZATIONS
    print(f"perfect_matchings={len(MATCHINGS)} one_factorizations={len(FACTORIZATIONS)}")
    for number, factorization in enumerate(FACTORIZATIONS):
        print(f"T{number}: {factorization}; p={witness(factorization)}")


if __name__ == "__main__":
    main()
