# C1110 — final focused reader-polish reassessment

Date: 2026-09-07. Reviewed frozen authority commit `316953a30` associated with the 335531-byte, twelve-page PDF. This is a resumed, nonblind comparison with my previous paired assessment, not another cold read. Scope: the introduction, Section 2's code conclusion, Section 5's opening and surrounding statements, Section 7's table completion, and the established navigation. Read the corresponding source passages and extracted PDF pages 1, 2, 6, and 9. The parent owns visual layout/export checks. No author revision notes, external literature, research-code runs, computational replay, or formal checks were used. PDF extraction served only to read page flow. This report is intentionally uncommitted.

## Verdict

The final changes resolve the local wording concerns from the preceding review. The opening is more inviting, the coding comparison is more disciplined, and the division-table description is now exact. I find no substantial remaining reader-facing obstacle in the passages reviewed. The paper needs no additional overview, expanded tutorial, or new motivational section.

These are useful finishing changes within the previous score ranges, rather than another large improvement in relative standing. I would retain the current rounded grades instead of increasing them merely because another revision occurred.

## Updated estimates

The reference class remains typical recent specialist finite-geometry/algebraic-combinatorics research preprints. Adjacent accessibility is assessed for graph-theory/algebra graduate researchers against that same population. These are subjective estimates, not measured rankings, probabilities of correctness, or acceptance predictions. The readings are paired and nonblind. No new separate metric is introduced under the name “readability”: it is assessed here through the original adjacent-accessibility dimension.

| Dimension | Previous midpoint | Current midpoint | Plausible current range | Delta and reason |
|---|---:|---:|---:|---|
| Readability / adjacent-field accessibility | 75 | 75 | 60–85 | 0: the opening lowers the entry cost and the table wording is clearer, but these are small refinements to an already accessible route. |
| Interest / conceptual motivation | 80 | 80 | 70–90 | 0: the erasure experiment is a better invitation; the underlying question, examples, and consequences remain the same. |
| Concision/style | 75 | 75 | 65–85 | 0: useful repeated conclusions were cut, while the new opening and Section 5 bridge add some deliberate repetition. Net flow improves slightly without warranting a five-point rank change. |
| Literature positioning | 75 | 75 | 60–85 | 0: narrowing the coding comparison repairs an overbroad sentence; it does not establish new literature coverage or novelty. |
| Overall exposition | 80 | 80 | 70–90 | 0: the previous improvement is consolidated, with no substantial new architecture or proof-transparency change. |

Novelty remains ungraded. Other dimensions from the preceding report are not reassessed in this focused pass.

## What works, what is resolved, and the small remaining costs

1. **New opening, Introduction.** “Choose four points ... erase the plane” immediately gives an adjacent reader an object and an experiment. This is a better hook than beginning with general arc terminology. The subsequent definitions translate that picture without introducing a new subject, and “tangent” now receives its gloss at first use. Removing the game-origin sentence also keeps the first page focused on the actual static question.

   There is one small precision cost: “Does the remaining graph determine which of its symmetries come from the original geometry?” can suggest identifying a proper subgroup of geometric symmetries. The principal theorem instead says that every graph symmetry extends in its stated range. If making one final sentence edit, prefer: **“Must every symmetry of the remaining graph extend to a symmetry of the original plane?”** The theorem then gives the exact semilinear and field-order qualifications. The present question is understandable; it is not a substantial defect.

   The informal construction followed by its formal definition is mild repetition, but it earns its space for the adjacent audience. Do not add a third version. The theorem remains early on PDF page 2, so the new invitation has not buried the result.

2. **Related work, coding paragraph.** The comparison now names what Dyshko studies rather than asserting assumptions for the entire MacWilliams-type literature, and MDS is expanded. This resolves my earlier scope concern without requiring a new audit. The paragraph retains its substantive point: the graph specifies the distance function, while coordinate recovery belongs to the extension problem. The change is precise and useful.

3. **Section 2, after `prop:intersection`.** Cutting the repeated theorem conclusion was the right choice. The paragraph now ends at its own mathematical contribution: the graph retains all pairwise code distances while forgetting coordinate and symbol names. That is a satisfying endpoint and does not require another reminder of semilinearity.

4. **Section 5, `sec:obstructions`.** The new rows/columns → division → translated division paragraph explains why the small-arc results are here. It makes the section more interesting than a sequence of isolated counterexamples. Its overlap with the opening of `sec:frame` is noticeable on PDF page 6, but the two paragraphs have different local jobs: one interprets the obstruction, the other prepares the algebraic proof. Retain both unless a page-budget constraint forces a cut; neither needs expansion.

5. **Section 7, `thm:recognition`, “Complete the division table.”** The replacement correctly identifies the restored identity row, identity column, and diagonal of the multiplicative-group table. Removing the redundant row-2 example improves pace. This fully resolves the earlier concern about describing the operation as restoring information from deleting both 0 and 1. The clause “zero does not belong to this table” is mathematically accurate but optional: “division on F_q^*” already states the domain. It can be omitted for economy, but it causes no reading problem.

## Remaining priorities and stopping point

The author-owned artifact publication citation remains unresolved: Appendix A should eventually identify a retrievable, versioned bundle. That is still a submission task, but it is not a reason to keep rewriting the mathematical exposition.

The only reader-facing edit I would now prioritize is the more direct question at the end of the new opening. Beyond that, preserve the current structure and seek an actual new reader when another independent assessment is wanted. Repeated passes by this reviewer will increasingly measure familiarity rather than cold accessibility.

No new mathematical issue or mystery arose in this bounded review. The established q=7 and q=8 explanatory open problems remain outside this pass. The useful closeout observation is that the paper now has enough orientation; future additions should replace weaker sentences rather than increase the number of summaries.

Vibe check: the finishing changes help, the previous gains hold, and the exposition is ready to stop growing.
