# Claim, proof, and novelty ledger

Every assertion promoted to theorem or corollary status appears here.  Human
proof, Lean coverage, executable evidence, imported mathematics, novelty, and
editorial disposition are independent fields.

## Status vocabulary

- `HUMAN`: a complete mathematical proof is present in the manuscript or named
  proof report.
- `KERNEL`: the exact paper statement is checked by Lean.
- `KERNEL-CORE`: Lean checks only part of the paper statement.
- `IMPORTED`: a named classical theorem is consumed explicitly.
- `CERTIFIED`: a finite executable artifact checks only its stated finite
  domain.
- `NONE-FOUND`: a bounded search found no predecessor; this never authorizes a
  categorical priority claim.
- `BLOCKED-BODY`: the claim cannot carry the main proof spine yet.

| Claim family | Human proof | Lean status | Computation | Literature/novelty boundary | Manuscript action |
|---|---|---|---|---|---|
| Complete support/coefficient/probability port | Existing definitions and basic-invariants proof; C672 supplies the coefficient-span mechanism | `KERNEL` for support/coefficient bridge, code recovery, and intrinsic reconstruction; probability remains C675 | Existing coefficient replay is corroborative only | Repair tolerance and all-low-weight-dual-support machinery are prior or adjacent art | Support/coefficient layers admitted; probability layer remains gated |
| MDS local reconstruction | Complete common-core star-basis proof in C672 | `KERNEL`: prescribed minimum word, complete support clutter, spanning, exact radius, and double-dual recovery | None | MDS support clutter is generic; value lies in the coefficient reconstruction statement | Admitted page-2 headline |
| Exact pointed confinement and weighted transfer | Complete proof in current Section 3, including zero/singleton/multisupport partition and both port-equality inclusions | `RepairPorts.exactFunctionalStrata`, `RepairPorts.exactPointedConfinementAndTransfer` | None required | Concatenated-dual decomposition and fiber enumerator are prior art; the proof uses only the decomposition, not the enumerator | Retained body theorem |
| Strict weighted example | Conceptual Singer averaging and code deduction | `RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action` | None required | Natural strict example, not a new MDS construction | Retained secondary corollary |
| Prescribed positive-density realization | Complete trace-duality, exact-cost, two-inclusion, density, and scaled-parameter proof | `RepairPorts.eventually_pointedConfinement_iff_zeroCost`, `eventually_prescribedPorts`, `representedTargets_density`, `concatenatedRestrictedCode_parameters` | None required | Random GV and AG/TVZ outer-family existence are classical; the represented coefficient-port consequence uses no enumerator | Retained body theorem |
| Clebsch/MDS fingerprints | MDS common-core basis plus prescribed-port transfer; exact \(z_x\) specialization for Clebsch | `RepairPorts.eventually_mdsMinimumCoefficientFingerprints` | None required | Support-only MDS data is generic; the coefficient layer carries the represented geometry | General MDS corollary retained; Clebsch compactly derived |
| Reliability calculus | Complete finite-sum manuscript proof | `KERNEL`: deletion--contraction, pivotal derivative, Russo--Margulis, and minimum-blocker leading coefficient | Exact profiles are `CERTIFIED` appendix refinements only | Reliability, pivotality, Russo--Margulis, and blocker calculus are classical tools | Admitted body theorem |
| Bounded EXIT | Complete conditioning and event-difference proof | `KERNEL`: erasure-sign recurrence, radius filtration, and cheapest-radius transform | Exact finite curves are `CERTIFIED` appendix refinements only | EXIT is classical; finite radius is bounded-query decoding, not symbol-MAP or capacity | Admitted body proposition |
| Pointed Tutte specialization | Manuscript derivation from cited Las Vergnas structure | None | Current \(q=9\) comparison is `CERTIFIED` | The polynomial is prior art; the bounded-radius filtration is the paper-specific boundary | `BLOCKED-BODY`; C676 |
| Cubic--axis port | Complete manuscript proof | `KERNEL` chain | Exact \(q=9\) tables are also kernel checked but secondary | Classical geometry; exact repair rows and all-symbol separation are `NONE-FOUND` candidate contributions | Retain as an application after adequacy reconciliation |
| Quartic--nucleus/harmonic port | Symbolic manuscript proof using classical nucleus/design inputs | None | \(q=9,q=27\) circuits and profiles are `CERTIFIED` | Classical geometry and design; complete radius-four repair interpretation is `NONE-FOUND` | `BLOCKED-BODY`; C677 |
| Harmonic closure and Poisson consequences | Manuscript arguments of mixed scope | None | Finite gate and error tables are `CERTIFIED` | Chen--Stein and design overlaps are classical; no threshold or completeness claim | Admit only theorem-derived Lean consequences; otherwise appendix |

## Promotion rule

A row leaves `BLOCKED-BODY` only when its human proof, exact Lean terminal,
adequacy comparison, and axiom audit all pass.  Replaying a certificate cannot
promote a row.
