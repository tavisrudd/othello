#!/usr/bin/env python3
"""C80: certify the direct q23 rank-zero defect correspondence."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q23_defect_rank_descent.py"
OUT = ROOT / "notes/2026-07-25-c80-q23-rank-zero-correspondence.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_farsighted_base")
GEOMETRY = BASE.GEOMETRY
INPUTS = tuple(sorted(set((*BASE.INPUTS, SOURCE))))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build_certificate() -> dict:
    census = BASE.DescentCensus()
    game = census.game
    control = census.control()
    selectors = {
        "maximum_rank": lambda row: (row["rank"],),
        "maximum_minimum_descent_degree": lambda row: (
            row["minimum_descent_degree"],
        ),
        "maximum_total_descent_edges": lambda row: (
            row["total_descent_edges"],
        ),
        "maximum_min_degree_then_edges": lambda row: (
            row["minimum_descent_degree"],
            row["total_descent_edges"],
        ),
        "maximum_min_drop_then_degree": lambda row: (
            row["minimum_rank_drop"],
            row["minimum_descent_degree"],
            row["total_descent_edges"],
        ),
        "maximum_deletion_updates": lambda row: (
            row["defect_deletion_updates"],
            row["minimum_descent_degree"],
        ),
    }
    results = {
        name: {
            "complete": 0,
            "pure": 0,
            "first_incomplete": None,
            "first_impure": None,
        }
        for name in selectors
    }
    rows = []
    first_fibre_profile = None
    rank_zero_relation = {
        "complete": 0,
        "pure": 0,
        "selected_edges": 0,
        "first_incomplete": None,
        "first_impure": None,
        "all_candidate_survivor_edges": 0,
        "survivor_edges_outside_relation": 0,
        "first_survivor_outside_relation": None,
    }
    for opponent in GEOMETRY.bits(game.legal_mask(control)):
        child = control | (1 << opponent)
        candidates = []
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            target = child | (1 << reply)
            defects = census.update.defect(target)
            rank = len(defects)
            degrees = []
            drops = []
            deletion_updates = 0
            defect_set = set(defects)
            for defect in defects:
                grandchild = target | (1 << defect)
                degree = 0
                best_drop = 0
                for response in GEOMETRY.bits(
                    game.legal_mask(grandchild)
                ):
                    follower = grandchild | (1 << response)
                    next_defects = census.update.defect(follower)
                    next_rank = len(next_defects)
                    if next_rank < rank:
                        degree += 1
                        best_drop = max(best_drop, rank - next_rank)
                        if (
                            response in defect_set
                            and set(next_defects).issubset(
                                defect_set - {defect, response}
                            )
                        ):
                            deletion_updates += 1
                assert degree > 0
                degrees.append(degree)
                drops.append(best_drop)
            candidates.append(
                {
                    "reply": list(game.cell_tuple(reply)),
                    "target": target,
                    "rank": rank,
                    "minimum_descent_degree": min(degrees),
                    "total_descent_edges": sum(degrees),
                    "minimum_rank_drop": min(drops),
                    "total_rank_drop": sum(drops),
                    "defect_deletion_updates": deletion_updates,
                }
            )

        selector_rows = {}
        for name, key in selectors.items():
            optimum = max(key(row) for row in candidates)
            selected = [row for row in candidates if key(row) == optimum]
            labels = [
                census.ranked_survivor(row["target"])["holds"]
                for row in selected
            ]
            summary = {
                "optimum": list(optimum),
                "selected": len(selected),
                "passing": sum(labels),
            }
            selector_rows[name] = summary
            result = results[name]
            if any(labels):
                result["complete"] += 1
            elif result["first_incomplete"] is None:
                result["first_incomplete"] = {
                    "opponent": list(game.cell_tuple(opponent)),
                    **summary,
                }
            if all(labels):
                result["pure"] += 1
            elif result["first_impure"] is None:
                result["first_impure"] = {
                    "opponent": list(game.cell_tuple(opponent)),
                    **summary,
                }
        rank_zero = [
            row for row in candidates
            if row["minimum_rank_drop"] == row["rank"]
        ]
        all_labels = [
            census.ranked_survivor(row["target"])["holds"]
            for row in candidates
        ]
        rank_zero_relation["all_candidate_survivor_edges"] += sum(
            all_labels
        )
        for row, label in zip(candidates, all_labels):
            in_relation = row["minimum_rank_drop"] == row["rank"]
            if label and not in_relation:
                rank_zero_relation[
                    "survivor_edges_outside_relation"
                ] += 1
                if (
                    rank_zero_relation[
                        "first_survivor_outside_relation"
                    ] is None
                ):
                    rank_zero_relation[
                        "first_survivor_outside_relation"
                    ] = {
                        "opponent": list(game.cell_tuple(opponent)),
                        "reply": row["reply"],
                        "rank": row["rank"],
                    }
        rank_zero_labels = [
            census.ranked_survivor(row["target"])["holds"]
            for row in rank_zero
        ]
        rank_zero_relation["selected_edges"] += len(rank_zero)
        if rank_zero and any(rank_zero_labels):
            rank_zero_relation["complete"] += 1
        elif rank_zero_relation["first_incomplete"] is None:
            rank_zero_relation["first_incomplete"] = {
                "opponent": list(game.cell_tuple(opponent)),
                "selected": len(rank_zero),
                "passing": sum(rank_zero_labels),
            }
        if rank_zero and all(rank_zero_labels):
            rank_zero_relation["pure"] += 1
        elif rank_zero_relation["first_impure"] is None:
            rank_zero_relation["first_impure"] = {
                "opponent": list(game.cell_tuple(opponent)),
                "selected": len(rank_zero),
                "passing": sum(rank_zero_labels),
            }
        selector_rows["all_defects_reply_to_rank_zero"] = {
            "selected": len(rank_zero),
            "passing": sum(rank_zero_labels),
        }
        rows.append(
            {
                "opponent": list(game.cell_tuple(opponent)),
                "legal_reply_candidates": len(candidates),
                "selectors": selector_rows,
            }
        )
        if game.cell_tuple(opponent) == (6, 3):
            labelled = []
            for row in candidates:
                labelled.append(
                    {
                        key: value
                        for key, value in row.items()
                        if key != "target"
                    }
                    | {
                        "ranked_survivor": census.ranked_survivor(
                            row["target"]
                        )["holds"]
                    }
                )
            first_fibre_profile = {
                "candidates": len(labelled),
                "passing": sum(
                    row["ranked_survivor"] for row in labelled
                ),
                "passing_rows": [
                    row for row in labelled if row["ranked_survivor"]
                ],
            }

    assert len(rows) == 118
    assert sum(row["legal_reply_candidates"] for row in rows) == 7986
    assert rank_zero_relation == {
        "complete": 118,
        "pure": 118,
        "selected_edges": 1240,
        "first_incomplete": None,
        "first_impure": None,
        "all_candidate_survivor_edges": 1240,
        "survivor_edges_outside_relation": 0,
        "first_survivor_outside_relation": None,
    }
    expected_selectors = {
        "maximum_rank": (40, 24),
        "maximum_minimum_descent_degree": (62, 24),
        "maximum_total_descent_edges": (31, 30),
        "maximum_min_degree_then_edges": (41, 41),
        "maximum_min_drop_then_degree": (45, 45),
        "maximum_deletion_updates": (37, 37),
    }
    assert {
        name: (row["complete"], row["pure"])
        for name, row in results.items()
    } == expected_selectors
    assert first_fibre_profile is not None
    assert first_fibre_profile["candidates"] == 66
    assert first_fibre_profile["passing"] == 13

    selected_degree_histogram = Counter(
        row["selectors"]["all_defects_reply_to_rank_zero"]["selected"]
        for row in rows
    )
    selected_rank_histogram = Counter(
        row["rank"]
        for row in first_fibre_profile["passing_rows"]
    )
    return {
        "schema": "c80-q23-rank-zero-correspondence-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "control": {
            "q": BASE.Q,
            "root_t4": list(BASE.T4),
            "history": [list(cell) for cell in BASE.HISTORY],
            "outer_opponent_fibres": len(rows),
            "outer_reply_candidates": sum(
                row["legal_reply_candidates"] for row in rows
            ),
        },
        "direct_relation": {
            "definition": (
                "R0(T;o,p) iff for U=T+o+p, every x in Def(U) "
                "has a legal y with Def(U+x+y)=empty"
            ),
            "soundness": (
                "nondefect opponents reply into B_small; defect opponents "
                "reply into defect rank zero, hence Shell_small"
            ),
            **rank_zero_relation,
            "projected_fibre_degree_histogram": [
                {"selected_replies": degree, "outer_fibres": count}
                for degree, count in sorted(
                    selected_degree_histogram.items()
                )
            ],
        },
        "recursive_comparison": {
            "all_7986_candidates_checked": True,
            "direct_relation_equals_recursive_survivor_on_domain": True,
            "direct_edges": 1240,
            "recursive_survivor_edges": 1240,
            "recursive_edges_outside_direct_relation": 0,
        },
        "extremal_selector_falsifiers": results,
        "first_nonminimum_fibre": {
            "outer_opponent": [6, 3],
            "candidate_replies": first_fibre_profile["candidates"],
            "direct_relation_replies": first_fibre_profile["passing"],
            "selected_rank_histogram": [
                {"defect_rank": rank, "replies": count}
                for rank, count in sorted(
                    selected_rank_histogram.items()
                )
            ],
            "selected_rows": first_fibre_profile["passing_rows"],
        },
        "rows": rows,
        "verdict": {
            "opponent_complete": "118/118",
            "selected_edges_sound": "1240/1240",
            "exact_finite_recursive_compression": "1240/1240",
            "greedy_or_extremal_rule": "FAIL",
            "uniform_odd_q_theorem": "OPEN",
            "c82_released": False,
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
