# C544 — aggregate Lean and trust gate for the beyond-four PRS paper

**Lane:** `reed-solomon` · **Date:** 2026-07-24 · **Status:** complete

## Result

The paper-facing formal closure is
`RelativeConicArcs.Gates.PRSBeyondRedundancyFour`.  It imports exactly the adopted
projective Reed--Solomon foundation, redundancy-five, polar/redundancy-six/seven,
redundancy-eight, redundancy-nine, and characteristic-two Hessian/Lucas gates.
The adjacent
`RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit` checks 103 adopted
algebraic, contraction, arithmetic, finite-table, and conditional synthesis
terminals.

The declaration-level paper map in
`papers/beyond4_prs/supplement/LEAN-STATEMENTS.md` reconciles all 47 numbered
theorems, propositions, and corollaries.  Each row identifies one of four exact
routes:

1. kernel-checked algebra or arithmetic;
2. a conditional Lean terminal with visible geometric, coding, group-action, or
   certificate-semantics fields;
3. a manuscript proof or cited external theorem with no direct declaration; or
4. a public certificate whose internal arithmetic is checked by Lean while its
   exhaustive-search semantics remain external.

No manuscript-only theorem is promoted to a Lean proof.  In particular, the
four-marker redundancy-nine lower-package budgets are manuscript mathematics,
not part of the residual-quadratic Lean package.

## Trust and source review

The aggregate audit reports only `propext`, `Classical.choice`, and
`Quot.sound`.  The complete project-owned transitive closure contains no
project-local axiom, `sorry`, native evaluator, generated Lean certificate, or
opaque external oracle.  Every public declaration in the eleven mathematical
modules has a docstring, and the eleven modules plus their fourteen gate/audit
files pass the referee-facing review for stable names, mathematical scope,
trust-boundary disclosure, workflow vocabulary, task identifiers, local paths,
and repository-local references.

The review found a stale source anchor in both finite-table modules.  Their
headers now name the current public
`papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.json`, SHA-256
`b3441d983798793f211878de7e72b976be9170b580041f460cf981a73dbf66a2`.
The paper-local evidence manifest records the same `545912` bytes and hash.
Lean reduces the transcribed table arithmetic but does not claim to consume or
semantically validate that JSON.

## Manuscript and reproducibility reconciliation

The formalization ledger, theorem map, claim/proof ledger, verification map,
verification section, statement-adequacy supplement, release checklist,
adversarial audit, paper README, and second-draft release rule now agree on the
formal boundary.  The aggregate formal gate is closed; the independent final
reader, clean public export/replay, immutable identifiers, and author/venue
confirmation remain release gates.

The paper-local package was regenerated after the statement map changed.
`python3 supplement/verify.py` verifies all 56 bundled evidence artifacts, the
classification-record generator check, classification hashes, and the local
release-manifest rows.  `make check` rebuilds the 43-page PDF without LaTeX,
reference, citation, overfull, or underfull warnings.

## Validation

Final guarded run:

```text
/home/tavis/.cache/othello-lean-build/run-20260724-095209-1afdb1c9
```

It records both exact targets as trace-current and passes the final trace-only
aggregate gate:

```text
skipped-current  RelativeConicArcs.Gates.PRSBeyondRedundancyFour
skipped-current  RelativeConicArcs.Gates.PRSBeyondRedundancyFourAxiomAudit
gate-passed      <aggregate>
```

The preceding guarded runs built the aggregate gate and the corrected
103-terminal audit.  One intermediate run built the audit but failed its
aggregate check because the new import gate had not first been named as a build
target; the invocation was corrected.  A later audit attempt exposed one
misspelled namespace in an added orbit-table print, which was corrected before
the successful build.  Neither failure was a theorem or axiom failure.

One exploratory `jq` projection accidentally expanded nested orbit records and
produced more than 10,000 tokens.  Its truncated output was discarded.  The
replacement projection selected only field-level counts in one compact line;
no conclusion depends on the oversized output.

## Extra-juice and Tao closeout

The closeout asked which claims could still drift even after every leaf gate was
green.  Four cheap upgrades followed:

- the aggregate audit was expanded from headline synthesis theorems to all 103
  paper-adopted terminals, including marker swaps, exact budgets, and the
  redundancy-six orbit arithmetic;
- an automated comparison proves that every one of the 47 manuscript labels
  occurs in the declaration-level map;
- the public classification-record hash is synchronized across Lean headers,
  the statement map, formalization ledger, verification map, and evidence
  manifest; and
- stale release documents were updated so formal reconciliation is no longer
  listed as a publication blocker, while the genuinely external release gates
  remain visible.

The structural lesson is that one green synthesis theorem is not a complete
paper trust map.  The valuable aggregate object is the typed boundary: algebra,
visible hypotheses, external theorems, and certificate semantics must remain
separate through the final manuscript label.

## Mystery ledger

Settled:

- **Did the aggregate closure accidentally import unrelated geometry?** No.  It
  imports exactly the six adopted PRS leaf gates.
- **Could an unformalized manuscript proposition be mistaken for a Lean
  theorem?** No.  All 47 labels have an explicit route, including a direct “no
  declaration” status where appropriate.
- **Did the finite-table modules still point to the released bytes?** Not
  initially; the stale hash was found and corrected to the current
  release-manifest value.
- **Were the R9 four-marker budgets kernel checked?** No.  The manuscript claim
  was corrected; Lean checks the residual algebra and conditional synthesis,
  not that lower-package proof.
- **Does the aggregate trust base contain a hidden local axiom or oracle?** No.
  The tracked 103-terminal audit reports only the three standard Lean/mathlib
  dependencies above.

Open, with exact owners:

- **Concrete coordinate dictionaries, component geometry, rational-point
  theorems, covering radius, and genuine group actions:** these are deliberately
  visible formal hypotheses and manuscript/citation obligations, not C544
  defects.
- **Public immutable Lean revision and clean export:** owned by C545 together
  with the independent reader and release bundle.
- **Other degree-nine Lucas strata:** remain outside the paper claim and belong
  to C531.

No genuine task-owned mystery remains, and no incidental observation met the
discovery-track discriminator.
