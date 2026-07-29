#!/usr/bin/env sage
"""Search a regular A5 matching orbit for a one-dimensional quadratic trade."""

import argparse
import importlib.util
import itertools
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
REPLAY = load(
    "c665_replay",
    HERE / "2026-07-26-c665-balanced-matching-completeness-replay.py",
)


def compose(g, h):
    return tuple(g[h[i]] for i in range(len(g)))


def generated_group(generators):
    identity = tuple(range(len(generators[0])))
    answer = {identity}
    frontier = [identity]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            product = compose(generator, current)
            if product not in answer:
                answer.add(product)
                frontier.append(product)
    return answer


def matching_orbit(generators, matching):
    answer = {matching}
    frontier = [matching]
    while frontier:
        current = frontier.pop()
        for generator in generators:
            transformed = BASE.image(generator, current)
            if transformed not in answer:
                answer.add(transformed)
                frontier.append(transformed)
    return sorted(answer)


def standard_generators(q):
    translation = tuple(BASE.mobius((1, 1, 0, 1), x, q) for x in range(q + 1))
    inversion = tuple(BASE.mobius((0, -1, 1, 0), x, q) for x in range(q + 1))
    squares = {x * x % q for x in range(1, q)}
    nonsquare = next(x for x in range(2, q) if x not in squares)
    dilation = tuple(BASE.mobius((nonsquare, 0, 0, 1), x, q) for x in range(q + 1))
    return translation, inversion, dilation


def a5_subgroup(q):
    involution = tuple(BASE.mobius((0, -1, 1, 0), x, q) for x in range(q + 1))
    for a in range(q):
        for b in range(1, q):
            d = (1 - a) % q
            c = (a * d - 1) * pow(b, -1, q) % q
            order_three = tuple(BASE.mobius((a, b, c, d), x, q) for x in range(q + 1))
            if BASE.permutation_order(order_three) != 3:
                continue
            if BASE.permutation_order(compose(involution, order_three)) != 5:
                continue
            subgroup = generated_group((involution, order_three))
            if len(subgroup) == 60:
                return subgroup
    raise RuntimeError("no A5 subgroup found")


def regular_matching(subgroup, q):
    base = 0
    images = {g[base]: g for g in subgroup}
    assert len(images) == q + 1
    involution = next(g for g in subgroup if BASE.permutation_order(g) == 2)
    partner_at_base = involution[base]
    edges = {
        tuple(sorted((point, g[partner_at_base])))
        for point, g in images.items()
    }
    matching = tuple(sorted(edges))
    assert len(matching) == (q + 1) // 2
    assert len({endpoint for edge in matching for endpoint in edge}) == q + 1
    assert all(BASE.image(g, matching) == matching for g in subgroup)
    return matching


def evaluation_rows(orbit, q):
    field = GF(q)
    base_product = REPLAY.secant_product(orbit[0], q)
    degree = (q - 3) // 2
    points = []
    for matching in orbit:
        product = REPLAY.secant_product(matching, q)
        difference = {
            exponent: (product.get(exponent, 0) - base_product.get(exponent, 0)) % q
            for exponent in set(product) | set(base_product)
        }
        points.append(REPLAY.quotient_coefficients(difference, degree, q))
    affine = matrix(
        field,
        [[1] * len(orbit)] + [list(column) for column in zip(*points)],
    )
    return affine.row_space().basis_matrix()


def sampled_square_rank(linear, target_rank, seed):
    pairs = list(
        itertools.combinations_with_replacement(range(linear.nrows()), 2)
    )
    random.Random(seed).shuffle(pairs)
    selected = pairs[: target_rank + 64]
    square = matrix(
        linear.base_ring(),
        [
            linear.row(i).pairwise_product(linear.row(j))
            for i, j in selected
        ],
    )
    return square.rank(), len(selected)


def translation_norm_ranks(linear, orbit, sheets, translation, q):
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
        linear.base_ring(),
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
    return sheet_ranks, norm_images.rank()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, default=59)
    parser.add_argument("--seed", type=int, default=0)
    args = parser.parse_args()
    q = args.q
    assert q % 2 == 1 and q + 1 == 60

    subgroup = a5_subgroup(q)
    matching = regular_matching(subgroup, q)
    translation, inversion, dilation = standard_generators(q)
    special = matching_orbit((translation, inversion), matching)
    full = matching_orbit((translation, inversion, dilation), matching)
    assert len(full) == 2 * len(special)
    other_sheet = sorted(set(full) - set(special))
    linear = evaluation_rows(full, q)
    target_rank = len(full) - 1
    rank, sampled_rows = sampled_square_rank(linear, target_rank, args.seed)
    sheet_norm_ranks, joint_norm_rank = translation_norm_ranks(
        linear, full, (special, other_sheet), translation, q
    )
    print(
        {
            "q": q,
            "a5_order": len(subgroup),
            "sheet_size": len(special),
            "orbit_size": len(full),
            "lambda": len(special) // q,
            "affine_rank": linear.nrows(),
            "sampled_quadratic_rows": sampled_rows,
            "sampled_square_rank": rank,
            "unique_trade_if_rank": target_rank,
            "sheet_norm_ranks": sheet_norm_ranks,
            "joint_norm_rank": joint_norm_rank,
        }
    )


if __name__ == "__main__":
    main()
