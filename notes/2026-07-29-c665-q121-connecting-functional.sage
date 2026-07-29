#!/usr/bin/env sage
"""Evaluate the six q=121 filtered connecting rows visible to trace.

The dual-Weyl module W=Sym^59(V) has the Lucas basis

    B=L(4) tensor L(5)^(1) -> W,
    s^i t^(4-i) tensor s^(11j)t^(55-11j) |-> index i+11j.

Using the complementary monomials as a torus-fixed section gives explicit
extension blocks.  They induce the two adjacent connecting cochains in

    C0=Sym^2(B),  M=B tensor A,  C2=Sym^2(A).

Only three C0 tensor C2 rows and three cross-factor Sym^2(M) rows can
survive projection C0->L(6), categorical trace, and M->T+.
"""

import argparse
import importlib.machinery
import importlib.util
import json
from pathlib import Path

from sage.all import identity_matrix, matrix, vector


HERE = Path(__file__).resolve().parent
DOMAIN_PATH = HERE / "2026-07-29-c665-q121-transgression-domain.sage"
H1_PATH = HERE / "2026-07-29-c665-q121-borel-simple-h1.sage"
CERTIFICATE = HERE / "2026-07-29-c665-q121-connecting-functional.json"


def load_module(name, path):
    loader = importlib.machinery.SourceFileLoader(name, str(path))
    spec = importlib.util.spec_from_loader(loader.name, loader)
    if spec is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    loader.exec_module(module)
    return module


domain = load_module("c665_q121_connecting_domain", DOMAIN_PATH)
h1 = load_module("c665_q121_connecting_h1", H1_PATH)
base = domain.base
FIELD = base.FIELD
A = base.A
P = base.P
MODULUS = base.TORUS_MODULUS
NONSQUARE = FIELD.multiplicative_generator()
PARAMETERS = (FIELD.one(), A)


class MatrixModule:
    def __init__(self, label, actions, weights, dilation):
        self.label = label
        self.actions = tuple(actions)
        self.weights = tuple(weights)
        self.dilation = tuple(dilation)
        self.dimension = len(weights)
        self._columns = {}

    def action_column(self, generator, source):
        key = (generator, source)
        if key not in self._columns:
            column = self.actions[generator].column(source)
            self._columns[key] = tuple(
                (int(target), coefficient)
                for target, coefficient in column.dict().items()
            )
        return self._columns[key]


class CachedModule:
    def __init__(self, module):
        self.module = module
        self.label = getattr(module, "label", None)
        self.dimension = module.dimension
        self.weights = module.weights
        self.dilation = module.dilation
        self._columns = {}

    def action_column(self, generator, source):
        key = (generator, source)
        if key not in self._columns:
            self._columns[key] = self.module.action_column(generator, source)
        return self._columns[key]


class StreamingKernel(domain.StreamingRank):
    def basis(self):
        free_columns = [
            column
            for column in range(self.variable_count)
            if column not in self.pivots
        ]
        answer = []
        for free_column in free_columns:
            solution = [FIELD.zero()] * self.variable_count
            solution[free_column] = FIELD.one()
            for pivot_column in sorted(self.pivots, reverse=True):
                row = self.pivots[pivot_column]
                solution[pivot_column] = -sum(
                    (
                        coefficient * solution[column]
                        for column, coefficient in row.items()
                        if column != pivot_column
                    ),
                    FIELD.zero(),
                )
            answer.append(vector(FIELD, solution))
        return answer


def hom_basis(source, target):
    variables = {}
    for target_row, target_weight in enumerate(target.weights):
        for source_column, source_weight in enumerate(source.weights):
            if (target_weight - source_weight) % MODULUS == 0:
                variables[(target_row, source_column)] = len(variables)
    kernel = StreamingKernel(len(variables))
    equation_count = 0
    for generator in range(3):
        for source_column in range(source.dimension):
            equations = {}
            for target_source in range(target.dimension):
                variable = variables.get((target_source, source_column))
                if variable is None:
                    continue
                for target_row, coefficient in target.action_column(
                    generator, target_source
                ):
                    equation = equations.setdefault(target_row, {})
                    domain.add_entry(equation, variable, coefficient)
            for source_row, coefficient in source.action_column(
                generator, source_column
            ):
                for target_row in range(target.dimension):
                    variable = variables.get((target_row, source_row))
                    if variable is not None:
                        equation = equations.setdefault(target_row, {})
                        domain.add_entry(equation, variable, -coefficient)
            for equation in equations.values():
                if equation:
                    equation_count += 1
                    kernel.add(equation)
    maps = []
    for basis_vector in kernel.basis():
        hom = matrix(FIELD, target.dimension, source.dimension)
        for (target_row, source_column), variable in variables.items():
            hom[target_row, source_column] = basis_vector[variable]
        maps.append(hom)
    return {
        "torus_block_variables": len(variables),
        "equations": equation_count,
        "rank": kernel.rank,
        "dimension": len(maps),
    }, maps


