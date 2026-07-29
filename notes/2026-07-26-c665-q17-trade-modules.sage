#!/usr/bin/env sage
"""Decompose the certified q=17 split competitors and their trade modules."""

import argparse
import importlib.util
from pathlib import Path

from sage.all import GF, matrix
from sage.libs.gap.libgap import libgap


HERE = Path(__file__).resolve().parent
Q = 17
F = GF(Q)


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load("c665_base", HERE / "2026-07-26-c665-balanced-matching-completeness.py")
PLATINUM = load("c665_platinum", HERE / "2026-07-26-c665-platinum-falsifier.py")


def generator_permutations():
    translation = tuple(list(range(1, Q)) + [0, Q])
    inversion = [0] * (Q + 1)
    inversion[0] = Q
    inversion[Q] = 0
    for x in range(1, Q):
        inversion[x] = -pow(x, -1, Q) % Q
    return translation, tuple(inversion)


def module_from_actions(actions):
    return libgap.GModuleByMats(
        [libgap(action) for action in actions], libgap.GF(Q)
    )


def module_factor_dimensions(module):
    factors = libgap.MTX["CompositionFactors"](module)
    return sorted(int(libgap.MTX["Dimension"](factor)) for factor in factors)


def module_summand_records(module):
    summands = libgap.MTX["Indecomposition"](module)
    answer = []
    for entry in summands:
        summand = entry[1]
        dimension = int(libgap.MTX["Dimension"](summand))
        radical_dimension = int(
            libgap.Length(libgap.MTX["BasisRadical"](summand))
        )
        socle_dimension = int(
            libgap.Length(libgap.MTX["BasisSocle"](summand))
        )
        answer.append(
            {
                "dimension": dimension,
                "head_dimension": dimension - radical_dimension,
                "socle_dimension": socle_dimension,
            }
        )
    return sorted(answer, key=lambda item: (item["dimension"], item["head_dimension"]))


def record(representative):
    pgl, psl = BASE.projective_groups(Q)
    orbit = sorted(BASE.orbit(pgl, representative))
    sheets = BASE.subgroup_orbits(psl, orbit)
    assert len(sheets) == 2 and len(sheets[0]) == len(sheets[1])

    base_product = BASE.matching_product(orbit[0], Q)
    points = []
    for matching in orbit:
        product = BASE.matching_product(matching, Q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % Q
            for exponent in set(product) | set(base_product)
        }
        points.append(BASE.quotient_by_conic(difference, 7, Q))

    affine = matrix(F, [[1] * len(orbit)] + [list(column) for column in zip(*points)])
    linear_basis = affine.row_space().basis_matrix()
    square = matrix(
        F,
        [
            linear_basis.row(i).pairwise_product(linear_basis.row(j))
            for i in range(linear_basis.nrows())
            for j in range(i, linear_basis.nrows())
        ],
    )
    trade = square.right_kernel().basis_matrix().echelon_form()

    translation = generator_permutations()[0]
    unseen = set(orbit)
    translation_orbits = []
    while unseen:
        matching = min(unseen)
        part = []
        current = matching
        while current not in part:
            part.append(current)
            current = BASE.image(translation, current)
        assert len(part) == Q
        translation_orbits.append(part)
        unseen -= set(part)
    orbit_index = {matching: i for i, matching in enumerate(orbit)}
    orbit_sums = matrix(F, len(translation_orbits), len(orbit), sparse=True)
    for row, part in enumerate(translation_orbits):
        for matching in part:
            orbit_sums[row, orbit_index[matching]] = 1
    norm_images = square * orbit_sums.transpose()
    norm_image_rank = norm_images.rank()
    sheet_sets = [set(sheet) for sheet in sheets]
    orbit_sheet = [
        next(i for i, sheet_set in enumerate(sheet_sets) if part[0] in sheet_set)
        for part in translation_orbits
    ]
    sheet_norm_ranks = [
        norm_images[:, [j for j, value in enumerate(orbit_sheet) if value == i]].rank()
        for i in range(2)
    ]

    sheet = sheets[0]
    sheet_index = {matching: i for i, matching in enumerate(sheet)}
    trade_actions = []
    sheet_actions = []
    for generator in generator_permutations():
        orbit_action = matrix(F, len(orbit), len(orbit), sparse=True)
        for i, matching in enumerate(orbit):
            orbit_action[i, orbit_index[BASE.image(generator, matching)]] = 1
        transformed = trade * orbit_action
        induced = transformed[:, trade.pivots()]
        assert induced * trade == transformed
        trade_actions.append(induced)

        sheet_action = matrix(F, len(sheet), len(sheet), sparse=True)
        for i, matching in enumerate(sheet):
            sheet_action[i, sheet_index[BASE.image(generator, matching)]] = 1
        sheet_actions.append(sheet_action)

    return {
        "orbit_size": len(orbit),
        "sheet_size": len(sheet),
        "affine_rank": linear_basis.nrows(),
        "square_rank": square.rank(),
        "trade_dimension": trade.nrows(),
        "translation_orbit_count": len(translation_orbits),
        "quadratic_norm_image_rank": norm_image_rank,
        "sheet_norm_image_ranks": sheet_norm_ranks,
        "translation_invariant_trade_dimension":
            len(translation_orbits) - norm_image_rank,
        "trade_factors": module_factor_dimensions(module_from_actions(trade_actions)),
        "sheet_summands": module_summand_records(module_from_actions(sheet_actions)),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("indices", nargs="*", type=int)
    args = parser.parse_args()
    indices = args.indices or list(range(len(PLATINUM.Q17_REPRESENTATIVES)))
    for index in indices:
        result = record(PLATINUM.Q17_REPRESENTATIVES[index])
        print(f"competitor {index}:", result)


if __name__ == "__main__":
    main()
