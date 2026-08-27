"""Min-sum algorithms for prescribed-coset and confinement costs."""

from __future__ import annotations

from dataclasses import dataclass, field
from itertools import product
from math import prod
from typing import Iterable, Mapping, Sequence

from .finite import (
    LinearMap,
    Matrix,
    all_matrices,
    canonical_row_basis,
    column_block,
    column_space_basis,
    concatenate_columns,
    flatten,
    mat_add,
    mat_mul,
    mat_sub,
    nullspace_basis,
    shape,
    subspace_contains,
    transpose,
    unflatten,
    zero_matrix,
)

INF = 10**18


@dataclass(frozen=True)
class RecoveryWitness:
    """Replayable certificate for one min-plus table entry."""

    label: Matrix
    cost: int
    support: tuple[int, ...] = ()
    lift: Matrix | None = None
    local_labels: tuple[Matrix, ...] = ()
    children: tuple["RecoveryWitness", ...] = ()


@dataclass(frozen=True)
class WitnessVerification:
    valid: bool
    errors: tuple[str, ...]


def verify_leaf_witness(phi: LinearMap, witness: RecoveryWitness) -> WitnessVerification:
    """Verify a prescribed-coset leaf without rerunning its optimization."""

    errors = []
    if witness.lift is None:
        errors.append("missing_lift")
    else:
        if shape(witness.label) != (phi.codomain_dim, len(witness.lift[0]) if witness.lift else 0):
            errors.append("label_shape")
        elif shape(witness.lift)[0] != phi.domain_dim:
            errors.append("lift_shape")
        elif mat_mul(phi.data, witness.lift, phi.p) != witness.label:
            errors.append("lift_replay")
        actual_support = tuple(
            index for index, row in enumerate(witness.lift) if any(row)
        )
        if actual_support != witness.support:
            errors.append("support")
        if len(actual_support) != witness.cost:
            errors.append("cost")
    return WitnessVerification(not errors, tuple(errors))


def verify_composition_witness(
    outer_blocks: Sequence[Matrix], witness: RecoveryWitness, p: int
) -> WitnessVerification:
    """Verify one hierarchical min-plus node from its child labels and costs."""

    errors = []
    if not outer_blocks:
        errors.append("missing_blocks")
        return WitnessVerification(False, tuple(errors))
    if not (
        len(outer_blocks) == len(witness.local_labels) == len(witness.children)
    ):
        errors.append("arity")
        return WitnessVerification(False, tuple(errors))
    output_rows, _ = shape(outer_blocks[0])
    _, demand_dim = shape(witness.label)
    replay = zero_matrix(output_rows, demand_dim)
    for block, label, child in zip(
        outer_blocks, witness.local_labels, witness.children
    ):
        if child.label != label:
            errors.append("child_label")
            continue
        try:
            replay = mat_add(replay, mat_mul(block, label, p), p)
        except ValueError:
            errors.append("shape")
    if replay != witness.label:
        errors.append("label_replay")
    if sum(child.cost for child in witness.children) != witness.cost:
        errors.append("cost")
    return WitnessVerification(not errors, tuple(errors))


def hierarchical_helper_loads(
    witness: RecoveryWitness,
) -> tuple[tuple[tuple[int, ...], int], ...]:
    """Extract exact leaf-helper loads, addressed by hierarchy path and coordinate."""

    loads: dict[tuple[int, ...], int] = {}

    def visit(node: RecoveryWitness, path: tuple[int, ...]) -> None:
        # A translated leaf retains a child explaining its shifted label, but
        # its own restored lift is the executable helper action.
        if node.lift is not None:
            for coordinate in node.support:
                resource = path + (coordinate,)
                loads[resource] = loads.get(resource, 0) + 1
            return
        for index, child in enumerate(node.children):
            visit(child, path + (index,))

    visit(witness, ())
    return tuple(sorted(loads.items()))


@dataclass(frozen=True)
class CostTable:
    p: int
    output_dim: int
    demand_dim: int
    costs: Mapping[tuple[int, ...], int]
    transitions: int = 0
    homogeneous_subadditive: bool = False
    witnesses: Mapping[tuple[int, ...], RecoveryWitness] = field(default_factory=dict)
    witness_source: LinearMap | None = None

    def key(self, value: Matrix) -> tuple[int, ...]:
        if shape(value) != (self.output_dim, self.demand_dim):
            raise ValueError("cost-table query has wrong shape")
        return flatten(value)

    def get(self, value: Matrix) -> int:
        return self.costs.get(self.key(value), INF)

    def witness_for(self, value: Matrix) -> RecoveryWitness | None:
        key = self.key(value)
        witness = self.witnesses.get(key)
        if witness is not None:
            return witness
        if self.witness_source is None or self.get(value) == INF:
            return None
        witness = prescribed_coset_witness(self.witness_source, value)
        if witness is None or witness.cost != self.get(value):
            raise AssertionError("lazy prescribed-coset witness disagrees with cost table")
        return witness

    def matrix_for(self, key: tuple[int, ...]) -> Matrix:
        return unflatten(key, self.output_dim, self.demand_dim, self.p)

    def nonzero_extrema(self) -> tuple[int, int]:
        zero = (0,) * (self.output_dim * self.demand_dim)
        values = [cost for key, cost in self.costs.items() if key != zero]
        if not values:
            return (INF, -INF)
        return min(values), max(values)


@dataclass(frozen=True)
class SubspaceCostTable:
    """Compact costs keyed by spans of selected projective columns."""

    p: int
    ambient_dim: int
    generated_spans: tuple[Matrix, ...]
    transitions: int = 0
    witness_source: LinearMap | None = None

    def cost_for_subspace(self, basis: Matrix) -> int:
        canonical = canonical_row_basis(basis, self.p)
        return min(
            (
                len(span)
                for span in self.generated_spans
                if subspace_contains(span, canonical, self.p)
            ),
            default=INF,
        )

    def get(self, value: Matrix) -> int:
        if len(value) != self.ambient_dim:
            raise ValueError("subspace-cost query has wrong codomain dimension")
        return self.cost_for_subspace(column_space_basis(value, self.p))

    def expand(self, demand_dim: int) -> CostTable:
        costs: dict[tuple[int, ...], int] = {}
        candidates = 0
        for span in self.generated_spans:
            dimension = len(span)
            if dimension:
                basis_columns = transpose(span)
                values = (
                    mat_mul(basis_columns, coefficients, self.p)
                    for coefficients in all_matrices(
                        dimension, demand_dim, self.p
                    )
                )
            else:
                values = (zero_matrix(self.ambient_dim, demand_dim),)
            for value in values:
                candidates += 1
                costs.setdefault(flatten(value), dimension)
        return CostTable(
            self.p,
            self.ambient_dim,
            demand_dim,
            costs,
            self.transitions + candidates,
            True,
            witness_source=self.witness_source,
        )


