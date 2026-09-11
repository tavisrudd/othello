# C1140: specialist comparison of neutral candidates A and B

Date: 2026-09-11. Audience: birational geometers and rationality specialists.

## Read boundary and comparison conditions

I read every page of candidate A (24 pages) and candidate B (19 pages), including the appendices and references, from page-separated PDF text extracted to disk. I visually inspected A pages 1, 2, 8, 11, 14 and 22 and B pages 1, 2, 8, 9 and 17. These include both openings, the tangent-section/descent transition, the upper-bound argument, A's new family and elliptic-reduction arguments, and the dense certificate tables. I did not inspect manuscript sources, a diff, any prior referee report, the upgrade packet, external source texts, or executable certificates. This is a specialist comprehension and editorial comparison, not the separately commissioned source-mathematics audit.

The candidate ordering was not supplied. The PDFs themselves disclose their titles and dates, and A's greater scope is evident. Mandatory repository routing exposed the lane handoff, which contains historical scope and review summaries; therefore this is a comparison blind to the supplied ordering, not a reader wholly ignorant of project history. No conclusion below uses the handoff's mathematical or review verdicts as evidence. Process defect: the first handoff read exceeded the output limit; a batched recovery also exceeded the aggregate limit. Required reading was completed with separately bounded chunks. Neither failure affected the complete, untruncated page reads of the PDFs.

Candidate identities:

- A: *Two-Variable Rationalization and Sharp Stabilization of Cubic Threefolds*, September 2026. SHA-256 `1fc85b756d80251ff85e2189971bedd19a0a2a977900a8d2528141ea4ae746df`.
- B: *Sharpness of Irrationality after One Stabilization for Cubic Threefolds*, August 2026. SHA-256 `77bdc33b24d0fc4b84c6c7f5d5c69253d61e3c9357ed62f286906e609b7eb965`.

## Summary and contribution

Both candidates prove a two-variable rationality theorem for smooth quartic del Pezzo surfaces over characteristic-zero fields, assuming a rational point and stably permutation geometric Picard lattice. The resulting bound applies in particular to stably rational surfaces. The principal construction is a rational quotient of the seven-dimensional projective Cox model by a saturated rank-three torus. Four selected weight spaces form a Galois-stable set and have integral-basis weight differences. Signed maximal minors locate the unique point where a general orbit meets the chosen tangent section; birational tangent projection makes that section rational. An equivariant generic trivialization of the universal torsor identifies the same quotient with the surface times a residual two-dimensional torus. Rationality of that residual torus gives the upper bound.

B applies the construction to two named cubic threefolds and the related higher-dimensional series of Tschinkel and Zhang. A retains these results and adds a three-parameter cubic family, proves its three-dimensional moduli image, and studies an explicit rational pencil inside it. The pencil's intermediate Jacobians split up to geometric isogeny into five elliptic factors. Their potential toric ranks distinguish the positive squarefree parameters prime to six. The imported one-stabilization obstruction makes the upper bound exact, while imported rational Hodge conservation makes the first stabilizations pairwise nonbirational. Thus the family supplies infinitely many irrational fourfolds that become rational after one additional projective-line factor.

## Significance and scope

The surface rationalization is the principal independent contribution in either version. Its mechanism explains why precisely two variables remain, rather than merely providing a smaller stabilization bound. The saturation remark is mathematically useful: it identifies the apparent degree-two ambiguity from three visible sign cocharacters as a parametrization kernel, and shows why the actual quotient admits a unique orbit correction. The application to rationality gives that lattice distinction a concrete geometric consequence.

A's expanded scope is unified. The family theorem tests the surface construction uniformly under specialization of the coefficients, using containment of the signed Picard action rather than assuming monodromy remains maximal. The arithmetic pencil then answers a natural next question: which distinctions survive the first stabilization when the second is rational? Its local rank formula gives an intelligible reason for the chosen squarefree parameter set. The added mathematics therefore changes the paper's contribution, not simply its inventory of corollaries.

Moving generic-surface consequences, partner constructions, finite-index slices and the limits of the Cox representation into appendices improves the hierarchy. A reader interested in the cubic contribution can finish the main text on page 14. B is shorter and more concentrated on the quotient construction, but its main text subsequently presents several secondary directions at nearly the same organizational level. A has the stronger research narrative despite its greater length.

This assessment is conditional on the truth of the cited inputs and computations, which I have not independently inspected. It is not a priority verdict. The manuscript's attribution of the Cox geometry, classification and earlier type-I0 bound is sufficiently visible for a specialist to distinguish the asserted contribution from its predecessors.

