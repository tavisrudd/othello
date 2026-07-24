# C542 — Lean closure for projective Reed--Solomon redundancy eight

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete

## Result

`RelativeConicArcs.PRSRedundancyEight` formalizes the redundancy-eight specialization of coherent
polar induction.  Its public boundary contains:

- ordered contraction by three affine or infinite projective markers, with scalar-extension
  compatibility and adjacent-swap invariance;
- a normalized geometric-`S3` identity-twist interface with three distinct markers, genus one,
  branch-and-diagonal deletion degree `12`, marker contribution `3*6`, and total deletion degree
  `30`;
- the exact Hasse--Weil integer threshold: the strict deletion inequality starts at `42` and fails
  at `41`, while a checked prime-power exclusion proves that `43` is the first finite-field order
  used by the theorem;
- the upper transverse/collision budget `4+10=14` and the conditional `q>=43` synthesis theorem;
- exact persistent-family cardinality `q(q+1)^2/2`;
- the seventh-power sigma quotient, tangent cocycle `z -> z+7u`, and the four exact
  `PGL2/PGammaL2` orbit-count pairs `2/2`, `3/3`, `5/5`, and `5/3`; and
- a bounded characteristic-seven carrier structure recording only the proved `q=7` rootless count
  `819` and a rootless shallow witness at `q=49`.

The theorem concludes that a deep syndrome is persistent under the explicit geometric and coding
inputs.  It does not promote rootlessness to deepness over larger characteristic-seven fields.

The import-only terminal is `RelativeConicArcs.Gates.PRSRedundancyEight`; the adjacent
`RelativeConicArcs.Gates.PRSRedundancyEightAxiomAudit` audits the public contraction, arithmetic,
synthesis, cardinality, orbit, cocycle, and carrier-boundary declarations.

## Manuscript reconciliation

The terminal matches `papers/beyond4_prs/sections/07-fixed-level-eight-nine.tex`,
Theorem `thm:r8`:

| Manuscript clause | Lean declaration |
|---|---|
| field order `q>=43` and persistent-only classification | `RelativeConicArcs.PRSRedundancyEight.redundancyEightHighFieldSynthesis` |
| three-marker geometric-`S3` lower package and deletion degree `30` | `ThreeMarkerGeometricS3Slice`, `projectiveSequenceContraction_comm`, the two `threeMarkerContraction_swap_*` theorems, `exact_deletion_and_polar_budgets`, and `threeMarker_genusOne_hasseWeil_bound` |
| exact integer and prime-power threshold arithmetic | `threeMarker_genusOne_hasseWeil_exact_threshold`, `primePowerOrder_at_least_fortyThree`, and `redundancyEightPrimePowerSynthesis` |
| size `q(q+1)^2/2` | `PersistentFamilyData.classified_card` |
| orbit law `T/T^7` modulo inversion and Frobenius | `OrbitArithmetic.seventhPower_sigmaInversionOrbitCount` and `OrbitArithmetic.orbit_count_pairs` |
| tangent split exactly when the scalar seven vanishes | `tangentTranslateSeven_of_cast_eq_zero` and `tangentTranslateSeven_surjective` |

The concrete Hankel-coordinate identification, geometric integrality and lower-cover construction,
contained-component classification, actual projective and semilinear group actions, and external
covering-radius theorem remain explicit structure inputs.  The formal terminal checks their logical
composition and all displayed arithmetic; it does not present those inputs as Lean axioms.

## Validation

Guarded single-file elaboration passed after the closeout refinement.  Serialized run
`run-20260724-073825-cdcce6cc` passed:

- `RelativeConicArcs.PRSRedundancyEight`;
- `RelativeConicArcs.Gates.PRSRedundancyEightAxiomAudit`; and
- the trace-only aggregate gate `RelativeConicArcs.Gates.PRSRedundancyEight`.

The aggregate exact-target `--no-build` check reported all targets current.  The axiom audit reports
only the standard Lean/mathlib dependencies `propext`, `Classical.choice`, and `Quot.sound`; the two
finite orbit-arithmetic terminals are axiom-free.  There is no project-specific axiom, `sorry`,
native evaluator, generated oracle, or external certificate in the imported closure.

Implementation commits: `a368682f`, `67d1e104`.

## Extra-juice and Tao closeout

The numerical stress test separated two cutoffs that prose can easily conflate.  The genus-one
inequality is already true at integer `42` and false at `41`; the coding theorem starts at `43`
because that is the first relevant prime power.  A follow-up terminal now proves the prime-power
jump itself and derives synthesis directly from `IsPrimePow q` and `42<=q`.

The ordered-marker stress test separated labels from algebra.  The geometric cover retains an
ordered root triple, but projective contraction itself commutes for every affine/infinity pair.
The two adjacent-swap theorems therefore generate the full `S3` invariance of the contracted
coefficient sequence without quotienting the ordered cover.

The carrier stress test kept the characteristic-seven statement deliberately asymmetric.  At
`q=7`, rootlessness is exactly the carrier deepness condition and has count `819`; at `q=49`, a
rootless member already has a split squarefree kernel witness.  The formal boundary therefore
records these two facts without manufacturing a larger-field rootlessness criterion.

## Mystery ledger

Settled:

- **Does the exact deletion inequality really begin at the theorem threshold?** It begins one
  integer earlier, at `42`; `43` is the first prime-power field order.  Both assertions and their
  synthesis composition are checked.
- **Does ordered-marker normalization make contraction order-dependent?** No.  Affine and infinite
  projective contractions commute pairwise, and the two checked adjacent swaps generate `S3`.
- **Can the characteristic-seven carrier be promoted by root type?** No.  The `q=49` shallow
  witness blocks that promotion, and the formal interface states no larger-field sufficiency.
- **Are the four orbit cases merely prose?** No.  Their numerical pairs and seventh-power
  inversion counts are kernel checked, while the genuine group-action semantics remain named
  hypotheses.

No genuine task-owned mystery remains.  The concrete geometric, group-action, and covering-radius
inputs are the declared trust boundary for aggregate reconciliation, not hidden formal gaps.

The discovery-log review found one stale collision warning about the `q=49` witness.  Its roots are
disjoint in `F_49`; an append-only correction retires that old lead.  No new incidental lead was
created.
