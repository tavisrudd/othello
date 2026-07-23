#!/usr/bin/env python3
"""Independent reconstruction of the finite C417 affine extensions."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SCOUT = json.loads(
    (HERE / "2026-07-20-c406-matching-orbit-scout.json").read_text()
)
CERTIFICATE = json.loads(
    (HERE / "2026-07-23-c417-affine-cocycle-line-bundle.json").read_text()
)


def load_module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


REPLAY = load_module(
    "c417_independent_c406_replay",
    HERE / "2026-07-20-c406-matching-module-replay.py",
)


def action_permutation(element, orbit, orbit_index):
    return tuple(
        orbit_index[REPLAY.image_matching(element, matching)]
        for matching in orbit
    )


def column_rank(columns, q):
    return REPLAY.matrix_rank(REPLAY.transpose(columns), q)


def independent_case(record):
    name = record["type"]
    q = record["field_order"]
    endpoints, pgl, psl = REPLAY.mobius_groups(q)
    base = tuple(tuple(pair) for pair in record["coxeter_invariant_matching"])
    orbit = sorted(
        {REPLAY.image_matching(group_element, base) for group_element in pgl}
    )
    orbit_index = {matching: index for index, matching in enumerate(orbit)}
    base_index = orbit_index[base]
    base_product = REPLAY.secant_product(base, endpoints, q)
    quotient_degree = (q + 1) // 2 - 2
    vectors = []
    for matching in orbit:
        product = REPLAY.secant_product(matching, endpoints, q)
        difference = {
            exponent: (
                product.get(exponent, 0) - base_product.get(exponent, 0)
            )
            % q
            for exponent in set(product) | set(base_product)
        }
        vectors.append(REPLAY.conic_quotient(difference, quotient_degree, q))

    image_rank = column_rank(vectors, q)
    _reduced, coordinate_pivots = REPLAY.row_reduce(vectors, q)
    assert len(coordinate_pivots) == image_rank
    points = [
        [vector[index] for index in coordinate_pivots] for vector in vectors
    ]
    _reduced, point_basis_indices = REPLAY.row_reduce(
        REPLAY.transpose(points), q
    )
    assert len(point_basis_indices) == image_rank
    basis_matrix = REPLAY.transpose(
        [points[index] for index in point_basis_indices]
    )
    basis_inverse = REPLAY.matrix_inverse(basis_matrix, q)

    def affine_pair(element):
        action = action_permutation(element, orbit, orbit_index)
        moved_base = action[base_index]
        target_basis = REPLAY.transpose(
            [
                [
                    (points[action[index]][coordinate]
                     - points[moved_base][coordinate])
                    % q
                    for coordinate in range(image_rank)
                ]
                for index in point_basis_indices
            ]
        )
        linear = REPLAY.matrix_product(target_basis, basis_inverse, q)
        return linear, points[moved_base]

    # These standard Möbius transformations generate PSL_2(q).
    point_index = {point: index for index, point in enumerate(endpoints)}

    def mobius(a, b, c, d):
        permutation = []
        for left, right in endpoints:
            image = (
                (a * left + b * right) % q,
                (c * left + d * right) % q,
            )
            scale = pow(image[0] or image[1], -1, q)
            permutation.append(
                point_index[(image[0] * scale % q, image[1] * scale % q)]
            )
        return tuple(permutation)

    generators = [mobius(1, 1, 0, 1), mobius(0, -1, 1, 0)]
    assert all(generator in psl for generator in generators)

    variable_count = len(generators) * image_rank
    identity_permutation = tuple(range(len(generators[0])))
    cocycle_operators = {
        identity_permutation: [[0] * variable_count for _ in range(image_rank)]
    }
    frontier = [identity_permutation]
    cocycle_relations = []
    while frontier:
        element = frontier.pop()
        operator = cocycle_operators[element]
        for generator_index, generator in enumerate(generators):
            linear, _translation = affine_pair(generator)
            candidate = REPLAY.matrix_product(linear, operator, q)
            candidate = [row[:] for row in candidate]
            for coordinate in range(image_rank):
                candidate[coordinate][
                    generator_index * image_rank + coordinate
                ] = (
                    candidate[coordinate][
                        generator_index * image_rank + coordinate
                    ]
                    + 1
                ) % q
            product = REPLAY.compose(generator, element)
            if product not in cocycle_operators:
                cocycle_operators[product] = candidate
                frontier.append(product)
            else:
                cocycle_relations.extend(
                    [
                        [
                            (left - right) % q
                            for left, right in zip(
                                candidate[row],
                                cocycle_operators[product][row],
                            )
                        ]
                        for row in range(image_rank)
                    ]
                )
    assert set(cocycle_operators) == psl
    z1_dimension = variable_count - REPLAY.matrix_rank(
        cocycle_relations, q
    )
    coboundary_columns = []
    for coordinate in range(image_rank):
        vector = [int(index == coordinate) for index in range(image_rank)]
        column = []
        for generator in generators:
            linear, _translation = affine_pair(generator)
            moved = REPLAY.matrix_vector(linear, vector, q)
            column.extend(
                [
                    (moved[index] - vector[index]) % q
                    for index in range(image_rank)
                ]
            )
        coboundary_columns.append(column)
    b1_dimension = column_rank(coboundary_columns, q)
    h1_dimension_global = z1_dimension - b1_dimension
    assert h1_dimension_global == 1

    rows = []
    rhs = []
    for generator in generators:
        linear, translation = affine_pair(generator)
        for row in range(image_rank):
            rows.append(
                [
                    (int(row == column) - linear[row][column]) % q
                    for column in range(image_rank)
                ]
            )
            rhs.append(translation[row])
    rank = REPLAY.matrix_rank(rows, q)
    augmented_rank = REPLAY.matrix_rank(
        [row + [value] for row, value in zip(rows, rhs)], q
    )
    assert augmented_rank == rank + 1

    sylow_generator = generators[0]
    sylow_linear, sylow_translation = affine_pair(sylow_generator)
    difference = [
        [
            (sylow_linear[row][column] - int(row == column)) % q
            for column in range(image_rank)
        ]
        for row in range(image_rank)
    ]
    difference_rank = REPLAY.matrix_rank(difference, q)
    norm = [[0] * image_rank for _ in range(image_rank)]
    power = [[int(row == column) for column in range(image_rank)]
             for row in range(image_rank)]
    for _ in range(q):
        norm = [
            [
                (norm[row][column] + power[row][column]) % q
                for column in range(image_rank)
            ]
            for row in range(image_rank)
        ]
        power = REPLAY.matrix_product(sylow_linear, power, q)
    norm_rank = REPLAY.matrix_rank(norm, q)
    h1_dimension = image_rank - difference_rank - norm_rank
    assert h1_dimension == 2

    _reduced, image_pivots = REPLAY.row_reduce(difference, q)
    quotient_basis = [
        [difference[row][column] for row in range(image_rank)]
        for column in image_pivots
    ]
    for coordinate in range(image_rank):
        standard = [int(index == coordinate) for index in range(image_rank)]
        if column_rank(quotient_basis + [standard], q) > len(quotient_basis):
            quotient_basis.append(standard)
    quotient_inverse = REPLAY.matrix_inverse(
        REPLAY.transpose(quotient_basis), q
    )

    def h1_coordinates(vector):
        return REPLAY.matrix_vector(quotient_inverse, vector, q)[-2:]

    identity_permutation = tuple(range(len(sylow_generator)))
    powers = {identity_permutation: 0}
    current = identity_permutation
    for exponent in range(1, q):
        current = REPLAY.compose(sylow_generator, current)
        powers[current] = exponent
    normalizer_actions = []
    normalizer_order = 0
    for element in psl:
        conjugate = REPLAY.compose(
            REPLAY.compose(REPLAY.invert(element), sylow_generator),
            element,
        )
        if conjugate not in powers:
            continue
        normalizer_order += 1
        geometric_sum = [[0] * image_rank for _ in range(image_rank)]
        power = [[int(row == column) for column in range(image_rank)]
                 for row in range(image_rank)]
        for _ in range(powers[conjugate]):
            geometric_sum = [
                [
                    (geometric_sum[row][column] + power[row][column]) % q
                    for column in range(image_rank)
                ]
                for row in range(image_rank)
            ]
            power = REPLAY.matrix_product(sylow_linear, power, q)
        linear_element, _translation = affine_pair(element)
        operator = REPLAY.matrix_product(
            linear_element, geometric_sum, q
        )
        columns = [
            h1_coordinates(
                REPLAY.matrix_vector(
                    operator,
                    quotient_basis[image_rank - 2 + column],
                    q,
                )
            )
            for column in range(2)
        ]
        normalizer_actions.append(REPLAY.transpose(columns))
    invariant_rows = []
    for action in normalizer_actions:
        invariant_rows.extend(
            [
                [
                    (action[row][column] - int(row == column)) % q
                    for column in range(2)
                ]
                for row in range(2)
            ]
        )
    invariant_dimension = 2 - REPLAY.matrix_rank(invariant_rows, q)
    restricted_class = h1_coordinates(sylow_translation)
    assert any(restricted_class)
    assert invariant_dimension == 1
    assert all(
        REPLAY.matrix_vector(action, restricted_class, q)
        == restricted_class
        for action in normalizer_actions
    )

    sheets = []
    unseen = set(orbit)
    while unseen:
        representative = min(unseen)
        sheet = {
            REPLAY.image_matching(element, representative) for element in psl
        }
        unseen -= sheet
        sheets.append(sheet)
    sheet_records = []
    for sheet in sheets:
        indices = sorted(orbit_index[matching] for matching in sheet)
        affine_columns = [
            [
                (points[index][coordinate] - points[indices[0]][coordinate])
                % q
                for coordinate in range(image_rank)
            ]
            for index in indices
        ]
        homogeneous_columns = [[1] + points[index] for index in indices]
        kernel = REPLAY.nullspace(REPLAY.transpose(homogeneous_columns), q)
        sheet_records.append(
            {
                "affine_rank": column_rank(affine_columns, q),
                "homogeneous_lift_rank": column_rank(homogeneous_columns, q),
                "homogeneous_lift_kernel": kernel,
            }
        )
    return {
        "type": name,
        "quotient_image_rank": image_rank,
        "psl_fixed_point_system_rank": rank,
        "psl_fixed_point_augmented_rank": augmented_rank,
        "psl_z1_dimension": z1_dimension,
        "psl_b1_dimension": b1_dimension,
        "psl_h1_dimension": h1_dimension_global,
        "sylow_p_h1_dimension": h1_dimension,
        "sylow_p_normalizer_order_in_psl": normalizer_order,
        "sylow_p_normalizer_invariant_dimension": invariant_dimension,
        "sheet_homogeneous_lifts": sheet_records,
    }


def main():
    expected = {case["type"]: case for case in CERTIFICATE["cases"]}
    for record in SCOUT["types"]:
        if record["type"] not in ("B3", "H3"):
            continue
        replayed = independent_case(record)
        certified = expected[record["type"]]
        assert replayed["quotient_image_rank"] == certified[
            "quotient_image_rank"
        ]
        assert replayed["psl_fixed_point_system_rank"] == certified[
            "affine_cocycle"
        ]["psl_fixed_point_system_rank"]
        assert replayed["psl_fixed_point_augmented_rank"] == certified[
            "affine_cocycle"
        ]["psl_fixed_point_augmented_rank"]
        assert replayed["psl_z1_dimension"] == certified[
            "affine_cocycle"
        ]["psl_z1_dimension"]
        assert replayed["psl_b1_dimension"] == certified[
            "affine_cocycle"
        ]["psl_b1_dimension"]
        assert replayed["psl_h1_dimension"] == certified[
            "affine_cocycle"
        ]["psl_h1_dimension"]
        assert replayed["sylow_p_h1_dimension"] == certified[
            "affine_cocycle"
        ]["sylow_p_h1_dimension"]
        assert replayed["sylow_p_normalizer_order_in_psl"] == certified[
            "affine_cocycle"
        ]["sylow_p_normalizer_order_in_psl"]
        assert replayed[
            "sylow_p_normalizer_invariant_dimension"
        ] == certified["affine_cocycle"][
            "sylow_p_normalizer_invariant_dimension"
        ]
        for actual, stored in zip(
            replayed["sheet_homogeneous_lifts"],
            certified["sheet_homogeneous_lifts"],
        ):
            assert actual["affine_rank"] == stored["affine_rank"]
            assert (
                actual["homogeneous_lift_rank"]
                == stored["homogeneous_lift_rank"]
            )
            assert (
                actual["homogeneous_lift_kernel"]
                == stored["homogeneous_lift_kernel"]
            )

    boundary = CERTIFICATE["h3_modular_boundary"]
    assert boundary["depth_relation"] == [2, 8, 1]
    assert boundary["cubic_tate_relation"] == [2, 9, 1]
    assert boundary["relations_are_distinct"]
    print("C417 independent affine-cocycle replay OK")


if __name__ == "__main__":
    main()
