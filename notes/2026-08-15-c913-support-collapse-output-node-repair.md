# C913 — derived/gauged cold-read repairs: output-node support collapse, total affine slope, chart independence

**Date:** 2026-08-15
**Lane:** `clebsch`
**Manuscript:** `papers/cubic-stabilization-irrationality/`
**Source of findings:** `2026-08-14-c913-cold-read-derived-gauged.md` (derived/gauged-GW cold read),
confirmed independently by Tavis's reviewer note of the same date.

`make check` passes: 44 pages, warning-free, tracked PDF current, release-surface and
endpoint-regression gates green.

---

## 1. Support collapse: the marked-point gap and the chosen repair

### The gap

`prop:support-collapse` claimed that at a nonendpoint polarization "every marking and node lands
in the corresponding fixed locus", citing González–Woodward Proposition 3.15(c), Lemma 3.17 and
Proposition 3.18. Those statements prove two different things:

- Lemma 3.17 and Proposition 3.18: the **principal component** maps to `X^{ζ,t}/G_ζ`, the locus of
  `L_t`-**semistable** points of the `ζ`-fixed locus.
- Proposition 3.15(c): an **arbitrary node or marking** maps only to the full fixed point set
  `X^ζ`, with no semistability.

`lem:orbit-cylinder-disjoint`(b) proves `a_p|_F = 0` only for `F` semistable at some interpolated
`L_u`. Its own clause (c) shows the two orbit limits `w_0, w_∞` keep strictly nonzero weights along
the whole interpolation, so the fixed components containing them are exactly the ones the vanishing
does not cover — and `a_p = PD[Ō]` meets them. A distinguished marking carried off on a bubble tree
could therefore land where the class does not vanish.

### Source check now closed

The extraction note flagged González–Woodward Remark 3.19 as truncated and named it the highest-value
remaining check. Read in full from the cached source (`arXiv:1208.1727`, sha256 `2c99203c…`,
`/tmp/persistent/tavis/lit-search/text/arXiv_1208.1727.txt` line 3435):

> There is an isomorphism `M^{G_ζ}_n(C, X, L_t, ζ) → ⋃_{r,[I_1,…,I_r]} ( M^{G_ζ,fr}_r(C, X^{ζ,t})
> ×_{(X^ζ)^r} ∏_{j=1}^r M_{|I_j|+1}(X) / (G_ζ)^r )^{C^×_ζ}`, where `I_1 ∪ … ∪ I_r ⊂ {1,…,n}` is a
> disjoint union of subsets describing markings lying on bubble components.

So the remark **sharpens the distinction rather than closing it**: the principal factor is a
gauged-map stack over the semistable `X^{ζ,t}` framed at its attaching points, the bubble factors are
glued along those framings, and markings on bubbles are indexed by the `I_j` and evaluate only into
`X^ζ`. The source supplies semistability for the principal component and for attaching nodes — not
for an arbitrary marking.

### Why no choice of class repairs it

Recorded as the new `rem:iv-semistable-restriction`. For smooth projective `W` with a `G_m`-action,
Białynicki-Birula makes `H^*_{G_m}(W;Q)` free over `H^*(BG_m;Q)`, so restriction to `W^{G_m}` is
injective. A class vanishing on **every** fixed component is zero and cannot have the two endpoint
point classes as Kirwan restrictions. Definition 8.1(iv) on its widest reading is therefore
unsatisfiable, and the wall vanishing can never come from a stronger property of `a_p`. It has to
come from restricting which fixed components the distinguished evaluation can reach.

### The repair as landed

1. `def:gauged-admissible`(iv) now says "every fixed component that is semistable for some
   polarization interpolating the two chamber linearizations", matching what
   `lem:orbit-cylinder-disjoint`(b) delivers. Same narrowing in
   `eq:marked-class-restrictions`, the ledger row for `lem:orbit-cylinder-disjoint`, and the
   introduction.
2. The distinguished class is inserted at the **output evaluation of the graph factor**, not at an
   ordinary input marking. That is the evaluation of the principal component at a fixed parametrized
   point of the domain — the slot through which Woodward's localized graph potential is defined by
   pushforward, and the slot `eq:endpoint-gauged-maps` is evaluated in. When a bubble tree sits over
   that point, the evaluation is the attaching node computed from the principal side, so Lemma 3.17
   plus Remark 3.19 put it in `W^{ζ,t}`, and the wall term vanishes.
