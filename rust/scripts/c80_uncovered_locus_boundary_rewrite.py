#!/usr/bin/env python3
"""C80: classify small uncovered loci and test a depth-one boundary rewrite."""
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
COVERAGE_PATH = ROOT / "rust/scripts/c80_tangent_triple_coverage_datum.py"
ADAPTIVE_PATH = ROOT / "rust/scripts/c80_adaptive_copycat_survivor.py"
OUT = ROOT / "notes/2026-07-25-c80-uncovered-locus-boundary-rewrite.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


COVERAGE = load_module(COVERAGE_PATH, "c80_uncovered_coverage")
ADAPTIVE = load_module(ADAPTIVE_PATH, "c80_uncovered_adaptive")
GEOMETRY = COVERAGE.GEOMETRY
LIVE = COVERAGE.LIVE
SPOILER = COVERAGE.SPOILER
INPUTS = tuple(sorted(set((*COVERAGE.INPUTS, COVERAGE_PATH, ADAPTIVE_PATH))))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def graph_shape(adjacency: tuple[int, ...]) -> list[dict]:
    result = []
    for component in ADAPTIVE.components(adjacency):
        degrees = sorted(
            (adjacency[vertex] & sum(1 << item for item in component)).bit_count()
            for vertex in component
        )
        result.append(
            {
                "vertices": len(component),
                "edges": sum(degrees) // 2,
                "degree_sequence": degrees,
            }
        )
    return sorted(
        result,
        key=lambda row: (
            row["vertices"],
            row["edges"],
            row["degree_sequence"],
        ),
    )


