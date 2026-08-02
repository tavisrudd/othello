# C718 — Golden boson--fermion complement

**Lane:** `golden`

**Status:** complete; research-only, no manuscript edit

## Objective

Compute and interpret the permanent side of the C707 golden transfer blocks,
and determine whether boson--fermion complementarity exposes a second
algebraic shadow of the Segre nodes or supplies a clean experimental control.

## Gates

1. Fix the bosonic three-particle preparation and normalization for the same
   \(3\times3\) one-particle block \(K_T(x)\); distinguish collision-free
   events from the full bosonic output distribution.
2. Compute the exact permanents and specialize the Jabbour--Cerf
   determinant--permanent identities to the six golden protocols.
3. At all balanced masks, derive the bosonic probability spectrum and its
   dependence on the oriented Segre node.  Test whether it restores signs
   lost by \(Z_T^2\) or is also orientation-blind.
4. Search for a closed algebraic relation, symmetry representation, sharp
   cube bound, or simultaneous extremum for the six permanent coordinates.
5. Identify the minimal measurement comparing bosonic and fermionic runs
   that certifies the golden mixer or rejects mode mismatch.
6. Run a bounded novelty check against multiparticle interference,
   immanants, and boson--fermion complementarity literature.

## Acceptance

- Exact permanent formulas and a human proof of every retained identity.
- A positive new invariant/extremum theorem or a useful negative theorem
  showing that the Segre structure is specifically antisymmetric.
- Independent replay of the finite balanced-mask and probability claims.

## Boundary

Do not call a permanent coordinate an amplitudehedron or supersymmetry
observable without an explicit theorem supplying that structure.

## Dependencies

C720 freezes the paper interface; C707 is complete.  C719 consumes the
accepted experimental discriminator.

## Resolution

The bare permanent is not an invariant of the unmarked Golden block because
the internal (O(3)\times O(3)) port gauge changes it.  A frozen pivot gauge
nevertheless gives an exact 44-term permanent cubic and a complete balanced
census: coherent amplitudes distinguish all twenty oriented masks, while
probabilities collapse to four labelled vectors.  The intrinsic bosonic
companion is instead

\[
 \operatorname{tr}(\operatorname{Sym}^3(K_T^{\mathsf T}K_T))=313/125,
\]

with fermionic exterior probability (16/125), complement (297/125), and
mixed-symmetry trace (8/5).  Together with the one-particle trace these
aggregate readings recover the balanced squared singular spectrum.  The
Jabbour--Cerf covariance sum rule supplies a universal matched-mode control,
not a Golden certificate by itself.

Full report and evidence:
`notes/2026-08-01-c718-golden-boson-fermion-complement.md`.
