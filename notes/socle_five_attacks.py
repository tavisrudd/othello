#!/usr/bin/env python3
"""Small-data probes for the five socle-reduction attacks.

This is intentionally conservative: exact computations are kept small and run
through the corrected solver.  The goal is a reproducible table for the current
assignment update, not a new high-performance canonicalizer.
"""

from __future__ import annotations

import argparse
import math
import os
import resource
import sys
from functools import lru_cache
from typing import Iterable, Sequence, Tuple


sys.path.insert(0, os.path.dirname(__file__))
from sumfree_solver import Group, Solver, build_canonical_group, mask_bits, set_mem_limit_mb
from socle_reduction_probe import rho_local_probe


Mods = Tuple[int, ...]


def fmt_mods(mods: Mods) -> str:
    return "x".join("Z" + str(m) for m in mods) if mods else "1"


def clean_mods(mods: Iterable[int]) -> Mods:
    return tuple(m for m in mods if m > 1)


def outcome(mods: Mods):
    g = Group(mods)
    cg, label = build_canonical_group(g, "auto", 200_000)
    sv = Solver(g, cg)
    out, first = sv.solve()
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
    return out, "-" if first is None else g.label(first), sv.nodes, len(sv.tt), rss, label


class Grundy:
    def __init__(self, mods: Mods):
        self.g = Group(mods)
        cg, _ = build_canonical_group(self.g, "auto", 200_000)
        self.solver = Solver(self.g, cg)
        self.tt = {}
        self.nodes = 0

    def mex(self, vals):
        s = set(vals)
        x = 0
        while x in s:
            x += 1
        return x

    def grundy(self, amask, members, s, d, t, moves):
        self.nodes += 1
        key = self.solver.canon(amask, members)
        if key in self.tt:
            return self.tt[key]
        vals = []
        for _, x, camask, cmembers, cs, cd, ct, cmoves in self.solver.ordered_children(
            amask, members, s, d, t, moves
        ):
            vals.append(0 if cmoves == 0 else self.grundy(camask, cmembers, cs, cd, ct, cmoves))
        val = self.mex(vals)
        self.tt[key] = val
        return val

    def solve(self) -> int:
        amask, members, s, d, t = self.solver.compute_state(())
        moves = self.solver.legal_mask(amask, s, d, t)
        return self.grundy(amask, members, s, d, t, moves)


def quotient6_mods(mods: Mods) -> Mods:
    # Coordinate quotient by 6G: Z_m / 6Z_m has order gcd(m,6).
    return clean_mods(math.gcd(m, 6) for m in mods)


def projected_coords(e, mods: Mods):
    out = []
    for a, m in zip(e, mods):
        q = math.gcd(m, 6)
        if q > 1:
            out.append(a % q)
    return tuple(out)


def find_projection_counterexample(mods: Mods, limit_masks=1 << 18):
    """Find sum-free A in G whose image in G/6G is not sum-free."""
    qmods = quotient6_mods(mods)
    if not qmods:
        return None
    g = Group(mods)
    q = Group(qmods)
    raw = Solver(g)
    max_mask = min(1 << g.N, limit_masks)
    for mask in range(max_mask):
        if not raw.sumfree_mask(mask):
            continue
        image = set()
        for i in mask_bits(mask):
            image.add(q.idx[projected_coords(g.elems[i], mods)])
        qmask = 0
        for i in image:
            qmask |= q.pow2[i]
        if not Solver(q).sumfree_mask(qmask):
            return [g.label(i) for i in mask_bits(mask)], [q.label(i) for i in mask_bits(qmask)]
    return None


