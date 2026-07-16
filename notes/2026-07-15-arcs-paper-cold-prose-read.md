# Cold prose read: *Arcs complete outside a prescribed conic*

Date: 2026-07-15  
Manuscript: `papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` at the then-current HEAD  
Scope: cold, in-order review of exposition only. I did not check computations, certificates, classifications, citations, or mathematical correctness. Comments such as “clear” mean that the claim and its role are communicated clearly, not that the claim has been independently verified.

## Executive assessment

The paper has a strong, intelligible mathematical spine: define completeness outside prescribed holes; recall the two classical secant moments; expose their exact nonnegative remainder; specialize it to a conic; derive lower bounds; and use an uncovered-locus obstruction to settle the exceptional finite case. The exposition is at its best in Sections 2–6: definitions arrive before use, theorem statements are self-contained, proofs are short, and brief interpretive paragraphs tell the reader what each formula buys.

The manuscript becomes much harder to classify and read once it reaches the finite-field examples. The title promises a prescribed-hole identity and an `F_16` classification, but the abstract and latter third also carry an extensive coding-theory package, the `q=11` Clebsch/icosahedral extension structure, a game-theoretic consequence, implementation provenance, hashes, and repeated novelty-boundary statements. All of this may be valuable, but in the current sequence it obscures the main result rather than reinforcing it. The largest revision opportunity is therefore architectural and rhetorical, not local: decide which secondary story is essential to this paper, subordinate or relocate the others, and let the `q=16` conclusion arrive with less surrounding machinery.

Must-fix clarity problems are marked **Must fix**. Optional improvements are marked **Polish**. “Clean” or “strong” records paragraphs that already work well.

## Paragraph-level observations, in manuscript order

### Title and abstract

- **Title, lines 35–36 (“Arcs complete outside…”): Strong.** It names both the general object and the flagship finite result. “Prescribed-hole defect identity” is memorable once “hole” is defined, though a first-time reader will not yet know the term.
- **Abstract, lines 44–60 (“Let C be…” through the lower bound): Strong but dense.** The opening defines the problem efficiently and reaches the exact identity and asymptotic consequence quickly. The long displayed inequality is justified because it is the paper’s central deliverable.
- **Abstract, lines 61–67 (“Conversely, if H…”): Clean individually, crowded collectively.** Averaging, even-characteristic constraints, the evaluation dichotomy, and the coding dictionary arrive in four successive clauses without a hierarchy. A reader cannot tell which are main results and which are supporting translations.
- **Abstract, lines 67–82 (“Directly checkable witnesses…”): Must fix.** This final portion tries to summarize the small values, all 2,633 classes, the verifier, Lean trust boundary, non-GRS status, covering radius, coset and extension spectra, and the icosahedral complex. The abstract changes from a mathematical overview into an inventory. Retain the exact small values and the conceptual `q=16` obstruction; compress formal-verification provenance to one phrase and either omit or sharply subordinate the `q=11` coding/icosahedral results.

### 1. Introduction

- **Lines 87–92 (“An arc in a projective plane…”): Clean.** This is an economical entry point and gives the standard comparison literature without delaying the problem.
- **Lines 94–95 (“Fix a nonsingular conic…”): Strong.** A useful one-sentence informal definition immediately precedes the formal one.
- **Definition 1.1, lines 97–114: Strong.** The definition, parameter, uncovered locus, and equivalence are in a natural order. The notation load is reasonable here.
- **Lines 116–119 (“The minimum… is attained”): Clean but slightly interruptive.** It closes a genuine logical gap. It could be a short remark after the equivalence paragraph if the introduction is being tightened.
- **Lines 121–124 (“Equivalently, A is maximal…”): Clean.** This gives two high-value interpretations with little burden.
- **Lines 126–134 (“The problem differs…”): Strong.** The distinctions from saturating sets, almost-complete conic subsets, and line coverage orient the reader effectively.
- **Lines 136–150 (“There is also classical work…”): Must fix for pacing.** The historical connection is relevant, but the paragraph carries names, dates, two definitions, the `q=11` witness, and an announced reversal of inclusions before the main theorem has been stated. Split after the definition-level contrast, or defer the detailed `q=7/q=11` discussion to the finite-examples section.
- **Lines 150–165 (display comparing exteriority and completeness): Strong.** The three-line inclusion display is the clearest part of the historical detour and should be preserved wherever that discussion lives.
- **Lines 166–178 (“The first inclusion can be strict…”): Must fix for placement, not content.** This detailed `q=7` count and the qualification about what BSW does not state load the introduction with a side case. It reads like a later literature note supporting the `q=11` discussion, not like motivation for the defect identity.
- **Lines 180–188 (“The point index…”): Strong.** This paragraph cleanly identifies the classical input and states the new move—splitting over the exceptional set and retaining the remainder.
- **Contribution list, lines 190–201: Useful but overbroad.** Items (i)–(iv) form a coherent primary sequence. Items (v)–(vii) expand into three additional agendas. Consider grouping them as “structural and finite-field applications” so the list signals hierarchy.
- **Lines 203–212 (“Thus the classical scaffolding…”): Clear but defensive.** The distinction between classical moments and the new remainder is valuable. The last sentence says essentially the same thing a second time; one crisp novelty statement would carry more confidence.
- **Lines 214–220 (“A targeted literature search…”): Polish / likely relocate.** The caveat is responsible, but “not a priority certificate” and “may occur elsewhere” sound like research-process notes. A shorter literature-positioning sentence would fit the introduction; the search-scope disclaimer could go in acknowledgments or a note if it must remain.

