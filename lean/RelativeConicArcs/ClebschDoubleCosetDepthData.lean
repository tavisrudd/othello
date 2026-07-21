import RelativeConicArcs.ClebschGatewayQ11Matching
import Mathlib.Data.Matrix.Basic

/-!
# Concrete projective data for six mixed double cosets

The arrays encode normalized points of the projective plane over `ZMod 11`, their sixteen relation
cells, conic parameters, two generators of the common tetrahedral subgroup, and the involution
exchanging the two special-linear sheets.  No depth profile, orbit decomposition, equivariance
statement, or recovery conclusion is included as input; checker modules derive those facts by
kernel reduction from these arrays and the displayed matching table.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

abbrev Parent := ClebschGateway.Q11Matching.Parent
abbrev Endpoint := ClebschGateway.Q11Matching.ChildPoint
abbrev ProjectivePoint := Fin 133
abbrev RelationCell := Fin 16
abbrev Generator := Fin 2

/-- Normalized representatives of all points of the projective plane over `ZMod 11`. -/
def projectivePoint : ProjectivePoint → Fin 3 → ZMod 11 := ![![0, 0, 1], ![0, 1, 0], ![0, 1, 1], ![0, 1, 2], ![0, 1, 3], ![0, 1, 4], ![0, 1, 5], ![0, 1, 6], ![0, 1, 7], ![0, 1, 8], ![0, 1, 9], ![0, 1, 10], ![1, 0, 0], ![1, 0, 1], ![1, 0, 2], ![1, 0, 3], ![1, 0, 4], ![1, 0, 5], ![1, 0, 6], ![1, 0, 7], ![1, 0, 8], ![1, 0, 9], ![1, 0, 10], ![1, 1, 0], ![1, 1, 1], ![1, 1, 2], ![1, 1, 3], ![1, 1, 4], ![1, 1, 5], ![1, 1, 6], ![1, 1, 7], ![1, 1, 8], ![1, 1, 9], ![1, 1, 10], ![1, 2, 0], ![1, 2, 1], ![1, 2, 2], ![1, 2, 3], ![1, 2, 4], ![1, 2, 5], ![1, 2, 6], ![1, 2, 7], ![1, 2, 8], ![1, 2, 9], ![1, 2, 10], ![1, 3, 0], ![1, 3, 1], ![1, 3, 2], ![1, 3, 3], ![1, 3, 4], ![1, 3, 5], ![1, 3, 6], ![1, 3, 7], ![1, 3, 8], ![1, 3, 9], ![1, 3, 10], ![1, 4, 0], ![1, 4, 1], ![1, 4, 2], ![1, 4, 3], ![1, 4, 4], ![1, 4, 5], ![1, 4, 6], ![1, 4, 7], ![1, 4, 8], ![1, 4, 9], ![1, 4, 10], ![1, 5, 0], ![1, 5, 1], ![1, 5, 2], ![1, 5, 3], ![1, 5, 4], ![1, 5, 5], ![1, 5, 6], ![1, 5, 7], ![1, 5, 8], ![1, 5, 9], ![1, 5, 10], ![1, 6, 0], ![1, 6, 1], ![1, 6, 2], ![1, 6, 3], ![1, 6, 4], ![1, 6, 5], ![1, 6, 6], ![1, 6, 7], ![1, 6, 8], ![1, 6, 9], ![1, 6, 10], ![1, 7, 0], ![1, 7, 1], ![1, 7, 2], ![1, 7, 3], ![1, 7, 4], ![1, 7, 5], ![1, 7, 6], ![1, 7, 7], ![1, 7, 8], ![1, 7, 9], ![1, 7, 10], ![1, 8, 0], ![1, 8, 1], ![1, 8, 2], ![1, 8, 3], ![1, 8, 4], ![1, 8, 5], ![1, 8, 6], ![1, 8, 7], ![1, 8, 8], ![1, 8, 9], ![1, 8, 10], ![1, 9, 0], ![1, 9, 1], ![1, 9, 2], ![1, 9, 3], ![1, 9, 4], ![1, 9, 5], ![1, 9, 6], ![1, 9, 7], ![1, 9, 8], ![1, 9, 9], ![1, 9, 10], ![1, 10, 0], ![1, 10, 1], ![1, 10, 2], ![1, 10, 3], ![1, 10, 4], ![1, 10, 5], ![1, 10, 6], ![1, 10, 7], ![1, 10, 8], ![1, 10, 9], ![1, 10, 10]]