## Correctness and hypothesis boundary

I found no demonstrated internal contradiction or mismatch between an announced theorem and its stated proof inputs. The important interfaces are visible and, as written, are suitable for a focused mathematical audit:

1. Theorem 1.2 retains characteristic zero, a rational point and a stably permutation Picard lattice. The final clause explains why stable rationality supplies these hypotheses. The nonminimal case is treated separately by contraction to degree at least five.
2. The quotient criterion requires both the integral-basis condition and descent of the selected weight-space sum and its complement. Its proof also checks that the rational component actually meets the isomorphism locus of tangent projection. It does not infer rationality merely from an orbit-intersection count.
3. Proposition 3.2 combines two open conditions on the same pair of points. The four coordinate witnesses establish nonemptiness over the splitting field; density of ground-field points supplies descended data. The text does not claim that a displayed witness itself descends.
4. Generic torsor splitting is explicitly equivariant before either torus quotient is taken. This is the necessary interface between the rational quotient and the surface product.
5. A's Section 5 identifies a signed Galois action containing every specialized action. The absence of a linear term in the binary cubic is used in the displayed argument. Extension of constants need not preserve the full Galois group. The lower bound over arbitrary characteristic-zero fields is obtained by finite descent of a hypothetical rational map, not by asserting that every such field embeds in the complex numbers.
6. A clearly separates geometric isogenies from polarized isomorphisms and records the arithmetic twists. Potential toric rank is used after finite extension, so the argument does not confuse reduction of a chosen model with geometric isogeny invariance. The passage from nonisogenous Jacobians to nonbirational fourfolds expressly imports Hodge conservation.
7. The finite-index appendix proves degree divisibility, not equality, and supplies an example where the rational component has smaller degree. The rank-four and rank-five exclusions concern the stated representation and criterion, not all possible rationalizations.

Neither candidate establishes the companion irrationality theorem internally. A additionally uses the companion Hodge conservation theorem. A names the companion and its theorem numbers in the introduction and identifies both dependencies in the abstract and proof-route table. The headline is therefore not misleading at the level of presentation. Whether the cited companion proves precisely those assertions is a separate, indispensable source-review question; this report cannot certify it. Likewise, A's conic-bundle isogeny input, reduction inputs, and signed Picard identification have not been independently re-proved here.

The verification appendices distinguish textual arguments, imported results, exact certificates and trusted symbolic execution. A specifically acknowledges that its new symbolic program lacks a second implementation and that finite point counts do not prove the all-parameter conclusions. Both explicitly disclaim Lean coverage of the main results. These are appropriate boundaries. I did not execute either candidate's programs, so their reported passes remain manuscript assertions in this review.

## Exposition and organization

The strongest common passage is the proof of the quotient criterion, followed by the construction of the tangent-section open. The low-rank orbit-correction example, signed-minor formula and saturation discussion make the mechanism accessible at specialist pace. The proof of the surface theorem then brings the geometric and torsor descriptions together cleanly.

A improves the opening substantially as a statement of the paper's full contribution. A precise family theorem appears on page 1, followed by the independent surface bound and the separated-family theorem. The local rank formula is announced before the five-factor calculation, so a reader knows what to retain from the arithmetic section. The final squarefree-parameter argument is short and decisive. The visual inspections found readable formulas and tables without clipping or overlapping material.

B has one explanatory advantage worth preserving: the introduction explicitly identifies the Cox-model notation and displays the dimension equation `7 - 3 = 4 = 2 + 2`. A's compressed opening loses that preparation before its quotient diagram. The shared core proof is essentially as comprehensible in either version; the preference for A comes principally from its contribution and hierarchy, not a claim that every local paragraph is better.

A's Section 4 proves the older named examples before Section 5 proves the new headline family. This is defensible as a short application of the surface theorem, but a reader following Theorem 1.1 directly could use a one-sentence instruction that Section 5 may follow the proof of Theorem 1.2. There is no need for another large roadmap or a restructuring of the entire proof.

## Major comments

No major exposition or scope defect was demonstrated by this comparison. I would not ask the author to split the new family and arithmetic pencil into a separate paper: they make the stabilization question more substantive, and the main-text/appendix separation controls the added scope.

Editorial acceptance of the exact-level and nonbirationality conclusions must nevertheless be coordinated with review of the particular companion revision supplying one-stabilization irrationality and Hodge conservation. The candidate identifies those imports honestly; this recommendation does not replace that review. A's reference [7] points to a September 2026 manuscript included in the accompanying source package. Before publication, that exact revision should have a persistent identifier or an equally precise durable citation.

