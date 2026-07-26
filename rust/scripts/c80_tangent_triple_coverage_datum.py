#!/usr/bin/env python3
"""C80: exact tangent-plus-triple coverage datum and greedy falsifier."""
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
SOURCE = ROOT / "rust/scripts/c80_continuation_conic_matching_bridge.py"
OUT = ROOT / "notes/2026-07-25-c80-tangent-triple-coverage-datum.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BRIDGE = load_module(SOURCE, "c80_coverage_bridge")
COMPARE = BRIDGE.COMPARE
LIVE = BRIDGE.LIVE
SPOILER = BRIDGE.SPOILER
GEOMETRY = BRIDGE.GEOMETRY
INPUTS = (SOURCE, *BRIDGE.INPUTS)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def coverage_terms(game, target: int, first: int, second: int) -> dict:
    legal = game.legal_mask(target)
    first_bit = 1 << first
    second_bit = 1 << second
    after_first = game.legal_mask(target | first_bit)
    after_second = game.legal_mask(target | second_bit)
    first_conflicts = legal & ~after_first & ~first_bit
    second_conflicts = legal & ~after_second & ~second_bit
    common_conflicts = first_conflicts & second_conflicts
    line = game.line_masks[first + 2][second + 2]
    triple_line = legal & line & ~first_bit & ~second_bit
    assert not (triple_line & (first_conflicts | second_conflicts))
    formula = (
        legal.bit_count()
        - 2
        - first_conflicts.bit_count()
        - second_conflicts.bit_count()
        + common_conflicts.bit_count()
        - triple_line.bit_count()
    )
    actual = game.legal_mask(target | first_bit | second_bit).bit_count()
    assert formula == actual
    return {
        "first_conflicts": first_conflicts.bit_count(),
        "second_conflicts": second_conflicts.bit_count(),
        "common_conflicts": common_conflicts.bit_count(),
        "triple_line_coverage": triple_line.bit_count(),
        "coverage_deficiency": formula,
    }


def case_data(
    q: int,
    t4: tuple[int, ...],
    opponent_cell: tuple[int, int],
    repair_cell: tuple[int, int],
) -> dict:
    kernel = SPOILER.BASE.CopycatKernel(q)
    game = kernel.game
    target = game.base_mask(t4)
    target |= 1 << LIVE.cell_index(game, opponent_cell)
    target |= 1 << LIVE.cell_index(game, repair_cell)
    isolates = BRIDGE.HISTORY.terminal_isolates(game, target)
    legal_cells = list(GEOMETRY.bits(game.legal_mask(target)))
    pair_checks = 0
    rows = []
    for opponent in legal_cells:
        child = target | (1 << opponent)
        candidates = []
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            terms = coverage_terms(game, target, opponent, reply)
            pair_checks += 1
            next_target = child | (1 << reply)
            candidates.append(
                {
                    "reply": list(game.cell_tuple(reply)),
                    "target_exact_grid_value": (
                        "P" if not game.value(next_target) else "N"
                    ),
                    "in_copycat_survivor": kernel.contains(next_target),
                    "target_omega": kernel.omega(next_target),
                    **terms,
                }
            )
        minimum = min(row["coverage_deficiency"] for row in candidates)
        minimizers = [
            row for row in candidates
            if row["coverage_deficiency"] == minimum
        ]
        rows.append(
            {
                "opponent": list(game.cell_tuple(opponent)),
                "terminal_graph_status": (
                    "isolate" if opponent in isolates else "core"
                ),
                "minimum_coverage_deficiency": minimum,
                "minimizers": minimizers,
                "has_P_minimizer": any(
                    row["target_exact_grid_value"] == "P"
                    for row in minimizers
                ),
            }
        )
    histogram = Counter(
        (
            row["terminal_graph_status"],
            row["minimum_coverage_deficiency"],
        )
        for row in rows
    )
    oriented_values = Counter(
        minimizer["target_exact_grid_value"]
        for row in rows
        for minimizer in row["minimizers"]
    )
    return {
        "q": q,
        "root_t4": list(t4),
        "history_edge": {
            "opponent": list(opponent_cell),
            "repair": list(repair_cell),
        },
        "legal_moves": len(legal_cells),
        "coverage_formula_pair_checks": pair_checks,
        "minimum_deficiency_histogram": [
            {
                "terminal_graph_status": key[0],
                "minimum_coverage_deficiency": key[1],
                "opponents": count,
            }
            for key, count in sorted(histogram.items())
        ],
        "opponents_with_P_minimizer": sum(
            row["has_P_minimizer"] for row in rows
        ),
        "isolate_opponents_with_P_minimizer": sum(
            row["terminal_graph_status"] == "isolate"
            and row["has_P_minimizer"]
            for row in rows
        ),
        "oriented_minimizer_value_histogram": {
            value: oriented_values[value] for value in ("P", "N")
        },
        "opponents": rows,
    }


