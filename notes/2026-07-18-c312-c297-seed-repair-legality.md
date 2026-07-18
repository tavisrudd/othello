# C312: universal seed--repair determinant and trace reduction

**Lane**: `relconic`

**Status:** queued; first reduction theorem in the post-C297 program.

## Objective

Derive a basis-independent necessary-and-sufficient seed--repair legality test for arbitrary
quadratic repair graphs over `E/F`, then specialize it to C297's full constant-p family as an exact
invariant coefficient system. Solving that system globally belongs to C315 after C314 supplies a
usable moduli atlas.

This is the universal reduction needed by the decisive viability gate. C297 and C304 already prove
internal repair legality and exclude `2+1` cross-repair triples. The missing triples are exactly
those supported on one seed layer and one repair layer.

## Required startup reading

Read, in order:

1. [`2026-07-18-post-c297-theory-program.md`](2026-07-18-post-c297-theory-program.md);
2. C297, sections “Natural marked family,” “Exact cross-repair trace reduction,” and “Exact
   projective and semilinear quotients” in
   [`2026-07-18-c297-c210-normal-form-moduli.md`](2026-07-18-c297-c210-normal-form-moduli.md);
3. C304's constant-p theorem only in
   [`2026-07-18-c304-c210-alternative-towers-functions.md`](2026-07-18-c304-c210-alternative-towers-functions.md);
4. the universal height-interpolation identity cited by the live handoff, loading its exact C210
   source only when the derivation needs it.

Do not preload finite censuses or C210 factorization reports.

## Exact problem

For each `gamma in {alpha,beta}` and `i in {1,2}`, classify both orientations:

- two distinct points of `S_gamma` plus one point of `R_i`;
- two distinct points of `R_i` plus one point of `S_gamma`.

Start from the three-point determinant for `P(x,h)`, not from a specialized C210 resultant. For
each orientation, eliminate the two same-layer parameters by their sum and product. Existence of
two distinct `F`-parameters must be reduced to an exact nonzero/trace condition. State separately
the deleted cases where a point lies on the prescribed conic or two displayed layer points
coincide.

The target theorem should express the obstruction as trace functions of the remaining layer
parameter and classify when those functions are:

- identically legal or illegal;
- constant nontrivial trace classes;
- affine Artin--Schreier functions;
- nonconstant quadratic/rational functions with explicit pole divisors.

Then export the coefficient identities defining the everywhere-legal cases. Do not attempt the
global moduli solve in this task.

## Required theorem package

1. A basis-independent seed--repair determinant lemma valid for an arbitrary quadratic repair
   graph over `E/F`.
2. Necessary-and-sufficient splitting and distinctness criteria for all four seed/repair pairs and
   both orientations.
3. An exact finite equation/inequation system equivalent to simultaneous legality for
   `S_alpha,S_beta,R_1,R_2` on the constant-p family.
4. Proof that the classification is preserved by C297's projective action, repair/seed relabeling,
   and semilinear action, without conflating those quotients.
5. A proof that no orientation, repeated-root case, or denominator divisor is missing from the
   exported system.
6. A clean interface listing the equations, inequations, trace classes, and allowed quotient
   actions consumed by C315.

## Proof strategy

- Normalize only through C297's proved affine conic stabilizer.
- Reduce quadratic splitting over `F` using `Tr(q/p^2)=0` with the `p=0` and repeated-root cases
  separated first.
- Reduce trace functions modulo `g^2+g` before making pole or constancy claims.
- Use coefficient comparison over the function field to derive identities; do not infer an
  identity from samples.
- Where a nonconstant Artin--Schreier curve remains, state its normalization, constant field,
  genus bound, and deleted points. Do not use finite point counts as the classification theorem.

## Non-goals and safety

- No relative-coverage or `C`-completeness claim.
- No coefficient or field census.
- No claim that C210's equal-curvature slice represents the general case.
- No use of a resultant symmetry as projective equivalence.
- Do not edit C297, C304, or the shared handoff while proving the task; export discrepancies in
  this report for the lane integrator.

## First productive session

1. Write the general determinant identity for two constant-height seed points and one arbitrary
   quadratic repair point.
2. Derive the reverse `2 repair + 1 seed` identity independently.
3. Express both as pair-sum/product trace tests and audit every denominator.
4. Only then substitute C297's constant-p coefficient relations.
5. Record the smallest invariant coefficient system whose solutions are the simultaneous
   seed-legal locus, without solving it.

## Exit gate

C312 closes only when simultaneous seed legality is reduced exactly to a complete invariant system
that C315 can solve without rereading scratch algebra. C312 must not claim that the system is empty
or has survivors unless that conclusion follows immediately from the displayed identities; global
component/dimension analysis remains C315-owned.
