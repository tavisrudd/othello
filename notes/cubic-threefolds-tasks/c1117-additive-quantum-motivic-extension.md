# C1117: Additive quantum motivic extension and factorization constraints

**Lane:** `cubic-threefolds`
**Status:** complete; authority and standalone gates pass

## Result

The additive scalar and exact-discriminant extensions, Hodge comparison,
factorization identities, and limitations are integrated in Section 4.
Report: `notes/2026-09-07-c1117-additive-spectrum-extension.md`.
Authority `08ee6cea8`, standalone `bcce442`; identical 17-page PDFs.
The five new statements have absent Lean coverage, explicitly recorded.

## Goal

Prove or delimit the additive extension of the scalar exponent marker through
`K0(Var_C)/(L-1)`, then test exact spectral refinement and useful applications.
Entry report: `notes/2026-09-07-cubic-astra-review-triage.md`.
Own `papers/cubic-stabilization-m1/`, this card, dated C1117 evidence/reports,
and lane routing docs. Keep C978's exposition work coordinated through labels.

## Work and acceptance

1. Derive intrinsic center values in every dimension from C1116's accepted
   comparisons. Include empty varieties and disjoint unions, then apply
   Bittner Theorem 3.1 to the integer-valued assignment. Prove annihilation of
   `(L-1)a` for arbitrary a by smooth projective generators. State additive,
   not multiplicative, and `Ical(1)=Ical(L)=0`.
2. Replace the applications paragraph's invalid multiplicativity rationale.
   If the geometric comparison remains open, state a conditional extension
   and the exact missing premise instead of asserting an unconditional measure.
3. Separately prove a fixed spectrum target and preservation of the canonical
   modified residue's exact squared gap. Exponent classes modulo integers
   alone do not prove exact-gap invariance. Retain the scalar theorem even if
   this stronger refinement fails.
4. Prove the same-Hodge-diamond example with a smooth bidegree-(2,6) curve on
   a quadric in P3 and the point blowup of a cubic. Prove the net-three-center identity for a
   factorization from X x P2 to P5 and the `(c-1)`-weighted general identity.
   Add the cubic-type spectrum identity only after item 3 passes.
5. Record the deformation-invariance limitation and the higher-rank pairing
   counterexample with correct hypotheses. No higher-rank engine or explicit
   weak-factorization construction is included in this task.

Acceptance requires complete proofs, source/novelty checks proportionate to
any manuscript claim, accurate annotation changes, necessary finite evidence
bundles, scoped paper gates, and a focused proof review. Integrate after the
original obstruction proof so the first reading stays concrete. No priority
claim follows from Astra's assessment.
