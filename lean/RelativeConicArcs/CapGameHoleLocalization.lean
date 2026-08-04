import RelativeConicArcs.ParametrizedHoles
import ProjectiveCap.ProjectiveCapGame

/-!
# Localizing the cap achievement game to the uncovered holes

Work in the coordinate projective plane `PG(2, K)` over a finite field `K`, with
points `Point K = Projectivization K (Fin 3 → K)` as in
`RelativeConicArcs.ProjectiveBridge`, and with the normal-play cap achievement
game of `ProjectiveCap.ProjectiveCapGame` played on the cap predicate
`ProjectiveCap.Projective.Cap`.

Let `A` be a set of points and `H` a set of points such that `A` is relatively
complete outside `H` (`RelativeConicArcs.CompleteOutside`): every point outside
`H` already fails to extend `A` to an arc. The theorems here say that the game
started from `A` never leaves `H`:

* `projectiveCap_subset_union_of_completeOutside` — any cap containing `A` is
  contained in `A ∪ H`;
* `move_mem_holes_of_completeOutside` and
  `legalExtensions_subset_holes_of_completeOutside` — every legal move from a
  position containing `A` lands in `H`;
* `legalExtensions_sdiff_holes_eq_uncovered` — the legal moves from `A` itself
  are exactly the uncovered holes.

The remaining declarations transport the game across a finite parametrization
`e : I ↪ Point K` of `H`. The induced validity predicate on `Finset I` is
`RelativeConicArcs.ProjectiveBridge.ParametrizedHoleValid A e`, which mentions
no game and is stated with the rest of the game-free bridge; here
`win_parametrizedHoles_iff` and
`isP_parametrizedHoles_iff` state that the normal-play win and
previous-player-win values of the position `A ∪ T.map e` in the full plane game
agree with those of `T` in the parametrized game. This is an exact
correspondence of positions and moves, not a bound.

This is the only game-theoretic content of the projective bridge; the
incidence-geometry identification of arcs with caps
(`RelativeConicArcs.ProjectiveBridge.arc_iff_projectiveCap`) mentions no game
and stays in `RelativeConicArcs.ProjectiveBridge`.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace ProjectiveBridge

open Configuration Matrix Projectivization

variable {K : Type*} [Field K] [DecidableEq K]

noncomputable section GameLocalization

variable [Fintype K]

local instance : Fintype (Point K) := Fintype.ofFinite (Point K)
local instance : DecidableEq (Point K) := Classical.decEq (Point K)

/-- A cap containing a relatively complete seed can add points only from the prescribed hole set.
This is the static form of the cap-game localization bridge. -/
theorem projectiveCap_subset_union_of_completeOutside {A H S : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) (hAS : A ⊆ S)
    (hS : ProjectiveCap.Projective.Cap K (Fin 3 → K) S) :
    S ⊆ A ∪ H := by
  intro x hxS
  by_contra hxUnion
  have hxA : x ∉ A := by simpa using fun hx => hxUnion (Finset.mem_union_left H hx)
  have hxH : x ∉ H := by simpa using fun hx => hxUnion (Finset.mem_union_right A hx)
  obtain ⟨l, ⟨a, ha, b, hb, hab, hal, hbl⟩, hxl⟩ :=
    covered_iff_exists_secant.mp (hcomplete.2.2 x hxA hxH)
  have hxa : x ≠ a := fun h => hxA (h ▸ ha)
  have hxb : x ≠ b := fun h => hxA (h ▸ hb)
  apply hS hxS (hAS ha) (hAS hb) hxa hxb hab
  apply collinear_iff_projective_collinear.mp
  exact ⟨l, hxl, hal, hbl⟩

