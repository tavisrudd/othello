"""Exact small-instance algorithms for fixed-code and reconfiguration repair."""

from __future__ import annotations

from dataclasses import dataclass
from heapq import heappop, heappush
from itertools import combinations, product
from typing import Hashable, Iterable, Mapping, Sequence, TypeVar

from .finite import Matrix, column_space_basis, mat_mul, matrix_rank, subspace_contains


Node = TypeVar("Node", bound=Hashable)
Resource = TypeVar("Resource", bound=Hashable)
Candidate = TypeVar("Candidate", bound=Hashable)


def _ordered(items: Iterable[Resource]) -> tuple[Resource, ...]:
    return tuple(sorted(set(items), key=repr))


def _minimal_supports(
    supports: Iterable[Iterable[Resource]],
) -> tuple[tuple[Resource, ...], ...]:
    unique = {frozenset(support) for support in supports}
    ordered = sorted(unique, key=lambda support: (len(support), repr(support)))
    minimal: list[frozenset[Resource]] = []
    for support in ordered:
        if not any(other < support for other in minimal):
            minimal.append(support)
    return tuple(_ordered(support) for support in minimal)


@dataclass(frozen=True)
class CapacityCut:
    resources: tuple[Resource, ...]
    forced_demands: tuple[int, ...]
    capacity: int
    repair_upper_bound: int


@dataclass(frozen=True)
class ParallelRepairResult:
    assignment: tuple[tuple[int, tuple[Resource, ...]], ...]
    unmatched_demands: tuple[int, ...]
    states_examined: int
    capacity_cut: CapacityCut

    @property
    def repaired_count(self) -> int:
        return len(self.assignment)

    @property
    def complete(self) -> bool:
        return not self.unmatched_demands


@dataclass(frozen=True)
class WeightedParallelRepairResult:
    assignment: tuple[tuple[int, tuple[tuple[Resource, int], ...]], ...]
    unmatched_demands: tuple[int, ...]
    transitions_examined: int
    peak_pareto_states: int

    @property
    def repaired_count(self) -> int:
        return len(self.assignment)

    @property
    def complete(self) -> bool:
        return not self.unmatched_demands


def maximum_weighted_parallel_repairs(
    repair_options: Sequence[Iterable[Mapping[Resource, int]]],
    capacities: Mapping[Resource, int],
) -> WeightedParallelRepairResult:
    """Maximum parallel repairs for arbitrary integral download/load vectors.

    An option maps each helper or other resource to the number of units it
    consumes.  Pareto dominance discards a state whenever another processed-
    demand state has at least as many repairs and no larger load in any
    coordinate.
    """

    if any(not isinstance(value, int) or value < 0 for value in capacities.values()):
        raise ValueError("capacities must be nonnegative integers")
    resources = _ordered(capacities)
    index = {resource: i for i, resource in enumerate(resources)}
    families: list[tuple[tuple[tuple[Resource, int], ...], ...]] = []
    loads: list[tuple[tuple[int, ...], ...]] = []
    for raw_family in repair_options:
        canonical: set[tuple[tuple[Resource, int], ...]] = set()
        for raw_option in raw_family:
            if any(
                resource not in index
                or not isinstance(amount, int)
                or amount < 0
                for resource, amount in raw_option.items()
            ):
                raise ValueError("loads need listed resources and nonnegative integers")
            option = tuple(
                (resource, raw_option.get(resource, 0))
                for resource in resources
                if raw_option.get(resource, 0)
            )
            if all(amount <= capacities[resource] for resource, amount in option):
                canonical.add(option)
        ordered = sorted(canonical, key=repr)
        minimal = tuple(
            option
            for i, option in enumerate(ordered)
            if not any(
                i != j
                and all(
                    dict(other).get(resource, 0) <= dict(option).get(resource, 0)
                    for resource in resources
                )
                for j, other in enumerate(ordered)
            )
        )
        families.append(minimal)
        loads.append(
            tuple(
                tuple(dict(option).get(resource, 0) for resource in resources)
                for option in minimal
            )
        )

    zero = (0,) * len(resources)
    states: dict[
        tuple[int, ...], tuple[tuple[int, tuple[tuple[Resource, int], ...]], ...]
    ] = {zero: ()}
    transitions = 0
    peak = 1
    for demand, (family, family_loads) in enumerate(zip(families, loads)):
        updated = dict(states)
        for used, assignment in states.items():
            for option, load in zip(family, family_loads):
                transitions += 1
                new_used = tuple(x + y for x, y in zip(used, load))
                if any(
                    new_used[i] > capacities[resource]
                    for i, resource in enumerate(resources)
                ):
                    continue
                candidate = assignment + ((demand, option),)
                incumbent = updated.get(new_used)
                if incumbent is None or len(candidate) > len(incumbent):
                    updated[new_used] = candidate
        items = tuple(updated.items())
        states = {
            used: assignment
            for used, assignment in items
            if not any(
                other_used != used
                and len(other_assignment) >= len(assignment)
                and all(x <= y for x, y in zip(other_used, used))
                for other_used, other_assignment in items
            )
        }
        peak = max(peak, len(states))
    assignment = max(states.values(), key=lambda value: (len(value), repr(value)))
    repaired = {demand for demand, _ in assignment}
    unmatched = tuple(demand for demand in range(len(families)) if demand not in repaired)
    return WeightedParallelRepairResult(
        assignment, unmatched, transitions, peak
    )


