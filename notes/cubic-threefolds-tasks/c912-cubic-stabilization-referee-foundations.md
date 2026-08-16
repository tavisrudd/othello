# C912 — Cubic stabilization referee-foundations revision

**Lane:** `cubic-threefolds` (re-pegged from `clebsch` on 2026-08-15 by author
instruction; dated reports written before that date carry the old lane in their
headers, which records where the work was done and is not a routing error)

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
package, not a whole package, plus the frame-transport lemma owed to referee A.
That is the one blocker: `prop:framed-operations` and `lem:divisor-tagging` are
unproved as written.  The three framing-compatibility checks have now been run
against the pinned sources and the framing route is closed off; the surviving
gap is one statement about bulk displacement, and the next routes are under the
review protocol below.  Start a fresh session with
`../2026-08-15-c912-framing-compatibility-checks.md`, then the memo
`../2026-08-15-c912-frame-transport-memo.pdf` for the underlying analysis.
The one-stabilization base-point ambiguity is now computed against the atom
route: it is finite of order two at the sheet level and acts trivially, the
formal bulk germ is caustic-free for a filtration reason, the only crossing
question sits at `4q_2 = 27q_1`, and the count is not a Stokes-torsor invariant,
so that hole and the Gamma-rank route's hole are different objects.  Report:
`../2026-08-15-c912-m1-ambiguity-computation.md`, with committed script and
output `../2026-08-15-c912-xp1-spectral-check.py` and `.out`.
A following pass proves that standing hypothesis (H2) of the rigidity theorem is
forced by the Frobenius structure, shows the sheared pairing is symplectic so
that in rank two it gives `tr R = -1` and can never give `det R`, and identifies
the count with the number of primitive-sixth eigenvalues of the Serre operator
on the numerical K-group of the Kuznetsov component, whose characteristic
polynomial for the cubic threefold is the sixth cyclotomic polynomial.  That
identification is expected rather than proved, and the genus-six Gushel--Mukai
threefold is the test that may refute it or the lane's provisional zero.
Report: `../2026-08-15-c912-det-r-pairing-and-serre-lattice.md`, with
`../2026-08-15-c912-serre-lattice-check.py` and `.out`.
That test has now been run and passes: the numerical K-group of the Kuznetsov
component of a Gushel--Mukai threefold is `<-1> + <-1>` with symmetric Euler
form, so its Serre operator is the identity and the count is zero, matching the
lane's provisional zero.  The same computation, run from Riemann--Roch with no
external Euler matrix, reproduces the whole prime-Fano census, and fixes the
sign convention between the census's polynomial `R` and the Serre side as
`lam -> -lam`.  It also predicts count two for the sextic double solid, which is
outside the census and is the sharpest remaining falsification test.
Report: `../2026-08-15-c912-gm-genus-six-serre-test.md`, with
`../2026-08-15-c912-gm-genus-six-serre-check.py` and `.out`.

