# C909 — the Prym-axis index formula

Date: 2026-08-12

Status: general structural lemma; no manuscript, PDF, mirror, or Lean edit

## The formula

Let `pi:C-->C_0` be a finite map of degree `m` between smooth proper curves
over a connected characteristic-zero base.  Suppose it fits into a map of
etale double covers

```text
 C  --> C_0
 |      |
 v      v
 D  --> D_0
```

and let

```text
 P=Prym(C/D),              P_0=Prym(C_0/D_0).
```

Assume pullback has image an abelian subscheme `A` of `P` of the same
relative dimension `r` as `P_0`.  Let `i:A-->P` be the primitive inclusion,
write

```text
                        pi^*=i phi,
```

and suppose the induced polarization on `A` has scalar exponent `e`:

```text
                         i^dagger i=[e].
```

Then

```text
                  e divides m,
                  phi^dagger phi=[m/e],
                  deg(phi)=(m/e)^r.                         (1)
```

In particular:

* if `e=m`, pullback identifies `P_0` with the primitive axis `A`;
* if `m/e` is odd, pullback induces an isomorphism on two-torsion; and
* any proposed primitive-axis exponent which does not divide `m` is
  impossible for such a quotient-Prym realization.

## Proof

For an etale double cover the ambient Jacobian theta restricts to twice the
principal Prym polarization.  Since the same factor two occurs on source and
target, the Jacobian norm--pullback identity restricts without an extra
factor:

```text
                       (pi^*)^dagger pi^*=[m].               (2)
```

Substitute `pi^*=i phi` and `i^dagger i=[e]` in (2):

```text
             [m]=phi^dagger i^dagger i phi
                =e phi^dagger phi.
```

Thus `phi^dagger phi` is the rational scalar `(m/e) id`.  An integral scalar
endomorphism of an abelian scheme is multiplication by an integer: inspect
its action on any integral first-homology fibre.  Hence `e|m` and the second
formula in (1) follows.  Taking degrees gives

```text
  deg(phi)^2=deg([m/e] on P_0)=(m/e)^(2r),
```

which proves the last formula.  All identities are relative and can be
checked on one geometric fibre because relative Hom schemes are unramified.

## Cubic extremality

For the Van Geemen--Yamauchi degree-five quotient, `m=5`.  The primitive
Roulleau norm axis has `i^dagger i=[5]`, so `e=5`.  Formula (1) forces

```text
                            deg(phi)=1.
```

Thus the explicit elliptic Prym and the primitive `D_5` norm axis are the
same elliptic scheme.  The equality is not an accidental match of
`j`-invariants and does not require a period calculation: it is forced by
the equality between quotient degree and primitive polarization exponent.

## Predictive use

The formula gives a short search principle for new finite-etale
orbit-axis examples.  Start from an odd-order quotient of a double-cover
family and compute only the primitive fixed-axis exponent.  The quotient
Prym can land primitively precisely at the extremal value `e=m`; otherwise
its exact isogeny degree is already determined by (1).  When `m/e` is odd,
its two-division resolvent still transfers unchanged, so a modular graph
marking can be computed on the simpler quotient Prym even without a
degree-one identification.

This is independent of the subsequent divisor-product saturation theorem.
It constructs and measures the primitive axis; finite-etale spectral
separation is the additional condition which turns that axis presentation
into integral divided-power identities.

