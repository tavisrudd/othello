# Second cold prose read: arcs complete outside a conic

Date: 2026-07-15  
Manuscript: `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex`  
Reading posture: finite-geometry/coding-theory journal reader/referee

## Scope of this note

This is an independent exposition review of the manuscript in reading order. I did not inspect prior reviews, handoffs, archives, repository history, or diffs. I did not rerun or recheck any finite-field calculation, classification count, certificate, digest, or Lean result. Remarks below about proofs concern what the prose makes easy or hard to follow; they are not a fresh correctness audit. In particular, a sentence described as convincing or clear means that its argumentative role is communicated well, not that the underlying computation has been independently verified here.

Stable anchors below use section/statement labels and distinctive opening phrases so that they remain useful after line movement.

## Headline assessment

The manuscript has a strong publishable expository core: the prescribed-hole defect identity is motivated economically, derived from familiar moments by a clean exact remainder, and specialized to a conic with a good explanation of what each loss term measures. The paper also does a notably good job of separating universal secant overlap from genuinely conic-specific geometry. For a specialist finite-geometry or coding-theory venue, the level of definition and proof detail is generally appropriate.

The principal remaining weakness is not local sentence quality but hierarchy. The paper currently advertises and develops at least four stories: the general defect identity, the conic lower/upper bounds, the certified (q=16) classification, and the exceptional (q=11) coding/icosahedral structure. All are interesting, but the abstract and final third make them compete for attention. The cleanest narrative is already latent: universal moment identity -> conic consequences -> mechanisms beyond the scalar inequality -> certified small-field cases. The coding dictionary and the elaborate (q=11) extension complex should be explicitly subordinated to that spine or presented as a clearly signposted second application.

## Sequential paragraph-level reading notes

### Title and abstract

- **Title, `Arcs complete outside a prescribed conic` / subtitle.** Clear, searchable, and accurate. The subtitle usefully signals both the conceptual theorem and the exact finite result, although it is long. For a journal article, this is acceptable; if brevity is desired, “A defect identity and the case of \(\F_{16}\)” would retain the hierarchy more sharply.

- **Abstract, opening `Let \(\cC\) be a nonsingular conic...`.** Strong opening. It defines the object and invariant before making claims, and “secants cover every point outside” is immediately intelligible to the intended reader.

- **Abstract, `Starting from the classical first two equations...` through the boxed conic inequality.** This is the best part of the abstract: provenance, novelty, and principal formula are adjacent. “Exact defect identity,” “equality,” and “stability” are informative, though all three are announced before the reader has a feel for which is the main deliverable.

- **Abstract, `In particular...` and `Conversely...`.** The lower/upper asymptotic picture is compact and well balanced. The phrase “moves it off \(H\)” is slightly informal beside the rest of the abstract; “has a projective image disjoint from \(H\)” is equally short and more precise.

- **Abstract, `We also derive...` through the end.** Overloaded. This passage moves through the nucleus, evaluation obstruction, four exact values, 2633 projective classes, supplementary checkers, Lean, syndrome collisions, non-GRS codes, deep holes, and an icosahedral complex. Each item is intelligible, but collectively they obscure which result should govern the reader’s expectations. The final sentence in particular carries too many unfamiliar nouns and reads like a second abstract compressed into one sentence. Keep the \(q=16\) certified-classification sentence; reduce the \(q=11\) material to one subordinate clause or omit it from the abstract.

### Introduction (`sec:introduction`, unlabelled section beginning at `An arc in a projective plane...`)

- **Opening paragraph, `An arc in a projective plane...`.** Clean specialist entry. It defines completeness by both maximality and secant coverage, then locates the topic in adjacent literature without an unnecessary historical survey.

- **Paragraph `Fix a nonsingular conic...` and Definition `def:relative`.** Excellent transition from the standard object to the new one. The definition contains the invariant and uncovered locus in one place and ends with the exact equivalence needed later. This paragraph should be preserved nearly as is.

