# C912 — Cubic stabilization referee-foundations revision

**Lane:** `clebsch`

**Status:** active; author-close only

**Current release gate:** GO for the repaired WP1--WP3 foundation tranche;
full-paper copy, detritus, visual, commit, and export gates remain open.  The
universal framed operator, normalized gauges, and Iritani comparison maps now
meet only in a faithful graded Hahn receiver after the positive completion,
with the coefficient field algebraically closed before the independent
integral loop coordinate is adjoined.  C912 remains active and author-close
only; WP4--WP6 remain prioritized work.

**Lifecycle rule:** keep this card open until the author explicitly closes it.
Passing implementation, review, export, and release gates does **not** authorize
automatic closure.

## Objective

Audit every claim in the Claude Fable referee report on
`papers/cubic-stabilization-epilogue/` against the manuscript and the cited
primary sources, repair only verified defects, and deliver a referee-readable
revision of the paper. The six prioritized work packages are:

1. rebuild the framed formal-monodromy foundation over the algebraic closure of
   the numerical Novikov function field;
2. define the finite-level characteristic-polynomial system through the unique
   normalized gauge, rather than implying an independent Artinian
   Levelt--Turrittin construction;
3. prove the comparison maps' adic continuity and freeze every load-bearing
   external statement to an exact source version and locator;
4. rederive the cubic indicial block and its primitive-sixth spectrum inside
   this paper;
5. make the divisor-tagging equality and root-evaluation argument fully
   explicit;
6. close the verified cycle-side and statement-hygiene seams without changing
   theorem strength.

The task is manuscript-facing. C910 retains ownership of the standalone Lean
companion and its formal coverage classification. Any Lean strengthening
triggered by this revision must follow the guarded Lean workflow and must not
be reported as closing a geometric or analytic manuscript input unless the
exact bridge is formalized.

## Non-negotiable scope

- Do not downgrade Theorem 1.1 or Theorem 1.2 merely because a referee requests
  more detail. Change theorem strength only if verification finds a genuine
  mathematical failure that cannot be repaired at the stated strength.
- Do not accept a referee premise by deference. Each item below must receive a
  source-backed verdict before its remedy is promoted.
- Do not edit unrelated Clebsch papers, historical task records, or the
  standalone Lean coverage partition.
- Do not replace stable internal reference labels with mutable section,
  equation, theorem, or bibliography numbers in tracking prose. The paper may
  cite frozen source-version equation numbers where the referee specifically
  requires exact external locators.
- Preserve the distinction between coefficient extensions (including Novikov
  roots) and ramified changes of the differential variable `z`.
- Preserve the paper's explicit boundary at one stabilization; do not describe
  the result as an obstruction to arbitrary stable rationality.
- Keep the card open until the author explicitly says to close C912.

## Referee-claim inventory and verification ledger

### Major comment 1 — framed formal monodromy over `K_T`

- [x] Locate the definition and every downstream use of framed formal
  monodromy and `nu_6`.
- [x] Test the rank-one equation `partial_z y = (a/z)y` for
  `a in K_T minus C`.
- [x] Verify that the phrase "one turn" does not canonically define
  `exp(2 pi i a)` over an abstract algebraically closed coefficient field.
- [x] Verdict: **genuine foundational defect; first priority**.
- [x] Choose and state a canonical cyclotomic formulation whose root-of-unity
  multiplicities do not depend on auxiliary exponential choices.
- [x] Prove equivalence with ordinary framed formal monodromy over `C`.
- [x] Prove invariance under algebraic coefficient extension and adjoining
  numerical Novikov roots inside the fixed algebraic closure.
- [x] State separately how ramified `z`-extensions contribute deck factors.
- [x] Rewrite `nu_6` using the repaired definition.
- [ ] Audit every theorem and proof using `nu_6` for unchanged meaning.
- [ ] Ask a differential-equations referee to cold-check the construction,
  choice independence, ramification convention, and primitive-root count.

### Major comment 2 — comparison theorems and source interfaces

- [x] Check whether the manuscript already quotes the relevant formulas from
  Iritani's blowup theorem and Iritani--Koto's projective-bundle theorem.
- [x] Verdict: **partly addressed already, but the paper's own adic-continuity
  step remains asserted rather than proved**.
- [ ] Pin exact versions for every load-bearing preprint in the bibliography
  and verification record.
- [ ] Quote the precise integral-`z`, `z`-independent mirror-coordinate,
  normalized-bulk, definedness, and inverse identities used from each source.
- [ ] Add an internal lemma: a coefficient map taking the source augmentation
  ideal into `J` extends continuously to the completed rings and descends at
  every `J^N` stage.
