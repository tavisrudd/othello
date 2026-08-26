import RelativeConicArcs.NormalizedMarkedIncidenceData

/-!
# Normalized marked incidence transport

This module packages the relative geometric identification used after
normalizing the Clebsch-chart pullback.  A datum identifies its two geometric
components with a Boolean sheet label, identifies geometric deck exchange with
Boolean negation, and compares the actual odd value, conference matrix,
Petersen coefficients, and chart lift with the normalized marked models.

Once those geometric comparison fields are supplied, all four deck-sign
statements follow formally.  Thus existence of the geometric comparison stays
an explicit input, while its orientation consequences are kernel checked.
-/

namespace RelativeConicArcs.NormalizedMarkedIncidence

open ClebschSteinChart
open MarkedClebschBridge

variable {K Axis Plane Face H Component : Type*}
  [Field K] [AddCommGroup H] [Module K H]

/-- The actual odd generator value changes sign under geometric deck exchange. -/
theorem oddValue_deck (d : Datum (K := K) (Axis := Axis) (Plane := Plane)
    (Face := Face) (H := H) (Component := Component)) (c : Component) :
    d.oddValue (d.deck c) = -d.oddValue c := by
  rw [d.oddValue_identification, d.deck_labels, d.oddValue_identification]
  cases d.componentLabels c <;> simp

/-- The actual marked conference matrix changes sign under deck exchange. -/
theorem conference_deck (d : Datum (K := K) (Axis := Axis) (Plane := Plane)
    (Face := Face) (H := H) (Component := Component)) (c : Component) :
    d.conference (d.deck c) = -d.conference c := by
  calc
    d.conference (d.deck c) = sheetConference (d.componentLabels (d.deck c)) :=
      d.conference_identification _
    _ = sheetConference (!d.componentLabels c) := by rw [d.deck_labels]
    _ = -sheetConference (d.componentLabels c) := sheetConference_not _
    _ = -d.conference c := by rw [d.conference_identification]

/-- The actual marked Petersen coefficients change sign under deck exchange. -/
theorem pairCoefficients_deck
    (d : Datum (K := K) (Axis := Axis) (Plane := Plane)
      (Face := Face) (H := H) (Component := Component))
    (c : Component) (y : Fin 5 → K) :
    d.pairCoefficients (d.deck c) y = -d.pairCoefficients c y := by
  calc
    d.pairCoefficients (d.deck c) y =
        sheetPairSum (d.componentLabels (d.deck c)) y :=
      d.pairCoefficients_identification _ _
    _ = sheetPairSum (!d.componentLabels c) y := by rw [d.deck_labels]
    _ = -sheetPairSum (d.componentLabels c) y := sheetPairSum_not _ _
    _ = -d.pairCoefficients c y := by rw [d.pairCoefficients_identification]

/-- The actual normalized chart lift changes sign under deck exchange. -/
theorem chartLift_deck (d : Datum (K := K) (Axis := Axis) (Plane := Plane)
    (Face := Face) (H := H) (Component := Component)) (c : Component) :
    d.chartLift (d.deck c) = -d.chartLift c := by
  rw [d.chartLift_identification, d.deck_labels, d.chartLift_identification]
  cases d.componentLabels c <;> simp

end RelativeConicArcs.NormalizedMarkedIncidence
