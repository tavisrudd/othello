#!/usr/bin/env python3
"""Finite-field cross-check on the Eckardt locus of the nonstandard A_5-cubic
pencil, independent of the elimination over Q.

The companion script a5_pencil_eckardt_locus.py determines the Eckardt locus and
the singular locus of the pencil by a Groebner elimination over Q.  That is a
trusted execution of a computer algebra system, so this script recomputes both
loci by a completely different method, sharing no code with it: for each of five
finite fields it enumerates every point of P^4(F_q) on every member and applies
the rank criterion directly.

It also runs the same detector on the Fermat cubic threefold as a control, which
is what identifies the two Eckardt members: they carry thirty Eckardt points
each when the cube roots of unity are rational and none otherwise, matching the
Fermat count exactly.

Criterion.  A point p of a smooth cubic threefold X = {F = 0} is an Eckardt
point exactly when the Hessian of F at p has rank at most two.

Model.  A_5 = PSL(2,5) on the six points of P^1(F_5);
on the sum-zero subspace that permutation module is W_5.  With T_1 the sum
over one of the two A_5-orbits of ten squarefree monomials x_i x_j x_k and
p_3 = sum x_i^3,

    F_{a,b} = a p_3 + b T_1     on    x_1 + ... + x_6 = 0,

coordinatized by y_1..y_5 with x_i = y_i for i <= 5 and x_6 = -(y_1+...+y_5).

The Hessian in y follows from the Hessian M in x by the chain rule,
H_ij = M_ij - M_i6 - M_6j + M_66, with

    M = a diag(6 x) + b N,      N_kl = sum over triples containing k and l
                                       of the remaining coordinate (k != l),
                                N_kk = 0.

Rank at most two is tested as the vanishing of all hundred three-by-three
minors, applied as a cascade of masks so that almost all points drop out at
the first minor.

Caveat.  Absence of an F_q-rational Eckardt point does not by itself prove
geometric absence; an Eckardt point could be defined over an extension.  What
the sweep gives is the answer, uniformly in the member, over five fields, plus
the exact list of members that do carry one.

Replay, from the paper directory:

    uv run --with numpy python3 verification/a5_pencil_eckardt_sweep.py \
        > verification/a5-pencil-eckardt-sweep.txt
    uv run --with numpy python3 verification/a5_pencil_eckardt_sweep.py \
        --check verification/a5-pencil-eckardt-sweep.txt

The --check mode regenerates in memory and compares against the tracked output
without writing to the working tree.
"""

from __future__ import annotations

import io
import sys
from itertools import combinations

import numpy as np

PRIMES = [11, 19, 29, 31, 41]


def a5_on_six_points():
    pts = [0, 1, 2, 3, 4, 'inf']
    idx = {p: i for i, p in enumerate(pts)}

    def shift(z):
        return 'inf' if z == 'inf' else (z + 1) % 5

    def invert(z):
        if z == 'inf':
            return 0
        if z == 0:
            return 'inf'
        return (-pow(z, 3, 5)) % 5

    gens = [tuple(idx[shift(p)] for p in pts), tuple(idx[invert(p)] for p in pts)]
    ident = tuple(range(6))
    seen, frontier = {ident}, [ident]
    while frontier:
        new = []
        for s in frontier:
            for g in gens:
                t = tuple(g[s[i]] for i in range(6))
                if t not in seen:
                    seen.add(t)
                    new.append(t)
        frontier = new
    return sorted(seen)


def triple_orbit(group):
    triples = [frozenset(c) for c in combinations(range(6), 3)]
    seed = frozenset([0, 1, 2])
    orb, stack = set(), [seed]
    while stack:
        t = stack.pop()
        if t in orb:
            continue
        orb.add(t)
        for g in group:
            stack.append(frozenset(g[i] for i in t))
    assert len(orb) == 10 and orb <= set(triples)
    return sorted(sorted(t) for t in orb)


