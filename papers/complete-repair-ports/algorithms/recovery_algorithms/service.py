"""Canonical bounded service-rate LP construction."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Iterable, Sequence


@dataclass(frozen=True)
class ServiceLP:
    helper_count: int
    demand_count: int
    variables: tuple[tuple[int, tuple[int, ...]], ...]
    active_helper_incidence: tuple[tuple[int, tuple[int, ...]], ...]
    demand_incidence: tuple[tuple[int, ...], ...]

    @property
    def helper_incidence(self) -> tuple[tuple[int, ...], ...]:
        """Materialize the dense helper matrix only for compatibility/debugging."""

        width = len(self.variables)
        active = dict(self.active_helper_incidence)
        return tuple(active.get(helper, (0,) * width) for helper in range(self.helper_count))


def inclusion_minimal(sets: Iterable[Iterable[int]]) -> tuple[tuple[int, ...], ...]:
    by_mask: dict[int, tuple[int, ...]] = {}
    for item in sets:
        support = tuple(sorted(set(item)))
        if any(helper < 0 for helper in support):
            raise ValueError("helper indices must be nonnegative")
        mask = sum(1 << helper for helper in support)
        by_mask[mask] = support
    ordered = sorted(by_mask.items(), key=lambda pair: (pair[0].bit_count(), pair[1]))
    minimal: list[tuple[int, ...]] = []
    minimal_masks: list[int] = []
    for mask, support in ordered:
        if not any(other != mask and other & mask == other for other in minimal_masks):
            minimal_masks.append(mask)
            minimal.append(support)
    return tuple(minimal)


def build_service_lp(
    recovery_sets: Sequence[Iterable[Iterable[int]]], helper_count: int
) -> ServiceLP:
    minimal = tuple(inclusion_minimal(family) for family in recovery_sets)
    if any(
        helper >= helper_count
        for family in minimal
        for support in family
        for helper in support
    ):
        raise ValueError("recovery support exceeds helper count")
    variables = tuple(
        (demand, support)
        for demand, family in enumerate(minimal)
        for support in family
    )
    active_helpers = sorted(
        {helper for _, support in variables for helper in support}
    )
    helper_rows = tuple(
        (
            helper,
            tuple(int(helper in support) for _, support in variables),
        )
        for helper in active_helpers
    )
    demand_rows = tuple(
        tuple(int(owner == demand) for owner, _ in variables)
        for demand in range(len(minimal))
    )
    return ServiceLP(helper_count, len(minimal), variables, helper_rows, demand_rows)


def zero_extend_service_lp(lp: ServiceLP, total_helpers: int, offset: int) -> ServiceLP:
    if offset < 0 or offset + lp.helper_count > total_helpers:
        raise ValueError("inner helper block does not fit")
    shifted_families: list[list[tuple[int, ...]]] = [[] for _ in range(lp.demand_count)]
    for demand, support in lp.variables:
        shifted_families[demand].append(tuple(offset + helper for helper in support))
    return build_service_lp(shifted_families, total_helpers)
