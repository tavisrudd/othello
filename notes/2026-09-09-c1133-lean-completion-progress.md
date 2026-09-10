# C1133 Lean completion progress

The user requested completion of the core Lean upgrade. C1133 remains active;
this record does not mark L1–L7 complete.

## Rank-three formal persistence

`Quantum/FormalDifferentialSystemVanishing.lean` proves
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.family_eq_zero_of_constantCoeff_eq_zero_of_differential_system`:
a finite homogeneous formal differential system with zero initial values is zero
over any characteristic-zero domain, with an arbitrary type of variables.

`Quantum/CyclicRankThreePersistence.lean` proves
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.centeredCyclicRankThree_flatness_coefficients`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.centeredCyclicRankThree_nilpotent_persists`.
The public terminal in `PaperInterface/Main.lean` is
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.rankThree_cyclicNilpotent_persists_on_formal_germ`.
It derives `b=c=0`, `E³=0`, and `E²≠0` from actual formal matrix identities,
commutation, and zero initial characteristic coefficients. Geometric cluster
construction and passage to a cyclic frame remain explicit external boundaries.

The trace calculation gives `db=-2bv-3cw` and
`dc=-2bu-3cv-2b²w`. These already stabilize `(b,c)`; eliminating `u` using
trace zero is unnecessary for persistence. Thus no division by three and no
coefficient-field hypothesis is required.

Both new leaves passed guarded elaboration and queue builds. The public audit
passed at `run-20260910-023106-06a45c21`, run ID
`20260910-023106-1e7b9569`. The captured axiom audit contains all 326 public
terminals; the added terminal uses only `propext`, `Classical.choice`, and
`Quot.sound`. The annotation checker passed against this log: 67 claims,
90 machinery, 22 source records, five evidence bundles; claim coverage unchanged.

## Command diagnostics

The initial combined guide/map read exceeded the outer display cap; the omitted
guide tail was reread in a bounded command. Later reads were individually bounded.
The first queue submission of the differential-system leaf failed because its
explicit Lake root had not been registered. Registering that already-elaborated
leaf resolved the unknown-target error. One cyclic trace rewrite needed a second
rotation; the corrected module passed without warnings.

## Mystery ledger: bounded ej + tt pass

- Settled: whether rank-three persistence needs division by three. It does not;
  the unreduced trace equations already preserve the characteristic ideal.
- Open: geometric construction of the cyclic frame. The theorem concerns an
  explicitly supplied companion matrix and compressed flatness identities;
  this must not be described as construction of a geometric quantum cluster.
- Core completion gate remains the L1–L7 map; this checkpoint closes only the
  formal rank-three persistence component of L3.

## Complete parameterized formal gauge

`Quantum/TwoByTwoBlockGauge.lean` now constructs the unique normalized gauge
for every formal system with leading blocks `[[0,t],[1,0]]` and
`[[0,1],[0,0]]`, assuming `t=(2a+b)q≠0`. The explicit rational Sylvester inverse
uses no square root. Its exact public terminal is
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.parameterizedRankTwo_normalizedGauge_and_modifiedResidue`
in `PaperInterface/Main.lean`. It constructs the full gauge, identifies its
first coefficient and the second reduced lower-left entry, extracts an actual
rank-two power series, and proves its elementary-modification residue equals
`parameterizedModifiedResidue`, with discriminant `4(b-2a)/(2a+b)`.
The exact source declarations are
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.twoByTwo_exists_normalizedGauge`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.twoByTwo_normalizedGauge_unique`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.parameterizedNormalizedGauge_coefficients`, and
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.parameterizedNormalizedGauge_modifiedResidue`.
The guarded leaf build passed at `run-20260910-023805-7361a5d0` and the
327-terminal public axiom gate at `run-20260910-024310-661790fa`. The added
terminal uses only the three standard axioms. No manuscript coverage promotion.

The same queue compiled `Quantum/FourDimensionalCountingMatrix.lean`, with
exact declarations
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.countingMatrixCyclicBasis_column`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.countingMatrixCyclicBasis_det`, and
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.fourDimensionalCountingMatrix_charpoly`.
The cyclic determinant is one for every six-parameter matrix over a commutative
ring, not just the seventeen rational instances. The table specialization and
lattice module remain separate uncommitted work at this checkpoint.

## Canonical lattice, exhaustive matrix table, primary projectors

The 332-terminal public gate passes at `run-20260910-025531-0f37ed0d`,
run ID `20260910-025532-28858dd4`, with only the standard three axioms on the
five added terminals. Coverage remains 67 manuscript claims, 96 machinery,
22 imported sources and five evidence bundles; no claim promotion.

