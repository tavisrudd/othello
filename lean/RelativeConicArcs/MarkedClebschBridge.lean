import RelativeConicArcs.ClebschGoldenConference
import RelativeConicArcs.KneserPairEigenspace

/-!
# Marked Clebsch orientation data

A marked bridge records three genuine identifications: an ordering of the six
projective axes, labels of the five plane triples, and labels of the ten face
axes by two-subsets of the five labels.  It also records the normalized linear
chart lift.  No volume orientation or choice of projective representatives is
part of the structure.

After these data are fixed, changing auxiliary axis representatives acts by
conference switching and leaves the triangle cubic unchanged.  Deck exchange
negates the conference source, the chart lift, the primitive Petersen
pair-sum coefficients, and the cubic.  The declarations below formalize this
relative sign transport without asserting that a sheet reconstructs any of
the marking fields.
-/

namespace RelativeConicArcs.MarkedClebschBridge

open RelativeConicArcs.ClebschGoldenConference
open RelativeConicArcs.KneserPairEigenspace

/-- The genuine marking and normalized chart lift used by the relative
Clebsch bridge.  The source types are abstract; the equivalences are the
chosen labels. -/
structure MarkedBridgeDatum
    (K Axis Plane Face H : Type*) [Field K] [AddCommGroup H] [Module K H] where
  axisOrder : Axis ≃ Fin 6
  planeLabels : Plane ≃ Fin 5
  faceLabels : Face ≃ Pair 5
  chartLift : standardSubmodule (K := K) →ₗ[K] H
  chartLift_injective : Function.Injective chartLift

variable {K : Type*} [Field K]

/-- The two normalized sheets carry opposite conference matrices. -/
def sheetConference (negativeSheet : Bool) : Matrix (Fin 6) (Fin 6) K :=
  if negativeSheet then -(conferenceMatrixOver K) else conferenceMatrixOver K

/-- Deck exchange negates the sheet conference matrix. -/
theorem sheetConference_not (negativeSheet : Bool) :
    sheetConference (!negativeSheet) = -sheetConference negativeSheet := by
  cases negativeSheet <;> simp [sheetConference]

/-- The oriented triangle cubic attached to a normalized sheet. -/
def sheetTriangleCubic (negativeSheet : Bool) (x : Fin 6 → K) : K :=
  triangleCubic (sheetConference negativeSheet) x

/-- Deck exchange negates the oriented triangle cubic. -/
theorem sheetTriangleCubic_not (negativeSheet : Bool) (x : Fin 6 → K) :
    sheetTriangleCubic (!negativeSheet) x = -sheetTriangleCubic negativeSheet x := by
  rw [sheetTriangleCubic, sheetConference_not, triangleCubic_neg]
  rfl

/-- Auxiliary sign changes of projective-axis representatives do not alter
the triangle cubic on either sheet. -/
theorem sheetTriangleCubic_switch (negativeSheet : Bool) (d : Fin 6 → K)
    (hd : ∀ i, d i * d i = 1) (x : Fin 6 → K) :
    triangleCubic (switchMatrix d (sheetConference negativeSheet)) x =
      sheetTriangleCubic negativeSheet x := by
  rw [triangleCubic_switch d hd]
  rfl

/-- The primitive Petersen coefficients on a sheet; the opposite sheet uses
the negative vertex weighting. -/
def sheetPairSum (negativeSheet : Bool) (y : Fin 5 → K) : Pair 5 → K :=
  pairSum (if negativeSheet then -y else y)

/-- Deck exchange negates every primitive Petersen pair-sum coefficient. -/
theorem sheetPairSum_not (negativeSheet : Bool) (y : Fin 5 → K) :
    sheetPairSum (!negativeSheet) y = -sheetPairSum negativeSheet y := by
  funext p
  cases negativeSheet <;>
    simp [sheetPairSum, pairSum, Finset.sum_neg_distrib]

/-- Negating the normalized chart lift negates its value on every marked
parameter. -/
theorem neg_chartLift_apply
    {Axis Plane Face H : Type*} [AddCommGroup H] [Module K H]
    (m : MarkedBridgeDatum K Axis Plane Face H)
    (y : standardSubmodule (K := K)) :
    (-m.chartLift) y = -m.chartLift y := by
  rfl

/-- Negating twice restores the normalized chart lift. -/
theorem neg_neg_chartLift
    {Axis Plane Face H : Type*} [AddCommGroup H] [Module K H]
    (m : MarkedBridgeDatum K Axis Plane Face H) :
    -(-m.chartLift) = m.chartLift := by
  simp

/-- Scaling the sum-zero chart parameter scales the chosen normalized lift
by the same scalar.  Thus chart scale remains an explicit input rather than
an extra sign or normalization hidden in the bridge. -/
theorem chartLift_smul
    {Axis Plane Face H : Type*} [AddCommGroup H] [Module K H]
    (m : MarkedBridgeDatum K Axis Plane Face H)
    (c : K) (y : standardSubmodule (K := K)) :
    m.chartLift (c • y) = c • m.chartLift y := by
  exact map_smul m.chartLift c y

end RelativeConicArcs.MarkedClebschBridge
