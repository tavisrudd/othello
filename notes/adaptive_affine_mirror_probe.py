#!/usr/bin/env python3
"""Probe whether oracle P-positions admit an adaptive affine involution mirror."""

from __future__ import annotations

import argparse
import itertools
import os
import resource
import sys

sys.path.insert(0, os.path.dirname(__file__))
from sumfree_solver import Group, Solver, build_canonical_group, mask_bits, set_mem_limit_mb


def gl2():
    out = []
    for vals in itertools.product(range(3), repeat=4):
        a = ((vals[0], vals[1]), (vals[2], vals[3]))
        det = (a[0][0] * a[1][1] - a[0][1] * a[1][0]) % 3
        if det:
            out.append(a)
    return out


def mmul(a, b):
    return tuple(tuple(sum(a[i][k] * b[k][j] for k in range(2)) % 3 for j in range(2)) for i in range(2))


def mvec(a, v):
    return tuple(sum(a[i][k] * v[k] for k in range(2)) % 3 for i in range(2))


def affine_involutions(g):
    ident = ((1, 0), (0, 1))
    for a in gl2():
        if mmul(a, a) != ident:
            continue
        for lam in (1, 4):
            for c_h in itertools.product(range(3), repeat=2):
                if tuple((mvec(a, c_h)[i] + c_h[i]) % 3 for i in range(2)) != (0, 0):
                    continue
                cks = range(5) if lam == 4 else [0]
                for c_k in cks:
                    perm = []
                    for e in g.elems:
                        h = mvec(a, e[:2])
                        out_h = ((h[0] + c_h[0]) % 3, (h[1] + c_h[1]) % 3)
                        out_k = (lam * e[2] + c_k) % 5
                        perm.append(g.idx[out_h + (out_k,)])
                    yield tuple(perm)


def clean_mirror(raw, perm, amask, members, s, d, t):
    # A invariant.
    img = 0
    for a in members:
        img |= raw.g.pow2[perm[a]]
    if img != amask:
        return False
    moves = raw.legal_mask(amask, s, d, t)
    for y in mask_bits(moves):
        r = perm[y]
        if r == y:
            return False
        child = raw.child_state(amask, members, s, d, t, y)
        cmoves = raw.legal_mask(child[0], child[2], child[3], child[4])
        if not (cmoves & raw.g.pow2[r]):
            return False
    return True


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--mem-mb", type=int, default=0)
    ap.add_argument("--samples", type=int, default=200)
    args = ap.parse_args()
    set_mem_limit_mb(args.mem_mb)
    g = Group((3, 3, 5))
    raw = Solver(g)
    cg, _ = build_canonical_group(g, "auto", 200_000)
    sv = Solver(g, cg)
    invs = list(affine_involutions(g))
    print(f"affine involutions={len(invs)}")

    def hero_move(am, mem, s, d, t):
        moves = raw.legal_mask(am, s, d, t)
        for _, x, cam, cm, cs, cd, ct, cmoves in sv.ordered_children(am, mem, s, d, t, moves):
            if cmoves == 0 or not sv.win(cam, cm, cs, cd, ct, cmoves, len(cm)):
                return x
        return None

    am, mem, s, d, t = raw.compute_state(())
    first = hero_move(am, mem, s, d, t)
    stack = [raw.child_state(am, mem, s, d, t, first)]
    seen = set()
    checked = good = 0
    bad_examples = []
    while stack and checked < args.samples:
        state = stack.pop()
        am, mem, s, d, t = state
        if am in seen:
            continue
        seen.add(am)
        checked += 1
        ok = any(clean_mirror(raw, p, am, mem, s, d, t) for p in invs)
        good += int(ok)
        if not ok and len(bad_examples) < 5:
            bad_examples.append([g.elems[i] for i in mem])
        moves = raw.legal_mask(am, s, d, t)
        for y in mask_bits(moves):
            child = raw.child_state(am, mem, s, d, t, y)
            r = hero_move(*child)
            if r is not None:
                stack.append(raw.child_state(*child, r))
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss // 1024
    print(f"checked={checked} clean_mirror={good} rss={rss}MB")
    for ex in bad_examples:
        print(f"no mirror example={ex}")


if __name__ == "__main__":
    main()
