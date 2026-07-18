# C316: the constant-height survivor has relative-offset collision maps

**Lane**: `relconic`

**Date:** 2026-07-18

**Status:** complete; exports four lossless incidence presentations, their generic degrees, and
the full exceptional-divisor skeleton to C317.

## Result

On C315's odd-degree-tail survivor, C305's two-height collision map does **not** generalize.  All
four layer heights share one common offset `H in E`, and this offset cancels identically from every
three-point determinant.  Its coefficient matrix has rank zero, not two.  Collision geometry is
therefore independent of `H`; only prescribed-conic avoidance and the nonzero-seed opens see it.

The collision-sensitive targets are instead the two relative seed offsets

    Gamma_alpha=alpha+H,       Gamma_beta=beta+H.         (1)

After simultaneous translation of the three selected affine parameters is factored out, the only
remaining mixed-layer collision supports are governed by four finite dominant maps:

| support | collision-sensitive target | generic degree |
|---|---|---:|
| `R_1,R_2,S_alpha` | `Gamma_alpha` | `6` |
| `R_1,R_2,S_beta` | `Gamma_beta` | `6` |
| `S_alpha,S_beta,R_1` | `Gamma_alpha` | `5` |
| `S_alpha,S_beta,R_2` | `Gamma_alpha+Delta_R` | `5` |

Here `Delta_R=C_2+C_1`.  On the exact repair-conic coincidence locus `Delta_R=0`, each degree-six
map drops to degree two.  The degree-five maps have no analogous survivor divisor because
`Gamma_alpha+Gamma_beta notin F` is a standing seed open.

Every unreduced collision incidence has one additional affine-line factor: adding the same
subfield element to all three selected affine parameters fixes their differences and preserves
the triple.  Thus each incidence variety has total dimension ten over the nine-dimensional
marked survivor moduli, with generic relative dimension one.  The reduced finite maps above are
the exact quotients by that free translation parameter; no geometric collision is discarded.

Dominance and degree are geometric statements over the full relative-offset planes.  C315's
absolute-trace survivor conditions select arithmetic subsets of those planes.  This report does
not claim that every arithmetic survivor value has an `F`-rational preimage; fiber components,
constant fields, rational points, and the final obstruction-versus-construction conclusion belong
to C317.

These four supports are exhaustive.  A triple contained in one layer is excluded by internal
legality; a `2+1` triple on the two repair layers is excluded by C297; and a `2+1` triple on one
seed and one repair layer is excluded by C312--C315.  A triple meeting three distinct layers has
exactly one of the four supports in the table.

## Survivor coordinates and the failed height bundle

Use C315's normalized parameters

    rho in F^*\{1},       d=1+rho,       P0 in F^*,
    theta=w^2+w+1,        Tr(theta)=1,   w~w+1,           (2)

and put

    Delta_R=d^2*omega^2+P0^2*theta+d*P0*omega.          (3)

The four layer heights are exactly

    R_1: H,                    R_2: H+Delta_R,
    S_gamma: H+Gamma_gamma.                            (4)

In C315's seed coordinates,

    Gamma_gamma
      =(P0^2*Y_gamma+1)+(P0*X_gamma+1)*omega.           (5)

Thus `(X_gamma,Y_gamma) -> Gamma_gamma` is an affine isomorphism of two-dimensional `F`-planes.
The two points satisfy C315's exact trace conditions, `X_alpha!=X_beta`, and the zero-height opens
listed below.

For arbitrary `x_i,h_i`, the determinant identity is

    det(P(x_1,h_1),P(x_2,h_2),P(x_3,h_3))
      =(x_1+x_2)*(x_2+x_3)*(x_3+x_1)
       +(x_2+x_3)*h_1+(x_3+x_1)*h_2+(x_1+x_2)*h_3.     (6)

Adding `H` to all three heights contributes

    H*((x_2+x_3)+(x_3+x_1)+(x_1+x_2))=0.               (7)

