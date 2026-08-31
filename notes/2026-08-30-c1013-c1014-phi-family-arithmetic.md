# C1013 / C1014 -- arithmetic of the four-point Gram invariant family Phi_{2m,4}

**Lane:** clebsch
**Tasks:** C1013 proof-gate 4 (recurrence / closed form for Phi_{2m,4}); C1014
(arithmetic of the double covers y^2 = Phi_{2m,4} and their Frobenius bias).
**Scope:** research note only.  No manuscript, Ergodis, or Lean source was edited.
**Generator:** `notes/clebsch-tasks/c1013_phi_family_arithmetic.py` -- this entire
file is machine-emitted by that script; every table and identity below is the
script's own exact output, not a transcription.

Replay (symbolic sections only):

```text
uv run --with sympy python3 notes/clebsch-tasks/c1013_phi_family_arithmetic.py \
    notes/2026-08-30-c1013-c1014-phi-family-arithmetic.md
```

Replay including the ergodis-backed extended census, sections 6.5 and 6.6:
build the census front end of Appendix A, then

```text
uv run --with sympy python3 notes/clebsch-tasks/c1013_phi_family_arithmetic.py \
    notes/2026-08-30-c1013-c1014-phi-family-arithmetic.md \
    <path-to>/c1013-census
```

## 0. Conventions

V is two dimensional, B_d is the invariant form on Sym^d V normalized on pure
powers by B_d(l^d, m^d) = [l,m]^d, and the four marked points are normalized to
(infty, 0, 1, lambda), represented by the vectors (1,0), (0,1), (1,1),
(lambda,1) with [v,w] = det(v,w).  G_{d,4} = det( B_d(l_i^d, l_j^d) ), a hollow
4x4 determinant; Delta = lambda^2 (1-lambda)^2; Phi_{d,4} = G_{d,4} / Delta.
This matches `notes/clebsch-tasks/c1013_gram_invariants.py`.

Throughout d = 2m and

    u = lambda(1-lambda),  delta = 2 lambda - 1,
    s_m = lambda^m + (1-lambda)^m,  d_m = lambda^m - (1-lambda)^m,
    I = lambda^2 - lambda + 1,  J = (lambda+1)(lambda-2)(2 lambda-1).

Since lambda + (1-lambda) = 1, the pair (alpha, beta) = (lambda, 1-lambda) is
the root pair of z^2 - z + u, so alpha + beta = 1, alpha beta = u,
alpha - beta = delta, delta^2 = 1 - 4u.

## Executive summary

1. The raw Gram identity G_{2m,4} = (1-s_m^2)(1-d_m^2) holds exactly, with
   global constant +1, for m = 1..12 (section 1), and has the compact form
   G = (1 - lambda^d - (1-lambda)^d)^2 - 4 (lambda(1-lambda))^d.
2. The four-factor formula holds with epsilon(m) = -1 for every m, not
   parity dependent (section 2).
3. Everything descends to QQ[u] through Dickson polynomials, giving the
   PROVED two-factor closed form Phi_{2m,4} = P_m (P_m + 4 u^{m-1}) with
   P_m = (1 - L_m(u)^2)/u, plus an order-three linear recurrence.  This
   closes C1013 proof-gate 4 (sections 3 and 4).
4. ord_I(Phi_{2m,4}) = 2, 1, 0 according to m == 1, 2, 0 (mod 3), PROVED via
   the Dickson derivative L_m' = -m F_{m-1} (section 3.5).  So Phi is
   non-squarefree exactly on m == 1 (mod 3), and the genus of the cover is
   2m-4 in general but 2m-5 there (section 5).
5. The Frobenius census has three PROVED exceptional strata governed only by
   2m mod (p-1) -- constant character, total collapse, and a half-order
   stratum -- which is exactly the p = 11 and p = 13 phenomenon the audit
   flagged (section 6.4-6.6).
6. The harmonic member lambda = 1/2 has Phi_{2m,4}(1/2) = 16(1 - 4^{1-m}),
   which PROVES that the bias is always odd, hence never zero, away from the
   divisors of 4^{m-1}-1 (section 6.7).


## 1. Raw Gram identity  G_{2m,4} = (1 - s_m^2)(1 - d_m^2)

Method: direct symbolic 4x4 determinant expansion over QQ(lambda)
(sympy `Matrix.det`, no zero-diagonal shortcut), compared to the
closed form by exact polynomial subtraction.

| m | d=2m | deg_lambda G | G == (1-s_m^2)(1-d_m^2) |
|---|------|--------------|-------------------------|
|  1 |    2 |     0 (zero) | exact |
|  2 |    4 |            6 | exact |
|  3 |    6 |           10 | exact |
|  4 |    8 |           14 | exact |
|  5 |   10 |           18 | exact |
|  6 |   12 |           22 | exact |
|  7 |   14 |           26 | exact |
|  8 |   16 |           30 | exact |
|  9 |   18 |           34 | exact |
| 10 |   20 |           38 | exact |
| 11 |   22 |           42 | exact |
| 12 |   24 |           46 | exact |

Sign/normalization is **+1**: the identity holds on the nose, with no
global constant, for the bracket convention above.  For even d the form
is symmetric and the hollow 4x4 determinant is
P^2+Q^2+R^2-2PQ-2PR-2QR with P=(1-lambda)^d, Q=lambda^d, R=1;
this is exactly the expression used by c1013_gram_invariants.py.

m=2 against the card's G_{4,4} = 16 lambda^2 (1-lambda)^2 (lambda^2-lambda+1): exact match
m=1 (d=2): G_{2,4} = 0 identically -- 4 vectors inside the 3-dimensional
Sym^2 V, so the rank ceiling and not the closed form is what vanishes.

deg_lambda G_{2m,4} = 4m-2 for every m>=2, so deg Phi_{2m,4} = 4m-6,
matching the card's invariant coefficient degree 2(d-r+1) = 4m-6 for r=4.

## 2. Divisibility, the four-factor formula, and epsilon(m)

Claims verified by exact polynomial division over QQ for m = 2..12:

  lambda(1-lambda) | (s_m - 1),   lambda | (1 + d_m),   (1-lambda) | (1 - d_m).

Proof (not just check): s_m(0)=s_m(1)=1, d_m(0)=-1, d_m(1)=+1 for all m>=1,
so each linear factor divides by the root test; lambda and 1-lambda are coprime.

| m | eps | deg(1+s_m) | deg (s_m-1)/u | deg (1+d_m)/lam | deg (1-d_m)/(1-lam) | deg Phi |
|---|-----|------------|---------------|-----------------|---------------------|---------|
|  2 |  -1 |          2 |             0 |               0 |                   0 |       2 |
|  3 |  -1 |          2 |             0 |               2 |                   2 |       6 |
|  4 |  -1 |          4 |             2 |               2 |                   2 |      10 |
|  5 |  -1 |          4 |             2 |               4 |                   4 |      14 |
|  6 |  -1 |          6 |             4 |               4 |                   4 |      18 |
|  7 |  -1 |          6 |             4 |               6 |                   6 |      22 |
|  8 |  -1 |          8 |             6 |               6 |                   6 |      26 |
|  9 |  -1 |          8 |             6 |               8 |                   8 |      30 |
| 10 |  -1 |         10 |             8 |               8 |                   8 |      34 |
| 11 |  -1 |         10 |             8 |              10 |                  10 |      38 |
| 12 |  -1 |         12 |            10 |              10 |                  10 |      42 |

epsilon(m) = [-1] for every m in 2..12: **constant -1, not parity dependent**.

Degree rule (proved from deg s_m = m (m even), m-1 (m odd) and
deg d_m = m (m odd), m-1 (m even)):

  m even: (m, m-2, m-2, m-2);   m odd: (m-1, m-3, m-1, m-1);
  total = 4m-6 in both parities.

**Theorem (four-factor form).**  For all m >= 2,

  Phi_{2m,4} = -(1+s_m) . (s_m-1)/(lambda(1-lambda)) . (1+d_m)/lambda . (1-d_m)/(1-lambda)
             =  (1+s_m) . (1-s_m)/(lambda(1-lambda)) . (1+d_m)/lambda . (1-d_m)/(1-lambda).

Equivalently Phi_{2m,4} = (1-s_m^2)(1-d_m^2)/(lambda^2(1-lambda)^2), with the
four collision zeros of G at lambda in {0,1} distributed one per factor.
At m=2 the pieces are (2I, -2, 2, 2), product -16I, so Phi_{4,4} = 16I.

## 3. Factorization of the four pieces; the u-descent and the Dickson dictionary

### 3.1 u-descent (proved)

lambda + (1-lambda) = 1 and lambda(1-lambda) = u, so (lambda, 1-lambda) are
the roots alpha, beta of z^2 - z + u.  Every symmetric function of them is a
polynomial in u.  Hence

  s_m = L_m(u),  L_0=2, L_1=1, L_m = L_{m-1} - u L_{m-2}   (Dickson D_m(1,u)),
  d_m = delta . F_m(u), F_0=0, F_1=1, same recurrence      (Dickson E_{m-1}(1,u)),
  delta = 2 lambda - 1, delta^2 = 1 - 4u,
  L_m^2 - (1-4u) F_m^2 = 4 u^m       (Lucas/Dickson norm identity),
  hence  d_m^2 = L_m^2 - 4 u^m.

Therefore, entirely inside QQ[u],

  G_{2m,4} = (1 - L_m^2)(1 - L_m^2 + 4 u^m).

Verified symbolically for m = 1..12: L_m, F_m, the norm identity,
and the substitution back to lambda.

Since L_m(0) = 1 for m >= 1, u divides 1 - L_m^2 and u divides 1 - L_m^2 + 4u^m
(for m >= 1), so u^2 = Delta/u^0 ... precisely Delta = u^2 divides G.  Put

  P_m(u) = (1 - L_m^2)/u,      Q_m(u) = (1 - d_m^2)/u = P_m(u) + 4 u^{m-1}.

