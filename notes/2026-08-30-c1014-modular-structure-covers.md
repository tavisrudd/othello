# C1014 -- modular structure of the descent quotients of y^2 = Phi_{2m,4}

**Lane:** clebsch

**Task:** C1014 (modular identification of the quotient curves of the
four-point Gram invariant family; sporadic strata).

**Scope:** research note only.  No manuscript, Ergodis, or Lean source edited.

**Generator:** `notes/clebsch-tasks/c1014_modular_structure.py` -- this file
is machine-emitted by that script, which also writes and runs the generated
PARI scripts `c1014_curves.gp` and `c1014_hyperell.gp` in the same directory
and drives the C1013 ergodis census front end.

Replay:

```text
uv run --with sympy python3 notes/clebsch-tasks/c1014_modular_structure.py \
    notes/2026-08-30-c1014-modular-structure-covers.md
```

Prerequisite context: `notes/2026-08-30-c1013-c1014-phi-family-arithmetic.md`
(Phi_{2m,4} = P_m (P_m + 4u^{m-1}), P_m = (1-L_m^2)/u, L_m Dickson; the
descent S = S_1 + S_2; Theorems A/B/C).  The PARI legs need a few minutes;
the modular-level search of section 3.4 dominates the runtime.

## Executive summary

1. **The genus law of the prior report is off by one at m == 1 (mod 3).**
   g(C_m) = 2m-4, dropping to 2m-6 (not 2m-5) when m == 1 (mod 3), because
   the repeated part I^2 must be divided out whole.  The same slip made
   chi(Phi) = chi(radical) instead of chi(Phi/I^2) in that report's
   section 6 preamble.  Section 1.

2. **Both m = 4 quotients are elliptic of conductor 14** -- the unique
   level-14 newform (class 14a).  Across m = 4, 5, 6 these are the only
   genus-1 quotients.  Section 2.

3. **The supersingular congruence has a one-line cause.**  L = lcm of the
   rational torsion orders across the isogeny class divides p+1 at every
   supersingular p, so m = 3 forces p == 11 (mod 12) (L = 12) and m = 4
   forces only p == 5 (mod 6) (L = 6).  Exhaustive on p < 2000.  Section 2.1.

4. **The higher-genus quotients are split, and the reason is an anharmonic
   S_3 on the parent curve.**  The square-class model of Phi_{2m,4} is
   EXACTLY invariant under the anharmonic group acting on lambda, with
   constant 1, so Aut_QQ(C_m) contains S_3 (Theorem H).  Decomposing
   H^0(Omega) as a.triv + b.sgn + c.std gives g(C_m) = a+b+2c,
   g(D_1) = a+c, g(D_2) = b+c, and the measured multiplicities are (0,0,1)
   at m = 3,4; (1,1,2) at m = 5; (1,1,3) at m = 6,7; (2,2,4) at m = 8.  So
   for m >= 5 Jac(D_1) contains Jac(C_m/S_3) -- an elliptic curve for
   m = 5,6,7, an abelian surface at m = 8 -- even though D_1 itself has
   trivial reduced automorphism group; that is why the L-polynomial always
   factors.  At m = 3,4 the trivial and sign parts vanish and D_1, D_2 are
   the same isogeny factor, which is why the prior report found
   a_p(E_1) = a_p(E_2).  The new elliptic factors are the level-150 (m = 5)
   and level-1584 (m = 6) newforms.  Section 3.

5. **Exact bad-prime law.**  Bad(C_m) = {2} u H(m) u M(m) u E(m) from three
   distinct geometric sources -- the harmonic point lambda = 1/2, the
   collision locus u = 0 (which is where p | m enters), and a genuine double
   branch point where L_m^2-1 and F_{m-1} collide.  Matches every m = 2..12
   with no exception, and closes the prior report's (8,29) puzzle.
   Section 4.

6. **The (6,23) collapse is a stratum, not an accident of that one point.**
   It is r = 2m == (p-1)/2 + 1 (mod p-1), where lambda^r = chi(lambda) lambda
   and the character becomes -1 outside the doubly-nonsquare set and
   chi(lambda^2-lambda+1) on it.  (5,19) is the same stratum.  What is
   accidental at p = 23 is only that the residual character is -1 on all six
   residual points.  Section 5, with a complete classification of every
   constant-character stratum for p <= 300.

## 1. The u-descent quotients D_1, D_2 and a corrected genus law

Method: exact `sympy.factor_list` square-class reduction over QQ.  For
y^2 = f the normalization only sees the product of the ODD-multiplicity
irreducible factors (a repeated square factor h^2 is removed by
y -> y/h), so the genus is floor((deg sqcl(f) - 1)/2) with sqcl the
square-class part -- NOT the radical.

| m | deg Phi | deg sqcl Phi | g(C_m) | 2m-4 | radical genus (prior) | deg sqcl Phit | g(D_1) | deg sqcl (1-4u)Phit | g(D_2) | g1+g2 |
|---|---------|--------------|--------|------|-----------------------|---------------|--------|---------------------|--------|-------|
|  2 |       2 |            2 |      0 |    0 |                     0 |             1 |      0 |                   2 |      0 |     0 |
|  3 |       6 |            6 |      2 |    2 |                     2 |             3 |      1 |                   4 |      1 |     2 |
|  4 |      10 |            6 |      2 |    4 |                     3 |             3 |      1 |                   4 |      1 |     2 |
|  5 |      14 |           14 |      6 |    6 |                     6 |             7 |      3 |                   8 |      3 |     6 |
|  6 |      18 |           18 |      8 |    8 |                     8 |             9 |      4 |                  10 |      4 |     8 |
|  7 |      22 |           18 |      8 |   10 |                     9 |             9 |      4 |                  10 |      4 |     8 |
|  8 |      26 |           26 |     12 |   12 |                    12 |            13 |      6 |                  14 |      6 |    12 |
|  9 |      30 |           30 |     14 |   14 |                    14 |            15 |      7 |                  16 |      7 |    14 |
| 10 |      34 |           30 |     14 |   16 |                    15 |            15 |      7 |                  16 |      7 |    14 |
| 11 |      38 |           38 |     18 |   18 |                    18 |            19 |      9 |                  20 |      9 |    18 |
| 12 |      42 |           42 |     20 |   20 |                    20 |            21 |     10 |                  22 |     10 |    20 |

g(C_m) = 2m-4 except at m = [4, 7, 10], i.e. exactly m == 1 (mod 3), where
g(C_m) = 2m-6.  **This corrects the 2m-5 recorded in the C1013/C1014
arithmetic report**, which used the radical of Phi rather than its
square class: at m == 1 (mod 3) the repeated part is exactly I^2 with
I = lambda^2-lambda+1, and dividing it out drops the degree by 4, not by 2.
The same correction applies to the character statement of that report:
chi(Phi) = chi(Phi/I^2) = chi(sqcl Phi), and chi(radical) = chi(I) chi(sqcl)
differs from it whenever chi(I) = -1.  The genus split g = g1 + g2 holds
in every row, so the Klein-four descent Jac(C_m) ~ Jac(D_1) x Jac(D_2) is
unaffected.

### 1.1 Explicit quotient models

D_1 : y^2 = sqcl Phit_m(u)   (the sigma-quotient C_m/<sigma>)
D_2 : w^2 = sqcl (1-4u) Phit_m(u)   (the twisted quotient C_m/<sigma.h>)

m = 3:  g(C_m) = 2 = 1 + 1
  D_1 (g=1):  y^2 = -3*(3*u - 2)*(4*u**2 - 9*u + 6)
  D_2 (g=1):  w^2 = 3*(3*u - 2)*(4*u - 1)*(4*u**2 - 9*u + 6)
m = 4:  g(C_m) = 2 = 1 + 1
  D_1 (g=1):  y^2 = -(u - 2)*(4*u**2 - 5*u + 2)
  D_2 (g=1):  w^2 = (u - 2)*(4*u - 1)*(4*u**2 - 5*u + 2)
