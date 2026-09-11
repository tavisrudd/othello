# C1140: adjacent-field cold comparison

Date: 2026-09-11. Reader: an algebraic geometer outside arithmetic Prym and Cox specialisms. Candidates were identified only as A and B; no order key, drafting packet, revision diff, or prior referee report was opened. The mandatory lane handoff was read and contains historical descriptions of the programme, so this is a blind candidate-order comparison, not complete ignorance of the programme. No conclusions from its reported reviews are adopted here.

## Scope and method

I read the complete extracted text of candidate A (24 pages) and candidate B (19 pages), including all proofs, appendices and references. I visually inspected A pages 1–3, 11–14, 20 and 22 and B pages 1–3, 10 and 12. These cover the opening, the main new transitions and representative tables; this is not a claim of visual inspection of every page. Extracted text and rendered review images are under `/tmp/persistent/tavis/c1140-blind/adjacent-*`.

This report assesses mathematical communication and the correctness of the stated boundaries. I did not independently audit cited source proofs, execute the mathematical certificates, inspect source code, or audit the companion obstruction theorems. In particular I do not certify the striking one-stabilization irrationality or Hodge-conservation inputs. No independent novelty search was performed.

Process note: an initial full live-handoff command unexpectedly emitted more than 10,000 original tokens and was truncated. This command-shaping failure was reported promptly; the handoff was then read in bounded chunks. The manuscript reads were bounded by PDF page ranges.

## Summary and contribution

Both papers prove a useful surface rationalization theorem: a smooth quartic del Pezzo surface with a rational point and stably permutation geometric Picard lattice becomes rational after adjoining two variables. The mechanism is a rational quotient of a seven-dimensional projective Cox model by a saturated rank-three torus. A descended tangent section meets general torus orbits once because four selected weights form an integral simplex. An equivariant generic trivialization identifies the quotient with the surface times a residual rank-two torus, which is rational.

B presents this principally as the sharp upper bound for two named cubic threefolds and two higher-dimensional cubic series. The companion irrationality theorem supplies the lower bound. A makes a substantial further contribution: a three-parameter cubic family with exact level two, together with a rational pencil whose intermediate Jacobians split geometrically up to isogeny into five elliptic factors. The potential toric-rank formula distinguishes every pair of distinct positive squarefree parameters prime to six. The companion Hodge-conservation theorem then distinguishes their first stabilizations. The finite rational partner result and torus-action consequences are appropriately secondary.

The surface construction is the primary new geometric mechanism common to both versions. A's arithmetic calculation is a second mechanism with a different purpose: it measures distinctions that survive one stabilization and disappear after two. This gives A a more substantial independent identity than a sharpness supplement alone. That assessment is based on the stated results and arguments, not a source-level certification or priority verdict.

## Exposition, organization and blind preference

**I prefer candidate A for conveying the overall theorem hierarchy, but candidate B is easier at the first encounter with the Cox quotient mechanism.** These judgments must be kept separate. A's mathematical content is stronger; that alone does not make its sentences easier to read.

A leads with the parameter family, states the three principal results on pages 1–2, and gives an economical table separating the surface/cubic construction, exact level, and separated family. Moving generic-surface, partner, finite-index and rank-four consequences to appendices makes the main progression easier to recognize. Its Section 6 is particularly effective: the local rank formula is stated before the Prym calculation, so a reader knows exactly what must emerge from the elliptic factors. The final prime-divisor argument is then short and memorable. The elliptic formulas earn their space.

B provides a more gradual opening to the shared geometry. It defines the Cox model and acting tori and displays the dimension identity before asking the reader to use them. Its introduction also clearly explains why the named examples matter. In A, the same quotient diagram is printed at the foot of page 2 before its symbols are defined; its explanation continues overleaf. This is a loss of accessibility, not a necessary cost of stronger content. Restoring the compact definitions and dimension calculation would recover B's advantage.

