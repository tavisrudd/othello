#!/usr/bin/env sage
"""Direct split-Borel pullback test for the q=121 C665 gate.

For the torus-normalized affine cocycle c_g and the unique embedding
i:L(6)->F, the pullback of

    Sym^2(F) -> partial^{-1}(i(L(6))) -> L(6)

is represented on a Borel generator g by

    s |-> c_g * i(g s) in Sym^2(F).

This checker asks directly whether that cocycle is a coboundary.  A
cobounding map is forced to respect split-torus characters, so it suffices
to solve the two exact inhomogeneous systems for u(1) and u(a).
"""

import argparse
import importlib.machinery
import importlib.util
import json
from math import comb
from pathlib import Path

from sage.all import identity_matrix, matrix, vector


HERE = Path(__file__).resolve().parent
SUPPORT_PATH = HERE / "2026-07-28-c665-q121-pullback-support.sage"
CONNECTING_PATH = HERE / "2026-07-29-c665-q121-connecting-functional.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-direct-borel.json"


def load_module(name, path):
    loader = importlib.machinery.SourceFileLoader(name, str(path))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


pullback = load_module("c665_q121_direct_pullback", SUPPORT_PATH)
connecting = load_module("c665_q121_direct_connecting", CONNECTING_PATH)
base = pullback.base
FIELD = pullback.FIELD
A = pullback.A
N = len(base.EXPONENTS)
SIMPLE_DIMENSION = base.SIMPLE_DEGREE + 1
PARAMETERS = (FIELD.one(), A)


def pair_index(left, right):
    if left > right:
        left, right = right, left
    return left * N - left * (left - 1) // 2 + right - left


def pair_from_index(index):
    left = 0
    width = N
    while index >= width:
        index -= width
        left += 1
        width -= 1
    return left, left + index


def same_character(left, right):
    return (left - right) % base.TORUS_MODULUS == 0


def source_data():
    group_elements = (
        (1, 1, 0, 1),
        (1, A, 0, 1),
    )
    generator_data = [pullback.action_data(g) for g in group_elements]
    primitive = FIELD.multiplicative_generator()
    torus_data = pullback.action_data(
        (primitive, 0, 0, primitive**-1)
    )
    _, correction, cocycles = pullback.split_torus_fixed_lift(
        generator_data, torus_data
    )
    embedding_record, embedding, simple_actions = (
        pullback.embedding_polynomials()
    )
    embedded_images = []
    for action in simple_actions[:2]:
        columns = []
        for simple_column in range(SIMPLE_DIMENSION):
            columns.append(
                sum(
                    (
                        action[source_simple, simple_column]
                        * embedding[source_simple]
                        for source_simple in range(SIMPLE_DIMENSION)
                        if action[source_simple, simple_column]
                    ),
                    pullback.R.zero(),
                )
            )
        embedded_images.append(columns)
    return {
        "generator_data": generator_data,
        "torus_correction": correction,
        "cocycles": cocycles,
        "embedding_record": embedding_record,
        "embedding": embedding,
        "simple_actions": simple_actions[:2],
        "embedded_images": embedded_images,
    }


def translation_columns(parameter):
    return tuple(
        base.translation_column(exponent, parameter)
        for exponent in base.EXPONENTS
    )


def hermite_raw_column_sizes(parameter):
    """Raw term counts in F=Sym^2(Sym^59(V)) before collisions."""
    w_action = base.binary_translation(parameter, base.DEGREE)
    w_sizes = tuple(len(w_action.column(index).dict()) for index in range(60))
    return tuple(
        w_sizes[left] * w_sizes[right]
        for left in range(60)
        for right in range(left, 60)
    )


def binary_pair_index(left, right):
    dimension = base.DEGREE + 1
    if left > right:
        left, right = right, left
    return (
        left * dimension
        - left * (left - 1) // 2
        + right
        - left
    )


def hermite_map_matrix():
    """Canonical factorization map Sym^59(Sym^2 V)->Sym^2(Sym^59 V)."""
    entries = {}
    half = FIELD(2) ** -1
    for source, (i, j, _k) in enumerate(base.EXPONENTS):
        for chosen_ad in range(j + 1):
            left = i + chosen_ad
            right = i + j - chosen_ad
            target = binary_pair_index(left, right)
            value = FIELD(comb(j, chosen_ad)) * half**j
            entries[(target, source)] = (
                entries.get((target, source), FIELD.zero()) + value
            )
    return matrix(FIELD, N, N, entries, sparse=True)