/-- The common tetrahedral relation cell containing each normalized projective point. -/
def relationCell : ProjectivePoint → RelationCell := ![5, 5, 7, 3, 10, 1, 13, 13, 1, 10, 3, 7, 5, 7, 13, 1, 10, 3, 3, 10, 1, 13, 7, 7, 2, 8, 4, 12, 15, 15, 12, 4, 8, 2, 3, 8, 15, 14, 11, 11, 11, 11, 14, 15, 8, 10, 4, 6, 12, 6, 11, 11, 6, 12, 6, 4, 1, 12, 9, 14, 4, 14, 14, 4, 14, 9, 12, 13, 15, 9, 9, 6, 8, 8, 6, 9, 9, 15, 13, 15, 9, 9, 6, 8, 8, 6, 9, 9, 15, 1, 12, 9, 14, 4, 14, 14, 4, 14, 9, 12, 10, 4, 6, 12, 6, 11, 11, 6, 12, 6, 4, 3, 8, 15, 14, 11, 11, 11, 11, 14, 15, 8, 7, 2, 8, 4, 12, 15, 15, 12, 4, 8, 2]

/-- The projectivity from the icosahedral coordinates to the standard conic coordinates. -/
def h3ToStandard : Matrix (Fin 3) (Fin 3) (ZMod 11) := ![![8, 3, 2], ![3, 3, 0], ![3, 8, 2]]

/-- Homogeneous parameters for the twelve points of the standard conic. -/
def conicParameter : Endpoint → Fin 2 → ZMod 11 := ![![1, 0], ![1, 1], ![1, 7], ![1, 2], ![1, 9], ![1, 8], ![1, 10], ![0, 1], ![1, 6], ![1, 4], ![1, 5], ![1, 3]]

/-- Linear representatives for generators of the common tetrahedral subgroup. -/
def subgroupGeneratorMatrix : Generator → Matrix (Fin 3) (Fin 3) (ZMod 11) :=
  ![![![1, 0, 0], ![0, 10, 0], ![0, 0, 10]], ![![0, 1, 0], ![0, 0, 10], ![1, 0, 0]]]

/-- The induced generator actions on conic endpoints. -/
def subgroupGeneratorEndpoint : Generator → Endpoint → Endpoint :=
  ![![1, 0, 3, 2, 5, 4, 7, 6, 9, 8, 11, 10], ![3, 10, 8, 4, 0, 7, 2, 11, 6, 1, 9, 5]]

/-- The induced generator actions on normalized projective points. -/
def subgroupGeneratorPoint : Generator → ProjectivePoint → ProjectivePoint :=
  ![![0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 122, 132, 131, 130, 129, 128, 127, 126, 125, 124, 123, 111, 121, 120, 119, 118, 117, 116, 115, 114, 113, 112, 100, 110, 109, 108, 107, 106, 105, 104, 103, 102, 101, 89, 99, 98, 97, 96, 95, 94, 93, 92, 91, 90, 78, 88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 67, 77, 76, 75, 74, 73, 72, 71, 70, 69, 68, 56, 66, 65, 64, 63, 62, 61, 60, 59, 58, 57, 45, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 34, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 23, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24], ![1, 12, 122, 111, 100, 89, 78, 67, 56, 45, 34, 23, 0, 11, 6, 8, 9, 3, 10, 4, 5, 7, 2, 13, 123, 112, 101, 90, 79, 68, 57, 46, 35, 24, 18, 73, 128, 62, 117, 51, 106, 40, 95, 29, 84, 16, 93, 49, 126, 82, 38, 115, 71, 27, 104, 60, 15, 103, 70, 37, 125, 92, 59, 26, 114, 81, 48, 21, 43, 65, 87, 109, 131, 32, 54, 76, 98, 120, 14, 113, 91, 69, 47, 25, 124, 102, 80, 58, 36, 20, 53, 86, 119, 31, 64, 97, 130, 42, 75, 108, 19, 63, 107, 30, 74, 118, 41, 85, 129, 52, 96, 17, 83, 28, 94, 39, 105, 50, 116, 61, 127, 72, 22, 33, 44, 55, 66, 77, 88, 99, 110, 121, 132]]