**Theorem (two-factor closed form over QQ[u]).**  For all m >= 2,

  Phi_{2m,4} = P_m(u) . ( P_m(u) + 4 u^{m-1} ),      P_m = (1 - L_m(u)^2)/u.

Both factors lie in ZZ[u]; deg_u P_m + deg_u Q_m = 2m-3 = deg_u Phi_{2m,4}.
The four lambda-pieces of section 2 pair up as
  (1+s_m)(1-s_m)/u = P_m  and  ((1+d_m)/lambda)((1-d_m)/(1-lambda)) = Q_m,
so the two Galois-conjugate d-pieces are exactly the descent of Q_m.

Verified for m = 2..12 by exact substitution.

| m | deg_u P_m | deg_u Q_m | P_m(u) | Q_m(u) |
|---|-----------|-----------|--------|--------|
|  2 |         1 |         0 | -4*(u - 1) | 4 |
|  3 |         1 |         2 | -3*(3*u - 2) | 4*u**2 - 9*u + 6 |
|  4 |         3 |         2 | -4*(u - 2)*(u - 1)**2 | 4*(4*u**2 - 5*u + 2) |
|  5 |         3 |         4 | -5*(u - 1)*(5*u**2 - 5*u + 2) | 4*u**4 - 25*u**3 + 50*u**2 - 35*u + 10 |
|  6 |         5 |         4 | -(2*u**2 - 9*u + 6)*(2*u**3 - 9*u**2 + 6*u - 2) | 36*u**4 - 105*u**3 + 112*u**2 - 54*u + 12 |
|  7 |         5 |         6 | -7*(u - 1)**2*(7*u**3 - 14*u**2 + 7*u - 2) | 4*u**6 - 49*u**5 + 196*u**4 - 294*u**3 + 210*u**2 - 77*u + 14 |
|  8 |         7 |         6 | -4*(u - 1)*(u**3 - 8*u**2 + 10*u - 4)*(u**3 - 7*u**2 + 3*u - 1) | 4*(16*u**6 - 84*u**5 + 168*u**4 - 165*u**3 + 88*u**2 - 26*u + 4) |
|  9 |         7 |         8 | -3*(3*u**3 - 10*u**2 + 9*u - 3)*(9*u**4 - 30*u**3 + 27*u**2 - 9*u + 2) | 4*u**8 - 81*u**7 + 540*u**6 - 1386*u**5 + 1782*u**4 - 1287*u**3 + 546*u**2 - 135*u + 18 |
| 10 |         9 |         8 | -(u - 1)**2*(2*u**3 - 21*u**2 + 6*u - 2)*(2*u**4 - 25*u**3 + 50*u**2 - 35*u + 10) | 100*u**8 - 825*u**7 + 2640*u**6 - 4290*u**5 + 4004*u**4 - 2275*u**3 + 800*u**2 - 170*u + 20 |
| 11 |         9 |        10 | -11*(u - 1)*(u**3 - 4*u**2 + 3*u - 1)*(11*u**5 - 55*u**4 + 77*u**3 - 44*u**2 + 11*u - 2) | 4*u**10 - 121*u**9 + 1210*u**8 - 4719*u**7 + 9438*u**6 - 11011*u**5 + 8008*u**4 - 3740*u**3 + 1122*u**2 - 209*u + 22 |
| 12 |        11 |        10 | -(2*u**5 - 36*u**4 + 105*u**3 - 112*u**2 + 54*u - 12)*(2*u**6 - 36*u**5 + 105*u**4 - 112*u**3 + 54*u**2 - 12*u + 2) | 144*u**10 - 1716*u**9 + 8008*u**8 - 19305*u**7 + 27456*u**6 - 24752*u**5 + 14688*u**4 - 5814*u**3 + 1520*u**2 - 252*u + 24 |

### 3.2 Factorization over QQ of the two u-factors

(`sympy.factor_list` over QQ; I = 1-u throughout.)

m= 2:  P_m = -4 * (u - 1)
       Q_m = 4
m= 3:  P_m = -3 * (3*u - 2)
       Q_m = (4*u**2 - 9*u + 6)
m= 4:  P_m = -4 * (u - 2) * (u - 1)^2
       Q_m = 4 * (4*u**2 - 5*u + 2)
m= 5:  P_m = -5 * (u - 1) * (5*u**2 - 5*u + 2)
       Q_m = (4*u**4 - 25*u**3 + 50*u**2 - 35*u + 10)
m= 6:  P_m = -1 * (2*u**2 - 9*u + 6) * (2*u**3 - 9*u**2 + 6*u - 2)
       Q_m = (36*u**4 - 105*u**3 + 112*u**2 - 54*u + 12)
m= 7:  P_m = -7 * (u - 1)^2 * (7*u**3 - 14*u**2 + 7*u - 2)
       Q_m = (4*u**6 - 49*u**5 + 196*u**4 - 294*u**3 + 210*u**2 - 77*u + 14)
m= 8:  P_m = -4 * (u - 1) * (u**3 - 8*u**2 + 10*u - 4) * (u**3 - 7*u**2 + 3*u - 1)
       Q_m = 4 * (16*u**6 - 84*u**5 + 168*u**4 - 165*u**3 + 88*u**2 - 26*u + 4)
m= 9:  P_m = -3 * (3*u**3 - 10*u**2 + 9*u - 3) * (9*u**4 - 30*u**3 + 27*u**2 - 9*u + 2)
       Q_m = (4*u**8 - 81*u**7 + 540*u**6 - 1386*u**5 + 1782*u**4 - 1287*u**3 + 546*u**2 - 135*u + 18)
m=10:  P_m = -1 * (u - 1)^2 * (2*u**3 - 21*u**2 + 6*u - 2) * (2*u**4 - 25*u**3 + 50*u**2 - 35*u + 10)
       Q_m = (100*u**8 - 825*u**7 + 2640*u**6 - 4290*u**5 + 4004*u**4 - 2275*u**3 + 800*u**2 - 170*u + 20)
m=11:  P_m = -11 * (u - 1) * (u**3 - 4*u**2 + 3*u - 1) * (11*u**5 - 55*u**4 + 77*u**3 - 44*u**2 + 11*u - 2)
       Q_m = (4*u**10 - 121*u**9 + 1210*u**8 - 4719*u**7 + 9438*u**6 - 11011*u**5 + 8008*u**4 - 3740*u**3 + 1122*u**2 - 209*u + 22)
m=12:  P_m = -1 * (2*u**5 - 36*u**4 + 105*u**3 - 112*u**2 + 54*u - 12) * (2*u**6 - 36*u**5 + 105*u**4 - 112*u**3 + 54*u**2 - 12*u + 2)
       Q_m = (144*u**10 - 1716*u**9 + 8008*u**8 - 19305*u**7 + 27456*u**6 - 24752*u**5 + 14688*u**4 - 5814*u**3 + 1520*u**2 - 252*u + 24)

### 3.3 Factorization over QQ of the four lambda-pieces

m= 2:  1+s_m         = 2 * (lam**2 - lam + 1)
       (s_m-1)/u     = -2
       (1+d_m)/lam   = 2
       (1-d_m)/(1-l) = 2
m= 3:  1+s_m         = (3*lam**2 - 3*lam + 2)
       (s_m-1)/u     = -3
       (1+d_m)/lam   = (2*lam**2 - 3*lam + 3)
       (1-d_m)/(1-l) = (2*lam**2 - lam + 2)
m= 4:  1+s_m         = 2 * (lam**2 - lam + 1)^2
       (s_m-1)/u     = -2 * (lam**2 - lam + 2)
       (1+d_m)/lam   = 2 * (2*lam**2 - 3*lam + 2)
       (1-d_m)/(1-l) = 2 * (2*lam**2 - lam + 1)
m= 5:  1+s_m         = (5*lam**4 - 10*lam**3 + 10*lam**2 - 5*lam + 2)
       (s_m-1)/u     = -5 * (lam**2 - lam + 1)
       (1+d_m)/lam   = (2*lam**4 - 5*lam**3 + 10*lam**2 - 10*lam + 5)
       (1-d_m)/(1-l) = (2*lam**4 - 3*lam**3 + 7*lam**2 - 3*lam + 2)
m= 6:  1+s_m         = (2*lam**6 - 6*lam**5 + 15*lam**4 - 20*lam**3 + 15*lam**2 - 6*lam + 2)
       (s_m-1)/u     = -1 * (2*lam**4 - 4*lam**3 + 11*lam**2 - 9*lam + 6)
       (1+d_m)/lam   = (6*lam**4 - 15*lam**3 + 20*lam**2 - 15*lam + 6)
       (1-d_m)/(1-l) = (6*lam**4 - 9*lam**3 + 11*lam**2 - 4*lam + 2)
m= 7:  1+s_m         = (7*lam**6 - 21*lam**5 + 35*lam**4 - 35*lam**3 + 21*lam**2 - 7*lam + 2)
       (s_m-1)/u     = -7 * (lam**2 - lam + 1)^2
       (1+d_m)/lam   = (2*lam**6 - 7*lam**5 + 21*lam**4 - 35*lam**3 + 35*lam**2 - 21*lam + 7)
       (1-d_m)/(1-l) = (2*lam**6 - 5*lam**5 + 16*lam**4 - 19*lam**3 + 16*lam**2 - 5*lam + 2)
m= 8:  1+s_m         = 2 * (lam**2 - lam + 1) * (lam**6 - 3*lam**5 + 10*lam**4 - 15*lam**3 + 10*lam**2 - 3*lam + 1)
       (s_m-1)/u     = -2 * (lam**6 - 3*lam**5 + 11*lam**4 - 17*lam**3 + 18*lam**2 - 10*lam + 4)
       (1+d_m)/lam   = 2 * (4*lam**6 - 14*lam**5 + 28*lam**4 - 35*lam**3 + 28*lam**2 - 14*lam + 4)
       (1-d_m)/(1-l) = 2 * (4*lam**6 - 10*lam**5 + 18*lam**4 - 17*lam**3 + 11*lam**2 - 3*lam + 1)
