#!/usr/bin/env python3
"""Coverage-directed local optimization for the indexed C201 split-Z3 family."""

from __future__ import annotations

import argparse
import collections
import itertools
import random

import probe_c201_q64_baer as field
import probe_c201_q64_z3_index as index

LOCAL_INCUMBENT = (0, 250, 406, 1298)


def random_arc_labels(
    rng: random.Random,
    edges: list[tuple[int, int]],
    adjacency: list[int],
    bad: dict[tuple[int, int], int],
) -> tuple[int, ...]:
    while True:
        i, j = edges[rng.randrange(len(edges))]
        common = adjacency[i] & adjacency[j]
        k = index.choose_bit(common, rng)
        common &= adjacency[k]
        common &= ~((1 << (k + 1)) - 1)
        if not common:
            continue
        ell = index.choose_bit(common, rng)
        labels = tuple(sorted((i, j, k, ell)))
        if all(
            index.mixed_ok(a, b, c, bad)
            for a, b, c in itertools.combinations(labels, 3)
        ):
            return labels


def coverage_mask(
    labels: tuple[int, ...],
    legal: list[tuple[int, ...]],
    self_masks: list[int],
    line_masks: dict[tuple[int, ...], int],
) -> int:
    coverage = 0
    for label in labels:
        coverage |= self_masks[label]
    for a, b in itertools.combinations(labels, 2):
        coverage |= index.pair_coverage(legal[a], legal[b], line_masks)
    return coverage


def valid_replacements(
    others: tuple[int, int, int],
    adjacency: list[int],
    bad: dict[tuple[int, int], int],
) -> int:
    candidates = adjacency[others[0]] & adjacency[others[1]] & adjacency[others[2]]
    for a, b in itertools.combinations(others, 2):
        edge = (a, b) if a < b else (b, a)
        candidates &= ~bad[edge]
    for label in others:
        candidates &= ~(1 << label)
    return candidates


def improve(
    start: tuple[int, ...],
    legal: list[tuple[int, ...]],
    adjacency: list[int],
    bad: dict[tuple[int, int], int],
    self_masks: list[int],
    line_masks: dict[tuple[int, ...], int],
) -> tuple[tuple[int, ...], int, int]:
    labels = start
    mask = coverage_mask(labels, legal, self_masks, line_masks)
    steps = 0
    while True:
        best_labels = labels
        best_mask = mask
        best_covered = mask.bit_count()
        for removed in labels:
            others = tuple(label for label in labels if label != removed)
            base = coverage_mask(others, legal, self_masks, line_masks)
            candidates = valid_replacements(others, adjacency, bad)
            while candidates:
                low = candidates & -candidates
                candidate = low.bit_length() - 1
                candidate_mask = base | self_masks[candidate]
                for other in others:
                    candidate_mask |= index.pair_coverage(
                        legal[candidate], legal[other], line_masks
                    )
                covered = candidate_mask.bit_count()
                candidate_labels = tuple(sorted(others + (candidate,)))
                if covered > best_covered or (
                    covered == best_covered and candidate_labels < best_labels
                ):
                    best_labels = candidate_labels
                    best_mask = candidate_mask
                    best_covered = covered
                candidates ^= low
        if best_covered <= mask.bit_count():
            return labels, len(field.POINTS) - mask.bit_count(), steps
        labels = best_labels
        mask = best_mask
        steps += 1


def improve_two_orbits(
    labels: tuple[int, ...],
    legal: list[tuple[int, ...]],
    edges: list[tuple[int, int]],
    adjacency: list[int],
    bad: dict[tuple[int, int], int],
    self_masks: list[int],
    line_masks: dict[tuple[int, ...], int],
) -> tuple[tuple[int, ...], int]:
    best_labels = labels
    best_mask = coverage_mask(labels, legal, self_masks, line_masks)
    best_covered = best_mask.bit_count()
    retained_data = []
    for retained in itertools.combinations(labels, 2):
        a, b = retained
        edge = (a, b) if a < b else (b, a)
        base = self_masks[a] | self_masks[b]
        base |= index.pair_coverage(legal[a], legal[b], line_masks)
        retained_data.append((retained, base, bad[edge]))

    for c, d in edges:
        candidate_bad = bad[(c, d)]
        candidate_component = self_masks[c] | self_masks[d]
        candidate_component |= index.pair_coverage(legal[c], legal[d], line_masks)
        for (a, b), retained_base, retained_bad in retained_data:
            if c in (a, b) or d in (a, b):
                continue
            if not all(
                (adjacency[x] >> y) & 1
                for x in (c, d)
                for y in (a, b)
            ):
                continue
            if (retained_bad >> c) & 1 or (retained_bad >> d) & 1:
                continue
            if (candidate_bad >> a) & 1 or (candidate_bad >> b) & 1:
                continue

            mask = retained_base | candidate_component
            for x in (c, d):
                for y in (a, b):
                    mask |= index.pair_coverage(legal[x], legal[y], line_masks)
            covered = mask.bit_count()
            candidate_labels = tuple(sorted((a, b, c, d)))
            if covered > best_covered or (
                covered == best_covered and candidate_labels < best_labels
            ):
                best_labels = candidate_labels
                best_mask = mask
                best_covered = covered
    return best_labels, len(field.POINTS) - best_covered


