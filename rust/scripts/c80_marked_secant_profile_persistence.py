#!/usr/bin/env python3
"""C80: test persistence of intrinsic marked-secant exchange profiles.

The retention identity only sees two kinds of active capacity-two lines:

* lines through the reply, whose full overload is deactivated; and
* lines not through the reply, whose overload is thinned by points killed
  on the new reply--selected secants.

This script records that complete destruction profile in projectively
normalized form.  A line of the affine chart has ``q`` residual cells, so
its load is represented by the deficiency ``q-load``.  The profile also
retains the opponent/reply chord data and conic/off-conic sorts.

We then ask the strongest classifier-free question available from this
profile: which profiles are globally safe, meaning that every occurrence
is a positive strict reply into the lower strict-overload kernel?  If a
marked fibre has no globally safe profile, no exchange class measurable
from the exact retention data can certify that fibre.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter, defaultdict
from fractions import Fraction
from functools import lru_cache
from itertools import combinations
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-25-c80-marked-secant-profile-persistence.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


SCALE = load_module(
    ROOT / "rust/scripts/c80_scale_survivor_falsifiers.py",
    "c80_profile_scale",
)
KERNEL = SCALE.KERNEL


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def kind(base, point: int) -> str:
    return "conic" if base.game.is_conic_cell(point) else "intruder"


def histogram(values) -> tuple[tuple[object, int], ...]:
    return tuple(sorted(Counter(values).items()))


def destruction_profile(base, state: int, opponent: int, reply: int) -> tuple:
    """Complete normalized data entering the marked-secant drop identity."""
    q = base.q
    state_legal = base.game.legal_mask(state)
    child = state | (1 << opponent)
    child_legal = base.game.legal_mask(child)
    target = child | (1 << reply)
    target_legal = base.game.legal_mask(target)
    killed = child_legal & ~target_legal & ~(1 << reply)

    through = []
    thinned = []
    for line_mask, fixed_load in base.lines:
        if fixed_load + (child & line_mask).bit_count() != 0:
            continue
        load = (child_legal & line_mask).bit_count()
        excess = max(0, load - 2)
        if line_mask & (1 << reply):
            if excess:
                through.append(q - load)
            continue
        killed_on_line = (killed & line_mask).bit_count()
        loss = min(killed_on_line, excess)
        if loss:
            thinned.append((q - load, killed_on_line, loss))

    chord = base.game.line_masks[opponent + 2][reply + 2]
    chord_fixed = sum(
        base.game.collinear(
            fixed,
            base.game.points[opponent + 2],
            base.game.points[reply + 2],
        )
        for fixed in (base.game.a, base.game.b)
    )
    chord_selected = chord_fixed + (state & chord).bit_count()
    chord_parent_legal = (state_legal & chord).bit_count()
    chord_child_legal = (child_legal & chord).bit_count()

    return (
        kind(base, opponent),
        kind(base, reply),
        chord_selected,
        chord_parent_legal,
        chord_child_legal,
        histogram(through),
        histogram(thinned),
        killed.bit_count(),
    )


@lru_cache(maxsize=None)
def pair_product_order(base, first: int, second: int) -> int:
    if first > second:
        first, second = second, first
    return KERNEL.GEOMETRY.prod_order(base.game, first, second)


@lru_cache(maxsize=None)
def triple_fixed_count(base, first: int, second: int, third: int) -> int:
    points = tuple(sorted((first, second, third)))
    perms = [base.game.sigma_perm(point) for point in points]
    return sum(
        perms[0][perms[1][perms[2][parameter]]] == parameter
        for parameter in base.game.params
    )


def triple_fixed_histogram(base, points: tuple[int, ...]) -> tuple:
    return histogram(
        triple_fixed_count(base, *triple)
        for triple in combinations(points, 3)
    )


def orbital_profile(base, state: int, opponent: int, reply: int) -> tuple:
    """Bounded conic-involution data after normalizing the fixed conic/frame."""
    old = tuple(
        KERNEL.GEOMETRY.bits(state & ~base.game.conic_mask)
    )
    opponent_intruder = not base.game.is_conic_cell(opponent)
    reply_intruder = not base.game.is_conic_cell(reply)

    def pair_orders(left: tuple[int, ...], right: tuple[int, ...]) -> tuple:
        pairs = (
            combinations(left, 2)
            if left == right
            else (
                (a, b)
                for a in left
                for b in right
                if a != b
            )
        )
        return tuple(
            sorted(
                pair_product_order(base, a, b) for a, b in pairs
            )
        )

    marked = tuple(
        point
        for point, enabled in (
            (opponent, opponent_intruder),
            (reply, reply_intruder),
        )
        if enabled
    )
    all_intruders = old + marked
    selected_conic_parameters = tuple(
        sorted(
            base.game.cell_param[point]
            for point in KERNEL.GEOMETRY.bits(
                state & base.game.conic_mask
            )
        )
    )
    return (
        selected_conic_parameters,
        pair_orders(old, old),
        pair_orders(old, (opponent,)) if opponent_intruder else (),
        pair_orders(old, (reply,)) if reply_intruder else (),
        (
            pair_product_order(base, opponent, reply)
            if opponent_intruder and reply_intruder
            else 0
        ),
        triple_fixed_histogram(base, all_intruders),
        len(KERNEL.GEOMETRY.live_conic(base.game, state)),
        len(
            KERNEL.GEOMETRY.live_conic(
                base.game, state | (1 << opponent)
            )
        ),
        len(
            KERNEL.GEOMETRY.live_conic(
                base.game,
                state | (1 << opponent) | (1 << reply),
            )
        ),
    )


def profile_json(profile: tuple) -> dict:
    return {
        "opponent_kind": profile[0],
        "reply_kind": profile[1],
        "opponent_reply_chord_selected_load": profile[2],
        "opponent_reply_chord_parent_legal": profile[3],
        "opponent_reply_chord_child_legal": profile[4],
        "deactivated_line_deficiency_histogram": [
            [key, count] for key, count in profile[5]
        ],
        "thinned_line_profile_histogram": [
            [list(key), count] for key, count in profile[6]
        ],
        "killed_legal_points": profile[7],
        "boundary_target": profile[8],
        "normalized_retention": {
            "numerator": profile[9],
            "denominator": profile[10],
        },
        "residual_selected_size": profile[11],
        "parent_omega": profile[12],
        "child_omega": profile[13],
        "target_omega": profile[14],
        "maximum_strict_target_omega": profile[15],
        "selected_conic_parameters": list(profile[16]),
        "old_intruder_pair_orders": list(profile[17]),
        "old_opponent_pair_orders": list(profile[18]),
        "old_reply_pair_orders": list(profile[19]),
        "opponent_reply_product_order": profile[20],
        "intruder_triple_fixed_histogram": [
            [key, count] for key, count in profile[21]
        ],
        "live_conic_counts": list(profile[22:25]),
    }


def cells(base, mask: int) -> list[list[int]]:
    return [
        list(base.game.cell_tuple(point))
        for point in KERNEL.GEOMETRY.bits(mask)
    ]


def audit_order(q: int) -> tuple[dict, dict[tuple, list[dict]], list[dict]]:
    base = KERNEL.StrictKernel(q)
    roots = [
        base.game.base_mask(label)
        for label in SCALE.labels_for_order(q)
        if base.contains(base.game.base_mask(label))
    ]
    states = SCALE.certified_states(base, roots)
    rows = SCALE.PacketKernel(base, "all_strict")
    occurrences = {
        "clocked_secant": defaultdict(list),
        "normalized_orbital": defaultdict(list),
    }
    sizes = {
        "clocked_secant": defaultdict(set),
        "normalized_orbital": defaultdict(set),
    }
    fibres = []

    for state in sorted(states):
        old_omega = base.omega(state)
        for opponent in KERNEL.GEOMETRY.bits(base.game.legal_mask(state)):
            reply_rows = rows.reply_rows(state, opponent)
            maximum = max(row[2] for row in reply_rows)
            fibre_rows = []
            for reply, target, target_omega, _vector, _coordinates in reply_rows:
                in_kernel = base.contains(target)
                ratio = (
                    Fraction(target_omega, maximum)
                    if target_omega > 0
                    else Fraction(0)
                )
                full_profile = destruction_profile(
                    base, state, opponent, reply
                ) + (
                    target_omega == 0,
                    ratio.numerator,
                    ratio.denominator,
                    state.bit_count(),
                    old_omega,
                    base.omega(state | (1 << opponent)),
                    target_omega,
                    maximum,
                ) + orbital_profile(base, state, opponent, reply)
                row_profiles = {
                    "clocked_secant": full_profile[:16],
                    # Scale/depth-normalized bounded conic-involution data.
                    "normalized_orbital": full_profile[:11]
                    + full_profile[16:],
                }
                row = {
                    "profiles": row_profiles,
                    "full_profile": full_profile,
                    "state": state,
                    "opponent": opponent,
                    "reply": reply,
                    "target": target,
                    "target_omega": target_omega,
                    "in_kernel": in_kernel,
                    "ratio": ratio,
                }
                for variant, profile in row_profiles.items():
                    sizes[variant][profile].add(state.bit_count())
                    occurrences[variant][profile].append(row)
                fibre_rows.append(row)
            boundary_kernel = any(
                row["in_kernel"] and row["target_omega"] == 0
                for row in fibre_rows
            )
            if (
                not boundary_kernel
                and any(
                    row["in_kernel"] and row["target_omega"] > 0
                    for row in fibre_rows
                )
            ):
                fibres.append(
                    {
                        "state": state,
                        "opponent": opponent,
                        "old_omega": old_omega,
                        "maximum": maximum,
                        "rows": fibre_rows,
                    }
                )

    return (
        {
            "q": q,
            "kernel_roots": len(roots),
            "certified_positive_states": len(states),
            "forced_positive_target_fibres": len(fibres),
            "forced_positive_fibres_by_selected_size": {
                str(size): count
                for size, count in sorted(
                    Counter(
                        fibre["state"].bit_count() for fibre in fibres
                    ).items()
                )
            },
            "variants": {
                variant: {
                    "profiles": len(occurrences[variant]),
                    "kernel_mixed_profiles": sum(
                        {row["in_kernel"] for row in rows}
                        == {False, True}
                        for rows in occurrences[variant].values()
                    ),
                    "recurrent_profiles": sum(
                        len(sizes[variant][profile]) >= 2
                        for profile in occurrences[variant]
                    ),
                    "cross_depth_mixed_profiles": sum(
                        len(sizes[variant][profile]) >= 2
                        and {row["in_kernel"] for row in rows}
                        == {False, True}
                        for profile, rows in occurrences[variant].items()
                    ),
                }
                for variant in occurrences
            },
        },
        occurrences,
        fibres,
    )


def coverage(
    audits: list[tuple[int, dict, dict[tuple, list[dict]], list[dict]]],
    alpha: Fraction,
    variant: str,
) -> dict:
    global_occurrences: dict[tuple, list[tuple[int, dict]]] = defaultdict(list)
    profile_sizes: dict[tuple, set[int]] = defaultdict(set)
    for q, _summary, occurrences, _fibres in audits:
        for profile, rows in occurrences[variant].items():
            global_occurrences[profile].extend((q, row) for row in rows)
            profile_sizes[profile].update(
                row["state"].bit_count() for row in rows
            )

    def allowed(row: dict) -> bool:
        return row["in_kernel"] and (
            row["target_omega"] == 0 or row["ratio"] >= alpha
        )

    safe = {
        profile
        for profile, rows in global_occurrences.items()
        if all(allowed(row) for _q, row in rows)
    }
    recurrent_safe = {
        profile for profile in safe if len(profile_sizes[profile]) >= 2
    }
    result = {}
    recurrent_result = {}
    first_failure = None
    for q, _summary, _labels, fibres in audits:
        covered = 0
        for fibre in fibres:
            witnesses = [
                row
                for row in fibre["rows"]
                if row["profiles"][variant] in safe
                and row["in_kernel"]
                and row["target_omega"] > 0
                and row["ratio"] >= alpha
            ]
            if witnesses:
                covered += 1
            elif first_failure is None:
                good = [
                    row
                    for row in fibre["rows"]
                    if row["in_kernel"] and row["target_omega"] > 0
                ]
                collision_rows = []
                for row in good:
                    bad = next(
                        (
                            (bad_q, bad_row)
                            for bad_q, bad_row in global_occurrences[
                                row["profiles"][variant]
                            ]
                            if not allowed(bad_row)
                        ),
                        None,
                    )
                    collision_rows.append((row, bad))
                first_failure = {
                    "q": q,
                    "alpha": {
                        "numerator": alpha.numerator,
                        "denominator": alpha.denominator,
                    },
                    "selected_size_residual": fibre["state"].bit_count(),
                    "selected_cells": cells(KERNEL.StrictKernel(q), fibre["state"]),
                    "old_omega": fibre["old_omega"],
                    "opponent": list(
                        KERNEL.StrictKernel(q).game.cell_tuple(fibre["opponent"])
                    ),
                    "maximum_strict_target_omega": fibre["maximum"],
                    "good_reply_profiles": [
                        {
                            "reply": list(
                                KERNEL.StrictKernel(q).game.cell_tuple(row["reply"])
                            ),
                            "target_omega": row["target_omega"],
                            "ratio": {
                                "numerator": row["ratio"].numerator,
                                "denominator": row["ratio"].denominator,
                            },
                            "globally_safe_profile": (
                                row["profiles"][variant] in safe
                            ),
                            "profile": profile_json(row["full_profile"]),
                            "bad_collision": (
                                {
                                    "q": bad[0],
                                    "selected_size_residual": bad[1][
                                        "state"
                                    ].bit_count(),
                                    "selected_cells": cells(
                                        KERNEL.StrictKernel(bad[0]),
                                        bad[1]["state"],
                                    ),
                                    "opponent": list(
                                        KERNEL.StrictKernel(
                                            bad[0]
                                        ).game.cell_tuple(
                                            bad[1]["opponent"]
                                        )
                                    ),
                                    "reply": list(
                                        KERNEL.StrictKernel(
                                            bad[0]
                                        ).game.cell_tuple(bad[1]["reply"])
                                    ),
                                    "target_omega": bad[1]["target_omega"],
                                    "target_in_kernel": bad[1]["in_kernel"],
                                    "exact_cap_value": (
                                        "N"
                                        if KERNEL.StrictKernel(
                                            bad[0]
                                        ).game.value(bad[1]["target"])
                                        else "P"
                                    ),
                                    "ratio": {
                                        "numerator": bad[1]["ratio"].numerator,
                                        "denominator": bad[1]["ratio"].denominator,
                                    },
                                }
                                if bad is not None
                                else None
                            ),
                        }
                        for row, bad in collision_rows
                    ],
                }
        result[str(q)] = {"covered": covered, "of": len(fibres)}
        recurrent_result[str(q)] = {
            "covered": sum(
                any(
                    row["profiles"][variant] in recurrent_safe
                    and row["in_kernel"]
                    and row["target_omega"] > 0
                    and row["ratio"] >= alpha
                    for row in fibre["rows"]
                )
                for fibre in fibres
            ),
            "of": len(fibres),
        }
    return {
        "variant": variant,
        "alpha": {"numerator": alpha.numerator, "denominator": alpha.denominator},
        "globally_safe_profiles": len(safe),
        "coverage": result,
        "cross_depth_recurrent_safe_profiles": len(recurrent_safe),
        "cross_depth_recurrent_coverage": recurrent_result,
        "first_failure": first_failure,
    }


def run() -> dict:
    audits = []
    summaries = []
    for q in (13, 17):
        summary, occurrences, fibres = audit_order(q)
        audits.append((q, summary, occurrences, fibres))
        summaries.append(summary)
    return {
        "schema": "c80-marked-secant-profile-persistence-v1",
        "claim_scope": (
            "Exact profile-purity and positive-depth coverage audit on the "
            "listed q=13/q=17 strict-kernel certificate DAGs. It falsifies "
            "only exchange classes measurable from the recorded complete "
            "marked-secant destruction profile."
        ),
        "upstream": {
            "script": {
                "path": "rust/scripts/c80_scale_survivor_falsifiers.py",
                "sha256": sha256(
                    ROOT / "rust/scripts/c80_scale_survivor_falsifiers.py"
                ),
            },
            "certificate": {
                "path": "notes/2026-07-24-c80-scale-survivor-falsifiers.json",
                "sha256": sha256(
                    ROOT / "notes/2026-07-24-c80-scale-survivor-falsifiers.json"
                ),
            },
        },
        "orders": summaries,
        "coverage": [
            coverage(audits, alpha, variant)
            for variant in ("clocked_secant", "normalized_orbital")
            for alpha in (Fraction(0), Fraction(1, 4))
        ],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(run(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "profile persistence output mismatch"
        print("C80 marked-secant profile persistence: PASS")
    else:
        OUT.write_text(rendered)
        print(OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