def hermite_check():
    hermite = hermite_map_matrix()
    standard_w = connecting.MatrixModule(
        "Sym^59(V)",
        tuple(
            [base.binary_translation(parameter, base.DEGREE)
             for parameter in PARAMETERS]
            + [base.binary_inversion(base.DEGREE)]
        ),
        tuple(base.DEGREE - 2 * index for index in range(60)),
        tuple(FIELD.one() for _ in range(60)),
    )
    hermite_f = connecting.domain.SymmetricSquareModule(standard_w)
    hermite_actions = tuple(
        matrix(
            FIELD,
            N,
            N,
            {
                (target, source): coefficient
                for source in range(N)
                for target, coefficient in hermite_f.action_column(
                    generator, source
                )
            },
            sparse=True,
        )
        for generator in range(3)
    )
    ternary_columns = [
        tuple(
            base.translation_column(exponent, parameter)
            for exponent in base.EXPONENTS
        )
        for parameter in PARAMETERS
    ]
    ternary_columns.append(
        tuple(
            base.inversion_column(exponent)
            for exponent in base.EXPONENTS
        )
    )
    ternary_actions = tuple(
        matrix(
            FIELD,
            N,
            N,
            {
                (target, source): coefficient
                for source, column in enumerate(columns)
                for target, coefficient in column.items()
            },
            sparse=True,
        )
        for columns in ternary_columns
    )
    intertwining = [
        hermite * action == target_action * hermite
        for action, target_action in zip(
            ternary_actions, hermite_actions
        )
    ]
    return {
        "schema": 1,
        "mode": "Hermite map check",
        "q": base.Q,
        "map_rank": hermite.rank(),
        "map_nonzero_entries": len(hermite.dict()),
        "intertwining": intertwining,
    }


def profile():
    data = source_data()
    columns = [translation_columns(parameter) for parameter in PARAMETERS]
    allowed_characters = set(base.SIMPLE_WEIGHTS)
    pair_count = N * (N + 1) // 2
    compatible_pairs = 0
    variables = 0
    action_terms = [0, 0]
    maximum_column_terms = [0, 0]
    hermite_f_sizes = [
        hermite_raw_column_sizes(parameter) for parameter in PARAMETERS
    ]
    hermite_action_terms = [0, 0]
    hermite_maximum_terms = [0, 0]
    for left in range(N):
        for right in range(left, N):
            weight = base.F_WEIGHTS[left] + base.F_WEIGHTS[right]
            multiplicity = sum(
                same_character(weight, simple_weight)
                for simple_weight in base.SIMPLE_WEIGHTS
            )
            if not multiplicity:
                continue
            compatible_pairs += 1
            variables += multiplicity
            for generator in range(2):
                terms = (
                    len(columns[generator][left])
                    * len(columns[generator][right])
                )
                action_terms[generator] += multiplicity * terms
                maximum_column_terms[generator] = max(
                    maximum_column_terms[generator], terms
                )
                hermite_terms = (
                    hermite_f_sizes[generator][left]
                    * hermite_f_sizes[generator][right]
                )
                hermite_action_terms[generator] += (
                    multiplicity * hermite_terms
                )
                hermite_maximum_terms[generator] = max(
                    hermite_maximum_terms[generator], hermite_terms
                )
    return {
        "schema": 1,
        "mode": "profile",
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "F_dimension": N,
        "symmetric_square_dimension": pair_count,
        "torus_compatible_pairs": compatible_pairs,
        "torus_block_variables": variables,
        "raw_action_terms": action_terms,
        "maximum_raw_action_column_terms": maximum_column_terms,
        "hermite_raw_action_terms": hermite_action_terms,
        "hermite_maximum_raw_action_column_terms": hermite_maximum_terms,
        "affine_cocycle_supports": [
            len(cocycle.dict()) for cocycle in data["cocycles"]
        ],
        "embedding_column_supports": [
            len(column.dict()) for column in data["embedding"]
        ],
        "embedded_image_supports": [
            [len(column.dict()) for column in columns]
            for columns in data["embedded_images"]
        ],
    }