Exact public declarations in `PaperInterface/Main.lean`, with common prefix
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.`:

- `rankTwo_canonicalLattice_preserved_by_regularComparison` — the actual
  preimage lattice equals the image of an injective modification map and is
  preserved by a regular horizontal comparison. Source:
  `Quantum/RankTwoCanonicalLattice.lean`.
- `rankTwo_canonicalLattice_and_residue_coefficientExtension` — injective
  coefficient extension preserves and reflects membership, and residues and
  discriminants commute with coefficient maps. Same source.
- `seventeenCountingMatrices_charpoly_and_cyclicBasis` — exhaustive matrix
  characteristic polynomials and actual cyclic bases of determinant one over
  the seventeen-constructor domain. Source: `Quantum/SeventeenCountingMatrices.lean`.
- `superPrimary_polynomialProjectors_exist` — actual polynomial idempotents
  are constructed from a coprime annihilating factorization. Source:
  `Quantum/PrimaryPolynomialProjectors.lean`.
- `superPrimary_tracePairing_restricts_nondegenerately` — derives trace-pairing
  nondegeneracy on the full central-idempotent image, from whole-algebra
  nondegeneracy. Same source.

The seventeen-entry proof initially exposed an opaque six-coordinate vector
application. A single reducible evaluator `sixCountingParameters` resolved
that bottleneck; the full table then elaborated in about twelve seconds without
warnings. The exact table inputs remain authored source definitions. No native
execution or external certificate is part of their proofs.

At this checkpoint the uncommitted continuations are
`Quantum/RankThreeCountingSplits.lean`, `Quantum/SuperPrimaryPairing.lean`, and
`Quantum/PrimarySummandDecomposition.lean`. Their claims are not included in the
332-terminal gate. L4–L7 and the remaining L2/L3 assembly are still open.

## Full primary images and the four rank-three splits

The public gate now passes at 337 terminals (101 machinery), with no manuscript
coverage change: `run-20260910-030654-bc3256e0`, run ID
`20260910-030654-c65a7d27`. All five additions have only the standard three
axioms, verified in the captured audit and annotation check.

Exact public declarations in `PaperInterface/Main.lean`, prefix
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.`:

- `superPrimary_oddPairing_nondegenerate_and_even`: whole-algebra trace and
  parity hypotheses imply nondegeneracy of the full odd pairing and even
  odd-dimension. Source: `Quantum/SuperPrimaryPairing.lean`.
- `superPrimary_polynomialProjection_preserves_submodule`: polynomial
  projectors preserve Euler-stable parity submodules. Source:
  `Quantum/PrimarySummandDecomposition.lean`.
- `superPrimary_fullSummandDecomposition`: an actual linear equivalence
  identifies the entire algebra with complementary multiplication images;
  its forward map is proved to be multiplication by the idempotents. Same source.
- `rankThreeCountingMatrices_split_and_formalGauge`: all four genus 2–5
  rational matrices have explicit invertible bases giving the 3+1 block
  form, and systems with these leading blocks have full normalized gauges.
  Source: `Quantum/RankThreeCountingSplits.lean`.
- `superPrimary_evenRankOne_forces_odd_zero`: a genuine central-idempotent
  image with even dimension one has zero odd subspace. Scalar spanning is
  derived from dimension one and restricted pairing nondegeneracy from the
  whole pairing. Source: `Quantum/PrimaryScalarEvenVanishing.lean`.

The four leaf builds passed at `run-20260910-030357-0d03b2ed`. The rank-three
matrix proof uses 64 entry checks and its basis determinant is the nonzero
complementary eigenvalue cubed. Geometric family and Hodge-number identifications
are not inferred. The primary splitting and parity lemmas act on full vector
spaces, never invariant vectors.

Uncommitted continuation at this checkpoint: `Quantum/PrimaryOddAllocation.lean`
and `Quantum/InvertibleComplementGauge.lean`. Neither is included in the
337-terminal gate. The latter extends the rational Sylvester solver to a
complementary companion block of arbitrary trace, needed for the five genus
rank-two cases alongside the four degree cases.

## Current validation window

The next aggregate run is `run-20260910-031640-d57f0a75`. It builds the already
elaborated `Quantum/RankTwoCountingBases.lean` (nine actual rational split bases
and inverses) and `Quantum/InvertibleComplementResidue.lean` (full-gauge residue
extraction), then the public odd-allocation audit. These remain uncommitted
until the scoped queue and correspondence gate pass. The public allocation
source is `Quantum/PrimaryOddAllocation.lean`; its leaf and the generalized
solver `Quantum/InvertibleComplementGauge.lean` already passed the prior queue.
`Quantum/NineRankTwoResidues.lean` is authored but has not yet elaborated; it
is deliberately outside the aggregate import path.