- **Paragraph `The minimum in Definition... is attained.`** Correctly anticipates a small foundational question, but it interrupts the conceptual introduction for a point most readers will take for granted in a finite plane. It could be folded into one sentence after the definition or omitted. The following paragraph already supplies the more useful maximality interpretation.

- **Paragraph `Equivalently, \(A\) is maximal...`.** Strong. The projective equivalence observation efficiently explains why the invariant is well defined independently of the chosen conic.

- **Paragraph `The problem differs from two nearby standard notions.`** Valuable terminology control. The three comparisons prevent predictable misreadings. Sentence load is moderate but appropriate for specialists. “prescribe a one-dimensional set that must be covered” versus “an exceptional set that may remain uncovered” is especially effective.

- **Paragraph `There is also classical work on complete exterior sets...` and the three displayed implications.** Conceptually strong and visually memorable. This is the most helpful comparison in the introduction because it explains the later \(q=11\) coincidence. The sentence “The strict \(q=7\) example” is premature terminology: “strict” has no immediate referent until the reader recalls the two inclusions. Prefer “The strict containment at \(q=7\)...”.

- **Paragraph `The point index with respect to an arc...` through the four-item contribution list.** Strong motivation for the main theorem. “The inequalities normally used to control overlap have an exact remainder” states the conceptual novelty better than the title alone. The list is well sized and gives the paper a spine.

- **Paragraph `We then develop three applications...`.** Useful roadmap, but the order named does not quite match the order read: coding comes before conic specialization and the nucleus, while the evaluation interpretation reappears much later. State the actual section order or reorganize the sections.

- **Paragraph `The classical inputs are...`.** Admirably explicit about provenance and contribution. “Known \(q=11\) Clebsch geometry” is specialized but later supported. This paragraph would be even more helpful if it named the principal theorem as the main result and the \(q=11\) structure as an application, establishing hierarchy before the paper branches.

### Classical secant equations (`sec:classical`)

- **Opening `Throughout the remainder...`.** Efficient notation setup. The shift from \(\PG(2,q)\) to an arbitrary projective plane is worth highlighting because it demonstrates that the defect theorem is incidence-theoretic; the current wording lets that generality emerge naturally.

- **Lemma `lem:max-index` and proof.** Ideal short proof: one geometric observation, one conclusion. “use pairwise disjoint pairs” is concrete and avoids excessive formalism.

- **Proposition `prop:moments`, first proof paragraph.** Clean standard count.

- **Proposition `prop:moments`, second proof paragraph beginning `For (2.2), count...`.** Strong exposition of the less immediate count. The forward and converse directions are balanced, and the reason the intersection lies outside the arc is stated rather than left implicit.

- **Closing `Only the projective-plane axioms...`.** Excellent scope sentence. It tells the reader exactly how far the theorem generalizes and identifies the axiom that would fail elsewhere.

### Prescribed-hole defect (`sec:defect`)

- **Opening `The next theorem is stated for an arbitrary exceptional point set.`** Crisp and helpful. It delays the conic exactly where the argument does not need it.

- **Notation paragraph beginning `Let \(\cH\subseteq...\)`.** Dense but controlled. The gloss immediately following the definitions is essential and sufficient. “required locus” is intuitive; it would help to use that phrase consistently when \(V_{\cH}(A)\) reappears.

- **Split-moment paragraph `Splitting Proposition...`.** Natural bridge; no motivational padding needed.

- **Theorem `thm:defect`.** The theorem statement is admirably self-contained. Boxing the exact remainder, rather than merely its inequality consequence, correctly emphasizes the contribution. A short sentence immediately before the theorem could preview the two endpoint patterns \(\{1,m\}\) and \(\{0,m\}\), but the current statement is already readable.

- **Proof of `thm:defect`, paragraphs `Only points...`, `By...`, and `Substitution...`.** Very clean algebraic exposition. Each displayed manipulation has a declared purpose, and the last sentence ties nonnegativity to the earlier geometric bound. This proof is an expository high point.

- **Corollary `cor:coverage` and proof.** Clear and appropriately terse. The equality criterion is stated in the same place as the inequality, which makes the later stability discussion meaningful.

