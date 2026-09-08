# Referee follow-up on the complete-ports revision

Date: 2026-09-08

## Assessment

The revision addresses my prior referee comments and improves the paper's focus. The abstract now gives the problem, the exact equation-escape/composition result, the distinction between equation escape and a useful repair alternative, and the minimal-support transfer theorem with its direct operational consequences. It contains no secondary relative-weight hierarchy, contextual quotient, width bound, price-oracle equivalence, software promotion, or verification machinery. **I would keep this abstract.** I found no introduced theorem defect and request only one remaining qualification in the introduction's eventual-confinement sentence.

My recommendation remains acceptance subject to minor revision. After the sentence identified below is clarified, this follow-up does not call for further mathematical results or an additional abstract rewrite. It is a revision follow-up by the same referee, not a second independent cold read or an aggregate release decision.

## Scope and identity

I inspected the complete requested source diff from `c69f4913b4137180a69f0c365e425e390a46d443` to `e4c29b92f`, covering the main TeX file, information-hierarchy figure, sections, imported-source metadata, and release checker. I reread changed passages with their relevant definitions and surrounding claims. The working paper subtree matched the latter commit and was clean when checked. The revised PDF has 44 pages and SHA-256 `284f1d53c336820451a26a9138a9f7e1745e9d5e02af7d345dc57323a84721cd`.

I visually inspected revised PDF pages 1, 2, 3, 4, 10, 22, 23, and 38. The revised figure is legible; its dashed arrows no longer pass through the intermediate boxes. The main theorem remains on page 2, followed by an explicit heading identifying operational confinement as the second main result. The 44-page PDF agrees with the revised expected-page constant. I did not perform a full visual proofread, rerun the release verifier, execute examples or software checkers, or run Lean/lake. I did not read other referee reports or private repair notes. No new literature search was required; the source-pinpoint judgment relies on my recorded primary-source consultation in the original report.

## Abstract

The abstract is accurate at its intended overview level. The retained functional-label sentence explains the compositional issue without introducing formal notation. The exact minimum helper cost and associative witness reconstruction describe the first result. The sentence about dispensable external coefficients gives the mechanism separating the two confinement notions. The condition on outer dual words is presented as sufficient, with the strict bound greater than r+1 and the inclusive helper radius at most r correctly aligned. The ensuing reliability and allocation statements are immediate consequences of that main operational result, not a catalogue of secondary theorems. The last sentence reinforces the distinction without claiming an exact characterization of operational escape.

The count is 143 whitespace-separated words and 144 tokens under the release checker's actual word-count expression; both satisfy the existing 140–200 requirement. The final sentence is not so redundant that I would recommend deleting it merely for brevity, particularly given that lower bound. No padding or reintroduction of secondary machinery is needed.

## Disposition of my prior findings

| Prior comment | Disposition in this revision |
|---|---|
| Give operational confinement equal conceptual prominence | Addressed by the introduction's “second main result” heading, the revised Section 4 opening, and the explicit separation of the equation threshold from the first useful external repair. The text correctly says the target-touching criterion is sufficient. A new comparison table is unnecessary. |
| Explain generator coordinates, trace labels, and normalization | Addressed in Section 4, p. 10. The same identification transports the requested space and normalization, and the new sentence explicitly permits the section alpha to vary. This closes the reader-facing ambiguity without changing the minimization. |
| Tie implementation claims to inspectable contracts | Addressed as a documentation request in Section 5.6, p. 22. Named implementation files and the composition checker are linked to the artifact-version manifest; all seven named paths occur there. The paragraph explicitly does not claim a fresh execution audit. This improves inspectability without independently verifying the implementation. |
| Incorrect Kashyap pinpoint | Corrected in both Section 5.7, p. 23, and imported-source metadata to Section 2.4, equation (1), and Theorem 3.4. This matches the source checked in my original report. |
| Stale “next section” optimizer roadmap | Corrected to a reference to the existing optimization section. |
| Introduction promises measurements in verification section | Corrected: verification scope and artifact references are separated from measurements in software documentation. |
| Figure's source object omits nonzero fibres; arrows crowd boxes | Addressed. The top object now consists of blockwise coefficient lifts with labels; the caption explicitly includes nonzero fibres and states that compatibility and normalization select recovery systems. The revised routes are clear in the PDF. |
| Distinguish general theorem proofs from concrete arithmetic checks | Addressed in Section 10, p. 38, with separate statements about theorem proofs and displayed finite instances. |
| Optional compression of contextual overview and software-heavy conclusion | Addressed without deleting a needed hypothesis. The conclusion retains the fixed operational distinction and the interface-construction question. |

The Appendix A replacement of “Operationally” by “For this numerical escape observable” is also an improvement: it prevents numerical equation-context equivalence from sounding like equivalence of availability or allocation observations.

## One remaining actionable qualification

At the start of PDF p. 4, following the two hypotheses for a coefficient-preserving bijection, the introduction now says:

> This holds eventually at each fixed r when the outer dual distance tends to infinity.

The preceding sentence supplies the inner inequality, so a charitable contextual reading is correct. Nevertheless, the compressed sentence can be read as saying that divergence of outer dual distance alone eventually gives the bijection for every fixed radius. That reading is false. The inner inequality r < M_t(D_P,K_P) + d(I-perp) remains necessary in this outer-distance regime and cannot become true by increasing the outer length.

The manuscript's own running example demonstrates the distinction. Its local rank-one cost is one and its inner-dual distance is two. With the full outer code L^N, the outer-dual distance is infinity, yet a local recovery plus a weight-two inner-dual equation in another block is a nonconfined equation of helper cost three for every N at least two. Thus the claimed coefficient bijection fails at radius three at every length, although minimal-support transfer holds. If a sequence with finite dual distances is preferred, outer codes whose duals are length-N repetition lines have dual distance N and retain the same zero-sector obstruction for all sufficiently large N.

This is a misleading quantifier in the summary prose, not a counterexample to `thm:objectwise-confinement` or `thm:ranked-confinement`, whose hypotheses remain correct. The older sentence already relied on the preceding qualifications; the shortened replacement makes the risk more immediate. A precise replacement is:

> If the outer dual distance tends to infinity, its required bound eventually holds at every fixed radius r; the displayed inner inequality is still required for this bijection.

No change to a theorem or proof is needed.

## Closing recommendation

Keep the revised abstract and the substantive editorial changes. Clarify the single eventual-confinement sentence, then retain the present mathematical scope. The revision is responsive and sound; there is no reason from this follow-up to expand the paper or restore the removed secondary material to the abstract.
