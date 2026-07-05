#!/usr/bin/env python3
"""Empirical probes for the sum-free-game socle reduction.

This script uses the corrected bitmask solver in sumfree_solver.py.  It checks
outcome(G) versus outcome(G[6]) and probes the natural rho mirror:

  rho = identity on the {2,3}-Sylow / socle directions, negation on the 6'-part.

The mirror probe is local: over rho-symmetric sum-free sets, if y is legal and
rho(y) is fresh, does adding the pair stay sum-free?  Failure triples are printed
to characterize the interference.
"""

from __future__ import annotations

import argparse
import os
import resource
import sys
from typing import List, Optional, Sequence, Tuple


sys.path.insert(0, os.path.dirname(__file__))
from sumfree_solver import Group, Solver, build_canonical_group, mask_bits, parse_mods, set_mem_limit_mb


def mul(g: Group, k: int, x: int) -> int:
    r = g.zero
    for _ in range(k):
        r = g.add[r][x]
    return r


def socle_indices(g: Group) -> List[int]:
    return [i for i in range(g.N) if mul(g, 6, i) == g.zero]


def outcome(g: Group, restrict: Optional[Sequence[int]], canon: str, progress: int = 0):
    cg, label = build_canonical_group(g, canon, cap=200_000)
    sv = Solver(g, cg, restrict=restrict, progress=progress)
    out, first = sv.solve()
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
    return out, first, sv.nodes, len(sv.tt), rss, label


def part23(m: int) -> int:
    out = 1
    while m % 2 == 0:
        out *= 2
        m //= 2
    while m % 3 == 0:
        out *= 3
        m //= 3
    return out


def rho_factor(x: int, m: int) -> int:
    m6 = part23(m)
    mp = m // m6
    for z in range(m):
        if z % m6 == x % m6 and z % mp == (-x) % mp:
            return z
    raise RuntimeError((x, m))


def rho_perm(g: Group) -> Tuple[int, ...]:
    perm = []
    for e in g.elems:
        perm.append(g.idx[tuple(rho_factor(a, m) for a, m in zip(e, g.mods))])
    p = tuple(perm)
    g.verify_automorphism(p)
    return p


def first_violation_triple(g: Group, mask: int):
    bits = list(mask_bits(mask))
    for a in bits:
        for b in bits:
            c = g.add[a][b]
            if mask & g.pow2[c]:
                return a, b, c
    return None


def rho_local_probe(mods: Sequence[int], max_sets: int = 100_000):
    g = Group(mods)
    rho = rho_perm(g)
    raw = Solver(g)
    ground = [i for i in range(g.N) if i != g.zero]

    seen = {0}
    stack = [(0, tuple(), 0, 0, 0)]
    tested = bad = 0
    first_bad = None

    while stack:
        amask, members, s, d, t = stack.pop()
        moves = raw.legal_mask(amask, s, d, t)
        for y in ground:
            if not (moves & g.pow2[y]) or rho[y] == y:
                continue
            ry = rho[y]
            tested += 1
            if amask & g.pow2[ry]:
                bad += 1
                first_bad = first_bad or (amask, y, ry, "rho-reply already present", None)
                continue
            y_child = raw.child_state(amask, members, s, d, t, y)
            yamask, ymembers, ys, yd, yt = y_child
            if not (raw.legal_mask(yamask, ys, yd, yt) & g.pow2[ry]):
                bad += 1
                tri = first_violation_triple(g, yamask | g.pow2[ry])
                first_bad = first_bad or (amask, y, ry, "rho-reply illegal", tri)
                continue

            child = raw.child_state(yamask, ymembers, ys, yd, yt, ry)
            camask = child[0]
            if camask not in seen and len(seen) < max_sets:
                seen.add(camask)
                stack.append(child)

    return {
        "mods": tuple(mods),
        "tested": tested,
        "bad": bad,
        "sets": len(seen),
        "socle_size": len(socle_indices(g)),
        "first_bad": first_bad,
        "group": g,
    }


def print_compare(mods: Sequence[int], canon: str, progress: int) -> None:
    g = Group(mods)
    socle = socle_indices(g)
    og, fg, ng, ttg, rssg, label = outcome(g, None, canon, progress)
    os, fs, ns, tts, rsss, _ = outcome(g, socle, canon, progress)
    flag = "OK" if og == os else "MISMATCH"
    print(
        f"  {'x'.join('Z'+str(m) for m in mods):12s} "
        f"G={og} first={ '-' if fg is None else g.label(fg):12s} "
        f"G6={os} |G6|={len(socle):3d} nodes=({ng},{ns}) "
        f"tt=({ttg},{tts}) rss={max(rssg,rsss)}MB canon={label} {flag}",
        flush=True,
    )


def print_rho(mods: Sequence[int], max_sets: int) -> None:
    res = rho_local_probe(mods, max_sets=max_sets)
    g = res["group"]
    print(
        f"  {'x'.join('Z'+str(m) for m in mods):12s} |G6|={res['socle_size']:3d} "
        f"sets={res['sets']:6d} tests={res['tested']:8d} bad={res['bad']:6d} "
        f"{'OK' if res['bad'] == 0 else 'FAIL'}"
    )
    if res["first_bad"] is not None:
        amask, y, ry, why, tri = res["first_bad"]
        aset = [g.label(i) for i in mask_bits(amask)]
        print(f"    first: A={aset} y={g.label(y)} rho(y)={g.label(ry)} reason={why}")
        if tri is not None:
            a, b, c = tri
            print(f"    triple: {g.label(a)} + {g.label(b)} = {g.label(c)}")


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--mem-mb", type=int, default=0)
    ap.add_argument("--progress", type=int, default=0)
    ap.add_argument("--canon", default="auto", choices=["auto", "full", "monomial", "coord", "none"])
    ap.add_argument("--rho-sets", type=int, default=100_000)
    ap.add_argument("mods", nargs="*", help="optional explicit groups, e.g. 5,3 2,5,3")
    args = ap.parse_args()
    set_mem_limit_mb(args.mem_mb)

    if args.mods:
        groups = [parse_mods(m) for m in args.mods]
    else:
        groups = [
            (5,),
            (7,),
            (5, 3),
            (7, 3),
            (5, 9),
            (5, 3, 3),
            (2, 5),
            (2, 5, 3),
            (5, 2, 2),
            (10,),
            (14,),
            (30,),
            (5, 2, 9),
        ]

    print("=== outcome(G) vs outcome(G[6]) with corrected solver ===")
    for mods in groups:
        try:
            print_compare(mods, args.canon, args.progress)
        except MemoryError:
            print(f"  {'x'.join('Z'+str(m) for m in mods):12s} MEMORY WALL")

    print("\n=== rho local mirror probe ===")
    for mods in groups:
        try:
            print_rho(mods, args.rho_sets)
        except MemoryError:
            print(f"  {'x'.join('Z'+str(m) for m in mods):12s} MEMORY WALL")


if __name__ == "__main__":
    main()
