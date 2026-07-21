import RelativeConicArcs.ClebschHarmonicQuotient
import Mathlib.LinearAlgebra.Dimension.Constructions

/-!
# Finite quotient coordinates for the Coxeter factorization configurations

The three arrays below are literal prime-field coordinates for the factorization-difference
quotients attached to the distinguished `A3`, `B3`, and `H3` perfect-matching orbits.  A quotient
is expressed after an invertible change of coordinates in its image: the listed basis columns are
standard coordinate vectors.  For `B3` and `H3`, the sign arrays are `+1` and `-1` on the two
orbits of the index-two projective special linear subgroup.

The arrays are untrusted input.  This module contains only definitions; separate checker leaves
establish the image dimensions, signed lower-moment cancellations, and cubic nonvanishing by
kernel reduction.
-/

namespace RelativeConicArcs
namespace ClebschFactorization

open scoped BigOperators

/-- The linear map whose columns are a finite vector configuration. -/
def configurationMap {R : Type*} [CommRing R] {n r : ℕ}
    (vectors : Fin n → Fin r → R) : (Fin n → R) →ₗ[R] (Fin r → R) where
  toFun coefficients coordinate :=
    ∑ column, coefficients column * vectors column coordinate
  map_add' left right := by
    funext coordinate
    simp only [Pi.add_apply, add_mul, Finset.sum_add_distrib]
  map_smul' scalar coefficients := by
    funext coordinate
    simp only [Pi.smul_apply, smul_eq_mul, mul_assoc, Finset.mul_sum, RingHom.id_apply]

/-- A checked certificate that selected configuration columns are the standard coordinate basis. -/
def HasCoordinateBasis {R : Type*} [CommRing R] {n r : ℕ}
    (vectors : Fin n → Fin r → R) (basisColumns : Fin r → Fin n) : Prop :=
  ∀ i j, vectors (basisColumns i) j = if i = j then 1 else 0

/-- The signed first moment of a finite vector configuration. -/
def signedFirstMoment {R : Type*} [CommRing R] {n r : ℕ}
    (vectors : Fin n → Fin r → R) (signs : Fin n → R) : Fin r → R :=
  fun i => ∑ column, signs column * vectors column i

/-- The signed second moment, recorded in ordered coordinate pairs. -/
def signedSecondMoment {R : Type*} [CommRing R] {n r : ℕ}
    (vectors : Fin n → Fin r → R) (signs : Fin n → R) : Fin r → Fin r → R :=
  fun i j => ∑ column, signs column * vectors column i * vectors column j

/-- Evaluation of the signed cubic moment by a coordinate monomial. -/
def signedCubicCoordinate {R : Type*} [CommRing R] {n r : ℕ}
    (vectors : Fin n → Fin r → R) (signs : Fin n → R) (i j k : Fin r) : R :=
  ∑ column, signs column * vectors column i * vectors column j * vectors column k

/-- The finite checker predicate for vanishing signed moments through degree two and one specified
nonzero coordinate of the signed cubic moment. -/
def ChecksSignedMomentWitness {R : Type*} [CommRing R] {n r : ℕ}
    (vectors : Fin n → Fin r → R) (signs : Fin n → R) (i j k : Fin r) (value : R) : Prop :=
  signedFirstMoment vectors signs = 0 ∧
    signedSecondMoment vectors signs = 0 ∧
    signedCubicCoordinate vectors signs i j k = value ∧ value ≠ 0

/-- Quotient-image coordinates for the five `A3` factorization points over `𝔽₅`. -/
def a3Vectors : Fin 5 → Fin 3 → ZMod 5 := ![
  ![1, 0, 0],
  ![0, 1, 0],
  ![0, 0, 1],
  ![4, 4, 4],
  ![0, 0, 0]
]

/-- Columns that form the displayed coordinate basis for the `A3` configuration. -/
def a3BasisColumns : Fin 3 → Fin 5 := ![0, 1, 2]

/-- Quotient-image coordinates for the fourteen `B3` factorization points over `𝔽₇`. -/
def b3Vectors : Fin 14 → Fin 6 → ZMod 7 := ![
  ![1, 0, 0, 0, 0, 0], ![0, 1, 0, 0, 0, 0], ![0, 0, 0, 0, 0, 0],
  ![0, 0, 1, 0, 0, 0], ![0, 0, 0, 1, 0, 0], ![0, 0, 0, 0, 1, 0],
  ![0, 0, 0, 0, 0, 1], ![3, 4, 1, 4, 3, 1], ![4, 4, 6, 3, 5, 3],
  ![3, 5, 0, 6, 2, 3], ![2, 2, 3, 6, 2, 4], ![3, 1, 6, 0, 1, 4],
  ![4, 4, 0, 0, 4, 6], ![1, 0, 4, 1, 3, 6]
]

/-- Columns that form the displayed coordinate basis for the `B3` configuration. -/
def b3BasisColumns : Fin 6 → Fin 14 := ![0, 1, 3, 4, 5, 6]

/-- The two-valued sheet sign on the `B3` configuration. -/
def b3SheetSigns : Fin 14 → ZMod 7 := ![1, 6, 1, 6, 1, 6, 1, 6, 6, 1, 1, 6, 6, 1]

/-- Quotient-image coordinates for the twenty-two `H3` factorization points over `𝔽₁₁`. -/
def h3Vectors : Fin 22 → Fin 10 → ZMod 11 := ![
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 0], ![1, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  ![0, 1, 0, 0, 0, 0, 0, 0, 0, 0], ![0, 0, 1, 0, 0, 0, 0, 0, 0, 0],
  ![0, 0, 0, 1, 0, 0, 0, 0, 0, 0], ![0, 0, 0, 0, 1, 0, 0, 0, 0, 0],
  ![0, 0, 0, 0, 0, 1, 0, 0, 0, 0], ![0, 0, 0, 0, 0, 0, 1, 0, 0, 0],
  ![0, 0, 0, 0, 0, 0, 0, 1, 0, 0], ![0, 0, 0, 0, 0, 0, 0, 0, 1, 0],
  ![0, 0, 0, 0, 0, 0, 0, 0, 0, 1], ![6, 4, 7, 2, 9, 4, 7, 6, 5, 1],
  ![4, 3, 3, 6, 9, 2, 0, 1, 3, 6], ![6, 10, 7, 0, 4, 6, 7, 0, 4, 6],
  ![0, 2, 0, 5, 2, 6, 10, 10, 5, 10], ![10, 7, 6, 10, 8, 7, 9, 0, 4, 10],
  ![1, 1, 0, 5, 1, 6, 0, 10, 0, 10], ![5, 7, 5, 9, 8, 8, 9, 5, 5, 10],
  ![0, 6, 1, 10, 6, 2, 5, 0, 9, 5], ![4, 4, 3, 6, 10, 8, 10, 1, 8, 5],
  ![6, 10, 6, 1, 9, 5, 7, 0, 5, 1], ![1, 0, 5, 0, 10, 0, 1, 10, 6, 1]
]

/-- Columns that form the displayed coordinate basis for the `H3` configuration. -/
def h3BasisColumns : Fin 10 → Fin 22 := ![1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

/-- The two-valued sheet sign on the `H3` configuration. -/
def h3SheetSigns : Fin 22 → ZMod 11 :=
  ![1, 10, 10, 1, 1, 10, 1, 10, 10, 1, 10, 1, 10, 1, 10, 1, 10, 1, 1, 10, 1, 10]

end ClebschFactorization
end RelativeConicArcs
