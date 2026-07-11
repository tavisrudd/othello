import RepairCodes.Transfer

/-!
# Discharging the transfer interface (`RepairCodes` Phase 1, decision-1 guard)

Plan §5, decision 1 requires the abstract `ConcatDualWord` interface to be
*discharged by at least one concrete instance*, else the transfer lemma is
vacuous. This file provides a concrete witness now (so the interface is proven
inhabitable and the `transfer_lemma` conclusion is nontrivial) and records the
full `q = 9` seed obligation as the tracked Phase-1 follow-through.

## Toy witness

A two-block configuration over `ℕ`: block `0` is a nonzero inner-dual word of
weight `4`, block `1` is zero. Here `innerDual b := b = 0 ∨ 4 ≤ b` models "`b`
is either zero or has weight `≥ d(I⊥) = 4`", `dI = 4`, `dO = 5`, budget `s = 4`.
Both bounds `4 < 5` and `4 < 8` hold, so `transfer_lemma` applies and returns a
*nontrivial* single-block verdict (exactly one nonzero block, not zero).

## The real `q = 9` obligation (tracked, not yet discharged)

Instantiate `ConcatDualWord` with the inner seed `C₀ = C_{3,2} = [10,4,6]_9`,
all-symbol locality `3`, `d(C₀⊥) = 4`, over an `𝔽₉`-linear outer code `O_N` with
`d(O_N⊥) ≥ 5` (so `dI = 4`, `dO = 5`, `s = 4`). Discharging `hbeta`/`houter`
then needs the real trace-form nondegeneracy and Chen–Ling–Xing dual
decomposition — that is the concrete `FiniteGeom` code layer, built next. When
that lands, the `(ν,τ) = (3,5)` distinguished coordinate and nine `(1,1)`
coordinates give the `1/10` : `9/10` invariant distribution the sweep claims.
-/

namespace RepairCodes

open Finset

/-- Toy two-block witness discharging `ConcatDualWord`: one nonzero weight-4
inner-dual block and one zero block. -/
def q9SeedToy : ConcatDualWord (Fin 2) ℕ ℕ where
  w := ![4, 0]
  beta := fun _ => 0
  blockWt := id
  innerDual := fun b => b = 0 ∨ 4 ≤ b
  dI := 4
  dO := 5
  s := 4
  hpos := by intro b hb; simp only [not_or, not_le] at hb; show 1 ≤ b; omega
  hbeta := by intro j; fin_cases j <;> simp
  houter := Or.inl (fun _ => rfl)
  hdist := by intro b hb hb0; show 4 ≤ b; rcases hb with h | h <;> omega
  htot := by decide
  hsO := by decide

/-- The interface is inhabited and the transfer conclusion is nontrivial: the
toy witness has all blocks inner-dual and exactly one nonzero block. -/
example :
    (∀ j, q9SeedToy.innerDual (q9SeedToy.w j)) ∧
      (univ.filter (fun j => q9SeedToy.w j ≠ 0)).card ≤ 1 :=
  transfer_lemma q9SeedToy (by decide)

end RepairCodes