Consequently the exact coefficient matrix for the two `F`-coordinates of `H` is the zero
`2 by 2` matrix on every support.  There is no rank-open on which `H` can be reconstructed from a
collision triple.  The full survivor is instead the rank-two common-offset bundle over

    B=(rho,P0,w,Gamma_alpha,Gamma_beta),                 (8)

where `B` has arithmetic parameter dimension seven.  Its fiber deletes the four sections

    H=0,          H=Delta_R,          H=Gamma_alpha,
    H=Gamma_beta.                                         (9)

The first two are prescribed-conic avoidance for the repair layers; the last two are
`alpha*beta!=0`.  Repeated sections are deleted only once on their coincidence loci.

This audit is lossless: (5) reconstructs both seed heights from `(B,H)`, while (3)--(4)
reconstruct both repair heights.  It is also the exact reason C305's matrix cannot be imported.
C305 varied two repair-height coordinates while holding a seed height fixed; C315's survivor
forces all four heights to move by the same `H`.

## Repair--repair--seed incidence

Fix `gamma in {alpha,beta}` and take

    x_1=omega+r,       x_2=rho*omega+s,       x_3=t.

Put

    u=r+s,             a=t+r,
    q=d*omega+u,       z=omega+a.                       (10)

The three affine points lie in distinct cosets, so they are automatically distinct.  Substitution
of (4) into (6), followed by cancellation of `H`, gives

    q*(Gamma_gamma+z^2+q*z)+z*Delta_R=0.                (11)

For `u in F`, `q` is nonzero and

    Nm(q)=u^2+d*u+d^2                                  (12)

has no zero on the odd tower.  Division by `q` is therefore exact on rational triples.  The
reduced collision map is

    Psi(u,a)=z^2+z*(q+Delta_R/q)=Gamma_gamma.            (13)

Before division, multiplication by `q` has the coordinate matrix

    [ u  d   ]
    [ d  u+d ],                                          (14)

with determinant (12).  This is the same matrix shape found in C305, but here it reconstructs the
relative target `Gamma_gamma`, not the common height `H`.

The original parameters are recovered losslessly from `(u,a,r)` by

    s=u+r,             t=a+r.                            (15)

Thus `r in A^1` is precisely the free simultaneous-translation factor.

### Generic degree six

The degree calculation is transparent after base change to an algebraic closure that splits
`E/F`.  Let `x` and `y` be the first components of `q` and `z`; the conjugate components are
`x+d` and `y+1`.  Write `delta,bar(delta)` for the two components of `Delta_R` and set

    A=x+delta/x,
    Bx=x+d+bar(delta)/(x+d),
    S=A+Bx,
    T=Gamma_1+Gamma_2+1+Bx.                             (16)

Away from `S=0`, the sum of the two component equations gives `y=T/S`.  Substitution into the
first gives

    T^2+A*T*S+Gamma_1*S^2=0.                            (17)

Put `D=x*(x+d)` and write `A=A_n/D`, `S=S_n/D`, `T=T_n/D`, where

    A_n=(x^2+delta)*(x+d),
    S_n=d*(x^2+P0*x+delta),
    T_n=(Gamma_1+Gamma_2+1)*D+x*(x^2+d^2+bar(delta)).    (18)

After multiplication by `D^3`, equation (17) has numerator

    E_RR=T_n^2*D+A_n*T_n*S_n+Gamma_1*S_n^2*D.           (19)

The factor `D` records the two poles `x=0,d` introduced by clearing denominators.  Dividing it out
leaves a degree-six polynomial whose leading coefficient is `rho=1+d!=0`.  For a generic target,
neither pole is a solution and `S=0` contributes only when its separate compatibility equation
`T=0` holds.  Hence (13) is dominant and generically finite of degree six.

The split-coordinate Jacobian is

    J_RR=y*(A'*Bx+A*Bx')+A*Bx'.                         (20)

It is not identically zero, so the generic degree-six extension is separable.  The exact source
branch divisor is the numerator of (20), after deleting `x*(x+d)=0`.  If
`F_RR=E_RR/D` and `Jhat_RR` is (20) after `y=T/S` and denominator clearing, its target branch
scheme is exactly the `x`-elimination of

    (F_RR,Jhat_RR):(D*S_n)^infinity.                    (20a)

