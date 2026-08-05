# C815 — Lean formalization of four-shadow recognition

**Lane:** `clebsch`  
**Status:** reopened after formal audit; the three Paper III gates, their axiom
reports, manifests, and all paper-local replays are green with no
compiled-evaluation axiom at any terminal, the documentation and gate-replay
obligations of the audit checklist are closed, the recognition theorem is
transported off the root gauge and the conference switching class is proved
unique, and the remaining work is the aligned-design strengths, the rank-14
weighted Jacobian, and gap class B before the API is handed to C823

## Objective

Formalize the reusable converse theorem behind C809: for a symmetric zero-diagonal order-six matrix with nonzero off-diagonal entries, nonzero proportionality between the triangle cubic and the commutator-Pfaffian/third-compound cubic forces the quadratic relation $A^2=\lambda I$. Formalize the root-normalized scalar-sign specialization that detects the conference square and its oriented six-test recognition packet. Reduction of arbitrary sign matrices and uniqueness modulo switching and permutation were originally excluded; the 2026-08-03 author instruction to close every gap by strengthening the formal side brought both into scope, and both are now formalized.

## Required scope

1. Reuse rather than duplicate C763's existing ring-general forward bridge from a fixed conference matrix to the commutator-Pfaffian cubic.
2. Define the triangle coefficients and prove the pair-moment identity
   
   \[
   \sum_{k\ne i,j}\tau_{ijk}=a_{ij}(A^2)_{ij}.
   \]
3. Express translation invariance of the commutator cubic and derive vanishing pair moments from nonzero proportionality.
4. Prove that nonzero edges make $A^2$ diagonal and that commutation with $A$ makes its diagonal scalar.
5. On scalar sign matrices, prove the gauge-to-pentagon classification and the converse conference square without replacing the structural argument by a 1,024-case table.
6. Formalize that five first-row balance equations plus one oriented coefficient select the labelled oriented codes. One audited finite classifier may discharge this exact labelled fibre only after the conference square and pentagon degree statement have been proved symbolically.
7. State the exact boundary: the rank-14 local weighted rigidity calculation remains an exact external certificate unless a clean existing rational-rank interface makes formalization essentially free.

## Coordination boundary

C815 owns the new converse/recognition declarations. C800 owns the pre-existing general operator identities and final shared-manifest reconciliation; C799 owns aligned-design reconstruction. Before any Lean operation, follow `lean/AGENTS.md`, inspect the current shared package, and avoid overlapping edits with an active owner. If C800 has not yet merged manifests, land C815 as a separately gated module with an explicit handoff rather than silently taking C800's release surface.

## Acceptance

- The universal coefficient bridge used by the converse is either reused from C763 or proved once at the correct abstraction level.
- The general nonzero-edge quadratic implication, normalized scalar-sign conference-square characterization, and six-test oriented recognition theorem are kernel-checked.
- The guarded focused gate, axiom audit, hash manifest, and paper-local replay surface pass.
- Every theorem is mapped to C809's human statement and the local weighted Jacobian boundary remains honest.
- No manuscript prose or public release is changed; C816 owns promotion.

Acceptance has not fully passed.  The repair checklist is recorded in
`notes/2026-08-02-paper-iii-lean-audit-checklist.md`; the final declaration
map, trust boundary, replay surface, and closeout ledger belong in
`notes/2026-08-02-c815-four-shadow-lean-formalization.md` only after terminal
validation.

The formalization itself is now kernel-checked: the module elaborates without
errors or warnings, the focused gate builds through the guarded queue, its
`#print axioms` output matches the tracked report, and the paper-local replay
passes in both modes.  Validation also found that the `x₀x₁x₂` coefficient of
the commutator-Pfaffian cubic carried the wrong sign, which had made both
orientation predicates select the opposite six-code fibre; the corrected
classification is confirmed by an exact independent recomputation committed
with the report.

## Evidence source

Human theorem and exact certificate: `notes/2026-08-02-c809-four-shadow-characterization.md` and its adjacent `.py`/`.json` bundle.