- [ ] Prove that comparison matrices and their inverses descend modulo `J^N`
  and retain both inverse and intertwining identities.
- [ ] Freeze the parity-preservation citation to Iritani's exact version,
  remark, and assertions rather than citing a broad section.
- [ ] Verify that adjoining `q`-roots is only coefficient extension inside the
  fixed algebraic closure and introduces no `z`-deck eigenvalues.
- [ ] Build a claim/source/locator table for Proposition 4.6.
- [ ] Cold-check all four source interfaces independently.

### Major comment 3 — finite-level definition and divisor equation

- [x] Inspect the current recursion, uniqueness, and reduction statements.
- [x] Verdict: **the recursion is present; the definition/proof order and the
  divisor-substitution reconciliation need repair**.
- [ ] Define the finite-level characteristic polynomial by transporting the
  base-changed small framed polynomial through the unique normalized gauge.
- [ ] State explicitly that no separate Levelt--Turrittin theory over the
  Artinian quotients is being invoked.
- [x] Prove uniqueness of the normalized gauge before defining the invariant.
- [ ] Prove adjacent reduction compatibility of the gauge and polynomial.
- [ ] Add the paragraph reconciling divisor substitution with positive-bulk
  gauge invariance: the former is a filtered coefficient automorphism and the
  latter supplies the normalized identification.
- [ ] Spell out the intrinsic/tagged/specialized polynomial equalities and the
  evaluation at a primitive sixth root fixed by the coefficient embedding.
- [ ] Recheck the initial-term/Vandermonde independence over the fraction field
  of the associated graded ring.

### Major comment 4 — nef vanishing

- [x] Compare the manuscript proof with the cited claim in the recent
  preprint.
- [x] Verdict: **already self-contained in substance; no new theorem proof is
  needed**.
- [ ] Rewrite the citation as attribution/support rather than an external
  logical dependency.
- [ ] Check the numerical Novikov grading, both parity cases, nilpotent
  residue, and undoing of the half-parity twist in the final prose.
- [ ] Make the `P^2 = P_pt(C^3)` reduction explicit.

### Major comment 5 — cycle-side Roulleau/Hartlieb interface

- [x] Verify the generic non-CM argument and distinguish it from fibrewise CM
  specializations.
- [x] Verdict: **core argument is correct; short interface explanations are
  warranted**.
- [ ] State that the non-CM assertion is at the geometric generic point and
  cross-reference the later prescribed-lattice treatment of CM fibres.
- [ ] Explain why changing a target elliptic quotient by `+/-1` changes both
  quotient and inclusion coherently and leaves `i_H q_H`, divisor classes,
  and the `(5,-1)` Rosati entries unchanged.
- [ ] State the separatedness/properness input used to extend a generic-fibre
  equality of abelian-scheme homomorphisms.
- [ ] Prefer a classical reference or give an ad hoc relative-dimension-one
  argument for images of abelian schemes.

### Major comment 6 — two-/three-primary exclusion and theta descent

- [x] Verify the logical use of the three-primary classification in excluding
  rational two-primary kernels.
- [x] Verdict: **mathematically correct, but dependency should be displayed**.
- [ ] Write the implication explicitly: a rational two-primary half is
  `S_6`-fixed; every three-primary half is `S_6`-fixed; hence the full kernel is
  `S_6`-fixed.
- [ ] Explain that the quotient polarization is a polarization class and that
  translation/Appell--Humbert semicharacter choices do not change its first
  Chern class or the Neron--Severi coefficient lattice.
- [ ] Add the same clarification at graph-lattice descent if needed.

### Major comment 7 — final integral step

- [x] Check the algebraic assertion that vanishing after tensoring with every
  `Z_p` forces integral vanishing.
- [x] Verdict: **the referee's proposed torsion prerequisite is not needed for
  the finitely generated quotient used here; no mathematical gap found**.
- [ ] Add at most one clarifying sentence identifying the finite-generation
  argument if it materially helps readers.
- [ ] Do not introduce a false dependency on prior rational divisor-product
  membership.

### Minor comments

- [x] Inspect the rendered kernel-order superscripts.
- [x] Verdict: **rendered PDF is correct; no source repair needed**.
- [ ] Add the coefficient-extension versus `z`-ramification reminder at the
  exact comparison-map uses.
- [ ] Make the `P^2` projective-bundle reduction explicit.
- [ ] Confirm the two genus-eight projective bundles are fourfolds and retain
  the exact flop citation.
- [ ] Check publication/version wording for the `(0,2)` table row.
- [ ] Add the higher-stabilization companion cross-reference if it improves
  scope clarity without adding dependency.

## Prioritized implementation checklist

### WP1 — cyclotomic framed spectrum

