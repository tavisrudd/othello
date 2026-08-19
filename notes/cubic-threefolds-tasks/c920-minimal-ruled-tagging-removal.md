# C920 — Removing the divisor-tagging hypothesis for minimal rational ruled centers

**Lane:** `cubic-threefolds`

**Status:** closed 2026-08-18

**Objective:** close the rational geometrically ruled half of the residual use of
Hypothesis 5.7T in `papers/cubic-stabilization-epilogue/`, so that specialized
primitive-sixth vanishing for those centers is proved rather than assumed.

**Outcome:** done.  Hypothesis 5.7T is now used only for surface centers that
are neither minimal nor geometrically ruled.  Report:
`../2026-08-18-c920-minimal-ruled-tagging-removal.md`.

Two things went differently from the plan below.  Strand one could not be
carried out as written: the toric quantum Stanley--Reisner presentation is a
theorem only for Fano toric manifolds and is false for `F_a` with `a` at least
two, so the reduction to `F_0` and `F_1` is by one deformation and invariance of
genus-zero Gromov--Witten invariants, with the toric presentation used only for
`F_1` and even there only as a check.  And the class is the rational
geometrically ruled surfaces, not the minimal ones: `F_1` belongs to it without
being minimal, which is why the residual scope is stated as it is.

## Why this is the residual

`prop:low-dimensional-vanishing` needs the specialized invariant to vanish for
every point, curve, and surface, because weak factorization in dimension at most
four produces exactly those centers. After the direct-specialization pass
(`../2026-08-18-c910-direct-specialized-lowdim.md`), the cases already proved
without Hypothesis 5.7T are points, curves of positive genus and every minimal
surface with nef canonical class, the projective line and plane, and — assuming
only Hypothesis 5.7R — ruled surfaces over curves of positive genus. What is
left is minimal rational ruled surfaces and nonminimal surfaces, and for those
the manuscript proves only the intrinsic statement and carries it to the
specialization by Hypothesis 5.7T.

The prize behind this is not the hypothesis itself. `thm:every-cubic-conditional`
reaches the paper's headline through the framed route, which uses none of the
ordinary Hodge-atom theorems that the Section 4 route imports from an unrefereed
preprint. Removing both hypotheses would make that a second, independent
unconditional proof of the headline. This task closes one of the two residual
cases; the other is deliberately out of scope.

## Scope

In scope: minimal rational ruled surfaces, that is `PP^1 x PP^1` and the
Hirzebruch surfaces.

Out of scope: nonminimal surfaces. Every such surface is an iterated point
blowup, and carrying the intrinsic blowup formula past the external center
specialization needs the support or base-change statement that
`rem:tagging-scope` names as missing. Their even cohomology also has rank four
plus the number of blowups, so the quartic-discriminant route below does not
apply. That case needs new mathematics and belongs to its own task.

## Strand one: the specialized quantum relation

Derive the small quantum relation of a Hirzebruch surface at a strictly
Novikov-admissible specialization from the toric quantum Stanley--Reisner
presentation, and put it in the exact form the companion consumes: the monic
characteristic polynomial of Euler multiplication on the rank-four even
cohomology `H^0 + H^2 + H^4`, with coefficients written in the two specialized
Novikov values.

Check `PP^1 x PP^1` first against the product formula for a product with a
projective space, which the paper already proves; if that formula is available
in specialized rather than intrinsic form it settles this member directly and
the toric computation is needed only for the remaining Hirzebruch surfaces.

Follow `notes/research-reproducibility-conventions.md` for any computer-algebra
step: the displayed quartic is the single input everything downstream rests on,
so it needs a tracked generator, a replay command, and an independent check
against the toric literature.

## Strand two: the Lean reduction

In the paper-bundled companion, mirroring
`Quantum/ProjectiveSpaceEulerSpectrum.lean` and
`Applications/DirectSpecializedVanishing.lean`:

- from a supplied rank-four characteristic polynomial of Euler multiplication
  with nonvanishing quartic discriminant, prove that every maximal generalized
  eigenspace is one-dimensional and hence, through the supplied conclusion of
  the multiplicity-one Euler block lemma, that the specialized count vanishes.
  The universal quartic discriminant and its identification with the squared
  product of the pairwise root differences are already in
  `Quantum/QuarticDiscriminantDerivations.lean`;
- state and prove the collision trichotomy exhaustively, so that a degenerate
  specialization is handled rather than assumed away: all blocks of rank one; a
  rank-two block whose nilpotent part is square-zero, which
  `Quantum/RankTwoResidueRigidity.lean` already covers; and any other block
  shape, which must be excluded explicitly;
- prove the non-collision arithmetic for the center specializations that weak
  factorization actually produces, using the existing strict-admissibility
  structure and its valuation law, rather than checking it on paper.

The identification of Euler multiplication with the first Chern class action,
the toric presentation, and the comparison theorems stay supplied premises:
Mathlib has no Gromov--Witten theory, quantum cohomology, or toric machinery at
the needed strength.

## Acceptance

- The manuscript's remaining use of Hypothesis 5.7T is confined to nonminimal
  surfaces, stated as such in `rem:tagging-scope` and in the proof of
  `prop:low-dimensional-vanishing`.
- The claim map records the new terminals, the guarded build, `make check`, and
  the axiom-log check pass, and the standalone repository is synchronized.
- The displayed quartic and its discriminant condition are reproducible from a
  tracked generator, with the degeneracy locus stated exactly rather than as a
  genericity remark.
