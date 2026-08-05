# C815 work report: four-shadow recognition off the root gauge

**Lane:** `clebsch`
**Date:** 2026-08-04
**Task:** C815

Paper III is `papers/clebsch-passages/`, "Golden descent and operator
realizations of the Clebsch cubic". This round closes the fifth item of gap
class C in `2026-08-03-c815-paper-iii-formalization-gap-inventory.md`: root
normalization by switching, and uniqueness of the conference switching class.
Both were recorded there as claims the manuscript makes and Lean did not.

## What the Lean now says

Before this round every scalar-sign statement in
`lean/RelativeConicArcs/FourShadowRecognition.lean` fixed the root gauge: the
matrix was `normalizedSignMatrix bits`, whose edges at the label `0` are all
positive. The manuscript states the recognition theorem for an arbitrary
symmetric zero-diagonal matrix with entries `±1`, so the formal statement was
narrower than the paper on that axis.

The gap is closed by switching rather than by a wider case analysis. The two
transport facts are:

- `matchingEvaluation_switchMatrix` — diagonal switching by signs `d i`
  multiplies the commutator-Pfaffian cubic by `d 0 * d 1 * d 2 * d 3 * d 4 *
  d 5`, because each of the fifteen perfect matchings of the six labels meets
  every label exactly once;
- `ClebschGoldenConference.triangleCubic_switch`, already present — the
  triangle cubic is unchanged, because each triangle product meets each of its
  three labels twice.

So nonzero proportionality of the two cubics survives switching with the
proportionality scalar multiplied by the sign product, which is the content of
`exists_nonzero_cubicsProportional_switchMatrix`. The conference square
survives too, by `switchMatrix_mul_switchMatrix` and `switchMatrix_smul_one`.
Switching a sign matrix by its own root row makes every root edge positive
(`rootSwitchSigns_root_row`), and a root-normalized sign matrix is one of the
ten-bit signings with the bits read off its upper-triangular edges
(`exists_bits_eq_of_rootNormalized`). Composing these gives

- `exists_nonzero_cubicsProportional_iff_conferenceSquare_of_isSignMatrix`, and
- `exists_nonzero_cubicsProportional_smul_iff_conferenceSquare_of_isSignMatrix`
  for an arbitrary nonzero common edge scale,

at the manuscript's quantifier range, with the normalized theorems reused
unchanged rather than restated.

Uniqueness of the conference switching class is
`exists_switchMatrix_submatrix_eq_conferenceMatrix`: every sign matrix with
square `5 • 1` is carried onto the displayed `conferenceMatrix` by one
relabelling of the six axes followed by one diagonal switching. Its finite
step is
`exists_relabel_switchMatrix_eq_conferenceMatrix_of_firstRowBalanced`, which
supplies, for each of the twelve labelled pentagons of
`pentagon_bit_classification`, an explicit relabelling fixing the root and the
first non-root label. The same switching signs `(1,1,1,1,-1,-1)` work for all
twelve, so the twelve pentagons appear as one orbit under relabelling — the
finite content of the human proof's remark that the pentagon class is single
under the symmetric group on the five non-root labels. Each of the twelve
identities is closed by kernel-checked case analysis over the thirty-six index
pairs; no compiled evaluation and no external certificate enter any of them.

## The proportionality scalar is determined

A closeout pass added the strengthening that the transport makes cheap. The
existing statements said only that *some* nonzero scalar exists. The scalar is
in fact unique and equal to `4` or `-4`.

Uniqueness needs a point where the triangle cubic does not vanish, and there is
a structural one: at the indicator vector of a triple, every monomial except
that triple's has a vanishing coordinate, so the cubic equals that triple's
sign — `±1` on a sign matrix, never zero. No search and no case analysis is
involved; `triangleCubic_lastTripleBump` is one `simp`. Hence
`cubicsProportional_unique_of_isSignMatrix`.

The value then follows from the transport:
`cubicsProportional_switchMatrix_iff` states switching at the level of the
scalar rather than of its existence, so the normalized dichotomy `±4` carries
to the general matrix multiplied by the product of the switching signs, itself
`±1`. That is
`cubicsProportional_eq_four_or_neg_four_of_isSignMatrix`. The companion
`cubicsProportional_neg_switchMatrix` records the consequence in the form the
human proof states: switching by signs of product `-1` negates the scalar, so
the sign is a marker of the switched representative and not of the switching
class.

