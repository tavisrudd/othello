# C314: invariant moduli atlas for the C297 constant-`p` family

**Lane**: `relconic`

**Date:** 2026-07-18

**Status:** complete; exports a finite marked atlas, reconstruction maps, degeneracy divisors, and
the exact finite quotient actions to C315/C316.

## Result

Let `E/F` be quadratic of characteristic two on the odd tower, fix
`omega^2+omega+1=0`, and normalize the first repair coset by C297's genuine projective scaling:

    e_1=1,       rho=e_2/e_1 in F^*\{1},       d=1+rho.  (1)

Write `bar(z)` for relative conjugation and set

    theta=w^2+w+1,
    ell=p*(1+sqrt(c)),
    A=K+1.                                                (2)

The ordered constant-`p` family is reconstructed from

    (rho,alpha,beta,c,p,w,K,B,C)                         (3)

by

    x_0=p^2*theta,
    K_1=K,                         K_2=c*K,
    A_1=K+1,                       A_2=c*K+1,
    B_1=B,                         B_2=B+ell*K,
    C_1=C,
    C_2=C+B*d*omega+d^2*omega^2+K*(p^2*theta+d*p*omega). (4)

Here

    rho*c*p*K*alpha*beta!=0,
    rho!=1,                       alpha+beta notin F,     (5)

and `w` is identified with `w+1`.  The latter is equation gauge for the same `x_0`, not a
projectivity.

The remaining projective translation `mu in F` acts exactly by

    w -> w+t*mu,                    t=(1+sqrt(c))/p,
    C -> C+A*mu^2+B*mu,                                   (6)

with all other coordinates in (3) fixed, followed if desired by `w~w+1`.  Equivalently,

    x_0 -> x_0+(c+1)*mu^2+ell*mu.                         (7)

Equations (1)--(7) are an exact quotient presentation and already suffice to reconstruct the
marked family.  The finite atlas below resolves (6) into explicit sections.  It has one
irreducible constant-`p` component of dimension thirteen over `F`; `c=1` is a divisor, not a
second component.  The C210 slice

    c=1,       K=1+a*omega,       B=b*omega               (8)

has codimension three and dimension ten, as C297's raw count predicts.

## Derivation of the residual action

C297's normalized quotient sends

    C_i -> C_i+A_i*mu^2+B_i*mu.                          (9)

Using (4), the change in the constant relation is

    x_0 -> x_0+(c+1)*mu^2+p*(1+sqrt(c))*mu.              (10)

Since `c+1=(1+sqrt(c))^2`, division by `p^2` changes `theta` by

    (t*mu)^2+t*mu.

Thus (6) gives exactly (10).  This calculation is important: quotienting `C` alone while holding
`w` fixed would be wrong away from `c=1`.

The parameter space before (6) has fourteen `F`-dimensions:
one each from `rho,c,p,w`, two each from `K,B,C`, and four from the ordered seed pair.  The
one-dimensional translation quotient gives dimension thirteen.  It is irreducible because it is
the quotient of the irreducible open (5), using the irreducible Artin--Schreier cover in `w`;
the finite gauge `w~w+1` and later relabelings do not change dimension or components.

## Finite projective atlas

All charts below are disjoint locally closed strata, so no unrecorded overlap transition is
needed.  Each displayed section reconstructs (3)--(4); the stated finite identification is part
of the chart.

### U: unequal curvature, `c!=1`

Now `t!=0`.  Choose `mu=w/t` in (6), set `w=0`, and hence set `x_0=p^2`.  Replacing the original
representative `w` by `w+1` changes the chosen `mu` by `t^-1`.  Therefore the exact chart is

    (rho,alpha,beta,c,p,K,B,C_U),       c!=1,             (11)

modulo the residual involution

    C_U -> C_U+H_U,
    H_U=A/t^2+B/t.                                           (12)

The inverse reconstruction uses (4) with `w=0` and any representative of the two-element orbit
(12).  The involution is free when `H_U!=0`; its fixed divisor is

    B=A/t.                                                (13)

On (13), the nonzero translation `mu=t^-1`, combined with `w~w+1`, is an order-two projective
stabilizer.  Off (13), the normalized marked projective stabilizer is trivial.

