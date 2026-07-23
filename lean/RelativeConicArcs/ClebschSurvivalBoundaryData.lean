import Mathlib.Data.Matrix.Basic
import Mathlib.Data.ZMod.Basic

/-!
# Finite data for survival and erasure boundaries

This definitions-only module records four bounded data sets.

* A four-by-four table records which of four companion matching orbits reaches a frozen
  characteristic-eleven sheet at each of four cyclotomic reductions.
* A four-by-four minor records selected linear and quadratic moment coordinates of the full
  descended companion-weight map over `ZMod 11`.
* Four rational incidence matrices record the shared-edge and disjoint relations between the
  two matching sheets of sizes seven and eleven.
* A three-by-three quotient matrix records the values of three annihilating functionals on the
  three-dimensional relative-cubic space.  The same functionals vanish on the tested symmetric
  cube of the frozen five-dimensional component.

The module contains literals only.  Their geometric, representation-theoretic, and
characteristic-zero interpretations are deliberately not encoded here.
-/

namespace RelativeConicArcs
namespace ClebschSurvivalBoundary

abbrev F11 := ZMod 11

/-- Rows are the reductions `ζ = 3,4,5,9`; columns are the four companion orbits.
An entry is true exactly when that companion reaches a frozen sheet at that reduction. -/
def companionSheetHits : Fin 4 → Fin 4 → Bool :=
  ![
    ![false, false, false, true],
    ![true, false, false, false],
    ![false, true, false, false],
    ![false, false, true, false]
  ]

/-- Complex conjugation on the four companion-orbit labels. -/
def companionConjugation : Fin 4 → Fin 4 := ![3, 2, 1, 0]

/-- A full-rank minor selected from the stacked degree-one and degree-two moment map.
The rows are coordinates `4,18,19,21` in the frozen stacked coordinate order. -/
def lowerMomentMinor : Matrix (Fin 4) (Fin 4) F11 :=
  ![
    ![4, 7, 4, 6],
    ![5, 8, 5, 0],
    ![9, 9, 10, 0],
    ![0, 0, 0, 7]
  ]

/-- An inverse certificate for `lowerMomentMinor`. -/
def lowerMomentMinorInverse : Matrix (Fin 4) (Fin 4) F11 :=
  ![
    ![3, 4, 10, 10],
    ![9, 6, 0, 8],
    ![9, 2, 1, 8],
    ![0, 0, 0, 8]
  ]

/-- Shared-edge incidence between the two seven-element matching sheets. -/
def sevenSharedEdge : Matrix (Fin 7) (Fin 7) ℚ :=
  ![
    ![1, 0, 1, 1, 1, 0, 0],
    ![1, 1, 1, 0, 0, 1, 0],
    ![0, 0, 1, 1, 0, 1, 1],
    ![0, 1, 0, 1, 1, 1, 0],
    ![0, 1, 1, 0, 1, 0, 1],
    ![1, 0, 0, 0, 1, 1, 1],
    ![1, 1, 0, 1, 0, 0, 1]
  ]

/-- Disjointness incidence between the two seven-element matching sheets. -/
def sevenDisjoint : Matrix (Fin 7) (Fin 7) ℚ :=
  ![
    ![0, 1, 0, 0, 0, 1, 1],
    ![0, 0, 0, 1, 1, 0, 1],
    ![1, 1, 0, 0, 1, 0, 0],
    ![1, 0, 1, 0, 0, 0, 1],
    ![1, 0, 0, 1, 0, 1, 0],
    ![0, 1, 1, 1, 0, 0, 0],
    ![0, 0, 1, 0, 1, 1, 0]
  ]

/-- Shared-edge incidence between the two eleven-element matching sheets. -/
def elevenSharedEdge : Matrix (Fin 11) (Fin 11) ℚ :=
  ![
    ![1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 1],
    ![1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0],
    ![1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1],
    ![0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1],
    ![0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1],
    ![1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 0],
    ![0, 0, 1, 1, 0, 0, 1, 1, 1, 1, 0],
    ![0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0],
    ![1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1],
    ![1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 0],
    ![0, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1]
  ]

/-- Disjointness incidence between the two eleven-element matching sheets. -/
def elevenDisjoint : Matrix (Fin 11) (Fin 11) ℚ :=
  ![
    ![0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0],
    ![0, 0, 1, 0, 1, 0, 0, 1, 0, 1, 1],
    ![0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0],
    ![1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0],
    ![1, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0],
    ![0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 1],
    ![1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1],
    ![1, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1],
    ![0, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0],
    ![0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1],
    ![1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0]
  ]

/-- Values of three five-space-annihilating functionals on a basis of the relative cubics. -/
def relativeCubicQuotient : Matrix (Fin 3) (Fin 3) F11 :=
  ![
    ![0, 9, 10],
    ![9, 1, 1],
    ![6, 3, 2]
  ]

/-- An inverse certificate for `relativeCubicQuotient`. -/
def relativeCubicQuotientInverse : Matrix (Fin 3) (Fin 3) F11 :=
  ![
    ![7, 4, 7],
    ![7, 2, 8],
    ![7, 7, 6]
  ]

/-- The three quotient functionals vanish on all 35 monomial columns of the tested
symmetric cube of the five-dimensional component.  The identification of these columns with
that component is an external finite-certificate boundary. -/
def fiveSpaceCubicQuotient : Matrix (Fin 3) (Fin 35) F11 := 0

end ClebschSurvivalBoundary
end RelativeConicArcs