The annotation for `prop:universal-rank-two-residue` is being corrected from
absent to fragment, attaching the two exact public declarations
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.parameterizedRankTwo_finiteReduction`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.parameterizedRankTwo_normalizedGauge_and_modifiedResidue`.
They now serve that claim rather than being classified as unassigned machinery.
The remaining formal limitation is intrinsic zero-primary submodule and
coordinate-free canonical-lattice identification, not construction of varieties:
this manuscript proposition itself concerns explicit matrices. This metadata
change does not alter the proposition or promote it to complete coverage.

## Odd allocation and generalized rational residue bridge

The 338-terminal public audit and annotation gate now pass at
`run-20260910-031640-d57f0a75`, run ID `20260910-031640-2c165182`.
The added public terminal in `PaperInterface/Main.lean` is
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.superPrimary_fullOdd_allocates_to_distinguished_factor`.
Its source, `Quantum/PrimaryOddAllocation.lean`, derives the actual full-odd
submodule equality for any finite central-idempotent decomposition whose other
even images have dimension one. Both the 2+1+1 and 3+1 patterns are covered.
It uses only the three standard axioms.

The general arbitrary-trace Sylvester solver and its full-gauge residue bridge
are also kernel-built, in `Quantum/InvertibleComplementGauge.lean` and
`Quantum/InvertibleComplementResidue.lean`. Exact source declarations:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.invertibleComplement_exists_normalizedGauge`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.invertibleComplementGaugeStep_unique`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.invertibleComplementNormalizedGauge_modifiedResidue`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.invertibleComplement_exists_gauge_with_residue`.
The nine actual basis and inverse identities are built in
`Quantum/RankTwoCountingBases.lean`, principally
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.rankTwoCountingBasis_inverse` and
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.rankTwoCountingBasis_intertwines`.

The universal-residue annotation correction is now checked, including the
regenerated dependency graph. Current counts: 67 manuscript claims,
13 absent / 27 fragment / 26 conditional / 1 complete; 338 public terminals,
100 machinery. The two parameterized terminals now serve the existing claim.
Reproduction of the graph:
`python3 verification/dependency_graph.py verification/dependency-graph.dot`
from the paper directory. The script treats its first argument as an output
path; an initial `--help` probe created a file with that name, which was removed
immediately before the correct explicit-output invocation.

Uncommitted continuations are `Quantum/NineRankTwoResidues.lean` (currently
elaborating the exact finite discriminants) and `Quantum/ExactResidueSelectors.lean`
(not yet elaborated). These are not part of the 338-terminal claim.

## Exact selectors and completed-map continuation

The 342-terminal kernel audit passed at `run-20260910-032858-16f38a04`.
It includes the nine complete residue certificates and actual regular-comparison
invariance, not the older modulo-integer marker. The additional singleton/additive
ledger terminal is being gated with this batch. Pending owned paths are
`Quantum/NineRankTwoResidues.lean`, `Quantum/ExactResidueSelectors.lean`,
`Quantum/ExactPrimaryLedger.lean`, `PaperInterface/Main.lean`,
`Verification/AxiomAudit.lean`, and `lakefile.toml`; registration waits for the
new terminal's actual axiom output. Two independent L4 leaves are under
elaboration: `Quantum/CompletedExponentialPushforward.lean` and
`Quantum/FixedBaseCoordinateEquivalences.lean`. They are not covered by the
342-terminal result. Finite-fiber exponential independence proves joint
injectivity directly on actual completed series; the multivariate geometric
center-map identification is a separate boundary.

The 343-terminal gate and registry comparison passed at
`run-20260910-034014-aaf0bed4`, run ID `20260910-034014-8d3ad87e`.
The five additional public declarations, all in `PaperInterface/Main.lean`, are:
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.nineRankTwoConnections_exactResidue_certificates`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.exactResidueSpectrum_detects_one_and_extends_coefficients`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.exactResidueSpectrum_invariant_under_regularComparison`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.rankThreeOddSelector_invariant_under_fullFiberEquivalence`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.exactPrimaryLedger_fold_from_regularComparisons`.
All use only `propext`, `Classical.choice`, and `Quot.sound`. Counts are
343 public terminals / 105 machinery; manuscript coverage remains
13 absent / 27 fragment / 26 conditional / 1 complete.

The same run kernel-built the two L4 leaves. Exact declarations are
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.completedDirectionalTaggedPushforward_jointly_injective`
in `Quantum/CompletedExponentialPushforward.lean`, and
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.coordinateEquiv_fixedLoci`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.polynomialCoordinateTranslationEquiv`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.polynomialCoefficientExtension_translation_injective`
in `Quantum/FixedBaseCoordinateEquivalences.lean`.
These are exact completed-coefficient and actual coordinate-equivalence results,
not the geometric center maps. The next uncommitted leaf is
`Quantum/MultivariateExponentialCharacters.lean`, currently under elaboration.

