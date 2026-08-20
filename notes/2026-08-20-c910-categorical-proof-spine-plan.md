# C910 categorical proof-spine plan

**Lane:** `cubic-threefolds`

**Scope:** `papers/cubic-stabilization-epilogue/lean/`, the corresponding
paper-facing verification apparatus, and C910's planning records.  This plan is
strictly for the epilogue's one-stabilization theorem.  Gamma-row and every
`m >= 2` construction are outside scope.

## Decision

The Lean companion will follow the manuscript's current proof architecture:
one occurrence-indexed categorical marker ledger, one operation-provider
interface, one weak-factorization descent theorem, and two folds.  The
rank-two residue marker and primitive-sixth framed marker will be literal
specializations of that common theorem.  They will not retain separate
top-level birational arguments.

The existing rank-two matrix algebra, cubic block reduction, framed
multiplicity arithmetic, low-dimensional calculations, numerical completion,
and cycle-side formalization remain useful.  The rebase changes their assembly
and public types, not their proved contents.

## Baseline mismatch at plan adoption

The manuscript rebase at `3cf849a8e` changed Sections 4 and 5 and resynchronized
the claim map, but did not change Lean source modules.  Four mismatches remain.

1. `Quantum/OrdinaryAtomLedger.lean` and
   `Applications/CubicAtomOneStep.lean` still make the headline deduction an
   ordinary Hodge-atom theorem.  The epilogue now proves it with a direct QDM
   block marker.
2. `Quantum/PacketInvariant.lean`, `Quantum/WeakFactorization.lean`, and
   `Quantum/BirationalDeduction.lean` hard-code the fold target to `Nat` and the
   descent bound to dimension four.  The manuscript theorem has an arbitrary
   effective commutative target monoid and ambient dimension `d`.
3. The present public interface exposes an atomic headline route and a framed
   packet route separately.  It does not make both applications invoke one
   common marker-ledger theorem.
4. No Lean object currently represents
   `pi_0 Sym^sqcup(Pi_T)`, its universal additive fold, or the actual indexed
   center occurrences.  The claim row for `thm:marker-ledger` therefore records
   only a natural-valued telescope fragment.

Current verified baseline: 53 manuscript claims, 6 absent, 21 fragments, 25
conditional deductions, 1 complete claim, and 311 reviewer terminals, of which
83 are machinery.  No coverage value changes merely because this plan exists.

## Implementation checkpoint: 2026-08-20

The foundation is now present in two guarded, independently building modules.

- `Quantum/EffectiveBlockLedger.lean` defines regular-isomorphism components,
  their effective multiset ledger, invariant-weight descent, and the unique
  additive fold into an arbitrary commutative additive monoid.
- `Quantum/OccurrenceIndexedMarker.lean` separates varieties, smooth centers,
  and actual specialized occurrences; its blowup formula carries a literal
  `Fin (codimension - 1)` occurrence family.  The module proves one-link,
  chain, birational-relation, and quotient-descent forms of the generic
  dimension-`d` marker theorem.

Neither module is yet imported by `PaperInterface`, so this checkpoint changes
no manuscript coverage or reviewer-terminal count.  The next tranche is the
natural-valued compatibility wrapper, followed by the residue specialization.

## Target formal architecture

### 1. Effective block ledger

Add `Quantum/EffectiveBlockLedger.lean` with the following mathematical
objects.

- A block presentation consists of a type of typed blocks and a setoid whose
  equivalence relation means regular isomorphism after the allowed scalar and
  formal-coordinate changes.  Its quotient is the set of connected components
  of the associated thin groupoid.
- The effective ledger is `Multiset` of those components.  This is the free
  commutative additive monoid and retains occurrence multiplicity.
- A marker fold is an additive-monoid homomorphism from the effective ledger to
  an arbitrary `AddCommMonoid A`.  No `AddCommGroup`, subtraction, cancellation,
  or group completion enters any theorem.
- Prove the fold's additivity and the free-monoid extension/uniqueness property.
  These terminals formalize the categorical algebra independently of QDM
  geometry.

