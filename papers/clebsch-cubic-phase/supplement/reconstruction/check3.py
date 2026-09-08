import sys
import sympy as sp
from check2 import cubic, coeffs_mod

# ---------- p = 7 ----------
p = 7
F7, u7 = cubic(7)
a, b, c, d, e, s = sp.symbols("a b c d e s")
sub7 = {u7[0]: a, u7[1]: b, u7[2]: s + c, u7[3]: 3 * s + c, u7[4]: d,
        u7[5]: e}
lhs7 = sp.expand(F7.subs(sub7, simultaneous=True))
I = a * e - 4 * b * d + 3 * c ** 2
J = sp.Matrix([[a, b, c], [b, c, d], [c, d, e]]).det()
Jexp = a * c * e + 2 * b * c * d - a * d ** 2 - b ** 2 * e - c ** 3
print("p=7: J determinant equals stated expansion:",
      sp.expand(J - Jexp) == 0)
rhs7 = sp.expand(4 * s * I + 3 * J)
gens7 = (a, b, c, d, e, s)
c1 = coeffs_mod(lhs7, gens7, 7)
c2 = coeffs_mod(rhs7, gens7, 7)
print("p=7: F_7(sub) == 4 s I + 3 J mod 7 :", c1 == c2)
if c1 != c2:
    print("   diff:", {k: (c1.get(k), c2.get(k))
                       for k in set(c1) | set(c2) if c1.get(k) != c2.get(k)})

# ---------- p = 11 ----------
F11, u11 = cubic(11)
z = sp.symbols("z0:9")
S11 = sp.Symbol("s")
sub11 = {u11[0]: z[0], u11[1]: z[1], u11[2]: 7 * z[2], u11[3]: 6 * z[3],
         u11[4]: 3 * S11 + 6 * z[4], u11[5]: S11 + 3 * z[4],
         u11[6]: 6 * z[5], u11[7]: 7 * z[6], u11[8]: z[7], u11[9]: z[8]}
lhs11 = sp.expand(F11.subs(sub11, simultaneous=True))
I2 = 2 * z[0] * z[8] + 6 * z[1] * z[7] + z[2] * z[6] + 9 * z[3] * z[5] \
     + 4 * z[4] ** 2
I3 = (6 * z[0] * z[4] * z[8] + 9 * z[0] * z[5] * z[7] + 7 * z[0] * z[6] ** 2
      + 9 * z[1] * z[3] * z[8] + 6 * z[1] * z[4] * z[7] + 7 * z[1] * z[5] * z[6]
      + 7 * z[2] ** 2 * z[8] + 7 * z[2] * z[3] * z[7] + z[2] * z[5] ** 2
      + z[3] ** 2 * z[6] + 4 * z[3] * z[4] * z[5] + 2 * z[4] ** 3)
rhs11 = sp.expand(4 * S11 * I2 + 2 * I3)
gens11 = tuple(z) + (S11,)
d1 = coeffs_mod(lhs11, gens11, 11)
d2 = coeffs_mod(rhs11, gens11, 11)
print("p=11: F_11(sub) == 4 s I2 + 2 I3 mod 11 :", d1 == d2)
if d1 != d2:
    print("   diff:", {k: (d1.get(k), d2.get(k))
                       for k in set(d1) | set(d2) if d1.get(k) != d2.get(k)})

# ---------- transvectants ----------
S, T = sp.symbols("S T")
f = sum(sp.binomial(8, i) * z[i] * S ** (8 - i) * T ** i for i in range(9))
f = sp.expand(f)


def transvect(F, G, r, m, n, normalize=True):
    tot = 0
    for j in range(r + 1):
        dF = sp.diff(F, S, r - j, T, j)
        dG = sp.diff(G, S, j, T, r - j)
        tot += (-1) ** j * sp.binomial(r, j) * dF * dG
    tot = sp.expand(tot)
    if normalize:
        tot = tot * sp.Rational(sp.factorial(m - r) * sp.factorial(n - r),
                                sp.factorial(m) * sp.factorial(n))
    return sp.expand(tot)


def mod11_poly(expr):
    return coeffs_mod(expr, tuple(z), 11)


def compare(name, got, target):
    g = mod11_poly(got)
    t = mod11_poly(target)
    if g == t:
        return f"{name}: EQUAL mod 11"
    # try scalar multiple
    for lam in range(1, 11):
        if {k: (lam * v) % 11 for k, v in g.items() if (lam * v) % 11} == t:
            return f"{name}: equal after multiplying computed by {lam} mod 11"
    if not g:
        return f"{name}: computed is IDENTICALLY ZERO mod 11"
    return f"{name}: DIFFERS; computed={g}\n     target={t}"


ff8_n = transvect(f, f, 8, 8, 8, True)
ff8_u = transvect(f, f, 8, 8, 8, False)
print(compare("I2 vs (f,f)_8 normalized", ff8_n, I2))
print(compare("I2 vs (f,f)_8 unnormalized", ff8_u, I2))

ff4_n = transvect(f, f, 4, 8, 8, True)
ff4_u = transvect(f, f, 4, 8, 8, False)
i3_nn = transvect(ff4_n, f, 8, 8, 8, True)
i3_uu = transvect(ff4_u, f, 8, 8, 8, False)
i3_un = transvect(ff4_u, f, 8, 8, 8, True)
print(compare("I3 vs ((f,f)_4,f)_8 both normalized", i3_nn, I3))
print(compare("I3 vs ((f,f)_4,f)_8 both unnormalized", i3_uu, I3))
print(compare("I3 vs unnorm inner + norm outer", i3_un, I3))
