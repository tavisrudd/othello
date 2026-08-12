# C904 series-framing cross cold read

Date: 2026-08-11

## Method and verdict

This was a PDF-first cold read of the five supplied PDFs. Before reaching the verdicts below, I did not consult manuscript source, prior reports, notes, handoffs, or Git history. For each paper I read the abstract, full introduction, principal theorem statements, conclusion, and enough of the proof/reading map and secondary theorem statements to test logical dependence and advertised scope.

**Series-wide verdict: PASS, with minor pre-release cleanup.** The programme is now legible as a coherent study of reconstruction from lossy invariants. The intended asymmetry also works: Paper I is the entry point; Papers II--IV explicitly stand alone; Paper V is the capstone and imports/returns prior source data. There is no major mathematical scope mismatch in the openings or closings. The two points worth correcting are (1) Paper V's abstract should say explicitly that its all-extension equivalence concerns **neutral scalar extensions**, as its theorem does, and (2) series branding/dependency prose is repeated often enough to make the standalone papers look more serial than they are.

### Ranked triage

| Priority | Paper | Verdict | Reason |
|---|---|---|---|
| 1 | V, *Chordal and Conference Cubics* | **MINOR** | Strong capstone and strong final punchline; one abstract/theorem scope clarification is needed. |
| 2 | I, *Clebsch Rigidity* | **MINOR** | Excellent programme entry and visible infinite-family consequence; the opening contains avoidable companion inventory/cross-promotion. |
| 3 | II, *Quadratic Trade Rigidity* | **PASS** | Standalone all-field classification is visible and honestly bounded; one count sentence could name the omitted coalescence point. |
| 4 | IV, *Passant Code q=13* | **PASS** | Cleanest standalone fixed-field statement and conclusion; remove one uncited Paper-V bibliography entry. |
| 5 | III, *Golden Descent* | **PASS** | Dense but internally coherent; both the arithmetic theorem and the infinite-family reconstruction headlines are visible. |

No paper merits **MAJOR**.

## Series-level findings

### 1. Programme unity: strong

The common question is not merely asserted; each paper instantiates the same information-loss pattern with a different retained shadow.

- Paper I, PDF p. 2: “when can a sparse invariant determine the object that produced it?” The retained invariant is the maximum-distance syndrome locus.
- Paper II, PDF p. 1: “Restriction to a conic deliberately forgets the pairing,” followed by recovery from low-degree quotient data.
- Paper III, PDF p. 2: the three inverse questions ask what the branch sextic, marked conference/harmonic shadows, and low-order spectral/four-set data retain.
- Paper IV, PDF p. 2: row reduction erases the geometry, while weighted minimum-word pair data recover it.
- Paper V, PDF p. 2: “Different lossy invariants of the same source need not look alike,” and the theorem classifies when the two shadows retain equivalent information.

The resulting common spine is clear: **source -> lossy shadow -> reconstruction -> exact residual ambiguity**. Papers I--IV establish recognition/reconstruction results; Paper V explains why two visibly inequivalent shadows can encode the same source information.

### 2. Deliberate asymmetry: achieved, almost over-explicitly

The dependency declarations match the intended architecture.

- **I is the entry point.** Its series map appears on PDF p. 2, and the prose says: “The later papers study other shadows of related sources; none is used in the proofs here.” Its abstract already contains both the fixed exceptional theorem and the field-uniform consequence.
- **II is standalone.** PDF p. 2 says that connections with the other papers “are not used here” and that Paper V identifies the companion only “after the additional marking stated there.”
- **III is standalone.** PDF p. 2 says Paper V “supplies no hypothesis here,” and the first-pass route cleanly separates the Hitchin route from the independent conference consequences.
- **IV is standalone.** PDF p. 2 calls it “a standalone fixed-field inverse problem” and says it is “logically independent of the other Clebsch papers.”
- **V is the capstone.** PDF p. 3 says Papers I--III provide concrete sources for the two shadow types, while Paper IV is an independent branch. More decisively, PDF p. 6 states that “The quotient and signed moment are imported from Paper II's stable results”; Section 6 then records source-by-source returns.

The architecture is therefore not ambiguous. The only editorial risk is repetition: after I's map and V's capstone map, the explicit declarations of independence in II--IV begin to sound defensive. Their abstracts and local theorem statements already establish standalone status.

### 3. Infinite-family headlines: visible where they should be

- **I:** PDF p. 1 advertises the uniform window
  `2k - 3 <= q <= (k(k-1)+3)/3` and the finite all-field existence reduction; Theorem 4.4 states it on PDF p. 10, and the conclusion opens with it on PDF p. 27.
