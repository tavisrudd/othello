#!/usr/bin/env python3
"""Mine local incidence descriptions of the certified q=17 C80 responses.

This deliberately analyzes only the response DAG selected by
``c80_strict_overload_kernel.py``.  It asks whether the selected reply is
recoverable from opponent-marked, value-independent local incidence scores.
"""
from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
import sys
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-24-c80-incidence-packet-mine.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


KERNEL = load_module(
    ROOT / "rust/scripts/c80_strict_overload_kernel.py", "c80_packet_kernel"
)


def histogram(counter: Counter) -> dict[str, int]:
    return {str(key): value for key, value in sorted(counter.items())}


def run_order(q: int) -> dict:
    kernel = KERNEL.StrictKernel(q)
    labels = (
        list(itertools.combinations(range(1, q), 4))
        if q == 11
        else KERNEL.escape_parameters(KERNEL.ROWS, q)
    )
    roots = [
        kernel.game.base_mask(label)
        for label in labels
        if kernel.contains(kernel.game.base_mask(label))
    ]

    certified_states: set[int] = set()
    stack = list(roots)
    while stack:
        state = stack.pop()
        if state in certified_states or kernel.omega(state) == 0:
            continue
        certified_states.add(state)
        for opponent in KERNEL.GEOMETRY.bits(kernel.game.legal_mask(state)):
            reply = kernel.responses[(state, opponent)]
            stack.append(state | (1 << opponent) | (1 << reply))

    chosen_maxima = Counter()
    chosen_ranks = Counter()
    opponent_progress = Counter()
    pair_line_loads = Counter()
    max_drop_packet_sizes = Counter()
    max_drop_kernel_members = Counter()
    max_drop_failure_count = 0
    max_drop_failures = []
    best_kernel_drop_deficits = Counter()
    best_kernel_drop_ranks = Counter()
    max_drop_failures_by_size = Counter()
    fallback_score_coverage = Counter()
    fallback_score_pure = Counter()
    fallback_coverage_patterns = Counter()
    uncovered_fallbacks = []
    local_score_class_status = Counter()
    global_score_labels: dict[tuple[int, ...], set[bool]] = {}
    failure_good_scores: list[set[tuple[int, ...]]] = []
    edges = 0

    for state in sorted(certified_states):
        old_omega = kernel.omega(state)
        state_legal = kernel.game.legal_mask(state)
        for opponent in KERNEL.GEOMETRY.bits(state_legal):
            edges += 1
            child = state | (1 << opponent)
            child_legal = kernel.game.legal_mask(child)
            reply = kernel.responses[(state, opponent)]
            target = child | (1 << reply)
            opponent_progress[old_omega - kernel.omega(child)] += 1

            scores = {}
            for candidate in KERNEL.GEOMETRY.bits(child_legal):
                candidate_target = child | (1 << candidate)
                legal_after = kernel.game.legal_mask(candidate_target)
                marked_line = kernel.game.line_masks[opponent + 2][candidate + 2]
                line_counts = [
                    (child_legal & line_mask).bit_count()
                    for line_mask, fixed_load in kernel.lines
                    if fixed_load + (child & line_mask).bit_count() == 0
                    and line_mask & (1 << candidate)
                ]
                scores[candidate] = (
                    old_omega - kernel.omega(candidate_target),
                    child_legal.bit_count() - legal_after.bit_count() - 1,
                    sum(max(0, count - 2) for count in line_counts),
                    sum(count >= 3 for count in line_counts),
                    max(line_counts, default=0),
                    -legal_after.bit_count(),
                    (state_legal & marked_line).bit_count(),
                )

            names = (
                "omega_drop",
                "legal_kills",
                "overload_mass_through_reply",
                "overloaded_lines_through_reply",
                "max_line_load_through_reply",
                "negative_target_legal",
                "opponent_reply_line_legal",
            )
            for index, name in enumerate(names):
                values = sorted(
                    {score[index] for score in scores.values()}, reverse=True
                )
                value = scores[reply][index]
                chosen_ranks[(name, values.index(value) + 1)] += 1
                if value == values[0]:
                    chosen_maxima[name] += 1

            maximum_drop = max(score[0] for score in scores.values())
            max_drop_packet = [
                candidate
                for candidate, score in scores.items()
                if score[0] == maximum_drop
            ]
            kernel_members = [
                candidate
                for candidate in max_drop_packet
                if kernel.omega(child | (1 << candidate)) < old_omega
                and kernel.contains(child | (1 << candidate))
            ]
            max_drop_packet_sizes[len(max_drop_packet)] += 1
            max_drop_kernel_members[len(kernel_members)] += 1
            distinct_drops = sorted(
                {score[0] for score in scores.values()}, reverse=True
            )
            best_kernel_drop = None
            for drop in distinct_drops:
                candidates = [
                    candidate
                    for candidate, score in scores.items()
                    if score[0] == drop
                ]
                if any(
                    kernel.omega(child | (1 << candidate)) < old_omega
                    and kernel.contains(child | (1 << candidate))
                    for candidate in candidates
                ):
                    best_kernel_drop = drop
                    break
            assert best_kernel_drop is not None
            best_kernel_drop_deficits[maximum_drop - best_kernel_drop] += 1
            best_kernel_drop_ranks[distinct_drops.index(best_kernel_drop) + 1] += 1
            if not kernel_members:
                max_drop_failure_count += 1
                max_drop_failures_by_size[state.bit_count()] += 1
                score_labels: dict[tuple[int, ...], set[bool]] = {}
                for candidate, score in scores.items():
                    candidate_target = child | (1 << candidate)
                    label = (
                        kernel.omega(candidate_target) < old_omega
                        and kernel.contains(candidate_target)
                    )
                    score_labels.setdefault(score, set()).add(label)
                    global_score_labels.setdefault(score, set()).add(label)
                good_classes = [
                    labels for labels in score_labels.values() if True in labels
                ]
                assert good_classes
                failure_good_scores.append(
                    {
                        score
                        for score, labels in score_labels.items()
                        if True in labels
                    }
                )
                local_score_class_status[
                    (
                        any(labels == {True} for labels in good_classes),
                        all(labels == {True} for labels in good_classes),
                    )
                ] += 1
                coverage_pattern = []
                for index, name in enumerate(names[1:], start=1):
                    best = max(score[index] for score in scores.values())
                    packet = [
                        candidate
                        for candidate, score in scores.items()
                        if score[index] == best
                    ]
                    labels = [
                        kernel.omega(child | (1 << candidate)) < old_omega
                        and kernel.contains(child | (1 << candidate))
                        for candidate in packet
                    ]
                    if any(labels):
                        fallback_score_coverage[name] += 1
                        coverage_pattern.append(name)
                    if labels and all(labels):
                        fallback_score_pure[name] += 1
                fallback_coverage_patterns[tuple(coverage_pattern)] += 1
                if not coverage_pattern and len(uncovered_fallbacks) < 20:
                    good = []
                    for candidate, score in scores.items():
                        candidate_target = child | (1 << candidate)
                        if (
                            kernel.omega(candidate_target) < old_omega
                            and kernel.contains(candidate_target)
                        ):
                            good.append(
                                {
                                    "cell": list(kernel.game.cell_tuple(candidate)),
                                    "kind": (
                                        "conic"
                                        if kernel.game.is_conic_cell(candidate)
                                        else "intruder"
                                    ),
                                    "scores": list(score),
                                }
                            )
                    uncovered_fallbacks.append(
                        {
                            "selected_size": state.bit_count(),
                            "selected_conic_parameters": sorted(
                                kernel.game.cell_param[point]
                                for point in KERNEL.GEOMETRY.bits(
                                    state & kernel.game.conic_mask
                                )
                            ),
                            "selected_intruder_cells": [
                                list(kernel.game.cell_tuple(point))
                                for point in KERNEL.GEOMETRY.bits(
                                    state & ~kernel.game.conic_mask
                                )
                            ],
                            "opponent_cell": list(
                                kernel.game.cell_tuple(opponent)
                            ),
                            "opponent_kind": (
                                "conic"
                                if kernel.game.is_conic_cell(opponent)
                                else "intruder"
                            ),
                            "good_replies": good,
                        }
                    )
                if len(max_drop_failures) < 20:
                    max_drop_failures.append(
                        {
                            "state": state,
                            "opponent": opponent,
                            "old_omega": old_omega,
                            "child_omega": kernel.omega(child),
                            "maximum_drop": maximum_drop,
                            "chosen_drop": scores[reply][0],
                            "packet_size": len(max_drop_packet),
                        }
                    )

            pair_mask = kernel.game.line_masks[opponent + 2][reply + 2]
            pair_fixed = sum(
                kernel.game.collinear(
                    fixed,
                    kernel.game.points[opponent + 2],
                    kernel.game.points[reply + 2],
                )
                for fixed in (kernel.game.a, kernel.game.b)
            )
            pair_line_loads[
                (
                    pair_fixed + (state & pair_mask).bit_count(),
                    (state_legal & pair_mask).bit_count(),
                    (child_legal & pair_mask).bit_count(),
                )
            ] += 1

    globally_pure_good = {
        score for score, labels in global_score_labels.items() if labels == {True}
    }
    pure_good_score_use = Counter(
        score
        for scores in failure_good_scores
        for score in scores
        if score in globally_pure_good
    )

    return {
        "q": q,
        "roots": len(roots),
        "certified_positive_overload_states": len(certified_states),
        "response_edges": edges,
        "chosen_score_maxima": {
            name: {"count": chosen_maxima[name], "of": edges}
            for name in sorted(chosen_maxima)
        },
        "chosen_score_ranks": {
            f"{name}:rank={rank}": count
            for (name, rank), count in sorted(chosen_ranks.items())
        },
        "max_drop_packet": {
            "edges_with_kernel_member": edges - max_drop_failure_count,
            "packet_size_histogram": histogram(max_drop_packet_sizes),
            "kernel_member_count_histogram": histogram(max_drop_kernel_members),
            "best_kernel_drop_deficit_histogram": histogram(
                best_kernel_drop_deficits
            ),
            "best_kernel_drop_rank_histogram": histogram(best_kernel_drop_ranks),
            "failures_by_selected_size": histogram(max_drop_failures_by_size),
            "fallback_score_maximum_coverage": {
                name: {
                    "has_kernel_member": fallback_score_coverage[name],
                    "all_members_in_kernel": fallback_score_pure[name],
                    "of_failures": max_drop_failure_count,
                }
                for name in names[1:]
            },
            "fallback_coverage_patterns": {
                "+".join(pattern) if pattern else "none": count
                for pattern, count in sorted(fallback_coverage_patterns.items())
            },
            "uncovered_fallbacks": uncovered_fallbacks,
            "local_score_class_status": {
                (
                    f"has_pure_good={key[0]},all_good_pure={key[1]}"
                ): value
                for key, value in sorted(local_score_class_status.items())
            },
            "global_score_vectors": {
                "total": len(global_score_labels),
                "pure_kernel": sum(
                    labels == {True} for labels in global_score_labels.values()
                ),
                "pure_nonkernel": sum(
                    labels == {False} for labels in global_score_labels.values()
                ),
                "mixed": sum(
                    labels == {False, True}
                    for labels in global_score_labels.values()
                ),
                "failure_transitions_covered_by_pure_kernel_vector": sum(
                    bool(scores & globally_pure_good)
                    for scores in failure_good_scores
                ),
                "most_used_pure_kernel_vectors": [
                    {"scores": list(score), "transitions": count}
                    for score, count in pure_good_score_use.most_common(20)
                ],
            },
            "first_failures": max_drop_failures,
        },
        "opponent_omega_drop": histogram(opponent_progress),
        "opponent_reply_line_profile": {
            f"selected_load={key[0]},parent_legal={key[1]},child_legal={key[2]}": value
            for key, value in sorted(pair_line_loads.items())
        },
    }


