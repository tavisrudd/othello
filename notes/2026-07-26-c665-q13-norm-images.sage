#!/usr/bin/env sage
"""Test translation-norm image ranks on q=13 split matching orbits."""

import importlib.util
from pathlib import Path

from sage.all import GF, matrix


HERE = Path(__file__).resolve().parent
Q = 13
F = GF(Q)


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load("c665_base", HERE / "2026-07-26-c665-balanced-matching-completeness.py")


def translation_permutation():
    return tuple(list(range(1, Q)) + [0, Q])


def norm_record(orbit, sheets):
    base_product = BASE.matching_product(orbit[0], Q)
    points = []
    for matching in orbit:
        product = BASE.matching_product(matching, Q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % Q
            for exponent in set(product) | set(base_product)
        }
        points.append(BASE.quotient_by_conic(difference, 5, Q))

    affine = matrix(F, [[1] * len(orbit)] + [list(column) for column in zip(*points)])
    linear = affine.row_space().basis_matrix()
    translation = translation_permutation()
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
    norm_images = matrix(
        F,
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
    sheet_sets = [set(sheet) for sheet in sheets]
    orbit_sheet = [
        next(i for i, sheet_set in enumerate(sheet_sets) if part[0] in sheet_set)
        for part in translation_orbits
    ]
    sheet_ranks = [
        norm_images[:, [j for j, value in enumerate(orbit_sheet) if value == i]].rank()
        for i in range(2)
    ]
    rank = norm_images.rank()
    lam = len(sheets[0]) // Q
    return {
        "orbit_size": len(orbit),
        "lambda": lam,
        "linear_rank": linear.nrows(),
        "norm_rank": rank,
        "sheet_norm_ranks": sheet_ranks,
        "invariant_trade_dimension": 2 * lam - rank,
    }


def main():
    pgl, psl = BASE.projective_groups(Q)
    matchings = sorted(BASE.perfect_matchings(range(Q + 1)))
    representatives = {}
    for orbit in BASE.subgroup_orbits(pgl, matchings):
        sheets = BASE.subgroup_orbits(psl, orbit)
        if len(sheets) == 2 and len(orbit) not in representatives:
            representatives[len(orbit)] = (orbit, sheets)
    assert sorted(representatives) == [364, 1092, 2184]
    for size in sorted(representatives):
        print(norm_record(*representatives[size]))


if __name__ == "__main__":
    main()
