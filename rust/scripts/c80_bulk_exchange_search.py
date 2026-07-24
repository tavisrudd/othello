#!/usr/bin/env python3
"""Bounded falsifier search for the C80 maximal-overload-drop bulk lemma.

Start with every selected-size-eight state on the chosen q=17 strict-kernel
response DAG.  Thereafter branch through every lower-K reply.  At each
positive-overload kernel state, test whether every marked opponent has some
maximal-overload-drop reply back into the lower kernel.
"""
from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from collections import Counter, deque
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-24-c80-bulk-exchange-search.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


KERNEL = load_module(
    ROOT / "rust/scripts/c80_strict_overload_kernel.py",
    "c80_bulk_exchange_kernel",
)


def cell(game, point: int) -> list[int]:
    return list(game.cell_tuple(point))


def selected_size_eight_frontier(kernel) -> set[int]:
    labels = KERNEL.escape_parameters(KERNEL.ROWS, 17)
    roots = [
        kernel.game.base_mask(label)
        for label in labels
        if kernel.contains(kernel.game.base_mask(label))
    ]
    frontier: set[int] = set()
    seen: set[int] = set()
    stack = list(roots)
    while stack:
        state = stack.pop()
        if state in seen:
            continue
        seen.add(state)
        if state.bit_count() >= 8:
            assert state.bit_count() == 8
            frontier.add(state)
            continue
        if kernel.omega(state) == 0:
            continue
        for opponent in KERNEL.GEOMETRY.bits(
            kernel.game.legal_mask(state)
        ):
            reply = kernel.responses[(state, opponent)]
            stack.append(state | (1 << opponent) | (1 << reply))
    return frontier


def exhaustive_small_order(q: int) -> dict:
    kernel = KERNEL.StrictKernel(q)
    reachable: set[int] = set()
    stack = [0]
    while stack:
        state = stack.pop()
        if state in reachable:
            continue
        reachable.add(state)
        stack.extend(
            state | (1 << point)
            for point in KERNEL.GEOMETRY.bits(
                kernel.game.legal_mask(state)
            )
        )

    kernel_states = 0
    positive_kernel_states = 0
    marked_edges = 0
    first_counterexample = None
    for state in sorted(reachable):
        if not kernel.contains(state):
            continue
        kernel_states += 1
        old_omega = kernel.omega(state)
        if old_omega == 0:
            continue
        positive_kernel_states += 1
        for opponent in KERNEL.GEOMETRY.bits(
            kernel.game.legal_mask(state)
        ):
            marked_edges += 1
            child = state | (1 << opponent)
            candidates = list(
                KERNEL.GEOMETRY.bits(kernel.game.legal_mask(child))
            )
            drops = {
                reply: old_omega
                - kernel.omega(child | (1 << reply))
                for reply in candidates
            }
            maximum_drop = max(drops.values())
            if not any(
                kernel.omega(child | (1 << reply)) < old_omega
                and kernel.contains(child | (1 << reply))
                for reply, drop in drops.items()
                if drop == maximum_drop
            ):
                first_counterexample = {
                    "state_mask": state,
                    "selected_size_residual": state.bit_count(),
                    "old_omega": old_omega,
                    "opponent": cell(kernel.game, opponent),
                    "maximum_drop": maximum_drop,
                }
                break
        if first_counterexample is not None:
            break

    return {
        "q": q,
        "reachable_states": len(reachable),
        "kernel_states_checked": kernel_states,
        "positive_kernel_states_checked": positive_kernel_states,
        "marked_edges_checked": marked_edges,
        "counterexample_found": first_counterexample is not None,
        "first_counterexample": first_counterexample,
        "search_complete": first_counterexample is None,
    }


