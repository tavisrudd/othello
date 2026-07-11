#!/usr/bin/env python3
"""Exact f=0 Frobenius-pair conic arrangement gate for prime s=5,7."""

from collections import Counter, defaultdict
from itertools import combinations, permutations


class GFp2:
    def __init__(self, p):
        self.p = p
        self.d = next(d for d in range(2, p) if pow(d, (p - 1) // 2, p) == p - 1)
        self.zero = (0, 0)
        self.one = (1, 0)

    def add(self, x, y):
        p = self.p
        return ((x[0] + y[0]) % p, (x[1] + y[1]) % p)

    def neg(self, x):
        p = self.p
        return ((-x[0]) % p, (-x[1]) % p)

    def sub(self, x, y):
        return self.add(x, self.neg(y))

    def mul(self, x, y):
        p, d = self.p, self.d
        return ((x[0] * y[0] + d * x[1] * y[1]) % p,
                (x[0] * y[1] + x[1] * y[0]) % p)

    def inv(self, x):
        p, d = self.p, self.d
        den = (x[0] * x[0] - d * x[1] * x[1]) % p
        if den == 0:
            raise ZeroDivisionError(x)
        z = pow(den, p - 2, p)
        return (x[0] * z % p, -x[1] * z % p)

    def div(self, x, y):
        return self.mul(x, self.inv(y))

    def conj(self, x):
        return (x[0], (-x[1]) % self.p)


def p1_sort_key(x):
    return (1, 0, 0) if x is None else (0, x[0], x[1])


def pgl_canonical(points, F):
    """Canonical unordered PGL(2,p^2)-orbit key via sharp 3-transitivity."""
    points = tuple(points)
    best = None
    for a, b, c in permutations(points, 3):
        scale = F.div(F.sub(c, a), F.sub(c, b))
        image = []
        for x in points:
            if x == a:
                y = None
            else:
                y = F.mul(scale, F.div(F.sub(x, b), F.sub(x, a)))
            image.append(y)
        key = tuple(sorted(image, key=p1_sort_key))
        serial = tuple(p1_sort_key(x) for x in key)
        if best is None or serial < best:
            best = serial
    return best


def closed_pairs(F):
    # One representative a+b*w for each {t,t^p}; b and -b are paired.
    p = F.p
    return [((a, b), (a, (-b) % p))
            for a in range(p) for b in range(1, (p + 1) // 2)]


def secant_fixed_subspace(t, u, F, vectors):
    # Line through (1,t,t^2),(1,u,u^2): (tu)X0-(t+u)X1+X2=0.
    h0 = F.mul(t, u)
    h1 = F.neg(F.add(t, u))
    h2 = F.one
    out = []
    for x0, x1, x2 in vectors:
        v = F.add(F.add(F.mul(h0, (x0, 0)), F.mul(h1, (x1, 0))), (x2, 0))
        if v == F.zero:
            out.append((x0, x1, x2))
    return frozenset(out)


def dim_from_size(size, p):
    d, z = 0, 1
    while z < size:
        z *= p
        d += 1
    assert z == size
    return d


def arrangement(points, F):
    p = F.p
    vectors = tuple((a, b, c) for a in range(p) for b in range(p) for c in range(p))
    V = frozenset(vectors)
    atoms = set()
    mate_planes = []
    cross_lines = []
    for t, u in combinations(points, 2):
        U = secant_fixed_subspace(t, u, F, vectors)
        atoms.add(U)
        if u == F.conj(t) or t == F.conj(u):
            mate_planes.append(U)
        else:
            cross_lines.append(U)
    assert all(1 <= dim_from_size(len(U), p) <= 2 for U in atoms)

    lattice = {V} | atoms
    changed = True
    while changed:
        changed = False
        current = tuple(lattice)
        for X, Y in combinations(current, 2):
            Z = X & Y
            if Z not in lattice:
                lattice.add(Z)
                changed = True

    # mu(V,X), processing superspaces first.
    ordered = sorted(lattice, key=len, reverse=True)
    mu = {}
    for X in ordered:
        if X == V:
            mu[X] = 1
        else:
            mu[X] = -sum(mu[Y] for Y in ordered if len(Y) > len(X) and X < Y)
    coeff = Counter()
    for X, m in mu.items():
        coeff[dim_from_size(len(X), p)] += m
    coeff = tuple(coeff.get(d, 0) for d in range(3, -1, -1))

    union = frozenset().union(*atoms)
    complement_vectors = len(V - union)
    assert complement_vectors % (p - 1) == 0
    legal = complement_vectors // (p - 1)
    eval_chi = sum(coeff[i] * p ** (3 - i) for i in range(4))
    assert eval_chi == complement_vectors
    atom_dims = Counter(dim_from_size(len(U), p) for U in atoms)
    pattern = None
    if len(mate_planes) == 3:
        assert len(set(mate_planes)) == 3
        cross_lines = set(cross_lines)
        assert len(cross_lines) == 6
        common = mate_planes[0] & mate_planes[1] & mate_planes[2]
        concurrent = len(common) == p
        assert len(common) in (1, p)
        mate_union = frozenset().union(*mate_planes)
        outside = sum(not (U <= mate_union) for U in cross_lines)
        pattern = ("concurrent" if concurrent else "triangle", outside)
    return coeff, legal, len(lattice), tuple(sorted(atom_dims.items())), pattern


def run(p):
    F = GFp2(p)
    pairs = closed_pairs(F)
    print(f"s={p} nonsquare={F.d} closed_pairs={len(pairs)}")

    e2 = Counter()
    for chosen in combinations(pairs, 2):
        pts = tuple(x for pair in chosen for x in pair)
        e2[arrangement(pts, F)] += 1
    expected = (1, -2, -1, 2)
    assert {x[0] for x in e2} == {expected}
    assert {x[1] for x in e2} == {(p - 2) * (p + 1)}
    print(f"e2 configs={sum(e2.values())} signatures={dict(e2)} check=PASS")

    by_sig = Counter()
    by_bucket = defaultdict(Counter)
    bucket_examples = {}
    examples = {}
    for chosen in combinations(pairs, 3):
        pts = tuple(x for pair in chosen for x in pair)
        sig = arrangement(pts, F)
        bucket = pgl_canonical(pts, F)
        by_sig[sig] += 1
        by_bucket[bucket][sig] += 1
        bucket_examples.setdefault((bucket, sig), tuple(pair[0] for pair in chosen))
        examples.setdefault(sig, tuple(pair[0] for pair in chosen))

    mixed = {b: c for b, c in by_bucket.items() if len(c) > 1}
    bucket_profile = Counter(tuple(sorted((sig, n) for sig, n in c.items())) for c in by_bucket.values())
    print(f"e3 configs={sum(by_sig.values())} pgl_buckets={len(by_bucket)} signatures={len(by_sig)} mixed_buckets={len(mixed)}")
    for sig, n in sorted(by_sig.items()):
        print(f"  sig coeff={sig[0]} legal={sig[1]} lattice={sig[2]} atoms={sig[3]} configs={n} example_reps={examples[sig]}")
    print("  bucket_signature_multiplicities:")
    for profile, n in sorted(bucket_profile.items(), key=repr):
        print(f"    buckets={n} profile={profile}")
    if mixed:
        b, c = next(iter(mixed.items()))
        print(f"  first_mixed_bucket={b} distribution={dict(c)}")
        for sig in c:
            print(f"    mixed_example sig={sig} reps={bucket_examples[(b, sig)]}")
    else:
        print("  bucket_determines_signature=PASS")


if __name__ == "__main__":
    run(5)
    run(7)
