# C989 — AME-LU commutant-algebra integration

**Lane:** `ame-lu`  
**Status:** in progress  
**Scope:** Paper I only; no Lean edits, mirror synchronization, push, deposit, or submission

## Objective

Integrate the results proved in
`2026-08-28-ame-lu-commutant-algebra-theorem.md`, subject to the literature
boundary in `2026-08-28-ame-lu-commutant-literature-audit.md`, while preserving
the paper's main route:

\[
 \text{support rigidity}
 \longrightarrow \text{transition maps}
 \longrightarrow \text{intrinsic endomorphism algebra}
 \longrightarrow \text{exact symmetry and code structure}
 \longrightarrow \text{robust rigidity}.
\]

## Frozen A baseline

- authority commit: `970a39a7a172dde58e92abd94aacdbe1bf5df00a`
- tracked PDF: `papers/ame_lu/ame-lu.pdf`
- PDF SHA-256: `2d73381a9be5a42a109272f38ac2a01f6618e2e592d6d2b68e8c94365206d339`
- length: 41 A4 pages

The baseline can be reconstructed from the recorded commit; no duplicate PDF
is stored in Git.

## Integration design to red-team

1. **Exact classification.** Replace the final ad hoc common-centralizer
   paragraph of the prime-field recognition corollary by the intrinsic algebra
   of block-diagonal endomorphisms preserving the stabilizer label space.
   Evaluation at one party identifies this algebra with the common centralizer
   of the fundamental holonomies. Derive the existing five group orders from
   the five possible algebra types.
2. **Low-party consequence.** State and prove that for four and six parties the
   fundamental holonomies commute, hence the algebra has dimension at least
   two. Keep the `q>=5` qualification on the noncentral-group corollary.
3. **Coding interpretation.** Give one compact theorem explaining the split,
   quadratic-field, dual-number, and full-matrix module structures. Concede the
   standard CSS, Hermitian, and ring-code constructions and the qubit
   `GF(4)`-linearity precursor. Do not use “MDS over the dual numbers” unless
   the chosen ring-distance convention and consequence are proved.
4. **Sharpness.** Keep the conditional open-dense argument and the conclusion
   of the exact `AME(8,7)` witness in the body. Put the explicit matrix and
   determinant data in a compact appendix or a reproducible paper-facing
   artifact only if the evidence conventions can be satisfied in this task;
   otherwise retain the witness in the research note and state no paper claim
   that depends on it.
5. **Front matter and ending.** Add only enough abstract/introduction/conclusion
   prose to expose the algebraic mechanism and low-party boundary. Exact LU
   rigidity and quantitative rounding remain the two headline scales.
6. **Trust surfaces.** Update the claim--proof--novelty ledger before any
   novelty wording, then the theorem map, verification map, formalization
   boundary, README, and summary surfaces only where the adopted manuscript
   actually changes them. No formal coverage is to be inferred for the new
   theorem composition.

## Acceptance gates

1. Pre-edit red team finds no hidden prime-field, characteristic-two,
   extension-field, module-freeness, self-duality, or genericity hypothesis.
2. The theorem-only route remains legible without the coding-interpretation
   subsection or sharpness details.
3. Warning-free paper check and clean rendered inspection pass.
4. New theorem labels, citations, novelty rows, and verification boundaries
   agree across all paper-local surfaces.
5. The revised paper remains within a target delta of four pages; a larger
   increase requires an explicit value-for-space finding.
6. A cold mathematical review and a cold exposition review report no major
   defect; all accepted findings are repaired and the gates rerun.
7. Blind A/B records separately: theorem-spine clarity, quantum-information
   accessibility, mathematical memorability, referee verifiability, and page
   economy. The current version is retained only if B wins without a material
   accessibility loss.

## Review record

Pending.

## Mystery ledger

Pending the required `ej` and `tt` closeout after the acceptance gates.