def projective_points(q):
    blocks = []
    for lead in range(5):
        m = 4 - lead
        n = q ** m
        block = np.zeros((n, 5), dtype=np.int64)
        block[:, lead] = 1
        idx = np.arange(n, dtype=np.int64)
        for t in range(m):
            block[:, lead + 1 + t] = (idx // (q ** (m - 1 - t))) % q
        blocks.append(block)
    return np.concatenate(blocks, axis=0)


def det3(m, rows, cols, q):
    (r0, r1, r2), (c0, c1, c2) = rows, cols

    def e(i, j):
        return m[i][j]

    t = (e(r0, c0) * (e(r1, c1) * e(r2, c2) - e(r1, c2) * e(r2, c1))
         - e(r0, c1) * (e(r1, c0) * e(r2, c2) - e(r1, c2) * e(r2, c0))
         + e(r0, c2) * (e(r1, c0) * e(r2, c1) - e(r1, c1) * e(r2, c0)))
    return t % q


def main():
    buf = io.StringIO()

    def say(t=""):
        print(t, file=buf)

    fails = [0]

    def check(label, ok, detail=""):
        if not ok:
            fails[0] += 1
        say(f"  [{'OK  ' if ok else 'FAIL'}] {label}" + (f"   {detail}" if detail else ""))

    say("Eckardt sweep over the whole nonstandard A_5-cubic pencil")
    say("=" * 70)
    say()

    group = a5_on_six_points()
    orbit = triple_orbit(group)
    say(f"Model: T_1 = sum over "
        f"{[''.join(str(i + 1) for i in t) for t in orbit]}")
    say()

    all_clear = True
    for q in PRIMES:
        say(f"q = {q}")
        P = projective_points(q)
        x = np.zeros((P.shape[0], 6), dtype=np.int64)
        x[:, :5] = P
        x[:, 5] = (-P.sum(axis=1)) % q

        p3 = np.zeros(P.shape[0], dtype=np.int64)
        for i in range(6):
            p3 = (p3 + x[:, i] * x[:, i] % q * x[:, i]) % q
        t1 = np.zeros(P.shape[0], dtype=np.int64)
        for (i, j, k) in orbit:
            t1 = (t1 + x[:, i] * x[:, j] % q * x[:, k]) % q

        # second derivatives in x
        Np3 = [[np.zeros(P.shape[0], dtype=np.int64) for _ in range(6)]
               for _ in range(6)]
        for i in range(6):
            Np3[i][i] = (6 * x[:, i]) % q
        Nt1 = [[np.zeros(P.shape[0], dtype=np.int64) for _ in range(6)]
               for _ in range(6)]
        for tri in orbit:
            for (i, j) in ((tri[0], tri[1]), (tri[0], tri[2]), (tri[1], tri[2])):
                third = [t for t in tri if t != i and t != j][0]
                Nt1[i][j] = (Nt1[i][j] + x[:, third]) % q
                Nt1[j][i] = Nt1[i][j]

        # first derivatives, for smoothness
        dp3 = [(3 * x[:, i] * x[:, i]) % q for i in range(6)]
        dt1 = []
        for i in range(6):
            acc = np.zeros(P.shape[0], dtype=np.int64)
            for tri in orbit:
                if i in tri:
                    o = [t for t in tri if t != i]
                    acc = (acc + x[:, o[0]] * x[:, o[1]]) % q
            dt1.append(acc)
        Ap = [(dp3[i] - dp3[5]) % q for i in range(5)]
        Bp = [(dt1[i] - dt1[5]) % q for i in range(5)]

        members = [(1, b) for b in range(q)] + [(0, 1)]
        singular, eckardt, clean = [], [], []
        for (a, b) in members:
            F = (a * p3 + b * t1) % q
            onX = F == 0
            sing = onX.copy()
            for i in range(5):
                sing &= ((a * Ap[i] + b * Bp[i]) % q) == 0
            if bool(sing.any()):
                singular.append((a, b))
                continue
            idx = np.flatnonzero(onX)
            H = [[((a * Np3[i][j] + b * Nt1[i][j])
                   - (a * Np3[i][5] + b * Nt1[i][5])
                   - (a * Np3[5][j] + b * Nt1[5][j])
                   + (a * Np3[5][5] + b * Nt1[5][5])) % q
                  for j in range(5)] for i in range(5)]
            Hs = [[H[i][j][idx] for j in range(5)] for i in range(5)]
            alive = np.ones(idx.shape[0], dtype=bool)
            for rows in combinations(range(5), 3):
                for cols in combinations(range(5), 3):
                    if not alive.any():
                        break
                    keep = np.flatnonzero(alive)
                    d = det3([[Hs[i][j][keep] for j in range(5)] for i in range(5)],
                             rows, cols, q)
                    newalive = np.zeros_like(alive)
                    newalive[keep[d == 0]] = True
                    alive = newalive
                if not alive.any():
                    break
            n = int(alive.sum())
            if n:
                eckardt.append((a, b, n))
            else:
                clean.append((a, b))
        say(f"  {len(clean)} smooth members with no F_{q}-rational Eckardt point,"
            f" {len(eckardt)} with one, {len(singular)} singular")
        say(f"  singular at (a:b) = {[f'{a}:{b}' for (a, b) in singular]}")
        if eckardt:
            say(f"  Eckardt at (a:b) = "
                f"{[f'{a}:{b} ({n} points)' for (a, b, n) in eckardt]}")

        # cross-check against the independent Singular elimination over Q of
        # a5_pencil_eckardt_locus.py, which gives the
        # singular locus as b (b+6) (b^2-3b-9) (7b^2+3b+9)
        def disc_poly(r):
            return (r * (r + 6) * (r * r - 3 * r - 9)
                    * (7 * r * r + 3 * r + 9)) % q

        predicted = sorted(r for r in range(q) if disc_poly(r) == 0)
        observed = sorted(b for (a, b) in singular if a == 1)
        check("the singular members match the elimination's discriminant "
              "b (b+6) (b^2-3b-9) (7b^2+3b+9)",
              observed == predicted, f"observed {observed}, predicted {predicted}")

        # the Eckardt locus is predicted to be the root set of b^2 + 3b + 9,
        # that is b = 3 omega for a primitive cube root of unity omega
        roots = sorted(r for r in range(q) if (r * r + 3 * r + 9) % q == 0)
        found = sorted(b for (a, b, _) in eckardt if a == 1)
        check("the Eckardt members are exactly the roots of b^2 + 3b + 9",
              found == roots, f"found {found}, roots {roots}")
        check(f"b^2 + 3b + 9 splits over F_{q} exactly when q = 1 mod 3",
              (len(roots) == 2) == (q % 3 == 1),
              f"{len(roots)} roots, q = {q % 3} mod 3")
        check("every Eckardt member carries exactly thirty Eckardt points",
              all(n == 30 for (_, _, n) in eckardt),
              f"counts {[n for (_, _, n) in eckardt]}")

        # Fermat control: the same detector on x_1^3 + ... + x_5^3
        fp3 = np.zeros(P.shape[0], dtype=np.int64)
        for i in range(5):
            fp3 = (fp3 + P[:, i] * P[:, i] % q * P[:, i]) % q
        fidx = np.flatnonzero(fp3 == 0)
        FH = [[((6 * P[:, i]) % q if i == j else np.zeros(P.shape[0], dtype=np.int64))
               for j in range(5)] for i in range(5)]
        FHs = [[FH[i][j][fidx] for j in range(5)] for i in range(5)]
        alive = np.ones(fidx.shape[0], dtype=bool)
        for rows in combinations(range(5), 3):
            for cols in combinations(range(5), 3):
                if not alive.any():
                    break
                keep = np.flatnonzero(alive)
                d = det3([[FHs[i][j][keep] for j in range(5)] for i in range(5)],
                         rows, cols, q)
                newalive = np.zeros_like(alive)
                newalive[keep[d == 0]] = True
                alive = newalive
            if not alive.any():
                break
        nfermat = int(alive.sum())
        say(f"  Fermat control: the Fermat cubic threefold has {nfermat}"
            f" F_{q}-rational Eckardt points")
        check("the Fermat control agrees with the Eckardt members",
              (nfermat == 30) == (q % 3 == 1),
              f"{nfermat} points, q = {q % 3} mod 3")
        all_clear &= not eckardt
        say()

    say("=" * 70)
    say("The Eckardt locus of the pencil is NOT empty.  On every field tested it")
    say("is exactly the root set of b^2 + 3b + 9, that is the conjugate pair")
    say("b = 3 omega and b = 3 omega-bar for a primitive cube root of unity, each")
    say("member carrying thirty Eckardt points -- the Fermat count.  Those are the")
    say("two members of the pencil that also admit the permutation action of A_5.")
    say(f"failures: {fails[0]}")
    return buf.getvalue(), fails[0]


if __name__ == "__main__":
    text, nfail = main()
    if len(sys.argv) > 2 and sys.argv[1] == "--check":
        with open(sys.argv[2]) as fh:
            want = fh.read()
        ok = want == text and nfail == 0
        print("check:", "OK" if ok else "MISMATCH")
        sys.exit(0 if ok else 1)
    sys.stdout.write(text)
    sys.exit(0 if nfail == 0 else 1)