m = 5:  g(C_m) = 6 = 3 + 3
  D_1 (g=3):  y^2 = -5*(u - 1)*(5*u**2 - 5*u + 2)*(4*u**4 - 25*u**3 + 50*u**2 - 35*u + 10)
  D_2 (g=3):  w^2 = 5*(u - 1)*(4*u - 1)*(5*u**2 - 5*u + 2)*(4*u**4 - 25*u**3 + 50*u**2 - 35*u + 10)
m = 6:  g(C_m) = 8 = 4 + 4
  D_1 (g=4):  y^2 = -(2*u**2 - 9*u + 6)*(2*u**3 - 9*u**2 + 6*u - 2)*(36*u**4 - 105*u**3 + 112*u**2 - 54*u + 12)
  D_2 (g=4):  w^2 = (4*u - 1)*(2*u**2 - 9*u + 6)*(2*u**3 - 9*u**2 + 6*u - 2)*(36*u**4 - 105*u**3 + 112*u**2 - 54*u + 12)

Both quotients always carry the same square class except for the factor
(1-4u) = delta^2, so D_2 is the curve obtained from D_1 by adjoining the
single extra branch point u = 1/4 (the harmonic point lambda = 1/2) and,
when deg sqcl Phit is odd, dropping the branch point at infinity.

## 2. Modular identification of the genus-1 quotients (task 2)

Across m = 4, 5, 6 the ONLY genus-1 quotients are D_1 and D_2 at m = 4
(m = 5 gives 3 + 3, m = 6 gives 4 + 4).  The m = 3 pair is included as the
anchor already identified in the prior report.

Method: PARI/GP 2.17.3 `ellfromeqn` (Jacobian of the plane model), then
`ellminimalmodel`, `ellglobalred`, `elltors`, `ellisomat`, `ellap`.
Generated script `notes/clebsch-tasks/c1014_curves.gp`.

| quotient | minimal model [a1,a2,a3,a4,a6] | conductor | j | torsion | isogeny degrees from this curve |
|----------|-------------------------------|-----------|---|---------|-------------------------------|
| m3D1 | [1, -1, 1, 13, -61] | 90 = [2, 3, 5; 1, 2, 1] | 357911/2160 | Z/4 | [1, 2, 4, 4, 3, 6, 12, 12] |
| m3D2 | [1, -1, 1, -122, 1721] | 90 = [2, 3, 5; 1, 2, 1] | -273359449/1536000 | Z/12 | [1, 2, 4, 4, 3, 6, 12, 12] |
| m4D1 | [1, 0, 1, -1, 0] | 14 = [2, 7; 1, 1] | -15625/28 | Z/6 | [1, 3, 9, 2, 6, 18] |
| m4D2 | [1, 0, 1, 4, -6] | 14 = [2, 7; 1, 1] | 9938375/21952 | Z/6 | [1, 3, 3, 2, 6, 6] |

### 2.1 Isogeny classes and the forced supersingular congruence

The a_p sequence is an isogeny-class invariant, so at a supersingular prime
(a_p = 0, good reduction, p > 2) EVERY curve E' in the class has
#E'(F_p) = p+1; rational torsion of E' injects into E'(F_p), so
L := lcm over the class of the rational torsion orders divides p+1.
This is the sharp form of the argument the prior report gave for m = 3 in
the special case Z/4 plus a rational 3-isogeny.

| quotient | torsion orders across the isogeny class | L = lcm | forced congruence | #{ss p < 2000} | measured p mod L |
|----------|------------------------------------------|---------|-------------------|----------------|------------------|
| m3D1 | [4, 4, 2, 2, 12, 12, 6, 6] | 12 | p == -1 (mod 12) | 20 | [11] |
| m3D2 | [12, 12, 6, 6, 4, 4, 2, 2] | 12 | p == -1 (mod 12) | 20 | [11] |
| m4D1 | [6, 6, 2, 6, 6, 2] | 6 | p == -1 (mod 6) | 13 | [5] |
| m4D2 | [6, 6, 2, 6, 6, 2] | 6 | p == -1 (mod 6) | 13 | [5] |

m3D1: supersingular p < 2000 = [11, 23, 47, 59, 71, 131, 167, 263, 311, 383, 419, 431, 719, 887, 1103, 1259, 1439, 1811, 1931, 1979]
  residues mod 12: [11];  residues mod 12: [11]
m3D2: supersingular p < 2000 = [11, 23, 47, 59, 71, 131, 167, 263, 311, 383, 419, 431, 719, 887, 1103, 1259, 1439, 1811, 1931, 1979]
  residues mod 12: [11];  residues mod 12: [11]
m4D1: supersingular p < 2000 = [5, 11, 23, 71, 101, 263, 503, 1031, 1283, 1487, 1511, 1583, 1637]
  residues mod 6: [5];  residues mod 12: [5, 11]
m4D2: supersingular p < 2000 = [5, 11, 23, 71, 101, 263, 503, 1031, 1283, 1487, 1511, 1583, 1637]
  residues mod 6: [5];  residues mod 12: [5, 11]

Every supersingular prime below 2000 lies in the single forced class in each
case, so the congruence is not merely consistent, it is exhaustive on the
searched range.  For m = 3 the class contains a curve with rational Z/12,
so 12 | p+1 and every supersingular p == 11 (mod 12) -- the prior report's
observation, now with a one-line cause.  For m = 4 the class maximum is
Z/6, so the forced class is only p == 5 (mod 6), and indeed the measured
residues mod 12 are BOTH 5 and 11: the m = 3 mod-12 rigidity does not
persist to m = 4, only its mod-6 shadow does.

### 2.2 The weight-2 newform

  level 14: 1 newforms, rational ones with a_1..a_12 = [[1, -1, -2, 1, 0, 2, 1, -1, 1, 0, 0, -2]]
  level 90: 3 newforms, rational ones with a_1..a_12 = [[1, -1, 0, 1, 1, 0, 2, -1, 0, -1, 6, 0], [1, 1, 0, 1, 1, 0, -4, 1, 0, 1, 0, 0], [1, 1, 0, 1, -1, 0, 2, 1, 0, -1, -6, 0]]

  m3D1 a_p (p < 45): [[7, -4], [11, 0], [13, 2], [17, -6], [19, -4], [23, 0], [29, 6], [31, 8], [37, 2], [41, 6], [43, -4]]
  m3D2 a_p (p < 45): [[7, -4], [11, 0], [13, 2], [17, -6], [19, -4], [23, 0], [29, 6], [31, 8], [37, 2], [41, 6], [43, -4]]
  m4D1 a_p (p < 45): [[3, -2], [5, 0], [11, 0], [13, -4], [17, 6], [19, 2], [23, 0], [29, -6], [31, -4], [37, 2], [41, 6], [43, 8]]
  m4D2 a_p (p < 45): [[3, -2], [5, 0], [11, 0], [13, -4], [17, 6], [19, 2], [23, 0], [29, -6], [31, -4], [37, 2], [41, 6], [43, 8]]

Level 14 carries a unique newform and it matches both m = 4 quotients, so
the m = 4 shadow census is the level-14 weight-2 newform (Cremona class 14a).
Level 90 carries three rational newforms; the one with a_7 = -4 is the m = 3
match, and it is the unique one with that a_7, so the m = 3 census is pinned
to a single level-90 newform without needing the Cremona tables.

Both m = 3 quotients and both m = 4 quotients sit in one isogeny class, so
Jac(C_3) ~ E^2 and Jac(C_4) ~ E'^2 with E of conductor 90 and E' of
conductor 14.  Section 3.3 identifies the reason: at m = 3, 4 the trivial
and sign parts of the S_3-representation vanish and the whole Jacobian is
the two-dimensional standard part, whose two copies are the two quotients.

## 3. The higher-genus quotients: split or simple? (task 3)

### 3.1 Reduced automorphism groups (geometric test)

Method: exact branch divisor (roots of the square-class model plus the point
at infinity when the degree is odd) computed to 50 digits, then an exhaustive
search over the Mobius maps carrying one fixed branch triple to every ordered
branch triple, keeping those that preserve the whole divisor.  For a
hyperelliptic curve this is Aut(D)/<hyperelliptic involution>.  Control:
y^2 = (u^2-1)(u^2-4)(u^2-9)(u^2-16) returns 2, as it must.