def standard_t_plus_cocycle(t_plus):
    """Canonical normalized pair spanning Z^1(B,T_plus)."""
    h1 = connecting.h1
    u1, ua = t_plus.actions[:2]
    dimension = t_plus.dimension
    primitive = FIELD.multiplicative_generator()
    sample_actions, _ = h1.base.digit_simple_actions(
        (FIELD.one(),), (1,)
    )
    sample_weights = h1.base.digit_simple_actions((), (1,))[1]
    sample_torus = matrix(
        FIELD,
        2,
        2,
        {
            (index, index): primitive**weight
            for index, weight in enumerate(sample_weights)
        },
    )
    multiplier = next(
        value
        for value in (primitive**2, primitive**-2)
        if sample_torus * sample_actions[0] * sample_torus**-1
        == h1.base.digit_simple_actions((value,), (1,))[0][0]
    )
    torus = matrix(
        FIELD,
        dimension,
        dimension,
        {
            (index, index): primitive**weight
            for index, weight in enumerate(t_plus.weights)
        },
    )
    zero = matrix(FIELD, dimension, dimension)
    one = identity_matrix(FIELD, dimension)
    norm1 = h1.power_sum(u1, base.P)
    norma = h1.power_sum(ua, base.P)
    one_left, one_right = h1.additive_cocycle_coefficients(
        multiplier, u1, ua
    )
    a_left, a_right = h1.additive_cocycle_coefficients(
        multiplier * A, u1, ua
    )
    relations = h1.block_matrix(
        FIELD,
        [
            [norm1, zero],
            [zero, norma],
            [one - ua, u1 - one],
            [torus - one_left, -one_right],
            [-a_left, torus - a_right],
        ],
        subdivide=False,
    )
    basis = relations.right_kernel().basis()
    assert len(basis) == 1
    standard = basis[0]
    return (
        vector(FIELD, standard[:dimension]),
        vector(FIELD, standard[dimension:]),
    )


def full_c0_c2_values(source, y_map, d2_simple):
    values = []
    for generator in range(2):
        operator = source.actions[generator].tensor_product(
            d2_simple[generator]
        )
        values.append(
            operator * y_map * source.actions[generator] ** -1
        )
    return tuple(values)


def full_m_cross_values(source, y_map, t_plus, d1_simple):
    values = []
    for generator in range(2):
        operator = d1_simple[generator].tensor_product(
            t_plus.actions[generator]
        )
        values.append(
            operator * y_map * source.actions[generator] ** -1
        )
    return tuple(values)


def flatten_values(values):
    return vector(
        FIELD,
        [
            value
            for cochain in values
            for column in range(cochain.ncols())
            for row in range(cochain.nrows())
            for value in (cochain[row, column],)
        ],
    )


def sparse_flatten(values):
    if not values:
        return {}
    target_dimension = values[0].nrows()
    source_dimension = values[0].ncols()
    answer = {}
    block = target_dimension * source_dimension
    for generator, value in enumerate(values):
        for (row, column), coefficient in value.dict().items():
            answer[
                generator * block + int(column) * target_dimension + int(row)
            ] = coefficient
    return answer


def add_sparse(target, source, scale=1):
    for index, value in source.items():
        new_value = target.get(index, FIELD.zero()) + scale * value
        if new_value:
            target[index] = new_value
        elif index in target:
            del target[index]


class SparseSpan:
    """Canonical sparse column span in an ambient coordinate space."""

    def __init__(self):
        self.basis = {}

    def reduce(self, column):
        answer = dict(column)
        for pivot in sorted(self.basis):
            coefficient = answer.get(pivot, FIELD.zero())
            if coefficient:
                add_sparse(answer, self.basis[pivot], -coefficient)
        return answer

    def add(self, column):
        reduced = self.reduce(column)
        if not reduced:
            return False
        pivot = min(reduced)
        scale = reduced[pivot] ** -1
        reduced = {
            index: scale * value for index, value in reduced.items()
        }
        for old_pivot, old_basis in list(self.basis.items()):
            coefficient = old_basis.get(pivot, FIELD.zero())
            if coefficient:
                add_sparse(old_basis, reduced, -coefficient)
        self.basis[pivot] = reduced
        return True


def tensor_action_column(left, right, source):
    right_dimension = right.dimension
    left_source, right_source = divmod(source, right_dimension)
    return tuple(
        (
            int(left_target) * right_dimension + int(right_target),
            left_value * right_value,
        )
        for left_target, left_value in left.actions[
            tensor_action_column.generator
        ].column(left_source).dict().items()
        for right_target, right_value in right.actions[
            tensor_action_column.generator
        ].column(right_source).dict().items()
    )


tensor_action_column.generator = 0


def component_coboundaries(source, left, right):
    """Sparse columns for all torus-fixed cochains S->left tensor right."""
    target_dimension = left.dimension * right.dimension
    block = target_dimension * source.dimension
    columns = []
    for left_row, left_weight in enumerate(left.weights):
        for right_row, right_weight in enumerate(right.weights):
            target_row = left_row * right.dimension + right_row
            for source_row, source_weight in enumerate(source.weights):
                if not same_character(
                    left_weight + right_weight, source_weight
                ):
                    continue
                column = {}
                for generator in range(2):
                    tensor_action_column.generator = generator
                    inverse = source.actions[generator] ** -1
                    for target, target_coefficient in tensor_action_column(
                        left, right, target_row
                    ):
                        for input_column, source_coefficient in inverse.row(
                            source_row
                        ).dict().items():
                            coordinate = (
                                generator * block
                                + int(input_column) * target_dimension
                                + target
                            )
                            column[coordinate] = (
                                column.get(coordinate, FIELD.zero())
                                + target_coefficient * source_coefficient
                            )
                    coordinate = (
                        generator * block
                        + source_row * target_dimension
                        + target_row
                    )
                    column[coordinate] = (
                        column.get(coordinate, FIELD.zero()) - 1
                    )
                    if not column[coordinate]:
                        del column[coordinate]
                columns.append(column)
    return columns


