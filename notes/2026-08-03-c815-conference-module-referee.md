# Referee report: kernel-reduction rewrite of the order-six conference module

**Lane:** `clebsch`
**Date:** 2026-08-03
**Task:** C815

## Verdict

**ACCEPT WITH REPAIRS.**

The mathematics is correct, every statement is preserved, and the trust base of the module
strictly improves. The repairs are (a) two downstream trust records the author did not flag,
(b) one factually wrong sentence in the new module header, (c) undefined terminology the
no-grandfathering rule now puts in scope, and (d) the fact that no committed artifact yet
witnesses the claimed axiom base, because the change has not been through the six dependent
gates.

Independent arithmetic check of the table in `lean/RelativeConicArcs/ClebschGoldenConference.lean`
lines 43-49 (done outside Lean): the matrix is symmetric, its square is exactly `5·I` with every
off-diagonal entry zero, and the twenty ordered triple products in the order used by
`triangleCubic` are `- - + + + - + + - - + + - - + - - - + +`, matching lines 137-156 term for
term. So the three rewritten proofs are proving true propositions; the only open question is
whether the tactics discharge them, which needs an elaboration I am forbidden to run.

## Findings, by severity

### 1. Two downstream trust records that now understate the trust base were missed (major)

The author flagged `papers/clebsch-passages/verification/golden_return_axioms.txt`,
`golden_return_formal.json`, and a sentence in `sections/08-verification.tex`. The first two are
confirmed; the third does not exist (see finding 3). Two further records are stale and were not
flagged:

- `papers/clebsch-passages/verification/passages_axioms.txt` line 37-40 records
  `RelativeConicArcs.ClebschGoldenConference.conferenceMatrixOver_sq` as depending on
  `RelativeConicArcs.ClebschGoldenConference.conferenceMatrix_sq._native.native_decide.ax_1_1`.
  That axiom no longer exists. The block must be regenerated to `[propext, Classical.choice,
  Quot.sound]`.
- `papers/clebsch-passages/verification/passages_formal.json`, field `trust_boundary.native`,
  currently reads "Native decision is confined to displayed finite conference/reflection matrices,
  explicit finite vectors, finite conference signs, the 16,384 normalized two-cut cases, and the
  F_11 nonsquare leaf." After this change the conference matrix and the conference signs are no
  longer native. The field must drop "conference/reflection matrices" down to the reflection
  matrices only and drop "finite conference signs", and should state that the conference table,
  its transpose, its square and its twenty triangle signs are kernel reductions.

Confirmed for the flagged pair:

- `golden_return_axioms.txt` lines 1-15 and 21-23: the four blocks for
  `conferenceMatrix_sq`, `conferenceMatrix_transpose`, `conferenceMatrixOver_sq` and
  `conference_triangleSigns`, plus the `conference_triangleCubic_translate` block, each carry a
  `._native.native_decide.ax_1_1` entry that must be removed. `conference_triangleSigns` and
  `conference_triangleCubic_translate` currently print `[propext, Quot.sound, <native ax>]`; after
  the rewrite the residual list is whatever `#print axioms` actually emits, not a hand-edited
  guess — regenerate, do not patch.
- `golden_return_formal.json`, field `trust_boundary.native`: "Literal integral matrix,
  determinant-minor, and finite twenty-triple claims use native decision in the pinned Lean
  runtime." The conference matrix and the twenty-triple claim leave that set; only the
  determinant-minor and the remaining `ClebschMiddleExterior` literal-matrix rows stay. The field
  must be narrowed to name those, and the conference rows moved into a kernel-reduction statement.

Additionally, three hash fields in all three records are now wrong, because the source file
changed from `9a2cc1a46d68a3b08576cc7227dd044a8bfd7104f8e36ab5ca91e94c33cce7b2` (parent) to
`3c561c1f7a464815f8bc384e206111eb8ea982bc0568ff33be2890b102d9f6ad` (current):

- `source_sha256["RelativeConicArcs/ClebschGoldenConference.lean"]` in
  `golden_return_formal.json`, `passages_formal.json`, and `four_shadow_formal.json`;
- `source_closure_sha256` in the same three files, and the corresponding entries in
  `golden_return_source_closure.json`, `passages_source_closure.json`,
  `four_shadow_source_closure.json`;
- `axiom_report_sha256` in `golden_return_formal.json` and `passages_formal.json`
  (`four_shadow_axioms.txt` mentions only `pairTriangleSum_eq_mul_mulApply`, whose recorded
  axioms `[propext, Classical.choice, Quot.sound]` are unchanged, but its report file's digest
  still changes only if the report itself changes — check, do not assume).

