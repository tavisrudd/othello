import sys
import sympy as sp
from common import data, eps, B1, B2


def cubic(p):
    """Return sympy expr of F(u) = sum_i eps_i (x_i.u)^3 and the u symbols."""
    E, _, _ = data(p)
    k = p - 1
    n = 2 * p
    us = sp.symbols(f"u0:{k}")
    ep = [1] * p + [-1] * p
    F = 0
    for i in range(n):
        lin = sum(E[i][j] * us[j] for j in range(k))
        F += ep[i] * lin ** 3
    return sp.expand(F), us


def rat_mod(c, p):
    r = sp.Rational(c)
    num, den = r.p, r.q
    assert den % p != 0, f"denominator divisible by {p}: {r}"
    return (num % p) * pow(den, p - 2, p) % p


def coeffs_mod(expr, gens, p):
    poly = sp.Poly(sp.expand(expr), *gens)
    d = {}
    for mon, c in zip(poly.monoms(), poly.coeffs()):
        c = rat_mod(c, p)
        if c:
            d[mon] = c
    return d


MAIN = __name__ == "__main__"
for p, claim_txt in ((7, B1), (11, B2)) if MAIN else ():
    F, us = cubic(p)
    claim = sp.sympify(claim_txt, locals={f"u{i}": us[i] for i in range(p - 1)})
    cf = coeffs_mod(F, us, p)
    cc = coeffs_mod(claim, us, p)
    print(f"--- p={p}: computed monomials={len(cf)} claimed={len(cc)}")
    if cf == cc:
        print("  MATCH exactly (coefficient-by-coefficient)")
    else:
        onlyF = {m: v for m, v in cf.items() if cc.get(m) != v}
        onlyC = {m: v for m, v in cc.items() if cf.get(m) != v}
        print("  MISMATCH; computed-not-matching:", onlyF)
        print("           claimed-not-matching:", onlyC)
    # also record a canonical printable form of the computed polynomial
    terms = []
    for mon in sorted(cf):
        s = "*".join(f"u{i}**{e}" if e > 1 else f"u{i}"
                     for i, e in enumerate(mon) if e)
        terms.append(f"{cf[mon]}*{s}")
    print("  computed F_%d = %s" % (p, " + ".join(terms)))
