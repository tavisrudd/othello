# C912 — Cubic stabilization referee-foundations revision

**Lane:** `clebsch`

**Status:** active; author-close only

**Current release gate:** GO for the repaired WP1--WP3 foundation tranche at
authority commit `9ee4987c7`; full-paper copy, detritus, visual, build, and
commit and standalone-export gates are green.  The
universal framed operator, normalized gauges, and Iritani comparison maps now
meet only in a faithful graded Hahn receiver after the positive completion,
with the coefficient field algebraically closed before the independent
integral loop coordinate is adjoined.  C912 remains active and author-close
only.  WP4 has begun in reviewed microincrements: commit `7f5d1439b`
displays Cai's exact small-even cubic connection matrix with its coefficient
and original-loop-coordinate conventions; commits `4a8d4d638` and
`09c571ec2` give the independently checked integral-`z` block reduction and
its stable Section~4 numbering; commits `f8f9f0bda` and `ae0cad04f` derive
the rank-two indicial equation coefficient by coefficient.  The roots and
framed eigenvalues are derived in commits `af1cc0c9e` and
`18fd50077`; commits `62c9b068e` and `44ddeb801` derive the two unramified
rank-one factors and their trivial regular monodromy; commits `23ddd1c6f`
and `e99e503b1` close the nonresonant Frobenius recursion and exact framed
count while preserving Cai's starting-matrix role.  The independent
coherent-tranche reviews are GO (`C912-WP4-CR-GO-001` and the closed
`R-WP4-*` findings), with source/scope repairs at `f4a959bf8`.  WP4 is
accepted.  WP5 through WP11 are landed: the divisor-tagging exposition at
`5a6362680` and `a9fd9b84e`, the cycle and exposition seams at `011580e55`,
the repositioning at `0db2a97fc`, `131e926d6`, `d92f27904`, `ac0bfee7b`, and
`0378e2ae1`, the source-version locator repair at `9c3518861`, the reopened
foundation rechecks at `87b6170e1`, the cold-read repairs at `a5fd508c2`, and
the forward-citation sweep recorded in
`../2026-08-14-c912-forward-citation-sweep.md`.  The paper now carries the
retitle and two-theorem framing (WP12 below) and builds warning-free at 30
pages.  What remains open on this card is the residual list under each work
package, not a whole package, plus the frame-transport lemma owed to referee A,
which is blocked on an architecture decision recorded in
`../2026-08-15-c912-frame-transport-receiver-obstruction.md`.

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

An external reader added two more on 2026-08-14, both verified against sources
before acting:

7. reposition the paper against the pre-emptions of the separation family;
8. repair the source-version locators, which are not all at the pinned
   version;
9. recheck the four load-bearing points the reader named inside the accepted
   foundation tranche;
10. close the pre-emption risk with a forward-citation sweep of the principal
    sources.

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
- [x] Audit every theorem and proof using `nu_6` for unchanged meaning.
- [x] Ask a differential-equations referee to cold-check the construction,
  choice independence, ramification convention, and primitive-root count.

### Major comment 2 — comparison theorems and source interfaces

- [x] Check whether the manuscript already quotes the relevant formulas from
  Iritani's blowup theorem and Iritani--Koto's projective-bundle theorem.
- [x] Verdict: **partly addressed already, but the paper's own adic-continuity
  step remains asserted rather than proved**.
- [x] Pin exact versions for every load-bearing preprint in the bibliography
  and verification record; done in WP8, including the seven entries that
  carried no version and a line stating that numbered statements follow the
  preprint versions.
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
- [x] Audit parity preservation and even-connection restriction.
- [ ] Re-run the literature evidence log and store immutable source identities.

### WP4 — internal cubic endpoint

- [x] Display the small even quantum connection matrix in the basis
  `1,P,P^2,P^3`.
- [x] Perform the formal integral-`z` block reduction in the paper.
- [x] Derive the rank-two indicial polynomial
  `rho^2 + rho + 5/36`.
- [x] Derive roots `-1/6,-5/6` and eigenvalues
  `exp(+/- pi i/3)` with the repaired framed convention.
- [x] Show the two rank-one exponential blocks are unramified and contribute
  no primitive-sixth eigenvalues.
- [x] Conclude `nu_6(X)=2` without using Cai's gauge assertions as a black box.
- [x] Retain Cai as attribution and compare calculations line by line.

