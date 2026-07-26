import RelativeConicArcs.MatchingDesignRigidity

/-!
# Local conductor constraints for square-root carriers

Let three lines through one point have tangent directions `v i`, and choose coefficients `c i`
for a linear relation among those directions.  If degree-`m` sections on the lines are restrictions
of one local section, their directional derivatives are evaluations of one linear functional.
The weighted derivative sum must therefore vanish.  In characteristic two, its square is the
corresponding weighted sum of second Hasse coefficients.

The final result records the deletion consequence of an independently established arc bound for a
finite carrier set.  It does not construct the dual Chow product, prove that its line restrictions
are squares, or formalize the global extension of compatible roots across a line arrangement.
-/

namespace RelativeConicArcs

open Finset

section LocalConductor

variable {K V : Type*} [CommRing K] [AddCommGroup V] [Module K V]

/-- The first conductor coordinate of three linewise jets whose tangent directions satisfy a
chosen linear relation. -/
def carrierConductor (c d : Fin 3 → K) : K :=
  ∑ i, c i * d i

/-- Derivatives obtained from one linear jet satisfy the first conductor compatibility equation. -/
theorem carrierConductor_eq_zero_of_linearJet
    (v : Fin 3 → V) (c d : Fin 3 → K)
    (hrel : ∑ i, c i • v i = 0)
    (φ : V →ₗ[K] K) (hd : ∀ i, d i = φ (v i)) :
    carrierConductor c d = 0 := by
  calc
    carrierConductor c d = ∑ i, c i * φ (v i) := by
      unfold carrierConductor
      apply Finset.sum_congr rfl
      intro i hi
      rw [hd i]
    _ = φ (∑ i, c i • v i) := by
      rw [map_sum]
      apply Finset.sum_congr rfl
      intro i hi
      simp
    _ = 0 := by simp [hrel]

