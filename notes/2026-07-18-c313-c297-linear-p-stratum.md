# C313: exact arithmetic of the C297 linear-`p` stratum

**Lane**: `relconic`

**Date:** 2026-07-18

**Status:** complete; the stratum is empty over every odd-degree scalar field, before the
seed--repair gate.

## Result

Let `F=GF(2^n)` with `n` odd.  C297's normalized linear repair-pair-sum system

    U_2=c,
    U_1=d*L*(z+omega),
    U_0=d^2*z^2,

with `c,L,d in F^*` and `z in F`, is cross-repair legal in both orientations only if

    1+L*(z^2+z+1)+c=0,                                 (1)
    Tr((c+L)/L^2)=1,                                   (2)
    Tr(c*(1+L)/L^2)=1.                                 (3)

There is no solution.  Indeed, the sum of the two trace arguments is

    (c+L+c*(1+L))/L^2
      =(1+c)/L
      =z^2+z+1,                                        (4)

where the last equality is (1).  Hence (2)--(3) would give

    0=1+1
      =Tr(z^2+z+1)
      =Tr(z^2+z)+Tr(1)
      =1,                                               (5)

because absolute trace kills every Artin--Schreier element and
`Tr_F/GF(2)(1)=n mod 2=1`.  This contradiction is uniform over the entire odd tower.

Consequently the linear-`p` locus has no algebraic component satisfying the two cross-repair
trace conditions and contributes no seed-legal component to C315 or C316.  C312's seed--repair
test is vacuous on this locus.  No field census, curve point count, or asymptotic argument is
involved.

## Elimination and exact boundary

For completeness, eliminate `c` from (1).  Put

    h=z^2+z+1,       x=L^-1.

Then

    c=1+L*h,
    (c+L)/L^2=x^2+(z^2+z)*x,                            (6)

    c*(1+L)/L^2=(x+h)*(x+1).                            (7)

Using `Tr(x^2)=Tr(x)`, equations (2)--(3) become

    Tr(h*x)=1,
    Tr(h*(x+1))=1.                                     (8)

Their sum is `Tr(h)=0`, whereas `Tr(h)=Tr(1)=1` for odd `n`.  Thus the direct elimination
(6)--(8) agrees exactly with the shorter obstruction (4)--(5).

The contradiction uses only `L!=0`, which is already needed for the linear pair sum.  The other
opens do not hide an exceptional solution:

- `d!=0` says that the two repair cosets are distinct;
- `c!=0` makes the second internal coefficient `K_2=c*K_1` nonzero;
- `z` is an element of `F`, not an `E/F` direction: it is the subfield coordinate introduced when
  the unique pole of the linear pair-sum function is translated to the origin;
- `1+L=0` is allowed by the algebra but does not evade (4)--(5); equation (3) would then have trace
  zero immediately;
- no division by `c`, `d`, `z`, or `1+L` occurs in the contradiction.

Thus there is neither a lost pole fiber nor a zero-parameter component.  The normalized solution
scheme on the stated open is empty for every odd-degree `F`.

## Repair-coefficient reconstruction

The empty-locus result can be checked against the original repair graphs without importing any
C210 specialization.  Write

    R_i={P(e_i*omega+r,A_i*r^2+B_i*r+C_i):r in F},
    d=e_1+e_2,       K_i=1+A_i.

For the orientation with two points on `R_1`, C297's coefficient definitions are

    U_2=K_2/K_1,
    U_1=(B_2+B_1)/K_1,
    U_0=(C_2+C_1+B_1*d*omega+d^2*omega^2)/K_1.          (9)

Therefore every hypothetical normalized linear-`p` member would be reconstructed by choosing
`K=K_1 in E^*` and arbitrary `B_1,C_1 in E`, then setting

    K_2=c*K,                  A_1=K+1,
    A_2=c*K+1,
    B_2=B_1+K*d*L*(z+omega),
    C_2=C_1+B_1*d*omega+d^2*omega^2+K*d^2*z^2.          (10)

Conversely, substituting (10) into (9) recovers the displayed `U_2,U_1,U_0`, so (10) loses no
repair coefficient.  Internal repair legality is exactly `K_1*K_2=c*K^2!=0`.  C297's trace
reduction says that cross-repair legality in both orientations is exactly (1)--(3).  Equations
(4)--(5) therefore prove that no coefficient tuple (10) passes the cross-repair gate over an odd
scalar degree.

In particular, pointwise conic avoidance and seed choices cannot rescue this stratum: they are
conditions on a family that has already failed to be an arc.  There is no need to apply C312's
eight seed packets, and no seed orientation or repeated-root divisor remains unresolved.

## Projective, relabeling, and semilinear behavior

The negative is invariant under exactly the actions proved by C297, with no enlargement of the
quotient.

- Weighted scaling and subfield translation act on (9) through the genuine affine
  conic-stabilizer.  Scaling gives `d` and `U_1` weight one and `U_0` weight two; translating the
  unique pole and then restoring it to zero is the parameterization normalization used above.
  Neither operation changes the two absolute trace classes.
- Repair reversal exchanges the two orientations whose trace classes are (2) and (3).  Their sum
  (4), and hence the contradiction, is symmetric under that exchange.
- Relative conjugation changes the chosen Artin--Schreier representative and is followed by the
  corresponding subfield reparameterization.  It fixes the intrinsic class
  `z^2+z+1` modulo `g^2+g`, so (5) is unchanged.
- Frobenius preserves (1), commutes with absolute trace, and sends any hypothetical solution to a
  solution.  It is a semilinear action, not a projectivity.

Because the solution functor is empty on every odd-degree field, its projective, repair-reversal,
relative-conjugation, and Frobenius orbit sets are all empty.  There is therefore no rational or
Artin--Schreier component to parameterize and no stabilizer class to export.

## Consumer interface

C315 and C316 may use the following closed theorem:

> Over every odd-degree finite extension of `GF(2)`, C297's normalized linear-`p` equations have
> no member satisfying both cross-repair trace-one conditions.  Hence the linear-`p` stratum
> contributes no internally and cross-repair legal two-repair family, no seed-legal component,
> and no collision-incidence base.

This result does not constrain even scalar degrees, the constant-`p` family owned by C315, or a
different repair architecture outside C297's exact linear-p reduction.  It makes no coverage or
`C`-completeness claim.

## Evidence boundary

This is a proof-only theorem.  The load-bearing calculation is the trace identity (4)--(5), and
(9)--(10) is a direct coefficient comparison.  No computational artifact or literature claim is
used.

## Vibe check

Decisive: the apparently new linear-`p` family is not a surviving odd-tower component.  The
obstruction is stronger and cleaner than a seed failure—it occurs already when the two
cross-repair orientations are required simultaneously—so C316 can omit this branch entirely.
