# C989 — AME-LU commutant-algebra integration

**Lane:** `ame-lu`  
**Status:** complete
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

### Pre-edit mathematical red team

Conditional go.  The algebra/centralizer theorem, five-type classification,
low-party commutativity theorem, and module interpretations are sound,
including in characteristic two.  Repairs adopted before manuscript editing:

- theorem-local prime dimension for the determinant-one, five-type,
  low-party, and module conclusions;
- locally framed CSS language;
- compatible-coordinate, weighted Hermitian language;
- module-theoretic dual-number language only; and
- exclusive use of `E \cong k \times k` in the split row.

The conditional genericity statement is geometric only.  The exact
`AME(8,7)` witness was independently verified but is withheld from the paper
until it has the required committed evidence bundle.

### Pre-edit architecture red team

The integration wins only as replacement/consolidation.  A raw A--E sequence
would add an estimated 5--7 pages and compete with robust rigidity.  The
adopted target is 2.5--3.5 pages: replace the current common-centralizer tail,
merge the five group types and their code meanings, state the low-party
theorem separately, and keep detailed module proofs outside the theorem-only
route.  Exact LU rigidity and quantitative rounding remain the two headlines.

### Post-edit mathematical referee

Conditional go, repaired.  The referee found no defect in the
algebra--centralizer identification, the five exhaustive types and orders,
the characteristic-two cases, the four-/six-party commutativity proof, or
the module interpretations.  The one blocker was an inherited but unstated
`m >= 2` hypothesis before the projective symmetry-order formula; it is now
explicit in Section 5 and Appendix A.  The revision also makes evaluation in
the determinant condition explicit, restores the block-determinant comparison
to the algorithm summary, and expands the weighted Hermitian normalization.

### Post-edit exposition referee

Keep, with local repairs completed.  The referee judged the exact-to-robust
spine intact and Section 5 a useful structural refinement rather than a
second narrative center.  Accepted repairs:

- move the one-page module proof to Appendix A, immediately after the body;
- display the weighted row/column orthogonality identities in the low-party
  proof;
- replace “locally framed” by standard local symplectic-coordinate language;
- explain the `tr` subscript on the compatible transition-system group;
- compress the repeated implementation details in the conclusion; and
- remove the rendered page-break orphan in the organization paragraph.

### Blind A/B

The first anonymous comparison preferred the integrated version with
confidence `0.8`.  It scored higher on theorem-spine clarity and mathematical
memorability, tied on verifiability, title alignment, and page economy, and
showed a small nonblocking abstract-accessibility regression.  The abstract
sentence was rewritten in plain dimensional language before the final A/B.

### Current build

- baseline: 41 A4 pages, SHA-256
  `2d73381a9be5a42a109272f38ac2a01f6618e2e592d6d2b68e8c94365206d339`;
- integrated pre-strip revision: 44 A4 pages;
- final revised paper: 39 A4 pages, SHA-256
  `b7fa88d3efd4eb78a7bd9126987031c8c17fca1aba052e23d09f6b8e9b85b7b7`;
- `make check`: warning-free;
- rendered inspection: abstract, Section 5, the Section 5--6 transition,
  Appendices A--C, the trust table, and the disclosure/bibliography transition
  inspected at original resolution.

### Final subtraction pass

The 44-page integrated draft still carried three superseded quantitative
routes in Appendix B: one-marginal tensor-axis rounding, aggregate
minimum-support rounding, and their explicit but weaker thresholds.  None was
used by the cleaning theorem or any exact result.  They and their theorem-map
rows were removed.  The broader two- and `k`-uniform discreteness and local
stability results remain, and the two-unitary consequence is compressed to a
short standard interpretation.  Removing an unnecessary forced page break at
the trust boundary recovered one further page.  The final revision is five
pages shorter than the integrated pre-strip draft and two pages shorter than
the frozen baseline, with no change to a surviving theorem's hypotheses or
conclusion.

The final anonymous comparison again preferred the integrated version, with
confidence `0.82`.  Its scores were `4/5` spine clarity, `5/5` adjacent-field
accessibility, `5/5` memorability, `4/5` verifiability, `5/5` title alignment,
and `4/5` page economy, versus `5/3/4/5/5/5` for the baseline.  The sole
blocking navigation comment was that the organization paragraph omitted the
trust-boundary appendix; this is repaired without reintroducing the rendered
page-break orphan.  No blocking mathematical, accessibility, sequencing, or
rendering finding remains.

A final blind comparison tested the 39-page subtraction pass directly against
the 44-page integrated draft.  It preferred the shorter version with
confidence `0.84`: the theorem spine tied `5/5`, economy improved from `3/5`
to `5/5`, and accessibility, audit retention, and appendix flow each moved
from `5/5` to `4/5` because the superseded proofs were no longer available as
optional detail.  The reader found no stale reference or headline-proof loss.
Its sole audit concern was the compressed two-unitary consequence; the final
text now cites the exact discreteness theorem and phase-quotient remark that
imply it, while leaving it as an unnumbered interpretation rather than an
advertised theorem.

## `ej` + `tt` closeout

**Extra juice.**  The common-centralizer computation does more than identify
the symmetry group.  It is a homogeneous linear system in four unknowns;
dimension and one characteristic polynomial determine the algebra type.
Section 5 now states the resulting constructive consequence: the recognition
calculation also returns the symmetry type and the associated code-structure
row without finite-group enumeration.

**Tao pass.**  The invariant to remember is the algebra, not its unit group.
The five group rows are shadows of three possible algebra dimensions
`1, 2, 4`, and the low-party theorem is fundamentally the exclusion of
dimension `1`.  This viewpoint keeps the theorem compositional and explains
why the module interpretations belong to the same result rather than to a
separate coding-theory digression.

## Mystery ledger

- **Settled:** why the former five symmetry orders looked unrelated.  They are
  determinant-one unit groups of the five possible common-centralizer
  algebras.
- **Settled:** whether characteristic two or an unspoken odd-prime hypothesis
  breaks the result.  Both independent mathematical reads found no such
  restriction; the displayed proofs retain characteristic two.
- **Settled:** whether the new result narrows the all-prime-power LU theorem.
  It does not.  The intrinsic algebra is stated over the underlying prime
  field, while every `2 x 2` type/group/module conclusion is theorem-locally
  restricted to `q=p`.
- **Open, outside C989:** which nonscalar algebra types occur for each prime
  at six parties.  This requires a separate occurrence/classification task.
- **Open, evidence-gated:** the exact `AME(8,7)` center-only witness and the
  conditional geometric genericity statement remain in the research note.
  A paper-facing use requires a committed generator, certificate, checksum
  manifest, independent replay, and evidence linkage.
- **Open, extension-field research:** for `q=p^e`, the symmetry group must
  preserve the full transported family of alternating forms.  Classifying
  those unit groups, and then adding semilinear equivalence, is a separate
  theorem rather than a free generalization of the five prime-field rows.
