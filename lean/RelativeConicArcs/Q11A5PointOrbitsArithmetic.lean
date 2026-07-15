import RelativeConicArcs.Q11A5PointOrbitsData

/-!
# Kernel-checked arithmetic normalization for the Q11 projective action

`ZMod` inversion is intentionally opaque to ordinary reduction.  This module replaces that
opaque computation by an explicit eleven-entry inverse table, proved once from its multiplicative
specification.  The bounded point-action leaves can then normalize projective division without
`native_decide` or unfolding the extended Euclidean algorithm.
-/

namespace RelativeConicArcs.Examples.Q11A5PointOrbits

open Q11Coding

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

def scalarInvCode (x : Scalar) : Scalar :=
  ![0, 1, 6, 4, 3, 9, 2, 8, 7, 5, 10] ⟨x.val, x.val_lt⟩

theorem scalar_inv_eq_code (x : Scalar) : x⁻¹ = scalarInvCode x := by
  by_cases hx : x = 0
  · subst x
    rw [ZMod.inv_zero]
    rfl
  · apply ZMod.inv_eq_of_mul_eq_one 11 x (scalarInvCode x)
    fin_cases x <;> first | contradiction | decide

theorem scalar_eq_zero_iff_val (x : Scalar) : x = 0 ↔ x.val = 0 :=
  (ZMod.val_eq_zero x).symm

theorem scalar_val_cast (n : Nat) : ZMod.val (n : Scalar) = n % 11 :=
  ZMod.val_natCast 11 n

/-- A reducible version of `canonicalIndex`, using the certified finite inverse table instead of
the intentionally opaque `ZMod` inverse implementation. -/
def canonicalIndexFast (v : Vec3) : PointIndex :=
  if h0 : v 0 ≠ 0 then
    let y := v 1 * scalarInvCode (v 0)
    let z := v 2 * scalarInvCode (v 0)
    ⟨y.val * 11 + z.val, by have hy := y.val_lt; have hz := z.val_lt; omega⟩
  else if h1 : v 1 ≠ 0 then
    let z := v 2 * scalarInvCode (v 1)
    ⟨121 + z.val, by have hz := z.val_lt; omega⟩
  else
    132

theorem canonicalIndex_eq_fast (v : Vec3) : canonicalIndex v = canonicalIndexFast v := by
  unfold canonicalIndex canonicalIndexFast
  split_ifs <;> simp only [div_eq_mul_inv, scalar_inv_eq_code]

def pointActionFast (g : GroupIndex) (p : PointIndex) : PointIndex :=
  canonicalIndexFast (matrixVec g (pointVec p))

theorem pointAction_eq_fast (g : GroupIndex) (p : PointIndex) :
    pointAction g p = pointActionFast g p := by
  unfold pointAction pointActionFast
  exact canonicalIndex_eq_fast _

def pointOrbitFast (p : PointIndex) : Finset PointIndex :=
  Finset.univ.image fun g : GroupIndex => pointActionFast g p

theorem pointOrbit_eq_fast (p : PointIndex) : pointOrbit p = pointOrbitFast p := by
  simp only [pointOrbit, pointOrbitFast, pointAction_eq_fast]

def fixedPointsFast (g : GroupIndex) : Finset PointIndex :=
  Finset.univ.filter fun p => pointActionFast g p = p

theorem fixedPoints_eq_fast (g : GroupIndex) : fixedPoints g = fixedPointsFast g := by
  simp only [fixedPoints, fixedPointsFast, pointAction_eq_fast]

def orderFiveFixedUnionFast : Finset PointIndex :=
  ((Finset.univ : Finset GroupIndex).filter OrderFive).biUnion fixedPointsFast

theorem orderFiveFixedUnion_eq_fast : orderFiveFixedUnion = orderFiveFixedUnionFast := by
  unfold orderFiveFixedUnion orderFiveFixedUnionFast
  rw [show fixedPoints = fixedPointsFast by
    funext g
    exact fixedPoints_eq_fast g]

macro "q11_point_action_norm" : tactic =>
  `(tactic|
    norm_num [pointAction, canonicalIndex, matrixVec, matrixEntry, matrixCode, pointVec,
      witnessIndex, supportPerm, div_eq_mul_inv] <;>
      simp [scalar_eq_zero_iff_val, scalar_inv_eq_code, scalarInvCode, scalar_val_cast,
        ZMod.val_one, ZMod.val_natCast, ZMod.val_ofNat, ZMod.val_mul] <;>
      norm_num [ZMod.val_one, ZMod.val_natCast])

end RelativeConicArcs.Examples.Q11A5PointOrbits
