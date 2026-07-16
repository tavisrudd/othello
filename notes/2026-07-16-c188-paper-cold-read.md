# C188 post-integration cold read

**Date:** 2026-07-16
**Lane:** `relconic`
**Scope:** Fresh, context-blind referee read of
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` after the q=5 exact-value
integration.  No files were edited during the read.

## Overall assessment

This is a strong specialty paper with a real organizing theorem, unusually careful trust
boundaries, and a substantial exact finite result.  The defect identity is elementary once seen,
but useful: it packages the classical first two secant moments into an exact nonnegative local
remainder, and the equality/stability consequences are clean.  The q=16 quadratic-avoidance
classification is the strongest concrete contribution.  The projective-averaging transfer and
coding dictionary are worthwhile, though the manuscript becomes somewhat omnibus-like.

The likely referee posture is “positive, moderate revision” for a good finite-geometry/coding
venue such as *Designs, Codes and Cryptography* or *Finite Fields and Their Applications*.  JCTA
is possible but less certain: the core identity is algebraically modest, novelty of the parameter
itself is not established, and the coding/q=11 extension material makes the paper feel broader
than its central theorem.  It is well above a routine computational note.

## Effect of adding q=5

The addition is modestly helpful, not transformative.  It shows the corrected lower bound is sharp
at the first small order, gives a conceptually clean extremizer in the projective four-frame, and
makes the exact-value record more complete.  It does not materially strengthen the main asymptotic
or q=16 story.  Before repair, visible documentation seams made it closer to neutral than clearly
beneficial; after those seams are repaired it should be a small net positive.

No mathematical defect was found in `rho_C(5)=4`.  The displayed coordinates agree with the Lean
leaf, and the matrix sends the standard frame to those coordinates.  The manuscript's wording
that the conic equation becomes a nonzero multiple of `XZ-Y^2` is safe.

## Must-fix findings

1. The verification appendix listed only `Q8.lean`, `Q9.lean`, `Q11.lean`, and `Q16.lean`, despite
   displaying and claiming five witnesses.  It must name `ExampleChecks/Q5.lean`.
2. The manuscript implied that `verify_relative_conic_arcs.py` checks every displayed witness.  It
   covers only q=8,9,11,16; q=5 has a separate C187/Lean path.
3. The verification entry-point paragraph and five-witness evidence row must distinguish those two
   trust paths explicitly.
4. The Q5 Lean comment's named scalar was inconsistent with the point-coordinate transport
   convention.  The scalar is irrelevant to the zero locus and checked theorem, but the comment
   should avoid or correct it.
5. Before applying the moment-derived `L2` bound to the unrestricted minimum, the human proof
   should state that a conic-complete arc for q at least three cannot have fewer than three points.

## Optional improvements

- Describe q=5,8,9,11 uniformly as explicit witnesses attaining `L2(q)`, then identify q=5 as the
  frame.
- Demote the companion-manuscript citation so it supplies context without looking like a proof
  dependency.
- Give the elementary q=5 frame calculation directly, making the result feel integrated rather
  than appended.
- Longer-term, reconsider whether the extensive q=11 coding/extension section makes the paper too
  omnibus-like.

## Requested repair gate

After applying the must-fixes and low-risk prose improvements, rebuild the PDF, check citation and
reference warnings, and resume the same cold reader for a targeted verification pass.
