#!/usr/bin/env python3
"""C31 recursive zone-steering ceiling census.

Input rows are C20 reply-state records from notes/data/c20-q13-q17-states.jsonl.gz.
For each P reply-state S, compute

  Z(S) = 0 if S is terminal, else
         max_m min_r max(zone(S+m+r), Z(S+m+r)),

where m ranges over legal opponent moves and r ranges over winning replies that return to
a P-position.  The zone is the off-conic legal move count used by C20.
"""

from __future__ import annotations

import argparse
import gzip
import importlib.util
import json
import sys
import time
from collections import Counter, defaultdict
from functools import lru_cache
from pathlib import Path


def load_c20_module():
    path = Path(__file__).with_name("2026-07-08-intrusion-census.py")
    spec = importlib.util.spec_from_file_location("c20_intrusion_census", path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot import {path}")
    mod = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = mod
    spec.loader.exec_module(mod)
    return mod


def iter_bits(mask: int):
    while mask:
        bit = mask & -mask
        yield bit.bit_length() - 1
        mask ^= bit


def cell_bit(q: int, cell: list[int] | tuple[int, int]) -> int:
    return 1 << (int(cell[0]) * q + int(cell[1]))


def state_mask(game, row: dict) -> int:
    mask = game.base_mask(tuple(row["t4"]))
    mask |= cell_bit(game.q, row["x"])
    mask |= cell_bit(game.q, row["y"])
    return mask


def load_p_reply_states(path: Path, q: int) -> tuple[list[tuple[int, dict]], Counter]:
    c20 = load_c20_module()
    game = c20.PrimeGridGame(q)
    states: dict[int, dict] = {}
    row_counts = Counter()
    with gzip.open(path, "rt", encoding="utf-8") as f:
        for line in f:
            if not line.strip():
                continue
            row = json.loads(line)
            if row["q"] != q:
                continue
            row_counts["rows"] += 1
            if row["reply_state_value"] != "P":
                continue
            mask = state_mask(game, row)
            row_counts["p_rows"] += 1
            states.setdefault(mask, row)
    row_counts["unique_p_states"] = len(states)
    return sorted(states.items(), key=lambda kv: (kv[0].bit_count(), kv[0])), row_counts


class Steering:
    def __init__(self, game):
        self.game = game
        self.zone_cache: dict[int, int] = {}
        self.z_cache: dict[int, int] = {}
        self.trace_cache: dict[int, tuple[int, int, int, int]] = {}

    def zone(self, mask: int) -> int:
        if mask not in self.zone_cache:
            legal = self.game.legal_mask(mask)
            self.zone_cache[mask] = (legal & ~self.game.conic_mask).bit_count()
        return self.zone_cache[mask]

    def z(self, mask: int) -> int:
        if mask in self.z_cache:
            return self.z_cache[mask]
        if self.game.value(mask):
            raise ValueError("Z requested for an N-state")
        moves = self.game.legal_mask(mask)
        if moves == 0:
            self.z_cache[mask] = 0
            self.trace_cache[mask] = (-1, -1, 0, 0)
            return 0
        worst = -1
        worst_move = -1
        worst_reply = -1
        worst_child_z = 0
        for m in iter_bits(moves):
            child = mask | (1 << m)
            best = None
            best_reply = -1
            best_child_z = 0
            replies = self.game.legal_mask(child)
            for r in iter_bits(replies):
                grand = child | (1 << r)
                if self.game.value(grand):
                    continue
                child_z = self.z(grand)
                score = max(self.zone(grand), child_z)
                if best is None or score < best:
                    best = score
                    best_reply = r
                    best_child_z = child_z
            if best is None:
                raise ValueError(f"N-child has no P reply at mask={mask} move={m}")
            if best > worst:
                worst = best
                worst_move = m
                worst_reply = best_reply
                worst_child_z = best_child_z
        self.z_cache[mask] = worst
        self.trace_cache[mask] = (worst_move, worst_reply, self.zone(mask | (1 << worst_move) | (1 << worst_reply)), worst_child_z)
        return worst


class NaiveSteering:
    """Independent outcome+Z recursion for spot checks.

    This deliberately does not call game.value or Steering.z.  It uses only legal_mask and zone.
    """

    def __init__(self, game):
        self.game = game
        self.zone_cache: dict[int, int] = {}

    def zone(self, mask: int) -> int:
        if mask not in self.zone_cache:
            self.zone_cache[mask] = (self.game.legal_mask(mask) & ~self.game.conic_mask).bit_count()
        return self.zone_cache[mask]

    @lru_cache(maxsize=None)
    def outcome_z(self, mask: int) -> tuple[bool, int | None]:
        moves = self.game.legal_mask(mask)
        if moves == 0:
            return False, 0
        child_results = []
        any_child_p = False
        for m in iter_bits(moves):
            child_n, _ = self.outcome_z(mask | (1 << m))
            child_results.append((m, child_n))
            if not child_n:
                any_child_p = True
        if any_child_p:
            return True, None

        worst = 0
        for m, _child_n in child_results:
            child = mask | (1 << m)
            replies = self.game.legal_mask(child)
            best = None
            for r in iter_bits(replies):
                grand = child | (1 << r)
                grand_n, grand_z = self.outcome_z(grand)
                if grand_n:
                    continue
                assert grand_z is not None
                score = max(self.zone(grand), grand_z)
                if best is None or score < best:
                    best = score
            if best is None:
                raise ValueError("independent recursion found N-child with no P reply")
            worst = max(worst, best)
        return False, worst


def cell(game, idx: int) -> tuple[int, int] | None:
    if idx < 0:
        return None
    return divmod(idx, game.q)


def run_q(q: int, rows_path: Path, limit: int | None, spotcheck: int) -> dict:
    c20 = load_c20_module()
    game = c20.PrimeGridGame(q)
    states, row_counts = load_p_reply_states(rows_path, q)
    if limit is not None:
        states = states[:limit]

    steering = Steering(game)
    z_counts = Counter()
    zone_counts = Counter()
    bucket_counts = Counter()
    bucket_max_z: dict[str, int] = {}
    examples: dict[int, dict] = {}
    start = time.time()

    for i, (mask, row) in enumerate(states, 1):
        if game.value(mask):
            raise RuntimeError(f"C20 P row reconstructed as N at q={q}: {row}")
        zval = steering.z(mask)
        bucket = row["canon"]
        z_counts[zval] += 1
        zone_counts[steering.zone(mask)] += 1
        bucket_counts[bucket] += 1
        bucket_max_z[bucket] = max(bucket_max_z.get(bucket, -1), zval)
        examples.setdefault(
            zval,
            {
                "mask_size": mask.bit_count(),
                "t4": row["t4"],
                "x": row["x"],
                "y": row["y"],
                "y_kind": row["y_kind"],
                "zone": steering.zone(mask),
                "trace": tuple(cell(game, v) if j < 2 else v for j, v in enumerate(steering.trace_cache[mask])),
            },
        )
        if i % 100 == 0:
            print(
                f"PROGRESS q={q} states={i}/{len(states)} z_cache={len(steering.z_cache)} "
                f"value_cache={game.value.cache_info().currsize} elapsed={time.time()-start:.1f}",
                flush=True,
            )

    spot = []
    if spotcheck:
        naive = NaiveSteering(game)
        for mask, row in states[:spotcheck]:
            n, z = naive.outcome_z(mask)
            fast_z = steering.z(mask)
            spot.append(
                {
                    "mask_size": mask.bit_count(),
                    "t4": row["t4"],
                    "x": row["x"],
                    "y": row["y"],
                    "naive_n": n,
                    "naive_z": z,
                    "fast_z": fast_z,
                    "naive_cache": naive.outcome_z.cache_info().currsize,
                }
            )
            if n or z != fast_z:
                raise RuntimeError(f"spotcheck mismatch q={q}: {spot[-1]}")

    return {
        "q": q,
        "row_counts": dict(row_counts),
        "processed_unique_p_states": len(states),
        "z_distribution": dict(sorted(z_counts.items())),
        "initial_zone_distribution": dict(sorted(zone_counts.items())),
        "bucket_count": len(bucket_counts),
        "bucket_state_counts": dict(sorted(bucket_counts.items())),
        "bucket_max_z": dict(sorted(bucket_max_z.items())),
        "max_z": max(z_counts) if z_counts else None,
        "examples": {str(k): v for k, v in sorted(examples.items())},
        "spotcheck": spot,
        "z_cache": len(steering.z_cache),
        "zone_cache": len(steering.zone_cache),
        "value_cache": game.value.cache_info().currsize,
        "seconds": time.time() - start,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", default="notes/data/c20-q13-q17-states.jsonl.gz")
    parser.add_argument("--qs", default="13")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--spotcheck", type=int, default=10)
    parser.add_argument("--json-out")
    args = parser.parse_args()

    sys.setrecursionlimit(10000)
    rows = Path(args.rows)
    results = [run_q(int(q), rows, args.limit, args.spotcheck) for q in args.qs.split(",") if q]
    text = json.dumps(results, indent=2, sort_keys=True)
    if args.json_out:
        Path(args.json_out).write_text(text + "\n", encoding="utf-8")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
