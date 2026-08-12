# C909 — Cartan–Hecke packets and finite-etale Lefschetz saturation

Date: 2026-08-12

Status: structural generalization for hostile audit; no manuscript, PDF,
mirror, or Lean edit

## 1. The finite packet theorem

Let `p` be prime.  The natural fractional-linear action of
`PGL_2(F_p)` on `P^1(F_{p^2})` has exactly two orbits:

```text
 P^1(F_p),                         size p+1,
 P^1(F_{p^2}) - P^1(F_p),          size p(p-1).
```

The stabilizer of a rational point is a Borel subgroup.  The stabilizer of
a nonrational point `alpha` is a nonsplit Cartan subgroup: a projective
transformation fixes `alpha` exactly when it also fixes `alpha^p`, hence is
multiplication by an element of `F_{p^2}^*` on the two-dimensional
`F_p`-space, modulo scalars.  Its order is `p+1`, giving orbit size
`p(p-1)`.

Thus a field-restriction graph packet indexed by `P^1(F_{p^2})` has a
canonical **Borel/Cartan decomposition**.  A choice of a rational graph is a
Borel-level marking; a choice of an exotic graph is a nonsplit-Cartan
marking.  Over a base whose projective `p`-torsion monodromy is the full
`PGL_2(F_p)`, the corresponding finite covers are the Borel and nonsplit
Cartan quotient covers of the full projective level-`p` cover.

For `p=2`,

```text
 PGL_2(F_2)=S_3,
 P^1(F_4)=P^1(F_2) disjoint_union {omega,omega^2}.
```

The Borel has order two and produces the degree-three root cover; the
nonsplit Cartan has order three and produces the degree-two sign cover.
Because the nonsplit Cartan is `A_3`, this is exactly the
root/discriminant-resolvent decomposition of an `S_3` cubic extension.

## 2. Modular form of the theorem

Let `Y` be a modular curve carrying an elliptic scheme whose projective
`p`-torsion local system has full monodromy `PGL_2(F_p)`.  Let `Y(p)^proj`
be the projective full-level cover.  Then

```text
 Y_B    = Y(p)^proj/B,
 Y_ns   = Y(p)^proj/C_ns
```

are the rational-slope and exotic-slope graph covers.  Their degrees are
`p+1` and `p(p-1)`.  Their normalized fibre product is the full projective
level cover: for compatible choices, `B intersect C_ns=1` and
`B C_ns=PGL_2(F_p)`.  For linear rather than projective level, the scalar
center remains as stack inertia.

At `p=2` and `Y=X_0(3)`,

```text
 Y_B  = X_0(6),
 Y_ns = X(Gamma_0(3) intersect Gamma_ns(2)),
       Q(Y_ns)=Q(T,sqrt(T)).
```

The signed nonstandard `A_5` cubic parameter `t` trivializes the latter by
`T=81t^2` and `sqrt(T)=9t`.

## 3. Lefschetz saturation on the Cartan branch

Suppose now that the coefficient discriminant module of a polarized
elliptic-power quotient has commutant `F_{p^2}` and its maximal-isotropic
graph kernels are the lines of `P^1(F_{p^2})`.  On the exotic branch the
chosen graph slope is multiplication by

```text
 alpha in F_{p^2} - F_p.
```

Its minimal polynomial is irreducible and hence squarefree.  If the packet is
realized by an exhibited self-adjoint unramified integral lift, its slope
algebra is finite etale.  The finite-etale graph theorem then implies, after
verifying the divisor lattice and every other relevant block, that
the full divided-power envelope of the Neron--Severi lattice equals its
ordinary divisor-product image in every degree.

This gives a general mechanism:

> **Conditional Cartan–Hecke saturation theorem.**  On a nonsplit-Cartan
> branch equipped with self-adjoint unramified integral graph lifts at every
> positive-depth block and the exact saturated divisor lattice, all integral
> divided powers of divisor classes are ordinary integral divisor products.
> The same holds on a rational Borel branch when its scalar blocks meet those
> local hypotheses.

No enumeration of kernels or cofactor determinant is needed once the
Borel/Cartan orbit and finite-etale slope are recognized.

## 4. Reach and limitations

The theorem applies to marked polarized elliptic-power Hecke families in
every dimension in which such a field-restriction coefficient packet is
realized.  It predicts that nonsplit Cartan modular covers are natural places
to seek Lefschetz-saturated ppavs.  Factorial activity and polarized
indecomposability require the separate trace-transfer and idempotent
arguments; Cartan membership alone implies neither.

It does not assert:

1. that every nonsplit Cartan modular curve is realized in a cubic
   intermediate-Jacobian locus;
2. that the underlying ppav is indecomposable without the separate local
   endomorphism/idempotent criterion;
3. full integral Hodge generation;
4. Chow-ring divided powers or relative diagonal decompositions; or
5. a relation to the quantum monodromy packet.

## 5. Why this is a genuine compression

The six-axis proof previously appeared to require a special five-kernel
calculation and a separate squarefree-polynomial check.  The group theory
shows both are forced by one standard modular object: the nonsplit Cartan
orbit.  The exotic quadratic cover, irreducible `F_4` slope, Frobenius
orientation, and finite-etale saturation are four faces of the same
Cartan-level structure.  The `A_5` cubic family is the smallest geometric
realization (`p=2`) of this general mechanism.

## Hostile gates

* For odd `p`, distinguish `GL_2`, `SL_2`, and projective monodromy; scalar
  centers change stack inertia but not the two projective orbits.
* A coefficient commutant `F_{p^2}` and a multiplicity monodromy
  `PGL_2(F_p)` are separate inputs; neither implies the other.
* The graph slope must have an integral unramified self-adjoint lift for the
  polarized coefficient form; an irreducible residue slope alone is not
  enough.
* Calling a cover a classical named Cartan modular curve requires a chosen
  level representation; the orbit theorem alone gives only its finite-cover
  structure.