def swapped_tensor_operator(left_action, right_lower):
    """Map R tensor T -> Y tensor R via lower(T)->Y and action(R)."""
    r_dimension = left_action.ncols()
    t_dimension = right_lower.ncols()
    y_dimension = right_lower.nrows()
    entries = {}
    for r_source in range(r_dimension):
        for t_source in range(t_dimension):
            source = r_source * t_dimension + t_source
            for r_target, r_value in left_action.column(
                r_source
            ).dict().items():
                for y_target, y_value in right_lower.column(
                    t_source
                ).dict().items():
                    target = int(y_target) * r_dimension + int(r_target)
                    entries[(target, source)] = (
                        entries.get((target, source), FIELD.zero())
                        + r_value * y_value
                    )
    return matrix(
        FIELD,
        y_dimension * r_dimension,
        r_dimension * t_dimension,
        entries,
        sparse=True,
    )


def degree_one_test():
    """Use all 60 degree-two rows against every degree-one factor."""
    (
        b_module,
        a_module,
        extension_blocks,
        architecture,
    ) = connecting.adapted_dual_weyl()
    c0 = connecting.CachedModule(
        connecting.domain.SymmetricSquareModule(b_module)
    )
    middle = connecting.CachedModule(
        connecting.domain.TensorModule(b_module, a_module)
    )
    c2 = connecting.CachedModule(
        connecting.domain.SymmetricSquareModule(a_module)
    )
    d1, d2 = connecting.adjacent_cochains(
        b_module,
        a_module,
        extension_blocks,
        c0.module,
        middle.module,
        c2.module,
    )
    source = connecting.domain.SimpleModule((6,))
    t_plus = connecting.domain.SimpleModule((9, 1))
    factor_cache = {}

    def factor_maps(layer, digits):
        key = (id(layer), tuple(digits))
        if key not in factor_cache:
            simple = connecting.domain.SimpleModule(tuple(digits))
            factor_cache[key] = (
                simple,
                *connecting.normalized_factor_maps(layer, simple),
            )
        return factor_cache[key]

    c0_digits = tuple(connecting.domain.C0_FACTORS)
    middle_digits = tuple(connecting.domain.M_FACTORS)
    c2_digits = tuple(connecting.domain.C2_FACTORS)
    for digits in c0_digits:
        factor_maps(c0, digits)
    for digits in middle_digits:
        factor_maps(middle, digits)
    for digits in c2_digits:
        factor_maps(c2, digits)

    d1_blocks = {}
    for r_digits in middle_digits:
        _, _, i_r, _ = factor_maps(middle, r_digits)
        for y_digits in c0_digits:
            _, _, _, p_y = factor_maps(c0, y_digits)
            values = tuple(p_y * value * i_r for value in d1[:2])
            if any(values):
                d1_blocks[(r_digits, y_digits)] = values
    d2_blocks = {}
    for z_digits in c2_digits:
        _, _, i_z, _ = factor_maps(c2, z_digits)
        for t_digits in middle_digits:
            _, _, _, p_t = factor_maps(middle, t_digits)
            values = tuple(p_t * value * i_z for value in d2[:2])
            if any(values):
                d2_blocks[(z_digits, t_digits)] = values

    domain_certificate = json.loads(
        connecting.domain.CERTIFICATE.read_text()
    )
    records = domain_certificate["nonzero_summands"]
    assert len(records) == 60
    component_rows = {}

    def add_component(row_index, key, values):
        row = component_rows.setdefault(key, {}).setdefault(row_index, {})
        add_sparse(row, sparse_flatten(values))

    for row_index, record in enumerate(records):
        left_digits, right_digits = map(tuple, record["factors"])
        left_simple = connecting.domain.SimpleModule(left_digits)
        right_simple = connecting.domain.SimpleModule(right_digits)
        target = connecting.domain.TensorModule(
            left_simple, right_simple
        )
        hom_record, homs = connecting.hom_basis(source, target)
        assert hom_record["dimension"] == 1
        y_map = homs[0]
        source_inverses = tuple(
            action**-1 for action in source.actions[:2]
        )
        if record["kind"] == "C0_tensor_C2":
            for t_digits in middle_digits:
                block_values = d2_blocks.get(
                    (right_digits, t_digits)
                )
                if block_values is None:
                    continue
                left_action = left_simple.actions
                values = tuple(
                    left_action[generator].tensor_product(
                        block_values[generator]
                    )
                    * y_map
                    * source_inverses[generator]
                    for generator in range(2)
                )
                add_component(
                    row_index, (left_digits, t_digits), values
                )
        else:
            for y_digits in c0_digits:
                left_blocks = d1_blocks.get(
                    (left_digits, y_digits)
                )
                if left_blocks is not None:
                    values = tuple(
                        left_blocks[generator].tensor_product(
                            right_simple.actions[generator]
                        )
                        * y_map
                        * source_inverses[generator]
                        for generator in range(2)
                    )
                    add_component(
                        row_index, (y_digits, right_digits), values
                    )
                right_blocks = d1_blocks.get(
                    (right_digits, y_digits)
                )
                if right_blocks is not None:
                    values = tuple(
                        swapped_tensor_operator(
                            left_simple.actions[generator],
                            right_blocks[generator],
                        )
                        * y_map
                        * source_inverses[generator]
                        for generator in range(2)
                    )
                    add_component(
                        row_index, (y_digits, left_digits), values
                    )

    pullback_key = ((6, 0), (9, 1))
    t_cocycle = standard_t_plus_cocycle(t_plus)
    pullback_values = []
    for value in t_cocycle:
        cochain = matrix(
            FIELD, source.dimension * t_plus.dimension, source.dimension
        )
        for source_index in range(source.dimension):
            for t_index, coefficient in value.dict().items():
                cochain[
                    source_index * t_plus.dimension + int(t_index),
                    source_index,
                ] = coefficient
        pullback_values.append(cochain)
    pullback_sparse = sparse_flatten(pullback_values)

    coefficient_stream = connecting.domain.StreamingRank(60)
    augmented_stream = connecting.domain.StreamingRank(61)
    quotient_equations = 0
    component_summaries = []
    witness_row = 34

    def component_order(key):
        left = factor_maps(c0, key[0])[0]
        right = factor_maps(middle, key[1])[0]
        if key == pullback_key:
            priority = 0
        elif witness_row in component_rows.get(key, {}):
            priority = 1
        else:
            priority = 2
        return (priority, left.dimension * right.dimension, key)

    component_keys = sorted(
        set(component_rows) | {pullback_key},
        key=component_order,
    )
    for key in component_keys:
        left = factor_maps(c0, key[0])[0]
        right = factor_maps(middle, key[1])[0]
        span = SparseSpan()
        coboundaries = component_coboundaries(source, left, right)
        for column in coboundaries:
            span.add(column)
        reduced_rows = {}
        for row_index, column in component_rows.get(key, {}).items():
            reduced = span.reduce(column)
            if reduced:
                reduced_rows[row_index] = reduced
        reduced_pullback = (
            span.reduce(pullback_sparse) if key == pullback_key else {}
        )
        coordinates = sorted(
            set().union(
                *(column.keys() for column in reduced_rows.values()),
                reduced_pullback.keys(),
            )
            if reduced_rows or reduced_pullback
            else ()
        )
        for coordinate in coordinates:
            equation = {}
            for row_index, column in reduced_rows.items():
                value = column.get(coordinate, FIELD.zero())
                if value:
                    equation[row_index] = value
            rhs = reduced_pullback.get(coordinate, FIELD.zero())
            if equation or rhs:
                coefficient_stream.add(dict(equation))
                augmented = dict(equation)
                if rhs:
                    augmented[60] = rhs
                augmented_stream.add(augmented)
                quotient_equations += 1
        component_summaries.append(
            {
                "factors": [list(key[0]), list(key[1])],
                "target_dimension": left.dimension * right.dimension,
                "torus_fixed_cochains": len(coboundaries),
                "filtered_rows": len(
                    component_rows.get(key, {})
                ),
                "filtered_row_indices": sorted(
                    component_rows.get(key, {})
                ),
                "quotient_support_coordinates": len(coordinates),
                "pullback_quotient_support": len(reduced_pullback),
                "cumulative_coefficient_rank": coefficient_stream.rank,
                "cumulative_augmented_rank": augmented_stream.rank,
            }
        )
        if augmented_stream.rank > coefficient_stream.rank:
            break
    coefficient_rank = coefficient_stream.rank
    augmented_rank = augmented_stream.rank
    return {
        "schema": 1,
        "mode": "all degree-one factors",
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "architecture": architecture,
        "degree_two_rows": len(records),
        "nonzero_d1_factor_blocks": len(d1_blocks),
        "nonzero_d2_factor_blocks": len(d2_blocks),
        "available_degree_one_components": len(component_keys),
        "processed_degree_one_components": len(component_summaries),
        "quotient_equations": quotient_equations,
        "coefficient_rank": coefficient_rank,
        "augmented_rank": augmented_rank,
        "pullback_in_full_degree_one_connecting_image": (
            coefficient_rank == augmented_rank
        ),
        "components": component_summaries,
        "conclusion": (
            "degree-one class is killed; continue to degree zero"
            if coefficient_rank == augmented_rank
            else "pullback is nonsplit on the Borel"
        ),
    }


