#!/usr/bin/env python3
"""C80: compare canonical spoiling fibres with certified marked repairs."""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
import tempfile
from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SPOILER_SOURCE = ROOT / "rust/scripts/c80_spoiling_fibre_canonicalization.py"
PROFILE_SOURCE = ROOT / "rust/scripts/c80_marked_secant_profile_persistence.py"
OUT = ROOT / "notes/2026-07-25-c80-marked-secant-spoiler-repair-compare.json"

REPAIRS = (
    (17, (13, 14, 15, 16), (4, 0), (7, 1)),
    (17, (13, 14, 15, 16), (5, 0), (4, 10)),
    (17, (13, 14, 15, 16), (8, 14), (4, 10)),
    (17, (13, 14, 15, 16), (11, 9), (7, 1)),
    (19, (15, 16, 17, 18), (4, 0), (0, 2)),
)

SCALAR_NAMES = (
    "overloaded_lines_through_reply",
    "overload_mass_through_reply",
    "maximum_load_through_reply",
    "thinned_active_lines",
    "total_thinned_overload",
    "killed_legal_points",
    "marked_chord_parent_legal",
    "marked_chord_child_legal",
    "target_live_conic",
    "target_omega",
    "target_legal_points",
    "opponent_reply_product_order",
    "reply_fixed_selected_conic_parameters",
)


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


SPOILER = load_module(SPOILER_SOURCE, "c80_compare_spoiler")
PROFILE = load_module(PROFILE_SOURCE, "c80_compare_profile")
GEOMETRY = SPOILER.GEOMETRY