Minor invocation corrections: the public interface lives under
`PaperInterface/Main.lean`; the second README is `verification/README.md`
at paper root. A failed README path occurred after registry changes; the
correct file was updated before the green registry gate. Finite-fiber summation
required the explicit `Finset.sum_coe_sort` equality, and the fixed-locus subtype
uses a reducible abbreviation so subtype coercions elaborate.

The multivariate line-restriction proof now kernel-builds in
`Quantum/MultivariateExponentialCharacters.lean`, exact terminal
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.integralLineRestriction_character`.
The first implicit substitution coercion exceeded 200,000 and 800,000
heartbeats; replacing the unfolding with explicit substitution equalities
restored the default heartbeat budget and a three-second build. Its completed
map consumer also kernel-builds in `Quantum/CompletedMultivariatePushforward.lean`:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.completedMultivariateTaggedPushforward_injective`.
Runs: `run-20260910-034508-e3a5d08d` and `run-20260910-034654-884e7b21`.
These modules plus their Lake roots and new public/audit terminals are awaiting
the combined 346-terminal gate. Current map/card/handoff edits refresh the
stale 327-terminal frontier. Independent uncommitted extensions are
`Quantum/MultiplicativeDivisorCharacters.lean` and
`Quantum/CompletedCoefficientExtension.lean`; they have no passing gate yet.

The public 346-terminal gate passed at `run-20260910-034815-2decb595`,
run ID `20260910-034815-18b77272`, and the registry/axiom comparison passes.
New public declarations in `PaperInterface/Main.lean`:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.completedMultivariateExponentialPushforward_injective`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.equivariantCoordinateChange_fixedLoci`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.polynomialCoordinateExtension_and_translation_injective`.
The fixed-locus equivalence uses only `Quot.sound`; the other two use the
three standard axioms. Counts: 346 public terminals / 108 machinery; unchanged
manuscript claim coverage. This closes the actual multivariate completed
coefficient-family injection, without claiming ring compatibility or geometric
base realization. The two multiplicative/ring extension leaves remain
uncommitted and are not included in this checkpoint.

The multiplicative character and completed coefficient-extension leaves passed
`run-20260910-035157-d5b4f420`. Exact declarations:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.integralPairingCharacter`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.integralLineRestriction_multiplicativeCharacter`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.completedCoefficientExtensionRingHom_injective`.
`Quantum/FaithfulCompletedExponentialRingMap.lean` now elaborates the actual
injective unital ring map and its polynomial translation extension; exact
terminal `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.completedExponentialRingHom_polynomialTranslation_injective`.
`Quantum/IndependentOccurrenceSeparation.lean` elaborates the actual nonzero
shifted-operator determinant, exact declaration
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.independentOccurrence_shiftedOperator_det_ne_zero`.
These four leaves and their Lake roots remain uncommitted until their combined
public gate. Two independent L5 leaves, `Quantum/StrictDegreeNilpotence.lean`
and `Quantum/PositiveLineIsotropicVanishing.lean`, are authored but untested.

The 348-terminal gate passed at `run-20260910-035706-1d4c860a`,
run ID `20260910-035706-74af0b00`, followed by the axiom/registry gate.
Added public declarations:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.faithfulCompletedExponentialRingMap_with_polynomialCoordinates`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.independentOccurrenceShifts_separate_finiteOperator`.
Both use only the three standard axioms. Counts: 348 public / 110 machinery;
claim coverage is unchanged. The exact source statements are fully reviewed.
The four L4 leaves, interface/audit, Lake roots and registry are committed at
this checkpoint. The authored localization and three surface leaves remain
outside it: `Quantum/FaithfulLocalizedCoefficientMaps.lean`,
`Quantum/StrictDegreeNilpotence.lean`, `Quantum/PositiveLineIsotropicVanishing.lean`,
and `Quantum/ClassicalCurveExactResidue.lean`.

### Scope correction retained for L4

The proved polynomial extension has a global finite polynomial support.
It is not yet the graded source with unbounded negative-degree bulk powers
across increasing curve degree. Faithfulness of the actual completed
curve-coefficient ring is now proved, but translating the full graded bulk
completion needs an additional coefficient-finiteness/substitution argument.
The geometric QDM base identification and comparison isomorphisms remain
separate imports as required by the implementation map. No claim of complete
L4 coverage follows from the 348-terminal checkpoint.

The localization, degree-raising nilpotence, positive-line isotropic vanishing,
and actual classical-curve loop residue leaves now pass guarded elaboration.
The corresponding Lake roots are added but the combined gate is not yet run.
During the surface assembly, the exact-primary datatype was found not to
represent centered rank-two blocks with zero leading operator (the elliptic
case). `Quantum/ExactPrimaryLedger.lean` now explicitly retains those blocks,
their actual loops and full odd dimensions with zero selector weight, and
requires regular horizontal comparisons plus odd-space equivalence in that
case. This is an eligibility-domain repair, not an assertion that their odd
cohomology vanishes. Its guard and affected public audit must pass before
this change is committed. The four new leaves, this ledger edit and Lake roots
are the owned uncommitted source set.

The five-leaf dependency gate passed at `run-20260910-040536-1aa423ef`:
localization, strict-degree nilpotence, positive-line isotropic vanishing,
classical curve residue, and the scalar-leading eligibility repair to the
exact-primary ledger. `Quantum/NefSurfacePrimarySeed.lean` passed
`run-20260910-040921-4012c425`, with exact declarations
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NefSurfacePrimarySeed.nilpotent`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NefSurfacePrimarySeed.weight_zero`.
The complete `Quantum/LowDimensionalPrimaryExpressions.lean` elaborates:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SurfacePrimaryExpression.weight_zero`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CurvePrimarySeed.weight_zero`.
The new three public terminals are awaiting their 351-terminal audit.
Additional authored, untested leaves are
`Quantum/ExactPrimaryOccurrenceDescent.lean` and `Quantum/SeventeenExactSignatures.lean`.
No actual-variety classification or Hodge-conservation coverage is promoted.

The 351-terminal gate passed at `run-20260910-041430-9da2ee98`, run ID
`20260910-041430-fa535e02`, followed by the axiom/registry comparison.
Public additions in `PaperInterface/Main.lean`:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.faithfulCoefficientMap_on_imageLocalizations`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.nefSurfaceLinearSeed_nilpotence_and_exactSelector_zero`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.lowDimensionalPrimaryExpressions_exactSelector_zero`.
Each uses only the three standard axioms. Counts: 351 public / 113 machinery,
with unchanged manuscript coverage. This includes the scalar-leading
rank-two eligibility repair and the six new localization/surface leaves.
It does not identify those linear/block models with geometric QDMs.

