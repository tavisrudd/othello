#!/usr/bin/env python3
"""C921 - testing the level structure the gluing packet forces on the pencil.

The epilogue's Proposition "principal gluing packet" says the relative kernel
K_p is a *section* of the local system of A_5-stable maximal isotropic halves.
Read as a constraint on the monodromy of Hartlieb's elliptic factor E_b, that
forces two things (derived in notes/2026-08-19-c921-integral-glued-model.md):

  at two   the two-primary kernel is one of the two exotic F_4-lines, whose
           stabilizer in GL_2(F_2) is the cyclic subgroup of order three, so
           the mod-two monodromy image lies in that subgroup - equivalently
           the discriminant of E_b is a square;
  at three the halves are H_3 tensor l for lines l in E_b[3], so a section is
           a monodromy-invariant order-three subgroup - equivalently E_b
           carries a rational three-isogeny.

Neither has been confronted with the explicit pencil.  This script does that.

The pencil (C914's rational model).  A_5 = PSL(2,5) acts on the six points of
P^1(F_5); on the sum-zero subspace of Q^6 that permutation module is W_5.  The
twenty squarefree monomials x_i x_j x_k fall into two A_5-orbits of ten; with
T_1 the sum over one orbit and p_3 = sum x_i^3,

    F_{a,b} = a p_3 + b T_1   restricted to   x_1 + ... + x_6 = 0.

Recovering the elliptic factor.  A_5 acts by coordinate permutations, hence
over the prime field, so the isotypic decomposition H^3(X_b) = W_5 tensor
H^1(E_b)(-1) is Galois-equivariant with W_5 carrying the trivial action.  For
a smooth member,

    #X_b(F_q) = q^3 + q^2 + q + 1 - 5 q a_b,        a_b = tr(Frob | H^1(E_b)),

so a_b is read off the point count.  That 5q divides the deficit is a
self-check on both the identity and the count.

The two tests, both invariant under quadratic twist so that the sign ambiguity
in a_b does not matter:

  (a) square discriminant.  If Frobenius acted on E_b[2] with order two there
      would be exactly one rational point of order two.  A necessary condition
      for the predicted order-one-or-three behaviour is

          #E_b(F_q) = q + 1 - a_b  is not congruent to 2 modulo 4.

      Both quadratic twists give the same residue, since (q+1-a) + (q+1+a) is
      divisible by four for odd q.

  (b) rational three-isogeny.  Frobenius fixes a line in E_b[3] exactly when
      x^2 - a x + q has a root modulo three, that is when a^2 - q is a square
      modulo three:

          q = 1 mod 3   requires   a_b not divisible by three,
          q = 2 mod 3   requires   a_b divisible by three.

      Replacing a by -a does not change either condition.

Singular members are detected by the existence of an F_q-rational point where
all partial derivatives vanish, and are excluded from the tests; the Segre
cubic at (a,b) = (1,0) has ten nodes and must appear among them.

Replay:

    uv run --with numpy python3 notes/2026-08-19-c921-pencil-level-structure.py \
        > notes/2026-08-19-c921-pencil-level-structure.txt
    uv run --with numpy python3 notes/2026-08-19-c921-pencil-level-structure.py \
        --check notes/2026-08-19-c921-pencil-level-structure.txt
"""

from __future__ import annotations

import io
import sys
from itertools import combinations

import numpy as np

PRIMES = [11, 19, 29, 31, 41, 43]


def a5_on_six_points():
    """A_5 = PSL(2,5) on P^1(F_5) = {0,1,2,3,4,inf}, as 0-based permutations."""
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


def triple_orbits(group):
    triples = [frozenset(c) for c in combinations(range(6), 3)]
    remaining = set(triples)
    orbits = []
    while remaining:
        seed = min(remaining, key=lambda s: sorted(s))
        orb = set()
        stack = [seed]
        while stack:
            t = stack.pop()
            if t in orb:
                continue
            orb.add(t)
            for g in group:
                stack.append(frozenset(g[i] for i in t))
        orbits.append(sorted(sorted(t) for t in orb))
        remaining -= orb
    return orbits


def projective_points(q):
    """Canonical representatives of P^4(F_q): first nonzero coordinate is one."""
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


def precompute(q, orbit):
    """p_3, T_1 and the five partial derivatives of each, at every point."""
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

    # d p_3 / d x_i = 3 x_i^2 ;  d T_1 / d x_i = sum over triples containing i
    dp3 = [(3 * x[:, i] * x[:, i]) % q for i in range(6)]
    dt1 = []
    for i in range(6):
        acc = np.zeros(P.shape[0], dtype=np.int64)
        for tri in orbit:
            if i in tri:
                other = [t for t in tri if t != i]
                acc = (acc + x[:, other[0]] * x[:, other[1]]) % q
        dt1.append(acc)
    # chain rule through x_6 = -(x_1 + ... + x_5)
    Ap = [(dp3[i] - dp3[5]) % q for i in range(5)]
    Bp = [(dt1[i] - dt1[5]) % q for i in range(5)]
    return p3, t1, Ap, Bp


