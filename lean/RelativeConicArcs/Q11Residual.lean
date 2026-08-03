import RelativeConicArcs.ExampleChecks.Q11
import CapGame.GraphMirror
import RelativeConicArcs.CapGameHoleLocalization

/-!
# The residual game of the `q = 11` relative-conic witness

The six-point witness `Examples.q11Witness` leaves all twelve points of the standard conic
available.  Two conic points conflict when they and one witness point are collinear.  This file
records that finite residual directly on `Fin 12`, identifies it with the standard icosahedral
graph, and proves that its independent-set building game is P by an explicit antipodal mirror.

The determinant and finite-table statements are discharged by kernel reduction.  The game-value
conclusion is not an exhaustive game-tree computation: it is an application of the generic
fixed-point-free conflict-graph mirror theorem.
-/

namespace RelativeConicArcs
namespace Examples
namespace Q11Residual

open Certificate ConflictGraph

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype (Conic.Point (ZMod 11)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 11)) := Classical.decEq _

/-- The twelve standard-conic representatives, ordered by the eleven affine parameters followed
by the point at infinity. -/
def conicVec (i : Fin 12) : Vec (ZMod 11) :=
  if i.1 < 11 then ![1, (i.1 : ZMod 11), (i.1 : ZMod 11) ^ 2] else ![0, 0, 1]

/-- No conic parameter is covered by a secant of two distinct witness points.  Thus every one of
the twelve conic points is initially live after the witness is occupied. -/
def SeedLegal (i : Fin 12) : Prop :=
  ∀ a ∈ q11Witness, ∀ b ∈ q11Witness, rayEq a.1 b.1 = false →
    Matrix.det ![conicVec i, a.1, b.1] ≠ 0

instance (i : Fin 12) : Decidable (SeedLegal i) := by
  unfold SeedLegal
  infer_instance

theorem all_seed_legal : ∀ i : Fin 12, SeedLegal i := by decide

theorem seed_rawArc : RawArc q11Witness :=
  (check_rawValid q11_check).2.1

/-- The twelve displayed conic vectors represent distinct projective points. -/
theorem conic_parameters_distinct :
    ∀ i j : Fin 12, i ≠ j → rayEq (conicVec i) (conicVec j) = false := by
  decide

theorem conicVec_ne_zero (i : Fin 12) : conicVec i ≠ 0 := by
  fin_cases i <;> decide

/-- The displayed vector as a raw projective point. -/
def conicRaw (i : Fin 12) : RawPoint (ZMod 11) :=
  ⟨conicVec i, conicVec_ne_zero i⟩

/-- The displayed standard-conic point. -/
def conicPoint (i : Fin 12) : Conic.Point (ZMod 11) :=
  toPoint (conicRaw i)

/-- The twelve displayed parameters embed in the projective plane. -/
def conicEmbedding : Fin 12 ↪ Conic.Point (ZMod 11) where
  toFun := conicPoint
  inj' := by
    intro i j hij
    by_contra hne
    have hray : RayEq (conicVec i) (conicVec j) :=
      (rayEq_iff_mk_eq (conicRaw i) (conicRaw j)).mpr hij
    have htrue : rayEq (conicVec i) (conicVec j) = true :=
      (rayEq_eq_true_iff _ _).mpr hray
    rw [conic_parameters_distinct i j hne] at htrue
    contradiction

theorem conicPoint_mem_standardConic (i : Fin 12) :
    conicPoint i ∈ Conic.standardConic (K := ZMod 11) := by
  rw [Conic.mem_standardConic_iff_onConic]
  exact (ProjectiveCap.Sym2Bridge.onConic_mk (conicVec i) (conicVec_ne_zero i)).mpr (by
    fin_cases i <;> decide)

/-- The explicit twelve-point parameterization has exactly the standard conic as its range. -/
theorem conicEmbedding_range (x : Conic.Point (ZMod 11)) :
    x ∈ Conic.standardConic (K := ZMod 11) ↔ ∃ i : Fin 12, conicEmbedding i = x := by
  classical
  let R : Finset (Conic.Point (ZMod 11)) := Finset.univ.map conicEmbedding
  have hsub : R ⊆ Conic.standardConic (K := ZMod 11) := by
    intro p hp
    obtain ⟨i, _hi, rfl⟩ := Finset.mem_map.mp hp
    exact conicPoint_mem_standardConic i
  have hcardR : R.card = 12 := by simp [R]
  have hcardC : (Conic.standardConic (K := ZMod 11)).card = 12 := by
    simpa using Conic.standardConic_card (K := ZMod 11)
  have heq : R = Conic.standardConic (K := ZMod 11) :=
    Finset.eq_of_subset_of_card_le hsub (by omega)
  rw [← heq]
  simp [R]

