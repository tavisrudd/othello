#!/usr/bin/env python3
"""C80: exact marked-secant accounting at retention bottlenecks.

The checker has two purposes.

1. Independently replay the one-move overload-drop identity.  After a legal
   marked child C and reply p, overload is lost exactly on active lines
   deactivated by p and on the other active lines through legal points killed
   by the new secants pS.
2. Compare the strongest retention ratio forced on *all* positive strict
   replies with the ratio available from lower-K_omega replies.  This
   distinguishes a purely load-algebraic blanket bound from the existential
   game-semantic exchange required by F_alpha.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-25-c80-marked-secant-retention.json"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


SCALE = load_module(
    ROOT / "rust/scripts/c80_scale_survivor_falsifiers.py",
    "c80_marked_secant_scale",
)
KERNEL = SCALE.KERNEL


def rational(value: Fraction) -> dict[str, int]:
    return {"numerator": value.numerator, "denominator": value.denominator}


def cells(base, mask: int) -> list[list[int]]:
    return [
        list(base.game.cell_tuple(cell))
        for cell in KERNEL.GEOMETRY.bits(mask)
    ]


def marked_drop(base, child: int, reply: int) -> tuple[int, dict[str, int]]:
    """Compute omega(child)-omega(child+reply) from marked secants."""
    child_legal = base.game.legal_mask(child)
    target = child | (1 << reply)
    target_legal = base.game.legal_mask(target)
    killed = child_legal & ~target_legal & ~(1 << reply)
    deactivated = 0
    thinned = 0
    deactivated_lines = 0
    thinned_lines = 0
    killed_line_incidences = 0
    for line_mask, fixed_load in base.lines:
        if fixed_load + (child & line_mask).bit_count() != 0:
            continue
        load = (child_legal & line_mask).bit_count()
        excess = max(0, load - 2)
        if line_mask & (1 << reply):
            deactivated += excess
            deactivated_lines += excess > 0
            continue
        killed_on_line = (killed & line_mask).bit_count()
        killed_line_incidences += killed_on_line
        loss = min(killed_on_line, excess)
        thinned += loss
        thinned_lines += loss > 0
    return deactivated + thinned, {
        "deactivated_overload": deactivated,
        "thinned_overload": thinned,
        "deactivated_overloaded_lines": deactivated_lines,
        "thinned_overloaded_lines": thinned_lines,
        "killed_legal_points": killed.bit_count(),
        "killed_active_line_incidences": killed_line_incidences,
    }


def roots_for_order(base, q: int) -> list[tuple[tuple[int, ...], int]]:
    labels = SCALE.labels_for_order(q)
    return [
        (label, base.game.base_mask(label))
        for label in labels
        if base.contains(base.game.base_mask(label))
    ]


def audit_order(q: int) -> dict:
    base = KERNEL.StrictKernel(q)
    roots = roots_for_order(base, q)
    states = SCALE.certified_states(base, [mask for _label, mask in roots])
    packet = SCALE.PacketKernel(base, "all_strict")
    identity_checks = 0
    fibres = 0
    blanket_min: tuple[Fraction, tuple] | None = None
    semantic_min: tuple[Fraction, tuple] | None = None

    for state in sorted(states):
        old_omega = base.omega(state)
        for opponent in KERNEL.GEOMETRY.bits(base.game.legal_mask(state)):
            child = state | (1 << opponent)
            child_omega = base.omega(child)
            rows = packet.reply_rows(state, opponent)
            for reply, target, target_omega, _vector, _coordinates in rows:
                drop, _parts = marked_drop(base, child, reply)
                assert drop == child_omega - target_omega
                assert target == child | (1 << reply)
                identity_checks += 1
            positive = [row for row in rows if row[2] > 0]
            positive_kernel = [
                row for row in positive if base.contains(row[1])
            ]
            if not positive_kernel:
                continue
            fibres += 1
            maximum = max(row[2] for row in rows)
            blanket = Fraction(min(row[2] for row in positive), maximum)
            semantic = Fraction(
                max(row[2] for row in positive_kernel), maximum
            )
            context = (state, opponent, child, rows)
            if blanket_min is None or blanket < blanket_min[0]:
                blanket_min = (blanket, context)
            if semantic_min is None or semantic < semantic_min[0]:
                semantic_min = (semantic, context)

    def example(record: tuple[Fraction, tuple], *, semantic: bool) -> dict:
        ratio, (state, opponent, child, rows) = record
        maximum = max(row[2] for row in rows)
        candidates = [
            row
            for row in rows
            if row[2] > 0
            and (
                base.contains(row[1])
                if semantic
                else row[2] == min(r[2] for r in rows if r[2] > 0)
            )
        ]
        chosen = max(candidates, key=lambda row: (row[2], -row[0]))
        drop, parts = marked_drop(base, child, chosen[0])
        return {
            "ratio": rational(ratio),
            "selected_size_residual": state.bit_count(),
            "selected_cells": cells(base, state),
            "old_omega": base.omega(state),
            "opponent": list(base.game.cell_tuple(opponent)),
            "child_omega": base.omega(child),
            "reply": list(base.game.cell_tuple(chosen[0])),
            "target_omega": chosen[2],
            "maximum_strict_target_omega": maximum,
            "target_in_kernel": base.contains(chosen[1]),
            "marked_drop": drop,
            "marked_drop_parts": parts,
        }

    strengths = SCALE.RetentionStrength(base)
    root_strengths = []
    for label, root in roots:
        value = strengths.value(root)
        root_strengths.append({"t4": list(label), **rational(value)})

    return {
        "q": q,
        "kernel_roots": len(roots),
        "certified_positive_states": len(states),
        "marked_drop_identity_checks": identity_checks,
        "positive_kernel_fibres": fibres,
        "blanket_positive_reply_minimum": (
            example(blanket_min, semantic=False)
            if blanket_min is not None
            else None
        ),
        "best_positive_kernel_reply_minimum": (
            example(semantic_min, semantic=True)
            if semantic_min is not None
            else None
        ),
        "root_retention_strengths": root_strengths,
    }


def run() -> dict:
    upstream_script = (
        ROOT / "rust/scripts/c80_scale_survivor_falsifiers.py"
    )
    upstream_certificate = (
        ROOT / "notes/2026-07-24-c80-scale-survivor-falsifiers.json"
    )
    return {
        "schema": "c80-marked-secant-retention-v1",
        "claim_scope": (
            "Exact marked one-reply overload-drop identity and finite "
            "retention audit on the listed q=11/13/17 strict-kernel DAGs. "
            "This does not prove or disprove a q-uniform positive bound."
        ),
        "upstream": {
            "script": {
                "path": "rust/scripts/c80_scale_survivor_falsifiers.py",
                "sha256": sha256(upstream_script),
            },
            "certificate": {
                "path": (
                    "notes/2026-07-24-c80-scale-survivor-falsifiers.json"
                ),
                "sha256": sha256(upstream_certificate),
            },
        },
        "orders": [audit_order(q) for q in (11, 13, 17)],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(run(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "marked-secant output mismatch"
        print("C80 marked-secant retention: PASS")
    else:
        OUT.write_text(rendered)
        print(OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
