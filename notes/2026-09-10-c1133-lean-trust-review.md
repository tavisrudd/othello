# C1133 — bounded Lean coverage and trust review

**Lane:** `cubic-threefolds`

## Outcome and scope

The corrected manuscript was exported first: authority `03279a7e8`, standalone
`b3316b7`, zero export findings, 351 tracked files, byte-identical 32-page PDFs.
The author then requested review of Lean gaps and trust. This is a focused
source/type review plus guarded build-trace and fresh public axiom audit,
not a cold semantic read of all 245 Lean sources or a clean-room rebuild of
Lean and Mathlib. No external-feedback grades are recorded.

No forbidden project axiom, `sorry`, native decision, unsafe declaration,
implemented-by override or kernel-skipping flag was found by the existing
source checker across the package. All 371 public terminals have exactly
their recorded kernel-reported dependencies: subsets of `propext`,
`Classical.choice`, `Quot.sound`. That does not discharge theorem hypotheses.

The main paper has 36 registered claims: 20 absent, 8 fragments, 8 conditional
deductions, and none marked complete. Across all three manuscripts the count
is 79: 25 absent, 27 fragments, 26 conditional deductions, one complete.
Of 371 reviewer terminals, 133 are machinery not assigned to a manuscript
claim. These totals must not be advertised as 371 formalized paper results.

## Findings, ordered by importance

### 1. Geometric comparison assembly is still supplied

Lemma 3.1 (`lem:faithful-center-base-change`) is correctly marked fragment.
The older public terminal
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.faithfulCenterBaseChange_targetOnly_injective`
proves injection from initial-form assumptions. Newer machinery
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.gradedCompletedBulkCenterRingHom_injective`
in `Quantum/GradedBulkSourceRing.lean:78` proves injection of an actual
constructed graded completed ring homomorphism; it requires an injective
integral pairing, a completed numerical quotient, grading data and a nonzero
exceptional parameter. It is not merely a hypothesis that the desired center
map is injective.

Nevertheless, identification with Iritani's actual reduced source, target,
coordinate changes, field embeddings and connection comparison is not
constructed. In particular the proved abstract map is not a proved equality
with the geometric pullback in the manuscript. The change to citing Remark
1.5 improves the written source chain; it does not formalize this bridge.

The lattice side is substantive but remains separate:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.horizontalComparison_preserves_adaptedCanonicalLattice`
in `Quantum/RankTwoCanonicalLattice.lean:141` derives line/lattice preservation
from horizontality of supplied regular matrix series in adapted coordinates.
`Quantum/ExactPrimaryLedger.lean` defines
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RegularRankTwoComparison`
with regular inverse series and horizontal identities as fields.
The geometric comparison and its regular inverse are not constructed there.

**Consequence:** this is the highest-value assembly gap for the requested
specialist review; clean axioms alone cannot certify Lemma 3.1.

### 2. Hodge-fixed-base comparison and realizations remain external

Lemma 7.1 (`lem:hodge-fixed-comparison`) and Theorem B
(`thm:hodge-conservation`) are marked absent. This is conservative and accurate.
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.coordinateEquiv_fixedLoci`
in `Quantum/FixedBaseCoordinateEquivalences.lean:33` restricts a supplied
equivariant equivalence of sets with group actions to their fixed loci.
It does not construct the Hodge group, derive the equivariance of Iritani's
maps, prove the retained divisors' geometric fixedness or instantiate the
completed ring map on that fixed parameter base.

`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.StabilizedWholeOddData`
in `Quantum/StabilizedWholeOddConservation.lean:26` supplies geometric ledger
realizations, weak factorization, and the doubled whole-odd endpoint
isomorphisms. The consequent whole-object cancellation is proved.
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.rationalWholeHodgeIso_of_stabilizedBirationality_varyingRanks`
in `Quantum/RationalHodgeVaryingRank.lean:27` additionally takes the realized
complex comparison and scalar-extension fullness of the rational morphism
space. Its realized-comparison input includes rank equality; the adjacent
`complexLinearComparison_rank_eq` proves equality from a supplied actual
linear equivalence, but the geometric equivalence is not built.

The final descent itself is genuine matrix mathematics:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.matrixMorphismSubspace_contains_invertible`
in `Quantum/InvertibleMorphismDescent.lean` uses the determinant polynomial
over an infinite field. `Quantum/RationalHodgeMatrixDescent.lean` represents
actual pure weight-three decompositions by conjugate complex projectors,
constructs a rational intertwiner and proves its inverse intertwines all
projectors. No integral lattice or polarization is encoded. Fullness for
arbitrary complex Hodge intertwiners is not inferred automatically; it is
explicitly supplied at the realization boundary.

### 3. Numerical normalization differs from the manuscript

`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactPrimaryBlock.weight`
in `Quantum/ExactPrimaryLedger.lean:55` uses `oddRank / 2` in even rank three.
The current manuscript uses full odd rank. Consequently
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.countingExactSignature`
in `Quantum/SeventeenExactSignatures.lean` records 52, 30, 20, 14 rather than
104, 60, 40, 28. The four formal endpoint blocks do carry the correct full
odd ranks, as seen in `Quantum/CountingPrimaryEndpoints.lean`.

This is not a kernel error or a failure of the nine-versus-eight obstruction:
these four positive values select the same endpoints. It is a concrete
correspondence gap. A bridge to full rank must retain the evenness condition;
on an arbitrary natural oddRank, doubling floor(oddRank/2) is not equality.
Prefer aligning the numerical formal selector with the printed full-rank
normalization, or prove an explicit conversion on the geometrically admissible
even-odd-rank domain. Do not silently promote coverage using these unequal
values. The semisimple selector in `Quantum/SemisimplePrimaryLedger.lean`
retains the full odd object and is not halved.

