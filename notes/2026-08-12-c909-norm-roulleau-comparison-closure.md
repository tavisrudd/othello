# C909 — closing the norm-axis/Roulleau comparison

Date: 2026-08-12

Status: structural proof closing the primitive relative-isogeny gate; no
manuscript, PDF, mirror, or Lean edit

## The comparison lemma

Let `S` be a smooth Fano surface in the nonstandard `A_5` family, let
`J=Alb(S)`, and let `H~=D_5` be one of the six subgroups.  Put

```text
 n_H=sum_{h in H}h,          E_H=Im(n_H)^0 subset J.
```

Roulleau's theorem gives a fibration

```text
 gamma_H:S --> C_H
```

onto an elliptic curve, with fibre

```text
 F_H=sum_{g in H, g^2=1} D_g.
```

Let `qtilde_H:J-->C_H` be the homomorphism induced by the Albanese universal
property.  Then:

1. `qtilde_H` has connected kernel;
2. `H` acts trivially on `C_H` and `qtilde_H` is `H`-invariant;
3. the Rosati-dual inclusion `qtilde_H^dagger:C_H-->J` has image exactly
   `E_H`; and
4. after identifying `C_H` with `E_H` through that primitive inclusion,
   `qtilde_H` is the Rosati adjoint `q_H=i_H^dagger` of the norm-image
   inclusion and

```text
                  q_H^*[0]|_S=F_H.
```

## Proof

### Connected kernel

The fibration `gamma_H` has connected fibres.  If the induced Albanese
homomorphism factored through a nontrivial isogeny

```text
 J --> C' --> C_H,
```

then `gamma_H` would factor through the corresponding finite cover `C'` of
its base.  Its Stein factorization would then have degree greater than one,
contradicting connected fibres.  Hence `qtilde_H` has connected kernel, and
its dual inclusion is primitive on integral homology.

### Trivial action on the elliptic base

The divisor `F_H` is `H`-stable, so `H` acts on the fibration and fixes the
corresponding point of `C_H`.  After taking that point as origin, the action
is by group automorphisms of the elliptic curve.  Its rational `H^1` is a
two-dimensional rational representation occurring in the restriction of
the `A_5` module

```text
                       W_5 tensor M_Q.
```

The only possible nontrivial rational one-dimensional character of `D_5` is
the reflection sign.  Character averaging gives

```text
 dim(W_5^H)=1,
 multiplicity_H(sign,W_5)=0:

 (5+5*1+4*0)/10=1,
 (5-5*1+4*0)/10=0.
```

Therefore the base cannot carry the sign action; its `H^1` is the trivial
isotypic multiplicity plane.  Thus `H` acts trivially on `C_H`, and
`qtilde_H` is `H`-invariant.

### Equality with the norm image

The dual image of an `H`-invariant elliptic quotient lies in the
one-dimensional `H`-fixed abelian subvariety of `J`.  On rational homology
that subvariety is

```text
                      W_5^H tensor M_Q,
```

which is precisely the image of `n_H`.  Hence the two connected elliptic
subvarieties have the same rational tangent/homology space and are equal:

```text
                   Im(qtilde_H^dagger)=E_H.
```

Both inclusions are primitive: the left one because `qtilde_H` has connected
kernel, the right one because `J/E_H` is an abelian variety.  Therefore their
identification has degree one; no hidden isogeny of elliptic targets remains.
Under this identification `qtilde_H=q_H`, up to an elliptic automorphism,
which does not change the origin divisor.  Pulling `[0]` back to `S` gives
the fibre `F_H`.

## Relative globalization

Over the smooth pencil, the `A_5` action and the integral norms `n_H` are
relative.  Their images have constant relative dimension one, so the
connected images `E_H` are elliptic abelian subschemes.  Conjugation gives
canonical transports because `N_{A_5}(H)=H` and `H` acts trivially on its
norm image.

The comparison above may be checked on one generic fibre.  It determines
the primitive Rosati homomorphisms and their integer pairings.  Relative Hom
schemes for abelian schemes are unramified/discrete, so the identities extend
over the connected smooth base.  Equivalently, the relative `D_g` fixed-locus
curves and their sum give the same fibre divisor wherever smooth, and the
homomorphism identity extends across the remaining smooth cubic fibres.

Thus the primitive inclusions globalize without a period-lattice choice.

## Exact Gram and actual kernel

The six fibre divisors satisfy

```text
 F_H^2=0,       F_H F_H'=24  (H != H').
```

The polarized Riemann--Roch trace identity applied as in the epilogue gives
the diagonal/off-diagonal integers `(d,m)`.  The six axes sum to zero in the
augmentation representation, so `d+5m=0`; the fibre intersection gives
`d^2-m^2=24`.  Positivity yields

```text
                         (d,m)=(5,-1).
```

Choose five axes.  Their sum map is a relative isogeny

```text
 f:E^5 --> J,                 f^*Theta=6I_5-J_5.
```

Consequently

```text
 |ker f|=6^4,        ker f subset E^5[6],
```

and the kernel is a maximal isotropic subgroup of the source polarization
kernel.  This is the actual geometric finite kernel required by the marked
finite-etale graph theorem.

The raw subgroup norm has the exact normalization

```text
 n_H=10P_H=2 i_H q_H,
```

so it constructs the connected image but is not itself the primitive Rosati
endomorphism.

## What remains

This closes the relative isogeny and actual-kernel gate independently of the
explicit Tate/Prym model.  Two narrower statements remain:

1. identify `E_H[2]` with the explicit Tate/Prym two-torsion local system to
   transfer the equation `r^2=T` from the elliptic multiplicity torsor to the
   actual kernel-marking torsor; and
2. construct kernel-linearized relative divisor line bundles if a horizontal
   minimal cycle is desired.

Neither is needed for the fibrewise C909 saturation theorem or the epilogue's
current universal `CH_0` conclusion.

## Source boundary

Roulleau's Theorem 11(D) supplies the connected elliptic fibration and its
fibre divisor; the manuscript's intersection calculation supplies the
`5,-1` normalization.  The connected-kernel Albanese argument and the
norm-image comparison above are elementary deductions that should be printed
rather than attributed to Roulleau.