- **Transition `For later use, we record...` and Corollary `cor:arbitrary-holes`.** Good sequencing. The corollary makes the general theorem operational before specializing the geometry.

- **Transition `The exact remainder also quantifies near equality.` and Corollary `cor:stability`.** Excellent motivation in one sentence. The sets \(M\) and \(J\) have terse names, but the final interpretation supplies the semantic content.

- **Closing `Thus small defect forces...`.** Strong interpretive paragraph. “almost every” is justified in the quantitative sense by the preceding bound; the sentence explains what stability means geometrically instead of merely restating the inequality.

### Coding interpretation (`sec:coding`)

- **Opening `We record the standard arc--code dictionary...`.** Locally clear and well sourced. The definition of projectively GRS is careful and useful for the later \(q=11\) claim.

- **Placement of the section.** This is the most noticeable flow problem in the first half. The manuscript has just built momentum from arbitrary holes toward the promised conic specialization; a full coding section delays that payoff. Because almost all conic-specific conclusions are still ahead, the reader momentarily loses the main question. Either move this section after `sec:conic` (or after the transfer/nucleus material), or add a stronger opening explanation that the syndrome interpretation will be used substantively in the finite examples rather than serving only as an optional dictionary.

- **Proposition `prop:syndrome-dictionary`.** Substantively well organized. Item (iii), the exact \(\binom{k}{3}\) count, is surprising enough to merit the proof it receives. The warning that “deep-hole directions” requires separately established covering radius is excellent terminological discipline.

- **Proof of `prop:syndrome-dictionary`.** Compact but sentence-heavy. The first four sentences each change representational weight and geometric case; a paragraph break before “If neither case occurs” would help. The citation-heavy final sentence is useful but could be separated from the direct proof.

- **Closing `Thus \(r_A(x)\) is not merely...`.** Strong conceptual payoff. The first-moment/second-moment/collision trichotomy makes the coding section earn its place. The paragraph is long and contains three levels of interpretation; splitting before “The first moment counts leaders” would let that final synthesis stand out.

### Conic specialization (`sec:conic`)

- **Opening notation and `cor:conic-bound`.** Clear and direct. The double expression for \(I_{\cC}(A)\) immediately gives both point and line interpretations.

- **Paragraph `The first correction...`.** Excellent one-sentence interpretation of the two losses. It should remain close to the displayed inequality.

- **Definitions of \(L_1,L_2\), parity forms, and comparison table.** Appropriate computational detail for a specialist paper. The integer-arithmetic note is useful for reproducibility. The table is small enough to illuminate rather than distract, and the \(q=16\) sentence previews the classification gap.

- **Theorem `thm:asymptotic`.** Clear statement and good choice to state both explicit and liminf forms.

- **Proof of `thm:asymptotic`, opening through `write \(k=s+a\)`.** The initial case split is efficient, though the sentence proving \(k\ge s\) is heavily packed with inequalities. Two sentences would reduce the load: first assume \(k<s\) and note \(k\le q\); then compare the two sides.

- **Proof of `thm:asymptotic`, polynomial expansion and coefficient bounds.** The exposition is serviceable but feels verification-oriented: the exact cubic polynomial appears without an indication of why the crude constants are chosen. Add a sentence such as “Only the leading coefficient matters asymptotically; we bound the remaining coefficients uniformly on \(0\le a\le2\).” That would make the calculation feel designed rather than dropped in.

- **Remark `rem:scale`.** One of the strongest paragraphs in the paper. It identifies precisely what the conic incidence term can and cannot accomplish, prevents overclaiming, and motivates the later algebraic/classification mechanism.

### Transfer (`sec:transfer`)

- **Theorem `thm:transfer` and proof.** Elegant and proportionate. The one-line expectation argument needs no more detail for the intended audience.

- **Corollary `cor:conic-transfer` and proof.** Clean specialization. “More generally” is accurate but slightly odd inside the conic corollary because the generality is really about any complete \(b\)-arc against the prescribed conic; still clear.