### 2. The classical secant equations

- **Lines 225–232 (“Throughout the remainder…”): Clean.** The universe, hypotheses, index, and abbreviations are introduced efficiently. The first sentence is long; a break after “order `q`” would improve breathing room.
- **Lemma 2.1 and proof, lines 234–243: Strong.** The bound is stated plainly and the matching argument is immediate.
- **Proposition 2.2 statement, lines 245–254: Strong.** The two equations are visually prominent and aptly labeled as classical.
- **Proof first paragraph, lines 256–259: Clean.** Direct counting with no extra notation.
- **Proof second paragraph, lines 261–268: Strong.** The forward and converse counts are well balanced, and the last sentence closes the possible location ambiguity.
- **Lines 270–272 (“Only the projective-plane axioms…”): Clean.** A useful scope clarification that does not overstay.

### 3. An exact defect identity for prescribed holes

- **Lines 277–289 (“The next theorem…” and definitions): Strong.** The explicit statement that the conic enters later is excellent signposting. The covered/uncovered gloss after the notation prevents symbol-only reading.
- **Lines 291–298 (“Splitting Proposition…”): Clean.** This makes the theorem feel inevitable in a good way.
- **Theorem 3.1 statement, lines 300–319: Strong.** The defect is defined before the boxed identity, and nonnegativity is immediate to locate. This is the paper’s expository high point.
- **Theorem 3.1 proof, lines 321–344: Strong.** Each algebraic move is motivated and the two termwise identities make the source of the remainder transparent.
- **Corollary 3.2 statement and proof, lines 346–375: Clean.** Coverage, uncovered locus, and equality conditions are presented together without repetition.
- **Lines 377–395 (“For later use…” and Corollary 3.3): Clean.** The transition correctly explains why the arbitrary-hole consequence is recorded before specialization.
- **Lines 397–417 (“The exact remainder…” and Corollary 3.4): Strong.** The sets `M` and `J` make the stability content concrete, and the proof is proportionate.
- **Lines 419–422 (“Thus small defect…”): Strong.** This is exactly the interpretive sentence a reader needs after a compact stability inequality.

### 4. Coding interpretation

- **Lines 427–443 (“We record the standard arc–code dictionary…”): Mostly clear, high terminology density.** The progression from columns to the MDS code to projective GRS is logical. A geometric reader meets “parity-check system,” “coset-weight,” “GRS,” and “normal rational curve” in rapid succession; one sentence stating why the coding view matters *before* the construction would reduce burden.
- **Proposition 4.1 statement, lines 445–463: Strong within its audience.** The four cases are exact and the warning that deep-hole terminology requires covering radius three is especially helpful.
- **Proposition 4.1 proof, lines 465–478: Clean.** The proof follows the enumeration and avoids unnecessary coding formalism.
- **Lines 480–493 (“Thus r_A(x) is not merely…”): Strong explanation, then defensive close.** The leader/collision interpretation genuinely illuminates the defect. The final “not a claim that…” repeats the novelty-defense pattern already used in the introduction.
- **Structural note:** Placing the coding section before the conic specialization temporarily interrupts the main geometric argument. If coding is a major coequal theme, the placement is defensible. If the defect-to-conic-to-bound story is primary, moving this section after the geometric consequences would improve momentum.

