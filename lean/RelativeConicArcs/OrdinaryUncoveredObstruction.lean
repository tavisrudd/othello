import RelativeConicArcs.Nucleus

/-!
# Ordinary uncovered-locus obstructions

If an arc is complete outside a prescribed hole set, every point left uncovered by its secants
belongs to that hole set.  Consequently an arc complete outside a nonsingular conic has at most
`q + 1` ordinary uncovered points, and those points form an arc.  These implications isolate the
geometric obstruction from any finite classification used to exhibit an oversized or collinear
uncovered locus.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs

open Conic Projectivization

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P]

/-- Every point ordinarily uncovered by an arc complete outside `H` belongs to `H`. -/
theorem ordinaryUncovered_subset_holes {A H : Finset P}
    (hcomplete : CompleteOutside (L := L) A H) :
    uncovered (L := L) A ∅ ⊆ H := by
  classical
  intro x hx
  obtain ⟨hxrequired, hxuncovered⟩ := Finset.mem_filter.mp hx
  change x ∈ Finset.univ \ (A ∪ ∅) at hxrequired
  have hxunion : x ∉ A ∪ ∅ := (Finset.mem_sdiff.mp hxrequired).2
  have hxA : x ∉ A := fun h => hxunion (Finset.mem_union_left ∅ h)
  by_contra hxH
  exact hxuncovered (hcomplete.2.2 x hxA hxH)

/-- The ordinary uncovered locus has at most as many points as the prescribed hole set. -/
theorem ordinaryUncovered_card_le_holes {A H : Finset P}
    (hcomplete : CompleteOutside (L := L) A H) :
    (uncovered (L := L) A ∅).card ≤ H.card :=
  Finset.card_le_card (ordinaryUncovered_subset_holes hcomplete)

/-- If the prescribed holes form an arc, so does the ordinary uncovered locus. -/
theorem ordinaryUncovered_arc {A H : Finset P}
    (hcomplete : CompleteOutside (L := L) A H)
    (hholes : Arc (L := L) H) :
    Arc (L := L) (uncovered (L := L) A ∅) :=
  arc_mono (ordinaryUncovered_subset_holes hcomplete) hholes

namespace Conic

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance : Fintype (Point K) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Point K) := Classical.decEq _

/-- The standard Veronese conic has no three distinct collinear points. -/
theorem standardConic_arc : Arc (L := Point K) (standardConic (K := K)) := by
  rw [ProjectiveBridge.arc_iff_projectiveCap]
  intro a b c ha hb hc hab hac hbc hcol
  apply (ProjectiveCap.Projective.not_collinear_iff_independent.mpr ?_) hcol
  obtain ⟨u, rfl⟩ := mem_standardConic.mp ha
  obtain ⟨v, rfl⟩ := mem_standardConic.mp hb
  obtain ⟨w, rfl⟩ := mem_standardConic.mp hc
  induction u using Projectivization.ind with
  | h u hu =>
    induction v using Projectivization.ind with
    | h v hv =>
      induction w using Projectivization.ind with
      | h w hw =>
        rw [ProjectiveCap.Sym2Bridge.veronesePoint_mk,
          ProjectiveCap.Sym2Bridge.veronesePoint_mk,
          ProjectiveCap.Sym2Bridge.veronesePoint_mk]
        exact ProjectiveCap.Projective.independent_triple_of_li
          (ProjectiveCap.Sym2Bridge.veronese_ne_zero hu)
          (ProjectiveCap.Sym2Bridge.veronese_ne_zero hv)
          (ProjectiveCap.Sym2Bridge.veronese_ne_zero hw)
          (Nucleus.veronese_triple_linearIndependent hu hv hw
            (fun h => hab (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h))
            (fun h => hac (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h))
            (fun h => hbc (congrArg ProjectiveCap.Sym2Bridge.veronesePoint h)))

/-- Every nonsingular conic, presented as a projective image of the standard conic, is an arc. -/
theorem NonsingularConic.points_arc (C : NonsingularConic (K := K)) :
    Arc (L := Point K) C.points := by
  intro a b c ha hb hc hab hac hbc hcol
  rw [NonsingularConic.points] at ha hb hc
  obtain ⟨u, hu, rfl⟩ := Finset.mem_map.mp ha
  obtain ⟨v, hv, rfl⟩ := Finset.mem_map.mp hb
  obtain ⟨w, hw, rfl⟩ := Finset.mem_map.mp hc
  apply standardConic_arc hu hv hw
  · exact fun huv => hab (congrArg _ huv)
  · exact fun huw => hac (congrArg _ huw)
  · exact fun hvw => hbc (congrArg _ hvw)
  · exact (NonsingularConic.collinear_map_coordinateChange C u v w).mp hcol

/-- Completeness outside a nonsingular conic forces its ordinary uncovered locus to be an arc. -/
theorem completeOutside_ordinaryUncovered_arc {A : Finset (Point K)}
    (C : NonsingularConic (K := K))
    (hcomplete : CompleteOutside (L := Point K) A C.points) :
    Arc (L := Point K) (uncovered (L := Point K) A ∅) :=
  ordinaryUncovered_arc hcomplete C.points_arc

/-- Completeness outside a nonsingular conic leaves at most `q + 1` ordinary uncovered points. -/
theorem completeOutside_ordinaryUncovered_card_le {A : Finset (Point K)}
    (C : NonsingularConic (K := K))
    (hcomplete : CompleteOutside (L := Point K) A C.points) :
    (uncovered (L := Point K) A ∅).card ≤ Fintype.card K + 1 := by
  simpa using ordinaryUncovered_card_le_holes hcomplete

end Conic
end RelativeConicArcs
