#!/usr/bin/env python3
"""Exact private-boundary and rooted-game signature census on frozen residuals.

For each residual cap game, load-one lines give forbidden pairs and load-zero
lines with at least three legal points give complete rank-three gadgets.
A vertex of one gadget is private when it belongs to no forbidden pair and no
other active gadget.  The private-boundary theorem permits retaining at most
two such vertices in each gadget.

The script performs that truncation simultaneously, verifies exact rooted-game
bisimulation against the untruncated residual, and interns the recursively
deduplicated option sets.  The resulting integer is an exact label-free rooted
game signature, not a hash.  Its child-set cardinality is the exact follower
signature quotient relevant to the mex bound.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path

import c528_overload_profile as overload


ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "notes/2026-07-23-c549-private-boundary-signatures.json"
SCRIPT = Path(__file__).resolve()
ORDERS = tuple((q, rows) for q, rows in overload.ORDERS if q in (17, 19))


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def mex(values: set[int]) -> int:
    value = 0
    while value in values:
        value += 1
    return value


class SignatureInterner:
    """Exact canonical ids for recursively deduplicated option sets."""

    def __init__(self) -> None:
        self.ids: dict[tuple[int, ...], int] = {(): 0}
        self.keys: list[tuple[int, ...]] = [()]
        self.grundy: list[int] = [0]

    def intern(self, children: set[int]) -> int:
        key = tuple(sorted(children))
        known = self.ids.get(key)
        if known is not None:
            return known
        signature = len(self.grundy)
        self.ids[key] = signature
        self.keys.append(key)
        self.grundy.append(mex({self.grundy[child] for child in children}))
        return signature

    def follower_count(self, signature: int) -> int:
        return len(self.keys[signature])


def static_residual(game, lines, root: int) -> tuple[list[int], list[int], list[int]]:
    """Return legal cells, pair adjacency, and complete-triple gadget masks."""
    legal = game.legal_mask(root)
    cells = list(overload.GEOMETRY.bits(legal))
    local = {cell: i for i, cell in enumerate(cells)}
    pair_adj = [0] * len(cells)
    gadgets: list[int] = []

    for line_mask, fixed_load in lines:
        on_line = legal & line_mask
        if not on_line:
            continue
        local_mask = 0
        for cell in overload.GEOMETRY.bits(on_line):
            local_mask |= 1 << local[cell]
        load = fixed_load + (root & line_mask).bit_count()
        if load == 1:
            for i in overload.GEOMETRY.bits(local_mask):
                pair_adj[i] |= local_mask ^ (1 << i)
        elif load == 0 and local_mask.bit_count() >= 3:
            gadgets.append(local_mask)

    return cells, pair_adj, sorted(gadgets)


def truncate_private(
    pair_adj: list[int], gadgets: list[int]
) -> tuple[list[int], list[int], dict]:
    """Delete all but two vertices private to each complete-triple gadget."""
    n = len(pair_adj)
    incident: list[list[int]] = [[] for _ in range(n)]
    for gadget_index, gadget in enumerate(gadgets):
        for vertex in overload.GEOMETRY.bits(gadget):
            incident[vertex].append(gadget_index)

    removed = 0
    private_classes = Counter()
    keep_mask = (1 << n) - 1
    for gadget_index, gadget in enumerate(gadgets):
        private = [
            vertex
            for vertex in overload.GEOMETRY.bits(gadget)
            if pair_adj[vertex] == 0 and incident[vertex] == [gadget_index]
        ]
        private_classes[min(2, len(private))] += 1
        for vertex in private[2:]:
            bit = 1 << vertex
            if keep_mask & bit:
                keep_mask ^= bit
                removed += 1

    kept_old = list(overload.GEOMETRY.bits(keep_mask))
    new_index = {old: new for new, old in enumerate(kept_old)}
    new_adj = [0] * len(kept_old)
    for old, new in new_index.items():
        for neighbor in overload.GEOMETRY.bits(pair_adj[old] & keep_mask):
            new_adj[new] |= 1 << new_index[neighbor]

    new_gadgets = []
    for gadget in gadgets:
        new_mask = 0
        for old in overload.GEOMETRY.bits(gadget & keep_mask):
            new_mask |= 1 << new_index[old]
        if new_mask.bit_count() >= 3:
            new_gadgets.append(new_mask)

    return new_adj, sorted(new_gadgets), {
        "removed_vertices": removed,
        "private_multiplicity_classes": dict(sorted(private_classes.items())),
        "reduced_vertices": len(kept_old),
    }


def rooted_signature(
    pair_adj: list[int], gadgets: list[int], interner: SignatureInterner
) -> tuple[int, int]:
    """Return the exact rooted signature and number of visited chosen sets."""
    n = len(pair_adj)
    incident: list[list[int]] = [[] for _ in range(n)]
    for gadget_index, gadget in enumerate(gadgets):
        for vertex in overload.GEOMETRY.bits(gadget):
            incident[vertex].append(gadget_index)
    memo: dict[int, int] = {}

    def visit(chosen: int, available: int) -> int:
        known = memo.get(chosen)
        if known is not None:
            return known
        children: set[int] = set()
        moves = available
        while moves:
            bit = moves & -moves
            vertex = bit.bit_length() - 1
            after = available & ~(bit | pair_adj[vertex])
            for gadget_index in incident[vertex]:
                gadget = gadgets[gadget_index]
                if (chosen & gadget).bit_count() == 1:
                    after &= ~gadget
            children.add(visit(chosen | bit, after))
            moves ^= bit
        signature = interner.intern(children)
        memo[chosen] = signature
        return signature

    return visit(0, (1 << n) - 1), len(memo)


def independent_signature(pair_adj: list[int], gadgets: list[int]) -> frozenset:
    """Independent nested-frozenset implementation for a bounded audit slice."""
    n = len(pair_adj)
    incident: list[list[int]] = [[] for _ in range(n)]
    for gadget_index, gadget in enumerate(gadgets):
        for vertex in overload.GEOMETRY.bits(gadget):
            incident[vertex].append(gadget_index)
    memo: dict[int, frozenset] = {}

    def visit(chosen: int, available: int) -> frozenset:
        known = memo.get(chosen)
        if known is not None:
            return known
        children = set()
        moves = available
        while moves:
            bit = moves & -moves
            vertex = bit.bit_length() - 1
            after = available & ~(bit | pair_adj[vertex])
            for gadget_index in incident[vertex]:
                gadget = gadgets[gadget_index]
                if (chosen & gadget).bit_count() == 1:
                    after &= ~gadget
            children.add(visit(chosen | bit, after))
            moves ^= bit
        signature = frozenset(children)
        memo[chosen] = signature
        return signature

    return visit(0, (1 << n) - 1)


def add_private_classes(total: Counter, row: dict) -> None:
    for multiplicity, count in row["private_multiplicity_classes"].items():
        total[int(multiplicity)] += count


def run_q(q: int, rows: Path, limit: int | None) -> dict:
    game = overload.C20.PrimeGridGame(q)
    lines = overload.CENSUS.projective_lines(game)
    states, _ = overload.C31.load_p_reply_states(rows, q)
    residual, _ = overload.find_residual_and_witnesses(game, lines, states, False)
    residual = sorted(residual)
    if limit is not None:
        residual = residual[:limit]

    interner = SignatureInterner()
    root_signatures = Counter()
    follower_counts = Counter()
    raw_vertices = Counter()
    reduced_vertices = Counter()
    removed_vertices = Counter()
    private_classes = Counter()
    distinct_child_signatures: set[int] = set()
    bisimulation_failures = 0
    independent_failures = 0
    independent_limit = len(residual) if q == 17 else 0
    state_digest = hashlib.sha256()
    visited_total = 0

    for root_index, root in enumerate(residual):
        cells, pair_adj, gadgets = static_residual(game, lines, root)
        reduced_adj, reduced_gadgets, truncation = truncate_private(pair_adj, gadgets)
        full_signature, full_visited = rooted_signature(pair_adj, gadgets, interner)
        if truncation["removed_vertices"]:
            reduced_signature, reduced_visited = rooted_signature(
                reduced_adj, reduced_gadgets, interner
            )
        else:
            reduced_signature, reduced_visited = full_signature, 0
        visited_total += full_visited + reduced_visited
        if full_signature != reduced_signature:
            bisimulation_failures += 1

        if root_index < independent_limit:
            direct_full = independent_signature(pair_adj, gadgets)
            direct_reduced = (
                independent_signature(reduced_adj, reduced_gadgets)
                if truncation["removed_vertices"]
                else direct_full
            )
            if direct_full != direct_reduced:
                independent_failures += 1

        key = interner.keys[full_signature]
        root_signatures[full_signature] += 1
        follower_counts[len(key)] += 1
        distinct_child_signatures.update(key)
        raw_vertices[len(cells)] += 1
        reduced_vertices[truncation["reduced_vertices"]] += 1
        removed_vertices[truncation["removed_vertices"]] += 1
        add_private_classes(private_classes, truncation)

        canonical_row = {
            "root": root,
            "root_signature": full_signature,
            "grundy": interner.grundy[full_signature],
            "followers": len(key),
            "raw_vertices": len(cells),
            "reduced_vertices": truncation["reduced_vertices"],
            "removed_vertices": truncation["removed_vertices"],
            "private_multiplicity_classes": truncation[
                "private_multiplicity_classes"
            ],
        }
        state_digest.update(
            (json.dumps(canonical_row, sort_keys=True, separators=(",", ":")) + "\n").encode()
        )

    return {
        "q": q,
        "states": len(residual),
        "limited": limit is not None,
        "state_rows_sha256": state_digest.hexdigest(),
        "private_truncation_bisimulation": {
            "states_checked": len(residual),
            "failures": bisimulation_failures,
        },
        "independent_nested_signature_check": {
            "states_checked": independent_limit,
            "failures": independent_failures,
        },
        "raw_vertex_distribution": dict(sorted(raw_vertices.items())),
        "reduced_vertex_distribution": dict(sorted(reduced_vertices.items())),
        "removed_private_vertex_distribution": dict(sorted(removed_vertices.items())),
        "private_multiplicity_class_totals": dict(sorted(private_classes.items())),
        "follower_signature_count_distribution": dict(sorted(follower_counts.items())),
        "max_follower_signatures": max(follower_counts, default=0),
        "distinct_root_game_signatures": len(root_signatures),
        "distinct_child_game_signatures": len(distinct_child_signatures),
        "root_signature_multiplicity_distribution": dict(
            sorted(Counter(root_signatures.values()).items())
        ),
        "interned_game_signatures": len(interner.ids),
        "visited_chosen_sets_full_plus_reduced": visited_total,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--q", type=int, choices=(17, 19), action="append")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.check and args.limit is not None:
        parser.error("--check cannot be combined with --limit")
    if args.limit is not None and args.output == OUT:
        parser.error("--limit requires an explicit exploratory --output path")

    selected = set(args.q or (17, 19))
    orders = [(q, rows) for q, rows in ORDERS if q in selected]
    source_paths = {
        SCRIPT,
        ROOT / "rust/scripts/c528_overload_profile.py",
        ROOT / "rust/scripts/c80_response_fibre_census.py",
        ROOT / "notes/2026-07-08-zone-repair-geometry.py",
        ROOT / "notes/2026-07-08-zone-steering-census.py",
        ROOT / "notes/2026-07-08-intrusion-census.py",
        *(rows for _q, rows in orders),
    }
    sources = {
        str(path.relative_to(ROOT)): {
            "sha256": sha256(path),
            "bytes": path.stat().st_size,
        }
        for path in source_paths
    }
    payload = {
        "schema_version": 1,
        "task": "C549",
        "claim_scope": (
            "Exact private-vertex truncation and rooted-game follower-signature "
            "quotient on every capOVER-core residual child in the frozen q17/q19 "
            "three-intruder domains. No q23 state is generated or tested."
        ),
        "signature": (
            "The exact recursively interned set of distinct child signatures. "
            "Labels and duplicate options are discarded, but the complete rooted "
            "normal-play game tree is retained up to two-sided bisimulation."
        ),
        "private_vertex": (
            "A legal vertex on one active load-zero gadget, incident to no load-one "
            "pair constraint and no other active load-zero gadget. At most two such "
            "vertices are retained per gadget."
        ),
        "sources": dict(sorted(sources.items())),
        "orders": [run_q(q, rows, args.limit) for q, rows in orders],
    }
    rendered = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "private-boundary census: MISMATCH"
        print("private-boundary census: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