`Quantum/SeventeenExactSignatures.lean` now elaborates its finite nine/eight
label count and doubled nonvanishing; exact declarations
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.countingExactSignature_ne_zero_iff`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.countingExactSignature_label_counts`.
Its four half-odd dimensions and simple-control interpretation are stated
inputs to the finite table, not new geometric proofs. This leaf is not yet
in the public gate. Uncommitted continuations also include
`Quantum/ExactPrimaryOccurrenceDescent.lean` (under elaboration) and
`Quantum/FormalIdempotentConjugacy.lean` (authored, untested).

`Quantum/ExactPrimaryOccurrenceDescent.lean` now elaborates the direct
low-dimensional occurrence-nullity and dimension-three/four birational
invariance deduction. Exact declarations:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.exactPrimary_lowDimensionalOccurrenceNullity`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.exactPrimary_marker_eq_of_birational`.
Inputs identify actual occurrence ledgers with the proved block expressions;
there is no seed-marker-zero field. A local typed component map was required
to expose the domain to multiset rewriting; `Multiset.singleton_add` supplies
the actual cons/add identity. This leaf and `SeventeenExactSignatures.lean`
have Lake roots and await their combined dependency/public gate.

`Quantum/FormalIdempotentConjugacy.lean` proves the one-variable conjugacy
and is being extended to a multivariate formal base. The explicit unit is
`p e + (1-p)(1-e)` with `e` the constant idempotent. It works over a
noncommutative coefficient ring, hence inside an equivariant endomorphism
ring. `Quantum/SemisimpleCoordinateObjects.lean` is authored but untested:
actual finite-support division-ring vector spaces and actual linear
isomorphisms, with doubled cancellation derived coordinatewise. Neither
leaf is part of the 351-terminal public gate.

The occurrence-descent and seventeen-signature leaves kernel-built at
`run-20260910-042217-2e7b3169`, run ID `20260910-042217-f4108d1f`.
Their two public terminals have been added and await the 353-terminal audit.
Uncommitted paths for this checkpoint are those two leaves, their Lake roots,
`PaperInterface/Main.lean`, `Verification/AxiomAudit.lean`, and this report.
The independent formal-idempotent and semisimple-coordinate leaves remain
under elaboration, outside that public gate.

