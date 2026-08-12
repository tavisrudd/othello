import Mathlib

/-!
# Finite parity-check code semantics

This module defines a linear code as the kernel of a finite parity-check map.
It also defines Hamming support, Hamming weight, and the finite support family
of coefficient words of a specified weight and syndrome.  All constructions are
over a finite index set; no geometric specialization or finite certificate is
used here.
-/

namespace TavisRuddFiniteGeom.Foundation.Coding

open Finset

section ParityCheck

variable {K W ι : Type*} [Field K] [DecidableEq K]
  [AddCommGroup W] [Module K W] [FiniteDimensional K W]
  [Fintype ι] [DecidableEq ι]

/-- The parity-check map with indexed columns `v`. -/
def parityCheckMap (v : ι → W) : (ι → K) →ₗ[K] W :=
  Fintype.linearCombination K v

/-- The linear code checked by the columns `v`. -/
def parityCheckCode (v : ι → W) : Submodule K (ι → K) :=
  LinearMap.ker (parityCheckMap v)

/-- The nonzero coordinate support of a word. -/
def hammingSupport (c : ι → K) : Finset ι :=
  Finset.univ.filter fun i => c i ≠ 0

/-- The Hamming weight of a word. -/
def hammingWeight (c : ι → K) : ℕ :=
  (hammingSupport c).card

section FiniteSyndromes

variable [Fintype K] [DecidableEq W]

/-- All coefficient words of weight `d` mapping to the syndrome `s`. -/
def syndromeLeadersOfWeight (v : ι → W) (s : W) (d : ℕ) : Finset (ι → K) :=
  Finset.univ.filter fun c =>
    hammingWeight c = d ∧ parityCheckMap (K := K) v c = s

/-- The supports occurring among coefficient words of weight `d` mapping to `s`. -/
def syndromeLeaderSupportsOfWeight (v : ι → W) (s : W) (d : ℕ) : Finset (Finset ι) :=
  (syndromeLeadersOfWeight (K := K) v s d).image hammingSupport

omit [FiniteDimensional K W] in
/-- Membership in the weight-`d` syndrome fibre is its defining conjunction. -/
@[simp] theorem mem_syndromeLeadersOfWeight {v : ι → W} {s : W} {d : ℕ} {c : ι → K} :
    c ∈ syndromeLeadersOfWeight (K := K) v s d ↔
      hammingWeight c = d ∧ parityCheckMap (K := K) v c = s := by
  simp [syndromeLeadersOfWeight]

omit [FiniteDimensional K W] in
/-- A finite set is a weight-`d` syndrome support precisely when a word realizes it. -/
@[simp] theorem mem_syndromeLeaderSupportsOfWeight {v : ι → W} {s : W} {d : ℕ}
    {S : Finset ι} :
    S ∈ syndromeLeaderSupportsOfWeight (K := K) v s d ↔
      ∃ c : ι → K, hammingWeight c = d ∧
        parityCheckMap (K := K) v c = s ∧ hammingSupport c = S := by
  simp [syndromeLeaderSupportsOfWeight, and_assoc]

end FiniteSyndromes

omit [DecidableEq ι] in
/-- The Hamming support of a word consists exactly of its nonzero coordinates. -/
@[simp] theorem mem_hammingSupport {c : ι → K} {i : ι} :
    i ∈ hammingSupport c ↔ c i ≠ 0 := by
  simp [hammingSupport]

omit [DecidableEq K] [FiniteDimensional K W] [DecidableEq ι] in
/-- A word lies in the parity-check code precisely when its column combination vanishes. -/
theorem mem_parityCheckCode_iff (v : ι → W) (c : ι → K) :
    c ∈ parityCheckCode (K := K) v ↔ ∑ i, c i • v i = 0 := by
  simp [parityCheckCode, parityCheckMap, LinearMap.mem_ker,
    Fintype.linearCombination_apply]

end ParityCheck

end TavisRuddFiniteGeom.Foundation.Coding