- **Kim--Vu paragraph and `cor:kim-vu`.** Good use of an external theorem: the dependency is explicit and the consequence immediate.

- **Closing `The transfer does not exploit the conic...`.** Strong calibration of the result’s likely sharpness and practical value.

### Even characteristic (`sec:nucleus`)

- **Opening nucleus facts.** Appropriate reminder; specialists know them, but the exact tangent characterization is used immediately.

- **Proposition `prop:nucleus-in` and proof.** Clear two-case line analysis. The parity explanation is especially concise.

- **Proposition `prop:nucleus-out` and proof.** Parallel structure makes comparison easy. “The nucleus is a required point” effectively reconnects the section to the relative-completeness definition.

- **Corollary `cor:even-loss`.** Correct level of prominence for the universal consequence.

- **Closing paragraph beginning `These two cases are useful structural reductions...`.** Very good negative guidance. The concrete \((16,8)\) comparison prevents the nucleus section from seeming like a route to the claimed exact result and sets up the need for the classification.

### Verified finite-field examples (`sec:examples`)

- **Opening `The verified values at \(q=8,9,11\)...`.** Good summary of which conclusions are witness-plus-bound and which need classification.

- **Paragraph `Complete exteriority supplies a useful foil.`** The geometric comparison is worthwhile and closes a loop from the introduction. However, the four-arc calculation arrives just as the reader expects the \(q=16\) mechanism. Consider moving this paragraph to the end of the introduction’s complete-exterior discussion or to the \(q=11\) subsection. Here it delays the announced classification.

#### Evaluation obstruction

- **Opening two paragraphs (`The algebraic rejection...`; `Indeed, if an arc...`).** Strong motivation. The first establishes literature context and notation; the second explicitly connects the abstract linear algebra to the relative-conic problem.

- **Lemma `lem:evaluation-obstruction` and proof.** Clean and useful. The two alternatives are easy to distinguish: full rank versus forced vanishing at an arc point.

- **Paragraph `For the full system of degree-\(d\) forms...`.** Strong translation into Veronese language. It gives the reader the exact size of the finite certificate in the quadratic case without overexplaining linear algebra.

- **Transition `The following sharp form...` and Proposition `prop:evaluation-dichotomy`.** The more general proposition is mathematically natural, but in the narrative it temporarily expands away from the \(q=16\) goal. Make its role explicit: is it needed later, or included because the obstruction has independent value? If the latter, a remark after the classification or a short standalone subsection would keep the main proof moving.

- **Proof of `prop:evaluation-dichotomy`.** Concise and readable. The union-size calculation is the one place where a reader may pause; it is appropriate for the target venue.

- **Closing `Taking \(\nu\) to be...`.** Helpful recap, though “one-selected-point exclusion mechanism” is slightly mechanical phrasing. “Lemma ... handles the single forced arc point” would read more naturally.

#### Small values and \(q=16\)

- **Proposition `prop:small-values` and proof.** Exactly the right level of detail: the lower bound and witness source are identified without repeating certificate material.

- **Theorem `thm:q16-quadratic` statement.** Strong formulation. Explicitly including singular quadratics closes an obvious loophole.

- **Proof of `thm:q16-quadratic`, step one beginning `First, canonical augmentation...`.** The prose supplies the right trust story—enumeration sizes, coverage certificates, transport, and independence from canonical labels—but the paragraph is extremely compressed for the load it bears. A reader needs a little more orientation to distinguish (a) generation, (b) exhaustiveness certification, and (c) agreement with the published count. Bullets or three short sentences with these roles named would improve confidence without adding technical detail.

- **Same proof, step two beginning `Second, for 2630...`.** Excellent compact statement of the certificate split. It ties directly to the two alternatives of the preceding lemma.

- **Same proof, step three beginning `Third, the obstruction is projectively invariant.`** Clear transport argument. The final appendix pointer appropriately locates the trust-boundary detail.

- **Corollary `cor:q16-exact` and proof.** Very clean payoff. The logical link between relative completeness and containment of the ordinary-uncovered locus is restated at exactly the right moment.

