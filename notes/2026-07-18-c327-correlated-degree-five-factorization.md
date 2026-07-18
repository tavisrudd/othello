# C327: correlated degree-five factorization before C299

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** active; theorem-led analysis of C316's two seed--seed--repair eliminants, with no large
field or coefficient census.  The first common pentic normal form and shared branch identity are
proved below, together with generic geometric monodromy `S5` for each pentic separately.  Their
generic splitting fields are disjoint and retain joint monodromy `S5 times S5` after the legality
Artin--Schreier base changes.  The generic legality cover is geometrically connected of degree
sixteen with constant field `GF(2)`.  On the common seed-translation line, the exact slope audit
has seven (not four) possible dependence divisors; off them the legality cover is a rational curve,
totally ramified only at infinity, and has exactly `Q/16` legal base parameters.  Pullback of the
two pentic covers and an explicit effective simultaneous-derangement count remain open.

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

## Theorem state and exit gate

| Package | State | Exact boundary |
|---|---|---|
| common invariant pentic form | complete | equations (1)--(7) |
| generic separability and irreducibility | complete | degree-five rational cover (8)--(9) |
| individual geometric monodromy | complete | `S5` by the generic transposition theorem |
| shared resolvents/splitting fields | complete generically | distinct sign divisors give disjoint fields and `S5 times S5` |
| trace-legality geometrization | complete generically | connected degree-sixteen `(C2)^4` cover, constant field `GF(2)` |
| effective arithmetic point supply | open | common-translation curve, branch/genus/deletions, effective Chebotarev |
| exceptional survivor rows | open | `X in {0,d}`, `Delta_R=0`, repeated-root/conic and branch divisors |
| downstream interface | open | two degree-six gates and relative coverage, conditional on degree-five survival |

C327 exits with an explicit simultaneous no-root theorem and threshold, an exact obstruction, or a
bounded mixed theorem naming the irreducible effective-point-count obstruction.  It does not exit
from generic monodromy or the conditional main term alone.

## Guardrails and stop conditions

- No raw coefficient census, full-field enumeration, or `Q=512` run.
- Tiny-field probes may guide conjectures but are not theorem evidence.
- Any load-bearing symbolic calculation must be a compact, deterministic, git-visible identity,
  resolvent, factorization certificate, or independently checkable output.
- Generic monodromy alone is insufficient: the trace-defined arithmetic slice and correlations
  between `E_1,E_2` must be controlled.
- Stop with a bounded mixed theorem if the trace-slice step requires substantially new machinery;
  name the exact missing hypothesis rather than invoking Chebotarev heuristically.

## Cold-session restart

### Minimal reading

After the root guide and relconic handoff, read this report in full.  Then use only:

1. C316's seed--seed--repair equations (25)--(33) and its exceptional/deletion table;
2. C315's survivor coordinates and trace conditions (13)--(20); and
3. C317 only for the fixed-versus-fresh theorem boundary.

Do not preload C312's packet derivation, C314's full atlas, C305's rejected census, or the old C210
residue reports unless an exact open divisor points back to them.

The closed C327 steps are committed as:

- `5312e378`: common pentic normal form and branch identity;
- `0641c949`: generic individual `S5` monodromy;
- `bc827624`: generic disjointness and joint `S5 times S5` through legality base change; and
- `c827582e`: connected degree-sixteen legality cover with constant field `GF(2)`.

### Immediate packet: the common-translation curve

