# C815 — Lean formalization of four-shadow recognition

**Lane:** `clebsch`  
**Status:** queued; C809 theorem frozen; coordinate source and manifest ownership with C800

## Objective

Formalize the reusable converse theorem behind C809: for a symmetric zero-diagonal order-six matrix with nonzero off-diagonal entries, nonzero proportionality between the triangle cubic and the commutator-Pfaffian/third-compound cubic forces the quadratic relation $A^2=\lambda I$. Formalize the scalar-sign specialization that recovers the unique conference switching class and its oriented six-test recognition packet.

## Required scope

1. Reuse rather than duplicate C763's existing ring-general forward bridge from a fixed conference matrix to the commutator-Pfaffian cubic.
2. Define the triangle coefficients and prove the pair-moment identity
   
   \[
   \sum_{k\ne i,j}\tau_{ijk}=a_{ij}(A^2)_{ij}.
   \]
3. Express translation invariance of the commutator cubic and derive vanishing pair moments from nonzero proportionality.
4. Prove that nonzero edges make $A^2$ diagonal and that commutation with $A$ makes its diagonal scalar.
5. On scalar sign matrices, prove the gauge-to-pentagon classification and the converse conference square without replacing the structural argument by a 1,024-case table.
6. Formalize that five first-row balance equations plus one oriented coefficient select the labelled oriented class. A finite `native_decide` replay may corroborate but must not replace the pentagon proof.
7. State the exact boundary: the rank-14 local weighted rigidity calculation remains an exact external certificate unless a clean existing rational-rank interface makes formalization essentially free.

## Coordination boundary

C815 owns the new converse/recognition declarations. C800 owns the pre-existing general operator identities and final shared-manifest reconciliation; C799 owns aligned-design reconstruction. Before any Lean operation, follow `lean/AGENTS.md`, inspect the current shared package, and avoid overlapping edits with an active owner. If C800 has not yet merged manifests, land C815 as a separately gated module with an explicit handoff rather than silently taking C800's release surface.

## Acceptance

- The universal coefficient bridge used by the converse is either reused from C763 or proved once at the correct abstraction level.
- The general nonzero-edge quadratic implication, scalar-sign conference classification, and six-test oriented recognition theorem are kernel-checked.
- The guarded focused gate, axiom audit, hash manifest, and paper-local replay surface pass.
- Every theorem is mapped to C809's human statement and the local weighted Jacobian boundary remains honest.
- No manuscript prose or public release is changed; C816 owns promotion.

## Evidence source

Human theorem and exact certificate: `notes/2026-08-02-c809-four-shadow-characterization.md` and its adjacent `.py`/`.json` bundle.
