# Cold prose read: *Arcs complete outside a prescribed conic*

Date: 2026-07-15

## Scope and overall impression

This report is a context-free referee-style reading of the manuscript in its displayed order. I have not checked the calculations or the computational certificates. My comments concern exposition, hierarchy, transitions among finite geometry, coding theory, and computation, and the extent to which secondary material can be skipped without losing the main argument.

The paper has a strong mathematical spine. The definition of relative completeness is natural, the exact defect identity is elementary in a good sense, and its consequences are developed with unusual care: equality, stability, an explicit asymptotic lower bound, a transfer upper bound, and an exact finite-field result. The prose is generally precise and professional. Individual proofs are short, local, and readable. The recurring distinction between universal secant overlap and conic-specific geometry is especially effective and could serve even more explicitly as the paper's organizing principle.

The principal weakness is not sentence-level writing but hierarchy. The manuscript is trying to be three papers at once: a general prescribed-hole incidence paper, a relative-conic paper with an exact result at \(q=16\), and a coding/icosahedral application at \(q=11\). Each strand is interesting, but the abstract, introduction, examples section, and appendices give them nearly equal rhetorical weight. The central theorem remains recoverable, yet the reader has to decide unaided which later branches are essential. For a specialist finite-geometry/coding-theory journal, I would regard the manuscript as publishable in substance but in need of a substantial expository revision before acceptance.

## Sequential, paragraph-level reading notes

### Title and abstract (lines 35--76)

- The title identifies the geometric problem and the \(\mathbb F_{16}\) endpoint well. The subtitle promises a focused article; the body is appreciably broader, especially once the \(q=11\) coding and extension-complex material arrives.
- The opening three sentences of the abstract are excellent: object, parameter, method, and conceptual novelty appear immediately.
- The first displayed inequality comes too early and is too detailed for the amount of notation already introduced. The symbol \(I_{\mathcal C}(A)\) is not explained in the abstract. A reader can infer that it is a correction term, but not what it measures. Either define it in a short phrase or state the qualitative consequence first and reserve the full formula for the body.
- The abstract then changes register four times in quick succession: incidence identity, asymptotic bound, projective averaging, certified classification, and MDS/deep-hole application. All are accurate signposts, but the cumulative effect is a results inventory rather than an argument. The last two sentences are particularly dense. The \(q=11\) code is secondary to the title and should be explicitly marked as an additional application, or omitted from the abstract.
- “Certified classification of all 2633 projective eight-arc classes” is admirably concrete, but “certified” needs its eventual trust-boundary meaning. In the abstract, “computer-assisted classification” would orient a journal reader more immediately.

### Introduction (lines 80--179)

- Lines 80--85 give a clean entry for both finite geometers and coding theorists. The equivalence between completeness and secant coverage is exactly the right first fact.
- Lines 87--107 introduce the new problem at an appropriate pace. The definition is fully explicit, and the final sentence provides a useful operational test.
- Lines 109--114 efficiently settle existence and independence of the chosen conic. The phrase “maximal under insertion” is understandable, though “inclusion-maximal among arcs disjoint from \(\mathcal C\)” would be slightly more standard and would avoid the brief switch in terminology.
- Lines 116--124 are valuable positioning. The contrast with almost-complete subsets of a conic is especially important because it prevents a predictable misreading. This paragraph is compact despite carrying three neighboring notions.
- Lines 126--148 are mathematically illuminating and introduce the ordinary-uncovered locus that later drives \(q=16\). The three-line implication display is one of the best orientation devices in the paper. However, the excursion into complete exterior sets is already a second research strand. The final forward reference to \(q=7\) and \(q=11\) makes it sound central; it would be clearer to label it explicitly as a later exceptional comparison.
- Lines 150--158 locate the main method in the literature and state the novelty cleanly. “The inequalities normally used to control overlap have an exact remainder” is the conceptual sentence the paper should repeatedly foreground.
- The four-item list in lines 160--166 is well ordered, but it omits the \(q=16\) classification even though the title features \(\mathbb F_{16}\). Conversely, the later coding application receives more emphasis than this list suggests. The introduction needs one authoritative hierarchy of principal versus secondary results.
- Lines 168--173 are the first roadmap, but it is compressed into a sequence of nouns (“Projective averaging and characteristic-two nucleus constraints...”). A section-by-section roadmap saying what is logically needed for \(\rho_{\mathcal C}(16)=9\) and what is optional would materially improve navigation.
- Lines 175--179 are a useful contributions statement, though it partly repeats lines 150--173. Consolidating these paragraphs would give the introduction a firmer close. “Known \(q=11\) Clebsch geometry” arrives before a nonspecialist has any reason to expect it.