def _outer_product(column: Sequence[int], row: Sequence[int], p: int) -> Matrix:
    return tuple(tuple(x * y % p for y in row) for x in column)


def simplify_projective_columns(phi: LinearMap) -> LinearMap:
    """Delete zero columns and retain one column from each projective class."""

    representatives: list[tuple[int, ...]] = []
    seen: set[tuple[int, ...]] = set()
    for coordinate in range(phi.domain_dim):
        column = tuple(phi.data[i][coordinate] for i in range(phi.codomain_dim))
        pivot = next((entry for entry in column if entry), None)
        if pivot is None:
            continue
        inverse = pow(pivot, -1, phi.p)
        normalized = tuple(entry * inverse % phi.p for entry in column)
        if normalized not in seen:
            seen.add(normalized)
            representatives.append(normalized)
    data = tuple(
        tuple(column[row] for column in representatives)
        for row in range(phi.codomain_dim)
    )
    return LinearMap(phi.p, data)


def _projective_columns_with_origins(
    phi: LinearMap,
) -> tuple[tuple[tuple[int, ...], int, int], ...]:
    """Return normalized columns with original coordinate and inverse scale."""

    representatives: list[tuple[tuple[int, ...], int, int]] = []
    seen: set[tuple[int, ...]] = set()
    for coordinate in range(phi.domain_dim):
        column = tuple(phi.data[i][coordinate] for i in range(phi.codomain_dim))
        pivot = next((entry for entry in column if entry), None)
        if pivot is None:
            continue
        inverse = pow(pivot, -1, phi.p)
        normalized = tuple(entry * inverse % phi.p for entry in column)
        if normalized not in seen:
            seen.add(normalized)
            representatives.append((normalized, coordinate, inverse))
    return tuple(representatives)


def prescribed_coset_witness(
    phi: LinearMap, target: Matrix
) -> RecoveryWitness | None:
    """Return a canonical minimum-support lift of ``target`` through ``phi``."""

    target_rows, demand_dim = shape(target)
    if target_rows != phi.codomain_dim:
        raise ValueError("target codomain dimension mismatch")
    representatives = _projective_columns_with_origins(phi)
    zero_key = (0,) * (phi.codomain_dim * demand_dim)
    states: dict[
        tuple[int, ...],
        tuple[int, tuple[int, ...], tuple[tuple[int, ...], ...]],
    ] = {zero_key: (0, (), ())}
    for column, coordinate, _ in representatives:
        new: dict[
            tuple[int, ...],
            tuple[int, tuple[int, ...], tuple[tuple[int, ...], ...]],
        ] = {}
        for state_key, (old_cost, support, rows) in states.items():
            state = unflatten(state_key, phi.codomain_dim, demand_dim, phi.p)
            for row in product(range(phi.p), repeat=demand_dim):
                key = flatten(mat_add(state, _outer_product(column, row, phi.p), phi.p))
                row_nonzero = any(row)
                candidate = (
                    old_cost + int(row_nonzero),
                    support + ((coordinate,) if row_nonzero else ()),
                    rows + (tuple(row),),
                )
                if key not in new or candidate < new[key]:
                    new[key] = candidate
        states = new
    target_key = flatten(target)
    if target_key not in states:
        return None
    cost, _, rows = states[target_key]
    lift = [[0] * demand_dim for _ in range(phi.domain_dim)]
    for row, (_, coordinate, inverse) in zip(rows, representatives):
        lift[coordinate] = [entry * inverse % phi.p for entry in row]
    lift_matrix = tuple(tuple(row) for row in lift)
    if mat_mul(phi.data, lift_matrix, phi.p) != target:
        raise AssertionError("prescribed-coset witness does not replay")
    support = tuple(index for index, row in enumerate(lift_matrix) if any(row))
    return RecoveryWitness(target, cost, support, lift_matrix)


def prescribed_coset_costs_row_dp(
    phi: LinearMap, demand_dim: int, *, simplify_columns: bool = True
) -> CostTable:
    """Compute every Lambda_{phi,T}(b) by coordinate-wise min-sum DP.

    Zero columns and duplicate projective column classes are irrelevant to the
    optimum, so they are removed by default before the recurrence is run.
    """

    working_phi = simplify_projective_columns(phi) if simplify_columns else phi
    p = working_phi.p
    k = working_phi.codomain_dim
    zero_key = (0,) * (k * demand_dim)
    states: dict[tuple[int, ...], int] = {zero_key: 0}
    transitions = 0
    for coordinate in range(working_phi.domain_dim):
        column = tuple(working_phi.data[i][coordinate] for i in range(k))
        choices = tuple(
            (_outer_product(column, row, p), int(any(row)))
            for row in product(range(p), repeat=demand_dim)
        )
        new: dict[tuple[int, ...], int] = {}
        for state_key, old_cost in states.items():
            state = unflatten(state_key, k, demand_dim, p)
            for contribution, row_cost in choices:
                transitions += 1
                target = flatten(mat_add(state, contribution, p))
                candidate = old_cost + row_cost
                if candidate < new.get(target, INF):
                    new[target] = candidate
        states = new
    return CostTable(p, k, demand_dim, states, transitions, True)


def prescribed_coset_subspace_costs(phi: LinearMap) -> SubspaceCostTable:
    """Compute prescribed-coset costs as a demand-independent span DP."""

    working_phi = simplify_projective_columns(phi)
    states: set[Matrix] = {()}
    transitions = 0
    for coordinate in range(working_phi.domain_dim):
        column = tuple(
            working_phi.data[i][coordinate]
            for i in range(working_phi.codomain_dim)
        )
        new = set(states)
        for span in states:
            transitions += 2
            target = canonical_row_basis(span + (column,), working_phi.p)
            new.add(target)
        states = new
    return SubspaceCostTable(
        working_phi.p,
        working_phi.codomain_dim,
        tuple(sorted(states, key=lambda basis: (len(basis), basis))),
        transitions,
        phi,
    )


def prescribed_coset_costs(phi: LinearMap, demand_dim: int) -> CostTable:
    """Expand the compact subspace DP to the requested matrix-label table."""

    return prescribed_coset_subspace_costs(phi).expand(demand_dim)


