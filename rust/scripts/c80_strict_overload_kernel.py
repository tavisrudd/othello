#!/usr/bin/env python3
"""C80: certify the strict-overload response kernel on frozen escape roots.

For a cap state S, let omega(S) be total capacity-two overload.  Define K
recursively by

  omega(S) = 0:  S is in K iff S is in Y_NK;
  omega(S) > 0:  S is in K iff every opponent move has a legal reply R
                         with omega(R) < omega(S) and R in K.

This is a structural, value-independent certificate: it uses only cap
legality, incidence overload, and the static Node-Kayles Grundy value at the
omega-zero boundary.  It does not call cap-game minimax when deciding K.

The exact cap-game value is computed separately as a consistency check.

Run:
  python3 rust/scripts/c80_strict_overload_kernel.py
Check:
  python3 rust/scripts/c80_strict_overload_kernel.py --check
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import importlib.util
import itertools
import json
import sys
from functools import lru_cache
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ROWS = ROOT / "notes/data/c20-q13-q17-states.jsonl.gz"
OUT = ROOT / "notes/2026-07-24-c80-strict-overload-kernel.json"


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


GEOMETRY = load_module(
    ROOT / "notes/2026-07-08-zone-repair-geometry.py", "c80_kernel_geometry"
)
CENSUS = load_module(
    ROOT / "rust/scripts/c80_response_fibre_census.py", "c80_kernel_census"
)
C31 = GEOMETRY.load_c31_module()
C20 = C31.load_c20_module()


def escape_parameters(path: Path, q: int) -> list[tuple[int, ...]]:
    """Canonical t4 labels occurring in the frozen P-reply corpus."""
    labels: set[tuple[int, ...]] = set()
    with gzip.open(path, "rt", encoding="utf-8") as source:
        for line in source:
            if not line.strip():
                continue
            row = json.loads(line)
            if row["q"] == q and row["reply_state_value"] == "P":
                labels.add(tuple(int(t) for t in row["t4"]))
    return sorted(labels)


class StrictKernel:
    def __init__(self, q: int):
        self.q = q
        self.game = C20.PrimeGridGame(q)
        self.lines = CENSUS.projective_lines(self.game)
        self.responses: dict[tuple[int, int], int] = {}
        self.boundary: set[int] = set()
        self.contains_cache_start = self.contains.cache_info().currsize

    @lru_cache(maxsize=None)
    def omega(self, mask: int) -> int:
        legal = self.game.legal_mask(mask)
        return sum(
            max(0, (legal & line_mask).bit_count() - 2)
            for line_mask, fixed_load in self.lines
            if fixed_load + (mask & line_mask).bit_count() == 0
        )

    @lru_cache(maxsize=None)
    def boundary_grundy(self, mask: int) -> int:
        """Static Node-Kayles Grundy of the full legal-point conflict graph."""
        cells = list(GEOMETRY.bits(self.game.legal_mask(mask)))
        adjacency = [0] * len(cells)
        for i, point in enumerate(cells):
            after = self.game.legal_mask(mask | (1 << point))
            for j in range(i + 1, len(cells)):
                if not (after & (1 << cells[j])):
                    adjacency[i] |= 1 << j
                    adjacency[j] |= 1 << i

        @lru_cache(maxsize=None)
        def graph_grundy(vertices: int) -> int:
            values = set()
            remaining = vertices
            while remaining:
                low = remaining & -remaining
                vertex = low.bit_length() - 1
                values.add(
                    graph_grundy(vertices & ~(low | adjacency[vertex]))
                )
                remaining ^= low
            result = 0
            while result in values:
                result += 1
            return result

        return graph_grundy((1 << len(cells)) - 1)

    @lru_cache(maxsize=None)
    def contains(self, mask: int) -> bool:
        old_omega = self.omega(mask)
        if old_omega == 0:
            is_ynk = self.boundary_grundy(mask) == 0
            if is_ynk:
                self.boundary.add(mask)
            return is_ynk

        for opponent in GEOMETRY.bits(self.game.legal_mask(mask)):
            child = mask | (1 << opponent)
            witness = None
            for reply in GEOMETRY.bits(self.game.legal_mask(child)):
                target = child | (1 << reply)
                if self.omega(target) < old_omega and self.contains(target):
                    witness = reply
                    break
            if witness is None:
                return False
            self.responses[(mask, opponent)] = witness
        return True

    def response_digest(self) -> str:
        rows = (
            f"{state}:{opponent}:{reply}"
            for (state, opponent), reply in sorted(self.responses.items())
        )
        return hashlib.sha256("\n".join(rows).encode()).hexdigest()

    def states_visited(self) -> int:
        return self.contains.cache_info().currsize - self.contains_cache_start


def run_escape_order(q: int, rows: Path) -> dict:
    kernel = StrictKernel(q)
    labels = escape_parameters(rows, q)
    records = []
    for label in labels:
        mask = kernel.game.base_mask(label)
        records.append(
            {
                "t4": list(label),
                "omega": kernel.omega(mask),
                "strict_kernel": kernel.contains(mask),
                "exact_cap_value": "N" if kernel.game.value(mask) else "P",
            }
        )

    kernel_count = sum(record["strict_kernel"] for record in records)
    p_count = sum(record["exact_cap_value"] == "P" for record in records)
    return {
        "q": q,
        "domain": "unique size-four on-conic escape roots in the frozen C20 P-reply corpus",
        "roots": len(records),
        "strict_kernel_roots": kernel_count,
        "exact_p_roots": p_count,
        "strict_kernel_iff_exact_p_on_domain": all(
            record["strict_kernel"] == (record["exact_cap_value"] == "P")
            for record in records
        ),
        "omega_min": min(record["omega"] for record in records),
        "omega_max": max(record["omega"] for record in records),
        "kernel_states_visited": kernel.states_visited(),
        "certified_response_edges": len(kernel.responses),
        "ynk_boundary_states": len(kernel.boundary),
        "response_map_sha256": kernel.response_digest(),
        "records": records,
    }


def run_exhaustive_order(q: int) -> dict:
    """Cross-check every reachable residual cap state for q=5,7."""
    kernel = StrictKernel(q)
    seen: set[int] = set()
    stack = [0]
    while stack:
        mask = stack.pop()
        if mask in seen:
            continue
        seen.add(mask)
        stack.extend(
            mask | (1 << point)
            for point in GEOMETRY.bits(kernel.game.legal_mask(mask))
        )

    p_states = {mask for mask in seen if not kernel.game.value(mask)}
    kernel_states = {mask for mask in seen if kernel.contains(mask)}
    return {
        "q": q,
        "domain": "every reachable residual cap state after the fixed opening pair",
        "states": len(seen),
        "exact_p_states": len(p_states),
        "strict_kernel_states": len(kernel_states),
        "strict_kernel_equals_exact_p": kernel_states == p_states,
        "symmetric_difference": len(kernel_states ^ p_states),
        "kernel_states_visited": kernel.states_visited(),
        "certified_response_edges": len(kernel.responses),
        "ynk_boundary_states": len(kernel.boundary),
        "response_map_sha256": kernel.response_digest(),
    }


def run_all_onconic_roots(q: int) -> dict:
    """Check every raw four-subset of the residual conic parameter line."""
    kernel = StrictKernel(q)
    records = []
    for label in itertools.combinations(range(1, q), 4):
        mask = kernel.game.base_mask(label)
        records.append(
            (
                kernel.contains(mask),
                not kernel.game.value(mask),
                kernel.omega(mask),
            )
        )
    return {
        "q": q,
        "domain": (
            "every raw size-four on-conic root after fixing conic parameters 0 and infinity"
        ),
        "roots": len(records),
        "strict_kernel_roots": sum(in_kernel for in_kernel, _is_p, _omega in records),
        "exact_p_roots": sum(is_p for _in_kernel, is_p, _omega in records),
        "strict_kernel_iff_exact_p": all(
            in_kernel == is_p for in_kernel, is_p, _omega in records
        ),
        "symmetric_difference": sum(
            in_kernel != is_p for in_kernel, is_p, _omega in records
        ),
        "omega_min": min(omega for _in_kernel, _is_p, omega in records),
        "omega_max": max(omega for _in_kernel, _is_p, omega in records),
        "kernel_states_visited": kernel.states_visited(),
        "certified_response_edges": len(kernel.responses),
        "ynk_boundary_states": len(kernel.boundary),
        "response_map_sha256": kernel.response_digest(),
    }


def payload(rows: Path) -> dict:
    return {
        "schema": "c80-strict-overload-kernel-v1",
        "claim_scope": (
            "The recursively defined strict-overload kernel is value-independent and "
            "supplies a well-founded response certificate into its Y_NK boundary. "
            "The finite checks establish membership only on the listed exact domains; "
            "they do not prove uniform odd-q membership."
        ),
        "source": {
            "path": str(rows.relative_to(ROOT)),
            "sha256": sha256(rows),
            "bytes": rows.stat().st_size,
        },
        "exhaustive_small_orders": [run_exhaustive_order(q) for q in (5, 7)],
        "mixed_escape_crosscheck": run_all_onconic_roots(11),
        "frozen_escape_orders": [run_escape_order(q, rows) for q in (13, 17)],
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=Path, default=ROWS)
    parser.add_argument("--output", type=Path, default=OUT)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    rendered = json.dumps(payload(args.rows), indent=2, sort_keys=True) + "\n"
    if args.check:
        assert args.output.read_text() == rendered, "strict-overload kernel mismatch"
        print("C80 strict-overload kernel: PASS")
    else:
        args.output.write_text(rendered)
        print(f"wrote {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