| quotient | genus | branch points | reduced Aut order |
|----------|-------|---------------|-------------------|
| m5D1 | 3 | 8 | 1 |
| m5D2 | 3 | 8 | 1 |
| m6D1 | 4 | 10 | 1 |
| m6D2 | 4 | 10 | 1 |
| C_3 (the lambda-line cover itself) | 2 | 6 | 6 |
| C_4 (the lambda-line cover itself) | 2 | 6 | 6 |
| C_5 (the lambda-line cover itself) | 6 | 14 | 6 |
| C_6 (the lambda-line cover itself) | 8 | 18 | 6 |
| control y^2=(u^2-1)(u^2-4)(u^2-9)(u^2-16) | 3 | 8 | 2 |

All four higher-genus quotients have TRIVIAL reduced automorphism group: the
branch locus in the u-line has no Mobius symmetry at all, so nothing splits
Jac(D_1) or Jac(D_2) from inside the quotient curve.

The lambda-line covers C_m, however, have reduced automorphism group of
order 6 -- the full ANHARMONIC group.  That is the answer to the splitting
question, and it is exact, not numerical:

**Theorem H (anharmonic symmetry of the branch locus).**  Let f_m denote the
square-class model of Phi_{2m,4} in lambda, of even degree d_m.  For every
element tau : lambda -> (a lambda + b)/(c lambda + d) of the anharmonic
group generated by lambda -> 1-lambda and lambda -> 1/lambda,

    f_m(tau(lambda)) . (c lambda + d)^{d_m} = f_m(lambda)   exactly,

with constant 1.  Since d_m is even, (c lambda + d)^{d_m} is a square in
QQ(lambda), so tau lifts to an automorphism of C_m DEFINED OVER QQ:
    (lambda, y)  |->  ( tau(lambda),  y / (c lambda + d)^{d_m/2} ).
Hence Aut_QQ(C_m) contains S_3 x <hyperelliptic involution>.

Verified symbolically (exact polynomial identity, all five nontrivial
elements of the anharmonic group): m=3 (deg 6): exact, m=4 (deg 6): exact, m=5 (deg 14): exact, m=6 (deg 18): exact, m=7 (deg 18): exact, m=8 (deg 26): exact

Conceptual reason: Delta . Phi_{2m,4} = prod_{eps,eta} (1 + eps lambda^m +
eta (1-lambda)^m), and the anharmonic group permutes the three quantities
1, lambda, lambda-1 projectively; raising them to the m-th power and taking
the product over all sign patterns is invariant under that permutation.

**Consequence (the splitting mechanism).**  Write H^0(C_m, Omega) as an
S_3-representation, a . triv + b . sgn + c . std.  With sigma a transposition
(sigma : lambda -> 1-lambda, which acts trivially on y since c = 0, d = 1),

    g(C_m) = a + b + 2c,   g(D_1) = a + c,   g(D_2) = b + c,

because D_1 = C_m/<sigma> takes sigma-invariants and D_2 = C_m/<sigma . h>
takes sigma-anti-invariants.  So Jac(D_1) ~ A_triv x A_std and
Jac(D_2) ~ A_sgn x A_std with A_triv = Jac(C_m/S_3): the quotients are split
whenever a and c are both nonzero, and the splitting is NOT visible as an
automorphism of D_1 because the order-3 element does not descend.  This is
exactly the situation section 3.2 measures.

### 3.2 L-polynomial factorization over QQ, odd good p <= 200

Method: PARI `hyperellcharpoly` on the square-class model reduced mod p,
then `factor` of the degree-2g characteristic polynomial of Frobenius over QQ.
A degree-2 factor T^2 - aT + p is recorded with its trace a.  Generated
script `notes/clebsch-tasks/c1014_hyperell.gp`.

| quotient | genus | good p tested | p with a degree-2 factor | distinct degree patterns |
|----------|-------|---------------|--------------------------|--------------------------|
| m5D1 | 3 | 42 | 42 | [[2, 2, 2], [2, 4]] |
| m5D2 | 3 | 42 | 42 | [[2, 2, 2], [2, 4]] |
| m6D1 | 4 | 42 | 42 | [[2, 2, 2, 2], [2, 2, 4], [2, 6]] |
| m6D2 | 4 | 42 | 42 | [[2, 2, 2, 2], [2, 2, 4], [2, 6]] |
| control-g4-a | 4 | 43 | 1 | [[2, 6], [4, 4], [8]] |
| control-g4-b | 4 | 45 | 1 | [[2, 6], [4, 4], [8]] |
| control-g3-a | 3 | 44 | 2 | [[2, 2, 2], [2, 4], [6]] |
| control-g3-b | 3 | 42 | 5 | [[2, 2, 2], [2, 4], [6]] |

m5D1: unambiguous elliptic traces (exactly one degree-2 factor):
  11:+2, 31:-8, 41:+2, 47:-8, 59:+10, 61:+2, 71:+12, 73:-4, 79:+0, 83:-4, 89:-10, 97:-8, 101:-8, 103:-14, 107:+12, 127:+2, 131:-18, 139:-20, 149:-20, 157:+22, 167:+12, 179:+10, 193:-4, 197:+22
m5D2: unambiguous elliptic traces (exactly one degree-2 factor):
  11:-4, 31:+4, 41:+8, 47:-8, 59:-6, 61:+14, 71:+2, 73:-4, 79:+0, 83:+16, 89:-2, 97:+0, 101:+8, 103:+12, 107:-12, 127:+4, 131:-16, 139:-20, 149:+16, 157:+4, 167:+12, 179:+6, 193:-24, 197:+26
m6D1: unambiguous elliptic traces (exactly one degree-2 factor):
  7:-4, 13:-2, 17:+2, 19:+0, 29:+6, 37:+6, 41:+2, 43:+0, 47:+8, 53:-6, 59:-4, 61:+6, 71:+0, 73:-14, 79:+4, 89:+6, 97:+2, 101:-2, 107:-12, 109:-2, 127:+4, 137:-2, 139:+8, 149:+22
m6D2: unambiguous elliptic traces (exactly one degree-2 factor):
  7:-2, 13:-4, 17:-6, 19:-2, 29:-6, 37:-2, 41:-10, 43:+0, 47:+2, 53:-4, 59:+10, 61:+4, 71:-6, 73:+0, 79:-12, 89:+16, 97:-2, 101:-10, 107:+12, 109:-14, 127:+0, 137:+16, 139:-16, 149:+2
control-g4-a: unambiguous elliptic traces (exactly one degree-2 factor):
  13:+0
control-g4-b: unambiguous elliptic traces (exactly one degree-2 factor):
  131:-16
control-g3-a: unambiguous elliptic traces (exactly one degree-2 factor):
  13:-6
control-g3-b: unambiguous elliptic traces (exactly one degree-2 factor):
  3:+3, 19:-2, 67:-12, 73:+6

Every single good prime in the range produces a degree-2 factor T^2 - aT + p
for all four quotients.  The four control curves in the table above are
random hyperelliptic curves of the same genera; they show what a simple
Jacobian looks like on the same test, and the contrast is not marginal.  For
a Jacobian with full USp(2g) monodromy the characteristic polynomial is
irreducible for a density-one set of p, and the controls confirm that on this
range.  So each of the four quotients has an elliptic factor over QQ that is
NOT cut out by any automorphism OF THAT CURVE.  Section 3.1 says where it
comes from instead: the order-three element of the anharmonic group acts on
the parent C_m but does not descend to D_1, so it acts on Jac(D_1) only
through a correspondence.

### 3.3 Measuring the S_3 multiplicities (a, b, c)

Method: Jac(D_1) ~ A_triv x A_std and Jac(D_2) ~ A_sgn x A_std share the
factor A_std, so at every good p the Frobenius characteristic polynomials of
D_1 and D_2 must share a factor of degree 2c, leaving cofactors of degree 2a
and 2b.  `gcd` of the two `hyperellcharpoly` outputs measures this directly.

