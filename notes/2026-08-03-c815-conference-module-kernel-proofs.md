# Kernel proofs for the order-six golden conference module

**Lane:** `clebsch`
**Date:** 2026-08-03
**Task:** C815

Goal: remove all three `native_decide` occurrences from
`lean/RelativeConicArcs/ClebschGoldenConference.lean` so that the five affected
terminals (`conferenceMatrix_sq`, `conferenceMatrix_transpose`,
`conferenceMatrixOver_sq`, `conference_triangleSigns`,
`conference_triangleCubic_translate`) carry only `propext`, `Classical.choice`,
`Quot.sound`. Statements, names, namespaces, and argument structure are frozen:
six gates import this module.

## Attempt log

### Round 1 — direct kernel reduction, all three at once

No structural detour was needed; the entrywise route worked on the first
elaboration.

| Occurrence | Old | New |
|---------------------------|-----------------|--------------------------------------------------|
| `conferenceMatrix_transpose` | `native_decide` | `ext i j; fin_cases i <;> fin_cases j <;> rfl` |
| `conferenceMatrix_sq` | `native_decide` | `ext i j; fin_cases i <;> fin_cases j <;> decide` |
| `conference_triangleSigns` | `native_decide` | `decide` |

Notes on why each works.

- The transpose is definitionally the entry swap of an explicit `!![...]`
  literal, so after `Matrix.ext` and the thirty-six `Fin 6` cases each goal is
  closed by `rfl` on a numeral.
- `Matrix` equality is a function equality and is not decidable, so `decide`
  cannot be applied to the square directly. Going through `Matrix.ext` first
  turns it into thirty-six closed integer goals, each a six-term row-column sum
  against `(5 • 1) i j`; the kernel evaluates those without difficulty.
- The twenty triangle signs are already a closed conjunction of integer
  equations, so a single `decide` suffices; no `Matrix.ext` step is involved.

`TightFrameConference.conference_sq_of_gram` was not needed and is not
imported. Introducing it would have added an import edge to a shared module for
no gain over the direct reduction.

### Elaboration timings

`lean/scripts/guarded-lean RelativeConicArcs/ClebschGoldenConference.lean`,
default profile (`single`, cores 20-23, one thread, `choom=1000`).

- First green run with the three replacements: exit 0, 12.5 s (cold imports).
- Final green run after the prose rewrite: exit 0, 5.2 s.
- Final run directory:
  `~/.cache/othello-lean-build/guarded-lean/20260803-200356-cd-lean-exec-taskset-c-20-23-env-LEAN_NUM_THREADS1-choom-n-1000-nix-develop-comma`

Both runs produced zero stdout lines and one stderr line, which is the Nix
dirty-worktree notice, not a Lean warning.

### Axiom audit

A temporary block of `#print axioms` commands was appended, elaborated, and
then removed. All eight audited declarations — the five affected terminals plus
`triangleSign_four_point`, `sq_eq_five_of_pairTriangleSum_eq_zero`, and
`conference_pairTriangleSum_eq_zero` — reported exactly `propext`,
`Classical.choice`, `Quot.sound`. Zero occurrences of `ofReduceBool`,
`sorryAx`, or a declaration-local `_n.n_decide.ax_*` axiom.

### Prose

The module header claimed the two integer tables were "checked by native
decision in the pinned Lean runtime". It now states the actual method: entrywise
reduction by `Matrix.ext`, `Fin` case enumeration over the full thirty-six-pair
index domain, kernel decision of each resulting integer equation, and the same
for the twenty triangle signs as one closed conjunction. It records that the
checks are exhaustive rather than sampled and that the module's trust base is
`propext`, `Classical.choice`, `Quot.sound`. The header also now names the
mathematical content (the conference equation, base change, switching
covariance, translation invariance, four-point identity) and the `Fin 6`
labelling convention, rather than leaving them to the declaration names. The
private transport helper `cast_conference_triangleSign` gained a docstring.

## Outstanding

Gate-level revalidation across the six dependent gates —
`RelativeConicArcs.Gates.ClebschPassages`, `ClebschGoldenReturn`,
`FourShadowRecognition`, `ClebschRigidityTrust`, `GoldenCubicNodes`,
`GoldenProofSpine` — has **not** been run. Another lane holds the host build
lock, so only single-file elaboration was possible. Statements are unchanged, so
no downstream break is expected, but this is unverified.

