#!/usr/bin/env python3
"""Bounded scout for the projective deletion-secant C80 Hall relation."""

from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import os
import random
import shutil
from collections import Counter
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
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


def ancestral_secant_relation(game, state, created, consumed):
    labels = sorted(consumed)
    neighbours = []
    carriers = []
    for defect in sorted(created):
        incident = set()
        edge_carriers = {}
        for label_index, label in enumerate(labels):
            witnesses = sorted(
                selected
                for selected in state
                if selected not in (defect, label)
                and game.collinear(defect, label, selected)
            )
            if witnesses:
                incident.add(label_index)
                edge_carriers[label_index] = witnesses
        neighbours.append(incident)
        carriers.append(edge_carriers)
    return labels, neighbours, carriers


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


class FeatureSink:
    FIELDS = [
        "q",
        "state_omega",
        "target_omega",
        "omega_drop",
        "old_defect_rank",
        "half_defect_rank",
        "next_defect_rank",
        "support_surplus",
        "created",
        "consumed",
        "omega_descends",
        "charge_descends",
    ]

    def __init__(self, output: Path | None):
        self.output = output
        self.count = 0
        self.raw_path = None
        self.raw = None
        if output is not None:
            self.raw_path = output.with_name(f".{output.name}.{os.getpid()}.rows")
            self.raw = self.raw_path.open("x", encoding="utf-8")

    def append(self, expected: bool, values: list[int]) -> None:
        if self.raw is None:
            return
        row = {
            "id": self.count,
            "weight": 1,
            "expected": expected,
            "values": values,
        }
        self.raw.write(json.dumps(row, separators=(",", ":")) + "\n")
        self.count += 1

    def finish(self, q: int, seed: int) -> None:
        if self.raw is None or self.output is None or self.raw_path is None:
            return
        self.raw.close()
        header = {
            "schema": "ergodis-campaign-data-v0",
            "presentation": f"c80-q{q}-reply-features-seed-{seed}",
            "problem": "C80 projective reply survivor classification",
            "fields": self.FIELDS,
            "rows": self.count,
        }
        with self.output.open("x", encoding="utf-8") as stream:
            stream.write(json.dumps(header, separators=(",", ":")) + "\n")
            with self.raw_path.open("r", encoding="utf-8") as raw:
                shutil.copyfileobj(raw, stream, length=1024 * 1024)
        self.raw_path.unlink()