def prescribed_coset_costs_direct(phi: LinearMap, demand_dim: int) -> CostTable:
    """Independent full-lift enumeration used only as a small-case oracle."""

    costs: dict[tuple[int, ...], int] = {}
    witnesses: dict[tuple[int, ...], RecoveryWitness] = {}
    candidates = 0
    for lift in all_matrices(phi.domain_dim, demand_dim, phi.p):
        candidates += 1
        target = flatten(mat_mul(phi.data, lift, phi.p))
        cost = sum(any(x != 0 for x in row) for row in lift)
        support = tuple(index for index, row in enumerate(lift) if any(row))
        witness = RecoveryWitness(
            unflatten(target, phi.codomain_dim, demand_dim, phi.p),
            cost,
            support,
            lift,
        )
        if cost < costs.get(target, INF) or (
            cost == costs.get(target, INF)
            and repr(witness) < repr(witnesses[target])
        ):
            costs[target] = cost
            witnesses[target] = witness
    return CostTable(
        phi.p, phi.codomain_dim, demand_dim, costs, candidates, True, witnesses
    )


def translated_cost_table(base: CostTable, target_contribution: Matrix) -> CostTable:
    """Return mu(b)=Lambda(b-target_contribution), as in equation (C3)."""

    if shape(target_contribution) != (base.output_dim, base.demand_dim):
        raise ValueError("target contribution has wrong shape")
    costs = {}
    witnesses = {}
    for b in all_matrices(base.output_dim, base.demand_dim, base.p):
        shifted = mat_sub(b, target_contribution, base.p)
        value = base.get(shifted)
        if value < INF:
            key = flatten(b)
            costs[key] = value
            source_witness = base.witness_for(shifted)
            if source_witness is not None:
                witnesses[key] = RecoveryWitness(
                    b,
                    value,
                    source_witness.support,
                    source_witness.lift,
                    (shifted,),
                    (source_witness,),
                )
    return CostTable(
        base.p,
        base.output_dim,
        base.demand_dim,
        costs,
        base.transitions,
        base.homogeneous_subadditive and not any(flatten(target_contribution)),
        witnesses,
    )


def iterated_envelope(constants: Sequence[tuple[int, int]]) -> tuple[int, int]:
    """Multiply sharp one-level constants for a tower-screening bound."""

    lower = upper = 1
    for delta, radius in constants:
        if delta < 0 or radius < delta:
            raise ValueError("invalid envelope constants")
        lower *= delta
        upper *= radius
    return lower, upper


def _all_map_costs(output_dim: int, demand_dim: int, p: int) -> CostTable:
    costs = {
        flatten(value): int(any(any(x != 0 for x in row) for row in value))
        for value in all_matrices(output_dim, demand_dim, p)
    }
    return CostTable(p, output_dim, demand_dim, costs, homogeneous_subadditive=True)


def _simplify_proportional_blocks(blocks: Sequence[Matrix], p: int) -> tuple[Matrix, ...]:
    representatives: dict[tuple[int, ...], Matrix] = {}
    for block in blocks:
        values = flatten(block)
        pivot = next((entry for entry in values if entry), None)
        if pivot is None:
            continue
        inverse = pow(pivot, -1, p)
        normalized = tuple(entry * inverse % p for entry in values)
        representatives.setdefault(
            normalized,
            tuple(tuple(entry * inverse % p for entry in row) for row in block),
        )
    return tuple(representatives.values())


def cost_contractions(inner: CostTable) -> tuple[Matrix, ...]:
    """Enumerate linear S with inner(Sx) <= inner(x) for every attainable x."""

    dimension = inner.output_dim
    contractions = []
    labels = tuple(
        (inner.matrix_for(key), cost) for key, cost in inner.costs.items()
    )
    for candidate in all_matrices(dimension, dimension, inner.p):
        if all(
            inner.get(mat_mul(candidate, label, inner.p)) <= cost
            for label, cost in labels
        ):
            contractions.append(candidate)
    return tuple(contractions)


def simplify_dominated_blocks(
    outer_blocks: Sequence[Matrix], inner: CostTable
) -> tuple[Matrix, ...]:
    """Keep maximal outer blocks under factorization through cost contractions."""

    if not outer_blocks:
        return ()
    if not inner.homogeneous_subadditive:
        raise ValueError("block dominance requires a homogeneous subadditive cost")
    contractions = cost_contractions(inner)
    dominates = tuple(
        tuple(
            any(mat_mul(left, contraction, inner.p) == right for contraction in contractions)
            for right in outer_blocks
        )
        for left in outer_blocks
    )
    maximal = tuple(
        j
        for j in range(len(outer_blocks))
        if not any(
            dominates[i][j] and not dominates[j][i]
            for i in range(len(outer_blocks))
        )
    )
    retained = []
    for j in maximal:
        if any(dominates[i][j] and dominates[j][i] for i in retained):
            continue
        retained.append(j)
    return tuple(outer_blocks[j] for j in retained)


def compose_cost_table(
    outer_blocks: Sequence[Matrix],
    inner: CostTable,
    *,
    simplify_blocks: bool = True,
    search_dominance: bool = False,
    retain_witnesses: bool = False,
) -> CostTable:
    """Apply exact labelled min-sum substitution to all output labels.

    Witness mode keeps the literal supplied block order; scalar-only block
    compression is skipped because a normalized representative would not be
    an executable plan for the original helper block without extra scaling
    data.
    """

    if not outer_blocks:
        raise ValueError("composition needs at least one outer block")
    p = inner.p
    m, ell = shape(outer_blocks[0])
    if ell != inner.output_dim or any(shape(block) != (m, ell) for block in outer_blocks):
        raise ValueError("outer block shape mismatch")
    if retain_witnesses:
        working_blocks = tuple(outer_blocks)
    elif search_dominance:
        working_blocks = simplify_dominated_blocks(outer_blocks, inner)
    elif simplify_blocks and inner.homogeneous_subadditive:
        working_blocks = _simplify_proportional_blocks(outer_blocks, p)
    else:
        working_blocks = tuple(outer_blocks)
    t = inner.demand_dim
    states: dict[tuple[int, ...], int] = {(0,) * (m * t): 0}
    paths: dict[
        tuple[int, ...], tuple[tuple[Matrix, RecoveryWitness], ...]
    ] = {(0,) * (m * t): ()}
    transitions = 0
    choices = tuple((inner.matrix_for(key), cost) for key, cost in inner.costs.items())
    for block in working_blocks:
        increments = tuple(
            (mat_mul(block, value, p), local_cost, value)
            for value, local_cost in choices
        )
        new: dict[tuple[int, ...], int] = {}
        new_paths: dict[
            tuple[int, ...], tuple[tuple[Matrix, RecoveryWitness], ...]
        ] = {}
        for state_key, old_cost in states.items():
            state = unflatten(state_key, m, t, p)
            for increment, local_cost, value in increments:
                transitions += 1
                target = flatten(mat_add(state, increment, p))
                candidate = old_cost + local_cost
                candidate_path = None
                if retain_witnesses:
                    local_witness = inner.witness_for(value)
                    if local_witness is None:
                        raise ValueError("inner table cannot supply a witness")
                    candidate_path = paths[state_key] + ((value, local_witness),)
                if candidate < new.get(target, INF) or (
                    retain_witnesses
                    and candidate == new.get(target, INF)
                    and repr(candidate_path) < repr(new_paths[target])
                ):
                    new[target] = candidate
                    if candidate_path is not None:
                        new_paths[target] = candidate_path
        states = new
        if retain_witnesses:
            paths = new_paths
    witnesses = {
        key: RecoveryWitness(
            unflatten(key, m, t, p),
            states[key],
            local_labels=tuple(value for value, _ in path),
            children=tuple(witness for _, witness in path),
        )
        for key, path in paths.items()
    } if retain_witnesses else {}
    return CostTable(
        p,
        m,
        t,
        states,
        transitions,
        inner.homogeneous_subadditive,
        witnesses,
    )


