# The pair dictionary behind the C475 determinant atlas

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Status:** review and rereading of the committed C475 result
(`2026-07-22-c475-reed-solomon-determinant-atlas.md`).  Every mathematical claim below is either a
symbolic consequence of C475's committed identities or is explicitly flagged as a framing lead.
No new certificate is required and no task is allocated; the C476/C477 consequences are
recommendations to the task owners.  Compact log form:
`2026-07-22-reed-solomon-discovery-track.md`, entries of this date.

## Summary

C475 is exact as stated: the four-cycle ratios generate the full edge-torus quotient, reconstruct
every rank-two syndrome on supports of size at least five, and contract exactly the rank-one
locus, whose missing datum is the radical point.  What the report does not say is that its own
formulas encode a classical dictionary that reorganizes the whole lane:

> **The projective syndrome plane of a conic-supported redundancy-three GRS code is
> `Sym^2(P^1)` — the space of unordered point-pairs of the line — and secant incidence is the
> classical harmonic relation between pairs.**

Under this dictionary the C476 enumeration becomes a marked-configuration orbit problem with two
free coarse invariants, the C477 collision theorem acquires a ready-made discriminant geometry,
and characteristic two contributes one canonical deep hole with a support-only atlas.

## 1. The dictionary

Identify a syndrome `u=(u_0,u_1,u_2)` with the binary quadratic

```text
Q_u(t) = u_0 t^2 - 2 u_1 t + u_2,
```

so that `Q_u(t) = beta_u(v,v)` for `v=(1,t)` in C475's notation (1).  The map `u -> Q_u` is a
linear bijection, and projectively it identifies the syndrome plane with `Sym^2(P^1)`: each
syndrome *is* an unordered pair of points of `P^1` — a rational pair, a Galois-conjugate pair over
`F_q^2`, or a double point.

Recall the classical joint harmonic invariant of two binary quadratics `a t^2 + 2b t + c` and
`a' t^2 + 2b' t + c'`:

```text
H = a c' + a' c - 2 b b',
```

which vanishes exactly when the two root pairs are harmonic (cross-ratio `-1`).  Take the support
pair `{s,t}` with quadratic `(x-s)(x-t)` and the syndrome quadratic `Q_u`.  Then

```text
H({s,t}, roots(Q_u)) = u_2 + u_0 s t - u_1 (s+t),
```

which is *literally the second factor of C475's identity (5)*:

```text
det(u, h(s), h(t)) = (t-s) * (u_0 s t - u_1 (s+t) + u_2).
```

This is an algebraic identity, not an observation about examples.  Consequently:

- **Secant incidence is harmonicity.**  The syndrome `u` lies on the secant through support
  points `s,t` if and only if the pair `roots(Q_u)` is harmonic with the pair `{s,t}`.
- **Deep syndromes are harmonicity avoiders.**  A deep syndrome is an unordered point-pair
  harmonic with no support pair.  C475's edge evaluation `beta_u(v_i,v_j)` is the joint harmonic
  invariant of the pairs `{v_i,v_j}` and `roots(Q_u)`, and the four-cycle atlas consists of its
  balanced ratios.
- **The rank-one stratum is the diagonal.**  `Delta(u)=u_0u_2-u_1^2=0` is exactly the double-root
  condition (odd characteristic), the contracted locus is the diagonal conic of `Sym^2(P^1)`, and
  C475's radical point is the doubled point itself.  The "structural contraction" of the atlas is
  the statement that a double point carries no cross-ratio data of its own.
- **The discriminant class is a free invariant.**  `u -> rho u` scales `Delta` by `rho^2` and a
  conic projectivity scales it by `rho^2 det(M)^4` (C475 (20)), so the square class of `Delta(u)`
  is well defined on projective syndromes and invariant under the full support-stabilizer and
  lift-gauge action.  It is the rational-pair versus conjugate-pair dichotomy — classically, the
  exterior/interior point dichotomy for the conic.

## 2. Consequences for C476

