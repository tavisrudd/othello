# C904 primitive-theta Fano/resolution lattice

Date: 2026-08-10
Status: exact negative closure for the saturated divisor lattice and the
theta-resolution lattice; the intrinsic Chow-one-cycle gate remains open
Scope: research note only; no manuscript or Lean edits

## Executive verdict

Three tempting ways to obtain the primitive theta-supported curve fail for
the same exact reason.

1. Passing from the ambient Neron--Severi lattice of `J` to the full
   saturated `NS(F)` and then using every divisor on `F x F` does not create
   an odd addition/difference degree.  The full divisor-generated curve
   lattice still lands in the even coset.
2. Resolving the theta divisor adds one exceptional curve direction, but the
   primitive lift `a` satisfies

   `2a = z + ell`,

   where `z` is the strict transform of a translated Fano incidence curve
   and `ell` is an exceptional line.  This is an integral homology relation,
   not a Chow division by two.
3. The two `D5` axes attached to an involution do not lie in its genus-two
   Jacobian surface.  The genus-two surface is the minus eigenspace of the
   harmonic inversion, whereas both axes are plus eigenlines.

Thus none of the full-`NS(F)`, blow-up-exceptional, or `D5`-axis upgrades
closes the primitive theta-support theorem.  The remaining gate is genuinely
intrinsic: an odd algebraic one-cycle on `Theta` (equivalently on its
resolution), or a new integral-at-two universal-sheaf correspondence.

## 1. Full saturated Fano divisor lattice

Let `a:F -> J` be the Albanese embedding of the Fano surface and let `C_s`
be an incidence divisor.  The classical normalization is

`[F]=Theta^3/3!`, and `a^*Theta=2C_s` numerically.

The restriction lattice from `H^2(J,Z)` has determinant four in its
saturation in `H^2(F,Z)`, hence index two.  The missing class is exactly the
incidence class `C_s=a^*Theta/2`.  On the product, the full divisor lattice is

`NS(F x F) = p_1^*NS(F) + p_2^*NS(F) + Hom(Alb(F),Pic^0(F))`,

with the usual transpose/Rosati condition on the cross term.  In particular,
this includes both half-theta classes and all 25 cross-term directions on the
generic marked `E^5` fibre; it is not merely the restriction of
`NS(J x J)`.

### Parity theorem

For any divisor-generated one-cycle

`Z=L_1 L_2 L_3 in N_1(F x F)`

formed from this full saturated lattice, the difference pushforward obeys

`Theta . delta_* Z = 0 mod 2`, where `delta(x,y)=a(x)-a(y)`.

The clean proof is the Rosati determinant identity.  To a curve/divisor
factor associate its Rosati-symmetric norm operator `A`; its trace has the
principal normalization

`tr(A)=Theta . a_*C = 2(C_s.C)`,

and is therefore even.  Polarizing the normalized determinant

`(Theta+D)^5/5! = det(I+N_D)`

shows that the only genuinely mixed three-operator contribution is

`tr(A)tr(B)tr(C) - tr(A)tr(BC) - tr(B)tr(AC) - tr(C)tr(AB)
 + tr(ABC) + tr(ACB)`.

The first four terms contain an even trace.  For Rosati-symmetric operators,
cyclicity and transpose give `tr(ABC)=tr(ACB)`, so the last two terms occur
twice.  The vertical/horizontal partition has normalization

`int D Theta^4/4 = 6 tr(D)`,

and is even as well.  These partitions exhaust the divisor triples by
multilinearity and the product decomposition of `NS(F x F)`.

This closes the complete-intersection search without a 29,260-triple brute
force census.  It does **not** prove that every intrinsic class in
`CH_1(F x F)` is divisor-generated.  That larger Chow image is a separate
residual gate.

### Relation to Nakaoka--Gugnin

There is no conflict with the exact ambient symmetric-square theorem

`r_j^*q^*H^6(Sym^2 J,Z)/tors = 2 Lambda^6 H^1(J,Z)`.

