"""Exact finite-prime-field subspace and linearized-polynomial recognition."""

from __future__ import annotations

from collections.abc import Callable, Iterable, Sequence


def prime_field_basis(
    elements: Iterable[int],
    coordinates: Callable[[int], Sequence[int]],
    characteristic: int,
) -> list[int]:
    """Return a deterministic independent subset over the prime field."""

    pivots: list[tuple[int, list[int]]] = []
    chosen: list[int] = []
    for element in sorted(set(elements)):
        if element == 0:
            continue
        vector = [value % characteristic for value in coordinates(element)]
        for pivot, row in pivots:
            factor = vector[pivot]
            if factor:
                vector = [
                    (value - factor * row_value) % characteristic
                    for value, row_value in zip(vector, row)
                ]
        pivot = next((index for index, value in enumerate(vector) if value), None)
        if pivot is None:
            continue
        inverse = pow(vector[pivot], -1, characteristic)
        vector = [(value * inverse) % characteristic for value in vector]
        pivots.append((pivot, vector))
        pivots.sort(key=lambda item: item[0])
        chosen.append(element)
    return chosen


def verify_prime_subspace(
    elements: Iterable[int],
    basis: Sequence[int],
    add: Callable[[int, int], int],
    characteristic: int,
) -> bool:
    expected = {0}
    for basis_element in basis:
        expanded = set()
        multiple = 0
        for scalar in range(characteristic):
            expanded.update(add(value, multiple) for value in expected)
            multiple = add(multiple, basis_element)
        expected = expanded
    return expected == set(elements)


def linearized_exponents(coefficients_low_to_high: Sequence[int], characteristic: int) -> list[int]:
    """Return nonzero p-power exponents, rejecting a non-linearized polynomial."""

    nonzero = [index for index, coefficient in enumerate(coefficients_low_to_high) if coefficient]
    allowed = set()
    exponent = 1
    while exponent < len(coefficients_low_to_high):
        allowed.add(exponent)
        exponent *= characteristic
    if any(index not in allowed for index in nonzero):
        raise ValueError("polynomial is not prime-field linearized")
    return nonzero