This saturated ideal, rather than an expanded discriminant, is the compact exact branch
certificate exported to C317.  The coefficient divisor

    S_n=d*(x^2+P0*x+delta)=0                            (21)

is retained separately because the coordinate solve `y=T/S` changes chart there, even when the
map itself is unramified.

### Repair-conic coincidence

By C314--C315,

    Delta_R=0  iff  P0=d and w in {0,1}.                (22)

On this locus (13) becomes the polynomial map

    Psi_0(u,a)=z^2+q*z.                                 (23)

In split coordinates `A=x`, `Bx=x+d`, so `S=d!=0`.  Solving the summed equation makes `y` affine
in `x`; substitution gives a quadratic with leading coefficient `rho/d^2!=0`.  Thus (23) is
dominant of generic degree two.  Its Jacobian is

    J_RR,0=x+d*y.                                       (24)

The coincidence locus is not deleted: it is a genuine lower-degree incidence component for
C317.

## Seed--seed--repair incidence

Take seed parameters `t,u`, a point `e_i*omega+r` of repair layer `i`, and put

    p=t+u,             a=r+t,             y=e_i*omega+a,
    e_1=1,             e_2=rho,
    Delta_S=Gamma_alpha+Gamma_beta.                      (25)

If `p=0`, equation (6) reduces to `y*Delta_S`, which is nonzero because `y notin F` and
`Delta_S notin F`.  Hence every collision has `p!=0`.  For

    Delta_1=0,         Delta_2=Delta_R,

the exact reduced equation is

    Chi_i(p,a)=y^2+y*(p+Delta_S/p)
      =Gamma_alpha+Delta_i.                             (26)

Multiplication by `p` before division has scalar coordinate matrix `p*I_2`, determinant `p^2`.
The original triple is recovered from `(p,a,t)` by

    u=p+t,             r=a+t,                            (27)

so `t` is again exactly the free simultaneous-translation factor.

### Generic degree five and branch divisor

Write

    Delta_S=delta_0+delta_1*omega,       delta_1!=0,
    Z=Gamma_alpha+Delta_i=Z_0+Z_1*omega.                (28)

The two coordinates of `p+Delta_S/p` are

    h_0=(p^2+delta_0)/p,        h_1=delta_1/p.           (29)

The omega-coordinate of (26) uniquely recovers `a`.  Put

    N=e_i*p^2+(Z_1+e_i^2)*p+e_i*(delta_0+delta_1).      (30)

Then `a=N/delta_1`, and substitution into the
base coordinate gives the exact eliminant

    E_SS(p)=N^2*p+e_i^2*delta_1^2*p
      +(p^2+delta_0)*N*delta_1+e_i*delta_1^3
      +Z_0*delta_1^2*p.                                 (31)

Its degree is five with leading coefficient `e_i^2!=0`.  At `p=0`, its value is

    e_i*delta_1*Nm(Delta_S)!=0,                          (32)

so clearing the denominator introduces no root.  Therefore each map (26) is dominant and
generically finite of degree five.

Direct differentiation of the two coordinate functions gives the Jacobian

    J_SS=e_i*(p^4+delta_1*p^2+Nm(Delta_S))/p^3.          (33)

It is not identically zero.  Its numerator `B_SS` is the exact scheme-theoretic source branch
divisor; over a perfect closure it is a square, but the map is generically separable because (33)
is nonzero at the generic point.  The target branch scheme is exactly

    Res_p(E_SS,B_SS)=0,                                 (33a)

with multiplicities retained.  No saturation at `p=0` is needed because (32) proves that it is
not a root of `E_SS`.  The only reconstruction divisor is `p=0`, already proved collision-free.

## Dimensions, losslessness, and quotient compatibility

