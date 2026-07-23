import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Data.Matrix.Basic

/-!
# Ternary twelve-coordinate code and permutation data

This definitions-only module records a generator matrix for a ternary linear code of length
twelve, an order-twelve sign matrix, and explicit degree-twelve permutations acting on the code
and its minimum-support design.  Coordinates and permutation images are numbered from zero.

The companion definitions module and independently compiled checker leaves derive the code,
support design, secant configuration, and finite permutation-action statements from these
literals.  The classical names of the permutation groups are not encoded here.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

abbrev F3 := ZMod 3
abbrev Word12 := Fin 12 → F3
abbrev SignRow12 := Fin 12 → Int
abbrev Perm12 := Fin 12 → Fin 12

/-- A systematic generator matrix for the extended ternary `[12,6]` code. -/
def generatorMatrix : Fin 6 → Word12 :=
  ![
    ![1, 0, 0, 0, 0, 0, 2, 0, 1, 2, 1, 2],
    ![0, 1, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0],
    ![0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1],
    ![0, 0, 0, 1, 0, 0, 1, 1, 0, 2, 2, 2],
    ![0, 0, 0, 0, 1, 0, 2, 1, 2, 2, 0, 1],
    ![0, 0, 0, 0, 0, 1, 0, 2, 1, 2, 2, 1]
  ]

/-- The cyclic quadratic-residue difference block in the punctured eleven-coordinate model. -/
def residueBlock : Finset (Fin 11) := {3, 4, 5, 7, 10}

/-- The normalized length-eleven Barker sign word. -/
def barkerWord : List Int := [1, 1, 1, -1, -1, -1, 1, -1, -1, 1, -1]

/-- The sign matrix whose rows represent all projective full-support codewords. -/
def hadamardSign : Fin 12 → SignRow12 :=
  ![
    ![ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ![ 1, 1, 1,-1,-1,-1, 1,-1, 1, 1,-1,-1],
    ![-1, 1, 1, 1,-1,-1,-1, 1,-1, 1, 1,-1],
    ![ 1,-1, 1, 1, 1,-1,-1,-1, 1,-1, 1,-1],
    ![ 1, 1,-1, 1, 1, 1,-1,-1,-1, 1,-1,-1],
    ![-1, 1, 1,-1, 1, 1, 1,-1,-1,-1, 1,-1],
    ![ 1,-1, 1, 1,-1, 1, 1, 1,-1,-1,-1,-1],
    ![-1, 1,-1, 1, 1,-1, 1, 1, 1,-1,-1,-1],
    ![-1,-1, 1,-1, 1, 1,-1, 1, 1, 1,-1,-1],
    ![-1,-1,-1, 1,-1, 1, 1,-1, 1, 1, 1,-1],
    ![ 1,-1,-1,-1, 1,-1, 1, 1,-1, 1, 1,-1],
    ![ 1, 1,-1,-1,-1, 1,-1, 1, 1,-1, 1,-1]
  ]

/-- Generators of the frozen order-660 degree-twelve action. -/
def frozenGenerators : Fin 2 → Perm12 :=
  ![
    ![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11],
    ![8, 2, 1, 7, 5, 4, 6, 3, 0, 9, 10, 11]
  ]

/-- The frozen action induced on the twelve projective full-support words. -/
def frozenRowGenerators : Fin 2 → Perm12 :=
  ![
    ![0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 1],
    ![0, 1, 2, 11, 8, 5, 7, 6, 4, 10, 9, 3]
  ]

/-- Generators of the transitive degree-twelve parent action preserving the signed code. -/
def transitiveParentGenerators : Fin 2 → Perm12 :=
  ![
    ![1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 11],
    ![11, 6, 4, 10, 8, 7, 3, 5, 9, 2, 1, 0]
  ]

/-- Generators of the parity-coordinate stabilizer parent action. -/
def fixedPointParentGenerators : Fin 2 → Perm12 :=
  ![
    ![0, 3, 7, 5, 4, 9, 8, 6, 2, 1, 10, 11],
    ![6, 4, 3, 8, 7, 5, 1, 0, 9, 10, 2, 11]
  ]

/-- Generators of the full minimum-support permutation action. -/
def designGenerators : Fin 2 → Perm12 :=
  ![
    ![10, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11],
    ![1, 11, 0, 2, 5, 3, 6, 4, 7, 8, 9, 10]
  ]

/-- Coordinate signs for the chosen monomial lifts of the design generators. -/
def designGeneratorSigns : Fin 2 → Word12 :=
  ![
    ![1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ![1, 1, 2, 1, 1, 1, 2, 2, 2, 1, 2, 2]
  ]

/-- Permutations induced on sign-matrix rows by the two design generators. -/
def rowGenerators : Fin 2 → Perm12 :=
  ![
    ![0, 11, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    ![10, 6, 4, 5, 0, 1, 2, 7, 9, 3, 11, 8]
  ]

/-- A carrier relabelling aligning the row action with the coordinate action. -/
def rowCarrierRelabelling : Perm12 :=
  ![0, 6, 10, 9, 3, 5, 8, 4, 1, 2, 11, 7]

/-- The inverse of the row-carrier relabelling. -/
def rowCarrierRelabellingInverse : Perm12 :=
  ![0, 8, 9, 4, 7, 5, 1, 11, 6, 3, 2, 10]

/-- A permutation witnessing that the square of row/column duality is inner. -/
def dualitySquareConjugator : Perm12 :=
  ![8, 9, 10, 6, 11, 7, 0, 3, 5, 4, 1, 2]

end ClebschWittHadamard
end RelativeConicArcs