### WP5 — divisor tagging

- [x] State the finite support and associated-graded initial-form setup.
- [x] Write the integral-direction selection argument.
- [x] Write the Vandermonde determinant and nonvanishing conclusion, now named
  over `Frac(gr_v A)` and tied to characteristic zero.
- [x] Name the intrinsic polynomial, tagged polynomial, and specialized
  polynomial separately, as `p^int`, `p^tag`, and `p^spec`.
- [x] Display both polynomial equalities, `p^tag = p^int` from injectivity of
  the tagging map and `p^tag = sigma(p^spec)` from the base-shift gauge, with
  the embeddings and the coefficient automorphism stated to fix `C`.
- [x] Evaluate at the primitive sixth root explicitly: since the root lies in
  `C` and both comparisons fix `C`, the three vanishing conditions agree, with
  equal multiplicities. Only the stated implication is used.
- [x] Explain why divisor substitution and positive-filtration gauge
  invariance are compatible: the divisor equation splits the bulk divisor
  direction into a coefficient automorphism, invisible to characteristic
  polynomials, and a positive-filtration deformation, which is what the
  normalized gauge removes. They act on different factors.
- [x] Say where the domain hypothesis on the associated graded enters; done in
  WP9.

WP5 is complete. The paper now runs 29 pages and builds warning-free.

### WP6 — cycle and exposition seams

- [x] Add the generic-point non-CM qualification and CM-fibre cross-reference:
  the non-CM statement is now marked as holding at the geometric generic point,
  with special fibres routed to the prescribed-lattice reading after
  `thm:all-degree-graph-saturation`.
- [x] Add the coherent `+/-1` target-automorphism explanation. Negating a
  target identification negates `q_H` and, by functoriality of Rosati duality,
  `i_H`, so `N_H = i_H q_H` and `D_H = q_H^*[0]` are unchanged; the Gram matrix
  moves only by a signed congruence, which preserves the Smith type. Note the
  off-diagonal entries do flip under a single-index change of sign, so the
  claim is invariance of the objects used, not entrywise invariance.
- [x] State the extension input for abelian-scheme homomorphisms. The
  scheme-theoretic image cites Achter--Casalaina-Martin--Wise for the
  abelian-scheme structure, with the relative dimension pinned locally by
  `n_H^2 = 10 n_H`; the generic-fibre equality extends because two morphisms
  from an integral scheme to a separated one agree along a closed subscheme
  containing the dense generic fibre.
- [x] Add the two-/three-primary logical dependency sentence, stated in the
  three-clause form the review asked for.
- [x] Add the polarization-class/semicharacter sentence at the descent step.
- [x] Add the finite-generation clarification: free and finite parts are both
  detected by the `p`-adic completions.
- [x] Resolve the verified minor comments: the coefficient-extension reminder
  now says "in the Novikov direction, not a ramification of `z`" at both
  comparison-field uses; the `P^1`, `P^2`, and ruled-surface reductions are
  written out; the genus-eight bundles are identified as rank-two bundles over
  threefolds, hence fourfolds, with the flop citation moved into the proof.
  The `(0,2)` row needs no repair: no section claims publication for any
  preprint, and the cited version is pinned.
- [x] Keep prose changes surgical: the paper stayed at 29 pages across the
  whole work package.
- [ ] Declined for now: the higher-stabilization companion cross-reference. It
  would add an external dependency to a scope paragraph that already states
  the boundary, which the review made conditional on improving clarity.

### WP7 — positioning against the pre-emptions

- [x] Verify Yang--Yu--Zhu, arXiv:2508.03623: a two-dimensional family of
  smooth cubic threefolds with unirational parametrizations of degrees two and
  three, universally `CH_0`-trivial by their own introduction, with
  Corollary 3.5 extending the parametrizations to `X x P^m`.
- [x] Verify that Voisin's Theorem 4.5 with Lemma 4.6 already gives components
  of codimension at most three carrying an algebraic minimal class, and that
  Colliot-Thélène's almost-diagonal theorem covers the Fermat cubic threefold.
- [x] Lead the abstract, introduction, and README with the uniform one-step
  irrationality theorem; present the `A_5`-pencil as a separate mechanism.