def normalized_factor_maps(layer, simple):
    embedding_record, embeddings = hom_basis(simple, layer)
    projection_record, projections = hom_basis(layer, simple)
    assert embedding_record["dimension"] == 1
    assert projection_record["dimension"] == 1
    embedding = embeddings[0]
    projection = projections[0]
    composition = projection * embedding
    scalar = composition[0, 0]
    assert scalar and composition == scalar * identity_matrix(
        FIELD, simple.dimension
    )
    projection /= scalar
    assert projection * embedding == identity_matrix(
        FIELD, simple.dimension
    )
    return {
        "embedding": embedding_record,
        "projection": projection_record,
    }, embedding, projection


def adapted_dual_weyl():
    degree = 59
    w_actions = [
        base.binary_translation(parameter, degree)
        for parameter in PARAMETERS
    ] + [base.binary_inversion(degree)]
    b_indices = tuple(
        digit0 + P * digit1
        for digit0 in range(5)
        for digit1 in range(6)
    )
    b_set = set(b_indices)
    a_indices = tuple(index for index in range(60) if index not in b_set)
    order = b_indices + a_indices
    position = {old: new for new, old in enumerate(order)}
    adapted_actions = []
    for action in w_actions:
        adapted = matrix(
            FIELD,
            60,
            60,
            {
                (position[row], position[column]): value
                for (row, column), value in action.dict().items()
            },
        )
        assert adapted[30:, :30] == 0
        adapted_actions.append(adapted)
    b_actions = tuple(action[:30, :30] for action in adapted_actions)
    a_actions = tuple(action[30:, 30:] for action in adapted_actions)
    extension_blocks = tuple(action[:30, 30:] for action in adapted_actions)
    standard_b_actions, standard_b_weights = base.digit_simple_actions(
        PARAMETERS, (4, 5)
    )
    assert b_actions == tuple(standard_b_actions)
    w_weights = tuple(degree - 2 * index for index in order)
    b_weights = w_weights[:30]
    a_weights = w_weights[30:]
    assert b_weights == standard_b_weights
    b_module = MatrixModule(
        "B=L(4,5)",
        b_actions,
        b_weights,
        tuple(NONSQUARE ** (weight // 2) for weight in b_weights),
    )
    a_module = MatrixModule(
        "A=L(5,4)",
        a_actions,
        a_weights,
        tuple(NONSQUARE ** (weight // 2) for weight in a_weights),
    )
    standard_a = domain.SimpleModule((5, 4))
    a_isomorphism_record, a_isomorphisms = hom_basis(
        standard_a, a_module
    )
    assert a_isomorphism_record["dimension"] == 1
    assert a_isomorphisms[0].is_invertible()
    return (
        b_module,
        a_module,
        extension_blocks,
        {
            "B_monomial_indices": list(b_indices),
            "A_section_monomial_indices": list(a_indices),
            "A_standard_isomorphism": a_isomorphism_record,
        },
    )


def symmetric_product(module, left, right):
    answer = vector(FIELD, module.dimension)
    for left_index, left_value in left.dict().items():
        for right_index, right_value in right.dict().items():
            pair = tuple(sorted((int(left_index), int(right_index))))
            answer[module.pair_index[pair]] += left_value * right_value
    return answer


def tensor_product(left, right):
    return vector(
        FIELD,
        [
            left_value * right_value
            for left_value in left
            for right_value in right
        ],
    )


def adjacent_cochains(b_module, a_module, extension_blocks, c0, m, c2):
    d1 = []
    d2 = []
    for generator in range(3):
        b_action = b_module.actions[generator]
        a_action = a_module.actions[generator]
        extension = extension_blocks[generator]
        d1_matrix = matrix(FIELD, c0.dimension, m.dimension)
        for b_source in range(b_module.dimension):
            transformed_b = b_action.column(b_source)
            for a_source in range(a_module.dimension):
                column = (
                    b_source * a_module.dimension + a_source
                )
                lower_a = extension.column(a_source)
                d1_matrix[:, column] = symmetric_product(
                    c0, transformed_b, lower_a
                )
        d1.append(d1_matrix)

        d2_matrix = matrix(FIELD, m.dimension, c2.dimension)
        for source, (left, right) in enumerate(c2.pairs):
            lower_left = extension.column(left)
            lower_right = extension.column(right)
            upper_left = a_action.column(left)
            upper_right = a_action.column(right)
            value = tensor_product(lower_left, upper_right)
            value += tensor_product(lower_right, upper_left)
            d2_matrix[:, source] = value
        d2.append(d2_matrix)
    assert d1[2] == 0 and d2[2] == 0
    return tuple(d1), tuple(d2)


def traced_c0_c2_row(source, y_map, y_simple, d2_simple):
    values = []
    for generator in range(2):
        source_action = source.actions[generator]
        source_inverse = source_action**-1
        answer = vector(FIELD, 20)
        for trace_index in range(source.dimension):
            for source_column, inverse_coefficient in source_inverse.column(
                trace_index
            ).dict().items():
                for pair_row, coefficient in y_map.column(
                    source_column
                ).dict().items():
                    s_row, y_row = divmod(
                        int(pair_row), y_simple.dimension
                    )
                    for transformed_s, s_coefficient in (
                        source_action.column(s_row).dict().items()
                    ):
                        if int(transformed_s) != trace_index:
                            continue
                        answer += (
                            inverse_coefficient
                            * coefficient
                            * s_coefficient
                            * d2_simple[generator].column(y_row)
                        )
        values.append(answer)
    return tuple(values)


def traced_m_cross_row(source, y_map, r_simple, t_simple, d1_simple):
    values = []
    for generator in range(2):
        t_action = t_simple.actions[generator]
        source_inverse = source.actions[generator]**-1
        answer = vector(FIELD, t_simple.dimension)
        for trace_index in range(source.dimension):
            for source_column, inverse_coefficient in source_inverse.column(
                trace_index
            ).dict().items():
                for pair_row, coefficient in y_map.column(
                    source_column
                ).dict().items():
                    r_row, t_row = divmod(
                        int(pair_row), t_simple.dimension
                    )
                    for s_row, lower_coefficient in d1_simple[
                        generator
                    ].column(r_row).dict().items():
                        if int(s_row) != trace_index:
                            continue
                        answer += (
                            inverse_coefficient
                            * coefficient
                            * lower_coefficient
                            * t_action.column(t_row)
                        )
        values.append(answer)
    return tuple(values)


def h1_scalar(values, t_simple):
    u1, ua = t_simple.actions[:2]
    dimension = t_simple.dimension
    primitive = FIELD.multiplicative_generator()
    torus_multiplier = h1.base.digit_simple_actions(
        (primitive**2,), (1,)
    )[0][0]
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
    torus_multiplier = next(
        multiplier
        for multiplier in (primitive**2, primitive**-2)
        if sample_torus * sample_actions[0] * sample_torus**-1
        == h1.base.digit_simple_actions((multiplier,), (1,))[0][0]
    )
    weights = t_simple.weights
    torus = matrix(
        FIELD,
        dimension,
        dimension,
        {
            (index, index): primitive**weight
            for index, weight in enumerate(weights)
        },
    )
    identity = identity_matrix(FIELD, dimension)
    norm1 = h1.power_sum(u1, P)
    norma = h1.power_sum(ua, P)
    one_left, one_right = h1.additive_cocycle_coefficients(
        torus_multiplier, u1, ua
    )
    a_left, a_right = h1.additive_cocycle_coefficients(
        torus_multiplier * A, u1, ua
    )
    relations = h1.block_matrix(
        FIELD,
        [
            [norm1, matrix(FIELD, dimension, dimension)],
            [matrix(FIELD, dimension, dimension), norma],
            [identity - ua, u1 - identity],
            [torus - one_left, -one_right],
            [-a_left, torus - a_right],
        ],
        subdivide=False,
    )
    combined = vector(FIELD, list(values[0]) + list(values[1]))
    assert relations * combined == 0
    cocycle_basis = relations.right_kernel().basis()
    assert len(cocycle_basis) == 1
    standard = cocycle_basis[0]
    if not combined:
        return FIELD.zero()
    scalar = next(
        combined[index] / standard[index]
        for index in range(2 * dimension)
        if standard[index]
    )
    assert combined == scalar * standard
    return scalar


def field_coordinates(value):
    coefficients = [int(item) for item in value.polynomial().list()]
    return coefficients + [0] * (FIELD.degree() - len(coefficients))


def calculate():
    domain_certificate = json.loads(domain.CERTIFICATE.read_text())
    c0_visible = [
        record
        for record in domain_certificate["nonzero_summands"]
        if record["kind"] == "C0_tensor_C2"
        and record["factors"][0] == [6, 0]
    ]
    m_visible = [
        record
        for record in domain_certificate["nonzero_summands"]
        if record["kind"] == "M_factor_tensor"
        and [9, 1] in record["factors"]
    ]
    assert [record["factors"] for record in c0_visible] == [
        [[6, 0], [10, 0]],
        [[6, 0], [6, 0]],
        [[6, 0], [2, 0]],
    ]
    assert [record["factors"] for record in m_visible] == [
        [[9, 1], [7, 1]],
        [[9, 1], [5, 1]],
        [[9, 1], [3, 1]],
    ]
    b_module, a_module, extension_blocks, architecture = (
        adapted_dual_weyl()
    )
    c0 = CachedModule(domain.SymmetricSquareModule(b_module))
    m = CachedModule(domain.TensorModule(b_module, a_module))
    c2 = CachedModule(domain.SymmetricSquareModule(a_module))
    d1, d2 = adjacent_cochains(
        b_module, a_module, extension_blocks, c0.module, m.module, c2.module
    )

    source = domain.SimpleModule((6,))
    t_plus = domain.SimpleModule((9, 1))
    factor_cache = {}

    def factor_maps(layer, digits):
        key = (id(layer), digits)
        if key not in factor_cache:
            simple = domain.SimpleModule(digits)
            factor_cache[key] = (
                simple,
                *normalized_factor_maps(layer, simple),
            )
        return factor_cache[key]

    _, c0_record, i_s, p_s = factor_maps(c0, (6, 0))
    _, m_t_record, i_t, p_t = factor_maps(m, (9, 1))

    rows = []
    for digits in ((10, 0), (6, 0), (2, 0)):
        y_simple, y_record, i_y, _ = factor_maps(c2, digits)
        target = domain.TensorModule(source, y_simple)
        hom_record, homs = hom_basis(source, target)
        assert hom_record["dimension"] == 1
        d2_simple = tuple(p_t * value * i_y for value in d2[:2])
        values = traced_c0_c2_row(
            source, homs[0], y_simple, d2_simple
        )
        scalar = h1_scalar(values, t_plus)
        rows.append(
            {
                "kind": "C0_tensor_C2",
                "factors": [[6, 0], list(digits)],
                "hom": hom_record,
                "connecting_scalar": field_coordinates(scalar),
            }
        )

    for digits in ((7, 1), (5, 1), (3, 1)):
        r_simple, r_record, i_r, _ = factor_maps(m, digits)
        target = domain.TensorModule(r_simple, t_plus)
        hom_record, homs = hom_basis(source, target)
        assert hom_record["dimension"] == 1
        d1_simple = tuple(p_s * value * i_r for value in d1[:2])
        values = traced_m_cross_row(
            source, homs[0], r_simple, t_plus, d1_simple
        )
        scalar = h1_scalar(values, t_plus)
        rows.append(
            {
                "kind": "M_factor_tensor",
                "factors": [list(digits), [9, 1]],
                "hom": hom_record,
                "connecting_scalar": field_coordinates(scalar),
            }
        )

    nonzero_rows = sum(
        row["connecting_scalar"] != [0, 0] for row in rows
    )
    return {
        "schema": 1,
        "q": base.Q,
        "p": P,
        "field_modulus": str(FIELD.modulus()),
        "architecture": architecture,
        "layer_dimensions": {
            "B": b_module.dimension,
            "A": a_module.dimension,
            "C0": c0.dimension,
            "M": m.dimension,
            "C2": c2.dimension,
        },
        "factor_hom_checks": {
            "C0_L6": c0_record,
            "M_T_plus": m_t_record,
        },
        "trace_visible_selection": {
            "degree_two_domain_dimension": domain_certificate["totals"][
                "hom_dimension"
            ],
            "C0_tensor_C2_rows": len(c0_visible),
            "M_factor_tensor_rows": len(m_visible),
            "total_rows": len(c0_visible) + len(m_visible),
        },
        "trace_visible_rows": rows,
        "nonzero_connecting_rows": nonzero_rows,
    }


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    result = calculate()
    encoded = json.dumps(result, default=int, indent=2, sort_keys=True) + "\n"
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
