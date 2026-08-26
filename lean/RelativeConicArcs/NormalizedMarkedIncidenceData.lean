import RelativeConicArcs.ClebschSteinChart
import RelativeConicArcs.MarkedClebschBridge

/-!
# Data for normalized marked incidence transport

This definitions-only module records the relative geometric comparison between
the two components of the normalized incidence pullback and the marked algebraic
models.  Existence of this comparison is deliberately a separate geometric
statement; downstream theorem leaves derive its deck-sign consequences.
-/

namespace RelativeConicArcs.NormalizedMarkedIncidence

open ClebschSteinChart
open MarkedClebschBridge
open KneserPairEigenspace

variable {K Axis Plane Face H Component : Type*}
  [Field K] [AddCommGroup H] [Module K H]

/-- Complete relative marking data for the normalized two-component pullback. -/
structure Datum where
  marking : MarkedBridgeDatum K Axis Plane Face H
  steinChart : ClebschSteinChart.Data K
  componentLabels : Component ≃ Bool
  deck : Component ≃ Component
  deck_labels : ∀ c, componentLabels (deck c) = !componentLabels c
  oddValue : Component → K
  oddValue_identification : ∀ c,
    oddValue c = if componentLabels c then -steinChart.root else steinChart.root
  conference : Component → Matrix (Fin 6) (Fin 6) K
  conference_identification : ∀ c,
    conference c = sheetConference (componentLabels c)
  pairCoefficients : Component → (Fin 5 → K) → Pair 5 → K
  pairCoefficients_identification : ∀ c y,
    pairCoefficients c y = sheetPairSum (componentLabels c) y
  chartLift : Component → standardSubmodule (K := K) →ₗ[K] H
  chartLift_identification : ∀ c,
    chartLift c = if componentLabels c then -marking.chartLift else marking.chartLift

end RelativeConicArcs.NormalizedMarkedIncidence