- [x] Record both pre-emptions and the read depths in the novelty ledger.
- [x] State the pencil's moduli dimension against the Yang--Yu--Zhu locus, and
  print the Fermat membership, crediting Hartlieb's Lemma 5.5.
- [x] Turn the imported loci into separation corollaries of the one-step
  theorem: Voisin's codimension-three components, the Fermat equation, and the
  Yang--Yu--Zhu family, proved in the synthesis section.
- [x] Frame the Yang--Yu--Zhu stable-rationality question as verified at the
  first stabilization only, not answered.
- [ ] Recheck the scope paragraph and the abstract for any remaining
  first-example rhetoric.

### WP8 — source-version locator repair

- [x] Repair both stale Iritani--Koto locators in `sections/04-one-step.tex`.
  The asymptotic display cited "Section 5.8, especially (5.11)", and the
  maximal-ideal placement cited "Formula (5.11)"; in the pinned
  arXiv:2307.03696v4 that section is the added Hinault--Yu--Zhang--Zhang
  reconstruction algorithm. Both now cite Theorem 5.1(4) and Proposition 5.6,
  which carry the content actually used.
- [x] Recheck the use of Theorem 5.1(5), the item v4 corrected, against its v4
  statement `(d_{tau i,k} varsigma_j)|_{Q=tau=0} = lambda_j^k (phi_i + O(q^{-1/r}))`,
  invertible over `C((q^{-1/r}))`. The corrected statement still supports the
  use, and the prose now records the correction and the version date.
- [x] Check whether anything depends on the `log q` term that v4 removed from
  the change of coordinates for Theorem 1.7. Nothing does: the paper cites
  only Section 5.1 with its equations (5.1)--(5.3), Theorem 5.1, Proposition
  5.6, Corollary 1.8, equation (1.1), Remark 1.2, and Remark 5.2, and Section
  5.1 opens by presenting itself as the precise version of Theorem 1.7. Every
  one of those locators was checked against v4 and carries the claimed
  content.
- [x] Audit the Iritani blowup locators against the pinned arXiv:2307.13555v3:
  Corollary 1.2, Remarks 1.3--1.5, Proposition 5.4 with (5.13)--(5.14),
  (5.15), Remark 5.6, Theorem 5.18, and Section 5.8.2 all exist there and
  carry the claimed content. Note that (5.15) is exactly the center Novikov
  specialization the reader flagged as possibly noninjective, so WP9 inherits
  it with a verified locator.
- [x] Pin every version that was unpinned, since the bibliography now promises
  it: Iritani's notes to v2, Hartlieb to v2, Voisin to v2, Colliot-Thélène to
  v3, Grieve to v2, Roulleau to v1, Kuznetsov to v1. A line before the
  bibliography states that numbered statements follow the preprint versions,
  which matters because Hartlieb's Lemma 5.5, Voisin's Theorem 4.5, and
  Colliot-Thélène's main statement were all verified in the preprints and the
  published articles were not accessible.
- [ ] Re-verify Cai's page-level locators against the pagination of
  arXiv:2608.01577v1, and Engel--de Gaay Fortman--Schreieder Theorem 1.3 and
  Corollary 1.4 against arXiv:2507.15704v3. The cached copies match the
  pinned versions; the individual pages and statements were not re-read in
  this pass.

### WP9 — reopened foundation rechecks

The external reader named four load-bearing points inside the accepted
WP1--WP3 tranche. Each needs an independent recheck, not a re-reading.

Rendered numbers moved when the clarifying remark was added, so the items are
keyed to the semantic labels.

- [x] `lem:formal-base-shift`, the reader's Lemma 4.4: no defect. The Laurent
  lower bound at level `N` does decrease without limit, and that is harmless
  because `def:pro-laurent-gauge-group` is the inverse limit of the finite
  levels, which for finite-dimensional `V` is `GL(V (x) L_{B,F})` itself; a
  compatible family therefore has an inverse in one ring, conjugation
  preserves the characteristic polynomial over any commutative ring, and
  integral `z`-powers at every level keep the original-disc frame. Added
  `rem:pro-laurent-concrete`, which describes `L_{B,F}` element by element as
  a series whose coefficients enter arbitrarily deep filtration as the
  exponent decreases, states the identification of the gauge group, and is
  pointed at from the step where the bound appears.