In both candidates, the rank-one model preceding the general quotient criterion does useful work: it separates a finite-index orbit ambiguity from an ineffective parametrization kernel. The cofactor correction and the discussion of uniqueness making descent possible are also strong. Proposition 3.2 usefully separates geometric nonemptiness, compatibility with tangent projection, and arithmetic descent. The four numerical witnesses are not falsely claimed to descend individually. Those are exactly the interfaces an adjacent reader needs exposed.

There is some duplication: the quotient's two descriptions occur in the introduction and again in the surface proof; the orbit-correction mechanism is summarized before its formal proof. These repetitions have different jobs and are acceptable. The repeated explanatory paragraph immediately before the four determinant formulas in the certificate appendix contributes less after the reconstruction conventions and could be shortened. Section 4 of A spends appreciable space on named examples before returning to its principal family in Section 5, but the section titles and route table make this manageable. A short opening sentence marking the named examples as a separate application would help.

## Major comments

Here “major” denotes reader-facing significance, not a demonstrated fatal mathematical defect.

1. **Repair the appendix skip in A, page 3.** The assertion that the appendices “are not needed for these three proof routes” is false as navigation: Appendix E supplies the all-smooth-parameter cover explicitly used in Proposition 3.2. The proof of the surface theorem, and hence its cubic applications, uses this nonemptiness result. Say that Appendices A–D are optional consequences/extensions, Appendix E contains the required finite nonemptiness calculation whose coordinate details may be postponed, and Appendix F records verification scope. A reader may defer the calculation, but must retain its mathematical output and trust boundary.

2. **Restore the missing introduction definitions in A, page 2.** Define the seven-dimensional projective Cox model `Z`, its rank-five actor `T_0`, and its saturated rank-three subtorus `T_3` immediately before the quotient diagram. The calculation `7−3=4=2+(5−3)` explains why this construction adds precisely two dimensions. The parent reported that this repair has been made in the working source; it was not present in the frozen candidate assessed here.

These are local, inexpensive changes. I do not recommend dismantling A's broader theorem hierarchy or moving the arithmetic separation argument out of the main text.

## Correctness of framing and source boundaries

The papers generally distinguish the relevant logical layers well. The surface rationalization does not require an irrationality theorem. Exact cubic level does require the companion one-stabilization result; nonisogeny of the pencil is arithmetic, whereas nonbirationality of its first stabilizations additionally requires Hodge conservation. A's prose identifies those dependencies. I found no presentation that upgrades a geometric isogeny to an isomorphism of principally polarized abelian varieties. The twists are explicitly restored for arithmetic point counts and explained to be irrelevant to potential ranks. The finite number of rational partner candidates is not advertised as a classification or an implemented solver.

The limitation of the Cox-weight method is appropriately confined to its embedding and full type-I3 action. It is not presented as an intrinsic impossibility theorem about further rationalization. Likewise, the finite-index construction gives a degree dividing the lattice index, not necessarily equal to it; the scroll example explains that distinction. The cancellation consequence is correctly identified as birational rather than an affine-cylinder isomorphism statement. The generic-fibre applications work over function fields and do not infer rationality by specializing fibres.

The final verification discussion distinguishes exact certificates, trusted symbolic execution, written arguments and imported geometry, and explicitly says there is no Lean formalization of the principal claims. That candour should be retained. Any journal decision on mathematical correctness still requires scrutiny of the external companion inputs and the cited Cox/Prym theorems beyond this report's scope.

## Minor comments

