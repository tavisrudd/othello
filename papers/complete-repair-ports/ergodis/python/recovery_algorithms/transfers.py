"""Algorithms transferred from the arc and robust-completion results.

The routines are deliberately incidence- and linear-algebraic.  Geometry is
responsible for constructing their inputs; the algorithms expose the reusable
mechanisms without pretending that the geometric hypotheses hold generally.
"""

from __future__ import annotations

from collections import Counter, deque
from dataclasses import dataclass
from itertools import product
from typing import Hashable, Iterable, Sequence, TypeVar

from .finite import Matrix, canonical_row_basis, matrix_rank, nullspace_basis


Item = TypeVar("Item", bound=Hashable)


def _ordered(items: Iterable[Item]) -> tuple[Item, ...]:
    return tuple(sorted(set(items), key=repr))


@dataclass(frozen=True)
class CollisionCorrection:
    candidate_count: int
    obstruction_count: int
    legal_count: int
    invisible_count: int
    redundancy: int
    multiplicities: tuple[int, ...]


def collision_correction(
    candidates: Iterable[Item], forbidden_by_obstruction: Sequence[Iterable[Item]]
) -> CollisionCorrection:
    """Evaluate ``legal + M = N + invisible + redundancy`` exactly.

    Each obstruction must charge zero or one supplied candidate.  This is the
    unique-charge hypothesis supplied by the mate-line geometry.  Charges
    outside the set and multi-charges are rejected rather than silently
    pretending that the geometric identity applies.
    """

    universe = _ordered(candidates)
    universe_set = set(universe)
    multiplicity: Counter[Item] = Counter()
    invisible = 0
    for raw_charges in forbidden_by_obstruction:
        charges = set(raw_charges)
        if not charges <= universe_set:
            raise ValueError("obstruction charges a nonexistent candidate")
        if len(charges) > 1:
            raise ValueError("collision correction requires unique charges")
        if not charges:
            invisible += 1
        multiplicity.update(charges)
    counts = tuple(multiplicity[item] for item in universe)
    legal = sum(value == 0 for value in counts)
    redundancy = sum(max(value - 1, 0) for value in counts)
    result = CollisionCorrection(
        len(universe),
        len(forbidden_by_obstruction),
        legal,
        invisible,
        redundancy,
        counts,
    )
    if result.legal_count + result.obstruction_count != (
        result.candidate_count + result.invisible_count + result.redundancy
    ):
        raise AssertionError("collision correction identity failed")
    return result


@dataclass(frozen=True)
class DefectCore:
    deleted: tuple[Item, ...]
    survivors: tuple[Item, ...]
    retained_per_clique: tuple[Item, ...]
    edit_charge: int


def delete_to_clique_free_core(
    items: Iterable[Item], bad_cliques: Sequence[Iterable[Item]]
) -> DefectCore:
    """Delete all but one item from each bad concurrence clique.

    This is the constructive cover used by arc defect stability.  The generic
    routine certifies the combinatorial step; the geometric theorem supplies
    the separate bound relating ``edit_charge`` to its defect.
    """

    universe = _ordered(items)
    universe_set = set(universe)
    deleted: set[Item] = set()
    retained: list[Item] = []
    edit_charge = 0
    for raw_clique in bad_cliques:
        clique = _ordered(raw_clique)
        if len(clique) < 2:
            raise ValueError("a bad clique must contain at least two items")
        if not set(clique) <= universe_set:
            raise ValueError("bad clique contains a nonexistent item")
        keep = next((item for item in clique if item not in deleted), clique[0])
        retained.append(keep)
        deleted.update(item for item in clique if item != keep)
        edit_charge += len(clique) - 1
    survivors = tuple(item for item in universe if item not in deleted)
    survivor_set = set(survivors)
    if any(len(survivor_set & set(clique)) > 1 for clique in bad_cliques):
        raise AssertionError("constructed core still contains a bad pair")
    return DefectCore(_ordered(deleted), survivors, tuple(retained), edit_charge)


@dataclass(frozen=True)
class DistinctRepairs:
    assignment: tuple[tuple[int, Item], ...]
    unmatched_demands: tuple[int, ...]
    hall_left: tuple[int, ...]
    hall_neighbors: tuple[Item, ...]

    @property
    def complete(self) -> bool:
        return not self.unmatched_demands