def compose_cost_table_with_witnesses(
    outer_blocks: Sequence[Matrix], inner: CostTable
) -> CostTable:
    """Literal-block composition with a canonical recursive witness per label."""

    return compose_cost_table(
        outer_blocks, inner, simplify_blocks=False, retain_witnesses=True
    )


def outer_block_cost_table(
    outer_blocks: Sequence[Matrix], demand_dim: int, p: int
) -> CostTable:
    """Outer Lambda table where a nonzero intermediate block costs one."""

    if not outer_blocks:
        raise ValueError("outer map needs blocks")
    ell = shape(outer_blocks[0])[1]
    return compose_cost_table(outer_blocks, _all_map_costs(ell, demand_dim, p))


def direct_composite_map(outer_blocks: Sequence[Matrix], inner_phi: LinearMap) -> LinearMap:
    """Construct phi_{A o B} blockwise for independent direct verification."""

    products = [mat_mul(block, inner_phi.data, inner_phi.p) for block in outer_blocks]
    return LinearMap(inner_phi.p, concatenate_columns(products))


def compose_prescribed_costs_via_spans(
    outer_blocks: Sequence[Matrix], inner_phi: LinearMap, demand_dim: int
) -> CostTable:
    """Compose explicit maps first, then run one generated-span optimization."""

    return prescribed_coset_costs(
        direct_composite_map(outer_blocks, inner_phi), demand_dim
    )


def sharp_composition_envelope(
    outer_blocks: Sequence[Matrix], inner: CostTable
) -> tuple[CostTable, CostTable, int, int]:
    """Return composite/outer tables and the sharp one-level constants."""

    composed = compose_cost_table(outer_blocks, inner)
    outer = outer_block_cost_table(outer_blocks, inner.demand_dim, inner.p)
    delta, radius = inner.nonzero_extrema()
    return composed, outer, delta, radius


def _maps_into_subspace(
    basis_columns: Matrix, demand_dim: int, p: int
) -> tuple[Matrix, ...]:
    ambient_dim, _ = shape(basis_columns)
    basis_rows = column_space_basis(basis_columns, p)
    subspace_dim = len(basis_rows)
    canonical_columns = transpose(basis_rows) if basis_rows else ()
    return tuple(
        mat_mul(canonical_columns, coefficients, p)
        for coefficients in all_matrices(subspace_dim, demand_dim, p)
    ) if subspace_dim else (zero_matrix(ambient_dim, demand_dim),)


@dataclass(frozen=True)
class TargetNormalizedWitnessResult:
    cost: int
    transitions: int
    target_images: tuple[Matrix, ...]
    local_labels: tuple[Matrix, ...]
    local_witnesses: tuple[RecoveryWitness, ...]


def _target_normalized_composition_result(
    outer_blocks: Sequence[Matrix],
    helper_costs: Sequence[CostTable],
    target_image_bases: Sequence[Matrix],
    normalization: Matrix,
    prescribed: Matrix,
    retain_witnesses: bool,
) -> TargetNormalizedWitnessResult:
    """Evaluate equation (C6) and retain its canonical labelled minimizer."""

    if not (
        len(outer_blocks) == len(helper_costs) == len(target_image_bases)
        and outer_blocks
    ):
        raise ValueError("one helper table and target image are required per block")
    p = helper_costs[0].p
    t = helper_costs[0].demand_dim
    m, ell = shape(outer_blocks[0])
    if shape(normalization) != (m, t) or shape(prescribed) != (m, t):
        raise ValueError("target condition has wrong shape")
    zero_pair = (0,) * (2 * m * t)
    states: dict[tuple[int, ...], int] = {zero_pair: 0}
    paths: dict[
        tuple[int, ...], tuple[tuple[Matrix, Matrix, RecoveryWitness], ...]
    ] = {zero_pair: ()}
    transitions = 0
    for block, local, image_basis in zip(
        outer_blocks, helper_costs, target_image_bases
    ):
        if local.p != p or local.output_dim != ell or local.demand_dim != t:
            raise ValueError("incompatible local helper table")
        u_maps = _maps_into_subspace(image_basis, t, p)
        z_maps = tuple((local.matrix_for(key), cost) for key, cost in local.costs.items())
        local_choices = tuple(
            (
                mat_mul(block, u, p),
                mat_mul(block, mat_add(u, z, p), p),
                local_cost,
                u,
                z,
                local.witness_for(z) if retain_witnesses else None,
            )
            for u in u_maps
            for z, local_cost in z_maps
        )
        new: dict[tuple[int, ...], int] = {}
        new_paths: dict[
            tuple[int, ...], tuple[tuple[Matrix, Matrix, RecoveryWitness], ...]
        ] = {}
        for pair_key, old_cost in states.items():
            split = m * t
            norm_state = unflatten(pair_key[:split], m, t, p)
            total_state = unflatten(pair_key[split:], m, t, p)
            for norm_add, total_add, local_cost, u, z, local_witness in local_choices:
                if retain_witnesses and local_witness is None:
                    raise ValueError("local helper table cannot supply a witness")
                transitions += 1
                next_norm = mat_add(norm_state, norm_add, p)
                next_total = mat_add(total_state, total_add, p)
                key = flatten(next_norm) + flatten(next_total)
                candidate = old_cost + local_cost
                candidate_path = (
                    paths[pair_key] + ((u, z, local_witness),)
                    if retain_witnesses
                    else None
                )
                if candidate < new.get(key, INF) or (
                    retain_witnesses
                    and candidate == new.get(key, INF)
                    and repr(candidate_path) < repr(new_paths[key])
                ):
                    new[key] = candidate
                    if candidate_path is not None:
                        new_paths[key] = candidate_path
        states = new
        if retain_witnesses:
            paths = new_paths
    key = flatten(normalization) + flatten(prescribed)
    if key not in states:
        return TargetNormalizedWitnessResult(INF, transitions, (), (), ())
    if not retain_witnesses:
        return TargetNormalizedWitnessResult(states[key], transitions, (), (), ())
    path = paths[key]
    return TargetNormalizedWitnessResult(
        states[key],
        transitions,
        tuple(u for u, _, _ in path),
        tuple(z for _, z, _ in path),
        tuple(witness for _, _, witness in path),
    )