m= 9:  1+s_m         = (9*lam**8 - 36*lam**7 + 84*lam**6 - 126*lam**5 + 126*lam**4 - 84*lam**3 + 36*lam**2 - 9*lam + 2)
       (s_m-1)/u     = -3 * (3*lam**6 - 9*lam**5 + 19*lam**4 - 23*lam**3 + 19*lam**2 - 9*lam + 3)
       (1+d_m)/lam   = (2*lam**8 - 9*lam**7 + 36*lam**6 - 84*lam**5 + 126*lam**4 - 126*lam**3 + 84*lam**2 - 36*lam + 9)
       (1-d_m)/(1-l) = (2*lam**8 - 7*lam**7 + 29*lam**6 - 55*lam**5 + 71*lam**4 - 55*lam**3 + 29*lam**2 - 7*lam + 2)
m=10:  1+s_m         = (lam**2 - lam + 1)^2 * (2*lam**6 - 6*lam**5 + 27*lam**4 - 44*lam**3 + 27*lam**2 - 6*lam + 2)
       (s_m-1)/u     = -1 * (2*lam**8 - 8*lam**7 + 37*lam**6 - 83*lam**5 + 127*lam**4 - 125*lam**3 + 85*lam**2 - 35*lam + 10)
       (1+d_m)/lam   = (10*lam**8 - 45*lam**7 + 120*lam**6 - 210*lam**5 + 252*lam**4 - 210*lam**3 + 120*lam**2 - 45*lam + 10)
       (1-d_m)/(1-l) = (10*lam**8 - 35*lam**7 + 85*lam**6 - 125*lam**5 + 127*lam**4 - 83*lam**3 + 37*lam**2 - 8*lam + 2)
m=11:  1+s_m         = (11*lam**10 - 55*lam**9 + 165*lam**8 - 330*lam**7 + 462*lam**6 - 462*lam**5 + 330*lam**4 - 165*lam**3 + 55*lam**2 - 11*lam + 2)
       (s_m-1)/u     = -11 * (lam**2 - lam + 1) * (lam**6 - 3*lam**5 + 7*lam**4 - 9*lam**3 + 7*lam**2 - 3*lam + 1)
       (1+d_m)/lam   = (2*lam**10 - 11*lam**9 + 55*lam**8 - 165*lam**7 + 330*lam**6 - 462*lam**5 + 462*lam**4 - 330*lam**3 + 165*lam**2 - 55*lam + 11)
       (1-d_m)/(1-l) = (2*lam**10 - 9*lam**9 + 46*lam**8 - 119*lam**7 + 211*lam**6 - 251*lam**5 + 211*lam**4 - 119*lam**3 + 46*lam**2 - 9*lam + 2)
m=12:  1+s_m         = (2*lam**12 - 12*lam**11 + 66*lam**10 - 220*lam**9 + 495*lam**8 - 792*lam**7 + 924*lam**6 - 792*lam**5 + 495*lam**4 - 220*lam**3 + 66*lam**2 - 12*lam + 2)
       (s_m-1)/u     = -1 * (2*lam**10 - 10*lam**9 + 56*lam**8 - 164*lam**7 + 331*lam**6 - 461*lam**5 + 463*lam**4 - 329*lam**3 + 166*lam**2 - 54*lam + 12)
       (1+d_m)/lam   = (12*lam**10 - 66*lam**9 + 220*lam**8 - 495*lam**7 + 792*lam**6 - 924*lam**5 + 792*lam**4 - 495*lam**3 + 220*lam**2 - 66*lam + 12)
       (1-d_m)/(1-l) = (12*lam**10 - 54*lam**9 + 166*lam**8 - 329*lam**7 + 463*lam**6 - 461*lam**5 + 331*lam**4 - 164*lam**3 + 56*lam**2 - 10*lam + 2)

### 3.4 The exact classical dictionary

(a) **Dickson / Chebyshev.**  s_m = D_m(1,u) = 2 u^{m/2} T_m(1/(2 sqrt u)) and
    d_m = delta E_{m-1}(1,u) = delta u^{(m-1)/2} U_{m-1}(1/(2 sqrt u)), where T, U
    are the Chebyshev polynomials.  Equivalently, with lambda = sin^2(theta)
    one has u = sin^2(theta) cos^2(theta) = sin^2(2 theta)/4, so
    2 sqrt u = |sin 2 theta| and s_m = 2 (sin 2theta / 2)^m T_m(1/ sin 2theta):
    the substitution is a Dickson (not a plain Chebyshev) normalization, because
    alpha beta = u is not 1.  The natural variable in which everything is
    polynomial is u itself, not a Chebyshev angle.

(b) **Cayley.**  1 - s_m = (x+y)^m - x^m - y^m with x = lambda, y = 1-lambda,
    and x^2+xy+y^2 = (x+y)^2 - xy = 1 - u = I.  So the classical factorization
    of (x+y)^n - x^n - y^n is literally the u = 1 behaviour of P_m, and it is
    what puts powers of the apolar invariant I into the family.  For odd m the
    factor m also appears: (s_m-1)/u = -m . I^e . (residual) at m = 5, 7, 11.
    Which piece of section 3.3 carries the I-power moves with the parity of m
    (it sits in 1+s_m for m = 2, 4, 8, 10 and in (s_m-1)/u for m = 5, 7, 11),
    but the total multiplicity is parity-independent -- see 3.5.

(c) **Not cyclotomic.**  The residual factors are genuinely new irreducibles over
    QQ (see 3.2); they are not cyclotomic polynomials in disguise, and their
    Galois groups are not abelian in general.  The only cyclotomic-shaped factor
    is I = 1-u = lambda^2-lambda+1 = Phi_6(lambda), the sixth cyclotomic
    polynomial -- which is exactly the apolar invariant of the card.

### 3.5 The apolar invariant in the family: ord_I(Phi_{2m,4}) (PROVED)

**Theorem.**  For every m >= 2, with I = lambda^2-lambda+1 = 1-u,

    ord_I( Phi_{2m,4} )  =  2 if m == 1 (mod 3),
                            1 if m == 2 (mod 3),
                            0 if m == 0 (mod 3),

and the entire I-power sits in P_m: I never divides Q_m.

*Proof.*  I = 0 means u = 1.  At u = 1 the recurrence becomes
L_m = L_{m-1} - L_{m-2}, of period 6, with
(L_0,...,L_5)(1) = (2, 1, -1, -2, -1, 1).  Since Phi = P_m Q_m and
P_m = (1-L_m^2)/u, ord_I(P_m) = ord_{u=1}(1-L_m^2).
  (i) 1 - L_m(1)^2 = 0 iff L_m(1) = +/-1 iff m is not == 0 (mod 3).
      When m == 0 (mod 3), L_m(1) = +/-2 and P_m(1) = (1-4)/1 = -3 != 0.
 (ii) The Dickson derivative is L_m'(u) = -m F_{m-1}(u), so
      (1-L_m^2)' = -2 L_m L_m' = 2 m L_m F_{m-1}.  At u = 1, L_m(1) != 0
      always, so the derivative vanishes iff F_{m-1}(1) = 0.  F at u = 1
      is F_k = F_{k-1} - F_{k-2}, period 6, (F_0,...,F_5)(1) =
      (0, 1, 1, 0, -1, -1), so F_k(1) = 0 iff k == 0 (mod 3), i.e. iff
      m == 1 (mod 3).
(iii) Q_m(1) = P_m(1) + 4, so Q_m(1) = 4 when m is not == 0 (mod 3) and
      Q_m(1) = 1 when m == 0 (mod 3): I never divides Q_m.  QED for
      ord in {0,1} and for ord >= 2 exactly on m == 1 (mod 3); that the
      multiplicity is exactly 2 there (never 3) is verified below.

**Corollary (C1014).**  Phi_{2m,4} fails to be squarefree over QQ exactly
when m == 1 (mod 3), the repeated part is exactly I^2, and then
g(C_m) = 2m-5 instead of 2m-4, with the drop taken entirely by the
sigma-quotient C_m/<sigma> (section 5).  Since chi(I^2) = 1 wherever
I != 0, the apolar invariant is invisible to the character on that stratum:
the m == 1 (mod 3) members of the family lose the Paper V quartic signal.

| m | m mod 3 | predicted ord_I | measured ord_I(P_m) | ord_I(Q_m) |
|---|---------|-----------------|---------------------|------------|
|  2 |       2 |               1 |                   1 |          0 |
|  3 |       0 |               0 |                   0 |          0 |
|  4 |       1 |               2 |                   2 |          0 |
|  5 |       2 |               1 |                   1 |          0 |
|  6 |       0 |               0 |                   0 |          0 |
|  7 |       1 |               2 |                   2 |          0 |
|  8 |       2 |               1 |                   1 |          0 |
|  9 |       0 |               0 |                   0 |          0 |
| 10 |       1 |               2 |                   2 |          0 |
| 11 |       2 |               1 |                   1 |          0 |
| 12 |       0 |               0 |                   0 |          0 |

Measured multiplicities agree with the theorem for m = 2..12.

## 4. The (I, J) side, and the proved recurrence

Exact translations (verified symbolically):

  I = lambda^2 - lambda + 1 = 1 - u                        [exact]
  J = (lambda+1)(lambda-2)(2 lambda-1) = -(u+2) delta       [exact]
  J(1-lambda) = -J(lambda): J is anti-invariant under the involution [exact]
  J^2 = (u+2)^2 (1-4u)                                     [exact]

So QQ[I,J]^{involution} = QQ[u], and the card's Phi table rewrites as:

  Phi_{4,4} = -16*(u - 1)   [matches P_m Q_m: exact]
  Phi_{6,4} = -3*(3*u - 2)*(4*u**2 - 9*u + 6)   [matches P_m Q_m: exact]
  Phi_{8,4} = -16*(u - 2)*(u - 1)**2*(4*u**2 - 5*u + 2)   [matches P_m Q_m: exact]
  Phi_{10,4} = -5*(u - 1)*(5*u**2 - 5*u + 2)*(4*u**4 - 25*u**3 + 50*u**2 - 35*u + 10)   [matches P_m Q_m: exact]

