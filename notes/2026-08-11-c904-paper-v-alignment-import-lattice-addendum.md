# Paper V alignment import: causal rereview addendum

**Date:** 2026-08-11  
**Verdict:** **MINOR**

## Frozen surface

- commit: `72904865`
- PDF: `papers/clebsch-round-trip/golden_companion_reconstruction.pdf`
- verified SHA-256: `f96e05078ffb49f8ca72e6089098c7d4f5f8bfa18aa039157346ed47ed48f7a4`
- rendered length: 22 pages

## Original repair

The sole MINOR from the first review is fully discharged.

1. Lemma 3.4 now states the complete Seidel convention: $S_{xx}=0$ and $S_{xy}=S_{yx}\in\{\pm1\}$ for $x\ne y$.
2. Its proof now states that diagonal switching fixes every triangle sign.
3. It states correctly that global complement $S\mapsto-S$ negates both $\sigma$ and $m$, while preserving the aligned family and the square identity.

These additions are mathematically exact and introduce no change to the checked $4/16$ factors or to the equivalence $A(\Delta)=\varnothing\iff S^2=5I$.

## New localized issue

The paragraph immediately after the lemma now says:

> The lemma identifies its sharp six-point failure locus: it is precisely the unmarked conference locus.

This is too strong. The conference locus is precisely the **empty-alignment** locus on six points, but it is not the whole failure locus for six-point aligned-design faithfulness. Paper III's own sharpness remark exhibits two noncomplementary six-point two-graphs with the same **nonempty** aligned family

$$
\bigl\{\{0,1,2,5\},\{0,1,3,4\}\bigr\}.
$$

Thus there are six-point failures outside the conference locus. This does not affect Lemma 3.4 or its relation to the intrinsic $A_5$ pair; it is a one-sentence contextual overclaim.

A sufficient replacement is:

> The lemma identifies the empty-alignment part of the sharp six-point failure: it is precisely the unmarked conference locus.

or, slightly shorter:

> The lemma identifies one sharp six-point failure locus, the empty-alignment locus, with the unmarked conference locus.

With that replacement, this review is **GO**.

## Rendered check

The new Seidel convention renders correctly at the start of Lemma 3.4 on page 9, and the invariance sentence renders with the continuation on page 10. No formula, sign, or notation defect was introduced by the repair.