**Manuscript status change, 2026-08-15.**  On author instruction the paper no
longer asserts the bulk-displacement step.  It is now the manually named
Hypothesis 4.7H, inserted before `prop:framed-operations` without renumbering
anything, and the new unnumbered Lemma 4.1A proves frame transport across a
coefficient-field gauge, which covers Iritani's `Psi` and Iritani--Koto's
`Phi`.  Conditional: `prop:framed-operations`, `lem:divisor-tagging`,
`prop:low-dimensional-vanishing`, `thm:nu6-birational-invariance`,
`thm:every-cubic`, the irrationality clauses of Corollaries 1.2--1.4 and
Theorem 1.5, and `cor:v14-one-step`.  Unconditional: Sections 2--3,
`prop:cubic-packet`, and every universal `CH_0`-triviality assertion.
Lemma 4.3 and Lemma 4.5 no longer claim intrinsic frame transport, and
equation (4.6b) is deleted.  Authority commit `7ed8fc604` after two author
review passes and the metadata alignment, warning-free at 32 pages, PDF SHA-256
`742d4510ba37d8254edb1800093756809bf383ddcb992baa780ad1a30c10dbeb`.  The
README, Zenodo metadata, claim ledger, and portfolio summary now carry one
canonical status sentence.  Export is done and unpushed: audit zero findings,
`verify` accepts 120 tracked files, the mirror's own gate passes with a
byte-identical PDF, standalone commit `f6d1480`, summary mirror `5bd57c9`.
Exact
partition, downgrades, and the README/ledger/summary residuals:
`../2026-08-15-c912-hypothesis-4-7h-conditionalization.md`.

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
- [ ] **Frame transport: blocked; the framing route is now closed off, and the
  gap is exactly located.**  `prop:framed-operations` is unproved as written,
  and `lem:divisor-tagging` carries the same problem.  Analysis and manuscript
  placement: `../2026-08-15-c912-frame-transport-memo.tex` and its built PDF,
  rebuilt with `nix develop papers#manuscript --command latexmk -xelatex`; the
  adversarial check that corrected two earlier versions is
  `../2026-08-15-c912-frame-transport-memo-red-team.md`.  The three
  framing-compatibility checks the memo proposed have been run against the
  pinned sources; verdicts, locators, and hashes are in
  `../2026-08-15-c912-framing-compatibility-checks.md`.  The memo is now at its
  sixth version, carries those verdicts in its Section 6, attacks the residual
  gap through the flatness identities in Section 7, and closes it for the cubic
  block in Section 8, assembles the one-stabilization statement in Section 9,
  and proves it unconditionally in Section 10.  PDF SHA-256
  `2d279ae244255fe28e5f366e648367794df1b9de2678620d6b6c3f350a6690ad`.  The sixth
  version deletes standing hypothesis (H2) of Section 8, which is now a theorem
  proved from the Frobenius property via an isometry lemma for the decoupling
  gauge; adds the arbitrary-Jordan-size analysis, where the commutant and
  no-splitting steps extend to any size but duality removes only the deepest
  pole coefficient, so rank two is special and the base point for larger blocks
  must be settled by the grading; corrects the graded minimal polynomial to
  Kuznetsov's `S^3 = [5]`; states the surface obligation as (iii) with its two
  reductions and a counterexample to the weakened form; and proves (iii) by a
  minimal-model induction on Iritani's blowup decomposition read at the source
  plus two statements the route already uses, so the endpoint route's surface
  exclusion is no longer an open problem of its own.  Either
  document can be read first; the report is the shorter route in, the memo's
  Sections 8 and 9 are where the mathematics now is.

  *Section 10 is refuted; the endpoint is NOT proved.*  Hostile-referee report
  `../2026-08-15-c912-section10-hostile-referee.md` (verdict FATAL, with source
  locators).  The parameter at which both summand parameters vanish does not
  exist.  Iritani--Koto's (5.13) states invertibility for the **displaced**
  coordinates `s_j = varsigma_j - varsigma_j^0` treated as independent formal
  variables, so demanding `s_j = -varsigma_j^0` sets a formal variable of a
  completed ring equal to a unit-order element `-+2q^{1/2} + O(q^{-1/2})`; that
  is not a point of the germ.  Iritani's Lemma 5.15 is the formal inverse
  function theorem at `Q = theta = 0`, an isomorphism of the germ at the origin
  onto the germ at the image, licensing nothing at a non-nilpotent displacement;
  and Iritani states the pullback of functions along the change of variables is
  ill-defined.  Every version of the decomposition identity in the sources is
  over a formal germ, not a family of pointwise statements, so "at any
  parameter" is also unsupported.  Reading the identity in either direction was
  the false step.  Section 8's algebra was recomputed independently and is
  correct in every step, but its domain is the formal even bulk germ, the same as
  Cai's gauge, so it does not extend validity to the displaced parameter either;
  its gain is avoiding the pro-Laurent gauge.  Net: the endpoint holds if
  `nu_6 = 2` at the displaced parameter, which is Hypothesis 4.7H.  A repair must
  supply: which elements may be substituted into the change of variables, proved
  from the graded completion rather than from the word invertible; invariance of
  `nu_6` under degree-zero and degree-two shifts as a theorem about framed
  monodromy rather than a normalization; and solvability in the negative-degree
  coordinates with convergence proved degree by degree.

  *Superseded claim, kept for the trail.*  Iritani's Theorem 1.1/5.18
  states a formal **invertible** change of variables
  `H*(Bl_Z X) -> H*(X) + H*(Z)^(r-1)` over `C((q^{-1/(r-1)}))[[Q]]`, invertible
  because its Jacobian at `Q = theta = 0` is (his Lemma 5.15).  The draft reads
  it one way only -- fix the blowup's parameter, receive a displaced one below,
  transport back -- which is Hypothesis 4.7H.  Read the other way the displaced
  parameters are prescribed and the blowup's parameter is solved for, so nothing
  is transported.  Ledger: every centre in a fourfold weak factorization has
  dimension at most two, where `nu_6 = 0` at *every* parameter (point; `K` nef
  by Claim 6.15's degree argument; `P^1`, `P^2` as projective bundles over a
  point; ruled surfaces over curves; point blowups; `H^0` coordinate normalized
  away by a scalar exponential).  So each relation transports the value
  bijectively along the factorization, and `P^4 = P(C^5)` over a point gives
  zero at every parameter, forcing `nu_6(X x P^1, .) = 0`.  But
  `X x P^1 = P(O + O)` and the invertible change of variables has a parameter
  `t_0` with both summand parameters equal to `0`, where
  `nu_6 = 2 nu_6(X, 0) = 4`.  Contradiction, hence `X x P^1` is irrational for
  every smooth cubic threefold.  Imports: Iritani's blowup theorem with
  invertibility, Iritani--Koto's projective-bundle theorem, weak factorization,
  Claim 6.15.  No receiver, no atom equivalence, no Serre enhancement, nothing
  from KKPY's forthcoming [49].  Sections 8 and 9 are not needed for it.
  Three checks before it is believed are listed at the end of Section 10; the
  sharpest is that the operation identity may be applied at an arbitrary
  parameter of the germ, which should be quoted at that strength rather than
  paraphrased.

  *The atom route, and the one step it still needs (Section 9).*  A first pass
  claimed this closed unconditionally; a red team found one genuine gap, and the
  memo now states the endpoint with it.  Hypothesis 4.7H does not appear at all:
  in the atom formulation the
  intermediate fourfolds of a weak factorization cancel in the ledger instead of
  being visited, so no framed operator is transported across a comparison.  Four
  steps.  (i) Bulk local constancy: solving `d_{t_i} M = -z^-1 P_i M` with
  `M|_0 = I` gives a gauge with integral `z` powers per bulk degree, fixed by
  the turn, conjugating the deformed `z`-connection to the one at the base
  point; so the whole formal type, not just the compressed pair, is constant
  along the base.  This is Cai's own argument stated generally, and the receiver
  problem does not arise because both points lie on one base with the bulk
  parameters formal.  (ii) Hence `nu_6` descends to atoms: isomorphism preserves
  it, and base-point change within a spectral component is (i).  (iii) No atom
  of a variety of dimension at most two carries it, by induction over the
  surface classification using the projective-bundle and blowup identities plus
  Claim 6.15 for nef canonical class.  (iv) `X x P^1 = P(O + O)` puts two copies
  of the cubic zero atom in its composition, and Proposition 5.17/5.30 gives the
  contradiction.

  *The gap, exactly.*  An atom is a geometric atomic F-bundle modulo isomorphism
  **and** modulo change of base point within a connected component of the
  spectral cover.  Step (i) gives the second only along formal germs, and it
  does not globalize: the gauge is the pro-Laurent object, convergent only for
  topologically nilpotent bulk parameters, so the receiver difficulty reappears
  at the globalization step instead of being escaped.  Comparing value sets over
  representatives does not rescue it, since the class to be excluded is exactly
  one whose value set would contain both 2 and 0.  What the gap does not touch:
  Theorem 8.7 and the `nu_6 = 2` computation, and step (iii), whose
  nef-canonical input is pointwise -- their Claim 6.15 proof shows that for `K`
  nef at any even point with vanishing `H^0` coordinate the Euler operator's
  block components vanish in nonpositive degree.  The visible route to closing
  it is Section 8 rather than the gauge: `d_a R = [R, G_a]` is a differential
  identity between functions on the base, and vanishing derivative gives local
  constancy; what it needs is its two hypotheses at every point of the
  component, including the locus where the nilpotent part degenerates.

  *Why the Serre decoration is now the leading candidate.*  It avoids the gap by
  construction.  KKPY Proposition 5.23 proves the fibre representation's
  isomorphism class independent of the representative by rigidity of
  representations of a proreductive group -- a global argument that monodromy
  data does not enjoy.  Their Example 6.17 runs the exact endpoint pattern in
  dimension four for a very general cubic fourfold containing a plane, excluding
  surfaces of general type by playing `S^3 = [4]` against the unipotency Claim
  6.15 forces; Example 6.21 gives the cubic threefold `S^5 = [3]`.  Cautions:
  the enhanced theory is asserted straightforward rather than written out, the
  integral-structure enhancement is deferred to their forthcoming work, and both
  are worked examples rather than theorems with hypotheses.  A source-verified assessment of
  the proposed Hodge-atom spine, which is the alternative presentation, is
  `../2026-08-15-c912-atom-spine-source-assessment.md`.

  *The coalesced case is closed for the cubic (Section 8).*  Over the formal
  even bulk germ, with the block decoupled and its exponential factor twisted
  away, three statements follow from the flatness identities alone.  The
  commutant of the regular block operator forces `C_{a,0} = p I + q N`, so the
  bulk connection has no `(2,1)` entry.  The double eigenvalue never splits:
  `d = det N` satisfies `d_a d = 2 q_a d` with `d(0) = 0`, hence `d = 0`.  After
  the shearing `diag(1,z)` no irregularity appears and the bulk connection loses
  its pole: the `z^-1` flatness equation gives `k_a = f h_a` and
  `d_a f = f w_a` with `f(0) = 0`, hence `f = 0`.  The `z^0` equation then reads
  `d_a R = [R, G_a]`, so the residue's characteristic polynomial is constant.
  For the cubic it is `rho^2 + rho + 5/36` with roots `-1/6, -5/6`, reproducing
  the draft's own `J_0 = [[0,2],[0,0]]`, `D_0 = diag(-19/18, 19/18)` and
  `(E_0)_21 = -8/81` exactly, so `nu_6 = 2` at every bulk parameter including a
  specialized one.  Specialization is substitution into constants, so no
  receiver, bulk gauge, or convergence question survives.  The regression test
  is met by construction: the residue contains the `z^2` coefficient through the
  shearing.  Not covered: derogatory blocks, semisimple blocks with a
  `rho_i - rho_j = -1` resonance, and Jordan blocks of size above two, which is
  what an arbitrary-center statement would need.

  *A shorter endpoint route, from KKPY's own Example 6.21.*  They compute the
  cubic's atomic composition as two one-dimensional atoms plus the zero atom
  `alpha(X)`, assert the no-splitting statement from their Remark 3.14, and then
  separate `alpha(X)` from a genus-five curve atom by its Serre automorphism:
  the graded minimal polynomial is `S^5 = [3]`, so `S` cannot have eigenvalue
  `-1`.  They conclude that every smooth cubic threefold is irrational.  That is
  dimension three, where only points and curves must be excluded.  The
  one-stabilization statement is dimension four and additionally needs surfaces
  excluded; the projective-bundle formula, the criterion, and the decoration are
  already theirs.  So the endpoint may reduce to one finite classification
  question -- can a surface atom carry `S^5 = [3]` -- with nef canonical class
  covered by their Lemma 5.24 and Claim 6.15 and the rest reduced by the
  projective-bundle and blowup formulas.  Cost: this imports the Hodge-atom,
  motive, and Serre-enhancement machinery the 2026-08-10 blueprint deliberately
  avoided, and their sentence is a worked example, not a theorem with
  hypotheses.

  *Correction carried by Section 8.*  Cai's Proposition 6 already states the
  `+/-1/6` exponents for the big quantum connection, proved by a bulk gauge
  `M = I + sum M_n t^n` with `d_{t_i} M = -z^-1 P_i M` -- the same pro-Laurent
  object the memo scrutinized.  That argument is sound with the bulk kept
  formal; the receiver problem was always about specialization.

  *State after the checks.*  Check 1 fails: Hinault--Yu--Zhang--Zhang's
  Theorem 4.34 governs F-bundles over the large-radius limit point `q=t=0`,
  where the K-operator is a nilpotent cup product, while `nu_6` is evaluated
  where the eigenvalues separate; their blowup statement Theorem 5.22 is
  asserted but not derived from Theorem 4.34, whose equal-dimension hypothesis
  misses the unequal summands `H^*(X)` and `H^*(Z)`, with existence referred to
  the earlier decomposition work; and the gauge it would supply lands at the
  shifted base point that the pro-Laurent gauge exists to undo.  Theorem 5.22
  therefore adds nothing to the blowup formula beyond Iritani.  Check 2
  passes: the base-map ambiguity of their Theorems 5.20/5.24 is a Novikov
  character, hence the divisor substitution (4.1), hence `nu_6`-invariant, and
  Iritani--Koto (5.11)--(5.12) and Iritani Section 5.8.1 pin it anyway; one
  manuscript sentence is owed.  Check 3 confirms the separation and is sharper
  than assumed: their center F-bundle is itself built on a collapsed Novikov
  variable, so the framing theory can never certify an intrinsic center
  invariant, while their Lemma 2.24 is the divisor-tagging mechanism in print.

  *Correction carried by the checks.*  The memo's claim that the unbounded
  negative loop order is the manuscript's own choice is wrong.  Iritani--Koto's
  reconstruction transports along the same object, their fundamental solution
  `M` of Section 5.8 with `M = id + O(z^-1)`, polynomial in `z^-1` per bulk
  degree exactly as `(4.1a)` says, unbounded only after summing bulk degrees.
  The sources handle it by Birkhoff factorization, not by an ordered receiver.

  *The residual gap, and it is the whole blocker.*  The comparison maps need no
  receiver: Iritani's `Psi` and Iritani--Koto's `Phi` are `z`-polynomial module
  maps with inverses in the same ring, so the memo's transport lemma applies to
  them with `Gamma=0`.  What remains is one statement: for a bulk parameter in
  the positive filtration -- `tau^0 = q^-1[Z] + O(q^-2)` on the ambient summand,
  the `O(q^{-1/(c-1)})` tail plus `s_j` on a center summand -- the framed formal
  monodromy at that parameter has the same primitive-sixth multiplicity as at
  the origin.

  *Blockwise progress and its limit, memo Section 7.*  The flatness identities
  `[E*, phi_a*] = 0` and `d_a(E*) = phi_a* + [phi_a*, mu]` are exact, and in the
  Kato block frame the leading operator evolves unconditionally by
  `D_a U_i = C_{a,i} + [C_{a,i}, mu_i]`.  Self-adjointness of `E*` and
  anti-self-adjointness of `mu` for the Poincare pairing make every block
  residue traceless with spectrum symmetric about zero, and force it to vanish
  on every multiplicity-one block; so `nu_6` is carried entirely by coalesced
  blocks, and the draft's cubic roots `1/6` and `5/6` are the forced `+/-1/6`.
  That much is unconditional.  The coalesced case is **not** reduced: the
  off-block projector equation is the full Sylvester equation
  `(u_j-u_i)X + N_j X - X N_i = -(d_a U)_{ji}`, so the closed form
  `D_a mu_i = [C_{a,i}, S_i]` covers only semisimple blocks, and a
  nonsemisimple block is not modelled by the compressed pair at all.  The
  manuscript's own cubic block is the regression test: with the `z^2`
  coefficient's `-8/81` entry the indicial polynomial is `rho^2 + rho + 5/36`
  with roots `-1/6, -5/6`; without it the roots are `+/-1/18` mod `Z` and
  contribute nothing.  The live danger is block splitting, which would drop
  `nu_6` by two; the standard coalescence results assume a diagonalizable
  leading matrix and do not apply, since `J_0 != 0` here.

  *Next routes, in order.*  (i) Deformation of the full formal block normal
  form `J + zD + z^2 E + ...` for a coalesced block, tested against the cubic
  example, plus the splitting question.  (ii) Birkhoff: show the `id + O(z^-1)` factor of
  `(Phi^0)^-1 M = M' Phi^-1` preserves the multiplicity; same question in other
  coordinates, useful as a cross-check.  (iii) Direct specialized vanishing for centers of
  dimension at most two, using the classification already in the draft, which
  for nef canonical class gives an integral-loop gauge to a regular-singular
  connection.  Divisor tagging only if those fail; the mixed-receiver
  inequality is fallback machinery.  A separate scope reduction stands on its
  own: a direct quantum-Kuenneth computation for `X x P^1` plus a direct
  computation for `P^4` would leave the blowup step as the only operation
  formula the headline theorem needs, with the genus-eight corollary waiting.
  Note that the trivial-bundle case does not escape the bulk gauge: even for
  `V = O + O` the initial coordinate keeps its `O(q^{-1/r})` tail.

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
| C912-M14 | resolved | The receiver problem was attributed to the comparison isomorphism; both `Psi` and `Phi` are `z`-polynomial module maps, so the transport lemma applies to them unconditionally. | `../2026-08-15-c912-framing-compatibility-checks.md`, check 1d; the gap is the residual bulk gauge alone |
| C912-M15 | confirmed | The pro-Laurent bulk gauge is Iritani--Koto's own fundamental solution `M`; per bulk degree it is polynomial in `z^-1`, unbounded only in the limit. | Same report, Section 5; corrects the memo's Section 6 |
| C912-M16 | confirmed | Hinault--Yu--Zhang--Zhang Theorem 5.22 (blowup) is asserted, with uniqueness in Theorem 5.24, but is not derived from Theorem 4.34, whose hypotheses miss the unequal block sizes; existence is referred to the earlier decomposition work. That work is now located: Iritani arXiv:2307.13555, Theorem 5.18, with uniqueness from initial conditions in his Section 5.8; clause-by-clause agreement between the two statements is unchecked, the settings being quantum D-modules and framed F-bundles. | Same report, finding 1b, and `../2026-08-15-c912-blowup-formula-source-check.md`, Section 4 |
| C912-M17 | resolved | The base-map ambiguity of their Theorems 5.20/5.24 is a Novikov character, hence the divisor substitution (4.1), hence `nu_6`-invariant; the sources' initial conditions pin it anyway. | Same report, check 2; one manuscript sentence owed |
| C912-M18 | confirmed | Their center F-bundle is itself built on a collapsed Novikov variable, so the framing theory cannot certify intrinsic center invariants; their Lemma 2.24 is nonetheless the divisor-tagging mechanism in print. | Same report, check 3; `lem:divisor-tagging` stays owner |
| C912-M19 | confirmed | The count of `X x P^1` is carried by one connected component of its spectral cover, with two geometric points exchanged by a Galois group of order two that fixes the rational exponents; the sheet-level base-point ambiguity is finite and acts trivially. | `../2026-08-15-c912-m1-ambiguity-computation.md`, Propositions 2--3 |
| C912-M20 | confirmed | The carrier block meets another sheet only at `4q_2 = 27q_1`, which equates two distinct Novikov monomials, so the formal germ is caustic-free by filtration rather than by genericity and the rigidity theorem applies at every point of it. | Same report, Proposition 4 and Section 4 |
| C912-M21 | open | At `q_2 = 27q_1` two simple sheets coalesce at value zero, so the count can rise there. Harmless for the lower bound the one-stabilization theorem needs; a real gap in any equality form of birational invariance of the count. | Same report, Section 4; owner is whichever successor states the invariance as an equality |
| C912-M22 | confirmed | The Stokes torsor of the `X x P^1` small even connection is 52-dimensional and acts trivially on the count, since the count is a formal invariant; the one-stabilization hole is a discriminant-crossing problem, not a Stokes-section problem. | Same report, Section 5 |
| C912-M23 | resolved | Standing hypothesis (H2) of the rigidity theorem is forced by the Frobenius structure: the image of the nilpotent part is isotropic and the `z^0` coefficient is anti-self-adjoint, so the assumed entry vanishes pointwise rather than on a germ. | `../2026-08-15-c912-det-r-pairing-and-serre-lattice.md`, Theorem 2; recorded in the memo's Section 8 and (H2) deleted there |
| C912-M24 | confirmed | After the shearing the Poincare pairing is `z` times a symplectic form, and `sp(2) = sl(2)`, so in rank two the pairing gives exactly `tr R = -1` and can never determine `det R`. | Same report, Proposition 3 |
| C912-M25 | confirmed, refined | Their Serre automorphism is defined as the monodromy in the `u`-direction with `chi(a,b) = chi(b,S(a))`, so on the F-bundle side this identification is definitional and only the comparison with a Kuznetsov component's categorical Serre functor remains expected. The count equals the number of primitive-sixth eigenvalues of the Serre operator on the numerical K-group of the Kuznetsov component. The genus-six Gushel--Mukai test passes -- `N(Ku) = <-1> + <-1>`, symmetric Euler form, `S = I`, count zero -- and the identification reproduces the whole prime-Fano census. Still an expected correspondence rather than a proved one. | `../2026-08-15-c912-gm-genus-six-serre-test.md`, Sections 3--4 |
| C912-M26 | resolved, verdict corrected | Katzarkov--Kontsevich--Pantev--Yu's Example 6.21 does state `S^5 = [3]`, so the memo transcribed faithfully and the earlier transcription-slip verdict was wrong. The incompatibility with the lattice is a convention difference between their Hodge-atom Serre automorphism in the cohomological grading and the categorical Serre functor on a K-group; their Example 6.20 shows the same offset in dimension four. | `../2026-08-15-c912-kkpy-imports-source-check.md`, Section 3 |
| C912-M31 | confirmed | Every non-minimal smooth projective surface has an admissible subcategory of numerical Serre order six, from the exceptional pair `<O_E(-1), O_X>` on a `(-1)`-curve. Step (iii) is false for admissible subcategories, so the eigenvalue criterion is an invariant of the atomic decomposition rather than of the surface, and the blowup step of any proof is where the care is needed. | Same report, Section 3 |
| C912-M32 | resolved | Step (iii) is automatic wherever the small quantum cohomology is semisimple, since every atom is then rank one and a rank-one numerical Serre operator is the identity. The obligation lives entirely in the non-semisimple cases outside the nef-canonical class. | Same report, Section 2 |
| C912-M33 | confirmed | Step (iii) holds for every smooth projective surface by minimal-model induction. Its blowup input is Iritani's decomposition, read at the source; the two remaining imports, the projective-bundle formula and the nef-canonical atom description, are ones the endpoint route already uses. Blowing up only ever adds rank-one atoms, so the blow-down step is free; the minimal cases reduce to a curve or to a semisimple spectrum. | `../2026-08-15-c912-step-iii-surface-induction.md`, Section 1; memo Proposition in Section 8 |
| C912-M34 | resolved | Iritani's blowup formula (arXiv:2307.13555, Theorem 5.18, Corollary 1.2) is an isomorphism of quantum D-modules commuting with the quantum connection, intertwining the pairings and preserving the Euler vector fields, so formal monodromy transports summand by summand. Read at the source; the surface induction rests on two imports rather than three. | `../2026-08-15-c912-blowup-formula-source-check.md`, Sections 1--2 |
| C912-M35 | confirmed | Step (iii) upgrades to (iii'): every atom of a smooth projective surface has monodromy of order at most two. This is the discriminator Katzarkov--Kontsevich--Pantev--Yu use for the cubic fourfold, where they need only surfaces of general type; the endpoint needs all surfaces because the cubic threefold's atom is shaped like a curve atom. | `../2026-08-15-c912-kkpy-imports-source-check.md`, Section 4 |
| C912-M36 | open | The endpoint follows from their Theorem 4.11, the *enhanced* non-rationality criterion and (iii'), with no transport lemma and no integral structures. The enhanced criterion is load-bearing, since the argument separates atoms by monodromy, a decoration; it is asserted in unnumbered prose, unlike the numbered Proposition 5.30 which is proved. A manuscript using this route must prove it in the generality needed or quote it as an assertion. | Same report, Section 5 |
| C912-M27 | explained | The substitution is the half-parity gauge `u^g`, which shifts exponents by half the cohomological degree; every separation used survives it. The sign convention between the classification's reduced factorial cyclotomic polynomial `R` and the Serre side is `lam -> -lam`, the shift `[1]`: in all four genera where `R` is recorded the Serre characteristic polynomial is `R(-lam)` up to sign. | `../2026-08-15-c912-gm-genus-six-serre-test.md`, Section 4 |
| C912-M28 | open | `N(Ku)` of the sextic double solid has the cubic threefold's Gram matrix and an order-six Serre operator, so the identification predicts count two there; the lane has not computed that quantum-side value. Independently, no Kuznetsov component equivalent to a curve category can have nonzero count, so the degree-one case of Kuznetsov's Fano threefold conjecture cannot hold. | Same report, Section 5; owner is the sextic-double-solid quantum computation |
| C912-M29 | open | The Euler form on the residual component is symmetric for the Gushel--Mukai threefold and asymmetric for the cubic, and that symmetry alone controls the count. No structural reason for the difference was identified. | Same report, Section 3 |
| C912-M30 | open | Rank two is special in the rigidity section, not typical: for a Jordan block of size `m` the shear produces a nested family of pole coefficients, and duality removes only the deepest one, which in rank two happens to be the whole pole. The base-point input for `m >= 3` should instead be the grading, since an operator of `mu`-weight `p` sits exactly on the `p`-th sub-diagonal; the missing step is `mu`-equivariance of the decoupling gauge on the zero block. | Memo Section 8, "Arbitrary Jordan size"; owner is whichever successor needs the general center statement |

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
