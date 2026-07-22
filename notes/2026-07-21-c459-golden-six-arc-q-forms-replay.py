#!/usr/bin/env python3
"""Independent exact replay for C459 (no imports from the primary or C442)."""
from __future__ import annotations

import json
from fractions import Fraction as F
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE / "2026-07-21-c459-golden-six-arc-q-forms.json"

Z = (F(0), F(0))
O = (F(1), F(0))
P = (F(0), F(1))
PB = (F(1), F(-1))


def add(x, y): return (x[0] + y[0], x[1] + y[1])
def neg(x): return (-x[0], -x[1])
def sub(x, y): return add(x, neg(y))
def mul(x, y): return (x[0]*y[0] + x[1]*y[1], x[0]*y[1] + x[1]*y[0] + x[1]*y[1])
def sig(x): return (x[0] + x[1], -x[1])


def inv(x):
    n = x[0]*x[0] + x[0]*x[1] - x[1]*x[1]
    assert n
    sx = sig(x)
    return (sx[0]/n, sx[1]/n)


def dot(x, y):
    out = Z
    for a, b in zip(x, y): out = add(out, mul(a, b))
    return out


def mv(A, x): return tuple(dot(row, x) for row in A)


def mm(A, B):
    Bt = tuple(zip(*B))
    return tuple(tuple(dot(row, col) for col in Bt) for row in A)


def smul(c, x): return tuple(mul(c, a) for a in x)


def normv(x):
    pivot = next(a for a in x if a != Z)
    return smul(inv(pivot), x)


def normm(A):
    pivot = next(a for row in A for a in row if a != Z)
    c = inv(pivot)
    return tuple(tuple(mul(c, a) for a in row) for row in A)


def sigma_matrix(A): return tuple(tuple(sig(x) for x in row) for row in A)


def transpose(A): return tuple(tuple(x for x in row) for row in zip(*A))


def inv3(A):
    a, b, c = A[0]; d, e, f = A[1]; g, h, i = A[2]
    C = (
        (sub(mul(e, i), mul(f, h)), sub(mul(c, h), mul(b, i)), sub(mul(b, f), mul(c, e))),
        (sub(mul(f, g), mul(d, i)), sub(mul(a, i), mul(c, g)), sub(mul(c, d), mul(a, f))),
        (sub(mul(d, h), mul(e, g)), sub(mul(b, g), mul(a, h)), sub(mul(a, e), mul(b, d))),
    )
    det = add(add(mul(a, C[0][0]), mul(b, C[1][0])), mul(c, C[2][0]))
    return tuple(tuple(mul(inv(det), C[r][s]) for s in range(3)) for r in range(3))


I = ((O, Z, Z), (Z, O, Z), (Z, Z, O))


def refl(v):
    c = mul((F(2), F(0)), inv(dot(v, v)))
    return tuple(tuple(sub(O if i == j else Z, mul(mul(c, v[i]), v[j])) for j in range(3)) for i in range(3))


def roots(tau):
    tm1 = sub(tau, O)
    out = {(O, Z, Z), (Z, O, Z), (Z, Z, O)}
    for s1 in (1, -1):
        for s2 in (1, -1):
            a = (O, (s1*tau[0], s1*tau[1]), (s2*tm1[0], s2*tm1[1]))
            for off in range(3): out.add(normv(a[off:] + a[:off]))
    assert len(out) == 15
    return out


def six(tau):
    tm1 = sub(tau, O)
    return frozenset(normv(v) for v in (
        (Z, O, neg(tm1)), (Z, O, tm1), (O, neg(tm1), Z),
        (O, tm1, Z), (O, Z, neg(tau)), (O, Z, tau),
    ))


def closure(gens):
    group = {normm(I)}
    frontier = [normm(I)]
    while frontier:
        a = frontier.pop()
        for g in gens:
            b = normm(mm(a, g))
            if b not in group:
                group.add(b); frontier.append(b)
        assert len(group) <= 60
    return group


def order(A):
    x = normm(I)
    for n in range(1, 31):
        x = normm(mm(x, A))
        if x == normm(I): return n
    raise AssertionError


def main():
    cert = json.loads(CERT.read_text())
    S, Sc = six(P), six(PB)
    A5 = closure([normm(refl(v)) for v in roots(P)])
    assert len(A5) == 60
    u = ((Z, Z, O), (Z, neg(O), Z), (O, Z, Z))
    assert frozenset(normv(mv(u, v)) for v in Sc) == S
    assert mm(u, sigma_matrix(u)) == I
    T = {normm(mm(a, u)) for a in A5}
    D = {x for x in T if normm(mm(x, sigma_matrix(x))) == normm(I)}
    assert (len(T), len(D)) == (60, 10)
    unseen = set(D); orbit_sizes = []
    while unseen:
        x = next(iter(unseen))
        orb = {normm(mm(mm(a, x), inv3(sigma_matrix(a)))) for a in A5}
        assert orb <= D
        orbit_sizes.append(len(orb)); unseen -= orb
    assert orbit_sizes == [10]

    sqrt5 = sub(mul((F(2), F(0)), P), O)
    h = ((P, Z, O), (Z, sqrt5, Z), (sub(O, P), Z, O))
    hi = inv3(h)
    assert h == mm(u, sigma_matrix(h))
    Y = frozenset(normv(mv(hi, v)) for v in S)
    assert frozenset(normv(tuple(sig(x) for x in v)) for v in Y) == Y
    gram = mm(transpose(h), h)
    assert gram == (((F(3), F(0)), Z, O), (Z, (F(5), F(0)), Z), (O, Z, (F(2), F(0))))
    lines = frozenset(normv(mv(gram, y)) for y in Y)
    assert len(lines) == 6
    assert frozenset(normv(tuple(sig(x) for x in ell)) for ell in lines) == lines

    fixed = {a for a in A5 if normm(mm(mm(u, sigma_matrix(a)), inv3(u))) == a}
    rational = {normm(mm(mm(hi, a), h)) for a in fixed}
    assert len(rational) == 6
    assert all(x[1] == 0 for A in rational for row in A for x in row)
    assert sorted(order(A) for A in rational) == [1, 2, 2, 2, 3, 3]

    assert cert["enumeration"]["transporter_count"] == len(T)
    assert cert["enumeration"]["projective_cocycle_count"] == len(D)
    assert cert["enumeration"]["gauge_orbit_sizes"] == orbit_sizes
    assert cert["rational_stabilizer"]["element_order_distribution"] == [1, 2, 2, 2, 3, 3]
    assert cert["representative"]["descended_conic_gram"] == [["3", "0", "1"], ["0", "5", "0"], ["1", "0", "2"]]
    print("PASS C459 replay: independent Q(phi) arithmetic reproduces the unique S3 descent")


if __name__ == "__main__":
    main()
