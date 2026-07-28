#!/usr/bin/env python3
"""Explore the Klein transvectant on the free 3-covariant module."""

from __future__ import annotations

import argparse
import importlib.util
import json
from fractions import Fraction
from functools import reduce
from math import gcd
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "2026-07-28-c682-klein-e8-operator-algebra.py"
CERTIFICATE = HERE / "2026-07-28-c682-klein-e8-free-covariant.json"
GENERATOR_CONTENTS = [1, 110, 2, 380, 40, 870]


def load_base():
    spec = importlib.util.spec_from_file_location("klein_e8_base", BASE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {BASE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def scale(polynomial, scalar):
    return {
        monomial: Fraction(coefficient) * scalar
        for monomial, coefficient in polynomial.items()
        if coefficient
    }


def exact_divide(polynomial, divisor):
    if any(coefficient % divisor for coefficient in polynomial.values()):
        raise AssertionError("polynomial content division is not exact")
    return {
        monomial: coefficient // divisor
        for monomial, coefficient in polynomial.items()
    }


def coefficient_vector(polynomial, degree):
    return [
        Fraction(polynomial.get((degree - index, index), 0))
        for index in range(degree + 1)
    ]


def solve_columns(columns, target):
    row_count = len(target)
    column_count = len(columns)
    work = [
        [Fraction(columns[column][row]) for column in range(column_count)]
        + [Fraction(target[row])]
        for row in range(row_count)
    ]
    pivot_columns = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        value = work[pivot_row][column]
        work[pivot_row] = [entry / value for entry in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or not work[row][column]:
                continue
            multiplier = work[row][column]
            work[row] = [
                entry - multiplier * pivot_entry
                for entry, pivot_entry in zip(work[row], work[pivot_row])
            ]
        pivot_columns.append(column)
        pivot_row += 1
    if len(pivot_columns) != column_count:
        raise AssertionError("candidate covariants are dependent")
    for row in range(pivot_row, row_count):
        if not any(work[row][:-1]) and work[row][-1]:
            raise AssertionError("target is outside the free covariant span")
    solution = [Fraction(0)] * column_count
    for row, column in enumerate(pivot_columns):
        solution[column] = work[row][-1]
    return solution


def polynomial_power(base, exponent, tools):
    out = {(0, 0): 1}
    for _ in range(exponent):
        out = tools.multiply(out, base)
    return out


def falling(value, order):
    out = 1
    for offset in range(order):
        out *= value - offset
    return out


def ring_add(left, right):
    out = dict(left)
    for monomial, coefficient in right.items():
        out[monomial] = out.get(monomial, Fraction(0)) + coefficient
        if not out[monomial]:
            del out[monomial]
    return out


def ring_multiply(left, right):
    out = {}
    for (left_f, left_h), left_coefficient in left.items():
        for (right_f, right_h), right_coefficient in right.items():
            monomial = (left_f + right_f, left_h + right_h)
            out[monomial] = (
                out.get(monomial, Fraction(0))
                + left_coefficient * right_coefficient
            )
    return {monomial: coefficient for monomial, coefficient in out.items() if coefficient}


def determinant_three(matrix):
    positive = {}
    negative = {}
    for permutation in ((0, 1, 2), (1, 2, 0), (2, 0, 1)):
        term = {(0, 0): Fraction(1)}
        for row, column in enumerate(permutation):
            term = ring_multiply(term, matrix[row][column])
        positive = ring_add(positive, term)
    for permutation in ((0, 2, 1), (2, 1, 0), (1, 0, 2)):
        term = {(0, 0): Fraction(1)}
        for row, column in enumerate(permutation):
            term = ring_multiply(term, matrix[row][column])
        negative = ring_add(negative, term)
    return ring_add(
        positive,
        {monomial: -coefficient for monomial, coefficient in negative.items()},
    )


def build_data():
    tools = load_base()
    klein = tools.KLEIN_F
    raw_hessian = tools.transvectant(klein, klein, 2)
    hessian_content = reduce(gcd, (abs(value) for value in raw_hessian.values()))
    hessian = exact_divide(raw_hessian, hessian_content)
    raw_jacobian = tools.transvectant(klein, raw_hessian, 1)
    jacobian_content = reduce(gcd, (abs(value) for value in raw_jacobian.values()))
    jacobian = exact_divide(raw_jacobian, jacobian_content)
    raw_generators = [
        ("g2", 2, {(2, 0): 1}),
        ("g10", 10, tools.derivative(klein, 0, 2)),
        ("g12", 12, tools.transvectant({(2, 0): 1}, klein, 1)),
        ("g18", 18, tools.derivative(hessian, 0, 2)),
        ("g20", 20, tools.transvectant({(2, 0): 1}, hessian, 1)),
        ("g28", 28, tools.derivative(jacobian, 0, 2)),
    ]
    generators = []
    generator_contents = []
    for name, degree, generator in raw_generators:
        content = reduce(gcd, (abs(value) for value in generator.values()))
        generator_contents.append(content)
        generators.append((name, degree, exact_divide(generator, content)))
    if generator_contents != GENERATOR_CONTENTS:
        raise AssertionError("unexpected primitive covariant contents")
    return tools, klein, hessian, jacobian, generators


def candidates_of_degree(degree, klein, hessian, generators, tools):
    out = []
    for name, generator_degree, generator in generators:
        remainder = degree - generator_degree
        if remainder < 0:
            continue
        for h_power in range(remainder // 20 + 1):
            left = remainder - 20 * h_power
            if left % 12:
                continue
            f_power = left // 12
            coefficient = tools.multiply(
                polynomial_power(klein, f_power, tools),
                polynomial_power(hessian, h_power, tools),
            )
            out.append(
                (
                    name,
                    f_power,
                    h_power,
                    tools.multiply(coefficient, generator),
                )
            )
    return out


def transition_from_data(data, f_power, h_power, generator_index):
    tools, klein, hessian, _, generators = data
    name, degree, generator = generators[generator_index]
    coefficient = tools.multiply(
        polynomial_power(klein, f_power, tools),
        polynomial_power(hessian, h_power, tools),
    )
    source = tools.multiply(coefficient, generator)
    target = tools.transvectant(source, klein, 3)
    target_degree = degree + 12 * f_power + 20 * h_power + 6
    candidates = candidates_of_degree(
        target_degree,
        klein,
        hessian,
        generators,
        tools,
    )
    solution = solve_columns(
        [
            coefficient_vector(candidate, target_degree)
            for _, _, _, candidate in candidates
        ],
        coefficient_vector(target, target_degree),
    )
    return {
        "source": [name, f_power, h_power],
        "target_degree": target_degree,
        "terms": [
            [candidate_name, target_f, target_h, str(coefficient)]
            for (candidate_name, target_f, target_h, _), coefficient
            in zip(candidates, solution)
            if coefficient
        ],
    }


def transition(f_power, h_power, generator_index):
    return transition_from_data(build_data(), f_power, h_power, generator_index)


def explore(maximum_power):
    data = build_data()
    for generator_index in range(6):
        for f_power in range(maximum_power + 1):
            for h_power in range(maximum_power + 1 - f_power):
                print(
                    json.dumps(
                        transition_from_data(
                            data,
                            f_power,
                            h_power,
                            generator_index,
                        ),
                        sort_keys=True,
                    )
                )


def fit_operator_data(training_maximum, verification_maximum):
    data = build_data()
    _, _, _, _, generators = data
    names = [name for name, _, _ in generators]
    training_points = [
        (f_power, h_power)
        for f_power in range(training_maximum + 1)
        for h_power in range(training_maximum + 1)
    ]
    transitions = {}
    signatures = {generator_index: set() for generator_index in range(6)}
    for generator_index in range(6):
        for f_power, h_power in training_points:
            row = transition_from_data(
                data,
                f_power,
                h_power,
                generator_index,
            )
            terms = {}
            for target_name, target_f, target_h, coefficient in row["terms"]:
                signature = (
                    names.index(target_name),
                    target_f - f_power,
                    target_h - h_power,
                )
                terms[signature] = Fraction(coefficient)
                signatures[generator_index].add(signature)
            transitions[(generator_index, f_power, h_power)] = terms

    operator_terms = []
    for source_index in range(6):
        for target_index, f_shift, h_shift in sorted(signatures[source_index]):
            descriptors = []
            columns = []
            for f_order in range(4):
                for h_order in range(4 - f_order):
                    f_multiplier = f_shift + f_order
                    h_multiplier = h_shift + h_order
                    if f_multiplier < 0 or h_multiplier < 0:
                        continue
                    descriptors.append(
                        (
                            f_multiplier,
                            h_multiplier,
                            f_order,
                            h_order,
                        )
                    )
                    columns.append(
                        [
                            falling(f_power, f_order)
                            * falling(h_power, h_order)
                            for f_power, h_power in training_points
                        ]
                    )
            target = [
                transitions[(source_index, f_power, h_power)].get(
                    (target_index, f_shift, h_shift),
                    Fraction(0),
                )
                for f_power, h_power in training_points
            ]
            solution = solve_columns(columns, target)
            for descriptor, coefficient in zip(descriptors, solution):
                if coefficient:
                    operator_terms.append(
                        (
                            source_index,
                            target_index,
                            *descriptor,
                            coefficient,
                        )
                    )

    for source_index in range(6):
        for f_power in range(verification_maximum + 1):
            for h_power in range(verification_maximum + 1):
                actual_row = transition_from_data(
                    data,
                    f_power,
                    h_power,
                    source_index,
                )
                actual = {
                    (
                        names.index(target_name),
                        target_f,
                        target_h,
                    ): Fraction(coefficient)
                    for target_name, target_f, target_h, coefficient
                    in actual_row["terms"]
                }
                predicted = {}
                for (
                    term_source,
                    target_index,
                    f_multiplier,
                    h_multiplier,
                    f_order,
                    h_order,
                    coefficient,
                ) in operator_terms:
                    if term_source != source_index:
                        continue
                    scalar = (
                        coefficient
                        * falling(f_power, f_order)
                        * falling(h_power, h_order)
                    )
                    if not scalar:
                        continue
                    target_key = (
                        target_index,
                        f_power - f_order + f_multiplier,
                        h_power - h_order + h_multiplier,
                    )
                    predicted[target_key] = predicted.get(
                        target_key,
                        Fraction(0),
                    ) + scalar
                predicted = {
                    key: value for key, value in predicted.items() if value
                }
                if predicted != actual:
                    raise AssertionError(
                        "fitted Weyl operator failed verification at "
                        f"{names[source_index]} F^{f_power} H^{h_power}"
                    )

    return data, names, operator_terms


def fit_operator(training_maximum, verification_maximum):
    _, names, operator_terms = fit_operator_data(
        training_maximum,
        verification_maximum,
    )
    for source_index, source_name in enumerate(names):
        rows = []
        for (
            term_source,
            target_index,
            f_multiplier,
            h_multiplier,
            f_order,
            h_order,
            coefficient,
        ) in operator_terms:
            if term_source != source_index:
                continue
            rows.append(
                {
                    "target": names[target_index],
                    "coefficient": str(coefficient),
                    "F_multiplier": f_multiplier,
                    "H_multiplier": h_multiplier,
                    "dF_order": f_order,
                    "dH_order": h_order,
                }
            )
        print(
            json.dumps(
                {
                    "source": source_name,
                    "operator_terms": rows,
                    "training_grid": f"0..{training_maximum}",
                    "verification_grid": f"0..{verification_maximum}",
                },
                sort_keys=True,
            )
        )


def build_certificate():
    data, names, operator_terms = fit_operator_data(4, 6)
    tools, klein, hessian, jacobian, generators = data
    left = {"g2", "g10", "g18"}
    right = {"g12", "g20", "g28"}
    pairs = {
        (names[source_index], names[target_index])
        for (
            source_index,
            target_index,
            _,
            _,
            _,
            _,
            _,
        ) in operator_terms
    }
    expected_pairs = (
        {(source, target) for source in left for target in right}
        | {(source, target) for source in right for target in left}
    )
    if pairs != expected_pairs:
        raise AssertionError("the operator should have a complete 3-by-3 bipartite support")
    if any(
        (names[source_index] in left) == (names[target_index] in left)
        for (
            source_index,
            target_index,
            _,
            _,
            _,
            _,
            _,
        ) in operator_terms
    ):
        raise AssertionError("the finite presentation should be off diagonal")
    if any(coefficient.denominator != 1 for *_, coefficient in operator_terms):
        raise AssertionError("the primitive presentation should be integral")

    coefficient_gcd = reduce(
        gcd,
        (abs(int(coefficient)) for *_, coefficient in operator_terms),
    )
    if coefficient_gcd != 132:
        raise AssertionError("the primitive 3-covariant operator content should be 132")
    generator_actions = [
        transition_from_data(data, 0, 0, generator_index)
        for generator_index in range(6)
    ]
    normalized_generator_actions = []
    for action in generator_actions:
        normalized_generator_actions.append(
            {
                **action,
                "terms": [
                    [
                        target,
                        f_power,
                        h_power,
                        str(Fraction(coefficient) / coefficient_gcd),
                    ]
                    for target, f_power, h_power, coefficient in action["terms"]
                ],
            }
        )
    dark_hg2 = transition_from_data(data, 0, 1, 0)
    dark_fg10 = transition_from_data(data, 1, 0, 1)
    if (
        dark_hg2["terms"] != [["g28", 0, 0, "-13200"]]
        or dark_fg10["terms"] != [["g28", 0, 0, "13200"]]
    ):
        raise AssertionError("unexpected degree-22 Koszul pair")

    serialized_terms = []
    for (
        source_index,
        target_index,
        f_multiplier,
        h_multiplier,
        f_order,
        h_order,
        coefficient,
    ) in operator_terms:
        serialized_terms.append(
            {
                "source": names[source_index],
                "target": names[target_index],
                "coefficient": str(coefficient / coefficient_gcd),
                "F_multiplier": f_multiplier,
                "h_multiplier": h_multiplier,
                "dF_order": f_order,
                "dh_order": h_order,
            }
        )

    principal_by_pair = {}
    for term in serialized_terms:
        if term["dF_order"] + term["dh_order"] != 3:
            continue
        pair = (term["source"], term["target"])
        principal_by_pair.setdefault(pair, []).append(term)
    if sum(len(terms) for terms in principal_by_pair.values()) != 45:
        raise AssertionError("unexpected number of principal-symbol terms")
    symbol_multipliers = {}
    for pair in sorted(pairs):
        terms = principal_by_pair.get(pair, [])
        if not terms:
            symbol_multipliers[pair] = {}
            continue
        cubic_term = next(
            (
                term
                for term in terms
                if term["dF_order"] == 3 and term["dh_order"] == 0
            ),
            None,
        )
        if cubic_term is None:
            raise AssertionError("principal entry lacks its dF-cubed term")
        coefficient = Fraction(cubic_term["coefficient"]) / 2
        f_power = cubic_term["F_multiplier"] - 1
        h_power = cubic_term["h_multiplier"]
        expected = {
            (f_power + 1, h_power, 3, 0): 2 * coefficient,
            (f_power, h_power + 1, 2, 1): 5 * coefficient,
            (f_power + 3, h_power, 0, 3): -8000 * coefficient,
        }
        actual = {
            (
                term["F_multiplier"],
                term["h_multiplier"],
                term["dF_order"],
                term["dh_order"],
            ): Fraction(term["coefficient"])
            for term in terms
        }
        if actual != expected:
            raise AssertionError("principal entry is not a multiple of the cubic symbol")
        symbol_multipliers[pair] = {
            (f_power, h_power): coefficient
        }

    left_order = ["g2", "g10", "g18"]
    right_order = ["g12", "g20", "g28"]
    left_to_right = [
        [symbol_multipliers[(source, target)] for target in right_order]
        for source in left_order
    ]
    right_to_left = [
        [symbol_multipliers[(source, target)] for target in left_order]
        for source in right_order
    ]
    left_determinant = determinant_three(left_to_right)
    right_determinant = determinant_three(right_to_left)
    if left_determinant != {
        (0, 3): Fraction(-200),
        (5, 0): Fraction(345_600),
    }:
        raise AssertionError("wrong left principal determinant")
    if right_determinant != {
        (0, 6): Fraction(5_000),
        (5, 3): Fraction(-17_280_000),
        (10, 0): Fraction(14_929_920_000),
    }:
        raise AssertionError("wrong right principal determinant")
    klein_relation = ring_add(
        ring_add(
            tools.multiply(jacobian, jacobian),
            tools.multiply(
                tools.multiply(hessian, hessian),
                hessian,
            ),
        ),
        {
            monomial: -1728 * coefficient
            for monomial, coefficient in polynomial_power(
                klein,
                5,
                tools,
            ).items()
        },
    )
    if klein_relation:
        raise AssertionError("unexpected primitive Klein relation")

    def serialize_ring_element(polynomial):
        return [
            {
                "coefficient": str(coefficient),
                "F_power": f_power,
                "h_power": h_power,
            }
            for (f_power, h_power), coefficient in sorted(polynomial.items())
        ]

    return {
        "schema": "c682-klein-e8-free-covariant-v1",
        "field": "Q",
        "invariants": {
            "F": "Phi_12",
            "h": "(F,F)_2/242",
            "t": "(F,(F,F)_2)_1/4840",
            "coefficient_ring": "Q[F,h]",
        },
        "operator": {
            "raw_Delta": "(.,F)_3",
            "primitive_D": "Delta/132",
            "coefficient_order": 3,
            "normal_order": (
                "coefficient * F^u h^v dF^r dh^s, "
                "with derivatives acting on the coefficient-ring input"
            ),
            "raw_presentation_content": coefficient_gcd,
            "primitive_presentation_content": 1,
        },
        "free_3_covariant_basis": [
            {
                "name": name,
                "degree": degree,
                "primitive_content": content,
            }
            for (name, degree, _), content
            in zip(generators, GENERATOR_CONTENTS)
        ],
        "basis_definitions_on_q_equals_X2": {
            "g2": "X^2",
            "g10": "F_YY/110",
            "g12": "(X^2,F)_1/2",
            "g18": "h_YY/380",
            "g20": "(X^2,h)_1/40",
            "g28": "t_YY/870",
        },
        "bipartite_structure": {
            "left": sorted(left),
            "right": sorted(right),
            "nonzero_directed_pairs": [list(pair) for pair in sorted(pairs)],
            "conclusion": "Delta is an off-diagonal 3-by-3 block Weyl operator.",
        },
        "principal_symbol": {
            "scalar_cubic": (
                "p=2 F xi^3 + 5 h xi^2 eta - 8000 F^3 eta^3"
            ),
            "third_order_term_count": 45,
            "multiplier_matrix_left_to_right": [
                [serialize_ring_element(entry) for entry in row]
                for row in left_to_right
            ],
            "multiplier_matrix_right_to_left": [
                [serialize_ring_element(entry) for entry in row]
                for row in right_to_left
            ],
            "left_determinant": "-200*(h^3-1728 F^5)",
            "right_determinant": "5000*(h^3-1728 F^5)^2",
            "primitive_Klein_relation": "t^2=1728 F^5-h^3",
            "full_characteristic_determinant": (
                "1000000*p^6*(h^3-1728 F^5)^3"
            ),
            "intrinsic_characteristic_determinant": "-1000000*p^6*t^6",
            "characteristic_components": ["p=0", "t=0"],
        },
        "operator_term_count": len(serialized_terms),
        "operator_terms": serialized_terms,
        "action_on_free_generators_for_D": normalized_generator_actions,
        "degree_22_koszul_specialization": {
            "D(h g2)": "-100 g28",
            "D(F g10)": "100 g28",
            "dark_line": "h g2 + F g10",
            "bright_line": "F g10 - h g2",
            "D(bright_line)": "200 g28",
            "first_jet_row_to_g28": "100*(-d_h, d_F)",
        },
        "proof": {
            "training_grid": "0<=a,b<=4",
            "verification_grid": "0<=a,b<=6",
            "reason_global": (
                "The third transvectant differentiates the coefficient "
                "F^a h^b at most three times. Each fixed degree shift "
                "therefore has a polynomial coefficient of total degree "
                "at most three in the falling factorials (a)_r(b)_s. "
                "The exact grid determines these coefficients and the "
                "larger exact grid independently verifies them."
            ),
        },
        "claim_boundary": [
            "This is the complete Weyl-operator presentation on the 3-covariant block.",
            "The other eight binary-icosahedral covariant blocks are not yet presented.",
            "No later-weight saturation classification is inferred without corner analysis.",
            "The presentation uses ordinary derivatives in characteristic zero.",
        ],
    }


def canonical_json(data):
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def main():
    parser = argparse.ArgumentParser()
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--explore", type=int, metavar="MAX_POWER")
    mode.add_argument("--fit", action="store_true")
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    arguments = parser.parse_args()
    if arguments.fit:
        fit_operator(4, 6)
    elif arguments.explore is not None:
        explore(arguments.explore)
    else:
        rendered = canonical_json(build_certificate())
        if arguments.write:
            CERTIFICATE.write_text(rendered, encoding="utf-8")
            print(CERTIFICATE)
        elif not CERTIFICATE.exists():
            raise SystemExit(f"missing certificate: {CERTIFICATE}")
        elif CERTIFICATE.read_text(encoding="utf-8") != rendered:
            raise SystemExit("certificate is stale")
        else:
            print("c682 Klein E8 free-covariant presentation: PASS")


if __name__ == "__main__":
    main()