def lmsf_sizes(mods: Mods, max_states=300_000):
    g = Group(mods)
    raw = Solver(g)
    seen = 0

    @lru_cache(maxsize=None)
    def rec(amask, members, s, d, t):
        nonlocal seen
        seen += 1
        if seen > max_states:
            raise RuntimeError("state cap")
        moves = raw.legal_mask(amask, s, d, t)
        if moves == 0:
            return frozenset([len(members)])
        out = set()
        for x in mask_bits(moves):
            out |= rec(*raw.child_state(amask, members, s, d, t, x))
        return frozenset(out)

    amask, members, s, d, t = raw.compute_state(())
    return sorted(rec(amask, members, s, d, t)), seen


def attack1():
    print("=== Attack 1: atomic peel outcomes and rho mirrorability ===")
    rows = []
    rows += [("P_cop(5)", (3,), (3, 5))]
    rows += [("P_cop(5)", (3, 3), (3, 3, 5))]
    rows += [("P_cop(5)", (2, 3), (2, 3, 5))]
    rows += [("P_cop(5)", (2, 2), (2, 2, 5))]
    rows += [("P_2(2)", (3, 2), (3, 4))]
    rows += [("P_2(2)", (3, 3, 2), (3, 3, 4))]
    rows += [("P_3(2)", (3, 3), (3, 9))]
    rows += [("P_3(2)", (2, 3, 3), (2, 3, 9))]
    print("peel       base          lifted        base lifted holds mirror-note")
    for peel, base, lifted in rows:
        ob = outcome(base)[0]
        ol = outcome(lifted)[0]
        holds = "yes" if ob == ol else "NO"
        mirror = "-"
        if peel.startswith("P_cop"):
            probe = rho_local_probe(lifted, max_sets=20_000)
            mirror = "rho-ok" if probe["bad"] == 0 else f"rho-fails({probe['bad']})"
        print(f"{peel:10s} {fmt_mods(base):13s} {fmt_mods(lifted):13s} {ob:>4s} {ol:>6s} {holds:>5s} {mirror}")


def attack2():
    print("\n=== Attack 2: small Grundy table ===")
    groups = [(2,), (3,), (5,), (7,), (9,), (10,), (14,), (3, 3), (5, 3), (3, 9), (2, 3), (2, 3, 5)]
    print("group          Grundy nodes tt")
    for mods in groups:
        gr = Grundy(mods)
        val = gr.solve()
        print(f"{fmt_mods(mods):13s} {val:6d} {gr.nodes:5d} {len(gr.tt):5d}")


def attack3():
    print("\n=== Attack 3: quotient by 6G ===")
    groups = [(9,), (3, 9), (5, 3), (5, 3, 3), (2, 5, 3), (4, 3, 3)]
    print("G             G/6G          out(G) out(Q) morphism-note")
    for mods in groups:
        qmods = quotient6_mods(mods)
        og = outcome(mods)[0]
        oq = "P" if not qmods else outcome(qmods)[0]
        ce = find_projection_counterexample(mods)
        note = "projection-of-position fails" if ce else "no small counterexample"
        print(f"{fmt_mods(mods):13s} {fmt_mods(qmods):13s} {og:>6s} {oq:>6s} {note}")
        if ce:
            print(f"  counterexample A={ce[0]} maps to non-sum-free {ce[1]}")


def attack5():
    print("\n=== Attack 5: LMSF size distributions ===")
    groups = [(3,), (9,), (3, 3), (3, 9), (2, 3), (2, 3, 3), (5, 3)]
    print("group          LMSF sizes parity states")
    for mods in groups:
        try:
            sizes, states = lmsf_sizes(mods)
            parity = "even" if all(s % 2 == 0 for s in sizes) else ("odd" if all(s % 2 for s in sizes) else "mixed")
            print(f"{fmt_mods(mods):13s} {str(sizes):16s} {parity:6s} {states}")
        except RuntimeError:
            print(f"{fmt_mods(mods):13s} STATE WALL")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mem-mb", type=int, default=0)
    args = ap.parse_args()
    set_mem_limit_mb(args.mem_mb)
    attack1()
    attack2()
    attack3()
    attack5()


if __name__ == "__main__":
    main()
