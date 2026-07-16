import RelativeConicArcs.Q25OrbitDecomposition

/-!
# Reflected obstruction checker for exact Q25 repair counts

This C151 rules module factors a conjugate-pair legality check into the two geometric obstruction
families used by the compact certificate: secants of the old cap and the fixed carrier of the
candidate pair.  It imports the stable C143 checker but does not invalidate its generated leaves.
-/

namespace RelativeConicArcs
namespace Q25MinimumChecker

open Q25Coordinates Q25PairCertificate Q25OrbitDecomposition FiniteFields

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

/-- Conjugating all three rows conjugates the determinant. -/
theorem det_conjIdx (a b c : Idx25) :
    conj (Matrix.det ![vec a, vec b, vec c]) =
      Matrix.det ![vec (conjIdx a), vec (conjIdx b), vec (conjIdx c)] := by
  let M : Matrix (Fin 3) (Fin 3) K25 := ![vec a, vec b, vec c]
  let Mc : Matrix (Fin 3) (Fin 3) K25 :=
    ![vec (conjIdx a), vec (conjIdx b), vec (conjIdx c)]
  change conjRingEquiv (Matrix.det M) = Matrix.det Mc
  rw [RingEquiv.map_det]
  apply congrArg Matrix.det
  ext i j
  fin_cases i
  · change conjRingEquiv (vec a j) = vec (conjIdx a) j
    exact (congrFun (vec_conjIdx a) j).symm
  · change conjRingEquiv (vec b j) = vec (conjIdx b) j
    exact (congrFun (vec_conjIdx b) j).symm
  · change conjRingEquiv (vec c j) = vec (conjIdx c) j
    exact (congrFun (vec_conjIdx c) j).symm

/-- For an invariant old configuration, avoiding its secants is conjugation-invariant. -/
theorem rawExtension_conj {S : Finset Idx25} (hInv : IsConjInvariant S) {x : Idx25}
    (h : RawExtension S x) : RawExtension S (conjIdx x) := by
  intro a ha b hb hab hzero
  have hca : conjIdx a ∈ S := hInv a ha
  have hcb : conjIdx b ∈ S := hInv b hb
  have hcab : conjIdx a ≠ conjIdx b := by
    intro hc
    apply hab
    have := congrArg conjIdx hc
    rw [conjIdx_involutive, conjIdx_involutive] at this
    exact this
  apply h (conjIdx a) hca (conjIdx b) hcb hcab
  have hc := congrArg conj hzero
  rw [conj_zero, det_conjIdx, conjIdx_involutive] at hc
  exact hc

/-- The compact obstruction predicate: the candidate pair is fresh, one representative avoids
every old secant, and its conjugation-fixed carrier avoids every old point. -/
def ReflectedLegal (S : Finset Idx25) (o : OrbitCode) : Prop :=
  PairFresh S o ∧
    RawExtension S (orbitIdx o) ∧
    ∀ a ∈ S,
      Matrix.det ![vec (orbitIdx o), vec a, vec (conjIdx (orbitIdx o))] ≠ 0

instance (S : Finset Idx25) (o : OrbitCode) : Decidable (ReflectedLegal S o) := by
  unfold ReflectedLegal PairFresh
  infer_instance

/-- On an invariant configuration, `LegalPair` is exactly the complement of the secant and carrier
obstruction masks.  No cap hypothesis is needed for this predicate-level equivalence. -/
theorem legalPair_iff_reflectedLegal {S : Finset Idx25} (hInv : IsConjInvariant S)
    (o : OrbitCode) : LegalPair S o ↔ ReflectedLegal S o := by
  let p := orbitIdx o
  let q := conjIdx p
  have hpq : p ≠ q := by
    intro hpq
    have hr := congrArg rank hpq
    exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr
  constructor
  · intro h
    refine ⟨h.pairFresh, h.2.1, ?_⟩
    intro a ha
    exact h.2.2.2 p (by simp [p]) a (Finset.mem_insert_of_mem ha)
      (fun hpa => by subst a; exact h.1 ha)
  · rintro ⟨hfresh, hpExt, hcarrier⟩
    have hpS : p ∉ S := by
      intro hp
      exact (Finset.disjoint_left.mp hfresh hp) (by simp [orbitPair, p])
    have hqS : q ∉ S := by
      intro hq
      exact (Finset.disjoint_left.mp hfresh hq) (by simp [orbitPair, p, q])
    have hqExt : RawExtension S q := by
      exact rawExtension_conj hInv hpExt
    refine ⟨hpS, hpExt, ?_, ?_⟩
    · simp [p, q, hpq.symm, hqS]
    · intro a ha b hb hab
      simp only [Finset.mem_insert] at ha hb
      rcases ha with rfl | ha <;> rcases hb with rfl | hb
      · exact False.elim (hab rfl)
      · exact hcarrier b hb
      · intro hz
        apply hcarrier a ha
        have hswap :
            Matrix.det ![vec a, vec p, vec q] =
              -Matrix.det ![vec p, vec a, vec q] := by
          simp [Matrix.det_fin_three]
          ring
        rw [hswap] at hz
        exact neg_eq_zero.mp hz
      · exact hqExt a ha b hb hab

end Q25MinimumChecker
end RelativeConicArcs
