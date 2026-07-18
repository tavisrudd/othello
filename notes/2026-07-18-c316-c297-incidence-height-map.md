# C316: universal collision incidence and height-map audit

**Lane**: `relconic`

**Status:** ready; C313's linear base is empty and C315 exports the exact constant-height `E4`
survivor. Do not assume C305's two-height model generalizes.

## Objective

Over the exact constant-p seed-legal survivor scheme exported by C315 and every linear-p survivor
exported by C313, construct the universal genuine-collision incidence varieties. For each family,
determine whether its constant parameters form the same two-dimensional affine height bundle seen
in C305, a different-dimensional bundle, or no lossless height-map presentation at all. Only after
that audit, determine dominance, generic degree, and the exceptional-divisor skeleton needed by
C317.

If both C313 and C315 prove their survivor schemes empty, close C316 as a vacuous gate with the
exact reasons; do not invent a substitute finite census.

## Required startup reading

Read, in order:

1. [`2026-07-18-post-c297-theory-program.md`](2026-07-18-post-c297-theory-program.md);
2. C315's completed constant-p survivor interface;
3. C313's completed linear-p classification and seed-legality interface;
4. C314's invariant atlas and transition rules for the constant-p family;
5. the height-plane reduction in
   [`2026-07-18-c305-c210-q512-generic-closure.md`](2026-07-18-c305-c210-q512-generic-closure.md);
6. C297's coefficient reconstruction for both omitted strata.

C305 is a model and consistency check, not a theorem about the larger family.

## Exact audit

For each survivor family, write the collision equations before eliminating any repair constants.
Determine:

- the number and field of definition of independent constant/height parameters;
- the exact coefficient matrix for those parameters;
- its determinant or rank-drop ideal;
- the genuine open domain after removing repeated points, conic points, merged cosets, and all
  reconstruction denominators;
- whether solving for constants is lossless and equivariant under C314's transition maps.

Only if the audit produces a lossless target bundle `H -> M_surv` should the task define

    Phi: genuine collision triples -> H.

The rank-drop locus is an exceptional divisor to classify, not a denominator to discard silently.

## Required theorem package

1. Universal collision equations over every C313/C315 survivor component.
2. The exact constant-parameter bundle and coefficient-matrix rank theorem.
3. A lossless reconstruction theorem on a precisely stated open set, or a bounded negative saying
   why no such presentation exists.
4. Dimension of the domain, target, and generic fiber on every component.
5. Dominance or non-dominance of `Phi` when it exists.
6. Generic degree and branch/rank-drop divisor when meaningful.
7. A complete list of parameter divisors requiring separate fiber analysis.
8. A C317 interface containing equations, dimensions, degrees, deleted divisors, and fields of
   definition—but not yet claiming generic fiber irreducibility or genus.

## Proof strategy

- Work over each survivor component's function field.
- Establish matrix rank and losslessness before taking resultants.
- Use differentials or function-field transcendence degree for dominance.
- Verify transition compatibility chart by chart.
- Keep geometric equivalence separate from equation gauge throughout.

## Non-goals and safety

- No assumption that the target is `A^2_(h0,h1)`.
- No generic irreducibility, genus, Hasse--Weil threshold, or asymptotic obstruction claim; C317
  owns those theorems.
- No `q=512` sweep, coefficient census, or large certificate.
- Collision roots are not genuine until reconstruction and all distinctness checks are proved.

## First productive session

1. Count independent constant parameters in C297's reconstructed family.
2. Derive their coefficient matrix directly from height interpolation.
3. Compute the generic rank symbolically and name the rank-drop ideal.
4. Define the genuine open domain before eliminating variables.
5. Compare the restriction to C210's slice with C305's `2x2` matrix as a consistency check.

## Exit gate

C316 closes with lossless universal incidence/target presentations for every constant-p and
linear-p survivor family, plus a complete exceptional-divisor skeleton that C317 can analyze
geometrically. It must not bundle unproved fiber geometry under a “generic map” label.