The manuscript's committed axiom records under
`papers/clebsch-passages/verification/` are now stale in the direction of being
too pessimistic. `golden_return_axioms.txt` still lists
`RelativeConicArcs.ClebschGoldenConference.conferenceMatrix_sq._n.n_decide.ax_1_1`
and the matching `conferenceMatrix_transpose` axiom, and
`golden_return_formal.json` still describes the literal integral matrix and
finite twenty-triple claims as discharged by native decision. Those files and
the corresponding sentence in `sections/08-verification.tex` need regeneration
and a prose update once the gates are rebuilt. They were out of this task's edit
scope.

## Lean statements stronger than the manuscript

Recorded per the task requirement; each is a case where the formal statement
covers strictly more than `papers/clebsch-passages/` claims. None of these are
defects — they are free generality that the manuscript could quote if useful.

1. **Base change to every commutative ring.** The manuscript works with real
   symmetric conference matrices: section 5 of the golden-operator material
   forms `(I ± C/√q)/2` and speaks of eigenvalues, so its ambient field has
   characteristic zero. `conferenceMatrixOver_sq` and
   `conference_pairTriangleSum_eq_zero` are proved for an arbitrary `CommRing R`
   via the entrywise integer cast. This includes characteristic 2 and
   characteristic 5, where `5 • 1` degenerates and the manuscript's spectral
   argument has no content.

2. **Translation invariance over an arbitrary ring and arbitrary shift.**
   `conference_triangleCubic_translate` quantifies over every `CommRing R`,
   every `x : Fin 6 → R`, and every `u : R`. The manuscript's descent of the
   triangle cubic to the augmentation quotient is a real (or characteristic
   zero) statement about the all-ones direction.

3. **Switching by any square root of one, not only by signs.**
   `triangleSign_switch` and `triangleCubic_switch` assume only
   `∀ i, d i * d i = 1`. The manuscript switches by diagonal `±1` matrices. Over
   `ℤ` or a domain the two coincide, but over a general commutative ring the
   Lean hypothesis admits strictly more diagonal operators.

4. **The four-point identity needs neither a zero diagonal nor `±1` entries.**
   The manuscript states it for symmetric conference matrices. Lean's
   `triangleSign_four_point` assumes only `C.transpose = C` and
   `∀ i j, i ≠ j → C i j * C i j = 1`, over any commutative ring. Zero diagonal
   is never used, because the four labels are pairwise distinct. The docstring
   correctly says "symmetric signed matrix" rather than "conference matrix".

5. **Pair balance holds for an arbitrary square scalar.**
   `pairTriangleSum_eq_zero` takes `hsq : C * C = a • 1` for an arbitrary
   `a : R`, not the manuscript's `q = 2d - 1` (here `5`). The value of `a` plays
   no role off the diagonal.

6. **The pair-sum identity needs symmetry alone.**
   `pairTriangleSum_eq_mul_mulApply` proves
   `pairTriangleSum C i j = C i j * (C * C) i j` from symmetry only — no zero
   diagonal, no unit off-diagonal entries, no conference equation. The
   `pairTriangleSum` docstring mentions the zero diagonal as the reason repeated
   labels are harmless, which explains the intended use but is not a hypothesis
   of this lemma.

7. **Cubic reversal is unconditional.** `triangleCubic_neg` places no hypothesis
   whatever on `C`; it is a polynomial identity in the entries.

8. **Weaker typeclass on the underlying definitions.** `switchMatrix` and
   `triangleSign` are defined over `[Mul R]`, not `[CommRing R]`, so they make
   sense on any multiplicative structure. Only the statements that combine them
   additively need a commutative ring.

9. **The converse direction is formalized over any commutative ring.**
   `sq_eq_five_of_pairTriangleSum_eq_zero` derives `C * C = 5 • 1` from
   symmetry, zero diagonal, unit off-diagonal squares, and off-diagonal pair
   balance, with no reality or characteristic assumption. All four hypotheses
   are used: the diagonal and unit-square hypotheses in the `i = j` branch, the
   symmetry and balance hypotheses in the `i ≠ j` branch.