3. The proof now states explicitly why the weaker marking statement is not enough, and points at
   `rem:iv-semistable-restriction` for why no class repairs it. `08-scope.tex` item (5) was rewritten
   to describe the mechanism actually run — it previously described the safer node version, which the
   proof did not match.

### Endpoint check (required before accepting the repair)

At an endpoint there is no wall, and the distinguished output evaluation is the slot through which
`τ_{Y_±,-}` is defined. `lem:point-insertion-row` was already formulated for that slot: the point
class is paired against the flat section, and unitarity of the fundamental solution turns that
pairing into the Poincaré point covector. Its statement now says so. The `κ`-side factor is
unaffected because it comes from the affine-gauged **input**, a different slot. Further input and
bulk derivatives add and differentiate ordinary input markings only, so they commute with the output
insertion and both the wall vanishing and the endpoint identification survive them. The endpoint
contribution is therefore still exactly `c_n(z)^{-1} 𝔯_{Y,p} Dτ_{Y,-} Dκ`, and no theorem statement
changes.

## 2. `eq:signed-moving-slope` was false as displayed

The symbol `ε_a` was never defined, and under the natural reading (`±1` for `H^0` versus `H^1`) the
display computes `∑|h_a|`. Replaced by `eq:total-moving-slope`,

    ∑_a h_a = c_1^{G_m}(TW)·δ,

with no ray sign, the `h_a` themselves of either sign. The reason is now given: a virtual line of
degree `n_a` contributes `χ(O(n_a)) = n_a + 1` to the virtual rank on both rays, since for `n_a < 0`
the negative `H^1` contribution to the index is already what makes `χ = n_a + 1`. Also stated: the
gauge Lie algebra and the fixed part of the index have affine slope zero (the latter by
`thm:tailwise-derived`), so the whole affine slope sits in the moving index. "Signed slope" is gone
from the manuscript.

This is load-bearing in `prop:clutching-tail-holonomicity`, whose Stirling step needs the unsigned
sum. That proof now carries the two-ray estimate explicitly: both rays contribute
`-n_a log|n_a| + n_a + O(log|n_a|)` to `log|c_k|`, giving

    log|c_k| = -(∑ h_a) k log k - k ∑ h_a log|h_a| + (∑ h_a) k + O(log k),

so neutrality kills the `k log k` and linear terms and one rescaling removes the exponential rate
`-∑ h_a log|h_a|`. Red-team fixes applied to this passage: the sums run over roots with `h_a ≠ 0`
(a root with `h_a = 0` has constant degree and contributes a bounded factor, and `log|h_a|` would
otherwise be undefined), and sizes are componentwise in a fixed `C`-basis of `R_N`, so the nilpotent
Chern roots contribute bounded factors.

## 3. Chart independence in `prop:app-one-chart` was proved by a false statement

The old argument said separatedness makes two invariant affine charts impose the same condition on
their overlap. Separatedness gives uniqueness of an extension once it exists in a given chart; it
does not give existence. Counterexample now in the text: `W = P^1`, `t·y = ty`, `a = +1`; the chart
`Spec C[y]` imposes no condition and `Spec C[y^{-1}]` imposes `y^{-1} = 0`, and on the overlap they
disagree at every point.

Replaced by the invariance argument. If `y = lim_{t→0} t^a x ∈ F` and `U` is a `G_m`-invariant affine
open containing `y` (Sumihiro), then `t^a x ∈ U` for small `t ≠ 0` by continuity of the completed
orbit map, hence `x ∈ U` by invariance, hence the whole completed orbit lies in `U`. So `W_F^a` is
covered by the invariant affine charts **meeting `F`**; charts disjoint from `F` compute a different
stratum and are excluded, which the old argument did not do. The proposition itself was never in
doubt.

Family form, which the appendix previously did not argue: those charts are opens covering `W_F^a`,
so for an `R`-point `x` the preimages `x^{-1}(U)` cover `Spec R`; Zariski-locally `x` factors through
one `U`, and then so does the whole section, by invariance again.

Two smaller gaps in the same proposition, both one sentence, also closed: the levelwise construction
computes the derived mapping space because the **source** algebra `A` is smooth (`W` is smooth), not
because the target `R[z]` is a polynomial extension; and local triviality of a rotation-equivariant
`G_m`-bundle on `P^0_R` is now justified by the graded Picard group of `R[z]` being
`Pic(R) × Z`, with the note that the nonequivariant analogue fails for nonreduced `R`.

