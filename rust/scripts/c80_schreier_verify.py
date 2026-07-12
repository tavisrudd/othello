#!/usr/bin/env python3
"""Independent check of the three-centre Schreier-residual families.

Independent of the standalone three_centre_probe.py: this uses this repo's
PrimeGridGame geometry (a different conic normalization, sigma derivation and centre
domain — the affine residual grid). It classifies off-conic centre triples by the
subgroup H_S = <sigma_x, sigma_y, sigma_z> <= PGL(2,q) they generate, builds the residual
Node-Kayles graph (the union of the three involution matchings on the live conic points,
after removing the saturated set D(S) = conic points on a line through two centres, and
keeping isolated live vertices), computes the Node-Kayles Grundy of each connected
component and of the whole, and tabulates component structure + total value by subgroup
order.

Confirms (or refutes) the theorem structure independently of the parametrization:
  - order 4 (self-polar / V4) -> components all K4 (n4e6), total Grundy = parity
  - order 8 (D8)             -> components M8 (n8e12, cubic) + K2, total Grundy = parity

Usage:  c80_schreier_verify.py [q ...] [--full-max Q] [--sample N]
"""
from __future__ import annotations

import argparse
import importlib.util
import random
import sys
from collections import Counter, defaultdict
from functools import lru_cache
from itertools import combinations
from pathlib import Path


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def compose(p, q):
    return tuple(p[q[i]] for i in range(len(q)))


def perm_order(p):
    n = len(p)
    seen = [False] * n
    from math import gcd
    order = 1
    for s in range(n):
        if seen[s]:
            continue
        length = 0
        t = s
        while not seen[t]:
            seen[t] = True
            t = p[t]
            length += 1
        order = order * length // gcd(order, length)
    return order


def subgroup_order(gens, n, cap=200):
    # early-exit once the order exceeds `cap`: we only need to distinguish the small
    # subgroup rows (4, 8, 12, 24, 60) from "large" (PSL/PGL).
    ident = tuple(range(n))
    seen = {ident}
    frontier = [ident]
    while frontier:
        g = frontier.pop()
        for s in gens:
            h = compose(s, g)
            if h not in seen:
                seen.add(h)
                if len(seen) > cap:
                    return -1  # "large"
                frontier.append(h)
    return len(seen)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("q", nargs="*", type=int, default=[11, 13])
    ap.add_argument("--full-max", type=int, default=13)
    ap.add_argument("--sample", type=int, default=40000)
    args = ap.parse_args()

    rng = random.Random(20260712)
    notes = Path(__file__).resolve().parents[2] / "notes"
    c20 = load_module(notes / "2026-07-08-intrusion-census.py", "c80s_c20")

    for q in args.q:
        game = c20.PrimeGridGame(q)
        params = list(game.params)
        n = len(params)
        pidx = {p: i for i, p in enumerate(params)}
        conic_pt = [game.conic_point[params[i]] for i in range(n)]
        off = [c for c in range(q * q) if c not in game.cell_param]
        cpoint = {c: game.points[c + 2] for c in off}
        perm = {
            c: tuple(pidx[game.sigma(c, params[i])] for i in range(n)) for c in off
        }

        # keyed by (subgroup order, sorted pair-product orders) -> distributions
        key_sig = defaultdict(Counter)
        key_grundy = defaultdict(Counter)
        key_count = Counter()
        large = 0

        if q <= args.full_max:
            gen = combinations(off, 3)
            mode = "FULL"
        else:
            gen = (tuple(rng.sample(off, 3)) for _ in range(args.sample))
            mode = f"SAMPLE({args.sample})"

        for tri in gen:
            pa, pb, pc = (cpoint[tri[0]], cpoint[tri[1]], cpoint[tri[2]])
            # legal size-3 cap = the three centres not collinear
            if game.collinear(pa, pb, pc):
                continue
            gens = [perm[c] for c in tri]
            order = subgroup_order(gens, n)
            if order == -1:
                large += 1  # generic PSL/PGL triple; skip the expensive residual
                continue
            pairs = tuple(sorted(
                perm_order(compose(gens[i], gens[j])) for i, j in ((0, 1), (0, 2), (1, 2))
            ))
            # saturated set D(S): conic points on a line through two centres
            dead = set()
            for (u, v) in ((pa, pb), (pa, pc), (pb, pc)):
                for i in range(n):
                    if game.collinear(u, v, conic_pt[i]):
                        dead.add(i)
            live = [i for i in range(n) if i not in dead]
            liveset = set(live)
            adj = {i: set() for i in live}
            for g in gens:
                for i in live:
                    j = g[i]
                    if j != i and j in liveset:
                        adj[i].add(j)
                        adj[j].add(i)
            # connected components over ALL live vertices (isolated included)
            seen = set()
            comps = []
            for v in live:
                if v in seen:
                    continue
                stack = [v]
                comp = []
                while stack:
                    u = stack.pop()
                    if u in seen:
                        continue
                    seen.add(u)
                    comp.append(u)
                    stack.extend(adj[u] - seen)
                comps.append(comp)

            @lru_cache(maxsize=None)
            def nk(frozen):
                if not frozen:
                    return 0
                opts = set()
                for v in frozen:
                    removed = (adj[v] & set(frozen)) | {v}
                    opts.add(nk(frozenset(frozen) - removed))
                m = 0
                while m in opts:
                    m += 1
                return m

            total = 0
            sig = Counter()
            for comp in comps:
                total ^= nk(frozenset(comp))
                nn = len(comp)
                ee = sum(len(adj[v] & set(comp)) for v in comp) // 2
                sig[f"n{nn}e{ee}"] += 1
            nk.cache_clear()

            key = (order, pairs)
            key_count[key] += 1
            key_grundy[key][total] += 1
            key_sig[key][tuple(sorted(sig.items()))] += 1

        s4label = {(3, 3, 3): "A", (3, 4, 4): "B", (2, 3, 3): "C", (2, 3, 4): "D"}
        print(f"=== q={q} (q%8={q % 8}) {mode} conic_pts={n} off_centres={len(off)} "
              f"generic_triples={large} ===")
        for key in sorted(key_count):
            order, pairs = key
            gd = dict(sorted(key_grundy[key].items()))
            outcome = "P" if set(gd) == {0} else ("all-N" if 0 not in gd else "mixed")
            tag = ""
            if order == 24 and pairs in s4label:
                tag = f" S4-class-{s4label[pairs]}"
            top = key_sig[key].most_common(1)
            sig_str = "; ".join(
                "{" + ", ".join(f"{s}x{c}" for s, c in sig) + "}" + f"×{m}"
                for sig, m in top
            )
            print(f"  order={order:4d} pairs={pairs}{tag}  triples={key_count[key]:6d}  "
                  f"grundy={gd}  {outcome}")
            print(f"       comp: {sig_str}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
