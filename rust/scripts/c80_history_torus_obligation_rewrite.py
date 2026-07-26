#!/usr/bin/env python3
"""C80: test the history-marked torus-orbit obligation rewrite."""
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
SOURCE = ROOT / "rust/scripts/c80_central_involution_rank_datum.py"
OUT = ROOT / "notes/2026-07-25-c80-history-torus-obligation-rewrite.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


CENTRAL = load_module(SOURCE, "c80_history_central")
COMPARE = CENTRAL.COMPARE
LIVE = CENTRAL.LIVE
SPOILER = CENTRAL.SPOILER
GEOMETRY = CENTRAL.GEOMETRY
INPUTS = (SOURCE, *CENTRAL.INPUTS)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def history_generator(game, opponent: int, repair: int):
    left = CENTRAL.intruder_involution(
        game.q, SPOILER.projective_point(game, opponent)
    )
    right = CENTRAL.intruder_involution(
        game.q, SPOILER.projective_point(game, repair)
    )
    return CENTRAL.matrix_normalize(
        game.q, CENTRAL.matrix_mul(game.q, left, right)
    )


def terminal_isolates(game, target: int) -> set[int]:
    cells = list(GEOMETRY.bits(game.legal_mask(target)))
    incident = set()
    for left, first in enumerate(cells):
        child = target | (1 << first)
        for second in cells[left + 1 :]:
            if not (game.legal_mask(child) & (1 << second)):
                continue
            if game.legal_mask(child | (1 << second)) == 0:
                incident.update((first, second))
    return set(cells) - incident


def direct_pair_valid(game, target: int, first: int, second_point) -> bool:
    points = list(CENTRAL.full_selected_points(game, target))
    points.append(SPOILER.projective_point(game, first))
    points.append(second_point)
    return CENTRAL.direct_cap(game.q, points)


def relation_edges(kernel, target: int, generator, order: int, *, values: bool):
    game = kernel.game
    lookup = LIVE.point_to_cell(game)
    old_omega = kernel.omega(target)
    edges: dict[tuple[int, int], dict] = {}
    direct_checks = 0
    for first in GEOMETRY.bits(game.legal_mask(target)):
        point = SPOILER.projective_point(game, first)
        power_matrix = (1, 0, 0, 1)
        seen = set()
        for exponent in range(1, order + 1):
            power_matrix = CENTRAL.matrix_mul(
                game.q, power_matrix, generator
            )
            second_point = SPOILER.sym2(game.q, power_matrix, point)
            second = lookup.get(second_point)
            if second is None:
                assert not direct_pair_valid(
                    game, target, first, second_point
                )
                direct_checks += 1
                continue
            if second == first or second in seen:
                continue
            seen.add(second)
            child = target | (1 << first)
            engine_valid = bool(
                game.legal_mask(child) & (1 << second)
            )
            assert engine_valid == direct_pair_valid(
                game, target, first, second_point
            )
            direct_checks += 1
            if not engine_valid:
                continue
            next_target = child | (1 << second)
            next_omega = kernel.omega(next_target)
            if next_omega >= old_omega:
                continue
            pair = tuple(sorted((first, second)))
            row = edges.setdefault(
                pair,
                {
                    "witness_powers": set(),
                    "target": next_target,
                    "target_omega": next_omega,
                },
            )
            assert row["target"] == next_target
            row["witness_powers"].add(exponent)
    result = []
    for pair, row in sorted(edges.items()):
        public = {
            "edge": [
                list(game.cell_tuple(first)) for first in pair
            ],
            "witness_powers": sorted(row["witness_powers"]),
            "target_omega": row["target_omega"],
        }
        if values:
            public["target_exact_grid_value"] = (
                "P" if not game.value(row["target"]) else "N"
            )
            public["in_copycat_survivor"] = kernel.contains(row["target"])
        result.append(public)
    return result, direct_checks