### E0: equal curvature with independent directions

Suppose `c=1`, so `t=ell=0`, `K_2=K_1`, `B_2=B_1`, and `w` is fixed by projective translation.
Put

    Delta=A*bar(B)+bar(A)*B in F.                         (14)

On `Delta!=0`, `{A,B}` is an `F`-basis of `E`.  Write

    C=u*A+v*B,
    u=(C*bar(B)+bar(C)*B)/Delta,
    v=(A*bar(C)+bar(A)*C)/Delta.                          (15)

Translation sends `(u,v)` to `(u+mu^2,v+mu)`, so

    J=u+v^2                                               (16)

is invariant.  The unique section `v=0` has

    C=J*A.                                                (17)

Thus E0 uses `(rho,alpha,beta,p,w,K,B,J)` with `Delta!=0` and `w~w+1`.  Its inverse is (17), and
its marked projective stabilizer is trivial.

### E1 and E2: equal curvature with `A!=0`, `Delta=0`

Here

    B=s*A,       s=B/A in F.                              (18)

Write

    C/A=r+y*omega,       r,y in F.                        (19)

The transverse coordinate `y=(C/A)+bar(C/A)` is invariant, while

    r -> r+mu^2+s*mu.                                    (20)

If `s=0` (chart E1), Frobenius is bijective on `F`, so the unique section is

    C=A*y*omega.                                         (21)

If `s!=0` (chart E2), the image of `mu^2+s*mu` consists exactly of the elements `r_0` with
`Tr(r_0/s^2)=0`.  There are two arithmetic orbits, indexed by

    epsilon=Tr(r/s^2) in GF(2),

with sections

    C=A*(y*omega+epsilon*s^2).                            (22)

Every E2 point has the order-two stabilizer `{0,s}`.  E1 has trivial stabilizer.  Formula (22) is
an atlas for `F`-rational projective orbits; geometrically over an algebraic closure the
Artin--Schreier map is surjective and the discrete `epsilon` disappears.

### E3 and E4: the `A=0` boundary

The equation `A=0` is `K=1`.  If `B!=0` (E3), write `C/B=r+y*omega`.  Translation sends
`r->r+mu`, so the unique section is

    C=B*y*omega.                                         (23)

The stabilizer is trivial.

If `A=B=0` (E4), translation acts trivially.  The full `C in E` remains as a coordinate and the
stabilizer is the entire additive group `F`.  This is the only positive-dimensional stabilizer
locus.  Together U and E0--E4 exhaust (6), including every dependent-direction and zero-vector
case.

## Reconstruction and transition under relabeling

Seed interchange simply swaps `alpha` and `beta`.  It has no fixed point on (5), because a fixed
ordered pair would have `alpha=beta`, contrary to `alpha+beta notin F`.

Repair interchange followed by the normalization of the new first coset is

    rho'   =rho^-1,
    alpha' =alpha/rho^2,           beta'=beta/rho^2,
    c'     =c^-1,
    p'     =p/(rho*sqrt(c)),
    w'     =w  (mod w~w+1),
    K'     =c*K,
    B'     =(B+ell*K)/rho,
    C'     =C_2/rho^2,                                  (24)

where `C_2` is reconstructed by (4), after which the target chart applies its section from
(11)--(23).  The identity

    x_0'/(p')^2=x_0/p^2=theta

proves the `w` rule.  Substitution also gives

    ell'=ell/(rho*c),
    B'+ell'*K'=B/rho,

so applying (24) twice returns the original projective orbit.  Since a fixed point would require
`rho=rho^-1`, hence `rho=1` in characteristic two, repair interchange is free on (5), even on the
divisor where the two layer conics coincide.

Equations (4), (6), and (24) are the complete transition data.  They retain all constants needed
by C312 and by a universal incidence construction; no raw C297 coefficient action has to be
re-derived downstream.

For the unlabelled finite quotient, useful symmetric coordinates before taking semilinear orbits
are

    R=rho+rho^-1,
    s_S=(alpha+beta)/rho,          n_S=alpha*beta/rho^2,
    s_K=K*(1+c),                   n_K=c*K^2,             (24a)

and the unordered normalized linear-coefficient pair

    {B_1/e_1,B_2/e_2}={B,(B+ell*K)/rho}.                 (24b)