def maximum_distinct_repairs(
    candidate_families: Sequence[Iterable[Item]],
) -> DistinctRepairs:
    """Maximum matching of failed objects to distinct legal replacements.

    On failure, ``hall_left`` and ``hall_neighbors`` certify
    ``|N(hall_left)| < |hall_left|``.
    """

    adjacency = tuple(_ordered(family) for family in candidate_families)
    matched_right: dict[Item, int] = {}
    matched_left: dict[int, Item] = {}

    def augment(left: int, seen: set[Item]) -> bool:
        for right in adjacency[left]:
            if right in seen:
                continue
            seen.add(right)
            owner = matched_right.get(right)
            if owner is None or augment(owner, seen):
                matched_right[right] = left
                matched_left[left] = right
                return True
        return False

    for left in range(len(adjacency)):
        augment(left, set())

    unmatched = tuple(left for left in range(len(adjacency)) if left not in matched_left)
    if not unmatched:
        return DistinctRepairs(
            tuple(sorted(matched_left.items())), (), (), ()
        )

    # Alternating reachability from unmatched left vertices gives a Hall set.
    reachable_left = set(unmatched)
    reachable_right: set[Item] = set()
    queue = deque(unmatched)
    while queue:
        left = queue.popleft()
        matched = matched_left.get(left)
        for right in adjacency[left]:
            if right == matched or right in reachable_right:
                continue
            reachable_right.add(right)
            owner = matched_right.get(right)
            if owner is not None and owner not in reachable_left:
                reachable_left.add(owner)
                queue.append(owner)
    if len(reachable_right) >= len(reachable_left):
        raise AssertionError("alternating search did not produce a Hall witness")
    return DistinctRepairs(
        tuple(sorted(matched_left.items())),
        unmatched,
        tuple(sorted(reachable_left)),
        _ordered(reachable_right),
    )


def replacement_graph_components(
    configurations: Iterable[Iterable[Item]],
) -> tuple[tuple[frozenset[Item], ...], ...]:
    """Components under one-delete/one-add replacement moves.

    States are bucketed by every one-item deletion.  Sharing a bucket is
    exactly adjacency, so unioning each bucket avoids an all-pairs graph scan.
    """

    states = tuple(sorted({frozenset(state) for state in configurations}, key=repr))
    if states and any(len(state) != len(states[0]) for state in states):
        raise ValueError("replacement configurations must have equal size")
    parent = list(range(len(states)))

    def find(index: int) -> int:
        while parent[index] != index:
            parent[index] = parent[parent[index]]
            index = parent[index]
        return index

    def union(left: int, right: int) -> None:
        left_root, right_root = find(left), find(right)
        if left_root != right_root:
            parent[right_root] = left_root

    buckets: dict[frozenset[Item], list[int]] = {}
    for index, state in enumerate(states):
        for item in state:
            buckets.setdefault(state - {item}, []).append(index)
    for bucket in buckets.values():
        for index in bucket[1:]:
            union(bucket[0], index)
    grouped: dict[int, list[frozenset[Item]]] = {}
    for index, state in enumerate(states):
        grouped.setdefault(find(index), []).append(state)
    components = [tuple(sorted(component, key=repr)) for component in grouped.values()]
    return tuple(sorted(components, key=lambda component: repr(component[0])))


@dataclass(frozen=True)
class FeatureSeparator:
    witness: tuple[int, ...] | None
    obstruction: str | None
    nullity: int
    candidates_examined: int


def feature_separator(
    forbidden_evaluations: Matrix,
    protected_evaluations: Matrix,
    ambient_dimension: int,
    p: int,
) -> FeatureSeparator:
    """Find a form vanishing on all forbidden and on no protected point.

    For one protected point this is the sharp span test.  For several points
    finite-field hyperplanes can cover the nullspace, so the final small-space
    search is necessary and returns an exact ``finite_field_cover`` certificate.
    """

    if ambient_dimension < 1:
        raise ValueError("ambient dimension must be positive")
    rows = forbidden_evaluations + protected_evaluations
    if any(len(row) != ambient_dimension for row in rows):
        raise ValueError("evaluation width mismatch")
    forbidden_basis = canonical_row_basis(forbidden_evaluations, p)
    if len(forbidden_basis) == ambient_dimension:
        return FeatureSeparator(None, "full_forbidden_span", 0, 0)
    for evaluation in protected_evaluations:
        if matrix_rank(forbidden_basis + (evaluation,), p) == len(forbidden_basis):
            return FeatureSeparator(
                None, "protected_evaluation_in_forbidden_span",
                ambient_dimension - len(forbidden_basis), 0,
            )
    if forbidden_basis:
        kernel = nullspace_basis(forbidden_basis, p)
    else:
        kernel = tuple(
            tuple(int(i == j) for j in range(ambient_dimension))
            for i in range(ambient_dimension)
        )
    examined = 0
    for coefficients in product(range(p), repeat=len(kernel)):
        if not any(coefficients):
            continue
        examined += 1
        witness = tuple(
            sum(coefficients[i] * kernel[i][j] for i in range(len(kernel))) % p
            for j in range(ambient_dimension)
        )
        if all(
            sum(x * y for x, y in zip(evaluation, witness)) % p
            for evaluation in protected_evaluations
        ):
            return FeatureSeparator(witness, None, len(kernel), examined)
    return FeatureSeparator(None, "finite_field_cover", len(kernel), examined)