def target_normalized_composition(
    outer_blocks: Sequence[Matrix],
    helper_costs: Sequence[CostTable],
    target_image_bases: Sequence[Matrix],
    normalization: Matrix,
    prescribed: Matrix,
) -> tuple[int, int]:
    """Evaluate equation (C6) and return its legacy scalar interface."""

    result = _target_normalized_composition_result(
        outer_blocks,
        helper_costs,
        target_image_bases,
        normalization,
        prescribed,
        False,
    )
    return result.cost, result.transitions


def target_normalized_composition_with_witness(
    outer_blocks: Sequence[Matrix],
    helper_costs: Sequence[CostTable],
    target_image_bases: Sequence[Matrix],
    normalization: Matrix,
    prescribed: Matrix,
) -> TargetNormalizedWitnessResult:
    return _target_normalized_composition_result(
        outer_blocks,
        helper_costs,
        target_image_bases,
        normalization,
        prescribed,
        True,
    )


@dataclass(frozen=True)
class ConfinementResult:
    cost: int
    sector: str
    functional_coefficients: tuple[int, ...] | None
    transitions: int
    block_labels: tuple[Matrix, ...] = ()
    block_witnesses: tuple[RecoveryWitness | None, ...] = ()
    inner_distance_support: tuple[int, ...] | None = None
    witness_complete: bool = False


@dataclass(frozen=True)
class ConfinementPlan:
    method: str
    generator_candidate_bound: int
    syndrome_transition_bound: int | None
    result: ConfinementResult


@dataclass(frozen=True)
class RankOneTransferCertificate:
    radius: int
    transfers_completely: bool
    obstruction_cost: int | None
    obstruction_sector: str | None
    functional_coefficients: tuple[int, ...] | None
    block_labels: tuple[Matrix, ...]
    candidates_examined: int
    local_lookups: int


def certify_rank_one_transfer(
    functional_dual_basis: Matrix,
    block_count: int,
    inner_lambda: CostTable,
    target_mu: CostTable,
    target_block: int,
    inner_dual_distance: int,
    radius: int,
) -> RankOneTransferCertificate:
    """Decide complete transfer through ``radius`` from rank-one costs."""

    p = inner_lambda.p
    k = inner_lambda.output_dim
    if (
        radius < 0
        or inner_lambda.demand_dim != 1
        or target_mu.p != p
        or target_mu.output_dim != k
        or target_mu.demand_dim != 1
        or not 0 <= target_block < block_count
        or any(len(row) != block_count * k for row in functional_dual_basis)
    ):
        raise ValueError("incompatible rank-one certificate input")
    zero = zero_matrix(k, 1)
    zero_cost = target_mu.get(zero) + inner_dual_distance
    if zero_cost <= radius:
        return RankOneTransferCertificate(
            radius, False, zero_cost, "zero", None, (zero,) * block_count, 0, 1
        )

    dimension = len(functional_dual_basis)
    fd_transpose = transpose(functional_dual_basis)
    examined = 0
    lookups = 1
    order = (target_block,) + tuple(
        block for block in range(block_count) if block != target_block
    )
    for coefficients in all_matrices(dimension, 1, p):
        if not any(row[0] for row in coefficients):
            continue
        examined += 1
        blocks_flat = mat_mul(fd_transpose, coefficients, p)
        labels = tuple(
            tuple(blocks_flat[h * k + i] for i in range(k))
            for h in range(block_count)
        )
        cost = 0
        feasible = True
        for block in order:
            lookups += 1
            cost += (
                target_mu.get(labels[block])
                if block == target_block
                else inner_lambda.get(labels[block])
            )
            if cost > radius:
                feasible = False
                break
        if feasible:
            return RankOneTransferCertificate(
                radius,
                False,
                cost,
                "nonzero",
                flatten(coefficients),
                labels,
                examined,
                lookups,
            )
    return RankOneTransferCertificate(
        radius, True, None, None, None, (), examined, lookups
    )


def exact_confinement_cost(
    functional_dual_basis: Matrix,
    block_count: int,
    inner_lambda: CostTable,
    target_mu: CostTable,
    target_block: int,
    inner_dual_distance: int,
    inner_distance_support: tuple[int, ...] | None = None,
) -> ConfinementResult:
    """Compute Gamma by exhaustive outer-functional labels and table lookup."""

    if inner_distance_support is not None and (
        len(set(inner_distance_support)) != inner_dual_distance
        or any(index < 0 for index in inner_distance_support)
    ):
        raise ValueError("inner-distance support must have the claimed cardinality")

    p = inner_lambda.p
    k = inner_lambda.output_dim
    t = inner_lambda.demand_dim
    if target_mu.p != p or target_mu.output_dim != k or target_mu.demand_dim != t:
        raise ValueError("lambda and mu tables are incompatible")
    if not 0 <= target_block < block_count:
        raise ValueError("target block out of range")
    if any(len(row) != block_count * k for row in functional_dual_basis):
        raise ValueError("functional-dual basis has wrong width")
    zero = zero_matrix(k, t)
    best = target_mu.get(zero) + inner_dual_distance
    best_sector = "zero"
    best_coefficients: tuple[int, ...] | None = None
    best_labels: tuple[Matrix, ...] = ()
    transitions = 0
    dimension = len(functional_dual_basis)
    fd_transpose = transpose(functional_dual_basis)
    for coefficients in all_matrices(dimension, t, p):
        if not any(any(x != 0 for x in row) for row in coefficients):
            continue
        transitions += 1
        blocks_flat = mat_mul(fd_transpose, coefficients, p)
        cost = 0
        labels = []
        for h in range(block_count):
            block = tuple(blocks_flat[h * k + i] for i in range(k))
            labels.append(block)
            cost += target_mu.get(block) if h == target_block else inner_lambda.get(block)
            if cost >= best:
                break
        if cost < best:
            best = cost
            best_sector = "nonzero"
            best_coefficients = flatten(coefficients)
            best_labels = tuple(labels)
    if best_sector == "nonzero":
        best_witnesses = tuple(
            (target_mu if h == target_block else inner_lambda).witness_for(label)
            for h, label in enumerate(best_labels)
        )
        complete = all(witness is not None for witness in best_witnesses)
        return ConfinementResult(
            best,
            best_sector,
            best_coefficients,
            transitions,
            best_labels,
            best_witnesses,
            None,
            complete,
        )
    zero_witness = target_mu.witness_for(zero)
    return ConfinementResult(
        best,
        best_sector,
        None,
        transitions,
        tuple(zero for _ in range(block_count)),
        tuple(
            zero_witness if h == target_block else None
            for h in range(block_count)
        ),
        inner_distance_support,
        zero_witness is not None and inner_distance_support is not None,
    )