- **II:** PDF p. 1 says the classification ranges over full PGL2(q)-orbits over odd finite fields and that exactly B3/F7 and H3/F11 survive. Theorem 1.1(i), PDF p. 2, quantifies over “all odd prime powers q.”
- **III:** PDF p. 1 visibly states that aligned four-sets reconstruct every two-graph on at least seven vertices and that conference signings of order at least ten are recovered. These are exact in Theorem 5.4, PDF p. 21, and repeated in the conclusion, PDF p. 28. The general symmetric-conference spectral theorem is also explicit on PDF p. 19.
- **IV:** appropriately does **not** claim an infinite family. PDF p. 1 says the theorem is intentionally specific to q=13; PDF p. 2 and the conclusion, PDF p. 14, repeat the fixed-field boundary.
- **V:** PDF p. 1 visibly includes the lattice/residue theorem for every normalized symmetric conference matrix of order `n = 2 mod 4`; Theorem 1.3 states the same scope on PDF p. 4.

Thus the family-level results are not buried in appendices or conclusions. Paper III's title does not advertise its general two-graph theorem, but the abstract does, which is enough.

### 4. Paper V lands as a punchline, not a correction

The capstone's first sentence already prevents the wrong reading: the shadows are geometrically different, and the result concerns equivalent retained information rather than projective identification (PDF p. 2). Its main theorem then gives equivalences only after selecting the chordal line, and identifies the unselected map as a residual C2-torsor (PDF p. 4).

Most importantly, the conclusion opens (PDF p. 21): “The scattered shadows gather on one carrier, but not by becoming equal.” It then states the exact selected-line equivalence and bare C2-quotient before moving to the broader information-loss principle. That is a genuine series payoff. The caveats about markings, neutral base change, and unequal lattices feel like the sharp content of the punchline, not a retreat from an earlier overclaim.

### 5. Repeated series language: the main dilution risk

Three layers recur in all five papers:

1. the series title “Clebsch: Rigidity from Sparse Shadows -- [I--V]”;
2. the identical four-line epigraph beginning “From deep holes, a cubic takes shape” on PDF p. 1 of every paper;
3. a labeled “Reconstruction perspective” paragraph in every introduction.

Any two of these would establish unity. All three, plus explicit paper-number dependency sentences, make II--IV look like installments even when their mathematics is standalone. The repeated epigraph consumes prime title-page space and is the strongest source of serial over-branding. A clean division would be: keep the full map and programme language in I, keep the capstone map and return language in V, and let II--IV retain only their local inverse-problem sentence plus a short independence note if bibliographically necessary.

## Paper-by-paper cold read

### Paper I -- **MINOR**

**What works.** The abstract states the fixed q=11 recognition theorem immediately (PDF p. 1): conic containment of the uncovered locus forces the Clebsch hexagon, and in that case the locus is the full nonsingular conic. Theorem 1.1, PDF p. 3, makes the three-way equivalence exact, while Corollary 4.2, PDF p. 10, supplies the fixed-conic orbit statement needed for “reconstructs ... up to monomial equivalence.” The abstract and conclusion also make the uniform fixed-k field window visible. The conclusion, PDF p. 27, ends mathematically with syndrome-locus reconstruction and the golden operator rather than with verification administration.

**Minor issue.** The second half of the introduction turns into a companion inventory. PDF p. 4 lists “A separate computational companion,” Papers II--IV, and “the unnumbered Golden quantum-statistics companion.” The last phrase is especially release-note-like and unrelated to the main reconstruction theorem. This is the clearest place where series promotion dilutes an otherwise severe opening. Trim to the one map/dependency paragraph on PDF p. 2 and, at most, one concise related-work sentence.

**Scope check.** No mathematical mismatch found. The abstract's uniform k-arc claim is exactly the nonsingular-conic consequence of Theorem 4.4, PDF p. 10. The fixed-conic orbit statement justifies the coding-equivalence formulation.

### Paper II -- **PASS**

**What works.** The paper starts from its own object and inverse problem: restriction to a conic forgets a perfect matching (PDF p. 1). The all-field theorem is visible in the abstract and exact in Theorem 1.1(i), PDF p. 2. The theorem separates classification, quotient ranks, sheet recovery, cubic orientation, Gorenstein consequence, and the sharp off-carrier boundary. The proof map on PDF pp. 3--4 identifies the one load-bearing appendix and says the verification appendix contributes no logical premise. The conclusion, PDF pp. 25--26, returns to the information filtration: quadratic data recover the unordered factorization, and the first odd degree restores orientation.

