"""Small exact helpers for lifting finite certificate rows to parametric cores."""

from __future__ import annotations

from collections.abc import Callable, Iterable, Sequence


def power(value: int, exponent: int, multiply: Callable[[int, int], int], one: int) -> int:
    result = one
    base = value
    remaining = exponent
    while remaining:
        if remaining & 1:
            result = multiply(result, base)
        base = multiply(base, base)
        remaining >>= 1
    return result


def fit_monomial_coordinates(
    rows: Sequence[Sequence[int]],
    parameter_index: int,
    coordinate_indices: Iterable[int],
    field_elements: Iterable[int],
    multiply: Callable[[int, int], int],
    one: int,
    maximum_exponent: int,
) -> dict[int, tuple[int, int]]:
    """Find the lexicographically first ``c * t^e`` for each coordinate."""

    elements = tuple(field_elements)
    fits: dict[int, tuple[int, int]] = {}
    for coordinate in coordinate_indices:
        candidates = []
        for exponent in range(maximum_exponent + 1):
            for coefficient in elements:
                if all(
                    row[coordinate]
                    == multiply(
                        coefficient,
                        power(row[parameter_index], exponent, multiply, one),
                    )
                    for row in rows
                ):
                    candidates.append((exponent, coefficient))
        if not candidates:
            raise ValueError(f"coordinate {coordinate} has no monomial fit")
        exponent, coefficient = min(candidates)
        fits[coordinate] = (coefficient, exponent)
    return fits
