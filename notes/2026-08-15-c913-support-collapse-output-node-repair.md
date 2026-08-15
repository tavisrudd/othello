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

## Still open from the same cold read

- **Schürg–Toën–Vezzosi import** (its item 4): the cited paper's mapping-stack application is the
  reduced obstruction theory for stable maps to a K3 surface, not a general recognition theorem.
  Woodward's Definition 7.13 fixes the complex and not the morphism, so this is where the
  "as morphisms to a cotangent complex" upgrade actually rests. Repair: state as a convention that
  Woodward's obstruction morphism is the Illusie/Kodaira–Spencer map of the universal gauged map and
  finish the identification internally in `prop:app-square`, which already has the ingredients.
- **Locators** (its item 5): QK III Section 9.4, p. 35 for the relative perfect obstruction theory on
  the fixed locus; the uncited Graber–Pandharipande fixed-part step; the mis-citation of QK II
  Example 6.6(c) for invariance of virtual classes; a theorem number and equivariant relative form
  for the Toën–Vezzosi mapping-stack formula.
- **`prop:clutching-tail-holonomicity` wording** (its item 6): say D-finite, not holonomic, over an
  Artin coefficient ring, and give the paragraph turning polynomially bounded coefficients into a
  finite-order distributional radial boundary value.
- Optional items: demote the "comparison homotopy may be taken to be the identity" claim; give the
  reason for constancy of graph automorphism groups along a tail; cite `Dτ_{Y,-}` as the graph
  fundamental solution; note the rotation-parameter inversion at the chart at infinity.
- Standalone paper repository and portfolio summary are **not** synchronized for this change set;
  that waits until the remaining cold-read items land, so the mirror takes one forward commit.