The 353-terminal public gate passed at `run-20260910-042430-af5a3674`,
run ID `20260910-042430-8c146417`, with a matching registry/axiom gate.
Public additions:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.exactPrimaryMarker_birational_from_lowDimensional_realizations`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.seventeenExactSignatures_nine_positive_eight_controls`.
Both use the three standard axioms. Counts: 353 public / 115 machinery;
67 manuscript claims retain coverage 13 absent / 27 fragment /
26 conditional / 1 complete. Exact geometric endpoint/block realizations are
not inferred from the table. The actual all-seventeen geometric rationality
assembly and the full graded-bulk substitution remain open.

The two L6 continuations remain uncommitted: `Quantum/FormalIdempotentConjugacy.lean`
and `Quantum/SemisimpleCoordinateObjects.lean`. The latter retains actual
vector spaces, has componentwise linear maps as categorical morphisms,
constructs isomorphisms from multiplicities, and proves doubled cancellation;
its elaboration and public gate have not yet passed.

The multivariate extension now elaborates in
`Quantum/FormalIdempotentConjugacy.lean`, exact declaration
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.multivariateFormalIdempotent_conjugate_constant`.
The unit inverse coercion and the multivariate constant-series type are
explicit, avoiding ambiguity in the noncommutative coefficient ring.
`Quantum/EquivariantProjectorImages.lean` also elaborates:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.equivariantEndomorphismImage`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.intertwiningLinearEquiv_images`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.intertwiningLinearEquiv_images_equivariant`.
These construct full image subrepresentations and their actual equivariant
linear equivalences. The new Lake roots and three L6 leaves remain uncommitted
until the dependency and public gates; the semisimple-coordinate leaf is
still under elaboration.

The coordinate-object category and multiplicity reconstruction kernel-built at
`run-20260910-043517-2e4b2ab8`. Exact declarations already elaborated include
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimpleCoordinateObject.isoOfDoubleIso`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimpleCoordinateObject.branchSumReindex`,
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimpleCoordinateObject.categoryIso`.
The actual representation-equivalence wrapper now elaborates in
`Quantum/EquivariantProjectorImages.lean` as
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.equivariantImageRepresentationEquiv`.
Additional category-isomorphism cancellation wrappers are under elaboration.

The first semisimple primary ledger elaborated, and now adds parity/dimension
compatibility to derive safe-object nullity from numerical nullity. This
expanded leaf has not yet passed. Newly authored, untested end-of-proof leaves
are `Quantum/InvertibleMorphismDescent.lean` and `Quantum/PureWeightPeriodization.lean`.
The graded completion development is also uncommitted:
`Quantum/GradedBulkCoefficientFiniteness.lean` and
`Quantum/GradedCompletedBulkCenterMap.lean`. The former is under elaboration;
the latter has not been compiled. It derives polynomiality per curve from
actual formal-series grading bounds, rather than imposing global polynomial
bulk support. None of these continuations is covered by the 353-terminal gate.

The coordinate-category doubled-isomorphism wrapper and the bundled full-image
representation equivalence now elaborate. The graded coefficient-finiteness
lemma also elaborates, with no global polynomial-bulk-support hypothesis:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.finite_bulkMonomials_of_lowerGrade_and_unitBound`
and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.gradedBulkCoefficientPolynomial_coeff`.
A lower grading bound and a bounded unit exponent suffice; the upper grading
bound is not needed for this finiteness step. This is a useful hypothesis
weakening found during the planned L4 completion, not a separate discovery task.
The constructed `GradedCompletedBulkSource` retains raw formal bulk series
and only derives polynomial coefficients per curve. Its center-map consumer
and safe-object numerical-nullity bridge await their guards and public gate.
The two end-of-proof leaves also remain untested. No new source has yet been
added to the 353-terminal count.

### Graded bulk faithfulness and full semisimple objects

Guarded queue `run-20260910-045853-989a6cc8` passed the four consumers `SemisimplePrimaryLedger`, `GradedCompletedBulkCenterMap`, `InvertibleMorphismDescent`, and `PureWeightPeriodization`; queue `run-20260910-044915-4fe2c717` passed their new object and coefficient-finiteness dependencies. All module names below have prefix `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum`.

- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.gradedCompletedBulkCenterMap_injective` derives each polynomial bulk coefficient layer from actual graded formal coefficients, allowing negative bulk powers unbounded across curve classes. Ring closure of the raw graded source is not asserted.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimplePrimaryPresentation.fold_zero_of_numericFold_zero` derives vanishing of the whole semisimple odd-object fold from numerical vanishing, parity and faithful realization dimension bounds.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SemisimpleCoordinateObject.cancelDoubleCategoryIso` cancels doubling for actual objects and categorical isomorphisms in the explicit semisimple coordinate category. Geometric Hodge realization remains external.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.matrixMorphismSubspace_contains_invertible` constructs an invertible original-field matrix in the given morphism subspace.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.IntegralTwistAction.pureWeightMultiplicity_injective` recovers fixed-weight multiplicities from the actual integral-twist orbit quotient.
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.multivariateFormalIdempotent_conjugate_constant` and `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.equivariantImageRepresentationEquiv` retain full images and equivariance.

