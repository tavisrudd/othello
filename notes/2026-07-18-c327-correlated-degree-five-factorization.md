# C327: correlated degree-five factorization before C299

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** active; theorem-led analysis of C316's two seed--seed--repair eliminants, with no large
field or coefficient census.  The first common pentic normal form and shared branch identity are
proved below, together with generic geometric monodromy `S5` for each pentic separately.  Their
generic splitting fields are disjoint and retain joint monodromy `S5 times S5` after the legality
Artin--Schreier base changes.  Constant fields and effective finite-field point supply remain open.

## Objective

Determine whether C315's trace-defined `E4` survivor contains a simultaneous no-linear-factor
locus for the two degree-five seed--seed--repair eliminants.  Prove the strongest structural
alternative available before C299:

1. a positive-density or explicit positive-dimensional simultaneous no-root locus;
2. an exact incompatibility or forced-linear-factor theorem; or
3. a bounded mixed result isolating the unresolved monodromy, trace-slice, or exceptional strata.

This task does not solve the two degree-six gates or relative coverage in full.  It must formulate
their first exact consumer interface if the degree-five pair survives.

## Closed inputs

- C315 supplies the survivor coordinates `(rho,P0,w,Gamma_alpha,Gamma_beta,H)`, the single-seed
  safe set `T_{rho,theta}` of size `Q(Q+1)/4`, the ordered-pair condition
  `X_alpha!=X_beta`, and every zero-height/conic deletion.
- C316 supplies, for repair layer `i`, the degree-five eliminant

      E_i(p)=N_i^2*p+e_i^2*delta_1^2*p
        +(p^2+delta_0)*N_i*delta_1+e_i*delta_1^3
        +Z_{i,0}*delta_1^2*p,

  where

      N_i=e_i*p^2+(Z_{i,1}+e_i^2)*p+e_i*(delta_0+delta_1),
      Delta_S=Gamma_alpha+Gamma_beta=delta_0+delta_1*omega,
      Z_i=Gamma_alpha+Delta_i,
      e_1=1,       e_2=rho,       Delta_1=0,       Delta_2=Delta_R.

  It proves `delta_1!=0`, `E_i(0)!=0`, leading coefficient `e_i^2`, and exact reconstruction
  `a=N_i/delta_1`.
- C317 proves that no-root factor types are exactly `(5)` and `(3,2)`, and separates the fixed
  scalar-tower obstruction from the fresh-per-field problem.

Do not re-solve C312's packets, C314's atlas, or C315's legality classification.

## Required theorem package

1. Put both `E_i` in a common invariant coefficient form over the generic survivor base.
2. Prove generic separability and irreducibility, or classify the exact factorization divisor.
3. Determine the generic arithmetic/geometric monodromy groups or a resolvent-level substitute
   sufficient to control the presence of linear factors.
4. Determine whether the two splitting fields share a nontrivial resolvent or forced Frobenius
   invariant.
5. Geometrize C315's absolute-trace conditions through explicit Artin--Schreier covers, with actual
   constant fields audited before any Chebotarev or density statement.
6. Close or isolate `Delta_R=0`, packet repeated-root targets, repair--seed conic coincidences,
   branch loci, and the ordered-seed deletion.
7. If simultaneous no-root survives, state the exact degree-six and relative-coverage consumer
   interface.  Do not infer coverage from collision-freeness.

## Guardrails and stop conditions

- No raw coefficient census, full-field enumeration, or `Q=512` run.
- Tiny-field probes may guide conjectures but are not theorem evidence.
- Any load-bearing symbolic calculation must be a compact, deterministic, git-visible identity,
  resolvent, factorization certificate, or independently checkable output.
- Generic monodromy alone is insufficient: the trace-defined arithmetic slice and correlations
  between `E_1,E_2` must be controlled.
- Stop with a bounded mixed theorem if the trace-slice step requires substantially new machinery;
  name the exact missing hypothesis rather than invoking Chebotarev heuristically.