def run_q19_head_probe() -> dict:
    """Out-of-sample maximal-drop check through selected size eight."""
    q = 19
    label = (15, 16, 17, 18)
    kernel = KERNEL.StrictKernel(q)
    root = kernel.game.base_mask(label)
    assert kernel.contains(root)

    seen: set[int] = set()
    stack = [root]
    edges_by_size = Counter()
    covered_by_size = Counter()
    opponent_drops = Counter()
    max_kernel_target_status_by_size = Counter()
    while stack:
        state = stack.pop()
        if state in seen or state.bit_count() > 8 or kernel.omega(state) == 0:
            continue
        seen.add(state)
        old_omega = kernel.omega(state)
        for opponent in KERNEL.GEOMETRY.bits(kernel.game.legal_mask(state)):
            edges_by_size[state.bit_count()] += 1
            child = state | (1 << opponent)
            opponent_drops[old_omega - kernel.omega(child)] += 1
            candidates = list(
                KERNEL.GEOMETRY.bits(kernel.game.legal_mask(child))
            )
            drops = {
                candidate: old_omega
                - kernel.omega(child | (1 << candidate))
                for candidate in candidates
            }
            maximum_drop = max(drops.values())
            max_kernel_targets = [
                child | (1 << candidate)
                for candidate, drop in drops.items()
                if drop == maximum_drop
                and kernel.contains(child | (1 << candidate))
            ]
            if max_kernel_targets:
                covered_by_size[state.bit_count()] += 1
                target_omegas = [
                    kernel.omega(target) for target in max_kernel_targets
                ]
                max_kernel_target_status_by_size[
                    (
                        state.bit_count(),
                        any(omega == 0 for omega in target_omegas),
                        any(omega > 0 for omega in target_omegas),
                    )
                ] += 1
            chosen = kernel.responses[(state, opponent)]
            stack.append(child | (1 << chosen))

    return {
        "q": q,
        "root": list(label),
        "scope": "chosen strict-kernel DAG through selected size eight",
        "states_by_size": histogram(Counter(state.bit_count() for state in seen)),
        "response_edges_by_size": histogram(edges_by_size),
        "max_drop_edges_covered_by_size": histogram(covered_by_size),
        "opponent_omega_drop": histogram(opponent_drops),
        "max_kernel_target_status_by_size": {
            (
                f"size={key[0]},has_boundary={key[1]},"
                f"has_positive={key[2]}"
            ): count
            for key, count in sorted(
                max_kernel_target_status_by_size.items()
            )
        },
    }


def run() -> dict:
    return {
        "schema": "c80-incidence-packet-mine-v2",
        "orders": [run_order(q) for q in (11, 13, 17)],
        "q19_single_root_head_probe": run_q19_head_probe(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(run(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "incidence packet mine mismatch"
        print("C80 incidence packet mine: PASS")
    else:
        OUT.write_text(rendered)
        print(f"wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
