import RelativeConicArcs.ClebschGateway
import RelativeConicArcs.Q11Coding

/-!
# Deep directions of a six-column system over `F_11`

The six displayed projective columns are those in `RelativeConicArcs.Examples.q11Witness`.  The
kernel-checked relative-completeness certificate and singleton extension checks prove that their
projective distance-three locus is the twelve-point standard conic.  This module checks that the
six columns are projectively distinct and transports the arc theorem to a transparent
seven-column parity-check system for each conic point.

The conclusions concern this displayed coordinate system.  No theorem in this module identifies it
with an independently defined group orbit or classifies all six-arcs over `F_11`.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace Q11Extension

open Certificate Conic Examples Examples.Q11Coding Examples.Q11Residual Finset

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype (Conic.Point (ZMod 11)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 11)) := Classical.decEq _

/-- The six parent columns with their list indices retained. -/
def parentPoint (i : Fin 6) : Conic.Point (ZMod 11) :=
  toPoint (q11Witness.get i)

theorem parent_rays_distinct :
    ∀ i j : Fin 6, i ≠ j →
      rayEq (q11Witness.get i).1 (q11Witness.get j).1 = false := by
  decide

/-- The six displayed projective columns are pairwise distinct. -/
theorem parentPoint_injective : Function.Injective parentPoint := by
  intro i j hij
  by_contra hne
  have hray : RayEq (q11Witness.get i).1 (q11Witness.get j).1 :=
    (rayEq_iff_mk_eq (q11Witness.get i) (q11Witness.get j)).mpr hij
  have htrue : rayEq (q11Witness.get i).1 (q11Witness.get j).1 = true :=
    (rayEq_eq_true_iff _ _).mpr hray
  rw [parent_rays_distinct i j hne] at htrue
  contradiction

/-- The image of the indexed projective columns is the projectivization of the displayed raw
witness list. -/
theorem parentPoint_image :
    Finset.univ.image parentPoint = pointSet q11Witness := by
  classical
  ext x
  constructor
  · intro hx
    obtain ⟨i, _hi, rfl⟩ := Finset.mem_image.mp hx
    exact mem_pointSet.mpr ⟨q11Witness.get i, List.get_mem _ _, rfl⟩
  · intro hx
    obtain ⟨v, hv, rfl⟩ := mem_pointSet.mp hx
    obtain ⟨i, hi⟩ := List.mem_iff_get.mp hv
    change Fin 6 at i
    have hpoint : parentPoint i = toPoint v := by
      exact congrArg toPoint hi
    exact Finset.mem_image.mpr ⟨i, Finset.mem_univ _, hpoint⟩

/-- The six displayed projective columns form an arc. -/
theorem parent_arc :
    Arc (L := Conic.Point (ZMod 11)) (Finset.univ.image parentPoint) := by
  rw [parentPoint_image]
  exact (check_sound q11_check).1

/-- The typed deep transform of the parent is exactly the twelve-point conic. -/
theorem parent_deepTransform_eq_standardConic :
    deepTransform (L := Conic.Point (ZMod 11)) (Finset.univ.image parentPoint) =
      standardConic (K := ZMod 11) := by
  simpa [parentPoint_image] using projective_distanceThreeDirections_eq_standardConic

/-- Every one of the twelve deep projective syndrome directions adjoins a seventh column whose
representatives form a transparent codimension-three MDS parity-check system. -/
theorem conicPoint_oneColumnMDS (i : Fin 12) :
    CodingBridge.CodimThreeMDSColumns (K := ZMod 11)
      (fun j => ((appendPoint parentPoint (conicPoint i)) j).rep) := by
  apply oneColumnMDS_of_mem_deepTransform parentPoint parentPoint_injective (by simp) parent_arc
  rw [parent_deepTransform_eq_standardConic]
  exact conicPoint_mem_standardConic i

/-- Consequently every extension kernel has dimension four. -/
theorem conicPoint_extension_code_finrank (i : Fin 12) :
    Module.finrank (ZMod 11)
      (CodingBridge.parityCheckCode (K := ZMod 11)
        (fun j => ((appendPoint parentPoint (conicPoint i)) j).rep)) = 4 := by
  simpa using (conicPoint_oneColumnMDS i).code_finrank

/-- The same kernel has exact minimum distance four. -/
theorem conicPoint_extension_minimumDistance_four (i : Fin 12) :
    (∀ c : Option (Fin 6) → ZMod 11,
      c ∈ CodingBridge.parityCheckCode (K := ZMod 11)
        (fun j => ((appendPoint parentPoint (conicPoint i)) j).rep) →
      c ≠ 0 → 4 ≤ CodingBridge.hammingWeight c) ∧
    (∃ c : Option (Fin 6) → ZMod 11,
      c ∈ CodingBridge.parityCheckCode (K := ZMod 11)
        (fun j => ((appendPoint parentPoint (conicPoint i)) j).rep) ∧
      c ≠ 0 ∧ CodingBridge.hammingWeight c = 4) := by
  let h := conicPoint_oneColumnMDS i
  exact ⟨fun _ hc hc0 => h.minimumDistance_ge_four hc hc0,
    h.exists_minimumWeight_word (by simp)⟩

#print axioms parent_deepTransform_eq_standardConic
#print axioms conicPoint_oneColumnMDS
#print axioms conicPoint_extension_minimumDistance_four

end Q11Extension
end ClebschGateway
end RelativeConicArcs
