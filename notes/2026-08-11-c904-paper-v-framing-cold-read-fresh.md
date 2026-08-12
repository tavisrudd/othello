# C904 Paper V framing cold read, fresh

Date: 2026-08-11

Artifact read: `papers/chordal-conference-reconstruction/chordal_conference_reconstruction.pdf` (22 pages).

Protocol: PDF-first cold read of every page, including a rendered-page pass. No prior review, handoff, report, manuscript source, or Git history was consulted before the PDF pass was complete. Source was inspected afterward only to locate repairs.

## Verdict: MINOR

The mathematics advertised in the opening is present and substantially supported. The selected-line equivalence is cleanly separated from the unselected residual (C_2)-quotient; the fixed neutral metric-carrier scope is explicit; the six-point defect identity has a direct proof; and the binary-heart/Frobenius result has an independent lattice and modular-representation proof. Attribution and the trust boundary are unusually careful.

The paper is not yet a clean pass because the abstract does not make the inverse information-loss question intelligible before beginning the technical setup, and the central conference groupoid leaves one compatibility convention implicit. Both are local repairs. There are also removable repetitions and one apparently stale forward series reference.

## Opening and cold-reader framing

### What succeeds

- PDF p. 2 gives an excellent plain-language problem statement: “Different lossy invariants of the same source need not look alike. The inverse question is whether they nevertheless retain equivalent information.” It immediately distinguishes reconstruction from geometric isomorphism and states the selected/unselected contrast: “after one chordal line is retained, either shadow reconstructs the other ... Forgetting that line leaves exactly a (C_2)-ambiguity.” A general mathematical reader can understand the problem here.
- The title, “Chordal and Conference Cubics: Reconstruction and a Residual (C_2)-Torsor,” is technically honest and names both the mechanism and the obstruction. It is specialist-facing, however; by itself it does not expose the inverse information-loss question.

### Required framing repair

- PDF p. 1 begins the abstract with “Let Ω be the six Sylow-5 subgroups of (A_5)” and reaches only “We prove that they nevertheless encode the same marked carrier.” A cold reader has not been told what information is being lost, what a “marked carrier” operationally means, or why nonisomorphic cubics are being compared. The abstract then gives two dense theorem blocks before supplying that motivation on p. 2.
- Repair: move a one-sentence version of the p. 2 inverse question to the start of the abstract, then gloss “same marked carrier” as reconstruction of the common six-axis data. The exact source insertion point is `chordal_conference_reconstruction.tex:63`; the current object-first opening is at lines 64–76.
- PDF p. 1 also carries the ornamental series epigraph “From deep holes, a cubic takes shape ... and the scattered shadows gather home.” It previews series lore rather than the present inverse problem and repeats the conclusion’s “scattered shadows gather” image. Cutting it would give the abstract more authority and reduce copy-edit residue. Source: lines 56–61.

## Central mathematical checks

### Selected-line equivalence versus unselected quotient: PASS

- PDF p. 4, Theorem 1.2, states the selected-line equivalences and separately states: “after the selected chordal line is forgotten, … the unselected map is a residual (C_2)-torsor, not an equivalence.”
- PDF p. 12, Corollary 4.3, gives mutually inverse formulas on a selected line and then explains the obstruction: “Thus (h) and (-q_Πh) have the same oriented conference companion.”
- PDF pp. 13–14 proves full faithfulness/essential surjectivity and specifies that the quotient is an action groupoid, “including its morphisms and isotropy, rather than only an orbit set.” The dependency table on p. 14 correctly separates the selected-line sign, the unselected (uq)-fibre, and the fully forgotten Klein-four action.

### Neutral metric-carrier scope: PASS

- PDF p. 4 explicitly says: “We classify scalar extensions of this fixed quadratic carrier, not arbitrary twisted (K)-forms.” It also gives the precise reason for retaining the metric: cubic preservation alone leaves μ3 inertia, while the metric adds the square relation and forces the scalar to be one.
- PDF p. 13 uses the same square/cube argument in the full-faithfulness proof. PDF pp. 5 and 15 again state that arbitrary twisted forms and source-local charts are outside scope. There is no hidden claim to classify all forms of the carrier.

### Six-point defect theorem: PASS

- PDF p. 9, Lemma 3.4, states the exact identity
  (16|A(Δ)|=Σm(xy)^2) and the equivalence between empty alignment and (S^2=5I).
- The proof on pp. 9–10 derives the four-set indicator, sums first through triples and then through pairs, and uses (m(xy)=S_{xy}(S^2)_{xy}); the zero-defect conclusion follows because the diagonal of (S^2) is five. Complement and switching invariance are addressed.
- The paper distinguishes its direct order-six count from the neighboring literature on coherent/incoherent four-set counts and fourth-power criteria (PDF p. 2), and cites the classical order-six switching class in the proof (p. 9). No unsupported priority claim was found.

