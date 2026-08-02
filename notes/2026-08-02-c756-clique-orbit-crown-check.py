#!/usr/bin/env python3
"""C756 independent Python cross-check.

Reproduces the q = 7, 11, 19, 23 rows of the Rust sweep
(notes/2026-08-02-c756-clique-orbit-crown-check.rs) and the positive controls,
using deliberately different code:

  * Q_0 is built as the set of SQUARES of the norm-one circle, {z^2 : z in C},
    rather than as {z in C : z^{(q+1)/2} = 1};
  * the orbit family is enumerated over ALL b in F_{q^2} (not over the reduced
    parameter c = b - b^q), so the claimed reduction is checked by brute force
    instead of assumed;
  * a plain recursive clique search over the coherence graph re-derives the
    nonexistence of any coherent system at these q.

Prime q only (that is all the reproduced rows need).

Replay:  python3 notes/2026-08-02-c756-clique-orbit-crown-check.py
Exit status 0 means every assertion held.
"""

import itertools
import sys


def make_field(q):
    """Return helpers for F_{q^2} = F_q(s), s^2 = eps, q prime."""
    squares = {(x * x) % q for x in range(1, q)}
    eps = next(e for e in range(1, q) if e not in squares)

    def add(a, b):
        return ((a[0] + b[0]) % q, (a[1] + b[1]) % q)

    def sub(a, b):
        return ((a[0] - b[0]) % q, (a[1] - b[1]) % q)

    def mul(a, b):
        return ((a[0] * b[0] + eps * a[1] * b[1]) % q, (a[0] * b[1] + a[1] * b[0]) % q)

    def conj(a):
        return (a[0], (-a[1]) % q)

    def norm(a):
        return (a[0] * a[0] - eps * a[1] * a[1]) % q

    def chi(a):
        n = norm(a)
        if n == 0:
            return 0
        return 1 if pow(n, (q - 1) // 2, q) == 1 else -1

    def power(a, e):
        r = (1, 0)
        while e:
            if e & 1:
                r = mul(r, a)
            a = mul(a, a)
            e >>= 1
        return r

    return dict(q=q, eps=eps, add=add, sub=sub, mul=mul, conj=conj, norm=norm,
                chi=chi, power=power)


def params(q):
    t = (q + 1) // 2
    return t, t + 1, (-1) ** t


def is_coherent(F, Z):
    """Generic coherent-system tester (independent of the orbit machinery)."""
    q = F["q"]
    t, k, delta = params(q)
    if len(Z) != k or len(set(Z)) != k:
        return False
    for z in Z:
        if z[1] == 0:
            return False
        if F["chi"](F["sub"](z, F["conj"](z))) != delta:
            return False
    for z, w in itertools.permutations(Z, 2):
        if z == F["conj"](w):
            return False
        if F["chi"](F["sub"](z, w)) != delta:
            return False
        if F["chi"](F["sub"](z, F["conj"](w))) != -delta:
            return False
    return True


def circle_and_halves(F):
    q = F["q"]
    C = [(x, y) for x in range(q) for y in range(q)
         if (x, y) != (0, 0) and F["norm"]((x, y)) == 1]
    Q0 = sorted({F["mul"](z, z) for z in C})          # squares of the circle
    Q1 = sorted(set(C) - set(Q0))
    return sorted(C), Q0, Q1


def orbit_sweep(q):
    """Brute-force over ALL (a, b, j) with chi(a) = 1; returns counts and passes."""
    F = make_field(q)
    t, k, delta = params(q)
    assert q % 4 == 3 and delta == 1
    C, Q0, Q1 = circle_and_halves(F)
    assert len(C) == q + 1 and len(Q0) == len(Q1) == (q + 1) // 2

    S = [sorted(Q0 + [(0, 0)]), sorted(Q1 + [(0, 0)])]
    setup = {}
    for j in (0, 1):
        assert len(S[j]) == k
        clique = all(F["chi"](F["sub"](u, v)) == 1
                     for u, v in itertools.combinations(S[j], 2))
        maximal = not any(
            all(F["chi"](F["sub"]((x, y), u)) == 1 for u in S[j])
            for x in range(q) for y in range(q) if (x, y) not in set(S[j]))
        setup["S%d_clique" % j] = clique
        setup["S%d_maximal" % j] = maximal

    elems = [(x, y) for x in range(q) for y in range(q)]
    alist = [a for a in elems if F["chi"](a) == 1]
    chi = F["chi"]
    sub, add, mul, conj = F["sub"], F["add"], F["mul"], F["conj"]

    tested = 0
    passes = []
    c_values = set()
    for j in (0, 1):
        Sj = S[j]
        for a in alist:
            aq = conj(a)
            A = [mul(a, u) for u in Sj]
            B = [mul(aq, conj(u)) for u in Sj]
            d01 = sub(A[0], B[1])
            d10 = sub(A[1], B[0])
            d00 = sub(A[0], B[0])
            for b in elems:
                c = sub(b, conj(b))
                if j == 0 and a == alist[0]:
                    c_values.add(c)
                tested += 1
                if chi(add(d01, c)) != -1:
                    continue
                if chi(add(d10, c)) != -1:
                    continue
                if chi(add(d00, c)) != 1:
                    continue
                Z = [add(v, b) for v in A]
                if is_coherent(F, Z):
                    passes.append((j, a, b, tuple(Z)))
    # the reduction claim: b enters only through c = b - b^q, which ranges over s*F_q
    assert len(c_values) == q, (q, len(c_values))
    assert all(cv[0] == 0 for cv in c_values)
    return dict(q=q, eps=F["eps"], k=k, circle=len(C), q0=len(Q0), q1=len(Q1),
                triples_tested=tested, passes=passes, **setup)


def exhaustive(q):
    """Every coherent system, up to the transitive symmetry group; searches
    cliques through the vertex s = (0,1)."""
    F = make_field(q)
    t, k, delta = params(q)
    verts = [(x, y) for x in range(q) for y in range(1, q)]
    idx = {v: i for i, v in enumerate(verts)}
    n = len(verts)
    adj = [set() for _ in range(n)]
    for i in range(n):
        for jj in range(i):
            zi, zj = verts[i], verts[jj]
            if (F["chi"](F["sub"](zi, zj)) == delta
                    and F["chi"](F["sub"](zi, F["conj"](zj))) == -delta):
                adj[i].add(jj)
                adj[jj].add(i)
    # symmetry group z -> a z + b, a in F_q^*, b in F_q: transitive on irrationals
    orbit = {F["add"](F["mul"]((a, 0), (0, 1)), (b, 0))
             for a in range(1, q) for b in range(q)}
    assert orbit == set(verts)
    for (a, b) in ((2 % q, 0), (1, 1)):
        m = [idx[F["add"](F["mul"]((a, 0), v), (b, 0))] for v in verts]
        for i in range(n):
            for jj in adj[i]:
                assert m[jj] in adj[m[i]]

    v0 = idx[(0, 1)]
    found = []

    def rec(clique, cand):
        if len(clique) == k:
            found.append(list(clique))
            return
        if len(clique) + len(cand) < k:
            return
        cand = set(cand)
        while cand:
            if len(clique) + len(cand) < k:
                return
            v = min(cand)
            cand.discard(v)
            rec(clique + [v], {w for w in cand if w in adj[v] and w > v})

    rec([v0], set(adj[v0]))
    out = []
    for cl in found:
        Z = [verts[i] for i in cl]
        assert is_coherent(F, Z)
        out.append(frozenset(Z))
    return out


def main():
    ok = True

    # -- positive control: the two known q = 5 four-frames (eps = 2)
    F5 = make_field(5)
    assert F5["eps"] == 2
    t5, k5, d5 = params(5)
    assert (t5, k5, d5) == (3, 4, -1)
    frame1 = [(0, 1), (1, 4), (2, 2), (4, 3)]
    frame2 = [(0, 1), (4, 4), (1, 3), (3, 2)]
    for nm, fr in (("frame1", frame1), ("frame2", frame2)):
        r = is_coherent(F5, fr)
        print("control q=5 %s coherent: %s" % (nm, r))
        ok &= r

    # -- positive control: the clique search finds exactly those two
    found5 = exhaustive(5)
    print("control q=5 coherent systems through s: %d" % len(found5))
    ok &= (set(found5) == {frozenset(frame1), frozenset(frame2)})
    print("control q=5 search recovers exactly the two known frames: %s"
          % (set(found5) == {frozenset(frame1), frozenset(frame2)}))

    # -- negative controls: deterministic non-random spoilers
    bad = [(0, 1), (1, 1), (2, 1), (3, 1)]
    r = is_coherent(F5, bad)
    print("control q=5 spoiler coherent: %s (expect False)" % r)
    ok &= (not r)

    # -- the reproduced rows
    print("%4s %5s %4s %8s %8s %14s %7s" %
          ("q", "eps", "k", "S0 ok", "S1 ok", "triples", "passes"))
    for q in (7, 11, 19, 23):
        r = orbit_sweep(q)
        s0 = r["S0_clique"] and r["S0_maximal"]
        s1 = r["S1_clique"] and r["S1_maximal"]
        print("%4d %5d %4d %8s %8s %14d %7d" %
              (r["q"], r["eps"], r["k"], s0, s1, r["triples_tested"], len(r["passes"])))
        ok &= s0 and s1 and not r["passes"]
        assert r["circle"] == q + 1 and r["q0"] == r["q1"] == (q + 1) // 2

    for q in (7, 11, 19, 23):
        n = len(exhaustive(q))
        print("exhaustive q=%d (3 mod 4) coherent systems through s: %d" % (q, n))
        ok &= (n == 0)

    # -- q = 1 mod 4: delta = -1, so Z is a clique in the complement of P(q^2).
    #    Prime q only here; the Rust run covers the prime powers 9, 25, 49, 81, 121, 125.
    for q in (13, 17, 29, 37, 41, 53):
        assert params(q)[2] == -1
        n = len(exhaustive(q))
        print("exhaustive q=%d (1 mod 4) coherent systems through s: %d" % (q, n))
        ok &= (n == 0)

    print("ALL CHECKS PASSED" if ok else "FAILURE")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