@dataclass(frozen=True)
class ContextWork:
    outer_vectors: int = 0
    distinct_subspaces: int = 0
    cache_hits: int = 0
    scalar_probes: int = 0
    generator_candidates: int = 0


@dataclass(frozen=True)
class ContextCost:
    cost: int
    sector: str
    work: ContextWork


@dataclass(frozen=True)
class ContextPlan:
    execution: str
    expected_queries: int
    amortization_queries: int
    estimated_cache_entries: int
    estimated_cache_bytes: int


@dataclass(frozen=True)
class PlannedContextCost:
    result: ContextCost
    plan: ContextPlan


def _projective_line_count(p: int, dimension: int) -> int:
    return (p**dimension - 1) // (p - 1)


def _rank_bounded_subspace_count(p: int, dimension: int, max_rank: int) -> int:
    total = 0
    for rank in range(1, max_rank + 1):
        numerator = prod(p ** (dimension - index) - 1 for index in range(rank))
        denominator = prod(p ** (rank - index) - 1 for index in range(rank))
        total += numerator // denominator
    return total


def _context_plan(
    strategy: str,
    expected_queries: int,
    memory_budget_bytes: int,
    amortization_queries: int,
    estimated_cache_entries: int,
    estimated_entry_bytes: int,
) -> ContextPlan:
    if strategy not in {"direct", "cached", "auto"}:
        raise ValueError("unknown contextual execution strategy")
    if expected_queries <= 0 or memory_budget_bytes < 0:
        raise ValueError("invalid contextual execution forecast")
    estimated_cache_bytes = estimated_cache_entries * estimated_entry_bytes
    execution = strategy
    if strategy == "auto":
        execution = (
            "cached"
            if expected_queries >= amortization_queries
            and memory_budget_bytes >= estimated_cache_bytes
            else "direct"
        )
    return ContextPlan(
        execution,
        expected_queries,
        amortization_queries,
        estimated_cache_entries,
        estimated_cache_bytes,
    )


def _validate_scalar_context(
    functional_dual_basis: Matrix, block_count: int, target_block: int, p: int
) -> Matrix:
    if any(len(row) != block_count for row in functional_dual_basis):
        raise ValueError("functional-dual basis has wrong width")
    basis = canonical_row_basis(functional_dual_basis, p)
    target_line = (tuple(int(block == target_block) for block in range(block_count)),)
    if subspace_contains(basis, target_line, p):
        raise ValueError("functional dual kills the target projection")
    return basis


class RankOneProbeCache:
    """Lazy zero-truncated projective line-probe profile over a prime field."""

    def __init__(
        self,
        inner_lambda: CostTable,
        target_mu: CostTable,
        block_count: int,
        target_block: int,
        inner_dual_distance: int,
    ) -> None:
        if (
            inner_lambda.output_dim != 1
            or inner_lambda.demand_dim != 1
            or target_mu.p != inner_lambda.p
            or target_mu.output_dim != 1
            or target_mu.demand_dim != 1
            or block_count < 2
            or not 0 <= target_block < block_count
        ):
            raise ValueError("incompatible rank-one probe input")
        self.inner = inner_lambda
        self.target = target_mu
        self.block_count = block_count
        self.target_block = target_block
        self.inner_dual_distance = inner_dual_distance
        self.zero_cost = target_mu.get(((0,),)) + inner_dual_distance
        self.probes: dict[tuple[int, ...], int] = {}

    def context_cost(self, functional_dual_basis: Matrix) -> ContextCost:
        return self.context_cost_planned(functional_dual_basis).result

    def _cached_context_cost_if_complete(self, basis: Matrix) -> ContextCost | None:
        if not self.probes:
            return None
        p = self.inner.p
        seen: set[tuple[int, ...]] = set()
        best = self.zero_cost
        outer_vectors = distinct = hits = 0
        for coefficients in product(range(p), repeat=len(basis)):
            if not any(coefficients):
                continue
            outer_vectors += 1
            vector = tuple(
                sum(coefficients[row] * basis[row][col] for row in range(len(basis)))
                % p
                for col in range(self.block_count)
            )
            pivot = next(value for value in vector if value)
            inverse = pow(pivot, -1, p)
            line = tuple(inverse * value % p for value in vector)
            if line in seen:
                continue
            seen.add(line)
            distinct += 1
            if line not in self.probes:
                return None
            hits += 1
            best = min(best, self.probes[line])
        return ContextCost(
            best,
            "nonzero" if best < self.zero_cost else "zero",
            ContextWork(outer_vectors, distinct, hits, 0, 0),
        )

    def context_cost_cached(self, functional_dual_basis: Matrix) -> ContextCost:
        p = self.inner.p
        basis = _validate_scalar_context(
            functional_dual_basis, self.block_count, self.target_block, p
        )
        seen: set[tuple[int, ...]] = set()
        best = self.zero_cost
        outer_vectors = distinct = hits = scalar_probes = 0
        for coefficients in product(range(p), repeat=len(basis)):
            if not any(coefficients):
                continue
            outer_vectors += 1
            vector = tuple(
                sum(coefficients[row] * basis[row][col] for row in range(len(basis)))
                % p
                for col in range(self.block_count)
            )
            pivot = next(value for value in vector if value)
            inverse = pow(pivot, -1, p)
            line = tuple(inverse * value % p for value in vector)
            if line in seen:
                continue
            seen.add(line)
            distinct += 1
            if line in self.probes:
                hits += 1
                probe = self.probes[line]
            else:
                probe = self.zero_cost
                for scalar in range(1, p):
                    scalar_probes += 1
                    cost = 0
                    for block, value in enumerate(line):
                        label = ((scalar * value % p,),)
                        cost += (
                            self.target.get(label)
                            if block == self.target_block
                            else self.inner.get(label)
                        )
                        if cost >= probe:
                            break
                    probe = min(probe, cost)
                self.probes[line] = probe
            best = min(best, probe)
        return ContextCost(
            best,
            "nonzero" if best < self.zero_cost else "zero",
            ContextWork(outer_vectors, distinct, hits, scalar_probes, 0),
        )

    def context_cost_planned(
        self,
        functional_dual_basis: Matrix,
        strategy: str = "auto",
        expected_queries: int = 1,
        memory_budget_bytes: int = 2**63 - 1,
    ) -> PlannedContextCost:
        basis = _validate_scalar_context(
            functional_dual_basis, self.block_count, self.target_block, self.inner.p
        )
        if strategy == "auto":
            if expected_queries <= 0:
                raise ValueError("expected query count must be positive")
            cached = self._cached_context_cost_if_complete(basis)
            if cached is not None:
                entries = len(self.probes)
                return PlannedContextCost(
                    cached,
                    ContextPlan(
                        "cached", expected_queries, 1, entries,
                        entries * (self.block_count + 32),
                    ),
                )
        plan = _context_plan(
            strategy,
            expected_queries,
            memory_budget_bytes,
            1,
            len(self.probes) + _projective_line_count(self.inner.p, len(basis)),
            self.block_count + 32,
        )
        result = (
            self.context_cost_cached(basis)
            if plan.execution == "cached"
            else _direct_context_cost(
                basis,
                self.block_count,
                self.inner,
                self.target,
                self.target_block,
                self.inner_dual_distance,
            )
        )
        return PlannedContextCost(result, plan)