/-- Rescaling each tangent-direction representative and inversely rescaling its relation
coefficient leaves the conductor coordinate unchanged. -/
theorem carrierConductor_eq_of_rescale
    (c d c' d' s : Fin 3 → K)
    (hc : ∀ i, c' i * s i = c i)
    (hd : ∀ i, d' i = s i * d i) :
    carrierConductor c' d' = carrierConductor c d := by
  unfold carrierConductor
  apply Finset.sum_congr rfl
  intro i hi
  rw [hd i, ← mul_assoc, hc i]

/-- Adding the derivative of one common local change of trivialization alters the conductor
coordinate only by its common scalar factor. -/
theorem carrierConductor_change_of_trivialization
    (v : Fin 3 → V) (c d : Fin 3 → K)
    (hrel : ∑ i, c i • v i = 0)
    (φ : V →ₗ[K] K) (a z : K) :
    carrierConductor c (fun i => a * d i + z * φ (v i)) =
      a * carrierConductor c d := by
  unfold carrierConductor
  calc
    ∑ i, c i * (a * d i + z * φ (v i)) =
        a * ∑ i, c i * d i + z * ∑ i, c i * φ (v i) := by
      simp only [mul_add, Finset.sum_add_distrib, Finset.mul_sum]
      apply congrArg₂ (· + ·)
      · apply Finset.sum_congr rfl
        intro i hi
        ring
      · apply Finset.sum_congr rfl
        intro i hi
        ring
    _ = a * ∑ i, c i * d i + z * φ (∑ i, c i • v i) := by
      congr 2
      rw [map_sum]
      apply Finset.sum_congr rfl
      intro i hi
      simp
    _ = a * ∑ i, c i * d i := by simp [hrel]

/-- A change of local trivialization with nonzero common scalar preserves whether the conductor
coordinate vanishes. -/
theorem carrierConductor_change_of_trivialization_eq_zero_iff
    [NoZeroDivisors K]
    (v : Fin 3 → V) (c d : Fin 3 → K)
    (hrel : ∑ i, c i • v i = 0)
    (φ : V →ₗ[K] K) (a z : K) (ha : a ≠ 0) :
    carrierConductor c (fun i => a * d i + z * φ (v i)) = 0 ↔
      carrierConductor c d = 0 := by
  rw [carrierConductor_change_of_trivialization v c d hrel φ a z]
  simp [ha]

/-- In characteristic two, the square of the first conductor coordinate is the weighted sum of
the squares of its three derivative values. -/
theorem carrierConductor_sq
    [CharP K 2] (c d : Fin 3 → K) :
    carrierConductor c d ^ 2 = ∑ i, c i ^ 2 * d i ^ 2 := by
  have htwo : (2 : K) = 0 := by
    exact CharP.cast_eq_zero K 2
  have hadd_sq (a b : K) : (a + b) ^ 2 = a ^ 2 + b ^ 2 := by
    calc
      (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by ring
      _ = a ^ 2 + b ^ 2 := by rw [htwo]; ring
  simp [carrierConductor, Fin.sum_univ_three, hadd_sq, mul_pow]

/-- If the squared linewise derivatives are prescribed second Hasse coefficients, the squared
conductor coordinate is their relation-weighted sum. -/
theorem carrierConductor_sq_eq_hasse
    [CharP K 2] (c d q : Fin 3 → K)
    (hq : ∀ i, d i ^ 2 = q i) :
    carrierConductor c d ^ 2 = ∑ i, c i ^ 2 * q i := by
  rw [carrierConductor_sq]
  apply Finset.sum_congr rfl
  intro i hi
  rw [hq i]

/-- After the common-value conditions at an ordinary `s`-fold line intersection, the remaining
number of normalization-conductor coordinates is `choose (s - 1) 2`. -/
theorem localConductorCoordinateCount (s : ℕ) (hs : 1 ≤ s) :
    Nat.choose s 2 - (s - 1) = Nat.choose (s - 1) 2 := by
  obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt hs)
  rw [Nat.choose_succ_succ]
  simp

end LocalConductor

section CarrierDeletion

variable {P L : Type*} [Membership P L] [DecidableEq P]

/-- Every arc contained in `X` has cardinality at most `k`. -/
def ArcSubsetsBoundedBy (X : Finset P) (k : ℕ) : Prop :=
  ∀ Y : Finset P, Y ⊆ X → Arc (L := L) Y → Y.card ≤ k

/-- If every arc in `X` has size at most `k`, deleting points until the remainder is an arc removes
at least `X.card - k` points. -/
theorem card_sub_le_of_sdiff_arc
    {X D : Finset P} {k : ℕ}
    (hbound : ArcSubsetsBoundedBy (L := L) X k)
    (hD : D ⊆ X) (harc : Arc (L := L) (X \ D)) :
    X.card - k ≤ D.card := by
  have hremaining : (X \ D).card ≤ k :=
    hbound (X \ D) Finset.sdiff_subset harc
  rw [Finset.card_sdiff_of_subset hD] at hremaining
  omega

/-- Additive form of the carrier deletion bound. -/
theorem card_le_card_add_of_sdiff_arc
    {X D : Finset P} {k : ℕ}
    (hbound : ArcSubsetsBoundedBy (L := L) X k)
    (hD : D ⊆ X) (harc : Arc (L := L) (X \ D)) :
    X.card ≤ D.card + k := by
  have hremaining : (X \ D).card ≤ k :=
    hbound (X \ D) Finset.sdiff_subset harc
  rw [Finset.card_sdiff_of_subset hD] at hremaining
  omega

end CarrierDeletion

section FiniteCover

variable {α β : Type*} [DecidableEq α]

/-- If a finite family of fibers covers a finite set and every fiber has size at most `c`, then the
covered set has size at most the number of fibers times `c`.  This is the double-counting kernel
used when each large carrier subset is assigned a collinear triple. -/
theorem card_le_card_mul_of_biUnion_cover
    (large : Finset α) (witnesses : Finset β) (fiber : β → Finset α) (c : ℕ)
    (hcover : large ⊆ witnesses.biUnion fiber)
    (hcap : ∀ b ∈ witnesses, (fiber b).card ≤ c) :
    large.card ≤ witnesses.card * c := by
  calc
    large.card ≤ (witnesses.biUnion fiber).card :=
      Finset.card_le_card hcover
    _ ≤ ∑ b ∈ witnesses, (fiber b).card :=
      Finset.card_biUnion_le
    _ ≤ ∑ _b ∈ witnesses, c := by
      apply Finset.sum_le_sum
      intro b hb
      exact hcap b hb
    _ = witnesses.card * c := by simp

end FiniteCover

end RelativeConicArcs