def main():
    buf = io.StringIO()

    def say(t=""):
        print(t, file=buf)

    fails = [0]

    def check(label, ok, detail=""):
        if not ok:
            fails[0] += 1
        say(f"  [{'OK  ' if ok else 'FAIL'}] {label}" + (f"   {detail}" if detail else ""))

    say("C921 - level structure of the nonstandard A_5-cubic pencil")
    say("=" * 70)
    say()

    group = a5_on_six_points()
    say("Model")
    check("|A_5| = 60", len(group) == 60, f"order {len(group)}")
    orbits = triple_orbits(group)
    check("the twenty triples split into two A_5-orbits of ten",
          sorted(len(o) for o in orbits) == [10, 10],
          f"sizes {sorted(len(o) for o in orbits)}")
    orbit = orbits[0]
    say(f"  T_1 = sum over {[''.join(str(i + 1) for i in t) for t in orbit]}")
    say()

    verdict_a = True
    verdict_b = True
    for q in PRIMES:
        say(f"q = {q}   (q = {q % 3} mod 3)")
        p3, t1, Ap, Bp = precompute(q, orbit)
        members = [(1, b) for b in range(q)] + [(0, 1)]
        total = q ** 3 + q ** 2 + q + 1
        singular, smooth, bad = [], [], []
        traces = {}
        for (a, b) in members:
            F = (a * p3 + b * t1) % q
            npts = int((F == 0).sum())
            sing = np.ones(F.shape[0], dtype=bool)
            for i in range(5):
                sing &= ((a * Ap[i] + b * Bp[i]) % q) == 0
            sing &= (F == 0)
            if bool(sing.any()):
                singular.append((a, b, npts, int(sing.sum())))
                continue
            deficit = total - npts
            if deficit % (5 * q):
                bad.append((a, b, npts, deficit))
                continue
            tr = deficit // (5 * q)
            traces[(a, b)] = tr
            smooth.append((a, b, npts, tr))
        check(f"every smooth member has 5q dividing the deficit", not bad,
              "" if not bad else f"offenders {bad[:3]}")
        check("Weil bound |a| <= 2 sqrt(q) on every smooth member",
              all(t * t <= 4 * q for (_, _, _, t) in smooth),
              f"max |a| = {max((abs(t) for (_, _, _, t) in smooth), default=0)}")
        check("the Segre member (1,0) is singular",
              any(a == 1 and b == 0 for (a, b, _, _) in singular))
        say(f"  members: {len(smooth)} smooth, {len(singular)} singular"
            f" over F_{q}, {len(bad)} anomalous")
        say(f"  singular at (a:b) = "
            f"{[f'{a}:{b}' for (a, b, _, _) in singular]}")

        # test (a)
        viol_a = [(a, b, tr, (q + 1 - tr) % 4) for (a, b, _, tr) in smooth
                  if (q + 1 - tr) % 4 == 2]
        check("(a) #E_b(F_q) is never 2 mod 4, so the discriminant is a square",
              not viol_a,
              "" if not viol_a else f"{len(viol_a)} violations, e.g. {viol_a[:3]}")
        verdict_a &= not viol_a

        # test (b)
        if q % 3 == 1:
            viol_b = [(a, b, tr) for (a, b, _, tr) in smooth if tr % 3 == 0]
            lab = "3 does not divide a_b"
        else:
            viol_b = [(a, b, tr) for (a, b, _, tr) in smooth if tr % 3 != 0]
            lab = "3 divides a_b"
        check(f"(b) rational three-isogeny: {lab}", not viol_b,
              "" if not viol_b else f"{len(viol_b)} violations, e.g. {viol_b[:3]}")
        verdict_b &= not viol_b

        # (c) the Fermat members, the roots of b^2 + 3b + 9, should have an
        # elliptic factor with complex multiplication by Q(sqrt -3), that is
        # j = 0, since the Fermat cubic threefold has a CM Hodge structure.
        # Over F_q that reads a^2 - 4q = -3 c^2.
        fermat = [r for r in range(q) if (r * r + 3 * r + 9) % q == 0]
        cm = []
        for r in fermat:
            if (1, r) not in traces:
                continue
            a = traces[(1, r)]
            t = 4 * q - a * a
            ok = t > 0 and t % 3 == 0 and round((t // 3) ** 0.5) ** 2 == t // 3
            cm.append((r, a, t, ok))
        if fermat:
            check("(c) the Fermat members have an elliptic factor with complex "
                  "multiplication by Q(sqrt -3)",
                  bool(cm) and all(o for (_, _, _, o) in cm),
                  f"{[(r, a, f'4q-a^2={t}') for (r, a, t, _) in cm]}")
        else:
            say(f"  (c) the Fermat members are not F_{q}-rational here"
                f" (q = 2 mod 3)")

        say(f"  traces a_b = {[traces[m] for m in sorted(traces)]}")
        say()

    say("=" * 70)
    say(f"prediction (a), square discriminant : "
        f"{'CONFIRMED' if verdict_a else 'REFUTED'}")
    say(f"prediction (b), rational 3-isogeny  : "
        f"{'CONFIRMED' if verdict_b else 'REFUTED'}")
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