- [x] Write a self-contained algebraic definition of the cyclotomic part of
  framed formal monodromy after Levelt--Turrittin.
- [x] Specify the allowed exponential extension and prove that precisely the
  rational exponent classes map to roots of unity.
- [x] Show primitive-sixth multiplicity is independent of complement,
  exponential splitting, ordering of LT blocks, and algebraic coefficient
  extension.
- [x] Treat ramified blocks and deck permutations explicitly.
- [x] Prove agreement with analytic monodromy over `C`.
- [x] Replace the old Definition 4.1 and update Definition 4.2 and all uses.
- [ ] Add a short reader-facing example, including the nonconstant rank-one
  exponent that invalidates the old wording.
- [x] Run a dedicated adversarial mathematical review before moving to WP2.

### WP2 — normalized-gauge finite levels

- [x] Reorder the section so existence/uniqueness precedes finite-level
  invariant construction.
- [x] Construct normalized gauges at each finite positive cutoff, assemble
  them by uniqueness, and compare framed operators only in an explicitly
  typed faithful graded receiver.
- [x] Prove the cutoff compatibility and inverse identities before passing to
  the receiver; no monodromy operator is placed over a nonfield quotient.
- [x] Ensure the pro-system is assembled from those proved identities.
- [x] Remove every sentence suggesting independent Artinian formal monodromy.
- [x] Check the Lean companion prose remains honest about its formal boundary.

### WP3 — adic continuity and frozen sources

- [x] Prove the faithful completed/graded-Laurent Hahn receiver construction.
- [x] Prove degreewise continuity of the full nonlinear coordinate maps and
  their inverse identities before faithful embedding.
- [x] Record exact source versions, theorem/remark names, and equation locators
  for the repaired completion bridge.
- [x] Quote only the minimum source statements consumed by that bridge.
- [ ] Audit parity preservation and even-connection restriction.
- [ ] Re-run the literature evidence log and store immutable source identities.

### WP4 — internal cubic endpoint

- [ ] Display the small even quantum connection matrix in the basis
  `1,P,P^2,P^3`.
- [ ] Perform the formal integral-`z` block reduction in the paper.
- [ ] Derive the rank-two indicial polynomial
  `rho^2 + rho + 5/36`.
- [ ] Derive roots `-1/6,-5/6` and eigenvalues
  `exp(+/- pi i/3)` with the repaired framed convention.
- [ ] Show the two rank-one exponential blocks are unramified and contribute
  no primitive-sixth eigenvalues.
- [ ] Conclude `nu_6(X)=2` without using Cai's gauge assertions as a black box.
- [ ] Retain Cai as attribution and compare calculations line by line.

### WP5 — divisor tagging

- [ ] State the finite support and associated-graded initial-form setup.
- [ ] Write the integral-direction selection argument.
- [ ] Write the Vandermonde determinant and nonvanishing conclusion over
  `Frac(gr A)`.
- [ ] Name the intrinsic polynomial, tagged polynomial, and specialized
  polynomial separately.
- [ ] Display both polynomial equalities and the field embeddings fixing `C`.
- [ ] Evaluate at the primitive sixth root explicitly.
- [ ] Explain why divisor substitution and positive-filtration gauge invariance
  are compatible, not contradictory.

### WP6 — cycle and exposition seams

- [ ] Add the generic-point non-CM qualification and CM-fibre cross-reference.
- [ ] Add the coherent `+/-1` target-automorphism explanation.
- [ ] Add the Hom-scheme extension input.
- [ ] Add the two-/three-primary logical dependency sentence.
- [ ] Add the polarization-class/semicharacter sentence.
- [ ] Add the finite-generation clarification only if useful.
- [ ] Resolve all verified minor comments.
- [ ] Keep prose changes surgical; do not add a new page without need.

## Review protocol

### Mathematical cold reads

- [ ] Quantum referee A: read the revised paper context-free, concentrating on
  LT theory, cyclotomic exponent classes, ramification, and field extensions.
- [ ] Quantum referee B: independently verify Proposition 4.6 against the
  frozen versions of every cited preprint.
- [ ] Quantum referee C: recompute the cubic block and divisor-tagging endpoint
  without using the manuscript's intermediate assertions.
- [ ] Geometry referee: recheck the complete cycle spine and every new
  Roulleau/Hartlieb/polarization clarification for regressions.
- [ ] General referee: cold-read the entire paper at the stated landmark-result
  standard and issue stable finding IDs with exact severity.
- [ ] Every NO-GO finding receives an exact repair and a fresh repeat review.
- [ ] No self-review substitutes for the independent cold reads.

### Copy edit and detritus reviews

- [ ] Run a context-free copy edit for grammar, punctuation, displayed-math
  introductions, antecedents, theorem-strength words, and sentence length.
