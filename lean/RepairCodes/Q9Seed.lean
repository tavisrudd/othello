import RepairCodes.Transfer

/-!
# Consistency witness for the transfer interface (`RepairCodes` Phase 1, decision-1 guard)

Plan §5 decision 1 requires the abstract `ConcatDualWord` interface to be
inhabited by a concrete instance, so that `transfer_lemma` is not vacuous. This
file supplies a **consistency witness**: it establishes only that the hypotheses
are jointly satisfiable and that the single-block conclusion is witnessed by an
actual nonzero block (card `= 1`, not `0`). It is **not** the real `q = 9` seed
and does **not** make the transfer lemma unconditional.

Two notes for a reviewer:

* Any instance satisfying the hypotheses necessarily has every block inner-dual —
  that is exactly `transfer_blockwise`. So a *satisfying* witness cannot exercise
  the `exfalso` branch of `transfer_blockwise`: that branch characterizes
  configurations the hypotheses rule out, not ones a witness can realize.
* `innerDual` / `blockWt` here are a toy stand-in over `ℕ`, not the `𝔽₉` code;
  the witness tests the interface's shape, not any coding-theoretic content.

## The real `q = 9` obligation (tracked, not discharged)

Instantiate `ConcatDualWord` with the inner seed `C₀ = C_{3,2} = [10,4,6]_9`
(all-symbol locality `3`, `d(C₀⊥) = 4`) over an `𝔽₉`-linear outer code `O_N` with
`d(O_N⊥) ≥ 5`, giving `dI = 4`, `dO = 5`, `s = 4`. Discharging `hbeta` / `houter`
needs the trace-form nondegeneracy and the Chen–Ling–Xing dual decomposition on
the concrete `FiniteGeom` code layer (not yet built). Only then does the
`(ν,τ) = (3,5)` distinguished coordinate + nine `(1,1)` coordinates
(`1/10 : 9/10` distribution) follow.
-/

namespace RepairCodes

open Finset

/-- Toy two-block consistency witness for `ConcatDualWord`: block `0` is a
nonzero weight-`4` inner-dual word, block `1` is zero. Here
`innerDual b := b = 0 ∨ 4 ≤ b` stands in for "`b` is `0` or has weight `≥ d(I⊥)`",
`dI = 4`, `dO = 5`, budget `s = 4`. Both `4 < 5` and `4 < 8` hold. -/
def q9SeedToy : ConcatDualWord (Fin 2) ℕ ℕ where
  w := ![4, 0]
  beta := fun _ => 0
  blockWt := id
  innerDual := fun b => b = 0 ∨ 4 ≤ b
  dI := 4
  dO := 5
  s := 4
  innerDual_zero := Or.inl rfl
  blockWt_eq_zero := fun _ => Iff.rfl
  hbeta := by intro j; fin_cases j <;> simp
  houter := Or.inl (fun _ => rfl)
  hdist := by intro b hb hb0; show 4 ≤ b; rcases hb with h | h <;> omega
  htot := by decide
  hsO := by decide

/-- The interface is inhabited and the transfer conclusion is nontrivial: the
witness has every block inner-dual and exactly one nonzero block (card `= 1`). -/
example :
    (∀ j, q9SeedToy.innerDual (q9SeedToy.w j)) ∧
      (univ.filter (fun j => q9SeedToy.w j ≠ 0)).card ≤ 1 :=
  transfer_lemma q9SeedToy (by decide)

end RepairCodes
