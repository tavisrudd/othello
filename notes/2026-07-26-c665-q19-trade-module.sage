#!/usr/bin/env sage
"""Decompose the exact q=19 A5 quadratic-trade module."""

import importlib.util
from pathlib import Path

from sage.all import GF, matrix
from sage.libs.gap.libgap import libgap


HERE = Path(__file__).resolve().parent


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load("c665_base", HERE / "2026-07-26-c665-balanced-matching-completeness.py")
PLATINUM = load("c665_platinum", HERE / "2026-07-26-c665-platinum-falsifier.py")
Q = 19
F = GF(Q)


def generator_permutations():
    translation = tuple(list(range(1, Q)) + [0, Q])
    inversion = [0] * (Q + 1)
    inversion[0] = Q
    inversion[Q] = 0
    for x in range(1, Q):
        inversion[x] = -pow(x, -1, Q) % Q
    return translation, tuple(inversion)


def main():
    pgl, psl = BASE.projective_groups(Q)
    orbit = sorted(BASE.orbit(pgl, PLATINUM.Q19_A5_REPRESENTATIVE))
    sheets = BASE.subgroup_orbits(psl, orbit)
    assert [len(sheet) for sheet in sheets] == [57, 57]

    base_product = BASE.matching_product(orbit[0], Q)
    points = []
    for matching in orbit:
        product = BASE.matching_product(matching, Q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % Q
            for exponent in set(product) | set(base_product)
        }
        points.append(BASE.quotient_by_conic(difference, 8, Q))

    affine = matrix(F, [[1] * len(orbit)] + [list(column) for column in zip(*points)])
    linear_basis = affine.row_space().basis_matrix()
    square_rows = [
        linear_basis.row(i).pairwise_product(linear_basis.row(j))
        for i in range(linear_basis.nrows())
        for j in range(i, linear_basis.nrows())
    ]
    square = matrix(F, square_rows)
    trade = square.right_kernel().basis_matrix().echelon_form()
    assert linear_basis.nrows() == 32
    assert square.rank() == 100
    assert trade.nrows() == 14

    orbit_index = {matching: i for i, matching in enumerate(orbit)}
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

    trade_actions = []
    sheet_actions = []
    selected_sheet = sheets[0]
    sheet_index = {matching: i for i, matching in enumerate(selected_sheet)}
    for generator in generator_permutations():
        permutation = matrix(F, len(orbit), len(orbit), sparse=True)
        for i, matching in enumerate(orbit):
            permutation[i, orbit_index[BASE.image(generator, matching)]] = 1
        transformed = trade * permutation
        pivots = trade.pivots()
        induced = transformed[:, pivots]
        assert induced * trade == transformed
        trade_actions.append(induced)

        sheet_permutation = matrix(
            F, len(selected_sheet), len(selected_sheet), sparse=True
        )
        for i, matching in enumerate(selected_sheet):
            sheet_permutation[
                i, sheet_index[BASE.image(generator, matching)]
            ] = 1
        sheet_actions.append(sheet_permutation)

    module = libgap.GModuleByMats(
        [libgap(action) for action in trade_actions], libgap.GF(Q)
    )
    factors = libgap.MTX["CompositionFactors"](module)
    factor_dimensions = sorted(int(libgap.MTX["Dimension"](factor)) for factor in factors)

    sheet_module = libgap.GModuleByMats(
        [libgap(action) for action in sheet_actions], libgap.GF(Q)
    )
    sheet_summands = libgap.MTX["Indecomposition"](sheet_module)
    sheet_summand_dimensions = sorted(
        int(libgap.MTX["Dimension"](entry[1])) for entry in sheet_summands
    )
    print("q=19 quadratic trade dimension:", trade.nrows())
    print("translation-orbit count:", len(translation_orbits))
    print("quadratic norm-image rank:", norm_image_rank)
    print("sheet norm-image ranks:", sheet_norm_ranks)
    print(
        "translation-invariant trade dimension:",
        len(translation_orbits) - norm_image_rank,
    )
    print("composition-factor dimensions:", factor_dimensions)
    print("sheet indecomposable dimensions:", sheet_summand_dimensions)


if __name__ == "__main__":
    main()
