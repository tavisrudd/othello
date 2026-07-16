#!/usr/bin/env python3
"""Index and probe the nucleus-plus-four-split-Z3-orbit C201 family.

The mixed determinant norm F(P,Q,R) vanishes precisely when the third orbit
meets one of the nine secants joining the first two orbits.  We index those
bad third-orbit labels as Python integer bitsets, then sample only quadruples
that pass all pair and ternary arc conditions.  Coverage is tested before the
more expensive quadratic profile, as required by the C201 q=64 gate.
"""

from __future__ import annotations

import argparse
import collections
import itertools
import random

import probe_c201_q64_baer as field
import size_c201_q64_z3 as sizing


def build_family() -> tuple[int, list[tuple[int, ...]]]:
    omega = next(x for x in range(2, field.Q) if field.power(x, 3) == 1)
    matrix = ((field.mul(omega, omega), 0, 0), (0, omega, 0), (0, 0, 1))
    orbits = sizing.point_orbits(field.point_permutation(matrix))
    conic = {
        field.POINT_INDEX[(0, 0, 1)],
        *(field.POINT_INDEX[(1, t, field.mul(t, t))] for t in range(field.Q)),
    }
    nucleus = field.POINT_INDEX[(0, 1, 0)]
    legal = [
        orbit
        for orbit in orbits
        if len(orbit) == 3
        and not set(orbit) & conic
        and field.is_arc((nucleus,) + orbit)
    ]
    assert len(legal) == 1302
    return nucleus, legal


def compatibility(
    nucleus: int,
    legal: list[tuple[int, ...]],
    line_masks: dict[tuple[int, ...], int],
) -> tuple[list[int], list[tuple[int, int]], list[int], list[int]]:
    adjacency = [0] * len(legal)
    point_masks = [sum(1 << point for point in orbit) for orbit in legal]
    self_masks = []
    for orbit in legal:
        mask = 0
        for a, b in itertools.combinations((nucleus,) + orbit, 2):
            mask |= line_masks[field.line(a, b)]
        self_masks.append(mask)
    edges = []
    for i, left in enumerate(legal):
        for j in range(i + 1, len(legal)):
            if self_masks[i] & point_masks[j] or self_masks[j] & point_masks[i]:
                continue
            adjacency[i] |= 1 << j
            adjacency[j] |= 1 << i
            edges.append((i, j))
    assert len(edges) == 730380
    return adjacency, edges, point_masks, self_masks


def bad_third_index(
    legal: list[tuple[int, ...]],
    edges: list[tuple[int, int]],
    line_label_masks: dict[tuple[int, ...], int],
) -> dict[tuple[int, int], int]:
    answer: dict[tuple[int, int], int] = {}
    for i, j in edges:
        labels = 0
        for a in legal[i]:
            for b in legal[j]:
                labels |= line_label_masks[field.line(a, b)]
        answer[(i, j)] = labels
    return answer


def mixed_ok(i: int, j: int, k: int, bad: dict[tuple[int, int], int]) -> bool:
    edge = (i, j) if i < j else (j, i)
    return not (bad[edge] >> k) & 1


def direct_mixed_ok(
    left: tuple[int, ...], right: tuple[int, ...], third: tuple[int, ...]
) -> bool:
    return all(field.determinant(a, b, c) for a in left for b in right for c in third)


def line_indices(
    legal: list[tuple[int, ...]],
) -> tuple[dict[tuple[int, ...], int], dict[tuple[int, ...], int]]:
    point_label = [-1] * len(field.POINTS)
    for label, orbit in enumerate(legal):
        for point in orbit:
            point_label[point] = label
    line_masks = {}
    line_label_masks = {}
    for ell, points in field.LINE_POINTS.items():
        point_mask = 0
        label_mask = 0
        for point in points:
            point_mask |= 1 << point
            label = point_label[point]
            if label >= 0:
                label_mask |= 1 << label
        line_masks[ell] = point_mask
        line_label_masks[ell] = label_mask
    return line_masks, line_label_masks


