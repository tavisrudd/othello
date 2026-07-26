import RelativeConicArcs.NinePointHeisenbergCubicPencil
import RelativeConicArcs.NinePointHeisenbergIncidence

/-!
# Finite census of a Heisenberg-invariant cubic pencil

This definitions-only module lists the twenty rational members of the projective pencil and
defines their rational point counts and projective coefficient equivalence.  No finite
proposition is discharged here.
-/

namespace RelativeConicArcs
namespace NinePointHeisenbergCubicPencilCounts

open NinePointHeisenbergIncidence NinePointHeisenbergCubicPencil

/-- Number of rational projective zeros of a cubic. -/
def projectivePointCount (coefficients : CubicCoefficients) : Nat :=
  canonicalPoints.countP fun p => cubicValue coefficients p = 0

/-- The nineteen affine pencil parameters `F_A + t F_U`. -/
def affinePencilMembers : List CubicCoefficients :=
  fieldElements.map fun t => selectedCoefficients + t • uncoveredCoefficients

/-- The twenty rational members of the projective cubic pencil. -/
def rationalPencilMembers : List CubicCoefficients :=
  affinePencilMembers ++ [uncoveredCoefficients]

/-- Whether two cubic coefficient vectors differ by a field scalar. -/
def scalarEquivalentCoefficients
    (left right : CubicCoefficients) : Bool :=
  fieldElements.any fun scalar => decide (left = scalar • right)

/-- Number of rational pencil members with a prescribed projective point count. -/
def pencilPointCountMultiplicity (pointCount : Nat) : Nat :=
  rationalPencilMembers.countP fun coefficients =>
    projectivePointCount coefficients = pointCount

attribute [reducible] projectivePointCount affinePencilMembers rationalPencilMembers
  scalarEquivalentCoefficients pencilPointCountMultiplicity

end NinePointHeisenbergCubicPencilCounts
end RelativeConicArcs
