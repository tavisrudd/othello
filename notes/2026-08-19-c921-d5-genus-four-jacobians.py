#!/usr/bin/env python3
"""C921: are the genus-four D_5 curves' Jacobians powers of an elliptic curve?

If the four-dimensional factor A_b of the A_5-pencil's intermediate Jacobian were
the Jacobian of an irreducible genus-four curve C, Torelli would make C a genus-four
curve with a faithful D_5-action.  Riemann--Hurwitz leaves one branch datum for such
a curve, (2,2,5,5) over the projective line, so C is a cyclic quintic cover of the
line branched at four points carrying an involution that inverts the deck group:

    C_{m,n,t}:  y^5 = (x-1)^m (x+1)^{5-m} (x-t)^n (x+t)^{5-n},   m, n in {1,...,4}.

Up to relabelling the branch points, inverting the deck generator, and multiplying
the exponent vector by a unit modulo five, the families are (m,n) = (1,1) and (1,2).

Every A_b is isogenous to the fourth power of an elliptic curve.  So if the pencil's
factors were these Jacobians, every member of one of the two families would be
isogenous to a fourth power as well.  This script refutes that for a single member of
each family, which is enough: it counts points over F_{p^k} for k = 1..4, assembles
the degree-eight Weil polynomial, and tests whether any two Frobenius eigenvalues have
a ratio that is a root of unity.

The test is exact and needs no bound on the degree of the field over which a
hypothetical isogeny is defined.  Every Frobenius eigenvalue has absolute value
sqrt(q) under every complex embedding, so every ratio has all conjugates on the unit
circle; by Kronecker's theorem such a ratio is a root of unity exactly when it is an
algebraic integer.  A ratio alpha_i/alpha_j lies in the compositum of two fields of
degree at most eight, so a root of unity among the ratios has order m with
phi(m) <= 64, hence m <= 210.  And alpha_i/alpha_j is a root of unity of order m
exactly when the characteristic polynomial of the m-th power of Frobenius has a
repeated root.  Testing every m <= 210 therefore decides the question.

If no two eigenvalues are equivalent, the abelian fourfold is not isogenous over any
extension to a power of an elliptic curve, so neither is the Jacobian in
characteristic zero it reduces from.

Replay:

    uv run --with sympy python3 notes/2026-08-19-c921-d5-genus-four-jacobians.py \
        > notes/2026-08-19-c921-d5-genus-four-jacobians.txt
"""

import itertools
from fractions import Fraction

from sympy import Poly, factor_list, gcd, resultant, sqf_part, symbols, totient

T, X = symbols("T x")

# (prime, parameter) pairs, and the two exponent families
CASES = [(11, 3), (31, 3)]
FAMILIES = [(1, 1), (1, 2)]
RATIO_ORDER_BOUND = 210  # phi(m) <= 64 forces m <= 210


def is_irreducible(coeffs, p, k):
    """Is x^k + sum coeffs[i] x^i irreducible over F_p, for k <= 4?"""

    def evaluate(x):
        value = pow(x, k, p)
        for i, c in enumerate(coeffs):
            value = (value + c * pow(x, i, p)) % p
        return value

    if any(evaluate(x) == 0 for x in range(p)):
        return False
    if k <= 3:
        return True
    for b in range(p):
        for c in range(p):
            for d in range(p):
                for e in range(p):
                    if ((b + d) % p == coeffs[3] % p
                            and (c + e + b * d) % p == coeffs[2] % p
                            and (b * e + c * d) % p == coeffs[1] % p
                            and (c * e) % p == coeffs[0] % p):
                        return False
    return True


def find_irreducible(p, k):
    if k == 1:
        return [0]
    for tail in itertools.product(range(p), repeat=k):
        coeffs = list(tail)
        if is_irreducible(coeffs, p, k):
            return coeffs
    raise RuntimeError("no irreducible polynomial of degree %d over F_%d" % (k, p))


