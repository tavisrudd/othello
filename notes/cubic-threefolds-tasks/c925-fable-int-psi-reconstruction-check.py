#!/usr/bin/env python3
"""C925: exact certificate for the integral Birkhoff factorization step of
the (INT-Psi) reconstruction proof
(notes/2026-08-23-c925-fable-int-psi-reconstruction.md).

leg A (integral Birkhoff lifting, triangular reduction, base-row identity).
  Over Q[eps] (eps plays q^{-1/s}), build a 3 x 3 loop B = Nbar Pbar (1 +
  eps D1 + eps^2 D2) whose reduction Nbar Pbar is block-lower-triangular
  with (1,1)-block of the form id + O(z^{-1}) and z-free lower-right
  constant -- the shape of the reduced reconstruction loop
  Ebar''^{-1} Mbar -- and whose eps-corrections D1, D2 are full matrices
  (triangularity broken at every positive order).  Run the m-adic lifting
  recursion: mu_k + phi_k = beta_k - sum mu_i phi_j, split by z-sign.
  Verify exactly through a declared eps-adic precision: (i) the recursion
  gives N P = B modulo eps^NE with no truncation in z and no division
  (all retained entries stay polynomial in eps);
  (ii) N - id has strictly negative z-support and P has non-negative
  z-support; (iii) the reductions are Nbar, Pbar; (iv) the positive
  factor's base row-block is (unit block, 0) at eps = 0 -- the mechanism
  that gives Psi's base row reduction (I, 0) on pullback columns.

leg B (the sharp residual).  For a genus-zero curve centre with normal
  bundle O(-1) + O(-1) in a threefold (r = 2), Iritani's ring extension
  (5.40) sends Q_Z^d to Q^{i_* d} q^{- rho_Z . d / (r-1)} with
  rho_Z . [C] = deg N = -2, i.e. q^{+2} Q^{i_* C}: a POSITIVE q-power.
  The P^1 J-function's Q_Z-linear coefficient 1/(H+z)^2 = z^{-2} - 2 H
  z^{-3} is nonzero, so M's centre block genuinely contains that monomial.
  Thus the whole-loop integral-input hypothesis used in leg A is not
  automatic at flopping-type rational centres; deciding the base row still
  requires a sharper filtered argument or an actual countercalculation.

Replay:
    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-int-psi-reconstruction-check.py
"""

import argparse
import json
from pathlib import Path

import sympy as sp

eps = sp.symbols("eps")
NE = 5  # eps-orders kept: 0..NE-1

# Loops are dicts {z_power: 3x3 sympy Matrix over Q[eps]}; all operations
# are exact (finite supports, no truncation in z).


def lmul(a, b):
    out = {}
    for p, m in a.items():
        for q_, n in b.items():
            out[p + q_] = out.get(p + q_, sp.zeros(3)) + m * n
    return {p: sp.expand(m) for p, m in out.items()
            if m != sp.zeros(3) or p == 0}


def ladd(a, b, sgn=1):
    out = dict(a)
    for p, m in b.items():
        out[p] = out.get(p, sp.zeros(3)) + sgn * m
    return {p: sp.expand(m) for p, m in out.items()}


def eps_coeff(a, k):
    return {p: sp.expand(m.applyfunc(lambda x: sp.Poly(x, eps).coeff_monomial(eps**k)
                                     if x != 0 else 0))
            for p, m in a.items()}


def zsplit(a):
    neg = {p: m for p, m in a.items() if p < 0}
    pos = {p: m for p, m in a.items() if p >= 0}
    return neg, pos


def is_poly_eps(a):
    return all(x.is_polynomial(eps) for m in a.values() for x in m)


# ---- reduced loop: block-lower-triangular, (1,1)-block id + O(z^{-1})
K11 = sp.Matrix([[0, 0, 0], [0, 0, 0], [0, 0, 0]])
K11[0, 1] = 2                      # (1,1)-block nilpotent z^{-1} datum
Nbar = {0: sp.eye(3), -1: sp.Matrix([[0, 2, 0], [0, 0, 0], [1, -1, 0]])}
# Pbar = C0 (I + z C1'), C1' nilpotent, block-lower-triangular, base row (I,0)
C0 = sp.Matrix([[1, 0, 0], [0, 1, 0], [2, 1, 3]])   # lower-right constant V=3
C1p = sp.Matrix([[0, 0, 0], [0, 0, 0], [1, 0, 0]])  # nilpotent
Pbar = lmul({0: C0}, {0: sp.eye(3), 1: C1p})
Bbar = lmul(Nbar, Pbar)
# base row of Pbar at z-orders: (I_{2x2}-ish, 0) block structure
assert Pbar[0][:2, 2] == sp.zeros(2, 1)
assert Pbar[1][:2, :] == sp.zeros(2, 3)
assert Pbar[0][:2, :2] == sp.eye(2)

# ---- perturbation: full matrices, triangularity broken
D1 = {-1: sp.Matrix([[0, 0, 1], [1, 0, 0], [0, 1, 0]]),
      0: sp.Matrix([[1, 0, 2], [0, -1, 0], [0, 0, 1]]),
      1: sp.Matrix([[0, 1, 0], [0, 0, 1], [1, 0, 0]])}
D2 = {-2: sp.Matrix([[1, 1, 0], [0, 1, 1], [1, 0, 1]])}
pert = {0: sp.eye(3)}
pert = ladd(pert, {p: eps * m for p, m in D1.items()})
pert = ladd(pert, {p: eps**2 * m for p, m in D2.items()})
B = lmul(Bbar, pert)