class RankBoundedContextCache:
    """Exact rank-bounded outer-context cache; maps remain fully labelled."""

    def __init__(
        self,
        inner_lambda: CostTable,
        target_mu: CostTable,
        block_count: int,
        target_block: int,
        inner_dual_distance: int,
    ) -> None:
        if (
            inner_lambda.output_dim != 1
            or inner_lambda.demand_dim == 0
            or target_mu.p != inner_lambda.p
            or target_mu.output_dim != 1
            or target_mu.demand_dim != inner_lambda.demand_dim
        ):
            raise ValueError("incompatible rank-bounded context input")
        self.inner = inner_lambda
        self.target = target_mu
        self.block_count = block_count
        self.target_block = target_block
        self.inner_dual_distance = inner_dual_distance
        self.target_rank = inner_lambda.demand_dim
        self.zero_cost = target_mu.get(zero_matrix(1, self.target_rank)) + inner_dual_distance
        self.costs: dict[Matrix, int] = {}

    def context_cost(self, functional_dual_basis: Matrix) -> ContextCost:
        return self.context_cost_planned(functional_dual_basis).result

    def _subspaces(self, basis: Matrix) -> set[Matrix]:
        p = self.inner.p
        subspaces: set[Matrix] = set()
        for rank in range(1, min(self.target_rank, len(basis)) + 1):
            for candidate in all_matrices(rank, len(basis), p):
                canonical = canonical_row_basis(candidate, p)
                if len(canonical) == rank:
                    subspaces.add(canonical)
        return subspaces

    def _cached_context_cost_if_complete(self, basis: Matrix) -> ContextCost | None:
        if not self.costs:
            return None
        best = self.zero_cost
        subspaces = self._subspaces(basis)
        for coefficient_basis in sorted(subspaces):
            ambient_basis = canonical_row_basis(
                mat_mul(coefficient_basis, basis, self.inner.p), self.inner.p
            )
            if ambient_basis not in self.costs:
                return None
            best = min(best, self.costs[ambient_basis])
        return ContextCost(
            best,
            "nonzero" if best < self.zero_cost else "zero",
            ContextWork(0, len(subspaces), len(subspaces), 0, 0),
        )

    def context_cost_cached(self, functional_dual_basis: Matrix) -> ContextCost:
        p = self.inner.p
        basis = _validate_scalar_context(
            functional_dual_basis, self.block_count, self.target_block, p
        )
        subspaces = self._subspaces(basis)
        best = self.zero_cost
        hits = transitions = 0
        for coefficient_basis in sorted(subspaces):
            ambient_basis = canonical_row_basis(mat_mul(coefficient_basis, basis, p), p)
            if ambient_basis in self.costs:
                hits += 1
                cost = self.costs[ambient_basis]
            else:
                cost = self.zero_cost
                rank = len(ambient_basis)
                for coefficients in all_matrices(rank, self.target_rank, p):
                    if len(canonical_row_basis(coefficients, p)) != rank:
                        continue
                    transitions += 1
                    candidate = 0
                    for block in range(self.block_count):
                        label = (
                            tuple(
                                sum(
                                    ambient_basis[row][block] * coefficients[row][col]
                                    for row in range(rank)
                                )
                                % p
                                for col in range(self.target_rank)
                            ),
                        )
                        candidate += (
                            self.target.get(label)
                            if block == self.target_block
                            else self.inner.get(label)
                        )
                        if candidate >= cost:
                            break
                    cost = min(cost, candidate)
                self.costs[ambient_basis] = cost
            best = min(best, cost)
        return ContextCost(
            best,
            "nonzero" if best < self.zero_cost else "zero",
            ContextWork(0, len(subspaces), hits, 0, transitions),
        )

    def context_cost_planned(
        self,
        functional_dual_basis: Matrix,
        strategy: str = "auto",
        expected_queries: int = 1,
        memory_budget_bytes: int = 2**63 - 1,
    ) -> PlannedContextCost:
        basis = _validate_scalar_context(
            functional_dual_basis, self.block_count, self.target_block, self.inner.p
        )
        if strategy == "auto":
            if expected_queries <= 0:
                raise ValueError("expected query count must be positive")
            cached = self._cached_context_cost_if_complete(basis)
            if cached is not None:
                entries = len(self.costs)
                return PlannedContextCost(
                    cached,
                    ContextPlan(
                        "cached", expected_queries, 2, entries,
                        entries * (self.target_rank * self.block_count + 32),
                    ),
                )
        plan = _context_plan(
            strategy,
            expected_queries,
            memory_budget_bytes,
            2,
            len(self.costs)
            + _rank_bounded_subspace_count(
                self.inner.p,
                len(basis),
                min(self.target_rank, len(basis)),
            ),
            self.target_rank * self.block_count + 32,
        )
        result = (
            self.context_cost_cached(basis)
            if plan.execution == "cached"
            else _direct_context_cost(
                basis,
                self.block_count,
                self.inner,
                self.target,
                self.target_block,
                self.inner_dual_distance,
            )
        )
        return PlannedContextCost(result, plan)