The arithmetic survivor skeleton `B` in (8) has parameter dimension seven: one each from
`rho,P0,w` and two from each relative seed offset.  The common-offset bundle has rank two, so the
marked survivor has dimension nine after the finite trace restrictions and before finite
relabeling/semilinear quotients.

For every one of the four supports, adjoining three selected point parameters and imposing the
two coordinate equations gives total dimension

    9+3-2=10.                                           (34)

The explicit reconstructions (15) and (27) prove losslessness.  After quotienting the free
translation line, the maps have relative dimension zero and the generic degrees in the result
table.  No resultant symmetry or extra projective quotient is used.

The constructions respect all of C314's exact actions:

- `w~w+1` fixes `theta` and `Delta_R`;
- seed interchange swaps the two degree-six maps and reparameterizes (26) by interchanging
  `Gamma_alpha,Gamma_beta`;
- repair interchange swaps the two degree-five maps and carries (13) through C314's normalized
  scaling with `rho->rho^-1`;
- semilinear automorphisms preserve (6), the opens, and the displayed branch ideals;
- the additive `E4` projective stabilizer fixes every coefficient and is not the free translation
  of the three selected parameters in (15) or (27).

Hence charting, relabeling, and semilinear passage neither duplicate nor omit an incidence
component.

## Complete exceptional and deletion skeleton for C317

C317 must retain the following loci explicitly.

| locus | role |
|---|---|
| `H in {0,Delta_R,Gamma_alpha,Gamma_beta}` | prescribed-conic and zero-seed deletions |
| `Delta_R=0`, equivalently (22) | repair conics coincide; degree `6 -> 2`, not deleted |
| `Gamma_gamma=0` or `Gamma_gamma=Delta_R` | repair conic 1 or 2 equals seed conic `gamma`; allowed |
| `Gamma_gamma=omega^2` | layer-one seed packet is identically repeated-root; allowed |
| `Gamma_gamma=Delta_R+rho^2*omega^2` | layer-two seed packet is identically repeated-root; allowed |
| `x*(x+d)=0` | geometric pole divisor of (13); no odd-tower `F`-points |
| `S_n=0` from (21) | alternate reconstruction chart for the degree-six map |
| `J_RR=0` or `J_RR,0=0` | repair--repair--seed ramification |
| `p=0` | seed--seed--repair collision-free deletion |
| numerator of `J_SS` in (33) | seed--seed--repair ramification |
| `X_gamma=1` | absent from C315's arithmetic survivor fiber |
| `X_alpha=X_beta` | forbidden seed-difference divisor |

Point distinctness needs no further divisor: the three supports in each incidence type lie in
distinct affine cosets or distinct marked seed layers, and the only same-`x` seed case `p=0` is
proved noncollinear.  The finite trace conditions defining `T_rho,theta` remain part of the base,
not branch divisors of these geometric maps.

## C317 interface and evidence boundary

C317 should consume:

1. the common-offset reconstruction (2)--(5) and deletions (9);
2. the degree-six maps (13), eliminant (19), branch chart (20)--(21), and degree-two specialization
   (22)--(24);
3. the degree-five maps (26), eliminant (31), and branch divisor (33);
4. the lossless translation reconstructions (15), (27) and dimension formula (34); and
5. the complete exceptional table above.

It must determine geometric components and constant fields of the fibers over C315's arithmetic
trace subset, count deleted rational points, and decide whether every survivor has a genuine
collision or whether an arithmetic collision-free subfamily remains.  Dominance and generic
degree alone do not answer that question.

This is a proof-only result.  Equations (11) and (26) are direct substitutions into the universal
determinant (6); all matrices, eliminants, Jacobians, and degrees are displayed above.  No CAS
decomposition, coefficient sample, or finite-field census is evidence for the theorem.

## Vibe check

Strong simplification with a real remaining arithmetic question.  The feared generalized
two-height bundle collapses completely: common height is invisible to collisions.  What remains
is four small finite relative-offset maps of degrees `6,6,5,5`, with one exact degree-two
coincidence specialization.  C317 can now analyze explicit fibers instead of an unspecified
height image.
