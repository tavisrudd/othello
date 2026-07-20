import RelativeConicArcs.ClebschGateway
import RelativeConicArcs.Q11Residual

/-!
# C380 q=11 leaf: the full-conic second transform is empty

The checker ranges only over the twelve displayed conic representatives and the 133 canonical
projective representatives.  Its semantic conclusion uses `rawArc_complete_empty` from the frozen
C380 foundation.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace Q11Conic

open Certificate Conic Examples.Q11Residual Finset

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype (Conic.Point (ZMod 11)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 11)) := Classical.decEq _

/-- The twelve conic representatives in the existing q=11 parameter order. -/
def conicRawList : List (RawPoint (ZMod 11)) :=
  List.ofFn conicRaw

/-- Bounded determinant leaf: no three represented conic points are collinear. -/
theorem conicRawList_rawArc : RawArc conicRawList := by
  decide

/-- Bounded coverage leaf: a selected point or one of the 66 conic secants covers every canonical
projective representative. -/
theorem conicRawList_ordinaryCoverage : RawOrdinaryCoverage conicRawList := by
  decide

theorem pointSet_conicRawList :
    pointSet conicRawList = standardConic (K := ZMod 11) := by
  ext x
  constructor
  · intro hx
    obtain ⟨v, hv, rfl⟩ := mem_pointSet.mp hx
    obtain ⟨i, rfl⟩ := List.mem_ofFn.mp hv
    exact conicPoint_mem_standardConic i
  · intro hx
    obtain ⟨i, hi⟩ := (conicEmbedding_range x).mp hx
    apply mem_pointSet.mpr
    refine ⟨conicRaw i, List.mem_ofFn.mpr ⟨i, rfl⟩, ?_⟩
    simpa [conicEmbedding, conicPoint] using hi

/-- The full q=11 conic is an ordinary complete arc. -/
theorem standardConic_complete :
    CompleteOutside (L := Conic.Point (ZMod 11)) (standardConic (K := ZMod 11)) ∅ := by
  rw [← pointSet_conicRawList]
  exact rawArc_complete_empty conicRawList_rawArc conicRawList_ordinaryCoverage

/-- Hence the presentation-independent deep transform terminates after the full-conic child. -/
theorem standardConic_secondTransform_empty :
    deepTransform (L := Conic.Point (ZMod 11)) (standardConic (K := ZMod 11)) = ∅ := by
  have hsub : deepTransform (L := Conic.Point (ZMod 11))
      (standardConic (K := ZMod 11)) ⊆ ∅ :=
    (completeOutside_iff_distanceThreeDirections_subset.mp standardConic_complete).2.2
  exact Finset.Subset.antisymm hsub (Finset.empty_subset _)

#print axioms conicRawList_rawArc
#print axioms conicRawList_ordinaryCoverage
#print axioms standardConic_secondTransform_empty

end Q11Conic
end ClebschGateway
end RelativeConicArcs
