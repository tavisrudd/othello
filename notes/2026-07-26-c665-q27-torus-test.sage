#!/usr/bin/env sage
"""Exact first characteristic-three torus test for the C665 Platinum gap.

Besides the full quadratic ranks, this checks the fixed-correction identity
and the one-sheet/joint Sylow-translation norm ranks on every torus orbit.
"""

import argparse
import json
from pathlib import Path

from sage.all import GF, PolynomialRing, matrix


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
        orbit_index = {matching: i for i, matching in enumerate(orbit)}
        for matching, axis in plus_labels.items():
            for endpoint in axis:
                incidence_difference[endpoint, orbit_index[matching]] += 1
            for row, value in enumerate(axis_digit_values(axis)):
                axis_digit_difference[row, orbit_index[matching]] += value
        for matching, axis in minus_labels.items():
            for endpoint in axis:
                incidence_difference[endpoint, orbit_index[matching]] -= 1
            for row, value in enumerate(axis_digit_values(axis)):
                axis_digit_difference[row, orbit_index[matching]] -= value
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
    else:
        axis_incidence = None
        axis_digit = None
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
    else:
        sheet_norm_ranks = None
        joint_norm_rank = norm_images.rank()
        norm_rank_increment = None
        invariant_trade_dimension = (
            len(translation_orbits) - joint_norm_rank
        )
        defect_quotient = None
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
        "axis_incidence_difference": axis_incidence,
        "axis_l2_tensor_frobenius_difference": axis_digit,
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
        for record in split_records
    )
    return {
        "schema": 1,
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