### 5. Specialization to a conic

- **Lines 498–504 (“Let C be…”): Clean.** The point count and two equivalent meanings of `I_C(A)` prepare the specialization with minimal setup.
- **Corollary 5.1 statement, lines 506–524: Strong.** The general theorem specializes cleanly, and the complete case is rightly boxed.
- **Lines 526–528 (“The first correction…”): Strong.** This gives an intuitive budget interpretation in one sentence.
- **Lines 530–543 (definitions of `L_1`, `L_2`): Clean.** The reader can see exactly what the corrected bound changes; the integer-arithmetic note is practical.
- **Lines 545–566 (parity forms and table): Strong.** The closed forms and small table make an abstract inequality operational. The sentence highlighting `q=16` focuses attention appropriately.
- **Lines 567–572 (“At q=5…”): Must fix.** “A queued follow-up will import…” is project-management language and makes the paper date-sensitive. Either state the `q=5` result supported by material actually included, omit it, or say neutrally that the witness is not part of the present verification. “Companion Clebsch analysis” is also undefined for a reader of this paper.
- **Theorem 5.2 statement, lines 574–588: Strong.** The additive term and liminf consequence are easy to parse.
- **Proof, lines 590–630: Generally clear, with one burden spike.** The initial split into `k >= s+2` and `k=s+a` is effective. The coefficient bounding in lines 620–627 is terse: “their total contribution” requires the reader to reconstruct which powers of `s` are being bounded and why `s>=2` yields `4s^2`. One extra displayed or verbal inequality would improve auditability without redoing the computation.
- **Remark 5.3, lines 632–645: Strong.** It explains exactly why the conic term is useful only in finite cases and prevents the reader from chasing the wrong asymptotic mechanism.

### 6. An upper-bound transfer from complete arcs

- **Lines 650–652 (“Let t_2…”): Clean.** Necessary notation only.
- **Theorem 6.1 and proof, lines 653–673: Strong.** The expectation argument is immediate, and the conclusion carefully includes both disjointness and inherited completeness.
- **Corollary 6.2 and proof, lines 675–689: Clean.** The strict inequality check is explicit.
- **Lines 691–702 (Kim–Vu consequence): Clean.** This locates the transfer in the asymptotic landscape without overclaiming.
- **Lines 704–706 (“The transfer does not exploit…”): Strong.** Candid limitation plus a concise statement of value.

### 7. Even characteristic and the nucleus

- **Lines 711–713 (“Assume q is even…”): Clean.** The three nucleus facts needed later are gathered in one place.
- **Proposition 7.1 statement and proof, lines 715–743: Strong.** The tangent count, parity, and inequality follow in an easy narrative order.
- **Proposition 7.2 statement and proof, lines 745–773: Strong.** It mirrors the preceding case well, reducing reader effort.
- **Corollary 7.3 and proof, lines 775–789: Clean.** This closes the case split efficiently.
- **Lines 791–797 (“These two cases…”): Strong.** The concrete `(16,8)` comparison clearly explains why the next section needs a different idea.

### 8. Verified finite-field examples