Nakaoka--Gugnin controls integral classes pulled back from `Sym^2 J`.  The
half-theta incidence divisor is intrinsic to `F`, and a hypothetical odd
theta curve would be intrinsic to `Theta`; neither is the restriction of the
ambient codimension-three lattice.  The new calculation says that even after
adjoining all intrinsic divisors of `F x F`, their triple intersections
still do not reach the odd coset.

## 2. Exact theta-resolution lattice

Let

`pi:M=Bl_0 Theta -> Theta`, `f:M->J`, and `E=pi^{-1}(0)=X`.

Andreotti--Frankel and Lefschetz duality give

`H_2(Theta,Z) -> H_2(J,Z)` an isomorphism.

The blow-up/localization sequence, `H_1(X,Z)=0`, and `H_2(X,Z)=Z[ell]`
give the short exact sequence

`0 -> Z[ell] -> H_2(M,Z) -> H_2(J,Z) -> 0`,

where `ell` is a line in the exceptional cubic and `E.ell=-1`.  Pairing with
`E` gives a canonical integral splitting: for every class downstairs there
is a unique lift orthogonal to `E`.  Let `a` be the lift of
`c=Theta^4/4!` with `E.a=0`.

Choose a first-type line `s` on the cubic.  The translated incidence curve

`C_s-s subset F-F=Theta`

has class `2c`.  The incidence curve is smooth at `s`; therefore its strict
transform `z` meets `E` once.  Consequently

`f_*z=2c`, `E.z=1`, and `z=2a-ell`.

Equivalently,

`2a=z+ell`.

This is the exact integral relation requested by the theta-resolution
attack.  Both terms on the right are algebraic, but no known Chow relation
divides their sum by two.  The obvious algebraic/tautological lattice has
index two in the primitive direction.

## 3. The genus-two `D5` axis does not close the gate

For an involution `g` of `A5`, Roulleau's genus-two curve `D_g` has
`T_0 Jac(D_g)` equal to the two-plane underlying the distinguished line
`L_t`.  In the harmonic-inversion coordinates the action is

`diag(+1,+1,+1,-1,-1)` and `L_t={x_1=x_2=x_3=0}`.

Hence

`T_0 B_g=W_5^-(g)`, of dimension two, for
`B_g=im(Jac(D_g)->J)`.

There are six `D5` normalizers in `A5`; each involution belongs to exactly
two.  The unique axis for either containing `D5` is fixed by that subgroup,
hence fixed by `g`, and lies in the three-dimensional `W_5^+(g)`.  Therefore
neither dual elliptic axis is contained in `B_g`, and their span cannot be
`H_1(B_g)`.  The tempting odd theta-degree-five axis misses the theta
carrier produced by `D_g-D_g`.

This representation-theoretic no-go agrees with the independent character
enumeration for graph curves, whose theta degrees are
`{0,4,6,8,10,12,16}`.

## 4. Moduli/diagonal status

The polynomial `P_v(n)=3n(n+1)^2/2` has value gcd three, but this is not the
full determinant-weight ideal.  The exact weights

`chi(v,O_p)=3` and `chi(v,O_l)=2`

give a weight-one class `O_p-O_l`.  Thus `M` is fine and has a universal
sheaf; there is no residual order-three gerbe.

Uniform higher-Ext vanishing supports the integral top-Chern identity

`[Delta_M]=c_4(-R pi_* RHom(E_1,E_2))`.

However, extracting a codimension-three Chow projector from universal
K-theory still carries the gamma-filtration factor `(3-1)!=2`.  The standard
Markman/Buelles mechanism therefore produces `2a`, fully consistent with
`2a=z+ell`, and not the primitive class `a`.

One bibliographic correction is essential: arXiv:2011.12240 is by Arend
Bayer, Sjoerd Viktor Beentjes, Soheyla Feyzbakhsh, Georg Hein, Diletta
Martinelli, Fatemeh Rezaee, and Benjamin Schmidt.  The contrary attribution
in an earlier version of this note was wrong.

## 5. Exact remaining gates and priority

The following are now excluded:

1. ambient codimension-three classes on `Sym^2 J`;
2. triple intersections from the full saturated `NS(F x F)`;
3. exceptional-curve correction on `Bl_0 Theta` by itself;
4. either of the two `D5` axes through a genus-two involution;
5. standard rational diagonal/GRR extraction.

The residual options, in decreasing expected value, are:

1. compute the mod-two cycle-class image of `CH_1(M)` in the single
   primitive summand and find a genuinely integral universal `c_3` or prove
   it even;
2. compute the image of intrinsic, non-divisor-generated
   `CH_1(F x F)->CH_1(J)`;
3. construct an odd theta-supported signed cycle by a geometric
   correspondence not factoring through the saturated divisor lattice;
4. prove an impossibility/index-two theorem by an unramified or
   decomposition-of-diagonal obstruction.

The minimal unproved bit is now sharply stated: is the integral Hodge class
`a in H_2(M,Z)` algebraic, given the algebraic relation `2a=z+ell`?

## 6. Replay

The finite certificate checks:

- the six-Sylow permutation model of `A5`, two `D5` memberships per
  involution, and the plus/minus eigenspace separation;
- the full mod-two Rosati trace identity;
- the integral rank-two resolution relation.

Run:

```sh
python3 notes/2026-08-10-c904-primitive-theta-resolution-replay.py
diff -u notes/2026-08-10-c904-primitive-theta-resolution-replay.out \
  <(python3 notes/2026-08-10-c904-primitive-theta-resolution-replay.py)
```

The source proof above is independent of the finite replay: the replay does
not stand in for the geometric inputs `a^*Theta=2C_s`, smoothness of the
incidence curve at a first-type diagonal point, or the moduli-space
identification.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-primitive-theta-resolution-replay.py` | 5,508 | `ce396fbe01e0a233f2a346c7b837f907580c44cc7ed7501d305a4292b8f63272` |
| `notes/2026-08-10-c904-primitive-theta-resolution-replay.out` | 101 | `94b136df29a15224bc330c007bc1b3e90b1b366e58f2eeeb5527ad0aba31c4b0` |

## 7. Primary sources

- C. H. Clemens and P. A. Griffiths, *The intermediate Jacobian of the cubic
  threefold*, Ann. of Math. 95 (1972), especially the incidence-divisor and
  diagonal analysis in Sections 2 and 12. DOI `10.2307/1970801`; cached PDF
  SHA-256 `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`.
- X. Roulleau, *Genus 2 curve configurations on Fano surfaces*, Lemma 6,
  Definition 7, Lemma 9, and Theorem 11. arXiv:`1002.4467`; cached PDF
  SHA-256 `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
- A. Bayer, S. V. Beentjes, S. Feyzbakhsh, G. Hein, D. Martinelli,
  F. Rezaee, and B. Schmidt, *The desingularization of the theta divisor of
  a cubic threefold as a moduli space*, Theorem 7.1 and Lemma 7.5.
  arXiv:`2011.12240`; cached PDF SHA-256
  `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a`.
- P. Grieve, normalized reduced-norm/intersection theorem, Theorem 4.1,
  Corollary 4.2, and the non-CM `E^g` determinant specialization in Section
  7.1; exact bibliographic audit is recorded in
  `notes/2026-08-10-c904-annals-literature-red-team.md`.
- Nakaoka--Gugnin integral symmetric-square lattice: exact statement and
  replay are recorded in
  `notes/2026-08-10-c904-symmetric-theta-descent.md`.

## Mystery ledger

- **Settled:** the half-theta saturation of `NS(F)` does not create an odd
  divisor-generated curve after difference pushforward.
- **Settled:** the exceptional divisor supplies the exact correction
  `2a=z+ell`, but no algebraic half.
- **Settled:** the `D5` axes have the wrong involution eigensign to lie in
  `B_g`.
- **Open:** algebraicity of the unique primitive lift `a`; exact evidence
  gap is one bit in the integral cycle-class image of `CH_1(M)`.
- **Open:** whether non-divisor-generated intrinsic curves on `F x F` reach
  the odd coset; this is not decided by the Rosati triple-intersection
  theorem.