- **Paragraph `The published ordinary classification records...`.** Useful novelty claim, but it would be stronger before the theorem proof or folded into its first step. In its current position it reads as an afterthought.

- **Remark `Anatomy of the three exceptional leaves`.** Interesting and appropriately labeled as unused. For a specialist venue, this level of detail is acceptable because it explains the only exceptional certificates geometrically. The raw coefficient vectors are dense; keeping them in an appendix would sharpen the main narrative if space is tight.

#### \(q=11\) coding application

- **Statistics table and paragraph `The row at \(q=11\)...`.** The table is useful, though placing all four fields under a \(q=11\) heading is slightly awkward. The derivation of \((N_1,N_2,N_3)\) is crisp and reconnects to the moment equations.

- **Proposition `prop:q11-code`.** Substantively strong, but the terms “projectively non-GRS,” “covering radius,” “deep-hole syndrome locus,” affine cosets, and leader multiplicities arrive together. The earlier coding section makes them legitimate, yet a one-sentence geometric summary before the proposition would tell geometry-first readers why the result matters.

- **Proof of `prop:q11-code`.** The argument is readable but overloaded in its final five sentences. Separate the MDS/non-GRS verification from the syndrome-spectrum consequences. The phrase “The index-zero directions give the covering radius” is too compressed expository shorthand; say explicitly that their existence yields distance-three cosets, while the codimension-three dictionary gives the upper bound three.

- **Proposition `prop:q11-extensions`.** This is the point where the paper most resembles a second article. Part (i) combines a complex identification, its independence polynomial, maximal-extension counts, completeness, and a nonextension statement; part (ii) adds an edge-colouring/perfect-matching structure. All are attractive, but their relation to the title theorem needs one explicit framing sentence. If retained in the main text, state that the relative-complete seed confines every extension to the conic, turning the residual geometry into a finite graph.

- **Proof of `prop:q11-extensions`.** Compact and logically staged. The key sentence “Relative completeness confines every further extension point to the conic” is the conceptual bridge and should occur before, or immediately after, the proposition rather than halfway through its proof.

- **Historical paragraph beginning `The six-set is a classical Clebsch hexagon...`.** Important provenance, but it comes too late. The reader learns only after two propositions that the configuration is classical and which pieces are new. Move at least the first two sentences before `prop:q11-code`; then conclude afterward with the precise novelty in syndrome and simultaneous-extension terms. “Chord-defect identity” is not a term introduced earlier and may be confused with the paper’s prescribed-hole defect; name the exact count or citation more explicitly.

- **Closing appendix pointers.** Clear, though the second sentence confirms that the game consequence is auxiliary enough not to require a main-text proposition.

### Further questions

- **Opening and seven Problem environments.** The problems are concrete and genuinely arise from the paper. The strongest are the \(q=16\) obstruction beyond even order, \(O(\sqrt q)\) construction, and equality/bounded-defect classification. Seven separate problems create a long decelerating tail. Group them under three themes—algebraic obstructions, asymptotic construction, and extensions/generalizations—or retain only four in the article and move the rest to a final remark.

- **Final paragraph `The central distinction is between universal overlap...`.** Excellent conclusion. It restates the paper’s conceptual contribution, explains why further progress requires a different mechanism, and ends forward rather than merely summarizing. This should remain the final main-text paragraph.

### Appendices

- **Appendix `app:verification`, witness-verifier paragraph and digest.** The checklist is useful and appropriate. It clearly distinguishes witness certification from exhaustive search. The literal SHA-256 hashes provide strong artifact identification, but their repeated display interrupts prose and will be brittle across packaging changes. A single manifest table or supplementary archive citation would be easier to maintain.

- **Same appendix, `Two further implementations independently regenerate...`.** The independence/adversarial-control explanation is unusually thoughtful and gives real information about validation quality. The succession of filenames and full hashes, however, dominates the paragraph visually.