- **Lines 802–804 (“The verified values…”): Strong.** This is an excellent section roadmap: easy cases by bounds and witnesses, `q=16` by classification.
- **Lines 806–814 (“The algebraic rejection…”): Clear but slightly broad.** “Arbitrary feature maps” is more general than the immediate quadratic need. The paragraph does explain evaluation well; a sentence explicitly tying `U(A) subset C` to “a quadratic vanishing on `U(A)` but not on `A`” would sharpen the motivation before generalization.
- **Lemma 8.1 statement and proof, lines 816–833: Strong.** The two rejection modes are crisp and the proof is exactly the right length.
- **Lines 835–841 (“For the full system…”): Strong.** This translates the dual-space language back into a checkable matrix criterion.
- **Lines 843–845 (“The following sharp form…”): Clean transition, but the generality begins a detour.** The proposition is elegant; its importance to the promised `F_16` result is not yet evident.
- **Proposition 8.2 statement and proof, lines 847–876: Clear.** The finite-union argument is readable. If the dichotomy is not used in the `q=16` proof beyond Lemma 8.1, consider moving it to a later applications section or appendix so the flagship classification arrives sooner.
- **Lines 878–882 (“Taking nu…”): Clean.** It states the relation between the lemma and proposition accurately and succinctly.
- **Proposition 8.3 and proof, lines 884–906: Clean.** The lower and upper bound sources are easy to locate, though “verification is described below” makes the reader wait through substantial unrelated material before reaching it.
- **Theorem 8.4 statement, lines 908–919: Strong.** It is concise, conceptually stronger than the conic corollary, and explicitly includes singular quadratics.
- **Theorem 8.4 proof, lines 921–940 (classification paragraph): Must fix for exposition.** This is a very long paragraph mixing normalization, four levels of counts, certificate design, an independent literature match, internal theorem names, list order, frame reduction, and the trusted computing boundary. The mathematical proof idea is buried. Split into: (1) classification strategy and class counts; (2) how exhaustiveness is certified; (3) what is and is not trusted. Internal identifiers such as `StepBook.coverage` are better in a reproducibility appendix unless essential to the theorem statement’s proof standard.
- **Theorem 8.4 proof, lines 942–947 (leaf obstruction): Strong.** The `2630 + 3` split is the key finite fact and is communicated cleanly.
- **Theorem 8.4 proof, lines 949–955 (invariance): Strong until the last sentence.** The transport argument is clear. The final Lean sentence repeats trust-boundary detail already given in the first proof paragraph.
- **Corollary 8.5 and proof, lines 958–972: Strong.** This is the clean payoff promised by the title. It could land even harder if less verification infrastructure preceded it.
- **Lines 974–977 (“The published ordinary classification…”): Polish.** This belongs with the introduction’s novelty positioning or in a closing note, not between the main corollary and the anatomy remark.
- **Remark 8.6, lines 979–999: Clear specialist detail.** The three exceptional kernels and their geometry explain the residual cases rather than leaving them opaque. This is valuable but feels appendix-like relative to the main narrative.
- **Lines 1001–1010 (incidence statistics table): Clean.** The compact table is a good reference point.
- **Lines 1012–1022 (`q=11` index calculation): Strong.** The paragraph moves from geometric meaning to moments to the exact distribution with no wasted motion.
- **Proposition 8.7 statement, lines 1024–1049: Must fix for scope and reader burden.** Four very different results—code parameters/cosets, extension complex, complete extensions, and an edge-colouring decomposition—are bundled into one proposition. The reader must absorb MDS codes, deep holes, an icosahedral graph, independence polynomials, complete arcs, antipodes, and perfect matchings at once. At minimum split the coding-spectrum claim from the graph/extension claims; more fundamentally, decide whether the full icosahedral package belongs in this paper.
- **Proposition 8.7 proof, lines 1051–1075 (coding paragraph): Dense but traceable.** The logical steps are present, yet trust-boundary commentary interrupts the mathematical story twice. State the mathematical derivation first; place formalization scope afterward in one consolidated note.
- **Proposition 8.7 proof, lines 1077–1091 (extensions paragraph): Must fix for sentence load.** The first three sentences explain the graph model well. The remainder becomes a list of checker and Lean claims, with several conjunctions and no hierarchy. Break out the mathematical consequences and consolidate verification provenance elsewhere.
- **Lines 1094–1107 (“The six-set is a classical Clebsch hexagon…”): Informative but over-defensive.** The exact classical/new boundary matters, but “novelty posture,” “bounded search,” and “priority claim” sound procedural. A conventional literature paragraph can say what follows from prior results and what combination is recorded here without narrating the claim-management process.
- **Remark 8.8, lines 1109–1123 (game structure): Must fix for scope.** This is lucid as a standalone observation, but it opens another conceptual domain after an already expansive coding/graph subsection. Since it is unused in any bound and absent from the title, move it to a companion paper or a clearly labeled appendix unless the projective cap game is made part of the paper’s declared purpose.
- **Lines 1125–1145 (primary verifier and hash): Clear reproducibility prose, poor narrative placement.** The checklist is easy to audit. Move implementation names, hashes, and trust details to a dedicated “Computational verification” appendix; the main text only needs the verified properties and a pointer.
- **Lines 1147–1168 (two `q=11` implementations and hyperplane checker): Must fix for pacing.** File names, three hashes, adversarial controls, and exhaustive ranges are repository-manifest material. They halt the mathematical narrative.
- **Lines 1170–1180 (`q=16` generator): Same issue.** The distinction between generator and trusted proof is important, but it can be stated once in a verification appendix rather than interleaved with results.
- **Lines 1182–1196 (Lean library): Must fix for density.** This single paragraph lists many modules, theorem families, representative normal forms, reduction mechanisms, manifest contents, and dependency exclusions. Consolidate the proof architecture in a table or short appendix subsection. In the main narrative, one sentence about machine-checked exhaustiveness is enough.

