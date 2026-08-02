# Cold expert read, round two: ame_lu manuscript

Date: 2026-08-02. Reader: cold referee pass over `papers/ame_lu/main.tex` and all of
`sections/`, read as a continuous document before consulting any ledger. Ledgers were
consulted afterwards only to check whether specific issues had been considered
(one bounded grep of `theorem-map.md` and `claim-proof-novelty-ledger.md`).

## 1. Referee's verdict

**Publishable, after one substantial revision round.** The mathematics I could check by
hand is correct; the two errors found are missing-hypothesis errors, not broken proofs
(Section 2 below). The natural venues are *Quantum* or *IEEE Transactions on Information
Theory*: the paper mixes stabilizer formalism, MDS coding theory, finite projective
geometry, and quantitative perturbation analysis, and both venues accept
certificate-supported finite computation when the trust boundary is mapped as carefully
as Section 7 maps it. *Communications in Mathematical Physics* is a plausible stretch for
the rigidity + discreteness half alone; the pencil and certificate material would work
against it there.

**Strongest section:** Section 3's main line (full-Weyl marginals, the support theorem,
the atlas classification) and, within Subsection 3.3, the closing chain
quantitative-intertwiner → quantized-overlap gap → uniform separation → explicit
threshold. The idea that stabilizer overlap quantization replaces the compactness step
in the approximate-symmetry decomposition, with a threshold constant
`(2−2p^{−1/2})^{1/2}` depending on the characteristic alone, is the best single idea in
the paper and is proved cleanly. The hypothesis hygiene throughout 3.3 is exemplary:
nearly every hypothesis is shown load-bearing by an explicit configuration
(the scalar-product ceiling family, the RM(1,ℓ) radius family, the `H^{⊗2m}` check on
the half-splitting bound, the Bell-pair boundary for 2-uniformity).

