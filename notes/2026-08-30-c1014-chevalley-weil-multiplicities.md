# C1014 -- closed form for the anharmonic S_3 multiplicities on C_m : y^2 = Phi_{2m,4}

**Lane:** clebsch

**Task:** C1014 successor leg -- derive the S_3-isotypic multiplicities
(a, b, c) of H^0(C_m, Omega) in closed form, prove them, and extract the
corollaries.  Closes item (4) and item (4b) of
`notes/2026-08-30-c1014-modular-structure-covers.md` section 6.

**Scope:** research note only.  No manuscript, Ergodis, or Lean source edited.

**Generator:** `notes/clebsch-tasks/c1014_chevalley_weil.py`, which also emits
and (through PARI) drives `notes/clebsch-tasks/c1014_cw_quotients.gp`.

Replay:

```text
choom -n 1000 -- uv run --with sympy python3 \
    notes/clebsch-tasks/c1014_chevalley_weil.py 40
nix shell nixpkgs#pari --command gp -q notes/clebsch-tasks/c1014_cw_quotients.gp
```

Every claim is labelled **proved**, **symbolic-verified (range)**,
**measured**, or **predicted**.

## Executive summary

1. **The multiplicities are proved in closed form.**  With
   g = g(C_m) = 2m-4-2[m == 1 mod 3],

       a = b = floor((m-2)/3),      c = (g - 2a)/2,

   equivalently a = b = q-1, c = 2q-1 for m = 3q and m = 3q+1, and
   a = b = q, c = 2q for m = 3q+2.  The main-agent conjecture is correct.
   Section 3, proof in sections 1-3, symbolic verification m = 3..40 in
   section 4, agreement with all six measured rows in section 4.

2. **a = b is forced, not a coincidence.**  Every transposition of the
   anharmonic S_3 has trace 0 on H^0(Omega) because g is even, so the
   trivial and sign multiplicities are equal for every m.  Section 2.4.

3. **The whole computation reduces to one period-6 integer sequence.**
   The trace of a 3-cycle on H^0(Omega) is -a_{g-1} where
   a_n = sum_i (-1)^i C(n-i, i) has generating function 1/(1-x+x^2) and
   period 6 (1, 1, 0, -1, -1, 0).  Since g is always == 0 or 2 (mod 6),
   only the values 0 and 1 ever occur.  Section 2.5.

4. **Theorem H is now proved for all m, not verified case by case, and it
   needs one correction.**  The exact identity

       u^2 . Phi_{2m,4} = prod_{eps,eta in {+-1}} (1 + eps lambda^m
                                                     + eta (1-lambda)^m)

   is one line from the Dickson definition, and the anharmonic invariance
   with constant 1 follows in three more.  But the NAIVE lift of
   tau : lambda -> 1/lambda satisfies (sigma tau)^3 = the hyperelliptic
   involution, not the identity: sigma and tau generate the dihedral group
   of order 12, and the honest S_3 is <sigma, tau'> with
   tau' : (lambda, y) -> (1/lambda, -y/lambda^{g+1}).  The prior report's
   conclusion (an S_3 over QQ inside Aut) stands; its explicit generator
   for tau does not.  Sections 1 and 2.2.

5. **The genus law is proved for all m.**  Phi_{2m,4} has degree 4m-6 and
   is squarefree over QQbar except at the two roots of
   I = lambda^2-lambda+1, where its multiplicity is exactly 2 and only when
   m == 1 (mod 3).  Section 1.4.

6. **The elliptic factors of both m = 5, 6 quotients, and of m = 7, are now
   identified outright -- open item (4b) is closed.**  Writing Y = y/(W
   I^{(g-2)/2}) with W = lambda(lambda-1) gives explicit models

       C_m/S_3  : Y^2 = R_m(J),     C_m/S_3' : Z^2 = (4J-27) R_m(J),
       J = I^3/W^2 the anharmonic invariant,

   and PARI returns conductors 150 and 2550 (m = 5), 1584 and 2046
   (m = 6), 637 and 6370 (m = 7).  The a_p agree with every unambiguous
   trace in the prior report.  The three sign-side conductors all exceed
   the prior level-1600 search bound, which is why that search returned
   nothing.  Section 5.

