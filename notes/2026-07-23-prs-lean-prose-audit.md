# PRS Lean prose audit

**Date:** 2026-07-23  
**Lane:** `reed-solomon`  
**Scope:** referee-facing comments and docstrings in the Lean modules currently named by
`papers/beyond4_prs/formalization-ledger.md`

## Method and status

The audit applied `papers/style-guide.md` and the referee-facing prose rules in
`lean/AGENTS.md`. It covered the shared PRS foundation and contraction modules, the
redundancy-five modules and certificate, the existing redundancy-nine module, and their import and
axiom-audit gates.

C540 was active during the review. In the inspected worktree,
`RelativeConicArcs.PRSFoundation` and `RelativeConicArcs.PRSRedundancyNine` were modified, while
the redundancy-five certified wrapper and its two gates were untracked. The findings below describe
that live snapshot. The audit changed no Lean source.

## Findings

### High priority

1. `lean/RelativeConicArcs/PRSRedundancyFive.lean:11` says that the kernel checks “all numerical
   consequences.” The same module accepts orbit counts, group-action conclusions, cover
   classification, and certificate semantics as inputs. The header should say that Lean checks the
   algebra and derives numerical formulas from stated hypotheses. It should not imply that the
   hypotheses have been proved.

2. `lean/RelativeConicArcs/PRSRedundancyFive.lean:206` describes
   `HankelSpanCriterionInput` as providing projective equivariance. The structure contains a span
   predicate and an equivalence with kernel-member existence; it contains no group action or
   equivariance law. Remove the equivariance claim or formalize the missing law.

3. `lean/RelativeConicArcs/PRSFoundation.lean:288` and
   `lean/RelativeConicArcs/PRSRedundancyFive.lean:446` suggest that actual projective and
   semilinear group-action arguments supply the recorded orbit counts. Their structures contain
   numerical fields but no actions, stabilizers, representatives, or orbit-cardinality proofs.
   The comments should call these numbers hypotheses and state that their group-theoretic
   justification remains external.

4. `lean/RelativeConicArcs/PRSRedundancyFiveCertificate.lean:6` calls the seventeen table rows
   precisely the sporadic projective-linear orbits before a value of `CertificateValidation` has
   supplied their semantics. The file checks the transcription and internal arithmetic.
   Semantic identification of the rows is an external obligation. The opening paragraph should
   make that distinction immediately.

### Medium priority

5. `lean/RelativeConicArcs/PRSFoundation.lean:67` documents an existence equivalence without
   saying that the proof invokes classical logic. The adjacent double-negation theorem carefully
   marks the constructive boundary. Begin this docstring with “Classically” so that the pair reads
   consistently with the axiom audit.

6. `lean/RelativeConicArcs/PRSRedundancyFive.lean:194` says that split-freeness descends to
   projective syndrome directions. The theorem proves invariance under nonzero scalar
   multiplication; it does not construct or eliminate through a projective quotient. Describe
   the proved scaling invariance directly.

7. `lean/RelativeConicArcs/PRSRedundancyFive.lean:467` contains the architectural expression
   prohibited by the paper style guide. The sentence is also too strong for the declaration:
   `CertificateEvidence` is an arbitrary type at that point, so the structure does not force each
   finite validation to be a separate proposition. Name the four external inputs that the
   structure actually separates.

8. Terminology varies between “split squarefree” and “split-squarefree,” and among “deepest
   syndrome,” “deep syndrome,” “deepness,” and “shallowness.” The comments never give the paper’s
   coding-theoretic bridge from a deep syndrome to a deep-hole coset. State that bridge once and
   choose one local form of each term.

9. The module headers have a uniform implementation-first opening: nearly every file begins with
   “This module” or “This gate.” Across the audited comments, “exact,” “concrete,” “interface,”
   “explicit,” and “terminal” recur often enough to flatten the voice. Lead with the mathematical
   object or implication. Keep implementation and trust information in a shorter second paragraph.

### Low priority

10. `lean/RelativeConicArcs/PRSRedundancyFiveCertified.lean:7` calls imported modules
    “independently elaborated leaves.” That is build terminology. A public reader needs the
    mathematical specialization and the certificate-evidence type, not the build shape.

11. Several docstrings in `lean/RelativeConicArcs/PRSFoundation.lean` repeat the same account of
    predicate compatibility and witness-induced shallowness. Each public theorem needs a
    docstring, but each docstring can state only the hypothesis or conclusion that distinguishes
    that theorem from its neighbors.

## Strengths to retain

- Every audited top-level public declaration has a docstring.
- The source contains no task identifiers, internal reports, status language, private paths, or
  tactic narration.
- `lean/RelativeConicArcs/PRSRedundancyFive.lean` gives stable, pinpoint citations for the
  Seroussi--Roth and Aubry--Perret inputs.
- `lean/RelativeConicArcs/PRSRedundancyFiveCertificate.lean` names the public artifact, records its
  SHA-256 hash, and says that Lean does not rerun the enumeration.
- `lean/RelativeConicArcs/PRSResidualQuadratic.lean` is the best prose model in this closure: its
  header states the coordinate convention and characteristic restriction, and its docstrings say
  what each identity proves without narrating tactics.

## Recommended order

Before C540 lands, correct the claims about kernel coverage, equivariance, orbit semantics,
certificate semantics, and classical logic. Then standardize terminology and revise the six main
module openings in one prose-only pass. The remaining shortening can follow without changing the
formal API.
