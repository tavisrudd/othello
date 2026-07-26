# C656: PRS cold-read release repairs

**Lane:** `reed-solomon`

**Status:** queued

## Objective

Repair the release-blocking issues independently identified by two cold
referee reads of `papers/beyond4_prs/`.  Preserve the fixed-level R5--R7
results, but do not retain the arbitrary-redundancy headline or its threshold
unless the exact component and modular-budget gates below pass.

C646 owns formalization of marker density, closure transport, and abstract
irreducible-component selection.  C656 may consume that work but must not
count those conditional abstractions as proofs of the concrete bottom
component ledger, nucleus geometry, or finite classifications.

## Required repairs

### 1. Modular-pullback budget

- Define exactly which positive-characteristic normal-rational-curve nuclei
  enter each \(\mathcal M_j\).
- Prove scheme-theoretically that the relevant coherent lifts are nested, or
  that their union has one common degree-one pullback on the marker line.
- If neither statement is true, replace the degree-one charge in
  `prop:uniform-iterated-packages` by the correct union degree and propagate
  the resulting budget through \(d_j\), \(Q_r\), every headline and corollary,
  the tables, and the paper-facing Lean arithmetic.
- Record a small-characteristic regression that would fail if a second
  modular component were silently omitted.

### 2. Exact bottom-component ledger

- Promote every component-exclusion step behind
  `prop:exact-bottom-ledger` to a theorem-level statement with its base ring,
  ideal, saturation, reduction, dimensions, multiplicities, and exceptional
  fibres explicit.
- Prove or certificate-check the tame cyclic saturation, the complete
  characteristic-two vertical primes and ordered-Hessian rulings, the
  characteristic-three wild cone and diagonal collision, and the absence of
  further vertical or embedded components.
- If computer algebra is essential, state the result as a
  computer-assisted theorem and ship deterministic commands, compact
  certificates or canonical output, exact toolchain locks, and an
  independently implemented replay tied directly to the printed lemmas.

### 3. Recursive transport

- Replace the compressed proof of `lem:recursive-bottom-transport` by a
  componentwise induction over geometric generic points.
- Make base change, scheme-theoretic image closure, special fibres,
  noninjective boundaries, finite reduced unions, and possible
  embedded/nilpotent structure explicit.
- Prove that persistent and modular lower components lift to precisely the
  declared upper components; do not infer this merely from set-theoretic
  containment of one polar line.
- State and prove the consecutive-Hankel lemma used to route rank-one
  rowspaces and rulings to the normal-rational-curve boundary.

### 4. Fixed-field evidence

- Independently replay every certificate-dependent R5, R6, and R7 bridge
  field without importing the generator's classifications or orbit
  partition.
- Reproduce projective syndrome totals, split-free tests, orbit partitions,
  stabilizers, Frobenius fusion, representative invariants, and every
  asserted absence of exceptional orbits.
- Document which layers are independent: field arithmetic, syndrome test,
  canonicalization, orbit enumeration, and aggregation.

### 5. Manuscript and trust-boundary repair

- Expand the R5 inseparable trivial-gcd argument rather than routing it by
  “overlap equations” alone.
- Give a standalone arbitrary-\(r\) proof that the persistent tangent and
  conjugate-secant directions are split-free and have total cardinality
  \(q(q+1)^2/2\).
- Reorganize the all-level proof so the exact bottom theorem and
  componentwise coherent lifts precede the recursive induction and
  threshold.
- Mark each headline as geometric, certificate-assisted, or conditional on
  an external theorem.  Describe Lean as checking identities and
  conditional implication plumbing unless the concrete geometry is
  actually formalized.
- If any gate above fails, narrow Version 1 to the strongest proved
  fixed-level theorem rather than weakening the trust language.

### 6. Post-audit literature delta

- Starting from the 2026-07-25 baseline in
  `papers/beyond4_prs/literature-audit.md`, screen new, revised, newly
  indexed, and newly citing work relevant to the R5--R7 classifications,
  coherent marked contraction, split-squarefree Hankel systems, NRC
  nuclei/Lucas carriers, and the all-level stable-component theorem.
- Refresh the pinned forward graphs and record OpenAlex, Crossref, and
  Semantic Scholar counts separately whenever a negative relies on an
  exhaustively screened citing set.
- Apply `notes/literature-audit-conventions.md` in full: record every query,
  screened-set size and discriminator, source version and unconditional read
  depth, cache key and SHA-256, empty-versus-error checks, and every
  unreachable coverage gap.
- If a possible predecessor or stronger adjacent result appears, stop the
  release path, read the strongest accessible text at claim-verification
  depth, and run the bounded novelty-failure extraction required by the
  workspace conventions.

## Acceptance gate

1. The modular-union degree lemma passes, or every affected threshold and
   theorem is corrected.
2. A specialist can reconstruct the exact bottom primary-decomposition and
   saturation claims from the printed proof plus the public evidence bundle.
3. The recursive transport proof closes without an unstated
   set-theoretic-to-scheme-theoretic step.
4. The independent R5--R7 replay agrees exactly with every public table and
   absence claim.
5. The canonical and TIT PDFs, supplement verifier with replay, paper-facing
   Lean aggregate/axiom audit, and deterministic fresh-history export are
   green.
6. The post-2026-07-25 literature delta is durable, convention-complete, and
   reconciled with every absence-dependent manuscript sentence.
7. Two new cold specialist readers, denied access to the prior reviews,
   independently return no release-blocking mathematical objection.

No upload, DOI registration, repository publication, or other external
release action is authorized by this task.

## Deliverable

`notes/2026-07-26-c656-prs-cold-read-release-repairs.md`
