# C604 relconic Lean reconstruction and matching-design closure

**Lane:** `relconic`

**Status:** QUEUED

## Goal

Close the paper-facing Lean gap for:

1. exact recovery of a projective arc from its ordinary uncovered locus above
   the strict incidence threshold, including the canonical secant/vertex
   reconstruction and semilinear-stabilizer equality; and
2. the zero-defect concurrence decomposition, maximum-matching design, exact
   centre counts, and bad-edge stability theorem.

Finish by importing the public declarations through
`RelativeConicArcs.Gates.Relconic`, auditing their axioms, and synchronizing
the trust manifest, proof audit, and manuscript verification table with the
actual checked boundary.

## Ordered execution

1. **Terence--Tao diagnostic first.** Before designing declarations or editing
   Lean, identify the invariant formulation Tao would seek, the smallest
   reusable incidence/Kneser interface, hidden finiteness or Desarguesian
   hypotheses, sharpness and converse questions, and whether one abstraction
   proves both reconstruction and matching rigidity without coupling unrelated
   paper notation. Record the resulting theorem-shape decisions here.
2. Read the nested Lean guide and inventory only the directly relevant
   existing definitions and theorem signatures.
3. Formalize exact uncovered-locus reconstruction and the canonical inverse /
   stabilizer corollary.
4. Formalize concurrence-clique decomposition, zero-defect
   `MATCH(k,floor(k/2),1)` rigidity, exact centre counts, and bad-edge
   stability.
5. Validate through the scoped Relconic gate, run the required axiom audit,
   and reconcile every paper/trust statement with the declarations actually
   imported.
6. Run the required `ej`+`tt` closeout, record the mystery ledger, and complete
   the normal relconic task lifecycle.

## Acceptance boundary

- No manuscript claim may say reconstruction or matching rigidity is
  kernel-checked unless a named theorem is imported by the Relconic gate.
- The axiom report must remain within the documented Mathlib foundations, with
  no `sorry`, `admit`, custom axiom, or `native_decide`.
- The quantitative C583 inverse-stability package is out of scope unless the
  initial diagnostic shows it is a free consequence of the exact
  reconstruction interface; otherwise retain it as a separately allocatable
  successor.
- The Singular-backed ten-point rank-three classification is out of scope; its
  explicit non-Lean trust boundary must remain visible.
