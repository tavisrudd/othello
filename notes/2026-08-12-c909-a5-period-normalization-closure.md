# C909 — corrected modular normalization of the `A_5` period curve

Date: 2026-08-12

Status: corrected after hostile audit; no manuscript edit

## Theorem-grade part

Let `t` be the signed parameter of the nonstandard `A_5` cubic pencil and
put `s=t^2`, `T=81s`.  The exact elliptic multiplicity factor has

```text
 j(E_T)=(T+27)(T+3)^3/T,
```

the standard `X_0(3)` Hauptmodul map.  The generic projective automorphism
group is `A_5`; irreducibility makes its projective centralizer trivial, and
the normalizer quotient is the outer `C_2` acting by `t |-> -t`.  Hence the
`s`-line is generically injective in cubic moduli.  Strong Torelli then makes
the smooth normal curve

```text
 U_cub = X_0(3) - {0,infinity,-27,729/5}
```

the normalization of its reduced intermediate-Jacobian period image (after
the usual finite shrink needed for finiteness onto the image).  The last two
removed values are interior modular points, not cusps.

The discriminant/sign cover of the universal two-division local system is

```text
                         r^2=T.
```

Pulling back by `T=81t^2` gives `r=+/-9t`.  Thus the signed cubic parameter
is exactly the pullback and trivialization of the **elliptic
multiplicity-system** exotic marking torsor.  This is stronger than an
analogy of double covers.

## Exact open integral gate

To identify the whole principally polarized cubic family with one fixed
finite-etale graph-presentation stack requires a homomorphism of abelian
schemes

```text
                    f:E^5 --> J
```

whose pulled polarization is `6I-J` and whose finite kernel in `E^5[6]` is
the specified self-dual graph at two and three.  Fibrewise elliptic
quotients, rational isotypy, Gram/Smith data, and the finite sub-local-system
do not construct this integral map or select its actual kernel.  A full
level cover can trivialize torsion after the subgroup exists; it cannot
create `f` or its primitive lattice.

The first missing lemma is an integral polarized comparison of the relative
`H^3` lattice with the elliptic rank-two multiplicity system.  Once it
produces `f`, the finite sub-local-system and `r=9t` identity can select and
globalize the exotic kernel.  No compactified boundary statement is needed.

Accordingly, the proved conclusion is:

> The normalized cubic period curve has the `X_0(3)` parameter, and its
> signed coordinate is the elliptic discriminant resolvent.  Its lift to a
> fixed graph-presentation component is conditional on the integral
> polarized relative isogeny and kernel.

The degree-three companion is the `X_0(6)` root resolvent.  Identifying it
with the quartic intermediate-Jacobian family remains behind its separate
integral lattice theorem.

## Relative-cycle consequence, conditional

If the integral relative isogeny/kernel is constructed and the finite list
of rank-one coefficient Neron--Severi sections is represented by
kernel-linearized rigidified relative line bundles, their fixed integral
product identity gives one horizontal cycle whose fibre class is
`Theta^k/k!`.  This does not give unmarked descent, a relative diagonal, or
a Chow divided-power identity.

The line-bundle clause is substantive: the inverse image of a relative
Neron--Severi section in `Pic(A/S)` is a torsor under `A^vee`, and need not
split after finite etale base change.  Theta-group ambiguity controls
linearization only after a lift exists.

## Remaining gates

1. Cite the generic automorphism/normalizer calculation used above.
2. Construct the relative integral polarized isogeny `f:E^5-->J`.
3. Identify its actual finite kernel with the exotic/scalar graph subgroup.
4. Construct the required kernel-linearized relative line bundles before
   asserting a horizontal cycle.
5. Do not infer compactified period equality or transfer the statement to
   the classical quartic branch.
