# Complete-ports: Astra interim revision follow-up

Date: 2026-09-07. Reviewer: GPT-6 Astra.

This is a follow-up to my journal-style report, not a fresh cold read. It assesses the revised sources inspected during the current editing pass; subsequent changes and the forthcoming rebuilt PDF are outside this assessment. Line references below are to the source version inspected, relative to `papers/complete-repair-ports/`.

## Overall assessment

The revision substantially addresses the requested change of focus. The Ergodis section now explains the mathematics embodied by the software and what retaining the corresponding information enables. Its organizing questions are composition, reconstruction, repricing, availability, capacity sharing, and verification. The unrelated system-feature inventory has been removed. The section can now be read as an algorithmic development of the recovery theorems rather than a catalogue of a separately developed platform.

The introduction is also more effective: the ordinary and target-normalized fibre costs, outer compatibility condition, and complete two-sector Gamma formula now precede the main theorem. The result is evaluable at first presentation. The distinct minimal-support theorem follows immediately, with the deletion mechanism explained. These changes repair the principal opening and hierarchy concerns in my journal report. A targeted recheck confirmed that the initially ambiguous map domains and missing checker-contract reference were repaired during this pass. The remaining substantive source point concerns attribution of benchmark effects, not a counterexample to the core theorem.

## Remaining substantive points

**BENCHMARK-ATTRIBUTION — distinguish a comparison of complete approaches from isolation of a component.** The protocol rewrite at `sections/07-verification-provenance.tex:113–131` resolves the previous in-process/external-time and sample-count conflicts in the prose. However, lines 108–111 and 133–135 still describe separating the compiler from the residual engine, while the retained tower comparison explicitly lacks a rerun of the labelled-table control (lines 140–141). The benchmark figure caption still says that the direct-CP-SAT comparison “isolates the reduction supplied by the closure theorem” (`figures/ergodis-benchmark-highlights.tex:33–35`). Describe the displayed result as a comparison of the composed approach with direct CP-SAT, or identify the matched-preprocessing comparison actually supporting the stronger causal wording. This does not require more benchmarking to finish the prose revision; narrowing the claim is sufficient. These references describe the last source passages inspected, before the parent's announced attribution edit.

## Strong passages and confirmed corrections

- **The exact introductory statement:** `compositional_recovery.tex:99–150` now gives the actual optimization and explains why the zero sector needs the additional nonzero-kernel cost. This is materially better than a theorem whose value was defined only schematically. The shared-kernel-cost correction also appears in `sections/03a-exact-recovery-optimization.tex:91–99` and in the information-hierarchy figure.
- **The minimizing-map domains:** a targeted recheck of introduction lines 107–110 confirmed explicit domains and the statement that only the displayed constraints are imposed. Thus the nonzero mu fibres do not accidentally inherit the inner-duality constraint. With these domains, the introductory formulas agree with the body definitions.
- **The operational contrast:** introduction lines 152–167 explain what deleting the external helpers accomplishes and why minimal-support transfer needs a different hypothesis. This passage presents both the theorem and its practical significance without overclaiming coefficient preservation.
- **The Ergodis opening:** `sections/03a-exact-recovery-optimization.tex:4–22` connects the retained mathematical data to the queries those data can answer. The progression from fibre minima to support alternatives and overlap is now a clear reason for the subsequent results.
- **The workload discussion:** lines 296–315 connect pricing, support alternatives, shared capacities, and changed observations. In particular, the qualification that fractional completeness needs an oracle for the full admitted family is useful mathematical content, not an implementation disclaimer.
- **Witnesses versus optimality:** lines 317–323 state the distinction concisely. The preceding transition-potential argument gives a concrete mechanism for the optimality side rather than treating a feasible witness as proof of optimality.
- **The checker destination:** the newly added `sections/07-verification-provenance.tex:13–21` supplies the promised executable-contract distinction and reserves source lowering and domain optimality for separate justification. This closes the forward-reference gap without reinstating the system inventory. Lines 4–11 now identify an artifact manifest and versioned Lean companion; the identities themselves are being checked separately by the parent.
- **Prior local corrections:** the F4 table now explicitly uses the coordinate-dot-product functional identification and explains its common trace rescaling; the one-coordinate proof now makes minimal-support equality a consequence rather than an equivalent condition. The simplex characterization now fixes dimension and lower code and gives the averaging and hyperplane-multiplicity argument. These changes address the corresponding findings in the original report without weakening the intended conclusions.
- **The numerical contextual contract:** introduction lines 221–224 now state the same-leaf qualification and identify the observation as the numerical escape response. This addresses the previous ambiguity about arbitrary new prices or support observations.

## Optional finishing edits

The abstract still reads partly as a catalogue of all results; a shorter selection of principal outputs would strengthen the new hierarchy. The pipeline figure retains general phrases such as “admitted state,” “classes,” and “admitted updates.” Its caption is better tied to the mathematics than those node labels; concrete recovery labels, feasible supports, selected lifts, and checked bounds would match the revised section more closely. Neither point is a correctness defect.

For a fully self-contained main statement, add one sentence specifying that a global normalized system is a linear map into the concatenated dual whose target coefficient map still satisfies G_P alpha = id_T. In the introductory proof summary, “each minimum is attained” should read “each finite minimum is attained,” since an empty constrained fibre has value infinity. At the end of `03-positive-density.tex`, “These data's coarsenings” is awkward; “Coarser summaries of these data” is clearer.

## Coverage and limits

I initially read the revised main TeX (302 lines), the full optimization section (324 lines), the full verification section (177 lines), and the three included figure sources. I then rechecked the updated introductory definitions and the verification section's added artifact/checker paragraphs and benchmark passages. I inspected the scoped changes to `03-positive-density.tex` and `06-geometric-flagships.tex` against the previously read versions. I did not reread every unchanged theorem proof, inspect artifact manifests or executable source, rerun experiments or Lean, retrieve literature, or inspect a rebuilt PDF. This is therefore an interim source-level disposition, not a release recommendation or a renewed empirical/formal verification verdict.

No manuscript edits or commits were made by this review. The earlier reports remain unchanged.