def run(max_states: int) -> dict:
    kernel = KERNEL.StrictKernel(17)
    frontier = selected_size_eight_frontier(kernel)
    queue = deque(sorted(frontier))
    enqueued = set(frontier)
    processed = 0
    states_by_size = Counter()
    positive_states_by_size = Counter()
    boundary_states_by_size = Counter()
    marked_edges = 0
    lower_kernel_targets = 0
    lower_kernel_target_omega = Counter()
    counterexample = None

    while queue and processed < max_states and counterexample is None:
        state = queue.popleft()
        processed += 1
        states_by_size[state.bit_count()] += 1
        old_omega = kernel.omega(state)
        if old_omega == 0:
            boundary_states_by_size[state.bit_count()] += 1
            continue
        positive_states_by_size[state.bit_count()] += 1

        for opponent in KERNEL.GEOMETRY.bits(
            kernel.game.legal_mask(state)
        ):
            marked_edges += 1
            child = state | (1 << opponent)
            candidates = list(
                KERNEL.GEOMETRY.bits(kernel.game.legal_mask(child))
            )
            drops = {
                reply: old_omega
                - kernel.omega(child | (1 << reply))
                for reply in candidates
            }
            maximum_drop = max(drops.values())
            max_packet = [
                reply
                for reply, drop in drops.items()
                if drop == maximum_drop
            ]
            max_kernel = [
                reply
                for reply in max_packet
                if kernel.omega(child | (1 << reply)) < old_omega
                and kernel.contains(child | (1 << reply))
            ]
            if not max_kernel:
                all_kernel = [
                    reply
                    for reply in candidates
                    if kernel.omega(child | (1 << reply)) < old_omega
                    and kernel.contains(child | (1 << reply))
                ]
                assert all_kernel
                counterexample = {
                    "state_mask": state,
                    "selected_size": state.bit_count(),
                    "old_omega": old_omega,
                    "opponent": cell(kernel.game, opponent),
                    "maximum_drop": maximum_drop,
                    "max_packet": [
                        {
                            "reply": cell(kernel.game, reply),
                            "target_omega": kernel.omega(
                                child | (1 << reply)
                            ),
                        }
                        for reply in max_packet
                    ],
                    "lower_kernel_replies": [
                        {
                            "reply": cell(kernel.game, reply),
                            "drop": drops[reply],
                            "target_omega": kernel.omega(
                                child | (1 << reply)
                            ),
                        }
                        for reply in all_kernel
                    ],
                }
                break

            for reply in candidates:
                target = child | (1 << reply)
                if (
                    kernel.omega(target) < old_omega
                    and kernel.contains(target)
                ):
                    lower_kernel_targets += 1
                    lower_kernel_target_omega[kernel.omega(target)] += 1
                    if target not in enqueued:
                        enqueued.add(target)
                        queue.append(target)

    return {
        "schema": "c80-bulk-exchange-search-v1",
        "q": 17,
        "domain": (
            "breadth-first closure from the chosen-DAG selected-size-eight "
            "frontier through every strict lower-K reply"
        ),
        "max_states": max_states,
        "frontier_states": len(frontier),
        "processed_states": processed,
        "states_by_selected_size": {
            str(size): count for size, count in sorted(states_by_size.items())
        },
        "positive_states_by_selected_size": {
            str(size): count
            for size, count in sorted(positive_states_by_size.items())
        },
        "boundary_states_by_selected_size": {
            str(size): count
            for size, count in sorted(boundary_states_by_size.items())
        },
        "marked_edges_checked": marked_edges,
        "lower_kernel_targets_seen": lower_kernel_targets,
        "lower_kernel_target_omega_histogram": {
            str(omega): count
            for omega, count in sorted(lower_kernel_target_omega.items())
        },
        "queue_remaining": len(queue),
        "search_complete": not queue and counterexample is None,
        "counterexample_found": counterexample is not None,
        "counterexample": counterexample,
        "exhaustive_small_orders": [
            exhaustive_small_order(q) for q in (5, 7)
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-states", type=int, default=5000)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(
        run(args.max_states), indent=2, sort_keys=True
    ) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "bulk exchange search mismatch"
        print("C80 bulk exchange search: PASS")
    else:
        OUT.write_text(rendered)
        print(f"wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
