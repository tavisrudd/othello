# C776 integration review — follow-up on commit 77c693cf

**Lane**: `ame-lu`
**Date**: 2026-08-02
**Status**: COMPLETE. Read-only pass; this file is the only write.

Reviewed: the full diff of 77c693cf; the drafting report
`2026-08-01-c776-two-uniform-rigidity-adoption.md`; the new Section 3 subsection
(`sec:two-uniform`, sections/03-lu-rigidity.tex lines 352–1027) read in full; the abstract,
introduction, conclusion, and Section 8 diffs; the theorem-map, novelty-ledger,
verification-map, and formalization-ledger additions; and, as constraints, the C774 red-team
and C775 literature audit in full. My prior scope review
(`2026-08-01-c776-scope-fable-review.md`) is the baseline.

**Bottom line.** The edit implements the refined split faithfully and in several places improves
on it. All four non-negotiables are in the prose. Both flagged judgment calls are upheld. Two
concrete defects need fixing before the cold read, one of them referee-visible on any careful
read: the manual equation tags now render out of order — (3.12)–(3.16) appear before
(3.8)–(3.11) — and the decomposition proof states right invariance of the defect but uses left
translates. Neither touches correctness of any theorem.

---

## 1. Fidelity and deviations

Implemented as recommended: Theorem A as `thm:two-uniform-discrete` inside Section 3 with
`cor:discrete-lu-symmetry` recontextualized as the stabilizer specialization; the Lie-lift repair
as a standalone lemma (`lem:product-lie`, exactly C774's Lemma A0); stability with the visible
smallness hypothesis; B′ with the minimal-lift hypothesis in the statement, the `q=2`,
`h_j=π·diag(1,−1)` counterexample displayed, and the split quadratic-growth/isolation proof; C581
as `lem:quantitative-axes` + `prop:quantitative-intertwiner` with the explicit threshold `τ_p`
and the Auddy–Yuan odeco citation framed as specialization; Fisher as a remark with
Braunstein–Caves and Hyllus/Tóth citations and no firstness; the RM(1,4) boundary remark with a
self-contained proof (I re-verified the `TXT†` computation and the weight arithmetic — both
correct); the Bell-marginal clause in the introduction; the
infinitely-many-classes/finite-symmetry contrast; the new scope-table row; title unchanged; all
four ledgers updated; claim-to-trust paragraph in Section 8.

Deviations, judged on merit:

1. **The stability theorem is two-sided** (display (3.14)), following C774's strengthening, so
   "sharp to within about ten percent" is a proved statement rather than a numerical comment.
   Improvement over my one-sided recommendation.
2. **The isometry is stated in polarized form** (`lem:local-generator-isometry`), with the
   vanishing imaginary part proved. This is what makes the Fisher remark a statement about the
   quadratic form rather than its diagonal. Improvement.
3. **`prop:stability-region` is a manuscript proposition with a closed-form proof**, not a
   citation of C774's certificate. I re-derived the weight-enumerator computation, the defect and
   generator norms, and the ratio function `θ/(2 sin(θ/2))` from scratch: all correct, including
   the monotonicity argument and the factor-of-three sharpness remark. Keeping the supplement
   computation-free was the right call; the reproducibility contract is genuinely not engaged.
4. **Corollary D entered as a corollary with proof rather than my suggested three-sentence
   remark.** Right on merit: C775 cleared it, and C774's three repairs (isometric isomorphism
   written out, "modulo the local phases", inherited hypotheses and the non-explicit
   `ε₀(W)`) need statement-and-proof form to be checkable. The `q^{-1}‖·‖_F` normalization is
   verified in the proof, matching C774's check.
5. **The C581 negative half is conditional, and the C774 coding theorem is absent** — the two
   flagged calls, ruled on in §4.
6. **Two conclusion sentences beyond the brief.** Justified; a conclusion silent on the new
   subsection would misdescribe the paper, and the sentence "spent entirely on naming the finite
   group rather than on producing it" is the right summary.

Nothing I recommended is missing without a flagged reason.

---

## 2. Does the Fisher argument survive C774's narrowing?

My §1(a) argued the Fisher identity must ride with the stability theorem because it explains why
the constant is party-count independent. C774 split that property in two: the **ratio constant**
`√(6q/5)` is genuinely n-independent, but the **region of validity** shrinks like `n^{-1/2}`, at
an attained rate.

The argument survives, with the explanandum narrowed to exactly the part the Fisher form can
explain. The isotropy of the quantum Fisher form is second-order data: it is precisely the
statement that the Hessian of the defect is the same flat multiple of the Euclidean form in every
local-generator direction, which is why the *ratio* does not see `n`. The region shrinkage is a
third-order phenomenon — it is the cubic term of the Taylor expansion that the smallness
hypothesis controls — and the quadratic Fisher form is structurally silent about it. So the remark
should stay where it is and explain what it now explains; it should not move to the letter. The
drafted remark is correctly scoped: its first sentence claims only that (3.12) "explains why the
constant does not involve n", and the region facts are carried by `prop:stability-region` and the
"two separate statements in one breath" paragraph immediately after.