/-- No three distinct displayed conic parameters are collinear. -/
theorem conic_triples_legal :
    ∀ i j k : Fin 12, i ≠ j → i ≠ k → j ≠ k →
      Matrix.det ![conicVec i, conicVec j, conicVec k] ≠ 0 := by
  decide

/-- The selected indices in their canonical finite order. -/
def selectedIndices (S : Finset (Fin 12)) : List (Fin 12) :=
  (List.ofFn fun i : Fin 12 => i).filter fun i => i ∈ S

/-- Raw representatives for the seed followed by a selected residual parameter set. -/
def continuationRaw (S : Finset (Fin 12)) : List (RawPoint (ZMod 11)) :=
  q11Witness ++ (selectedIndices S).map conicRaw

theorem pointSet_continuation (S : Finset (Fin 12)) :
    pointSet (continuationRaw S) =
      pointSet q11Witness ∪ S.map conicEmbedding := by
  classical
  ext p
  rw [mem_pointSet, Finset.mem_union]
  constructor
  · rintro ⟨v, hv, rfl⟩
    rcases List.mem_append.mp hv with hvSeed | hvConic
    · exact Or.inl (mem_pointSet.mpr ⟨v, hvSeed, rfl⟩)
    · obtain ⟨i, hiSelected, rfl⟩ := List.mem_map.mp hvConic
      have hiS : i ∈ S := of_decide_eq_true (List.mem_filter.mp hiSelected).2
      exact Or.inr (Finset.mem_map.mpr ⟨i, hiS, rfl⟩)
  · rintro (hpSeed | hpConic)
    · obtain ⟨v, hvSeed, rfl⟩ := mem_pointSet.mp hpSeed
      exact ⟨v, List.mem_append_left _ hvSeed, rfl⟩
    · obtain ⟨i, hiS, rfl⟩ := Finset.mem_map.mp hpConic
      refine ⟨conicRaw i, List.mem_append_right _ (List.mem_map.mpr ⟨i, ?_, rfl⟩), rfl⟩
      exact List.mem_filter.mpr ⟨List.mem_ofFn.mpr ⟨i, rfl⟩, decide_eq_true hiS⟩

theorem mem_continuationRaw {S : Finset (Fin 12)} {v : RawPoint (ZMod 11)} :
    v ∈ continuationRaw S ↔
      v ∈ q11Witness ∨ ∃ i ∈ S, conicRaw i = v := by
  constructor
  · intro hv
    rcases List.mem_append.mp hv with hv | hv
    · exact Or.inl hv
    · obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hv
      exact Or.inr ⟨i, of_decide_eq_true (List.mem_filter.mp hi).2, rfl⟩
  · rintro (hv | ⟨i, hiS, rfl⟩)
    · exact List.mem_append_left _ hv
    · apply List.mem_append_right
      apply List.mem_map.mpr
      refine ⟨i, ?_, rfl⟩
      exact List.mem_filter.mpr ⟨List.mem_ofFn.mpr ⟨i, rfl⟩, decide_eq_true hiS⟩

theorem conic_seed_ray_false (i : Fin 12) (a : RawPoint (ZMod 11)) (ha : a ∈ q11Witness) :
    rayEq (conicVec i) a.1 = false ∧ rayEq a.1 (conicVec i) = false := by
  revert i a
  decide

private theorem index_ne_of_ray_false {i j : Fin 12}
    (h : rayEq (conicVec i) (conicVec j) = false) : i ≠ j := by
  intro hij
  subst j
  have ht : rayEq (conicVec i) (conicVec i) = true :=
    (rayEq_eq_true_iff _ _).mpr ⟨1, by simp⟩
  rw [h] at ht
  contradiction

private theorem det_rotate (u v w : Vec (ZMod 11)) :
    Matrix.det ![u, v, w] = Matrix.det ![v, w, u] := by
  simp [Matrix.det_fin_three]
  ring

private theorem det_swap_last (u v w : Vec (ZMod 11)) :
    Matrix.det ![u, v, w] = -Matrix.det ![u, w, v] := by
  simp [Matrix.det_fin_three]
  ring

