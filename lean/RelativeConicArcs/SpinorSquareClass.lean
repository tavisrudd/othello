import Mathlib.GroupTheory.QuotientGroup.Basic
import RelativeConicArcs.GoldenQuadraticCharacters

/-!
# Spinor classes from reflection factorizations

For a field `K`, its square-class group is the quotient of `Kˣ` by the
subgroup of squares.  A reflection factorization with nonisotropic reflecting
vectors has spinor class equal to the product of their quadratic norms in this
quotient.  This module packages that definition for arbitrary norm functions
and then applies it to the two-reflection factorization of the Clebsch
configuration exchanger.
-/

namespace RelativeConicArcs.SpinorSquareClass

variable (K : Type*) [Field K]

/-- The multiplicative square-class group `Kˣ/Kˣ²`. -/
abbrev SquareClass := Kˣ ⧸ (powMonoidHom 2 : Kˣ →* Kˣ).range

/-- The quotient homomorphism from nonzero scalars to square classes. -/
def squareClassHom : Kˣ →* SquareClass K :=
  QuotientGroup.mk' (powMonoidHom 2 : Kˣ →* Kˣ).range

variable {K}
variable {V : Type*}

/-- A nonisotropic vector for a scalar-valued quadratic norm. -/
abbrev Nonisotropic (Q : V → K) := {v : V // Q v ≠ 0}

/-- The unit represented by the norm of a nonisotropic vector. -/
def normUnit (Q : V → K) (v : Nonisotropic Q) : Kˣ :=
  Units.mk0 (Q v.1) v.2

/-- The spinor class represented by a list of reflecting vectors. -/
def ofReflectionList (Q : V → K) (vectors : List (Nonisotropic Q)) :
    SquareClass K :=
  squareClassHom K (vectors.map (normUnit Q)).prod

/-- Concatenating reflection factorizations multiplies their spinor classes. -/
theorem ofReflectionList_append (Q : V → K)
    (left right : List (Nonisotropic Q)) :
    ofReflectionList Q (left ++ right) =
      ofReflectionList Q left * ofReflectionList Q right := by
  simp [ofReflectionList, squareClassHom]

/-- A two-reflection factorization represents the product of the two norms. -/
theorem ofReflectionList_pair (Q : V → K) (v w : Nonisotropic Q) :
    ofReflectionList Q [v, w] = squareClassHom K (normUnit Q v * normUnit Q w) := by
  simp [ofReflectionList]

/-! ## The Clebsch exchanger -/

open GoldenQuadraticCharacters

/-- The first nonisotropic vector in the exchanger factorization. -/
def exchangerVectorData : Nonisotropic standardNormSq :=
  ⟨exchangerReflectionVector, by
    rw [exchanger_reflection_norms.1]
    norm_num⟩

/-- The second nonisotropic vector in the exchanger factorization. -/
def swapVectorData : Nonisotropic standardNormSq :=
  ⟨swapReflectionVector, by
    rw [exchanger_reflection_norms.2]
    norm_num⟩

/-- The exchanger's reflection factorization has square class `[2]`. -/
theorem exchanger_spinorClass :
    ofReflectionList standardNormSq [exchangerVectorData, swapVectorData] =
      squareClassHom ℚ (Units.mk0 2 (by norm_num)) := by
  rw [ofReflectionList_pair]
  apply congrArg (squareClassHom ℚ)
  apply Units.ext
  simp [normUnit, exchangerVectorData, swapVectorData,
    exchanger_reflection_norms]

end RelativeConicArcs.SpinorSquareClass