def _best_capacity_cut(
    families: tuple[tuple[tuple[Resource, ...], ...], ...],
    capacities: Mapping[Resource, int],
) -> CapacityCut:
    resources = _ordered(capacities)
    if len(resources) > 22:
        return CapacityCut((), (), 0, len(families))
    best = CapacityCut((), (), 0, len(families))
    for mask in range(1 << len(resources)):
        cut = tuple(resources[i] for i in range(len(resources)) if mask >> i & 1)
        cut_set = set(cut)
        forced = tuple(
            demand
            for demand, family in enumerate(families)
            if all(bool(cut_set & set(option)) for option in family)
        )
        capacity = sum(capacities[item] for item in cut)
        upper = min(len(families), len(families) - len(forced) + capacity)
        if upper < best.repair_upper_bound:
            best = CapacityCut(cut, forced, capacity, upper)
    return best


def maximum_parallel_repairs(
    repair_sets: Sequence[Iterable[Iterable[Resource]]],
    capacities: Mapping[Resource, int],
) -> ParallelRepairResult:
    """Choose a maximum number of repairs under integral helper capacities.

    Every selected repair consumes one unit from every resource in its support.
    The dynamic program has at most ``product_h(capacity[h]+1)`` load states.
    This contains distinct-candidate matching as the singleton-support case and
    unit-capacity recovery-set packing as a special case.
    """

    if any(not isinstance(value, int) or value < 0 for value in capacities.values()):
        raise ValueError("capacities must be nonnegative integers")
    families: list[tuple[tuple[Resource, ...], ...]] = []
    for raw_family in repair_sets:
        family = tuple(
            support
            for support in _minimal_supports(raw_family)
            if all(item in capacities and capacities[item] > 0 for item in support)
        )
        families.append(family)
    weighted = maximum_weighted_parallel_repairs(
        tuple(tuple({resource: 1 for resource in support} for support in family) for family in families),
        capacities,
    )
    assignment = tuple(
        (demand, tuple(resource for resource, _ in option))
        for demand, option in weighted.assignment
    )
    repaired = {demand for demand, _ in assignment}
    unmatched = tuple(demand for demand in range(len(families)) if demand not in repaired)
    cut = _best_capacity_cut(tuple(families), capacities)
    if len(assignment) > cut.repair_upper_bound:
        raise AssertionError("capacity cut contradicted a feasible assignment")
    return ParallelRepairResult(
        assignment, unmatched, weighted.transitions_examined, cut
    )


def scalar_recovery_sets_from_dual(
    dual_basis: Matrix,
    target: int,
    p: int,
    radius: int | None = None,
) -> tuple[tuple[int, ...], ...]:
    """Enumerate inclusion-minimal scalar repair supports from a dual basis."""

    if not dual_basis:
        return ()
    length = len(dual_basis[0])
    if any(len(row) != length for row in dual_basis):
        raise ValueError("dual rows have different lengths")
    if not 0 <= target < length:
        raise ValueError("target outside code length")
    if matrix_rank(dual_basis, p) != len(dual_basis):
        raise ValueError("dual input must be a row basis")
    supports = []
    for coefficients in product(range(p), repeat=len(dual_basis)):
        word = tuple(
            sum(coefficients[i] * dual_basis[i][j] for i in range(len(dual_basis))) % p
            for j in range(length)
        )
        if word[target] == 0:
            continue
        support = tuple(j for j, value in enumerate(word) if j != target and value)
        if radius is None or len(support) <= radius:
            supports.append(support)
    return _minimal_supports(supports)


