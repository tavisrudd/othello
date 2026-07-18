#!/usr/bin/env python3
"""Depth-bounded exact P/N certificate probe for the C294 PGL2(5) gates."""

from __future__ import annotations

import argparse
import concurrent.futures
import functools
import importlib.util
import json
from collections import Counter
from pathlib import Path
from types import ModuleType


Mask = int
UNKNOWN = -1
N_POSITION = 0
P_POSITION = 1


def load_module(filename: str, name: str) -> ModuleType:
    path = Path(__file__).with_name(filename)
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


M = load_module("2026-07-17-c294-mixed-scar-obstruction.py", "c294_mixed")
R = load_module("2026-07-17-c294-recursive-defective-mirror.py", "c294_recursive")


class Probe:
    def __init__(self, type_index: int, depth: int, kernel: str = "primary") -> None:
        self.model = R.Model(5, type_index)
        self.depth = depth
        self.kernel = kernel
        self.counts: Counter[str] = Counter()
        self.cache: dict[tuple[Mask, int], int] = {}
        self.pairing_cache: dict[Mask, bool] = {}

    def paired(self, mask: Mask) -> bool:
        cached = self.pairing_cache.get(mask)
        if cached is not None:
            self.counts["pairing_cache_hits"] += 1
            return cached
        self.counts["pairing_tests"] += 1
        induced = M.induced_graph(self.model.adjacency, mask)
        search = (
            M.pairing_witness
            if self.kernel == "primary"
            else M.independent_pairing_witness
        )
        value = search(induced) is not None
        self.pairing_cache[mask] = value
        self.counts[f"pairing_{str(value).lower()}"] += 1
        return value

    def classify(self, mask: Mask, depth: int) -> int:
        key = (mask, depth)
        cached = self.cache.get(key)
        if cached is not None:
            self.counts["state_cache_hits"] += 1
            return cached
        self.counts["states"] += 1
        if mask == 0 or self.paired(mask):
            result = P_POSITION
        elif depth == 0:
            result = UNKNOWN
        else:
            saw_unknown = False
            result = P_POSITION
            moves = sorted(
                M.bits(mask),
                key=lambda vertex: (mask & ~self.model.closed[vertex]).bit_count(),
            )
            for vertex in moves:
                child = mask & ~self.model.closed[vertex]
                child_result = self.classify(child, depth - 1)
                if child_result == P_POSITION:
                    result = N_POSITION
                    break
                if child_result == UNKNOWN:
                    saw_unknown = True
            else:
                if saw_unknown:
                    result = UNKNOWN
        self.cache[key] = result
        self.counts[{P_POSITION: "proved_p", N_POSITION: "proved_n", UNKNOWN: "unknown"}[result]] += 1
        return result

    def run(self) -> dict[str, object]:
        model = self.model
        follower = model.full & ~model.closed[model.identity_index]
        result = self.classify(follower, self.depth)
        return {
            "counts": dict(sorted(self.counts.items())),
            "depth": self.depth,
            "follower_result": {UNKNOWN: "unknown", N_POSITION: "N", P_POSITION: "P"}[result],
            "kernel": self.kernel,
            "pair_product_orders": list(M.pair_product_orders(model.generators)),
            "type_index": model.type_index,
            "vertices": follower.bit_count(),
        }


def run_depth_case(arguments: tuple[int, int, str]) -> dict[str, object]:
    return Probe(*arguments).run()


class StateLimitReached(RuntimeError):
    pass


class KSetProbe:
    """Bodlaender--Kratsch--Timmer connected-component nimber recursion."""

    def __init__(self, q: int, type_index: int, state_limit: int) -> None:
        self.model = R.Model(q, type_index)
        self.state_limit = state_limit
        self.cache: dict[Mask, int] = {}
        self.counts: Counter[str] = Counter()

    def components(self, mask: Mask) -> list[Mask]:
        result = []
        unseen = mask
        while unseen:
            seed = unseen & -unseen
            component = seed
            frontier = seed
            unseen ^= seed
            while frontier:
                vertex_bit = frontier & -frontier
                frontier ^= vertex_bit
                vertex = vertex_bit.bit_length() - 1
                added = self.model.adjacency[vertex] & unseen
                unseen ^= added
                frontier |= added
                component |= added
            result.append(component)
        return result

    def nimber(self, mask: Mask) -> int:
        if not mask:
            return 0
        components = self.components(mask)
        if len(components) > 1:
            self.counts["decompositions"] += 1
            value = 0
            for component in components:
                value ^= self.nimber(component)
            return value
        cached = self.cache.get(mask)
        if cached is not None:
            self.counts["cache_hits"] += 1
            return cached
        if len(self.cache) >= self.state_limit:
            raise StateLimitReached
        self.counts["connected_states"] += 1
        seen = 0
        for vertex in M.bits(mask):
            seen |= 1 << self.nimber(mask & ~self.model.closed[vertex])
        value = (~seen & -~seen).bit_length() - 1
        self.cache[mask] = value
        return value

    def run(self) -> dict[str, object]:
        model = self.model
        follower = model.full & ~model.closed[model.identity_index]
        try:
            value: int | None = self.nimber(follower)
            stopped = False
        except StateLimitReached:
            value = None
            stopped = True
        return {
            "counts": dict(sorted(self.counts.items())),
            "field_order": model.q,
            "follower_nimber": value,
            "pair_product_orders": list(M.pair_product_orders(model.generators)),
            "state_limit": self.state_limit,
            "stopped_at_limit": stopped,
            "type_index": model.type_index,
            "vertices": follower.bit_count(),
        }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--type", type=int, default=0)
    parser.add_argument("--depth", type=int, default=2)
    parser.add_argument("--q", type=int, default=5)
    parser.add_argument("--kset-limit", type=int)
    parser.add_argument("--emit-graph", action="store_true")
    parser.add_argument("--hard-types", action="store_true")
    parser.add_argument("--jobs", type=int, default=1)
    parser.add_argument("--kernel", choices=("primary", "independent"), default="primary")
    parser.add_argument("--output", type=Path)
    parser.add_argument("--check", type=Path)
    args = parser.parse_args()
    if args.emit_graph:
        model = R.Model(args.q, args.type)
        print(args.q, args.type, len(model.adjacency))
        for neighbours in model.adjacency:
            print(neighbours & ((1 << 64) - 1), neighbours >> 64)
        print(model.full & ~model.closed[model.identity_index] & ((1 << 64) - 1),
              (model.full & ~model.closed[model.identity_index]) >> 64)
        return
    if args.hard_types:
        arguments = [(index, args.depth, args.kernel) for index in (0, 1, 2, 3, 7, 9, 11)]
        with concurrent.futures.ProcessPoolExecutor(max_workers=args.jobs) as executor:
            cases = list(executor.map(run_depth_case, arguments))
        result = {
            "cases": cases,
            "depth": args.depth,
            "kernel": args.kernel,
            "schema": "c294-depth-bounded-pairing-v1",
        }
    elif args.kset_limit is None:
        result = Probe(args.type, args.depth, args.kernel).run()
    else:
        result = KSetProbe(args.q, args.type, args.kset_limit).run()
    encoded = json.dumps(result, indent=2, sort_keys=True) + "\n"
    if args.check is not None and encoded != args.check.read_text():
        raise SystemExit(f"generated output differs from {args.check}")
    if args.output is not None:
        args.output.write_text(encoded)
    if args.output is None and args.check is None:
        print(encoded, end="")


if __name__ == "__main__":
    main()