def reduce_component(source, left, right, row_columns, pullback_column):
    span = SparseSpan()
    coboundaries = component_coboundaries(source, left, right)
    for column in coboundaries:
        span.add(column)
    reduced_rows = {
        row_index: reduced
        for row_index, column in row_columns.items()
        for reduced in (span.reduce(column),)
        if reduced
    }
    reduced_pullback = (
        span.reduce(pullback_column) if pullback_column else {}
    )
    coordinates = sorted(
        set().union(
            *(column.keys() for column in reduced_rows.values()),
            reduced_pullback.keys(),
        )
        if reduced_rows or reduced_pullback
        else ()
    )
    equations = []
    for coordinate in coordinates:
        equation = {
            row_index: column[coordinate]
            for row_index, column in reduced_rows.items()
            if coordinate in column
        }
        rhs = reduced_pullback.get(coordinate, FIELD.zero())
        if equation or rhs:
            equations.append((equation, rhs))
    return equations, {
        "target_dimension": left.dimension * right.dimension,
        "torus_fixed_cochains": len(coboundaries),
        "filtered_row_indices": sorted(row_columns),
        "quotient_support_coordinates": len(coordinates),
        "pullback_quotient_support": len(reduced_pullback),
    }


def minimal_witness():
    """Replay the two-component direct Borel obstruction."""
    (
        b_module,
        a_module,
        extension_blocks,
        architecture,
    ) = connecting.adapted_dual_weyl()
    c0 = connecting.CachedModule(
        connecting.domain.SymmetricSquareModule(b_module)
    )
    middle = connecting.CachedModule(
        connecting.domain.TensorModule(b_module, a_module)
    )
    c2 = connecting.CachedModule(
        connecting.domain.SymmetricSquareModule(a_module)
    )
    d1, d2 = connecting.adjacent_cochains(
        b_module,
        a_module,
        extension_blocks,
        c0.module,
        middle.module,
        c2.module,
    )
    source = connecting.domain.SimpleModule((6,))
    t_plus = connecting.domain.SimpleModule((9, 1))
    r31 = connecting.domain.SimpleModule((3, 1))
    y02 = connecting.domain.SimpleModule((0, 2))
    factor_cache = {}

    def factor_maps(layer, digits):
        key = (id(layer), tuple(digits))
        if key not in factor_cache:
            simple = connecting.domain.SimpleModule(tuple(digits))
            factor_cache[key] = (
                simple,
                *connecting.normalized_factor_maps(layer, simple),
            )
        return factor_cache[key]

    _, _, _, p_s = factor_maps(c0, (6, 0))
    _, _, i_t, p_t = factor_maps(middle, (9, 1))
    first_rows = {}
    for row_index, digits in zip(
        (14, 15, 16), ((10, 0), (6, 0), (2, 0))
    ):
        y_simple, _, i_y, _ = factor_maps(c2, digits)
        target = connecting.domain.TensorModule(source, y_simple)
        hom_record, homs = connecting.hom_basis(source, target)
        assert hom_record["dimension"] == 1
        d2_simple = tuple(p_t * value * i_y for value in d2[:2])
        first_rows[row_index] = sparse_flatten(
            full_c0_c2_values(source, homs[0], d2_simple)
        )
    for row_index, digits in zip(
        (32, 33, 34), ((7, 1), (5, 1), (3, 1))
    ):
        r_simple, _, i_r, _ = factor_maps(middle, digits)
        target = connecting.domain.TensorModule(r_simple, t_plus)
        hom_record, homs = connecting.hom_basis(source, target)
        assert hom_record["dimension"] == 1
        d1_simple = tuple(p_s * value * i_r for value in d1[:2])
        first_rows[row_index] = sparse_flatten(
            full_m_cross_values(
                source, homs[0], t_plus, d1_simple
            )
        )

    t_cocycle = standard_t_plus_cocycle(t_plus)
    pullback_values = []
    for value in t_cocycle:
        cochain = matrix(
            FIELD, source.dimension * t_plus.dimension, source.dimension
        )
        for source_index in range(source.dimension):
            for t_index, coefficient in value.dict().items():
                cochain[
                    source_index * t_plus.dimension + int(t_index),
                    source_index,
                ] = coefficient
        pullback_values.append(cochain)
    first_equations, first_summary = reduce_component(
        source,
        source,
        t_plus,
        first_rows,
        sparse_flatten(pullback_values),
    )
    first_summary["factors"] = [[6, 0], [9, 1]]

    _, _, _, p_y02 = factor_maps(c0, (0, 2))
    _, _, i_r31, _ = factor_maps(middle, (3, 1))
    target = connecting.domain.TensorModule(t_plus, r31)
    hom_record, homs = connecting.hom_basis(source, target)
    assert hom_record["dimension"] == 1
    source_inverses = tuple(
        action**-1 for action in source.actions[:2]
    )
    lower_t = tuple(p_y02 * value * i_t for value in d1[:2])
    second_values = tuple(
        lower_t[generator].tensor_product(r31.actions[generator])
        * homs[0]
        * source_inverses[generator]
        for generator in range(2)
    )
    second_equations, second_summary = reduce_component(
        source,
        y02,
        r31,
        {34: sparse_flatten(second_values)},
        {},
    )
    second_summary["factors"] = [[0, 2], [3, 1]]

    coefficient_stream = connecting.domain.StreamingRank(60)
    augmented_stream = connecting.domain.StreamingRank(61)
    summaries = []
    for equations, summary in (
        (first_equations, first_summary),
        (second_equations, second_summary),
    ):
        for equation, rhs in equations:
            coefficient_stream.add(dict(equation))
            augmented = dict(equation)
            if rhs:
                augmented[60] = rhs
            augmented_stream.add(augmented)
        summary["quotient_equations"] = len(equations)
        summary["cumulative_coefficient_rank"] = (
            coefficient_stream.rank
        )
        summary["cumulative_augmented_rank"] = augmented_stream.rank
        summaries.append(summary)

    assert coefficient_stream.rank == 1
    assert augmented_stream.rank == 2
    return {
        "schema": 1,
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "generators": ["u(1)", "u(a)", "split_torus"],
        "architecture": architecture,
        "degree_two_domain_dimension": 60,
        "witness_components": summaries,
        "coefficient_rank": coefficient_stream.rank,
        "augmented_rank": augmented_stream.rank,
        "pullback_splits_on_borel": False,
        "restriction_index": base.Q + 1,
        "restriction_index_mod_p": (base.Q + 1) % base.P,
        "conclusion": (
            "the q=121 quadratic pullback is nonsplit on the split Borel"
        ),
    }


