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
