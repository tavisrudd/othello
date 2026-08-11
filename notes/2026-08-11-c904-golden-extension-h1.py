#!/usr/bin/env python3
"""Exact H^1 calculation for the golden A5 extension.

The coefficient module is the natural two-dimensional F4-module for
SL_2(F4) = A5.  We use the (2,3,5) presentation, enumerate cocycles and
coboundaries exactly, and verify that every nonzero cohomology class gives
the same nonsplit three-dimensional middle module up to isomorphism.

No external packages are used.  Run with --write to regenerate the adjacent
.out file and with --check to compare a fresh computation against it.
"""

from itertools import product
from pathlib import Path
import sys


# F4 = F2[w]/(w^2+w+1), encoded as a+b*w in the two low bits.
def add(a, b):
    return a ^ b


def mul(a, b):
    a0, a1 = a & 1, (a >> 1) & 1
    b0, b1 = b & 1, (b >> 1) & 1
    return (a0 * b0 ^ a1 * b1) | (
        (a0 * b1 ^ a1 * b0 ^ a1 * b1) << 1
    )


def inv(a):
    assert a
    return next(b for b in range(1, 4) if mul(a, b) == 1)


def smul(a, v):
    return tuple(mul(a, x) for x in v)


def vadd(u, v):
    return tuple(add(x, y) for x, y in zip(u, v))


def mm(a, b):
    n, m, r = len(a), len(b), len(b[0])
    return tuple(
        tuple(
            __import__("functools").reduce(
                add, (mul(a[i][k], b[k][j]) for k in range(m)), 0
            )
            for j in range(r)
        )
        for i in range(n)
    )


def mv(a, v):
    return tuple(
        __import__("functools").reduce(
            add, (mul(a[i][j], v[j]) for j in range(len(v))), 0
        )
        for i in range(len(a))
    )


def madd(a, b):
    return tuple(tuple(add(x, y) for x, y in zip(ra, rb))
                 for ra, rb in zip(a, b))


def ident(n):
    return tuple(tuple(int(i == j) for j in range(n)) for i in range(n))


def mpow(a, n):
    out = ident(len(a))
    for _ in range(n):
        out = mm(out, a)
    return out


def order(a):
    out = ident(len(a))
    for n in range(1, 61):
        out = mm(out, a)
        if out == ident(len(a)):
            return n
    raise AssertionError("matrix order exceeds 60")


def norm(a, n):
    out = tuple(tuple(0 for _ in range(len(a))) for _ in range(len(a)))
    power = ident(len(a))
    for _ in range(n):
        out = madd(out, power)
        power = mm(power, a)
    return out


def generated_group(gens):
    one = ident(len(gens[0]))
    seen = {one}
    frontier = [one]
    while frontier:
        x = frontier.pop()
        for g in gens:
            y = mm(x, g)
            if y not in seen:
                seen.add(y)
                frontier.append(y)
    return frozenset(seen)


def cocycle_relations(s, t, a, b):
    st = mm(s, t)
    fst = vadd(a, mv(s, b))
    return (
        mv(norm(s, 2), a) == (0, 0)
        and mv(norm(t, 3), b) == (0, 0)
        and mv(norm(st, 5), fst) == (0, 0)
    )


def coboundary(s, t, v):
    # f_v(g)=g v-v; subtraction equals addition in characteristic two.
    return vadd(mv(s, v), v), vadd(mv(t, v), v)


def extension_matrix(g, c):
    return (
        (g[0][0], g[0][1], c[0]),
        (g[1][0], g[1][1], c[1]),
        (0, 0, 1),
    )


def invariant_complements(gs, gt):
    # A complement to H in H+F4 is spanned by a unique vector (x,1).
    out = []
    for x in product(range(4), repeat=2):
        v = x + (1,)
        if mv(gs, v) == v and mv(gt, v) == v:
            out.append(v)
    return tuple(out)