def reduction_test():
    """Test the full 980-dimensional trace-compatible quotient.

    The earlier six-row calculation retained only categorical traces in
    T_plus.  Here the same six filtration rows are kept as full cocycles in
    Hom(L(6), L(6) tensor T_plus), together with every torus-compatible
    coboundary in that 980-dimensional Borel module.
    """
    (
        b_module,
        a_module,
        extension_blocks,
        architecture,
    ) = connecting.adapted_dual_weyl()
    c0 = connecting.CachedModule(
        connecting.domain.SymmetricSquareModule(b_module)
    )
    middle = connecting.CachedModule(
        connecting.domain.TensorModule(b_module, a_module)
    )
    c2 = connecting.CachedModule(
        connecting.domain.SymmetricSquareModule(a_module)
    )
    d1, d2 = connecting.adjacent_cochains(
        b_module,
        a_module,
        extension_blocks,
        c0.module,
        middle.module,
        c2.module,
    )
    source = connecting.domain.SimpleModule((6,))
    t_plus = connecting.domain.SimpleModule((9, 1))
    factor_cache = {}

    def factor_maps(layer, digits):
        key = (id(layer), digits)
        if key not in factor_cache:
            simple = connecting.domain.SimpleModule(digits)
            factor_cache[key] = (
                simple,
                *connecting.normalized_factor_maps(layer, simple),
            )
        return factor_cache[key]

    _, _, _, p_s = factor_maps(c0, (6, 0))
    _, _, i_t, p_t = factor_maps(middle, (9, 1))
    row_values = []
    row_labels = []
    for digits in ((10, 0), (6, 0), (2, 0)):
        y_simple, _, i_y, _ = factor_maps(c2, digits)
        target = connecting.domain.TensorModule(source, y_simple)
        hom_record, homs = connecting.hom_basis(source, target)
        assert hom_record["dimension"] == 1
        d2_simple = tuple(p_t * value * i_y for value in d2[:2])
        row_values.append(
            full_c0_c2_values(source, homs[0], d2_simple)
        )
        row_labels.append(f"C0xC2:L(6,0)xL{digits}")

    for digits in ((7, 1), (5, 1), (3, 1)):
        r_simple, _, i_r, _ = factor_maps(middle, digits)
        target = connecting.domain.TensorModule(r_simple, t_plus)
        hom_record, homs = connecting.hom_basis(source, target)
        assert hom_record["dimension"] == 1
        d1_simple = tuple(p_s * value * i_r for value in d1[:2])
        row_values.append(
            full_m_cross_values(
                source, homs[0], t_plus, d1_simple
            )
        )
        row_labels.append(f"Sym2M:L{digits}xL(9,1)")

    t_cocycle = standard_t_plus_cocycle(t_plus)
    pullback_values = []
    for value in t_cocycle:
        cochain = matrix(
            FIELD, source.dimension * t_plus.dimension, source.dimension
        )
        for source_index in range(source.dimension):
            for t_index, coefficient in value.dict().items():
                cochain[
                    source_index * t_plus.dimension + int(t_index),
                    source_index,
                ] = coefficient
        pullback_values.append(cochain)

    target_actions = [
        source.actions[generator].tensor_product(
            t_plus.actions[generator]
        )
        for generator in range(2)
    ]
    fixed_maps = []
    for output_s, output_weight in enumerate(source.weights):
        for output_t, t_weight in enumerate(t_plus.weights):
            row = output_s * t_plus.dimension + output_t
            for input_s, input_weight in enumerate(source.weights):
                if same_character(
                    output_weight + t_weight, input_weight
                ):
                    fixed = matrix(
                        FIELD,
                        source.dimension * t_plus.dimension,
                        source.dimension,
                    )
                    fixed[row, input_s] = 1
                    fixed_maps.append(fixed)
    coboundaries = []
    for fixed in fixed_maps:
        values = []
        for generator in range(2):
            values.append(
                target_actions[generator]
                * fixed
                * source.actions[generator] ** -1
                - fixed
            )
        coboundaries.append(flatten_values(values))

    row_columns = [flatten_values(values) for values in row_values]
    pullback_column = flatten_values(pullback_values)
    coefficient = matrix(
        FIELD, list(zip(*(row_columns + coboundaries)))
    )
    augmented = coefficient.augment(
        matrix(FIELD, len(pullback_column), 1, list(pullback_column))
    )
    coefficient_rank = coefficient.rank()
    augmented_rank = augmented.rank()

    trace_scalars = [
        connecting.field_coordinates(
            connecting.h1_scalar(
                (
                    connecting.traced_c0_c2_row(
                        source,
                        connecting.hom_basis(
                            source,
                            connecting.domain.TensorModule(
                                source,
                                factor_maps(c2, digits)[0],
                            ),
                        )[1][0],
                        factor_maps(c2, digits)[0],
                        tuple(
                            p_t * value * factor_maps(c2, digits)[2]
                            for value in d2[:2]
                        ),
                    )
                    if index < 3
                    else connecting.traced_m_cross_row(
                        source,
                        connecting.hom_basis(
                            source,
                            connecting.domain.TensorModule(
                                factor_maps(middle, digits)[0],
                                t_plus,
                            ),
                        )[1][0],
                        factor_maps(middle, digits)[0],
                        t_plus,
                        tuple(
                            p_s
                            * value
                            * factor_maps(middle, digits)[2]
                            for value in d1[:2]
                        ),
                    )
                ),
                t_plus,
            )
        )
        for index, digits in enumerate(
            ((10, 0), (6, 0), (2, 0), (7, 1), (5, 1), (3, 1))
        )
    ]
    return {
        "schema": 1,
        "mode": "trace-compatible quotient",
        "q": base.Q,
        "p": base.P,
        "field_modulus": str(FIELD.modulus()),
        "architecture": architecture,
        "module": "Hom(L(6),L(6) tensor T_plus)",
        "module_dimension": (
            source.dimension * source.dimension * t_plus.dimension
        ),
        "normalized_cocycle_coordinates": len(pullback_column),
        "torus_fixed_cochains": len(fixed_maps),
        "filtered_rows": row_labels,
        "filtered_trace_scalars": trace_scalars,
        "coefficient_rank": coefficient_rank,
        "augmented_rank": augmented_rank,
        "pullback_in_filtered_span_mod_coboundaries": (
            coefficient_rank == augmented_rank
        ),
        "conclusion": (
            "quotient is blind; continue the direct Borel calculation"
            if coefficient_rank == augmented_rank
            else "pullback is nonsplit on the Borel"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    exploration = parser.add_mutually_exclusive_group()
    exploration.add_argument("--profile", action="store_true")
    exploration.add_argument("--reduction", action="store_true")
    exploration.add_argument("--degree-one", action="store_true")
    exploration.add_argument("--hermite-check", action="store_true")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.profile:
        result = profile()
    elif args.reduction:
        result = reduction_test()
    elif args.degree_one:
        result = degree_one_test()
    elif args.hermite_check:
        result = hermite_check()
    else:
        result = minimal_witness()
        result["hermite_intertwiner"] = hermite_check()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write:
        CERTIFICATE.write_text(encoded)
        print(f"wrote {CERTIFICATE.name}")
    elif args.check:
        assert CERTIFICATE.read_text() == encoded
        print(f"checked {CERTIFICATE.name}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
