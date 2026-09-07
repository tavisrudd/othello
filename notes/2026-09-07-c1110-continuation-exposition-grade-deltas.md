# C1110 — resumed exposition reassessment and grade deltas

Date: 2026-09-07. Earlier snapshot: authority `11e00a242`, 12-page PDF, 331605 bytes. Revised snapshot: authority `3ad9e3ce7`, standalone `9b83a53`, 12-page PDF, 335629 bytes. The parent independently checked snapshot/export identity and reports unchanged computational artifacts. This reviewer read the entire current manuscript and extracted text of all twelve current PDF pages, then consulted the earlier report `notes/2026-09-07-c1110-continuation-cold-exposition-grades.md`. No author revision notes were read. The previous manuscript remains available in this reviewer's conversation context.

This is a **resumed paired comparison by the same reviewer**, not a new cold or blind review. Familiarity itself makes a second reading easier, so the positive deltas below are tied to identifiable textual changes. No computation was regenerated, no research code or formal checker was run, no external literature was audited, and no manuscript was edited. PDF extraction was used only for reading; this report does not claim a fresh visual layout audit. This report is intentionally uncommitted for parent integration.

## Paired verdict

The revision is better, especially for adjacent-field readers. The substantive gain is that disciplinary translations now do mathematical work: the hypergraph comparison identifies the first reconstruction problem, the coding paragraph explains that adjacency already determines the full distance function, and the frame section explains how recovered partitions become the two isotopy equations. Moving the moduli comparison into optional background removes a costly detour from the introduction.

My overall exposition estimate moves from the 75th to the 80th percentile. Literature positioning moves from 65 to 75, conceptual motivation from 75 to 80, and adjacent-field accessibility from 65 to 75. Specialist clarity remains at 80: the original already had a clear specialist proof, and the principal audience gains less from these additions. The revision has not earned a higher novelty grade or a stronger correctness claim. Computational trust communication remains at 70 because the artifact-discoverability problem is unchanged.

No fatal main-proof defect or new load-bearing mathematical regression emerged from this paired read. The paper is a stronger candidate for external referee review, with modest remaining editorial issues and one practical submission issue. Further wholesale exposition revision would have low value.

## Calibration and all eleven dimensions

The comparator population is unchanged: **typical recent specialist finite-geometry/algebraic-combinatorics research preprints**, not all mathematical writing and not textbooks. Adjacent accessibility is judged for graph-theory/algebra graduate researchers against that same population. Midpoints and ranges are subjective expert estimates, not measured benchmarks, confidence intervals, probabilities of correctness, or acceptance probabilities. Delta means a change in the rounded midpoint, in percentile points. Overlapping ranges are intentional; a five-point paired improvement does not establish a statistically separated population rank. Overall scores are not arithmetic means.

| Dimension | Old midpoint (range) | New midpoint (range) | Delta | Reason for the paired judgment |
|---|---:|---:|---:|---|
| Specialist clarity | 80 (70–90) | 80 (70–90) | 0 | The theorem and essential proof were already clear; explicit coordinate matching helps, but the longer introductory explanations offset some expert-speed benefit. |
| Adjacent-field accessibility | 65 (50–75) | 75 (60–85) | +10 | Moduli language is optional and glossed; hypergraphs, Hamming distance, isotopy, and the coordinate-to-centre transition now have operational explanations. |
| Layered navigation | 80 (70–90) | 85 (75–90) | +5 | Related work follows the proof's actual hierarchy, and Section 9 visibly separates configuration-space background, stronger residual data, and open problems. |
| Conceptual motivation | 75 (65–85) | 80 (70–90) | +5 | The erased information is explicit, the individual-map extension is interpreted, and the code-distance viewpoint gives an adjacent researcher another concrete reason to care. |
| Proof transparency/rigour | 80 (70–90) | 85 (75–90) | +5 | `prop:normal` and the passage to `eq:mult`–`eq:shift` expose the central language change; `thm:recognition` now specifies closures and deduplication. This increase concerns transparency, not new correctness evidence. |
| Notation/definitions | 75 (65–85) | 80 (70–90) | +5 | Simple-graph conventions and the domains of the extremal maxima are explicit; isotopy is glossed and the misleading normal-form direction is corrected. A few minor wording issues remain. |
| Concision/style | 75 (65–85) | 75 (65–85) | 0 | Removing the unsupported complement-reconstruction detour helps, but repeated recovery summaries and a redundant row example consume the recovered space. |
| Computational trust communication | 70 (55–80) | 70 (55–80) | 0 | The sound separation of written proof and trusted finite computation is preserved; the PDF still names a public bundle without a repository/archive URL and fixed version. |
| Literature positioning | 65 (50–75) | 75 (60–85) | +10 | Hypergraph reconstruction is now the primary comparison, its threshold comparison is properly scoped, coding gives a substantive interface, and moduli no longer leads the relevance argument. Original sources remain unaudited here. |
| Overall exposition | 75 (65–85) | 80 (70–90) | +5 | The revision removes real entry barriers while preserving the short mathematical core; its remaining weaknesses are localized. |
| Submission readiness | 65 (50–75) | 70 (55–80) | +5 | Several precision issues are resolved, but artifact retrieval and a final focused wording pass remain. Venue fit, independently verified novelty, and computational correctness are not newly established. |

