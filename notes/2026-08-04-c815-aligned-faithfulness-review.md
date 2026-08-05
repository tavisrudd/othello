# Cold referee review: aligned-family faithfulness formalization (commit 335937df)

**Verdict: ACCEPT WITH FIXES** — the formal statement faithfully captures the two-graph half of
`thm:aligned-faithfulness`, the proof is sound and axiom-clean, but four referee-facing prose
inaccuracies must be corrected, the worst being a theorem docstring that denies hypotheses the
statement actually carries.

Reviewed files (all unchanged between 335937df and current HEAD; verified by empty
`git diff 335937df HEAD` on the six paths):

- `lean/RelativeConicArcs/AlignedFamilyFaithfulness.lean` (new)
- `lean/RelativeConicArcs/AlignedTwoGraph.lean` (header prose touched; full-module audit per the
  review gate's no-grandfathering rule)
- `lean/RelativeConicArcs/Gates/ClebschPassages.lean`
- `papers/clebsch-passages/sections/08-verification.tex`
- `papers/clebsch-passages/verification/passages_formal.json`, `trust_manifest.json` (row OPER-4)

Elaboration evidence: `lean/scripts/guarded-lean RelativeConicArcs/AlignedFamilyFaithfulness.lean`
exits 0 with no diagnostics; `guarded-lean RelativeConicArcs/Gates/ClebschPassages.lean` exits 0 and
prints 55 `#print axioms` results. Both are single-file elaborations against last-built dependency
oleans, i.e. smoke tests in the sense of `lean/AGENTS.md`, not a gate build.

## Q1. Does the Lean theorem state the paper's claim?

Yes, with one encoding remark and one docstring defect.

`exists_complementBit_of_alignedFamily_eq` (AlignedFamilyFaithfulness.lean:585-592) states: for
`tau sigma : α → α → α → Bool` with `TriangleSymmetric` and `FourSetParity` each, `[Fintype α]`,
`7 ≤ Fintype.card α`, and `hfam : ∀ a b c d, DistinctQuadruple a b c d → (Aligned tau a b c d ↔
Aligned sigma a b c d)`, there is one `epsilon : Bool` with `sigma a b c = xor (tau a b c) epsilon`
on every `DistinctTriple`.

- **Hypothesis strength.** `hfam` quantifies over ordered pairwise-distinct quadruples with an iff;
  given `TriangleSymmetric` on both sides this is exactly `\mathcal A(tau) = \mathcal A(sigma)` as
  families of 4-element subsets — neither weaker nor stronger. `Aligned` (AlignedTwoGraph.lean:48-52)
  is "the four triangle values of the four canonical sub-triples agree", the paper's definition.
- **Smuggled strength at repeated arguments.** `FourSetParity` (AlignedTwoGraph.lean:42-45) and
  `TriangleSymmetric` (AlignedFamilyFaithfulness.lean:45-49) quantify over ALL tuples, including
  repeats. The instance `FourSetParity a b c c` forces `tau a c c = tau b c c`, and `a = b` forces
  `tau a a c = tau a a d`; so the hypotheses do constrain repeated-argument values. I checked all
  coincidence patterns of two equal arguments: given symmetry, every repeated-argument parity
  instance cancels the distinct-triple values and relates only repeated-argument data to itself. So
  no strength is smuggled into the distinct-triple content, and every set-function two-graph extends
  to a qualifying tuple function (set the value to `false` at every repeated argument; all parity
  instances then hold). But that extension dictionary is itself outside Lean — see Q6.
- **Conclusion.** Agreement up to one global bit on distinct triples is exactly "determines tau up to
  complement" for a set function, once paired with the formal converse `aligned_complement_iff`
  (AlignedTwoGraph.lean:59-64, in the gate), which the docstring correctly cites. `epsilon = false`
  gives equality, `epsilon = true` gives the complement; nothing is claimed at repeated arguments,
  matching a function on `\binom V 3`.
- **Finiteness.** The paper (05-golden-operator.tex:214, "two-graph on a finite set V") and the Lean
  `[Fintype α]` with `7 ≤ Fintype.card α` agree.

**Defect (required fix #1).** The docstring lines 582-584 claim: "The hypotheses quantify over
triples and four-sets of pairwise distinct points only; nothing is assumed about the value of a
triangle bit at a repeated argument." This is false for `hsymT/hparT/hsymS/hparS`, which are
asserted at all tuples and, as shown above, do constrain repeated-argument values. Only `hfam` and
the conclusion are distinct-points-only. The sentence makes the theorem sound weaker-hypothesised
(hence stronger) than what Lean checks — precisely the comment/statement mismatch
`lean/AGENTS.md` bans.

## Q2. Non-vacuity and consistency

Not vacuous, hypotheses not contradictory.

- `tau ≡ false` satisfies both laws trivially; with `sigma := tau` the theorem yields
  `epsilon = false`. With `sigma ≡ true` (also satisfies both laws; the four-fold xor of `true`
  is `false`), `hfam` holds since both sides are always aligned, and the conclusion forces
  `epsilon = true` on, e.g., `α = Fin 7`. So the bit genuinely varies.
- Non-degenerate instances: for any symmetric `g : α → α → Bool`, `edgeTriangle g`
  (AlignedTwoGraph.lean:446-448) satisfies both laws at all tuples (each edge occurs twice in the
  four-set xor, including under coincidences), and a one-edge graph on `Fin 7` gives a proper
  aligned family. So the hypothesis class contains every graph-generated two-graph.
- Repeated-argument parity does force relations like `tau a c c` independent of `a`, but never
  anything about distinct triples, and the all-false-at-repeats extension shows the class is exactly
  the paper's two-graphs plus benign diagonal data.

## Q3. Faithfulness of the supporting definitions

All checked against the paper tables and equation (5.2); all match.

- `cutOfBits` (AlignedFamilyFaithfulness.lean:102-104) encodes `(b₀,b₁,b₂)` as bits 0,1,2 of a
  `Fin 8`, with `cutBit _ 3 = false` (AlignedTwoGraph.lean:215-219 and the simp lemma at
  AlignedFamilyFaithfulness.lean:118). `anchorCut tau q₃ q₀ q₁ q₂ x` (:124-125) is
  `(tau q₃ q₀ x, tau q₃ q₁ x, tau q₃ q₂ x, 0)`. This realizes the paper's normalized cut with the
  root playing the paper's vertex 4: rooting at a member of the aligned anchor with zero triangle
  bit replaces the paper's two-step switching ("switch representatives so both vanish on Q, switch
  each outside vertex so its edge to vertex 4 is zero") by taking triangle bits rooted at `q₃` and
  fixing the fourth coordinate to zero definitionally. The equivalence is not assumed by analogy:
  the transport lemmas derive the signature identities from `FourSetParity` alone.
- Balanced cuts: paper `B₁₂ = 1100, B₁₃ = 1010, B₁₄ = 0110` in coordinates `(e₁,e₂,e₃,e₄)`
  correspond to `(b₀,b₁,b₂)` values `3, 5, 6` = `balancedCut12/13/14` (AlignedTwoGraph.lean:232-239).
  Values correct; docstring wording defective (fix #3 below).
- Paper equation (5.2), `ij ∈ B(p,s,e) ⟺ pᵢ+sᵢ = pⱼ+sⱼ and e = pⱼ+sᵢ`, is exactly `pairAligned`
  (AlignedTwoGraph.lean:257-260) including the asymmetric second conjunct `equalBit e
  (xor (cutBit p j) (cutBit s i))` — `p` the first outside point's cut and index `j` the second
  anchor coordinate. I re-derived (5.2) by hand from the rooted-edge expansion
  (`tau(uvx) = pᵢ+pⱼ`, `tau(uxy) = pᵢ+sᵢ+e`, etc.) and it matches.
- Transport lemmas (AlignedFamilyFaithfulness.lean:175-225): `aligned_root_pair_iff` gives
  `anchorSignature` coordinates 0-2 (both cut coordinates equal and zero ⟺ `Aligned q₃ u v x`),
  `aligned_outer_iff` gives coordinate 3 (three coordinates agree ⟺ `Aligned q₀ q₁ q₂ x`),
  `aligned_anchor_pair_iff` gives `pairAligned` at anchor coordinate pairs `(i,j)` with `i,j ≤ 2`,
  and `aligned_root_outside_iff` covers pairs `(i,3)` where coordinate 3 is the root: there
  `pairAligned p s e i 3` degenerates (via `cutBit _ 3 = false`) to `pᵢ = sᵢ ∧ e = sᵢ`, matching
  `Aligned u q₃ x y`. I checked every one of the ten `fin_cases` branches of `sevenPoint_agreement`
  (:256-322) for correct pairing of signature coordinate, `NormalizedAnchor` field, and `hfam`
  index quadruple; all consistent (e.g. `anchorSignature _ 0` ↔ `root₁₂` ↔ `hfam 0 2 3 m`;
  `pairSignature _ 2` ↔ root-outside at `u = p 1` ↔ `hfam 1 0 m n`).
- The one-outside-point signature classification and the 16,384-case pair classifier
  (`anchorSignature_eq_false_iff_balanced`, `pairSignature_classification`,
  AlignedTwoGraph.lean:250-283; 8·8·8·8·2·2 = 16,384) agree with the paper's three tables,
  including the empty signatures of exactly the three balanced cuts and the sole distinct-balanced
  swap ambiguity.

## Q4. Circularity, unused hypotheses, decide-hiding

- No circularity: `AlignedFamilyFaithfulness` imports only `AlignedTwoGraph` plus Finset/Fintype
  card lemmas; the classifiers it invokes do not depend on the new module.
- All named hypotheses of the three public theorems are load-bearing (symmetry enters through
  `aligned_root_outside_iff` and the final rooted-reconstruction case split; parity through
  `triangle_eq_rooted_xor`; `DecidableEq` through the `Finset.erase` bookkeeping in
  `exists_complementBit_on_seven`). The one intentionally unused binding is `_hbaseAgain`
  (AlignedTwoGraph.lean:436), properly underscored.
- The `decide` calls in the new module are all small Boolean tautologies after explicit `cases`
  (≤ 2⁵ cases) or `Fin 7` index inequalities; the mathematical content in each transport lemma is
  the preceding rewrite by the parity-derived identities, so no definitional accident can hide
  there. The `simpa [hdT, hdS, anchorCut]` reads at :355-378 unfold to the `cutBit_cutOfBits_*`
  simp lemmas, which are proved by 8-case `rfl`, not by unfolding `Nat.testBit` blindly.
- Axiom audit (from the gate elaboration log): all 55 printed terminals depend on at most
  `propext, Classical.choice, Quot.sound`; exactly six depend on no axiom; no `sorry`,
  `ofReduceBool`, or compiled-evaluation axiom appears. This matches the gate header's claim
  (ClebschPassages.lean:22-24) verbatim, including the count "six".

## Q5. Referee-facing prose audit (entire touched modules)

Violations, with locations:

1. **AlignedFamilyFaithfulness.lean:582-584** — docstring falsely states the hypotheses quantify
   over distinct points only and assume nothing at repeated arguments (see Q1). Required.
2. **AlignedFamilyFaithfulness.lean:28** — "Every step here is symbolic." The module contains many
   kernel-`decide` steps (e.g. :82, :96, :182, :195, :212, :225 and the `Fin 7` index facts). The
   header's own dichotomy (symbolic here vs kernel-decided classifiers in `AlignedTwoGraph`) makes
   this inexact; reword to disclose the small kernel-decided Boolean case checks, per the
   computational-disclosure rule. Required, small.
3. **AlignedTwoGraph.lean:232-239** — `balancedCut12/13/14` docstrings give "three-bit word
   `011`/`101`/`110`" without stating word order. In the module's own coordinate order
   (`cutBit` bits 0,1,2) the words are `110`, `101`, `011` respectively; the docstrings use
   msb-first binary of the `Fin 8` value, so for `balancedCut12` and `balancedCut14` a reader using
   the coordinate convention documented at `cutOfBits` ("first three coordinates") reconstructs the
   wrong constant. Also, nothing explains what "12"/"13"/"14" denote (the paper's `B₁ⱼ`
   bipartition labels on anchor points 1-4, while the Lean coordinates are 0-3). Touched module, so
   no grandfathering. Required, small.
4. **passages_formal.json OPER-4 `excluded` field** — "…are no longer excluded, since faithfulness …
   is kernel-checked …" is change-history prose inside a field whose job is to state what IS
   excluded now. Rewrite to the two current exclusions plus, if wanted, a positive statement of
   what is checked, without "no longer". Required, small.
5. **08-verification.tex:44** — "The formal proof follows the one above." The globalization step
   differs: the manuscript proof (05-golden-operator.tex:326-329) descends along adjacent
   seven-sets in the connected Johnson graph, while the Lean proof places any two distinct triples
   in one common seven-point restriction and calibrates at a base triple
   (AlignedFamilyFaithfulness.lean:594-623, `global_agreement_of_common_seven_restrictions`).
   The same sentence's own later enumeration ("the extension of any two triples to a common
   seven-point restriction") already describes the Lean route, so the tex is internally
   inconsistent with the manuscript proof it points at. Either qualify the sentence or align the
   manuscript's globalization paragraph. Optional but recommended.
6. **AlignedFamilyFaithfulness.lean:436-437** — "both two-graphs are shifted so that their common
   anchor bit vanishes": the anchor four-set is common, but each candidate has its own anchor bit
   (`eT`, `eS`, possibly different); "their common anchor bit" misreads. Optional wording fix.

No workflow identifiers, task IDs, lane names, agent references, status prose ("TODO", "for now",
etc.), novelty claims, or strength-bearing names lacking formal witness were found in either Lean
module or the gate. "Faithfulness" in the module/file name is witnessed by the theorem plus
`aligned_complement_iff`. External citations are not made in these modules; internal references
(`anchorSignature_eq_false_iff_balanced`, `pairSignature_classification`,
`normalizedSevenSignature_injective`, `aligned_complement_iff`) all resolve. The
`selectedQueryCount_eq` and `sixPointAnchor_testCount` docstrings correctly disclaim defining the
query family or formalizing a search procedure.

## Q6. Do the tex/JSON claims match the checked surface?

Essentially yes; nothing materially overstated or understated.

- 08-verification.tex:41-44 states the kernel-checked form exactly as the Lean conclusion, and its
  scoping "determine the triangle values on distinct triples" is commendably precise. The itemized
  list (:44-51) — both Ramsey bounds, anchor through a root, label-to-cut normalization, signature
  ambiguity, third-point elimination, seven-point distinctness, common seven-point extension,
  overlap agreement — corresponds one-to-one to `exists_monochromatic_triple`,
  `no_monochromatic_triple_five`, `exists_alignedAnchor`, `xorBit`/`normalizedAnchor_of_aligned`,
  the classifiers, `threePairOutcomes_eliminate_swaps`, `hpinj` inside
  `exists_complementBit_on_seven`, `Finset.exists_superset_card_eq`, and `complementBit_unique`.
  The retained human steps (design identification, query-family cardinality) match the Lean
  docstring disclaimers.
- trust_manifest.json `boundary` and OPER-4 `proof_role` describe exactly the new surface
  ("faithfulness up to a global complement bit for every two-graph on a finite point set with at
  least seven points") and correctly moved the old exclusions (finite-set normalization inputs)
  out of the not-proved list, replacing them with the design identification. `coverage` remains
  "partial mechanism; no full row claim", correct since the conference-matrix half of the theorem
  is human. The five new gate `#print` lines match the five new declarations added to the OPER-4
  `declarations` list.
- One residual gap worth one sentence somewhere (module header or tex): the phrase "every
  two-graph" quantifies over set functions `\binom V3 → F₂`, whereas the Lean theorem quantifies
  over symmetric tuple functions with the parity law at all tuples. Every two-graph induces such a
  function (extend by `false` at repeated arguments) and conversely, but this two-line dictionary
  is not formalized. This is standard encoding slack, not an overstatement, but stating it would
  close the correspondence explicitly, as the style guide asks for formal results.
- The tex sentence "The unrestricted inclusion-rank and Ramsey exclusion is a human proof" remains
  accurate: the exchange-rigidity application (Jolliffe rank, the `2d−1 ≤ 5` contradiction) is
  unformalized even though `R(3,3) = 6` itself now is; OPER-3's proof_role says exactly this.

## Ranked fixes

Required:

1. Rewrite the `exists_complementBit_of_alignedFamily_eq` docstring (AlignedFamilyFaithfulness.lean:582-584):
   the aligned-family hypothesis and the conclusion are distinct-points-only; the symmetry and
   parity laws are assumed at all argument tuples, and any function on three-element subsets
   obeying the parity law extends to such a function (zero at repeated arguments).
2. passages_formal.json OPER-4 `excluded`: remove the "no longer excluded" history clause; state
   only the current exclusions (and, if desired, the current positive coverage).
3. AlignedTwoGraph.lean:232-239: fix or disambiguate the `balancedCutNN` docstring bit-words and
   gloss the `12/13/14` bipartition labels against the 0-3 coordinate convention.
4. AlignedFamilyFaithfulness.lean:28: replace "Every step here is symbolic" with a wording that
   discloses the small kernel-decided Boolean case checks.

Optional improvements:

5. 08-verification.tex:44 / 05-golden-operator.tex:326-329: reconcile "the formal proof follows the
   one above" with the different globalization (common seven-set vs Johnson-graph descent).
6. AlignedFamilyFaithfulness.lean:436-437: "their common anchor bit" → each candidate's own anchor
   bit on the common anchor.
7. Add the one-sentence set-function/tuple-function correspondence remark (module header or tex).

Verification caveat: my elaborations are single-file smoke tests against last-built dependency
artifacts, not a gate build; the axiom outputs quoted above come from the guarded gate elaboration
log of this session.
