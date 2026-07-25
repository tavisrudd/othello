#!/usr/bin/env python3
"""C80: certify the exact residual-hypergraph exchange morphism.

The quotient of a cap state keeps only:

* the live legal vertices;
* live supports of load-one lines (pair-conflict blocks);
* live supports of load-zero lines of size at least three (active triples).

Selecting a vertex deletes it and its pair-conflict neighbours, restricts all
old blocks, and degrades each active block through the selected vertex into a
pair-conflict block.  This script checks that depth-free transform against a
fresh direct reconstruction after both moves of every positive-overload
lower-K_Omega reply in the frozen q=17 forced-positive fibres.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from collections import Counter
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-25-c80-residual-exchange-morphism.json"


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
    "c80_morphism_profile",
)
KERNEL = PROFILE.KERNEL


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def bits(mask: int):
    while mask:
        low = mask & -mask
        yield low.bit_length() - 1
        mask ^= low


@dataclass(frozen=True)
class Residual:
    live: int
    pair_blocks: tuple[int, ...]
    active_blocks: tuple[int, ...]

    @property
    def omega(self) -> int:
        return sum(block.bit_count() - 2 for block in self.active_blocks)

    @property
    def edge_count(self) -> int:
        return sum(
            block.bit_count() * (block.bit_count() - 1) // 2
            for block in self.pair_blocks
        )

    @property
    def triple_count(self) -> int:
        return sum(
            block.bit_count()
            * (block.bit_count() - 1)
            * (block.bit_count() - 2)
            // 6
            for block in self.active_blocks
        )


def canonical_blocks(blocks) -> tuple[int, ...]:
    return tuple(sorted(set(blocks)))


def direct_residual(base, state: int) -> Residual:
    live = base.game.legal_mask(state)
    pairs = []
    active = []
    for line_mask, fixed_load in base.lines:
        load = fixed_load + (state & line_mask).bit_count()
        block = live & line_mask
        if load == 1 and block.bit_count() >= 2:
            pairs.append(block)
        elif load == 0 and block.bit_count() >= 3:
            active.append(block)
    return Residual(
        live,
        canonical_blocks(pairs),
        canonical_blocks(active),
    )


def transform(residual: Residual, move: int) -> Residual:
    move_bit = 1 << move
    assert residual.live & move_bit

    killed = move_bit
    for block in residual.pair_blocks:
        if block & move_bit:
            killed |= block
    live = residual.live & ~killed

    pairs = [
        block & live
        for block in residual.pair_blocks
        if not (block & move_bit)
        and (block & live).bit_count() >= 2
    ]
    pairs.extend(
        block & live
        for block in residual.active_blocks
        if block & move_bit
        and (block & live).bit_count() >= 2
    )
    active = [
        block & live
        for block in residual.active_blocks
        if not (block & move_bit)
        and (block & live).bit_count() >= 3
    ]
    return Residual(
        live,
        canonical_blocks(pairs),
        canonical_blocks(active),
    )


def digest(residual: Residual) -> str:
    payload = (
        residual.live,
        residual.pair_blocks,
        residual.active_blocks,
    )
    return hashlib.sha256(repr(payload).encode()).hexdigest()


def audit_order(q: int) -> dict:
    _summary, _occurrences, fibres = PROFILE.audit_order(q)
    base = KERNEL.StrictKernel(q)
    rows = []
    for fibre in fibres:
        rows.extend(
            row
            for row in fibre["rows"]
            if row["in_kernel"] and row["target_omega"] > 0
        )

    parent_cache = {}
    child_cache = {}
    parent_steps = 0
    child_steps = 0
    target_steps = 0
    mismatches = []
    signatures = Counter()
    for row in rows:
        state = row["state"]
        opponent = row["opponent"]
        reply = row["reply"]
        child = state | (1 << opponent)
        target = child | (1 << reply)

        if state not in parent_cache:
            parent_cache[state] = direct_residual(base, state)
        parent_q = parent_cache[state]
        child_key = (state, opponent)
        if child_key not in child_cache:
            transformed_child = transform(parent_q, opponent)
            direct_child = direct_residual(base, child)
            parent_steps += 1
            if transformed_child != direct_child:
                mismatches.append(("opponent", state, opponent, 0))
            child_cache[child_key] = transformed_child
        child_q = child_cache[child_key]

        transformed_target = transform(child_q, reply)
        direct_target = direct_residual(base, target)
        child_steps += 1
        target_steps += 1
        if transformed_target != direct_target:
            mismatches.append(("reply", state, opponent, reply))
        if transformed_target.omega != row["target_omega"]:
            mismatches.append(("omega", state, opponent, reply))
        signatures[
            (
                state.bit_count(),
                transformed_target.live.bit_count(),
                len(transformed_target.pair_blocks),
                len(transformed_target.active_blocks),
                transformed_target.omega,
            )
        ] += 1

    all_targets = [
        transform(
            transform(
                parent_cache[row["state"]],
                row["opponent"],
            ),
            row["reply"],
        )
        for row in rows
    ]
    return {
        "q": q,
        "domain": (
            "all positive-overload lower-K_Omega replies in forced-positive "
            "fibres of the frozen strict-kernel DAG"
        ),
        "parents": len(parent_cache),
        "marked_children": len(child_cache),
        "reply_rows": len(rows),
        "opponent_transform_checks": parent_steps,
        "reply_transform_checks": child_steps,
        "direct_target_reconstructions": target_steps,
        "mismatches": len(mismatches),
        "first_mismatch": list(mismatches[0]) if mismatches else None,
        "distinct_target_residuals": len(
            {digest(residual) for residual in all_targets}
        ),
        "target_selected_size_histogram": {
            str(size): count
            for size, count in sorted(
                Counter(row["state"].bit_count() + 2 for row in rows).items()
            )
        },
        "target_live_vertex_range": [
            min(residual.live.bit_count() for residual in all_targets),
            max(residual.live.bit_count() for residual in all_targets),
        ],
        "target_pair_block_range": [
            min(len(residual.pair_blocks) for residual in all_targets),
            max(len(residual.pair_blocks) for residual in all_targets),
        ],
        "target_active_block_range": [
            min(len(residual.active_blocks) for residual in all_targets),
            max(len(residual.active_blocks) for residual in all_targets),
        ],
        "target_omega_range": [
            min(residual.omega for residual in all_targets),
            max(residual.omega for residual in all_targets),
        ],
        "signature_rows": len(signatures),
    }


def run() -> dict:
    return {
        "schema": "c80-residual-exchange-morphism-v1",
        "claim_scope": (
            "Exact bounded-arity residual transform checked on the stated "
            "frozen q=17 positive-overload reply domain. The mathematical "
            "update law is general for line-capacity-two residuals. This is "
            "not a bounded-cardinality or bounded-dimensional quotient and "
            "does not prove uniform K_Omega membership."
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
        "order": audit_order(17),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(run(), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert OUT.read_text() == rendered, "residual morphism output mismatch"
        print("C80 residual exchange morphism: PASS")
    else:
        OUT.write_text(rendered)
        print(OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