Use the quotient-by-setoid presentation rather than importing a heavy category
API merely to reconstruct a thin groupoid.  The module header will state the
exact equivalence with connected components of that groupoid.

### 2. Occurrence-indexed operation providers

Add `Quantum/OccurrenceIndexedMarker.lean` and refactor
`Quantum/WeakFactorization.lean` around an arbitrary target `A`.

- A variety ledger assigns a block multiset and dimension to every object.
- A projective-bundle provider records the rank-`r` ledger decomposition or its
  folded equality.
- A blowup step records its smooth center, codimension, the map from
  `Fin (c - 1)` to actual occurrence objects, and the folded correction of each
  occurrence.  Distinct occurrences may have equal marker values and are never
  identified before the fold.
- A weak-factorization chain uses these typed links.  The descent theorem is
  stated for arbitrary ambient dimension `d`; its center hypothesis uses
  `centerDimension + 2 <= d`, avoiding truncated subtraction in the formal
  type.
- Given a birational setoid, prove the object-set descent map by `Quotient.lift`
  as the formal counterpart of the manuscript's descent square.

The QDM-provider theorem will expose regularity, parity, common generic spine,
bulk-coordinate, and faithful occurrence-specialization data as premises.  It
will prove the fold equalities from supplied block decompositions, but will not
claim to construct Iritani's or Iritani--Koto's comparisons.

### 3. Compatibility layer

Keep `PacketData` temporarily as a natural-valued wrapper around the generic
marker data.  Reprove its existing public arithmetic terminals by specialization
of the generic theorems.  This lets the 311-terminal baseline stay green while
applications migrate.  Remove the wrapper from `PaperInterface` only after no
claim row depends on it.

`OrdinaryAtomLedger`, `ProjectiveLineStabilizationInput`, and the Hodge-specific
headline assembly receive no such permanent compatibility status.  They may
survive during the migration only outside the new public path; the final
epilogue interface must not describe the direct-QDM headline as an imported
Hodge-atom deduction.

### 4. Rank-two residue specialization

Add `Quantum/RankTwoResidueMarker.lean` and
`Applications/CubicResidueMarkerOneStep.lean`.

- Define the block weight to be one exactly for rank two, nonzero square-zero
  leading nilpotent, and nonzero modified-residue discriminant, and zero
  otherwise.
- Descend the weight through regular-isomorphism components using the existing
  rigidity and conjugacy terminals.
- Build the additive `Nat` fold through `EffectiveBlockLedger`.
- Replace the old parity-rank/Hodge-representative interface with the direct
  low-dimensional marker statement used by `prop:atomic-lowdim`: points and
  projective spaces have simple blocks, curves have zero residue discriminant,
  nef-canonical surfaces have no rank-two block, geometrically ruled surfaces
  use the projective-bundle provider, and point blowups use the blowup provider.
- Assemble the cubic values `1`, `2`, and `0` from the existing block reduction,
  projective-line formula, and projective-space spectrum, then invoke the one
  generic descent theorem for the contradiction.

The existing rank-two flat-rigidity, Sylvester, residue-discriminant, and cubic
matrix modules remain unchanged unless their public terminology incorrectly
asserts a Hodge-atom construction.

### 5. Framed specialization

Add `Quantum/FramedSixthMarker.lean` and migrate the Section 5 applications.

- The refined block presentation retains the marked small section and original
  loop framing.
- The component weight is the existing primitive-sixth algebraic multiplicity;
  direct-sum additivity supplies the `Nat` fold.
- Existing framed operation and specialized low-dimensional terminals provide
  the conditional operation/nullity inputs.
- `thm:nu6-birational-invariance` and
  `thm:every-cubic-conditional` invoke the same generic descent theorem used by
  the residue marker.  Their residual hypotheses remain exactly where the
  manuscript puts them.

No theorem identifies the framed block type with the residue-marker block type.
They are different presentations and folds sharing one compiler.

### 6. Applications and verification surface

After both specializations elaborate:

- replace the Hodge-specific headline terminals in `PaperInterface` with
  direct-QDM marker terminals;