`four_shadow_formal.json`'s `trust_boundary.native` already says "No compiled evaluation is used"
and stays correct.

`lean/trust/facts/RelativeConicArcs.PaperIOrientationSpine.json` lists every
`ClebschGoldenConference` declaration in `project_declarations` and `declaration_module`, but its
`terminal_axioms` contains no conference terminal and no native axiom, and `project_axioms` and
`opaque` are both empty. It needs regeneration for the closure hashes only, not for a trust
statement.

### 2. The module header miscounts its own finite claims (moderate)

`lean/RelativeConicArcs/ClebschGoldenConference.lean` line 19: "Three claims about the explicit
integer table are finite and are discharged by kernel reduction alone." There are five:
`conferenceMatrix_transpose` (line 52), `conferenceMatrix_apply_self` (line 57, `fin_cases` plus
`rfl`), `conferenceMatrix_apply_sq` (line 61, `fin_cases` plus `simp_all`), `conferenceMatrix_sq`
(line 66) and `conference_triangleSigns` (line 136). The header enumerates only the three the
commit touched, which is exactly the reverse-reference-to-the-change that the review gate's
no-grandfathering rule is meant to prevent: the header must describe the module, not the diff.
Either raise the count and name all five, or drop the numeral and say "every claim about the
explicit integer table".

### 3. The flagged manuscript sentence does not exist (moderate, but it is a non-repair)