### Classical secant equations (lines 184--232)

- The setup is economical and the notation \(N,m,r(x)\) is introduced in the order used.
- The maximum-index lemma and its proof are exemplary: brief, visual, and sufficient.
- The two moment equations are presented at exactly the right level. The second-moment proof explains the factor three rather than treating it as folklore; this will help coding-theory readers.
- The closing paragraph about projective-plane axioms is useful scope control. It makes clear that the coming identity is not yet conic-specific.

### Exact defect identity (lines 237--382)

- Lines 237--249 make the prescribed-hole generalization very naturally. The notation load is real (\(V,\mathcal X,\mathcal U,I\)), but each object is immediately glossed in words.
- The split equations in lines 251--258 prepare the theorem transparently. This is good proof architecture: the reader sees that the result is an exact rearrangement, not a mysterious new estimate.
- The theorem statement is crisp and the boxed identity deserves its prominence. It would benefit from one sentence immediately after the statement explaining the two sums conceptually: intermediate multiplicities off the holes and nonextremal multiplicities on the holes are precisely the defect.
- The proof in lines 281--304 is clean algebra. The two termwise identities are the decisive step and are displayed appropriately.
- The coverage/uncovered corollary and equality condition are easy to scan. This is a strong conversion from identity to usable inequalities.
- The arbitrary-hole corollary is logically useful, but its one-line proof and subsequent immediate move to stability make the section feel like a chain of theorem environments. A short paragraph identifying which corollary will drive the conic result would restore narrative rhythm.
- The stability statement is concise and well motivated by the preceding phrase “The exact remainder also quantifies near equality.” The explanatory paragraph at lines 379--382 is essential and strong. The paper should provide similarly plain-language interpretations after the conic and coding translations.

### Conic specialization and asymptotic bound (lines 387--533)

- Lines 387--393 are an effective change from general incidence language to conic geometry. The equality expressing \(I_{\mathcal C}\) as both point indices and secant intersections immediately gives the term geometric meaning.
- The conic inequalities are central and clearly displayed. The following sentence (“unavoidable concurrence” versus incidence “spent on the exempt conic”) is excellent; it should perhaps precede the formula as motivation and recur in the introduction.
- The definitions of \(L_1,L_2\), parity formulas, and table are useful for finite cases. This is computation-facing material, but the transition is gentle because it remains integer arithmetic directly attached to the theorem.
- The table makes the \(q=16\) gap visible. A sentence should also tell the reader which values will later be sharp, so the table functions as a map rather than a detached comparison.
- The explicit additive lower bound is a genuine headline theorem. Its proof is readable but more algebraically compressed than the preceding combinatorial arguments. The split into \(k\ge s+2\) and \(k=s+a\) is sensible; nevertheless, the proof should announce the strategy before the coefficient expansion: the overlap correction forces the leading coefficient \((2a-3)/4\) to be nonnegative up to a controlled \(O(1/s)\) error.
- “Only the leading coefficient matters asymptotically” is slightly at odds with the theorem being an explicit all-\(q\) inequality; the next sentences do correctly control the remainder. Rephrase to emphasize that the remaining coefficients are being bounded uniformly to obtain the explicit error term.
- The scale remark is very helpful. It prevents the reader from expecting the conic incidence term alone to improve the asymptotic constant and cleanly distinguishes universal from conic-specific information.

### Coding interpretation (lines 538--609)