def arc_from_labels(
    nucleus: int, legal: list[tuple[int, ...]], labels: tuple[int, ...]
) -> tuple[int, ...]:
    return tuple(sorted(
        (nucleus,) + tuple(point for label in labels for point in legal[label])
    ))


def direct_coverage(arc: tuple[int, ...], line_masks: dict[tuple[int, ...], int]) -> int:
    mask = 0
    for a, b in itertools.combinations(arc, 2):
        mask |= line_masks[field.line(a, b)]
    return mask


def optimize(restarts: int, two_opt_passes: int, seed: int) -> None:
    nucleus, legal = index.build_family()
    line_masks, line_label_masks = index.line_indices(legal)
    adjacency, edges, _, self_masks = index.compatibility(nucleus, legal, line_masks)
    bad = index.bad_third_index(legal, edges, line_label_masks)
    rng = random.Random(seed)

    global_labels: tuple[int, ...] | None = None
    global_uncovered = len(field.POINTS)
    local_histogram: collections.Counter[int] = collections.Counter()
    step_histogram: collections.Counter[int] = collections.Counter()
    for restart in range(restarts):
        start = (
            LOCAL_INCUMBENT
            if restart == 0
            else random_arc_labels(rng, edges, adjacency, bad)
        )
        assert all(
            (adjacency[a] >> b) & 1 for a, b in itertools.combinations(start, 2)
        )
        assert all(
            index.mixed_ok(a, b, c, bad)
            for a, b, c in itertools.combinations(start, 3)
        )
        labels, uncovered, steps = improve(
            start, legal, adjacency, bad, self_masks, line_masks
        )
        local_histogram[uncovered] += 1
        step_histogram[steps] += 1
        if uncovered < global_uncovered or (
            uncovered == global_uncovered
            and (global_labels is None or labels < global_labels)
        ):
            global_labels = labels
            global_uncovered = uncovered
            print(
                f"IMPROVEMENT restart {restart} local_steps {steps} "
                f"uncovered {uncovered} labels {labels}"
            )

    assert global_labels is not None
    two_opt_results = []
    for pass_number in range(two_opt_passes):
        labels, uncovered = improve_two_orbits(
            global_labels, legal, edges, adjacency, bad, self_masks, line_masks
        )
        two_opt_results.append(uncovered)
        print(
            f"TWO_OPT pass {pass_number + 1} uncovered {uncovered} labels {labels}"
        )
        if uncovered >= global_uncovered:
            break
        global_labels = labels
        global_uncovered = uncovered

    arc = arc_from_labels(nucleus, legal, global_labels)
    assert len(arc) == 13 and field.is_arc(arc)
    assert all(
        index.mixed_ok(a, b, c, bad)
        for a, b, c in itertools.combinations(global_labels, 3)
    )
    direct_mask = direct_coverage(arc, line_masks)
    assert len(field.POINTS) - direct_mask.bit_count() == global_uncovered

    projectivity = ((1, 2, 4), (0, 1, 8), (0, 0, 1))
    action = field.point_permutation(projectivity)
    transformed = tuple(reversed(tuple(action[point] for point in arc)))
    assert field.is_arc(transformed)
    transformed_mask = direct_coverage(transformed, line_masks)
    assert transformed_mask.bit_count() == direct_mask.bit_count()

    print(f"seed {seed} restarts {restarts} requested_two_opt_passes {two_opt_passes}")
    print(f"local_uncovered_histogram {dict(sorted(local_histogram.items()))}")
    print(f"local_step_histogram {dict(sorted(step_histogram.items()))}")
    print(f"best_uncovered {global_uncovered} best_labels {global_labels}")
    print(f"two_opt_uncovered {two_opt_results}")
    print("direct_arc_and_projective_invariance_checks PASS")
    if global_uncovered <= field.Q + 1:
        profile = field.profile(arc)
        assert profile["uncovered_size"] == global_uncovered
        print(f"coverage_prefilter PASS: {global_uncovered} <= {field.Q + 1}")
        print(f"best_profile {profile}")
    else:
        print(f"coverage_prefilter FAIL: {global_uncovered} > {field.Q + 1}")
        print("quadratic_analysis SKIPPED")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--restarts", type=int, default=20)
    parser.add_argument("--two-opt-passes", type=int, default=0)
    parser.add_argument("--seed", type=int, default=201)
    args = parser.parse_args()
    assert args.restarts > 0
    assert args.two_opt_passes >= 0
    optimize(args.restarts, args.two_opt_passes, args.seed)


if __name__ == "__main__":
    main()
