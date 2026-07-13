import RelativeConicArcs.CodingBridge
import RelativeConicArcs.Q11Residual

/-!
# Transparent q=11 affine-syndrome definitions

This small base module is shared by split kernel certificates.  The public semantic synthesis is
in `Q11Coding.lean`; splitting the finite tables prevents their reduction terms from accumulating
in one Lean process.
-/

namespace RelativeConicArcs.Examples.Q11Coding

open Certificate Q11Residual Matrix

set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- The witness vectors in list order. -/
def witnessVec (i : Fin 6) : Vec (ZMod 11) :=
  (q11Witness.get i).1

/-- Canonical representatives of all 133 projective points. -/
def projectiveVec (i : Fin 133) : Vec (ZMod 11) :=
  if _h₁ : i.1 < 121 then
    ![1, ((i.1 / 11 : ℕ) : ZMod 11), ((i.1 % 11 : ℕ) : ZMod 11)]
  else if _h₂ : i.1 < 132 then
    ![0, 1, ((i.1 - 121 : ℕ) : ZMod 11)]
  else ![0, 0, 1]

theorem projectiveVec_ne_zero (i : Fin 133) : projectiveVec i ≠ 0 := by
  unfold projectiveVec
  split_ifs <;> simp

abbrev NonzeroScalar := {a : ZMod 11 // a ≠ 0}
abbrev AffineRay := Fin 133 × NonzeroScalar

def affineRayVec (p : AffineRay) : Vec (ZMod 11) :=
  p.2.1 • projectiveVec p.1

theorem affineRayVec_ne_zero (p : AffineRay) : affineRayVec p ≠ 0 :=
  smul_ne_zero p.2.2 (projectiveVec_ne_zero p.1)

def affineRayOfVec (s : {s : Vec (ZMod 11) // s ≠ 0}) : AffineRay :=
  if h₀ : s.1 0 ≠ 0 then
    (⟨(s.1 1 / s.1 0).val * 11 + (s.1 2 / s.1 0).val, by
        have h₁ := (s.1 1 / s.1 0).val_lt
        have h₂ := (s.1 2 / s.1 0).val_lt
        omega⟩, ⟨s.1 0, h₀⟩)
  else if h₁ : s.1 1 ≠ 0 then
    (⟨121 + (s.1 2 / s.1 1).val, by
        have h₂ := (s.1 2 / s.1 1).val_lt
        omega⟩, ⟨s.1 1, h₁⟩)
  else
    (⟨132, by omega⟩, ⟨s.1 2, by
      intro h₂
      apply s.2
      funext i
      fin_cases i <;> simp_all⟩)

def oneWord (i : Fin 6) (a : ZMod 11) : Fin 6 → ZMod 11 :=
  fun j => if j = i then a else 0

def twoWord (i j : Fin 6) (a b : ZMod 11) : Fin 6 → ZMod 11 :=
  fun k => if k = i then a else if k = j then b else 0

theorem oneWord_syndrome (i : Fin 6) (a : ZMod 11) :
    CodingBridge.parityCheckMap (K := ZMod 11) witnessVec (oneWord i a) =
      a • witnessVec i := by
  classical
  simp [CodingBridge.parityCheckMap, Fintype.linearCombination_apply, oneWord]

theorem oneWord_weight (i : Fin 6) {a : ZMod 11} (ha : a ≠ 0) :
    CodingBridge.hammingWeight (oneWord i a) = 1 := by
  have hs : CodingBridge.hammingSupport (oneWord i a) = {i} := by
    ext j
    simp [CodingBridge.mem_hammingSupport, oneWord, ha]
  simp [CodingBridge.hammingWeight, hs]

theorem twoWord_syndrome {i j : Fin 6} (hij : i ≠ j) (a b : ZMod 11) :
    CodingBridge.parityCheckMap (K := ZMod 11) witnessVec (twoWord i j a b) =
      a • witnessVec i + b • witnessVec j := by
  fin_cases i <;> fin_cases j <;>
    simp_all [CodingBridge.parityCheckMap, Fintype.linearCombination_apply, twoWord,
      Fin.sum_univ_succ, add_comm]

theorem twoWord_weight {i j : Fin 6} (hij : i ≠ j) {a b : ZMod 11}
    (ha : a ≠ 0) (hb : b ≠ 0) :
    CodingBridge.hammingWeight (twoWord i j a b) = 2 := by
  have hs : CodingBridge.hammingSupport (twoWord i j a b) = {i, j} := by
    ext k
    fin_cases i <;> fin_cases j <;> fin_cases k <;>
      simp_all [CodingBridge.mem_hammingSupport, twoWord]
  simp [CodingBridge.hammingWeight, hs, hij]

theorem twoWord_support {i j : Fin 6} (hij : i ≠ j) {a b : ZMod 11}
    (ha : a ≠ 0) (hb : b ≠ 0) :
    CodingBridge.hammingSupport (twoWord i j a b) = {i, j} := by
  ext k
  fin_cases i <;> fin_cases j <;> fin_cases k <;>
    simp_all [CodingBridge.mem_hammingSupport, twoWord]

def witnessPairs : Finset (Fin 6 × Fin 6) :=
  Finset.univ.filter fun e => e.1 < e.2

def rawPointIndex (x : Vec (ZMod 11)) : ℕ :=
  (witnessPairs.filter fun e => Matrix.det ![x, witnessVec e.1, witnessVec e.2] = 0).card

def canonicalSyndromeDistance (i : Fin 133) : ℕ :=
  if rawPointIndex (projectiveVec i) = 5 then 1
  else if rawPointIndex (projectiveVec i) = 0 then 3
  else 2

def affineRaysOfDistance (d : ℕ) : Finset AffineRay :=
  Finset.univ.filter fun p => canonicalSyndromeDistance p.1 = d

def affineSyndromesOfDistance (d : ℕ) : Finset (Vec (ZMod 11)) :=
  (affineRaysOfDistance d).image affineRayVec

end RelativeConicArcs.Examples.Q11Coding