def _direct_context_cost(
    functional_dual_basis: Matrix,
    block_count: int,
    inner: CostTable,
    target: CostTable,
    target_block: int,
    inner_dual_distance: int,
) -> ContextCost:
    result = exact_confinement_cost(
        functional_dual_basis,
        block_count,
        inner,
        target,
        target_block,
        inner_dual_distance,
    )
    return ContextCost(
        result.cost,
        result.sector,
        ContextWork(generator_candidates=result.transitions),
    )


def exact_confinement_cost_syndrome_dp(
    constraint_blocks: Sequence[Matrix],
    inner_lambda: CostTable,
    target_mu: CostTable,
    target_block: int,
    inner_dual_distance: int,
    inner_distance_support: tuple[int, ...] | None = None,
) -> ConfinementResult:
    """Weighted syndrome-trellis evaluation of Gamma.

    The supplied block matrices C_h define the functional dual as
    {B : sum_h C_h B_h = 0}.  A Boolean state excludes the all-zero tuple from
    the nonzero functional sector.
    """

    if inner_distance_support is not None and (
        len(set(inner_distance_support)) != inner_dual_distance
        or any(index < 0 for index in inner_distance_support)
    ):
        raise ValueError("inner-distance support must have the claimed cardinality")

    if not constraint_blocks:
        raise ValueError("syndrome DP needs at least one constraint block")
    p = inner_lambda.p
    k = inner_lambda.output_dim
    t = inner_lambda.demand_dim
    syndrome_dim, block_width = shape(constraint_blocks[0])
    if block_width != k or any(shape(block) != (syndrome_dim, k) for block in constraint_blocks):
        raise ValueError("constraint block shape mismatch")
    if target_mu.p != p or target_mu.output_dim != k or target_mu.demand_dim != t:
        raise ValueError("lambda and mu tables are incompatible")
    if not 0 <= target_block < len(constraint_blocks):
        raise ValueError("target block out of range")
    canonical_constraints = canonical_row_basis(
        concatenate_columns(constraint_blocks), p
    )
    if canonical_constraints:
        syndrome_dim = len(canonical_constraints)
        constraint_blocks = tuple(
            column_block(canonical_constraints, h * k, k)
            for h in range(len(constraint_blocks))
        )
    else:
        syndrome_dim = 1
        constraint_blocks = tuple(
            (tuple(0 for _ in range(k)),) for _ in constraint_blocks
        )
    zero_label = (0,) * (k * t)
    zero_syndrome = (0,) * (syndrome_dim * t)
    states: dict[tuple[tuple[int, ...], bool], int] = {(zero_syndrome, False): 0}
    paths: dict[
        tuple[tuple[int, ...], bool], tuple[Matrix, ...]
    ] = {(zero_syndrome, False): ()}
    transitions = 0
    for h, constraint in enumerate(constraint_blocks):
        local = target_mu if h == target_block else inner_lambda
        choices = tuple(
            (
                mat_mul(constraint, local.matrix_for(key), p),
                key != zero_label,
                cost,
                local.matrix_for(key),
            )
            for key, cost in local.costs.items()
        )
        new: dict[tuple[tuple[int, ...], bool], int] = {}
        new_paths: dict[tuple[tuple[int, ...], bool], tuple[Matrix, ...]] = {}
        for (syndrome_key, already_nonzero), old_cost in states.items():
            syndrome = unflatten(syndrome_key, syndrome_dim, t, p)
            for syndrome_increment, label_nonzero, local_cost, label in choices:
                transitions += 1
                next_syndrome = flatten(
                    mat_add(syndrome, syndrome_increment, p)
                )
                state = (next_syndrome, already_nonzero or label_nonzero)
                candidate = old_cost + local_cost
                candidate_path = paths[(syndrome_key, already_nonzero)] + (label,)
                if candidate < new.get(state, INF) or (
                    candidate == new.get(state, INF)
                    and repr(candidate_path) < repr(new_paths[state])
                ):
                    new[state] = candidate
                    new_paths[state] = candidate_path
        states = new
        paths = new_paths
    nonzero_cost = states.get((zero_syndrome, True), INF)
    zero_cost = target_mu.get(zero_matrix(k, t)) + inner_dual_distance
    if nonzero_cost < zero_cost:
        labels = paths[(zero_syndrome, True)]
        witnesses = tuple(
            (target_mu if h == target_block else inner_lambda).witness_for(label)
            for h, label in enumerate(labels)
        )
        return ConfinementResult(
            nonzero_cost,
            "nonzero",
            None,
            transitions,
            labels,
            witnesses,
            None,
            all(witness is not None for witness in witnesses),
        )
    zero = zero_matrix(k, t)
    zero_witness = target_mu.witness_for(zero)
    return ConfinementResult(
        zero_cost,
        "zero",
        None,
        transitions,
        tuple(zero for _ in constraint_blocks),
        tuple(
            zero_witness if h == target_block else None
            for h in range(len(constraint_blocks))
        ),
        inner_distance_support,
        zero_witness is not None and inner_distance_support is not None,
    )


def exact_confinement_cost_auto(
    functional_dual_basis: Matrix,
    block_count: int,
    inner_lambda: CostTable,
    target_mu: CostTable,
    target_block: int,
    inner_dual_distance: int,
    inner_distance_support: tuple[int, ...] | None = None,
) -> ConfinementPlan:
    """Choose generator enumeration or a syndrome trellis by state-size bounds."""

    p = inner_lambda.p
    k = inner_lambda.output_dim
    t = inner_lambda.demand_dim
    dimension = len(functional_dual_basis)
    generator_bound = p ** (dimension * t) - 1
    constraints = nullspace_basis(functional_dual_basis, p) if functional_dual_basis else ()
    if not constraints:
        result = exact_confinement_cost(
            functional_dual_basis,
            block_count,
            inner_lambda,
            target_mu,
            target_block,
            inner_dual_distance,
            inner_distance_support,
        )
        return ConfinementPlan("generator", generator_bound, None, result)
    syndrome_dim = len(constraints)
    max_states = 2 * p ** (syndrome_dim * t)
    syndrome_bound = max_states * (
        len(target_mu.costs) + (block_count - 1) * len(inner_lambda.costs)
    )
    if syndrome_bound < generator_bound:
        blocks = tuple(
            column_block(constraints, h * k, k) for h in range(block_count)
        )
        result = exact_confinement_cost_syndrome_dp(
            blocks,
            inner_lambda,
            target_mu,
            target_block,
            inner_dual_distance,
            inner_distance_support,
        )
        return ConfinementPlan("syndrome", generator_bound, syndrome_bound, result)
    result = exact_confinement_cost(
        functional_dual_basis,
        block_count,
        inner_lambda,
        target_mu,
        target_block,
        inner_dual_distance,
        inner_distance_support,
    )
    return ConfinementPlan("generator", generator_bound, syndrome_bound, result)
