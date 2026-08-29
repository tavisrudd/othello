#!/usr/bin/env python3
"""Independent re-verification of the GF(27) certificate witnesses.

Reads 2026-08-28-r11-gf27-certify-witness-sample.tsv, which the Rust `certify`
mode writes (as out/certify-witness-sample.tsv) for a
seeded sample of carrier classes.  Each row gives a syndrome z = (z2,...,z8) and
the nine-point set S that the sweep claims closes it.  This script re-derives
GF(27) from scratch, rebuilds the monic locator from S, and checks

  * S has exactly nine distinct elements of K,
  * g(t) = prod_{s in S} (t - s) is monic of degree nine,
  * both Hankel equations hold: sum_{i=2}^{8} z_i g_{i-1} = 0
                                sum_{i=2}^{8} z_i g_i     = 0,
  * every s in S is a root of g (independent of the coefficient construction).

It shares no code with the Rust program.  Exit status 0 iff every row passes.

Usage:  python3 verify_witnesses.py [path/to/certify-witness-sample.tsv]
"""

import os
import sys

# ---------------------------------------------------------------- GF(27) ----
# K = F3[x]/(x^3 - x - 1); element n = d0 + 3*d1 + 9*d2 <-> d0 + d1 x + d2 x^2.


def digits(a):
    return (a % 3, (a // 3) % 3, (a // 9) % 3)


def undigits(d):
    return d[0] % 3 + 3 * (d[1] % 3) + 9 * (d[2] % 3)


def add(a, b):
    x, y = digits(a), digits(b)
    return undigits((x[0] + y[0], x[1] + y[1], x[2] + y[2]))


def neg(a):
    x = digits(a)
    return undigits((-x[0], -x[1], -x[2]))


def sub(a, b):
    return add(a, neg(b))


def mul(a, b):
    x, y = digits(a), digits(b)
    c = [0] * 5
    for i in range(3):
        for j in range(3):
            c[i + j] = (c[i + j] + x[i] * y[j]) % 3
    # x^3 = x + 1, x^4 = x^2 + x
    return undigits(((c[0] + c[3]) % 3, (c[1] + c[3] + c[4]) % 3, (c[2] + c[4]) % 3))


def check_field():
    """The cubic must be irreducible and the ring must be a field."""
    for a in range(3):
        if (mul(mul(a, a), a) - a - 1) % 3 == 0 and a < 3:
            # x^3 - x - 1 evaluated at the three elements of F3
            pass
    for a in range(3):
        v = (a * a * a - a - 1) % 3
        assert v != 0, "x^3 - x - 1 is reducible over F3"
    for a in range(1, 27):
        assert any(mul(a, b) == 1 for b in range(1, 27)), "not a field: %d has no inverse" % a


def poly_from_roots(roots):
    """Monic polynomial with the given roots; coefficients low -> high."""
    p = [1]
    for r in roots:
        q = [0] * (len(p) + 1)
        for i, c in enumerate(p):
            q[i + 1] = add(q[i + 1], c)
            q[i] = sub(q[i], mul(c, r))
        p = q
    return p


def poly_eval(p, x):
    s = 0
    for c in reversed(p):
        s = add(mul(s, x), c)
    return s


# ------------------------------------------------------------------ main ----


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    default = os.path.join(here, "2026-08-28-r11-gf27-certify-witness-sample.tsv")
    path = sys.argv[1] if len(sys.argv) > 1 else default
    check_field()

    total = 0
    bad = []
    with open(path) as fh:
        header = fh.readline().rstrip("\n").split("\t")
        assert header[0].startswith("z2"), "unexpected header: %r" % header
        for line in fh:
            line = line.rstrip("\n")
            if not line:
                continue
            fields = line.split("\t")
            z = [int(v) for v in fields[0].split(",")]
            nine = [int(v) for v in fields[2].split(",")]
            total += 1
            why = []
            if len(z) != 7 or any(v < 0 or v > 26 for v in z):
                why.append("bad syndrome")
            if all(v == 0 for v in z):
                why.append("zero syndrome")
            if len(nine) != 9:
                why.append("locator support has %d points" % len(nine))
            if len(set(nine)) != len(nine):
                why.append("repeated root")
            if any(v < 0 or v > 26 for v in nine):
                why.append("root outside K")
            if not why:
                g = poly_from_roots(nine)
                if len(g) != 10 or g[9] != 1:
                    why.append("locator is not monic of degree nine")
                # sum_{i=2}^{8} z_i g_{i-1} and sum_{i=2}^{8} z_i g_i
                e1 = 0
                e2 = 0
                for k in range(7):  # z[k] = z_{k+2}
                    e1 = add(e1, mul(z[k], g[k + 1]))
                    e2 = add(e2, mul(z[k], g[k + 2]))
                if e1 != 0:
                    why.append("first Hankel equation = %d" % e1)
                if e2 != 0:
                    why.append("second Hankel equation = %d" % e2)
                for s in nine:
                    if poly_eval(g, s) != 0:
                        why.append("%d is not a root of the rebuilt locator" % s)
                        break
            if why:
                bad.append((fields[0], fields[2], "; ".join(why)))

    print("witness rows checked: %d" % total)
    print("rows failing: %d" % len(bad))
    for z, s, why in bad[:20]:
        print("  FAIL z=%s S=%s : %s" % (z, s, why))
    if total == 0:
        print("nothing to check")
        return 1
    if bad:
        return 1
    print("all witnesses verified: nine distinct roots in GF(27) and both Hankel equations hold")
    return 0


if __name__ == "__main__":
    sys.exit(main())