/-- Every legal move from any cap extending a relatively complete seed lies in the prescribed
hole set. In particular, confinement persists after arbitrary subsequent legal hole moves. -/
theorem move_mem_holes_of_completeOutside {A H S : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) (hAS : A ⊆ S) {x : Point K}
    (hx : FiniteBuildGame.Move (ProjectiveCap.Projective.Cap K (Fin 3 → K)) S x) :
    x ∈ H := by
  have hsubset := projectiveCap_subset_union_of_completeOutside hcomplete
    (Finset.Subset.trans hAS (Finset.subset_insert x S)) hx.2
  have hxUnion : x ∈ A ∪ H := hsubset (Finset.mem_insert_self x S)
  rcases Finset.mem_union.mp hxUnion with hxA | hxH
  · exact False.elim (hx.1 (hAS hxA))
  · exact hxH

/-- The legal-extension set of every cap-game continuation containing a relatively complete seed
is contained in the prescribed hole set. -/
theorem legalExtensions_subset_holes_of_completeOutside {A H S : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) (hAS : A ⊆ S) :
    ProjectiveCap.Projective.LegalExtensions (K := K) (V := Fin 3 → K) S ⊆ H := by
  intro x hx
  exact move_mem_holes_of_completeOutside hcomplete hAS
    (ProjectiveCap.Projective.mem_legalExtensions.mp hx)

/-- At the relatively complete seed itself, every legal projective cap-game extension is a hole. -/
theorem legalExtensions_subset_holes {A H : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A H) :
    ProjectiveCap.Projective.LegalExtensions (K := K) (V := Fin 3 → K) A ⊆ H :=
  legalExtensions_subset_holes_of_completeOutside hcomplete Finset.Subset.rfl

/-- Off-hole legal cap moves are exactly the uncovered required locus.  This identifies the
static defect variable with a game-domain count without asserting any game value or monotonicity. -/
theorem legalExtensions_sdiff_holes_eq_uncovered {A H : Finset (Point K)}
    (hA : RelativeConicArcs.Arc (L := Point K) A) :
    ProjectiveCap.Projective.LegalExtensions (K := K) (V := Fin 3 → K) A \ H =
      uncovered (L := Point K) A H := by
  classical
  ext x
  rw [Finset.mem_sdiff]
  constructor
  · rintro ⟨hxlegal, hxH⟩
    have hxmove := ProjectiveCap.Projective.mem_legalExtensions.mp hxlegal
    have hxnotCovered : ¬ Covered (L := Point K) A x :=
      (arc_insert_iff_not_covered hA hxmove.1).mp
        ((arc_iff_projectiveCap (K := K) (insert x A)).mpr hxmove.2)
    simp [uncovered, requiredLocus, hxmove.1, hxH, hxnotCovered]
  · intro hx
    have hxparts : (x ∉ A ∧ x ∉ H) ∧ ¬ Covered (L := Point K) A x := by
      simpa [uncovered, requiredLocus] using hx
    refine ⟨ProjectiveCap.Projective.mem_legalExtensions.mpr ⟨hxparts.1.1, ?_⟩, hxparts.1.2⟩
    rw [← arc_iff_projectiveCap]
    exact arc_insert_of_not_covered hA hxparts.2

/-! ## Exact game localization through a finite parametrization -/

variable {I : Type*} [Fintype I] [DecidableEq I]