- [ ] Run a separate detritus audit for stale review prose, workflow language,
  mutable internal IDs, hard-coded internal reference numbers, duplicate
  caveats, dead TODOs, obsolete version claims, and old PDF filenames.
- [ ] Check all cross-references, bibliography keys, URLs, arXiv versions, and
  quoted equation locators.
- [ ] Check theorem names, abstract, introduction, conclusion, summary README,
  verification README, C910 card, and standalone metadata for exact agreement.
- [ ] Confirm no unrelated paper/table claims changed.

### Build, trust, and visual gates

- [ ] Run the paper's supported `make check` gate.
- [ ] If Lean changes, run only the guarded Lean build and axiom-audit route.
- [ ] Confirm the rejecting theorem inventory and coverage partition remain
  exact; record and justify any intentional change.
- [ ] Build the PDF through the supported deterministic route.
- [ ] Inspect every page visually, including formulas, superscripts, tables,
  floats, references, and final-page balance.
- [ ] Check logs for undefined references/citations and layout warnings.
- [ ] Confirm deterministic rebuild and record page count and checksum.
- [ ] Red-team the complete diff against the pre-C912 authority commit.

### Commit and export gates

- [ ] Commit each coherent repair tranche with exact-path staging.
- [ ] Never mix foreign worktree changes into a C912 commit.
- [ ] Finish every started edit; leave no dangling manuscript tranche.
- [ ] Commit the final reviewed manuscript and generated PDF together where the
  repository convention requires it.
- [ ] Run export plan/audit/sync from an immutable source commit.
- [ ] Update all standalone links and metadata if filenames or commit targets
  change.
- [ ] Do not push unless the author separately requests it.
- [ ] Report the final authority commits, page count, checksum, review verdicts,
  and any remaining explicit assumptions.
- [ ] Leave C912 **open** after all green gates; await explicit author closure.

## Mystery ledger

Record discoveries that materially affect the paper, even when they do not
become manuscript edits.

| ID | Status | Discovery | Resolution / owner |
|---|---|---|---|
| C912-M01 | confirmed | Analytic "one turn" is not canonically defined for arbitrary `K_T`-valued exponents. | WP1; C912 |
| C912-M02 | confirmed | The finite-level recursion exists, but the prose conflates a gauge-transported invariant with independent Artinian formal monodromy. | WP2; C912 |
| C912-M03 | confirmed | The source comparison formulas are substantially present, while continuity for the paper's own completions is not proved. | WP3; C912 |
| C912-M04 | confirmed | The nef vanishing proof is already self-contained in substance. | Wording/source audit only |
| C912-M05 | confirmed | The referee's claimed torsion prerequisite for the final local-to-integral step is unnecessary in the finitely generated setting. | Preserve proof; optional clarification |
| C912-M06 | resolved | The choice-independent formulation uses `K[V]`, the universal exponential with torsion preimage `Q`, and the intrinsic orbit relation `U^(e/d) = M_RS`; a focused adversarial review rejected three weaker drafts before accepting this form. | WP1; `C912-QF-001` and `C912-QF-002` closed |
| C912-M07 | resolved | A universal exponential field built from `C[V]` does not contain the original coefficient field and cannot carry its LT matrices. | Replaced by `K[V]`; `C912-QF-001` |
| C912-M08 | resolved | Factoring a ramified return as a scalar finite descent character times a fractional residue exponential fails in resonant multiplicity spaces. | Replaced by the intrinsic return-power argument; `C912-QF-002` |
| C912-M09 | resolved | The source operator over `Omega_V` cannot be base-changed directly to `B/F^N`; ordering the finite gauges first does not by itself type the comparison. | Framed operators are now compared only after faithful graded embedding; `C912-GEN-001` / `C912-GEO-001` closed |
| C912-M10 | resolved | No coefficient map from the universal LT constants field `Omega_V` to the nilpotent quotient rings `B/F^N` is supplied or generally available. | The repair uses no such map: it completes positive/scaled variables first and embeds gauges and comparison maps into a common Hahn receiver |
| C912-M11 | resolved | Extending the positive ideal across Iritani's Laurent coordinate makes it the unit ideal, while ordinary localization misses series whose Laurent pole order grows with bulk degree. | Use the sources' homogeneous scaled variables and finite-below grading; pull through the full nonlinear coordinate isomorphism, embed in a coefficient Hahn field, construct `Omega_V`, then adjoin only integral powers of the independent loop coordinate |

## Close condition

C912 has no automatic close condition. Even after every checkbox above is
green and the reviewed standalone export is synchronized, its status remains
`active; author-close only` until the author explicitly instructs that C912 be
closed.