`isSignMatrix_normalizedSignMatrix` closes the loop by exhibiting the
normalized signings as sign matrices, so the general statements are genuine
generalizations of the ones they were built from.

Two supporting facts are stated in the ring generality the module already
uses: the matching evaluation transport and the sign-product square hold over
any commutative ring, and the proportionality transport over any integral
domain. The reduction, normalization and uniqueness statements are integral,
as the manuscript's sign locus is.

## Evidence

The gate `RelativeConicArcs.Gates.FourShadowRecognition` now audits
forty-two terminals, all of the new declarations included. Every one depends
only on `propext`, `Classical.choice` and `Quot.sound`; `native_decide` occurs
nowhere in the pinned closure and the replay refuses it.

The module elaborates with no error and no warning through
`lean/scripts/guarded-lean`, the gate builds through the guarded queue, and
the axiom report and closure inventory are regenerated by their tracked
generators from the tracked gate stdout, whose bytes are pinned under
`axiom_report_provenance`. Replays, from `papers/clebsch-passages`:

```text
python3 verification/verify_four_shadow_lean.py --lean-root <lean tree> --source-only
python3 verification/verify_four_shadow_lean.py --lean-root <lean tree> \
  --axiom-log verification/evidence/gate_stdout/four_shadow.stdout.txt
nix develop --command python3 verification/verify_release.py --lean-root <lean tree>
```

All three pass, and the release run replays all three Paper III gates.

## What this does not close

The remaining items of gap class C are the aligned-design strengths — the
explicit query family with its distinctness and cardinality, the finite-set
extension to a common seven-set, the transport from arbitrary labels to the
normalized cut coordinates, and the anchor step's distinctness obligation —
and the rank-fourteen weighted Jacobian, which is still an external rational
certificate. Gap class B, the nine manuscript clauses with no formal
counterpart, is untouched.

Two facts about the twelve pentagons remain read off the displayed list rather
than proved: that they number twelve, and that they are pairwise distinct. The
trust boundary says so. Neither is used by any statement above; the uniqueness
theorem quantifies over sign matrices, not over the list.

## Observations

The uniform switching is explained, not mysterious. The same signs
`(1,1,1,1,-1,-1)` work for all twelve pentagons because a normalized pentagon
has an all-positive root row, so the signs are forced entry by entry to be the
root row of the target conference matrix, independently of the pattern. Nothing
about the pentagon enters. The genuine content is carried by the relabellings,
which differ per pattern.

The library already carried a root-gauge switching layer: `ClebschTwoGraph`
defines `rootSwitchSign` and proves its signs square to one, for an arbitrary
commutative ring and under the weaker hypothesis that off-diagonal entries
square to one. The first version of this work defined its own copy. That
duplicate is removed: `FourShadowRecognition` now imports `ClebschTwoGraph`
and uses the existing signs, with
`offDiagonal_mul_self_of_isSignMatrix` supplying their hypothesis from the
sign-matrix property. The four-shadow closure grows by exactly that one module,
which imports only `ClebschGoldenConference` and is already pinned by the
passages gate.

What remains genuinely new here is the transport layer — the matching-evaluation
switching factor, the scalar-level proportionality transport, the square
transport, closure of sign matrices under switching, and the identification of
a root-normalized sign matrix with a ten-bit signing. Of the library's other
switching consumers, the Paper I orientation modules
(`PaperIOrientationHolonomy`, `PaperIOrientationPentagon`,
`MarkedClebschBridge`) use the same multiplicative encoding and already share
`switchMatrix` and `rootSwitchSign`, so they are the candidates for a shared
home. The aligned-design side uses a different encoding — `AlignedTwoGraph`
states switching with Boolean parameters and `Bool.xor` over an arbitrary
vertex type, with a global negation — so the aligned-certificate work inherits
the argument pattern but not these declarations.

Order six remains hard-coded, as it is throughout the module: the matching
evaluation is a fifteen-term sum over the perfect matchings of six labels, so
the switching factor is the product of six signs by construction. The
manuscript states switching invariance for conference matrices of arbitrary
even order. Generalizing the index type is untouched and remains the one axis
on which the formalization is narrower than the paper.
