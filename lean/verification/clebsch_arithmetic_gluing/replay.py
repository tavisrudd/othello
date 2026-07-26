#!/usr/bin/env python3
"""Independent replay of the characteristic-eleven arithmetic-gluing data."""

from __future__ import annotations

import json
from collections import deque
from pathlib import Path


P = 11
INF = 11
HERE = Path(__file__).resolve().parent


def norm(a: int, b: int, c: int, d: int) -> tuple[int, int, int, int]:
    entries = [a % P, b % P, c % P, d % P]
    scale = pow(next(entry for entry in entries if entry), -1, P)
    return tuple(scale * entry % P for entry in entries)  # type: ignore[return-value]


def point(matrix: tuple[int, int, int, int], value: int) -> int:
    a, b, c, d = matrix
    if value == INF:
        return INF if c == 0 else a * pow(c, -1, P) % P
    denominator = (c * value + d) % P
    return INF if denominator == 0 else (a * value + b) * pow(
        denominator, -1, P
    ) % P


def permutation(matrix: tuple[int, int, int, int]) -> tuple[int, ...]:
    return tuple(point(matrix, value) for value in range(P + 1))


def act(
    element: tuple[int, ...], matching: tuple[tuple[int, int], ...]
) -> tuple[tuple[int, int], ...]:
    return tuple(
        sorted(tuple(sorted((element[left], element[right]))) for left, right in matching)
    )


def multiply(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(left[right[value]] for value in range(P + 1))


def inverse(element: tuple[int, ...]) -> tuple[int, ...]:
    result = [0] * len(element)
    for value, image in enumerate(element):
        result[image] = value
    return tuple(result)


def closure(generators: set[tuple[int, ...]]) -> set[tuple[int, ...]]:
    steps = generators | {inverse(element) for element in generators}
    identity = tuple(range(P + 1))
    seen = {identity}
    queue = deque([identity])
    while queue:
        element = queue.popleft()
        for step in steps:
            product = multiply(element, step)
            if product not in seen:
                seen.add(product)
                queue.append(product)
    return seen


def matching(raw: list[list[int | None]]) -> tuple[tuple[int, int], ...]:
    return tuple(
        sorted(
            tuple(sorted(INF if value is None else value for value in edge))
            for edge in raw
        )
    )


def main() -> None:
    source = json.loads((HERE / "source_data.json").read_text())
    certificate = json.loads((HERE / "certificate.json").read_text())
    literal = source["literal_data"]
    base = matching(literal["matchings"]["h3_base"])
    conjugate = matching(literal["matchings"]["h3_conjugate"])

    matrices = {
        norm(a, b, c, d)
        for a in range(P)
        for b in range(P)
        for c in range(P)
        for d in range(P)
        if (a * d - b * c) % P
    }
    pgl = {permutation(matrix) for matrix in matrices}
    psl = {
        permutation(matrix)
        for matrix in matrices
        if pow((matrix[0] * matrix[3] - matrix[1] * matrix[2]) % P, 5, P) == 1
    }
    base_stabilizer = {element for element in pgl if act(element, base) == base}
    conjugate_stabilizer = {
        element for element in pgl if act(element, conjugate) == conjugate
    }
    full_orbit = {act(element, base) for element in pgl}
    base_sheet = {act(element, base) for element in psl}
    conjugate_sheet = {act(element, conjugate) for element in psl}
    transporter = permutation(norm(*literal["golden_transporter"]))

    assert (len(pgl), len(psl)) == (1320, 660)
    assert (
        len(base_stabilizer),
        len(conjugate_stabilizer),
        len(base_stabilizer & conjugate_stabilizer),
    ) == (60, 60, 12)
    assert base_stabilizer <= psl and conjugate_stabilizer <= psl
    assert closure(base_stabilizer | conjugate_stabilizer) == psl
    assert len(full_orbit) == 22
    assert len(base_sheet) == len(conjugate_sheet) == 11
    assert base_sheet.isdisjoint(conjugate_sheet)
    assert full_orbit == base_sheet | conjugate_sheet
    assert act(transporter, base) == conjugate

    h3 = certificate["h3"]
    certified_base_stabilizer = {
        permutation(norm(*matrix)) for matrix in h3["base_stabilizer"]
    }
    certified_conjugate_stabilizer = {
        permutation(norm(*matrix)) for matrix in h3["conjugate_stabilizer"]
    }
    assert certified_base_stabilizer == base_stabilizer
    assert certified_conjugate_stabilizer == conjugate_stabilizer

    certified_pgl_representatives = [
        permutation(norm(*matrix)) for matrix in h3["pgl_coset_representatives"]
    ]
    certified_base_representatives = [
        permutation(norm(*matrix))
        for matrix in h3["psl_base_coset_representatives"]
    ]
    certified_conjugate_representatives = [
        permutation(norm(*matrix))
        for matrix in h3["psl_conjugate_coset_representatives"]
    ]
    assert {
        act(element, base) for element in certified_pgl_representatives
    } == full_orbit
    assert {
        act(element, base) for element in certified_base_representatives
    } == base_sheet
    assert {
        act(element, conjugate) for element in certified_conjugate_representatives
    } == conjugate_sheet

    certified_generators = [
        permutation(norm(*matrix)) for matrix in h3["generation_generators"]
    ]
    assert set(certified_generators) == base_stabilizer | conjugate_stabilizer
    certified_word_values = []
    identity = tuple(range(P + 1))
    for word in h3["generation_words"]:
        value = identity
        for index in word:
            assert 0 <= index < len(certified_generators)
            value = multiply(value, certified_generators[index])
        certified_word_values.append(value)
    assert len(certified_word_values) == len(set(certified_word_values))
    assert set(certified_word_values) == psl
    print("clebsch arithmetic-gluing independent replay: CHECK OK")


if __name__ == "__main__":
    main()
