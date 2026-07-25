#!/usr/bin/env python3
"""C80: test a nonrecursive overload-retention/Tutte-excess bank."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TUTTE_SOURCE = ROOT / "rust/scripts/c80_tutte_defect_contraction.py"
OUT = ROOT / "notes/2026-07-25-c80-coupled-overload-tutte-bank.json"
INPUTS = (
    TUTTE_SOURCE,
    ROOT / "rust/scripts/c80_positive_pairing_shell.py",
    ROOT / "rust/scripts/c80_adaptive_copycat_survivor.py",
    ROOT / "rust/scripts/c80_strict_overload_kernel.py",
)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


TUTTE = load_module(TUTTE_SOURCE, "c80_tutte_bank_source")
SHELL = TUTTE.SHELL
BASE = TUTTE.BASE
GEOMETRY = TUTTE.GEOMETRY


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def raw_strict_reply_graph(kernel, mask: int):
    """Reply graph using only legality and strict Omega descent."""
    cells = tuple(GEOMETRY.bits(kernel.game.legal_mask(mask)))
    adjacency = [0] * len(cells)
    old_omega = kernel.omega(mask)
    for left, opponent in enumerate(cells):
        child = mask | (1 << opponent)
        legal_replies = kernel.game.legal_mask(child)
        for right in range(left + 1, len(cells)):
            reply = cells[right]
            if not (legal_replies & (1 << reply)):
                continue
            target = child | (1 << reply)
            if kernel.omega(target) < old_omega:
                adjacency[left] |= 1 << right
                adjacency[right] |= 1 << left
    return cells, tuple(adjacency)


def graph_metrics(cells, adjacency) -> dict:
    match = SHELL.maximum_matching(adjacency)
    matching_size = SHELL.matching_size(match)
    deficiency = len(cells) - 2 * matching_size
    return {
        "legal_moves": len(cells),
        "edges": sum(row.bit_count() for row in adjacency) // 2,
        "isolated_vertices": sum(not row for row in adjacency),
        "matching_size": matching_size,
        "deficiency": deficiency,
        "tutte_excess": deficiency - (len(cells) & 1),
    }


@lru_cache(maxsize=None)
def raw_metrics(q: int, mask: int) -> dict:
    kernel = BASE.CopycatKernel(q)
    cells, adjacency = raw_strict_reply_graph(kernel, mask)
    result = graph_metrics(cells, adjacency)
    result["omega"] = kernel.omega(mask)
    result["strict_edges"] = result.pop("edges")
    result["tutte_berge_verified"] = TUTTE.verify_tutte_berge(adjacency)
    return result


def filtered_metrics(kernel, mask: int) -> dict:
    cells, adjacency = TUTTE.reply_graph(kernel, mask)
    return graph_metrics(cells, adjacency)


def cell_index(game, cell: tuple[int, int]) -> int:
    return cell[0] * game.q + cell[1]


def target_mask(game, state: int, opponent: tuple[int, int], reply: tuple[int, int]):
    return (
        state
        | (1 << cell_index(game, opponent))
        | (1 << cell_index(game, reply))
    )


def marked_fibre_audit(kernel, state: int, opponent: tuple[int, int], good_reply):
    opponent_index = cell_index(kernel.game, opponent)
    child = state | (1 << opponent_index)
    child_omega = kernel.omega(child)
    rows = []
    for reply_index in GEOMETRY.bits(kernel.game.legal_mask(child)):
        target = child | (1 << reply_index)
        target_omega = kernel.omega(target)
        if target_omega >= kernel.omega(state):
            continue
        rows.append(
            {
                "reply": list(kernel.game.cell_tuple(reply_index)),
                "omega": target_omega,
                "target": target,
            }
        )
    good = next(row for row in rows if row["reply"] == list(good_reply))
    assert kernel.contains(good["target"])
    good_metrics = raw_metrics(kernel.game.q, good["target"])
    good_public = {
        "reply": good["reply"],
        "omega": good["omega"],
        "tutte_excess": good_metrics["tutte_excess"],
        "tutte_berge_verified": good_metrics["tutte_berge_verified"],
        "in_copycat_survivor": True,
    }
    dominator = None
    for row in sorted(rows, key=lambda item: item["omega"], reverse=True):
        if row["reply"] == list(good_reply) or row["omega"] <= good["omega"]:
            continue
        metrics = raw_metrics(kernel.game.q, row["target"])
        if metrics["tutte_excess"] <= good_metrics["tutte_excess"]:
            dominator = {
                "reply": row["reply"],
                "omega": row["omega"],
                "tutte_excess": metrics["tutte_excess"],
                "tutte_berge_verified": metrics["tutte_berge_verified"],
                "in_copycat_survivor": False,
            }
            break
    return {
        "opponent": list(opponent),
        "child_omega": child_omega,
        "strict_replies": len(rows),
        "copycat_survivor_replies": 1,
        "certified_reply": good_public,
        "dominant_nonsurvivor_found": dominator is not None,
        "strongest_checked_dominant_nonsurvivor": dominator,
    }


def run() -> dict:
    matching_self_check_graphs = SHELL.matching_self_check()
    q17_old = BASE.CopycatKernel(17)
    q17_pair = SHELL.PositivePairingKernel(17)
    q17_root = q17_old.game.base_mask((13, 14, 15, 16))
    q17_rows = []
    q17_fibres = []
    for opponent, reply in (
        ((4, 0), (7, 1)),
        ((5, 0), (4, 10)),
        ((8, 14), (4, 10)),
        ((11, 9), (7, 1)),
    ):
        target = target_mask(q17_old.game, q17_root, opponent, reply)
        q17_rows.append(
            {
                "opponent": list(opponent),
                "reply": list(reply),
                "target_in_copycat_survivor": q17_old.contains(target),
                "target_in_positive_pairing_kernel": q17_pair.contains(target),
                "raw_bank_coordinates": raw_metrics(17, target),
                "recursive_M_omega_filtered_coordinates": filtered_metrics(
                    q17_pair, target
                ),
            }
        )
        q17_fibres.append(
            marked_fibre_audit(q17_old, q17_root, opponent, reply)
        )

    q19_old = BASE.CopycatKernel(19)
    q19_pair = SHELL.PositivePairingKernel(19)
    q19_root = q19_old.game.base_mask((15, 16, 17, 18))
    q19_rows = []
    for role, reply in (
        ("maximum_drain_decoy", (7, 1)),
        ("structural_survivor", (0, 2)),
    ):
        target = target_mask(q19_old.game, q19_root, (4, 0), reply)
        q19_rows.append(
            {
                "role": role,
                "opponent": [4, 0],
                "reply": list(reply),
                "target_in_copycat_survivor": q19_old.contains(target),
                "target_in_positive_pairing_kernel": q19_pair.contains(target),
                "raw_bank_coordinates": raw_metrics(19, target),
            }
        )

    assert all(
        row["raw_bank_coordinates"]["tutte_excess"] == 0
        and row["recursive_M_omega_filtered_coordinates"]["tutte_excess"] == 2
        and row["recursive_M_omega_filtered_coordinates"][
            "isolated_vertices"
        ] == 0
        and row["raw_bank_coordinates"]["tutte_berge_verified"]
        for row in q17_rows
    )
    assert all(
        row["dominant_nonsurvivor_found"] for row in q17_fibres
    )
    assert all(
        row["raw_bank_coordinates"]["tutte_excess"] == 0
        and row["raw_bank_coordinates"]["tutte_berge_verified"]
        for row in q19_rows
    )
    assert all(
        row["certified_reply"]["tutte_berge_verified"]
        and row["strongest_checked_dominant_nonsurvivor"][
            "tutte_berge_verified"
        ]
        for row in q17_fibres
    )
    assert q19_rows[1]["raw_bank_coordinates"]["omega"] > q19_rows[0][
        "raw_bank_coordinates"
    ]["omega"]

    return {
        "schema": "c80-coupled-overload-tutte-bank-v1",
        "source": "rust/scripts/c80_coupled_overload_tutte_bank.py",
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path) for path in INPUTS
        },
        "definition": {
            "raw_strict_reply_graph": (
                "vertices are legal moves; xy is an edge iff x,y are jointly "
                "legal and the two-move target has strictly lower Omega"
            ),
            "tutte_excess": (
                "matching deficiency of the raw strict-reply graph minus its "
                "unavoidable parity deficiency"
            ),
            "candidate_bank": "Omega(target) - lambda * tutte_excess(target)",
            "lambda_domain": "lambda >= 0",
        },
        "matching_self_check_graphs": matching_self_check_graphs,
        "all_reported_tutte_berge_certificates_verified": True,
        "verdict": {
            "candidate_falsified": True,
            "reason": (
                "raw Tutte excess is zero on every tested target; in each "
                "q17 exceptional fibre a nonsurvivor with Omega 49 and excess "
                "zero strictly dominates the unique survivor at Omega 40"
            ),
            "generality": (
                "the same witnesses falsify every bank monotone increasing in "
                "retained Omega and monotone decreasing in raw Tutte excess"
            ),
            "recursive_filter_warning": (
                "the q17 target excess two appears only after reply edges are "
                "filtered by lower M_Omega membership"
            ),
        },
        "q17_defect_thread": q17_rows,
        "q17_marked_fibre_falsifier": q17_fibres,
        "q19_marked_control": q19_rows,
    }


def write_output(path: Path) -> None:
    path.write_text(json.dumps(run(), indent=2, sort_keys=True) + "\n")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check:
        with tempfile.TemporaryDirectory() as tmp:
            candidate = Path(tmp) / OUT.name
            write_output(candidate)
            if not OUT.exists() or candidate.read_bytes() != OUT.read_bytes():
                print(f"FAIL {OUT.relative_to(ROOT)}")
                return 1
        print(f"PASS {OUT.relative_to(ROOT)}")
        return 0
    write_output(OUT)
    print(f"WROTE {OUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