- The transition “The same remainder has a coding interpretation” is direct, but the section assumes the reader can absorb parity-check codes, projective GRS equivalence, coset leaders, syndrome directions, deep holes, and covering radius in roughly two pages. For a mixed finite-geometry/coding audience, this is just at the edge of being too fast.
- Lines 538--549 give the arc--MDS dictionary clearly. The explanation of why the parameters are \([k,k-3,4]_q\) is concise and sufficient.
- The definition of “projectively GRS” is appropriately precise. The next sentence announces that this dictionary is needed only for the \(q=11\) witness; that is an important hierarchy cue and should be made even stronger: this section can be skipped by a reader interested only in the defect inequality and \(q=16\).
- The syndrome proposition is valuable, but item (iii), exactly \(\binom{k}{3}\) leaders, may surprise readers because “leaders” are usually codewords in a coset rather than supports. The proof resolves this, but one phrase in the statement clarifying that each three-subset gives one coefficient word would reduce friction.
- The caution that distance-three directions are deep-hole directions only after covering radius three is established is excellent terminological discipline.
- Lines 580--595 prove the dictionary efficiently. The final literature sentence adds reassurance without replacing the proof.
- The projective-to-affine factor paragraph is clear and anticipates later counting. The last paragraph’s “first moment counts leaders, the second counts collisions” is the conceptual payoff and could profitably be moved earlier, perhaps to the beginning of the section.

### Upper-bound transfer (lines 614--670)

- This is one of the cleanest sections. The averaging theorem is elementary, useful, and completely self-contained.
- The conic corollary and Kim--Vu consequence follow at a comfortable pace. The final paragraph accurately calibrates sharpness.
- In the paper’s overall flow, this section interrupts the route from the lower bound to the \(q=16\) obstruction less than the coding section does, because it is short and directly concerns \(\rho_{\mathcal C}(q)\). It belongs in the main line.

### Even characteristic and the nucleus (lines 675--761)

- The geometric facts about the nucleus are stated before use, so odd-characteristic readers are not stranded.
- The two cases \(\nu\in A\) and \(\nu\notin A\) are symmetric and well organized. Each proposition has a short geometric proof and a clear inequality consequence.
- The universal loss corollary is a natural synthesis.
- Lines 755--761 are especially effective exposition: they explicitly show why this promising geometric refinement cannot close the \((16,8)\) case. This negative calculation motivates the coming classification and prevents the section from feeling ornamental.

### Evaluation obstruction (lines 766--853)

- The opening paragraph of the examples section states the lower/upper-bound status efficiently.
- The change from incidence geometry to linear algebra is audience-appropriate at first: evaluation functionals are defined before use, and the connection to a conic containing the uncovered locus is stated concretely.
- The uncovered evaluation lemma is simple and well pitched. Its proof is immediate, which is a virtue here.
- The Veronese paragraph explains the six-by-six quadratic matrices that appear later. This is precisely the right amount of algebraic-geometric vocabulary.
- The finite-field evaluation dichotomy is broader than needed for \(q=16\). It is elegant, but it interrupts the direct line from the lemma to the classification, and the classification uses only the lemma’s two alternatives. Unless the dichotomy has another central application, it should be moved to a remark or appendix. As written, readers may expect it to drive the main theorem.
- The “sharp threshold” discussion is clear but reinforces the sense that a general side result has been inserted into a focused finite-field argument.

### Small values and the \(\mathbb F_{16}\) classification (lines 858--972)

- The \(q=8,9,11\) proposition is concise. It relies on witness coordinates relegated appropriately to the appendix.
- Lines 882--886 give an excellent one-paragraph description of the additional datum extracted from the ordinary classification.
- The statement of the quadratic-avoidance theorem is admirably exact and explicitly includes singular quadrics. This is the crucial computationally assisted theorem.
- The proof’s four-part structure is good. However, “Generation,” “Certified exhaustiveness,” and “Leaf obstruction” are currently summaries of a certificate architecture rather than a proof a referee can audit from the manuscript. The body gives counts and describes what certificates check, but not the canonical augmentation rule, the precise coverage certificate, or the formal statement that connects certificate acceptance to exhaustive classification. The appendix later points to external files. For a journal article, the mathematical specification of the exhaustive search and the trust boundary must be self-contained enough that supplementary code is reproducibility material, not missing proof prose.
- The sentence “The exhaustiveness claim therefore does not trust the generator’s canonical labels” is helpful, but “therefore” asks the reader to accept a chain not actually spelled out here. A compact proposition describing the certificate checker’s inputs and verified conclusion would make this persuasive.
- The external count agreement is a useful consistency check and is correctly not presented as the proof.
- The projective-transport paragraph closes the mathematical reduction cleanly.
- The corollary \(\rho_{\mathcal C}(16)=9\) is then very easy to follow. This is the desired endpoint and should not be delayed by any optional material between the obstruction lemma and classification theorem.
- The anatomy-of-exceptional-leaves remark is concrete and interesting, but nonessential. It can be skipped without losing any main argument and should be visibly labeled as optional computational geometry, perhaps moved to the verification appendix.