| m | g(C_m) | g(D_1) | typical deg gcd(L_1, L_2) | cofactor degrees | (a, b, c) | a+b+2c |
|---|--------|--------|---------------------------|------------------|-----------|--------|
| 3 | 2 | 1 | 2 (43 of 43 primes) | 0, 0 | (0, 0, 1) | 2 |
| 4 | 2 | 1 | 2 (44 of 44 primes) | 0, 0 | (0, 0, 1) | 2 |
| 5 | 6 | 3 | 4 (15 of 18 primes) | 2, 2 | (1, 1, 2) | 6 |
| 6 | 8 | 4 | 6 (17 of 18 primes) | 2, 2 | (1, 1, 3) | 8 |
| 7 | 8 | 4 | 6 (17 of 18 primes) | 2, 2 | (1, 1, 3) | 8 |
| 8 | 12 | 6 | 8 (12 of 13 primes) | 4, 4 | (2, 2, 4) | 12 |

The multiplicities are (a, b, c) = (0, 0, 1) at m = 3 and m = 4,
(1, 1, 2) at m = 5, (1, 1, 3) at m = 6 and m = 7, and (2, 2, 4) at m = 8.
In every row a + b + 2c reproduces g(C_m) from section 1, which is an
independent check on the corrected genus law.  The occasional larger gcd at
a few primes is an accidental coincidence of Weil polynomials, not a change
in the decomposition.

The reading at m = 3, 4 needs one remark: there the cofactors are empty, so
gcd(L_1, L_2) = L_1 = L_2 and the measurement cannot by itself separate
"c = 1, a = b = 0" from "a = b = 1, c = 0 with A_triv isogenous to A_sgn".
The first is correct.  If a = b = 1 and c = 0 then Jac(D_1) = A_triv and
Jac(D_2) = A_sgn are unrelated curves and their equal a_p would be a
coincidence at every prime; with a = b = 0 and c = 1 they are literally the
same isogeny factor, which is what the prior report observed as
a_p(E_1) = a_p(E_2) and Jac(C_3) ~ E_1^2.  So C_3/S_3 and C_4/S_3 have
genus 0, and A_std is the elliptic curve of conductor 90 (resp. 14).

So dim A_triv = g(C_m/S_3) is 0 at m = 3, 4, then 1 at m = 5, 6, 7, then 2
at m = 8.  For m >= 5 the "elliptic factor" of section 3.2 that D_1 and D_2
do NOT share is exactly Jac(C_m/S_3) for D_1 and its sign-twin for D_2, and
the m = 8 change of dimension is g(C_8/S_3) reaching 2.

### 3.4 How far along the family the splitting persists

The same test was run at m = 7 and m = 8 (odd good p <= 120), where the
quotients have genus 4 and 6:

| quotient | genus | good p tested | p with a degree-2 factor | distinct degree patterns |
|----------|-------|---------------|--------------------------|--------------------------|
| m7D1 | 4 | 26 | 26 | [[2, 2, 2, 2], [2, 2, 4], [2, 6]] |
| m7D2 | 4 | 26 | 26 | [[2, 2, 2, 2], [2, 2, 4], [2, 6]] |
| m8D1 | 6 | 27 | 10 | [[2, 2, 2, 6], [2, 2, 4, 4], [2, 2, 8], [4, 8]] |
| m8D2 | 6 | 26 | 8 | [[2, 2, 2, 2, 4], [2, 2, 2, 6], [2, 2, 8], [4, 8]] |

At m = 7 the universal degree-2 factor is still there.  At m = 8 it is not --
but every degree pattern is a partition of 12 splitting as 4 + 8: the
L-polynomial always has a degree-4 factor (irreducible, or a product of two
quadratics) and a complementary degree-8 factor.  That is exactly a = 2 in
the S_3 bookkeeping of 3.3, i.e. Jac(C_8/S_3) is an abelian surface.  So the
phenomenon does not stop at m = 8; the small factor changes dimension:

    dim A_triv = g(C_m/S_3), against g(D_1) = a + c:
      m = 3, 4:  0 out of 1   (Jac(D_1) = A_std, and D_1 ~ D_2)
      m = 5:     1 out of 3
      m = 6, 7:  1 out of 4
      m = 8:     2 out of 6

### 3.5 Identifying the elliptic factor by its modular level

Method: the elliptic factor has good reduction outside the bad primes of the
quotient (section 4), so its conductor N is supported on those primes.  For
every such N <= 1600 the rational weight-2 newforms of level N are
enumerated (`mfinit`, `mfeigenbasis`) and their a_p compared with the
unambiguous traces above.  Generated script
`notes/clebsch-tasks/c1014_levels.gp`.

| quotient | conductor primes searched | level bound | newform found | a_1..a_24 |
|----------|---------------------------|-------------|---------------|-----------|
| m5D1 | [2, 3, 5, 17] | 1600 | yes | [[150, [1, -1, -1, 1, 0, 1, 2, -1, 1, 0, 2, -1, 6, -2, 0, 1, 2, -1, 0, 0, -2, -2, -4, 1]]] |
| m5D2 | [2, 3, 5, 17] | 1600 | none in range | - |
| m6D1 | [2, 3, 11, 31] | 1600 | yes | [[1584, [1, 0, 0, 0, 2, 0, -4, 0, 0, 0, 1, 0, -2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 8, 0]]] |
| m6D2 | [2, 3, 11, 31] | 1600 | none in range | - |

Two of the four are pinned outright.  The genus-3 quotient D_1 at m = 5 has an
elliptic factor of level 150 = 2 . 3 . 5^2, and the genus-4 quotient D_1 at
m = 6 has one of level 1584 = 2^4 . 3^2 . 11.  Both levels are supported on
the bad primes of the corresponding C_m computed in section 4 -- {2,3,5,17}
and {2,3,11,31} -- so the level law of section 4 is confirmed at m = 5 and
m = 6 as well as at m = 3 and m = 4.  The two twisted quotients D_2 have no
matching newform of level <= 1600 on those primes, so their elliptic
factors (which the L-polynomial evidence says exist) have larger conductor;
that is the one part of task 3 left open.

## 4. Bad primes, discriminants, and the level law (task 4)

Method: exact `sympy.discriminant` of the square-class model (the curve the
character actually sees), and of both u-descent models; `sympy.factorint` of
the discriminant and of the leading coefficient.  p is a bad prime of the
smooth model iff it divides the discriminant or the leading coefficient.

| m | 4^{m-1}-1 | bad primes of C_m | bad primes of D_1 | bad primes of D_2 | H(m) u M(m) u E(m) (+2 for m>=3) | law exact? |
|---|-----------|-------------------|-------------------|-------------------|----------------------------------|------------|
|  2 | {3: 1} | [3] | [] | [2, 3] | [3] | yes |
|  3 | {3: 1, 5: 1} | [2, 3, 5] | [2, 3, 5] | [2, 3, 5] | [2, 3, 5] | yes |
|  4 | {3: 2, 7: 1} | [2, 7] | [2, 7] | [2, 7] | [2, 7] | yes |
|  5 | {3: 1, 5: 1, 17: 1} | [2, 3, 5, 17] | [2, 3, 5, 17] | [2, 3, 5, 17] | [2, 3, 5, 17] | yes |
|  6 | {3: 1, 11: 1, 31: 1} | [2, 3, 11, 31] | [2, 3, 11, 31] | [2, 3, 11, 31] | [2, 3, 11, 31] | yes |
|  7 | {3: 2, 5: 1, 7: 1, 13: 1} | [2, 5, 7, 13] | [2, 5, 7, 13] | [2, 5, 7, 13] | [2, 5, 7, 13] | yes |
|  8 | {3: 1, 43: 1, 127: 1} | [2, 3, 29, 43, 127] | [2, 29, 43, 127] | [2, 3, 29, 43, 127] | [2, 3, 29, 43, 127] | yes |
|  9 | {3: 1, 5: 1, 17: 1, 257: 1} | [2, 3, 5, 7, 17, 257] | [2, 3, 5, 7, 17, 257] | [2, 3, 5, 7, 17, 257] | [2, 3, 5, 7, 17, 257] | yes |
| 10 | {3: 3, 7: 1, 19: 1, 73: 1} | [2, 3, 5, 7, 19, 37, 73] | [2, 3, 5, 7, 19, 37, 73] | [2, 3, 5, 7, 19, 37, 73] | [2, 3, 5, 7, 19, 37, 73] | yes |
| 11 | {3: 1, 5: 2, 11: 1, 31: 1, 41: 1} | [2, 3, 5, 11, 31, 41, 61] | [2, 5, 11, 31, 41, 61] | [2, 3, 5, 11, 31, 41, 61] | [2, 3, 5, 11, 31, 41, 61] | yes |
| 12 | {3: 1, 23: 1, 89: 1, 683: 1} | [2, 3, 23, 67, 89, 199, 683] | [2, 3, 23, 67, 89, 199, 683] | [2, 3, 23, 67, 89, 199, 683] | [2, 3, 23, 67, 89, 199, 683] | yes |

