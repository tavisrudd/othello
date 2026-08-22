import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAxisNorm

/-!
# Self-normalizing six-point axis stabilizers and coherent transport

Each labelled axis stabilizer is the normalizer of the corresponding
Sylow-five subgroup of the concrete alternating group.  The Sylow normalizer
theorem therefore makes the axis stabilizer self-normalizing.

Lean also proves the transporter-independence statement used to identify the
six axes coherently: if one object is fixed by the source stabilizer, then any
two group elements carrying the source label to the same target label carry
that object to the same target.  This is a group-action theorem; it does not
construct elliptic schemes, geometric axis inclusions, or their transport.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

/-- Every concrete dihedral axis stabilizer is self-normalizing in the
alternating group on five letters. -/
theorem alternatingFiveSixPointStabilizer_normalizer_eq_self (label : Fin 6) :
    Subgroup.normalizer (alternatingFiveSixPointStabilizer label :
      Set (alternatingGroup (Fin 5))) =
      alternatingFiveSixPointStabilizer label := by
  rw [alternatingFiveSixPointStabilizer_eq_normalizer]
  exact Sylow.normalizer_normalizer (sixPointFiveSylow label)

/-- Two transporters from one label to the same target differ by an element
of the source-label stabilizer. -/
theorem sixPointAxis_transporter_difference_mem_stabilizer
    (source target : Fin 6)
    (left right : alternatingGroup (Fin 5))
    (leftMaps : alternatingFiveSixPointAction left source = target)
    (rightMaps : alternatingFiveSixPointAction right source = target) :
    right⁻¹ * left ∈ alternatingFiveSixPointStabilizer source := by
  rw [mem_alternatingFiveSixPointStabilizer_iff]
  rw [map_mul, map_inv, Equiv.Perm.mul_apply, leftMaps, ← rightMaps]
  exact Equiv.symm_apply_apply _ _

/-- An object fixed by the source axis stabilizer has transporter-independent
image at every target label. -/
theorem sixPointAxis_transport_independent
    {Object : Type*} [MulAction (alternatingGroup (Fin 5)) Object]
    (source target : Fin 6) (object : Object)
    (fixed : ∀ transformation : alternatingGroup (Fin 5),
      transformation ∈ alternatingFiveSixPointStabilizer source →
        transformation • object = object)
    (left right : alternatingGroup (Fin 5))
    (leftMaps : alternatingFiveSixPointAction left source = target)
    (rightMaps : alternatingFiveSixPointAction right source = target) :
    left • object = right • object := by
  have differenceMember :
      right⁻¹ * left ∈ alternatingFiveSixPointStabilizer source :=
    sixPointAxis_transporter_difference_mem_stabilizer source target left right
      leftMaps rightMaps
  calc
    left • object = right • ((right⁻¹ * left) • object) := by
      simp [mul_smul]
    _ = right • object := by
      rw [fixed (right⁻¹ * left) differenceMember]

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