- [x] `prop:framed-operations`, the reader's Proposition 4.6: the
  source-facing claims hold against the pinned versions. Iritani's Theorem
  5.18 gives the decomposition over `C[z]((q^{-1/s}))[[Q, tau]]`, so the
  isomorphism and its inverse carry only integral powers of `z` and the mirror
  coordinates are `z`-free, as the manuscript asserts. The manuscript's
  convention `s_c = c-1` for even `c` and `2(c-1)` for odd `c` matches
  Iritani's own sentence that `s` equals `r-1` or `2(r-1)` according to the
  parity of `r`. Strengthened the completion step: the coefficient ring of
  Iritani--Koto (5.3) is now named as a power series ring, its exponent monoid
  is noted to be finitely generated because `0 <= k <= r-1`, and the order is
  stated to be positive on those generators, so supports are well-ordered.
- [x] The center specialization: the manuscript's map
  `Q^{i_* d} q^{-rho_C . d/(c-1)}` is exactly Iritani (5.15), the
  noninjectivity is real because `i_*` can have a kernel, and the valuation
  identity `v_H = (H|_C) . d` follows from the projection formula with
  ampleness of `H|_C` supplying positivity and properness. No defect.
- [x] `lem:divisor-tagging`, the reader's Lemma 4.8: the domain hypothesis on
  the associated graded is now located precisely in the proof. It makes the
  valuation multiplicative, so each monomial image has valuation exactly
  `l(d)`, the exponential tag is a unit of valuation zero, no product jumps,
  and the degree-`mu` identity holds with the coefficients intact. This closes
  the referee item that WP5 was carrying.
- [ ] Residual: re-derive the continuity claim for the inverse of the full
  coordinate map, which is asserted from the invertible linear term and the
  degreewise finiteness of substitution. The structure supports it; the
  recursion was not written out.

### WP10 — deep literature sweep closing the pre-emption risk

Three pre-emptions surfaced on 2026-08-14 from a single external prompt, and
the ledger's audit boundary still records MathSciNet as uncovered and the
forward trees of the principal sources as unclosed. This work package closes
that gap. It is bound by `notes/literature-audit-conventions.md` in full; the
verdict text lives only in `claim-proof-novelty-ledger.md`.

- [x] Pin every seed by identifier resolved from a consulted source, never by
  title search: Voisin arXiv:1407.7261, Colliot-Thélène arXiv:1607.05673,
  Yang--Yu--Zhu arXiv:2508.03623, Hartlieb arXiv:2304.03214, Wei--Yu
  arXiv:1907.00392, Engel--de Gaay Fortman--Schreieder arXiv:2507.15704, Cai
  arXiv:2608.01577, Katzarkov--Kontsevich--Pantev--Yu arXiv:2508.05105.
  Record the resolved DOI or OpenAlex identifier for each in the report.
- [x] Take the forward-citation set of each seed independently from OpenAlex,
  Crossref, and Semantic Scholar. Record the three counts separately, screen
  the largest set, and report any disagreement between the services as a
  finding rather than collapsing them.
- [x] Record every load-bearing query verbatim, and state for each service how
  an empty result was distinguished from an error.
- [x] Screen the citing sets for two targets: further constructions of
  universally `CH_0`-trivial cubic threefolds, whether by unirational
  parametrizations, minimal-class algebraicity, or specialization; and any
  statement about irrationality or rationality of a cubic threefold times
  projective space.
- [x] Record the set size, provenance, screened fields, and the verbatim
  discriminator for each screened set. Promote a member out of the set only
  with an ordinary read-depth field attached.
- [x] Search zbMATH Open, which is reachable, over the same two targets.
- [x] Record MathSciNet as NOT COVERED if it cannot be authenticated, and keep
  every claim it would have gated at the weaker strength.
- [x] Add every fetched source to the shared literature cache with its key and
  SHA-256.
- [x] Rewrite the ledger's audit boundary from the result, keeping "searched
  and found nothing" strictly apart from "could not access", and state which
  of the paper's remaining claims the sweep now licenses at full strength.
- [ ] Recheck the second distinguished member of the pencil,
  `x_0^3 + x_1^2 x_2 + x_2^2 x_3 + x_3^2 x_4 + x_4^2 x_1`, against the swept
  literature before any claim that its universal `CH_0`-triviality has no
  earlier proof; see `../2026-08-14-c914-a5-pencil-vs-known-loci.md`.