/-- A relatively complete seed has exactly the same normal-play game as any injective
parametrization of its prescribed holes.  This is the dynamic bridge from the static
`CompleteOutside` predicate: it handles every continuation, not only the first move. -/
theorem win_parametrizedHoles_iff {A H : Finset (Point K)} (e : I ↪ Point K)
    (hcomplete : CompleteOutside (L := Point K) A H)
    (hrange : ∀ x : Point K, x ∈ H ↔ ∃ i : I, e i = x)
    (T : Finset I) :
    FiniteBuildGame.Win (ProjectiveCap.Projective.Cap K (Fin 3 → K)) (A ∪ T.map e) ↔
      FiniteBuildGame.Win (ParametrizedHoleValid (K := K) A e) T := by
  rw [FiniteBuildGame.win_iff_exists_move, FiniteBuildGame.win_iff_exists_move]
  constructor
  · rintro ⟨x, hxmove, hxlose⟩
    have hAS : A ⊆ A ∪ T.map e := Finset.subset_union_left
    have hxH := move_mem_holes_of_completeOutside hcomplete hAS hxmove
    obtain ⟨i, hi⟩ := (hrange x).mp hxH
    have hiT : i ∉ T := by
      intro hiT
      apply hxmove.1
      rw [← hi]
      exact Finset.mem_union_right A (Finset.mem_map.mpr ⟨i, hiT, rfl⟩)
    have hsets : insert x (A ∪ T.map e) = A ∪ (insert i T).map e := by
      ext z
      simp [hi]
    have himove : FiniteBuildGame.Move (ParametrizedHoleValid (K := K) A e) T i := by
      refine ⟨hiT, ?_⟩
      change ProjectiveCap.Projective.Cap K (Fin 3 → K) (A ∪ (insert i T).map e)
      rw [← hsets]
      exact hxmove.2
    refine ⟨i, himove, fun hiwin => hxlose ?_⟩
    rw [hsets]
    exact (win_parametrizedHoles_iff e hcomplete hrange (insert i T)).mpr hiwin
  · rintro ⟨i, himove, hilose⟩
    let x : Point K := e i
    have hxiH : x ∈ H := (hrange x).mpr ⟨i, rfl⟩
    have hxiA : x ∉ A := fun hxiA =>
      (Finset.disjoint_left.mp hcomplete.2.1) hxiA hxiH
    have hxiMap : x ∉ T.map e := by
      intro hxmap
      obtain ⟨j, hjT, hji⟩ := Finset.mem_map.mp hxmap
      have hji' : j = i := e.injective hji
      exact himove.1 (hji' ▸ hjT)
    have hxFresh : x ∉ A ∪ T.map e := by
      intro hx
      rcases Finset.mem_union.mp hx with hxA | hxMap
      · exact hxiA hxA
      · exact hxiMap hxMap
    have hsets : insert x (A ∪ T.map e) = A ∪ (insert i T).map e := by
      ext z
      simp [x]
    have hxmove : FiniteBuildGame.Move
        (ProjectiveCap.Projective.Cap K (Fin 3 → K)) (A ∪ T.map e) x := by
      refine ⟨hxFresh, ?_⟩
      rw [hsets]
      exact himove.2
    refine ⟨x, hxmove, fun hxwin => hilose ?_⟩
    rw [hsets] at hxwin
    exact (win_parametrizedHoles_iff e hcomplete hrange (insert i T)).mp hxwin
termination_by Fintype.card I - T.card
decreasing_by
  · have hcard : (insert i T).card = T.card + 1 := Finset.card_insert_of_notMem hiT
    have hle : T.card + 1 ≤ Fintype.card I := by
      rw [← hcard]
      exact Finset.card_le_univ _
    rw [hcard]
    omega
  · have hcard : (insert i T).card = T.card + 1 :=
      Finset.card_insert_of_notMem himove.1
    have hle : T.card + 1 ≤ Fintype.card I := by
      rw [← hcard]
      exact Finset.card_le_univ _
    rw [hcard]
    omega

/-- P-positions transport across the exact parametrized-hole localization bridge. -/
theorem isP_parametrizedHoles_iff {A H : Finset (Point K)} (e : I ↪ Point K)
    (hcomplete : CompleteOutside (L := Point K) A H)
    (hrange : ∀ x : Point K, x ∈ H ↔ ∃ i : I, e i = x)
    (T : Finset I) :
    FiniteBuildGame.IsP (ProjectiveCap.Projective.Cap K (Fin 3 → K)) (A ∪ T.map e) ↔
      FiniteBuildGame.IsP (ParametrizedHoleValid (K := K) A e) T :=
  not_congr (win_parametrizedHoles_iff e hcomplete hrange T)

end GameLocalization

end ProjectiveBridge
end RelativeConicArcs