@dataclass(frozen=True)
class ScalarRecoveryEquation:
    support: tuple[int, ...]
    coefficients: tuple[int, ...]


def scalar_recovery_equations_from_dual(
    dual_basis: Matrix,
    target: int,
    p: int,
    radius: int | None = None,
) -> tuple[ScalarRecoveryEquation, ...]:
    """Return normalized equations ``c_target=sum a_h c_h``.

    Only inclusion-minimal helper supports are retained, but distinct
    coefficient fibres on the same support remain distinct equations.
    """

    minimal_supports = set(
        scalar_recovery_sets_from_dual(dual_basis, target, p, radius)
    )
    if not minimal_supports:
        return ()
    equations: set[ScalarRecoveryEquation] = set()
    length = len(dual_basis[0])
    for combination in product(range(p), repeat=len(dual_basis)):
        word = tuple(
            sum(combination[i] * dual_basis[i][j] for i in range(len(dual_basis))) % p
            for j in range(length)
        )
        if not word[target]:
            continue
        support = tuple(j for j, value in enumerate(word) if j != target and value)
        if support not in minimal_supports:
            continue
        inverse = pow(word[target], -1, p)
        coefficients = tuple(-word[helper] * inverse % p for helper in support)
        equations.add(ScalarRecoveryEquation(support, coefficients))
    return tuple(
        sorted(equations, key=lambda equation: (equation.support, equation.coefficients))
    )


def recovery_families_from_dual(
    dual_basis: Matrix,
    targets: Sequence[int],
    p: int,
    radius: int | None = None,
) -> dict[int, tuple[tuple[int, ...], ...]]:
    return {
        target: scalar_recovery_sets_from_dual(dual_basis, target, p, radius)
        for target in targets
    }


def linear_materialization_supports(
    generator: Matrix,
    desired_columns: Matrix,
    p: int,
    max_helpers: int | None = None,
) -> tuple[tuple[int, ...], ...]:
    """Supports whose downloaded symbols jointly materialize new columns.

    ``generator`` is a ``k x n`` generator matrix and ``desired_columns`` is
    ``k x t``.  A support works exactly when its generator-column span contains
    the image of the desired block.  The result retains every inclusion-minimal
    support, not only minimum-cardinality supports.
    """

    if not generator:
        raise ValueError("generator must record a positive message dimension")
    dimension = len(generator)
    length = len(generator[0])
    if any(len(row) != length for row in generator):
        raise ValueError("generator rows have different lengths")
    if len(desired_columns) != dimension:
        raise ValueError("desired columns have the wrong message dimension")
    desired_width = len(desired_columns[0]) if desired_columns else 0
    if any(len(row) != desired_width for row in desired_columns):
        raise ValueError("desired columns have different lengths")
    desired_span = column_space_basis(desired_columns, p)
    limit = length if max_helpers is None else min(max_helpers, length)
    if limit < 0:
        raise ValueError("max_helpers must be nonnegative")
    supports = []
    for size in range(limit + 1):
        for support in combinations(range(length), size):
            block = tuple(tuple(row[j] for j in support) for row in generator)
            helper_span = column_space_basis(block, p) if support else ()
            if subspace_contains(helper_span, desired_span, p):
                supports.append(support)
    return _minimal_supports(supports)


def _solve_full_column_rank(a: Matrix, b: Matrix, p: int) -> Matrix:
    """Solve ``a*x=b`` when a has independent columns and b is in their span."""

    rows = len(a)
    variables = len(a[0]) if a else 0
    outputs = len(b[0]) if b else 0
    work = [list(a[i]) + list(b[i]) for i in range(rows)]
    pivot_row = 0
    for col in range(variables):
        pivot = next((i for i in range(pivot_row, rows) if work[i][col] % p), None)
        if pivot is None:
            raise ValueError("materialization support is not independent")
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][col], -1, p)
        work[pivot_row] = [value * inverse % p for value in work[pivot_row]]
        for i in range(rows):
            if i != pivot_row and work[i][col] % p:
                scalar = work[i][col]
                work[i] = [
                    (x - scalar * y) % p
                    for x, y in zip(work[i], work[pivot_row])
                ]
        pivot_row += 1
    if any(
        not any(row[:variables]) and any(row[variables:])
        for row in work
    ):
        raise ValueError("desired columns are outside the helper span")
    return tuple(
        tuple(work[i][variables + j] for j in range(outputs))
        for i in range(variables)
    )


