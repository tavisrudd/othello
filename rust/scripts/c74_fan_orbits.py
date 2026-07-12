#!/usr/bin/env python3
"""C74/R2-5: label-blind PGL(2,q) five-to-six orbit incidence.

Enumerates PGL matrices, five-set orbits, six-set orbits, and the link matrix
M(A,B)=#{x notin A : A union {x} belongs to B}.  This is geometry only: it
never reads or computes game values.  Supports prime q and selected small
prime powers; extension-field elements use base-p coefficient encoding.
"""
import argparse
from collections import Counter
from itertools import combinations, product
import sys


class Field:
    def __init__(self, q):
        self.q = q
        extensions = {
            9: (3, (1, 0, 1)),       # u^2 + 1
            25: (5, (3, 0, 1)),      # u^2 + 3
            27: (3, (1, 2, 0, 1)),   # u^3 + 2u + 1
            49: (7, (1, 0, 1)),      # u^2 + 1
            121: (11, (1, 0, 1)),    # u^2 + 1
            125: (5, (1, 1, 0, 1)),  # u^3 + u + 1
            343: (7, (1, 1, 0, 1)),  # u^3 + u + 1
        }
        if q in extensions:
            self.p, self.modulus = extensions[q]
            self.degree = len(self.modulus) - 1
        else:
            self.p = q
            self.degree = 1
            self.modulus = None
            if any(q % d == 0 for d in range(2, int(q ** 0.5) + 1)):
                raise ValueError("supported: prime q or selected small prime powers")

    def digits(self, x):
        out = []
        for _ in range(self.degree):
            out.append(x % self.p)
            x //= self.p
        return out

    def encode(self, xs):
        out = 0
        for x in reversed(list(xs)):
            out = out * self.p + x % self.p
        return out

    def add(self, x, y):
        if self.degree == 1:
            return (x + y) % self.p
        return self.encode((a + b) % self.p
                           for a, b in zip(self.digits(x), self.digits(y)))

    def neg(self, x):
        if self.degree == 1:
            return (-x) % self.p
        return self.encode(-a % self.p for a in self.digits(x))

    def sub(self, x, y):
        return self.add(x, self.neg(y))

    def mul(self, x, y):
        if self.degree == 1:
            return x * y % self.p
        xd, yd = self.digits(x), self.digits(y)
        coeffs = [0] * (2 * self.degree - 1)
        for i, a in enumerate(xd):
            for j, b in enumerate(yd):
                coeffs[i + j] = (coeffs[i + j] + a * b) % self.p
        for k in range(len(coeffs) - 1, self.degree - 1, -1):
            c = coeffs[k]
            for j in range(self.degree):
                idx = k - self.degree + j
                coeffs[idx] = (coeffs[idx] - c * self.modulus[j]) % self.p
        return self.encode(coeffs[:self.degree])

    def pow(self, x, n):
        out = 1
        while n:
            if n & 1:
                out = self.mul(out, x)
            x = self.mul(x, x)
            n >>= 1
        return out

    def inv(self, x):
        assert x != 0
        y = self.pow(x, self.q - 2)
        assert self.mul(x, y) == 1
        return y


def pgl_matrices(F):
    q = F.q
    seen = set()
    for a, b, c, d in product(range(q), repeat=4):
        det = F.sub(F.mul(a, d), F.mul(b, c))
        if det == 0:
            continue
        v = (a, b, c, d)
        z = next(x for x in v if x)
        zi = F.inv(z)
        m = tuple(F.mul(x, zi) for x in v)
        seen.add(m)
    assert len(seen) == q * (q * q - 1)
    return sorted(seen)


def act(F, m, x):
    q = F.q
    a, b, c, d = m
    if x == q:  # infinity
        return q if c == 0 else F.mul(a, F.inv(c))
    den = F.add(F.mul(c, x), d)
    num = F.add(F.mul(a, x), b)
    return q if den == 0 else F.mul(num, F.inv(den))