- assign the generic fold and descent terminals only to
  `thm:marker-ledger`; application wrappers may depend on them but must not
  duplicate them across claim rows;
- review `prop:qdm-operation-ledgers` against the exact provider type before
  deciding between `fragment` and `conditional_deduction`;
- re-examine `prop:atomic-lowdim`, `thm:every-cubic`,
  `prop:framed-operations`, `thm:nu6-birational-invariance`, and
  `thm:every-cubic-conditional` against their new terminals;
- update `PaperInterface`, `Verification/AxiomAudit`, the claim map, imported
  source registry, dependency graph, statement/terminal digests, coverage
  snapshot, and Lean README in one reviewed tranche;
- remove every public or prose claim that the epilogue's headline follows from
  an ordinary Hodge-atom ledger.  The separately published Hodge-atom companion
  remains a sibling specialization and is not a Lean dependency of this
  package.

### 7. TeX provenance links

The formal-annotation layer is part of the paper/Lean interface and must remain
intact throughout the rebase.  The manuscript loads `formal-annotations.tex`,
whose six machine-readable commands are `\lean`, `\coverage`, `\uses`,
`\imports`, `\evidence`, and `\proves`.  They are intentionally
typographically empty: the checker, rather than the typeset PDF, consumes them.

For every new or renamed theorem-like manuscript statement:

- place `\coverage` immediately after its `\label` and add `\lean` exactly
  when the claim map assigns reviewer terminals;
- record logical and conceptual manuscript dependencies with `\uses` in the
  statement or proof position required by the annotation convention;
- retain `\proves` on detached proof environments, and resolve every
  `\imports` and `\evidence` identifier through the corresponding registries;
- update the annotation and claim-map surfaces together, so neither a stale
  terminal nor a stripped macro can pass the source-only checker.

The categorical rebase does not turn these commands into visible PDF links.
Human-facing links remain in the Lean README and verification report; the TeX
commands remain exact provenance metadata.

## Work order

1. Land the effective-ledger/free-fold module and its focused reviewer
   terminals.
2. Generalize the occurrence-indexed blowup chain and dimension-`d` telescope;
   rederive the current `Nat`, dimension-four terminals as wrappers.
3. Land the direct rank-two residue specialization and migrate
   `thm:every-cubic` plus the unconditional genus-eight transport.
4. Land the framed specialization and migrate the conditional Section 5
   theorem cluster.
5. Delete the obsolete Hodge-specific public route after a declaration-level
   reverse-use audit.
6. Refresh the formal annotations and all generated verification surfaces only
   after the theorem correspondence review; preserve the six TeX provenance
   commands and their exact placement while statements move.
7. Run the guarded aggregate build, source-only checker, axiom-log checker,
   deterministic manuscript gate, exporter audit, standalone sync, standalone
   release gate, and exporter verification.

Each coherent module tranche gets a focused single-file elaboration through
`lean/scripts/guarded-lean`, followed by the smallest owning aggregate target
through `lean/scripts/lean-build-queue.py`.  No direct `lean` or `lake` command
is permitted.

## Acceptance criteria

The categorical rebase is complete when all of the following hold.

1. One generic theorem, polymorphic in the additive target and ambient
   dimension, proves occurrence-indexed weak-factorization descent.
2. The effective ledger is formally a multiset of regular-isomorphism
   components, and its fold uses neither cancellation nor group completion.
3. The residue and framed invariants are definitions or structures
   instantiating that same ledger API, and both main application proofs call
   its generic descent theorem.
4. `thm:every-cubic` has no Hodge-atom premise in its public Lean type or
   docstring.
5. Every actual center correction remains occurrence-indexed until after the
   fold.
6. All retained claim coverage is exact, every removed legacy terminal is
   accounted for, and the axiom audit remains free of project axioms,
   `sorry`, unsafe declarations, and compiled evaluation.
7. The paper and standalone release gates pass with Gamma-row untouched.
8. Every categorical claim's TeX annotations agree exactly with the claim map,
   and the source-only checker rejects missing, stripped, or mismatched
   `\coverage`, `\lean`, `\uses`, `\imports`, `\evidence`, or `\proves`
   metadata.