1. **The enumeration is a configuration orbit problem.**  Rank-two deep-syndrome orbits for a
   six-point support are exactly `PGammaL_2(q)` orbits of `(6+2)`-point marked configurations on
   the line: the support six-set plus an unordered (possibly conjugate) pair avoiding harmonicity
   with every support pair.  This replaces "enumerate syndromes and compare atlases" by a
   configuration count with classical structure.
2. **Two free stratifiers.**  Every orbit census should be stratified by `(rank, Delta-class)`
   before anything subtle is computed.  Both are invariant, so **no collision can cross a
   `Delta`-class boundary**; comparisons are needed only within strata.  The export schema of
   C475 §6 should carry the `Delta` square class alongside `rank`.
3. **The rank-one fibre size is known in advance.**  A chord of the conic meets it only at its
   two support points, so all `q-5` off-support conic points are deep and rank one.  The
   radical-orbit computation is the support-stabilizer action on a set of known size `q-5` per
   support.
4. **Characteristic two has a canonical deep hole.**  At `u=(0,1,0)` — the nucleus of the
   standard conic — C475's factors evaluate to `s+t` on affine pairs and `1` against infinity,
   both nonzero on distinct points.  So in characteristic two the nucleus is a deep syndrome of
   *every* conic sub-support; its `beta` is the symplectic bracket and its four-cycle atlas is
   pure cross-ratio data of the support alone.  Prediction for the q=8 row: a distinguished
   singleton orbit with support-only atlas.  The `Delta`-class stratifier degenerates there
   (every element of `F_8` is a square), consistent with the pair dictionary's known
   characteristic-two degeneration.

## 3. Consequences for C477

A collision — two inequivalent syndromes with matching atlases under the allowed actions — is,
in the dictionary, a **cross-ratio resonance**: two marked pairs whose joint harmonic-invariant
ratios against the support sextic agree without the configurations being projectively equivalent.
The natural discriminator candidates therefore come from classical joint covariants of a binary
sextic `f` (the support) and a binary quadratic `Q_u` (the syndrome): the resultant
`Res(f,Q_u)`, apolar covariants/transvectants, and catalecticant-type degenerations.  C477 should
try these before inventing new machinery; they are computable, invariant by construction, and
their vanishing loci are candidate discriminant geometry.

## 4. Framing and the result ceiling

Under the dictionary, the lane's stated ceiling — an all-field redundancy-three orbit
reconstruction with explicit discriminant and classified exceptional fibres — is a finite-field
instance of the classical joint-invariant theory of a binary sextic and a binary quadratic.
That framing cuts both ways:

- it supplies a mature toolbox (transvectants, apolarity) and predicts where exceptional fibres
  live (resonance loci of the joint covariants);
- it raises a **novelty risk**: before any external claim, a claim-specific literature audit must
  cover joint invariants of binary forms over finite fields and their use in MDS-extension or
  deep-hole problems.  Internal use as vocabulary is unrestricted.

There is also a historical footnote worth one line in any eventual paper: the invariant theory in
question is Clebsch-era binary-form theory, so the Reed--Solomon lane and the Clebsch-hexagon
programme share an ancestor at the level of methods, independently of their shared q=11 objects.

## 5. What C475 is not missing

For completeness of the review: the torus-quotient theorem, the integral four-cycle generation,
the rational-point orbit separation, the `n>=5` reconstruction, the characteristic-two and
infinity coverage, and the semilinear descent are complete and were checked against the pair
dictionary without discrepancy.  The dictionary adds interpretation and predictions; it does not
correct anything.

## Provenance

Produced in a user-requested ej review of the lane on 2026-07-22, after C475 closed and before
C476 started.  The load-bearing verification is symbolic: the harmonic-invariant factorization is
an identity against C475's committed equations (5)/(6), double-checked by hand on the pairs
`({0,infinity},{r,-r})` (harmonic) and `({0,infinity},{1,2})` (non-harmonic).  The
characteristic-two nucleus claim is a direct evaluation of the same equations.
