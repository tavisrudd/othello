# C315: solve seed legality on the C297 constant-p moduli

**Lane**: `relconic`

**Status:** gated by C312 and C314.

## Objective

Solve C312's exact seed--repair equation/inequation system on C314's invariant moduli atlas.
Classify the simultaneous seed-legal locus of C297's constant-p trace-compatible family as empty,
positive-dimensional, or an explicit union of exceptional strata. Export actual survivor schemes,
not sampled coefficients, to C316.

## Required startup reading

Read, in order:

1. [`2026-07-18-post-c297-theory-program.md`](2026-07-18-post-c297-theory-program.md);
2. the completed C312 determinant/trace reduction and its exported system;
3. the completed C314 invariant atlas and degeneracy table;
4. C297's constant-p family statement only as a convention check.

Do not redo C312's determinant derivation or C314's quotient calculation.

## Exact problem

On every C314 chart, pull back C312's equations, inequations, and trace classes. Separate:

- coefficient identities that hold over the function field;
- proper algebraic divisors;
- Artin--Schreier trace conditions that vary with a layer parameter;
- open distinctness/conic-avoidance conditions;
- repair- or seed-relabelled copies of the same geometric stratum.

Determine simultaneous legality for all four seed/repair pairs and both orientations. A stratum is
not a survivor until every C312 condition and every C314 open condition is checked.

## Required theorem package

1. A component-by-component solution of C312's legality system on the invariant atlas.
2. Dimension and codimension of every survivor or obstruction component.
3. Proof that chart overlaps and finite relabeling/semilinear actions do not duplicate or omit
   components.
4. Explicit equations and open conditions for each actual seed-legal survivor scheme.
5. If the locus is empty, a uniform obstruction theorem naming the minimal incompatible trace
   conditions.
6. A table separating internal repair legality, cross-repair legality, seed legality, point
   distinctness, and conic avoidance.
7. A compact C316 interface: invariant chart, survivor equations, universal parameters, and every
   deleted divisor.

## Proof strategy

- Solve identities over chart function fields before specializing parameters.
- Reduce trace functions modulo `g^2+g` and classify their pole divisors.
- Use algebraic independence/dimension arguments to eliminate impossible identities.
- Use Artin--Schreier curve theory only after the coefficient strata are exact.
- Prove overlap consistency from C314 transition maps rather than comparing sample points.

## Non-goals and safety

- No collision, height-image, relative-coverage, or completeness claim.
- No coefficient or finite-field census.
- No unchecked primary decomposition over characteristic two.
- No global “generic survivor” statement while exceptional charts remain unresolved.
- If the complete solve proves too large, stop at a rigorously named unresolved component rather
  than moving it silently into C316.

## First productive session

1. Build a matrix with rows equal to C314 charts/strata and columns equal to C312 orientations.
2. Mark immediate identity contradictions and open-condition failures.
3. Reduce the remaining trace functions to canonical Artin--Schreier representatives.
4. Solve the generic chart before exceptional divisors.
5. Write the C316 survivor interface as soon as one component is completely closed.

## Exit gate

C315 closes only when every C314 chart has an exact legality verdict and C316 can construct its
universal incidence object over a committed survivor base. If the base is empty, state that
vacuously and export the obstruction theorem to C317.