Here `(s_S,n_S)` recovers the unordered seed heights after the common geometric weight is removed,
and `(s_K,n_K)` recovers the unordered pair `{K_1,K_2}`.  The atlas coordinate for `C` must still
be retained: the symmetric data (24a)--(24b) alone do not reconstruct the translated constants.
Thus they are coordinates for the finite relabeling quotient, not a replacement for the marked
atlas.

## Semilinear orbit boundary and `E/F` directions

The atlas deliberately retains `K,B,C in E`, or their exact section coordinates, because their
relative trace and norm

    tr(z)=z+bar(z),       Nm(z)=z*bar(z)                  (25)

determine only the unordered pair `{z,bar(z)}`.  Relative conjugation is not a projectivity and
must not be silently used to choose one root.  Thus (25), together with a residual conjugation
sheet, records each unrestricted `E/F` direction without collapsing projective orbits.

For a field automorphism `sigma` preserving `F`, C297's action applies `sigma` to the normalized
coordinates and then uses

    C_i' =sigma(C_i)+sigma(A_i)*kappa_i^2
           +sigma(B_i)*kappa_i,
    kappa_i=epsilon_sigma*sigma(e_i)+mu,                 (26)

followed by the appropriate atlas section; scaling is included if `sigma(e_1)!=1`.  Relative
conjugation has `epsilon_sigma=1`, while ordinary Frobenius may also act nontrivially on `F`.
Consequently:

- the projective orbit space is exactly U and E0--E4 modulo (12), `w~w+1`, and the two finite
  relabelings;
- the semilinear orbit space is the further quotient by (26);
- trace/norm coincidences certify possible semilinear pairing, not projective equivalence.

No resultant symmetry or equation gauge is added to either orbit space.

## Degeneracy and deletion table

For use in C315/C316, define

    v_1=omega,                 v_2=rho*omega,
    D_i=A_i*v_i^2+B_i*v_i+C_i.                            (27)

The conic carrying layer `i` has normalized equation

    X*Z=K_i*Y^2+B_i*X*Y+D_i*X^2.                         (28)

For any two recovered layer conics `L,M`, all affine intersections are governed by the invariant
difference polynomial

    Q_LM(X)=(K_L+K_M)*X^2+(B_L+B_M)*X+(D_L+D_M).         (28a)

Thus `Q_LM=0` coefficientwise is exactly conic coincidence; `B_L+B_M=0` is the
inseparable/tangent boundary when the quadratic coefficient is nonzero; and the existence of an
intersection with a prescribed `F`-parameter domain is exactly the corresponding resultant with
`X^|F|-X`.  This records the full conic-intersection degeneration without selecting roots.

The following table is invariant under (6); equations may be checked in any atlas section.

| Locus | Exact equation or open |
|---|---|
| distinct repair cosets | `rho*(rho+1)!=0` |
| distinct/legal seed layers | `alpha*beta!=0`, `alpha+beta notin F` |
| internal repair legality | `K*c!=0` |
| equal repair curvature and linear direction | `c=1` (then `ell=0`) |
| first zero curvature | `A_1=K+1=0` |
| second zero curvature | `A_2=c*K+1=0` |
| first zero linear coefficient | `B=0` |
| second zero linear coefficient | `B+ell*K=0` |
| two repair layer conics coincide | `c=1`, `p=d`, `w in {0,1}` |
| repair conic `i` equals seed conic `gamma` | `K_i=1`, `B_i=0`, `D_i=gamma` |
| repair conic `i` equals the prescribed conic | `K_i=1`, `B_i=0`, `D_i=0` |
| a selected repair point lies on the prescribed conic | `A_i*r^2+B_i*r+C_i=0` for some `r in F` |

For the last row, the exact eliminated equation over a fixed `F` is

    Res_X(A_i*X^2+B_i*X+C_i, X^|F|-X)=0.                (29)

Pointwise conic avoidance is the inequation that (29) is nonzero.  The coincidence formula in
the preceding row follows from comparing all three coefficients in (28): on `c=1` the remaining
difference is

    K*(x_0+d*p*omega+d^2*omega^2),