## 4. Second batch: imports, locators, D-finiteness (same day)

**Schürg–Toën–Vezzosi no longer carries the identification.** The cited paper constructs derived
enhancements and reads off the induced obstruction theory in its own geometry (stable maps); it is
not a general recognition theorem for an arbitrary classically constructed obstruction *morphism*,
and Woodward's Definition 7.13 names only the complex `(Rp_*e^*T(X/G))^∨`. New
`conv:app-obstruction-morphism` fixes the reading: Woodward's obstruction morphism is the
Illusie–Kodaira–Spencer map of the universal gauged map relative to the domain stack, which is the
reading his virtual classes are formed under and the one that makes the comparison a statement.
`lem:app-truncation` then makes the comparison internally: both morphisms send a first-order
deformation of the section to the induced pair of chart deformations compared on the open orbit, and
in the Čech presentation they are the same map of two-term complexes. The claim is explicitly bounded
to square-zero extensions of classical test schemes — the level at which Woodward's morphism is
specified and the virtual class is formed. Schürg–Toën–Vezzosi stays cited as precedent.

**Toën–Vezzosi is now precedent, not a load-bearing import.** Its general mapping-stack formula
assumes a proper flat source, which the rotation quotient of the domain is not. The equivariant
relative form actually used is derived from `def:app-fixed-section` (a map from a square-zero
extension is a rotation-fixed section of the pullback tangent complex), and perfectness comes from
`lem:app-cech` rather than from properness. Stated in the appendix opening, in the proof, and in
`rem:app-imports`.

**Locators.** The relative perfect obstruction theory on the rotation-fixed locus, induced from the
ambient one, is QK III Section 9.4 (pp. 35–36) — not Definition 7.13 plus Section 8.3 plus QK II
Example 6.6(c), which are three different moduli stacks (single-vertex gauged maps, scaled gauged
maps, affine gauged maps). The appendix opening now says that explicitly. The fixed-part step is
cited to Graber–Pandharipande, previously invisible. Invariance of virtual classes under an
isomorphism of obstruction theories is now Behrend–Fantechi (the intrinsic normal cone depends only
on the morphism to the cotangent complex), with QK II Section 6 for the relative bivariant form;
Example 6.6(c) was a mis-citation for that. Both new entries added to `refs.bib`.

**"Comparison homotopy may be taken to be the identity" demoted.** The Čech computation compares the
differentials of two presentations of the same two-term complex — it identifies the left vertical
arrow strictly and says nothing about the classical truncations the two composites factor through.
The text now says exactly that, and notes that 2-commutativity comes from functoriality and does not
depend on it.

**D-finite, not holonomic.** Holonomicity has no standard meaning over a coefficient ring with
nilpotents, and the proof proves a linear recurrence with polynomial coefficients. The proposition
title and every prose use now say `(D)`-finite; the label `prop:clutching-tail-holonomicity` is kept
so cross-references and the release-surface gate keep their anchors, and the gate's pinned sentence
was updated to the new wording. README and ledger follow.

**Finite-order boundary values now argued, not asserted.** With `|c_k| ≤ Ck^N(log k)^M`, pick
`q > N+2` and set `b_k = c_k/(ik)^q`; then `∑ b_k r^k e^{ikθ}` converges uniformly up to `r = 1` with
continuous radial limit, and `∂_θ^q` recovers the original series, so the radial limit exists in
`D'(S^1)` with order at most `q`. Uniform on the tail because `N, M` are. Argued componentwise in a
`C`-basis of `R_N`.

`make check` passes at 45 pages, warning-free, tracked PDF current.

## Still open from the same cold read

- Optional items not taken: the reason (rather than the conclusion) for constancy of graph
  automorphism groups along a tail; a citation for `Dτ_{Y,-}` being the graph fundamental solution;
  the rotation-parameter inversion gloss at the chart at infinity.
- Coverage the cold read did not reach: Aleshkin–Liu Definition 5.18 / Theorem 5.21 and
  González–Woodward Remarks 1.18(d), 4.6, 4.7 as characterized in `rem:neutral-boundary`; QK II
  Proposition 5.21 and QK III Proposition 7.14(b) beyond the extraction note's transcription.
- Standalone paper repository and portfolio summary sync: pending the fresh cold read on this text.
