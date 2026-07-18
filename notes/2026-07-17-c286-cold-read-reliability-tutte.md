# C286 cold read: reliability, bounded EXIT, and pointed Tutte structure

**Date:** 2026-07-17  
**Scope:** Context-light, paragraph-by-paragraph read of
`papers/complete-repair-ports/complete_repair_ports.tex`, lines 306--463.  I read only the assigned
range and the designated C188 cold-read example; I did not consult C285, proof ledgers, handoffs,
other reviews, or surrounding manuscript text.  The manuscript was not edited.

## Sequential audit

- **Lines 306--307 (tail of deletion/contraction display): PASS.** This is only the closing line of
  an environment begun before the assigned range; the displayed contraction antichain expression
  is legible, but the unavailable opening context was not assessed.
- **Lines 309--328 (Theorem, “Reliability calculus”): PASS.** Conditioning gives the stated
  deletion--contraction identity, differentiation has the correct sign, the homogeneous derivative
  is the usual pivotal sum, and distinct minimum blockers have unions of size strictly larger than
  the minimum size, so the small-failure leading term is correct.
- **Lines 330--335 (proof of reliability calculus): PASS.** The proof is terse but sufficient for
  all four claims; “all intersections” is understood as intersections of distinct blocker events.
- **Lines 337--347 (EXIT-convention paragraph): PASS.** The target-unavailable convention,
  extrinsic/intrinsic distinction, and finite-radius disclaimer are unusually clear and prevent a
  likely capacity overclaim.
- **Lines 349--364 (Proposition, “Bounded-EXIT hierarchy”): PASS.** The failure-form mixture and
  derivative have the correct orientation in the erasure variables.  The difference of successive
  failure probabilities is exactly the law of the cheapest available repair, with the MAP failure
  event furnishing the atom at infinity.
- **Lines 366--369 (failure-certificate paragraph): PASS.** The distinction between target-specific
  transversal certificates and representation-dependent Tanner stopping sets is precise and
  appropriately bounded.
- **Lines 371--386 (locality-deficit paragraph and displays): PASS.** Beta integration gives
  `1/(N binom(N-1,k))` for each size-`k` helper survivor set, and the area identity follows by
  adding the nonnegative bounded-radius deficit to the symbol-MAP area.
- **Lines 388--396 (section opening and pointed-rank paragraph): PASS.** The nonloop/noncoloop
  hypotheses support the elementary perspective, and `epsilon_x(A)=0` is exactly the spanning (and
  hence repair) condition.
- **Lines 398--421 (Theorem, “Pointed perspective polynomial”): MODERATE.** The formulas themselves
  check out, including the derivative identity for `S_x`.  However, the letter `C` is bound here to
  the contraction matroid `M/x`, while lines 446--448 immediately use `C` as a code in
  `d_x(C)` and `c in C`.  In a cold local read the latter expression is ill-typed under the nearest
  binding and forces the reader to reconstruct an earlier code notation.  **Exact correction:**
  rename the contraction throughout the theorem and proof, for example
  `Let D=M\backslash x and C_0=M/x`, then replace `U_C`, `r_C`, and `D\to C` by `U_{C_0}`,
  `r_{C_0}`, and `D\to C_0`.  This leaves `C` unambiguously available for the code in the distance
  formula.
