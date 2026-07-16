import RelativeConicArcs.Q25MinimumChecker

/-!
# Compact masks for the exact Q25 repair minimum

This file separates the cheap count layer from the determinant layer.  A generated certificate
stores `310` orbit bits in five little-endian `64`-bit words.  Its soundness field may be assembled
from small determinant-checking leaves; the final cardinality theorem only manipulates the literal
mask and never unfolds `ReflectedLegal` over all candidates at once.
-/

namespace RelativeConicArcs
namespace Q25MinimumMask

open Q25Coordinates Q25PairCertificate Q25OrbitDecomposition Q25MinimumChecker

/-- Five little-endian words cover the `310` stable orbit numbers; the last two bits are padding. -/
abbrev OrbitMask := Fin 5 → Nat

def orbitNumberFin (o : OrbitCode) : Fin 310 := ⟨orbitNumber o, orbitNumber_lt o⟩

def wordIndex (n : Fin 310) : Fin 5 := ⟨n.val / 64, by omega⟩

def maskBit (mask : OrbitMask) (n : Fin 310) : Bool :=
  (mask (wordIndex n)).testBit (n.val % 64)

def maskOrbitSet (mask : OrbitMask) : Finset OrbitCode :=
  Finset.univ.filter fun o => maskBit mask (orbitNumberFin o) = true

def legalOrbitSet (S : Finset Idx25) : Finset OrbitCode :=
  Finset.univ.filter (LegalPair S)

theorem normalizedConfig_isConjInvariant (a b c : OrbitCode) :
    IsConjInvariant (normalizedConfig a b c) := by
  intro i hi
  have hfixed (h : i ∈ fixedPair) : conjIdx i ∈ fixedPair := by
    simp only [fixedPair, Finset.mem_insert, Finset.mem_singleton] at h ⊢
    rcases h with rfl | rfl
    · exact Or.inl rfl
    · exact Or.inr (by simp only [conjIdx, conj_zero])
  have hpair (o : OrbitCode) (h : i ∈ orbitPair o) : conjIdx i ∈ orbitPair o := by
    simp only [orbitPair, Finset.mem_insert, Finset.mem_singleton] at h ⊢
    rcases h with rfl | rfl
    · exact Or.inr rfl
    · rw [conjIdx_involutive]
      exact Or.inl rfl
  simp only [normalizedConfig, Finset.mem_union] at hi ⊢
  rcases hi with ((h | h) | h) | h
  · exact Or.inl (Or.inl (Or.inl (hfixed h)))
  · exact Or.inl (Or.inl (Or.inr (hpair a h)))
  · exact Or.inl (Or.inr (hpair b h))
  · exact Or.inr (hpair c h)

/-- A compact lower-bound certificate.  Generated leaves prove only the set bits sound; the
literal-mask cardinality is a small independent reduction. -/
structure ReflectedMaskCertificate (S : Finset Idx25) (mask : OrbitMask) : Prop where
  card_le : 32 ≤ (maskOrbitSet mask).card
  sound : ∀ n : Fin 310, maskBit mask n = true →
    ReflectedLegal S (orbitCodeOfNumber n)

/-- Sound mask bits inject into the actual legal-pair set. -/
theorem card_legalOrbitSet_ge_32 {S : Finset Idx25} {mask : OrbitMask}
    (hInv : IsConjInvariant S) (cert : ReflectedMaskCertificate S mask) :
    32 ≤ (legalOrbitSet S).card := by
  apply cert.card_le.trans
  apply Finset.card_le_card
  intro o ho
  have hbit : maskBit mask (orbitNumberFin o) = true :=
    (Finset.mem_filter.mp ho).2
  have hreflected : ReflectedLegal S o := by
    simpa [orbitNumberFin] using cert.sound (orbitNumberFin o) hbit
  exact Finset.mem_filter.mpr
    ⟨Finset.mem_univ o, (legalPair_iff_reflectedLegal hInv o).2 hreflected⟩

end Q25MinimumMask
end RelativeConicArcs