`papers/clebsch-passages/sections/08-verification.tex` contains no sentence about native
decision, compiled evaluation, or a Lean runtime. The nearest candidates are line 31-32 ("checked
by the pinned golden-return Lean gate") and line 47 ("they are not inferred from a finite matrix
check"), neither of which asserts anything about the evaluation method. No tex edit is required by
this change. If the intent is to record the improvement, that is a new claim for the manuscript
owner to decide on, not a repair. I propose no wording.

### 4. Undefined terminology in a header required to be self-contained (moderate)

Line 11 and line 42 both speak of "the six labelled golden axes" and line 10 of "the golden
conference matrix". Nothing in this module says what a golden axis is, so a reader holding only
the Lean artifact and the cited literature cannot resolve the phrase; the module in fact never uses
any property of the axes, only the integer table. AGENTS.md forbids relying on "as in the paper" or
a name as the only explanation. Repair: either add one clause fixing the six axes as a
mathematical object (the six-element index set carrying the two-graph, however the paper realizes
it), or drop "golden" and describe the object as what it is — the symmetric zero-diagonal
`±1` matrix of order six with `C² = 5I`, in the fixed row order `0,…,5`.

### 5. Three docstrings assert or imply more than the module proves (minor)

- Lines 107-108, `triangleSign`: "For a symmetric matrix it depends only on the underlying
  three-element set." No declaration in the module establishes invariance under the six
  permutations of `i, j, k`; `triangleSign_four_point` only uses symmetry inline for its own
  rewriting. The statement is true and cheap, but as written it is a comment implying a theorem
  Lean does not check. Either add the permutation lemma or restate as a convention note.
- Lines 169-171, `pairTriangleSum`: "Terms with repeated labels may be retained because a
  conference matrix has zero diagonal." The definition is over an arbitrary matrix and neither
  `pairTriangleSum_eq_mul_mulApply` nor `pairTriangleSum_eq_zero` assumes a zero diagonal — the
  full sum over `k` is simply the definition, and the diagonal only matters for the correspondence
  with the manuscript's `∑_{k≠i,j}`. Restate the remark as that correspondence.
- Line 213, `sq_eq_five_of_pairTriangleSum_eq_zero`: "the signed symmetric matrix axioms". In a
  module whose header makes a precise claim about its Lean axiom base, "axioms" here means
  hypotheses. Say "hypotheses".
- Line 13, "covariance of the triangle products … under diagonal sign changes" understates
  `triangleSign_switch` (line 256), which proves invariance, and under a weaker hypothesis than
  sign changes. Line 17's description of the four-point identity omits that the four labels must be
  pairwise distinct. `triangleCubic_neg` (line 275) is a terminal of the module and is named by
  none of the header's four categories on line 31.

### 6. Soundness and completeness of the three new proofs (no defect found; unverified by build)

- `conferenceMatrix_transpose` (52-54): `ext i j` reduces to entries; `fin_cases i <;> fin_cases j`
  is exhaustive over `Fin 6 × Fin 6` because `fin_cases` enumerates the full `Fintype` of `Fin 6`;
  the 36 residual goals close by `rfl` since `Matrix.transpose` is definitionally
  `of fun i j => M j i` and `Matrix.of` is definitionally the identity equivalence. This is the one
  step in the commit that leans on definitional unfolding of `Matrix.of`. A Mathlib change making
  `Matrix` opaque would break it — loudly, not silently, so this is a maintenance cost rather than
  a soundness risk. Using `decide` here too would remove the dependence at negligible cost and make
  the three proofs uniform.
- `conferenceMatrix_sq` (66-68): same exhaustive enumeration; each residual goal is a closed
  equation between two `ℤ` terms, decidable through `Int.instDecEq`, so `decide` is applied to a
  genuinely decidable closed proposition. The kernel must reduce `Matrix.mul_apply` through
  `dotProduct` and `Finset.sum` over `Fin 6` — a six-term sum of products of small literals per
  entry, 216 integer multiplications in total across the 36 goals. That is a trivial kernel load;
  the fragile part is not size but the reduction path: `5 • (1 : Matrix … ℤ)` is an `ℕ`-scalar
  `AddMonoid.nsmul`, so the kernel must unfold the `Int` additive-monoid instance's `nsmul` field,
  and `Finset.sum` must reduce through `Multiset`'s `Quot`. Both are standard and both fail loudly
  if Mathlib changes them.
- `conference_triangleSigns` (136-157): a closed conjunction of twenty decidable `ℤ` equations,
  each a product of three table entries. `decide` is appropriate and the domain is the complete set
  of twenty three-subsets of a six-element set, i.e. exhaustive, as the header says.
- No `native_decide`, `sorry`, `axiom`, `unsafe`, `opaque`, `partial`, `implemented_by`, or
  `extern` remains anywhere in the file. Nothing outside Mathlib is imported.

The header's concluding claim (lines 26-29) that the module's results rest only on `propext`,
`Classical.choice` and `Quot.sound` is a claim about actual `#print axioms` output. No committed
artifact currently witnesses it — the only axiom reports in the repository still show the native
axioms. Until the six dependent gates are rebuilt and the reports regenerated, that sentence is
unbacked. This is the reason the verdict is not a plain ACCEPT.

### 7. Statement preservation (no defect)

The commit's diff against this file consists of exactly four hunks: the module header, the proof
body of `conferenceMatrix_transpose`, the proof body of `conferenceMatrix_sq`, the proof body of
`conference_triangleSigns`, and one added docstring above the private
`cast_conference_triangleSign`. No `theorem`, `def`, or `private theorem` signature line is
touched; no name, namespace, universe, binder explicitness, or instance argument changes;
`namespace RelativeConicArcs` / `namespace ClebschGoldenConference` and both `end` lines are
unchanged. Nothing that `RelativeConicArcs.Gates.ClebschPassages`, `ClebschGoldenReturn`,
`FourShadowRecognition`, `ClebschRigidityTrust`, `GoldenCubicNodes` or `GoldenProofSpine` imports
can break on type grounds.

### 8. Shared-module risk (no defect)

- No import edge added or removed: the `import` block (lines 1-5) is outside every hunk, and
  `Mathlib.Tactic.FinCases` was already present. `decide` needs no import.
- No attribute added, no `@[simp]` lemma introduced, no instance declared, no `local` notation or
  `open` changed, so simp-normal forms and elaboration in every downstream file are untouched.
- No new declaration at all, so no name-resolution shadowing downstream.
- The only real cross-gate cost is rebuild-and-regenerate: the proof terms change, so every one of
  the six gates re-elaborates and every axiom report and closure digest in finding 1 must be
  regenerated in the same owning build window.

### 9. Author's list of statements stronger than the manuscript (item 5)

Manuscript baseline: `papers/clebsch-passages/sections/05-golden-operator.tex` works with
`C = Cᵀ` a zero-diagonal `±1` matrix of order `2d` with `C² = qI` over the reals, and states pair
balance at line 497-499 as `∑_{k≠i,j} (C_T)_{ij}(C_T)_{jk}(C_T)_{ki} = 0`, switching invariance and
the four-point identity at lines 500-502, and the orientation cubic at lines 445-451.

I agree with all ten of the author's items:

1. `conferenceMatrixOver_sq` (line 77) and `conference_pairTriangleSum_eq_zero` (line 243) are
   universally quantified over `(R : Type*) [CommRing R]` with no characteristic hypothesis, so
   they do cover characteristics 2 and 5. Note for the record that the content degenerates there
   (in characteristic 5 the square is zero, in characteristic 2 it is the identity); the statements
   remain true and the extra generality is real but mathematically thin.
2. `conference_triangleCubic_translate` (line 283) quantifies over the ring, over `x : Fin 6 → R`
   and over the shift `u : R`. Agree.
3. `triangleSign_switch` (line 256) and `triangleCubic_switch` (line 268) hypothesize only
   `∀ i, d i * d i = 1`, which in a general commutative ring is strictly weaker than `d i = ±1`.
   Agree.
4. `triangleSign_four_point` (line 337) assumes symmetry and `∀ i j, i ≠ j → C i j * C i j = 1`,
   with no zero-diagonal hypothesis and no `±1` restriction. Agree.
5. `pairTriangleSum_eq_zero` (line 201) takes the scalar `a : R` as a parameter rather than fixing
   it at five. Agree.
6. `pairTriangleSum_eq_mul_mulApply` (line 178) assumes only `C.transpose = C`. Agree.
7. `triangleCubic_neg` (line 275) has no hypothesis on `C` or `x`. Agree.
8. `switchMatrix` (line 103) and `triangleSign` (line 109) are defined under `[Mul R]`. Agree, with
   the caveat that no theorem in the module is stated at that generality — every consumer
   respecializes to `CommRing`, so the weaker class is currently unexercised.
9. `sq_eq_five_of_pairTriangleSum_eq_zero` (line 215) is over an arbitrary commutative ring and all
   four hypotheses appear in the proof: `hsymm` through `hsymm_apply` and `hpair`, `hdiag` and
   `hedge` in the diagonal branch (lines 229-231), `hedge` and `hbalance` in the off-diagonal
   branch (lines 234-238). Agree that all four are used; whether each is strictly non-removable is
   not something I can settle without elaboration, but the diagonal entry genuinely needs `hdiag`
   to kill the `k = i` term and `hedge` to make the remaining five terms one apiece, which is
   precisely where the constant five comes from.

Three the author missed:

10. `conferenceMatrixOver` (line 72) is defined for `[Ring R]`, not `[CommRing R]`, so the
    base-changed table itself exists over any ring; only the theorems about it need commutativity.
11. `triangleSign_switch` and `triangleCubic_switch` also drop every hypothesis on `C`: they hold
    for an arbitrary matrix, not merely a symmetric conference matrix. The author's item 3 records
    only the relaxation on `d`.
12. `pairTriangleSum_eq_zero` and `pairTriangleSum_eq_mul_mulApply` hold for an arbitrary matrix
    satisfying their stated hypotheses, with no zero diagonal, whereas the manuscript's pair-balance
    display is specifically about `C_T`.

One counterweight the list should carry, because as written it reads as uniform strengthening: every
statement in this module is fixed to the index type `Fin 6`, while the manuscript's four-point
identity, switching invariance and pair balance are stated for a symmetric conference matrix of
arbitrary order `2d`. `triangleSign_four_point`, `pairTriangleSum_eq_zero` and
`sq_eq_five_of_pairTriangleSum_eq_zero` are therefore stronger in ring generality and strictly
weaker in index generality than the corresponding manuscript sentences. Also, the Lean
`pairTriangleSum` sums over all `k`, not over `k ≠ i, j`; the two agree only when the diagonal
vanishes, which holds for `conferenceMatrixOver` but is not a hypothesis of the general lemmas.
Any claim of correspondence with the manuscript display must say so.

## Required follow-on edits

1. In the owning build window, rebuild all six dependent gates and regenerate, atomically with a
   commit: `papers/clebsch-passages/verification/golden_return_axioms.txt`,
   `passages_axioms.txt`, `four_shadow_axioms.txt`, the three matching `*_formal.json`, the three
   `*_source_closure.json`, and `lean/trust/facts/RelativeConicArcs.PaperIOrientationSpine.json`.
   Do not hand-patch an axiom report.
2. Rewrite `trust_boundary.native` in `golden_return_formal.json` and `passages_formal.json` per
   finding 1.
3. Fix the module header count at line 19 (finding 2) and define or drop "golden axes" at lines 11
   and 42 (finding 4).
4. Correct the four docstring items in finding 5 (lines 107-108, 169-171, 213, and the header's
   lines 13, 17, 31).
5. Consider replacing `rfl` by `decide` at line 54 to remove the module's only reliance on
   definitional unfolding of `Matrix.of`.
6. No manuscript edit is required by this change; finding 3 stands as a correction to the author's
   report, not a task for the tex owner.
