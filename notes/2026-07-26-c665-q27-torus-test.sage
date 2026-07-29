#!/usr/bin/env sage
"""Exact first characteristic-three torus test for the C665 Platinum gap.

Besides the full quadratic ranks, this checks the fixed-correction identity,
the one-sheet/joint Sylow-translation norm ranks, and the
discriminant-weight-four trade on every split torus orbit.  It also resolves
the nine-dimensional translation-fixed trade space into seven finite-axis
Fourier trades and a two-dimensional trivial-character corner.
"""

import argparse
import json
from pathlib import Path

from sage.all import GF, PolynomialRing, matrix, vector


q = 27
k = GF(q, name="a")
a = k.gen()
HERE = Path(__file__).resolve().parent
CERTIFICATE = HERE / "2026-07-26-c665-q27-torus-test.json"
points = tuple(k) + (None,)
point_index = {x: i for i, x in enumerate(points)}
infinity = q


def mobius(entries, x):
    aa, bb, cc, dd = map(k, entries)
    if x is None:
        return None if cc == 0 else aa / cc
    denominator = cc * x + dd
    return None if denominator == 0 else (aa * x + bb) / denominator


def permutation(entries):
    return tuple(point_index[mobius(entries, x)] for x in points)


def image(g, matching):
    return tuple(sorted(tuple(sorted((g[x], g[y]))) for x, y in matching))


def generated_orbit(generators, base):
    seen = {base}
    frontier = [base]
    while frontier:
        matching = frontier.pop()
        for generator in generators:
            target = image(generator, matching)
            if target not in seen:
                seen.add(target)
                frontier.append(target)
    return sorted(seen)


def generated_labeled_orbit(generators, base, base_axis):
    labels = {base: base_axis}
    frontier = [base]
    while frontier:
        matching = frontier.pop()
        axis = labels[matching]
        for generator in generators:
            target = image(generator, matching)
            target_axis = tuple(sorted(generator[x] for x in axis))
            if target in labels:
                assert labels[target] == target_axis
            else:
                labels[target] = target_axis
                frontier.append(target)
    return labels


translation_one = permutation((1, 1, 0, 1))
translation_a = permutation((1, a, 0, 1))
translation_a2 = permutation((1, a**2, 0, 1))
inversion = permutation((0, -1, 1, 0))
square_dilation = permutation((a**2, 0, 0, 1))
outer_dilation = permutation((a, 0, 0, 1))
h_generators = (translation_one, translation_a, inversion, square_dilation)
g_generators = h_generators + (outer_dilation,)
translation_generators = (translation_one, translation_a, translation_a2)

squares = sorted({x**2 for x in k if x != 0})
base = tuple(
    sorted(
        [(point_index[k(0)], infinity)]
        + [
            tuple(sorted((point_index[x], point_index[a * x])))
            for x in squares
        ]
    )
)
assert len({vertex for edge in base for vertex in edge}) == q + 1

h_orbit = generated_orbit(h_generators, base)
g_orbit = generated_orbit(g_generators, base)
outer_image = image(outer_dilation, base)
other_h_orbit = generated_orbit(h_generators, outer_image)
assert set(g_orbit) == set(h_orbit) | set(other_h_orbit)
assert set(h_orbit).isdisjoint(other_h_orbit)
torus_parameters = [
    c for c in k if c != 0 and c not in squares
]
torus_matchings = [
    tuple(
        sorted(
            [(point_index[k(0)], infinity)]
            + [
                tuple(sorted((point_index[x], point_index[c * x])))
                for x in squares
            ]
        )
    )
    for c in torus_parameters
]

R = PolynomialRing(k, names=("X", "Y", "Z"))
X, Y, Z = R.gens()
endpoint_vectors = tuple((x, k(1)) for x in k) + ((k(1), k(0)),)
conic = X * Z - Y**2