- **Lines 423--435 (proof of pointed-perspective theorem): MINOR.** The rank-difference and
  derivative arguments are correct.  The sentence “Extracting the `Z^0` terms counts successful
  survivor sets by size” skips the specialization that actually recovers size from the two Tutte
  exponents.  **Exact correction:** replace it with
  `The Z^0 terms are exactly the successful sets; more explicitly,
  S_x(u)=u^{r(M)}[Z^0]T_{D\to C_0}(1+u^{-1},1+u,Z), which yields the reliability formula.`
  (Use the manuscript's final name for the contraction if the preceding rename is not adopted.)
- **Lines 437--449 (standardness, duality, blockers, and distance paragraph): MINOR.** The duality
  and the formula `tau_full(x)=d_x(C)-1` are correct, but the prose identifies blockers, which are
  subsets of the helper ground set `V`, with cocircuits through `x`, which contain `x`.  The missing
  deletion of `x` is small but is exactly the reason for the minus one in the next display.
  **Exact correction:** replace the two sentences beginning “For a represented matroid” with
  `For a represented matroid, the minimal failure blockers are the sets $Q\setminus\{x\}$, where
  $Q$ ranges over the cocircuits containing $x$; equivalently, $Q$ is an inclusion-minimal row-code
  support through $x$.  In particular, ...`
- **Lines 451--454 (filtered-refinement paragraph): PASS.** The six-circuit/rank-five example makes
  the information lost by the unfiltered pointed polynomial immediate, and the conclusion is
  proportionate.
- **Lines 456--463 (new section/subsection and opening fragment): PASS at boundary.** The headings
  transition cleanly from invariant structure to examples.  The twisted-cubic definition is cut
  off at the assigned endpoint, so no claim about that new paragraph beyond the visible setup is
  made.

## Findings by severity

- **BLOCKER:** none.
- **MODERATE:** one local notation collision: `C=M/x` versus `C` as the code in the pointed-distance
  formula.
- **MINOR:** make the `Z^0` size-enumerator specialization explicit; identify a blocker as a
  cocircuit through `x` with `x` removed, rather than as the cocircuit itself.

## Overall flow and highest-value edits

The passage has a strong progression: ordinary reliability calculus leads naturally to bounded
EXIT, the area deficit quantifies the cost of the radius bound, and pointed Tutte theory then
explains exactly what the full-radius invariant remembers and forgets.  The trust boundary around
finite-radius decoding is especially well handled.  No mathematical gap or incorrect displayed
formula emerged in this range.

The highest-value edit is the contraction/code rename, because it removes a genuine local type
ambiguity at the main coding-theoretic consequence.  Next, insert the one-line Tutte specialization;
it turns an intuitive proof sentence into a checkable algebraic bridge.  Finally, add
`\setminus\{x\}` to the cocircuit characterization so that the prose and the subsequent `-1` agree
literally.

## Resolution verification

Targeted reread of the current reliability/pointed-Tutte passage after the C285/C286 edits (the
insertions shifted the logical passage to lines 323--490):

- **PASS — contraction/code notation.** The contraction is now consistently named `Q=M/x` in the
  perspective theorem, polynomial, rank calculation, and `U_Q`; `C` is therefore unambiguous in
  the later codeword-distance formula.
- **PASS — explicit `Z^0` specialization.** The proof now gives
  `S_x(u)=u^{r(M)}[Z^0]T_{D\to Q}(1+u^{-1},1+u,Z)`.  Its exponents simplify termwise to
  `u^{|A|}` exactly when `epsilon_x(A)=0`, so it supplies the previously omitted algebraic bridge.
- **PASS — cocircuit minus target.** Minimal blockers are now stated as
  `$Q'\setminus\{x\}$` for cocircuits `$Q'$` containing `$x$`, in literal agreement with
  `tau_full(x)=d_x(C)-1`.
- **PASS — C285 citations and normalization.** The new Colbourn citation is attached only to the
  standard deletion--contraction/pivotality identification; the EXIT citation follows the explicit
  statement that entropy is normalized in `log_q` units; and the Las Vergnas citation identifies
  the displayed invariant as the singleton specialization of the cited set-pointed theory.  The
  `log_q` convention correctly makes the conditional entropy on a `q`-ary erasure channel the
  unrecoverable-symbol indicator, so the symbol-MAP areas sum to `K` with no missing scale factor.

**New defects:** none found.  All three C286 findings are resolved, and the C285 additions introduce
no mathematical, citation-scope, normalization, or narrative defect in this passage.
