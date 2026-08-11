#!/usr/bin/env python3
"""Exact GRR audit for the charge-three cubic-threefold moduli space.

The coefficient ring is Q[h,eps]/(h^4,eps^2).  Here h is the cubic
hyperplane class, integral h^3=3, and eps is the point class on a test
curve contained in one Abel--Jacobi fibre.
"""

from math import comb, gcd

import sympy as sp


h, eps, delta, eta, t = sp.symbols("h eps delta eta t")


def trunc(poly):
    """Reduce modulo (h^4, eps^2)."""
    out = 0
    for term in sp.Poly(sp.expand(poly), h, eps).terms():
        (ih, ie), coeff = term
        if ih <= 3 and ie <= 1:
            out += coeff * h**ih * eps**ie
    return sp.expand(out)


def exp_h(k):
    return sum(k**i * h**i / sp.factorial(i) for i in range(4))


def integrate(poly):
    """Integrate on X times the test curve: integral_X h^3=3."""
    return sp.expand(poly).coeff(h, 3).coeff(eps, 1) * 3


td = 1 + h + sp.Rational(2, 3) * h**2 + sp.Rational(1, 3) * h**3

# A normalized charge-three bundle F has c1=0 and c2=h^2=3[line].
chF = 2 - h**2

# On X times a curve C in one AJ fibre, write
# c1(U)=delta*eps and c2(U)=h^2+eta*h*eps.  The universal object is rank 2,
# hence has no higher Chern classes.  Expand its Chern character exactly.
c1 = delta * eps
c2 = h**2 + eta * h * eps
chU = trunc(
    2
    + c1
    + (c1**2 - 2 * c2) / 2
    + (c1**3 - 3 * c1 * c2) / 6
    + (c1**4 - 4 * c1**2 * c2 + 2 * c2**2) / 24
)

# Hilbert polynomial and determinant-of-cohomology degrees.
hilbert = sp.expand(3 * sp.expand(chF * exp_h(t) * td).coeff(h, 3))
lambda_t_degree = sp.factor(integrate(trunc(chU * exp_h(t) * td)))

# The canonical line is det Rp_* REnd(U).  For rank 2,
# ch End(U)=4+D^2+D^4/12, D^2=c1(U)^2-4c2(U).
D2 = trunc(c1**2 - 4 * c2)
chEnd = trunc(4 + D2 + D2**2 / 12)
canonical_degree = sp.factor(integrate(trunc(chEnd * td)))

# Integral numerical K-basis O_X, O_H, O_L, O_p.
ch_basis = [
    1,
    trunc(1 - exp_h(-1)),
    h**2 / 3,
    h**3 / 3,
]
basis_names = ["O_X", "O_H", "O_L", "O_p"]


def integrate_X(poly):
    return sp.expand(poly).coeff(h, 3) * 3


euler_basis = sp.Matrix(
    [
        [integrate_X(sp.expand(x).subs(h, -h) * y * td) for y in ch_basis]
        for x in ch_basis
    ]
)
weights = []
degrees = []
for chu in ch_basis:
    weights.append(sp.expand(3 * sp.expand(chF * chu * td).coeff(h, 3)))
    degrees.append(sp.factor(integrate(trunc(chU * chu * td))))

# The intrinsic class u=O_L-O_p has Euler weight zero and degree -eta.
intrinsic_weight = sp.expand(weights[2] - weights[3])
intrinsic_degree = sp.factor(degrees[2] - degrees[3])

# Projection check: beta=[I_L] has ch=1-h^2/3, while pr_Ku(F) has
# [F]-chi(O,F)[O]=[F]+[O]=3 beta.  Its Euler square is -9.
ch_beta = 1 - h**2 / 3
beta_square = sp.expand(3 * sp.expand(ch_beta**2 * td).coeff(h, 3))
projected_euler_square = 9 * beta_square

# Independent integer checks: the closed binomial Hilbert formula and the
# determinant-weight kernel on the displayed integral basis.
def hilbert_binomial(n):
    # Polynomial binomial values are needed at negative n as well.
    b1 = sp.binomial(n + 4, 4)
    b2 = sp.binomial(n + 1, 4)
    return sp.expand(2 * (b1 - b2) - 3 * (n + 1))


for n in range(-1, 7):
    assert sp.expand(hilbert.subs(t, n) - hilbert_binomial(n)) == 0
assert hilbert == t**3 + 3 * t**2 + t - 1
assert sp.simplify(
    lambda_t_degree - (delta * hilbert - 3 * eta * (t + 1) ** 2) / 2
) == 0
assert canonical_degree == 0
assert weights == [-1, -1, 2, 2]
assert intrinsic_weight == 0
assert intrinsic_degree == -eta
assert beta_square == -1
assert projected_euler_square == -9
assert gcd(*[abs(int(x)) for x in weights]) == 1
assert euler_basis.det() == 1

print("schema=c904-m9-determinant-grr-v1")
print(f"hilbert={hilbert}")
print(f"determinant_degree_Ot={lambda_t_degree}")
print(f"canonical_degree_on_AJ_curve={canonical_degree}")
for name, weight, degree in zip(basis_names, weights, degrees):
    print(f"basis={name}; weight={weight}; degree={degree}")
print(f"intrinsic=O_L-O_p; weight={intrinsic_weight}; degree={intrinsic_degree}")
print(f"beta_euler_square={beta_square}")
print(f"projected_3beta_euler_square={projected_euler_square}")
print(f"basis_euler_det={euler_basis.det()}")
print("independent_checks=PASS")