/-- Conflict in the conic residual: a witness point lies on the chord through the two parameters. -/
def Adj (i j : Fin 12) : Prop :=
  i ≠ j ∧ ∃ a ∈ q11Witness, Matrix.det ![conicVec i, conicVec j, a.1] = 0

instance (i j : Fin 12) : Decidable (Adj i j) := by
  unfold Adj
  infer_instance

instance (S : Finset (Fin 12)) : Decidable (IndepValid Adj S) := by
  unfold IndepValid
  infer_instance

/-- The six antipodal pairs in affine-parameter order:
`(0,9), (1,7), (2,∞), (3,4), (5,8), (6,10)`. -/
def antipode : Fin 12 ≃ Fin 12 where
  toFun i := ![9, 7, 11, 4, 3, 8, 10, 1, 5, 0, 6, 2] i
  invFun i := ![9, 7, 11, 4, 3, 8, 10, 1, 5, 0, 6, 2] i
  left_inv := by decide
  right_inv := by decide

theorem antipode_involutive (i : Fin 12) : antipode (antipode i) = i := by
  fin_cases i <;> decide

theorem antipode_fixedPointFree (i : Fin 12) : antipode i ≠ i := by
  fin_cases i <;> decide

theorem adj_symmetric : ∀ i j : Fin 12, Adj i j → Adj j i := by
  decide

theorem adj_antipode_iff (i j : Fin 12) :
    Adj (antipode i) (antipode j) ↔ Adj i j := by
  fin_cases i <;> fin_cases j <;> decide

theorem antipodal_chord_nonedge (i : Fin 12) : ¬ Adj i (antipode i) := by
  fin_cases i <;> decide

/-- The standard 30-edge presentation: north and south poles, two pentagons, and the ten
cross-pentagon edges. -/
def icosahedronEdges : Finset (Fin 12 × Fin 12) := {
  (0, 1), (0, 2), (0, 3), (0, 4), (0, 5),
  (11, 6), (11, 7), (11, 8), (11, 9), (11, 10),
  (1, 2), (2, 3), (3, 4), (4, 5), (5, 1),
  (6, 7), (7, 8), (8, 9), (9, 10), (10, 6),
  (1, 6), (2, 7), (3, 8), (4, 9), (5, 10),
  (1, 10), (2, 6), (3, 7), (4, 8), (5, 9) }

def IcosahedronAdj (i j : Fin 12) : Prop :=
  (i, j) ∈ icosahedronEdges ∨ (j, i) ∈ icosahedronEdges

instance (i j : Fin 12) : Decidable (IcosahedronAdj i j) := by
  unfold IcosahedronAdj
  infer_instance

/-- An explicit graph isomorphism from affine-parameter order to the standard presentation. -/
def toIcosahedron : Fin 12 ≃ Fin 12 where
  toFun i := ![7, 1, 11, 10, 3, 6, 9, 8, 4, 5, 2, 0] i
  invFun i := ![11, 1, 10, 4, 8, 9, 5, 0, 7, 6, 3, 2] i
  left_inv := by decide
  right_inv := by decide

/-- The determinant-defined residual is exactly the icosahedral graph. -/
theorem adj_iff_icosahedron (i j : Fin 12) :
    Adj i j ↔ IcosahedronAdj (toIcosahedron i) (toIcosahedron j) := by
  fin_cases i <;> fin_cases j <;> decide

theorem icosahedronEdges_card : icosahedronEdges.card = 30 := by decide

def neighbors (i : Fin 12) : Finset (Fin 12) :=
  Finset.univ.filter (Adj i)

theorem degree_five (i : Fin 12) : (neighbors i).card = 5 := by
  fin_cases i <;> decide

