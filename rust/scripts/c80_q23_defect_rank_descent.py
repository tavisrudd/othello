#!/usr/bin/env python3
"""C80: test q23 defect-rank descent and extract its first obstruction."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import Counter
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_defect_three_update.py"
OUT = ROOT / "notes/2026-07-25-c80-q23-defect-rank-descent.json"

Q = 23
T4 = (1, 2, 3, 4)
HISTORY = ((0, 0), (5, 2))


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_defect_rank_base")
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE
INPUTS = tuple(sorted(set((*BASE.INPUTS, SOURCE))))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class DescentCensus:
    def __init__(self):
        self.update = BASE.DefectUpdate()
        self.shell = self.update.shell
        self.kernel = self.update.kernel
        self.game = self.update.game
        self.ranked_state_histogram = Counter()
        self.ranked_defect_obligations = 0
        self.ranked_legal_replies_examined = 0

    def control(self) -> int:
        mask = self.game.base_mask(T4)
        for cell in HISTORY:
            mask |= 1 << LIVE.cell_index(self.game, cell)
        return mask

    @lru_cache(maxsize=None)
    def defect_rank(self, mask: int) -> int:
        return len(self.update.defect(mask))

    @lru_cache(maxsize=None)
    def defect_response(self, mask: int, opponent: int) -> dict:
        """Best rank reachable after a fixed defect opponent."""
        rank = self.defect_rank(mask)
        child = mask | (1 << opponent)
        rows = []
        for reply in GEOMETRY.bits(self.game.legal_mask(child)):
            target = child | (1 << reply)
            next_rank = self.defect_rank(target)
            rows.append(
                {
                    "reply": list(self.game.cell_tuple(reply)),
                    "next_defect_rank": next_rank,
                    "target_omega": self.kernel.omega(target),
                    "target_legal_moves": self.game.legal_mask(
                        target
                    ).bit_count(),
                }
            )
        assert rows
        minimum = min(row["next_defect_rank"] for row in rows)
        minimizers = [
            row for row in rows if row["next_defect_rank"] == minimum
        ]
        return {
            "opponent": list(self.game.cell_tuple(opponent)),
            "current_defect_rank": rank,
            "legal_replies_tested": len(rows),
            "minimum_next_defect_rank": minimum,
            "descending": minimum < rank,
            "minimizers": minimizers,
        }

    def follower(self, mask: int) -> dict:
        defects = self.update.defect(mask)
        rank = len(defects)
        assert rank > 0
        responses = [
            self.defect_response(mask, opponent) for opponent in defects
        ]
        blockers = [row for row in responses if not row["descending"]]
        return {
            "defect_rank": rank,
            "legal_moves": self.game.legal_mask(mask).bit_count(),
            "omega": self.kernel.omega(mask),
            "defect_opponents": len(responses),
            "defect_opponents_with_lower_rank_reply": (
                len(responses) - len(blockers)
            ),
            "descent_holds": not blockers,
            "first_blocker": blockers[0] if blockers else None,
            "minimum_rank_change": min(
                row["minimum_next_defect_rank"] - rank
                for row in responses
            ),
            "maximum_minimum_rank_change": max(
                row["minimum_next_defect_rank"] - rank
                for row in responses
            ),
        }

    def selected_cells(self, mask: int) -> list[list[int]]:
        return [
            list(self.game.cell_tuple(point))
            for point in GEOMETRY.bits(mask)
        ]

    @lru_cache(maxsize=None)
    def ranked_survivor(self, mask: int) -> dict:
        """Well-founded defect-rank closure with a canonical obstruction."""
        defects = self.update.defect(mask)
        rank = len(defects)
        self.ranked_state_histogram[rank] += 1
        if rank == 0:
            return {
                "holds": True,
                "rank": 0,
                "witness_edges": [],
                "first_nondecreasing_obstruction": None,
            }

        witnesses = []
        for opponent in defects:
            self.ranked_defect_obligations += 1
            child = mask | (1 << opponent)
            lower = []
            ranks = []
            for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                self.ranked_legal_replies_examined += 1
                target = child | (1 << reply)
                next_rank = self.defect_rank(target)
                ranks.append((reply, next_rank, target))
                if next_rank < rank:
                    lower.append((reply, next_rank, target))
            if not ranks:
                return {
                    "holds": False,
                    "rank": rank,
                    "witness_edges": witnesses,
                    "first_nondecreasing_obstruction": {
                        "state_cells": self.selected_cells(mask),
                        "state_defect_rank": rank,
                        "state_legal_moves": self.game.legal_mask(
                            mask
                        ).bit_count(),
                        "state_omega": self.kernel.omega(mask),
                        "defect_opponent": list(
                            self.game.cell_tuple(opponent)
                        ),
                        "legal_replies_tested": 0,
                        "minimum_next_defect_rank": None,
                        "rank_change": None,
                        "minimizers": [],
                    },
                }
            if not lower:
                minimum = min(next_rank for _, next_rank, _ in ranks)
                minimizers = [
                    {
                        "reply": list(self.game.cell_tuple(reply)),
                        "next_defect_rank": next_rank,
                    }
                    for reply, next_rank, _ in ranks
                    if next_rank == minimum
                ]
                return {
                    "holds": False,
                    "rank": rank,
                    "witness_edges": witnesses,
                    "first_nondecreasing_obstruction": {
                        "state_cells": self.selected_cells(mask),
                        "state_defect_rank": rank,
                        "state_legal_moves": self.game.legal_mask(
                            mask
                        ).bit_count(),
                        "state_omega": self.kernel.omega(mask),
                        "defect_opponent": list(
                            self.game.cell_tuple(opponent)
                        ),
                        "legal_replies_tested": len(ranks),
                        "minimum_next_defect_rank": minimum,
                        "rank_change": minimum - rank,
                        "minimizers": minimizers,
                    },
                }

            successful = None
            first_failure = None
            for reply, next_rank, target in lower:
                result = self.ranked_survivor(target)
                if result["holds"]:
                    successful = {
                        "opponent": list(self.game.cell_tuple(opponent)),
                        "reply": list(self.game.cell_tuple(reply)),
                        "next_defect_rank": next_rank,
                    }
                    break
                if first_failure is None:
                    first_failure = result[
                        "first_nondecreasing_obstruction"
                    ]
            if successful is None:
                assert first_failure is not None
                return {
                    "holds": False,
                    "rank": rank,
                    "witness_edges": witnesses,
                    "first_nondecreasing_obstruction": first_failure,
                }
            witnesses.append(successful)

        return {
            "holds": True,
            "rank": rank,
            "witness_edges": witnesses,
            "first_nondecreasing_obstruction": None,
        }

    def outer_fibre(self, control: int, opponent: int) -> dict:
        child = control | (1 << opponent)
        rows = []
        for reply in GEOMETRY.bits(self.game.legal_mask(child)):
            follower_mask = child | (1 << reply)
            row = self.follower(follower_mask)
            rows.append(
                {
                    "reply": list(self.game.cell_tuple(reply)),
                    **row,
                }
            )
        passing = [row for row in rows if row["descent_holds"]]
        minimum_rank = min(row["defect_rank"] for row in rows)
        minimum_rank_rows = [
            row for row in rows if row["defect_rank"] == minimum_rank
        ]
        passing_minimum_rank = [
            row for row in minimum_rank_rows if row["descent_holds"]
        ]
        rank_histogram = Counter(row["defect_rank"] for row in rows)
        blocker_rank_changes = Counter(
            row["first_blocker"]["minimum_next_defect_rank"]
            - row["defect_rank"]
            for row in rows
            if row["first_blocker"] is not None
        )
        return {
            "opponent": list(self.game.cell_tuple(opponent)),
            "legal_replies_tested": len(rows),
            "replies_satisfying_defect_descent": len(passing),
            "minimum_follower_defect_rank": minimum_rank,
            "minimum_rank_replies": len(minimum_rank_rows),
            "minimum_rank_replies_satisfying_descent": len(
                passing_minimum_rank
            ),
            "follower_defect_rank_histogram": [
                {"defect_rank": rank, "replies": count}
                for rank, count in sorted(rank_histogram.items())
            ],
            "first_blocker_rank_change_histogram": [
                {"rank_change": change, "replies": count}
                for change, count in sorted(blocker_rank_changes.items())
            ],
            "first_passing_reply": passing[0] if passing else None,
            "first_passing_minimum_rank_reply": (
                passing_minimum_rank[0] if passing_minimum_rank else None
            ),
            "first_blocked_reply": next(
                (row for row in rows if not row["descent_holds"]),
                None,
            ),
            "first_blocked_minimum_rank_reply": next(
                (
                    row for row in minimum_rank_rows
                    if not row["descent_holds"]
                ),
                None,
            ),
        }


def build_certificate() -> dict:
    census = DescentCensus()
    game = census.game
    control = census.control()
    control_legal = tuple(GEOMETRY.bits(game.legal_mask(control)))
    assert len(control_legal) == 118

    tested = []
    for opponent in control_legal:
        row = census.outer_fibre(control, opponent)
        tested.append(row)

    unrestricted_failures = [
        row for row in tested
        if row["replies_satisfying_defect_descent"] == 0
    ]
    greedy_failures = [
        row for row in tested
        if row["minimum_rank_replies_satisfying_descent"] == 0
    ]
    assert not unrestricted_failures
    assert all(row["first_blocked_reply"] is None for row in tested)
    greedy_obstruction = greedy_failures[0] if greedy_failures else None
    greedy_blocker = (
        greedy_obstruction["first_blocked_minimum_rank_reply"]
        if greedy_obstruction is not None else None
    )
    if greedy_blocker is not None:
        assert greedy_blocker["first_blocker"] is not None

    recursive_rows = []
    recursive_obstruction = None
    for opponent in control_legal:
        child = control | (1 << opponent)
        replies_tested = 0
        first_failure = None
        first_failed_reply = None
        witness = None
        candidates = []
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            target = child | (1 << reply)
            candidates.append(
                (census.defect_rank(target), reply, target)
            )
        candidates.sort()
        minimum_candidate_rank = candidates[0][0]
        for initial_rank, reply, target in candidates:
            replies_tested += 1
            result = census.ranked_survivor(target)
            if result["holds"]:
                witness = {
                    "reply": list(game.cell_tuple(reply)),
                    "initial_defect_rank": initial_rank,
                    "is_minimum_rank_reply": (
                        initial_rank == minimum_candidate_rank
                    ),
                }
                break
            if first_failure is None:
                first_failure = result[
                    "first_nondecreasing_obstruction"
                ]
                first_failed_reply = {
                    "reply": list(game.cell_tuple(reply)),
                    "initial_defect_rank": initial_rank,
                    "is_minimum_rank_reply": (
                        initial_rank == minimum_candidate_rank
                    ),
                }
        row = {
            "opponent": list(game.cell_tuple(opponent)),
            "outer_replies_tested_until_witness_or_exhaustion": (
                replies_tested
            ),
            "minimum_candidate_defect_rank": minimum_candidate_rank,
            "ranked_survivor_reply_found": witness is not None,
            "first_witness": witness,
            "first_failed_reply": first_failed_reply,
            "first_failure_nondecreasing_obstruction": first_failure,
        }
        recursive_rows.append(row)
        if witness is None:
            assert first_failure is not None
            recursive_obstruction = {
                "outer_opponent": list(game.cell_tuple(opponent)),
                "outer_replies_tested": replies_tested,
                **first_failure,
            }
            break

    first_recursive_greedy_failure = next(
        (
            row for row in recursive_rows
            if row["first_witness"] is not None
            and not row["first_witness"]["is_minimum_rank_reply"]
        ),
        None,
    )
    if first_recursive_greedy_failure is not None:
        greedy_obstruction = first_recursive_greedy_failure[
            "first_failure_nondecreasing_obstruction"
        ]
        greedy_mask = 0
        for cell in greedy_obstruction["state_cells"]:
            greedy_mask |= 1 << LIVE.cell_index(game, tuple(cell))
        greedy_opponent = LIVE.cell_index(
            game, tuple(greedy_obstruction["defect_opponent"])
        )
        greedy_replay = census.defect_response(
            greedy_mask, greedy_opponent
        )
        assert not greedy_replay["descending"]
        assert (
            greedy_replay["minimum_next_defect_rank"]
            == greedy_obstruction["minimum_next_defect_rank"]
        )

    if recursive_obstruction is not None:
        obstruction_mask = 0
        for cell in recursive_obstruction["state_cells"]:
            obstruction_mask |= 1 << LIVE.cell_index(game, tuple(cell))
        obstruction_opponent = LIVE.cell_index(
            game, tuple(recursive_obstruction["defect_opponent"])
        )
        obstruction_child = obstruction_mask | (1 << obstruction_opponent)
        replay_replies = tuple(
            GEOMETRY.bits(game.legal_mask(obstruction_child))
        )
        assert len(replay_replies) == recursive_obstruction[
            "legal_replies_tested"
        ]
        if replay_replies:
            replay = census.defect_response(
                obstruction_mask, obstruction_opponent
            )
            assert not replay["descending"]
            assert (
                replay["minimum_next_defect_rank"]
                == recursive_obstruction["minimum_next_defect_rank"]
            )

    total_outer_replies = sum(
        row["legal_replies_tested"] for row in tested
    )
    initial_rank_histogram = Counter(
        row["first_witness"]["initial_defect_rank"]
        for row in recursive_rows
        if row["first_witness"] is not None
    )

    return {
        "schema": "c80-q23-defect-rank-descent-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "quantifier_tested": (
            "for every outer opponent there exists an outer reply such "
            "that every defect opponent has a legal reply of strictly "
            "smaller defect rank"
        ),
        "canonical_order": (
            "affine cell indices inherited from the normalized q23 grid"
        ),
        "control": {
            "q": Q,
            "root_t4": list(T4),
            "history": [list(cell) for cell in HISTORY],
            "legal_outer_opponents": len(control_legal),
            "omega": census.kernel.omega(control),
        },
        "search": {
            "outer_fibres_tested": len(tested),
            "outer_fibres_total": len(control_legal),
            "outer_fibres_with_some_passing_reply": (
                len(tested) - len(unrestricted_failures)
            ),
            "outer_fibres_with_passing_minimum_rank_reply": (
                len(tested) - len(greedy_failures)
            ),
            "rows": tested,
        },
        "recursive_ranked_survivor_search": {
            "outer_fibres_tested_before_stop": len(recursive_rows),
            "outer_fibres_total": len(control_legal),
            "outer_fibres_with_witness_before_stop": sum(
                row["ranked_survivor_reply_found"]
                for row in recursive_rows
            ),
            "total_outer_replies_in_local_census": total_outer_replies,
            "ranked_states_visited": sum(
                census.ranked_state_histogram.values()
            ),
            "ranked_state_histogram": [
                {"defect_rank": rank, "states": count}
                for rank, count in sorted(
                    census.ranked_state_histogram.items()
                )
            ],
            "defect_obligations_checked": (
                census.ranked_defect_obligations
            ),
            "legal_replies_examined": (
                census.ranked_legal_replies_examined
            ),
            "initial_witness_rank_histogram": [
                {"defect_rank": rank, "outer_fibres": count}
                for rank, count in sorted(initial_rank_histogram.items())
            ],
            "rows": recursive_rows,
        },
        "first_nondecreasing_obstruction": recursive_obstruction,
        "first_greedy_recursive_nondecreasing_obstruction": (
            None if first_recursive_greedy_failure is None else {
                "outer_opponent": first_recursive_greedy_failure[
                    "opponent"
                ],
                "failed_outer_reply": first_recursive_greedy_failure[
                    "first_failed_reply"
                ],
                "obstruction": first_recursive_greedy_failure[
                    "first_failure_nondecreasing_obstruction"
                ],
                "eventual_witness": first_recursive_greedy_failure[
                    "first_witness"
                ],
            }
        ),
        "first_greedy_minimum_rank_obstruction": (
            None if greedy_blocker is None else {
                "outer_opponent": greedy_obstruction["opponent"],
                "minimum_follower_defect_rank": greedy_obstruction[
                    "minimum_follower_defect_rank"
                ],
                "minimum_rank_replies_tested": greedy_obstruction[
                    "minimum_rank_replies"
                ],
                "outer_reply": greedy_blocker["reply"],
                "defect_opponent": greedy_blocker["first_blocker"][
                    "opponent"
                ],
                "minimum_next_defect_rank": greedy_blocker[
                    "first_blocker"
                ]["minimum_next_defect_rank"],
                "rank_change": (
                    greedy_blocker["first_blocker"][
                        "minimum_next_defect_rank"
                    ] - greedy_blocker["defect_rank"]
                ),
                "minimizing_replies": greedy_blocker["first_blocker"][
                    "minimizers"
                ],
            }
        ),
        "verdict": {
            "one_step_existential_outer_coverage": (
                f"{len(tested) - len(unrestricted_failures)}/{len(tested)}"
            ),
            "greedy_minimum_rank_outer_coverage": (
                f"{len(tested) - len(greedy_failures)}/{len(tested)}"
            ),
            "raw_replywise_defect_descent": "PASS_ALL_118_FIBRES",
            "recursive_ranked_survivor": (
                "PASS" if recursive_obstruction is None else "FAIL"
            ),
            "greedy_recursive_minimum_rank_rule": (
                "PASS" if first_recursive_greedy_failure is None
                else "FAIL"
            ),
            "q23_control_candidate": recursive_obstruction is None,
            "uniform_c80_theorem": "OPEN",
            "bounded_negative_scope": (
                (
                    "greedy minimum-rank recursive choice on the normalized "
                    "q23 control"
                ) if first_recursive_greedy_failure is not None else (
                    None if recursive_obstruction is None else
                "the first canonical recursively reached nondecreasing "
                "obstruction inside the normalized q23 control"
                )
            ),
        },
    }


def write_certificate(path: Path) -> None:
    path.write_text(
        json.dumps(build_certificate(), indent=2, sort_keys=True) + "\n"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as directory:
            candidate = Path(directory) / OUT.name
            write_certificate(candidate)
            if candidate.read_bytes() != OUT.read_bytes():
                raise SystemExit(f"certificate mismatch: {OUT}")
        print(f"PASS {OUT.relative_to(ROOT)}")
        return
    write_certificate(OUT)
    print(f"WROTE {OUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
