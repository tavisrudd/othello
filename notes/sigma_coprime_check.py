#!/usr/bin/env python3
"""Check sigma-on-F3 plus negation-on-coprime for Z2 x F3^b x Zp.

Strategy from {m}: play p=(0,a,0), then mirror
  sigma(eps, v, k) = (1-eps, a-v, -k).

This is a direct test of whether the Z2 x F3^b theorem survives a coprime
factor by negating the coprime coordinate.
"""

from __future__ import annotations

import argparse
import itertools
import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
from sumfree_solver import Group, Solver, mask_bits, parse_mods, set_mem_limit_mb
from verify_strategy import Verifier


def make_strategy(g: Group, b: int):
    a = (1,) + (0,) * (b - 1)
    opening = g.idx[(0,) + a + (0,)]

    def sigma(x):
        eps, *rest = g.elems[x]
        v = rest[:b]
        k = rest[b]
        w = tuple((a[i] - v[i]) % 3 for i in range(b))
        return g.idx[((1 - eps) % 2,) + w + ((-k) % g.mods[-1],)]

    def strategy(verifier, amask, members, s, d, t, opponent_last):
        moves = verifier.legal_mask(amask, s, d, t)
        if opponent_last is None:
            return opening if moves & g.pow2[opening] else None
        r = sigma(opponent_last)
        return r if moves & g.pow2[r] else None

    return strategy, sigma, opening


def local_sweep(mods, b, cap):
    g = Group(mods)
    raw = Solver(g)
    strategy, sigma, opening = make_strategy(g, b)
    m = g.idx[(1,) + (0,) * b + (0,)]
    base = (m, opening)
    am, mem, s, d, t = raw.compute_state(base)
    seen = {am}
    stack = [(am, mem, s, d, t)]
    tests = bad = 0
    first_bad = None
    while stack:
        am, mem, s, d, t = stack.pop()
        moves = raw.legal_mask(am, s, d, t)
        for y in mask_bits(moves):
            r = sigma(y)
            tests += 1
            if not (moves & g.pow2[y]):
                continue
            child = raw.child_state(am, mem, s, d, t, y)
            cmoves = raw.legal_mask(child[0], child[2], child[3], child[4])
            if not (cmoves & g.pow2[r]):
                bad += 1
                first_bad = first_bad or (am, y, r)
                continue
            pair_child = raw.child_state(*child, r)
            if pair_child[0] not in seen and len(seen) < cap:
                seen.add(pair_child[0])
                stack.append(pair_child)
    return g, tests, bad, len(seen), first_bad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--b", type=int, default=2)
    ap.add_argument("--p", type=int, default=5)
    ap.add_argument("--mem-mb", type=int, default=0)
    ap.add_argument("--cap", type=int, default=100000)
    args = ap.parse_args()
    set_mem_limit_mb(args.mem_mb)
    mods = (2,) + (3,) * args.b + (args.p,)
    g, tests, bad, seen, first_bad = local_sweep(mods, args.b, args.cap)
    print(f"local {'x'.join('Z'+str(m) for m in mods)} tests={tests} bad={bad} seen={seen}")
    if first_bad:
        am, y, r = first_bad
        print(f"first bad A={[g.label(i) for i in mask_bits(am)]} y={g.label(y)} sigma={g.label(r)}")
    strategy, _, _ = make_strategy(g, args.b)
    verifier = Verifier(g, strategy, max_nodes=200000)
    m = g.idx[(1,) + (0,) * args.b + (0,)]
    ok = verifier.verify([m], True)
    print(f"adversarial from {{m}} {'VERIFIED' if ok else 'FAILED'} nodes={verifier.nodes} reason={verifier.failure}")
    if not ok:
        print(verifier.path_labels())


if __name__ == "__main__":
    main()