Fix the invariant skeleton

    (rho,P0,w,x,x',t),       t=y+y',

on the open

    rho*P0*(rho+1)*(x+x')*(x)*(x+d)*(x')*(x'+d)*(x+1)*(x'+1)!=0,
    d=1+rho.

Translate both seed coordinates by one parameter `h`:

    y=y_0+h,                 y'=y'_0+h.

Characteristic two keeps `t=y+y'`, hence `Delta_S`, fixed.  Both pentics therefore remain covers
of one common target line while legality varies with `h`.

The four Artin--Schreier slopes on the `h`-line are

    1/x^2,       rho^2/(x+d)^2,
    1/(x')^2,    rho^2/(x'+d)^2.                       (21)

Perform the following steps in order.

1. Prove the four slopes (21) are `GF(2)`-independent on an explicit skeleton open; classify every
   subset-sum dependence divisor rather than hiding it generically.  The exact answer below has
   seven divisors: two pair, four triple, and one four-slope divisor.
2. Construct the resulting degree-sixteen legality cover of `P1_h`; prove its geometric
   components, constant fields, genus, infinity ramification, and exact affine deletions.
3. Pull back the two pentic splitting covers and recheck `S5 times S5` on this one-parameter slice.
   Generic monodromy on the full base does not automatically prove monodromy on every fiber.
4. List the finite transposition branch values and compute the wild inertia above `h=infinity`.
5. Construct the smallest quotient or twists detecting the derangement union

       D={(5),(3,2)} subset S5,

   rather than defaulting to the full `120^2*16=230400`-sheet Galois closure.
6. Apply a source-pinned effective function-field Chebotarev or an equivalent explicit
   twist-and-Hasse--Weil bound.  Record genus/degree, constant field, deleted points, error term, and
   an actual odd-tower threshold.
7. Subtract the common-height, zero-seed, branch, and other C315/C316 deletions explicitly.

Conditional on the group and equidistribution surviving this slice, the predicted proportions are

    legality among h:                         1/16,
    both pentics derangements given legality: (11/30)^2=121/900,
    combined main term among h:               121/14400.              (22)

Equation (22) is a target main term, not a theorem.  The session succeeds only after producing the
effective error and deletions needed to make its lower bound positive, or after proving the exact
reason this slice cannot do so.

### Literature and computation boundary

Before fetching an effective Chebotarev source, read the shared literature-cache README and query
the cache.  Use a curve theorem with stated hypotheses and constants; do not cite general
Chebotarev or Lang--Weil as a label.

No raw field/coefficient enumeration and no `Q=512` run are authorized.  Tiny-field checks may
debug formulas but are not evidence.  Any symbolic artifact promoted into the theorem must be a
compact deterministic script/output/checksum bundle under the C327-owned paper path.

## Exact legality geometry on the common translation line

Fix a skeleton as in the immediate packet and write the four right sides of the legality equations
as

    f_1=h/x^2+c_1,                 f_2=rho^2*h/(x+d)^2+c_2,
    f_3=h/(x')^2+c_3,              f_4=rho^2*h/(x'+d)^2+c_4,             (23)

where the constants `c_i` contain `y_0,y'_0,theta` and the added `1`.  Put

    l_1=1/x,       l_2=rho/(x+d),       l_3=1/x',       l_4=rho/(x'+d).

The slopes in (23) are `l_i^2`.  On the standing open, their complete subset-dependence list is
the following seven divisors:

| subset | divisor |
|---|---|
| `14` | `x'+d+rho*x=0` |
| `23` | `x+d+rho*x'=0` |
| `123` | `d*(x+1)*x'+x*(x+d)=0` |
| `124` | `d*(x+1)*(x'+d)+rho*x*(x+d)=0` |
| `134` | `d*(x'+1)*x+x'*(x'+d)=0` |
| `234` | `d*(x'+1)*(x+d)+rho*x'*(x'+d)=0` |
| `1234` | `x*x'+x+x'+d=0` |

There are no others.  Thus the earlier cold-session phrase “four slope-dependence divisors” was
too small: it counted neither the two surviving cross-pair relations nor the four-slope relation.
The exact independence open is the standing skeleton open with all seven displayed factors
deleted.