@dataclass(frozen=True)
class MaterializationPlan:
    support: tuple[int, ...]
    coefficients: Matrix
    output_width: int


def linear_materialization_plans(
    generator: Matrix,
    desired_columns: Matrix,
    p: int,
    max_helpers: int | None = None,
) -> tuple[MaterializationPlan, ...]:
    """Return inclusion-minimal supports together with executable coefficients."""

    plans = []
    for support in linear_materialization_supports(
        generator, desired_columns, p, max_helpers
    ):
        block = tuple(tuple(row[j] for j in support) for row in generator)
        basis_indices: list[int] = []
        for local_index in range(len(support)):
            candidate = tuple(
                tuple(row[j] for j in basis_indices + [local_index])
                for row in block
            )
            if matrix_rank(candidate, p) > len(basis_indices):
                basis_indices.append(local_index)
        basis_block = tuple(
            tuple(row[j] for j in basis_indices) for row in block
        )
        basis_coefficients = _solve_full_column_rank(
            basis_block, desired_columns, p
        )
        coefficients = tuple(
            basis_coefficients[basis_indices.index(i)]
            if i in basis_indices
            else (0,) * (len(desired_columns[0]) if desired_columns else 0)
            for i in range(len(support))
        )
        if support and mat_mul(block, coefficients, p) != desired_columns:
            raise AssertionError("materialization coefficients failed replay")
        if not support and any(any(row) for row in desired_columns):
            raise AssertionError("empty support cannot materialize nonzero columns")
        plans.append(MaterializationPlan(support, coefficients, len(desired_columns[0])))
    return tuple(plans)


@dataclass(frozen=True)
class RepairClosure:
    arrival_times: tuple[tuple[Node, int], ...]
    chosen_supports: tuple[tuple[Node, tuple[Node, ...]], ...]
    unreachable: tuple[Node, ...]


def earliest_repair_times(
    recovery_sets: Mapping[Node, Iterable[Iterable[Node]]],
    initially_live: Iterable[Node],
) -> RepairClosure:
    """Earliest repair rounds with unlimited within-round helper fanout.

    A reverse incidence index updates an AND-option only when one of its
    missing helpers becomes live.  Newly repaired nodes become helpers in the
    following round.
    """

    live = _ordered(initially_live)
    families = {
        owner: tuple(_ordered(support) for support in raw_family)
        for owner, raw_family in recovery_sets.items()
    }
    option_owner: list[Node] = []
    option_support: list[tuple[Node, ...]] = []
    missing: list[int] = []
    latest: list[int] = []
    reverse: dict[Node, list[int]] = {}
    ready_empty: list[int] = []
    for owner, family in families.items():
        for support in family:
            option = len(option_owner)
            option_owner.append(owner)
            option_support.append(support)
            missing.append(len(support))
            latest.append(0)
            if support:
                for helper in support:
                    reverse.setdefault(helper, []).append(option)
            else:
                ready_empty.append(option)

    times: dict[Node, int] = {node: 0 for node in live}
    chosen: dict[Node, tuple[Node, ...]] = {}
    heap: list[tuple[int, str, Node]] = []
    for node in live:
        heappush(heap, (0, repr(node), node))
    for option in ready_empty:
        owner = option_owner[option]
        if owner not in times:
            times[owner] = 1
            chosen[owner] = ()
            heappush(heap, (1, repr(owner), owner))
    while heap:
        time, _, helper = heappop(heap)
        if times.get(helper) != time:
            continue
        for option in reverse.get(helper, ()):
            missing[option] -= 1
            latest[option] = max(latest[option], time)
            if missing[option]:
                continue
            owner = option_owner[option]
            candidate_time = latest[option] + 1
            if owner not in times or candidate_time < times[owner]:
                times[owner] = candidate_time
                chosen[owner] = option_support[option]
                heappush(heap, (candidate_time, repr(owner), owner))
    unreachable = _ordered(owner for owner in families if owner not in times)
    return RepairClosure(
        tuple(sorted(times.items(), key=lambda pair: (pair[1], repr(pair[0])))),
        tuple(sorted(chosen.items(), key=lambda pair: repr(pair[0]))),
        unreachable,
    )