**Minor clarity only.** The abstract, PDF p. 1, says the fixed affine line has q pairwise nonconjugate rational points and then counts one matching point plus q-2 nonmatching orbits. The remaining rational point is the coalescence parameter, but it is named only in the introduction on PDF p. 4: “the excluded rational point is the coalescence parameter.” Adding those two words in the abstract would close an otherwise momentary q-versus-q-1 count puzzle.

**Scope check.** No quantifier mismatch. The “all odd prime powers” statement is restricted to full perfect-matching orbits and the two-valued one-dimensional strength-two trade, exactly as in Theorem 1.1.

### Paper III -- **PASS**

**What works.** Although dense, the abstract distinguishes four layers: the arithmetic incidence cover, the marked bridge, the operator/cubic realizations, and two independent general consequences (PDF p. 1). The introduction's first-pass route, PDF p. 2, tells a reader which subsections are load-bearing and which are independent. Theorem 1.1, PDF p. 3, states the exact square class and Stein algebra; Proposition 1.2, PDF p. 4, states precisely what the marked sheet does and does not determine. The general theorems are not hidden: Theorem 5.3, PDF p. 19, characterizes order six by cut-independent exchange spectrum, and Theorem 5.4, PDF p. 21, gives the sharp seven-vertex two-graph reconstruction and the conference consequence from order ten. The conclusion, PDF p. 28, preserves the distinction between different ambient cubic spaces and restates the unresolved finite-prime boundary without weakening the characteristic-zero theorem.

**Density note.** The opening carries several publishable results, but the explicit “first-pass route” prevents them from reading as an accidental bundle. I would not demote the general reconstruction results: they are part of what makes the paper independently valuable.

**Scope check.** No mismatch found. The theorem says “up to complement,” and the conference corollary says “up to diagonal switching and global negation,” matching the abstract. The unresolved integral spreading problem is explicitly separated from the characteristic-zero algebra.

### Paper IV -- **PASS**

**What works.** This is the cleanest standalone opening. The abstract names the code, exact parameters, minimum-word count, four orbits, weighted-pair reconstruction, exact arity, automorphism group, full plane recovery, and F8 action, all before drawing the fixed-field boundary (PDF p. 1). Theorem 1.1, PDF p. 2, states both the reconstruction map and what remains noncanonical. The proof map, PDF p. 3, makes the finite endpoints and structural transports visible. The conclusion, PDF p. 14, focuses on the exact information threshold and again rejects a uniform distance claim.

**Copy detritus.** Reference [1] on PDF p. 14 is “T. Rudd, Chordal and Conference Cubics: Reconstruction and a Residual C2-Torsor, Paper V, companion manuscript, 2026.” It is not cited anywhere in the PDF text. Remove the uncited entry; it is the only clear bibliographic residue found in the five closings.

**Scope check.** No mismatch found. The “exact arity two” claim is supported by constant unary statistics and reconstruction from the weighted 2-section; the paper consistently limits all distance and full-plane claims to q=13.

### Paper V -- **MINOR**

**What works.** The opening is capstone-quality. PDF p. 2 states the conceptual distinction between unequal shadows and equivalent retained information, then gives the four-step mechanism. The series map on PDF p. 3 separates the upper common-carrier return from Paper IV's independent branch. Theorem 1.2, PDF p. 4, gives the selected-line equivalences and the exact unselected C2-quotient. Theorem 1.3 makes the general conference/lattice result visible. The conclusion, PDF p. 21, is the strongest series closing and should be preserved essentially as is.

**Scope/quantifier clarification.** The abstract, PDF p. 1, says that selecting either chordal line gives mutually inverse reconstruction functors “over every field extension of F11.” The theorem's exact statement on PDF p. 4 is narrower and more precise: “For every extension K/k, **neutral scalar extension** gives natural equivalences.” The preceding paragraph explicitly says the paper does not classify arbitrary twisted K-forms. Add “for neutral scalar extensions” to the abstract. Without it, an expert can reasonably read “over every field extension” as a classification of all K-forms.

**Production-register note.** Immediately before the conclusion, PDF p. 21 explains the verifier output “CHECK OK (NO_MATCH)” and that NO_MATCH is not a failed check. This is legitimate trust-boundary prose, not a mathematical defect, but it gives the capstone a momentary internal-build-register tone. The conclusion itself successfully resets the final impression.

## Mathematical scope and quantifier audit