**Novelty remains ungraded.** Better explanation of relationships to cited work is not a verified absence of predecessors. Nothing in these deltas certifies the cited numerical threshold comparisons, the scope of an entire extension-theorem literature, or the sufficiency of the bibliography.

## Literature positioning and motivation: what changed materially

### Introduction, Related work

The old opening comparison with `M_{0,5}` asked the reader to change subjects before understanding why that comparison mattered. The current first paragraph instead describes the very hypergraph that drives `prop:intersection` and `lem:clique`. “A star clique consists of hyperedges sharing one symbol” makes the threshold comparison interpretable. Distinguishing the clique lemmas from the broader recognition theorem also prevents the reader from mistaking a local improvement from 14 to 10 for a replacement of a general recognition result. These are real gains in positioning, not just gentler wording.

The coding paragraph is the best new motivation. It spells out a nontrivial equivalence visible from the paper's own definitions: distinct words have only two possible distances, so the graph carries the entire distance function. This gives the extension theorem a second precise interpretation. The paragraph after `prop:intersection` supports that interpretation at general length k. No new external theorem is required for this observation.

The cross-ratio paragraph now leads with the common automorphism question and distinguishes adjacency constructions. It is a better relevance comparison than the old emphasis on vertex counts. The moduli interpretation remains available in `sec:remarks`, with an operational definition, without interrupting the main route. These changes justify +10 in positioning; they do not justify a top-decile estimate or an independently established novelty verdict.

One qualification remains: “MacWilliams-type extension results assume algebraic structure on the code and its isometries” sounds like a statement about an entire family of results. The paragraph specifically cites Dyshko, so the safest and clearest presentation is to attach the assumptions to the cited result itself. This review does not establish that the broad sentence is false; it establishes that its breadth is unnecessary to explain the comparison. “MDS” is also left unexpanded in the prose; either expand it or omit the acronym if no property of MDS codes is needed locally.

### Introduction, opening and post-corollary paragraph

The new explanation of what incompatibility erases makes the reconstruction problem concrete. The replacement for the old three-question taxonomy is more direct: a graph permutation initially preserves no supplied lines, so traces, centre classes, and field structure have to be recovered. The post-corollary text emphasizes individual maps and makes algorithmic recognition an actual consequence rather than a section pointer. Together these justify +5 in motivation.

The advance remains a well-defined rigidity result for a particular family, with an algorithmic consequence and exact small-order exceptions. The revision has not supplied broad applications or transformed its mathematical scope, and the grades should not imply otherwise. “The full symmetry of the encoded constraint system” mostly restates the automorphism theorem; it adds less than the adjacent code-distance interpretation does.

## Resolved earlier concerns

- `prop:normal` now gives the four coordinate-to-centre correspondences explicitly. The passage immediately before `eq:mult`–`eq:shift` explains the induced fibre permutations and why the quotient formulas must be consistent with the first two coordinates. This is the highest-value local proof change.
- `lem:frobenius` now recalls cyclicity of the multiplicative group. The extra interpretation before the exponent argument is accurate at the intended conceptual level and costs little.
- `cor:reconstruction` refers to `prop:normal` instead of saying “proved below.”
- `thm:recognition` explicitly deduplicates both families of closures and defines the five-seed operation. Soundness still rests on the final coordinate/adjacency check; the new text does not blur that boundary.
- `sec:def` makes the simple-graph/distinct-vertices convention explicit and supplies concise hypergraph definitions.
- `sec:remarks` specifies the maximization domains for `m(k)` and `r(k)`. `prob:extremal` now correctly says improvements *can* lower the corresponding bounds, avoiding the former claim about every improvement lowering the combined threshold.
- The stronger-complex paragraph no longer claims a reconstruction theorem under unstated large-order hypotheses. Its elementary comparison can now stand on its own.