7. **The level law gains three new confirmations and becomes sharp at the
   sign side.**  Each conductor is supported on Bad(C_m), and the sign-side
   conductor uses ALL of Bad(C_m) in each of m = 5, 6, 7 while the trivial
   side uses only part.  Section 5.2.

## 0. Notation

  u = lambda(1-lambda);  W = lambda(lambda-1) = -u;
  L_m(u) = lambda^m + (1-lambda)^m  (Dickson of the first kind, argument 1):
      L_0 = 2, L_1 = 1, L_k = L_{k-1} - u L_{k-2};
  F_k(u) = (lambda^k - (1-lambda)^k)/(lambda-(1-lambda))  (second kind, in
      the indexing of the prior report, so that (1-L_m^2)' = 2 m L_m F_{m-1});
  P_m = (1-L_m^2)/u,   Phi_{2m,4} = P_m (P_m + 4 u^{m-1});
  I = lambda^2 - lambda + 1 = 1-u;
  f_m = square class of Phi_{2m,4} over QQ,  d_m = deg f_m,
      C_m : y^2 = f_m(lambda),  g = d_m/2 - 1,  k := d_m/2 = g+1;
  sigma : lambda -> 1-lambda,  tau : lambda -> 1/lambda;
  iota = the hyperelliptic involution (lambda, y) -> (lambda, -y);
  D_1 = C_m/<sigma>,  D_2 = C_m/<sigma . iota>.

## 1. The product identity, exact anharmonic invariance, and the genus law

### 1.1 The product identity (proved; symbolic-verified m = 3..40)

Put s = lambda^m, t = (1-lambda)^m, so that L_m = s+t and u^m = s t.  Then

    1 - L_m^2         = (1 - s - t)(1 + s + t),
    1 - L_m^2 + 4 u^m = 1 - (s+t)^2 + 4st = 1 - (s-t)^2
                      = (1 - s + t)(1 + s - t),

hence, multiplying and using u P_m = 1 - L_m^2,

**(1.1)   u^2 . Phi_{2m,4} = prod_{eps,eta in {+-1}} (1 + eps lambda^m
                                                        + eta (1-lambda)^m).**

This is the prior report's heuristic ("Delta . Phi = prod ...") made exact,
with Delta = u^2 and constant 1.  Verified as a polynomial identity for
m = 3..40 by the generator.

Equivalently u^2 Phi = Q(1, s, t) with
Q(A,B,C) = A^4+B^4+C^4-2A^2B^2-2B^2C^2-2C^2A^2, the symmetric quartic.

### 1.2 Degree (proved)

s+t has degree m for m even and m-1 for m odd; s-t the reverse.  So
(1-(s+t)^2)(1-(s-t)^2) has degree 2m + (2m-2) = 4m-2 either way, and

**deg Phi_{2m,4} = 4m - 6.**

### 1.3 Exact invariance (proved) -- Theorem H, corrected

Q is symmetric and even in each argument.  Therefore:

* **sigma.**  Q(1, s, t) is symmetric in s, t, so Phi(1-lambda) = Phi(lambda)
  (the u^2 prefactor is sigma-invariant).
* **tau.**  Substituting lambda -> 1/lambda multiplies the argument triple
  by lambda^{-m}: (1, lambda^{-m}, (1-1/lambda)^m) = lambda^{-m}
  (lambda^m, 1, (-1)^m (1-lambda)^m).  Q is homogeneous of degree 4 and even
  in each variable, so the (-1)^m disappears and
  Q(1,s,t)(1/lambda) . lambda^{4m} = Q(1,s,t)(lambda).  Since
  u^2(1/lambda) . lambda^4 = (lambda-1)^2 = u^2/lambda^2, dividing gives

**(1.3)   Phi_{2m,4}(1/lambda) . lambda^{4m-6} = Phi_{2m,4}(lambda),
          Phi_{2m,4}(1-lambda) = Phi_{2m,4}(lambda),**

with constant 1 and exponent exactly deg Phi.  I = lambda^2-lambda+1 obeys
the same two equations with exponent 2, so both pass to the square class:

**(1.3')  f_m(1-lambda) = f_m(lambda),  f_m(1/lambda) . lambda^{d_m} = f_m(lambda).**

This is Theorem H, now for every m rather than for m = 3..8.  Its
consequence for the group is corrected in section 2.2.

### 1.4 The genus law (proved)

Let A_{eps,eta} = 1 + eps lambda^m + eta (1-lambda)^m be the four factors of
(1.1).

*Repeated root inside one factor.*  A = A' = 0 forces
eps lambda^{m-1} = eta (1-lambda)^{m-1}; combining with A = 0 gives
eps lambda^m = -lambda and eta (1-lambda)^m = -(1-lambda), i.e.
lambda^{m-1} = -eps and (1-lambda)^{m-1} = -eta.  So lambda and 1-lambda are
both roots of unity summing to 1, which forces lambda = exp(+-i pi/3), i.e.
I(lambda) = 0 and u = 1; and then lambda^{m-1} = +-1 forces 3 | m-1.

*Common root of two factors.*  Differencing two distinct factors gives
lambda^m = 0 or (1-lambda)^m = 0, i.e. lambda in {0,1}; there exactly two
factors vanish, each simply, and the resulting double root is exactly
cancelled by the u^2 on the left of (1.1).

*Multiplicity at u = 1.*  L_m' = -m F_{m-1} and F_{m-1}(1) =
2 sin((m-1)pi/3)/sqrt 3, which vanishes iff m == 1 (mod 3); a direct
differentiation shows the zero of F_{m-1} at u = 1 is simple, so 1-L_m^2 has
a double zero there, while P_m + 4u^{m-1} takes the value 4.  u = 1 is not a
critical value of lambda -> u (the only one is u = 1/4), so each root of I is
a root of Phi of multiplicity exactly 2.

Therefore **Phi_{2m,4} is squarefree over QQbar except when m == 1 (mod 3),
where Phi = I^2 . (squarefree)**, and

**(1.4)   d_m = 4m-6-4[m == 1 mod 3],   g = 2m-4-2[m == 1 mod 3].**

For m == 2 (mod 3) the quadratic I divides Phi exactly once, so I survives in
the square class; for m == 0 (mod 3), I does not divide Phi at all.  (The
generator prints this multiplicity: 0, 2, 1 as m == 0, 1, 2 mod 3, m = 3..40.)

## 2. The exact lift and the representation on differentials

### 2.1 The lifts (proved)

d_m = 2k is even, so by (1.3') both generators lift to C_m over QQ:

    sigma : (lambda, y) -> (1-lambda, y),
    tau   : (lambda, y) -> (1/lambda, y/lambda^k),        k = g+1.

(For sigma the automorphy factor c lambda + d is 1.)  sigma^2 = tau^2 = id
exactly.

### 2.2 The group generated is dihedral of order 12 (proved)

With matrix representatives A_sigma = [[-1,1],[0,1]], A_tau = [[0,1],[1,0]]
the map gamma -> (c lambda + d)^k is a genuine automorphy factor, so the
naive lift is a homomorphism from the matrix group generated by A_sigma and
A_tau.  That group contains (A_sigma A_tau)^3 = -Id, and the automorphy
factor of -Id in weight k is (-1)^k.  Since g = 2m-4-2[m == 1 mod 3] is
always even, **k = g+1 is always odd**, so

**(2.2)   (sigma tau)^3 = iota,**

the hyperelliptic involution.  Hence <sigma, tau> is dihedral of order 12,
sigma tau has order 6, and the naive assignment sigma, tau -> S_3 is only
projective.  Abstractly D_6 = S_3 x C_2 with the C_2 generated by the central
(sigma tau)^3 = iota, so the prior report's conclusion Aut_QQ(C_m) contains
S_3 x <iota> is right, but the honest S_3 is

**(2.2')  S_3 = <sigma, tau'>,  tau' = iota . tau :
          (lambda, y) -> (1/lambda, -y/lambda^{g+1}),**

not <sigma, tau>.  Indeed tau'^2 = id and (sigma tau')^3 = iota^3 . iota =
id.  All of this is checked on the matrices for m = 3..40 (section 4).

For m == 1 (mod 3) the square-class model divides out I^2, which changes d_m
by 4 and hence k by 2; it does not change the parity of k, so (2.2) holds in
the m == 1 (mod 3) model as well.  This is why the phenomenon has no
exception.

### 2.3 The matrices (proved)

d_m = 2g+2, so omega_i = lambda^i dlambda / y, i = 0..g-1, is a basis of
H^0(C_m, Omega).  Directly:

    sigma^* omega_i = -(1-lambda)^i dlambda/y
                    = -sum_j (-1)^j C(i,j) omega_j,
    tau^*   omega_i = -lambda^{k-i-2} dlambda/y = -omega_{g-1-i},
    tau'^*  omega_i = +omega_{g-1-i}.

So the transposition tau' acts by the antidiagonal permutation matrix, and
sigma by the signed Pascal matrix S_{ji} = -(-1)^j C(i,j).

### 2.4 a = b for every m (proved)

tr(sigma^*) = -sum_{i=0}^{g-1} (-1)^i = 0 because g is even, and
tr(tau'^*) = 0 for the same reason (an even antidiagonal has no fixed index).
So the character of H^0(Omega) vanishes on the transposition class, and

**(2.4)   a = <chi, triv> and b = <chi, sgn> differ by 6^{-1} . 6 . tr(transposition) = 0,
          i.e. a = b for every m.**

Equivalently g(D_1) = g(D_2) = g/2 -- the split recorded in every row of the
prior report's section 1 table is forced, not observed.

### 2.5 The 3-cycle trace is a period-6 sequence (proved)

With S and T' the matrices of sigma^* and tau'^*,
(S T')_{ji} = -(-1)^j C(g-1-i, j), so

**(2.5)   chi(3-cycle) = tr(S T') = -sum_{i>=0} (-1)^i C(g-1-i, i) = -a_{g-1},**

where a_n = sum_i (-1)^i C(n-i,i) has generating function
sum_n a_n x^n = 1/(1-x+x^2) = (1+x)/(1+x^3), hence period 6:

    a_n = 1, 1, 0, -1, -1, 0   for n == 0,1,2,3,4,5 (mod 6).

From (1.4): m = 3q+2 gives g = 6q, m = 3q or 3q+1 gives g = 6q-4, so
**g == 0 or 2 (mod 6) always**, and only a_{g-1} in {0, 1} ever occurs.
(g == 4 mod 6 never happens; that case would have given chi(3-cycle) = +1.)

## 3. The closed form

**Theorem (S_3-isotypic multiplicities).**  Let m >= 3, g = g(C_m) as in
(1.4), and write H^0(C_m, Omega) = a . triv + b . sgn + c . std as a
representation of the anharmonic S_3 = <sigma, tau'> of (2.2').  Then

    a = (g + 3 . 0 + 2(-a_{g-1}))/6,   b = a,   c = (g + a_{g-1})/3,

i.e. explicitly

**    a = b = floor((m-2)/3),      c = (g - 2a)/2,**

equivalently

| m mod 3 | m      | g     | a = b | c    |
|---------|--------|-------|-------|------|
| 0       | 3q     | 6q-4  | q-1   | 2q-1 |
| 1       | 3q+1   | 6q-4  | q-1   | 2q-1 |
| 2       | 3q+2   | 6q    | q     | 2q   |

*Proof.*  The character values are chi(e) = g, chi(transposition) = 0 by
(2.4), chi(3-cycle) = -a_{g-1} by (2.5).  The S_3 orthogonality relations
give a = (chi(e)+3chi(t)+2chi(3))/6, b = (chi(e)-3chi(t)+2chi(3))/6,
c = (chi(e)-chi(3))/3.  Substituting and using g == 0 or 2 (mod 6) from
(1.4) gives the table; floor((m-2)/3) equals q-1 for m = 3q, 3q+1 and q for
m = 3q+2.  QED

The hyperelliptic involution acts as -1 on all of H^0(Omega), which is why
the faithful content is the quotient action of the order-12 group by <iota>;
that quotient is the anharmonic S_3, realized inside Aut(C_m) by (2.2').

### 3.1 Independent derivation by equivariant Riemann-Hurwitz / Chevalley-Weil

The 3-cycle rho_3 : lambda -> 1/(1-lambda) has exactly the two roots of I as
fixed points on the lambda-line.  Over each of them the fibre of C_m has one
point if I | f_m and two points otherwise, and rho_3, having order 3, fixes
each point of a 2-point fibre.  By section 1.4:

| m mod 3 | mult of I in Phi | I in f_m? | #Fix(rho_3) |
|---------|------------------|-----------|-------------|
| 0       | 0                | no        | 4           |
| 1       | 2                | no        | 4           |
| 2       | 1                | yes       | 2           |

Riemann-Hurwitz for the degree-3 map C_m -> C_m/<rho_3>, totally ramified at
each fixed point:  2g-2 = 6 g_3 - 6 + 2 . #Fix, so

    g_3 = (g-2)/3   for m == 0, 1 (mod 3);      g_3 = g/3   for m == 2 (mod 3).

On the other hand H^0(Omega)^{C_3} = a . triv + b . sgn (std restricts to
omega + omega^2 with no invariants), so g_3 = a + b = 2a.  Solving gives
a = (g-2)/6 and a = g/6 respectively -- the same table.  This is the
Chevalley-Weil computation the prior report asked for, and it agrees with
section 3 identically for m = 3..40 (checked by assertion in the generator).

The transposition side is the same check on the other subcover: sigma fixes
exactly the two points over the harmonic point lambda = 1/2 (f_m(1/2) != 0,
since Phi~_m(1/4) = 16(1-4^{1-m})) and SWAPS the two points at infinity
(because g is even), so #Fix(sigma) = 2 and
g(D_1) = (2g+2-2)/4 = g/2 = a+c, consistent.

## 4. Verification

The generator performs, for every m = 3..40, exact symbolic assertions on:

* the product identity (1.1);
* the two functional equations (1.3') for the square-class model f_m;
* sigma^2 = tau^2 = tau'^2 = 1, (sigma tau)^3 = -1 (i.e. = iota),
  (sigma tau')^3 = +1, and sigma (sigma tau') sigma = (sigma tau')^2;
* tr(sigma^*) = tr(tau'^*) = 0 and tr(sigma^* tau'^*) = -a_{g-1};
* a + b + 2c = g, the closed form of section 3, the genus law (1.4);
* the Riemann-Hurwitz cross-check g_3 = 2a and g(D_1) = a+c = g/2.

All pass.  Against the prior report's measured (a, b, c):

| m | g  | tr(sigma) | tr(3-cycle) | (a,b,c) derived | (a,b,c) measured |
|---|----|-----------|-------------|-----------------|------------------|
| 3 |  2 | 0         | -1          | (0, 0, 1)       | (0, 0, 1)        |
| 4 |  2 | 0         | -1          | (0, 0, 1)       | (0, 0, 1)        |
| 5 |  6 | 0         |  0          | (1, 1, 2)       | (1, 1, 2)        |
| 6 |  8 | 0         | -1          | (1, 1, 3)       | (1, 1, 3)        |
| 7 |  8 | 0         | -1          | (1, 1, 3)       | (1, 1, 3)        |
| 8 | 12 | 0         |  0          | (2, 2, 4)       | (2, 2, 4)        |

and the continuation, all **proved** (no measurement exists beyond m = 8):

| m  |  9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
|----|----|----|----|----|----|----|----|----|----|----|----|----|
| g  | 14 | 14 | 18 | 20 | 20 | 24 | 26 | 26 | 30 | 32 | 32 | 36 |
| a=b|  2 |  2 |  3 |  3 |  3 |  4 |  4 |  4 |  5 |  5 |  5 |  6 |
| c  |  5 |  5 |  6 |  7 |  7 |  8 |  9 |  9 | 10 | 11 | 11 | 12 |

## 5. Corollaries

### 5.1 Isotypic decomposition of the Jacobian (proved, up to isogeny)

    Jac(C_m) ~ A_triv x A_sgn x A_std^2,
    dim A_triv = dim A_sgn = a = floor((m-2)/3),   dim A_std = c,
    Jac(D_1) ~ A_triv x A_std,   Jac(D_2) ~ A_sgn x A_std,
    A_triv = Jac(C_m/S_3),  A_sgn = Jac(C_m/S_3'),  S_3' = <rho_3, sigma.iota>.

Growth.  a increases by 1 and c by 2 every time m increases by 3, and the
isotypic fractions of g are

    dim A_triv / g = dim A_sgn / g -> 1/6,      2 . dim A_std / g -> 2/3,

exactly 1/6 and 2/3 on the m == 2 (mod 3) subfamily.  So the "new" standard
part carries two thirds of the Jacobian asymptotically and the two
one-dimensional characters share the remaining third.

The jumps of dim A_triv are at m == 2 (mod 3): a is constant on each block
{3q+2, 3q+3, 3q+4}.  The prior report observed the jump from 1 to 2 between
m = 7 and m = 8; the next jumps are at m = 11 (a = 3) and m = 14 (a = 4),
**proved**.  At m = 8 the trivial part is an abelian surface -- section 5.3
writes its genus-2 curve down.

### 5.2 Explicit models for A_triv and A_sgn, and the conductors

Homogenising lambda = X/Z, the anharmonic group has covariant forms

    I = X^2-XZ+Z^2  (degree 2, multipliers sigma:+1, tau:+1),
    W = XZ(X-Z)     (degree 3, sigma:+1, tau:-1),
    V = (2X-Z)(X+Z)(X-2Z)  (degree 3, sigma:-1, tau:+1),

with the classical syzygy **V^2 = 4 I^3 - 27 W^2** (verified symbolically).
J = I^3/W^2 generates QQ(lambda)^{S_3}, and K = V/W transforms by the sgn
character.  Under the naive lift y pulls back by (c lambda+d)^{-k}, so for a
degree-k covariant Omega with multipliers (sigma:+1, tau:-1) the function
Y = y/Omega is invariant under the honest S_3 of (2.2').  k is odd, so

    Omega = W . I^{(k-3)/2},      Y = y / (W I^{(g-2)/2}),
    Y^2 = f_m / (u^2 I^{k-3}) = R_m(J),
    Z = K . Y,   Z^2 = (4J-27) . R_m(J)     (since K^2 = V^2/W^2 = 4J-27).

Hence, **proved**:

    C_m/S_3  : Y^2 = R_m(J),        C_m/S_3' : Z^2 = (4J-27) R_m(J),

a pair differing exactly by the sign covariant -- the S_3-level analogue of
the prior report's observation that D_2 is D_1 with the single extra branch
point (1-4u).  The extra branch point here is J = 27/4, the harmonic orbit.

Computed square-class models (symbolic-verified; the genus equals a in every
case, an independent confirmation of section 3):

| m | a | R_m(J) (trivial part)                                | genus | (4J-27)R_m genus |
|---|---|------------------------------------------------------|-------|------------------|
| 3 | 0 | 3(12J-1)                                             | 0     | 0                |
| 4 | 0 | 16(4J+1)                                             | 0     | 0                |
| 5 | 1 | 5 J (20J^2+25J+8)                                    | 1     | 1                |
| 6 | 1 | (2J+3)(72J^2+102J-1)                                 | 1     | 1                |
| 7 | 1 | 7(28J^3+147J^2+196J+8)                               | 1     | 1                |
| 8 | 2 | 16 J (J+4)(16J^3+68J^2+16J+1)                        | 2     | 2                |

m = 3, 4 give genus 0, which **settles** the ambiguity the prior report
flagged in its section 3.3: C_3/S_3 and C_4/S_3 are rational, so
(a,b,c) = (0,0,1) and not (1,1,0), and Jac(C_3) ~ E^2, Jac(C_4) ~ E'^2.

PARI (`ellfromeqn`, `ellminimalmodel`, `ellglobalred`, `ellap`) on the four
genus-1 rows:

| curve       | conductor | factorisation      | Bad(C_m)        |
|-------------|-----------|--------------------|-----------------|
| m=5 A_triv  |      150  | 2 . 3 . 5^2        | {2, 3, 5, 17}   |
| m=5 A_sgn   |     2550  | 2 . 3 . 5^2 . 17   | {2, 3, 5, 17}   |
| m=6 A_triv  |     1584  | 2^4 . 3^2 . 11     | {2, 3, 11, 31}  |
| m=6 A_sgn   |     2046  | 2 . 3 . 11 . 31    | {2, 3, 11, 31}  |
| m=7 A_triv  |      637  | 7^2 . 13           | {2, 5, 7, 13}   |
| m=7 A_sgn   |     6370  | 2 . 5 . 7^2 . 13   | {2, 5, 7, 13}   |

Cross-check against the prior report's unambiguous L-polynomial traces
(section 3.2 there): a_p agrees at every listed prime, e.g. m5D1
a_11=+2, a_31=-8; m5D2 a_11=-4, a_31=+4; m6D1 a_7=-4, a_13=-2, a_17=+2,
a_19=0, a_29=+6, a_37=+6; m6D2 a_7=-2, a_13=-4, a_17=-6, a_19=-2, a_29=-6,
a_37=-2; m7D1 a_11=-3, a_23=-6, a_29=-5; m7D2 a_11=+3, a_23=-6, a_29=+3.

**This closes open item (4b) of the prior report.**  The two sign-side
elliptic curves at m = 5 and m = 6 have conductors 2550 and 2046, both above
the level-1600 bound of that report's newform search, which is the whole
reason it found nothing.  m = 7 is a new data point at both ends.

Level law, sharpened (**measured**, m = 5, 6, 7; the m = 3, 4 rows of the
prior report agree): every conductor is supported on Bad(C_m), and the
**trivial-side conductor omits at least one bad prime while the sign-side
conductor uses all of Bad(C_m)** -- in all three rows cond(A_sgn) is
divisible by every prime of Bad(C_m) with no exception.  That is the expected
effect of the extra branch point J = 27/4, the harmonic orbit {1/2, -1, 2},
whose square class is governed by Phi~_m(1/4) = 16(1-4^{1-m}).  The primes
the trivial side drops are 17 at m = 5, 31 at m = 6, and {2, 5} at m = 7; at
m = 5, 6 that is the largest harmonic prime, but m = 7 breaks that finer
pattern (13 in H(7) = {5,7,13} does divide 637), so only the coarse statement
is supported.  Stated as a **prediction** for m >= 8: cond(A_sgn) is
divisible by every prime of Bad(C_m), while cond(A_triv) is a proper divisor
of the same support.

### 5.3 The abelian surface at m = 8 (proved model, unidentified)

At m = 8 the trivial part is the Jacobian of the genus-2 curve

    Y^2 = 16 J (J+4)(16J^3 + 68J^2 + 16J + 1),

and the sign part is the Jacobian of Y^2 = (4J-27) times the same cubic
product (genus 2).  This is the derived form of the prior report's
observation that the m = 8 L-polynomial always splits as 4 + 8.  Identifying
these two abelian surfaces (split or simple, and their conductors) is the
natural successor computation; it is not done here.

## 6. Open observations and mystery ledger

**(1) SETTLED -- the multiplicities.**  a = b = floor((m-2)/3),
c = (g-2a)/2, proved twice (character computation, section 3; equivariant
Riemann-Hurwitz, section 3.1) and symbolically verified m = 3..40.  The
main-agent conjecture was exactly right.

**(2) SETTLED -- why a = b.**  g is even, so every transposition has trace 0.
There is no m at which a != b, and no sporadic correction anywhere in the
closed form: the only arithmetic input is m mod 3, entering through the
genus law and through whether I divides the square-class model.

**(3) SETTLED -- the group.**  <sigma, tau> is dihedral of order 12 with
(sigma tau)^3 = iota, because k = g+1 is always odd.  The honest S_3 needs
tau' = iota . tau.  The prior report's Theorem H statement is correct as an
abstract containment and wrong as an explicit generator list.

**(4) SETTLED -- the genus law, now proved rather than tabulated.**  The only
repeated root of Phi_{2m,4} over QQbar is at I = 0, of multiplicity exactly
2, exactly when m == 1 (mod 3).  Section 1.4.  This upgrades the prior
report's m = 2..12 table to a theorem.

**(5) SETTLED -- the conductors of the D_2 elliptic factors (prior item 4b).**
2550 at m = 5 and 2046 at m = 6, from explicit models, with 637/6370 as a new
m = 7 pair.  Section 5.2.

**(6) OPEN -- why g == 4 (mod 6) never occurs.**  The character formula would
give chi(3-cycle) = +1 and hence a = (g+2)/6, c = (g-1)/3 there, a third
branch of the closed form that the family never reaches.  It is excluded only
because the genus law happens to produce g == 0 or 2 (mod 6).  The exclusion
is a consequence of two independent facts (deg Phi = 4m-6 and the m == 1 mod 3
degree drop of 4) that have no common cause visible here.  Exact statement:
for all m in 3..40, g mod 6 in {0, 2}; proved for all m from (1.4).

**(7) OPEN -- the m = 8 abelian surfaces.**  Models in section 5.3; split or
simple, and their conductors, not determined.

**(8) OPEN -- the sign-side level law.**  The pattern "cond(A_sgn) uses all
of Bad(C_m), cond(A_triv) uses only part of it" is measured at three
consecutive m only, and which primes the trivial side drops is not explained.  A conductor computation at m = 9, 10 (where a = 2 and
the isotypic pieces are surfaces) would test it, but needs a genus-2
conductor, not `ellglobalred`.

**(9) OPEN -- the exponent structure of the conductors.**  cond(A_triv) at
m = 6 is 2^4 . 3^2 . 11 while cond(A_sgn) is 2 . 3 . 11 . 31: the trivial
side is additive at 2 and 3 and the sign side multiplicative there.  The
same flip appears at m = 5 (2 . 3 . 5^2 vs 2 . 3 . 5^2 . 17: same exponents)
and m = 7 (7^2 . 13 vs 2 . 5 . 7^2 . 13).  So m = 6 is the only row where the
exponents differ between the two isotypic sides, and nothing here explains
why.

No genuine mystery remains in the multiplicity question itself; items (6)-(9)
are downstream arithmetic of the pieces, not gaps in the derivation.

Status: complete.
