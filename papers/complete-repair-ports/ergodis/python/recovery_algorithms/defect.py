"""Exact small-defect shell enumeration.

The balanced degrees ``center`` and ``center + 1`` have zero convex defect.
All other degrees consume positive budget, so they can be enumerated sparsely;
the two bulk multiplicities are then forced by the point and degree sums.
"""

from __future__ import annotations

from collections.abc import Iterator


Histogram = tuple[int, ...]


def convex_shell_histograms(
    *,
    point_count: int,
    degree_sum: int,
    center: int,
    minimum_degree: int,
    maximum_degree: int,
    defect: int,
) -> Iterator[Histogram]:
    """Yield every degree histogram with the prescribed exact defect.

    A degree ``d`` contributes ``binom(d-center, 2)``.  Histogram coordinates
    are ordered from ``minimum_degree`` through ``maximum_degree``.
    """

    if not (
        0 <= point_count
        and 0 <= defect
        and minimum_degree <= center < center + 1 <= maximum_degree
    ):
        raise ValueError("invalid convex-shell parameters")
    width = maximum_degree - minimum_degree + 1
    exceptional = []
    for degree in range(minimum_degree, maximum_degree + 1):
        if degree in (center, center + 1):
            continue
        delta = degree - center
        cost = delta * (delta - 1) // 2
        if cost <= defect:
            exceptional.append((degree, cost))
    counts = [0] * width

    def visit(index: int, used_points: int, used_sum: int, remaining: int) -> Iterator[Histogram]:
        if index == len(exceptional):
            if remaining != 0:
                return
            bulk_points = point_count - used_points
            bulk_sum = degree_sum - used_sum
            high_count = bulk_sum - center * bulk_points
            low_count = bulk_points - high_count
            if low_count < 0 or high_count < 0:
                return
            counts[center - minimum_degree] = low_count
            counts[center + 1 - minimum_degree] = high_count
            yield tuple(counts)
            counts[center - minimum_degree] = 0
            counts[center + 1 - minimum_degree] = 0
            return

        degree, cost = exceptional[index]
        maximum_count = min(remaining // cost, point_count - used_points)
        for count in range(maximum_count + 1):
            next_points = used_points + count
            next_sum = used_sum + count * degree
            counts[degree - minimum_degree] = count
            yield from visit(index + 1, next_points, next_sum, remaining - count * cost)
        counts[degree - minimum_degree] = 0

    yield from visit(0, 0, 0, defect)


def gf27_q27_t54_histogram_pairs() -> Iterator[tuple[Histogram, Histogram]]:
    """Yield the arithmetic degree-shell pairs for the GF(27) defect-19 model."""

    internal_by_defect = [
        tuple(
            convex_shell_histograms(
                point_count=279,
                degree_sum=1_026,
                center=3,
                minimum_degree=0,
                maximum_degree=28,
                defect=value,
            )
        )
        for value in range(20)
    ]
    external_by_defect = [
        tuple(
            convex_shell_histograms(
                point_count=478,
                degree_sum=486,
                center=1,
                minimum_degree=1,
                maximum_degree=28,
                defect=value,
            )
        )
        for value in range(20)
    ]
    for internal_defect in range(20):
        for internal in internal_by_defect[internal_defect]:
            for external in external_by_defect[19 - internal_defect]:
                yield internal, external


def gf27_q27_t54_centered_spectra() -> tuple[Histogram, ...]:
    """Return the distinct spectra of ``u=1+3a-d`` in the defect-19 branch."""

    spectra = set()
    for internal, external in gf27_q27_t54_histogram_pairs():
        counts = [0] * 11
        for degree, count in enumerate(internal):
            if count:
                counts[4 - degree + 6] += count
        for degree_minus_one, count in enumerate(external):
            if count:
                counts[-degree_minus_one + 6] += count
        spectra.add(tuple(counts))
    return tuple(sorted(spectra))