which vanishes exactly when `p=d` and `theta=1`, equivalently `w in {0,1}`.

For C312's determinant strata, take either packet `U=(U_2,U_1,U_0)` reconstructed from (4).  Since
`v_i=e_i*omega` and `omega+bar(omega)=1`, its pair-sum coefficients are the regular functions

    a_j=(U_j+bar(U_j))/e_i.                              (30)

Thus the packet boundaries are exactly

    a_2=0,       a_1=0,       a_0=0,                    (31)

with `a_2=a_1=a_0=0` the repeated-root-safe stratum, `a_2=a_1=0,a_0!=0` the constant-trace
stratum, `a_2=0,a_1!=0` the linear-pole stratum, and `a_2!=0,a_1=0` the inseparable-quadratic
stratum.  C312's explicit pole-cancellation functions supply the further closed equations inside
(31).  Equations (27)--(31), together with `d*p*K*c!=0`, are the complete atlas-visible
denominators and degeneracy divisors needed to pull back C312's eight legality packets.  Any new
rank divisor belonging to C316's not-yet-constructed incidence map must be derived there rather
than guessed from C305's specialized height presentation.

## Stabilizers and intrinsic recognition boundary

The marked projective stabilizers are completely classified by the atlas:

- trivial on U off (13), E0, E1, and E3;
- order two on U divisor (13) and throughout E2;
- the full additive group on E4.

Seed and repair relabelings are free on the ordered open (5).  Semilinear stabilizers are a
separate finite-extension problem governed by (26); a full classification is not needed by C315
or C316 and is not asserted.

For `|F|>16`, C297's intersection argument intrinsically recovers every distinct layer conic from
the unmarked point set: a different conic meets each of the four layer conics in at most four
points and hence contains at most sixteen selected points.  Once two recovered layer conics are
distinct, their common point at infinity and common tangent are intrinsic.  The exceptions are
exactly coincidences among the conics, including the tabled repair--repair and repair--seed loci.

This argument does **not** by itself distinguish the prescribed empty conic from every other
member of the common-tangent pencil.  Accordingly, the stronger recovery of the prescribed conic
from the unmarked selected set is left as a secondary recognition question; it is not used in the
marked atlas or either downstream gate.  No `q<=16` full-projective classification is claimed.

## Downstream chart table

| Chart | Base conditions | Quotient coordinate for `C` | Stabilizer | Finite actions |
|---|---|---|---|---|
| U | `c!=1` | `C_U mod C_U~C_U+H_U` | trivial; `C2` on `H_U=0` | seed/repair swap, semilinear |
| E0 | `c=1`, `Delta!=0` | `J=u+v^2`, section `C=J*A` | trivial | `w~w+1`, swaps, semilinear |
| E1 | `c=1`, `A!=0`, `B=0` | `y`, section `C=A*y*omega` | trivial | `w~w+1`, swaps, semilinear |
| E2 | `c=1`, `A!=0`, `B=s*A`, `s!=0` | `(y,epsilon)` as in (22) | `C2` | `w~w+1`, swaps, semilinear |
| E3 | `c=1`, `A=0`, `B!=0` | `y`, section `C=B*y*omega` | trivial | `w~w+1`, swaps, semilinear |
| E4 | `c=1`, `A=B=0` | full `C in E` | additive `F` | `w~w+1`, swaps, semilinear |

C315 should pull C312's eight packets back through (4), use (30)--(31) to stratify them, and solve
each row of this table.  C316 should construct any surviving universal incidence object directly
from (4) on the same rows.  Repair reversal uses (24) and then re-sections the target row; no
coefficient or orbit census is required.

## Evidence boundary

This is a proof-only quotient theorem.  The atlas follows from the additive action (6), elementary
Artin--Schreier images over `F`, and direct reconstruction.  The conic equations and degeneracy
loci are coefficient comparisons.  No CAS decomposition, finite-field sample, or C300
classification is used.

## Vibe check

Good: the thirteen-dimensional omitted family now has a small, exact atlas.  Unequal curvature
has one residual involution; equal curvature has five transparent direction strata, and every
extra marked stabilizer is visible.  C315 can attack seed legality without redoing quotient
algebra, while C316 has a lossless coefficient reconstruction if survivors remain.
