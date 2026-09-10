# C1133 — parameterized rank-two residue, formal checkpoint

**Date:** 2026-09-09. **Status:** finite matrix identities kernel-checked.
This implements the first algebraic portion of L2. It is not a geometric Fano
classification or a claim that a complete normalized formal gauge was built.

## What is proved

The new `Quantum/ParameterizedRankTwoResidue.lean` works over an arbitrary
characteristic-zero field with `q ≠ 0` and `s = 2a+b ≠ 0`. The explicit leading
matrix has characteristic polynomial `T²(T²-sq)`. A displayed rational basis
has determinant `-s²q²`, a proved two-sided inverse, and intertwines the leading
matrix with the complementary block and the rank-two square-zero block.
The grading change and first-order off-diagonal gauge equation are proved.
The second-order lower-left entry is `-4a²/s²`; the commutator with **any**
second gauge contributes zero there. Differentiation of the first gauge is
included in the coefficient equation.

The modified residue has characteristic polynomial
`T²+T+(10a-3b)/(4s)` and exact discriminant `4(b-2a)/s`. Both are actual Lean
matrix/polynomial identities. The rational inputs `(240,1248)`, `(48,160)`,
`(24,60)`, `(16,32)` give `16/9`, `1`, `4/9`, `0`. In particular the resonant
case remains visible. No geometric identification of these inputs is supplied
by the proof.

Public declarations in `PaperInterface/Main.lean`:

- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.parameterizedRankTwo_finiteReduction`;
- `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.parameterizedRankTwo_fourDiscriminants`.

The supporting coefficient bridge is
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.parameterizedReduction_second_order_lowerLeft`.
It allows an arbitrary original second coefficient and records its additive
contribution, rather than silently assuming it vanishes in every application.

## Verification and correspondence

The leaf elaborated without warnings through `lean/scripts/guarded-lean` and
built through the guarded queue. The public interface and exact axiom audit
then built with the new import. Commands, from the monorepo root:

```sh
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ParameterizedRankTwoResidue \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
lean/scripts/lean-build-queue.py build \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.PaperInterface.Main \
  TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Verification.AxiomAudit \
  --lean-root /home/tavis/src/othello/papers/cubic-stabilization-m1/lean --cores 20-23
```

Successful runs: `/home/tavis/.cache/othello-lean-build/run-20260910-010657-64d9d9ad`
(leaf, 2,079,392 kB peak) and
`/home/tavis/.cache/othello-lean-build/run-20260910-011328-26c4e1f2`
(interface/audit, at most 2,079,196 kB peak). The aggregate trace gate passed.
Both public declarations use exactly `propext`, `Classical.choice`, `Quot.sound`.
The source checker with the captured axiom log passes: **188 sources, 322
terminals, 67 manuscript claims, 86 machinery declarations, 22 imported-source
records and 5 evidence bundles**. Only the two new machinery digests were
refreshed. Existing coverage remains 14 absent / 26 fragment / 26 conditional /
1 complete. The new entries explicitly do not discharge current manuscript
claims. No PDF build, export or mirror update was needed for this checkpoint.

## EJ+TT and Mystery ledger

- **Settled:** the second gauge does not change the relevant lower-left entry;
  its leading commutator is zero there without a normalization hypothesis.
- **Settled:** the discriminant-one input is certified by exact arithmetic and
  is not discarded by a modulo-integer exponent selector.
- **Open:** connect the finite identities to the existing complete normalized
  formal gauge construction. The full gauge equation must produce these first
  two coefficients; an arbitrary input second coefficient cannot be omitted.
- **Open:** all seventeen leading matrices, cyclic determinants, scalar shifts,
  and nine rank-two certificates still need their finite Lean interface. The
  existing two rational replay implementations remain independent evidence.
- **Open:** geometric quantum-product identifications, deformation bridges,
  family exhaustion and all-member rationality are separate source-level
  inputs. This checkpoint does not upgrade their formal coverage.