def matching_product(matching):
    answer = R.one()
    for left, right in matching:
        si, ti = endpoint_vectors[left]
        sj, tj = endpoint_vectors[right]
        answer *= ti * tj * X - (si * tj + ti * sj) * Y + si * sj * Z
    return answer


def axis_digit_values(axis):
    left, right = axis
    si, ti = endpoint_vectors[left]
    sj, tj = endpoint_vectors[right]
    quadratic = (
        ti * tj,
        -(si * tj + ti * sj),
        si * sj,
    )
    return tuple(
        value * frobenius**3
        for value in quadratic
        for frobenius in quadratic
    )


degree = (q - 3) // 2
monomials = tuple(
    X**i * Y**j * Z ** (degree - i - j)
    for i in range(degree + 1)
    for j in range(degree - i + 1)
)


def evaluate(representative, orbit, orbit_number):
    base_axis = (point_index[k(0)], infinity)
    plus_labels = generated_labeled_orbit(
        h_generators, representative, base_axis
    )
    minus_representative = image(outer_dilation, representative)
    minus_labels = generated_labeled_orbit(
        h_generators, minus_representative, base_axis
    )
    h_part = sorted(plus_labels)
    split = len(orbit) == 2 * len(h_part)
    if split:
        assert set(orbit) == set(plus_labels) | set(minus_labels)
        assert set(plus_labels).isdisjoint(minus_labels)
    reference = matching_product(orbit[0])
    quotients = []
    for index, matching in enumerate(orbit):
        difference = matching_product(matching) - reference
        quotient, remainder = difference.quo_rem(conic)
        assert remainder == 0
        quotients.append(quotient)

    affine = matrix(
        k,
        [[1] * len(orbit)]
        + [[quotient.monomial_coefficient(monomial) for quotient in quotients]
           for monomial in monomials],
    )
    linear = affine.row_space().basis_matrix()
    square = matrix(
        k,
        [
            linear.row(i).pairwise_product(linear.row(j))
            for i in range(linear.nrows())
            for j in range(i, linear.nrows())
        ],
    )
    square_rank = square.rank()
    if split:
        incidence_difference = matrix(k, q + 1, len(orbit), sparse=True)
        axis_digit_difference = matrix(k, 9, len(orbit), sparse=True)
        weight_four_plus = matrix(k, 1, len(orbit), sparse=True)
        weight_four_difference = matrix(k, 1, len(orbit), sparse=True)
        orbit_index = {matching: i for i, matching in enumerate(orbit)}
        for matching, axis in plus_labels.items():
            for endpoint in axis:
                incidence_difference[endpoint, orbit_index[matching]] += 1
            for row, value in enumerate(axis_digit_values(axis)):
                axis_digit_difference[row, orbit_index[matching]] += value
            if infinity not in axis:
                left, right = axis
                separation = points[left] - points[right]
                weight_four_plus[0, orbit_index[matching]] += (
                    separation**-4
                )
                weight_four_difference[0, orbit_index[matching]] += (
                    separation**-4
                )
        for matching, axis in minus_labels.items():
            for endpoint in axis:
                incidence_difference[endpoint, orbit_index[matching]] -= 1
            for row, value in enumerate(axis_digit_values(axis)):
                axis_digit_difference[row, orbit_index[matching]] -= value
            if infinity not in axis:
                left, right = axis
                separation = points[left] - points[right]
                weight_four_difference[0, orbit_index[matching]] -= (
                    separation**-4
                )
        incidence_moments = square * incidence_difference.transpose()
        incidence_parameter_kernel = incidence_moments.right_kernel()
        incidence_trade_coefficients = (
            incidence_parameter_kernel.basis_matrix()
            * incidence_difference
        )
        axis_incidence = {
            "coefficient_family_rank": incidence_difference.rank(),
            "trade_parameter_dimension": (
                incidence_parameter_kernel.dimension()
            ),
            "trade_family_rank": incidence_trade_coefficients.rank(),
        }
        axis_digit_moments = square * axis_digit_difference.transpose()
        axis_digit_parameter_kernel = axis_digit_moments.right_kernel()
        axis_digit_trade_coefficients = (
            axis_digit_parameter_kernel.basis_matrix()
            * axis_digit_difference
        )
        axis_digit = {
            "coefficient_family_rank": axis_digit_difference.rank(),
            "moment_rank": axis_digit_moments.rank(),
            "trade_parameter_dimension": (
                axis_digit_parameter_kernel.dimension()
            ),
            "trade_family_rank": axis_digit_trade_coefficients.rank(),
        }
        weight_four_plus_moments = square * weight_four_plus.transpose()
        weight_four_moments = square * weight_four_difference.transpose()
        assert not weight_four_plus_moments.is_zero()
        assert weight_four_moments.is_zero()

        def act_on_coefficients(coefficients, generator):
            answer = vector(k, len(orbit))
            for source, matching in enumerate(orbit):
                target = orbit_index[image(generator, matching)]
                answer[target] = coefficients[source]
            return answer

        weight_four_span = [weight_four_difference.row(0)]
        while True:
            candidates = weight_four_span + [
                act_on_coefficients(coefficients, generator)
                for coefficients in weight_four_span
                for generator in h_generators
            ]
            enlarged = list(matrix(k, candidates).row_space().basis())
            if len(enlarged) == len(weight_four_span):
                break
            weight_four_span = enlarged
        assert len(weight_four_span) == 9
        assert (
            square * matrix(k, weight_four_span).transpose()
        ).is_zero()
        weight_four_trade = {
            "axis_weight": "(x-y)^-4 on finite axes; 0 at infinity",
            "common_moment_rank": weight_four_plus_moments.rank(),
            "difference_moment_rank": weight_four_moments.rank(),
            "h_span_dimension": len(weight_four_span),
        }
    else:
        axis_incidence = None
        axis_digit = None
        weight_four_trade = None
    translation_orbits = []
    unseen = set(orbit)
    while unseen:
        matching = min(unseen)
        part = generated_orbit(translation_generators, matching)
        assert len(part) == q
        translation_orbits.append(part)
        unseen -= set(part)
    orbit_index = {matching: i for i, matching in enumerate(orbit)}
    norm_images = matrix(
        k,
        [
            [
                sum(
                    linear[i, orbit_index[matching]]
                    * linear[j, orbit_index[matching]]
                    for matching in part
                )
                for part in translation_orbits
            ]
            for i in range(linear.nrows())
            for j in range(i, linear.nrows())
        ],
    )
    if split:
        sheet_sets = [set(h_part), set(orbit) - set(h_part)]
        orbit_sheet = [
            next(
                i
                for i, sheet_set in enumerate(sheet_sets)
                if part[0] in sheet_set
            )
            for part in translation_orbits
        ]
        sheet_columns = [
            [j for j, value in enumerate(orbit_sheet) if value == i]
            for i in range(2)
        ]
        sheet_norm_ranks = [
            norm_images[:, columns].rank() for columns in sheet_columns
        ]
        joint_norm_rank = norm_images.rank()
        norm_rank_increment = joint_norm_rank - sheet_norm_ranks[0]
        invariant_trade_dimension = (
            len(translation_orbits) - joint_norm_rank
        )
        plus_columns = list(norm_images[:, sheet_columns[0]].columns())
        quotient_source_columns = []
        combined_basis = list(plus_columns)
        combined_rank = matrix(k, combined_basis).transpose().rank()
        for column_index in sheet_columns[1]:
            candidate = norm_images.column(column_index)
            trial = matrix(k, combined_basis + [candidate]).transpose()
            trial_rank = trial.rank()
            if trial_rank > combined_rank:
                quotient_source_columns.append(column_index)
                combined_basis.append(candidate)
                combined_rank = trial_rank
        assert len(quotient_source_columns) == norm_rank_increment
        combined_basis_matrix = matrix(k, combined_basis).transpose()
        translation_part_index = {
            matching: index
            for index, part in enumerate(translation_orbits)
            for matching in part
        }
        quotient_action = matrix(
            k, norm_rank_increment, norm_rank_increment
        )
        for column, source_index in enumerate(quotient_source_columns):
            target_matching = image(
                square_dilation, translation_orbits[source_index][0]
            )
            target_index = translation_part_index[target_matching]
            coordinates = combined_basis_matrix.solve_right(
                norm_images.column(target_index)
            )
            quotient_action[:, column] = coordinates[
                len(plus_columns):
            ]
        quotient_roots = quotient_action.charpoly().roots()
        assert sum(multiplicity for _, multiplicity in quotient_roots) == 5
        defect_quotient = {
            "dimension": norm_rank_increment,
            "square_torus_charpoly": str(quotient_action.charpoly()),
            "square_torus_eigenvalue_exponents": sorted(
                [
                    int(root.log(a))
                    for root, multiplicity in quotient_roots
                    for _ in range(multiplicity)
                ]
            ),
        }

        part_axes = []
        for part, sheet in zip(translation_orbits, orbit_sheet):
            labels = plus_labels if sheet == 0 else minus_labels
            axis = labels[part[0]]
            if infinity in axis:
                part_axes.append(None)
            else:
                left, right = axis
                part_axes.append((points[left] - points[right])**2)
        axis_columns = {
            (sheet, axis): column
            for column, (sheet, axis) in enumerate(
                zip(orbit_sheet, part_axes)
            )
        }
        assert len(axis_columns) == 2 * (len(squares) + 1)
        assert all(
            (sheet, axis) in axis_columns
            for sheet in range(2)
            for axis in tuple(squares) + (None,)
        )

        correction_fourier_moments = []
        finite_axis_trade_exponents = []
        for exponent in range(len(squares)):
            coefficients = vector(k, len(translation_orbits))
            for axis in squares:
                weight = axis**(-exponent)
                coefficients[axis_columns[(0, axis)]] = weight
                coefficients[axis_columns[(1, axis)]] = -weight
            moment = norm_images * coefficients
            correction_fourier_moments.append(moment)
            if moment.is_zero():
                finite_axis_trade_exponents.append(exponent)
        correction_fourier_support = [
            exponent
            for exponent, moment in enumerate(correction_fourier_moments)
            if not moment.is_zero()
        ]
        assert correction_fourier_support == [0, 8, 9, 10, 11, 12], (
            correction_fourier_support
        )
        assert finite_axis_trade_exponents == [1, 2, 3, 4, 5, 6, 7], (
            finite_axis_trade_exponents
        )

        trivial_columns = [
            sum(
                (
                    norm_images.column(axis_columns[(sheet, axis)])
                    for axis in squares
                ),
                vector(k, norm_images.nrows()),
            )
            for sheet in range(2)
        ]
        trivial_columns = [
            trivial_columns[0],
            norm_images.column(axis_columns[(0, None)]),
            trivial_columns[1],
            norm_images.column(axis_columns[(1, None)]),
        ]
        trivial_moment_matrix = matrix(k, trivial_columns).transpose()
        trivial_kernel = trivial_moment_matrix.right_kernel()
        assert trivial_kernel.dimension() == 2
        sign_relation = vector(k, [1, 1, -1, -1])
        assert sign_relation in trivial_kernel
        other_relation = next(
            relation
            for relation in trivial_kernel.basis()
            if matrix(k, [sign_relation, relation]).rank() == 2
        )
        other_relation -= other_relation[0] * sign_relation
        pivot = next(entry for entry in other_relation if entry)
        other_relation /= pivot
        assert other_relation == vector(k, [0, 1, -1, 0])
        trivial_corner = {
            "basis_order": [
                "plus_finite_sum",
                "plus_infinity",
                "minus_finite_sum",
                "minus_infinity",
            ],
            "dimension": trivial_kernel.dimension(),
            "sign_relation": [str(entry) for entry in sign_relation],
            "mixed_relation": [str(entry) for entry in other_relation],
        }
        invariant_trade_decomposition = {
            "finite_axis_fourier_trade_exponents": (
                finite_axis_trade_exponents
            ),
            "correction_fourier_support_exponents": (
                correction_fourier_support
            ),
            "trivial_character_corner": trivial_corner,
            "dimension_check": (
                len(finite_axis_trade_exponents)
                + trivial_kernel.dimension()
            ),
        }
    else:
        sheet_norm_ranks = None
        joint_norm_rank = norm_images.rank()
        norm_rank_increment = None
        invariant_trade_dimension = (
            len(translation_orbits) - joint_norm_rank
        )
        defect_quotient = None
        invariant_trade_decomposition = None
    return {
        "orbit_number": orbit_number,
        "g_orbit_size": len(orbit),
        "split": split,
        "h_orbit_size": len(h_part),
        "lambda": len(h_part) // q if split else None,
        "affine_rank": linear.nrows(),
        "square_rows": square.nrows(),
        "square_rank": square_rank,
        "trade_dimension": len(orbit) - square_rank,
        "translation_orbit_count": len(translation_orbits),
        "sheet_norm_ranks": sheet_norm_ranks,
        "joint_norm_rank": joint_norm_rank,
        "norm_rank_increment": norm_rank_increment,
        "invariant_trade_dimension": invariant_trade_dimension,
        "defect_quotient": defect_quotient,
        "invariant_trade_decomposition": invariant_trade_decomposition,
        "axis_incidence_difference": axis_incidence,
        "axis_l2_tensor_frobenius_difference": axis_digit,
        "axis_weight_four_difference": weight_four_trade,
    }


