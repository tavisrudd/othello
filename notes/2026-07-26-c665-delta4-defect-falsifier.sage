#!/usr/bin/env sage
"""Independent evaluation-functional falsifier for the C665 torus defect.

This route never constructs the affine coefficient space or its full
quadratic moment matrix.  It evaluates matching products at sixteen fixed
off-conic points, forms translation norms directly, and interpolates their
dependence on the squared axis separation.
"""

import argparse
import json
from pathlib import Path

from sage.all import GF, matrix


HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c665-delta4-defect-falsifier.json"


def calculate(q):
    assert q in (27, 243)
    k = GF(q, name="a")
    primitive = k.multiplicative_generator()
    n = (q - 1) // 2
    squares = sorted({value**2 for value in k if value})
    assert len(squares) == n
    c = primitive
    assert c not in squares

    def edges(parameter):
        answer = [((k(0), k(1)), (k(1), k(0)))]
        answer.extend(
            ((value, k(1)), (parameter * value, k(1)))
            for value in squares
        )
        return answer

    plus_edges = edges(c)
    minus_edges = edges(c**-1)
    evaluation_points = [
        (k(1), value, value**2 + 1)
        for value in list(k)[:16]
    ]
    assert all(X * Z - Y**2 == 1 for X, Y, Z in evaluation_points)

    def direct_product_values(matching, entries):
        aa, bb, cc, dd = entries
        answers = [k(1)] * len(evaluation_points)
        for (s1, t1), (s2, t2) in matching:
            u1, v1 = aa * s1 + bb * t1, cc * s1 + dd * t1
            u2, v2 = aa * s2 + bb * t2, cc * s2 + dd * t2
            coefficients = (v1 * v2, -(u1 * v2 + v1 * u2), u1 * u2)
            for index, (X, Y, Z) in enumerate(evaluation_points):
                answers[index] *= (
                    coefficients[0] * X
                    + coefficients[1] * Y
                    + coefficients[2] * Z
                )
        return answers

    def dickson_product_value(parameter, X, Y, Z):
        recurrence = matrix(
            k,
            [
                [(1 + parameter) * Y, -parameter * X * Z],
                [1, 0],
            ],
        )
        homogeneous_dickson = (recurrence**n).trace()
        return -Y * (
            X**n + (parameter * Z) ** n - homogeneous_dickson
        )

    def product_values(parameter, entries):
        aa, bb, cc, dd = entries
        answers = []
        for X, Y, Z in evaluation_points:
            transformed_Z = (
                aa * (Z * aa - Y * cc)
                + cc * (-Y * aa + X * cc)
            )
            transformed_minus_Y = (
                aa * (Z * bb - Y * dd)
                + cc * (-Y * bb + X * dd)
            )
            transformed_X = (
                bb * (Z * bb - Y * dd)
                + dd * (-Y * bb + X * dd)
            )
            answers.append(
                dickson_product_value(
                    parameter,
                    transformed_X,
                    -transformed_minus_Y,
                    transformed_Z,
                )
            )
        return answers

    identity = (k(1), k(0), k(0), k(1))
    reference = product_values(c, identity)
    assert reference == direct_product_values(plus_edges, identity)
    assert product_values(c**-1, identity) == direct_product_values(
        minus_edges, identity
    )
    functional_count = len(evaluation_points) + 1
    pair_indices = [
        (left, right)
        for left in range(functional_count)
        for right in range(left, functional_count)
    ]
    columns = []
    plus_columns = []
    axis_parameters = []
    for delta in squares:
        plus_moments = [k(0)] * len(pair_indices)
        minus_moments = [k(0)] * len(pair_indices)
        for translation in k:
            entries = (
                translation + delta,
                translation,
                k(1),
                k(1),
            )
            plus_values = [k(1)] + [
                value - base
                for value, base in zip(
                    product_values(c, entries), reference
                )
            ]
            minus_values = [k(1)] + [
                value - base
                for value, base in zip(
                    product_values(c**-1, entries), reference
                )
            ]
            for index, (left, right) in enumerate(pair_indices):
                plus_moments[index] += (
                    plus_values[left] * plus_values[right]
                )
                minus_moments[index] += (
                    minus_values[left] * minus_values[right]
                )
        columns.append(
            [
                minus_value - plus_value
                for plus_value, minus_value in zip(
                    plus_moments, minus_moments
                )
            ]
        )
        plus_columns.append(plus_moments)
        axis_parameters.append(delta**2)

    plus_moments = [k(0)] * len(pair_indices)
    minus_moments = [k(0)] * len(pair_indices)
    for translation in k:
        entries = (k(1), translation, k(0), k(1))
        plus_values = [k(1)] + [
            value - base
            for value, base in zip(product_values(c, entries), reference)
        ]
        minus_values = [k(1)] + [
            value - base
            for value, base in zip(
                product_values(c**-1, entries), reference
            )
        ]
        for index, (left, right) in enumerate(pair_indices):
            plus_moments[index] += plus_values[left] * plus_values[right]
            minus_moments[index] += (
                minus_values[left] * minus_values[right]
            )
    columns.append(
        [
            minus_value - plus_value
            for plus_value, minus_value in zip(
                plus_moments, minus_moments
            )
        ]
    )
    plus_columns.append(plus_moments)

    correction = matrix(k, columns).transpose()
    plus_norms = matrix(k, plus_columns).transpose()
    minus_norms = plus_norms + correction
    joint_norms = plus_norms.augment(minus_norms)
    vandermonde = matrix(
        k,
        [
            [parameter**degree for degree in range(n)]
            for parameter in axis_parameters
        ],
    )
    coefficients = vandermonde.solve_right(
        correction[:, :n].transpose()
    )
    support = [
        degree
        for degree in range(n)
        if not coefficients.row(degree).is_zero()
    ]
    expected_support = [0, 1] + list(range(n - 4, n))
    if q == 27:
        assert support == expected_support, support
        assert correction.rank() == 6
    return {
        "q": q,
        "field_modulus": str(k.modulus()),
        "matching_parameter_exponent": int(c.log(primitive)),
        "evaluation_point_count": len(evaluation_points),
        "moment_row_count": len(pair_indices),
        "finite_axis_parameter_count": len(axis_parameters),
        "axis_orbit_count": len(axis_parameters) + 1,
        "projected_plus_norm_rank": int(plus_norms.rank()),
        "projected_joint_norm_rank": int(joint_norms.rank()),
        "projected_defect_increment": (
            int(joint_norms.rank() - plus_norms.rank())
        ),
        "projection_disproves_lambda_plus_five": (
            joint_norms.rank() > n + 1 + 5
        ),
        "correction_rank": int(correction.rank()),
        "interpolation_support": support,
        "q27_reference_support": [0, 1] + list(range(n - 4, n)),
        "matches_q27_six_character_pattern": (
            support == [0, 1] + list(range(n - 4, n))
        ),
        "matching_product_crosscheck": (
            "Dickson recurrence agrees with direct secant-factor "
            "multiplication at both base parameters"
        ),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, choices=(27, 243))
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--write", action="store_true")
    mode.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.q is not None:
        assert not args.write and not args.check
        result = calculate(args.q)
    else:
        records = [calculate(q) for q in (27, 243)]
        assert records[0]["projected_plus_norm_rank"] == 14
        assert records[0]["projected_joint_norm_rank"] == 19
        assert records[0]["projected_defect_increment"] == 5
        assert records[1]["projected_plus_norm_rank"] == 122
        assert records[1]["projected_joint_norm_rank"] == 136
        assert records[1]["projected_defect_increment"] == 14
        result = {
            "schema": 1,
            "verdict": (
                "the q=27 five-dimensional defect does not extend "
                "uniformly: a q=243 moment projection already has "
                "defect increment 14"
            ),
            "records": records,
        }
    encoded = json.dumps(
        result, default=int, indent=2, sort_keys=True
    ) + "\n"
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
