# C913 referee disposition — cubic stabilization

**Lane:** `clebsch`
**Paper:** `papers/cubic-stabilization-irrationality/`
**Input frozen:** Fable referee report supplied in the 2026-08-14 chat.
**Status:** planned dispositions only; no manuscript claim is changed by this
record.

## Reading of the report

The report finds the explicitly conditional architecture honest and finds no
endpoint calculation error.  Its recommendation is major revision because the
two input layers are elaborate and the most substantial proved geometric
arguments are too compressed for a cold specialist reader.  The report's
statement that no geometric instance has been verified is superseded in one
limited respect by the later C907 toric calibration: Coates--Iritani--Jiang
gives a genuine ordinary, non-zero-mode neutral mechanism at intrinsic
toric-QDM/I-function level.  That calibration does not verify the
projective-master inverse-system family or its zero-mode clause, so it does
not alter the report's main concern.

## Major-comment disposition matrix

| Referee point | Disposition | C913 work and acceptance evidence |
|---|---|---|
| 1. Hypothesis 8.9 is bespoke, extensive, and not geometrically verified. Make it modular; state a clean displayed implication target; discuss a nontrivial threshold or its obstruction. | **Accept, presentation repair.** Do not claim the input is discharged. | Package C separates ordinary sign/stability and zero-mode clauses, displays their one-object form, and states a **new manuscript conjecture** (not a cited theorem) giving a marked Gamma/window route to the hypothesis. Explain the CIJ calibration and the projective-master/reduction-in-stages and zero-mode boundaries. |
| 2. Definition 8.1 is a second unverified layer. Say the cubic application only needs maps `X x P^m dashrightarrow P^(m+3)` and classify expected versus open clauses. | **Accept, scope repair.** | Package C states the endpoint-only application form and distinguishes standing gauged-theory conditions from the completion properties not supplied by Wlodarczyk. No general admissibility theorem is asserted. |
| 3. The orbit-cylinder point lift needs disjointness from every intermediate fixed component after resolution, not only a generic-limit slogan. | **Accept, mathematical proof-expansion risk.** | Package D must prove a dedicated disjointness lemma after the chosen completion, or stop for author approval before moving the marked-lift assertion into an assumption. |
| 4. The derived fixed-section/POT comparison in Theorem 8.6 is load-bearing and too compressed, especially equivariance, rigidification, and Woodward compatibility. | **Accept, mathematical proof-expansion risk.** | Package D expands the derived functor, stable open, universal object, POT-to-cotangent 2-commutative square, inertia/rigidification, and cutting comparison. Failure to sustain the theorem stops for author approval; it is not silently demoted. |
| 5. Theorem 3.1 depends brittlely on internal Gu--Yu--Yu preprint numbering. Quote the exact imported statements and retain version/source locators. | **Accept, source-robustness repair.** | Package B replaces scattered internal-number dependency with one manuscript proposition listing the precise inputs, hypotheses, and source anchors, then audits it against the cached primary source. |
| 6. Make the formal-primary endpoint/frame match and common half-Tate relabeling explicit. | **Accept, local exposition repair.** | Package A states that endpoint detection uses the formal primary projection via the cited internal lemma, with no sectorial choice; the shared half-Tate shift changes both labels equally. |

## Independently checked computations recorded by the referee

These are verification observations, not new manuscript claims.  Package A
must retain their hypotheses and add only the stated missing explanation.

| Item checked | Referee verdict | Required action |
|---|---|---|
| Indicial polynomial: `(rho+19/18)(rho-1/18)+16/81 = rho^2+rho+5/36`, roots `-1/6,-5/6`. | Correct. | None beyond frame clarification. |
| `(3d)!/(d!)^5` is the displayed `2F3` coefficient sequence. | Correct. | None. |
| Barnes coefficients from DLMF 16.11.2 are nonzero and match the two displayed constants. | Correct. | None. |
| The two `z` exponents match the indicial roots. | Correct. | None. |
| Cai-matrix cyclic-span computation gives the reported eigenvalues. | Correct. | None. |
| Incomplete-Gamma frame solves the displayed equation. | Correct. | None. |
| Theorem 3.1 induction is sound conditional on the quoted GYY polynomiality input. | Correct conditional on source input. | Package B quotation/audit. |
| The projective-space grading computation as written yields the trace only. Each DFT diagonal is zero only after using squared modulus `1/n`. | Correct conclusion; one omitted argument. | Package A adds the entrywise DFT calculation. |

## Minor-comment disposition matrix

| Referee point | Disposition and owner |
|---|---|
| 1. Clarify formal/primary endpoint evaluation at first use. | **Accept — A.** |
| 2. Promote Warning 3.2's centre-coordinate limitation into Theorem 1.3. | **Accept — A.** |
| 3. Define “jointly flat” in the hybrid ring. | **Accept — A.** |
| 4. Make the no-product-of-simple-residues disclaimer a numbered remark. | **Accept — A.** |
| 5. Cross-reference the rational `2^k/3^{-k}` two-tail counterexample from Hypothesis 8.9. | **Accept — A/C.** |
| 6. Standardize Poincaré spelling, `2`-commutative typography, and `P_6` arguments. | **Accept — A.** |
| 7. State where the endpoint package is archived and its limits. | **Accept — A.** The named public release surface is Zenodo concept DOI `10.5281/zenodo.21937490`; the checker and certificate are regression artifacts in `verification/`, not proof substitutes. |
| 8. Check journal policy for AI disclosure. | **Defer until venue selection.** No policy claim belongs in this revision. |

## C913 execution order

1. Package A and Package B only: make the local/source edits, build, obtain a
   narrow cold check, and export the frozen revision to the standalone mirror
   and portfolio summary.
2. Package C: reorganize the two hypotheses and the named new conjectural
   implication without expanding their truth claims.
3. Package D: expand the orbit-cylinder and derived-clutching proofs. Any
   proposed demotion or statement change requires explicit author approval.
4. Freeze the final PDF and commission the two new cold reads specified in the
   C913 card.

## Uncertainties deliberately preserved

- The stable public identifier is the concept DOI above.  The exact GitHub
  Release URL is not recorded in the paper sources consulted here; do not
  invent one in the manuscript.
- This note does not decide whether the marked Gamma/window conjecture should
  receive a final title.  C913 must label any title as manuscript-local until
  a source or author decision establishes otherwise.
- The Fable report did not supply full bibliographic metadata for every
  unpublished dependency.  Package B must use the source version and stable
  locator actually verified in the literature cache.