### 4. Endpoint realizations and reconstruction are not formalized geometry

`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CountingStabilizationData`
in `Quantum/CountingStabilizationObstruction.lean:20` explicitly supplies the
low-dimensional realizations, endpoint ledger identification, projective-line
formula and factorization data. Its
`CountingStabilizationData.rational_iff_control` also requires rationality of
the eight control labels. Thus zero invariant is not mistaken for rationality.
The universal-residue proposition remains a fragment: its claim map excludes
the intrinsic generalized-eigenspace/canonical-coordinate-free assembly.

All seventeen Lean six-parameter matrices exactly match the literal Python
inputs, including 119681280 in genus two. Their characteristic polynomials
and cyclic bases are genuine finite kernel checks. The reconstruction
polynomial repaired in this turn is in Python/source evidence; Lean does not
prove its identification with geometric quantum matrices. The earlier wrong
formula therefore did not corrupt these Lean matrices, but an axiom audit
could not have detected that error in the external identification premise.

### 5. Verification prose had stale evidence enumeration

The public verification README still said only two statements carried evidence
and its broad rank-two wording did not distinguish the direct cubic proof
from the later Fano endpoint calculation. It also omitted the reconstruction
replay from its summary of `make check`. These are repaired. The README now
explicitly distinguishes the half/full numerical normalization and external
reconstruction from the formal matrix checks. No Lean theorem or coverage
classification was changed. The manuscript remains unchanged by this review.

### 6. Python O3 mismatch repaired; reader-facing summaries refreshed

A further author-supplied source review identified the same half-dimension
normalization in `finite_checks.py`'s `O3` field. That field is now
`2 * H21[name]` on rank-three-plus-rank-one rows, with explicit expected
values 104, 60, 40, 28 and zero for the remaining families. Restoring the
old assignment in an in-memory mutation fails its new regression assertion.
`finite_checks.json`, the input hash in `reconstruction_check.json`, README,
manifest and SHA256SUMS are regenerated. Reconstruction numbers are unchanged.
The Lean normalization difference in Finding 3 remains, with explicit public
disclosure; no Lean theorem has been edited or silently reinterpreted.

The paper README and portfolio `papers/summary/README.md` now describe the
all-seventeen classification, separate whole-Hodge conservation and C/D
consequences with their quantifiers. Both quote the current manuscript abstract
verbatim after notation conversion (133 whitespace-delimited words).
The cubic headline stays first; the abstract in the manuscript is unchanged.
The portfolio's former unqualified novelty statement is replaced by exact
quotations from the owning claim ledger: prior quantum/Fano work is credited
and whole-Hodge conservation priority comparison remains open. Public
verification prose records absent geometric coverage and the normalization
boundary. No grades or speculative reception claims are included.

## Build, audit and reproducibility

Pinned toolchain: `leanprover/lean4:v4.32.0-rc1`.
Mathlib: `571b8a8e54219b4d393f75f4b8653fac08197fcc`.
The guarded library build reports trace-current and aggregate passed:
`/home/tavis/.cache/othello-lean-build/run-20260911-052712-3b24aaf7`.
The source import census reaches 244 project modules from the library roots;
the remaining module is the separately run public axiom audit. Its project
import closure has 238 modules. Seven library modules outside that audit
closure are listed in the snapshot; none is a missing registered public
terminal. The exact terminal census check passes.

Fresh axiom audit command from the monorepo:

```
lean/scripts/guarded-lean --root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean TavisRuddFiniteGeom/Papers/CubicStabilizationM1/Verification/AxiomAudit.lean
```

It elaborated successfully (rather than merely replaying a saved audit).
Its log is
`/home/tavis/.cache/othello-lean-build/guarded-lean/20260910-222842-cd-lean-exec-taskset-c-20-23-env-LEAN_NUM_THREADS1-choom-n-1000-nix-develop-comma/stdout.log`.
The package's `check_formal_artifact.py --axiom-log` passes against that
transcript, including source bans, exact expected dependencies, claim and
terminal signature digests, registries and dependency graph.

The adjacent `2026-09-10-c1133-lean-trust-review.py` and JSON pin all 245 source
hashes, toolchain, inputs, observed-audit-log hash, closure census, axiom sets,
coverage counts, literal table comparison and the corrected finite O3 values. Replay from the monorepo:

```
python3 notes/2026-09-10-c1133-lean-trust-review.py --axiom-log PATH_TO_FRESH_AUDIT_STDOUT --check
```

The axiom comparison uses the existing package parser; it is not an independent
Lean kernel implementation. The matrix comparison parses literal Lean rows and
Python AST entries with exact Fractions, without executing the SymPy generator.
Semantic findings above are source/type review, not results of that script.
No project Lean source was changed or coverage promoted. The full paper gate
passes after the README and finite O3 correction; the PDF is unchanged.
The snapshot is regenerated with the corrected finite-script and certificate
hashes. All private reports/scripts/certificates remain outside public exports.

## EJ + TT closeout / Mystery ledger

Settled: source transposition was outside the formal theorem dependency chain;
all literal matrix inputs agree. The difference between full and half odd
rank explains the formal/printed endpoint discrepancy; no unexplained numeric
mismatch remains. Cheap improvements applied: external modular regression in
the preceding repair and precise public trust/normalization disclosure here.

Open: actual geometric realizations of the two comparison diagrams and the
rational-Hodge morphism-space realization; these are exposed input boundaries,
not hidden axioms. Highest-value formal follow-up: align the numerical selector,
then assemble the already-proved center-ring and lattice transport into one
explicit comparison interface with every geometric premise listed. This does
not replace a focused mathematical audit of Lemmas 3.1 and 7.1. No full-source
prose audit or blanket referee-readiness verdict is claimed.
