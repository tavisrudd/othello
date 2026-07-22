#!/usr/bin/env python3
"""Independent exact replay for C459 (no imports from the primary or C442)."""
from __future__ import annotations

import json
from fractions import Fraction as F
from itertools import permutations
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


def cross(v, w):
    return (
        sub(mul(v[1], w[2]), mul(v[2], w[1])),
        sub(mul(v[2], w[0]), mul(v[0], w[2])),
        sub(mul(v[0], w[1]), mul(v[1], w[0])),
    )


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
    Ys = sorted(Y); yi = {v: i for i, v in enumerate(Ys)}
    sp = tuple(yi[normv(tuple(sig(x) for x in v))] for v in Ys)
    pairs = sorted({tuple(sorted((i, sp[i]))) for i in range(6)})
    assert len(pairs) == 3
    secants = [normv(cross(Ys[i], Ys[j])) for i, j in pairs]
    assert set(secants) == {(Z, O, neg(O)), (Z, O, Z), (Z, O, O)}
    assert {normv(cross(secants[i], secants[j])) for i in range(3) for j in range(i + 1, 3)} == {(O, Z, Z)}
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
    point_perms = {tuple(yi[normv(mv(A, v))] for v in Ys) for A in rational}
    point_orbits = []
    unseen = set(range(6))
    while unseen:
        i = min(unseen); orbit = {p[i] for p in point_perms}
        point_orbits.append(orbit); unseen -= orbit
    assert sorted(len(o) for o in point_orbits) == [3, 3]
    assert {sp[i] for i in point_orbits[0]} == point_orbits[1]
    pi = {pair: i for i, pair in enumerate(pairs)}
    pair_perms = {
        tuple(pi[tuple(sorted((p[i], p[j])))] for i, j in pairs) for p in point_perms
    }
    assert pair_perms == set(permutations(range(3)))
    pole = (O, Z, Z)
    assert all(normv(mv(A, pole)) == pole for A in rational)
    line_x = (O, Z, (F(-3), F(0)))
    line_y = (Z, O, Z)
    assert dot(line_x, mv(gram, line_x)) == (F(15), F(0))
    assert dot(line_y, mv(gram, line_y)) == (F(5), F(0))
    assert dot(line_x, mv(gram, line_y)) == Z

    def compose(p, q): return tuple(p[q[i]] for i in range(5))
    def parity(p): return sum(p[i] > p[j] for i in range(5) for j in range(i + 1, 5)) % 2
    S5 = list(permutations(range(5)))
    A5p = [p for p in S5 if parity(p) == 0]
    odd_inv = [p for p in S5 if parity(p) == 1 and compose(p, p) == tuple(range(5))]
    even_inv = [p for p in A5p if compose(p, p) == tuple(range(5))]
    assert (len(A5p), len(odd_inv), len(even_inv)) == (60, 10, 16)
    t = odd_inv[0]; d = next(p for p in even_inv if p != tuple(range(5)))
    assert sum(compose(a, t) == compose(t, a) for a in A5p) == 6
    assert sum(compose(a, d) == compose(d, a) for a in A5p) == 4

    assert cert["enumeration"]["transporter_count"] == len(T)
    assert cert["enumeration"]["projective_cocycle_count"] == len(D)
    assert cert["enumeration"]["gauge_orbit_sizes"] == orbit_sizes
    assert cert["rational_stabilizer"]["element_order_distribution"] == [1, 2, 2, 2, 3, 3]
    assert cert["representative"]["descended_conic_gram"] == [["3", "0", "1"], ["0", "5", "0"], ["1", "0", "2"]]
    assert cert["classification"]["quadratic_A5_descent_taxonomy"]["quadratic_split_rational_symmetry_types"] == ["A5", "V4", "S3"]
    assert cert["classification"]["intrinsic_golden_quotient"]["degree_6_etale_algebra"] == "Q(phi)^3"
    assert [t for t in range(11) if (t*t-t-1) % 11 == 0] == [4, 8]
    units = [r for r in range(1, 40, 2) if r % 5]
    split = [r for r in units if r % 5 in (1, 4)]
    assert [r for r in split if r % 8 in (3, 5)] == [11, 19, 21, 29]
    assert [r for r in split if r % 8 in (1, 7)] == [1, 9, 31, 39]
    def red5(x):
        return (x[0].numerator * pow(x[0].denominator, -1, 5)
                + 3*x[1].numerator * pow(x[1].denominator, -1, 5)) % 5
    def pn5(v):
        a = next(x for x in v if x); ai = pow(a, -1, 5)
        return tuple(x*ai % 5 for x in v)
    support = sorted({pn5(tuple(red5(x) for x in v)) for v in Y})
    assert support == [(1, 0, 2), (1, 2, 2), (1, 3, 2)]
    assert cert["classification"]["characteristic_5_degeneration"]["conic_equation"] == "2*(z-2*x)^2=0"
    print("PASS C459 replay: independent Q(phi) arithmetic reproduces the unique S3 descent")


if __name__ == "__main__":
    main()
