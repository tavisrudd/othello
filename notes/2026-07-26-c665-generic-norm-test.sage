#!/usr/bin/env sage
"""Test the translation-norm bound on deterministic generic matching orbits."""

import argparse
import importlib.util
import random
from pathlib import Path

from sage.all import GF, matrix


HERE = Path(__file__).resolve().parent


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


BASE = load("c665_base", HERE / "2026-07-26-c665-balanced-matching-completeness.py")


def seeded_matching(q, seed):
    endpoints = list(range(q + 1))
    random.Random(seed).shuffle(endpoints)
    return tuple(
        sorted(
            (min(endpoints[i], endpoints[i + 1]), max(endpoints[i], endpoints[i + 1]))
            for i in range(0, q + 1, 2)
        )
    )


def translation_permutation(q):
    return tuple(list(range(1, q)) + [0, q])


def record(q, seed):
    field = GF(q)
    representative = seeded_matching(q, seed)
    pgl, psl = BASE.projective_groups(q)
    orbit = sorted(BASE.orbit(pgl, representative))
    sheets = BASE.subgroup_orbits(psl, orbit)
    if len(sheets) != 2:
        return {
            "q": q,
            "seed": seed,
            "orbit_size": len(orbit),
            "split": False,
        }

    base_product = BASE.matching_product(orbit[0], q)
    degree = (q - 3) // 2
    points = []
    for matching in orbit:
        product = BASE.matching_product(matching, q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % q
            for exponent in set(product) | set(base_product)
        }
        points.append(BASE.quotient_by_conic(difference, degree, q))

    affine = matrix(field, [[1] * len(orbit)] + [list(column) for column in zip(*points)])
    linear = affine.row_space().basis_matrix()
    square = matrix(
        field,
        [
            linear.row(i).pairwise_product(linear.row(j))
            for i in range(linear.nrows())
            for j in range(i, linear.nrows())
        ],
    )

    translation = translation_permutation(q)
    unseen = set(orbit)
    translation_orbits = []
    while unseen:
        matching = min(unseen)
        part = []
        current = matching
        while current not in part:
            part.append(current)
            current = BASE.image(translation, current)
        assert len(part) == q
        translation_orbits.append(part)
        unseen -= set(part)

    orbit_index = {matching: i for i, matching in enumerate(orbit)}
    norm_images = matrix(
        field,
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
    lam = len(sheets[0]) // q
    return {
        "q": q,
        "seed": seed,
        "orbit_size": len(orbit),
        "stabilizer_order": len(pgl) // len(orbit),
        "lambda": lam,
        "affine_rank": linear.nrows(),
        "sheet_norm_ranks": sheet_ranks,
        "joint_norm_rank": norm_images.rank(),
        "lambda_plus_one": lam + 1,
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, default=17)
    parser.add_argument("--seeds", type=int, nargs="+", default=[0])
    args = parser.parse_args()
    for seed in args.seeds:
        print(record(args.q, seed))


if __name__ == "__main__":
    main()
