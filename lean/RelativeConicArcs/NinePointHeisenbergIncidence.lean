import RelativeConicArcs.NinePointHeisenbergPair
import Mathlib.Data.List.Sublists

/-!
# Incidence profile of a nine-point Heisenberg pair

This module defines the executable incidence profile of the two explicit nine-point sets in
`PG(2, 19)` defined in `RelativeConicArcs.NinePointHeisenbergPair`.  Projective points and lines
are represented by the 381 normalized coordinate vectors

`(1,y,z)`, `(0,1,z)`, and `(0,0,1)`.

The finite terminal propositions are divided among downstream modules so that kernel reduction
of the 381 projective points, the line profile, and the chord directions occurs in separate
elaboration environments.  No external incidence table or search result is imported.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergIncidence

open NinePointHeisenbergPair

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

private abbrev selectedPoints : List V := NinePointHeisenbergPair.selected
private abbrev uncoveredPoints : List V := NinePointHeisenbergPair.uncovered

/-- The standard integer representatives of the elements of `ZMod 19`. -/
def fieldElements : List K := List.ofFn fun i : Fin 19 => (i.val : K)

private def affinePointsFor (yCoordinates : List K) : List V :=
  yCoordinates.flatMap fun y => fieldElements.map fun z => ![1, y, z]

/-- Canonical affine points whose second coordinate has representative zero through four. -/
def canonicalPointsY0To4 : List V :=
  affinePointsFor (fieldElements.take 5)

/-- Canonical affine points whose second coordinate has representative five through nine. -/
def canonicalPointsY5To9 : List V :=
  affinePointsFor ((fieldElements.drop 5).take 5)

/-- Canonical affine points whose second coordinate has representative ten through fourteen. -/
def canonicalPointsY10To14 : List V :=
  affinePointsFor ((fieldElements.drop 10).take 5)

/--
Canonical affine points whose second coordinate has representative fifteen through eighteen,
together with all points on the line at infinity.
-/
def canonicalPointsY15To18AndInfinity : List V :=
  affinePointsFor (fieldElements.drop 15) ++
    (fieldElements.map fun z => ![0, 1, z]) ++
    [![0, 0, 1]]

/-- The canonical coordinate representatives of all points of `PG(2, 19)`. -/
def canonicalPoints : List V :=
  canonicalPointsY0To4 ++ canonicalPointsY5To9 ++ canonicalPointsY10To14 ++
    canonicalPointsY15To18AndInfinity

/-- Whether a vector represents a ray occurring in a coordinate list. -/
def onRays (p : V) (points : List V) : Bool :=
  points.any fun q => Certificate.rayEq p q

private def determinantOfTriple : List V → K
  | [a, b, c] => Matrix.det ![a, b, c]
  | _ => 0

/-- Executable arc predicate for a list having no repeated projective points. -/
def isCoordinateArc (points : List V) : Bool :=
  (List.sublistsLen 3 points).all fun triple => decide (determinantOfTriple triple ≠ 0)

private def determinantOfPairWith (p : V) : List V → K
  | [a, b] => Matrix.det ![p, a, b]
  | _ => 1

/-- Whether a point is selected or belongs to a secant of the selected nine-point set. -/
def ordinarilyCovered (p : V) : Bool :=
  onRays p selectedPoints ||
    (List.sublistsLen 2 selectedPoints).any fun pair =>
      decide (determinantOfPairWith p pair = 0)

/-- Whether ordinary uncoveredness agrees with the displayed uncovered ray set on a point list. -/
def uncoveredLocusAgreementOn (points : List V) : Bool :=
  points.all fun p =>
    (!ordinarilyCovered p) == onRays p NinePointHeisenbergPair.uncovered

/-- Number of chords of `points` incident with `p`. -/
def secantMultiplicity (points : List V) (p : V) : Nat :=
  (List.sublistsLen 2 points).countP fun pair => determinantOfPairWith p pair = 0

/-- Number of points from a coordinate list incident with a coordinate line. -/
def pointsOnLine (line : V) (points : List V) : Nat :=
  points.countP fun p => dotProduct line p = 0

/-- The pair of intersection sizes of a line with the selected and uncovered sets. -/
def lineType (line : V) : Nat × Nat :=
  (pointsOnLine line selectedPoints, pointsOnLine line uncoveredPoints)

/-- Number of projective lines having a prescribed pair of intersection sizes. -/
def lineTypeCount (aCount uCount : Nat) : Nat :=
  canonicalPoints.countP fun line => lineType line = (aCount, uCount)

/-- Number of points outside `points` having a prescribed chord multiplicity. -/
def offSetSecantMultiplicityCount (points : List V) (multiplicity : Nat) : Nat :=
  canonicalPoints.countP fun p =>
    !onRays p points && decide (secantMultiplicity points p = multiplicity)

abbrev Label := Fin 3 × Fin 3

/-- The nine labels of the regular `C₃ × C₃` action. -/
def labels : List Label :=
  (List.ofFn fun i : Fin 3 => i).flatMap fun i =>
    (List.ofFn fun j : Fin 3 => j).map fun j => (i, j)

private def labelIndex (x : Label) : Fin 9 :=
  ⟨x.2.val * 3 + x.1.val, by omega⟩

/-- A point of the selected regular orbit with its `C₃ × C₃` label. -/
def selectedAt (x : Label) : V :=
  (heisenbergOrbit ![0, 0, 1]).get (labelIndex x)

/-- A point of the uncovered regular orbit with its `C₃ × C₃` label. -/
def uncoveredAt (x : Label) : V :=
  (heisenbergOrbit ![1, 6, 10]).get (labelIndex x)

private def addLabel (x y : Label) : Label := (x.1 + y.1, x.2 + y.2)
private def subLabel (x y : Label) : Label := (x.1 - y.1, x.2 - y.2)

private def chordSelectedCount (x direction : Label) : Nat :=
  let left := uncoveredAt (addLabel x direction)
  let right := uncoveredAt (subLabel x direction)
  selectedPoints.countP fun a => Matrix.det ![left, right, a] = 0

private def chordHitsSelectedAt (x direction offset : Label) : Bool :=
  let left := uncoveredAt (addLabel x direction)
  let right := uncoveredAt (subLabel x direction)
  decide (Matrix.det ![left, right, selectedAt (addLabel x offset)] = 0)

/-- Whether all nine chords in a direction contain exactly the selected point at the translated
third group-line label. -/
def directionProfile (direction offset : Label) : Bool :=
  labels.all fun x =>
    chordSelectedCount x direction = 1 && chordHitsSelectedAt x direction offset

/-- Whether all nine chords in a direction avoid the selected orbit. -/
def missedDirection (direction : Label) : Bool :=
  labels.all fun x => chordSelectedCount x direction = 0

attribute [reducible] fieldElements affinePointsFor canonicalPointsY0To4 canonicalPointsY5To9
  canonicalPointsY10To14 canonicalPointsY15To18AndInfinity canonicalPoints onRays determinantOfTriple
  isCoordinateArc determinantOfPairWith ordinarilyCovered secantMultiplicity
  uncoveredLocusAgreementOn
  pointsOnLine lineType lineTypeCount offSetSecantMultiplicityCount labels labelIndex
  selectedAt uncoveredAt addLabel subLabel chordSelectedCount chordHitsSelectedAt
  directionProfile missedDirection

end NinePointHeisenbergIncidence
end RelativeConicArcs
