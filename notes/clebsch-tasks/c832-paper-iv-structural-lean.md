# C832 — Paper IV structural theorem Lean formalization

**Lane:** `clebsch`

**Status:** active; C831 dependency; formalization authorized 2026-08-02

## Objective

Formalize the structural theorem interfaces adopted by C831 and replace the
superseded Paper-IV brute-force proof surface with semantic Lean statements
and compact paper-owned exact leaves.

## Required packets

1. **Theta packet:** define the 42-vertex cyclic tangent graph and integral
   quadratic-form certificate; prove that positivity plus diagonal/edge
   values bounds every clique by five; connect this theorem to the existing
   semantic weight-eight transport.  Exact matrix positivity and kernel data
   may remain a paper-owned native-evaluation leaf with an explicit axiom
   report.
2. **Moment packet:** formalize the incidence and passant-pair double counts,
   derive
   \(4n_4+12n_6+24n_8+\cdots=10-m\), and prove the two global shapes.  The
   four line-stabilizer and thirty-three point-stabilizer exclusions are
   separately named finite leaves.
3. **Pair-reconstruction packet:** replace triple-concurrence row selection
   by concurrence-8 neighborhoods; formalize the common-concurrence-7 split
   of the fused relation, parity operator image theorem, and exact arity-two
   interface.
4. **Ambient-plane packet:** formalize the group-theoretic construction from
   fourteen Sylow-13 subgroups and 169 involutions, the three intrinsic
   incidence rules, and the transport identifying the recovered
   internal--internal polarity block with the passant matrix.  The concrete
   q=13 group/plane census may be a named exact leaf, while the reconstruction
   implication and data interfaces are kernel checked.
5. **Minimum-geometry packet:** formalize the three punctured pencil-conic
   supports and their discriminant parity proof; expose the octahedral
   matching-profile classification as a separate bounded leaf.
6. **Hidden-field packet:** formalize the irreducible cubic action on the
   code, \(K\cong\mathbf F_8^{12}\), the three Frobenius scalar operators,
   and the resulting orbit-spanning implication.  Do not formalize the
   deferred cuspidal/Schur-field development.

## Trust and release requirements

- Reuse the existing semantic q=13 geometry and minimum-word APIs; do not
  duplicate coordinate models.
- Every native computation is declaration-local and appears in the tracked
  `#print axioms` audit.
- The aggregate gate exports theorem-shaped terminals matching the C831 main
  theorem and trust table.
- The focused shared-library build, standalone Lake build, paper aggregate,
  axiom audit, and source-hygiene checks all pass under the pinned toolchain.
- C832 does not publish or alter external release state; it hands a frozen
  formal surface to C831/C761.