INPUTS = (
    SPOILER_SOURCE,
    PROFILE_SOURCE,
    SPOILER.SOURCE,
    *SPOILER.BANK.INPUTS,
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cell_index(game, cell: tuple[int, int]) -> int:
    return cell[0] * game.q + cell[1]


def json_histogram(values) -> list[dict]:
    counts = Counter(
        json.dumps(value, sort_keys=True, separators=(",", ":"))
        for value in values
    )
    return [
        {"value": json.loads(value), "count": count}
        for value, count in sorted(counts.items())
    ]


def expanded_loads(q: int, deficiency_histogram: tuple) -> list[int]:
    return [
        q - deficiency
        for deficiency, count in deficiency_histogram
        for _ in range(count)
    ]


def active_line_load_histogram(kernel, target: int) -> list[list[int]]:
    legal = kernel.game.legal_mask(target)
    loads = Counter()
    for line_mask, fixed_load in kernel.lines:
        if fixed_load + (target & line_mask).bit_count() == 0:
            loads[(legal & line_mask).bit_count()] += 1
    return [[load, count] for load, count in sorted(loads.items())]


def edge_features(kernel, state: int, opponent: int, reply: int) -> dict:
    game = kernel.game
    child = state | (1 << opponent)
    target = child | (1 << reply)
    destruction = PROFILE.destruction_profile(
        kernel, state, opponent, reply
    )
    orbital = PROFILE.orbital_profile(kernel, state, opponent, reply)
    through_loads = expanded_loads(kernel.q, destruction[5])
    thinned = destruction[6]
    played = GEOMETRY.played_params(game, state)
    opponent_intruder = not game.is_conic_cell(opponent)
    reply_intruder = not game.is_conic_cell(reply)
    product_order = (
        GEOMETRY.prod_order(game, opponent, reply)
        if opponent_intruder and reply_intruder
        else 0
    )
    reply_fixed = (
        GEOMETRY.tau_played(game, reply, played)
        if reply_intruder
        else -1
    )
    scalar = (
        len(through_loads),
        sum(load - 2 for load in through_loads),
        max(through_loads, default=0),
        sum(count for _key, count in thinned),
        sum(key[2] * count for key, count in thinned),
        destruction[7],
        destruction[3],
        destruction[4],
        len(GEOMETRY.live_conic(game, target)),
        kernel.omega(target),
        game.legal_mask(target).bit_count(),
        product_order,
        reply_fixed,
    )
    return {
        "opponent": list(game.cell_tuple(opponent)),
        "reply": list(game.cell_tuple(reply)),
        "opponent_kind": destruction[0],
        "reply_kind": destruction[1],
        "opponent_reply_line_type": GEOMETRY.line_type(
            game, opponent, reply
        ),
        "opponent_reply_product_order": product_order,
        "opponent_fixed_selected_conic_parameters": (
            GEOMETRY.tau_played(game, opponent, played)
            if opponent_intruder
            else -1
        ),
        "reply_fixed_selected_conic_parameters": reply_fixed,
        "marked_chord_selected_load": destruction[2],
        "marked_chord_parent_legal": destruction[3],
        "marked_chord_child_legal": destruction[4],
        "deactivated_line_deficiency_histogram": [
            [key, count] for key, count in destruction[5]
        ],
        "thinned_line_profile_histogram": [
            [list(key), count] for key, count in destruction[6]
        ],
        "killed_legal_points": destruction[7],
        "target_omega": kernel.omega(target),
        "target_legal_points": game.legal_mask(target).bit_count(),
        "target_live_conic": len(GEOMETRY.live_conic(game, target)),
        "target_active_line_load_histogram": active_line_load_histogram(
            kernel, target
        ),
        "scalar_summary": {
            name: value for name, value in zip(SCALAR_NAMES, scalar)
        },
        "_scalar_tuple": scalar,
        "_full_profile": destruction + orbital,
        "_target": target,
    }


def public_features(features: dict) -> dict:
    return {
        key: value
        for key, value in features.items()
        if not key.startswith("_")
    }


def independent_small_value(game, start: int) -> bool:
    """Return True for N, using only the move relation from legal_mask."""

    @lru_cache(maxsize=None)
    def is_n(mask: int) -> bool:
        return any(
            not is_n(mask | (1 << move))
            for move in GEOMETRY.bits(game.legal_mask(mask))
        )

    return is_n(start)


def repair_rows() -> tuple[list[dict], list[tuple], list[tuple[tuple, bool]]]:
    rows = []
    profiles = []
    natural_rows = []
    by_order: dict[int, tuple] = {}
    for q, t4, opponent_cell, reply_cell in REPAIRS:
        if q not in by_order:
            pair_kernel = SPOILER.SHELL.PositivePairingKernel(q)
            copycat_kernel = SPOILER.BASE.CopycatKernel(q)
            by_order[q] = (pair_kernel, copycat_kernel)
        pair_kernel, copycat_kernel = by_order[q]
        root = pair_kernel.game.base_mask(t4)
        opponent = cell_index(pair_kernel.game, opponent_cell)
        reply = cell_index(pair_kernel.game, reply_cell)
        features = edge_features(pair_kernel, root, opponent, reply)
        target = features["_target"]
        exact_is_n = pair_kernel.game.value(target)
        assert not exact_is_n
        assert copycat_kernel.contains(target)
        row = {
            "q": q,
            "root_t4": list(t4),
            "certified_copycat_survivor": True,
            "certified_positive_pairing_kernel": pair_kernel.contains(target),
            "exact_grid_value": "P",
            "features": public_features(features),
        }
        rows.append(row)
        profiles.append(features["_full_profile"])

    for q, (pair_kernel, _copycat_kernel) in sorted(by_order.items()):
        root_labels = REPAIRS[0][1] if q == 17 else REPAIRS[-1][1]
        root = pair_kernel.game.base_mask(root_labels)
        old_omega = pair_kernel.omega(root)
        opponents = [
            cell_index(pair_kernel.game, case[2])
            for case in REPAIRS
            if case[0] == q
        ]
        for opponent in opponents:
            child = root | (1 << opponent)
            for reply in GEOMETRY.bits(pair_kernel.game.legal_mask(child)):
                target = child | (1 << reply)
                if pair_kernel.omega(target) >= old_omega:
                    continue
                features = edge_features(
                    pair_kernel, root, opponent, reply
                )
                natural_rows.append(
                    (features["_full_profile"], not pair_kernel.game.value(target))
                )
    return rows, profiles, natural_rows


def spoiler_rows() -> tuple[
    list[dict], dict[str, list[dict]], dict[str, list[tuple[str, ...]]]
]:
    rows = []
    by_type: dict[str, list[dict]] = defaultdict(list)
    fibre_multisets: dict[str, list[tuple[str, ...]]] = defaultdict(list)
    for q, t4, marked_opponent, decoy_reply in SPOILER.CASES:
        pair_kernel = SPOILER.SHELL.PositivePairingKernel(q)
        copycat_kernel = SPOILER.BASE.CopycatKernel(q)
        root = pair_kernel.game.base_mask(t4)
        decoy = SPOILER.BANK.target_mask(
            pair_kernel.game, root, marked_opponent, decoy_reply
        )
        for opponent, replies in SPOILER.direct_spoilers(
            pair_kernel, copycat_kernel, decoy
        ):
            type_name = f"q{q}-strict-{len(replies)}"
            fibre = []
            for reply_row in replies:
                reply = cell_index(
                    pair_kernel.game, tuple(reply_row["reply"])
                )
                features = edge_features(
                    pair_kernel, decoy, opponent, reply
                )
                target = features["_target"]
                engine_is_n = pair_kernel.game.value(target)
                independent_is_n = independent_small_value(
                    pair_kernel.game, target
                )
                assert engine_is_n and independent_is_n
                assert not copycat_kernel.contains(target)
                assert not pair_kernel.contains(target)
                if pair_kernel.omega(target) == 0:
                    features["target_boundary_grundy"] = (
                        pair_kernel.boundary_grundy(target)
                    )
                    features["target_follower_value_summary"] = None
                else:
                    follower_values = Counter()
                    p_followers = []
                    for move in GEOMETRY.bits(
                        pair_kernel.game.legal_mask(target)
                    ):
                        follower = target | (1 << move)
                        value = (
                            "N" if pair_kernel.game.value(follower) else "P"
                        )
                        follower_values[value] += 1
                        if value == "P":
                            p_followers.append(
                                list(pair_kernel.game.cell_tuple(move))
                            )
                    features["target_boundary_grundy"] = None
                    features["target_follower_value_summary"] = {
                        "P": follower_values["P"],
                        "N": follower_values["N"],
                        "P_moves": p_followers,
                    }
                fibre.append(features)
                rows.append(
                    {
                        "q": q,
                        "type": type_name,
                        "exact_grid_value": "N",
                        "independent_small_tree_value": "N",
                        "in_copycat_survivor": False,
                        "in_positive_pairing_kernel": False,
                        "features": public_features(features),
                    }
                )
                by_type[type_name].append(features)
            assert fibre
            fibre_multisets[type_name].append(
                tuple(
                    sorted(
                        json.dumps(
                            {
                                key: value
                                for key, value in public_features(
                                    features
                                ).items()
                                if key not in {"opponent", "reply"}
                            },
                            sort_keys=True,
                            separators=(",", ":"),
                        )
                        for features in fibre
                    )
                )
            )
    return rows, by_type, fibre_multisets


def type_summary(
    type_name: str, rows: list[dict], fibre_multisets: list[tuple[str, ...]]
) -> dict:
    fields = (
        "opponent_reply_line_type",
        "opponent_reply_product_order",
        "reply_fixed_selected_conic_parameters",
        "marked_chord_parent_legal",
        "marked_chord_child_legal",
        "killed_legal_points",
        "target_omega",
        "target_legal_points",
        "target_live_conic",
        "target_boundary_grundy",
    )
    return {
        "type": type_name,
        "coordinate_fibres": len(fibre_multisets),
        "candidate_edges": len(rows),
        "all_exact_N": True,
        "feature_multiset_identical_across_coordinate_fibres": (
            len(set(fibre_multisets)) == 1
        ),
        "feature_histograms": {
            field: json_histogram([row[field] for row in rows])
            for field in fields
        },
        "deactivated_line_profiles": json_histogram(
            [row["deactivated_line_deficiency_histogram"] for row in rows]
        ),
        "thinned_line_profiles": json_histogram(
            [row["thinned_line_profile_histogram"] for row in rows]
        ),
    }


def threshold_audit(
    repair_profiles: list[tuple],
    natural_rows: list[tuple[tuple, bool]],
    repair_rows_public: list[dict],
) -> dict:
    repair_scalars = [
        tuple(
            row["features"]["scalar_summary"][name]
            for name in SCALAR_NAMES
        )
        for row in repair_rows_public
    ]
    atoms = []
    for index, name in enumerate(SCALAR_NAMES):
        lower = min(row[index] for row in repair_scalars)
        upper = max(row[index] for row in repair_scalars)
        atoms.append((f"{name}>={lower}", index, "ge", lower))
        atoms.append((f"{name}<={upper}", index, "le", upper))

    def accepts(scalars: tuple, atom: tuple) -> bool:
        _name, index, relation, threshold = atom
        if relation == "ge":
            return scalars[index] >= threshold
        return scalars[index] <= threshold

    exact_profile_counts = []
    for profile in sorted(set(repair_profiles), key=repr):
        labels = [
            is_p for candidate, is_p in natural_rows if candidate == profile
        ]
        exact_profile_counts.append(
            {
                "occurrences": len(labels),
                "P": sum(labels),
                "N": len(labels) - sum(labels),
            }
        )

    # Re-enumerate the compact scalar rows from the five natural fibres.
    scalar_rows = []
    for q, t4, opponent_cell, _reply_cell in REPAIRS:
        pair_kernel = SPOILER.SHELL.PositivePairingKernel(q)
        root = pair_kernel.game.base_mask(t4)
        opponent = cell_index(pair_kernel.game, opponent_cell)
        child = root | (1 << opponent)
        old_omega = pair_kernel.omega(root)
        for reply in GEOMETRY.bits(pair_kernel.game.legal_mask(child)):
            target = child | (1 << reply)
            if pair_kernel.omega(target) >= old_omega:
                continue
            features = edge_features(pair_kernel, root, opponent, reply)
            scalar_rows.append(
                (
                    features["_scalar_tuple"],
                    not pair_kernel.game.value(target),
                )
            )

    first_pure_size = None
    first_pure_examples = []
    for size in range(1, 5):
        for indices in combinations(range(len(atoms)), size):
            selected = [
                is_p
                for scalars, is_p in scalar_rows
                if all(accepts(scalars, atoms[index]) for index in indices)
            ]
            if selected and all(selected):
                first_pure_size = size
                first_pure_examples.append(
                    {
                        "atoms": [atoms[index][0] for index in indices],
                        "selected_P_edges": len(selected),
                    }
                )
                if len(first_pure_examples) == 3:
                    break
        if first_pure_size is not None:
            break

    return {
        "natural_marked_strict_fibres": {
            "edges": len(scalar_rows),
            "P": sum(is_p for _row, is_p in scalar_rows),
            "N": sum(not is_p for _row, is_p in scalar_rows),
        },
        "exact_full_profile_membership": exact_profile_counts,
        "threshold_atom_library": {
            "scalar_coordinates": list(SCALAR_NAMES),
            "atoms": (
                "for each coordinate, the weakest lower and upper thresholds "
                "that accept all five certified repairs"
            ),
            "no_P_pure_conjunction_through_size": first_pure_size - 1,
            "first_P_pure_conjunction_size": first_pure_size,
            "first_examples": first_pure_examples,
        },
    }


def run() -> dict:
    repairs, repair_profiles, natural_rows = repair_rows()
    spoilers, by_type, fibre_multisets = spoiler_rows()
    assert len(repairs) == 5
    assert len(spoilers) == 106
    assert sorted((name, len(rows)) for name, rows in by_type.items()) == [
        ("q17-strict-11", 44),
        ("q17-strict-12", 48),
        ("q19-strict-14", 14),
    ]
    assert {
        name: len(fibres) for name, fibres in fibre_multisets.items()
    } == {
        "q17-strict-11": 4,
        "q17-strict-12": 4,
        "q19-strict-14": 1,
    }
    assert all(
        len(set(fibres)) == 1 for fibres in fibre_multisets.values()
    )
    boundary_grundies = [
        row["features"]["target_boundary_grundy"]
        for row in spoilers
        if row["features"]["target_omega"] == 0
    ]
    omega_one = [
        row for row in spoilers if row["features"]["target_omega"] == 1
    ]
    assert len(boundary_grundies) == 105
    assert set(boundary_grundies) == {1, 2}
    assert len(omega_one) == 1
    assert omega_one[0]["features"]["target_follower_value_summary"] == {
        "P": 1,
        "N": 3,
        "P_moves": [[14, 8]],
    }

    repair_chord = [
        row["features"]["marked_chord_parent_legal"] for row in repairs
    ]
    spoiler_chord = [
        row["features"]["marked_chord_parent_legal"] for row in spoilers
    ]
    repair_live = [
        row["features"]["target_live_conic"] for row in repairs
    ]
    spoiler_live = [
        row["features"]["target_live_conic"] for row in spoilers
    ]
    repair_legal = [
        row["features"]["target_legal_points"] for row in repairs
    ]
    spoiler_legal = [
        row["features"]["target_legal_points"] for row in spoilers
    ]

    return {
        "schema": "c80-marked-secant-spoiler-repair-compare-v1",
        "source": (
            "rust/scripts/c80_marked_secant_spoiler_repair_compare.py"
        ),
        "input_sha256": {
            str(path.relative_to(ROOT)): sha256(path)
            for path in dict.fromkeys(INPUTS)
        },
        "scope": (
            "The four certified q17 Omega=40 repair edges, the certified "
            "q19 Omega=169 repair edge, all 106 strict candidates in the "
            "three canonical spoiling types, and the complete natural "
            "strict-reply fibres of the five marked root opponents."
        ),
        "repairs": repairs,
        "spoiling_candidates": spoilers,
        "canonical_type_summaries": [
            type_summary(name, rows, fibre_multisets[name])
            for name, rows in sorted(by_type.items())
        ],
        "finite_separations": {
            "marked_chord_parent_legal": {
                "repairs": [min(repair_chord), max(repair_chord)],
                "spoilers": [min(spoiler_chord), max(spoiler_chord)],
            },
            "target_live_conic": {
                "repairs": [min(repair_live), max(repair_live)],
                "spoilers": [min(spoiler_live), max(spoiler_live)],
            },
            "target_legal_points": {
                "repairs": [min(repair_legal), max(repair_legal)],
                "spoilers": [min(spoiler_legal), max(spoiler_legal)],
            },
            "interpretation": (
                "Every spoiler is a premature near-boundary collapse: all "
                "q17 candidates have Omega=0; at q19 thirteen have Omega=0 "
                "and one has Omega=1. The repairs retain a broad active-line "
                "and conic reservoir. These gaps separate this finite data "
                "but do not prove future survival."
            ),
        },
        "profile_purity_audit": threshold_audit(
            repair_profiles, natural_rows, repairs
        ),
        "cross_checks": {
            "all_spoilers_exact_N_in_grid_engine": True,
            "all_spoilers_exact_N_in_independent_small_tree_replay": True,
            "overload_zero_spoilers_have_grundy_one_or_two": True,
            "unique_overload_one_spoiler_has_one_P_follower": True,
            "all_repairs_exact_P_in_grid_engine": True,
            "all_repairs_in_structural_copycat_survivor": True,
            "candidate_count": len(spoilers),
        },
        "verdict": (
            "The three canonical spoiling types are actual N-edge fibres, "
            "not merely misses of F_cc. Full marked destruction profiles "
            "identify the five repairs purely in the searched root fibres, "
            "but no conjunction of at most three predeclared monotone scalar "
            "thresholds does. The clean finite gap is premature absorption, "
            "not a demonstrated q-independent admissible-edge law."
        ),
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