def pair_coverage(
    left: tuple[int, ...],
    right: tuple[int, ...],
    line_masks: dict[tuple[int, ...], int],
) -> int:
    mask = 0
    for a in left:
        for b in right:
            mask |= line_masks[field.line(a, b)]
    return mask


def choose_bit(mask: int, rng: random.Random) -> int:
    rank = rng.randrange(mask.bit_count())
    while rank:
        mask &= mask - 1
        rank -= 1
    return (mask & -mask).bit_length() - 1


def probe(samples: int, seed: int) -> None:
    nucleus, legal = build_family()
    line_masks, line_label_masks = line_indices(legal)
    adjacency, edges, _, self_masks = compatibility(nucleus, legal, line_masks)
    bad = bad_third_index(legal, edges, line_label_masks)

    indexed_incidence_count = sum(labels.bit_count() for labels in bad.values())
    check_rng = random.Random(0xC201)
    for _ in range(20000):
        i, j = edges[check_rng.randrange(len(edges))]
        k = check_rng.randrange(len(legal))
        assert mixed_ok(i, j, k, bad) == direct_mixed_ok(legal[i], legal[j], legal[k])

    rng = random.Random(seed)
    accepted = 0
    attempts = 0
    best_uncovered = len(field.POINTS)
    best_labels: tuple[int, ...] | None = None
    uncovered_histogram: collections.Counter[int] = collections.Counter()
    while accepted < samples:
        attempts += 1
        i, j = edges[rng.randrange(len(edges))]
        common = adjacency[i] & adjacency[j]
        k = choose_bit(common, rng)
        common &= adjacency[k]
        common &= ~((1 << (k + 1)) - 1)
        if not common:
            continue
        ell = choose_bit(common, rng)
        labels = tuple(sorted((i, j, k, ell)))
        if any(
            not mixed_ok(a, b, c, bad)
            for a, b, c in itertools.combinations(labels, 3)
        ):
            continue

        coverage = 0
        for label in labels:
            coverage |= self_masks[label]
        for a, b in itertools.combinations(labels, 2):
            coverage |= pair_coverage(legal[a], legal[b], line_masks)
        uncovered = len(field.POINTS) - coverage.bit_count()
        uncovered_histogram[uncovered] += 1
        accepted += 1
        if uncovered < best_uncovered:
            best_uncovered = uncovered
            best_labels = labels

    assert best_labels is not None
    arc = tuple(sorted((nucleus,) + tuple(
        point for label in best_labels for point in legal[label]
    )))
    assert field.is_arc(arc)
    direct = field.profile(arc)
    assert direct["uncovered_size"] == best_uncovered

    bad_counts = [labels.bit_count() for labels in bad.values()]
    print(f"legal_orbits {len(legal)} compatible_pairs {len(edges)}")
    print(
        f"bad_third_index incidences {indexed_incidence_count} "
        f"per_pair_range {min(bad_counts)}..{max(bad_counts)} "
        f"per_pair_mean {indexed_incidence_count / len(bad_counts):.6f}"
    )
    print("index_equivalence PASS: 20000 seeded direct-determinant checks")
    print(
        f"seed {seed} requested_arc_draws {samples} attempts {attempts} "
        f"accepted_arc_draws {accepted}"
    )
    print(
        f"uncovered_range {min(uncovered_histogram)}..{max(uncovered_histogram)} "
        f"best_labels {best_labels}"
    )
    if best_uncovered <= field.Q + 1:
        print(f"coverage_prefilter PASS: {best_uncovered} <= {field.Q + 1}")
        print(f"best_profile {direct}")
    else:
        print(f"coverage_prefilter FAIL: {best_uncovered} > {field.Q + 1}")
        print("quadratic_analysis SKIPPED")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--samples", type=int, default=10000)
    parser.add_argument("--seed", type=int, default=201)
    args = parser.parse_args()
    assert args.samples > 0
    probe(args.samples, args.seed)


if __name__ == "__main__":
    main()
