#!/usr/bin/env python3
"""Search structured affine-involution mirror certificates in Z3^2 x Z_p.

Candidate mirrors have the form

  (h,k) -> (M h + b, alpha k + beta)

where h in F3^2, k in F_p, M in GL(2,3), alpha in {1,-1}, and the whole map is
an involution.  The verifier is local/adversarial: from a pi-invariant starting
board, every legal move must have a legal pi-mate and recursion continues only
through pi-invariant positions.

The first target is the Lemma-B zero-sum triple child family.
"""

from __future__ import annotations

import argparse
import collections
import itertools


def add(a, b, mods):
    return tuple((a[i] + b[i]) % mods[i] for i in range(3))


def sumfree(board, mods):
    s = set(board)
    return all(add(x, y, mods) not in s for x in s for y in s)


def legal_moves(board, elems, mods):
    s = set(board)
    return [x for x in elems if x not in s and sumfree(list(s) + [x], mods)]


def det2(M):
    return (M[0][0] * M[1][1] - M[0][1] * M[1][0]) % 3


def mat_vec(M, h):
    return ((M[0][0] * h[0] + M[0][1] * h[1]) % 3, (M[1][0] * h[0] + M[1][1] * h[1]) % 3)


def mat_mul(A, B):
    return tuple(
        tuple(sum(A[i][k] * B[k][j] for k in range(2)) % 3 for j in range(2))
        for i in range(2)
    )


def gl23():
    out = []
    for vals in itertools.product(range(3), repeat=4):
        M = ((vals[0], vals[1]), (vals[2], vals[3]))
        if det2(M) % 3:
            out.append(M)
    return out


def affine_specs(p):
    I = ((1, 0), (0, 1))
    for M in gl23():
        if mat_mul(M, M) != I:
            continue
        for b in itertools.product(range(3), repeat=2):
            # Need M b + b = 0 for the F3 affine part to square to identity.
            if tuple((mat_vec(M, b)[i] + b[i]) % 3 for i in range(2)) != (0, 0):
                continue
            for alpha in (1, -1):
                betas = [0] if alpha == 1 else list(range(p))
                for beta in betas:
                    name = f"M={M},b={b},alpha={alpha},beta={beta}"
                    yield name, M, b, alpha, beta


def make_pi(spec, p):
    _, M, b, alpha, beta = spec

    def pi(x):
        h = mat_vec(M, x[:2])
        return ((h[0] + b[0]) % 3, (h[1] + b[1]) % 3, (alpha * x[2] + beta) % p)

    return pi


def invariant(board, pi):
    s = set(board)
    return all(pi(x) in s for x in s)


def verify(board, spec, elems, mods, max_states):
    pi = make_pi(spec, mods[2])
    if not invariant(board, pi):
        return False, "not-invariant", 0
    seen = {}

    def rec(A):
        if A in seen:
            return seen[A]
        if len(seen) >= max_states:
            seen[A] = False
            return False
        for x in legal_moves(A, elems, mods):
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


def coordstr(x):
    return ",".join(str(v) for v in x)


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


def mine_zero_triple(p, max_rows, max_states):
    mods = (3, 3, p)
    elems = [e for e in itertools.product(*[range(m) for m in mods]) if any(e)]
    s = (0, 0, 1)
    t = (0, 1, 1)
    r = (0, 2, (-2) % p)
    triple = [s, t, r]
    moves = legal_moves(triple, elems, mods)
    specs = list(affine_specs(p))
    print(f"p={p} affine involutions={len(specs)} triple children={len(moves)}")

    covered = []
    uncovered = []
    spec_counts = collections.Counter()
    kind_counts = collections.Counter()
    for a in moves:
        board = triple + [a]
        cert = None
        for spec in specs:
            pi = make_pi(spec, p)
            if not invariant(board, pi):
                continue
            ok, _, states = verify(board, spec, elems, mods, max_states)
            if ok:
                cert = (spec, states)
                break
        if cert:
            spec, states = cert
            covered.append((a, spec, states))
            spec_counts[spec[0]] += 1
            kind_counts[(kind(a), spec[0])] += 1
        else:
            uncovered.append(a)

    print(f"certified children: {len(covered)}/{len(moves)}")
    print("top specs:")
    for name, n in spec_counts.most_common(max_rows):
        print(f"  {n:3d} {name}")
    print("sample certificates:")
    for a, spec, states in covered[:max_rows]:
        print(f"  child {coordstr(a):8s} ({kind(a):7s}) states={states}  {spec[0]}")
    if uncovered:
        print("uncovered:")
        for a in uncovered[:max_rows]:
            print(f"  {coordstr(a):8s} ({kind(a)})")


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--p", type=int, default=7)
    ap.add_argument("--max-rows", type=int, default=12)
    ap.add_argument("--max-states", type=int, default=200000)
    args = ap.parse_args()
    mine_zero_triple(args.p, args.max_rows, args.max_states)


if __name__ == "__main__":
    main()