/-- The induced generator actions on the twenty-two matching rows. -/
def subgroupGeneratorParent : Generator → Parent → Parent :=
  ![![0, 6, 3, 2, 9, 7, 1, 5, 8, 4, 10, 11, 15, 21, 18, 12, 16, 19, 14, 17, 20, 13], ![0, 5, 4, 2, 3, 10, 7, 8, 6, 9, 1, 19, 20, 21, 13, 11, 16, 12, 18, 15, 17, 14]]

/-- A linear representative of the involution exchanging the two sheets. -/
def sheetInvolutionMatrix : Matrix (Fin 3) (Fin 3) (ZMod 11) := ![![1, 0, 0], ![0, 0, 10], ![0, 10, 0]]

/-- The sheet involution on conic endpoints. -/
def sheetInvolutionEndpoint : Endpoint → Endpoint := ![2, 3, 0, 1, 5, 4, 11, 10, 8, 9, 7, 6]

/-- The sheet involution on normalized projective points. -/
def sheetInvolutionPoint : ProjectivePoint → ProjectivePoint := ![1, 0, 2, 7, 5, 4, 10, 3, 9, 8, 6, 11, 12, 122, 111, 100, 89, 78, 67, 56, 45, 34, 23, 22, 132, 121, 110, 99, 88, 77, 66, 55, 44, 33, 21, 131, 120, 109, 98, 87, 76, 65, 54, 43, 32, 20, 130, 119, 108, 97, 86, 75, 64, 53, 42, 31, 19, 129, 118, 107, 96, 85, 74, 63, 52, 41, 30, 18, 128, 117, 106, 95, 84, 73, 62, 51, 40, 29, 17, 127, 116, 105, 94, 83, 72, 61, 50, 39, 28, 16, 126, 115, 104, 93, 82, 71, 60, 49, 38, 27, 15, 125, 114, 103, 92, 81, 70, 59, 48, 37, 26, 14, 124, 113, 102, 91, 80, 69, 58, 47, 36, 25, 13, 123, 112, 101, 90, 79, 68, 57, 46, 35, 24]

/-- The sheet involution on matching rows. -/
def sheetInvolutionParent : Parent → Parent := ![16, 12, 21, 13, 18, 17, 15, 19, 20, 14, 11, 10, 1, 3, 9, 6, 0, 5, 4, 7, 8, 2]

/-- The induced permutation of the sixteen relation cells. -/
def sheetInvolutionRelation : RelationCell → RelationCell := ![0, 10, 2, 13, 4, 5, 14, 7, 8, 11, 1, 9, 12, 3, 6, 15]

/-- Four oriented pairs of relation cells exchanged by the sheet involution. -/
def orientedRelationPair : Fin 4 → Fin 2 → RelationCell :=
  ![![1, 10], ![3, 13], ![6, 14], ![9, 11]]

/-- One matching-row representative for each of the six generator orbits. -/
def orbitRepresentative : Fin 6 → Parent := ![0, 2, 10, 16, 21, 11]

end ClebschDoubleCosetDepth
end RelativeConicArcs
