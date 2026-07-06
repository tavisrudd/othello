#!/usr/bin/env python3
"""Search affine-reflection certificates for the Lemma-B zero-sum triple.

For Lemma B in Z3^2 x Z_p, put
  s=(0,0,1), t=(0,1,1), r=-s-t=(0,2,-2).

At p=7 the triple {s,t,r} has all children P.  This script tests whether each
child {s,t,r,a} is P for the simple reason that it is invariant under an affine
reflection pi_c(x)=c-x and the responder can pi_c-mirror forever.
"""

from __future__ import annotations

import argparse
import itertools
import collections


def add(a, b, mods):
    return tuple((a[i] + b[i]) % mods[i] for i in range(3))


def neg(a, mods):
    return tuple((-a[i]) % mods[i] for i in range(3))


def sub(a, b, mods):
    return add(a, neg(b, mods), mods)


def coordstr(a):
    return ",".join(str(x) for x in a)


def kind(x):
    soc = x[:2] != (0, 0)
    cop = x[2] != 0
    if soc and cop:
        return "mixed"
    if soc:
        return "socle"
    if cop:
        return "coprime"
    return "zero"


def sumfree(board, mods):
    s = set(board)
    return all(add(x, y, mods) not in s for x in s for y in s)


def legal_moves(board, elems, mods):
    s = set(board)
    out = []
    for x in elems:
        if x in s:
            continue
        if sumfree(list(s) + [x], mods):
            out.append(x)
    return out


def reflection(center, mods):
    def pi(x):
        return sub(center, x, mods)
    return pi


def invariant(board, pi):
    s = set(board)
    return all(pi(x) in s for x in s)


def verify_mirror(board, center, elems, mods, max_states=200000):
    pi = reflection(center, mods)
    if not invariant(board, pi):
        return False, "not-invariant", 0
    seen = {}

    def rec(A):
        if A in seen:
            return seen[A]
        if len(seen) >= max_states:
            seen[A] = False
            return False
        moves = legal_moves(A, elems, mods)
        for x in moves:
            y = pi(x)
            if y == x:
                seen[A] = False
                return False
            if y not in legal_moves(A | {x}, elems, mods):
                seen[A] = False
                return False
            child = frozenset(set(A) | {x, y})
            if not invariant(child, pi):
                seen[A] = False
                return False
            if not rec(child):
                seen[A] = False
                return False
        seen[A] = True
        return True

    ok = rec(frozenset(board))
    return ok, "ok" if ok else "mirror-break", len(seen)


def centers_for(board, elems, mods):
    out = []
    for c in [(0, 0, 0)] + elems:
        if invariant(board, reflection(c, mods)):
            out.append(c)
    return out


def mine(p: int, max_rows: int):
    mods = (3, 3, p)
    elems = [e for e in itertools.product(*[range(m) for m in mods]) if any(e)]
    s = (0, 0, 1)
    t = (0, 1, 1)
    r = neg(add(s, t, mods), mods)
    triple = [s, t, r]
    moves = legal_moves(triple, elems, mods)
    print(f"p={p} triple={triple} legal children={len(moves)}")

    covered = []
    uncovered = []
    center_counts = collections.Counter()
    kind_counts = collections.Counter()
    state_counts = []
    for a in moves:
        board = triple + [a]
        certs = []
        for c in centers_for(board, elems, mods):
            ok, why, states = verify_mirror(board, c, elems, mods)
            if ok:
                certs.append((c, states))
        if certs:
            c, states = min(certs, key=lambda row: row[1])
            covered.append((a, c, states))
            center_counts[c] += 1
            kind_counts[(kind(a), kind(c))] += 1
            state_counts.append(states)
        else:
            uncovered.append(a)

    print(f"affine-reflection certified children: {len(covered)}/{len(moves)}")
    if state_counts:
        print(f"mirror state counts: min={min(state_counts)} max={max(state_counts)}")
    print("center counts:")
    for c, n in center_counts.most_common():
        print(f"  {coordstr(c):8s} {n}")
    print("child kind -> center kind:")
    for (ka, kc), n in kind_counts.most_common():
        print(f"  {ka:7s}->{kc:7s} {n}")
    print("sample certificates:")
    for a, c, states in covered[:max_rows]:
        print(f"  child {coordstr(a):8s} ({kind(a):7s})  center {coordstr(c):8s} ({kind(c):7s}) states={states}")
    if uncovered:
        print("uncovered:")
        for a in uncovered[:max_rows]:
            cs = " ".join(coordstr(c) for c in centers_for(triple + [a], elems, mods))
            print(f"  child {coordstr(a):8s} ({kind(a):7s}) invariant-centers=[{cs}]")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--p", type=int, default=7)
    ap.add_argument("--max-rows", type=int, default=20)
    args = ap.parse_args()
    mine(args.p, args.max_rows)


if __name__ == "__main__":
    main()