1. **Real mismatch risk -- V abstract:** “over every field extension” should be synchronized with the theorem's “neutral scalar extension.”
2. **Clarity risk -- II abstract:** q points = one matching + q-2 nonmatching + one coalescence point; name the last term where the count first appears.
3. **Checked and consistent:** I's fixed-k field window; II's all-odd-prime-power matching-carrier classification; III's seven-vertex/tenth-order thresholds and characteristic-zero/integral boundary; IV's q=13-only reconstruction and exact arity; V's general `n = 2 mod 4` residue theorem.

I found no opening/closing claim that silently upgrades a computation to a conceptual theorem, no hidden dependence of II--IV on another series paper, and no claim that the chordal and conference cubics themselves are isomorphic.

## Copy and framing cleanup list

1. **Remove** Paper IV's uncited Paper-V reference (PDF p. 14).
2. **Cut or neutralize** Paper I's “unnumbered Golden quantum-statistics companion” sentence and compress the companion inventory (PDF p. 4).
3. **Reduce repeated branding:** consider retaining the common epigraph only in I and V, or retaining it in all papers but dropping the labeled “Reconstruction perspective” in II--IV.
4. **Retain V's conclusion:** “The scattered shadows gather on one carrier, but not by becoming equal” is the correct series punchline (PDF p. 21).
5. **Synchronize V's abstract scope** with Theorem 1.2 by inserting “neutral scalar extensions.”
6. **Name II's coalescence point** in the abstract count.

## Bottom line

The series now reads as one programme rather than five papers sharing an object: it studies which source structures survive different lossy invariants, how to reconstruct them, and what finite torsor remains when reconstruction is not canonical. The asymmetry is deliberate and visible. Papers II--IV can be handed to readers independently; Paper V depends on the earlier source data in precisely the way a capstone should. The remaining work is editorial compression and one genuine scope synchronization, not conceptual reframing.

## A/B closeout on rebuilt PDFs

Date: 2026-08-11

This closeout re-read the current rebuilt PDFs at abstract, full-introduction, main-theorem, proof/reading-map, and conclusion level. Verdict: **all requested repairs hold, and the repairs introduce no new scope, quantifier, dependency, or proof-mode mismatch.**

| Paper | A/B verdict | Exact confirmation / residual |
|---|---|---|
| I | **PASS** | I alone retains the common epigraph and the full entry-point series map (PDF pp. 1--2). The introduction's former companion list is reduced on PDF p. 4 to the one computational companion, Paper IV's structural account of its q=13 consequence, and the sentence “The remaining cross-paper architecture is recorded in Figure 1”; the “unnumbered Golden quantum-statistics companion” and the Paper-II/III inventory are gone. **Residual: none.** |
| II | **PASS** | The epigraph is gone. The abstract now closes the affine-line count on PDF p. 1: “the remaining rational point is the coalescence parameter.” PDF p. 2 says, “The classification and reconstruction are standalone; no companion construction is used here.” The all-odd-prime-power quantifier in Theorem 1.1 is unchanged and still restricted to full perfect-matching orbits with the stated trade condition. **Residual: none.** |
| III | **PASS** | The epigraph is gone. The paper remains internally routed by its own source--shadow--return figure; its only capstone pointer says Paper V supplies “no hypothesis here” (PDF p. 2). The repaired abstract's statement that, after the full marked bridge datum is fixed, the two sheets are labelled by a conference source and its opposite matches Proposition 1.2's componentwise statement (PDF p. 4). The characteristic-zero, finite-prime, two-graph, and conference-order quantifiers remain synchronized. **Residual: none.** |
| IV | **PASS** | The epigraph is gone. PDF p. 2 still states that this is a standalone fixed-field inverse problem, and the q=13-only boundary remains explicit in the abstract. The former uncited Paper-V bibliography item is absent; the current references begin with Ball--Lavrauw on PDF p. 15. The revised exact-arity sentence now says that weighted pair data recover the marked conic plane and polarity, exactly matching Theorem 1.1's reconstruction chain. **Residual: none.** |
| V | **PASS** | The abstract now says “for neutral scalar extensions over every field extension of F11” (PDF p. 1), matching Theorem 1.2's “For every extension K/k, neutral scalar extension gives natural equivalences” (PDF p. 4). V remains visibly the capstone through its series map (PDF p. 3), imported Paper-II datum (PDF pp. 5--6), and unchanged conclusion: “The scattered shadows gather on one carrier, but not by becoming equal” (PDF p. 20). **Residual: none.** |

### Series verdict

**PASS.** The deliberate asymmetry is now clean: I alone carries full entry-point branding; II--IV read as standalone inverse problems; V carries the marked return and common-carrier payoff. The common series title remains on all five papers, but the repeated epigraph has been removed from II--V, which is enough to eliminate the serial-overbranding problem identified in the first pass. No exact residual remains from the initial report.