One cheap upgrade the drafter left on the table: add a clause to `rem:fisher-isotropy` saying
explicitly that the Fisher form is quadratic data and therefore governs the constant while saying
nothing about the size of the certified neighbourhood, pointing forward to
`prop:stability-region`. Without it, a referee who reads the remark as "the Fisher metric explains
the n-independence" may feel misled two paragraphs later when the neighbourhood turns out to
shrink. One sentence closes that reading.

---

## 3. The four non-negotiables, checked in the prose

1. **No party-count-independent certification claim.** LANDED. The abstract, the introduction
   paragraph, and the post-proposition summary each state the constant's independence and the
   neighbourhood's `n^{-1/2}` shrinkage in the same sentence. The deliberate-exclusions list adds
   it as a standing exclusion. One nuance, not a violation: the abstract's "on a neighbourhood
   that shrinks like the inverse square root of it" reads as a matched rate, while what is proved
   is an upper bound on every valid threshold (`prop:stability-region` says exactly "every valid
   threshold is O(n^{-1/2})"; C774's mystery ledger records the matching lower bound as open).
   "Shrinks at least as fast as the inverse square root" would be exact. Cold-read polish, not a
   blocker; the in-text statements are precise.
2. **No self-testing framing.** LANDED. A repository grep finds no occurrence of "self-test" in
   any manuscript file; the one certification word in the paper is the negative sentence "neither
   certifies an unknown device" (line 789), which is the genuine trust boundary C774 §3.2 asked
   for.
3. **No unsupported size-degradation sentence.** LANDED. "Degrade" does not occur in the
   manuscript; the source note's uncited claim about self-testing bounds was not reproduced.
4. **Genuine concession paragraph with correctly scoped firstness.** LANDED.
   `rem:discreteness-prior-art` concedes Wirthmüller (Theorem 7 and Corollary 11, with the Bell
   exclusion identified with the `n≥4` boundary) and Tan (Theorem 5.3, order 5832 stated), uses
   Słowik–Sawicki–Maciążek as the 1-uniform contrast with the positive-dimension fact the drafter
   verified from their Lemma 2 at full text — closing the gate C775 left open — and adds the GIT
   framing with the four stabilizer-dimension citations. The manuscript's only firstness sentence
   (line 522) is scoped to "arbitrary local dimension and arbitrary, in particular nonstabilizer,
   2-uniform states" and retains "to our knowledge", matching C775's uncovered-database posture.

All four verified against the prose directly, not the drafting report.

---

## 4. Rulings on the two flagged judgment calls

**(a) The cross-programme coding theorem (`rank_Q Λ_C = n` iff `d(C⊥) ≥ 3`): non-adoption
UPHELD.** The theorem is sharp and attractive, but its quantum payoff — the diagonal symmetry
group of a binary CSS coset state is finite exactly when the dual distance is at least three —
routes through the Smith-normal-form classification that belongs to the diagonal-rigidity
programme (C778–C785), is qubit-only in a prime-power-uniform paper, and carries a novelty
exposure (against Gross–Van den Nest and the CSS-T line) that C780 exists to audit and has not
audited. Importing the corollary without its engine would be an orphan; importing the engine would
be a scope pivot. The one follow-through the ruling requires: the proposition currently lives
only inside the C774 report, and the diagonal programme should adopt it explicitly when its
manuscript forms — worth a line in the C778–C785 planning notes so it is not lost. That is a
queue-side note, not a manuscript change.

**(b) The conditional form of C581's negative half: UPHELD, with a named upgrade path.** The
drafted sentence proves the implication that needs no witness — an exact intertwiner outside a
proposed smaller closed subgroup falsifies, at `ε = 0`, every uniform estimate toward it. My
original request ("by C623's exact witnesses") would have imported the `q=9` nonsemilinear
intertwiners and the `q=25` `Sp₄(5)` kernel, which are nowhere in the manuscript and would bring
C623's census under the paper's evidence contract for the sake of one sentence. The drafter's
form is better than what I asked for *given the manuscript's current contents*. The residual
weakness is real: as written, a referee can ask whether the antecedent ever fires. If a successor
task imports any C623 witness with proper evidence (or the census enters the paper for other
reasons), upgrade the sentence to the concrete form then. Record that as the reversal condition;
do not reverse now.

---

## 5. Cold read of the subsection, and the compression call

Read cold, `sec:two-uniform` is a decisive addition, not a bolt-on. It has its own arc — one
identity (3.12), then discreteness, stability, region, decomposition, the two-state bound, the
gate corollary — and it is stitched to the paper at both ends: the Bell boundary paragraph ties
the identity's failure mode to the `m ≥ 2` sharpness the paper already states, and the RM(1,4)
remark shows in one object what the AME hypothesis buys beyond 2-uniformity. The prose quality
matches the surrounding sections; the concession remark reads as confident rather than defensive.
The intertwiner block earns its place by the explicit-threshold/explicit-constant contrast, which
the transition sentence states plainly.

**The crowding call triggers, in the moderated form I pre-registered.** The one structural seam is
`cor:discrete-lu-symmetry` itself: its ninety-line nonabelian factor-set calculus (outer action,
normalized factor set, associativity and change-of-section laws) now sits mid-subsection between
the RM(1,4) remark and the stability theorem, interrupting the discreteness-to-stability flow with
party-permutation cohomology that has nothing to do with 2-uniformity. Before this edit the
corollary ended a subsection and the weight was tolerable; inside the new narrative it is a
digression whose only consumer is the party-extensions appendix. Recommendation for the cold read:
keep the corollary's exact sequences and finiteness statements in place (they are the stabilizer
specialization the subsection needs) and move the outer-action/factor-set displays and their proof
paragraphs to the party-extensions appendix beside `cor:computed-party-splitting`. This touches
theorem-map entries naming the kernel-checked factor-set terminals, so it is a deliberate
follow-up edit, not a mechanical one — which is why I flag it for the cold read rather than
calling the current state a defect. The drafter's alternative (split the subsection before
`lem:quantitative-axes`) is worse: the one-state/two-state/gate arc is the subsection's spine.