**Weakest section:** the second half of Section 5 (the Clebsch extremal X-syndrome
proposition and its boundary remark). The substantive content is imported from the
companion Clebsch paper; what is native here is one application of Theorem 5.3 at q=11
plus a coset-syndrome lemma. The remark then spends roughly ten sentences fencing off
misreadings ("this is a fixed-party statement, not…", "it is not a claim that…", "the
unlabelled conic also carries neither…"). When a result needs that much fencing, it is
either mis-stated or over-weighted; here it is over-weighted. Section 6 plus Appendix A
is the runner-up for weakest: correct and useful as a contrast, but the generic-constancy
proposition's statement carries its own caveat paragraph inside the theorem environment,
which is a statement-hygiene failure.

**What a hostile referee attacks first, in order:**

1. **Novelty of the headline.** For q=2 the LU-to-LC conclusion of Theorem 1.1 is
   contained in Van den Nest–Dehaene–De Moor, and Tan 2026 contains the q=3, m=2
   automorphism subcase. The paper concedes both at the point of use — correctly and in
   the right tone — but the title and abstract still lead with rigidity. The referee will
   ask whether the genuinely new content (uniform prime-power arbitrary-additive scope,
   the atlas classification with its exact sequence, the separation/threshold theory,
   the diagonal-isodual dichotomy) shouldn't be foregrounded instead. This is a framing
   attack, not a correctness attack, and the paper survives it, but expect the question.
2. **Two papers in one cover** (Section 3 of this report).
3. **The certificate step inside a theorem proof.** The proof of Theorem 4.1 (pencil
   classification) depends on the 450-holonomy multiset (4.5), which is
   certificate-supported, not hand-checked. The paper says so in the proof and maps it in
   Section 7, which is the right practice; a conservative referee will still ask for
   either a human-checkable derivation of (4.5) for one representative value or a
   statement flag ("computer-assisted") on the theorem itself.
4. **The missing m ≥ 2 hypotheses** (Section 2, findings 1–2). These are real errors as
   the statements stand and are the first thing a referee who tests boundary cases will
   find, precisely because the paper itself advertises that "the boundary m ≥ 2 is sharp."

**What I would demand before acceptance:**

- Fix the two missing-hypothesis errors (findings 1–2 below).
- Restructure Subsection 3.3 as its own top-level section with named subsections
  (discreteness / stability radius / separation and threshold); it is currently ~1150
  source lines — over a third of the paper — filed as a subsection of "Full-Weyl
  marginals and LU rigidity," and its fifteen numbered results are a section-scale
  argument.
- Cut the abstract to roughly half its length. Four paragraphs covering five result
  clusters is a table of contents, which the house style itself forbids.
- Repair the small expository defects in Section 2/5 findings below (garbled Möbius
  sentence, duplicated closing sentences, caveats inside theorem statements).
- Add figures. There are currently none, and at least five would do real work
  (Section 4 of this report).

## 2. Correctness scan

I checked every proof in Sections 1–6 at the level of following each step, and checked
the appendix arguments at the level of structure plus spot verification (the
`T X T†` computation, the multiset multiplicity accounting, the double-coset counts, the
group-order arithmetic 16464 / 159720 / 2420, the constants 5/16, 0.83591, R_k values,
θ* ≈ 1.4656). The certificate-backed claims ((4.5), the transport determinants, the
computed party rows, the q=13 ranks) I took as stated, per the declared trust boundary.

**Finding 1 (hypothesis omission, needs fixing): Theorem 1.2 (atlas classification) is
missing m ≥ 2.** The statement reads "two stabilizer AME(2m,q) states are LU equivalent
exactly when…" with no bound on m, and the exact sequence
`1 → L_ψ → Γ_ψ → G_ψ → 1` is asserted for the fixed-party projective product-unitary
group Γ_ψ. At m = 1 the state is a Bell pair, Γ_ψ contains the continuous non-Clifford
`U ⊗ Ū` family, the map λ_ψ to symplectic label data is not even defined on it, and the
sequence is false. The proof silently uses Theorem 1.1 (which does carry m ≥ 2). The
paper elsewhere insists the m ≥ 2 boundary is sharp, so this is exactly the
statement-vs-use scope drift the manuscript has had before. One clause fixes it.

**Finding 2 (hypothesis omission, needs fixing): Corollary 1.3 (transversal Clifford
no-go) is missing m ≥ 2.** The statement quantifies over encoding isometries
`V: C^q → (C^q)^{⊗(2m−1)}` whose Choi states are stabilizer AME(2m,q), with no bound on
m. At m = 1 the "encoder" is a unitary on one qudit and the conclusion is plainly false
(any logical unitary L is implemented by the physical unitary `V_φ L V_ψ^†`, Clifford or
not). The proof again inherits m ≥ 2 from Theorem 1.1 without the statement saying so.

**Finding 3 (unstated but true step, should be one sentence): quantitative intertwiner,
control of the nonidentity part.** In Proposition 3.x (quantitative-intertwiner) the
lemma is applied to the nonidentity part `T_S` of the (m+1)-party marginal, with
`η ≤ 2ε` justified by "partial trace contracts the trace norm, and the Hilbert–Schmidt
norm is no larger." That bounds the distance of the *full* marginals. Passing to the
nonidentity parts additionally uses that conjugation by a product unitary preserves the
site-wise (traceless ⊕ scalar) decomposition, so the all-sites-traceless component of
the difference is an orthogonal projection of it and the bound survives. True, two
lines, currently absent — and it is the kind of step a referee tests.

**Finding 4 (commentary scope slip, minor): budget-free stability requires m ≥ 3, and
the surrounding prose forgets it once.** Theorem 3.x (budget-free) is correctly stated
with m ≥ 3, but the later paragraph after the explicit threshold says "for such states
Corollary [k-uniform-region] and Theorem [budget-free] certify the quadratic estimate
out to defects of constant order" while discussing AME(2m,q) with m ≥ 2 generally. At
m = 2 only the k-uniform route applies. Also note Corollary [two-unitary-gauge]
(m = 2 by construction) correctly avoids citing the budget-free theorem — good — but the
"two routes" comparison paragraph should carry the m ≥ 3 tag once.

**Checked and sound (a sample of the places I pushed hardest):**

- Support theorem counting (3.3)–(3.5) and the purity computation for (3.4).
- The atlas proof in both directions, including the graph/holonomy reduction at prime q
  (normality of SL_2 in GL_2 is used correctly to keep propagated blocks symplectic).
- Lemma [local-generator-isometry]: both the real part (pair marginals kill cross terms)
  and the often-forgotten imaginary part (commutator terms are traceless) are handled.
- The RM(1,4) non-Clifford example: I verified `T X T† = 2^{−1/2}(X + iXZ)` and the
  weight-divisibility argument by direct computation. Correct.
- Theorem [two-uniform-stability] constants: the 5/6 bound, the √(6/5) claim, and the
  Taylor-remainder bookkeeping all check.
- Corollary [k-uniform-region]: c ≥ 0.97917, ρ ≥ 0.83591 > 5/6, R_2 = 1/8, R_3 = 1/√2
  all check; the tracial-agreement lemma is applied within its scope (r ≤ k).
- Proposition [stability-region]: the weight-distribution computation
  ⟨U⟩ = 1 − (1−cos θ)/N, the ratio θ/(2 sin(θ/2)), and θ* all check.
- Half-splitting and budget-free proofs: the norm-1 computations, the cut-transversal
  label counting, the inequality `(x−y)² ≥ x²/2 − y²`, disjointness of the two label
  families for m ≥ 2, and the 5/16 endgame all check.
- Quantitative axes lemma: the Eckart–Young step, the "no shared dominant column"
  argument (column mass 1), and the 2(1−√(1−δ²)) ≤ 2δ² bound all check; the additivity
  and symplectic-form steps in the intertwiner proposition, with thresholds 1/3 and
  sin(π/p)/(2√2), check against the 3κ and 4κ perturbation counts.
- Stabilizer overlap quantization and the separation corollary, including the p = 2
  worst case (2−√2)^{1/2}.
- Explicit threshold: B < 1/(2π), the 1 − 0.0018 − 0.1592 > 1/√2 verification, and the
  final application of the stability theorem at t ≤ 1/2 all check.
- Proposition [diagonal-multiplier-line] and the branch argument in the proof of the
  diagonal-isodual corollary, including why per-party diagonal blocks are forced
  constant (D(C,C) is the scalar line). Correct and elegantly economical.
- Lemma [six-arc-self-association]: the five-row-independence argument via
  `H_I D H_I^T = 0` and the dimension count is correct.
- The (4.5) collision analysis: I verified that all three non-(−1/z) bins equal 4 only
  at z = −1/4, that the quadratic's discriminant is `4(4z+1)²/z`, and that the possible
  merged multiplicities {144,168,240,264} are disjoint from {90,24,96,120}. The
  recovery-of-z argument is airtight *given* (4.5).
- Lemma [conic-matchings]: the free-action divisibility |H| | 120, the A_5 row, and the
  characteristic-3 case check; the dihedral row is compressed to near the edge of
  checkability (see prose findings) but I believe it.
- Theorem [lu-h3-grs]: the 70 > 66 margin logic and the characteristic-5 vacuity check.
- Appendix C group orders and the `J² = −I` linear-vs-projective splitting distinction.

**Scope-drift sweep (the specific commissioned check).** Besides findings 1–2, I looked
for proved-for-X-stated-for-Y drift at every statement/use pair: the odd-prime
restriction on the logical-group results is stated in the abstract, intro, Table 1, and
Section 5 consistently, with the e > 1 failure mode explicitly flagged in Section 5; the
prime restriction on the pencil LC/LU classification is consistent between Theorem 4.1
and Corollary 1.6, and the extension-field non-claim is stated three times (Section 4
end, Section 7, conclusion) — if anything once too often; the 2-uniform discreteness
results are never used beyond their stated scope, and Remark
[two-uniform-not-clifford] exists precisely to prevent the natural over-reading. Table 1
(result scopes) is accurate against the statements as written. Apart from findings 1–2 I
found no scope drift.

## 3. Does it hang together?

Mostly yes at the level of theme; no at the level of architecture. Plainly: this is one
research programme filed as one paper but shaped like a paper and a half.

The case that it is one argument: the discreteness/stability subsection is genuinely
integrated, not bolted on. The introduction frames the split correctly and memorably
(the entanglement half forces discreteness; the algebraic half names the group), the
Bell-pair failure of 2-uniformity is exactly the m ≥ 2 sharpness of the rigidity
theorem, and — decisively for integration — the stability chain *ends* by feeding back
into the exact theory: the quantized-overlap separation converts the compactness
threshold of the decomposition corollary into a closed formula, and that formula uses
the rigidity theorem's Clifford conclusion. The conclusion section states this
one-argument reading well.

The case that it is two papers sharing covers: Subsection 3.3 is over a third of the
manuscript by source; it has its own hypothesis regime (arbitrary local dimension, no
stabilizer structure, analysis rather than algebra), its own literature (Fisher
information, metrology, odeco tensor perturbation, GIT stability), its own
counterexample families, and its own open problem — and *none* of Sections 4, 5, 6, or
the appendices uses a single statement from it. The applications spine
(dictionary → rigidity → atlas → pencil → logical phase → invariants) runs entirely on
the exact theory. The title and Section 3's own title do not mention discreteness,
stability, or thresholds. A reader who comes for the MDS–CSS transversal-gate theorem
must either skip 1150 lines mid-section or read a second paper on the way.

What I would do, as referee advice rather than a demand: keep it in this paper — the
feedback loop through the explicit threshold justifies co-publication, and splitting now
would orphan the best idea — but promote 3.3 to its own section ("Discreteness,
stability, and the decomposition threshold") with three named subsections, move the
2-unitary gauge corollary to the applications side, mention the stability half in the
title or drop the pretense that the abstract's second paragraph is a footnote. The
abstract currently gives the stability material its longest paragraph while the title
gives it nothing; that mismatch is the visible symptom.

## 4. Figures

The paper has no figures. The style guide's test is whether a figure explains an
incidence structure, correspondence, or proof mechanism faster than prose. Six
candidates pass that test; two are borderline (proposed with reservations); four
considered candidates fail and are listed with reasons. Proposed captions state the
mathematical point and the visual encoding without repeating adjacent prose; theorem
numbers in captions are by name here and should be replaced by final numbering.

For every figure the intended validation is a blind comparative read: give the affected
passage with and without the figure to matched readers who did not propose it, and probe
comprehension with the stated question. Per-figure testability notes flag where that
protocol is weak. (Implementation note for whoever builds F5: it is a data plot; the
repo's dataviz conventions apply, and it must remain legible in monochrome.)

### F1. Operator pushing and holonomy on the party circle

- **Job:** make the atlas data `M_A(i,j)` and the holonomy loop concrete before the
  atlas theorem. The introduction currently does this with an inline arrow chain
  (`P_i → P_j → P_k → P_i`) plus a paragraph asking the reader to imagine overlapping
  supports; the figure replaces the imagining.
- **Object:** 2m = 6 parties as labelled nodes on a circle; three 4-party minimum
  supports A, B, C as shaded regions (distinct hatchings, not color alone) with
  pairwise overlaps at parties j, k, i; a single Weyl label pushed along directed arcs
  labelled `M_A(i,j)`, `M_B(j,k)`, `M_C(k,i)`; the composed loop marked
  `Hol ∈ GL_2(q)` at the base party. Inset: the plane `P_i = F_q²` with the label v and
  its return image `Hol·v`, and the compatibility condition `F_i Hol = Hol F_i`.
- **Where:** Section 3.1, immediately after the definition of `M_A(i,j)` (near (3.6)),
  cross-referenced from the introduction's schematic display.
- **Caption draft:** "Operator pushing on minimum supports, shown for 2m = 6. Each
  (m+1)-party support identifies the local Weyl-label planes of its parties through the
  bijective projections of the support theorem; overlapping supports compose to a loop
  whose holonomy is a linear map of the base plane. A tuple of local symplectic frame
  changes is an atlas equivalence exactly when it intertwines every transition; for a
  single state and prime q, the compatible gauges are the centralizer of all loop
  holonomies."
- **Test:** blind read of Section 3.1 through the atlas proof; probe: "what data does
  the atlas record, and what is G_ψ for prime q?" Cleanly testable.

### F2. Rank-one contractions recover the axes

- **Job:** the engine of the whole paper is Lemma [diagonal-axes]; its mechanism
  (contraction locus = coordinate axes, detected by the rank of a flattening) is stated
  linearly in prose and is intrinsically pictorial. This is the figure that transfers
  the proof idea of Theorem 1.1.
- **Object:** a three-leg tensor-network diagram of
  `T = Σ_j λ_j e_{1j}⊗e_{2j}⊗e_{3j}` with the diagonal index j shown as a single wire
  through all legs; two contractions side by side: against a generic dual vector x
  (resulting flattening shown as a matrix nonzero pattern with several surviving rows;
  annotation `rank = #{j : x_j ≠ 0}`) and against a dual axis `e*_{1k}` (flattening with
  one surviving row; `rank = 1`).
- **Where:** Section 3, beside Lemma [diagonal-axes].
- **Caption draft:** "A diagonal tensor with all coefficients nonzero exposes its own
  axes: contracting one leg against x and flattening the remainder gives a matrix of
  rank equal to the number of nonzero coordinates of x, so the rank-one contraction
  locus is exactly the set of dual coordinate axes. For an (m+1)-party AME marginal
  viewed in local Hilbert–Schmidt spaces, the recovered axes are the local Weyl axes,
  and a product conjugation must permute them."
- **Test:** blind read of Lemma [diagonal-axes] plus Proposition
  [full-weyl-marginal]; probe: "why must a product intertwiner permute Weyl axes?"
  Cleanly testable.

### F3. The symmetry-group ladder

- **Job:** the paper's group structure lives in three exact sequences stated pages
  apart — `1 → L_ψ → Γ_ψ → G_ψ → 1` (Theorem 1.2), the torus sequences and
  `1 → Γ → Γ̃ → Π → 1` (Corollary [discrete-lu-symmetry]), and the factor-set splitting
  criterion (Appendix C). No passage assembles them; every reader must build the lattice
  alone. A single diagram does work that prose demonstrably has not done.
- **Object:** an extension ladder: identity component `T = (S¹)^{2m}` at the base;
  `G ⊂ G̃` (unitary tuple groups) with quotients `Γ ⊂ Γ̃` marked finite; inside Γ the
  normal projective-Pauli subgroup `L_ψ` with quotient `G_ψ`, annotated "= holonomy
  centralizer in SL_2(q), q prime"; Γ̃/Γ ≅ Π (realized party permutations) with a dashed
  arrow marked "splits iff the Appendix C factor set is trivial; all computed rows
  split." Each solid arrow tagged with the result that proves exactness.
- **Where:** end of Section 3.1 or beside Corollary [discrete-lu-symmetry], so both
  sequences are in scope.
- **Caption draft:** "The layered symmetry group of a stabilizer AME state. One-site
  phases form the identity component; the fixed-party projective quotient is finite and
  is an extension of the atlas gauge group by the projective Pauli stabilizer; allowing
  party motion extends it by the realized permutation group, with splitting governed by
  a nonabelian factor set."
- **Test:** weaker than F1/F2 because the figure aggregates three passages, so a single
  affected passage is hard to isolate. Suggested protocol: after reading Section 3 with
  or without the diagram, ask the reader to state which group is finite, which is the
  identity component, and where party permutations enter. Comprehension differences will
  be measurable but attribution to one passage will not be.

### F4. The defect landscape (schematic)

- **Job:** Subsection 3.3's argument arc — isolated zeros, quadratic wells whose
  certified radius grows with uniformity order, a uniform gap under Clifford points, an
  explicit threshold below which everything falls into a well — is currently
  reconstructible only by reading fifteen statements in order. One schematic supplies
  the causal picture and doubles as the subsection's roadmap.
- **Object:** graph of `ε(U)²` over a one-dimensional caricature of `PU(q)^{2m}`:
  zeros at the exact symmetries (marked as Clifford points); parabolic wells with
  annotated certified slope `≈ D²/q` and radius "grows with uniformity order"; all
  other product-Clifford points on or above a horizontal line at `2 − 2p^{−1/2}`
  (uniform separation); a low horizontal line at `ε_0²` (explicit threshold) with the
  annotation "below this line, round to Clifford ⇒ exact symmetry." Optionally the
  RM(1,ℓ) family as one marked shallow configuration limiting the order-3 radius.
- **Where:** opening of the (promoted) discreteness-and-stability section, as its
  roadmap figure.
- **Caption draft:** "Defect of a product unitary acting on a stabilizer AME state
  (one-dimensional schematic of a high-dimensional group manifold). Exact symmetries are
  isolated zeros with certified quadratic growth on a neighbourhood whose radius grows
  linearly in the uniformity order; every product Clifford outside the symmetry group
  has defect at least `(2−2p^{−1/2})^{1/2}`, a constant of the characteristic; below the
  explicit threshold every product unitary factors through an exact Clifford symmetry."
- **Test and risk:** blind read with probe "what replaces the compactness step, and
  where does the threshold formula come from?" The risk specific to this figure is that
  a cartoon can overclaim (e.g. suggesting all local minima sit at Cliffords, or that
  the manifold picture is faithful). Validation must include a falsehood probe: ask the
  blind reader what the figure asserts and check they do not report anything the
  theorems do not say. If that probe fails in piloting, cut the figure rather than
  caveat it into uselessness.

### F5. Certified radius versus uniformity order (data plot)

- **Job:** the quantitative regime structure — `R_k = ((k+1)!/48)^{1/(k−1)}` growing as
  k/e, the ceiling `2π(1−1/q)n` making linear growth maximal, the direct t ≤ 1/2 bound
  at k = 2, and the exact order-3 radius pinned to `[R_3, θ*]` by the Reed–Muller
  family — is currently spread across four results and two pages of prose with inline
  numbers (R_4 = 1.357, R_10 = 4.548, …). This is exactly the repeated-comparison
  content the style guide sends to a display, and it is the one proposal where the
  figure replaces arithmetic the reader would otherwise do.
- **Object:** x-axis uniformity order k (2…30), y-axis ℓ¹ radius, log scale. Points or
  curve for R_k; dashed asymptote k/e; the k = 2 direct bound 1/2 as a distinguished
  point; a shaded vertical interval [1/√2, 1.4656] at k = 3 labelled "exact radius for
  constant √(6q/5) (RM(1,ℓ) family)"; for AME(2m,q) annotate k = m and draw the ceiling
  `4π(1−1/q)m` in the same variable for one stated q, labelled as the scalar-phase
  ceiling.
- **Where:** immediately after Proposition [stability-region].
- **Caption draft:** "Certified ℓ¹ radius of the quadratic stability estimate against
  the uniformity order k. The radius `R_k = ((k+1)!/48)^{1/(k−1)}` grows as k/e; the
  scalar-phase configurations bound every certified radius by `2π(1−1/q)n`, so linear
  growth in the party count is the maximal order and AME states, with k = m, attain it.
  At k = 3 the Reed–Muller family pins the exact radius for the constant `√(6q/5)`
  inside the shaded interval."
- **Test:** the easiest to validate. Probe: "how does the certified region scale with
  the party count for AME states, and what stops it growing faster?" The prose-only
  version of that answer requires assembling three results; time-to-correct-answer is a
  clean metric.

### F6. The pencil parameter tower and its special loci

- **Job:** Section 4 plus Appendix B ask the reader to track: the admitted locus (4.1),
  the substitutions t → y → z with the four deck identifications and their realizing
  party permutations, the GRS boundary z = −1/4, the collision value z = 1, the q = 13
  witness pair z = 4, 12, and the transport divisor z ∈ {2, 4/9} — with the last item
  three sections away and explicitly *not* an LU-orbit boundary. A tower diagram makes
  the degree-8 structure and the status of each special value simultaneously visible;
  prose cannot hold six decorated loci in the reader's head at once.
- **Object:** three horizontal parameter lines. Top: t-line with the admitted deletions
  of (4.1) as open circles. Middle: y-line, map `t ↦ (t−1)²/t` marked 2:1. Bottom:
  z-line, map `y ↦ (y−y^{−1})²/16` marked 4:1, with the deck maps `y ↦ ±y^{±1}` listed
  beside their party permutations (id, (56), (35)(46), (3546)). On the z-line, marked
  and typed loci: z = −1/4 "GRS boundary (excluded)"; z = 1 "bracket collision A² = B²";
  z = 4, 12 "q = 13 four-copy witness pair"; z = 2, 4/9 "transport-rank divisor
  (Appendix B; detector-only, not an orbit boundary)."
- **Where:** Section 4, directly after the statement of Theorem [lc-pencil].
- **Caption draft:** "The degree-eight quotient of the admitted pencil. The parameter t
  double-covers y = (t−1)²/t, and the four identifications y ↦ ±y^{±1}, each realized by
  a displayed projectivity and party permutation, cover z. Excluded and special loci are
  marked with their status; the transport divisor belongs to one scalar detector and is
  not an LU-orbit boundary."
- **Test:** blind read of Section 4 plus the first page of Appendix B; probe: "list the
  special z-values and say in what sense each is special." Cleanly testable, and the
  detector-vs-orbit-boundary distinction is precisely the confusion the figure exists to
  prevent.

### Borderline proposals

- **F7. Self-association mechanism strip (Section 5).** A conic-vs-nonconic two-panel
  picture of six points would be decorative: the geometric dichotomy is easy to imagine
  and the prose is already crisp. What might earn a place is a *mechanism* strip:
  arc H → Veronese rows V_i → full-support relation d → diagonal S with SC = C⊥ →
  unipotent blocks (3.15) at every leg → logical SL_2. That is a correspondence chain of
  five languages (geometry, linear algebra, coding, symplectic labels, logical gates),
  which is figure-shaped. I would prototype it and keep it only if the blind test shows
  a gain on the probe "why does a conic through six points buy logical SL_2?"; my
  expectation is a modest gain.
- **F8. Half-splitting cut picture.** The bipartition A | A^c with the unit vectors u, v
  on the label group and the cut-transversal labels `A ∪ {j}` straddling the cut is
  spatial, and the proof of the budget-free theorem is the subsection's hardest read.
  A small inline diagram (parties in two blocks, one straddling label highlighted, the
  inequality flow `v large, u small`) could be folded into the promoted stability
  section. Second priority; test as for F4 with the probe "which labels force u and v
  apart, and why does the AME condition supply them?"

### Rejected candidates

- **Four-step mechanism strip in the introduction.** The displayed implication chain
  already does this job in four lines; a figure would restate prose, failing the
  style-guide test. F2 covers the only step that benefits from a picture.
- **Choi/encoder reshaping diagram for Corollary 1.3.** Standard for the venue
  audience; the displayed equations are faster than a wiring diagram.
- **Clebsch X-syndrome conic in PP²(F_11).** The content is imported from the companion
  paper; a figure here would raise its visual weight exactly when the section needs its
  weight lowered.
- **Support-count staircase for (3.4).** One two-case formula; a graphic adds nothing.
- **(4.5) holonomy multiset as a chart.** It is already a table, and the argument that
  consumes it is about multiplicity arithmetic, not shape.

## 5. Prose and exposition

**Where the reader loses the thread.**

- The introduction paragraph beginning "Finiteness alone needs much less" attempts to
  summarize all of Subsection 3.3 in one paragraph, and its second sentence runs to
  roughly eighty words with four qualifying clauses. It should be split into the
  discreteness claim, the separation claim, and the what-remains-open claim, one
  sentence each; the abstract's second paragraph has the same problem in the same words.
- The transition into Subsection 3.3 is abrupt: the reader leaves a Choi-isometry proof
  and lands in Lie theory with only two sentences of bridge. Promoting the subsection to
  a section with a strategy paragraph (and F4 as roadmap) fixes this.
- The sentence at (3.4), "Möbius inversion is the stabilizer-state specialization of the
  quantum-MDS Shor–Laflamme distribution of Huber and Grassl," does not parse — Möbius
  inversion is not a specialization of a distribution. Presumably intended: "(3.4)
  together with Möbius inversion recovers the stabilizer-state specialization of…".
  As written it is a defect a referee will quote.
- Section 5's closing paragraph ("A different MDS uniformity governs operator pushing")
  compares two counts (ten pushes per input Pauli, twenty supports per syndrome) whose
  purpose in the paper is never stated; the paragraph reads as a dangling observation.
  Either say what the contrast is for or cut it.
- Remark [clebsch-x-syndrome-boundary] stacks five consecutive scope disclaimers. The
  style guide's rule — warn once, close to first use — applies; two of the five carry
  content (fixed-party vs electric–magnetic; covering radius is about translates, not
  error correction) and the rest should go.
- Proposition [fixed-copy-boundary] contains its own caveat ("This asserts no existence
  of k-points…") inside the theorem environment. Correct mathematics, wrong location:
  the vacuity caveat belongs in the surrounding text or a remark, not in the statement,
  where it breaks the claim's rhythm and invites misquotation.

**Duplication.** The final two sentences of Section 6 ("In contrast, the four-party
operator tensor (3.2) retains the Weyl axes… precise distinction between scalar
blindness and marginal covariant rigidity") reappear verbatim as the final two sentences
of Appendix A. One copy must go — the Appendix A copy, since Section 6 owns the
contrast.

**Where the paper does work the reader will not notice** (worth surfacing, since these
are the passages that prevent real errors): Lemma [pauli-phase-correction] quietly
carries the entire lift half of the atlas theorem; Remark [local-phase-torus] forecloses
a genuine which-torus confusion that a careless reader (or author) would otherwise trip
on; the paragraph distinguishing the coherent `H_q ⋊ SL_2(q)` lift from a nonexistent
section of `F_q² ⋊ SL_2(q)` settles a point on which the transversal-gate literature is
often sloppy; and the systematic verification that each stability hypothesis is
load-bearing (the ceiling family against the budget-free bound, the RM family against
the ℓ¹ budget) is referee-proofing of a quality rarely seen. A one-sentence signpost at
the head of the promoted stability section ("each hypothesis below is shown necessary by
an explicit configuration") would let readers see this discipline instead of merely
benefiting from it.

**Where the paper claims more attention than the content earns:** the Clebsch
proposition and remark in Section 5 (imported content, native contribution thin — see
verdict); the Frobenius-sector proposition in Section 4 is presented at theorem weight
but is, by its own closing paragraph, two divisors plus an explicitly non-claimed
bridge — a remark-weight result; and the abstract's fourth paragraph gives the m = 3
pencil result equal billing with the uniform theorems, which the paper's own hierarchy
(Table 1) does not support.

**Mechanical.**

- Equation numbering mixes `\numberwithin` automation with manual `\tag`s ((2.0)–(2.3),
  (3.1)–(3.16), (1.1)–(1.3)) and automatic `\begin{equation}` numbers in Sections 6 and
  the appendices. No collision today, but "(2.0)" is nonstandard and the mixed scheme is
  fragile under revision; unify.
- "an \([6,3,4]_q\) MDS code" (Section 2) — article typo.
- Proposition [region-ceiling]: "both eigenvalues of \(e^{ih_j}\)" — there are two
  distinct eigenvalues of h_j but q of e^{ih_j}; say "every eigenvalue."
- The appendix file order (A = scalar certificates, B = transport, C = party
  extensions) does not match the source file names (10, 07, 09); harmless in the PDF,
  but note the conclusion (file 07-conclusion) renders as Section 8 after Verification
  (Section 7) — that order is deliberate and good (the paper ends mathematically), just
  confirm the intro's forward references stay synchronized if sections move.

**Overall tone check against the house style:** the manuscript is calm, does not
advertise, states priority boundaries once and generously (the Rains/VdN–DDM and Tan
concessions are models of the genre), and expands where understanding is won. Its
failures are structural (mass distribution, abstract length) and local (the items
above), not tonal.

## Summary of demanded changes (referee hat, ranked)

1. Add `m ≥ 2` to Theorem 1.2 (atlas classification) and Corollary 1.3 (transversal
   no-go). Both are false at m = 1 as stated.
2. Promote Subsection 3.3 to its own section with internal structure and a roadmap;
   reconcile title/abstract weight with it.
3. Halve the abstract.
4. Add the two-line traceless-component justification in the quantitative-intertwiner
   proof; tag the budget-free comparison paragraph with m ≥ 3.
5. Fix the garbled Möbius sentence, the duplicated closing sentences, the in-statement
   caveat in Proposition [fixed-copy-boundary], and the Remark
   [clebsch-x-syndrome-boundary] disclaimer stack.
6. Add figures F1, F2, F5, F6 (F3, F4 recommended; F7, F8 optional pending pilot), each
   validated by the blind comparative-read protocol described above.
7. Decide whether the Clebsch proposition stays at proposition weight or becomes an
   example; either way cut its remark by half.