Indeed, squaring is injective, so a subset of the slopes sums to zero exactly when the
corresponding `l_i` sum does.  Singletons are nonzero.  The pairs `12`, `34`, `13`, and `24` reduce
respectively to the already deleted factors `x+1`, `x'+1`, `x+x'`, and `x+x'`; the two remaining
pairs give the first two rows.  Clearing denominators in the four triple sums gives the next four
rows.  Finally

    (l_1+l_2)+(l_3+l_4)
      =d*(x+1)/(x*(x+d))+d*(x'+1)/(x'*(x'+d)),          (24)

whose cleared numerator is

    d*(x+x')*(x*x'+x+x'+d).

The first factor is already deleted, leaving the last row.

### Theorem: the independent legality cover is rational

Let `F=GF(Q)` have odd degree over `GF(2)` and specialize the skeleton to an `F`-point of the exact
independence open.  The cover of `P1_h` obtained by adjoining

    u_i^2+u_i=f_i,             1<=i<=4,                 (25)

is geometrically connected, Galois of degree sixteen with group `(C2)^4`, has constant field `F`,
and has genus zero.  It is etale over `A1_h`; above `h=infinity` it has one `F`-rational point,
with inertia group `(C2)^4`, ramification index sixteen, and different exponent thirty.  Hence it
has exactly `Q` affine `F`-points and exactly

    Q/16                                                        (26)

base parameters `h in F` satisfying all four legality trace conditions.

For the proof, every nonempty character sum of (25) has the form

    u^2+u=a*h+c,             a!=0,

by the seven-divisor audit.  It has one simple pole, at infinity, and no finite pole.  The odd pole
shows that its Artin--Schreier class remains nontrivial after extending the constant field, proving
geometric connectedness and full inertia.  Each of the fifteen nontrivial characters has conductor
exponent two.  The conductor--discriminant formula therefore gives different exponent `15*2=30`,
and Riemann--Hurwitz gives

    2*g-2=16*(-2)+30=-2.

Thus `g=0`.  Full inertia over the rational point at infinity leaves one rational point above it,
so the curve is an `F`-rational projective line and has `Q+1` rational points.  Removing its unique
point at infinity leaves `Q`.  Finally, because `Tr_F/GF(2)(1)=1`, an `h` satisfies C315 (17)
exactly when all four equations (25) split over `F`; such an `h` has exactly sixteen lifts, while
an illegal `h` has none.  Division by sixteen proves (26).

This exact count has no Weil error and no hidden affine deletion.  C315's zero-height and
prescribed-conic exclusions, C316's pentic branch values, and any divisors needed to preserve
`S5 times S5` on the specialized skeleton are downstream deletions and have not yet been
subtracted from (26).

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

## Geometry and constant field of the legality cover

### Theorem

On the generic seed chart

    x,x' notin {0,d,1},             x!=x',

put `theta=w^2+w+1` and adjoin, for `gamma=(X,Y)` equal to either `(x,y)` or
`(x',y')`, variables satisfying

    U_gamma^2+U_gamma=Y/X^2+1,                          (19)
    V_gamma^2+V_gamma=rho^2*(Y+theta)/(X+d)^2+1.        (20)

Over every odd-degree finite field, (19)--(20) have rational solutions exactly when C315's two
trace-one conditions hold.  Over the generic rational base, their four Artin--Schreier classes are
linearly independent modulo `g^2+g`.  Consequently their composite is a geometrically connected
etale cover of degree sixteen with Galois group `(C2)^4` and constant field `GF(2)`.

### Proof of independence

Use the four boundary valuations

    x=0,       x=d,       x'=0,       x'=d.

At `x=0`, only the right side of (19) for `alpha` has a pole.  Its order is two and its leading
residue is `y`, which is not a square in the divisor's rational residue field.  If a rational
function `g^2+g` has a pole of order two, its leading residue is the square of the leading
coefficient of a simple pole of `g`.  Hence the `alpha` class (19) cannot occur with nonzero
coefficient in an Artin--Schreier relation.

At `x=d`, only the `alpha` class (20) has a pole, with leading residue
`rho^2*(y+theta)`.  The square factor `rho^2` does not make the transcendental element
`y+theta` a square in the residue field.  The same argument at `x'=0,d` separately detects the two
`beta` classes.  Thus no nonempty `GF(2)`-linear combination of the four right sides lies in the
image of `g->g^2+g`.

Artin--Schreier theory now gives a degree-sixteen elementary abelian extension.  The valuation
argument remains valid after algebraic closure of the constant field, so the cover is
geometrically connected.  Since its equations and rational base are defined over `GF(2)`, its
actual constant field is `GF(2)`.

For an odd-degree finite field, `Tr(1)=1`; hence (19) is solvable precisely when
`Tr(Y/X^2)=1`, and similarly for (20).  Every generic legal ordered seed pair has exactly sixteen
rational lifts, and every rational lift projects to such a pair.

### Updated arithmetic boundary

The constant-field and generic-connectedness hypotheses behind (18) are now closed, as is the
joint geometric monodromy `S5 times S5` after this base change.  Turning (18) into a theorem still
requires a source-pinned effective Chebotarev or explicit twist-and-point-count bound with:

- the branch and deletion divisors removed explicitly;
- a degree/Betti or other effective error constant;
- a threshold on the odd tower; and
- separate treatment of `X in {0,d}` and the other C315 exceptional rows.

Until that bound is supplied, C327 does not claim that a simultaneous no-root rational point
exists over any particular field.

## Evidence boundary

The task begins from proof-only closed reports.  No new theorem is claimed here yet.  The strategic
motivation and cross-program possibilities are recorded separately in
[`2026-07-18-post-C312–C317-codex-brainstorm.md`](2026-07-18-post-C312–C317-codex-brainstorm.md).