- **Same appendix, classification generator and Lean paragraphs.** The trust-boundary sentence—generator assertions and labels are not trusted—is excellent. The Lean paragraph is appropriately detailed for a certified classification paper, but it reads partly like a project inventory. For the journal version, organize by claim and trusted evidence rather than by implementation: witness checks; generic theorem formalization; \(q=16\) exhaustive certificates; \(q=11\) structural checks. This would improve proof/computation balance without reducing transparency.

- **Appendix `app:game`.** The prose is clear and the graph argument is attractive, but the residual-game result lies furthest from the manuscript’s advertised scope. An appendix is the right place if it must remain, yet for a finite-geometry/coding journal it is a plausible candidate for supplementary material or deletion. Its last sentence about the \(q=9\) arc being terminal feels especially disconnected from the appendix’s stated \(q=11\) purpose.

- **Appendix `app:witnesses`.** Appropriate, concise, and reproducible. Each field encoding precedes its coordinates, and the standard conic is stated once. This is exactly the sort of concrete data that belongs in an appendix.

- **Bibliography.** The references support all the neighboring notions invoked in the exposition. The note about arXiv numbering for the MDS-coset paper is helpful and prevents citation ambiguity.

## Venue-level assessment

### Scope and tone

The main theorem, conic consequences, and \(q=16\) classification form a coherent contribution for a specialist finite-geometry/coding venue. The tone is appropriately restrained: classical inputs are identified, computational claims are labeled as certified rather than “obvious,” and limitations of the incidence term are stated explicitly. There is little hype.

The \(q=11\) coding/icosahedral material is also venue-relevant, but it needs firmer subordination. At present it enlarges the perceived scope late in the paper. The game appendix is optional rather than integral and is the only part that risks making the article feel miscellaneously assembled.

### Proof/computation balance

The balance is broadly appropriate. Conceptual results have conventional proofs in the main text; finite classifications are summarized by the mathematical shape of their certificates; detailed coordinates and trust information are deferred. The manuscript does not ask the reader simply to trust a search count.

The main improvement would be to describe the \(q=16\) classification proof by layers of evidence more explicitly and to consolidate the verification appendix around claims rather than filenames/hashes. No computation needs to be re-presented in the main text. Conversely, the paper should not shorten the step-two full-rank/rank-five split: that is the conceptual certificate and is exactly what a reader needs.

### Detail and appendices

Definitions, moment proofs, the defect proof, and the conic lower-bound argument are at the right detail. The asymptotic coefficient estimate needs one sentence of strategy, not more algebra. The appendix of witness coordinates is fully justified. The formal-verification appendix is justified by the \(q=16\) theorem but could be more editorially shaped. The game appendix is not necessary to establish any headline result.

## Strongest exposition

1. The introduction’s distinction among saturating sets, almost-complete conic subsets, line-covering arcs, and complete exterior sets.
2. The sentence that the usual overlap inequalities have an exact remainder, followed by the four-item contribution spine.
3. The statement and proof of Theorem `thm:defect`, including the endpoint-pattern equality criterion and stability interpretation.
4. The one-sentence explanation of the two loss terms after `cor:conic-bound`.
5. Remark `rem:scale`, which sharply separates what the scalar conic-incidence term can and cannot prove.
6. The evaluation obstruction and the 2630/3 certificate split for \(q=16\).
7. The final main-text paragraph distinguishing universal overlap from conic-specific geometry.

## Remaining weaknesses

1. The abstract is a catalogue rather than a hierarchy, especially in its final third.
2. The coding interpretation interrupts the direct route from the general defect theorem to its conic specialization.
3. The \(q=11\) application is insufficiently framed before it introduces a large bundle of coding and icosahedral structure; its classical provenance arrives after the new results.
4. The classification’s exhaustiveness/trust paragraph carries too much in a single block.
5. The verification appendix visually overweights filenames and hashes instead of the claim-to-certificate map.
6. Seven further problems and the auxiliary game appendix prolong the ending after the principal results are already complete.

## Prioritized revisions

### Must fix before submission

