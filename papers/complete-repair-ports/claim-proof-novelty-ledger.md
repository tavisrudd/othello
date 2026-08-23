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
| Bounded recovery supports, equations, and probability | Definitions and basic-invariants proof; C672 supplies coefficient-span reconstruction and C675 the finite survival-event calculus | `KERNEL` for the support/coefficient bridge, code recovery, intrinsic reconstruction, and probability layer | Existing coefficient replay is corroborative only | Repair tolerance and all-low-weight-dual-support machinery are prior or adjacent art | All three layers admitted |
| MDS local reconstruction | Complete common-core star-basis proof in C672 | `KERNEL`: prescribed minimum word, complete support clutter, spanning, exact radius, and double-dual recovery | None | MDS support clutter is generic; value lies in the coefficient reconstruction statement | Admitted page-2 headline |
| Exact pointed confinement and weighted transfer | Complete proof in current Section 3, including zero/singleton/multisupport partition and both recovery-data-equality inclusions | `RepairPorts.exactFunctionalStrata`, `RepairPorts.exactPointedConfinementAndTransfer` | None required | Concatenated-dual decomposition and fiber enumerator are prior art; the proof uses only the decomposition, not the enumerator | Retained body theorem |
| Multi-target exact confinement (C946 sequel; not a manuscript claim) | Human proof packet in `notes/2026-08-22-c946-multitarget-recovery-confinement.md`; independent cold reads pending | None | Exhaustive binary intrinsic and repetition-concatenation checks are corroborative only | Cooperative repair, kernel/span and normalized dual-row existence are prior (Rawat--Mazumdar--Vishwanath; Abdel-Ghaffar--Weber); arbitrary distinguished-set Tutte carriers are prior (Chaiken; Las Vergnas); GHW cooperative bounds and first-order MacWilliams counts are prior. The affine all-splittings refinement plus exact finite map cost and eventual threshold is `NONE-FOUND` in the bounded C946 audit, not a priority claim | Sequel research only; blocked from manuscript/Lean promotion pending cold reads |
| Strict weighted example | Conceptual Singer averaging and code deduction | `RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action` | None required | Natural strict example, not a new MDS construction | Retained secondary corollary |
| Prescribed positive-density realization | Complete trace-duality, exact-cost, two-inclusion, density, and scaled-parameter proof | `RepairPorts.eventually_pointedConfinement_iff_zeroCost`, `eventually_prescribedPorts`, `representedTargets_density`, `concatenatedRestrictedCode_parameters` | None required | Random GV and AG/TVZ outer-family existence are classical; the represented normalized-equation consequence uses no enumerator | Retained body theorem |
| Clebsch/MDS fingerprints | MDS common-core basis plus prescribed-recovery transfer; exact \(z_x\) specialization for Clebsch | `RepairPorts.eventually_mdsMinimumCoefficientFingerprints` | None required | Support-only MDS data is generic; the coefficient layer carries the represented geometry | General MDS corollary retained; Clebsch compactly derived |
| Reliability calculus | Complete finite-sum manuscript proof | `KERNEL`: deletion--contraction, pivotal derivative, Russo--Margulis, and minimum-blocker leading coefficient | Exact profiles are `CERTIFIED` appendix refinements only | Reliability, pivotality, Russo--Margulis, and blocker calculus are classical tools | Admitted body theorem |
| Bounded EXIT | Complete conditioning and event-difference proof | `KERNEL`: erasure-sign recurrence, radius filtration, and cheapest-radius transform | Exact finite curves are `CERTIFIED` appendix refinements only | EXIT is classical; finite radius is bounded-query decoding, not symbol-MAP or capacity | Admitted body proposition |
| Pointed Tutte specialization and filtration boundary | Complete termwise perspective/derivative/duality proof; explicit rank-four \(\mathbb F_7\) sparse-paving pair with a complete minor table | `KERNEL`: rank-sum specialization, derivative difference, general two-repair inclusion--exclusion, both symbolic curves, and their inequality in `RepairPorts.PointedTutte`; aggregate gate and axiom audit pass | Exact \(\mathbb F_7\) replay corroborates the human minor proof; the \(q=9\) comparison is illustration only | The polynomial is prior art; the bounded-radius non-determination is the paper-specific boundary | Admitted body theorem and proposition; C676 |
| Matched asymptotic separation and transfer synthesis | Complete sparse-paving, exact-cost, common-outer, parameter, density, and recovery-data functoriality proof | `KERNEL-CORE`: `RepairPorts.eventually_radiusThree_prescribedPortPair` plus the C676 reliability and general transfer/reliability terminals | Public field-seven replay checks the finite representations only | Random-linear outer-family existence is classical; the theorem claims matched global formulas and seed-profile equality, explicitly not large-code pointed-invariant equality or matched availability | Admitted main synthesis theorem and derived corollary; C939 |
| Cubic--axis recovery structure | Complete coordinate and combinatorial manuscript proof | `KERNEL`: code parameters, exhaustive small-repair classification, exact rows, and all-symbol strict gap in the printed range | Exact \(q=9\) rows are kernel checked but appendix-only | Classical geometry; exact repair rows and all-symbol separation are `NONE-FOUND` candidate contributions | Admitted as a subordinate application; C678 |
| Quartic--nucleus/harmonic recovery structure | Complete symbolic manuscript proof; classical nucleus/design sources reconciled at theorem/section level | `KERNEL`: determinant factors, projective Steiner completion, arbitrary-order harmonic-family characterization, no circuits below five, exact dual distance, pointed radius-four recovery families, and closure identities in `RepairPorts.HarmonicQuartic`; aggregate gate and axiom audit pass | \(q=9,q=27\) circuits and profiles are `CERTIFIED` appendix corroboration only | Classical geometry and design; complete radius-four repair interpretation is `NONE-FOUND` | Admitted body theorem; C677 |
| Harmonic closure and Poisson consequences | Direct nucleus-gate closure proof; probability statements restricted to consequences of the admitted recovery identities | `KERNEL`: all three abstract harmonic recovery-closure identities | Finite gate and error tables are `CERTIFIED` appendix evidence | Chen--Stein and design overlaps are classical; no threshold or completeness claim | Admit closure and general reliability consequences only; finite rows remain appendix |

## Promotion rule

A row leaves `BLOCKED-BODY` only when its human proof, exact Lean terminal,
adequacy comparison, and axiom audit all pass.  Replaying a certificate cannot
promote a row.