### The \(q=11\) coding application (lines 974--1103)

- The first paragraph changes language again, now combining classical Clebsch geometry, exterior sets, and coding. The references are precise, but “Dye’s edge criterion” is not explained; a reader outside this exact subliterature must accept it as a black box. Since the witness is independently verified later, clarify whether the classical discussion is interpretation or an input.
- The comparison with \(q=7\) is mathematically neat but is another branch away from the title’s main endpoint. It is fully skippable.
- The statistics table usefully unifies the examples. It may belong earlier, immediately after the exact-value statements, before the detailed \(q=11\) digression.
- The derivation of \((N_1,N_2,N_3)=(90,15,10)\) is clear and gives the reader a satisfying use of the two moment equations.
- The code-and-coset proposition is well stated and its proof makes the geometry-to-coding translation concrete. Coding readers will value it; geometry-only readers can skip the entire subsection without affecting \(\rho_{\mathcal C}(16)=9\).
- The extension-complex proposition is the point where secondary material becomes disproportionately large. Icosahedral independence polynomials, maximal extensions, edge color classes, and perfect matchings are attractive consequences, but they are not prepared by the title or main roadmap and they do not feed back into the defect identity or \(q=16\). This material would be stronger as a separately labeled final application, an appendix, or a companion note.
- “Exhausting the \(2^{12}\) subsets” is adequate for a small direct check, but the claim that maximality upgrades to ordinary completeness deserves one more explanatory sentence for readers tracking the distinction between extension maximality and secant coverage.

### Further questions (lines 1105--1143)

- The four problems are concrete and well chosen. Their order appropriately returns first to the \(q=16\) obstruction and asymptotic construction problem.
- The fourth problem combines higher-dimensional caps, saturating sets, covering codes, arbitrary feature maps, and Veronese degrees. It is too broad for one problem statement and mirrors the manuscript’s tendency to collect every available direction. Splitting or narrowing it would improve force.
- The closing paragraph is an excellent conceptual conclusion. Its distinction between universal overlap and conic-specific geometry should appear earlier as the explicit organizing thesis.

### Verification and witness appendices (lines 1146--1244)

- The trust-boundary table is unusually useful. It distinguishes witness checking, formalization of general theorems, exhaustive \(q=16\) classification, and \(q=11\) finite data. This is good scholarly practice.
- Some entries remain tool- and repository-facing (“entry point,” path names, checked-in report) rather than publication-facing. A journal version should identify supplementary artifacts by stable archive/version identifiers and describe the checker mathematically in the paper. Exact local paths are useful to developers but are not durable exposition.
- The Lean trust boundary is stated with commendable precision, though the list of foundational axioms may be more detail than most readers need in the main paper. It fits in supplementary documentation unless the journal specifically values formal proof metadata.
- The paragraph at lines 1192--1200 is dense with implementation nouns. It should be rewritten as a reproducibility protocol: input, checker, verified property, and resulting theorem.
- The witness-coordinate appendix is clean and minimal. Field encodings precede coordinates, so the data are usable. It is appropriately separate from the mathematical narrative.

## Can secondary material be skipped?

