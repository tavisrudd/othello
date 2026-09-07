# C1116: Cubic pair foundation audit after Astra feedback

**Lane:** `cubic-threefolds`
**Status:** completed 2026-09-07; targeted audit and repairs validated

## Outcome

The faithful-center proof now uses the reduced graded source, polynomial
translations at initial Novikov degree, and untruncated divisor exponentials.
The cyclic repair was checked and its unformalized preliminary step is
explicit in the claim map. The quotient/descent interfaces and TZ v2 inputs
were checked; citations and hypothesis matches were updated. Both authority
and mirror gates pass, with byte-identical rebuilt PDFs. No push or email.
Report: `../2026-09-07-c1116-cubic-foundations-audit.md`.
Next: C1120; exact spectrum and finite-index proofs remain with C1117/C1119.

## Goal and scope

Audit the exact proof interfaces on which both current stabilization papers
and Astra's proposed extensions depend. Entry report:
`notes/2026-09-07-cubic-astra-review-triage.md`.
Owned paths: the two `papers/cubic-stabilization-*` authorities, this card,
dated C1116 reports/evidence, and lane routing docs. Lean and exports require
their routed instructions before any such operation.

## Work

1. Audit the existing cyclic-centralizer repair at `6034287a6`: separated
   rank-two cluster over the complete ring, regular cyclic centralizer,
   trace-centering, compatible flatness identities, formal recursion, and
   nonzero rank-one persistence. Do not implement the same repair again.
2. Audit `lem:faithful-center-base-change` against the exact Iritani sources:
   all rings, completions, continuous maps, divisor-equation reduction, fixed
   shifts, independent coordinates, and combined coordinate inverse. In
   particular, explain the purported passage through the image of a
   noninjective map; an injective composite cannot factor through a genuinely
   noninjective source map. Determine whether the actual reduced map avoids
   that issue. Separate dimension-four sufficiency from all-dimensional scope.
3. Check Euler/grading transport, scalar shifts, separation by unit parameters,
   and projective-bundle coefficient embeddings. Identify precisely what is
   preserved for the scalar marker and what an exact-discriminant refinement
   would additionally require.
4. Audit the descended slice, common tangent-isomorphism open, and equivariant
   generic trivialization. Compare used Tschinkel--Zhang v1 inputs with v2,
   especially its revised tangent-projection citation/hypotheses. The source
   comparison is recorded in `notes/2026-09-07-tz-v1-v2-comparison.md`.
5. Check formal annotation scope after the repaired proof, existing finite
   evidence, and release consistency for both already-landed errata. Do not
   equate a passed finite gate with a geometric proof.

## Acceptance

Bounded source-review input completed on 2026-09-07:
`notes/2026-09-07-c1116-tz-friendly-feedback.md` checks the revised projection
theorem statement, identifies the Example 5.2 model-pointer error with an
explicit coordinate bridge, and records a qualified Remark 5.4 question.
An unsent friendly-email draft is adjacent. This does not complete the
foundation audit or authorize sending correspondence.
Author instruction: hold that email until both paper updates are complete and
validated; offer thanks and observations only, with no request or expectation
of feedback on the observations or our papers.

A claim-by-claim audit names each exact source hypothesis and local provider,
and separates accepted conclusions from unresolved gates. Repair concrete
defects in authority, update provenance correctly, run the required scoped
gates, and independently review the changed interfaces. If a foundation does
not close, record that fact and block only the dependent upgrades. No source
repin, headline strengthening, or certification by assertion. C956/C978 remain
open by author instruction; no push or deposit.