| m | H(m) harmonic | M(m) collision u=0 | E(m) double branch point | union (+2) | measured Bad(C_m) |
|---|---------------|--------------------|--------------------------|------------|-------------------|
|  2 | [3] | [] | [] | [3] | [3] |
|  3 | [3, 5] | [3] | [] | [2, 3, 5] | [2, 3, 5] |
|  4 | [7] | [] | [] | [2, 7] | [2, 7] |
|  5 | [3, 5, 17] | [5] | [3, 5] | [2, 3, 5, 17] | [2, 3, 5, 17] |
|  6 | [3, 11, 31] | [3] | [11] | [2, 3, 11, 31] | [2, 3, 11, 31] |
|  7 | [5, 7, 13] | [7] | [7, 13] | [2, 5, 7, 13] | [2, 5, 7, 13] |
|  8 | [3, 43, 127] | [] | [29, 43] | [2, 3, 29, 43, 127] | [2, 3, 29, 43, 127] |
|  9 | [3, 5, 17, 257] | [3] | [3, 5, 7, 17] | [2, 3, 5, 7, 17, 257] | [2, 3, 5, 7, 17, 257] |
| 10 | [7, 19, 73] | [5] | [3, 19, 37] | [2, 3, 5, 7, 19, 37, 73] | [2, 3, 5, 7, 19, 37, 73] |
| 11 | [3, 5, 11, 31, 41] | [11] | [5, 11, 31, 41, 61] | [2, 3, 5, 11, 31, 41, 61] | [2, 3, 5, 11, 31, 41, 61] |
| 12 | [3, 23, 89, 683] | [3] | [23, 67, 199, 683] | [2, 3, 23, 67, 89, 199, 683] | [2, 3, 23, 67, 89, 199, 683] |

disc of the square-class u-models (D_1 then D_2), factored:

  m= 2: disc D_1 = {}
         disc D_2 = {3: 2}
  m= 3: disc D_1 = {2: 8, 3: 5, 5: 1, -1: 1}
         disc D_2 = {2: 20, 3: 7, 5: 3, -1: 1}
  m= 4: disc D_1 = {2: 6, 7: 1, -1: 1}
         disc D_2 = {2: 14, 7: 3, -1: 1}
  m= 5: disc D_1 = {2: 24, 3: 3, 5: 16, 17: 1, -1: 1}
         disc D_2 = {2: 44, 3: 5, 5: 18, 17: 3, -1: 1}
  m= 6: disc D_1 = {2: 52, 3: 20, 11: 4, 31: 1, -1: 1}
         disc D_2 = {2: 76, 3: 22, 11: 6, 31: 3, -1: 1}
  m= 7: disc D_1 = {2: 34, 5: 1, 7: 23, 13: 4}
         disc D_2 = {2: 62, 5: 3, 7: 25, 13: 6}
  m= 8: disc D_1 = {2: 54, 29: 3, 43: 1, 127: 1, -1: 1}
         disc D_2 = {2: 78, 3: 2, 29: 3, 43: 3, 127: 3, -1: 1}
  m= 9: disc D_1 = {2: 56, 3: 73, 5: 1, 7: 3, 17: 7, 257: 1}
         disc D_2 = {2: 92, 3: 75, 5: 3, 7: 3, 17: 9, 257: 3}
  m=10: disc D_1 = {2: 93, 3: 3, 5: 37, 7: 1, 19: 7, 37: 3, 73: 1}
         disc D_2 = {2: 133, 3: 5, 5: 37, 7: 3, 19: 9, 37: 3, 73: 3}
  m=11: disc D_1 = {2: 72, 5: 11, 11: 49, 31: 1, 41: 4, 61: 3}
         disc D_2 = {2: 116, 3: 2, 5: 15, 11: 51, 31: 3, 41: 6, 61: 3}
  m=12: disc D_1 = {2: 180, 3: 50, 23: 10, 67: 3, 89: 1, 199: 3, 683: 1}
         disc D_2 = {2: 228, 3: 52, 23: 12, 67: 3, 89: 3, 199: 3, 683: 3}

**Exact bad-prime law (measured, m = 2..12, no exceptions).**

    Bad(C_m) = {2}  u  H(m)  u  M(m)  u  E(m)      (the {2} only for m >= 3)

with three geometrically distinct sources:

  H(m) -- the HARMONIC point.  Phit_m(1/4) = 4(1-4^{1-m}) . 4 and lambda = 1/2
    is the ramification point of lambda -> u, so a simple zero at u = 1/4
    pulls back to a double zero of Phi (Theorem E of the prior report).  So
    H(m) = { p : p | 4^{m-1}-1 }, MINUS the single exception p = 3 when
    m == 1 (mod 3): there 1/4 == 1 (mod 3) and u = 1 is the apolar locus
    I = 0, whose square factor I^2 is removed by the square-class reduction,
    so the harmonic degeneration is erased with it.  This is exactly the
    m = 4, 7 rows.
  M(m) -- the COLLISION locus.  P_m(0) = 2m (differentiate 1 - L_m^2 at
    u = 0 and use L_m(0) = 1, F_{m-1}(0) = 1), so u = 0 -- i.e. the deleted
    collision points lambda in {0,1} -- becomes a branch point exactly when
    p | m.  M(m) = { odd p : p | m }.  This is the only place the divisors
    of m enter, and they only ever add a NEW prime when p does not already
    divide 4^{m-1}-1: the first such case in range is (m,p) = (10,5).
  E(m) -- a genuine DOUBLE BRANCH POINT of Phit in the u-line.  Since
    (1 - L_m^2)' = 2 m L_m F_{m-1}, a repeated root u_0 of P_m away from
    u = 0 forces L_m(u_0) = +/-1 AND F_{m-1}(u_0) = 0, so
    E(m) = { odd p : p | Res( (L_m^2-1)/g, F_{m-1}/g ) },  g = gcd of the two
    (the gcd is nontrivial, equal to I, exactly when m == 1 mod 3).

Every extra prime beyond the harmonic ones was checked directly: at each of
(m,p) = (8,29), (9,7), (10,37), (11,61), (12,67), (12,199) the repeated root
u_0 of P_m mod p satisfies L_m(u_0) = +/-1 and F_{m-1}(u_0) = 0 exactly, and
u_0 is not the harmonic point 1/4.