1. **Rehierarchize the abstract.** Preserve the defect identity, explicit lower bound, transfer, and \(q=16\) classification. Compress the nucleus and \(q=11\) claims to at most one sentence total.
2. **Repair the main section flow.** Move `sec:coding` after the conic specialization, or explicitly justify why the dictionary must intervene before it. Ensure the introduction roadmap matches the resulting order.
3. **Frame the \(q=11\) strand before its propositions.** Introduce the Clebsch hexagon/classical exterior property first, state which observations are classical, and explain in one sentence why relative completeness makes the extension graph relevant.
4. **Unpack the first step of the \(q=16\) classification proof.** Clearly distinguish generation, certified exhaustiveness/projective transport, and agreement with the published class count.

### Medium priority

1. Split the heavier coding paragraphs and the proof of `prop:q11-code` at their conceptual boundaries.
2. Move the \(q=7\) complete-exterior foil out of the opening of `sec:examples` so the section reaches the advertised \(q=16\) mechanism sooner.
3. Consolidate the verification appendix into a claim/evidence/trust-boundary organization; collect hashes in one table or manifest pointer.
4. Reduce or group the Further Questions list.
5. Decide whether `app:game` belongs in the article or supplementary material.

### Polish

1. Replace the ambiguous “strict \(q=7\) example” with “strict containment at \(q=7\).”
2. Add one strategy sentence before the coefficient bounds in the asymptotic proof.
3. Move the post-theorem novelty sentence about the published \(q=16\) classification before the theorem proof.
4. Clarify the covering-radius conclusion in `prop:q11-code` rather than saying only that index-zero directions “give” it.
5. Reduce visual interruption from repeated centered hashes.

## Targeted rewrite sketches

These are structural sketches, not proposed wholesale replacement prose.

### 1. Compressed end of abstract

> In even characteristic we obtain complementary constraints according as the conic nucleus lies in the arc. For \(q=8,9,11\), explicit witnesses meet the lower bound. For \(q=16\), a certified classification of all 2633 projective eight-arc classes shows that no quadratic can contain the ordinary-uncovered locus while avoiding the arc, and hence \(\rho_{\cC}(16)=9\). The defect identity also has a syndrome-leader interpretation for codimension-three MDS codes; the exceptional \(q=11\) witness yields a non-GRS code with conic deep-hole locus.

This retains every major audience signal while dropping the icosahedral detail from the abstract.

### 2. Stronger transition into the coding section if it remains in place

> Before specializing the holes to a conic, we record a second interpretation of the same remainder. Under the arc--MDS correspondence, the secant index counts minimum weight-two syndrome leaders, so the two moment equations count leaders and collisions. This dictionary will be used again for the \(q=11\) witness; readers interested only in the geometric bounds may continue directly to Section~`sec:conic`.

This makes the detour voluntary and explains its eventual use.

### 3. Opening frame for the \(q=11\) subsection

> The six-point witness over \(\F_{11}\) is the classical Clebsch hexagon. Its secants avoid the conic, so relative completeness sharpens the classical inclusion \(\cC(\F_{11})\subseteq U(A)\) to equality. We first translate this equality into the coset structure of the associated MDS code, and then use it to confine all simultaneous extensions to the twelve conic points, where compatibility becomes the independence relation of the icosahedral graph.

This gives the reader provenance, novelty, and the reason the graph appears before the technical propositions begin.

## Overall narrative and pacing

The first half is paced very well from definitions through the defect identity and conic inequality. The transfer and nucleus sections are short, self-contained applications that broaden the theory without losing focus. The evaluation obstruction then supplies exactly the “additional mechanism” promised by `rem:scale`, making the \(q=16\) result a satisfying culmination.

Pacing slows after that culmination. The exceptional leaves, the full \(q=11\) coding spectrum, the extension complex, a long problem list, and three appendices create several successive codas. Reordering the \(q=11\) provenance, compressing its presentation slightly, and pruning the final questions/game material would let the paper finish with the same decisiveness with which it develops the defect identity. The underlying exposition is strong; the remaining task is to make the paper’s hierarchy as exact as its central identity.