### 9. Further questions

- **Lines 1200–1206 (opening and first problem): Clean.** The first problem grows directly from the `q=16` method.
- **Lines 1208–1214 (higher-dimensional problem): Strong.** It identifies both what already generalizes and what is missing.
- **Lines 1216–1223 (saturating sets/codes/complexes): Overpacked.** This is three questions plus a disclaimer about slice rank. Split the extension-complex scan from the defect/coding lower-bound question, and remove the unasserted-consequence caveat unless readers are likely to infer it.
- **Lines 1225–1230 (`O(sqrt q)` constructions): Strong.** Concrete, central, and tied to a theorem in the paper.
- **Lines 1232–1237 (equality and bounded defect): Strong.** This is the most direct open problem arising from the exact remainder.
- **Lines 1239–1244 (conic stabilizer): Clean.** The reference back to the scale remark prevents duplication.
- **Lines 1246–1251 (“The central distinction…”): Strong closing paragraph.** It synthesizes the paper’s real conceptual boundary and ends on a focused research agenda. This voice—direct, conceptual, minimally defensive—is the model for revising the introduction and abstract.

### Appendix A and bibliography

- **Lines 1257–1296 (field encodings and witnesses): Clean.** The four witness blocks are uniform and directly usable. A one-line reminder that verification instructions/hashes live elsewhere would be enough if the computational material is moved into another appendix.
- **Bibliography, lines 1298–1418:** No prose-flow issues reviewed beyond consistency visible on a cold read. The note about arXiv numbering in the Davydov–Marcugini–Pambianco entry is helpful because the text cites a numbered result.

## Repeated patterns

1. **The paper often explains novelty boundaries more than once.** Variants of “not a claim that… is new,” “not a priority certificate,” “not novelty claims,” and “checked synthesis rather than a priority claim” recur in the introduction, coding section, finite examples, and game remark. One precise contribution paragraph plus local attribution where needed would be more authoritative and less distracting.
2. **Mathematics and verification provenance are interleaved.** The main line repeatedly pauses for theorem identifiers, generator trust boundaries, kernel-checking scope, implementation independence, hashes, and adversarial controls. Those details deserve preservation, but a dedicated appendix would let readers choose when to enter that layer.
3. **Several paragraphs use inventory syntax.** Long chains joined by “and,” especially in the abstract and `q=11`/Lean passages, flatten the hierarchy between theorem, corollary, evidence, and ancillary observation.
4. **Interpretive one- or two-sentence paragraphs are consistently excellent.** Examples include lines 419–422, 526–528, 632–645, 704–706, 791–797, and 1246–1251. The paper is clearest when it states a result, then immediately says what mechanism it measures and what it cannot do.
5. **The exposition is strongest when generality follows motivation.** The prescribed-hole theorem earns its generality from the conic problem. By contrast, the arbitrary-feature-map dichotomy arrives before the reader has seen the concrete `q=16` obstruction in action, so it feels more detached.

## Targeted rewrite sketches

These sketches illustrate local clarification; they are not proposals to rewrite the manuscript wholesale.

### 1. Compress the abstract’s final third

Current burden begins at “A sharp finite-field evaluation dichotomy…” (lines 64–82). A possible hierarchy-preserving compression is:

> We also derive even-characteristic nucleus constraints and formulate the quadratic obstruction as a finite-field evaluation criterion. Explicit witnesses give `rho_C(8)=rho_C(9)=rho_C(11)=6` and `rho_C(16)=9`; the last equality follows from a certified classification of the 2,633 projective eight-arcs over `F_16`, showing that no quadratic can contain an eight-arc’s ordinary-uncovered locus while avoiding the arc. Supplementary checkers and a companion Lean development verify the finite witnesses and classification certificates. A further `q=11` application identifies the associated non-GRS MDS code and its icosahedral extension complex.

This preserves every major theme while making the `q=16` result the climax rather than one item in a verification inventory.

### 2. Replace the `q=5` project-status paragraph

