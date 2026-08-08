# C884 — the harmonic section's representation-theoretic and special-function inputs

**Lane:** `clebsch`
**Status:** queued; begin after C815 closes rows HARM-1 and HARM-2, and before
C816 promotes the harmonic section

## Objective

Three assertions of `papers/clebsch-passages/sections/05-harmonic-realization.tex`
lie outside Theorem `thm:harmonic-main` and outside the route that closes rows
HARM-1 and HARM-2 in
`notes/2026-08-03-c815-paper-iii-formalization-gap-inventory.md`.  No inventory
row owns them.  They are representation theory and special-function
normalization, not more of the moment-functional route, so they are collected
here rather than folded into HARM-1.

1. **The covariant obstruction.**  The paragraph beginning "Nor can a
   rotation-equivariant polynomial covariant induce this linear bridge" asserts
   that a rotation-equivariant polynomial map restricting to the displayed
   Clebsch four-space as the nonzero linear comparison cannot exist.  Its
   content is the vanishing of the space of rotation-equivariant linear maps
   between two nonisomorphic irreducible rotation modules, together with the
   reduction that decomposes the covariant into homogeneous parts and evaluates
   at a scaled argument to force the degree-one part to carry the same
   restriction.  The paragraph names both ingredients but proves neither.

2. **The non-arithmetic content of the Gaunt factorization.**  The factorization
   `-784000/1247103 = -(400/46189)(1960/27)` is arithmetic and already checked.
   What is not established is that the first factor is the square of the Wigner
   symbol with all three angular momenta six and all three magnetic quantum
   numbers zero; that `46189 = 11·13·17·19` is therefore the universal
   degree-six denominator rather than an artifact of this configuration; and
   that multiplicity one of the invariant cubic is what reduces the whole cubic
   calculation to the marked fixed line.

3. **The Condon--Shortley remark.**  The two displayed constants follow from the
   stated conversion factor `-130/√(3553 π)` together with the theorem's
   coefficient, and that implication is verified.  The conversion factor itself,
   which rests on the Gaunt formula and the value
   `(6 6 6; 0 0 0) = -20/√46189`, is a special-function input with no owner.

## Required scope

1. Fix, for each of the three, which of the following it becomes: a statement
   proved in Lean at the quantifier range the manuscript uses; a statement
   proved on paper from a citation given at theorem or page level, with the
   citation verified against the original source; or a manuscript claim that is
   narrowed or removed.  The series formal standard in the lane handoff admits
   no permanent partial coverage, so "cited and left informal" is not by itself
   an outcome.
2. For the covariant obstruction, decide whether the cheapest closure is the
   general equivariance statement or the concrete degree-by-degree argument on
   the two modules actually in play.
3. For the Wigner and Gaunt inputs, identify the exact classical statements
   used, with pinpoint references, and separate what is a definition-chasing
   evaluation of a single Wigner symbol from what needs the general Gaunt
   formula.
4. Record what remains trusted, in the form the verification section and the
   trust manifest consume.

## Coordination boundary

C815 owns rows HARM-1 and HARM-2 and the modules that close them; this task
owns nothing inside those rows.  C816 owns manuscript promotion of the harmonic
section: if this task concludes that a manuscript sentence must change, it
records the exact replacement and hands it to C816 rather than editing the
section.  Any new Lean module lands beside the harmonic modules and is added to
a gate under the ordinary shared-library validation rules.

## Acceptance

- Each of the three paragraphs has a named owner outcome and, where the outcome
  is a proof, a kernel-checked declaration or a verified pinpoint citation.
- The gap inventory gains rows for whatever remains, or records that nothing
  does.
- No manuscript prose is changed by this task.

## Evidence source

The arithmetic of the three paragraphs is already verified and recorded in
`notes/2026-08-07-c815-harmonic-route-referee-review.md` (finding 3):
`46189 = 11·13·17·19`, `46189·27 = 1247103`, `400·1960 = 784000`, and
`13·1247103 = 4563·3553`, and the displayed `W_6(F_y)` constant follows exactly
from the stated conversion factor and the theorem's coefficient.  What is
missing is ownership of the representation-theoretic and special-function
inputs, not a computation.
