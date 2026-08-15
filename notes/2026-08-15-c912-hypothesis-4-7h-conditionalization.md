# C912 — Hypothesis 4.7H conditionalization of the cubic stabilization paper

**Date:** 2026-08-15 · **Lane:** `clebsch` · **Task:** C912 (active; author-close only)

## What was done

Applied the author's edit specification (`/tmp/opus_edit_spec_one_stabilization.md`)
to `papers/cubic-stabilization-epilogue/`.  The unresolved positive-filtration
bulk-displacement step is now a manually named hypothesis rather than an
asserted proof step, and every statement that depends on it says so.

Authority commit `76b016341`.  Warning-free deterministic build at **32 pages**,
PDF SHA-256 `eb5983e46d1de135c9bab92cb5f0a052e851cadf9163ae4a9516c8979a2ecc95`;
`make check` (lint, formal-static, manuscript, warnings) exits zero.

## The hypothesis

**Hypothesis 4.7H (Reconstruction-displacement invariance)**, inserted after
Lemma 4.6 and before Proposition 4.7 as an unnumbered environment, so no
existing statement number moved.  It asserts invariance of the algebraic
multiplicities of `e^{±πi/3}` under exactly two families of positive-filtration
bulk displacements: the reconstruction tails left after the unit and
fixed-divisor terms are separated in the blowup and projective-bundle
decompositions, and the divisor-tagging family of Lemma 4.9.  It explicitly
asserts nothing for an arbitrary bulk displacement.

## New unconditional lemma

**Lemma 4.1A (Frame transport over a coefficient field)**, also unnumbered,
placed after Definition 4.1 and before Definition 4.2.  For a gauge
`G ∈ GL_n(K((z)))` over an algebraically closed characteristic-zero `K`, the
framed operators of gauge-equivalent modules are conjugate, because `σ(G)=G`
for the original-disc turn `σ`.  This closes the frame-transport step referee A
was owed *for the comparison isomorphisms*: Iritani's `Ψ` and Iritani--Koto's
`Φ` and their inverses are `z`-polynomial, so the lemma applies to them
directly.  It is not applied to the pro-Laurent bulk gauge of Lemma 4.5, and
the lemma says so.

## Status partition after the edit

Unconditional: Sections 2--3 entire; Definition 4.1 and `ν_6`; Lemma 4.1A;
Lemma 4.6; Proposition 4.12 (`ν_6(X)=2`, with an explicit sentence saying it
does not use the hypothesis); every universal `CH_0`-triviality assertion,
including all four in the introduction and Theorem 1.5's first conclusion.

Conditional on Hypothesis 4.7H: Proposition 4.7 with (4.2) and (4.3);
Lemma 4.9; Proposition 4.10; Theorem 4.11; Theorem 1.1; the irrationality
clauses of Corollaries 1.2--1.4 and Theorem 1.5; Corollary 4.13; and every
Section 5 sentence asserting irrationality after one stabilization.

## Downgraded claims

- Lemma 4.3's statement and proof no longer claim that an integral-`z`
  pro-Laurent gauge preserves the original-`z`-disc frame.  Both now say the
  result is an algebraic conjugacy statement in the inverse-limit coefficient
  algebra and nothing more.
- Lemma 4.5 now produces a *comparison-transported matrix*, not a framed
  operator, and its proof ends by naming Hypothesis 4.7H as exactly what would
  identify that matrix with an intrinsic framed operator at the shifted bulk
  point.
- Equation (4.6b), the full polynomial equality `p^tag = p^spec`, is deleted.
  Lemma 4.9 now derives equality of primitive-sixth multiplicities only, from
  the hypothesis plus the surviving injectivity equality (4.6a)
  `p^tag = p^int`.
- Proposition 4.10's proof says "if the canonical bundle of `T` is nef" in
  prose, removing the collision with the coefficient field `K_T`.

## Not done, by instruction

No exploratory material from the frame-transport memo was imported: no
mixed-order receiver inequality, no Sylvester/block-evolution calculation, no
Kato transport operators, no HYZZ repair narrative, no `±1/18` regression
variant.  The title is unchanged.  No stable-irrationality claim was added.  No
quantum-Künneth shortcut for `X × P^1` was invented.

## Residuals for the author

1. `README.md`, `.zenodo.json`, `claim-proof-novelty-ledger.md`, the C910 Lean
   companion prose, and the portfolio summary still describe the one-step
   irrationality theorem as unconditional.  The edit specification scoped
   itself to the manuscript, so these were left alone and need the same
   conditional/unconditional partition before any export or release.
2. The detector table in Section 5 lists `ν_6(P^3)=0`, which now depends on the
   conditional projective-bundle formula (4.2).  The specification did not
   cover that row.
3. The standalone paper repository under `~/src/math-papers/` is now two
   repairs behind, and re-export is gated on items 1--2.