Yes, but the manuscript does not currently advertise the route clearly enough. A reader seeking the principal geometric results can read the introduction, Sections 2--4, the transfer theorem, the nucleus section, the evaluation-obstruction lemma, the \(\mathbb F_{16}\) classification theorem and corollary, and the verification appendix. Such a reader can skip the coding interpretation, the finite-field evaluation dichotomy, the anatomy of the exceptional leaves, and the entire \(q=11\) coding/extension subsection without losing the proof of the defect identity, asymptotic lower bound, transfer upper bound, or \(\rho_{\mathcal C}(16)=9\).

That modularity is a strength. It should be made explicit in the introduction and section openings. A short “logical dependence” paragraph would suffice: Sections 2--4 establish the universal lower bound; Sections 6--8 establish the exact \(q=16\) value; Section 5 and the final \(q=11\) subsection are coding applications. Moving the optional evaluation dichotomy and icosahedral extension complex to appendices would make the main path nearly linear.

## Prioritized recommendations

### Must fix before publication

1. **Establish one hierarchy of contributions.** Decide whether the paper’s headline is the prescribed-hole defect identity with conic consequences or the exact \(\mathbb F_{16}\) result, and present the other as the principal application. Mark the \(q=11\) coding and extension-complex results as secondary. Align title, abstract, introduction list, roadmap, and section lengths with that hierarchy.

2. **Make the computer-assisted \(q=16\) proof self-contained at the level of mathematical specification.** The manuscript need not print code or certificates, but it should state the augmentation universe, equivalence relation, certificate objects, checker conclusions, and the exact implication from accepted certificates to exhaustive coverage of all eight-arcs. Stable supplementary artifacts can then support reproduction. At present the prose asserts a credible architecture but does not fully expose it for referee audit.

3. **Reduce or relocate the long secondary branch.** The finite-field evaluation dichotomy, exceptional-leaf anatomy, and especially the \(q=11\) extension complex can be skipped without affecting the main theorems. Move at least the extension-complex material to an appendix or identify it unmistakably as an optional final application. The current length and theorem-level prominence blur the paper’s center.

4. **Rewrite the abstract and final introduction roadmap.** Define or avoid \(I_{\mathcal C}(A)\) in the abstract, replace the result inventory with a causal narrative, identify the classification as computer-assisted, and tell readers which sections form the proof of \(\rho_{\mathcal C}(16)=9\) and which are coding applications.

### Medium priority

1. Add a one-sentence conceptual gloss immediately after the defect identity, parallel to the excellent “concurrence” and “incidence spent” gloss after the conic inequality.
2. Precede the asymptotic coefficient expansion with a sentence explaining the leading-coefficient strategy and the role of the explicit \(8/\sqrt{2q}\) error.
3. Slow the coding-language transition slightly by foregrounding the sentence “first moment counts leaders, second moment counts collisions” and by clarifying the leader count in Proposition 5.1.
4. Recast the verification appendix in publication-facing terms: stable supplement, formal input/output contracts, and checker guarantees, with local program paths moved to the supplement.
5. Split or narrow the fourth open problem, which currently bundles several different research programs.
6. Use the small-values table as a navigational device by stating which rows are exact and what additional ingredient settles each one.

### Polish

1. Replace a few compressed noun chains in roadmaps and transitions with full statements of logical purpose.
2. Consolidate the partly repetitive contributions paragraphs at the end of the introduction.
3. Clarify that the complete-exterior and Clebsch discussions are contextual interpretations unless they are genuine proof inputs.
4. Consider moving the exceptional-leaf factorization data to the computational appendix.
5. Retain the existing short proofs, explicit equality conditions, caution about deep-hole terminology, and trust-boundary table; these are notable expository strengths.

## Venue-level assessment

For a specialist journal spanning finite geometry and coding theory, the mathematical content appears substantial and well matched to the audience. The central incidence argument is elegant, the exact remainder is reusable beyond conics, and the paper connects theory to a genuinely nontrivial finite classification. The manuscript is already technically literate and mostly pleasant to read; it does not need wholesale stylistic rewriting.

My recommendation on exposition alone would be **major revision, with a favorable expectation after revision**. “Major” reflects structural presentation and the need to state the computer-assisted proof architecture more fully, not poor prose or an incoherent argument. If the hierarchy is clarified and the optional coding/computational material is more sharply separated, the paper should read as a strong, focused contribution rather than an accumulation of several individually interesting results.