@dataclass(frozen=True)
class RepairSchedule:
    rounds: tuple[tuple[tuple[Node, tuple[Node, ...]], ...], ...]
    unreachable: tuple[Node, ...]
    states_examined: int

    @property
    def complete(self) -> bool:
        return not self.unreachable


def minimum_round_repair_schedule(
    recovery_sets: Mapping[Node, Iterable[Iterable[Node]]],
    initially_live: Iterable[Node],
    capacities: Mapping[Node, int] | None = None,
) -> RepairSchedule:
    """Exact minimum-round centralized repair with renewable capacities.

    The state is the repaired-node subset.  Each transition is an exact
    capacity-feasible parallel batch; repaired nodes become helpers only in the
    next round.  This is exponential and intended as an oracle/planner for
    small failure sets.
    """

    initial = set(initially_live)
    nodes = _ordered(node for node in recovery_sets if node not in initial)
    families = {
        node: tuple(_ordered(support) for support in recovery_sets[node])
        for node in nodes
    }
    capacity = dict(capacities or {})
    if any(not isinstance(value, int) or value < 0 for value in capacity.values()):
        raise ValueError("capacities must be nonnegative integers")
    full_mask = (1 << len(nodes)) - 1
    queue = [0]
    predecessor: dict[int, tuple[int, tuple[tuple[Node, tuple[Node, ...]], ...]]] = {}
    seen = {0}
    examined = 0
    terminal: int | None = None
    head = 0
    while head < len(queue):
        state = queue[head]
        head += 1
        if state == full_mask:
            terminal = state
            break
        live = initial | {nodes[i] for i in range(len(nodes)) if state >> i & 1}
        pending = tuple(i for i in range(len(nodes)) if not (state >> i & 1))
        live_capacities = {helper: capacity.get(helper, 1) for helper in live}
        for size in range(1, len(pending) + 1):
            for selected in combinations(pending, size):
                examined += 1
                eligible = tuple(
                    tuple(support for support in families[nodes[index]] if set(support) <= live)
                    for index in selected
                )
                result = maximum_parallel_repairs(eligible, live_capacities)
                if not result.complete:
                    continue
                next_state = state | sum(1 << index for index in selected)
                if next_state in seen:
                    continue
                batch = tuple(
                    (nodes[selected[demand]], support)
                    for demand, support in result.assignment
                )
                seen.add(next_state)
                predecessor[next_state] = (state, batch)
                queue.append(next_state)
    if terminal is None:
        terminal = max(seen, key=lambda mask: (mask.bit_count(), mask))
    rounds = []
    cursor = terminal
    while cursor:
        previous, batch = predecessor[cursor]
        rounds.append(batch)
        cursor = previous
    repaired = {nodes[i] for i in range(len(nodes)) if terminal >> i & 1}
    return RepairSchedule(
        tuple(reversed(rounds)),
        _ordered(set(nodes) - repaired),
        examined,
    )


def materialized_replacement_families(
    candidate_options: Sequence[Mapping[Candidate, Iterable[Iterable[Node]]]],
) -> tuple[tuple[tuple[tuple[str, Hashable], ...], ...], dict[tuple[str, Hashable], int]]:
    """Combine distinct replacement choice with the downloads that create it.

    The returned supports use tagged candidate and helper resources.  Candidate
    resources have unit capacity; callers add helper capacities before passing
    the result to :func:`maximum_parallel_repairs`.
    """

    families = []
    candidate_resources: dict[tuple[str, Hashable], int] = {}
    for options in candidate_options:
        family = []
        for candidate, download_sets in options.items():
            candidate_resource = ("candidate", candidate)
            candidate_resources[candidate_resource] = 1
            for support in download_sets:
                family.append(
                    (candidate_resource,)
                    + tuple(("helper", helper) for helper in _ordered(support))
                )
        families.append(tuple(family))
    return tuple(families), candidate_resources