Lines 567–572 could say, depending on what the paper actually supports:

> At `q=5`, the bound `L_2(5)=4` is also sharp: a four-frame has ordinary-uncovered locus equal to the rational points of a nonsingular conic.

If that statement is not yet supported in this manuscript, omit the paragraph rather than describe a queued future import.

### 3. Lead the `F_16` proof with its three-step structure

Before the detailed certification paragraph at lines 921–940, add or substitute a roadmap such as:

> The proof has three steps. First, canonical augmentation reduces every eight-arc to one of 2,633 projective classes. Second, for 2,630 classes the uncovered-point evaluations span the six-dimensional space of quadratics; for each of the remaining three, that span contains the evaluation functional of a selected point. Lemma 8.1 therefore excludes the required quadratic for every representative. Finally, projective invariance transports the obstruction to every eight-arc.

The certificate and trust-boundary details can then follow in a separate paragraph or appendix without concealing the mathematical logic.

### 4. Consolidate novelty language

A single introduction sentence could replace several later disclaimers:

> We use the classical secant moments, arc–MDS correspondence, and known `q=11` Clebsch geometry as inputs; the contributions here are the prescribed-hole remainder and its consequences, the uncovered-locus evaluation obstruction, and the certified relative-conic conclusions stated below.

Later sections would then need only ordinary citations and precise statements of dependence.

## Prioritized revision list

### High priority — must-fix clarity and architecture

1. **Reduce and re-hierarchize the abstract**, especially lines 61–82. Keep the defect identity and `q=16` result dominant.
2. **Separate mathematical proof from computational/formal provenance** in Section 8. Move hashes, filenames, internal theorem names, adversarial controls, and detailed trust architecture to a dedicated appendix or supplement.
3. **Restructure the first paragraph of the `F_16` classification proof** so the mathematical three-step argument is visible before certification detail.
4. **Remove project-management language at lines 567–572.** A published manuscript should not contain “queued follow-up” or undefined companion ownership.
5. **Decide the scope of the `q=11` coding/icosahedral/game material.** If retained, split Proposition 8.7 and give it a clearly subordinate applications subsection; relocate the unused game consequence. If central, revise the title/introduction to announce it honestly.
6. **Shorten or relocate the detailed exterior-set detour at lines 136–178** so the introduction reaches the defect mechanism sooner.

### Medium priority — substantial flow improvements

1. Consider moving the coding interpretation after the conic lower-bound sections unless coding is intended as a coequal theme.
2. Consolidate novelty and priority caveats into one contribution statement; remove recurring defensive formulations.
3. Consider moving the general evaluation dichotomy after the concrete quadratic obstruction, or explain more directly why its full generality is needed before `q=16`.
4. Split Proposition 8.7 into coding-spectrum and extension-graph results, with proofs organized in the same order.
5. Add one explicit inequality in the asymptotic proof at lines 620–627 to make the `4s^2` bound immediately auditable.
6. Move the anatomy of the exceptional leaves and reproducibility manifest into well-labeled subsections or appendices.

### Low priority — optional polish

1. Break the long setup sentence at lines 225–227.
2. Tighten contribution-list items (v)–(vii) into a visibly secondary group.
3. Replace procedural phrases such as “novelty posture,” “bounded search,” and “priority certificate” with conventional attribution prose.
4. Split the third open problem into separate questions.
5. Preserve the short interpretive paragraphs after major results; use that pattern more often when retaining dense specialist material.

## What is strongest

- The progression from the two classical moments to the exact nonnegative defect is unusually clear.
- The theorem/corollary/proof units in Sections 2–7 are concise and well ordered.
- The paper repeatedly gives useful mechanism-level interpretations: overlap correction, incidence spent on the conic, leader collisions, asymptotic scale, and why nucleus information cannot settle `q=16`.
- The `F_16` quadratic-avoidance theorem is stated cleanly and yields the exact conic result in a very short corollary.
- The final paragraph identifies the conceptual frontier better than the current abstract does.

## What most needs work

The manuscript needs a firmer hierarchy of claims. Its core paper is already present and reads well, but it is surrounded by enough secondary coding, historical, game, and proof-engineering material that a cold reader may lose track of the central question. The best revision would not add exposition; it would redistribute it: main-text mathematics first, one coherent applications story second, reproducibility details in an appendix, and novelty qualifications stated once with confidence.
