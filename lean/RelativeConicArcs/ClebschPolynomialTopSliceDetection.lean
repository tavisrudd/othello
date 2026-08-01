import RelativeConicArcs.ClebschDetectingIntertwiners
import RelativeConicArcs.ClebschDividedPowerTopSlices

/-!
# Explicit coordinate detectors for the polynomial top slices

The relevant part of the four-leaf divided-power target has two coordinates: its highest-weight
line and the selected lowered orbit.  This file gives that slice, its divided-power operator,
and its coefficient functional explicitly.  In characteristic three the same two-coordinate
space records the two adjacent source sections and the raising operator between them.

These are coordinate slices, not a decomposition of the ambient tilting module.  An application
to the ambient polynomial module must still identify the indicated weight-space projection with
this slice; no Hom-space vanishing is hidden in that identification.
-/

namespace RelativeConicArcs.ClebschPolynomialTopSliceDetection

open ClebschDetectingIntertwiners ClebschDividedPowerTopSlices

variable {k : Type*} [Field k]

/-- Highest-weight coordinate in the two-coordinate polynomial slice. -/
def topVector : k × k := (1, 0)

/-- Selected lowered-orbit coordinate in the two-coordinate polynomial slice. -/
def loweredVector : k × k := (0, 1)

/-- Inclusion of the one-dimensional highest-weight line. -/
def topLine : k →ₗ[k] k × k where
  toFun a := (a, 0)
  map_add' _ _ := by simp
  map_smul' _ _ := by simp

/-- Inclusion of the one-dimensional selected lowered-orbit line. -/
def loweredLine : k →ₗ[k] k × k where
  toFun a := (0, a)
  map_add' _ _ := by simp
  map_smul' _ _ := by simp

/-- Projection to the selected lowered-orbit coefficient. -/
def loweredCoordinate : k × k →ₗ[k] k where
  toFun x := x.2
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The divided-power operator on the slice: it sends the top coordinate to the selected orbit
with coefficient `c` and kills the selected orbit. -/
def lowerTopBy (c : k) : k × k →ₗ[k] k × k where
  toFun x := (0, c * x.1)
  map_add' x y := by simp [mul_add]
  map_smul' a x := by simp [mul_left_comm]

/-- Raising between the adjacent characteristic-three sections. -/
def raiseLowered : k × k →ₗ[k] k × k where
  toFun x := (x.2, 0)
  map_add' _ _ := by simp
  map_smul' _ _ := by simp

@[simp] theorem topLine_apply (a : k) : topLine a = a • topVector := by
  ext <;> simp [topLine, topVector]

@[simp] theorem loweredLine_apply (a : k) : loweredLine a = a • loweredVector := by
  ext <;> simp [loweredLine, loweredVector]

/-- The highest-weight slice is exactly one-dimensional. -/
theorem mem_range_topLine_iff (x : k × k) :
    x ∈ LinearMap.range topLine ↔ x.2 = 0 := by
  constructor
  · rintro ⟨a, rfl⟩
    simp [topLine]
  · intro hx
    refine ⟨x.1, ?_⟩
    ext <;> simp [topLine, hx]

/-- The selected lowered-orbit slice is exactly one-dimensional. -/
theorem mem_range_loweredLine_iff (x : k × k) :
    x ∈ LinearMap.range loweredLine ↔ x.1 = 0 := by
  constructor
  · rintro ⟨a, rfl⟩
    simp [loweredLine]
  · intro hx
    refine ⟨x.2, ?_⟩
    ext <;> simp [loweredLine, hx]

@[simp] theorem lowerTopBy_topVector (c : k) :
    lowerTopBy c topVector = c • loweredVector := by
  ext <;> simp [lowerTopBy, topVector, loweredVector]

@[simp] theorem loweredCoordinate_lowerTopBy_topVector (c : k) :
    loweredCoordinate (lowerTopBy c topVector) = c := by
  simp [loweredCoordinate, lowerTopBy, topVector]