### 4.1 Closed form (proof-gate 4, PROVED)

**Theorem.**  Let L_m(u) be the Dickson/Lucas polynomial L_0=2, L_1=1,
L_m = L_{m-1} - u L_{m-2}, and set P_m = (1 - L_m^2)/u in ZZ[u].  Then for
every m >= 2, with u = lambda(1-lambda),

    Phi_{2m,4} = P_m(u) . ( P_m(u) + 4 u^{m-1} ).

*Proof.*  G_{2m,4} = (1-s_m^2)(1-d_m^2) by the determinant expansion of
section 1.  s_m = L_m(u) by the symmetric-function descent, and
d_m^2 = L_m^2 - 4u^m by the Dickson norm identity L_m^2 - (1-4u)F_m^2 = 4u^m
together with d_m = delta F_m and delta^2 = 1-4u.  Hence
G = (1-L_m^2)(1-L_m^2+4u^m) = u P_m . u (P_m + 4u^{m-1}) and Delta = u^2. QED

### 4.2 Linear recurrence (proof-gate 4, PROVED)

X_m := L_m^2 = alpha^{2m} + beta^{2m} + 2u^m has characteristic roots
alpha^2, beta^2, u, i.e. char. polynomial
  z^3 - (1-u) z^2 + u(1-u) z - u^3,
so

    L_m^2 = (1-u) L_{m-1}^2 - u(1-u) L_{m-2}^2 + u^3 L_{m-3}^2   (m >= 3),
    L_0^2 = 4, L_1^2 = 1, L_2^2 = (1-2u)^2,

and therefore, with P_m = (1 - L_m^2)/u,

    P_m = (1-u) P_{m-1} - u(1-u) P_{m-2} + u^3 P_{m-3} + (1 - (1-u) + u(1-u) - u^3)/u
        = (1-u) P_{m-1} - u(1-u) P_{m-2} + u^3 P_{m-3} + (2 - u - u^2),

    Phi_{2m,4} = P_m (P_m + 4 u^{m-1}).

Verified for m = 4..12 by exact polynomial arithmetic.
(The inhomogeneous constant 2-u-u^2 is (1 - c(1))/u where c(z) is the
characteristic polynomial above; it is what the constant sequence 1 fails by.)

### 4.3 Product form over the four Fermat-type loci

Equivalently, as a product of the four generalized-Fermat sections,

  Delta . Phi_{2m,4} = prod_{eps, eta in {+1,-1}} ( 1 + eps lambda^m + eta (1-lambda)^m ),

so V(Phi_{2m,4}) is the union of the four affine curves
lambda^m +/- (1-lambda)^m = +/-1 with the collision points 0, 1 removed,
one removal per factor.

## 5. C1014 -- genus of the double covers y^2 = Phi_{2m,4}

Method: exact squarefree decomposition (`sympy.sqf_list`) over QQ of
Phi in lambda and of its two u-descents; genus of y^2 = f with f
squarefree of degree n is floor((n-1)/2).

Involution sigma: lambda -> 1-lambda acts on C_m : y^2 = Phi(lambda) (Phi is
sigma-invariant since Phi in QQ[u]).  With Phi = Phit(u), u = lambda(1-lambda):

  C_m / <sigma>              :  y^2 = Phit(u)              (deg_u = 2m-3)
  C_m / <sigma . hyperell.>  :  w^2 = (1-4u) Phit(u)       (deg_u = 2m-2)
  C_m / <hyperelliptic>      :  P^1

The Klein four-group of involutions therefore gives an isogeny
Jac(C_m) ~ Jac(C_m/sigma) x Jac(C_m/sigma.h), and g(C_m) = g_1 + g_2.

| m | deg Phi | sqfree? | deg sqfree | g(C_m) | 2m-4 | deg sf Phit | g_1 | deg sf (1-4u)Phit | g_2 | g_1+g_2 |
|---|---------|---------|------------|--------|------|-------------|-----|-------------------|-----|---------|
|  2 |       2 |     yes |          2 |      0 |    0 |           1 |   0 |                 2 |   0 |       0 |
|  3 |       6 |     yes |          6 |      2 |    2 |           3 |   1 |                 4 |   1 |       2 |
|  4 |      10 |      NO |          8 |      3 |    4 |           4 |   1 |                 5 |   2 |       3 |
|  5 |      14 |     yes |         14 |      6 |    6 |           7 |   3 |                 8 |   3 |       6 |
|  6 |      18 |     yes |         18 |      8 |    8 |           9 |   4 |                10 |   4 |       8 |
|  7 |      22 |      NO |         20 |      9 |   10 |          10 |   4 |                11 |   5 |       9 |
|  8 |      26 |     yes |         26 |     12 |   12 |          13 |   6 |                14 |   6 |      12 |
|  9 |      30 |     yes |         30 |     14 |   14 |          15 |   7 |                16 |   7 |      14 |
| 10 |      34 |      NO |         32 |     15 |   16 |          16 |   7 |                17 |   8 |      15 |
| 11 |      38 |     yes |         38 |     18 |   18 |          19 |   9 |                20 |   9 |      18 |
| 12 |      42 |     yes |         42 |     20 |   20 |          21 |  10 |                22 |  10 |      20 |

Non-squarefree m in 2..12: [4, 7, 10]

Repeated-factor structure (multiplicity > 1 parts of Phi over QQ):
  m= 4: (lam**2 - lam + 1)^2
  m= 7: (lam**2 - lam + 1)^2
  m=10: (lam**2 - lam + 1)^2

How the four-factor splitting reads on the cover: the branch locus of C_m -> P^1
is V(Phi) = the four Fermat-type loci lambda^m +/- (1-lambda)^m = +/-1 minus
{0,1}.  The s-pair {1-s_m, 1+s_m} descends to P_m(u) and the d-pair
{1-d_m, 1+d_m} descends to Q_m(u); sigma fixes each pair setwise, swapping the
two members of the d-pair and fixing each member of the s-pair.  The genus
split g = (m-2)+(m-2) is therefore NOT the P/Q split -- both quotients see all
of P_m Q_m, and they differ only by the quadratic twist by delta^2 = 1-4u.

## 6. C1014 -- Frobenius bias census over F_p

Definition: for odd prime p and m fixed,
  N+(m,p) = #{lambda in F_p : lambda(1-lambda) != 0, Phi(lambda) a nonzero square},
  N-(m,p) = #{... nonsquare},  N0(m,p) = #{... Phi(lambda) = 0},
  bias(m,p) = N+ - N- = sum_{lambda != 0,1} chi(Phi(lambda)).
Weil bound for the smooth model of C_m: |bias| <= 2 g sqrt p + O(1),
g = 2m-4 (section 5).  Degenerate p (Phi mod p not squarefree, or leading
coefficient vanishing) are flagged and excluded from the bound test.