def transport_check(case: dict) -> dict:
    q = case["q"]
    t4 = tuple(case["root_t4"])
    opponent_cell = tuple(case["history_edge"]["opponent"])
    repair_cell = tuple(case["history_edge"]["repair"])
    kernel = SPOILER.BASE.CopycatKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = LIVE.cell_index(game, opponent_cell)
    repair = LIVE.cell_index(game, repair_cell)
    target = state | (1 << opponent) | (1 << repair)
    base = {
        LIVE.cell_index(game, tuple(row["opponent"])): (
            row["terminal_graph_status"],
            row["minimum_coverage_deficiency"],
            len(row["minimizers"]),
            sorted(
                minimizer["target_exact_grid_value"]
                for minimizer in row["minimizers"]
            ),
        )
        for row in case["opponents"]
    }
    lookup = LIVE.point_to_cell(game)
    matrices = LIVE.stabilizer_matrices(game, state)
    checks = 0
    for transporter in matrices:
        transformed_opponent = lookup[
            SPOILER.sym2(
                q, transporter, SPOILER.projective_point(game, opponent)
            )
        ]
        transformed_repair = lookup[
            SPOILER.sym2(
                q, transporter, SPOILER.projective_point(game, repair)
            )
        ]
        transformed_case = case_data(
            q,
            t4,
            game.cell_tuple(transformed_opponent),
            game.cell_tuple(transformed_repair),
        )
        transformed = {
            LIVE.cell_index(game, tuple(row["opponent"])): (
                row["terminal_graph_status"],
                row["minimum_coverage_deficiency"],
                len(row["minimizers"]),
                sorted(
                    minimizer["target_exact_grid_value"]
                    for minimizer in row["minimizers"]
                ),
            )
            for row in transformed_case["opponents"]
        }
        for move, expected in base.items():
            transformed_move = lookup[
                SPOILER.sym2(
                    q, transporter, SPOILER.projective_point(game, move)
                )
            ]
            assert transformed[transformed_move] == expected
            checks += 1
    return {
        "stabilizer_order": len(matrices),
        "transported_minimum_fibre_checks": checks,
        "all_checks_pass": True,
    }


def build_certificate() -> dict:
    cases = [
        case_data(q, t4, opponent, repair)
        for q, t4, opponent, repair in COMPARE.REPAIRS
    ]
    q17_histogram = [
        {
            "terminal_graph_status": "core",
            "minimum_coverage_deficiency": 0,
            "opponents": 10,
        },
        {
            "terminal_graph_status": "isolate",
            "minimum_coverage_deficiency": 1,
            "opponents": 8,
        },
        {
            "terminal_graph_status": "isolate",
            "minimum_coverage_deficiency": 2,
            "opponents": 13,
        },
        {
            "terminal_graph_status": "isolate",
            "minimum_coverage_deficiency": 3,
            "opponents": 1,
        },
    ]
    assert all(
        case["minimum_deficiency_histogram"] == q17_histogram
        and case["isolate_opponents_with_P_minimizer"] == 4
        and case["opponents_with_P_minimizer"] == 14
        and case["oriented_minimizer_value_histogram"]
        == {"P": 21, "N": 43}
        for case in cases[:4]
    )
    q19_histogram = {
        row["minimum_coverage_deficiency"]: row["opponents"]
        for row in cases[-1]["minimum_deficiency_histogram"]
    }
    assert q19_histogram == {3: 3, 4: 17, 5: 8, 6: 18, 7: 4, 8: 1}
    assert cases[-1]["opponents_with_P_minimizer"] == 19
    assert cases[-1]["oriented_minimizer_value_histogram"] == {
        "P": 21,
        "N": 55,
    }
    transports = {
        "q17_representative": transport_check(cases[0]),
        "q19_control": transport_check(cases[-1]),
    }
    return {
        "schema": "c80-tangent-triple-coverage-datum-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path)
            for path in sorted(set(INPUTS))
        },
        "coverage_identity": {
            "definition": (
                "kappa_T(x,y)=|Legal(T+x+y)|"
            ),
            "formula": (
                "|V|-2-|C_x|-|C_y|+|C_x intersection C_y|-|L_xy|"
            ),
            "terms": (
                "C_x,C_y are tangent pair-conflict neighborhoods in V; "
                "L_xy is the remaining legal trace on line xy"
            ),
            "terminality": "kappa_T(x,y)=0",
        },
        "candidate_reply_rule": (
            "for each opponent, retain all replies minimizing kappa"
        ),
        "cases": cases,
        "transport": transports,
        "cross_checks": {
            "coverage_formula_equals_direct_legal_mask_count_on_every_pair": True,
            "minimum_fibres_commute_with_projective_transport": True,
        },
        "verdict": {
            "exact_bounded_arity_datum": "PASS",
            "q17_isolate_deficiency_bound": "1..3",
            "q17_isolates_with_P_minimizer": "4/22",
            "q19_minimum_deficiency_range": "3..8",
            "greedy_minimum_deficiency_soundness": "FAIL",
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
