#!/usr/bin/env python3
"""C80: q23 out-of-sample falsifier for the bounded small-shell relation."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import subprocess
import sys
import tempfile
from collections import Counter
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "rust/scripts/c80_q19_rank_one_incidence_shell.py"
C54_REPORT = ROOT / "notes/2026-07-09-codex-q23-bucket-certification.md"
ORACLE_BINARY = ROOT / "rust/target/gridcap-c54"
ORACLE_RAW = (
    ROOT / "rust/s4-dumps/2026-07-08/q23-root-1234-1-2-3-4.raw"
)
OUT = ROOT / "notes/2026-07-25-c80-q23-small-shell-falsifier.json"

Q = 23
T4 = (1, 2, 3, 4)
HISTORY_OPPONENT = (0, 0)
HISTORY_REPLY = (5, 2)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


BASE = load_module(SOURCE, "c80_q23_small_shell_base")
GEOMETRY = BASE.GEOMETRY
LIVE = BASE.LIVE
INPUTS = tuple(sorted(set((*BASE.INPUTS, SOURCE, C54_REPORT))))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def oracle_evidence() -> dict:
    if not ORACLE_BINARY.is_file() or not ORACLE_RAW.is_file():
        raise RuntimeError(
            "q23 C54 binary/raw archive required for the exact P-label check"
        )
    command = [
        str(ORACLE_BINARY),
        "s4query",
        str(Q),
        ",".join(map(str, T4)),
        "--raw",
        str(ORACLE_RAW),
    ]
    result = subprocess.run(
        command,
        input=(
            f"state\nreplies {HISTORY_OPPONENT[0]},{HISTORY_OPPONENT[1]}\n"
            "quit\n"
        ),
        text=True,
        capture_output=True,
        check=True,
    )
    state_line = next(
        line for line in result.stdout.splitlines()
        if line.startswith("STATE ")
    )
    reply_prefix = (
        f"REPLY x={HISTORY_OPPONENT[0]},{HISTORY_OPPONENT[1]} "
        f"y={HISTORY_REPLY[0]},{HISTORY_REPLY[1]} "
    )
    reply_line = next(
        line for line in result.stdout.splitlines()
        if line.startswith(reply_prefix)
    )
    assert "value=P" in state_line
    assert "value=P" in reply_line
    return {
        "root_state_line": state_line,
        "history_reply_line": reply_line,
        "binary": str(ORACLE_BINARY.relative_to(ROOT)),
        "binary_sha256": sha256(ORACLE_BINARY),
        "raw_archive": str(ORACLE_RAW.relative_to(ROOT)),
        "raw_archive_bytes": ORACLE_RAW.stat().st_size,
        "raw_archive_sha256": sha256(ORACLE_RAW),
        "c54_contract": str(C54_REPORT.relative_to(ROOT)),
        "trust": (
            "exact early-break proof-DAG value queried through the "
            "independently rules-checked C54 archive interface"
        ),
    }


def build_certificate() -> dict:
    oracle = oracle_evidence()
    shell = BASE.IncidenceShell(Q)
    game = shell.game
    root = game.base_mask(T4)
    target = (
        root
        | (1 << LIVE.cell_index(game, HISTORY_OPPONENT))
        | (1 << LIVE.cell_index(game, HISTORY_REPLY))
    )

    @lru_cache(maxsize=None)
    def inner_coverage(mask: int) -> tuple[int, int]:
        legal = game.legal_mask(mask)
        covered = 0
        for opponent in GEOMETRY.bits(legal):
            child = mask | (1 << opponent)
            if any(
                shell.small_boundary(child | (1 << reply)) is not None
                for reply in GEOMETRY.bits(game.legal_mask(child))
            ):
                covered += 1
        return legal.bit_count(), covered

    rows = []
    for opponent in GEOMETRY.bits(game.legal_mask(target)):
        child = target | (1 << opponent)
        candidates = []
        for reply in GEOMETRY.bits(game.legal_mask(child)):
            follower = child | (1 << reply)
            boundary_kind = shell.small_boundary(follower)
            total, covered = inner_coverage(follower)
            rank = (
                0 if boundary_kind is not None
                else (1 if total == covered else None)
            )
            candidates.append(
                {
                    "reply": list(game.cell_tuple(reply)),
                    "small_shell_rank": rank,
                    "follower_legal_moves": total,
                    "inner_opponents_covered": covered,
                    "inner_opponents_uncovered": total - covered,
                    "target_omega": shell.kernel.omega(follower),
                }
            )
        selected = [
            row for row in candidates if row["small_shell_rank"] is not None
        ]
        assert not selected
        best_key = min(
            (
                row["inner_opponents_uncovered"],
                -row["inner_opponents_covered"],
            )
            for row in candidates
        )
        best = [
            row for row in candidates
            if (
                row["inner_opponents_uncovered"],
                -row["inner_opponents_covered"],
            )
            == best_key
        ]
        rows.append(
            {
                "opponent": list(game.cell_tuple(opponent)),
                "legal_replies_tested": len(candidates),
                "formula_replies": selected,
                "minimum_inner_opponents_uncovered": best_key[0],
                "maximum_inner_coverage_at_minimum_defect": -best_key[1],
                "best_failed_replies": best,
            }
        )

    defect_histogram = Counter(
        row["minimum_inner_opponents_uncovered"] for row in rows
    )
    coverage_histogram = Counter(
        row["maximum_inner_coverage_at_minimum_defect"] for row in rows
    )
    reply_count_histogram = Counter(
        row["legal_replies_tested"] for row in rows
    )
    assert len(rows) == 118
    assert all(
        row["minimum_inner_opponents_uncovered"] >= 3 for row in rows
    )
    assert defect_histogram == {
        3: 2,
        6: 2,
        8: 2,
        9: 7,
        10: 3,
        11: 9,
        12: 13,
        13: 9,
        14: 11,
        15: 14,
        16: 17,
        17: 8,
        18: 10,
        19: 5,
        20: 3,
        21: 2,
        22: 1,
    }
    assert coverage_histogram == {
        8: 1,
        9: 1,
        10: 2,
        11: 4,
        12: 11,
        13: 15,
        14: 18,
        15: 13,
        16: 14,
        17: 14,
        18: 12,
        19: 10,
        20: 1,
        21: 2,
    }

    root_opponent = LIVE.cell_index(game, HISTORY_OPPONENT)
    root_child = root | (1 << root_opponent)
    root_reply_rows = []
    for root_reply in GEOMETRY.bits(game.legal_mask(root_child)):
        reply_target = root_child | (1 << root_reply)
        first_missing = None
        for opponent in GEOMETRY.bits(game.legal_mask(reply_target)):
            child = reply_target | (1 << opponent)
            if not any(
                shell.small_boundary(child | (1 << reply)) is not None
                or shell.shell_holds(child | (1 << reply))
                for reply in GEOMETRY.bits(game.legal_mask(child))
            ):
                first_missing = list(game.cell_tuple(opponent))
                break
        root_reply_rows.append(
            {
                "reply": list(game.cell_tuple(root_reply)),
                "reply_target_satisfies_outer_correspondence": (
                    first_missing is None
                ),
                "first_uncovered_next_opponent": first_missing,
            }
        )
    assert len(root_reply_rows) == 181
    assert not any(
        row["reply_target_satisfies_outer_correspondence"]
        for row in root_reply_rows
    )
    first_missing_histogram = Counter(
        tuple(row["first_uncovered_next_opponent"])
        for row in root_reply_rows
    )
    assert first_missing_histogram == {
        (5, 2): 118,
        (5, 9): 38,
        (5, 10): 12,
        (5, 11): 1,
        (5, 13): 2,
        (6, 3): 6,
        (6, 4): 3,
        (6, 5): 1,
    }
    root_stabilizer = LIVE.stabilizer_matrices(game, root)
    target_stabilizer = LIVE.stabilizer_matrices(game, target)
    assert len(root_stabilizer) == 4
    assert len(target_stabilizer) == 1

    return {
        "schema": "c80-q23-small-shell-falsifier-v1",
        "source": str(Path(__file__).resolve().relative_to(ROOT)),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "oracle_evidence": oracle,
        "control": {
            "q": Q,
            "root_t4": list(T4),
            "history_edge": {
                "opponent": list(HISTORY_OPPONENT),
                "reply": list(HISTORY_REPLY),
            },
            "exact_value": "P",
            "target_omega": shell.kernel.omega(target),
            "legal_moves": game.legal_mask(target).bit_count(),
            "root_stabilizer_order": len(root_stabilizer),
            "target_stabilizer_order": len(target_stabilizer),
        },
        "incidence_equations": {
            "legal": (
                "L_S(z) iff z is not selected and det(a,b,z) != 0 "
                "for every distinct selected a,b"
            ),
            "omega_zero": (
                "there is no zero-load line ell containing three distinct "
                "points of L_S"
            ),
            "small_boundary": (
                "Omega(S)=0 and either L_S is empty or "
                "L_S={a,b} with L_{S+a}(b)"
            ),
            "small_shell": (
                "for every x in L_S there exists y in L_{S+x} "
                "such that S+x+y satisfies the small boundary"
            ),
            "outer_relation": (
                "R_small(T;o,p) iff p in L_{T+o} and "
                "T+o+p satisfies the small boundary or small shell"
            ),
        },
        "fibre_census": {
            "opponents": len(rows),
            "opponents_with_formula_reply": 0,
            "legal_reply_count_histogram": [
                {"legal_replies": key, "opponents": count}
                for key, count in sorted(reply_count_histogram.items())
            ],
            "minimum_inner_uncovered_histogram": [
                {"minimum_uncovered": key, "opponents": count}
                for key, count in sorted(defect_histogram.items())
            ],
            "maximum_coverage_at_minimum_defect_histogram": [
                {"inner_opponents_covered": key, "outer_opponents": count}
                for key, count in sorted(coverage_histogram.items())
            ],
            "best_global_failed_fibre": {
                "outer_opponent": [9, 16],
                "outer_reply": [17, 18],
                "follower_legal_moves": 24,
                "inner_opponents_covered": 21,
                "inner_opponents_uncovered": 3,
                "target_omega": 18,
            },
            "rows": rows,
        },
        "root_opponent_fibre_falsifier": {
            "opponent": list(HISTORY_OPPONENT),
            "legal_replies_tested": len(root_reply_rows),
            "reply_targets_satisfying_outer_correspondence": 0,
            "first_uncovered_next_opponent_histogram": [
                {
                    "first_uncovered_opponent": list(key),
                    "root_replies": count,
                }
                for key, count in sorted(first_missing_histogram.items())
            ],
            "rows": root_reply_rows,
        },
        "verdict": {
            "q23_out_of_sample_gate": "FAIL",
            "opponent_coverage": "0/118",
            "root_opponent_replies_into_correspondence": "0/181",
            "minimum_defect_over_all_outer_fibres": 3,
            "bounded_formula_soundness": "PRESERVED",
            "uniform_opponent_completeness": "FALSE",
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