### WP11 — cold read of the session changes

- [x] Independent cold read of WP5 through WP9 and the repositioning, run
  read-only against the pinned sources. Verdict GO on all eight items, with
  nine locator and exposition defects and none invalidating a statement.
  Report: `../2026-08-14-c912-cold-read-session-changes.md`.
- [x] Repair all nine. The substantive one: divisor tagging applies the base
  shift with the whole tagging direction in the positive filtration, so the
  lemma's coefficient substitution is the identity there; the tagged and
  specialized polynomials are equal outright, and the closing paragraph now
  assigns the substitution to the blowup and projective-bundle comparisons
  where it is actually used.
- [ ] The reader left five items unverified, all outside the session's diff:
  the Grieve trace-formula polarization step, Roulleau's intersection data,
  the Brauer-atlas endomorphism rings, `prop:cubic-packet` with its Cai input,
  and the priority question itself, which WP10 owns.

### WP12 — title and two-theorem framing

- [x] Retitle to *Irrationality of Cubic Threefolds after One Stabilization*.
  The old title named universal `CH_0`-triviality, which is a hypothesis only in
  the separation corollaries, so it advertised a restriction
  `thm:every-cubic` does not carry.  Applied to the manuscript, `README.md`,
  `.zenodo.json`, and `lean/README.md`.
- [x] Reframe the introduction so the two theorems read as the two halves one
  fourfold requires, rather than as parallel results with an asserted unity.
- [x] Independent cold read of both changes, read-only against the theorem
  statements: GO on the retitle, NO-GO on the framing pending four sentence
  repairs.  Report: `../2026-08-15-c912-title-framing-cold-read.md`.
- [x] Repair all four: the unrestricted "every cycle-theoretic obstruction",
  falsified by the paper's own Fermat corollary; "the criterion available for a
  cubic threefold", contradicted by the Colliot-Thélène and Yang--Yu--Zhu
  routes; "up to torsion", where the obstruction is divisibility by two; and
  "carries no rational parametrization", which contradicts the coprime-degree
  corollary.  Also took the recommended repairs: an explicit pointer to
  `thm:six-axis-divided-powers`, the dangling "irrationality half", and the
  duplication in the new lead and closing sentences.
- [x] Deterministic rebuild confirmed at 30 pages, PDF SHA-256
  `a06cc45ce5b9adac5c1795320d0c4162166ae47d70de4eee922caec3512d2f33`,
  authority commit `a85ddbb32`; `make check` warning-free with the claim
  inventory unchanged.
- [x] Carry the retitle and the current abstract into the portfolio summary,
  whose quoted abstract still led with the family rather than the uniform
  theorem.
- [x] Export: audit reports zero findings, `sync` from `a85ddbb32`, mirror gate
  replayed with a byte-identical PDF, `verify` accepts 120 tracked files.
  Standalone commit `8678447`; summary mirror commit `11b6e63`.  Neither is
  pushed.
- [x] Second external read of the retitled draft, scored 95.5 with the
  Levelt--Turrittin citation supplied.  Its three items are taken: the
  two-theorems paragraph moved to after Theorem~1.1 and its birational-class
  paragraph, which puts the headline theorem back on page one; "their
  conclusions are independent" softened to "the two inputs are logically
  independent" and "every obstruction that a decomposition of the diagonal
  kills" to "the usual decomposition-of-the-diagonal obstructions"; and the
  algebraic formal classification now cites van der Put--Singer Chapter~3,
  with Sabbah kept for the complex-analytic account only.  That closes referee
  A's severity-2 item as well.
- [x] Rebuilt deterministically at 30 pages, PDF SHA-256
  `b10f0a1d351ea292bd5d17382e40a19cd6701b2b9ac28b828f55c96c22c392da`,
  authority `f8183bf97`; re-exported with zero audit findings, standalone
  commit `b0b3861`, `verify` accepts 120 tracked files.
- [ ] The next Zenodo release deposits the new title as a new version; the
  existing deposit keeps the old one.

## Review protocol

### Mathematical cold reads