| (m,p) in E(m) | repeated root u_0 of P_m mod p | L_m(u_0) | F_{m-1}(u_0) | 1/4 mod p |
|---------------|-------------------------------|----------|--------------|-----------|
| (5,3) | 2 | 2 | 0 | 1 |
| (6,11) | 9 | 10 | 0 | 3 |
| (6,11) | 5 | 1 | 0 | 3 |
| (7,13) | 9 | 12 | 0 | 10 |
| (8,29) | 16 | 1 | 0 | 22 |
| (8,43) | 41 | 42 | 0 | 11 |
| (9,5) | 3 | 1 | 0 | 4 |
| (9,7) | 6 | 6 | 0 | 2 |
| (9,17) | 15 | 1 | 0 | 13 |
| (9,17) | 9 | 16 | 0 | 13 |
| (9,17) | 4 | 16 | 0 | 13 |
| (10,3) | 1 | 2 | 0 | 1 |
| (10,19) | 17 | 18 | 0 | 5 |
| (10,19) | 7 | 1 | 0 | 5 |
| (10,19) | 4 | 1 | 0 | 5 |
| (10,37) | 16 | 1 | 0 | 28 |
| (11,5) | 4 | 4 | 0 | 4 |
| (11,31) | 29 | 1 | 0 | 8 |
| (11,41) | 10 | 40 | 0 | 31 |
| (11,61) | 58 | 60 | 0 | 46 |
| (12,23) | 16 | 1 | 0 | 6 |
| (12,23) | 13 | 1 | 0 | 6 |
| (12,23) | 4 | 22 | 0 | 6 |
| (12,23) | 3 | 22 | 0 | 6 |
| (12,23) | 2 | 22 | 0 | 6 |
| (12,67) | 62 | 1 | 0 | 17 |
| (12,199) | 121 | 1 | 0 | 50 |
| (12,683) | 681 | 682 | 0 | 171 |

So the guess "Bad(m) = {2,3} u primes(m) u primes(4^{m-1}-1)" is close but
not right in either direction: it over-counts (3 leaves the set at m = 4 and
m = 7) and it under-counts (it misses E(m), which is empty for m <= 7 and
then contributes 29 at m = 8, 7 at m = 9, 37 at m = 10, 61 at m = 11, and
67, 199 at m = 12).  The corrected law above matches all 11 rows exactly.
It also RESOLVES item (7) of the prior report: (8,29) is not sporadic, it is
the first member of E(m).

**Level law (conjecture).**  The conductor of every elliptic factor of
Jac(C_m) is supported on Bad(C_m).  Supported by four independent data
points: m = 3 level 90 = 2 . 3^2 . 5 with Bad = {2,3,5}; m = 4 level
14 = 2 . 7 with Bad = {2,7}; m = 5 level 150 = 2 . 3 . 5^2 with
Bad = {2,3,5,17}; m = 6 level 1584 = 2^4 . 3^2 . 11 with Bad = {2,3,11,31}
(sections 2 and 3.3).  In each case the level uses only part of Bad, never
more.

The support does NOT stay inside {2,3,5}: 7 enters at m = 4, 17 at m = 5,
11 and 31 at m = 6, and by m = 12 the bad set contains 683.  The growth is
driven by 4^{m-1}-1 = (2^{m-1}-1)(2^{m-1}+1), so every m whose 2-order
introduces a new primitive prime divisor introduces a new bad prime; by
Zsygmondy that is every m-1 >= 7 except m-1 = 6.  In particular the guess
that the family lives over ZZ[1/30] is refuted already at m = 4.

## 5. The (6,23) sporadic collapse, explained (task 5)

### 5.1 Independent recomputation of the census

Direct Python count of chi(Phi_{12,4}(lambda)) over lambda in F_23 minus
{0,1} (Legendre symbol by modular exponentiation):
  N+ = 0, N- = 21, N0 = 0, bias = -21, p-2 = 21

Ergodis replay (`ergodis::character_sum::PrimeQuadraticCharacter`,
`polynomial_census_reduced`, whole field including lambda = 0, 1):
  positive = 2, negative = 21, zero = 0, sum = -19;
  chi(Phi(0)) = chi(Phi(1)) = 1, so the punctured bias is
  sum - 2 chi(Phi(0)) = -21.

Full cross-check of the two engines on m = 2..8 and every odd p < 200
(315 censuses): disagreements = none.

The collapse is confirmed by both engines: bias(6,23) = -21 = -(p-2),
chi(Phi) == -1 on all 21 admissible lambda, no zeros.

### 5.2 What is NOT the mechanism

