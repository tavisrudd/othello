# C314: invariant moduli atlas for the C297 family

**Lane**: `relconic`

**Status:** queued; parallel-ready structural theorem.

## Objective

Turn C297's exact quotient formulas into a theorem-ready invariant atlas for the constant-p family.
Classify the degeneracy divisors and repair/seed relabeling actions needed by C315/C316. A global
canonical section is not assumed to exist. Full extra-stabilizer classification and intrinsic
recognition of unmarked layers are useful secondary theorems, not gates for the marked-family
geometry.

## Required startup reading

Read:

1. [`2026-07-18-post-c297-theory-program.md`](2026-07-18-post-c297-theory-program.md);
2. “The genuine conic-stabilizer action,” “Exact projective and semilinear quotients,” and “Gauge,
   relabeling, and geometry” in
   [`2026-07-18-c297-c210-normal-form-moduli.md`](2026-07-18-c297-c210-normal-form-moduli.md);
3. C300 only if a claimed exceptional small-field symmetry needs comparison; it is not a startup
   dependency.

## Exact problem

C297 gives ordered projective moduli modulo one additive action and explicit formulas for seed
interchange, repair interchange, and semilinear automorphisms. Re-express the constant-p subfamily
using invariant ratios and trace/norm data that:

- distinguish `c=1` from unequal curvature;
- record the unrestricted `E/F` directions of `K` and `B_1`;
- make conic intersection, layer coincidence, and coefficient degeneration divisors explicit;
- expose the fixed loci of repair and seed interchange;
- identify generic and exceptional stabilizers.

The output must retain enough coordinates to reconstruct the original marked family up to the
proved quotient.

## Required theorem package

1. A finite invariant atlas or exact quotient presentation, with inverse reconstruction on each
   stated open chart and transition data where charts overlap.
2. Dimension and irreducible-component statements for the constant-p moduli and the C210 slice.
3. Equations for all degeneracy divisors relevant to distinctness, conic avoidance, and the
   determinant/height maps used by C312 and C315.
4. If it closes without delaying the atlas, the generic stabilizer and a classification of
   positive-dimensional or finite extra-stabilizer loci.
5. Likewise as a secondary strengthening, an intrinsic-recognition theorem for `q>16`: recover
   the prescribed conic, common tangent, and four layer conics from the unmarked point set, with
   explicit exceptions.
6. A precise comparison of projective versus semilinear orbit spaces.
7. A compact downstream parameter table naming each chart/base, its open subset, exceptional
   divisors, transition rules, and allowed finite quotient actions.

## Proof strategy

- Start from C297 equations (17)--(23); do not rediscover the conic stabilizer.
- Use symmetric functions for unlabelled seed and repair pairs.
- Use trace and norm only where they separate `E/F` directions; record any residual conjugation.
- Prove intrinsic recognition by conic intersection bounds and incidence multiplicities, not by
  automorphism enumeration.
- Treat `q<=16` as an explicit excluded range unless a uniform argument genuinely covers it.

## Non-goals and safety

- No classification of the `PG(2,64)` twelve repairs; C300 already owns that result.
- No assumption that weighted scaling fixes a prescribed seed pair.
- No quotient by a resultant symmetry unless it lifts to C297's geometric action.
- No manuscript rewrite; C299 consumes the final invariant presentation later.

## First productive session

1. Restrict C297's ordered moduli coordinates to equations (10)--(11).
2. Choose scaling-invariant ratios and compute the residual additive action on constants.
3. List every open condition and its complement as an invariant divisor.
4. Compute the repair-reversal action in the new coordinates.
5. Formulate the intrinsic layer-recognition lemma independently of coordinates.

## Exit gate

C314's core gate closes when C315 can solve C312's legality system chart by chart and C316 can
define its universal incidence map without consulting C297's raw coefficient action. Full
extra-stabilizer classification and intrinsic recognition may remain clearly delimited
strengthenings if the marked atlas and its finite relabeling actions are complete.