## Regressions, costs, and highest-value remaining fixes

1. **Still unresolved: artifact retrieval, `sec:verification`, PDF page 12.** “The public bundle” and a relative verification README still do not identify a source from which a reader can retrieve the exact evidence. Add a stable repository/archive citation and fixed revision or release. This remains the highest-value submission fix and is why the computational-trust score receives no increase. No inference about whether a bundle exists elsewhere is needed: the PDF itself should locate it.

2. **More repetition in the introduction and at the end of `sec:def`.** The traces → centres → field-action chain now appears in the opening discussion, post-corollary strategy, size-gap example, and several related-work comparisons. Some recurrence is useful, but the end of the coding-related-work paragraph and the final sentence after `prop:intersection` both repeat the theorem after already explaining the distance interpretation. Retain the actual bridge and trim one repeated conclusion. This is why concision receives zero delta rather than an automatic gain for added accessibility.

3. **New imprecision in `thm:recognition`, “Complete the division table.”** The added sentence says missing symbols carry information lost by deleting `0,1` from the coordinate grid. The completion performed here adjoins the multiplicative identity `1` and restores the missing diagonal; it completes the table on `F_q^*`, not a table including zero. The displayed row-2 example is correct, but “deleting 0,1” is a less exact summary of what this stage restores. Say that the omitted row, column, and diagonal identify the missing identity entries of the multiplicative division table. The preceding general row-x explanation already contains the example's mathematical content, so the example could alternatively be removed. This is a local exposition regression, not an algorithmic defect.

4. **Scope the MacWilliams comparison to the cited theorem.** This is a small literature-positioning precision fix, not a request to reopen a broad search. Define or omit MDS at the same time.

5. **Minor first-use ordering.** The new opening uses “tangent” immediately before the next paragraph defines it. The delay is short and harmless for specialists, but relocating the gloss to first use would finish the adjacent-reader pass. This does not warrant a new explanatory paragraph.

The PDF remains twelve pages. Its text flow now places the algebraic conclusion and main-theorem proof on page 8 rather than page 7, while the small-order proposition and table are together on page 10. This is a reasonable redistribution: the inserted proof bridges earn their space, and the census reads as a unit. These observations concern extracted page flow, not visual rendering quality.

## Mathematical and evidence boundary

The clique bounds, recovery logic, punctured-isotopy argument, polynomial identity, semilinear extension, and uniqueness argument retain their previous mathematical structure. The new explanations make their interaction more accessible; I found no contradictory hypothesis or invalid inference introduced there. The corrected extremal-problem sentence is a real precision repair, but no central theorem was strengthened by it.

The parent reports that the boundary certificate, recognizer, and replay code are byte-identical to the earlier snapshot and that only the `prob:extremal` row changes in the claim-map comparison. I did not independently run those checks or repeat computations. The finite census remains computational evidence not replayed by this reviewer; novelty remains unaudited. Those limits are unchanged by the editorial improvements.

## Closeout: ej + tt and mystery ledger

The useful extra-value question is now how to preserve the explanatory gains without accumulating more summaries. The code-distance equivalence is the strongest new bridge; preserve it. The coordinate-to-centre and fibre-permutation explanations supply the key local understanding; preserve those too. The next inexpensive improvement is to trim duplicated conclusions while adding the missing artifact citation, not to create another overview, figure, or literature branch.

No new mathematical mystery emerged. The q=7 partition abundance and q=8 two-resolution phenomenon remain the explicit open problem `prob:boundary-proof`; this review supplies no new evidence resolving them. The artifact citation is an editorial deliverable, not a mathematical mystery. No further review scope is proposed.

Vibe check: noticeably easier for an adjacent researcher, better situated in the nearest literature, and still mathematically focused; keep the remaining pass small.