- [x] Quantum referee A, context-free on the differential-equations
  foundation: **GO with required revisions**, report
  `../2026-08-14-c912-quantum-referee-a.md`.  It found no false statement, and
  confirmed that `nu_6` is canonical and the receiver construction sound.  Its
  three smaller items are repaired: the Levelt--Turrittin passage now states
  the algebraic form it needs and cites Sabbah for the complex-analytic
  account only; ambient endpoint faithfulness is stated for both endpoints;
  and the global-generation reduction now rests on the intrinsic Novikov
  embedding of Iritani--Koto Remark 5.2 rather than on a divisor shift that
  does not arise.
- [x] Quantum referee B, source exactness for `prop:framed-operations`:
  **NO-GO as written, now repaired**, report
  `../2026-08-14-c912-quantum-referee-b.md`.  Every external attribution
  checked out with no mismatch.  The blocking gap was the paper's own
  blowup-side completion, which built its value group from an infinite family
  of bulk generators all of weight one; it now uses the finite-dimensional
  parameter of Theorem 5.18, matching the projective-bundle half.  Also
  repaired: the false positivity claim for the ramified Novikov generator,
  parity for the projective-bundle decomposition, the filtration citation, the
  center-reduction over-read, and the ring citation.
- [x] Quantum referee C, independent recomputation: **GO**, report
  `../2026-08-14-c912-quantum-referee-c.md`.  The cubic block reproduces
  exactly.  Its moderate gap, that the tagged polynomial was never placed in
  the same coefficient ring as the transported operator, is repaired by
  reading all three polynomials in the graded Hahn receiver.
- [ ] **Blocked, not merely unwritten.** The lemma statement and proof are
  worked out in
  `../2026-08-15-c912-frame-transport-receiver-obstruction.md`, and they are
  short over a differential field.  The receiver cannot host them: its elements
  are finite tensors, so it does not contain a Levelt--Turrittin gauge, and no
  single Hahn field holds both a pro-Laurent gauge and a formal solution.  The
  two rates are exact — the pro-Laurent gauge gains one filtration unit per
  unit of `z`-pole, the splitting gauge loses `w(Delta lambda)` per unit of
  `z`-power — so a common order exists exactly when
  `w(Delta lambda)` is below the minimal generator weight.  That holds at the
  cubic endpoint and is not supplied for arbitrary weak-factorization centers.
  A red team of the memo (`../2026-08-15-c912-frame-transport-memo-red-team.md`)
  changed this picture and the memo was rebuilt on it.  Three corrections
  matter.  The constants computation is false unless the exponential factors
  carry constant coefficients, because in the draft's coefficient-dominant order
  `exp(-lambda/z)` is already a unit of the coefficient field; the transport
  theorem's two hypotheses have no common instance over the present receiver,
  since a trivial value group loses the gauge and a nontrivial one loses
  Levelt--Turrittin; and the criterion is **not** scale-invariant.  The draft
  pins `w(u)=w(s)=1` regardless of `L`, so the minimal generator weight is
  always one while Novikov generator weights grow linearly in `L`.  Choosing `L`
  minimally rather than large is therefore the cheapest repair, and it is now
  route 1.  Index one still fails under any admissible weight.  Independently,
  the obstruction is order-free: for the critical ratio the loop coefficient of
  the gauge product is an infinite sum of bounded weight, hence undefined in any
  completion.  `lem:divisor-tagging` carries the same obstruction and needs the
  same repair.  `prop:framed-operations` stays unproved as written until this
  lands.  The reviewer-facing memo carrying
  the lemma, its proofs, the obstruction, the criterion, the three candidate
  routes, and the exact manuscript placement is
  `../2026-08-15-c912-frame-transport-memo.tex`, built to
  `../2026-08-15-c912-frame-transport-memo.pdf` with
  `nix develop papers#manuscript --command latexmk -xelatex`.
- [ ] **Owed to referee A, the one item left open.** The frame-transport step
  in `prop:framed-operations` — that a turn-invariant gauge conjugates framed
  operators — is asserted in one sentence, and no solution algebra carrying
  the turn is built.  State and prove it as a lemma, adjoining `z^rho`,
  `log z`, and the exponential symbols formally over the receiver, and place
  it before the proposition.  The referee expects about a page.  Until then
  that proposition is unproved as written.
- [ ] Repeat review of the frame-transport lemma once written, per the rule
  that every NO-GO finding receives a fresh review.
- [ ] Re-export after the lemma lands; the standalone repository is currently
  at source commit `f0c46af5a`, one repair behind.