class Rewrite:
    def __init__(self, q: int):
        self.kernel = SPOILER.BASE.CopycatKernel(q)
        self.game = self.kernel.game

    @lru_cache(maxsize=None)
    def boundary_witness(self, mask: int) -> dict | None:
        """The sound nonrecursive B_cc boundary, only at overload zero."""
        if self.kernel.omega(mask) != 0:
            return None
        cells, adjacency = ADAPTIVE.conflict_graph(self.kernel, mask)
        shell = ADAPTIVE.adaptive_pairing_shell(adjacency, 1)
        if shell is not None:
            return {
                "kind": "adaptive_pairing_shell",
                "legal_moves": len(cells),
                "shape": graph_shape(adjacency),
            }
        pairing = ADAPTIVE.persistent_pairing(adjacency)
        if pairing is not None:
            return {
                "kind": "persistent_pairing",
                "legal_moves": len(cells),
                "shape": graph_shape(adjacency),
            }
        return None

    @lru_cache(maxsize=None)
    def rank_one_witness(self, mask: int) -> dict | None:
        """One direct opponent/reply exchange into the overload-zero boundary."""
        responses = []
        for opponent in GEOMETRY.bits(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            candidates = []
            for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                target = child | (1 << reply)
                witness = self.boundary_witness(target)
                if witness is not None:
                    candidates.append(
                        {
                            "reply": list(self.game.cell_tuple(reply)),
                            "coverage_deficiency": self.game.legal_mask(
                                target
                            ).bit_count(),
                        }
                    )
            if not candidates:
                return None
            minimum = min(row["coverage_deficiency"] for row in candidates)
            responses.append(
                {
                    "opponent": list(self.game.cell_tuple(opponent)),
                    "minimum_boundary_deficiency": minimum,
                    "replies": [
                        row for row in candidates
                        if row["coverage_deficiency"] == minimum
                    ],
                }
            )
        return {
            "kind": "one_exchange_into_boundary",
            "opponents": len(responses),
            "responses": responses,
        }

    def rank(self, mask: int) -> tuple[int, dict] | None:
        boundary = self.boundary_witness(mask)
        if boundary is not None:
            return 0, boundary
        shell = self.rank_one_witness(mask)
        if shell is not None:
            return 1, shell
        return None

    def target_mask(
        self,
        t4: tuple[int, ...],
        opponent_cell: tuple[int, int],
        repair_cell: tuple[int, int],
    ) -> int:
        return (
            self.game.base_mask(t4)
            | (1 << LIVE.cell_index(self.game, opponent_cell))
            | (1 << LIVE.cell_index(self.game, repair_cell))
        )

    def case_data(
        self,
        t4: tuple[int, ...],
        opponent_cell: tuple[int, int],
        repair_cell: tuple[int, int],
        include_rows: bool = True,
    ) -> dict:
        target = self.target_mask(t4, opponent_cell, repair_cell)
        target_omega = self.kernel.omega(target)
        isolates = COVERAGE.BRIDGE.HISTORY.terminal_isolates(
            self.game, target
        )
        rows = []
        for opponent in GEOMETRY.bits(self.game.legal_mask(target)):
            child = target | (1 << opponent)
            candidates = []
            for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                next_target = child | (1 << reply)
                ranked = self.rank(next_target)
                if ranked is None:
                    continue
                rank, witness = ranked
                candidates.append(
                    {
                        "reply": list(self.game.cell_tuple(reply)),
                        "rewrite_rank": rank,
                        "coverage_deficiency": self.game.legal_mask(
                            next_target
                        ).bit_count(),
                        "target_omega": self.kernel.omega(next_target),
                        "target_exact_grid_value": (
                            "P" if not self.game.value(next_target) else "N"
                        ),
                        "boundary_kind": witness["kind"],
                        "uncovered_shape": (
                            witness["shape"] if rank == 0 else None
                        ),
                    }
                )
            assert candidates
            minimum = min(
                (row["rewrite_rank"], row["coverage_deficiency"])
                for row in candidates
            )
            selected = [
                row for row in candidates
                if (row["rewrite_rank"], row["coverage_deficiency"]) == minimum
            ]
            rows.append(
                {
                    "opponent": list(self.game.cell_tuple(opponent)),
                    "terminal_graph_status": (
                        "isolate" if opponent in isolates else "core"
                    ),
                    "selected_rank": minimum[0],
                    "minimum_deficiency_at_rank": minimum[1],
                    "selected_replies": selected,
                }
            )
        assert all(
            reply["target_exact_grid_value"] == "P"
            for row in rows
            for reply in row["selected_replies"]
        )
        assert all(
            reply["target_omega"] < target_omega
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
        result = {
            "q": self.game.q,
            "root_t4": list(t4),
            "history_edge": {
                "opponent": list(opponent_cell),
                "repair": list(repair_cell),
            },
            "opponents": len(rows),
            "target_omega": target_omega,
            "rank_deficiency_histogram": [
                {
                    "rewrite_rank": key[0],
                    "minimum_deficiency_at_rank": key[1],
                    "opponents": count,
                }
                for key, count in sorted(histogram.items())
            ],
            "selected_fibre_degree_histogram": [
                {"degree": degree, "opponents": count}
                for degree, count in sorted(degrees.items())
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
            "selected_target_omega_histogram": [
                {"target_omega": omega, "oriented_edges": count}
                for omega, count in sorted(omegas.items())
            ],
            "rank_one_opponents": [
                row["opponent"] for row in rows if row["selected_rank"] == 1
            ],
        }
        if include_rows:
            result["rows"] = rows
        return result


def minimum_locus_census(rewrite: Rewrite, case: dict) -> list[dict]:
    game = rewrite.game
    target = rewrite.target_mask(
        tuple(case["root_t4"]),
        tuple(case["history_edge"]["opponent"]),
        tuple(case["history_edge"]["repair"]),
    )
    isolates = COVERAGE.BRIDGE.HISTORY.terminal_isolates(game, target)
    census = Counter()
    for opponent in GEOMETRY.bits(game.legal_mask(target)):
        if opponent not in isolates:
            continue
        candidates = []
        for reply in GEOMETRY.bits(game.legal_mask(target | (1 << opponent))):
            next_target = target | (1 << opponent) | (1 << reply)
            cells, adjacency = ADAPTIVE.conflict_graph(
                rewrite.kernel, next_target
            )
            candidates.append(
                (
                    len(cells),
                    "P" if not game.value(next_target) else "N",
                    json.dumps(graph_shape(adjacency), sort_keys=True),
                )
            )
        minimum = min(row[0] for row in candidates)
        for deficiency, value, shape in candidates:
            if deficiency == minimum:
                census[(deficiency, value, shape)] += 1
    return [
        {
            "minimum_deficiency": key[0],
            "exact_value": key[1],
            "uncovered_shape": json.loads(key[2]),
            "oriented_edges": count,
        }
        for key, count in sorted(census.items())
    ]


def signature(case: dict) -> dict:
    return {
        tuple(row["opponent"]): (
            row["terminal_graph_status"],
            row["selected_rank"],
            row["minimum_deficiency_at_rank"],
            len(row["selected_replies"]),
        )
        for row in case["rows"]
    }


def transport_check(
    rewrite: Rewrite,
    case: dict,
) -> dict:
    game = rewrite.game
    t4 = tuple(case["root_t4"])
    target = rewrite.target_mask(
        t4,
        tuple(case["history_edge"]["opponent"]),
        tuple(case["history_edge"]["repair"]),
    )
    base = signature(case)
    lookup = LIVE.point_to_cell(game)
    matrices = LIVE.stabilizer_matrices(game, game.base_mask(t4))
    checks = 0
    for transporter in matrices:
        transformed_history = []
        for cell in (
            tuple(case["history_edge"]["opponent"]),
            tuple(case["history_edge"]["repair"]),
        ):
            index = LIVE.cell_index(game, cell)
            transformed_history.append(
                game.cell_tuple(
                    lookup[
                        SPOILER.sym2(
                            game.q,
                            transporter,
                            SPOILER.projective_point(game, index),
                        )
                    ]
                )
            )
        transformed_case = rewrite.case_data(
            t4,
            transformed_history[0],
            transformed_history[1],
        )
        transformed = signature(transformed_case)
        for cell, expected in base.items():
            index = LIVE.cell_index(game, cell)
            transported = game.cell_tuple(
                lookup[
                    SPOILER.sym2(
                        game.q,
                        transporter,
                        SPOILER.projective_point(game, index),
                    )
                ]
            )
            assert transformed[transported] == expected
            checks += 1
    return {
        "stabilizer_order": len(matrices),
        "transported_fibre_checks": checks,
        "all_checks_pass": True,
    }


def build_certificate() -> dict:
    rewrites = {q: Rewrite(q) for q in (17, 19)}
    cases = [
        rewrites[q].case_data(t4, opponent, repair)
        for q, t4, opponent, repair in COVERAGE.COMPARE.REPAIRS
    ]
    q17_histogram = [
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 0, "opponents": 10},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 2, "opponents": 7},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 3, "opponents": 9},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 4, "opponents": 6},
    ]
    assert all(
        case["rank_deficiency_histogram"] == q17_histogram
        and case["selected_oriented_edges"] == 49
        and case["selected_value_histogram"] == {"P": 49}
        and case["selected_target_omega_histogram"]
        == [{"target_omega": 0, "oriented_edges": 49}]
        and not case["rank_one_opponents"]
        for case in cases[:4]
    )
    assert cases[-1]["rank_deficiency_histogram"] == [
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 4, "opponents": 8},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 5, "opponents": 6},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 6, "opponents": 7},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 7, "opponents": 12},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 8, "opponents": 11},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 9, "opponents": 2},
        {"rewrite_rank": 0, "minimum_deficiency_at_rank": 10, "opponents": 1},
        {"rewrite_rank": 1, "minimum_deficiency_at_rank": 7, "opponents": 1},
        {"rewrite_rank": 1, "minimum_deficiency_at_rank": 9, "opponents": 2},
        {"rewrite_rank": 1, "minimum_deficiency_at_rank": 11, "opponents": 1},
    ]
    assert cases[-1]["selected_oriented_edges"] == 67
    assert cases[-1]["selected_value_histogram"] == {"P": 67}
    assert cases[-1]["selected_target_omega_histogram"] == [
        {"target_omega": 0, "oriented_edges": 62},
        {"target_omega": 1, "oriented_edges": 3},
        {"target_omega": 2, "oriented_edges": 2},
    ]
    assert cases[-1]["rank_one_opponents"] == [
        [1, 3],
        [5, 12],
        [6, 15],
        [8, 8],
    ]
    locus = minimum_locus_census(rewrites[17], cases[0])
    expected_locus = [
        {
            "minimum_deficiency": 1,
            "exact_value": "N",
            "uncovered_shape": [
                {"degree_sequence": [0], "edges": 0, "vertices": 1}
            ],
            "oriented_edges": 13,
        },
        {
            "minimum_deficiency": 2,
            "exact_value": "N",
            "uncovered_shape": [
                {"degree_sequence": [1, 1], "edges": 1, "vertices": 2}
            ],
            "oriented_edges": 29,
        },
        {
            "minimum_deficiency": 2,
            "exact_value": "P",
            "uncovered_shape": [
                {"degree_sequence": [0], "edges": 0, "vertices": 1},
                {"degree_sequence": [0], "edges": 0, "vertices": 1},
            ],
            "oriented_edges": 3,
        },
        {
            "minimum_deficiency": 3,
            "exact_value": "N",
            "uncovered_shape": [
                {"degree_sequence": [1, 1, 2], "edges": 2, "vertices": 3}
            ],
            "oriented_edges": 1,
        },
        {
            "minimum_deficiency": 3,
            "exact_value": "P",
            "uncovered_shape": [
                {"degree_sequence": [0], "edges": 0, "vertices": 1},
                {"degree_sequence": [1, 1], "edges": 1, "vertices": 2},
            ],
            "oriented_edges": 2,
        },
    ]
    assert locus == expected_locus
    transports = {
        "q17_representative": transport_check(rewrites[17], cases[0]),
        "q19_control": transport_check(rewrites[19], cases[-1]),
    }
    return {
        "schema": "c80-uncovered-locus-boundary-rewrite-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "q17_minimum_uncovered_locus_census": locus,
        "rewrite": {
            "rank_zero": "Omega=0 and the legal conflict graph satisfies B_cc",
            "rank_one": (
                "every opponent has a legal reply to a rank-zero target"
            ),
            "selection": (
                "retain all replies lexicographically minimizing "
                "(rewrite rank, coverage deficiency)"
            ),
            "soundness": (
                "rank zero is P by persistent/adaptive copycat; "
                "rank one is P by one direct opponent/reply exchange"
            ),
        },
        "cases": cases,
        "transport": transports,
        "verdict": {
            "q17_small_locus_classification": "PASS",
            "q17_opponent_complete_sound_rewrite": "PASS at rank zero",
            "q19_opponent_complete_sound_rewrite": "PASS with four rank-one fibres",
            "selected_correspondence_value_purity": "116/116 P",
            "bounded_algebraic_format": "NOT ESTABLISHED",
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