1. A, page 14: introduce the table as **j-invariants**, not merely “invariants.” A row label `j(E)` would also make the table intelligible on its own. The symbol is only made explicit in the following sentence.
2. A, Section 5: one sentence explaining the passage from a cubic-surface fibre with a distinguished line to the two-quadric model would help the adjacent reader. The equations verify the passage, but its geometric reason comes after the computation has begun.
3. A, page 13: a short explanation that the standard representation contributes an elliptic multiplicity factor twice would smooth the inference `J(W) ∼ J(C_t) × E_t^2`. The dimensions are supplied and internally consistent, but this is the fastest language change in the new section.
4. `B` serves as the binary cubic, a boundary projective space, and later a fibration base; `Q` serves as a Cox generator, a quotient bundle, and a conic. The scopes are normally recoverable. The pencil uses calligraphic `𝒳_t`, whereas the named examples use plain `X_j`. Text extraction flattened that distinction and prompted an initial collision query; visual reinspection confirms the distinction is visible, so that query is withdrawn. No renaming is required.
5. The string `CHARACTER_GENERATORS` in the middle of Section 3 is verification detail that can move to the verification appendix. It does not explain the matrices to a geometric reader.
6. The inspected pages contain no clipped equations, broken tables or unreadable type. A's page-2 diagram is crowded against the page ending, and its defining/explanatory text should stay together if the repaired pagination permits. B splits the witness-table introduction from its table across pages 15–16; A's placement on page 20 is better.

## Editorial recommendation

At this report's exposition and framing boundary, I recommend **minor revision of candidate A**, retaining its current main-result architecture and implementing the two substantive clarity fixes above. A communicates the broader mathematical purpose better and gives the arithmetic section a clear stopping point. B remains the easier short account of the shared rationalization argument, but its narrower content should not be mistaken for intrinsically superior explanation. Once A restores the omitted introductory definitions and corrects the appendix navigation, there is no exposition-based reason here to prefer B for publication.

This is a reasoned recommendation on presentation, not unconditional acceptance of all mathematical inputs. The source proofs and companion obstruction theorems were not independently audited.

## Closeout observation

The cheap improvement exposed by an adjacent-reader pass is to protect the distinction between “safe to postpone a calculation” and “not a proof dependency.” The report settles that navigational issue without changing the mathematics. No additional research mystery was identified within this limited review scope; proving or auditing the imported geometric interfaces remains the parent review's responsibility. This note is deliberately left uncommitted for the parent to integrate with the task-owned report.

## Targeted repair recheck

On 2026-09-11 I rechecked the revised authority PDF at `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.pdf`, SHA-256 `dec5519fbcc127245575d098a25f1a936a62b955d8dfe1faf583ae4166c233fa`. The supplied artifact has 24 pages. This followup read and visually inspected only pages 1–3, 11 and 13–14; it does not replace or expand the original full-text read's correctness boundary.

Both required exposition comments are resolved. Page 2 defines `Z`, `T_0` and `T_3` before the quotient diagram and includes `7−3=4=2+(5−3)`. The definitions and diagram remain together on the page and are legible. Page 3 now distinguishes optional Appendices A–D from the necessary nonemptiness calculation in Appendix E, while allowing the coordinate details to be postponed. The new direct family route correctly starts after the proof of the surface theorem and permits the reader to defer the named examples.

The smaller requested bridges are also resolved: page 11 explains the contraction before the two-quadric formulas; page 13 explains the two-dimensional standard representation and its one-dimensional transposition invariants before identifying the elliptic multiplicity factor; page 14 explicitly identifies the table entries as j-invariants. Page 1 now asks for the dimension of the stabilizing factor, which agrees exactly with the displayed definition, and confines the moduli-image assertion to the family over C. The calligraphic pencil/plain named-example distinction remains visible. No clipping, table failure or new reader-facing dependency error was found in these six pages.

**Disposition:** the required local revisions from this adjacent-field report are satisfied. I retain the preference for A's hierarchy and now find that its opening recovers the principal mechanism-orientation benefit previously attributed to B. No further required exposition change arose in this targeted check. The remaining optional shortening suggestions are not acceptance conditions. This is acceptance of the requested presentation repairs, not independent certification of the cited source proofs, companion obstructions or computational evidence. The note remains uncommitted for parent integration.