These eight leaves are compiled; their new public reviewer exports and audit rows are not yet added. Public audited count remains 353. `BoundedIsogenyFiniteness.lean` is separately uncommitted while its first elaboration is pending.

Validation invocation correction: the await for queue `run-20260910-050650-38271d48` returned 124 while the subsequent consumer guard had already been placed sequentially in the same tool call. The wrapper must serialize/refuse that invocation; its outcome is not a completed dependency gate. Subsequent consumer elaboration is conditional on the queue terminal success. No direct Lean or process intervention was used.

### Full-object conservation and endpoint assembly

Queues `run-20260910-050319-afa09e2f` and `run-20260910-050650-38271d48` passed four more leaves. Under full prefix `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum`, `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.semisimple_lowDimensionalOccurrenceNullity` derives full-object nullity from actual block realizations; `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.StabilizedWholeOddData.wholeOddIso` assembles dimension-four factorization and endpoint doubled-object identifications into an actual categorical isomorphism. Its `geometricIso_of_veryGeneral_source` keeps the target arbitrary smooth and the source very general. `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.finite_geometricClasses_of_bounded_kernels` proves the finite torsion/kernel/quotient/polarization/reconstruction chain. `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.countingEndpointBlocks_weight` derives every endpoint signature from block expressions; rank-two records carry actual normalized gauge equations, not supplied discriminants. Geometric and source realization inputs remain explicit.

The premature consumer elaboration recorded above failed solely on the not-yet-built `CountingPrimaryEndpoints.olean`; after the queue success it was retried against the now-built dependency. The uncommitted consumer is `CountingStabilizationObstruction.lean`. Public audited coverage still remains 353 pending reviewer export integration.

### Conditional numerical and arithmetic assemblies

Guarded queue `run-20260910-051028-f35b3b35` passed `CountingStabilizationObstruction` and `ArithmeticStabilizationPartners`. Fully qualified terminals: `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CountingStabilizationData.rational_iff_control` derives the nine/eight dichotomy from actual normalized endpoint blocks, projective-line ledger doubling, point/curve/surface realizations and weak factorization; rationality of controls remains supplied. `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.finite_arithmetic_stabilizationPartners` composes whole-odd conservation with separately supplied cohomology-to-geometric-isogeny and uniform bounded-kernel inputs, finite torsion, polarization fibers and geometric Torelli. It unions models over every extension with degree at most the prescribed bound and counts geometric classes only.

`RealizedHodgeConservation.lean` is separately being elaborated to expose an actual target-category isomorphism via a supplied semisimple realization equivalence and endpoint identifications. None of these deductions certifies the external geometric or literature inputs.

### Public checkpoint: 365 terminals

The twelve new explicit reviewer wrappers and their imported closures pass
queue `run-20260910-051429-6635c703` (run id
`20260910-051429-5ef99b0d`). The package checker against the actual saved audit
log passes: **239 sources, 365 terminals, 127 machinery**, 67 manuscript claims,
22 source imports and 5 evidence records. Coverage remains 13 absent,
27 fragment, 26 conditional deductions and 1 complete. Each new terminal uses
only `propext`, `Classical.choice`, and `Quot.sound`; no project axiom, `sorry`,
or native evaluation axiom enters this checkpoint.