### Binary heart and Frobenius theorem: PASS

- PDF p. 16 proves that the rank-five augmentation and rank-six (D)-type lattices have the same four-dimensional binary heart without identifying the lattices.
- PDF pp. 16–17 proves the uniform root–weight saturation theorem directly, including minimality, switching independence, the quadratic relation, and faithfulness of the mod-2 coefficient algebra.
- PDF pp. 17–19 computes the A5-heart, proves nonsplitting and uniqueness, computes the Ext line from the (2,3,5) presentation, and then proves that conference reversal acts on the primitive scalars by Frobenius. The independent Paper-IV C3/F8 comparison is explicitly kept separate on p. 20: “They have different groups, modules, bases, and geometries, and no map between their carriers is asserted.”
- Attribution is proportionate: Chapman and Haemers–Parsaei Majd are identified as nearby conference/lattice precedents, Bleher as the nearby block-module description, while the manuscript prints the argument it actually uses.

## Must-fix precision issue

### The conference groupoid should state the ([B])–(c) convention and the full (uq) action

- PDF p. 13 defines objects as “conference packages ((Ω_0,[B],c)), where (c) is one of the two coefficient-normalized actual generators,” but it does not say whether ([B]) and (c) are the corresponding oriented pair or independent retained choices. The proof later speaks of “the normalized orientation” supplied by (c), so the intended convention is inferable but not formal.
- PDF p. 14 writes only “(uq:(L,h,c)↦(qL,-qh,c))” and says that it “preserves the conference package,” although the package definition also contains ([B]). Since the main theorem is an exact groupoid statement, the action on every retained component should be explicit.
- Repair at `chordal_conference_reconstruction.tex:956–963`: state either that (c=c_B) is the normalized generator paired with the chosen ([B]), or that the two choices are independent. Then at lines 1017–1030 write the induced action on ([B]) (even if it is fixed by convention) and one sentence defining the action on morphisms. This is a definitional repair, not a change to the reconstruction formulas.
- Nearby copy edit: PDF p. 13 says “every entry after (h) is required to be the construction of Sections 3 and 4,” but in the displayed tuple (R_h,Z_5,Ω_0,q_Π,L) all occur before (h). Source lines 947–955 should say “every derived entry” or reorder the tuple.

## Repetition, series residue, and overclaim audit

- PDF p. 3 repeats the already successful p. 2 opening almost verbatim: “This paper asks when two different shadows encode the same source information ... without that selection, the correspondence is exactly a residual (C_2)-quotient.” Keep either the p. 2 conceptual opening or this “Reconstruction perspective” paragraph as the main framing; the series map can follow a much shorter bridge. Source lines 181–192.
- The neutral-form boundary is stated three times: PDF p. 4 (“not arbitrary twisted (K)-forms”), p. 5 (“does not classify arbitrary twisted forms”), and p. 15 (“does not classify arbitrary twisted (K)-forms”). Retain it beside the definition/theorem and in the base-change corollary, but compress the p. 5 “Scope and exact information loss” paragraph. Source occurrences: lines 265, 416–419, and 1162–1164.
- PDF p. 14 has the immediate repetition “the action groupoid for the fixed-point-free autoequivalence ... which is fixed-point free.” Source lines 1019–1023; delete one occurrence.
- PDF p. 16 says the augmentation lattice “is the integral source for the later symplectic envelope in the series.” No later symplectic envelope is named in the PDF’s series map or references. This reads as a stale forward pointer; delete it or name and cite the exact companion. Source lines 1176–1177.
- PDF p. 16 ends, “This is the entire integral interface exported by Paper V.” The preceding mathematical sentence already says the sharper thing (“they do not become the same lattice”); the series-management sentence can be cut. Source lines 1208–1209.
- No substantive overclaim was found. PDF p. 21’s “complete information-loss statement” is supported if read inside the repeatedly stated fixed neutral-carrier scope. For maximal safety, qualify it locally as complete “for this fixed neutral metric carrier,” but this is optional rather than a theorem defect.

## Attribution, trust, and rendered-PDF audit

- The introduction marks classical six-point ingredients, the characteristic-zero chordal source, conference switching, and related two-graph counts with specific section/theorem citations. Source-local results are cited by paper and named statement. The new composition/compatibility boundary is stated neutrally.
- The trust section on PDF pp. 20–21 says exactly which coordinate transport is replay evidence and explicitly says it substitutes for none of the conceptual lemmas. The load-bearing structural arguments checked above are printed.
- All 22 rendered pages were inspected. No overflow, clipped equation, broken reference, orphaned caption, or illegible table was found. Figure 1 and the two data tables are small but readable at full-page resolution.

## Acceptance after repair

