# C942 -- linked lightweight referee guide for the one-stabilization paper

**Lane:** cubic-threefolds

**Status:** complete 2026-08-22; independently cold-read, release-checked, and
exported to the standalone mirror

## Goal

Add `papers/cubic-stabilization-m1/REVIEWER_GUIDE.md` and link it prominently
from `papers/cubic-stabilization-m1/README.md`.  Model the guide on the compact
`For referees` and `Proof and evidence boundary` sections of
`papers/complete-repair-ports/README.md`.  It should let a referee see the
unconditional theorem, follow the central proof in five or six steps, inspect
the exact human/formal/imported boundary, and find the existing verification
entry point without navigating the repository unaided.

The intended impression must be earned, not announced.  Do not describe the
work as credible, careful, rigorous, comprehensive, or thoroughly reviewed.
Demonstrate those qualities through exact theorem references, explicit logical
boundaries, authoritative artifacts, reproducible checks, and independent
review records.

## Dependency and scope

- Final wording waits for C940 to freeze the short primary paper's theorem,
  label, and provenance inventory.
- The required route covers only the unconditional primary `m=1` paper.  The
  six-axis and framed-monodromy companions are optional and the conditional
  all-`m` manuscript is outside scope.
- The standalone guide is a navigation surface, not a second claim ledger, a
  copied terminal census, or a long command manual.  Authoritative detail stays
  in the manuscript and verification registries.
- Do not change a theorem, hypothesis, claim-map classification, validation
  gate, or Lean source under C942.  Report any such defect to its owning task.
- Before writing Lean-facing replay language or synchronizing a standalone
  mirror, read and follow `lean/AGENTS.md` and
  `notes/export-and-mirror-conventions.md`, respectively.

## Deliverable

Add one prominent README link and one compact Markdown guide with at most three
pieces:

1. **Suggested reading:** identify the introduction, the one-blowup model, the
   main QDM-marker section, and which consequences may be skipped on a first
   pass.
2. **For referees:** five or six numbered proof steps keyed to stable semantic
   labels rather than rendered theorem or page numbers.  The route should cover
   the generic marker ledger, QDM operation providers, rank-two formal-exponent
   marker, cubic detection, low-dimensional center nullity, projective endpoint,
   and the weak-factorization contradiction, combining adjacent steps where the
   final short manuscript naturally does so.
3. **Proof and evidence boundary:** one short section distinguishing the full
   written proof, cited geometric/QDM inputs, partial Lean deductions exposed
   through `PaperInterface.Main`, computational evidence, and deliberately
   unformalized geometric providers.  Point to the authoritative verification
   directory and existing `make check` entry; do not reproduce volatile counts,
   hashes, or guarded commands already maintained there.

The README addition should be only a clear one-line invitation to the guide.
The guide should stay close to the complete-ports precedent: roughly 500--800
source words, unless the final split requires one extra short paragraph to
state a load-bearing boundary honestly.

## Review protocol

Treat the README change as paper-facing prose, not routine documentation.

1. Freeze the candidate and preserve a dated review copy or exact commit.
2. Obtain mutually isolated cold reads from:
   - a primary-audience mathematical referee following only the numbered
     proof route; and
   - a formal/reproducibility referee checking only the boundary and replay
     pointers.
3. Run a separate hostile audit for theorem scope, conditionality, semantic
   labels, source provenance, formal-coverage overstatement, dead links, and
   claims stronger than `make check` establishes.
4. Record verdict, confidence, required and optional findings, strongest
   passage, and first point of friction in dated lane-owned reports.
5. Repair every adopted finding, then rerun fresh isolated readers who have not
   seen the first reports.  The authoring pass does not count as a cold read.
6. Compare the frozen and repaired versions, run the existing paper checks,
   verify every link from a clean checkout, and record a final synthesis and
   finding disposition.

## Editorial test

Every sentence must do at least one of four jobs: locate a mathematical claim,
explain a proof dependency, delimit the trust boundary, or enable a check.  Cut
general assurances, review-process advertising, exhaustive inventory prose,
and implementation detail that does not help a referee assess the theorem.
Let stable labels, exact qualifications, passing gates, and accessible evidence
carry the signal.

## Acceptance gate

- The README exposes the guide prominently, and the linked guide gives a
  correct short route through the primary theorem and its causal proof
  mechanism.
- The route uses five or six stable semantic-label steps and the guide does not
  become a second verification manual.
- The unconditional primary theorem is unmistakably separate from the
  conditional framed companion and all-`m` manuscript.
- The proof/evidence paragraph states exactly what is written, imported,
  kernel checked, computationally replayed, and absent from formalization.
- The prose contains no unsupported quality claim; its specificity and the
  linked evidence make the standard of work directly inspectable.
- Every link and command is current and its stated effect is no stronger than
  the underlying gate.
- Fresh post-repair mathematical and formal/reproducibility readers both return
  accept, with no fatal or major finding open.
- Existing manuscript and verification gates pass, and the authority is
  synchronized to the standalone paper repository when required by the mirror
  conventions.

## Closeout

Completed at authority commit `6663d9020`; see
`notes/2026-08-22-c942-reviewer-guide-closeout.md`.  The clean standalone mirror
ends at `b5d99f1`.  The conditional framed companion's stale evidence checksum
is recorded there as an out-of-scope C940 defect; it is not used by the primary
theorem.

## Starting points

- `papers/complete-repair-ports/README.md`
- `papers/cubic-stabilization-m1/README.md`
- `papers/cubic-stabilization-m1/sections/`
- `papers/cubic-stabilization-m1/verification/README.md`
- `papers/cubic-stabilization-m1/verification/imported-sources.json`
- `papers/cubic-stabilization-m1/verification/evidence.json`
- `papers/cubic-stabilization-m1/lean/verification/claims.json`
- `notes/cubic-threefolds-tasks/c940-epilogue-three-way-split.md`
- `papers/style-guide.md`
