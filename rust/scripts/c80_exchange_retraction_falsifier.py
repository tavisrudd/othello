#!/usr/bin/env python3
"""C80: falsify the canonical cross-depth exchange retraction.

For a cap S and a legal opponent/reply exchange (o,p), put
T = S union {o,p}.  The canonical "forget the exchange" renormalization
compares the continuation complex of T with the continuation complex of S
restricted to the vertices still legal at T.  It can be an exact
renormalization only if those two complexes agree.

The first possible obstruction is a pair x,y which is a legal continuation
of S, with x and y individually legal at T, but not jointly legal at T.
Such a pair is a new rank-two conflict induced by one of the two marked
pencils centred at o or p.  It proves that vertex restriction is not a
simplicial map in the forgetful direction; differing edge counts also rule
out an arbitrary relabelled simplicial isomorphism.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-25-c80-exchange-retraction-falsifier.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


PROFILE = load_module(
    ROOT / "rust/scripts/c80_marked_secant_profile_persistence.py",
    "c80_exchange_profile",
)
KERNEL = PROFILE.KERNEL


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def independent_example_check() -> dict:
    """Direct determinant replay, independent of the imported game engine."""
    q = 17
    fixed = [(1, 0, 0), (0, 1, 0)]
    parent = [(3, 6), (4, 13), (5, 7), (8, 15)]
    opponent = (0, 0)
    reply = (1, 10)
    first = (2, 2)
    second = (13, 16)

    def point(cell):
        return (cell[0], cell[1], 1)

    def determinant(a, b, c):
        return (
            a[0] * (b[1] * c[2] - b[2] * c[1])
            - a[1] * (b[0] * c[2] - b[2] * c[0])
            + a[2] * (b[0] * c[1] - b[1] * c[0])
        ) % q

    def is_cap(cells):
        points = fixed + [point(cell) for cell in cells]
        return all(
            determinant(points[i], points[j], points[k]) != 0
            for i in range(len(points))
            for j in range(i + 1, len(points))
            for k in range(j + 1, len(points))
        )

    target = parent + [opponent, reply]
    return {
        "coordinate_model": (
            "fixed points (1,0,0),(0,1,0); affine cell (r,c)=(r,c,1)"
        ),
        "parent_plus_pair_is_cap": is_cap(parent + [first, second]),
        "target_is_cap": is_cap(target),
        "target_plus_first_is_cap": is_cap(target + [first]),
        "target_plus_second_is_cap": is_cap(target + [second]),
        "target_plus_pair_is_cap": is_cap(target + [first, second]),
        "reply_first_second_determinant_mod_17": determinant(
            point(reply), point(first), point(second)
        ),
    }


def bits(mask: int):
    while mask:
        low = mask & -mask
        yield low.bit_length() - 1
        mask ^= low


def cells(base, mask: int) -> list[list[int]]:
    return [
        list(base.game.cell_tuple(point))
        for point in bits(mask)
    ]


def added_pair_conflicts(base, state: int, opponent: int, reply: int):
    """Pairs gained by T relative to S on the common surviving vertices."""
    target = state | (1 << opponent) | (1 << reply)
    live = list(bits(base.game.legal_mask(target)))
    rows = []
    for index, first in enumerate(live):
        parent_after_first = base.game.legal_mask(state | (1 << first))
        target_after_first = base.game.legal_mask(target | (1 << first))
        for second in live[index + 1 :]:
            if not (parent_after_first & (1 << second)):
                continue
            if target_after_first & (1 << second):
                continue
            centres = [
                centre
                for centre in (opponent, reply)
                if base.game.collinear(
                    base.game.points[centre + 2],
                    base.game.points[first + 2],
                    base.game.points[second + 2],
                )
            ]
            assert centres, "new pair conflict has no marked centre"
            rows.append((first, second, tuple(centres)))
    return rows


def marked_clique_nontwin(base, state: int, opponent: int, reply: int, conflicts):
    """First rank-two witness against collapsing a marked-pencil clique."""
    target = state | (1 << opponent) | (1 << reply)
    live = list(bits(base.game.legal_mask(target)))
    after = {
        point: base.game.legal_mask(target | (1 << point))
        for point in live
    }
    for first, second, centres in conflicts:
        for centre in centres:
            for outside in live:
                if outside in (first, second):
                    continue
                if base.game.collinear(
                    base.game.points[centre + 2],
                    base.game.points[first + 2],
                    base.game.points[outside + 2],
                ):
                    continue
                first_compatible = bool(after[first] & (1 << outside))
                second_compatible = bool(after[second] & (1 << outside))
                if first_compatible != second_compatible:
                    return first, second, centre, outside, (
                        first_compatible,
                        second_compatible,
                    )
    return None


def audit_order(q: int) -> dict:
    _summary, _occurrences, fibres = PROFILE.audit_order(q)
    base = KERNEL.StrictKernel(q)
    first = None
    audited_fibres = []

    for fibre in fibres:
        rows = [
            row
            for row in fibre["rows"]
            if row["in_kernel"]
            and row["target_omega"] > 0
        ]
        if not rows:
            continue
        audited_rows = []
        for row in rows:
            conflicts = added_pair_conflicts(
                base, row["state"], row["opponent"], row["reply"]
            )
            nontwin = marked_clique_nontwin(
                base,
                row["state"],
                row["opponent"],
                row["reply"],
                conflicts,
            )
            audited_rows.append((row, len(conflicts), nontwin))
            if conflicts and first is None:
                x, y, centres = conflicts[0]
                target = (
                    row["state"]
                    | (1 << row["opponent"])
                    | (1 << row["reply"])
                )
                first = {
                    "selected_size_residual": row["state"].bit_count(),
                    "parent": cells(base, row["state"]),
                    "opponent": list(
                        base.game.cell_tuple(row["opponent"])
                    ),
                    "reply": list(base.game.cell_tuple(row["reply"])),
                    "target_omega": row["target_omega"],
                    "retention": {
                        "numerator": row["ratio"].numerator,
                        "denominator": row["ratio"].denominator,
                    },
                    "surviving_moves": [
                        list(base.game.cell_tuple(x)),
                        list(base.game.cell_tuple(y)),
                    ],
                    "marked_centres_on_conflict_line": [
                        list(base.game.cell_tuple(centre))
                        for centre in centres
                    ],
                    "pair_legal_over_parent": bool(
                        base.game.legal_mask(
                            row["state"] | (1 << x)
                        )
                        & (1 << y)
                    ),
                    "both_individually_legal_over_target": all(
                        base.game.legal_mask(target) & (1 << point)
                        for point in (x, y)
                    ),
                    "pair_legal_over_target": bool(
                        base.game.legal_mask(target | (1 << x))
                        & (1 << y)
                    ),
                    "added_pair_conflicts_on_common_vertices": len(conflicts),
                }
        audited_fibres.append(audited_rows)

    def threshold_summary(alpha: Fraction) -> dict:
        eligible = [
            (row, conflicts, nontwin)
            for rows in audited_fibres
            for row, conflicts, nontwin in rows
            if row["ratio"] >= alpha
        ]
        eligible_fibres = [
            [
                (row, conflicts, nontwin)
                for row, conflicts, nontwin in rows
                if row["ratio"] >= alpha
            ]
            for rows in audited_fibres
        ]
        eligible_fibres = [rows for rows in eligible_fibres if rows]
        return {
            "alpha": {
                "numerator": alpha.numerator,
                "denominator": alpha.denominator,
            },
            "forced_positive_fibres_with_eligible_reply": len(
                eligible_fibres
            ),
            "eligible_replies": len(eligible),
            "eligible_replies_with_added_pair_conflict": sum(
                conflicts > 0 for _row, conflicts, _nontwin in eligible
            ),
            "fibres_with_an_exact_forgetful_contraction": sum(
                any(
                    conflicts == 0
                    for _row, conflicts, _nontwin in rows
                )
                for rows in eligible_fibres
            ),
            "fibres_whose_every_eligible_reply_is_obstructed": sum(
                all(
                    conflicts > 0
                    for _row, conflicts, _nontwin in rows
                )
                for rows in eligible_fibres
            ),
            "conflicted_replies_with_nontwin_marked_clique": sum(
                conflicts > 0 and nontwin is not None
                for _row, conflicts, nontwin in eligible
            ),
            "fibres_surviving_marked_clique_twin_quotient": sum(
                any(nontwin is None for _row, _conflicts, nontwin in rows)
                for rows in eligible_fibres
            ),
            "eligible_by_selected_size": {
                str(size): count
                for size, count in sorted(
                    Counter(
                        row["state"].bit_count()
                        for row, _conflicts, _nontwin in eligible
                    ).items()
                )
            },
            "exact_contractions_by_selected_size": {
                str(size): count
                for size, count in sorted(
                    Counter(
                        row["state"].bit_count()
                        for row, conflicts, _nontwin in eligible
                        if conflicts == 0
                    ).items()
                )
            },
            "exact_contractions_by_move_sort": {
                key: count
                for key, count in sorted(
                    Counter(
                        f"{PROFILE.kind(base, row['opponent'])}/"
                        f"{PROFILE.kind(base, row['reply'])}"
                        for row, conflicts, _nontwin in eligible
                        if conflicts == 0
                    ).items()
                )
            },
            "added_pair_conflict_histogram": {
                str(count): multiplicity
                for count, multiplicity in sorted(
                    Counter(
                        conflicts
                        for _row, conflicts, _nontwin in eligible
                    ).items()
                )
            },
        }

    return {
        "q": q,
        "domain": (
            "all positive-overload lower-K_Omega replies in forced-positive "
            "fibres of the frozen strict-kernel DAG"
        ),
        "thresholds": [
            threshold_summary(alpha)
            for alpha in (Fraction(0), Fraction(1, 4))
        ],
        "first_obstruction": first,
    }


def run() -> dict:
    orders = [audit_order(q) for q in (13, 17)]
    return {
        "schema": "c80-exchange-retraction-falsifier-v2",
        "claim_scope": (
            "Falsifies the exact forgetful exchange retraction on the stated "
            "frozen q=17 positive-overload domain. It does not rule out a "
            "renormalization retaining the two new marked-pencil conflict "
            "relations or a non-simplicial value argument."
        ),
        "criterion": (
            "A new pair face over S on vertices still legal at T=S+o+p "
            "which is not a pair face over T proves that restriction is not "
            "a simplicial map; the pair-face counts differ, so no relabelled "
            "simplicial isomorphism exists between these two complexes."
        ),
        "upstream": {
            "script": {
                "path": (
                    "rust/scripts/"
                    "c80_marked_secant_profile_persistence.py"
                ),
                "sha256": sha256(
                    ROOT
                    / "rust/scripts/"
                    "c80_marked_secant_profile_persistence.py"
                ),
            },
            "certificate": {
                "path": (
                    "notes/"
                    "2026-07-25-c80-marked-secant-profile-persistence.json"
                ),
                "sha256": sha256(
                    ROOT
                    / "notes/"
                    "2026-07-25-c80-marked-secant-profile-persistence.json"
                ),
            },
        },
        "independent_determinant_replay": independent_example_check(),
        "orders": orders,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(run(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "exchange retraction output mismatch"
        print("C80 exchange retraction falsifier: PASS")
    else:
        OUT.write_text(rendered)
        print(OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
