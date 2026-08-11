# Paper V information-loss framing: blind A/B cold read

Date: 2026-08-11

## Protocol

I read only the two supplied PDFs, in randomized order **B, then A**, from page 1 through page 22 of each. I did not inspect TeX sources, Git state or history, notes, prior reviews, or artifact chronology. The comparative judgment below is therefore about the rendered manuscripts alone. SHA-256 hashes were recorded only after both reads were complete:

- A: `83f51b6f79bea157ab0f394750242f40910e27c12cf8711a918e073706a2586b`
- B: `daa4444dc62db320fda1d634bc566d4377898802357aef1c7ef0e89787d03403`

Scores use a 10-point editorial scale: 10 means submission-ready confidence or accessibility for the intended broad mathematical audience, not mathematical simplicity.

## Executive verdict

**Forced overall preference: B.** The mathematical body and formal theorem package appear the same for the purposes of this read, but B frames that package as a portable inverse/information-loss theorem rather than chiefly as the reconciliation of earlier papers in a series. It states the non-isomorphism caveat, selected-line hypothesis, residual `C2`, and independence of the Paper-IV comparison earlier and more explicitly. That materially lowers overclaim risk without weakening the result.

| Dimension | A | B | Forced choice |
|---|---:|---:|---|
| Specialist confidence | 9.0 | 9.3 | B |
| Generalist accessibility | 7.2 | 8.4 | B |
| Opening clarity/portability | 7.0 | 8.8 | B |
| Main-theorem findability | 8.6 | 9.0 | B |
| Standalone inverse-theorem reading | 7.1 | 8.8 | B |
| Precision/overclaim control | 8.8 | 9.4 | B |
| Conclusion strength | 8.4 | 9.0 | B |

The specialist-confidence gap is intentionally small: the proofs, definitions, formal statements, and trust boundary that drive confidence are effectively common to both PDFs. The larger gap is editorial.

## Forced-choice findings

### 1. Opening clarity and portability: B

B opens the introduction with a problem that travels outside the Clebsch series (p. 1):

> “Different lossy invariants of the same source need not look alike. The inverse question is whether they nevertheless retain equivalent information.”

Within the same paragraph it gives the answer and its exact boundary:

> “We prove that, after one chordal line is retained, either shadow reconstructs the other and their common six-axis carrier. Forgetting that line leaves exactly a `C2`-ambiguity. The result classifies information loss between inequivalent cubic shadows; it does not identify the cubics.”

This is an unusually efficient opening: problem, result, hypothesis, information-loss defect, and non-isomorphism disclaimer all arrive before the technical mechanism.

A instead opens (pp. 1–2):

> “An invariant can retain the correct symmetry and still be the wrong invariant.”

and then identifies the Paper-II signed matching tensor and says:

> “The purpose of this paper is to explain why that failure is exactly what makes the reconstruction work.”

That is memorable and mathematically intriguing, but “wrong invariant,” “Paper II,” and “that failure” require series context. A reader first encounters a reconciliation narrative and only later abstracts the inverse problem. B gives a general mathematical question first and then specializes it.

### 2. Speed and accuracy of locating the main theorem: B, narrowly

Both PDFs place Theorem 1.2 on p. 4, immediately after Definition 1.1, and both state the same equivalence, reconstruction outputs, and quotient. A specialist can locate the formal result quickly in either.

B nevertheless wins because its first introduction paragraph on p. 1 is already an accurate prose theorem. Its added “Reconstruction perspective” paragraph on p. 3 also previews the exact architecture just before the definitions:

> “After a chordal line is selected, the theorem constructs intrinsic reconstruction functors in both directions; without that selection, the correspondence is exactly a residual `C2`-quotient.”

Thus a skimming reader reaches the correct theorem twice—first conceptually on p. 1 and then formally on p. 4—without mistaking “chordal versus conference” for an isomorphism claim. A's “Series perspective” on p. 3 is accurate, but “exact marked forms of one carrier” is less immediately informative about the functors and quotient.

### 3. Standalone inverse/reconstruction theorem versus series reconciliation: B

B explicitly labels its p. 3 bridge paragraph “Reconstruction perspective” and says:

> “This paper asks when two different shadows encode the same source information. One is chordal, the other conference-type, and their projective geometries are not isomorphic.”

It then cleanly partitions the claims:

> “Papers I–III supply concrete sources realizing the two shadow types, but the classification itself is formulated on the fixed metric carrier.”

That sentence is the decisive portability improvement. It lets an adjacent-field reader understand the logical status of the series: the earlier papers supply realizations and retained bridge data; the intrinsic classification is a theorem on the fixed carrier.

A's corresponding p. 3 paragraph is titled “Series perspective” and begins by explaining what the Clebsch series asks, then describes Papers I–IV before saying what the present paper does. This is coherent for an existing series reader, but it makes the paper initially feel like a capstone/reconciliation document.

Neither manuscript is fully independent of the series in every result: Proposition 2.1 imports stable Paper-II outputs for the placement calculation, and Section 6 is intentionally source-specific. The correct standalone claim is narrower and strong: **the intrinsic selected-line classification, its exact forgetful fiber, and the integral theorem are formulated and proved on the fixed metric carrier; the source-placement and source-return results remain series-dependent.** B makes that division easier to see.

### 4. Mathematical precision and overclaim risk: B

The core precision is strong in both versions:

- **Chordal versus conference non-isomorphism.** On p. 10 both distinguish the conference cubic's six isolated nodes from the chordal cubic's curve singularity, so the lines are provably distinct. Both p. 5 scope paragraphs say the result does not identify the cubics. B improves the reader-facing guardrail by stating already on pp. 1 and 3 that the shadows are inequivalent and their projective geometries are not isomorphic.
- **Selected-line `C2` quotient.** Theorem 1.2(iv), p. 4, gives `Cconf(K) ≃ Cch(K)/<uq>` and identifies `uq:(L,h,c) -> (qL,-qh,c)`. Corollary 4.3 and the following paragraph on p. 11 show concretely why the line is not cosmetic: `h` and `-qh` have the same oriented conference companion. Page 13 then clarifies that the quotient is an action groupoid “including its morphisms and isotropy,” not merely an orbit set. The dependency table on p. 14 prevents the several `C2` choices from being falsely treated as independent. This is excellent overclaim control in both PDFs.
- **Paper-IV `C3` comparison.** Section 10, p. 20, is careful in both: Paper IV has “different groups, modules, bases, and geometries, and no map between their carriers is asserted.” B also states this independence on p. 3 before the reader can infer a geometric arrow from the series figure: Paper IV supplies an “independent `C3`-Frobenius instance ... with no common geometric carrier asserted.”
- **Scope and base change.** Both restrict to neutral scalar extensions of the fixed quadratic carrier rather than arbitrary twisted forms. B's p. 5 heading “Scope and exact information loss” and phrase “These boundaries record the information actually present in the shadows” more clearly present the qualifications as part of the theorem rather than after-the-fact caveats.

The remaining overclaim risk in both is mainly rhetorical, not formal. Phrases such as “equivalent source information” can be read too broadly unless the reader retains Theorem 1.2(iii) and Corollary 6.1: the inverse returns retained bridge data, not unretained source-local charts or global covers. B manages this risk better because it repeats the boundary in the opening and scope paragraph.

### 5. Conclusion strength: B

Both conclusions begin with the excellent sentence (p. 21):

> “The scattered shadows gather on one carrier, but not by becoming equal.”

Both then restate the reconstruction chain and the exact selected-line/`C2` distinction.

B's second paragraph is the stronger submission ending because it converts the example into a carefully modal principle:

> “Distinct shadows need not become isomorphic in order to encode equivalent source data; what matters is whether their residual ambiguity can be isolated and rigidified.”

It identifies the upper `C2` and independent Paper-IV `C3` cases, then concludes that sparse invariants **can** retain a source up to residual Galois-type rigidification. “Can” is appropriately restrained.

A's ending has a real virtue: it more explicitly revisits the rank-five/rank-six lattice distinction and normalization-before-reduction. But its final sentence—“the series ends ... with a structural answer to its recurring question”—returns the paper to series-capstone framing. For a standalone submission, B's conclusion more directly cashes out the paper's general theorem and reprises the crucial non-isomorphism caveat.

### 6. Overall submission preference: B

B should be the submission version on framing grounds. The changes visible in the PDFs do not merely make the prose more general; they give a more accurate logical map:

1. two non-isomorphic shadows;
2. a selected marking that produces equivalence of reconstruction groupoids;
3. an exact residual `C2` after that marking is forgotten;
4. concrete source realizations from Papers I–III rather than dependence of the classification on their narrative;
5. a separate Paper-IV `C3` example sharing only the residual-field mechanism.

That map is exactly what an editor, referee, or adjacent-field reader needs in order not to overread the claims.

## Relative regressions and tradeoffs

Because this was a chronology-blind test, these are comparative costs in B relative to A, not claims about which artifact came later.

1. **A has the sharper dramatic hook.** “An invariant can retain the correct symmetry and still be the wrong invariant” is more memorable than B's general opening. B is clearer and more portable, but a little less distinctive in its first sentence.
2. **B repeats the architecture more.** The abstract, opening paragraph, four-step explanation, p. 3 “Reconstruction perspective,” figure caption, and p. 5 scope paragraph all revisit related boundaries. The repetition is useful for cold readers, but the p. 3 paragraph could feel like one preview too many to a specialist.
3. **B's conclusion gives less airtime to Theorem 1.3.** A's final paragraph explicitly recalls the rank-five/rank-six distinction and the normalization-before-reduction mechanism. B's conclusion foregrounds the general information-loss principle, leaving the substantial integral theorem less visible at the very end.
4. **The abstract remains specialist-dense in both.** B's improved introduction does not change the abstract, whose first sentence starts with the quadratic augmentation module of six Sylow-5 subgroups and whose remaining claims move rapidly through chordal cubics, two-graphs, D-type lattices, and modular extensions. A generalist will still need the first introduction paragraph to learn the portable question.

None of these costs reverses the preference. If combining virtues were allowed, the ideal would preserve B's problem-first opening and conclusion while recovering one compact sentence in the conclusion about the rank-five/rank-six lattice distinction.

## Editorial bottom line

**Choose B.** It makes the central contribution legible as a standalone inverse/reconstruction classification while keeping the series realizations and the independent Paper-IV analogy in their proper logical places. It also gives the earliest and clearest protection against the three most likely misreadings: that chordal and conference cubics are being identified, that the selected line is inessential, or that the Paper-IV `C3` phenomenon lives on the same carrier.

Vibe check: B feels submission-ready in framing; A feels mathematically strong but more like a series finale addressed to readers already inside the project.