def case_data(
    q: int,
    t4: tuple[int, ...],
    opponent_cell: tuple[int, int],
    repair_cell: tuple[int, int],
) -> dict:
    kernel = SPOILER.BASE.CopycatKernel(q)
    game = kernel.game
    state = game.base_mask(t4)
    opponent = LIVE.cell_index(game, opponent_cell)
    repair = LIVE.cell_index(game, repair_cell)
    target = state | (1 << opponent) | (1 << repair)
    generator = history_generator(game, opponent, repair)
    order = GEOMETRY.prod_order(game, opponent, repair)
    edges, direct_checks = relation_edges(
        kernel, target, generator, order, values=True
    )
    cells = set(GEOMETRY.bits(game.legal_mask(target)))
    isolates = terminal_isolates(game, target)
    covered = {
        LIVE.cell_index(game, tuple(cell))
        for edge in edges
        for cell in edge["edge"]
    }
    p_edges = [
        edge
        for edge in edges
        if edge["target_exact_grid_value"] == "P"
    ]
    p_covered = {
        LIVE.cell_index(game, tuple(cell))
        for edge in p_edges
        for cell in edge["edge"]
    }
    value_histogram = Counter(
        edge["target_exact_grid_value"] for edge in edges
    )
    omega_histogram = Counter(edge["target_omega"] for edge in edges)
    return {
        "q": q,
        "root_t4": list(t4),
        "history_edge": {
            "opponent": list(opponent_cell),
            "repair": list(repair_cell),
        },
        "history_product_order": order,
        "history_generator_matrix": list(generator),
        "legal_moves": len(cells),
        "terminal_graph_isolates": len(isolates),
        "projected_relation_edges": len(edges),
        "moves_covered": len(covered),
        "moves_covered_by_P_edges": len(p_covered),
        "isolates_covered": len(isolates & covered),
        "isolates_covered_by_P_edges": len(isolates & p_covered),
        "uncovered_isolates": [
            list(game.cell_tuple(cell)) for cell in sorted(isolates - covered)
        ],
        "relation_value_histogram": {
            value: value_histogram[value] for value in ("P", "N")
        },
        "relation_target_omega_histogram": [
            [omega, omega_histogram[omega]]
            for omega in sorted(omega_histogram)
        ],
        "direct_determinant_legality_checks": direct_checks,
        "edges": edges,
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
    generator = history_generator(game, opponent, repair)
    order = case["history_product_order"]
    base_edges, _checks = relation_edges(
        kernel, target, generator, order, values=False
    )
    base_pairs = {
        tuple(
            sorted(
                LIVE.cell_index(game, tuple(cell))
                for cell in edge["edge"]
            )
        )
        for edge in base_edges
    }
    lookup = LIVE.point_to_cell(game)
    matrices = LIVE.stabilizer_matrices(game, state)
    conjugacy_checks = 0
    edge_checks = 0
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
        transformed_target = (
            state | (1 << transformed_opponent) | (1 << transformed_repair)
        )
        transformed_generator = history_generator(
            game, transformed_opponent, transformed_repair
        )
        conjugate = CENTRAL.matrix_normalize(
            q,
            CENTRAL.matrix_mul(
                q,
                CENTRAL.matrix_mul(q, transporter, generator),
                CENTRAL.matrix_inverse(q, transporter),
            ),
        )
        assert conjugate == transformed_generator
        conjugacy_checks += 1
        transformed_rows, _ = relation_edges(
            kernel,
            transformed_target,
            transformed_generator,
            order,
            values=False,
        )
        actual = {
            tuple(
                sorted(
                    LIVE.cell_index(game, tuple(cell))
                    for cell in edge["edge"]
                )
            )
            for edge in transformed_rows
        }
        expected = {
            tuple(
                sorted(
                    lookup[
                        SPOILER.sym2(
                            q,
                            transporter,
                            SPOILER.projective_point(game, cell),
                        )
                    ]
                    for cell in pair
                )
            )
            for pair in base_pairs
        }
        assert expected == actual
        edge_checks += len(expected)
    return {
        "stabilizer_order": len(matrices),
        "generator_conjugacy_checks": conjugacy_checks,
        "transported_projected_edge_checks": edge_checks,
        "all_checks_pass": True,
    }


def build_certificate() -> dict:
    cases = [
        case_data(q, t4, opponent, repair)
        for q, t4, opponent, repair in COMPARE.REPAIRS
    ]
    assert all(
        (
            case["legal_moves"],
            case["terminal_graph_isolates"],
            case["projected_relation_edges"],
            case["moves_covered"],
            case["isolates_covered"],
            case["isolates_covered_by_P_edges"],
            case["relation_value_histogram"],
        )
        == (32, 22, 14, 21, 15, 8, {"P": 6, "N": 8})
        for case in cases[:4]
    )
    assert (
        cases[-1]["legal_moves"],
        cases[-1]["projected_relation_edges"],
        cases[-1]["moves_covered"],
        cases[-1]["relation_value_histogram"],
    ) == (51, 11, 20, {"P": 2, "N": 9})
    transports = {
        "q17_representative": transport_check(cases[0]),
        "q19_control": transport_check(cases[-1]),
    }
    return {
        "schema": "c80-history-torus-obligation-rewrite-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path)
            for path in sorted(set(INPUTS))
        },
        "candidate": {
            "history_datum": (
                "H=iota_o iota_p from the marked repair edge"
            ),
            "reply_correspondence": (
                "distinct jointly legal strict replies y in the cyclic "
                "projective orbit <H>.x of the opponent x"
            ),
            "projection_rule": (
                "count distinct geometric reply edges after eliminating "
                "power witnesses"
            ),
        },
        "cases": cases,
        "transport": transports,
        "cross_checks": {
            "engine_pair_legality_equals_direct_projective_determinants": True,
            "history_generator_commutes_with_projective_transport": True,
            "projected_relation_commutes_with_transport": True,
        },
        "verdict": {
            "q17_isolate_coverage": "15/22",
            "q17_sound_isolate_coverage": "8/22",
            "q17_edgewise_purity": "FAIL: 6 P + 8 N edges",
            "q19_move_coverage": "20/51",
            "q19_edgewise_purity": "FAIL: 2 P + 9 N edges",
            "opponent_complete_rank_update": "FAIL",
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