## First attack

1. Expand `E_i` only far enough to expose its five invariant coefficients and the relation between
   the `e=1,Z=Gamma_alpha` and `e=rho,Z=Gamma_alpha+Delta_R` cases.
2. Compute derivative, discriminant/branch information, and low-degree resolvents symbolically.
3. Search for an exact coefficient transformation relating `E_1` and `E_2`; prove or reject each
   candidate directly.
4. Choose a minimal specialization over a rational function field that can certify a lower bound
   on generic monodromy without a field census.
5. Pull the trace conditions back only after the ambient algebraic relation is understood.

## First result: common pentic normal form

Put

    A_i=Z_{i,1}+e_i^2,
    M=Nm(Delta_S)=delta_0^2+delta_0*delta_1+delta_1^2.

Direct expansion of C316 (31) in characteristic two gives

    E_i(p)=e_i^2*p^5+e_i*delta_1*p^4
      +A_i*(A_i+delta_1)*p^3+e_i*delta_1^2*p^2
      +(e_i^2*delta_0^2+A_i*delta_0*delta_1
        +Z_{i,0}*delta_1^2)*p
      +e_i*delta_1*M.                                  (1)

Thus the target dependence is confined to the `p^3` and `p` coefficients after `(e_i,Delta_S)`
is fixed.  The source-branch quartic is common to the two repair orientations:

    B(p)=p^4+delta_1*p^2+M.                             (2)

Differentiating (1) and adding it back after multiplication by `p` gives the exact identity

    p*E_i'(p)+E_i(p)=e_i*delta_1*B(p).                  (3)

Since `e_i*delta_1*p!=0` on every collision fiber, a root of `E_i` is repeated exactly when it is
a root of `B`.  This recovers C316's Jacobian branch equation directly from the eliminant and shows
that both pentics share the same possible ramification parameters `p`, even though their branch
targets differ.

In C315's survivor coordinates, put

    x=X_alpha,      x'=X_beta,      y=Y_alpha,      y'=Y_beta,
    s=x+x',         t=y+y',         d=1+rho.

Then

    delta_0=P0^2*t,               delta_1=P0*s,
    A_1=P0*x,                     A_2=P0*(x+d),          (4)

and `s!=0` is exactly the ordered-seed open.  In particular the two `p^3` coefficients are

    P0^2*x*x',                   P0^2*(x+d)*(x'+d).      (5)

The `p` coefficients are respectively

    P0^4*(t^2+x*t*s+y*s^2)+P0^2*s^2,                   (6)

    P0^4*(rho^2*t^2+(x+d)*t*s+(y+theta)*s^2)
      +P0^2*rho^2*s^2.                                 (7)

Equations (4)--(7) are the first exact correlation interface.  They show that the two pentics are
not independent random degree-five polynomials: they share `(delta_0,delta_1,M,B)`, and their two
target-dependent coefficient pairs are related by the repair shift `x->x+d`,
`y->y+theta`, `e:1->rho`.  Whether this shared structure forces a common resolvent quotient or
still permits generic disjointness is the next theorem gate.

### Proof

Write

    N_i=e_i*p^2+A_i*p+e_i*(delta_0+delta_1).

In characteristic two, squaring has no cross terms.  Substitution into C316 (31) and collection by
degree gives (1); its constant term is
`e_i*delta_1*(delta_0^2+delta_0*delta_1+delta_1^2)`.  Equation (3) follows by direct
differentiation and cancellation of the odd-degree terms.  For (4)--(7), substitute C315's

    Gamma_gamma=(P0^2*Y_gamma+1)+(P0*X_gamma+1)*omega

and

    Delta_R=(d^2+P0^2*theta)+(d^2+d*P0)*omega

into the definitions of `Delta_S,Z_i,A_i`.  The identities
`rho^2=1+d^2` and characteristic-two cancellation give `A_2=P0*(x+d)` and (7).