All names below have the exact prefix
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.` and are in
`PaperInterface/Main.lean`:

- `formalIdempotent_conjugacy_over_multivariateBase`
- `fullEquivariantProjectorImages_representationEquiv`
- `semisimpleObjects_cancel_doubled_iso`
- `gradedBulkCenterMap_injective`
- `wholeOddLedger_zero_of_numericZero`
- `rationalMorphismSpace_contains_invertible`
- `pureWeightPeriodization_injective`
- `wholeOddObjects_conserved_under_stabilizedBirationality`
- `veryGeneralSource_stabilizedCancellation`
- `arithmeticStabilizationPartners_finite_geometricClasses`
- `seventeenFamilies_rational_iff_control`
- `realizedHodgeObjects_conserved_under_stabilizedBirationality`

The last terminal constructs an actual target-category endpoint isomorphism
using the supplied category equivalence and endpoint identifications. The
category and its geometric interpretation are not created by naming it Hodge.
The rationality terminal derives the detected obstruction from actual gauge
and block realizations; it does not assume the nine irrationality conclusions.
The source-only checker initially stopped on the twelve deliberately missing
axiom expectations; those were entered only after reading the actual audit,
and the complete comparison now passes.

### Mystery ledger — explicit ej + tt pass after the aggregate gate

- **Settled:** negative bulk exponents need no global bound across curve
  classes. A lower cohomological bound and a unit-exponent bound imply finite
  monomial support separately at each curve class. The upper grading bound
  is not needed for that injection argument. Exact evidence:
  `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.gradedBulkPowerSeries_finite_support`.
- **Settled:** formal projector conjugacy needs neither semisimplicity nor
  a commutative endomorphism ring. The explicit intertwiner has constant
  coefficient one and is therefore a formal unit. Exact evidence:
  `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.formalIdempotent_conjugacy_over_multivariateBase`.
- **Settled:** doubled cancellation must retain simple multiplicities, not
  just total dimension. The terminal
  `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.semisimpleObjects_cancel_doubled_iso`
  constructs the actual categorical inverse data.
- **Settled direction only:** numerical zero forces safe-object zero, but
  no converse is claimed: a nonzero rank-two numerical atom need not imply
  a nonzero odd object without an endpoint realization. Exact evidence:
  `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.wholeOddLedger_zero_of_numericZero`.
- **Explicit formal boundary:** ring closure of the raw graded-family source
  and a fully intrinsic universal residue identification are not asserted by
  the current terminals. The existing completed ambient ring maps and adapted
  matrix residue calculations are proved. These are proof-strength boundaries,
  not missing axioms disguised as conclusions.
- **External gates:** geometric QDM and Hodge realizations, the precisely
  scoped reconstruction/arithmetic imports, and full novelty/citation closure
  remain owned by C1133. Optional rank-three residue and uniform odd-cubic
  refinements remain L8. No additional unexplained numerical phenomenon was
  found in this closeout pass.

### Graded-ring closure strengthening

The raw-source ring boundary at the 365-terminal checkpoint is now closed by
`Quantum/GradedBulkSubring.lean` and `Quantum/GradedBulkSourceRing.lean`.
Exact declarations are
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.gradedCompletedBulkSource_equivSubring`
and
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.gradedCompletedBulkCenterRingHom_injective`.
Convolution adds the cohomological intervals and unit bounds; every nonzero
coefficient has actual curve and polynomial-monomial witnesses. The subring
is coefficientwise equivalent to the original formal-family source, with no
additional support hypothesis, and its actual unital ring map agrees with the
previous center map. Guarded queues `run-20260910-052329-da06ad4a` and
`run-20260910-052436-e77a540b` pass. Public reviewer export integration follows.

### Whole-object rational descent strengthening

The closeout review separated two valid but different interfaces: transport
through a supplied category equivalence, and descent of one whole complex
comparison to a rational Hodge isomorphism. The second does not require an
equivalence of an entire complex representation category with a rational Hodge
category, or rational descent of separately labelled scalar branches.

`Quantum/RationalHodgeMatrixDescent.lean` constructs effective pure weight-three
rational Hodge objects in chosen rational bases, with four orthogonal complex
projectors summing to one and conjugation exchanging p with 3-p. Rational
intertwining matrices form an actual rational submodule. The exact terminal
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.rationalHodgeMatrixIso_of_extendedCombination`
uses determinant-polynomial descent to construct a rational unit matrix;
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RationalWeightThreeHodgeMatrixIso.symm`
proves that its rational inverse intertwines all projectors. Queue
`run-20260910-053019-21561a99` passes.

`Quantum/RationalWholeHodgeConservation.lean` supplies
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.rationalWholeHodgeIso_of_stabilizedBirationality`.
Only the whole conserved comparison is realized over the complex numbers and
placed in the scalar extension of the actual rational Hodge-morphism space.
The rational isomorphism is derived, not supplied. Its single-file elaboration
passes; the dependency build is `run-20260910-053251-41e1ff7b`.
`Quantum/RationalHodgeApplications.lean` is uncommitted while assembling the
source-restricted reconstruction and arithmetic applications with this actual
rational Hodge premise. Source geometric identification and equivariant Hom
scalar-extension fullness remain explicit; arbitrary complex Hodge maps are
not assumed to descend.

The whole rational Hodge applications pass queue
`run-20260910-053511-f808dd94`. Exact declarations in
`Quantum/RationalHodgeApplications.lean` have prefix
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RationalHodgeEndpointRealization.`:
`conservedIso`, `genericCancellation`, and `finiteArithmeticPartners`.
The Torelli and isogeny premises now receive actual rational Hodge matrix
isomorphisms. The fixed-rank family model suffices for each cubic or quartic
application. A separately uncommitted `RationalHodgeVaryingRank.lean` exposes
the pairwise conservation conclusion with independently specified endpoint
ranks, obtaining their equality from the whole complex comparison rather
than prescribing one rank to all nine Fano families.