- [x] Geometry referee: recheck the complete cycle spine and every new
  Roulleau/Hartlieb/polarization clarification for regressions.
- [x] General referee: cold-read the entire paper at the stated landmark-result
  standard and issue stable finding IDs with exact severity.
- [x] Every NO-GO finding receives an exact repair and a fresh repeat review.
- [x] No self-review substitutes for the independent cold reads.

### Copy edit and detritus reviews

- [x] Run a context-free copy edit for grammar, punctuation, displayed-math
  introductions, antecedents, theorem-strength words, and sentence length.
- [x] Run a separate detritus audit for stale review prose, workflow language,
  mutable internal IDs, hard-coded internal reference numbers, duplicate
  caveats, dead TODOs, obsolete version claims, and old PDF filenames.
- [x] Check all cross-references, bibliography keys, URLs, arXiv versions, and
  quoted equation locators.
- [x] Check theorem names, abstract, introduction, conclusion, summary README,
  verification README, C910 card, and standalone metadata for exact agreement.
- [x] Confirm no unrelated paper/table claims changed.

### Build, trust, and visual gates

- [x] Run the paper's supported `make check` gate.
- [ ] If Lean changes, run only the guarded Lean build and axiom-audit route.
- [x] Confirm the rejecting theorem inventory and coverage partition remain
  exact; record and justify any intentional change.
- [x] Build the PDF through the supported deterministic route.
- [x] Inspect every page visually, including formulas, superscripts, tables,
  floats, references, and final-page balance.
- [x] Check logs for undefined references/citations and layout warnings.
- [x] Confirm deterministic rebuild and record page count and checksum:
  23 pages, SHA-256 `cd57a43e08019efd5f9ae7ff79ebb3ff09d71b34abd9eded62349937e8d708bb`
  at the WP1--WP3 authority; after WP5 through WP11 the tracked PDF is
  29 pages, SHA-256
  `2804d9254525fd86f629b2c407bb8c2d2dbbc3a2a8e9c1ee1725ba5f24b1b30c`
  at authority commit `673f51da1`.
- [x] Red-team the complete diff against the pre-C912 authority commit.

### Commit and export gates

- [x] Commit each coherent repair tranche with exact-path staging.
- [x] Never mix foreign worktree changes into a C912 commit.
- [x] Finish every started edit; leave no dangling manuscript tranche.
- [x] Commit the final reviewed manuscript and generated PDF together where the
  repository convention requires it.
- [x] Run export plan/audit/sync from immutable source commit `2405ca85a`,
  and again from `673f51da1` after WP5 through WP11; both runs report
  zero audit findings, and `verify` accepts the refreshed tree at 120
  tracked files;
  audit and post-sync verification both report zero findings.
- [x] Update all standalone links and metadata if filenames or commit targets
  change.
- [x] Do not push unless the author separately requests it; standalone commit
  `f336131`, and now `e51a9c0`, remain local and unpushed. The mirror's own
  `make check` passes and its PDF matches the authority byte for byte.
- [ ] Report the final authority commits, page count, checksum, review verdicts,
  and any remaining explicit assumptions.
- [x] Leave C912 **open** after all green gates; await explicit author closure.

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
| C912-M12 | resolved | Presenting the elementary Hahn embedding as a standalone unlabelled result escaped the rejecting theorem inventory even though the proof used it twice. | Fold its full well-ordering, multiplication, injectivity, and localization argument into the mapped operation-formula proof; three cold rereads found no lost premise |
| C912-M13 | resolved | The public literature ledger retained internal commit, cache, and task-routing residue, while the Lean claim caution described an obsolete inverse-limit architecture. | Rewrite the public ledger as a stable literature-scope note and name the manuscript-only Hahn/nonlinear-coordinate bridge explicitly in the formal claim boundary |

The final `ej`+`tt` closeout found no unresolved mystery in the completed
WP1--WP3 tranche.  Removing the freestanding Hahn paragraph both repaired the
claim inventory and shortened the warning-free PDF from 24 to 23 pages without
compressing a proof step.  WP4--WP6 are explicit planned work, not unexplained
features of this tranche.

## Close condition

C912 has no automatic close condition. Even after every checkbox above is
green and the reviewed standalone export is synchronized, its status remains
`active; author-close only` until the author explicitly instructs that C912 be
closed.