def compute():
    w, w2 = 2, 3
    assert mul(w, w) == w2 and mul(w, w2) == 1

    # A spherical (2,3,5)-pair in SL_2(F4).
    s = ((1, 1), (0, 1))
    t = ((0, w), (w2, 1))
    st = mm(s, t)
    assert (order(s), order(t), order(st)) == (2, 3, 5)
    group = generated_group((s, t))
    assert len(group) == 60

    # The relation norms have ranks 1, 0, 0 on the natural module.
    ns, nt, nst = norm(s, 2), norm(t, 3), norm(st, 5)
    assert ns != ((0, 0), (0, 0))
    assert nt == ((0, 0), (0, 0))
    assert nst == ((0, 0), (0, 0))

    pairs = tuple(product(range(4), repeat=2))
    z1 = tuple((a, b) for a in pairs for b in pairs
               if cocycle_relations(s, t, a, b))
    b1 = frozenset(coboundary(s, t, v) for v in pairs)
    assert len(z1) == 4 ** 3
    assert len(b1) == 4 ** 2

    # Quotient Z^1/B^1 has four elements, hence F4-dimension one.
    unseen = set(z1)
    cosets = []
    while unseen:
        z = min(unseen)
        coset = frozenset(
            (vadd(z[0], c[0]), vadd(z[1], c[1])) for c in b1
        )
        assert len(coset) == len(b1)
        cosets.append(coset)
        unseen.difference_update(coset)
    assert len(cosets) == 4
    zero_coset = next(c for c in cosets if ((0, 0), (0, 0)) in c)
    nonzero_reps = [min(c) for c in cosets if c != zero_coset]

    # Zero class splits; every nonzero class is nonsplit.
    split_counts = []
    for a, b in [((0, 0), (0, 0))] + nonzero_reps:
        gs = extension_matrix(s, a)
        gt = extension_matrix(t, b)
        assert (order(gs), order(gt), order(mm(gs, gt))) == (2, 3, 5)
        assert len(generated_group((gs, gt))) == 60
        split_counts.append(len(invariant_complements(gs, gt)))
    assert split_counts == [1, 0, 0, 0]

    # F4^x rescales cocycles transitively on the three nonzero classes.
    def class_index(z):
        return next(i for i, c in enumerate(cosets) if z in c)

    orbit = {
        class_index((smul(c, nonzero_reps[0][0]),
                     smul(c, nonzero_reps[0][1])))
        for c in (1, w, w2)
    }
    assert len(orbit) == 3 and class_index(((0, 0), (0, 0))) not in orbit

    rows = [
        "C904 golden extension H1 calculation",
        "  coefficient module: natural H=F4^2 for SL2(F4)=A5",
        f"  presentation generators orders={(order(s), order(t), order(st))}",
        f"  generated group order={len(group)}",
        "  relation-norm ranks over F4=(1,0,0)",
        f"  |Z1|={len(z1)}=4^3",
        f"  |B1|={len(b1)}=4^2",
        f"  |H1|={len(cosets)}=4; dim_F4 H1=1",
        f"  invariant complements for zero/nonzero classes={tuple(split_counts)}",
        "  F4^x is transitive on the three nonzero extension classes",
        "  unique nonsplit middle module up to F4A5-isomorphism",
        "PASS",
    ]
    return "\n".join(rows) + "\n"


def main():
    output = compute()
    out_path = Path(__file__).with_suffix(".out")
    if len(sys.argv) == 2 and sys.argv[1] == "--write":
        out_path.write_text(output)
        print(f"wrote {out_path.name}")
    elif len(sys.argv) == 2 and sys.argv[1] == "--check":
        assert out_path.read_text() == output
        print(f"PASS {out_path.name}")
    elif len(sys.argv) == 1:
        print(output, end="")
    else:
        raise SystemExit("usage: script.py [--write|--check]")


if __name__ == "__main__":
    main()