This is a direct polynomial proof; no CAS or finite-field sample is evidence for (1)--(7).

## Generic geometric monodromy of each pentic

### Theorem

Fix one repair orientation and work over

    K=GF(2)(e,delta_0,delta_1,A),

on the open `e*delta_1*M!=0`.  Regard `Z_0` as the target coordinate and put

    R(p)=e^2/delta_1^2*p^4+e/delta_1*p^3
      +A*(A+delta_1)/delta_1^2*p^2+e*p
      +(e^2*delta_0^2+A*delta_0*delta_1)/delta_1^2
      +e*M/(delta_1*p).                                 (8)

Then `E(p)=delta_1^2*p*(Z_0+R(p))`.  The cover

    R:P1_p -> P1_{Z_0}

is separable of degree five, its generic defining pentic is irreducible over `K(Z_0)`, and its
geometric monodromy group is `S5`.

The substitutions (4)--(7) are dominant onto the parameters used in this theorem.  Therefore the
result applies separately to both C316 pentics over the generic algebraic survivor base before the
absolute-trace covers are imposed.

### Degree, irreducibility, and separability

The rational function (8) has a pole of order four at infinity and a simple pole at zero.  Hence
its degree is five and

    [K(p):K(R(p))]=5.

The equation `Z_0=R(p)` is therefore the minimal equation of `p` over `K(Z_0)`, proving generic
irreducibility.  From (2)--(3), or by direct differentiation of (8),

    R'(p)=e*B(p)/(delta_1*p^2),                          (9)

which is nonzero.  Thus the degree-five function-field extension is separable.

### A generic transposition

Over an algebraic closure of `K`, write

    B(p)=(p^2+r*p+s)^2,
    r^2=delta_1,                 s^2=M.

Because `delta_1*M!=0`, the quadratic has two distinct nonzero roots `b,c`.  At a root `b`, expand
`R(b+q)`.  The coefficient of `q^2` is

    H_2(b)=e/b+A*(A+delta_1)/delta_1^2,                 (10)

while the coefficient of `q^3` is

    H_3(b)=e/b^2!=0.                                   (11)

Equation (10) is not identically zero in the free parameter `A`.  On its complement, the local
map has leading term `H_2(b)*q^2` and a nonzero odd next term, so it is a separable wild
ramification point of index two.

The two critical values are generically distinct.  Indeed, the coefficient of
`A*(A+delta_1)/delta_1^2` in `R(b)+R(c)` is

    b^2+c^2=(b+c)^2=delta_1!=0.                         (12)

Thus, off one further proper divisor, a branch fiber contains exactly one index-two ramification
point and otherwise unramified sheets.  Its geometric inertia permutation is a transposition.

### Group conclusion

Irreducibility makes the geometric monodromy subgroup of `S5` transitive.  Its order is therefore
divisible by five, so it contains a 5-cycle.  A 5-cycle together with any transposition generates
`S5`: conjugating the transposition by powers of the cycle gives the edges of a connected graph on
the five letters.  Hence the geometric monodromy is `S5`.

### Consequence and remaining caveat

Individually, each ambient pentic has the largest possible geometric monodromy.  This supports no
density conclusion on its own.  C315's trace-one conditions are imposed by Artin--Schreier
double covers, and base change by a 2-extension can meet the unique quadratic subfield of an `S5`
splitting field and reduce monodromy to `A5`.  Moreover the two pentics share
`(delta_0,delta_1,M,B)` and their target coordinates are related by (4)--(7).  C327 must therefore
compute or characterize the two sign/Berlekamp resolvent classes and their pullbacks to the trace
covers before claiming either generic disjointness or simultaneous derangement density.

## Generic disjointness and persistence through the legality covers

### Common target coordinate

Hold `(delta_0,delta_1,A_1,A_2,e_1,e_2)` fixed and vary the two seed `Y`-coordinates by a common
translation.  Their sum, hence `Delta_S`, stays fixed.  Put

    z=Z_{1,0}=P0^2*Y_alpha+1.

