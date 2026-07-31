# C715 — Golden anomaly inverse

**Lane:** `golden`

**Status:** complete; reported in
`notes/2026-07-31-c715-golden-anomaly-inverse.md`

## Objective

Turn the C707 observation that the six Joubert amplitudes satisfy
\(\sum Z_T=\sum Z_T^3=0\) into a precise synthesis theorem: recover a
physical diagonal filter from a rational anomaly-free six-Weyl charge
vector, identify every exceptional locus, and quantify the postselection
cost.

## Gates

1. Match the frozen C707 marking with the classical rational
   \((\mathbf P^1)^6\dashrightarrow\) Segre map and write an explicit inverse
   in the C707 path coordinates.
2. Prove the inverse and its domain by a certificate-independent structural
   argument; state fibres and stabilizers rather than hiding them in a
   solver.
3. Normalize every rational preimage to \(\|x\|_\infty\le1\), clear charge
   denominators projectively, and derive the exact three-fermion success
   probability and its scaling.
4. Pull back the vectorlike planes, singular nodes, smooth chiral locus, and
   inverse-polar exceptional divisor.  Explain the Boolean theorem
   \(44\mapsto0\), \(20\mapsto\) vectorlike nodes as a boundary case.
5. Determine whether \((-3,-2,-1,0,1,3)/3\) is in any natural sense a
   minimal-height or maximal-success preimage of
   \((11,-10,-8,5,4,-2)\); retain an honest finite boundary if not.
6. Run a formula-level novelty check against the classical Joubert/Segre and
   anomaly-parametrization literature before admitting a paper claim.

## Acceptance

- A human theorem with explicit forward and inverse formulas, exceptional
  set, and physical normalization.
- Exact generator/certificate and an independent replay for any finite
  height or optimization claim.
- Manuscript-safe attribution separating the classical birational map from
  the new golden Slater/Majorana realization.

## Boundary

The filter parametrizes anomaly-charge arithmetic.  It does not construct
gauge fields, a renormalizable Lagrangian, or an anomaly-cancelling quantum
field theory.

## Dependencies

C720 freezes the paper interface; C707 is complete.  C716 and C719 consume this task's frozen inverse and
normalization interface.

## Frozen output

The rational inverse is the classical
\((\mathbf P^1)^6/\!/\operatorname{PGL}_2\) quotient in the marked C707
coordinates.  Its stable fibres are projective-linear orbits.  The
vectorlike planes and inverse-polar exceptional divisor pull back to the
Vandermonde collision divisor; the nodes are the \(3+3\) closed orbits.
For a normalized preimage with \(Z=\lambda q\), the exact interface consumed
by C716/C719 is
\[
 p_T^{(3)}=\lambda^2q_T^2/500.
\]