Factorization of Phi_{12,4} mod 23 (`sympy.factor_list(..., modulus=23)`):
  content 6, factors (lam**2 + 3)^1, (lam**2 + 8)^1, (lam**2 + 10*lam - 5)^1, (lam**2 + 11*lam + 6)^1, (lam**2 - 2*lam + 4)^1, (lam**2 - 2*lam + 9)^1, (lam**3 + 7*lam**2 - 10*lam + 1)^1, (lam**3 - 10*lam**2 + 7*lam + 1)^1
  gcd(Phi, Phi') mod 23 = 1  (degree 0)
  23 | 4^5-1 = 1023 = 3.11.31 ?  False
  23 | disc of the square-class model ?  False

  C_6 (lambda-line, g=8): affine points over F_23 = 23 + S = 4 with S = -19; Weil bound 2g sqrt p = 76.73; |S|/(2g sqrt p) = 0.248
  D_1 (u-line, g=4): affine points over F_23 = 23 + S = 12 with S = -11; Weil bound 2g sqrt p = 38.37; |S|/(2g sqrt p) = 0.287
  D_2 (u-line, g=4): affine points over F_23 = 23 + S = 15 with S = -8; Weil bound 2g sqrt p = 38.37; |S|/(2g sqrt p) = 0.209
  23 | 4m^2 = 144?  False;  content of Phi_{12,4} = 1;  23 | that content?  False

So Phi mod 23 is squarefree, the genus does not drop, 23 is not a bad prime,
and 23 divides none of the structural constants (4m^2 = 144, the content, or
the discriminant).  Nor is C_6 mod 23 anywhere near maximal or minimal: the
character sum sits at about a quarter of the Weil bound, and the curve is not
supersingular.  The collapse is a SIGN uniformity, not a size extremum, and
it is not a degeneration of the curve at all.

### 5.3 The mechanism: a chi-twisted stratum (Theorem G)

The prior report's Theorem 0 says chi(Phi_{2m,4}) on F_p minus {0,1} depends
only on r := 2m mod (p-1), through

    G_r(lambda) = ( 1 - lambda^r - (1-lambda)^r )^2 - 4 u^r,   u = lambda(1-lambda).

Theorems A, B, C are the cases r = 0, r = 2, r = (p-1)/2.  At (m,p) = (6,23),
r = 12 and (p-1)/2 = 11, so r = (p-1)/2 + 1.  That is a new stratum:

**Theorem G (chi-twisted stratum, j = 1).**  Suppose r = 2m == (p-1)/2 + 1
(mod p-1); this is solvable in m only when p == 3 (mod 4).  Then
lambda^r = chi(lambda) lambda for lambda != 0, so with e = chi(lambda),
f = chi(1-lambda) the compact form collapses to four cases:

    (e,f) = (+,+):  G_r = -4u             chi(G_r) = chi(-1) chi(u) = chi(-1)
    (e,f) = (-,+):  G_r = 4 lambda        chi(G_r) = chi(lambda)   = -1
    (e,f) = (+,-):  G_r = 4 (1-lambda)    chi(G_r) = chi(1-lambda) = -1
    (e,f) = (-,-):  G_r = 4 (1-u) = 4 I   chi(G_r) = chi(I)

and chi(-1) = -1 because p == 3 (mod 4), while u = lambda(1-lambda) is a
square in the (+,+) case.  Hence chi(Phi) = -1 identically OUTSIDE the
doubly-nonsquare set N(p) = {lambda : chi(lambda) = chi(1-lambda) = -1}, and
on N(p) it equals chi(lambda^2-lambda+1) = chi(I), the apolar invariant.
A genus-(2m-4) character sum has been reduced to a character sum over a set
of size about (p-3)/4 evaluated on one quadratic.

Exact verification of the four-case reduction (every admissible lambda, both
sides computed in F_p): (m,p)=(6,23): exact, (m,p)=(5,19): exact, (m,p)=(2,7): exact, (m,p)=(5,7): exact, (m,p)=(3,11): exact, (m,p)=(8,11): exact, (m,p)=(8,31): exact

**Corollary.**  On the Theorem G stratum,
    N+ = #{lambda in N(p) : chi(I) = +1},  bias = -(p-2) + 2 N+ + (zeros).
Total collapse (N+ = 0, the "constant nonzero character" the prior report
flagged) happens exactly when chi(I) is never +1 on N(p).

### 5.4 Why 23 and not 11

| p | least m with 2m == (p-1)/2+1 | #N(p) | chi(I) values on N(p) | census (N+,N-,N0) | collapse |
|---|------------------------------|-------|-----------------------|-------------------|----------|
| 7 | 2 | 2 | [0] | (0, 3, 2) | YES |
| 11 | 3 | 3 | [1] | (3, 6, 0) | no |
| 19 | 5 | 5 | [-1, 0] | (0, 15, 2) | YES |
| 23 | 6 | 6 | [-1] | (0, 21, 0) | YES |
| 31 | 8 | 8 | [0, 1] | (6, 21, 2) | no |
| 43 | 11 | 11 | [-1, 0, 1] | (6, 33, 2) | no |
| 47 | 12 | 12 | [-1, 1] | (6, 39, 0) | no |
| 59 | 15 | 15 | [-1, 1] | (9, 48, 0) | no |
| 67 | 17 | 17 | [-1, 0, 1] | (6, 57, 2) | no |
| 71 | 18 | 18 | [-1, 1] | (12, 57, 0) | no |
| 79 | 20 | 20 | [-1, 0, 1] | (6, 69, 2) | no |
| 83 | 21 | 21 | [-1, 1] | (9, 72, 0) | no |

At p = 23 all six doubly-nonsquare lambda have chi(I) = -1, so the collapse is
total and N0 = 0 as well -- which is why (6,23) alone showed up as a clean
"constant nonzero character" point in the prior scan.  At p = 19 the residual
set contributes only zeros (I has roots mod 19), giving N+ = 0 but N0 = 2, so
the prior scan's N0 = 0 filter missed it: (5,19) is the SAME phenomenon.  At
p = 11 and p = 31 the residual character is +1 somewhere, and the census does
not collapse.  So (6,23) is not sporadic in kind, only in the residual
coincidence chi(I)|_{N(23)} == -1, an event of heuristic probability 2^-6.

### 5.5 Complete classification of constant-character strata, p <= 300

Method: for every odd p <= 300 and every even r in [0, p-2] -- i.e. every
value 2m mod (p-1) can take -- evaluate chi(G_r) on all of F_p minus {0,1}
and record r whenever the nonzero values are constant.  This is a COMPLETE
enumeration of the exceptional strata in that range, not a sample.

| stratum | count (p <= 300) | first instances (p, r, constant chi, has zeros) |
|---------|------------------|--------------------------------------------------|
| A   r = 0 (constant character) | 61 | [(3, 0, 0, True), (5, 0, -1, False), (7, 0, 1, False), (11, 0, -1, False), (13, 0, 1, False)] |
| A*  r = -2 (mod p-1) | 3 | [(11, 8, -1, True), (13, 10, -1, True), (19, 16, 1, True)] |
| B   r = 2 (total collapse, N0 = p-2) | 60 | [(5, 2, 0, True), (7, 2, 0, True), (11, 2, 0, True), (13, 2, 0, True), (17, 2, 0, True)] |
| C   r = (p-1)/2 | 14 | [(17, 8, -1, False), (53, 26, -1, False), (61, 30, 1, False), (109, 54, 1, False), (113, 56, -1, False)] |
| G   r = (p-1)/2 + 1  (this section) | 3 | [(7, 4, -1, True), (19, 10, -1, True), (23, 12, -1, False)] |
| H   r = (p-1)/2 + 2 | 1 | [(17, 10, -1, True)] |
| other | 20 | [(17, 6, 1, True), (17, 12, -1, True), (23, 10, 1, True), (47, 30, -1, True), (61, 14, -1, True)] |

**Reduction principle (all strata are one family).**  Write r = 2m mod (p-1)
and suppose r == k (p-1)/n + j (mod p-1) for a divisor n of p-1 and an
integer j.  Then lambda^r = psi(lambda) lambda^j where psi is the order-n
power-residue character raised to the k-th power, valued in the group
mu_n of n-th roots of unity inside F_p.  Hence

    G_r = ( 1 - psi(lambda) lambda^j - psi(1-lambda) (1-lambda)^j )^2
          - 4 psi(u) u^j,

which is one of at most n^2 polynomials, each of degree 2j in lambda, instead
of one polynomial of degree 4m-6.  When n and |j| are both small the
character sum is short and can degenerate to a constant; that is the ONLY
source of an exceptional stratum, and it is why each p has only finitely
many.  The named theorems are the corners of this family:
    Theorem A = (n,j) = (1,0);   Theorem B = (1,2);
    Theorem C = (2,0);           Theorem G = (2,1).
Negative j is the reciprocal branch, where the exact identity
    u^{2j} G_{-j} = ( u^j - L_j(u) )^2 - 4 u^j    versus    G_j = (1-L_j)^2 - 4u^j
exchanges the constant 1 for u^j and leaves -4u^j alone; it is verified
symbolically below.

The strata outside A, B, C, G, H number 20 for p <= 300.  Fitting
each to the smallest (n, |j|) over ALL divisors n of p-1 with |j| <= 3.  The
reduction is informative only when n is small, since G_r then takes at most
n^2 values; a fit with large n says nothing.

| p | r | constant chi | (p-1)/n form | n | j | image size of lambda -> lambda^r |
|---|---|--------------|--------------|---|---|----------------------------------|
| 17 | 6 | +1 | 1(p-1)/2 - 2 | 2 | -2 | 8 |
| 17 | 12 | -1 | 3(p-1)/4 + 0 | 4 | 0 | 4 |
| 23 | 10 | +1 | 1(p-1)/2 - 1 | 2 | -1 | 11 |
| 47 | 30 | -1 | 15(p-1)/23 + 0 | 23 | 0 | 23 |
| 61 | 14 | -1 | 1(p-1)/4 - 1 | 4 | -1 | 30 |
| 67 | 22 | +1 | 1(p-1)/3 + 0 | 3 | 0 | 3 |
| 67 | 44 | +1 | 2(p-1)/3 + 0 | 3 | 0 | 3 |
| 73 | 16 | -1 | 1(p-1)/4 - 2 | 4 | -2 | 9 |
| 79 | 26 | +1 | 1(p-1)/3 + 0 | 3 | 0 | 3 |
| 79 | 52 | +1 | 2(p-1)/3 + 0 | 3 | 0 | 3 |
| 127 | 42 | +1 | 1(p-1)/3 + 0 | 3 | 0 | 3 |
| 127 | 84 | +1 | 2(p-1)/3 + 0 | 3 | 0 | 3 |
| 137 | 34 | -1 | 1(p-1)/4 + 0 | 4 | 0 | 4 |
| 137 | 102 | -1 | 3(p-1)/4 + 0 | 4 | 0 | 4 |
| 163 | 54 | +1 | 1(p-1)/3 + 0 | 3 | 0 | 3 |
| 163 | 108 | +1 | 2(p-1)/3 + 0 | 3 | 0 | 3 |
| 257 | 64 | -1 | 1(p-1)/4 + 0 | 4 | 0 | 4 |
| 257 | 192 | -1 | 3(p-1)/4 + 0 | 4 | 0 | 4 |
| 277 | 92 | +1 | 1(p-1)/3 + 0 | 3 | 0 | 3 |
| 277 | 184 | +1 | 2(p-1)/3 + 0 | 3 | 0 | 3 |

The n = 3 and n = 4 rows are the cubic and quartic analogues of Theorem C:
lambda^r lands in mu_3 or mu_4 and G_r takes at most nine (resp. sixteen)
values.  Together with the n = 2 rows they account for all but one entry, so
the "other" column of the table above is not a residue of unexplained
sporadic points -- it is the rest of the same family, and Theorems A, B, C
and G are its smallest members.

The exception is [(47, 30, 23)]: there the smallest fit needs a
large n, the image of lambda -> lambda^r is the full subgroup of squares,
and no short-character-sum reduction applies.  That single point, and not
(6,23), is the one genuinely unexplained constant-character stratum for
p <= 300.  It is the concrete target a successor should take next; note that
unlike (6,23) it does have zeros, so it is a "constant on the nonvanishing
locus" collapse rather than a clean one.

Symbolic verification of the reciprocal identity:
    u^{2j} G_{-j} = ( u^j - L_j(u) )^2 - 4 u^j   against   G_j = (1 - L_j)^2 - 4 u^j,
as an identity of rational functions in lambda: exact for every j in 1..8.

## 6. Open observations

Each item states the exact searched range and the exact statement that held.

**(1) SETTLED -- the (6,23) collapse.**  It is the j = 1 chi-twisted stratum
(Theorem G, section 5.3), whose residual is a character sum of chi(I) over
the doubly-nonsquare set.  (5,19) is the same stratum and the prior scan
missed it only because it filtered on N0 = 0.  What is genuinely accidental
at p = 23 is that chi(I) = -1 on all six residual points; that is not forced,
and it already fails at p = 11 and p = 31.  Nothing about (6,23) is left open.
The complete p <= 300 classification in section 5.5 puts one point in its
place as the new open case: (p, r) = (47, 30), where the character is
constant on the nonvanishing locus but the exponent admits no
small-image reduction.

**(2) SETTLED -- the (8,29) bad prime.**  29 is a genuine bad prime and it is
the first member of the third source E(m) in the bad-prime law of section 4:
mod 29 the Dickson polynomials L_8^2-1 and F_7 acquire a common root u_0, so
Phit_8 has a double branch point away from the harmonic point.  The complete
law Bad = {2} u H u M u E reproduces all eleven rows m = 2..12 with no
exception, so the prior report's open item (7) is closed.

**(3) SETTLED -- the genus law.**  g(C_m) = 2m-4 for m not == 1 (mod 3) and
2m-6 for m == 1 (mod 3); the prior 2m-5 is corrected in section 1.

**(4) SETTLED -- why the higher-genus quotients split.**  The anharmonic S_3
acts on C_m over QQ (Theorem H), and the elliptic factor of Jac(D_1) is
Jac(C_m/S_3); the order-3 element does not descend to D_1, which is why D_1
itself has trivial reduced automorphism group.  What remains open is
quantitative, not structural: the S_3 multiplicities (a, b, c) are measured,
not derived -- a Riemann-Hurwitz computation for C_m -> C_m/S_3 would give
them in closed form as a function of m, and would predict where a jumps from
1 to 2 (observed between m = 7 and m = 8).  The unambiguous traces are

    m5D1: a_11=+2, a_31=-8, a_41=+2, a_47=-8, a_59=+10, a_61=+2, a_71=+12, a_73=-4, a_79=+0, a_83=-4, a_89=-10, a_97=-8, a_101=-8, a_103=-14
    m5D2: a_11=-4, a_31=+4, a_41=+8, a_47=-8, a_59=-6, a_61=+14, a_71=+2, a_73=-4, a_79=+0, a_83=+16, a_89=-2, a_97=+0, a_101=+8, a_103=+12
    m6D1: a_7=-4, a_13=-2, a_17=+2, a_19=+0, a_29=+6, a_37=+6, a_41=+2, a_43=+0, a_47=+8, a_53=-6, a_59=-4, a_61=+6, a_71=+0, a_73=-14
    m6D2: a_7=-2, a_13=-4, a_17=-6, a_19=-2, a_29=-6, a_37=-2, a_41=-10, a_43=+0, a_47=+2, a_53=-4, a_59=+10, a_61=+4, a_71=-6, a_73=+0
    m7D1: a_11=-3, a_23=-6, a_29=-5, a_41=+0, a_43=+2, a_47=-7, a_53=-3, a_59=+7, a_61=+7, a_67=-3, a_71=-5, a_73=-14, a_97=+14, a_101=+14
    m7D2: a_11=+3, a_23=-6, a_29=+3, a_41=-6, a_43=+8, a_47=+3, a_53=+3, a_59=-9, a_61=+5, a_67=+5, a_71=-15, a_73=-4, a_97=-4, a_101=+6

**(4b) OPEN -- the conductors of the D_2 elliptic factors.**  A_sgn at
m = 5 and m = 6 has no rational newform of level <= 1600 supported on the
bad primes, so its conductor is larger than the range searched.  It need not
be searched for at all: with tau the order-3 element and h the hyperelliptic
involution, A_triv = Jac(C_m/<tau, sigma>) and A_sgn = Jac(C_m/<tau,
sigma . h>), both quotients by an explicit order-6 subgroup of
S_3 x <h>, so both curves can be written down and their conductors computed
directly.  Doing that would also give (a, b, c) in closed form (item 4).

**(5) OPEN -- the mod-4 rigidity of the m = 3 bias.**  The prior report item
(3) recorded bias(3,p) == 1 (mod 4) for every non-degenerate p <= 199.  The
level-90 identification of section 2 makes this a statement about a single
weight-2 newform, so it should now be provable from the rational 4-torsion,
but it is not proved here.

**(6) OPEN -- why the (+,+) case of Theorem G is not an extra condition.**
In Theorem G the (+,+) case gives chi(-1) and the two mixed cases give -1
automatically, so exactly one of the four cases (the doubly-nonsquare one)
carries information.  The asymmetry is visible in the algebra but has no
conceptual explanation here; it is what makes the stratum nearly, but not
quite, a collapse theorem.

## 7. Ergodis interface notes

Per the lane directive the finite-field legs were routed through Ergodis
first.  This task needed four kinds of computation; Ergodis covered one of
them completely and none of the other three.

**Fits, and was used.**  The character-census leg is an exact fit, exactly as
recorded for C1013: `PrimeQuadraticCharacter::new(p)` plus
`reduce_coefficients` plus `polynomial_census_reduced` reproduces
(N+, N-, N0, bias) for chi(Phi_{2m,4}) over any prime field.  It was used to
confirm the (6,23) collapse independently of the Python count, and to replay
the whole m = 2..8, p < 200 census: disagreements = none.  That is the independent-replay leg
required by `notes/research-reproducibility-conventions.md`.

**Misfits -- three legs Ergodis cannot express at all.**
  1. *Zeta functions of curves over F_p.*  The whole of section 3 needs the
     characteristic polynomial of Frobenius on a genus-3 or genus-4
     hyperelliptic curve, not a character count.  Ergodis has no zeta,
     no point count over F_{p^k}, and no extension-field arithmetic exposed;
     PARI `hyperellcharpoly` did all of it.  A typed
     `hyperelliptic-zeta {p, coefficients}` returning the L-polynomial would
     be the single highest-value addition for this family of tasks, because
     it is the object that decides splitting, and it subsumes the census
     (the census is the T-coefficient).
  2. *Global arithmetic of the quotient curves.*  Minimal models, conductors,
     torsion, isogeny classes, newform levels -- section 2 -- are outside
     Ergodis by design and were done in PARI.  No interface note is warranted
     beyond noting that the census sums Ergodis computes ARE the a_p of these
     curves, so an optional "interpret this census as a_p" annotation would
     connect the two worlds cheaply.
  3. *Sweeps over the exponent r = 2m mod (p-1) rather than over p.*  The
     complete stratum classification of section 5.5 evaluates chi(G_r) for
     every even r < p-1 at every p <= 300.  Expressed through the existing
     API this would mean materializing a degree-2r polynomial per (p, r) and
     paying O(r) per point; the natural primitive is instead a census of
     chi(F(x^r, (1-x)^r, u^r)) with r as a parameter, i.e. exponent-sweep
     support with fast modular exponentiation inside the kernel.  This is a
     new typed operation, not packaging.  The scan was done in Python.

The four improvement items from the C1013 pass (CLI census command, prime
ranges, general polynomial twist, in-kernel squarefree detection, genus
annotation) all still stand; items 1 and 3 above are new and are the ones
that actually blocked work this time.  Nothing in the rank, orbit, span, or
incidence modules was applicable: the objects here are curves and character
sums, not codes.

Driver used: `/home/tavis/.cache/ergodis/c1013-census-target/release/c1013-census`
(crate `notes/clebsch-tasks/c1013-ergodis-driver`, build directory relocated
to `~/.cache/ergodis/c1013-census-target` so that no build tree lives under
`notes/`).

Status: complete.