def calculate():
    n = (q - 1) // 2
    correction = Y * (X**n - Z**n)
    for c, matching in zip(torus_parameters, torus_matchings):
        inverse_matching = torus_matchings[
            torus_parameters.index(c**-1)
        ]
        assert (
            matching_product(matching)
            + matching_product(inverse_matching)
            == correction
        )
    remaining = set(torus_matchings)
    torus_orbits = []
    while remaining:
        representative = min(remaining)
        orbit = generated_orbit(g_generators, representative)
        torus_orbits.append((representative, orbit))
        remaining -= set(orbit)
    records = [
        evaluate(representative, orbit, orbit_number)
        for orbit_number, (representative, orbit) in enumerate(
            torus_orbits, start=1
        )
    ]
    split_records = [record for record in records if record["split"]]
    assert len(split_records) == 6
    assert all(
        record["sheet_norm_ranks"] == [14, 14]
        and record["joint_norm_rank"] == 19
        and record["norm_rank_increment"] == 5
        and record["invariant_trade_dimension"] == 9
        and record["axis_incidence_difference"]["trade_family_rank"] == 1
        and record["axis_l2_tensor_frobenius_difference"][
            "trade_family_rank"
        ] == 0
        and record["axis_weight_four_difference"][
            "common_moment_rank"
        ] == 1
        and record["axis_weight_four_difference"][
            "difference_moment_rank"
        ] == 0
        and record["axis_weight_four_difference"][
            "h_span_dimension"
        ] == 9
        for record in split_records
    )
    return {
        "schema": 4,
        "q": q,
        "field_modulus": str(k.modulus()),
        "torus_matching_count": len(torus_matchings),
        "torus_g_orbit_count": len(torus_orbits),
        "fixed_correction_identity": {
            "parameters_checked": len(torus_parameters),
            "correction": "Y*(X^13-Z^13)",
            "passed": True,
        },
        "replacement_gate": (
            "the former lambda+1 and rank-one defect bounds fail; "
            "all split orbits have defect increment 5 and nine "
            "translation-invariant trades"
        ),
        "records": records,
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
