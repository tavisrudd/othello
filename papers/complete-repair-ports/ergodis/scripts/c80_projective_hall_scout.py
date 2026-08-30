#!/usr/bin/env python3
"""Bounded scout for the projective deletion-secant C80 Hall relation."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import random
from pathlib import Path


ROOT = Path(__file__).resolve().parents[4]
SOURCE = ROOT / "rust/scripts/c80_causal_nonpacking.py"


def load_source():
    spec = importlib.util.spec_from_file_location("c80_hall_source", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def saturates(neighbours: list[set[int]], right_count: int) -> bool:
    right_match = [-1] * right_count
    for root in range(len(neighbours)):
        parent_right = [-1] * right_count
        seen_left = {root}
        seen_right: set[int] = set()
        queue = [root]
        head = 0
        free = -1
        while head < len(queue) and free < 0:
            left = queue[head]
            head += 1
            for right in sorted(neighbours[left]):
                if right in seen_right:
                    continue
                seen_right.add(right)
                parent_right[right] = left
                next_left = right_match[right]
                if next_left < 0:
                    free = right
                    break
                if next_left not in seen_left:
                    seen_left.add(next_left)
                    queue.append(next_left)
        if free < 0:
            return False
        right = free
        while right >= 0:
            left = parent_right[right]
            previous = next(
                (candidate for candidate, owner in enumerate(right_match) if owner == left),
                -1,
            )
            right_match[right] = left
            right = previous
    return True


def point_list(points) -> list[list[int]]:
    return [list(point) for point in sorted(points)]


def primary_replay(source, q: int, issue: dict) -> bool:
    boundary = source.SmallBoundaryGame(q)
    game = boundary.game
    by_cell = {game.cell_tuple(index): index for index in range(q * q)}

    def mask(points) -> int:
        return sum(1 << by_cell[tuple(point)] for point in points)

    def cells(indices) -> list[list[int]]:
        return [
            list(game.cell_tuple(index)) for index in sorted(indices)
        ]

    state = mask(issue["state"])
    opponent = mask([issue["opponent"]])
    causal = mask([issue["causal"]])
    child = state | opponent
    successor = child | causal
    assert cells(boundary.defects(state)) == issue["old_defects"]
    assert cells(boundary.defects(child)) == issue["half_defects"]
    assert cells(boundary.defects(successor)) == issue["next_defects"]
    for fibre in issue["fibres"]:
        defect = mask([fibre["defect"]])
        before = child | defect
        replies = [
            reply
            for reply in source.KERNEL.GEOMETRY.bits(
                game.legal_mask(before)
            )
            if boundary.is_small_boundary(before | (1 << reply))
        ]
        assert cells(replies) == fibre["old_replies"]
    return True


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def write_json(path: Path, value: dict) -> None:
    temporary = path.with_name(f".{path.name}.{os.getpid()}.tmp")
    temporary.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")
    temporary.replace(path)


def scout(q: int, seed: int, state_budget: int, exchange_budget: int) -> dict:
    source = load_source()
    game = source.DirectSmallBoundaryGame(q)
    rng = random.Random(seed)
    states = set()
    attempts = 0
    while len(states) < state_budget and attempts < 20 * state_budget:
        attempts += 1
        state = frozenset()
        for _ in range(4):
            legal = game.legal(state)
            if not legal:
                break
            state |= {rng.choice(legal)}
        if len(state) == 4:
            states.add(state)

    counts = {
        "states": len(states),
        "complete_exchanges": 0,
        "exchanges_with_new_defects": 0,
        "new_defects": 0,
        "maximum_new_defects": 0,
        "uncovered_fibres": 0,
        "hall_failures": 0,
        "nondecreasing_exchanges": 0,
    }
    first_issue = None
    stop = False
    for state in sorted(states, key=lambda value: sorted(value)):
        old_defects = game.defects(state)
        for opponent in game.legal(state):
            if opponent not in old_defects:
                continue
            child = state | {opponent}
            half_defects = game.defects(child)
            for causal in game.legal(child):
                if causal not in old_defects:
                    continue
                counts["complete_exchanges"] += 1
                if counts["complete_exchanges"] > exchange_budget:
                    stop = True
                    break
                successor = child | {causal}
                next_defects = game.defects(successor)
                created = next_defects - half_defects - old_defects
                if not created:
                    continue
                consumed = old_defects - next_defects
                counts["exchanges_with_new_defects"] += 1
                counts["new_defects"] += len(created)
                counts["maximum_new_defects"] = max(
                    counts["maximum_new_defects"], len(created)
                )
                if len(consumed) <= len(created):
                    counts["nondecreasing_exchanges"] += 1

                labels = sorted(consumed)
                neighbours = []
                uncovered = []
                fibre_rows = []
                for defect in sorted(created):
                    before = child | {defect}
                    after = successor | {defect}
                    old_replies = [
                        reply
                        for reply in game.legal(before)
                        if game.is_small_boundary(before | {reply})
                    ]
                    new_replies = [
                        reply
                        for reply in game.legal(after)
                        if game.is_small_boundary(after | {reply})
                    ]
                    if new_replies:
                        raise AssertionError("a current defect has a certificate reply")
                    incident = set()
                    attacks = []
                    for reply in old_replies:
                        mode = "survives"
                        pivots = []
                        if reply == causal:
                            mode = "causal_reply_already_selected"
                        elif not game.legal_after(after, reply):
                            mode = "certificate_reply_secant_deletion"
                            pivots = sorted(
                                point
                                for point in before
                                if game.collinear(causal, reply, point)
                            )
                        for label_index, label in enumerate(labels):
                            if label == reply or (
                                reply != causal
                                and mode == "certificate_reply_secant_deletion"
                                and game.collinear(causal, reply, label)
                            ):
                                incident.add(label_index)
                        attacks.append(
                            {
                                "reply": list(reply),
                                "mode": mode,
                                "pivots": point_list(pivots),
                            }
                        )
                    neighbours.append(incident)
                    fibre_rows.append(
                        {
                            "defect": list(defect),
                            "old_replies": point_list(old_replies),
                            "attacks": attacks,
                            "incident_labels": point_list(
                                labels[index] for index in sorted(incident)
                            ),
                        }
                    )
                    if not incident:
                        uncovered.append(defect)

                hall = not uncovered and saturates(neighbours, len(labels))
                if uncovered:
                    counts["uncovered_fibres"] += len(uncovered)
                if not hall:
                    counts["hall_failures"] += 1
                if (uncovered or not hall or len(consumed) <= len(created)) and first_issue is None:
                    first_issue = {
                        "state": point_list(state),
                        "opponent": list(opponent),
                        "causal": list(causal),
                        "old_defects": point_list(old_defects),
                        "half_defects": point_list(half_defects),
                        "next_defects": point_list(next_defects),
                        "created": point_list(created),
                        "consumed": point_list(consumed),
                        "neighbours": [sorted(row) for row in neighbours],
                        "fibres": fibre_rows,
                        "uncovered": point_list(uncovered),
                        "hall": hall,
                        "omega": [
                            game.omega(state),
                            game.omega(child),
                            game.omega(successor),
                        ],
                        "successor_is_small_boundary": game.is_small_boundary(
                            successor
                        ),
                    }
                    stop = True
                    break
            if stop:
                break
        if stop:
            break

    result = {
        "schema": "c80-projective-hall-scout-v1",
        "q": q,
        "seed": seed,
        "state_budget": state_budget,
        "exchange_budget": exchange_budget,
        "source": str(SOURCE.relative_to(ROOT)),
        "source_sha256": sha256(SOURCE),
        "counts": counts,
        "first_issue": first_issue,
        "stopped_early": stop,
    }
    result["primary_replay"] = (
        primary_replay(source, q, first_issue)
        if first_issue is not None
        else None
    )
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, default=11)
    parser.add_argument("--seed", type=int, default=985_080_30)
    parser.add_argument("--states", type=int, default=100)
    parser.add_argument("--exchanges", type=int, default=10_000)
    output = parser.add_mutually_exclusive_group()
    output.add_argument("--write", type=Path)
    output.add_argument("--check", type=Path)
    args = parser.parse_args()
    result = scout(args.q, args.seed, args.states, args.exchanges)
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.write is not None:
        write_json(args.write, result)
    elif args.check is not None:
        if args.check.read_text() != encoded:
            raise SystemExit("certificate mismatch")
        print(f"PASS {hashlib.sha256(encoded.encode()).hexdigest()}")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