Then

    Z_{2,0}=z+c_0,
    c_0=d^2+P0^2*theta.                                 (13)

Thus both pentics define degree-five covers of the same `z`-line.  If `b,c` are the two critical
parameters above, the first sign cover ramifies over

    D_1: z in {R_1(b),R_1(c)},                          (14)

while the second ramifies over

    D_2: z in {R_2(b)+c_0,R_2(c)+c_0}.                  (15)

The sets in (14)--(15) are understood as the corresponding conjugation-invariant degree-two
branch divisors, so no choice of square roots is part of the statement.

### Theorem: the two generic splitting fields are disjoint

The branch divisors `D_1,D_2` are distinct.  Indeed, `R_1,R_2` are independent of `theta` after
the displayed fixed parameters are chosen, whereas (15) moves with nonzero coefficient `P0^2` in
the free algebraic parameter `theta`; (14) does not.  Hence no irreducible component of the
generic transposition divisor in (14) equals one in (15).

Let `L_i` be the splitting field of the `i`th generic pentic over the common survivor function
field.  Each has geometric Galois group `S5`.  Its unique proper nontrivial Galois quotient is the
quadratic sign field, and that field ramifies along `D_i` because the local inertia there is a
transposition.  The distinct branch divisors therefore make the two sign fields distinct.

The intersection `L_1 intersect L_2` is Galois over the base and corresponds to a common quotient
of the two `S5` groups.  A nontrivial proper common quotient would identify the sign fields; equality
of the full splitting fields would also identify them.  Both are excluded.  Consequently

    L_1 intersect L_2=K_base,
    Gal(L_1*L_2/K_base)=S5 times S5.                    (16)

### The legality Artin--Schreier covers do not reduce (16)

On the generic C315 chart `X_gamma notin {0,d,1}`, the four trace-one requirements can be
geometrized by adjoining Artin--Schreier variables for

    Y_gamma/X_gamma^2+1,
    rho^2*(Y_gamma+theta)/(X_gamma+d)^2+1,

for `gamma in {alpha,beta}`.  After deleting the displayed denominator divisors, these are finite
etale 2-power covers.  In particular they are etale at the generic points of `D_1,D_2`.

Any intersection of their composite with `L_1*L_2` is a normal 2-power quotient of
`S5 times S5`.  It is therefore contained in the compositum of the two sign quadratic fields.
Every nontrivial field in that biquadratic compositum ramifies along `D_1`, `D_2`, or both, while
the legality composite is etale there.  The intersection is trivial.  Thus, on every geometric
component of the generic legality cover,

    Gal((L_1*L_2)*K_legal/K_legal)=S5 times S5.          (17)

This closes the generic shared-resolvent question at the group level: the two splitting fields
have no common nontrivial resolvent field, and the legality covers do not create one.

### Arithmetic boundary

The derangement conjugacy classes in `S5` are `(5)` and `(3,2)`, with respectively `24` and `20`
elements.  If an effective finite-field Chebotarev theorem applies to a geometrically connected
legality component with constant field `GF(2)`, the joint group (17) predicts main-term proportion

    ((24+20)/120)^2=(11/30)^2=121/900                 (18)

for simultaneous no-linear-factor pentics on that component.

Equation (18) is presently a conditional main term, not a proved finite-field density.  The next
gate is to classify the geometric components and constant fields of the fourfold legality cover,
then supply an effective error term uniform enough for the odd tower.  No independence heuristic
or uneffective invocation of Chebotarev is substituted for that work.

## Evidence boundary

The task begins from proof-only closed reports.  No new theorem is claimed here yet.  The strategic
motivation and cross-program possibilities are recorded separately in
[`2026-07-18-post-C312–C317-codex-brainstorm.md`](2026-07-18-post-C312–C317-codex-brainstorm.md).
