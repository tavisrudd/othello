#!/usr/bin/env python3
"""C80: compress the four q19 rank-one fibres to a bounded incidence shell."""
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
SOURCE = ROOT / "rust/scripts/c80_uncovered_locus_boundary_rewrite.py"
OUT = ROOT / "notes/2026-07-25-c80-q19-rank-one-incidence-shell.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q19_shell_base")
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE
SPOILER = BASE.SPOILER
INPUTS = tuple(sorted(set((*BASE.INPUTS, SOURCE))))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


class IncidenceShell:
    def __init__(self, q: int = 19):
        self.rewrite = BASE.Rewrite(q)
        self.kernel = self.rewrite.kernel
        self.game = self.rewrite.game

    @lru_cache(maxsize=None)
    def small_boundary(self, mask: int) -> str | None:
        """Omega-zero terminal or a pair of mutually legal remaining moves."""
        if self.kernel.omega(mask) != 0:
            return None
        legal = self.game.legal_mask(mask)
        size = legal.bit_count()
        if size == 0:
            return "terminal"
        if size != 2:
            return None
        first, second = tuple(GEOMETRY.bits(legal))
        after_first = self.game.legal_mask(mask | (1 << first))
        if after_first & (1 << second):
            return "two_nonconflicting_moves"
        return None

    def active_blocks(self, mask: int) -> list[list[list[int]]]:
        legal = self.game.legal_mask(mask)
        blocks = []
        for line_mask, fixed_load in self.kernel.lines:
            support = legal & line_mask
            if (
                fixed_load + (mask & line_mask).bit_count() == 0
                and support.bit_count() > 2
            ):
                blocks.append(
                    [
                        list(self.game.cell_tuple(point))
                        for point in GEOMETRY.bits(support)
                    ]
                )
        return sorted(blocks)

    def shell_data(self, mask: int) -> dict:
        rows = []
        for opponent in GEOMETRY.bits(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            replies = []
            for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                target = child | (1 << reply)
                kind = self.small_boundary(target)
                if kind is not None:
                    replies.append(
                        {
                            "reply": list(self.game.cell_tuple(reply)),
                            "boundary_kind": kind,
                            "remaining_legal_moves": self.game.legal_mask(
                                target
                            ).bit_count(),
                            "target_exact_grid_value": (
                                "P" if not self.game.value(target) else "N"
                            ),
                        }
                    )
            assert replies
            rows.append(
                {
                    "opponent": list(self.game.cell_tuple(opponent)),
                    "replies": replies,
                }
            )
        values = Counter(
            reply["target_exact_grid_value"]
            for row in rows
            for reply in row["replies"]
        )
        kinds = Counter(
            reply["boundary_kind"]
            for row in rows
            for reply in row["replies"]
        )
        assert values == {"P": sum(kinds.values())}
        assert not self.game.value(mask)
        return {
            "target_omega": self.kernel.omega(mask),
            "target_legal_moves": self.game.legal_mask(mask).bit_count(),
            "active_blocks": self.active_blocks(mask),
            "opponents_covered": len(rows),
            "oriented_reply_edges": sum(
                len(row["replies"]) for row in rows
            ),
            "boundary_kind_histogram": dict(kinds),
            "target_exact_grid_value": "P",
            "reply_target_value_histogram": dict(values),
            "rows": rows,
        }

    @lru_cache(maxsize=None)
    def shell_holds(self, mask: int) -> bool:
        for opponent in GEOMETRY.bits(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            if not any(
                self.small_boundary(child | (1 << reply)) is not None
                for reply in GEOMETRY.bits(self.game.legal_mask(child))
            ):
                return False
        return True

    def outer_case_data(
        self,
        t4: tuple[int, ...],
        history_opponent: tuple[int, int],
        history_reply: tuple[int, int],
    ) -> dict:
        target = self.rewrite.target_mask(
            t4, history_opponent, history_reply
        )
        target_omega = self.kernel.omega(target)
        rows = []
        for opponent in GEOMETRY.bits(self.game.legal_mask(target)):
            child = target | (1 << opponent)
            candidates = []
            for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                follower = child | (1 << reply)
                if self.small_boundary(follower) is not None:
                    rank = 0
                elif self.shell_holds(follower):
                    rank = 1
                else:
                    continue
                candidates.append(
                    {
                        "reply": list(self.game.cell_tuple(reply)),
                        "small_shell_rank": rank,
                        "coverage_deficiency": self.game.legal_mask(
                            follower
                        ).bit_count(),
                        "target_omega": self.kernel.omega(follower),
                        "target_exact_grid_value": (
                            "P" if not self.game.value(follower) else "N"
                        ),
                    }
                )
            assert candidates
            minimum = min(
                (row["small_shell_rank"], row["coverage_deficiency"])
                for row in candidates
            )
            selected = [
                row for row in candidates
                if (row["small_shell_rank"], row["coverage_deficiency"])
                == minimum
            ]
            rows.append(
                {
                    "opponent": list(self.game.cell_tuple(opponent)),
                    "selected_rank": minimum[0],
                    "minimum_deficiency_at_rank": minimum[1],
                    "selected_replies": selected,
                }
            )
        assert all(
            reply["target_exact_grid_value"] == "P"
            and reply["target_omega"] < target_omega
            for row in rows
            for reply in row["selected_replies"]
        )
        histogram = Counter(
            (row["selected_rank"], row["minimum_deficiency_at_rank"])
            for row in rows
        )
        degrees = Counter(len(row["selected_replies"]) for row in rows)
        omegas = Counter(
            reply["target_omega"]
            for row in rows
            for reply in row["selected_replies"]
        )
        return {
            "q": self.game.q,
            "root_t4": list(t4),
            "history_edge": {
                "opponent": list(history_opponent),
                "reply": list(history_reply),
            },
            "target_omega": target_omega,
            "opponents": len(rows),
            "rank_deficiency_histogram": [
                {
                    "small_shell_rank": key[0],
                    "minimum_deficiency_at_rank": key[1],
                    "opponents": count,
                }
                for key, count in sorted(histogram.items())
            ],
            "selected_fibre_degree_histogram": [
                {"degree": degree, "opponents": count}
                for degree, count in sorted(degrees.items())
            ],
            "selected_target_omega_histogram": [
                {"target_omega": omega, "oriented_edges": count}
                for omega, count in sorted(omegas.items())
            ],
            "selected_oriented_edges": sum(
                len(row["selected_replies"]) for row in rows
            ),
            "selected_value_histogram": dict(
                Counter(
                    reply["target_exact_grid_value"]
                    for row in rows
                    for reply in row["selected_replies"]
                )
            ),
            "rows": rows,
        }


def target_signature(shell: IncidenceShell, mask: int) -> dict:
    data = shell.shell_data(mask)
    return {
        tuple(row["opponent"]): tuple(
            sorted(
                (
                    reply["boundary_kind"],
                    reply["remaining_legal_moves"],
                )
                for reply in row["replies"]
            )
        )
        for row in data["rows"]
    }


def transported_cell(shell: IncidenceShell, matrix, cell: tuple[int, int]):
    game = shell.game
    lookup = LIVE.point_to_cell(game)
    index = LIVE.cell_index(game, cell)
    return game.cell_tuple(
        lookup[
            SPOILER.sym2(
                game.q,
                matrix,
                SPOILER.projective_point(game, index),
            )
        ]
    )


def outer_signature(case: dict) -> dict:
    return {
        tuple(row["opponent"]): (
            row["selected_rank"],
            row["minimum_deficiency_at_rank"],
            len(row["selected_replies"]),
        )
        for row in case["rows"]
    }


def outer_transport_check(shell: IncidenceShell, case: dict) -> dict:
    game = shell.game
    t4 = tuple(case["root_t4"])
    history_opponent = tuple(case["history_edge"]["opponent"])
    history_reply = tuple(case["history_edge"]["reply"])
    matrices = LIVE.stabilizer_matrices(game, game.base_mask(t4))
    base = outer_signature(case)
    checks = 0
    for matrix in matrices:
        transformed = shell.outer_case_data(
            t4,
            transported_cell(shell, matrix, history_opponent),
            transported_cell(shell, matrix, history_reply),
        )
        transformed_signature = outer_signature(transformed)
        for cell, expected in base.items():
            moved = transported_cell(shell, matrix, cell)
            assert transformed_signature[moved] == expected
            checks += 1
    return {
        "stabilizer_order": len(matrices),
        "transported_outer_fibre_checks": checks,
        "all_checks_pass": True,
    }


def build_certificate() -> dict:
    shell = IncidenceShell()
    q, t4, history_opponent, history_reply = BASE.COVERAGE.COMPARE.REPAIRS[-1]
    assert q == 19
    control = shell.rewrite.case_data(t4, history_opponent, history_reply)
    control_target = shell.rewrite.target_mask(
        t4, history_opponent, history_reply
    )
    targets = []
    target_masks = []
    for row in control["rows"]:
        if row["selected_rank"] != 1:
            continue
        opponent = LIVE.cell_index(shell.game, tuple(row["opponent"]))
        for selected in row["selected_replies"]:
            reply = LIVE.cell_index(shell.game, tuple(selected["reply"]))
            mask = control_target | (1 << opponent) | (1 << reply)
            target_masks.append(mask)
            targets.append(
                {
                    "outer_opponent": row["opponent"],
                    "outer_reply": selected["reply"],
                    **shell.shell_data(mask),
                }
            )
    assert len(targets) == 5
    expected_kind_histograms = [
        {"terminal": 16},
        {"terminal": 12},
        {"terminal": 18},
        {"terminal": 18},
        {"terminal": 16, "two_nonconflicting_moves": 12},
    ]
    actual_kind_histograms = [
        row["boundary_kind_histogram"] for row in targets
    ]
    assert actual_kind_histograms == expected_kind_histograms, (
        actual_kind_histograms
    )
    assert sum(row["opponents_covered"] for row in targets) == 47
    assert sum(row["oriented_reply_edges"] for row in targets) == 92

    outer_shells = {17: IncidenceShell(17), 19: shell}
    outer_cases = [
        outer_shells[case_q].outer_case_data(
            case_t4, case_opponent, case_reply
        )
        for case_q, case_t4, case_opponent, case_reply
        in BASE.COVERAGE.COMPARE.REPAIRS
    ]
    q17_histogram = [
        {
            "small_shell_rank": 0,
            "minimum_deficiency_at_rank": 0,
            "opponents": 10,
        },
        {
            "small_shell_rank": 0,
            "minimum_deficiency_at_rank": 2,
            "opponents": 7,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 3,
            "opponents": 9,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 4,
            "opponents": 6,
        },
    ]
    assert all(
        case["rank_deficiency_histogram"] == q17_histogram
        and case["selected_oriented_edges"] == 49
        and case["selected_value_histogram"] == {"P": 49}
        and case["selected_target_omega_histogram"]
        == [{"target_omega": 0, "oriented_edges": 49}]
        for case in outer_cases[:4]
    )
    assert outer_cases[-1]["rank_deficiency_histogram"] == [
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 4,
            "opponents": 10,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 5,
            "opponents": 7,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 6,
            "opponents": 7,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 7,
            "opponents": 14,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 8,
            "opponents": 9,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 9,
            "opponents": 3,
        },
        {
            "small_shell_rank": 1,
            "minimum_deficiency_at_rank": 11,
            "opponents": 1,
        },
    ]
    assert outer_cases[-1]["selected_oriented_edges"] == 69
    assert outer_cases[-1]["selected_value_histogram"] == {"P": 69}
    assert outer_cases[-1]["selected_target_omega_histogram"] == [
        {"target_omega": 0, "oriented_edges": 49},
        {"target_omega": 1, "oriented_edges": 18},
        {"target_omega": 2, "oriented_edges": 2},
    ]

    matrices = LIVE.stabilizer_matrices(
        shell.game, shell.game.base_mask(t4)
    )
    checks = 0
    for matrix in matrices:
        transformed_history_opponent = transported_cell(
            shell, matrix, history_opponent
        )
        transformed_history_reply = transported_cell(
            shell, matrix, history_reply
        )
        transformed_control = shell.rewrite.target_mask(
            t4,
            transformed_history_opponent,
            transformed_history_reply,
        )
        for mask, target in zip(target_masks, targets):
            transformed_outer_opponent = transported_cell(
                shell, matrix, tuple(target["outer_opponent"])
            )
            transformed_outer_reply = transported_cell(
                shell, matrix, tuple(target["outer_reply"])
            )
            transformed_mask = (
                transformed_control
                | (
                    1
                    << LIVE.cell_index(
                        shell.game, transformed_outer_opponent
                    )
                )
                | (
                    1
                    << LIVE.cell_index(shell.game, transformed_outer_reply)
                )
            )
            original = target_signature(shell, mask)
            transformed = target_signature(shell, transformed_mask)
            for cell, expected in original.items():
                transported = transported_cell(shell, matrix, cell)
                assert transformed[transported] == expected
                checks += 1

    return {
        "schema": "c80-q19-rank-one-incidence-shell-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "bounded_relation": {
            "name": "R_small(U; x,y)",
            "definition": (
                "x,y are a legal pair; Omega(U+x+y)=0; and the follower "
                "has either zero legal moves or exactly two mutually legal moves"
            ),
            "soundness": (
                "the zero-move follower is terminal P; the two-move follower "
                "is P by replying with the other move"
            ),
            "rank_one_shell": (
                "Shell_small(U) iff every legal x has a legal y with "
                "R_small(U;x,y)"
            ),
            "format": (
                "fixed first-order incidence/cardinality formula; no matching, "
                "Grundy value, minimax query, or recursive survivor membership"
            ),
        },
        "control_target_omega": shell.kernel.omega(control_target),
        "rank_one_targets": targets,
        "full_outer_correspondence": {
            "selection": (
                "retain all replies lexicographically minimizing "
                "(small-shell rank, coverage deficiency)"
            ),
            "cases": outer_cases,
            "representative_value_purity": "118/118 P",
        },
        "summary": {
            "targets": 5,
            "outer_opponent_fibres": 4,
            "inner_opponents_covered": 47,
            "oriented_inner_reply_edges": 92,
            "terminal_edges": 80,
            "two_nonconflicting_move_edges": 12,
            "target_value_purity": "5/5 P",
            "inner_boundary_value_purity": "92/92 P",
        },
        "transport": {
            "stabilizer_order": len(matrices),
            "transported_inner_fibre_checks": checks,
            "outer_q17": outer_transport_check(
                outer_shells[17], outer_cases[0]
            ),
            "outer_q19": outer_transport_check(
                outer_shells[19], outer_cases[-1]
            ),
            "all_checks_pass": True,
        },
        "verdict": {
            "explicit_B_cc_pairings_eliminated": True,
            "explicit_rank_one_reply_table_eliminated_from_definition": True,
            "bounded_algebraic_incidence_schema": "PASS",
            "q19_four_fibre_coverage": "PASS",
            "full_q17_q19_outer_correspondence": "PASS",
            "full_outer_correspondence_value_purity": "118/118 P",
            "uniform_opponent_completeness": "OPEN",
            "uniform_c80_candidate": False,
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