/-- For every one of the 4096 residual subsets, the determinant definition of a legal
projective continuation agrees exactly with graph independence. -/
theorem continuation_rawArc_iff (S : Finset (Fin 12)) :
    RawArc (continuationRaw S) ↔ IndepValid Adj S := by
  constructor
  · intro hraw i hi j hj hij hadj
    obtain ⟨_hij, a, ha, hdet⟩ := hadj
    have hci : conicRaw i ∈ continuationRaw S :=
      mem_continuationRaw.mpr (Or.inr ⟨i, hi, rfl⟩)
    have hcj : conicRaw j ∈ continuationRaw S :=
      mem_continuationRaw.mpr (Or.inr ⟨j, hj, rfl⟩)
    have ha' : a ∈ continuationRaw S := mem_continuationRaw.mpr (Or.inl ha)
    have hijray := conic_parameters_distinct i j hij
    have hia := (conic_seed_ray_false i a ha).1
    have hja := (conic_seed_ray_false j a ha).1
    exact (hraw (conicRaw i) hci (conicRaw j) hcj a ha' hijray hia hja) hdet
  · intro hind a ha b hb c hc hab hac hbc
    rw [mem_continuationRaw] at ha hb hc
    rcases ha with ha | ⟨i, hi, rfl⟩ <;>
      rcases hb with hb | ⟨j, hj, rfl⟩ <;>
      rcases hc with hc | ⟨k, hk, rfl⟩
    · exact seed_rawArc a ha b hb c hc hab hac hbc
    · have h := all_seed_legal k a ha b hb hab
      rw [det_rotate] at h
      exact h
    · have h := all_seed_legal j a ha c hc hac
      rw [det_rotate, det_swap_last] at h
      exact neg_ne_zero.mp h
    · have hjk := index_ne_of_ray_false hbc
      intro hdet
      apply hind j hj k hk hjk
      exact ⟨hjk, a, ha, by
        exact (det_rotate a.1 (conicVec j) (conicVec k)) ▸ hdet⟩
    · exact all_seed_legal i b hb c hc hbc
    · have hik := index_ne_of_ray_false hac
      intro hdet
      apply hind i hi k hk hik
      exact ⟨hik, b, hb, by
        have hneg : -Matrix.det ![conicVec i, conicVec k, b.1] = 0 := by
          rw [← det_swap_last]
          exact hdet
        exact neg_eq_zero.mp hneg⟩
    · have hij := index_ne_of_ray_false hab
      intro hdet
      apply hind i hi j hj hij
      exact ⟨hij, c, hc, hdet⟩
    · exact conic_triples_legal i j k
        (index_ne_of_ray_false hab) (index_ne_of_ray_false hac)
        (index_ne_of_ray_false hbc)

/-- The seeded projective-cap validity predicate is exactly the determinant conflict graph. -/
theorem parametrizedHoleValid_iff (S : Finset (Fin 12)) :
    ProjectiveBridge.ParametrizedHoleValid
        (K := ZMod 11) (pointSet q11Witness) conicEmbedding S ↔
      IndepValid Adj S := by
  change ProjectiveCap.Projective.Cap (ZMod 11) (Fin 3 → ZMod 11)
      (pointSet q11Witness ∪ S.map conicEmbedding) ↔ IndepValid Adj S
  rw [← pointSet_continuation, ← rawArc_iff_projectiveCap]
  exact continuation_rawArc_iff S

/-- The residual independent-set building game is P by antipodal reply. -/
theorem isP :
    FiniteBuildGame.IsP (IndepValid Adj) (∅ : Finset (Fin 12)) := by
  exact initialIndepP_of_fpf_adjPreserving_involution Adj adj_symmetric antipode
    antipode_involutive antipode_fixedPointFree adj_antipode_iff antipodal_chord_nonedge

/-- The actual six-point projective cap position is P.  Static relative completeness confines
every continuation to the conic, the determinant table identifies those continuations with the
icosahedral independent-set game, and the antipodal mirror supplies the replies. -/
theorem seed_isP :
    FiniteBuildGame.IsP
      (ProjectiveCap.Projective.Cap (ZMod 11) (Fin 3 → ZMod 11))
      (pointSet q11Witness) := by
  have hcomplete : CompleteOutside (L := Conic.Point (ZMod 11))
      (pointSet q11Witness) (Conic.standardConic (K := ZMod 11)) :=
    check_sound q11_check
  have hlocal := ProjectiveBridge.isP_parametrizedHoles_iff
    (K := ZMod 11) conicEmbedding hcomplete conicEmbedding_range (∅ : Finset (Fin 12))
  have hpred : FiniteBuildGame.IsP
      (ProjectiveBridge.ParametrizedHoleValid
        (K := ZMod 11) (pointSet q11Witness) conicEmbedding) (∅ : Finset (Fin 12)) := by
    have htransport := FiniteBuildGame.isP_equiv (Equiv.refl (Fin 12))
      (Validα := IndepValid Adj)
      (Validβ := ProjectiveBridge.ParametrizedHoleValid
        (K := ZMod 11) (pointSet q11Witness) conicEmbedding)
      (fun S => by simpa using parametrizedHoleValid_iff S) (∅ : Finset (Fin 12))
    exact htransport.mpr isP
  simpa using hlocal.mpr hpred

end Q11Residual
end Examples
end RelativeConicArcs