@[simp] theorem raiseLowered_loweredVector :
    raiseLowered (k := k) (loweredVector (k := k)) = topVector := by
  simp [raiseLowered, loweredVector, topVector]

/-- The unit vector cyclically detects all linear maps out of the one-dimensional top section. -/
theorem one_detects_linear_maps :
    DetectsLinearMaps (k := k) (S := k) (T := k × k) 1 := by
  intro f hf
  apply LinearMap.ext
  intro a
  rw [show a = a • (1 : k) by simp, map_smul, hf, smul_zero]
  rfl

/-- The two coordinate vectors generate the two-section characteristic-three source. -/
theorem coordinate_pair_detects_linear_maps :
    DetectsLinearMapsPair (k := k) (S := k × k) (T := k × k)
      topVector loweredVector := by
  intro f htop hlowered
  apply LinearMap.ext
  intro x
  rw [show x = x.1 • topVector + x.2 • loweredVector by
    ext <;> simp [topVector, loweredVector]]
  simp [htop, hlowered]

/-- The concrete nonzero divided-power coefficient excludes a map from the top coordinate
section whenever its image lies in the highest-weight line. -/
theorem general_top_slice_map_eq_zero
    {p m d tail : ℕ} [Fact p.Prime] (hpForm : p = 2 * m + 3)
    (hm : 2 ≤ m) (hd : d = m + p * tail)
    (f : ZMod p →ₗ[ZMod p] ZMod p × ZMod p)
    (hhead : (f 1).2 = 0)
    (hf : IntertwinesOperator f (0 : ZMod p →ₗ[ZMod p] ZMod p)
      (lowerTopBy (twoLeafCoefficient p d m (m - 2)))) :
    f = 0 := by
  have hcoefficient := twoLeafCoefficient_ne_zero Fact.out hpForm hm hd
  have himage : f 1 = (f 1).1 • topVector := by
    ext <;> simp [topVector, hhead]
  exact eq_zero_of_detected_dividedPower_coefficient
    (g := (1 : ZMod p)) (X := topVector)
    (source := (0 : ZMod p →ₗ[ZMod p] ZMod p))
    (target := lowerTopBy (twoLeafCoefficient p d m (m - 2)))
    (coefficient := loweredCoordinate) one_detects_linear_maps rfl
    (twoLeafCoefficient p d m (m - 2))
    (loweredCoordinate_lowerTopBy_topVector _) hcoefficient f hf (f 1).1 himage

/-- In characteristic three, the two explicit section coordinates and the coefficient `2`
exclude every map intertwining both lowering and raising. -/
theorem characteristic_three_two_section_map_eq_zero
    (f : (ZMod 3 × ZMod 3) →ₗ[ZMod 3] (ZMod 3 × ZMod 3))
    (hlower : IntertwinesOperator f (0 : (ZMod 3 × ZMod 3) →ₗ[ZMod 3]
        (ZMod 3 × ZMod 3)) (lowerTopBy (2 : ZMod 3)))
    (hraise : IntertwinesOperator f (raiseLowered (k := ZMod 3))
      (raiseLowered (k := ZMod 3)))
    (alpha beta : ZMod 3)
    (htop : f topVector = alpha • topVector)
    (hlowered : f loweredVector = beta • loweredVector) :
    f = 0 := by
  apply eq_zero_of_two_generator_relations
    (g := topVector) (v := loweredVector) (X := topVector) (Y := loweredVector)
    (lowerSource := (0 : (ZMod 3 × ZMod 3) →ₗ[ZMod 3] (ZMod 3 × ZMod 3)))
    (raisingSource := raiseLowered (k := ZMod 3))
    (lowerTarget := lowerTopBy (2 : ZMod 3))
    (raisingTarget := raiseLowered (k := ZMod 3)) (coefficient := loweredCoordinate)
    coordinate_pair_detects_linear_maps rfl raiseLowered_loweredVector
    (loweredCoordinate_lowerTopBy_topVector _) (by decide)
    raiseLowered_loweredVector f hlower hraise alpha beta htop hlowered
  decide

end RelativeConicArcs.ClebschPolynomialTopSliceDetection
