# C910 — categorical proof-spine formalization

**Task:** C910 (`cubic-threefolds`) — Lean companion for the epilogue

## Result

The epilogue's main strict one-stabilization argument now has one formal proof
spine. `Quantum/EffectiveBlockLedger.lean` constructs the free effective
commutative monoid of regular-isomorphism classes and its universal additive
fold. `Quantum/OccurrenceIndexedMarker.lean` keeps every blowup contribution as
an actual `Fin (codimension - 1)` occurrence and proves one dimension-
parameterized weak-factorization descent theorem for an arbitrary commutative
additive target monoid.

The two paper arguments are literal specializations of that theorem:

- `Quantum/RankTwoResidueMarker.lean` and
  `Applications/CubicResidueMarkerOneStep.lean` give the direct rank-two
  residue marker and its cubic one-projective-line contradiction;
- `Quantum/FramedSixthMarker.lean` and
  `Applications/CubicFramedMarkerOneStep.lean` give the finer framed
  primitive-sixth marker and its conditional cubic one-projective-line
  contradiction.

The direct and framed block presentations remain genuinely different. They
share the effective-ledger compiler and descent theorem, not a forced
identification of their QDM data. The construction is strictly `m = 1`; no
Gamma-row, `m = 2`, or all-`m` interface was introduced or modified.

## Reviewer-facing boundary

Lean proves the quotient ledger, universal fold, occurrence-indexed blowup
telescope, birational descent, and both final contradiction patterns. The
construction of geometric QDM blocks, regular comparison isomorphisms,
projective-bundle formulas, weak factorization, and low-dimensional geometric
nullity remains visible in theorem types as explicit premises.

The red-team pass repaired the main type-level risks:

- varieties, centers, occurrences, coefficient rings, and marker targets have
  independent universes and types;
- endpoint smoothness and dimension-four witnesses are explicit rather than
  asserted globally for every object in a context;
- projective-line stabilization uses the typed projective-bundle formula;
- the residue presentation works over an arbitrary commutative coefficient
  ring;
- the non-rank-two block constructor carries a proof that its rank is not two;
- occurrence multiplicities are indexed before the fold, so equal weights do
  not collapse distinct exceptional contributions;
- no cancellation, subtraction, group completion, or unstated geometric
  provider enters the generic theorem.

## Verification

All current gates pass:

- guarded aggregate build of `CubicStabilizationEpilogue` and
  `Verification.AxiomAudit`;
- source audit over 167 sources and 308 reviewer terminals;
- axiom-log audit, with the new public terminals using only `propext`,
  `Classical.choice`, and `Quot.sound`;
- claim inventory: 53 claims, comprising 6 absent, 20 fragmentary, 26
  conditional deductions, and 1 complete claim, plus 83 machinery rows;
- deterministic `make check`, including the 50-page manuscript PDF.

## Mystery ledger

- **Settled: whether the two cubic proofs have one formal spine.** Both public
  one-step applications call the same generic occurrence-indexed descent
  theorem through different presentations and folds.
- **Settled: whether multiplicity is lost in the categorical quotient.** The
  effective ledger is a multiset of quotient classes, and every exceptional
  occurrence is present before folding.
- **Settled: whether the new interface overstates QDM formalization.** All
  geometric construction and comparison inputs remain hypotheses; only their
  categorical algebra and deductive consequences are kernel checked.
- **Open: direct construction of the geometric residue and framed providers.**
  This is the next high-value formalization layer, but it is not a gate on the
  soundness of the present conditional interfaces.
- **Open: retirement of legacy compatibility modules.** They still serve
  auxiliary low-dimensional and genus-eight rows and should be removed only
  after a declaration-level reverse-use audit.