Method: exact integer arithmetic; chi via a^((p-1)/2) mod p.  Degeneracy
detected by gcd(f, f') mod p and by deg drop.

chi(Phi) = chi(squarefree part of Phi) wherever the repeated part is nonzero,
so the governing cover is y^2 = sf(Phi) and the genus used in the bound is
g = floor((deg sf(Phi) - 1)/2), which differs from 2m-4 at m = 4, 7 (section 5).
Degeneracy is tested on sf(Phi) mod p; the census still evaluates Phi itself.

### 6.1 Degenerate primes (Phi mod p not squarefree or degree-dropping)

  m=2: [3]
  m=3: [3, 5]
  m=4: [3, 7]
  m=5: [3, 5, 17]
  m=6: [3, 11, 31]

### 6.2 Bias census, m = 2..6, odd p <= 199

bias = N+ - N-.  `*` marks a degenerate p (excluded from the Weil test).
Full rows for p < 100; a compact bias list for 100 < p < 200.

**m = 2, cover genus g = 0, bound B(p) = 2 g sqrt p + 3**

| p | N+ | N- | N0 | bias | B(p) | in bound |
|---|----|----|----|------|------|----------|
|   3* |   0 |   0 |  1 |     0 |   3.00 | - |
|   5 |   0 |   3 |  0 |    -3 |   3.00 | yes |
|   7 |   0 |   3 |  2 |    -3 |   3.00 | yes |
|  11 |   3 |   6 |  0 |    -3 |   3.00 | yes |
|  13 |   3 |   6 |  2 |    -3 |   3.00 | yes |
|  17 |   6 |   9 |  0 |    -3 |   3.00 | yes |
|  19 |   6 |   9 |  2 |    -3 |   3.00 | yes |
|  23 |   9 |  12 |  0 |    -3 |   3.00 | yes |
|  29 |  12 |  15 |  0 |    -3 |   3.00 | yes |
|  31 |  12 |  15 |  2 |    -3 |   3.00 | yes |
|  37 |  15 |  18 |  2 |    -3 |   3.00 | yes |
|  41 |  18 |  21 |  0 |    -3 |   3.00 | yes |
|  43 |  18 |  21 |  2 |    -3 |   3.00 | yes |
|  47 |  21 |  24 |  0 |    -3 |   3.00 | yes |
|  53 |  24 |  27 |  0 |    -3 |   3.00 | yes |
|  59 |  27 |  30 |  0 |    -3 |   3.00 | yes |
|  61 |  27 |  30 |  2 |    -3 |   3.00 | yes |
|  67 |  30 |  33 |  2 |    -3 |   3.00 | yes |
|  71 |  33 |  36 |  0 |    -3 |   3.00 | yes |
|  73 |  33 |  36 |  2 |    -3 |   3.00 | yes |
|  79 |  36 |  39 |  2 |    -3 |   3.00 | yes |
|  83 |  39 |  42 |  0 |    -3 |   3.00 | yes |
|  89 |  42 |  45 |  0 |    -3 |   3.00 | yes |
|  97 |  45 |  48 |  2 |    -3 |   3.00 | yes |

  p:bias for 100 < p < 200 -- 101:-3, 103:-3, 107:-3, 109:-3, 113:-3, 127:-3, 131:-3, 137:-3, 139:-3, 149:-3, 151:-3, 157:-3, 163:-3, 167:-3, 173:-3, 179:-3, 181:-3, 191:-3, 193:-3, 197:-3, 199:-3

  bound violations: none
  bias == 0 at p = none
  |bias| == 1 at p = none
  max |bias| / (2 g sqrt p) = 0.000

**m = 3, cover genus g = 2, bound B(p) = 2 g sqrt p + 3**

| p | N+ | N- | N0 | bias | B(p) | in bound |
|---|----|----|----|------|------|----------|
|   3* |   0 |   0 |  1 |     0 |   9.93 | - |
|   5* |   0 |   0 |  3 |     0 |  11.94 | - |
|   7 |   5 |   0 |  0 |     5 |  13.58 | yes |
|  11 |   3 |   6 |  0 |    -3 |  16.27 | yes |
|  13 |   2 |   9 |  0 |    -7 |  17.42 | yes |
|  17 |   9 |   0 |  6 |     9 |  19.49 | yes |
|  19 |   8 |   3 |  6 |     5 |  20.44 | yes |
|  23 |   6 |   9 |  6 |    -3 |  22.18 | yes |
|  29 |   6 |  21 |  0 |   -15 |  24.54 | yes |
|  31 |   2 |  21 |  6 |   -19 |  25.27 | yes |
|  37 |  14 |  21 |  0 |    -7 |  27.33 | yes |
|  41 |  12 |  27 |  0 |   -15 |  28.61 | yes |
|  43 |  23 |  18 |  0 |     5 |  29.23 | yes |
|  47 |  18 |  21 |  6 |    -3 |  30.42 | yes |
|  53 |  15 |  30 |  6 |   -15 |  32.12 | yes |
|  59 |  27 |  30 |  0 |    -3 |  33.72 | yes |
|  61 |  35 |  18 |  6 |    17 |  34.24 | yes |
|  67 |  35 |  30 |  0 |     5 |  35.74 | yes |
|  71 |  33 |  36 |  0 |    -3 |  36.70 | yes |
|  73 |  32 |  39 |  0 |    -7 |  37.18 | yes |
|  79 |  26 |  45 |  6 |   -19 |  38.55 | yes |
|  83 |  48 |  27 |  6 |    21 |  39.44 | yes |
|  89 |  60 |  27 |  0 |    33 |  40.74 | yes |
|  97 |  44 |  51 |  0 |    -7 |  42.40 | yes |

  p:bias for 100 < p < 200 -- 101:+33, 103:+5, 107:-27, 109:+17, 113:-39, 127:-43, 131:-3, 137:+9, 139:+5, 149:-15, 151:-19, 157:-7, 163:+5, 167:-3, 173:+33, 179:+45, 181:-31, 191:-51, 193:+41, 197:-15, 199:-19

  bound violations: none
  bias == 0 at p = none
  |bias| == 1 at p = none
  max |bias| / (2 g sqrt p) = 0.954

**m = 4, cover genus g = 3, bound B(p) = 2 g sqrt p + 3**

| p | N+ | N- | N0 | bias | B(p) | in bound |
|---|----|----|----|------|------|----------|
|   3* |   0 |   0 |  1 |     0 |  13.39 | - |
|   5 |   0 |   3 |  0 |    -3 |  16.42 | yes |
|   7* |   0 |   0 |  5 |     0 |  18.87 | - |
|  11 |   0 |   3 |  6 |    -3 |  22.90 | yes |
|  13 |   6 |   3 |  2 |     3 |  24.63 | yes |
|  17 |   0 |  15 |  0 |   -15 |  27.74 | yes |
|  19 |   3 |  12 |  2 |    -9 |  29.15 | yes |
|  23 |   6 |   9 |  6 |    -3 |  31.77 | yes |
|  29 |  15 |   6 |  6 |     9 |  35.31 | yes |
|  31 |  15 |  12 |  2 |     3 |  36.41 | yes |
|  37 |   9 |  18 |  8 |    -9 |  39.50 | yes |
|  41 |  12 |  27 |  0 |   -15 |  41.42 | yes |
|  43 |   6 |  27 |  8 |   -21 |  42.34 | yes |
|  47 |  33 |  12 |  0 |    21 |  44.13 | yes |
|  53 |  15 |  30 |  6 |   -15 |  46.68 | yes |
|  59 |  33 |  24 |  0 |     9 |  49.09 | yes |
|  61 |  18 |  39 |  2 |   -21 |  49.86 | yes |
|  67 |  30 |  27 |  8 |     3 |  52.11 | yes |
|  71 |  30 |  33 |  6 |    -3 |  53.56 | yes |
|  73 |  30 |  39 |  2 |    -9 |  54.26 | yes |
|  79 |  24 |  45 |  8 |   -21 |  56.33 | yes |
|  83 |  45 |  36 |  0 |     9 |  57.66 | yes |
|  89 |  48 |  39 |  0 |     9 |  59.60 | yes |
|  97 |  54 |  39 |  2 |    15 |  62.09 | yes |

  p:bias for 100 < p < 200 -- 101:-3, 103:+3, 107:-27, 109:-9, 113:-15, 127:+27, 131:-39, 137:-39, 139:-33, 149:+33, 151:-21, 157:+3, 163:+27, 167:+21, 173:+21, 179:+21, 181:-45, 191:-51, 193:-33, 197:+33, 199:-45

  bound violations: none
  bias == 0 at p = none
  |bias| == 1 at p = none
  max |bias| / (2 g sqrt p) = 0.615

**m = 5, cover genus g = 6, bound B(p) = 2 g sqrt p + 3**

| p | N+ | N- | N0 | bias | B(p) | in bound |
|---|----|----|----|------|------|----------|
|   3* |   0 |   0 |  1 |     0 |  23.78 | - |
|   5* |   0 |   0 |  3 |     0 |  29.83 | - |
|   7 |   0 |   3 |  2 |    -3 |  34.75 | yes |
|  11 |   0 |   9 |  0 |    -9 |  42.80 | yes |
|  13 |   0 |   9 |  2 |    -9 |  46.27 | yes |
|  17* |   0 |   6 |  9 |    -6 |  52.48 | - |
|  19 |   0 |  15 |  2 |   -15 |  55.31 | yes |
|  23 |   9 |   0 | 12 |     9 |  60.55 | yes |
|  29 |   9 |  18 |  0 |    -9 |  67.62 | yes |
|  31 |   9 |  12 |  8 |    -3 |  69.81 | yes |
|  37 |  21 |  12 |  2 |     9 |  75.99 | yes |
|  41 |  15 |  24 |  0 |    -9 |  79.84 | yes |
|  43 |  15 |  24 |  2 |    -9 |  81.69 | yes |
|  47 |  24 |  15 |  6 |     9 |  85.27 | yes |
|  53 |  21 |  24 |  6 |    -3 |  90.36 | yes |
|  59 |  33 |  24 |  0 |     9 |  95.17 | yes |
|  61 |  12 |  39 |  8 |   -27 |  96.72 | yes |
|  67 |  45 |  18 |  2 |    27 | 101.22 | yes |
|  71 |  30 |  39 |  0 |    -9 | 104.11 | yes |
|  73 |  33 |  36 |  2 |    -3 | 105.53 | yes |
|  79 |  27 |  42 |  8 |   -15 | 109.66 | yes |
|  83 |  24 |  51 |  6 |   -27 | 112.33 | yes |
|  89 |  36 |  51 |  0 |   -15 | 116.21 | yes |
|  97 |  45 |  48 |  2 |    -3 | 121.19 | yes |

  p:bias for 100 < p < 200 -- 101:-3, 103:+39, 107:+21, 109:+9, 113:-51, 127:-33, 131:+63, 137:+33, 139:+9, 149:-39, 151:+69, 157:+15, 163:-27, 167:-3, 173:+33, 179:-3, 181:+9, 191:-51, 193:+57, 197:-27, 199:-3

  bound violations: none
  bias == 0 at p = none
  |bias| == 1 at p = none
  max |bias| / (2 g sqrt p) = 0.468

**m = 6, cover genus g = 8, bound B(p) = 2 g sqrt p + 3**

| p | N+ | N- | N0 | bias | B(p) | in bound |
|---|----|----|----|------|------|----------|
|   3* |   0 |   0 |  1 |     0 |  30.71 | - |
|   5 |   0 |   3 |  0 |    -3 |  38.78 | yes |
|   7 |   5 |   0 |  0 |     5 |  45.33 | yes |
|  11* |   0 |   0 |  9 |     0 |  56.07 | - |
|  13 |  11 |   0 |  0 |    11 |  60.69 | yes |
|  17 |   0 |   9 |  6 |    -9 |  68.97 | yes |
|  19 |   5 |   6 |  6 |    -1 |  72.74 | yes |
|  23 |   0 |  21 |  0 |   -21 |  79.73 | yes |
|  29 |   6 |  15 |  6 |    -9 |  89.16 | yes |
|  31* |   2 |  24 |  3 |   -22 |  92.08 | - |
|  37 |   2 |  27 |  6 |   -25 | 100.32 | yes |
|  41 |  21 |  18 |  0 |     3 | 105.45 | yes |
|  43 |  20 |  21 |  0 |    -1 | 107.92 | yes |
|  47 |  15 |  30 |  0 |   -15 | 112.69 | yes |
|  53 |  33 |  18 |  0 |    15 | 119.48 | yes |
|  59 |  21 |  36 |  0 |   -15 | 125.90 | yes |
|  61 |  23 |  36 |  0 |   -13 | 127.96 | yes |
|  67 |  20 |  39 |  6 |   -19 | 133.97 | yes |
|  71 |  39 |  24 |  6 |    15 | 137.82 | yes |
|  73 |  35 |  36 |  0 |    -1 | 139.70 | yes |
|  79 |  38 |  39 |  0 |    -1 | 145.21 | yes |
|  83 |  33 |  36 | 12 |    -3 | 148.77 | yes |
|  89 |  51 |  36 |  0 |    15 | 153.94 | yes |
|  97 |  47 |  48 |  0 |    -1 | 160.58 | yes |

  p:bias for 100 < p < 200 -- 101:-21, 103:+5, 107:-3, 109:-31, 113:-3, 127:+17, 131:+57, 137:-21, 139:+35, 149:-51, 151:-19, 157:-13, 163:-31, 167:-27, 173:+21, 179:-21, 181:+23, 191:-39, 193:-43, 197:-33, 199:-19

  bound violations: none
  bias == 0 at p = none
  |bias| == 1 at p = [19, 43, 73, 79, 97]
  max |bias| / (2 g sqrt p) = 0.311

### 6.3 The p = 11, 13 probe (exceptional harmonic-design collapse)

| m | p=11: N+ N- N0 bias | p=13: N+ N- N0 bias |
|---|---------------------|---------------------|
| 2 | 3 6 0 -3 | 3 6 2 -3 |
| 3 | 3 6 0 -3 | 2 9 0 -7 |
| 4 | 0 3 6 -3 | 6 3 2 +3 |
| 5 | 0 9 0 -9 | 0 9 2 -9 |
| 6 | 0 0 9 +0* | 11 0 0 +11 |

### 6.4 Exceptional strata: the two collapse theorems (PROVED)

Rewrite the determinant of section 1 as, with d = 2m,

    G_{d,4} = ( 1 - lambda^d - (1-lambda)^d )^2 - 4 ( lambda(1-lambda) )^d,

verified symbolically below.  Over F_p with lambda != 0, 1, the value of
lambda^d depends only on d mod (p-1).  Two residues degenerate:

**Theorem 0 (periodicity in m).**  Because the compact form involves lambda
only through lambda^d, (1-lambda)^d and u^d, the FUNCTION
lambda |-> G_{2m,4}(lambda) on F_p minus {0,1} depends only on d = 2m mod
(p-1).  Hence the whole census (N+, N-, N0, bias) is periodic in m with
period (p-1)/2.  Verified below on the full extended scan.  This is the
structural reason a fixed prime can only ever see finitely many members of
the family: the arithmetic of C_m over F_p is (p-1)/2-periodic in m, while
the genus 2m-4 grows without bound.

**Theorem A (constant-character stratum).**  If d = 2m == 0 (mod p-1) then
lambda^d = (1-lambda)^d = 1, so
    G_{2m,4} == (1-2)^2 - 4 = -3   on all of F_p minus {0,1},
hence Phi_{2m,4} == -3 / u^2 and chi(Phi) == chi(-3) is CONSTANT.  Therefore
    bias(m,p) = chi(-3) . (p-2),   chi(-3) = +1 iff p == 1 (mod 3).
The character census carries no information at all on this stratum.

**Theorem B (total-collapse stratum).**  If d = 2m == 2 (mod p-1) then
lambda^d = lambda^2 and (lambda(1-lambda))^d = u^2, so
    G_{2m,4} == (1 - lambda^2 - (1-lambda)^2)^2 - 4u^2 = (2u)^2 - 4u^2 = 0
identically on F_p minus {0,1}: the whole Veronese Gram matrix is singular
for EVERY four-point configuration over F_p.  So N0 = p-2 and bias = 0.

In m-language: Theorem A is m == 0 (mod (p-1)/2), Theorem B is
m == 1 (mod (p-1)/2).  At p = 3 both read 'every m', consistently, since
-3 == 0 (mod 3).  The smallest instances are
  Theorem B: (m,p) = (2,3), (3,5), (4,7), (5,5), (6,11), (7,13), (7,5), ...
  Theorem A: (m,p) = (2,5), (3,7), (4,5), (5,11), (6,7), (6,13), ...
This is exactly the 'exceptional harmonic-design collapse' at p = 11 and 13:
m=5/p=11 and m=6/p=13 are Theorem A (constant character, opposite signs
because 11 == 2 and 13 == 1 mod 3); m=6/p=11 and m=7/p=13 are Theorem B.

Compact determinant form verified symbolically for m = 1..12.

**Theorem C (half-order stratum).**  If d = 2m == (p-1)/2 (mod p-1) then
lambda^d = chi(lambda) in {+1,-1} for lambda != 0, so with e = chi(lambda),
f = chi(1-lambda) the compact form gives
    G == (1 - e - f)^2 - 4 e f  in  { -3  (e = f),   5  (e != f) }.
Hence chi(Phi) = chi(G) takes at most the two values chi(-3), chi(5), and
it is CONSTANT exactly when chi(-3) = chi(5), i.e. when chi(-15) = +1.
Then bias = chi(-3)(p-2) again.  Verified instances and non-instances:
    (m,p) = (4,17): 2m = 8 = (p-1)/2, chi(-15) = +1  -> constant, bias = -15
    (m,p) = (3,13): 2m = 6 = (p-1)/2, chi(-15) = -1  -> not constant
    (m,p) = (7,29): 2m = 14 = (p-1)/2, chi(-15) = -1 -> not constant
The -15 here is the same -15 that governs the m = 3 root count in
section 8, item (4): it is disc(t^2+7t+16) = disc of the 1-4u pair.

### 6.5 Extended census and independent replay through ergodis

Engine: `ergodis::character_sum::PrimeQuadraticCharacter`
  `polynomial_census_reduced`            -> chi(f(x)) census over F_p
  `linear_twist_polynomial_census_reduced` -> chi((b+a x) f(x)) census over F_p
driven by the thin front end recorded in the report appendix.

Batch: 3507 census requests (m = 2..8, odd p <= 1000).

Independent replay of the section 6.2 census (m = 2..6, p <= 199), full
field including lambda = 0, 1: disagreements = none.

Descent identity S(p) = S_1(p) + S_2(p) over m = 2..8 and every odd
p <= 1000: violations = none.

Theorem A instances (2m == 0 mod p-1) in m = 2..8, p <= 1000: 16, all
satisfying bias = chi(-3)(p-2): yes.
Theorem B instances (2m == 2 mod p-1): 7, all satisfying N0 = p-2: yes.
Theorem 0 (periodicity in m with period (p-1)/2) over m = 2..8 and every
odd p <= 1000: pairs (m,m') with 2m == 2m' mod (p-1) but different census
= none.

Collapses OUTSIDE Theorems A and B: [(4, 17, 0, 15, 0, -15), (6, 23, 0, 21, 0, -21)].
  of which explained by Theorem C (2m == (p-1)/2 mod p-1, chi(-15)=+1): [(4, 17, 0, 15, 0, -15)]
  UNEXPLAINED residue: [(6, 23, 0, 21, 0, -21)]

First instances (m, p):
  Theorem A: [(2, 3), (2, 5), (3, 3), (3, 7), (4, 3), (4, 5), (5, 3), (5, 11), (6, 3), (6, 5), (6, 7), (6, 13), (7, 3), (8, 3)]
  Theorem B: [(3, 5), (4, 7), (5, 5), (6, 11), (7, 5), (7, 7), (7, 13)]

### 6.6 The p = 11 and p = 13 probe, extended to m = 2..8

| m | p | N+ | N- | N0 | bias | stratum |
|---|---|----|----|----|------|---------|
| 2 | 11 |  3 |  6 |  0 |   -3 | ordinary |
| 2 | 13 |  3 |  6 |  2 |   -3 | ordinary |
| 3 | 11 |  3 |  6 |  0 |   -3 | ordinary |
| 3 | 13 |  2 |  9 |  0 |   -7 | ordinary |
| 4 | 11 |  0 |  3 |  6 |   -3 | ordinary |
| 4 | 13 |  6 |  3 |  2 |   +3 | ordinary |
| 5 | 11 |  0 |  9 |  0 |   -9 | A (constant chi = -1) |
| 5 | 13 |  0 |  9 |  2 |   -9 | ordinary |
| 6 | 11 |  0 |  0 |  9 |   +0 | B (total collapse) |
| 6 | 13 | 11 |  0 |  0 |  +11 | A (constant chi = +1) |
| 7 | 11 |  3 |  6 |  0 |   -3 | ordinary |
| 7 | 13 |  0 |  0 | 11 |   +0 | B (total collapse) |
| 8 | 11 |  3 |  6 |  0 |   -3 | ordinary |
| 8 | 13 |  3 |  6 |  2 |   -3 | ordinary |

So the 'exceptional harmonic-design collapse' at p = 11 and 13 is exactly
Theorems A and B: at p = 11 the strata are m == 0 and m == 1 (mod 5), at
p = 13 they are m == 0 and m == 1 (mod 6).  chi(-3) = -1 at p = 11 and
+1 at p = 13, so the constant stratum is all-nonsquare at 11 and
all-square at 13.

### 6.7 The harmonic member lambda = 1/2 and the exact bad primes (PROVED)

lambda = 1/2 is the unique fixed point of sigma, i.e. the harmonic
configuration (infty, 0, 1, 1/2), and u = 1/4 is the branch point of
lambda -> u = lambda(1-lambda).

**Theorem D.**  L_m(1/4) = 2^{1-m}, P_m(1/4) = 4(1 - 4^{1-m}),
Q_m(1/4) = 4, and therefore

    Phi_{2m,4}(1/2) = 16 ( 1 - 4^{1-m} ) = ( 4^{m-1} - 1 ) / 4^{m-3},

whose square class is that of 4^{m-1} - 1 = (2^{m-1}-1)(2^{m-1}+1).

*Proof.*  At u = 1/4 the recurrence z^2 - z + 1/4 = (z - 1/2)^2 has a
double root, so L_m(1/4) = (A + Bm) 2^{-m}; L_0 = 2 gives A = 2 and
L_1 = 1 gives B = 0.  Then P_m(1/4) = (1 - 4^{1-m})/(1/4) and
Q_m = P_m + 4 u^{m-1} adds back exactly 4 . 4^{1-m}, leaving 4.  QED

**Theorem E (harmonic bad primes).**  A simple zero of Phit at u = 1/4
pulls back to a DOUBLE zero of Phi at lambda = 1/2, because lambda = 1/2
is the ramification point of the degree-two map lambda -> u.  Hence Phi
mod p is non-squarefree whenever p | 4^{m-1} - 1.  Measured on every odd
p <= 1000: for m = 2..7 these are ALL the bad primes; at m = 8 there is
one further bad prime, p = 29, which is not a divisor of 4^7-1.

**Theorem F (the bias is odd, hence nonzero).**  N+ + N- + N0 = p-2, so
bias == p - N0 (mod 2), i.e. bias is odd iff N0 is even.  Every root of
Phi in F_p minus {0,1} lies in a sigma-orbit {lambda, 1-lambda} of size 2
except lambda = 1/2.  Hence N0 is odd iff Phi(1/2) = 0, i.e. iff
p | 4^{m-1} - 1.  So

    bias(m,p) is ODD, and in particular NONZERO, for every p not dividing
    4^{m-1} - 1.

This is why the census of section 6.2 never once returned a zero bias, and
it upgrades 'no observed zero' to a theorem.  It also subsumes Theorem B:
2m == 2 (mod p-1) forces (p-1) | 2(m-1), hence p | 4^{m-1} - 1.

| m | Phi(1/2) | 4^{m-1}-1 factored | measured bad primes (p <= 1000) |
|---|----------|--------------------|---------------------------------|
|  2 | 12 | 3 = 3 | [3] |
|  3 | 15 | 15 = 3 . 5 | [3, 5] |
|  4 | 63/4 | 63 = 3^2 . 7 | [3, 7] |
|  5 | 255/16 | 255 = 3 . 5 . 17 | [3, 5, 17] |
|  6 | 1023/64 | 1023 = 3 . 11 . 31 | [3, 11, 31] |
|  7 | 4095/256 | 4095 = 3^2 . 5 . 7 . 13 | [3, 5, 7, 13] |
|  8 | 16383/1024 | 16383 = 3 . 43 . 127 | [3, 29, 43, 127]  (extra: [29]) |

Every divisor of 4^{m-1}-1 is a bad prime, as the theorem requires.  The
converse holds exactly for m = 2..7 and FAILS first at (m,p) = (8,29):
29 does not divide 4^7-1 = 3 . 43 . 127, yet Phi_{16,4} mod 29 is not
squarefree.  So the harmonic point accounts for the bad primes of the
first six members and then stops; (8,29) is an ordinary discriminant
prime and is logged in section 8.  The two degeneracies that looked
sporadic in section 6.1 -- (m,p) = (5,17) and (6,31) -- are simply
17 | 255 = 4^4-1 and 31 | 1023 = 4^5-1.

## 7. Jacobi-sum / descent decomposition of the bias

### 7.1 The exact descent identity (proved, then verified numerically)

For u in F_p the fibre of lambda -> u = lambda(1-lambda) has
1 + chi(1-4u) points (correct also when 1-4u = 0).  Since Phi = Phit(u),

    S(p) := sum_{lambda in F_p} chi(Phi(lambda))
          = sum_{u in F_p} chi(Phit(u)) + sum_{u in F_p} chi((1-4u) Phit(u))
          =: S_1(p) + S_2(p),

which is exactly the trace decomposition of Frobenius along
Jac(C_m) ~ Jac(C_m/sigma) x Jac(C_m/sigma.h) from section 5.
Note S(p) runs over all lambda; the census bias of section 6 is
bias(m,p) = S(p) - chi(Phi(0)) - chi(Phi(1)), and Phi(0) = Phi(1) = Phit(0).

| m | p | S(p) | S_1(p) | S_2(p) | S_1+S_2 | bias | bias = S - 2 chi(Phit(0)) |
|---|---|------|--------|--------|---------|------|---------------------------|
| 3 |   3 |     0 |      0 |      0 |       0 | 0 | ok |
| 3 |   5 |     2 |     -1 |      3 |       2 | 0 | ok |
| 3 |   7 |     7 |      4 |      3 |       7 | 5 | ok |
| 3 |  11 |    -1 |      0 |     -1 |      -1 | -3 | ok |
| 3 |  13 |    -5 |     -2 |     -3 |      -5 | -7 | ok |
| 3 |  17 |    11 |      6 |      5 |      11 | 9 | ok |
| 3 |  19 |     7 |      4 |      3 |       7 | 5 | ok |
| 3 |  23 |    -1 |      0 |     -1 |      -1 | -3 | ok |
| 4 |   3 |     2 |      1 |      1 |       2 | 0 | ok |
| 4 |   5 |    -1 |     -1 |      0 |      -1 | -3 | ok |
| 4 |   7 |     2 |     -2 |      4 |       2 | 0 | ok |
| 4 |  11 |    -1 |     -1 |      0 |      -1 | -3 | ok |
| 4 |  13 |     5 |      3 |      2 |       5 | 3 | ok |
| 4 |  17 |   -13 |     -7 |     -6 |     -13 | -15 | ok |
| 4 |  19 |    -7 |     -3 |     -4 |      -7 | -9 | ok |
| 4 |  23 |    -1 |     -1 |      0 |      -1 | -3 | ok |
| 5 |   3 |     2 |      1 |      1 |       2 | 0 | ok |
| 5 |   5 |     0 |      0 |      0 |       0 | 0 | ok |
| 5 |   7 |    -1 |     -2 |      1 |      -1 | -3 | ok |
| 5 |  11 |    -7 |     -6 |     -1 |      -7 | -9 | ok |
| 5 |  13 |    -7 |     -8 |      1 |      -7 | -9 | ok |
| 5 |  17 |    -4 |     -3 |     -1 |      -4 | -6 | ok |
| 5 |  19 |   -13 |     -8 |     -5 |     -13 | -15 | ok |
| 5 |  23 |    11 |      4 |      7 |      11 | 9 | ok |

Both identities hold exactly on every tested (m,p): the descent
decomposition S = S_1 + S_2 and the correction bias = S - 2 chi(Phit(0)).

### 7.2 m = 3: the two elliptic quotients and a Jacobi-sum test

Phit_3(u) = -3*(3*u - 2)*(4*u**2 - 9*u + 6) = 3(2-3u)(4u^2-9u+6),  (1-4u) Phit_3(u) quartic.
So E_1 : y^2 = 3(2-3u)(4u^2-9u+6) and E_2 : w^2 = (1-4u)Phit_3(u), both genus 1.

j(E_1) = 357911/2160

a_p test (a_p = -S_i(p) up to the standard normalization for the affine sum):

| p | p mod 3 | p mod 4 | S_1 | S_2 | S_1=0? | S_2=0? |
|---|---------|---------|-----|-----|--------|--------|
|   3 | 0 | 3 |    0 |    0 | yes | yes |
|   5 | 2 | 1 |   -1 |    3 |  |  |
|   7 | 1 | 3 |    4 |    3 |  |  |
|  11 | 2 | 3 |    0 |   -1 | yes |  |
|  13 | 1 | 1 |   -2 |   -3 |  |  |
|  17 | 2 | 1 |    6 |    5 |  |  |
|  19 | 1 | 3 |    4 |    3 |  |  |
|  23 | 2 | 3 |    0 |   -1 | yes |  |
|  29 | 2 | 1 |   -6 |   -7 |  |  |
|  31 | 1 | 3 |   -8 |   -9 |  |  |
|  37 | 1 | 1 |   -2 |   -3 |  |  |
|  41 | 2 | 1 |   -6 |   -7 |  |  |
|  43 | 1 | 3 |    4 |    3 |  |  |
|  47 | 2 | 3 |    0 |   -1 | yes |  |
|  53 | 2 | 1 |   -6 |   -7 |  |  |
|  59 | 2 | 3 |    0 |   -1 | yes |  |
|  61 | 1 | 1 |   10 |    9 |  |  |

S_1(p) = 0 at p = [3, 11, 23, 47, 59, 71, 131, 167]
S_2(p) = 0 at p = [3]
  p mod 3 for the S_1 zeros: [0, 2]
  p mod 4 for the S_1 zeros: [3]
  p mod 3 for the S_2 zeros: [0]
  p mod 4 for the S_2 zeros: [3]

## 8. Open observations (mystery scan)

Everything here is measured, not proved.  Each item states the exact
searched range and the exact statement that held on it.

**(1) SETTLED during this pass -- the bias is never zero, and that is a
theorem, not an observation.**  The census returned no zero bias anywhere;
the ej/tt closeout traced it to the harmonic point lambda = 1/2 and turned
it into Theorems D, E, F of section 6.7:  Phi_{2m,4}(1/2) = 16(1-4^{1-m}),
the bad primes are exactly the divisors of 4^{m-1}-1, and off those primes
the bias is odd.  Nothing left open here.

**(2) Fixed bias in the genus-zero case.**  bias(2,p) = -3 for every odd
p >= 5 with no exception in p <= 199 -- the Paper V elementary count, and
the g = 0 rigidity.  Proof sketch: Phi_{4,4} = 16 I is a quadratic with
nonzero discriminant, so sum_lambda chi(16 I) = -chi(16) = -1, and
chi(Phi(0)) = chi(Phi(1)) = chi(16) = 1.

**(3) Congruence rigidity of the bias.**  Measured residues over the
non-degenerate p <= 199:
    m=2: gcd|bias| = 3, residues mod 4 = [1], mod 3 = [0]
    m=3: gcd|bias| = 1, residues mod 4 = [1], mod 3 = [0, 2]
    m=4: gcd|bias| = 3, residues mod 4 = [1, 3], mod 3 = [0]
    m=5: gcd|bias| = 3, residues mod 4 = [1, 3], mod 3 = [0]
    m=6: gcd|bias| = 1, residues mod 4 = [1, 3], mod 3 = [0, 2]
  The m = 3 column is the sharp one: every bias is == 1 (mod 4).  The
  m = 4 column is entirely divisible by 3.  Neither is explained here;
  both smell like a rational torsion / Galois-image constraint on the
  two elliptic (resp. higher-genus) quotients of section 5.

**(4) The root count of Phi_{6,4} is all-or-nothing.**  For m = 3 and every
odd p <= 199, N0(3,p) is 0 or 6 -- never 2 or 4 -- even though the six
roots split over QQ into one rational u-root (u = 2/3) and one irrational
u-pair (roots of 4u^2-9u+6).  Partial mechanism: the two roots u1, u2 of
4u^2-9u+6 satisfy (1-4u1)(1-4u2) = 16 and (1-4u1)+(1-4u2) = -7, so
1-4u_i are the roots of t^2+7t+16, of discriminant -15; and the rational
root u = 2/3 lifts to lambda iff chi(1-8/3) = chi(-15) = 1, the same
condition that splits 4u^2-9u+6.  Why the u_i then always ALSO lift is
not settled here.

**(5) Anomalously many supersingular primes for the m = 3 quotient.**
E_1 : y^2 = 3(2-3u)(4u^2-9u+6) has j = 357911/2160 = 71^3/2160, which is
not an algebraic integer, so E_1 has NO complex multiplication.  Yet
S_1(p) = -a_p(E_1) vanishes at
    p = [3, 11, 23, 47, 59, 71, 131, 167]
and, extending the same computation to p < 500, at
    [3, 11, 23, 47, 59, 71, 131, 167, 263, 311, 383, 419, 431]
-- 13 of the 94 odd primes below 500, ALL == 11 (mod 12) apart from
p = 3 (measured residues mod 12: [3, 11]).
Elkies' theorem makes supersingular
primes density zero for a non-CM curve, so this many below 500 is far too
many and the residue class is far too clean.  Either the j-invariant
computation or the non-CM conclusion needs an independent check (LMFDB
identification of the conductor would settle it in one step).  This is
the single sharpest unexplained item in the whole pass.

**(6) E_1 and E_2 are isogenous for m = 3.**  Measured: S_2(p) = S_1(p) - 1
for every non-degenerate odd p <= 199.  The leading coefficient of
(1-4u) Phit_3(u) is 144 = 12^2, a square, so S_2 = -a_p(E_2) - 1; hence
a_p(E_1) = a_p(E_2) throughout and, by Faltings, E_1 ~ E_2 over QQ.  So
Jac(C_3) ~ E_1 x E_1 up to isogeny, not a product of two distinct curves.

**(7) MOSTLY SETTLED -- the degeneracies (5,17) and (6,31) are 17 | 4^4-1
and 31 | 4^5-1** (Theorem E, section 6.7).  What remains open is the one
bad prime the harmonic point does NOT explain: (m,p) = (8,29).  It is not
in any of strata A, B, C (2m = 16, p-1 = 28) and 29 does not divide
4^7-1 = 3.43.127, yet Phi_{16,4} mod 29 has a repeated root.  Whether the
family has a second systematic source of bad primes beyond lambda = 1/2 is
the concrete question a successor should settle; scanning m up to ~20 for
bad primes not dividing 4^{m-1}-1 would answer it cheaply.

**(7b) One genuinely sporadic constant-character point.**  Over m = 2..8
and every odd p <= 1000, exactly two (m,p) have a constant nonzero
character outside Theorems A and B: (4,17), which Theorem C explains, and
(6,23), which nothing here explains.  At (6,23), 2m = 12 while
(p-1)/2 = 11, so lambda^12 runs over the whole subgroup of squares rather
than over {+1,-1}, and yet chi(Phi_{12,4}(lambda)) = -1 for all 21
admissible lambda.  This is the one unexplained exceptional stratum point
in the scanned range, and it is a concrete target for a successor task.

**(8) I-multiplicity is governed by m mod 3, exactly.**  ord_I(Phi_{2m,4})
= 2 if m == 1 (mod 3), 1 if m == 2 (mod 3), 0 if m == 0 (mod 3), for every
m in 2..12.  Proved in section 3.5 -- this one is settled, and it is
what makes m == 1 (mod 3) drop the genus from 2m-4 to 2m-5.


## 9. Ergodis interface notes

The finite-field legs of this task (sections 6.5-6.7) were run on the ergodis
kernel, as directed.  What worked, what was missing, and what a typed front end
would need:

**What fits today.**  `ergodis::character_sum::PrimeQuadraticCharacter` is an
exact match for this workload:

  - `PrimeQuadraticCharacter::new(p)` builds the odd-prime square-bit table once;
  - `reduce_coefficients(&[i128])` reduces ascending integer coefficients once,
    outside the census;
  - `polynomial_census_reduced(&[u32])` returns a `CharacterCensus` carrying
    positive / negative / zero counts and the signed sum for chi(f(x)) over the
    whole field -- exactly N+, N-, N0 and the bias of section 6;
  - `linear_twist_polynomial_census_reduced(range, coeffs, b, a)` returns the
    census of chi((b + a x) f(x)) without materializing the product -- exactly
    the twisted descent sum S_2 = sum_u chi((1-4u) Phit(u)) of section 7, with
    (b,a) = (1,-4);
  - `polynomial_census_range_reduced` splits a field into subranges and
    `CharacterCensus::checked_merge` recombines them, so a large-p sweep
    parallelizes without losing witnesses.

The whole extended sweep -- 3507 censuses over m = 2..8 and every odd prime up
to 1000 -- runs well inside a second, and it independently replays the pure
Python census of section 6.2 with zero disagreements.  That replay is the
independent-reproduction leg required by
`notes/research-reproducibility-conventions.md`: two implementations, different
languages, different algorithms for the Legendre symbol (table lookup versus
modular exponentiation), identical counts.

**What was missing.**  The kernel is a library surface only.  There is no
`ergodis` CLI subcommand for a character census, and the bundled example inputs
are all coding-theory shaped (`transfer`, `transfer-subspace`, `transfer-tower`,
`schedule`, `application`), so a polynomial character sum cannot be expressed as
CLI JSON at all.  A thin binary had to be written against the crate; its full
source is Appendix A.  Concretely, a typed algebraic front end would need:

  1. a `character-census` CLI command taking `{p, coefficients}` or
     `{p, coefficients, twist: {intercept, slope}}` and returning the
     `CharacterCensus` JSON, with a list form for batches -- this alone would
     have removed the need for Appendix A;
  2. prime *ranges* as first-class input (`p_min`, `p_max`), since the natural
     unit of work here is a sweep over p, not a single field;
  3. a general polynomial-twist census, not only a linear twist: the natural
     object in this family is chi(P(u)) chi(Q(u)) for two polynomials, which
     today has to be flattened into one product polynomial by the caller;
  4. exact squarefree / degeneracy detection mod p (`gcd(f, f')`), so bad primes
     are reported by the kernel instead of being screened in sympy first --
     this is what forced sections 6.1 and 6.7 back into Python;
  5. a genus or degree annotation on the answer so the Weil bound
     |bias| <= 2 g sqrt p can be checked in-engine rather than by the caller.

Items 1 and 2 are packaging; items 3-5 are the real gap, and all three are
invariant-theoretic metadata of exactly the kind the C1013 card's section 7
improvement notes ask for.  Nothing about the rank, orbit, span, or incidence
modules was usable for this task: the object here is a character sum on a
one-parameter family, not a code.

## Appendix A -- the ergodis census front end

A separate crate that depends on ergodis by path; ergodis itself is used
read-only.  `Cargo.toml`:

```toml
[package]
name = "c1013-census"
version = "0.1.0"
edition = "2021"

[dependencies]
ergodis = { path = "<othello>/papers/complete-repair-ports/ergodis" }

[[bin]]
name = "c1013-census"
path = "src/main.rs"
```

`src/main.rs` reads one request per stdin line and writes one JSON object per
line, with request grammar

    census <label> <p> <c0> <c1> ...            -> chi(f(x)) over all x in F_p
    twist  <label> <p> <b> <a> <c0> <c1> ...    -> chi((b + a x) f(x)) over F_p

(coefficients ascending, arbitrary integers), and body

```rust
use std::io::{self, BufRead, Write};

use ergodis::character_sum::PrimeQuadraticCharacter;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let stdin = io::stdin();
    let stdout = io::stdout();
    let mut out = stdout.lock();
    for line in stdin.lock().lines() {
        let line = line?;
        let line = line.trim();
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let fields: Vec<&str> = line.split_whitespace().collect();
        let kind = fields[0];
        let label = fields[1];
        let p: u32 = fields[2].parse()?;
        let character = PrimeQuadraticCharacter::new(p)?;
        let (intercept, slope, coefficient_start) = match kind {
            "census" => (0_i128, 0_i128, 3_usize),
            "twist" => (fields[3].parse::<i128>()?, fields[4].parse::<i128>()?, 5_usize),
            other => return Err(format!("unknown request kind {other}").into()),
        };
        let raw: Vec<i128> = fields[coefficient_start..]
            .iter()
            .map(|value| value.parse::<i128>())
            .collect::<Result<_, _>>()?;
        let reduced = character.reduce_coefficients(&raw);
        let census = match kind {
            "census" => character.polynomial_census_reduced(&reduced)?,
            _ => {
                let modulus = i128::from(p);
                character.linear_twist_polynomial_census_reduced(
                    0..p,
                    &reduced,
                    intercept.rem_euclid(modulus) as u32,
                    slope.rem_euclid(modulus) as u32,
                )?
            }
        };
        writeln!(
            out,
            "{{\"label\":\"{label}\",\"kind\":\"{kind}\",\"p\":{p},\"positive\":{},\
             \"negative\":{},\"zero\":{},\"sum\":{}}}",
            census.positive(),
            census.negative(),
            census.zero(),
            census.sum()
        )?;
    }
    Ok(())
}
```

Build and smoke test:

```text
cargo build --release --offline
printf 'census phi4-p11 11 16 -16 16\ntwist s2-p11 11 1 -4 36 -108 105 -36\n' \
  | ./target/release/c1013-census
{"label":"phi4-p11","kind":"census","p":11,"positive":5,"negative":6,"zero":0,"sum":-1}
{"label":"s2-p11","kind":"twist","p":11,"positive":4,"negative":5,"zero":2,"sum":-1}
```

Note: the crate must not live under a `noexec` mount; `/tmp/persistent` is
mounted `noexec` on this host and cargo's build scripts fail there.

Status: complete.