class Field:
    """F_{p^k}, elements as coefficient lists against a fixed irreducible modulus."""

    def __init__(self, p, k):
        self.p, self.k = p, k
        self.modulus = find_irreducible(p, k)
        self.q = p ** k
        self.one = [1] + [0] * (k - 1)
        self.zero = [0] * k

    def reduce(self, a):
        a = list(a)
        while len(a) > self.k:
            c = a.pop()
            d = len(a) - self.k
            if c:
                for i in range(self.k):
                    a[d + i] = (a[d + i] - c * self.modulus[i]) % self.p
        while len(a) < self.k:
            a.append(0)
        return [x % self.p for x in a]

    def mul(self, a, b):
        prod = [0] * (len(a) + len(b) - 1)
        for i, ai in enumerate(a):
            if ai:
                for j, bj in enumerate(b):
                    prod[i + j] = (prod[i + j] + ai * bj) % self.p
        return self.reduce(prod)

    def sub(self, a, b):
        return [(x - y) % self.p for x, y in zip(a, b)]

    def power(self, a, e):
        result, base = self.one, list(a)
        while e:
            if e & 1:
                result = self.mul(result, base)
            base = self.mul(base, base)
            e >>= 1
        return result

    def is_zero(self, a):
        return all(x == 0 for x in a)

    def constant(self, c):
        return [c % self.p] + [0] * (self.k - 1)

    def elements(self):
        for tail in itertools.product(range(self.p), repeat=self.k):
            yield list(tail)


def count_points(field, roots, exponents):
    """Points of the smooth model of y^5 = prod (x - roots_i)^{exponents_i}."""
    assert sum(exponents) % 5 == 0
    assert (field.q - 1) % 5 == 0
    test = (field.q - 1) // 5
    root_elements = [field.constant(r) for r in roots]
    total = 0
    for x in field.elements():
        value = field.one
        for r, e in zip(root_elements, exponents):
            difference = field.sub(x, r)
            if field.is_zero(difference):
                value = field.zero
                break
            value = field.mul(value, field.power(difference, e))
        if field.is_zero(value):
            total += 1
        elif field.power(value, test) == field.one:
            total += 5
    return total + 5  # the fibre over x = infinity is unramified with five points


def weil_polynomial(counts, p):
    """Degree-eight Weil polynomial from the counts over F_{p^k}, k = 1..4."""
    power_sums = [p ** k + 1 - counts[k - 1] for k in range(1, 5)]
    elementary = [Fraction(1)]
    for n in range(1, 5):
        accumulator = Fraction(0)
        for i in range(1, n + 1):
            accumulator += (-1) ** (i - 1) * elementary[n - i] * power_sums[i - 1]
        elementary.append(accumulator / n)
    head = [int(x) for x in elementary]
    for x, y in zip(head, elementary):
        assert x == y, "non-integral symmetric function"
    full = head + [head[4 - j] * p ** j for j in range(1, 5)]
    return Poly(sum((-1) ** i * full[i] * T ** (8 - i) for i in range(9)), T)


def power_polynomial(weil, m):
    """Characteristic polynomial of the m-th power of Frobenius."""
    return Poly(resultant(weil.as_expr().subs(T, X), T - X ** m, X), T)


def equivalent_eigenvalues(radical):
    """Orders m <= 210 at which two distinct eigenvalues acquire the same m-th power.

    The argument is the squarefree part of the Weil polynomial: repeated eigenvalues
    are an artefact of the isotypic splitting and say nothing about ratios."""
    found = []
    for m in range(1, RATIO_ORDER_BOUND + 1):
        if totient(m) > 64:
            continue
        candidate = power_polynomial(radical, m)
        if gcd(candidate, candidate.diff(T)).degree() > 0:
            found.append(m)
    return found


def fourth_power_witness(weil, m, q_m):
    """Is the m-th power characteristic polynomial the fourth power of a quadratic?"""
    coefficients = power_polynomial(weil, m).all_coeffs()
    if len(coefficients) != 9 or coefficients[0] != 1:
        return None
    if coefficients[1] % 4 != 0:
        return None
    a = -coefficients[1] // 4
    candidate = Poly((T ** 2 - a * T + q_m) ** 4, T).all_coeffs()
    return a if candidate == coefficients else None


def naive_first_count(p, roots, exponents):
    """#C(F_p) again, by a double loop over the prime field, independent of Field."""
    total = 0
    for x in range(p):
        value = 1
        for r, e in zip(roots, exponents):
            value = value * pow((x - r) % p, e, p) % p
        if value == 0:
            total += 1
        else:
            total += sum(1 for y in range(p) if pow(y, 5, p) == value)
    return total + 5


