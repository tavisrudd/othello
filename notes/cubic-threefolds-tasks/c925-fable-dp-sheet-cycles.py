#!/usr/bin/env python3
"""Boundary monodromy cycle types of the small-quantum spectral cover of Bl_k P^2.

Small quantum cohomology of X = Bl_k P^2 (k <= 8) in the basis
(1, L, E_1..E_k, pt).  Only curve classes beta with c_1.beta in {1,2,3}
contribute to the small product, and by adjunction plus connectedness their
genus-zero invariants are classical:

  c_1.beta = 1, beta^2 = -1  ((-1)-classes):      N^{(0)} = 1
  c_1.beta = 2, beta^2 =  0  (conic classes):      N^{(1)} = 1
  c_1.beta = 3, beta^2 =  1  (line-type classes):  N^{(2)} = 1

Product formulas (D, D' divisors; PD(beta) the class of beta in H^2):
  D * 1   = D
  D * D'  = (D.D') pt + sum_{c=1} (D.b)(D'.b) q^b PD(b) + sum_{c=2} (D.b)(D'.b) q^b 1
  D * pt  = sum_{c=2} (D.b) q^b PD(b) + sum_{c=3} (D.b) q^b 1

For an integral cocharacter b of the Novikov torus, the loop
z_j(t) = z_j t^{b_j}, t = eps e^{2 pi i theta}, is a small loop around the
boundary stratum selected by b; the eigenvalues of c_1 * are tracked around
it and the resulting permutation's cycle type is recorded.

Usage: python3 c925-fable-dp-sheet-cycles.py K BOX [SEED]
"""
import itertools
import sys

import numpy as np

TWO_PI_I = 2j * np.pi


def classes(k):
    """All beta = d L + sum m_i E_i with c_1.beta in {1,2,3} and beta^2 = c-2."""
    out = []
    dmax = 20
    for d in range(0, dmax + 1):
        for c in (1, 2, 3):
            s_target = c - 3 * d          # sum m_i
            sq_target = d * d - (c - 2)   # sum m_i^2
            if sq_target < 0:
                continue
            mmin = -int(np.sqrt(sq_target)) - 1
            mmax = 1 if d == 0 else 0

            def rec(i, s, sq, acc):
                if i == k:
                    if s == s_target and sq == sq_target:
                        out.append((d, tuple(acc), c))
                    return
                rem = k - i
                for m in range(mmin, mmax + 1):
                    s2, sq2 = s + m, sq + m * m
                    if sq2 > sq_target:
                        continue
                    # crude pruning on remaining sum range
                    lo = s2 + (rem - 1) * mmin
                    hi = s2 + (rem - 1) * mmax
                    if not (lo <= s_target <= hi):
                        continue
                    rec(i + 1, s2, sq2, acc + [m])

            rec(0, 0, 0, [])
    # effectiveness filter: d >= 0 and (d == 0 -> exactly one m_i = 1, rest 0)
    res = []
    for d, m, c in out:
        if d == 0:
            if sum(m) == 1 and all(x in (0, 1) for x in m):
                res.append((d, m, c))
        else:
            if all(x <= 0 for x in m):
                res.append((d, m, c))
    return res


def dot(D, beta):
    x, y = D
    d, m = beta
    return x * d - sum(yi * mi for yi, mi in zip(y, m))


def divisor_matrix(k, cls, D, z):
    """Matrix of D * in basis (1, L, E_1..E_k, pt); z = Novikov coordinates."""
    n = k + 3
    M = np.zeros((n, n), dtype=complex)
    x, y = D

    def h2vec(xx, yy):
        v = np.zeros(n, dtype=complex)
        v[1] = xx
        for i in range(k):
            v[2 + i] = yy[i]
        return v

    # D * 1
    M[:, 0] = h2vec(x, y)
    # precompute q^beta and D.beta
    qb = []
    for d, m, c in cls:
        q = z[0] ** d
        for i in range(k):
            q *= z[1 + i] ** m[i]
        qb.append(q)
    # D * D' for D' in {L, E_i}
    basisdivs = [(1, tuple(0 for _ in range(k)))]
    for i in range(k):
        yy = [0] * k
        yy[i] = 1
        basisdivs.append((0, tuple(yy)))
    for j, Dp in enumerate(basisdivs):
        col = np.zeros(n, dtype=complex)
        xp, yp = Dp
        # classical cup product D.D' pt
        col[n - 1] = x * xp - sum(a * b for a, b in zip(y, yp))
        for (d, m, c), q in zip(cls, qb):
            w = dot(D, (d, m)) * dot(Dp, (d, m)) * q
            if c == 1:
                col += w * h2vec(d, m)
            elif c == 2:
                col[0] += w
        M[:, 1 + j] = col
    # D * pt
    col = np.zeros(n, dtype=complex)
    for (d, m, c), q in zip(cls, qb):
        w = dot(D, (d, m)) * q
        if c == 2:
            col += w * h2vec(d, m)
        elif c == 3:
            col[0] += w
    M[:, n - 1] = col
    return M