def orbit_map(F, k, group):
    universe = set(combinations(range(F.q + 1), k))
    reps, owner, sizes, stabs = [], {}, [], []
    while universe:
        A = min(universe)
        images = [tuple(sorted(act(F, g, x) for x in A)) for g in group]
        orb = set(images)
        idx = len(reps)
        reps.append(A)
        sizes.append(len(orb))
        stabs.append(len(group) // len(orb))
        for B in orb:
            owner[B] = idx
        universe.difference_update(orb)
    return reps, owner, sizes, stabs


def normalize_pair(F, t, zero, infinity):
    """Projectivity sending zero -> 0 and infinity -> oo, evaluated at t."""
    oo = F.q
    if zero == oo:
        assert infinity != oo and t != infinity
        return 0 if t == oo else F.inv(F.sub(t, infinity))
    if infinity == oo:
        assert t != zero
        return oo if t == oo else F.sub(t, zero)
    assert zero != infinity and t != infinity
    if t == oo:
        return 1
    return F.mul(F.sub(t, zero), F.inv(F.sub(t, infinity)))


def line_pencil_summary(F, A):
    """Distribution of product-collision d over frame/candidate secants."""
    hist = Counter()
    argmin = []
    for w in range(F.q + 1):
        if w in A:
            continue
        for e in A:
            U = [normalize_pair(F, t, e, w) for t in A if t != e]
            assert len(U) == 4 and 0 not in U and F.q not in U
            products = {F.mul(a, b) for a, b in combinations(U, 2)}
            d = len(products)
            assert d >= 4
            hist[d] += 1
            argmin.append((d, e, w))
    dm = min(d for d, _, _ in argmin)
    keys = [(e, w) for d, e, w in argmin if d == dm]
    supply = sum(3 if d == 4 else 1 if d == 5 else 0
                 for d, _, _ in argmin)
    assert supply == 15
    return hist, dm, keys


def run(q, known_p):
    F = Field(q)
    group = pgl_matrices(F)
    rows, _, row_sizes, row_stabs = orbit_map(F, 5, group)
    cols, col_owner, col_sizes, col_stabs = orbit_map(F, 6, group)
    print(f"SUMMARY q={q} pgl={len(group)} rows={len(rows)} cols={len(cols)}")
    print("ROW-ORBIT-HIST", dict(sorted(Counter(row_sizes).items())))
    print("COL-STAB-HIST", dict(sorted(Counter(col_stabs).items())))
    support_hist = Counter()
    multiplicity_hist = Counter()
    row_entries = []
    for i, A in enumerate(rows):
        entries = Counter()
        xmap = []
        for x in range(q + 1):
            if x in A:
                continue
            B = col_owner[tuple(sorted((*A, x)))]
            entries[B] += 1
            xmap.append((x, B))
        assert sum(entries.values()) == q - 4
        row_entries.append(entries)
        support_hist[len(entries)] += 1
        multiplicity_hist.update(entries.values())
        print(f"ROW q={q} idx={i} A={A} orbit={row_sizes[i]} stab={row_stabs[i]} "
              f"M={dict(sorted(entries.items()))} xmap={xmap}")
        pencil_hist, dmin, pencil_keys = line_pencil_summary(F, A)
        endpoint_buckets = Counter(
            col_owner[tuple(sorted((*A, w)))] for _, w in pencil_keys)
        print(f"PENCIL q={q} row={i} d-hist={dict(sorted(pencil_hist.items()))} "
              f"dmin={dmin} ties={len(pencil_keys)} endpoint-buckets={dict(sorted(endpoint_buckets.items()))} "
              f"keys={pencil_keys}")
    print("SUPPORT-HIST", dict(sorted(support_hist.items())))
    print("ENTRY-MULTIPLICITY-HIST", dict(sorted(multiplicity_hist.items())))
    if known_p:
        lower = [sum(v for j, v in entries.items() if j in known_p)
                 for entries in row_entries]
        print(f"KNOWN-P buckets={sorted(known_p)} row-lower-bounds={lower} min={min(lower)}")
        unresolved = [i for i, n in enumerate(lower) if n == 0]
        print(f"KNOWN-P unresolved-rows={unresolved}")
    for j, B in enumerate(cols):
        print(f"COL q={q} idx={j} B={B} orbit={col_sizes[j]} stab={col_stabs[j]}")


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("q", type=int, nargs="*", default=[11, 17, 25])
    ap.add_argument("--known-p", default="",
                    help="comma-separated six-set bucket indices already known P")
    args = ap.parse_args()
    known_p = {int(x) for x in args.known_p.split(",") if x}
    for q in args.q:
        run(q, known_p)
