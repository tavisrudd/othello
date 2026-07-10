# C34 report: D1 outcome-classes manuscript skeleton

Date: 2026-07-09.

## Result

C34 is complete as an assembly task.  The self-describing draft is
[`2026-07-09-d1-outcome-classes-manuscript.md`](2026-07-09-d1-outcome-classes-manuscript.md).
It is a manuscript scaffold, not a finished paper: it contains exact theorem declarations,
section intents, proof-mechanism stubs, a trust-tiered evidence table, bibliography placeholders,
and explicit expansion decisions.

No game solve, Lean build, new proof, or literature search was run.  This kept the task disjoint
from the active C30 generated-certificate/Lean work.  The only source-code reads were the existing
Lean declarations named below.

## What was quoted exactly

The draft quotes the following theorem signatures exactly from their source files (proof bodies
omitted):

- `CapGame.Affine.initialP_fin` and the representation-independent
  `CapGame.Affine.initialP_of_nontrivial` from `lean/CapGame/Affine.lean`;
- `Projective.initialPStatement_binary_of_finrank_ge_two` and
  `Projective.initialPStatement_binary_of_projectiveDim_ge_one` from
  `lean/ProjectiveCap/Binary.lean`;
- `Projective.initialPStatement_of_odd_card_finrank_eq_two_mul` from
  `lean/ProjectiveCap/EllipticMirror.lean`;
- `ProjectiveCap.initialPStatement_of_even_card_finrank` from
  `lean/ProjectiveCap/PlaneOutcome.lean`;
- `GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank` from
  `lean/ProjectiveCap/TrapConverse.lean`.

The exact displayed declarations retain their hypotheses and result types.  Surrounding namespace
and inherited typeclass assumptions are stated immediately before each quote rather than silently
folded into an informal paraphrase.

## What was stubbed

- Abstract and introduction prose is tagged **[EDITORIAL]** except for theorem claims.
- Each of the four theorem sections has a one-paragraph, source-backed proof-mechanism stub; no
  proof was added.
- The preliminaries identify the definitions and files that an expansion pass must quote.
- The conic-localization subsection is a D3 forward reference.  It explicitly says that the
  two-intruder path/cycle description is not a recursive invariant.
- Related-work prose is tiered as **[PRIOR ART]**, **[EDITORIAL]**, or **[VERIFY]**.

## Evidence table audit

The PG(2,q) table was transcribed from the current projective-cap handoff and extended only with
the handoff's separately stated q=25 partial sizing datum:

- **[LEAN]:** even q, q=5, q=7, q=11, q=13.
- **[COMPUTED]:** q=3, q=9, q=17, q=19, q=23.
- **[COMPUTED, PARTIAL] with value unknown:** q=25; one S4 representative is P, but there is no
  bucket census or plane verdict.
- **[CONDITIONAL]:** all odd q.

Two easy status upgrades were explicitly blocked in the draft:

1. q=23 remains **[COMPUTED]**.  C53's full-PGL orbit bridge is Lean-verified, but the 22 bucket
   labels it transports are solver output pending C54.
2. q=17/q=19 remain **[COMPUTED]** despite independent `certcheck` PASS.  Their generated Lean
   assemblies have not landed; q=17 exposed the current aggregate-checker `maxRecDepth` failure.

The manuscript also states the larger open hole: `PG(2m,q)`, `m >= 2`, for odd q has no direct
outcome evidence.  C32 is correctly described as a failed policy probe, not a solve.

## Bibliography audit

The bibliography uses metadata already present in the checked project notes for Segre, HHS,
Schaefer, Ellenberg--Gijswijt, and Beck.  It marks unconfirmed fields **[VERIFY]**, including:

- Croot--Lev--Pach title/venue/pages;
- the exact Guy/Dawson source;
- Harary and Anderson--Harary title/pages;
- the complete Clark--Mancini--Van Hook record and, crucially, its full-text game convention;
- final metadata for the legal-complex/strong-placement-game references.

No citation details were invented to fill those gaps.

## Readiness audit

| Section | Status | What remains |
|---|---|---|
| Abstract | ready-to-expand | choose final emphasis between outcome classification and verification |
| Introduction / umbrella | ready-to-expand | tighten to venue length; retain conservative novelty wording |
| Preliminaries | needs-a-proof-written | insert exact definitions and the finite-game P/N recurrence |
| Affine theorem | ready-to-expand | turn the checked mechanism stub into a reader-facing proof outline |
| Binary projective theorem | ready-to-expand | explain the nonzero-vector/sum-free transport without Lean implementation noise |
| Odd-dimensional odd-q theorem | ready-to-expand | state the elliptic involution construction and pair-extension check at paper granularity |
| Even-q plane theorem | ready-to-expand | expose the frame/residual-grid bridge before the translation mirror |
| Odd-plane conjecture and table | ready-to-expand | decide how much raw per-q certificate detail belongs in D1 |
| Conic-localization bridge | needs-a-proof-written | D3 must supply the complete theorem/proof; D1 currently has only a forward-reference stub |
| Higher even-dimensional hole | ready-to-expand | keep the evidence-vacuum statement visible; update after C43 only if a solve lands |
| Related work / novelty | needs-a-proof-written | retrieve Clark--Mancini--Van Hook; verify legal-complex references and final comparisons |
| Normal-play/misere caveat | ready-to-expand | add one standard misere reference if retained |
| Bibliography | needs-a-proof-written | resolve every **[VERIFY]** entry and add page/theorem pins |
| Verification architecture | needs-a-decision-from-user | include D4 inside D1 or ship it as a companion paper |
| C48/C51/C52 harvested families | needs-a-decision-from-user | fold into D1, place in outlook, or reserve for a separate varieties paper |

## Gaps before submission

1. Expand the four theorem proof outlines from the formal sources and check that the paper-level
   notation matches the Lean models.
2. Complete D3 or sharply limit D1's conic-localization claims to the already proved components.
3. Decide D4's placement.  The outcome table belongs in D1; the generated-certificate format and
   checker proof may be too large for the same paper.
4. Retrieve Clark--Mancini--Van Hook and finish the novelty comparison before any public “first”
   language.
5. Verify all bibliography metadata marked **[VERIFY]**.
6. Decide whether the post-C34 mirror-harvest families expand D1's scope or become a companion.
7. Preserve the Lean/computed/conditional trust tiers during prose expansion and after C30/C54
   status changes.

## Files changed

- Created `notes/2026-07-09-d1-outcome-classes-manuscript.md`.
- Created `notes/2026-07-09-codex-d1-manuscript-skeleton.md`.
- Marked C34 reported in the Codex task queue.