def c1(k):
    return (3, tuple(-1 for _ in range(k)))


def track_cycle_type(k, cls, z0, b, eps=0.05, steps=400):
    """Cycle type of the eigenvalue permutation around t = eps e^{2 pi i theta}."""
    n = k + 3
    thetas = np.linspace(0.0, 1.0, steps + 1)
    prev = None
    start = None
    for th in thetas:
        t = eps * np.exp(TWO_PI_I * th)
        z = np.array([z0[j] * t ** b[j] for j in range(k + 1)], dtype=complex)
        ev = np.linalg.eigvals(divisor_matrix(k, cls, c1(k), z))
        if prev is None:
            start = ev.copy()
            order = np.arange(n)
        else:
            # nearest-neighbour matching with a uniqueness check
            dist = np.abs(prev[:, None] - ev[None, :])
            perm = dist.argmin(axis=1)
            if len(set(perm)) != n:
                return None  # ambiguous; caller refines
            # bijectivity of nearest-neighbour matching is the only local
            # check; global reliability comes from agreement across step
            # counts and radii in the caller
            ev = ev[perm]
        prev = ev
    # final permutation: start[i] -> prev[i]; match prev back to start
    dist = np.abs(start[:, None] - prev[None, :])
    perm = dist.argmin(axis=1)
    if len(set(perm)) != n:
        return None
    seen = [False] * n
    cyc = []
    for i in range(n):
        if not seen[i]:
            l, j = 0, i
            while not seen[j]:
                seen[j] = True
                j = perm[j]
                l += 1
            cyc.append(l)
    return tuple(sorted(cyc, reverse=True))


def main():
    k = int(sys.argv[1])
    box = int(sys.argv[2])
    seed = int(sys.argv[3]) if len(sys.argv) > 3 else 1
    rng = np.random.default_rng(seed)
    cls = classes(k)
    counts = {c: sum(1 for _, _, cc in cls if cc == c) for c in (1, 2, 3)}
    print(f"k={k} classes: (-1)={counts[1]} conic={counts[2]} line={counts[3]}")
    z0 = np.exp(TWO_PI_I * rng.random(k + 1)) * (0.7 + 0.6 * rng.random(k + 1))
    # commutativity sanity
    zt = z0 * 0.3
    A = divisor_matrix(k, cls, (1, tuple(0 for _ in range(k))), zt)
    yy = [0] * k
    yy[0] = 1
    B = divisor_matrix(k, cls, (0, tuple(yy)), zt)
    print("commutator norm L*,E1*:", np.linalg.norm(A @ B - B @ A))
    seen = {}
    primes_hit = set()
    for b in itertools.product(range(-box, box + 1), repeat=k + 1):
        if all(x == 0 for x in b):
            continue
        # two independent small radii must agree; no large-radius fallback,
        # since a larger circle can cross the discriminant locus
        results = []
        for eps in (1e-2, 3e-3):
            for steps in (3200, 12800):
                results.append(track_cycle_type(k, cls, z0, b, eps=eps, steps=steps))
        ct = results[0] if (results[0] is not None and all(r == results[0] for r in results)) else None
        key = ct if ct is not None else "unresolved"
        seen.setdefault(key, []).append(b)
        if ct is not None:
            for l in ct:
                if l in (5, 7, 11):
                    primes_hit.add((l, b))
    print("cycle types observed (count, first witness):")
    for key, bs in sorted(seen.items(), key=lambda kv: str(kv[0])):
        print(f"  {key}: {len(bs)} e.g. {bs[0]}")
    print("prime cycles >=5:", sorted(primes_hit)[:10] if primes_hit else "none")


if __name__ == "__main__":
    main()
