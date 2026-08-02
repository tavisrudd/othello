# C608 — explicit exact PRS decoders through redundancy seven

**Lane:** `reed-solomon`

**Dependency gate:** Cleared by C545's 2026-07-29 Version 1 publication. This
task must not change the immutable Version 1 manuscript or release artifact.

## Target

Turn the Version 1 Hankel split-form criterion into elementary exact
maximum-likelihood decoders for full-length projective Reed--Solomon codes,
with proposed field-operation bounds
\[
O(q),\qquad O(q^2),\qquad O(q^3)
\]
at redundancies \(5,6,7\), respectively, suppressing fixed-degree
factorization and bounded-\(r\) factors.

The proposed algorithm tests locator degree in increasing order, factors a
unique locator in the low-degree range, enumerates the small intermediate
projective Hankel kernels, solves a terminal hyperplane split-form problem,
and recovers nonzero error values from the Vandermonde system.

## Proof gates

1. Replace “unique minimum support” by the exact Vandermonde/Hankel rank
   factorization proving one-dimensional locator kernel in the unique range.
2. Prove the terminal hyperplane solver rigorously: describe both infinity
   charts, the bilinear last-two-root equation, the collision bad locus, an
   explicit degree bound, the constant-size grid argument, and the bounded
   small-field branch.
3. Verify the intermediate kernel dimensions:
   cubic pencil at \(r=5\), quartic projective plane at \(r=6\), and the
   quartic-plane/quintic-three-space bounds at \(r=7\).
4. Prove that failure through degree \(r-1\) makes the final \(r\)-column basis
   solution have all coefficients nonzero.
5. Keep the \(q=7,8,9\) redundancy-seven covering-radius boundary separate:
   the decoder may return weight seven there, while the classified
   radius-supported range terminates at six.
6. Audit prior explicit and parameterized Reed--Solomon decoders before any
   novelty or optimality claim.

## Exit gate

- executable pseudocode and a proof of exact maximum likelihood;
- explicit operation counts and factoring assumptions;
- exhaustive small-field tests used only as regression evidence, not proof;
- independent coding-theory and algorithm review; and
- a decision whether the result is a compact Version 2 corollary or a separate
  practical-decoding companion.