At 39 pages the paper carries the growth; nothing else needs cutting.

**Two defects to fix before the cold read.**

1. **Equation tags render out of order.** The new subsection carries manual tags (3.12)–(3.16)
   (lines 399–914) but was inserted *before* the "Exact MDS–CSS logical images and lifts"
   subsection, whose displays are tagged (3.8)–(3.11) (lines 1083–1159). The rendered paper now
   runs (3.7), (3.12)…(3.16), (3.8)…(3.11). `make check` cannot catch manual tags, and a referee
   will. Cheapest fix: renumber the new subsection to (3.8)–(3.12) and shift the multiplier
   subsection to (3.13)–(3.17); the in-file references are at lines 1088, 1142, and 1162, plus
   one "(3.8)" mention in the claim ledger and the tag names in the theorem-map and drafting
   report. Moving the subsection after the multiplier material instead would fix numbering but
   would separate `cor:discrete-lu-symmetry` from the discreteness theorem, which is the wrong
   trade.
2. **Left/right invariance slip in the decomposition proof.** The proof of
   `cor:approximate-decomposition` establishes `f(Vg) = f(V)` (right invariance) but then applies
   the estimate on the left translates `gB`, whose elements are `gV` — that step needs
   `f(gV) = f(V)`, which holds by the equally short argument `⟨ψ|g = e^{iθ}⟨ψ|`. Both invariances
   are one-liners and the corollary is correct; the sentence should either prove the left form or
   use right translates `Bg` consistently (the factorization `U = g·⊗e^{ih_j}` wants the left
   form, so fix the invariance sentence, not the translates).

Minor polish, optional: the abstract's "shrinks like" (see §3 item 1); the one-clause Fisher
upgrade (§2); and Section 3's title, "Full-Weyl marginals and LU rigidity", which no longer quite
covers an entanglement-only subsection — tolerable, since the subsection's own heading does the
work.

---

## Verification boundary

Checked by my own computation during this pass: the RM(1,4) remark's conjugation identity and
weight arithmetic; the full weight-enumerator derivation in `prop:stability-region` including the
ratio function and `θ*`; both directions of (3.14) from the displayed remainder bound; the
dimension count and translate logic in the decomposition proof (which is how the left/right slip
surfaced); the equation-tag ordering (by grep across the section files); and the presence/absence
greps behind §3. Taken from C774/C775 on their authority, not re-derived: the RM failure-scan
table, the exhaustive `n ≤ 7` coset census, the citation-graph findings, and every read-depth
record. The rulings in §4 and the compression call in §5 are my judgment.

---

**Section 2 revisited, 2026-08-02.** The ruling that the Fisher remark stays with the stability
theorem still holds, but its stated explanandum shifts again: C786 showed the region shrinkage is a
uniformity-order effect rather than a party-count effect, so the remark's forward pointer and the
recommended clarifying clause should be rewritten against the corrected region statement rather than
the one reviewed here. The section 3 item asking to soften the abstract's neighbourhood phrasing is
superseded — that sentence is being restated wholesale. Carried by C795. See
`2026-08-01-c786-explicit-stability-threshold.md`.
