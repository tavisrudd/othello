# A referee's route through the proof

The paper proves that two explicit smooth cubic threefolds have stabilization
level exactly two over both `Q` and `C`.  The lower bound is imported from the
separate one-stabilization theorem.  The new proof is the upper bound: a
quartic del Pezzo surface satisfying the stated Picard-lattice hypothesis
becomes rational after multiplication by `A²`.

## A first pass

Read Theorems `thm:cubic-level` and `thm:two-variable` in the introduction,
followed by its final proof summary.  Section 2 states and proves the general
torus-quotient criterion.  In Section 3, the weight calculation through
Proposition `prop:tangent-section` verifies its hypotheses for the four
relevant Galois types.  Section 4 then turns the quotient into the surface and
cubic rationality statements.  The appendices contain the exact finite
calculation and the evidence boundary.

## Five checks

1. **Why is the quotient rational?** In `thm:torus-quotient`, the differences
   among `r+1` selected weights form a `Z`-basis of the character lattice.
   Signed maximal minors therefore determine a unique translate of a general
   torus orbit lying in the codimension-`r` linear section.  Uniqueness gives
   Galois descent.  The same section contains the centre of tangent
   projection and meets its isomorphism open, so its quotient component is
   birational to projective space.  The proof writes both directions of the
   birational parametrization.
2. **Why is the integral-basis hypothesis essential?** Remark
   `rem:saturation` identifies the index-two lattice produced by the three
   visible sign cocharacters and saturates it.  Without saturation, the
   equations parametrize a finite cover of an orbit rather than a rational
   section.
3. **Why does the criterion apply to quartic del Pezzo surfaces?** Section 3
   imports the projective Cox model and the descended form of its birational
   tangent projection from Tschinkel--Zhang.  The smooth tangent-projection
   theorem for varieties with one apparent double point is due to
   Ciliberto--Mella--Russo; the possibly singular Cox model uses the stronger
   form in Tschinkel--Zhang, Theorem 2.4.  The section constructs a
   Galois-stable saturated rank-three subtorus, four selected weight spaces
   whose weight differences form a basis, and the complementary subspace `B`.
   Proposition `prop:tangent-section` constructs the required tangent linear section and
   explains its descent for types `I0`--`I3`.  To make the openness condition
   uniform in the tangent point `p`, the proof packages the tangent projections
   into a rational map over the `p`-parameter space and uses its relative
   isomorphism locus before applying density of rational points.
4. **What does the computation prove?** The four rows in the parameter table
   give evaluation determinants `D_i` and smoothness minors `M_i`.  Appendix A
   proves that the opens `D_i M_i != 0` cover the smooth parameter locus
   `Delta != 0`.  The exact certificate retains the six empty localized cases
   and the final Bezout identity.  It does not prove the quotient theorem, Galois
   descent, torsor splitting, or the function-field deductions.
5. **How does the surface result imply the cubic result?** In Section 4, a
   rational section of the universal torsor gives
   `Z/T3 ~ S × (T0/T3)`.  The left side is rational by the tangent-section
   argument, while the residual rank-two torus is rational.  Applying this
   over the generic-fibre fields of the two cubic fibrations yields
   `X × P²` rational.  The separately cited one-stabilization theorem gives
   irrationality of `X_C × P¹`, hence the exact level.

## Evidence and replay

No Lean development formalizes the new results.  Formal coverage is recorded
as `absent` in `verification/claim-map.json`.  The imported results and their
conventions are listed in `verification/imported-sources.json`; the exact
calculation is described in the README and Appendix B.

From the paper directory, the complete deterministic gate is:

```text
nix develop --command make check
```

It reconstructs and independently checks the certificate, validates the
claim and source metadata, rebuilds the PDF, and rejects TeX warnings.
