#!/usr/bin/env python3
"""Certify the C682 invariant-operator audit's characteristic-11 bridge."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import itertools
import json
import math
from pathlib import Path


REPOSITORY = Path(__file__).resolve().parents[1]
NOTES = REPOSITORY / "notes"
EVIDENCE = (
    REPOSITORY
    / "papers"
    / "clebsch-factorization"
    / "verification"
    / "evidence"
)
MATCHING_MODULE_PATH = EVIDENCE / "matching_module.py"
C651_SCRIPT_PATH = NOTES / "2026-07-26-c651-hitchin-tensor-bridge.py"
C651_CERTIFICATE_PATH = C651_SCRIPT_PATH.with_suffix(".json")
OUTPUT = Path(__file__).with_suffix(".json")
PRIME = 11
F = {(11, 1): 1, (6, 6): 11, (1, 11): -1}


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


MM = load_module("c682_matching_module", MATCHING_MODULE_PATH)
C651 = load_module("c682_c651_bridge", C651_SCRIPT_PATH)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def clean(poly: dict[tuple[int, int], int]) -> dict[tuple[int, int], int]:
    return {exponent: coefficient for exponent, coefficient in poly.items() if coefficient}


def derivative(
    poly: dict[tuple[int, int], int], x_order: int, y_order: int
) -> dict[tuple[int, int], int]:
    answer = {}
    for (x_degree, y_degree), coefficient in poly.items():
        if x_degree < x_order or y_degree < y_order:
            continue
        answer[(x_degree - x_order, y_degree - y_order)] = (
            coefficient
            * math.factorial(x_degree)
            // math.factorial(x_degree - x_order)
            * math.factorial(y_degree)
            // math.factorial(y_degree - y_order)
        )
    return clean(answer)


def hasse(
    poly: dict[tuple[int, int], int], x_order: int, y_order: int
) -> dict[tuple[int, int], int]:
    answer = {}
    for (x_degree, y_degree), coefficient in poly.items():
        if x_degree < x_order or y_degree < y_order:
            continue
        answer[(x_degree - x_order, y_degree - y_order)] = (
            coefficient
            * math.comb(x_degree, x_order)
            * math.comb(y_degree, y_order)
        )
    return clean(answer)


def add_scaled(
    target: dict[tuple[int, int], int],
    source: dict[tuple[int, int], int],
    scale: int,
) -> None:
    for exponent, coefficient in source.items():
        target[exponent] = target.get(exponent, 0) + scale * coefficient
        if not target[exponent]:
            del target[exponent]


def multiply(
    left: dict[tuple[int, int], int],
    right: dict[tuple[int, int], int],
) -> dict[tuple[int, int], int]:
    answer: dict[tuple[int, int], int] = {}
    for (left_x, left_y), left_coefficient in left.items():
        for (right_x, right_y), right_coefficient in right.items():
            exponent = (left_x + right_x, left_y + right_y)
            answer[exponent] = (
                answer.get(exponent, 0) + left_coefficient * right_coefficient
            )
    return clean(answer)


def raw_third_transvectant(
    form: dict[tuple[int, int], int]
) -> dict[tuple[int, int], int]:
    return raw_third_transvectant_with_right(form, F)


def raw_third_transvectant_with_right(
    form: dict[tuple[int, int], int],
    right: dict[tuple[int, int], int],
) -> dict[tuple[int, int], int]:
    answer: dict[tuple[int, int], int] = {}
    for index in range(4):
        term = multiply(
            derivative(form, 3 - index, index),
            derivative(right, index, 3 - index),
        )
        add_scaled(answer, term, (-1) ** index * math.comb(3, index))
    return clean(answer)


def mod_poly(
    poly: dict[tuple[int, int], int]
) -> dict[tuple[int, int], int]:
    return clean({exponent: coefficient % PRIME for exponent, coefficient in poly.items()})


def bockstein_data() -> list[dict[str, object]]:
    answer = []
    for index in range(4):
        divided_hasse = hasse(F, index, 3 - index)
        assert all(coefficient % PRIME == 0 for coefficient in divided_hasse.values())
        quotient = {
            exponent: coefficient // PRIME
            for exponent, coefficient in divided_hasse.items()
        }
        answer.append(
            {
                "index": index,
                "f_hasse_orders": [3 - index, index],
                "F_hasse_orders": [index, 3 - index],
                "coefficient_mod_11": (
                    (-1) ** index
                    * math.factorial(index)
                    * math.factorial(3 - index)
                    * pow(2, -1, PRIME)
                )
                % PRIME,
                "B_polynomial": serialize_poly(mod_poly(quotient)),
            }
        )
    return answer


def divided_operator(
    form: dict[tuple[int, int], int],
    bockstein: list[dict[str, object]],
) -> dict[tuple[int, int], int]:
    answer: dict[tuple[int, int], int] = {}
    for record in bockstein:
        f_orders = record["f_hasse_orders"]
        b_poly = deserialize_poly(record["B_polynomial"])
        term = multiply(hasse(form, f_orders[0], f_orders[1]), b_poly)
        add_scaled(answer, term, record["coefficient_mod_11"])
    return mod_poly(answer)


def serialize_poly(
    poly: dict[tuple[int, int], int]
) -> list[dict[str, int]]:
    return [
        {"x": exponent[0], "y": exponent[1], "coefficient": coefficient}
        for exponent, coefficient in sorted(poly.items(), reverse=True)
    ]


def deserialize_poly(records: list[dict[str, int]]) -> dict[tuple[int, int], int]:
    return {
        (record["x"], record["y"]): record["coefficient"]
        for record in records
    }


def transvectant_matrix() -> tuple[list[list[int]], list[list[int]]]:
    raw = [[0] * 7 for _ in range(13)]
    for column in range(7):
        form = {(6 - column, column): 1}
        image = raw_third_transvectant(form)
        for row in range(13):
            raw[row][column] = image.get((12 - row, row), 0)
    content = math.gcd(*[abs(value) for row in raw for value in row])
    assert content == 2640
    primitive = [[value // content for value in row] for row in raw]
    return raw, primitive


def matrix_product(
    left: list[list[int]], right: list[list[int]], prime: int = PRIME
) -> list[list[int]]:
    return [
        [
            sum(a * b for a, b in zip(row, column)) % prime
            for column in zip(*right)
        ]
        for row in left
    ]


def difference_matrices(
    left: list[list[int]], right: list[list[int]]
) -> list[list[int]]:
    return [
        [
            (left[row][column] - right[row][column]) % PRIME
            for column in range(len(left[0]))
        ]
        for row in range(len(left))
    ]


def permutation_matrix(permutation: tuple[int, ...]) -> list[list[int]]:
    return [
        [int(row == permutation[column]) for column in range(len(permutation))]
        for row in range(len(permutation))
    ]


def recover_pgl_matrix(
    permutation: tuple[int, ...], parameters: tuple[tuple[int, int], ...]
) -> tuple[int, int, int, int]:
    parameter_index = {parameter: index for index, parameter in enumerate(parameters)}
    for entries in itertools.product(range(PRIME), repeat=4):
        a, b, c, d = entries
        determinant = (a * d - b * c) % PRIME
        if not determinant or MM.normalize_matrix(entries, PRIME) != entries:
            continue
        action = tuple(
            parameter_index[
                MM.COXETER.normalize_pair(
                    (a * left + b * right, c * left + d * right), PRIME
                )
            ]
            for left, right in parameters
        )
        if action == permutation:
            return entries
    raise AssertionError("PGL2 matrix not recovered")


def inverse_2x2_mod(
    entries: tuple[int, int, int, int], modulus: int
) -> tuple[int, int, int, int]:
    a, b, c, d = entries
    inverse_determinant = pow((a * d - b * c) % modulus, -1, modulus)
    return (
        d * inverse_determinant % modulus,
        -b * inverse_determinant % modulus,
        -c * inverse_determinant % modulus,
        a * inverse_determinant % modulus,
    )


def symmetric_action(
    entries: tuple[int, int, int, int], degree: int, determinant_twist: int
) -> list[list[int]]:
    """Return det(g)^twist f(g^-1 z) on x^(n-j)y^j coefficient columns."""
    return symmetric_action_mod(entries, degree, determinant_twist, PRIME)


def symmetric_action_mod(
    entries: tuple[int, int, int, int],
    degree: int,
    determinant_twist: int,
    modulus: int,
) -> list[list[int]]:
    a, b, c, d = inverse_2x2_mod(entries, modulus)
    determinant = (entries[0] * entries[3] - entries[1] * entries[2]) % modulus
    scale = pow(determinant, determinant_twist, modulus)
    action = [[0] * (degree + 1) for _ in range(degree + 1)]
    for column in range(degree + 1):
        left_degree = degree - column
        right_degree = column
        for left_y in range(left_degree + 1):
            for right_y in range(right_degree + 1):
                row = left_y + right_y
                coefficient = (
                    math.comb(left_degree, left_y)
                    * pow(a, left_degree - left_y, modulus)
                    * pow(b, left_y, modulus)
                    * math.comb(right_degree, right_y)
                    * pow(c, right_degree - right_y, modulus)
                    * pow(d, right_y, modulus)
                )
                action[row][column] = (
                    action[row][column] + scale * coefficient
                ) % modulus
    return action


def rectangular_hom_basis(
    left_actions: list[list[list[int]]],
    right_actions: list[list[list[int]]],
) -> list[list[int]]:
    rows = len(left_actions[0])
    columns = len(right_actions[0])
    equations = []
    for left, right in zip(left_actions, right_actions):
        for row in range(rows):
            for column in range(columns):
                equation = [0] * (rows * columns)
                for middle in range(rows):
                    equation[middle * columns + column] += left[row][middle]
                for middle in range(columns):
                    equation[row * columns + middle] -= right[middle][column]
                equations.append([value % PRIME for value in equation])
    return MM.nullspace(equations, PRIME)


def reshape(vector: list[int], rows: int, columns: int) -> list[list[int]]:
    return [
        vector[columns * row : columns * row + columns]
        for row in range(rows)
    ]


def linear_combination(vectors: list[list[int]], coefficients: list[int]) -> list[int]:
    return [
        sum(coefficient * vector[index] for coefficient, vector in zip(coefficients, vectors))
        % PRIME
        for index in range(len(vectors[0]))
    ]


def horizontal_join(left: list[list[int]], right: list[list[int]]) -> list[list[int]]:
    return [left_row + right_row for left_row, right_row in zip(left, right)]


def pair_embedding() -> list[list[int]]:
    return [
        [
            (
                int(left == coordinate)
                + int(right == coordinate)
                - int(left == 4)
                - int(right == 4)
            )
            % PRIME
            for coordinate in range(4)
        ]
        for left, right in itertools.combinations(range(5), 2)
    ]


def build_certificate() -> dict[str, object]:
    bockstein = bockstein_data()
    tested_monomials = 0
    for degree in range(29):
        for y_degree in range(degree + 1):
            form = {(degree - y_degree, y_degree): 1}
            raw = raw_third_transvectant(form)
            assert all(coefficient % PRIME == 0 for coefficient in raw.values())
            raw_divided = {
                exponent: coefficient // PRIME * pow(12, -1, PRIME)
                for exponent, coefficient in raw.items()
            }
            assert divided_operator(form, bockstein) == mod_poly(raw_divided)
            tested_monomials += 1

    assert all(
        not mod_poly(derivative(F, index, 3 - index))
        for index in range(4)
    )
    _raw_matrix, primitive_matrix = transvectant_matrix()
    primitive_mod = [[value % PRIME for value in row] for row in primitive_matrix]
    divided_matrix = [[0] * 7 for _ in range(13)]
    for column in range(7):
        image = divided_operator({(6 - column, column): 1}, bockstein)
        for row in range(13):
            divided_matrix[row][column] = image.get((12 - row, row), 0)
    assert divided_matrix == [
        [20 * value % PRIME for value in row] for row in primitive_mod
    ]
    assert primitive_mod == [
        [5 * value % PRIME for value in row] for row in divided_matrix
    ]
    assert MM.rank(primitive_mod, PRIME) == 4

    workspace = C651.h3_workspace()
    parent_group = workspace["parent_group"]
    _subgroups, five_actions = C651.natural_five_action(parent_group)
    generators = MM.permutation_generators(parent_group)
    _conic, raw_parameters = MM.COXETER.conic_parameterization(PRIME)
    parameters = tuple(raw_parameters)
    pgl_matrices = [recover_pgl_matrix(element, parameters) for element in generators]
    pair_permutations = [
        C651.pair_action(five_actions[element]) for element in generators
    ]
    pair_actions = [permutation_matrix(permutation) for permutation in pair_permutations]
    source_actions = [symmetric_action(matrix, 6, 3) for matrix in pgl_matrices]
    target_actions = [symmetric_action(matrix, 12, 1) for matrix in pgl_matrices]
    source_hom_basis = rectangular_hom_basis(source_actions, pair_actions)
    target_hom_basis = rectangular_hom_basis(target_actions, pair_actions)
    assert len(source_hom_basis) == 1
    assert len(target_hom_basis) == 3
    source_intertwiner = reshape(source_hom_basis[0], 7, 10)
    assert MM.rank(source_intertwiner, PRIME) == 4
    target_intertwiner = matrix_product(primitive_mod, source_intertwiner)
    assert MM.rank(target_intertwiner, PRIME) == 4
    assert all(
        matrix_product(source_action, source_intertwiner)
        == matrix_product(source_intertwiner, pair_action)
        for source_action, pair_action in zip(source_actions, pair_actions)
    )
    equivariance_defects = []
    lift_obstructions = []
    f_vector = [F.get((12 - row, row), 0) for row in range(13)]
    for generator_index, (matrix, source_action, target_action, pair_action) in enumerate(
        zip(pgl_matrices, source_actions, target_actions, pair_actions)
    ):
        left = matrix_product(target_action, target_intertwiner)
        right = matrix_product(target_intertwiner, pair_action)
        defect = [
            [
                (left[row][column] - right[row][column]) % PRIME
                for column in range(10)
            ]
            for row in range(13)
        ]
        first_defect = next(
            (
                {"row": row, "column": column, "value": defect[row][column]}
                for row in range(13)
                for column in range(10)
                if defect[row][column]
            ),
            None,
        )
        equivariance_defects.append(
            {
                "generator": generator_index,
                "rank": MM.rank(defect, PRIME),
                "first_nonzero_entry": first_defect,
                "image_closure_rank": MM.rank(
                    horizontal_join(target_intertwiner, left), PRIME
                ),
            }
        )
        lifted_target = symmetric_action_mod(matrix, 12, 1, PRIME**2)
        transformed_f = [
            sum(
                lifted_target[row][column] * f_vector[column]
                for column in range(13)
            )
            % (PRIME**2)
            for row in range(13)
        ]
        lift_difference = [
            (transformed_f[row] - f_vector[row]) % (PRIME**2)
            for row in range(13)
        ]
        assert all(value % PRIME == 0 for value in lift_difference)
        lift_polynomial = clean(
            {
                (12 - row, row): value // PRIME
                for row, value in enumerate(lift_difference)
            }
        )
        assert lift_polynomial
        rho_action = symmetric_action(matrix, 6, 0)
        correction = [[0] * 7 for _ in range(13)]
        determinant = (matrix[0] * matrix[3] - matrix[1] * matrix[2]) % PRIME
        correction_scale = (
            5 * pow(determinant, 3, PRIME) * pow(12, -1, PRIME)
        ) % PRIME
        for column in range(7):
            rho_form = clean(
                {
                    (6 - row, row): rho_action[row][column]
                    for row in range(7)
                }
            )
            image = raw_third_transvectant_with_right(rho_form, lift_polynomial)
            for row in range(13):
                correction[row][column] = (
                    correction_scale * image.get((12 - row, row), 0)
                ) % PRIME
        full_defect = difference_matrices(
            matrix_product(target_action, primitive_mod),
            matrix_product(primitive_mod, source_action),
        )
        assert correction == full_defect
        assert matrix_product(correction, source_intertwiner) == defect
        lift_obstructions.append(
            {
                "generator": generator_index,
                "F_lift_defect": serialize_poly(lift_polynomial),
                "F_lift_defect_rank_contribution": MM.rank(correction, PRIME),
                "defect_identity_verified": True,
            }
        )
    assert all(record["rank"] > 0 for record in equivariance_defects)

    source_kernel = MM.nullspace(source_intertwiner, PRIME)
    assert len(source_kernel) == 6
    target_hom_matrices = [
        reshape(vector, 13, 10) for vector in target_hom_basis
    ]
    factor_equations = []
    for kernel_vector in source_kernel:
        for row in range(13):
            factor_equations.append(
                [
                    sum(matrix[row][column] * kernel_vector[column] for column in range(10))
                    % PRIME
                    for matrix in target_hom_matrices
                ]
            )
    factor_coefficients = MM.nullspace(factor_equations, PRIME)
    assert len(factor_coefficients) == 1
    equivariant_target_intertwiner = reshape(
        linear_combination(target_hom_basis, factor_coefficients[0]), 13, 10
    )
    assert MM.rank(equivariant_target_intertwiner, PRIME) == 4
    assert all(
        matrix_product(target_action, equivariant_target_intertwiner)
        == matrix_product(equivariant_target_intertwiner, pair_action)
        for target_action, pair_action in zip(target_actions, pair_actions)
    )
    image_union_rank = MM.rank(
        horizontal_join(target_intertwiner, equivariant_target_intertwiner), PRIME
    )
    image_intersection_dimension = 8 - image_union_rank
    c651_chart = matrix_product(source_intertwiner, pair_embedding())
    transported_chart = matrix_product(primitive_mod, c651_chart)
    equivariant_target_chart = matrix_product(
        equivariant_target_intertwiner, pair_embedding()
    )
    assert MM.rank(c651_chart, PRIME) == 4
    assert MM.rank(transported_chart, PRIME) == 4
    assert MM.rank(equivariant_target_chart, PRIME) == 4
    first_nonzero = next(
        {
            "row": row,
            "column": column,
            "value": transported_chart[row][column],
        }
        for row in range(13)
        for column in range(4)
        if transported_chart[row][column]
    )

    c651_certificate = json.loads(C651_CERTIFICATE_PATH.read_text(encoding="utf-8"))
    assert c651_certificate["clebsch_restriction_scalar"] == 4
    inputs = (
        MATCHING_MODULE_PATH,
        C651_SCRIPT_PATH,
        C651_CERTIFICATE_PATH,
        EVIDENCE / "matching_orbit_scout.json",
    )
    return {
        "schema": "clebsch-invariant-operator-divided-power-v1",
        "field": "F_11",
        "klein_dodecic": serialize_poly(F),
        "ordinary_third_derivatives_reduce_to_zero": True,
        "bockstein_hasse_terms": bockstein,
        "bockstein_identity": (
            "Dbar(f)=sum_i (-1)^i i!(3-i)!/2 "
            "Hasse_(3-i,i)(f) * ((Hasse_(i,3-i)(F)/11) mod 11)"
        ),
        "monomial_identity_test_max_degree": 28,
        "monomial_identity_test_count": tested_monomials,
        "sym6_raw_transvectant_content": 2640,
        "operator_content": 132,
        "sym6_primitive_matrix": primitive_matrix,
        "sym6_primitive_matrix_rank_mod_11": MM.rank(primitive_mod, PRIME),
        "operator_to_primitive_scalar_mod_11": 20 % PRIME,
        "primitive_to_operator_scalar_mod_11": 5,
        "a5_order": len(parent_group),
        "a5_generator_count": len(generators),
        "a5_pgl2_generators": [list(matrix) for matrix in pgl_matrices],
        "a5_pair_permutations": [list(permutation) for permutation in pair_permutations],
        "source_action": "det(g)^3 Sym^6(g^{-1})",
        "target_action": "det(g) Sym^12(g^{-1})",
        "pair_to_sym6_hom_dimension": len(source_hom_basis),
        "pair_to_sym12_hom_dimension": len(target_hom_basis),
        "pair_to_sym6_intertwiner": source_intertwiner,
        "pair_to_sym6_intertwiner_rank": MM.rank(source_intertwiner, PRIME),
        "primitive_transvectant_pair_to_sym12": target_intertwiner,
        "primitive_transvectant_pair_to_sym12_rank": MM.rank(
            target_intertwiner, PRIME
        ),
        "primitive_transvectant_is_a5_equivariant_on_c651_four_space": False,
        "a5_equivariance_defects": equivariance_defects,
        "mod_121_lift_obstructions": lift_obstructions,
        "lift_obstruction_identity": (
            "For L_g=(det(g)F(g^-1 z)-F)/11 mod 11, "
            "rho12(g)P-P rho6(g)=5 det(g)^3/12 * "
            "(rho6_unweighted(g)(-),L_g)_3."
        ),
        "equivariant_pair_to_sym12_four_intertwiner": equivariant_target_intertwiner,
        "primitive_image_vs_equivariant_image_union_rank": image_union_rank,
        "primitive_image_vs_equivariant_image_intersection_dimension": (
            image_intersection_dimension
        ),
        "c651_four_chart_in_sym6": c651_chart,
        "c651_four_chart_after_primitive_transvectant": transported_chart,
        "c651_equivariant_target_four_chart": equivariant_target_chart,
        "marked_nonzero_entry": first_nonzero,
        "c651_clebsch_restriction_scalar": 4,
        "c651_integral_cubic_line": c651_certificate["integral_clebsch_line"],
        "interpretation": (
            "The primitive Sym^6-to-Sym^12 transvectant is rank four and is "
            "canonically recovered as an 11-adic Bockstein/Hasse operator, but "
            "it does not carry the standard C651 A5-marked four-space to the "
            "A5-equivariant target four-space.  The recorded generator defects "
            "are an exact obstruction to the stronger marked bridge."
        ),
        "inputs": {
            str(path.relative_to(REPOSITORY)): {
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
            for path in inputs
        },
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(rendered, encoding="utf-8")
        print(f"wrote {OUTPUT.relative_to(REPOSITORY)}")
        return 0
    if not OUTPUT.is_file() or OUTPUT.read_text(encoding="utf-8") != rendered:
        raise SystemExit(f"stale certificate: run {Path(__file__).name} --write")
    print("C682 invariant-operator divided-power certificate: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