This should become PASS after: (1) one abstract-opening sentence exposes the inverse information-loss question; (2) Definition 5.1 and the (uq) quotient explicitly state the ([B])/(c) convention and action; and (3) the stale symplectic-envelope pointer and immediate repetitions are removed. No mathematical redevelopment is indicated by the cold read.

## Semi-blind A/B addendum

Protocol: the initial PDF and the review above were treated as A. For B, only the scoped Git diff of `papers/chordal-conference-reconstruction/chordal_conference_reconstruction.tex` and the rebuilt 22-page PDF were inspected. No other source, report, handoff, or history was consulted.

### B verdict: PASS

B resolves every acceptance item from A without broadening the mathematical claims.

#### Abstract and theorem alignment

- B PDF p. 1 now leads with the inverse problem: “Different lossy invariants of the same source need not have the same geometry. We ask when two such cubic shadows nevertheless reconstruct one another and their common six-axis data.” This makes the paper's question intelligible before the Sylow-subgroup and invariant-pencil setup.
- The all-field scope is now qualified in the abstract itself: the inverse functors exist “for neutral scalar extensions over every field extension of F11.” This matches Definition 1.1 and Theorem 1.2, rather than suggesting a classification of arbitrary twisted forms.
- The remaining abstract headlines match the displayed results: selected-line reconstruction and its residual C2 quotient match Theorem 1.2; the lattice saturation, nonsplit binary residue, and Frobenius torsor match Theorem 1.3; the six-point formula matches Lemma 3.4. No abstract claim exceeds the printed theorem scope.
- The A epigraph is gone. The first page is visually cleaner, and the abstract fits without crowding or a bad page break.

#### Groupoid sufficiency under hostile reading

- B PDF p. 12 now fixes the formerly implicit pairing: “c = c_B is the coefficient-normalized actual triangle cubic attached to the oriented switching class [B]; replacing [B] by [-B] replaces c by -c.” Thus the conference groupoid has two compatible orientations, not four independently chosen signs.
- The expanded-carrier definition on p. 12 now says “every derived entry Rh, Z5, Ω0, qΠ, L, c, [B] is required to be the construction of Sections 3 and 4.” This repairs the tuple-ordering error and prevents extra recognition data from entering Gmet.
- B PDF p. 13 gives the full object action: “uq : (L,h,c,[B]) ↦ (qL,-qh,c,[B]),” and immediately adds: “On morphisms it retains the same metric normalizer map and relabeling.” Because the earlier normalizer action on the G-invariant pencil factors through the order-two quotient, that same morphism carries qL to qL' and -qh to -qh'. The action is therefore a genuine autoequivalence, not merely an orbit-set prescription.
- Essential surjectivity is literal: compatible ([B],c) plus L recovers the unique normalized h by the inverse of (qΠ-1)|L, and reconstruction returns the same paired ([B],c). Full faithfulness is literal: a conference morphism carrying [B], c, and L carries this recovered h, while a chordal morphism carries all derived entries. The square/cube scalar argument still removes the only possible lift ambiguity.
- The quotient is exact: B p. 13 states that uq “is fixed-point free on objects and preserves the conference package”; its two-element orbits are precisely the fibres after L is forgotten. Since c and [B] are now explicitly fixed, no conference-orientation datum is silently lost in the quotient.

#### Repetition, source returns, and stale pointers

- B PDF p. 3 no longer repeats the p. 2 inverse-problem paragraph. “Reconstruction perspective” now does only the series-placement job: “Papers I–III supply concrete sources ... Paper IV supplies an independent C3-Frobenius instance ... with no common geometric carrier asserted.”
- The remaining neutral-scope statements have distinct jobs: definition-level scalar rigidity on p. 3, a reading-map boundary on p. 5, and the base-change limitation on p. 15. The conspicuous duplicated reconstruction paragraph and the immediate double use of “fixed-point free” are gone.
- The source-return claim remains properly bounded. B p. 14 says recovery is “Relative to the markings in the following table,” and p. 15 states: “No inverse is asserted outside the declared retained output.” The all-field corollary on p. 15 again restricts itself to neutral scalar extensions and explicitly excludes arbitrary twisted forms.
- Both stale integral-series pointers are deleted. B p. 15 now says only: “The first has rank five and the second has rank six.” B p. 16 ends the comparison mathematically: “The rank-five and rank-six outputs meet at HΩ; they do not become the same lattice.” There is no longer an unnamed “later symplectic envelope” or an “interface exported by Paper V.”

#### Rendered-B check

The changed B pages 1, 3, 12, 13, 15, and 16 were checked in extracted text and at rendered-page resolution. The new abstract lead, Definition 5.1, Proposition 5.2 quotient paragraph, and shortened lattice transition render cleanly. No overflow, collision, orphaned heading, or stale visible phrase remains.