def scout(
    q: int,
    seed: int,
    state_budget: int,
    exchange_budget: int,
    continue_after_issue: bool,
    p_admission: bool,
    feature_output: Path | None = None,
    root_generator: str = "python",
) -> dict:
    source = load_source()
    game = source.DirectSmallBoundaryGame(q)
    primary = source.SmallBoundaryGame(q)
    by_cell = {
        game.board[index]: index
        for index in range(q * q)
    }

    def primary_mask(state) -> int:
        return sum(1 << by_cell[point] for point in state)
    feature_sink = FeatureSink(feature_output)
    states = set()
    attempts = 0
    rng = random.Random(seed)
    xorshift = max(seed, 1)

    def choose(legal):
        nonlocal xorshift
        if root_generator == "python":
            return rng.choice(legal)
        xorshift ^= (xorshift << 13) & ((1 << 64) - 1)
        xorshift ^= xorshift >> 7
        xorshift ^= (xorshift << 17) & ((1 << 64) - 1)
        xorshift &= (1 << 64) - 1
        return legal[xorshift % len(legal)]

    while len(states) < state_budget and attempts < 20 * state_budget:
        attempts += 1
        state = frozenset()
        for _ in range(4):
            legal = game.legal(state)
            if not legal:
                break
            state |= {choose(legal)}
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
        "complete_relation_hall_failures": 0,
        "support_first_lex_failures": 0,
        "omega_first_lex_failures": 0,
    }
    first_issue = None
    admission_counts = {
        "sampled_states_in_K_Omega": 0,
        "positive_omega_states": 0,
        "opponents": 0,
        "legal_replies": 0,
        "non_omega_descending_replies": 0,
        "omega_descending_non_survivor_replies": 0,
        "omega_descending_replies": 0,
        "with_certified_reply": 0,
        "without_certified_reply": 0,
        "with_charge_admissible_reply": 0,
        "without_charge_admissible_reply": 0,
        "certified_replies": 0,
        "charge_admissible_replies": 0,
        "minimum_certified_replies_per_opponent": 1 << 60,
        "maximum_certified_replies_per_opponent": 0,
        "minimum_certified_support_surplus": 1 << 60,
        "equal_support_certified_replies": 0,
        "minimum_equal_support_omega_drop": 1 << 60,
        "certified_replies_with_new_defects": 0,
        "ancestral_secant_edges": 0,
        "ancestral_secant_zero_degree_defects": 0,
        "ancestral_secant_hall_failures": 0,
    }
    first_admission_miss = None
    first_ancestral_secant_failure = None
    equality_profiles: Counter[str] = Counter()
    delta_profiles: Counter[str] = Counter()
    stop = False
    for state in sorted(states, key=lambda value: sorted(value)):
        old_defects = game.defects(state)
        if p_admission:
            state_mask = primary_mask(state)
            if primary.kernel.contains(state_mask):
                admission_counts["sampled_states_in_K_Omega"] += 1
                old_omega = primary.kernel.omega(state_mask)
                if old_omega > 0:
                    admission_counts["positive_omega_states"] += 1
                    for opponent in game.legal(state):
                        admission_counts["opponents"] += 1
                        child = state | {opponent}
                        half_defects = game.defects(child)
                        reply_rows = []
                        certified = 0
                        admissible = 0
                        for reply in game.legal(child):
                            admission_counts["legal_replies"] += 1
                            target = child | {reply}
                            target_mask = primary_mask(target)
                            omega_descends = (
                                primary.kernel.omega(target_mask) < old_omega
                            )
                            if omega_descends:
                                admission_counts["omega_descending_replies"] += 1
                                survivor = primary.kernel.contains(target_mask)
                                if not survivor:
                                    admission_counts[
                                        "omega_descending_non_survivor_replies"
                                    ] += 1
                            else:
                                admission_counts[
                                    "non_omega_descending_replies"
                                ] += 1
                                survivor = False
                            target_defects = game.defects(target)
                            created = target_defects - half_defects - old_defects
                            consumed = old_defects - target_defects
                            target_omega = game.omega(target)
                            charge = len(consumed) > len(created) or (
                                len(consumed) == len(created)
                                and target_omega < game.omega(state)
                            )
                            feature_sink.append(
                                survivor,
                                [
                                    q,
                                    game.omega(state),
                                    target_omega,
                                    game.omega(state) - target_omega,
                                    len(old_defects),
                                    len(half_defects),
                                    len(target_defects),
                                    len(consumed) - len(created),
                                    len(created),
                                    len(consumed),
                                    int(omega_descends),
                                    int(charge),
                                ],
                            )
                            reply_rows.append(
                                (
                                    reply,
                                    len(target_defects),
                                    target_omega,
                                    survivor,
                                    charge,
                                )
                            )
                            if survivor:
                                certified += 1
                                admissible += int(charge)
                                if created:
                                    admission_counts[
                                        "certified_replies_with_new_defects"
                                    ] += 1
                                    labels, relation, carriers = ancestral_secant_relation(
                                        game, state, created, consumed
                                    )
                                    admission_counts["ancestral_secant_edges"] += sum(
                                        len(row) for row in relation
                                    )
                                    admission_counts[
                                        "ancestral_secant_zero_degree_defects"
                                    ] += sum(not row for row in relation)
                                    hall = all(relation) and saturates(
                                        relation, len(labels)
                                    )
                                    if not hall:
                                        admission_counts[
                                            "ancestral_secant_hall_failures"
                                        ] += 1
                                        if first_ancestral_secant_failure is None:
                                            first_ancestral_secant_failure = {
                                                "state": point_list(state),
                                                "opponent": list(opponent),
                                                "reply": list(reply),
                                                "created": point_list(created),
                                                "consumed": point_list(consumed),
                                                "neighbours": [
                                                    sorted(row) for row in relation
                                                ],
                                                "edge_carriers": [
                                                    {
                                                        str(label): point_list(points)
                                                        for label, points in sorted(row.items())
                                                    }
                                                    for row in carriers
                                                ],
                                            }
                                surplus = len(consumed) - len(created)
                                admission_counts[
                                    "minimum_certified_support_surplus"
                                ] = min(
                                    admission_counts[
                                        "minimum_certified_support_surplus"
                                    ],
                                    surplus,
                                )
                                if surplus == 0:
                                    admission_counts[
                                        "equal_support_certified_replies"
                                    ] += 1
                                    admission_counts[
                                        "minimum_equal_support_omega_drop"
                                    ] = min(
                                        admission_counts[
                                            "minimum_equal_support_omega_drop"
                                        ],
                                        game.omega(state) - target_omega,
                                    )
                        admission_counts["certified_replies"] += certified
                        admission_counts["charge_admissible_replies"] += admissible
                        admission_counts[
                            "minimum_certified_replies_per_opponent"
                        ] = min(
                            admission_counts[
                                "minimum_certified_replies_per_opponent"
                            ],
                            certified,
                        )
                        admission_counts[
                            "maximum_certified_replies_per_opponent"
                        ] = max(
                            admission_counts[
                                "maximum_certified_replies_per_opponent"
                            ],
                            certified,
                        )
                        if certified:
                            admission_counts["with_certified_reply"] += 1
                        else:
                            admission_counts["without_certified_reply"] += 1
                        if admissible:
                            admission_counts["with_charge_admissible_reply"] += 1
                        else:
                            admission_counts[
                                "without_charge_admissible_reply"
                            ] += 1
                            if first_admission_miss is None:
                                first_admission_miss = {
                                    "state": point_list(state),
                                    "opponent": list(opponent),
                                    "old_defect_rank": len(old_defects),
                                    "old_omega": old_omega,
                                    "legal_replies": len(reply_rows),
                                    "certified_replies": [
                                        {
                                            "reply": list(reply),
                                            "next_defect_rank": rank,
                                            "next_omega": omega,
                                            "charge_descends": charge,
                                        }
                                        for reply, rank, omega, survivor, charge
                                        in reply_rows
                                        if survivor
                                    ],
                                }
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
                if len(consumed) < len(created):
                    counts["complete_relation_hall_failures"] += 1
                old_support = len(old_defects)
                next_support = old_support - len(consumed) + len(created)
                old_omega = game.omega(state)
                next_omega = game.omega(successor)
                support_first_descends = (next_support, next_omega) < (
                    old_support,
                    old_omega,
                )
                omega_first_descends = (next_omega, next_support) < (
                    old_omega,
                    old_support,
                )
                if not support_first_descends:
                    counts["support_first_lex_failures"] += 1
                if not omega_first_descends:
                    counts["omega_first_lex_failures"] += 1
                if next_support == old_support:
                    profile = (
                        len(old_defects),
                        len(next_defects),
                        len(created),
                        old_omega,
                        next_omega,
                    )
                    equality_profiles["/".join(map(str, profile))] += 1
                persistent_intermediate = len((half_defects - old_defects) & next_defects)
                delta_profile = (
                    len(consumed) - len(created),
                    old_omega - next_omega,
                    len(old_defects),
                    len(half_defects),
                    len(next_defects),
                    persistent_intermediate,
                )
                delta_profiles["/".join(map(str, delta_profile))] += 1

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
                            old_omega,
                            game.omega(child),
                            next_omega,
                        ],
                        "charged_support": [old_support, next_support],
                        "support_first_descends": support_first_descends,
                        "omega_first_descends": omega_first_descends,
                        "successor_is_small_boundary": game.is_small_boundary(
                            successor
                        ),
                    }
                    if not continue_after_issue:
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
        "continue_after_issue": continue_after_issue,
        "source": str(SOURCE.relative_to(ROOT)),
        "source_sha256": sha256(SOURCE),
        "counts": counts,
        "first_issue": first_issue,
        "stopped_early": stop,
    }
    if root_generator != "python":
        result["root_generator"] = root_generator
    result["primary_replay"] = (
        primary_replay(source, q, first_issue)
        if first_issue is not None
        else None
    )
    if continue_after_issue:
        result["equal_support_profiles_oldrank_nextrank_created_omega"] = dict(
            sorted(equality_profiles.items())
        )
        result["delta_profiles_support_omega_old_half_next_persistent"] = dict(
            sorted(delta_profiles.items())
        )
    if p_admission:
        for field in (
            "minimum_certified_replies_per_opponent",
            "minimum_certified_support_surplus",
            "minimum_equal_support_omega_drop",
        ):
            if admission_counts[field] == 1 << 60:
                admission_counts[field] = None
        result["K_Omega_p_admission"] = admission_counts
        result["first_K_Omega_admission_miss"] = first_admission_miss
        result["first_ancestral_secant_admission_failure"] = (
            first_ancestral_secant_failure
        )
    feature_sink.finish(q, seed)
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, default=11)
    parser.add_argument("--seed", type=int, default=985_080_30)
    parser.add_argument("--states", type=int, default=100)
    parser.add_argument("--exchanges", type=int, default=10_000)
    parser.add_argument("--continue-after-issue", action="store_true")
    parser.add_argument("--p-admission", action="store_true")
    parser.add_argument("--feature-output", type=Path)
    parser.add_argument(
        "--root-generator",
        choices=("python", "xorshift64"),
        default="python",
        help="deterministic root sampler; xorshift64 is the Rust parity oracle",
    )
    output = parser.add_mutually_exclusive_group()
    output.add_argument("--write", type=Path)
    output.add_argument("--check", type=Path)
    args = parser.parse_args()
    result = scout(
        args.q,
        args.seed,
        args.states,
        args.exchanges,
        args.continue_after_issue,
        args.p_admission,
        args.feature_output,
        args.root_generator,
    )
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