# ---- lifting recursion: beta = Nbar^{-1} B Pbar^{-1} - I (exact inverses)
Nbar_inv = {0: sp.eye(3), -1: -Nbar[-1], -2: Nbar[-1] * Nbar[-1]}
assert lmul(Nbar, Nbar_inv) == {0: sp.eye(3)}, "Nbar inverse must be exact"
Pbar_inv = lmul({0: sp.eye(3), 1: -C1p}, {0: C0.inv()})
assert lmul(Pbar, Pbar_inv) == {0: sp.eye(3)}
beta = ladd(lmul(Nbar_inv, lmul(B, Pbar_inv)), {0: sp.eye(3)}, sgn=-1)
assert eps_coeff(beta, 0) in ({}, {0: sp.zeros(3)}) or \
    all(m == sp.zeros(3) for m in eps_coeff(beta, 0).values())

mu = {}   # eps-order -> loop with z < 0 support
phi = {}  # eps-order -> loop with z >= 0 support
for k in range(1, NE):
    rhs = eps_coeff(beta, k)
    for i in range(1, k):
        j = k - i
        if i in mu and j in phi:
            rhs = ladd(rhs, lmul(mu[i], phi[j]), sgn=-1)
    mu[k], phi[k] = zsplit(rhs)

muL = {0: sp.eye(3)}
phiL = {0: sp.eye(3)}
for k in range(1, NE):
    muL = ladd(muL, {p: eps**k * m for p, m in mu[k].items()})
    phiL = ladd(phiL, {p: eps**k * m for p, m in phi[k].items()})
Nfac = lmul(Nbar, muL)
Pfac = lmul(phiL, Pbar)

# (i) N P = B modulo eps^NE.  The z-support is exact, while the nonlinear
# factorization generally has an infinite eps-adic tail even when B is
# polynomial in eps.
prod = lmul(Nfac, Pfac)
diff = ladd(prod, B, sgn=-1)
for k in range(NE):
    d = eps_coeff(diff, k)
    assert all(m == sp.zeros(3) for m in d.values()), f"N P != B at eps^{k}"
# (ii) shapes
assert all(p < 0 for p in ladd(Nfac, {0: sp.eye(3)}, sgn=-1) if p >= 0) or \
    all(m == sp.zeros(3) for p, m in ladd(Nfac, {0: sp.eye(3)}, sgn=-1).items() if p >= 0)
assert all(m == sp.zeros(3) for p, m in Pfac.items() if p < 0)
# no divisions occurred: everything polynomial in eps
assert is_poly_eps(Nfac) and is_poly_eps(Pfac)
# (iii) reductions
assert {p: m for p, m in eps_coeff(Nfac, 0).items()
        if m != sp.zeros(3)} == {p: m for p, m in Nbar.items()}
assert {p: m for p, m in eps_coeff(Pfac, 0).items()
        if m != sp.zeros(3)} == {p: m for p, m in Pbar.items()}
# (iv) base row of the positive factor at eps = 0: (I, 0)
P0 = eps_coeff(Pfac, 0)
assert P0[0][:2, :2] == sp.eye(2) and P0[0][:2, 2] == sp.zeros(2, 1)
assert all(m[:2, :] == sp.zeros(2, 3) for p, m in P0.items() if p != 0) or \
    all((m[:2, :2] == sp.zeros(2, 2) and m[:2, 2] == sp.zeros(2, 1))
        for p, m in P0.items() if p >= 1)
print("legA: lifting recursion closes exactly modulo eps^%s (N P = B,"
      " no z-truncation, no division); factors have the right z-shapes,"
      " reduce to (Nbar, Pbar), and the positive factor's base row"
      " reduces to (I, 0)" % NE)

# ---------------------------------------------------------------- leg B
H, z, QZ = sp.symbols("H z Q_Z")
# P^1 J-function Q_Z-coefficient, H^2 = 0: 1/(H+z)^2 = z^{-2} - 2 H z^{-3}
c1 = sp.series(1 / (H + z) ** 2, H, 0, 2).removeO()
c1 = sp.expand(c1)
assert c1 == 1 / z**2 - 2 * H / z**3
degN = -2          # N = O(-1) + O(-1) on a rational curve in a threefold
r = 2
expo = sp.Rational(-degN, r - 1)
assert expo == 2
print("legB: J_{P^1} has nonzero Q_Z-coefficient", c1,
      "; (5.40) substitutes Q_Z -> Q^{i_*C} q^{+%s}: a positive q-power."
      % expo, "The whole-loop integrality premise is therefore unavailable"
      " without an additional filtration at centres with deg N < 0")

certificate = {
    "schema": "c925-int-psi-reconstruction-v1",
    "leg_a": {
        "base_row_reduction": "(I_2,0)",
        "division_free": True,
        "epsilon_precision": NE,
        "factorization_congruence": f"N*P = B mod eps^{NE}",
        "z_support_exact": True,
    },
    "leg_b": {
        "centre": "P1",
        "codimension": r,
        "j_linear_coefficient_mod_H2": "z^-2 - 2*H*z^-3",
        "normal_bundle": "O(-1)+O(-1)",
        "normal_degree": degN,
        "q_exponent_after_5_40": int(expo),
    },
    "scope": (
        "Leg A certifies integral Birkhoff lifting only when the whole input "
        "loop is eps-integral. Leg B proves that this premise is not automatic; "
        "it does not prove that Iritani's actual base row is nonintegral."
    ),
}

parser = argparse.ArgumentParser()
mode = parser.add_mutually_exclusive_group()
mode.add_argument("--write-certificate", type=Path)
mode.add_argument("--check-certificate", type=Path)
args = parser.parse_args()
payload = json.dumps(certificate, indent=2, sort_keys=True) + "\n"
if args.write_certificate is not None:
    args.write_certificate.write_text(payload, encoding="utf-8")
if args.check_certificate is not None:
    assert args.check_certificate.read_text(encoding="utf-8") == payload
print("all checks passed")