def invariant_report(weil, p, counts, roots, exponents):
    """Checks that a miscount would break: Weil bound, functional equation, moduli."""
    from mpmath import mp, mpf, nstr, polyroots

    mp.dps = 30
    lines = []
    naive = naive_first_count(p, roots, exponents)
    lines.append("    independent recount of #C(F_p) by a double loop: %d (%s)"
                 % (naive, "agrees" if naive == counts[0] else "DISAGREES"))
    bound_ok = all(abs(counts[k - 1] - p ** k - 1) <= 8 * mpf(p) ** (mpf(k) / 2)
                   for k in range(1, 5))
    lines.append("    Weil bound |#C(F_(p^k)) - p^k - 1| <= 8 p^(k/2): %s"
                 % ("holds" if bound_ok else "FAILS"))
    coefficients = [int(c) for c in weil.all_coeffs()]
    functional = all(coefficients[8 - i] == coefficients[i] * p ** (4 - i)
                     for i in range(5))
    lines.append("    functional equation a_(8-i) = a_i p^(4-i): %s"
                 % ("holds" if functional else "FAILS"))
    moduli = [abs(z) for z in polyroots([mpf(c) for c in coefficients], maxsteps=200,
                                        extraprec=200)]
    spread = max(abs(z - mp.sqrt(p)) for z in moduli)
    lines.append("    every root has absolute value sqrt(p): deviation %s"
                 % nstr(spread, 5))
    return lines


def main():
    print("C921: genus-four D_5 curves y^5 = (x-1)^m (x+1)^(5-m) (x-t)^n (x+t)^(5-n)")
    print("Question: is the Jacobian isogenous to the fourth power of an elliptic curve?")
    print()
    for p, t in CASES:
        for m, n in FAMILIES:
            roots = [1, p - 1, t % p, (-t) % p]
            assert len(set(roots)) == 4, "branch points collide modulo p"
            exponents = [m, 5 - m, n, 5 - n]
            counts = [count_points(Field(p, k), roots, exponents) for k in range(1, 5)]
            weil = weil_polynomial(counts, p)
            radical = Poly(sqf_part(weil.as_expr()), T)
            factors = factor_list(weil.as_expr())[1]
            orders = equivalent_eigenvalues(radical)
            witness = fourth_power_witness(weil, 1, p)
            print("p = %d, t = %d, (m,n) = (%d,%d)" % (p, t, m, n))
            print("  branch points %s with exponents %s" % (roots, exponents))
            print("  point counts over F_(p^k), k = 1..4: %s" % counts)
            print("  Weil polynomial: %s" % weil.as_expr())
            print("  factorization: %s"
                  % " * ".join("(%s)^%d" % (f, e) for f, e in factors))
            print("  distinct eigenvalues: %d" % radical.degree())
            print("  fourth power of a quadratic over the base field: %s"
                  % ("yes, a = %d" % witness if witness is not None else "no"))
            print("  orders m <= %d merging two distinct eigenvalues: %s"
                  % (RATIO_ORDER_BOUND, orders if orders else "none"))
            print("  isogenous to a power of an elliptic curve over any extension: %s"
                  % ("undecided by this test" if orders else "no"))
            print("  invariant checks:")
            for line in invariant_report(weil, p, counts, roots, exponents):
                print(line)
            print()


def check(tracked):
    """Regenerate into memory and compare with the tracked output, changing nothing."""
    import hashlib
    import io
    from contextlib import redirect_stdout

    buffer = io.StringIO()
    with redirect_stdout(buffer):
        main()
    produced = buffer.getvalue()
    with open(tracked, encoding="utf-8") as handle:
        stored = handle.read()
    digest = hashlib.sha256(produced.encode("utf-8")).hexdigest()
    if produced == stored:
        print("CHECK OK: regenerated output matches %s (sha256 %s)" % (tracked, digest))
        return 0
    print("CHECK FAILED: regenerated output differs from %s (sha256 %s)"
          % (tracked, digest))
    return 1


if __name__ == "__main__":
    import sys

    if len(sys.argv) > 1 and sys.argv[1] == "--check":
        raise SystemExit(check(sys.argv[2] if len(sys.argv) > 2
                               else "notes/2026-08-19-c921-d5-genus-four-jacobians.txt"))
    main()
