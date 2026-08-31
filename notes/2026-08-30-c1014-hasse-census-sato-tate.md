# C1014 — Hasse–Witt census and the Sato–Tate decision at m = 8

**Task:** C1014 (clebsch lane), math-only.
**Date:** 2026-08-30.
**Scope:** two independent legs on the four-point Gram shadow.
Leg A settles thread 3 of the C1014 card ("real/local signature and Hasse
refinements") by determining the complete isometry invariant of the Gram
quadratic form and then censusing the coloring that genuinely refines it.
Leg B settles open item (7) of the Chevalley–Weil report (the m = 8 abelian
surfaces) by Sato–Tate moment statistics.

**Files.**
`notes/clebsch-tasks/c1014_hasse_sato_tate.py` (generator, all legs),
`notes/clebsch-tasks/c1014_st_ram.gp`,
`notes/clebsch-tasks/c1014_st_legb.gp`,
`notes/clebsch-tasks/c1014_st_moments.gp`,
`notes/clebsch-tasks/c1014_st_cond2.gp` (all generated), and the hand-written
`notes/clebsch-tasks/c1014_st_cond.gp`.

**Replay.**

    cd notes/clebsch-tasks
    uv run --with sympy python3 c1014_hasse_sato_tate.py legA-symbolic
    nix shell nixpkgs#pari --command gp -q c1014_st_ram.gp
    uv run --with sympy python3 c1014_hasse_sato_tate.py legA-census --pmax 200 --mmax 6
    uv run --with sympy python3 c1014_hasse_sato_tate.py legA-period --pmax 60
    uv run --with sympy python3 c1014_hasse_sato_tate.py legA-covers --mmax 8
    uv run --with sympy python3 c1014_hasse_sato_tate.py legB-emit
    nix shell nixpkgs#pari --command gp -q c1014_st_legb.gp    > split.txt
    nix shell nixpkgs#pari --command gp -q c1014_st_moments.gp > moments.txt
    uv run --with sympy python3 c1014_hasse_sato_tate.py legB-analyze \
        --momfile moments.txt --splitfile split.txt
    nix shell nixpkgs#pari --command gp -q c1014_st_cond.gp
    uv run --with sympy python3 c1014_hasse_sato_tate.py legB-quotients
    nix shell nixpkgs#pari --command gp -q c1014_st_cond2.gp

Every statement below is tagged **proved**, **symbolic-exact**,
**computed (range)**, or **statistical**.

## Executive summary

**Leg A is a sharp negative followed by a constructive replacement.**
The four-point pure-power Gram form is, over *every* field of characteristic
other than 2 and for *every* m, isometric to a hyperbolic plane plus the
binary form `-2 <1, -Phi_{2m,4}>`.  Its complete isometry invariant is
therefore the square class of `Phi_{2m,4}` — the coloring already censused in
C1013 — and there is no second coloring to census, at any level: not
pointwise over F_p, not over Q_p at rational lambda, not over the function
field Q(lambda).  The Hasse–Witt invariant is the quaternion class
`(2, Phi_{2m,4}) . (-1,-1)`, a function of the discriminant; its ramification
divisor over Q(lambda) is exactly the branch divisor of the double cover
C_m, so it carries no divisor data the cover does not already carry.  The
principal-minor sequence is `(0, -1, 2, Delta.Phi)` with the middle two
entries constant in both lambda and m, so the "restricted signature"
stratification proposed in the card's thread 3 is vacuous.

The coloring that *does* refine the discriminant is not a quadratic-form
invariant at all: it is the square-class vector of the four Fermat/Dickson
factors `A_{eps,eta} = 1 + eps lambda^m + eta (1-lambda)^m` whose product is
`u^2 Phi`.  All sixteen strata occur for every m in 2..6 and every odd
p <= 200, the deviations from equidistribution stay inside about 3 standard
deviations, and the refinement has a strictly finer periodicity: the
discriminant census depends on m only through `2m mod (p-1)`, while the
four-factor census depends on `m mod (p-1)`.  So the refinement doubles the
resolution of the exponent stratification, which is the one place where it
buys something the discriminant cannot see.

**Leg B answers the m = 8 question and refutes the uniform GL2-type
conjecture in its strong form.**  Both m = 8 isotypic abelian surfaces —
`A_triv = Jac(Y^2 = J(J+4)(16J^3+68J^2+16J+1))` and its sign twin
`A_sgn = Jac(Z^2 = (4J-27) J(J+4)(16J^3+68J^2+16J+1))` — have Sato–Tate
moments matching USp(4) and nothing else.  Sato–Tate group USp(4) forces
`End(A_Qbar) = Z`, so it is incompatible with GL2-type by definition; and the
measurement separates it from the GL2-type alternatives directly.  A surface
of GL2-type with real multiplication has Sato–Tate identity component
`SU(2)xSU(2)`, with second, fourth and sixth moments 2, 10, 70 in the generic
case and 1, 5, 35 when an extra component halves the trace (the
restriction-of-scalars case, GL2-type only over a quadratic field).  The
measured values are close to 1, 3, 14.  So A_triv and A_sgn at m = 8 are absolutely simple with trivial
endomorphism algebra: the candidate conjecture "every isotypic factor of
Jac(C_m) is of GL2-type with level supported on the bad-prime law" is false
at its first test beyond dimension 1.

The level half of that conjecture does survive.  A cheaper derivation of the
`S_3`-quotient models extends them to m = 9 and 10, and `genus2red` then gives
the odd conductors of all six surfaces at m = 8, 9, 10.  The sign-side
conductor is divisible by every odd bad prime at all three, confirming the
Chevalley–Weil prediction at its first untested values and putting it on six
consecutive m.  The trivial side is still not characterised: the collision
primes are never dropped in any of the six rows, but the dropped set is not
the harmonic set.  Proving the sign-side statement directly from the two
quotient models would make the conductor support of every isotypic piece a
priori for all m and retire the newform searches; that is the
highest-value successor in the lane.

## 0. Setting and notation

Four marked points on P^1, normalised as `(p_1, p_2, p_3, p_4) =
(oo, 0, 1, lambda)` and represented by linear forms; `[.,.]` is the bracket,
`d = 2m` is even, and the pure-power Gram matrix is

    M(lambda)_ij = [p_i, p_j]^{2m}.

With the standard representatives the brackets are `[oo,0] = [oo,1] =
[oo,lambda] = 1`, `[0,1] = -1`, `[0,lambda] = -lambda`, `[1,lambda] =
1-lambda`, so writing `s = lambda^m`, `t = (1-lambda)^m`,

    M = [ 0    1    1     1   ]
        [ 1    0    1     s^2 ]
        [ 1    1    0     t^2 ]
        [ 1    s^2  t^2   0   ].

`det M = Q(1, s, t)` with `Q(A,B,C) = A^4+B^4+C^4-2A^2B^2-2B^2C^2-2C^2A^2`,
which is `Delta . Phi_{2m,4}` with `Delta = u^2`, `u = lambda(1-lambda)`
(C1013 hierarchy, and the product identity of the Chevalley–Weil report).
The four Fermat factors are

    A_{eps,eta} = 1 + eps lambda^m + eta (1-lambda)^m,
    prod_{eps,eta} A_{eps,eta} = u^2 Phi_{2m,4}.

The quadratic form is `q(x) = x^T M x`.  Rescaling the representatives
`l_i -> c_i l_i` multiplies M by the diagonal congruence with entries
`c_i^{2m}`, all squares, and a GL_2 change of coordinates multiplies every
bracket by the same determinant, hence M by `(det)^{2m}`, again a square.
So the isometry class of q is a genuine invariant of the four-point
configuration and the normalisation above is legitimate.

## 1. Leg A — the Gram form has exactly one invariant

### 1.1 The universal diagonalisation (proved)

The upper-left 3x3 block of M is

    [0 1 1; 1 0 1; 1 1 0],

independent of both m and lambda, because `[oo,0]^{2m} = [oo,1]^{2m} = 1`
and `[0,1]^{2m} = (-1)^{2m} = 1`.  Symmetric Gaussian elimination on that
block gives `<2, -1/2, -2>`, of determinant 2, and the fourth diagonal entry
is then forced to be `det M / 2`.  Symbolic verification (sympy, exact
congruence `P^T M P` recomputed at every step) for m = 2..8 returns exactly

    q  ~=  < 2, -1/2, -2, (1/2) det M >   for every m in 2..8,

and the 3x3 block argument proves it for every m.  Since `-1/2 ~ -2` and
`(1/2) det M ~ 2 det M` modulo squares, and `<2,-2>` is the hyperbolic plane,

**(1.1)  q  ~=  H  ⊥  <-2, 2 G>,   G = det M = Delta . Phi_{2m,4},**

i.e. the Witt class of q is `(-2) . <1, -G>`, the scaled norm form of the
quadratic extension `K(sqrt G)`, for every field K of characteristic != 2 and
every m.

Three consequences, all **proved**:

1. **The square class of `Phi_{2m,4}` is a complete isometry invariant of the
   Gram form.**  Two configurations give isometric Gram forms if and only if
   their `Phi` values agree modulo squares.  There is nothing else to
   census — over F_p, over Q_p, over Q, or over Q(lambda).
2. **Isotropy.**  q has Witt index 2 (is hyperbolic) exactly when
   `Phi_{2m,4}(lambda)` is a square, and Witt index 1 otherwise, with
   anisotropic kernel the binary form `-2 <1, -Phi>`.  Over F_p this is the
   textbook statement that dimension and discriminant classify; the content
   here is that the same holds over Q and Q(lambda), where dimension and
   discriminant do *not* classify in general.
3. **Real signature.**  Over R the form is `H ⊥ <-2, 2 Phi>`, so the
   signature is `(2,2)` when `Phi(lambda) > 0` and `(1,3)` when
   `Phi(lambda) < 0`.  The card's thread-3 "restricted signature
   stratification" collapses to the sign of `Phi`, which is again the
   discriminant coloring.

### 1.2 Principal minors (proved, symbolic-exact m = 2..6)

    G_1 = 0,   G_2 = -1,   G_3 = 2,   G_4 = Delta . Phi_{2m,4}.

`G_1 = 0` because the Gram matrix of a pure-power kernel is hollow.
`G_2 = -[p_1,p_2]^{4m} = -1` and `G_3 = 2 [p_1,p_2]^{2m}[p_1,p_3]^{2m}
[p_2,p_3]^{2m} = 2 (prod [.,.])^{2m}`, a square times 2.  These are exactly
the C1013 hierarchy values `Phi_{d,2}` (giving square class -1) and
`Phi_{d,3} = 2 Delta_3^{(d-2)/2}` (giving square class 2): the r = 2 and
r = 3 members of the same family contribute only the constants -1 and 2 and
carry no lambda-dependence at all.  So the leading-principal-minor sequence
is a constant 4-symbol word `(0, -1, 2, chi(Phi))` and defines no
stratification of the lambda-line.

### 1.3 The Hasse–Witt invariant as a quaternion class (proved)

For the diagonalisation `<a_1,a_2,a_3,a_4> = <2, -2, -2, 2G>` (mod squares),
the Hasse–Witt invariant `s(q) = prod_{i<j} (a_i, a_j)` collapses:
`(2,-2) = 1`, the two copies of `(2,-2)` and the two copies of `(-2, 2G)`
cancel in Br(K)[2], and `(2,2G)(-2,-2) = (2,-1)(2,G)(-1,-1)(2,-1)`, so

**(1.3)  s(q) = (2, Phi_{2m,4}) . (-1,-1)  in Br(K)[2].**

The class is a function of the discriminant and one universal constant.  Over
`K = Q_p` at a rational specialisation this reads
`eps_p(lambda) = (2, Phi(lambda))_p . (-1,-1)_p`, a Hilbert symbol of the
discriminant — no new information.  Over `K = Q(lambda)` the constant class
`(-1,-1)` is unramified (constants inject into Br(Q(lambda)) with zero
residue), and for a square-class factor `pi` of `Phi` the residue of
`(2, Phi)` at `pi` is the class of 2 in `kappa(pi)^* / (kappa(pi)^*)^2`,
since 2 has valuation 0 at every place of Q(lambda).  The residue at
infinity is trivial because `deg sqcl Phi = d_m` is even for every m.

### 1.4 Ramification locus (computed, m = 2..8)

Test: `pi` ramifies iff 2 is not a square in the number field
`Q[lambda]/(pi)`, decided by `nfisincl(x^2-2, polredbest(pi~))` in PARI/GP
2.17.3 (`c1014_st_ram.gp`), on the monicised model of each square-class
factor.

| m | square-class factors of Phi (degrees) | 2 a square in kappa(pi)? | ramified? |
|---|---------------------------------------|--------------------------|-----------|
| 2 | 2                                     | no                       | yes       |
| 3 | 2, 2, 2                               | no, no, no               | yes (all) |
| 4 | 2, 2, 2   (plus I^2, invisible)        | no, no, no               | yes (all) |
| 5 | 2, 4, 4, 4                            | no (all)                 | yes (all) |
| 6 | 4, 4, 4, 6                            | no (all)                 | yes (all) |
| 7 | 6, 6, 6   (plus I^2, invisible)        | no (all)                 | yes (all) |
| 8 | 2, 6, 6, 6, 6                         | no (all)                 | yes (all) |

**Every** square-class factor of `Phi_{2m,4}` ramifies, for every m in 2..8.
The ramification divisor of the Hasse–Witt class over Q(lambda) is therefore
*exactly* the branch divisor of the double cover `C_m : y^2 = Phi_{2m,4}`.
That answers the card's question — yes, the Hasse invariant is governed by
the Dickson factors — but in the strongest possible negative sense: it is
governed by them through the discriminant alone, and its divisor is the one
we already had.  The class is `(2, Phi) . (-1,-1)`, and it is the pullback of
`(-1,-1)` under the cover together with the constant obstruction `(2, .)` on
the branch locus.

The unramified (constant) part of the class is the quaternion algebra
`(2, c) . (-1,-1)` over Q, with `c` the square-free content of `Phi_{2m,4}`;
Hilbert symbols in the same script give

| m  | square-free content c | constant class ramified at | note                              |
|----|-----------------------|----------------------------|-----------------------------------|
| 2  | 1                     | {2, oo}                    |                                   |
| 3  | 3                     | {3, oo}                    |                                   |
| 4  | 1                     | {2, oo}                    |                                   |
| 5  | 5                     | {5, oo}                    |                                   |
| 6  | 1                     | {2, oo}                    |                                   |
| 7  | 7                     | {2, oo}                    | 2 is a square mod 7, so 7 is not  |
| 8  | 1                     | {2, oo}                    |                                   |

so `c = m` for odd m and `c = 1` for even m in this range — the odd `p | m`
of the bad-prime law's collision locus, read off the constant term of the
quadratic form.

### 1.5 The coloring that does refine: the four Fermat factors

Since no quadratic-form invariant refines `chi(Phi)`, the natural refinement
must come from the factorisation, not the form.  The product identity
`u^2 Phi = prod A_{eps,eta}` gives the 4-symbol coloring

    lambda  |-->  ( chi(A_{++}), chi(A_{+-}), chi(A_{-+}), chi(A_{--}) )
                  in {+-1}^4,   with   chi(Phi) = product of the four.

Its natural intermediate is the 2-symbol coloring
`(chi(P_m), chi(P_m + 4u^{m-1}))` (the u-descent factorisation, whose factors
are the pairwise products `A_{++}A_{--} = 1 - L_m^2` and
`A_{+-}A_{-+} = 1 - L_m^2 + 4u^m`).  The pair `{A_{+-}, A_{-+}}` is swapped
by `sigma : lambda -> 1-lambda`, and `A_{++}, A_{--}` are individually
sigma-invariant (polynomials in u), so the sigma-invariant part of the
refinement is a 3-symbol coloring.

**Governing covers (symbolic-exact, m = 2..8).**  The correlation sum for a
subset S of the four factors is a Frobenius trace on `y^2 = sqcl(prod_S A)`.
Singleton genera:

| m | g(A++) | g(A+-) | g(A-+) | g(A--) |
|---|--------|--------|--------|--------|
| 2 | 0      | 0      | 0      | 0      |
| 3 | 0      | 1      | 1      | 0      |
| 4 | 0 *    | 1      | 1      | 1      |
| 5 | 1      | 2      | 2      | 1      |
| 6 | 2      | 2      | 2      | 2      |
| 7 | 2      | 3      | 3      | 0 *    |
| 8 | 3      | 3      | 3      | 3      |

`*` marks a genuine degeneracy, not merely genus 0.  At m = 4,
`A_{++} = 1 + lambda^4 + (1-lambda)^4 = 2 (lambda^2-lambda+1)^2 = 2 I^2`,
so `chi(A_{++}) = chi(2)` is **constant** on F_p for every p — a proved
constant stratum of the refined census.  At m = 7 the square-class degree of
`A_{--} = 1 - L_7` drops from 6 to 2 for the same reason.  These are the two
m <= 8 instances of `m == 1 (mod 3)`, and they show that the `I^2` of the
proved genus law is *localised in a single Fermat factor*: `A_{++}` when
`m == 4 (mod 6)`, `A_{--}` when `m == 1 (mod 6)`, verified at
m = 4, 7, 10, 13, 16 (observation 3 of section 3).  The refined coloring sees
this localisation; the discriminant coloring, which only sees `I^2`, does
not.

All fifteen non-empty subsets and their genera are printed by
`legA-covers`; the top subset reproduces `C_m` itself (genus 6 at m = 5,
8 at m = 6, matching the corrected genus law), which is the consistency
check that the refinement sits above the discriminant coloring.

### 1.6 The census (computed, m = 2..6, odd p <= 200)

Method, and the Ergodis route.  A joint distribution of four quadratic
characters is recovered from its 16 correlation sums by inclusion–exclusion:

    N(eps) = (1/16) sum_{S subset of the four factors}
                    (prod_{i in S} eps_i) . T_S,
    T_S    = sum_{lambda good} prod_{i in S} chi(A_i(lambda)),

and each `T_S` is exactly one Ergodis `census` request on the product
polynomial `prod_S A_i`.  The Ergodis kernel censuses over all of F_p, so the
generator enumerates the (small) set of lambda where some factor vanishes,
together with the degenerate points lambda = 0, 1, and subtracts their
contributions to restrict every correlation sum to the common good set.
Sixteen Ergodis requests per (m, p) replace `4p` Legendre-symbol evaluations.

| m | p range | strata seen (of 16) | largest stratum deviation | Ergodis == direct Python |
|---|---------|---------------------|---------------------------|--------------------------|
| 2 | 3..200  | 16                  | 1.53 sd (p = 167)         | yes                      |
| 3 | 3..200  | 16                  | 1.20 sd (p = 7)           | yes                      |
| 4 | 3..200  | 16                  | 2.37 sd (p = 139)         | yes                      |
| 5 | 3..200  | 16                  | 2.48 sd (p = 23)          | yes                      |
| 6 | 3..200  | 16                  | 3.11 sd (p = 13)          | yes                      |

("sd" is `|N(eps) - n/16| / sqrt(n)` with n the number of good lambda.)  All
sixteen strata occur at every m in the range; no stratum is systematically
empty or systematically over-full, so the four covers behave like independent
double covers and the refinement is equidistributed to `O(sqrt p)`, as the
Weil bound on each of the fifteen correlation sums requires.  The m = 4
constant stratum of section 1.5 is visible as the exact vanishing of eight of
the sixteen counts whenever `chi(2) = -1` (verified at p = 5, 11, 13: zero
lambda with `chi(A_{++}) = +1`; at p = 17, where `chi(2) = +1`, all 15 good
lambda have `chi(A_{++}) = +1`).  That is not a bias, it is a degeneracy of
the cover, and it is why the m = 4 row of the table still reports 16 strata:
the missing eight reappear at the primes with `chi(2) = +1`.

### 1.7 Periodicity: the refinement doubles the resolution (computed, p <= 59)

For lambda outside {0, 1}, `lambda^{2m}` depends on m only through
`2m mod (p-1)`, so the discriminant census has period `(p-1)/2` in m; but
`lambda^m` depends on `m mod (p-1)`, and replacing m by `m + (p-1)/2`
replaces `lambda^m` by `chi(lambda) lambda^m`, a quadratic twist of the
Fermat factors.  Measured for every odd prime `5 <= p <= 59` and every
m in 2..6:

| statistic            | census at m versus at m + (p-1)/2 |
|----------------------|-----------------------------------|
| chi(Phi) coloring    | equal at every p in the range     |
| four-factor coloring | differs at every p in the range   |

So the refined coloring separates the two halves of the exponent
stratification that the discriminant coloring identifies.  This is the one
concrete gain of the refinement, and it says where to look for a finer
version of the `2m mod (p-1)` stratum theorems of the modular-structure
report: those theorems should have `m mod (p-1)` refinements visible only on
the Fermat factors.

## 2. Leg B — Sato–Tate at m = 8

### 2.1 The objects

From the Chevalley–Weil report (proved there): at m = 8 the multiplicities
are `(a,b,c) = (2,2,4)`, `g(C_8) = 12`, and

    Jac(C_8) ~ A_triv x A_sgn x A_std^2,   dim (2, 2, 4),
    Jac(D_1) ~ A_triv x A_std   (dim 6),   Jac(D_2) ~ A_sgn x A_std,
    A_triv = Jac(C_8/S_3) : Y^2 = 16 J (J+4)(16J^3+68J^2+16J+1),
    A_sgn  = Jac(C_8/S_3'): Z^2 = (4J-27) . 16 J (J+4)(16J^3+68J^2+16J+1),

with `J = I^3/W^2`.  The leading 16 is a square and is dropped.  The
generator rebuilds the two genus-6 quotients independently from
`Phi_{16,4}(u) = P_8 (P_8 + 4u^7)`:

    D_1 : y^2 = 16 - 208u + 1380u^2 - 5896u^3 + 17668u^4 - 38448u^5
                + 61289u^6 - 71060u^7 + 58786u^8 - 33592u^9 + 12597u^10
                - 2856u^11 + 340u^12 - 16u^13                      (genus 6)
    D_2 : y^2 = (1-4u) . (the same square class)                   (genus 6)

so the two chains — the S_3-quotient models and the u-descent models — are
computed from different starting data and can be cross-checked against each
other.

### 2.2 The isotypic split, verified prime by prime (computed, p <= 700)

Method: PARI/GP 2.17.3 `hyperellcharpoly` on all four reduced models at every
odd `p <= 700` of good reduction for all four (120 primes), then exact
division of L-polynomials in Q[T] (`c1014_st_legb.gp`).

* `L(D_1) / L(A_triv)` is a polynomial at **all 120** primes.
* `L(D_2) / L(A_sgn)`  is a polynomial at **all 120** primes.
* The two degree-8 cofactors are **equal at all 120** primes.

That is a prime-by-prime confirmation, from two independently constructed
families of models — the `S_3`-quotients in `J` and the u-descent quotients in
`u` — of the decomposition `Jac(D_1) ~ A_triv x A_std`,
`Jac(D_2) ~ A_sgn x A_std` at m = 8, and it pins the standard-isotypic
L-factor as the common degree-8 cofactor `L_std`.

**The standard part is a simple abelian fourfold, not a doubled surface**
(computed, p <= 700).  `L_std` is irreducible over Q at 117 of the 120
primes, has two factors at 2 primes and three at 1 prime.  An abelian
fourfold isogenous to `B^2` for an abelian surface B would have
`L_std = L_B^2`, a square, at every prime; an irreducible degree-8 factor is
incompatible with that at a single prime, let alone 117.  So `A_std` at m = 8
does not split, and the natural guess "the degree-8 standard factor is twice
a degree-4 piece" is **refuted**.  Its normalised-trace moments over the 120
primes are `E[t^2] = 1.16`, `E[t^4] = 3.43`, `E[t^6] = 15.42`, against the
USp(8) reference `1, 3, 15` — close enough to make `A_std` a generic simple
fourfold the clear reading, though 120 primes is a short range for a
Sato–Tate call in dimension 4.

### 2.3 Reference Sato–Tate moments (computed exactly)

The moments of the normalised trace `t` are computed in the generator, not
quoted: for `USp(2g)`, `E[t^n]` is the dimension of the invariants in the
n-th tensor power of the standard representation, obtained by counting paths
of length n from the empty partition to itself on the Bratteli diagram of
partitions with at most g rows (add or remove one box per step).  For a
product of factors the moment sequences are convolved binomially; for a
disconnected group they are averaged over the components; `U(1)` contributes
`E[t^{2k}] = binom(2k,k)` and `SU(2)` contributes the Catalan numbers.

| Sato–Tate group   | corresponding arithmetic                            | E[t^2] | E[t^4] | E[t^6] | E[t^8] |
|-------------------|-----------------------------------------------------|--------|--------|--------|--------|
| USp(4)            | A absolutely simple, End = Z (generic)              | 1      | 3      | 14     | 84     |
| SU(2)xSU(2)       | E1 x E2 non-isogenous non-CM; also GL2-type with RM | 2      | 10     | 70     | 588    |
| N(SU(2)xSU(2))    | Q-simple, GL2-type only over a quadratic field      | 1      | 5      | 35     | 294    |
| SU(2) diagonal    | E x E, isogenous                                    | 4      | 32     | 320    | 3584   |
| N(SU(2)) diagonal | E x E^d, quadratic twist                            | 2      | 16     | 160    | 1792   |
| SU(2) x N(U(1))   | non-CM x CM over Q                                  | 2      | 11     | 90     | 889    |
| SU(2) x U(1)      | non-CM x CM with the CM field rational              | 3      | 20     | 175    | 1764   |
| N(U(1)) x N(U(1)) | two CM curves over Q                                | 2      | 12     | 110    | 1260   |
| U(1) x U(1)       | CM abelian surface, CM field rational               | 4      | 36     | 400    | 4900   |

The identification does not depend on the completeness of that list, because
the moments are monotone.  The Sato–Tate group of an abelian surface is a
closed subgroup `G` of USp(4) (the symplectic pairing), and for a compact `G`
the even moment `E[t^n]` equals `dim (V^{⊗n})^G`; a smaller group has at
least as many invariants, so

    E_G[t^n] >= E_{USp(4)}[t^n]  for every n and every closed G in USp(4),

with equality in all n only for `G = USp(4)`.  USp(4) is therefore the unique
*minimum* of the whole moment table, and every proper subgroup is separated
from it by the first moment at which it acquires an extra invariant: the
fourth moment 5 versus 3 for the smallest such subgroup in the list, and
larger elsewhere.  A measurement sitting at `(1, 3, 14)` — and not above it —
identifies USp(4) without any appeal to the classification.

### 2.4 The measurement (statistical, odd good p <= 7703)

`hyperellcharpoly` on the two genus-2 models at every odd prime of good
reduction (`c1014_st_moments.gp`); `L(T) = T^4 - a_1 T^3 +
a_2 T^2 - p a_1 T + p^2`, `t = a_1 / sqrt p`, and `a_2 / p` is the second
elementary symmetric function of the normalised Frobenius eigenvalues, whose
expectation is the dimension of the invariants in the second exterior power:
1 for USp(4), 2 for SU(2)xSU(2), 1.5 for N(SU(2)xSU(2)).

| row                       | primes | p max | E[t^2] | E[t^4] | E[t^6] | E[a_2/p] | frac a_1 = 0 | frac L reducible over Q |
|---------------------------|--------|-------|--------|--------|--------|----------|--------------|-------------------------|
| A_triv (m = 8), measured  | 976    | 7703  | 0.999  | 3.083  | 15.592 | 0.984    | 0.018        | 0.087                   |
| A_sgn  (m = 8), measured  | 973    | 7703  | 0.949  | 2.863  | 14.704 | 0.986    | 0.017        | 0.052                   |
| USp(4), exact             | -      | -     | 1      | 3      | 14     | 1        | 0            | 0                       |
| SU(2)xSU(2), exact        | -      | -     | 2      | 10     | 70     | 2        | 0            | 1                       |
| N(SU(2)xSU(2)), exact     | -      | -     | 1      | 5      | 35     | 1.5      | 0.5          | -                       |

The `frac a_1 = 0` column is a density of an integer condition, so for a group
with no trace-killing component it decays like `p^{-1/2}` rather than being
literally 0; the measured 0.018 at p ~ 7700 is that decay, and it is nowhere
near the exact 1/2 that any extra trace-killing component would force.  The
`frac L reducible` column is the density of primes at which the degree-4
L-polynomial factors over Q; a surface isogenous to a product of two elliptic
curves over Q gives 1, and the measured 0.05-0.09 is the expected density of
accidental coincidences for a simple surface.

(The script's prime bound is 10000; the run recorded here was stopped at
p = 7703 for time, which only shortens the range.)

### 2.5 Verdict

Both surfaces sit on USp(4) and on nothing else.  The second moment is near 1
rather than 2, which excludes every split case; the fourth moment is near 3
rather than 5, which excludes the Q-simple-but-GL2-type-over-a-quadratic-field
case `N(SU(2)xSU(2))` — the only other candidate with second moment 1; the
`a_2/p` mean is near 1 rather than 2 or 1.5, an independent confirmation from
a different coefficient; and `a_1 = 0` occurs at a small non-zero density, as
USp(4) predicts, rather than at density 1/2 as every group with a
trace-killing component would give.  So, **statistical, and unambiguous on
this range**:

    ST(A_triv at m = 8) = ST(A_sgn at m = 8) = USp(4),

hence `End(A_Qbar) = Z` for both, hence both are absolutely simple abelian
surfaces with no extra endomorphisms and neither is of GL2-type.

**Consequence for the uniform conjecture.**  The tt-pass candidate "every
isotypic factor of Jac(C_m) is of GL2-type with level supported on the
bad-prime law" is **false**.  It held for m = 3..7 only because every
isotypic factor there is one-dimensional, and elliptic curves are of GL2-type
for free.  At the first dimension-2 instance both factors are generic.  The
salvageable statement is the level half of it, which does survive (section
2.6), and a corrected shape of the conjecture:

    every isotypic factor of Jac(C_m) has good reduction outside Bad(C_m),
    and is absolutely simple with trivial endomorphism algebra as soon as its
    dimension exceeds 1.

The first clause is the one worth pursuing; the second is a prediction to
test at m = 9, 10, 11 (where a = 2, 2, 3) and at the standard part.

### 2.6 Conductors at m = 8, 9, 10, and a sharpened level law

The Chevalley–Weil report derived the `S_3`-quotient models only as far as
m = 8 and left the level law measured at three consecutive m.  The generator
recovers `R_m(J)` for any m by an argument that is cheaper than the original
derivation and is worth recording: `tau`-invariance of
`G = f_m . I^beta / W^alpha` (with `f_m` the square class of `Phi_{2m,4}`,
`I = lambda^2-lambda+1`, `W = lambda(lambda-1)`) forces

    3 alpha = 2k + 2 beta,   alpha even,   k = (deg f_m)/2,

and the smallest such `(alpha, beta)` with `beta >= 0` makes `G` a polynomial
in `J = I^3/W^2`, recovered by exact interpolation and verified as an
identity.  The construction reproduces the report's `R_5`, `R_6`, `R_7`, `R_8`
exactly (up to the square constant 16 at m = 8) and extends to m = 9, 10:

| m  | a | R_m(J), square class                     | genus |
|----|---|------------------------------------------|-------|
| 5  | 1 | 5 J (20J^2+25J+8)                        | 1     |
| 6  | 1 | (2J+3)(72J^2+102J-1)                     | 1     |
| 7  | 1 | 7 (28J^3+147J^2+196J+8)                  | 1     |
| 8  | 2 | J (J+4)(16J^3+68J^2+16J+1)               | 2     |
| 9  | 2 | 3 (3J+1)(36J^4+417J^3+1269J^2+351J-1)    | 2     |
| 10 | 2 | (2J+15)(200J^4+1750J^3+1955J^2+600J+8)   | 2     |

PARI `genus2red` (Liu's algorithm) on the three genus-2 rows and their sign
twins `(4J-27) R_m(J)`, script `c1014_st_cond2.gp`.  `genus2red` does not
compute the exponent at 2 and returns it as -1, so every conductor below is
the **odd part** only.

| m  | odd cond(A_triv) | factorisation   | odd cond(A_sgn) | factorisation                | odd Bad(C_m)          |
|----|------------------|-----------------|-----------------|------------------------------|-----------------------|
| 8  | 29               | 29              | 475107          | 3 . 29 . 43 . 127            | {3, 29, 43, 127}      |
| 9  | 1474767          | 3^6 . 7 . 17^2  | 631691865       | 3^5 . 5 . 7 . 17^2 . 257     | {3, 5, 7, 17, 257}    |
| 10 | 8348125          | 5^4 . 19^2 . 37 | 2559535125      | 3 . 5^3 . 7 . 19^2 . 37 . 73 | {3, 5, 7, 19, 37, 73} |

**The Chevalley–Weil prediction holds at all three new values of m**: the
sign-side conductor is divisible by every odd bad prime, and the trivial-side
conductor is a proper divisor of the same support.  That is the first test of
that prediction beyond the three rows it was extrapolated from, and it now
rests on six consecutive m.

**What the trivial side drops, against the H/M/E decomposition.**  Splitting
`Bad(C_m) = {2} ∪ H(m) ∪ M(m) ∪ E(m)` into harmonic, collision, and
true-double-branch primes (these three sets overlap; values from the
modular-structure report's table), and comparing only odd primes, since the
2-part of the m = 8, 9, 10 conductors is undetermined:

| m  | H(m) harmonic     | M(m) collision | E(m) double branch | odd primes cond(A_triv) drops |
|----|-------------------|----------------|--------------------|-------------------------------|
| 5  | {3, 5, 17}        | {5}            | {3, 5}             | {17}                          |
| 6  | {3, 11, 31}       | {3}            | {11}               | {31}                          |
| 7  | {5, 7, 13}        | {7}            | {7, 13}            | {5}                           |
| 8  | {3, 43, 127}      | -              | {29, 43}           | {3, 43, 127}                  |
| 9  | {3, 5, 17, 257}   | {3}            | {3, 5, 7, 17}      | {5, 257}                      |
| 10 | {7, 19, 73}       | {5}            | {3, 19, 37}        | {3, 7, 73}                    |

Two statements hold across all six rows and are recorded as **measured,
m = 5..10**:

    the collision primes M(m) are never dropped by the trivial side;
    every dropped prime lies in H(m) ∪ E(m).

Neither "the dropped primes are exactly the harmonic ones" nor "the
double-branch primes are never dropped" survives: at m = 8 the trivial side
drops 43, which is in `E(8)`, and at m = 10 it drops 3, which is in `E(10)`
and not in `H(10)`.  So Chevalley–Weil open item (8) is advanced — three new
rows, the sign-side half confirmed, and the collision primes identified as
the ones that never drop — but the trivial-side rule is still not pinned
down.  The m = 8 row is the extreme case: `M(8)` is empty and all of `H(8)`
drops, leaving `cond(A_triv)` odd-supported on 29 alone.

The odd conductor 29 for an absolutely simple abelian surface with trivial
endomorphism ring is small enough to deserve an independent check before it
is quoted anywhere: the 2-part is genuinely undetermined here and
`genus2red` marks it so.  Recorded as **computed (odd part only)**.

## 3. Open observations

**(1) Leg A closes thread 3 of the card, negatively and completely.**  There
is no Hasse or spinor refinement of the Gram square-class coloring, at any
level, because the form is `H ⊥ <-2, 2 Phi>` universally.  The card's thread-3
line "Hasse/spinor invariants as the next arithmetic shadows past the square
class" should be struck and replaced by the factorisation refinement of
section 1.5.  The argument does not need any classification theorem: an
explicit isometry is exhibited, so *every* invariant of the form — Hasse,
Clifford, spinor norm, higher cohomological — is a function of the square
class of `Phi` and the constants `2` and `-1`.

**(2) The one place the refinement pays.**  The doubling of the exponent
period from `(p-1)/2` to `(p-1)` (section 1.7).  Every stratum theorem of the
modular-structure report is stated in `2m mod (p-1)`; each should have a
finer companion in `m mod (p-1)` visible only on the Fermat factors, and the
`(47, 30)` sporadic — still unexplained — lives in exactly the regime where
the two resolutions differ.  That is a concrete next probe: recompute the
sporadic stratum with the four-factor coloring and see whether it splits.

**(3) The `m == 1 (mod 3)` degeneracy is localised in one Fermat factor, and
the alternation is mod 6.**  The proved genus law says only that `I^2 | Phi`
when `m == 1 (mod 3)`; the refinement says *which* of the four Fermat factors
carries it.  Checked at m = 4, 7, 10, 13, 16 (**computed**):

    I^2 divides A_{++}  exactly when  m == 4 (mod 6),
    I^2 divides A_{--}  exactly when  m == 1 (mod 6),

and in every case with multiplicity exactly 2 and in exactly one factor.
m = 4 is the extreme case, `A_{++} = 2 I^2` with nothing left over.  So the
`I^2` of the genus law is not a property of `Phi` as a whole but of a single
Lucas factor `1 +- L_m`, and which one is decided by `m mod 6` — the same
period-6 arithmetic that governs the 3-cycle trace in the Chevalley–Weil
computation.

**(4) The constant part of the Hasse class tracks the collision primes.**
The Brauer class `(2, content(Phi)) . (-1,-1)` over Q is ramified at
`{2, oo}` for m = 2, 4, 6, 7, 8 and at `{3, oo}`, `{5, oo}` for m = 3, 5.
The square-free content of `Phi_{2m,4}` is 1 for even m and m itself for odd
m — the same odd `p | m` that the bad-prime law calls the collision locus.
So the collision primes are visible in the *constant* term of the quadratic
form data, which is a cheaper witness for them than the resultant
computation.  **Computed, m = 2..8**; the content law itself is untested
beyond that range.

**(5) The standard part at m = 8 is a simple fourfold.**  `L_std` is
irreducible at 117 of 120 primes and its normalised moments
`(1.16, 3.43, 15.42)` sit on the USp(8) reference `(1, 3, 15)`.  So
`Jac(C_8)` is isogenous to `A_triv x A_sgn x B^2` with `A_triv`, `A_sgn`
non-isogenous simple surfaces and `B` a simple fourfold, all with trivial
endomorphism algebra — a completely generic decomposition, forced entirely by
the `S_3`-action and by nothing arithmetic.  The 120-prime range is short for
a dimension-4 Sato–Tate call; extending `c1014_st_legb.gp` past p = 2000
would settle it, at the cost of genus-6 `hyperellcharpoly` runs whose time
grows steeply.

**(6) The level law survives the conjecture's collapse, partially.**
Section 2.6 confirms the sign-side half at m = 8, 9, 10 — the sign-side
conductor uses every odd bad prime — even though none of those surfaces is
modular in the GL2 sense.  That already says the asymmetry is a statement
about the branch divisor (the extra branch point `J = 27/4` is the harmonic
orbit) and not about newforms, so it should be provable directly from the two
quotient models rather than measured; proving it would make the conductor
support of every isotypic piece a priori for all m and retire the newform
searches.  The trivial-side half is *not* explained: the collision primes are
never dropped in any of the six measured rows, but the dropped set is not the
harmonic set (m = 8 drops a double-branch prime, m = 10 drops a
non-harmonic one).

**(6b) A cheaper route to the quotient models.**  The `(alpha, beta)`
recipe of section 2.6 produces `R_m(J)` for arbitrary m from the square class
of `Phi_{2m,4}` alone, by one linear condition plus interpolation, and
reproduces every previously derived model.  The earlier derivation needed the
covariant `Omega = W I^{(k-3)/2}` and the automorphy factor; this needs
neither.  It is the practical tool for pushing the level law to m = 11, 12,
where `a = 3` and the isotypic pieces become abelian threefolds (out of
`genus2red` range, but not out of `hyperellcharpoly` range for a Sato–Tate
test).

**(7) Not settled: the 2-adic conductor exponents.**  `genus2red` does not
compute them, so open item (9) of the Chevalley–Weil report (the m = 6 flip
in the 2- and 3-adic exponents between the two isotypic sides) gains no new
data point from m = 8.  Deciding it needs 2-adic regular models, which PARI
does not provide.

## Mystery ledger

| # | Surprising or unexplained feature | Settled by this pass? | Gap / owner |
|---|-----------------------------------|-----------------------|-------------|
| 1 | The Gram form has no second invariant at all, over any field | **Settled** (proved, section 1.1) | none; thread 3 of the card closes |
| 2 | Every square-class factor of Phi ramifies the Hasse class, uniformly in m = 2..8 | Measured, not explained | Why is 2 never a square in kappa(pi)? Likely forced by the 2-adic Newton polygon of the Fermat factors; unproved |
| 3 | Which Fermat factor carries the `I^2` of the genus law | **Settled as a computed rule, m = 4..16**: `A_{++}` when m == 4 (mod 6), `A_{--}` when m == 1 (mod 6) | a proof from `L_m(1) = 2 cos((m)pi/3)`-type period-6 identities is one line away and not written here |
| 4 | Both m = 8 isotypic surfaces are generic (USp(4)) although both m = 5, 6, 7 factors are modular elliptic curves | **Settled**: the earlier modularity was an artefact of dimension 1 | none |
| 5 | Odd conductor 29 for an absolutely simple abelian surface with End = Z | Computed, unverified at 2 | needs a 2-adic regular model; do not quote the full conductor until then |
| 6 | Which bad primes the trivial-side conductor drops | Partly: three new rows, and the collision primes provably never drop in the measured range; the dropped set is still uncharacterised | m = 11, 12 need abelian threefolds (out of `genus2red` range); the 2-adic exponents remain undetermined |
| 7 | The refined coloring has twice the exponent resolution of the discriminant coloring | Measured and explained (quadratic twist by `chi(lambda)`) | the consequence for the `(47,30)` sporadic is untested |

## Ergodis interface notes

**Fits, and was used.**  The whole of the Leg A census (section 1.6) ran
through the Ergodis character kernel.  The new pattern is worth recording
because it generalises: a *joint* distribution of k quadratic characters is
recoverable from the `2^k` correlation sums by inclusion–exclusion, and each
correlation sum is one `census` request on a product polynomial.  So the
existing single-polynomial census primitive already computes k-fold joint
colorings with no new typed operation — 16 requests per `(m, p)` here in
place of `4p` Legendre evaluations, with the agreement against direct Python
exact at every one of the 5 x 45 (m, p) pairs tested.  This is the second
independent replay leg required by
`notes/research-reproducibility-conventions.md`.

**One small friction.**  The kernel censuses over all of F_p, and the
inclusion–exclusion needs every correlation sum restricted to the *common*
good set (the lambda where no factor vanishes, plus the excluded degenerate
lambda = 0, 1).  The generator has to enumerate the exceptional lambda in
Python and subtract their contributions by hand.  A typed
`census-excluding {p, coefficients, exclude: [x...]}` — or, better, a
`joint-census {p, [f_1..f_k]}` returning the `2^k` counts directly — would
remove that correction step and make the joint coloring a first-class object.
This is packaging, not a new kernel: the arithmetic is already there.

**Misfits.**  Leg B is entirely outside Ergodis, for the same reason recorded
in the modular-structure report: it needs characteristic polynomials of
Frobenius on genus-2 and genus-6 curves (`hyperellcharpoly`), exact division
and factorisation of L-polynomials over Q, and Liu reduction for conductors
(`genus2red`).  Ergodis has no zeta function, no extension-field arithmetic,
and no global arithmetic.  The `hyperelliptic-zeta {p, coefficients}` request
from the previous pass remains the single highest-value addition and would
have covered the split verification of section 2.2 outright; it would not
have covered the moment run (which needs a thousand primes and Kedlaya-class
performance) or the conductors.

Nothing in the rank, orbit, span, or incidence modules applies.

Driver used: `/home/tavis/.cache/ergodis/c1013-census-target/release/c1013-census`
(crate `notes/clebsch-tasks/c1013-ergodis-driver`; build tree in
`~/.cache/ergodis/`, nothing under `notes/`).

Status: complete.
