#!/usr/bin/env python3
"""Exhaustive small binary checks for C946 multi-target recovery."""

from __future__ import annotations

from itertools import combinations


def bit_positions(mask: int, n: int) -> tuple[int, ...]:
    return tuple(i for i in range(n) if (mask >> i) & 1)


def span_rank(vectors: list[int]) -> int:
    pivots: dict[int, int] = {}
    for value in vectors:
        x = value
        while x:
            pivot = x.bit_length() - 1
            if pivot in pivots:
                x ^= pivots[pivot]
            else:
                pivots[pivot] = x
                break
    return len(pivots)


def span(vectors: tuple[int, ...]) -> frozenset[int]:
    result = {0}
    for vector in vectors:
        result |= {x ^ vector for x in tuple(result)}
    return frozenset(result)


def all_binary_subspaces(n: int) -> list[frozenset[int]]:
    subspaces = {frozenset({0})}
    changed = True
    while changed:
        changed = False
        for space in tuple(subspaces):
            for vector in range(1 << n):
                enlarged = frozenset(space | {x ^ vector for x in space})
                if enlarged not in subspaces:
                    subspaces.add(enlarged)
                    changed = True
    return sorted(subspaces, key=lambda space: (len(space), tuple(space)))


def dual(code: frozenset[int], n: int) -> frozenset[int]:
    return frozenset(
        word
        for word in range(1 << n)
        if all((word & codeword).bit_count() % 2 == 0 for codeword in code)
    )


def restrict(word: int, coordinates: tuple[int, ...]) -> int:
    result = 0
    for target_index, source_index in enumerate(coordinates):
        result |= ((word >> source_index) & 1) << target_index
    return result


def intrinsic_checks() -> tuple[int, int]:
    n = 4
    tested = 0
    recoverable = 0
    for code in all_binary_subspaces(n):
        code_dual = dual(code, n)
        coordinates = tuple(range(n))
        for p_size in range(1, n + 1):
            for p_tuple in combinations(coordinates, p_size):
                p_mask = sum(1 << i for i in p_tuple)
                remaining = tuple(i for i in coordinates if i not in p_tuple)
                for h_size in range(len(remaining) + 1):
                    for h_tuple in combinations(remaining, h_size):
                        h_mask = sum(1 << i for i in h_tuple)
                        kernel_condition = all(
                            (codeword & p_mask) == 0
                            for codeword in code
                            if (codeword & h_mask) == 0
                        )
                        restricted_words = [
                            restrict(word, p_tuple)
                            for word in code_dual
                            if word & ~(p_mask | h_mask) == 0
                        ]
                        restriction_rank = span_rank(restricted_words)
                        dual_condition = restriction_rank == p_size
                        assert kernel_condition == dual_condition
                        tested += 1
                        if not dual_condition:
                            continue
                        recoverable += 1
                        fibers = [
                            sum(
                                1
                                for word in code_dual
                                if word & ~(p_mask | h_mask) == 0
                                and restrict(word, p_tuple) == (1 << i)
                            )
                            for i in range(p_size)
                        ]
                        kernel_size = sum(
                            1
                            for word in code_dual
                            if word & ~(p_mask | h_mask) == 0
                            and restrict(word, p_tuple) == 0
                        )
                        assert all(size == kernel_size for size in fibers)
                        splitting_count = 1
                        for size in fibers:
                            splitting_count *= size
                        assert splitting_count == kernel_size**p_size

        if code_dual != frozenset({0}):
            for x in coordinates:
                through_x = [
                    word.bit_count()
                    for word in code_dual
                    if (word >> x) & 1
                ]
                if not through_x:
                    continue
                dual_min = min(through_x) - 1
                recovery_min = min(
                    h_size
                    for h_size in range(n)
                    for h_tuple in combinations(
                        tuple(i for i in coordinates if i != x), h_size
                    )
                    if span_rank(
                        [
                            restrict(word, (x,))
                            for word in code_dual
                            if word
                            & ~(
                                (1 << x)
                                | sum(1 << coordinate for coordinate in h_tuple)
                            )
                            == 0
                        ]
                    )
                    == 1
                )
                assert recovery_min == dual_min
    return tested, recoverable


def outer_spc_generators(length: int) -> tuple[int, ...]:
    return tuple((1 << i) | (1 << (length - 1)) for i in range(length - 1))


def concatenated_repetition_code(length: int) -> frozenset[int]:
    generators = []
    for outer_word in outer_spc_generators(length):
        inner_word = 0
        for block in range(length):
            if (outer_word >> block) & 1:
                inner_word |= 0b111 << (3 * block)
        generators.append(inner_word)
    return span(tuple(generators))


def minimum_splitting_costs(length: int) -> tuple[int, int]:
    n = 3 * length
    code_dual = dual(concatenated_repetition_code(length), n)
    target = (0, 1)
    row_fibers = []
    for basis_index in range(2):
        wanted = 1 << basis_index
        row_fibers.append(
            [word for word in code_dual if restrict(word, target) == wanted]
        )
    minimum_confined = n + 1
    minimum_nonconfined = n + 1
    target_mask = 0b11
    first_block_mask = 0b111
    for first in row_fibers[0]:
        for second in row_fibers[1]:
            union = first | second
            helper_cost = (union & ~target_mask).bit_count()
            if union & ~first_block_mask:
                minimum_nonconfined = min(minimum_nonconfined, helper_cost)
            else:
                minimum_confined = min(minimum_confined, helper_cost)
    return minimum_confined, minimum_nonconfined


def main() -> None:
    tested, recoverable = intrinsic_checks()
    family_results = {
        length: minimum_splitting_costs(length) for length in range(2, 6)
    }
    assert family_results[2] == (1, 1)
    assert family_results[3] == (1, 2)
    assert family_results[4] == (1, 3)
    assert family_results[5] == (1, 3)
    print(f"intrinsic_cases={tested}")
    print(f"recoverable_cases={recoverable}")
    print(f"spc_repetition_costs={family_results}")
    print("c946_multitarget_check=PASS")


if __name__ == "__main__":
    main()