## Minor comments

1. **A, page 2, before the quotient display:** introduce `Z`, `T0` and `T3` explicitly. For example, identify the projective Cox model, its rank-five torus and the rank-three subtorus in one sentence. Retain B's dimension calculation nearby if space permits. At present the diagram arrives before these symbols have been assigned their roles.
2. **A, page 1, first question:** replace “How many projective-space factors” by “How many stabilizing variables” or “What dimension of projective space.” The invariant measures the dimension `m`; a single factor can already be `P^m`.
3. **A, page 3, reading map:** give the family-first reader the short route through the proof of Theorem 1.2 to Section 5, with Section 4's named cubic examples optional on that pass.
4. **A, page 14, invariant table:** call the entries “j-invariants,” not just “invariants.” The mathematical role is recoverable from the following paragraph, but the table should name it immediately.
5. **A, page 11, transition to the signed action:** briefly identify the five pairs as the components of the singular conic-bundle fibres representing the del Pezzo ruling data before introducing the `c_i`. The current sentence and citation suffice for an expert reconstruction; one extra clause would make this new interface smoother.
6. **Both, Section 3:** the program identifier `CHARACTER_GENERATORS` interrupts otherwise mathematical exposition. The matrices and basis conventions are the relevant data; the implementation identifier belongs in the verification appendix.

## Editorial recommendation and blind preference

**Prefer candidate A.** I recommend publication after minor exposition and citation refinements, subject to satisfactory independent mathematical review of the cited inputs and the exact computations. The present read supplies a favorable specialist assessment of coherence, comprehension and declared dependency boundaries, not unconditional mathematical certification.

My specialist confidence in this editorial preference is high. A presents a broader and more memorable conclusion, makes its additional dependencies explicit, and keeps the original surface proof available as a complete independent route. B remains an effective focused account, and its introductory notation/dimension explanation should be restored in A. The net expansion is justified by the family and separation results.

## Mystery ledger and closeout

An explicit extra-value and structural closeout pass asked what explains the parameter choices and where a reader could still mistake a method limit for an intrinsic obstruction. The text settles the relevant points: saturation explains the apparent degree-two orbit ambiguity; subgroup containment explains uniformity under coefficient specialization; the distinct ranks one and three explain the squarefree separator; and the finite-index example distinguishes component degree from lattice index. No new mathematical mystery was uncovered within this comparison's scope. External-source validity and independent replay of the new symbolic calculations remain evidence boundaries owned by the separate mathematical audit, not hidden conclusions of this report.

This file is deliberately left uncommitted for the parent agent's coordinated task commit. No manuscript, certificate or handoff was edited.

## Targeted repair recheck

On 2026-09-11 I rechecked the six minor comments against the revised authority PDF at `papers/cubic-stabilization-irrationality/cubic_stabilization_irrationality.pdf`, still 24 pages, SHA-256 `dec5519fbcc127245575d098a25f1a936a62b955d8dfe1faf583ae4166c233fa`. This was a targeted recheck, not another full-paper or external-source review. I read revised pages 1–3, 6, 11 and 14, plus the relevant continuation on page 12, and visually inspected pages 2, 3, 11 and 14.

All six minor comments are resolved:

1. Page 2 now defines `Z`, `T0` and `T3` before the quotient display and gives the dimension calculation. The added paragraph and display fit cleanly on the page.
2. Page 1 asks for the least dimension of a projective-space factor, matching the definition of the level.
3. Page 3 supplies the direct reading route from the surface proof to Section 5. It also distinguishes optional Appendices A–D from the finite calculation in Appendix E, which Proposition 3.2 uses.
4. Page 14 explicitly calls the table entries j-invariants; the table remains readable.
5. The signed-action transition on page 12 identifies the five pairs as singular-fibre components encoding the del Pezzo ruling data before introducing the exchanges `c_i`.
6. Page 6 proceeds directly from the mathematical character/cocharacter basis to the stable sublattice. The implementation identifier has been removed from that passage.

No new exposition defect was found in these targeted passages. The preference for A is unchanged, and no specialist exposition revision requested by this report remains open. The parent reports that the companion revision is bundled and SHA-pinned; this recheck did not independently inspect that package or its mathematical contents. A durable publication identifier remains a publication-stage matter, not a request to deposit now. The original external-source and computation-review boundaries remain in force. The updated note remains uncommitted for the parent agent's coordinated commit.
