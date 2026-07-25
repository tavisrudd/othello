# C613 planning: Choi and transversal Clifford corollary

**Lane:** `ame-lu`

## Goal

Formalize the complete operational corollary of C612.  For the
\([[2m-1,1,m]]_q\) encoder obtained by viewing one leg of an equal-phase
\([2m,m,m+1]_q\) MDS/CSS AME state as the input, prove that every product
physical unitary implementing a logical unitary has Clifford physical factors
and a Clifford logical action.

## Exact gaps

1. **One-leg reshape.**  Define the normalized Choi state of
   \(V:\mathbb C^q\to(\mathbb C^q)^{\otimes(2m-1)}\) in the same tensor and
   basis convention as the generic equal-phase state.
2. **Isometry from AME.**  Prove that the maximally mixed one-party reduction
   makes the reshaped map an isometry, including the normalization factor.
3. **Quantum-MDS parameters.**  Construct the one-logical-qudit code subspace
   and prove the \([[2m-1,1,m]]_q\) parameters: dimension \(q\), correction of
   every \(m-1\) output erasures from AME decoupling, distance \(m\), and
   quantum-Singleton equality.  Do not leave the displayed parameters as
   manuscript-only nomenclature.
4. **Choi action orientation.**  From
   \(U_{\mathrm{phys}}V=VL\), prove exactly
   \[
   (I\otimes U_{\mathrm{phys}})|\Psi_C\rangle
      =(L^T\otimes I)|\Psi_C\rangle
   \]
   and hence
   \[
   ((L^T)^{-1}\otimes U_{\mathrm{phys}})
      |\Psi_C\rangle=|\Psi_C\rangle .
   \]
   The transpose, inverse, tensor-leg order, and global phase must be visible
   in the theorem statement or its immediate bridge.
5. **Clifford closure.**  Prove that entrywise conjugation preserves the
   finite-field Weyl group, that adjoint and inverse preserve its normalizer,
   and therefore that transpose preserves the one-qudit Clifford predicate.
6. **Terminal corollary.**  Apply C612 to the normalized Choi state and
   conclude separately that every physical factor and \(L\) are Clifford.
   Export both the strong factorwise statement and the concise
   no-transversal-non-Clifford corollary.

## Proposed module boundary

- a generic finite-dimensional Choi/reshape module if mathlib lacks the exact
  convention;
- an AME one-leg encoder and erasure-correction module;
- a finite-field Clifford closure module;
- the transversal logical-action terminal;
- import-only and axiom-audit gates.

Reuse a suitable existing public Choi or quantum-code API when it matches the
paper convention.  Otherwise prove the finite matrix-entry identities
locally; do not introduce a broad quantum-information hierarchy merely to
state one corollary.

## Acceptance

- The encoder, code subspace, distance, and quantum-MDS parameters are
  kernel-checked, not assumed fields.
- The Choi identity has the paper's exact orientation and normalization.
- The logical conclusion proves the existing finite-field Clifford predicate,
  not only preservation of an unnamed operator basis.
- C612's general rigidity theorem is the only nontrivial rigidity input.
- Guarded elaboration, AME gates, exact no-build checks, aggregate trace, and
  axiom audits pass; the conceptual terminal has no `sorry`, native
  evaluation, generated declaration, external certificate, or project axiom.
- The abstract, Corollary 1.2, Section 3 proof, formalization ledger,
  statement-adequacy map, verification prose, and exact Lean declarations are
  synchronized.

## Stop conditions

Stop if the paper's claimed quantum-code parameters require a definition of
distance or erasure correction not equivalent to the chosen formal API.
Resolve that correspondence rather than formalizing only the Choi algebra and
calling the full corollary covered.  Stop on a transpose-orientation mismatch
with a two-dimensional matrix counterexample rather than changing the
manuscript convention silently.

