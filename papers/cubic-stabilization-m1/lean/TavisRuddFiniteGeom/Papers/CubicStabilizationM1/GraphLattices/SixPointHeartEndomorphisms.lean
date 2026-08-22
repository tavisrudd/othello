import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointThreePrimary
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointSylowFiveAction

/-!
# Simplicity and endomorphism algebras of the two six-point hearts

Let `Omega` be the six order-five subgroups of the alternating group on five
letters, equivalently their six normalizers, and let `F` be a prime field of
characteristic two or three.  The permutation module `F^Omega` contains the
augmentation hyperplane of vectors whose coordinate sum vanishes, and that
hyperplane contains the constant line, because six is divisible by both two and
three.  The heart is the quotient of the hyperplane by the constant line; it has
dimension four over `F`.

This module states, in one theorem, simplicity of both hearts under the
generated six-label action together with the exact matrix commutant of that
action in each characteristic.  The commutant is the endomorphism algebra of
the heart as a module over the generated group.

In characteristic two the commutant is `{0, 1, W, W + 1}`, where
`W ^ 2 + W + 1 = 0` and `W * (W + 1) = 1`, so it is a commutative ring with four
elements in which every nonzero element is invertible: the field with four
elements.  In characteristic three the commutant consists of the scalar matrices
alone, which is the prime field with three elements.

The generated action is the whole alternating group on five letters, and the six
labels carry `Omega`.  Both facts are proved elsewhere in this package and are
used here only as context:
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.sixPointGeneratedAction_realizes_alternatingGroup`
shows the generator words realize the alternating group faithfully and onto,
while
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.sixPointFiveSubgroup_injective`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.sixPointFiveSubgroup_card`,
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.sixPointFiveSubgroup_translation_conjugation`,
and
`TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.sixPointFiveSubgroup_inversion_conjugation`
show the six labels index six distinct order-five subgroups permuted by
conjugation exactly as the labels are permuted by the two generators.

The two hearts are given by explicit charts.  In characteristic two the chart
sends a six-coordinate vector to the four differences of its first four
coordinates with its last, and its kernel on the augmentation hyperplane is
exactly the constant line.  In characteristic three the chart is the linear
equivalence of the literal quotient with four coordinates.  Under both charts
the label permutations `z + 1` and `-1 / z` of the projective line over the
field with five elements induce the displayed generator matrices.

All finite identities are checked by kernel reduction over the explicit prime
fields `ZMod 2` and `ZMod 3`.  No native evaluation, external certificate, or
oracle is used.  The modules constructing the two hearts do not identify the six
labels with dihedral subgroups arising from a geometric object, and neither does
this module.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped Matrix

/-- The two nonzero elements of the characteristic-two commutant are inverse to
each other, so every nonzero commutant element is invertible. -/
theorem sixPointHeartCommutantRoot_mul_add_one :
    sixPointHeartCommutantRoot * (sixPointHeartCommutantRoot + 1) = 1 := by
  ext row column
  fin_cases row <;> fin_cases column <;> decide

/-- The distinguished commutant generator is not the zero matrix. -/
theorem sixPointHeartCommutantRoot_ne_zero :
    sixPointHeartCommutantRoot ≠ 0 := by
  intro equality
  have entry := congrFun (congrFun equality 0) 2
  simp [sixPointHeartCommutantRoot] at entry

/-- The distinguished commutant generator is not the identity matrix. -/
theorem sixPointHeartCommutantRoot_ne_one :
    sixPointHeartCommutantRoot ≠ 1 := by
  intro equality
  have entry := congrFun (congrFun equality 0) 0
  simp [sixPointHeartCommutantRoot] at entry

/-- The zero and identity matrices of the four-dimensional heart differ, so the
four displayed commutant elements are pairwise distinct. -/
theorem sixPointHeart_zero_ne_one :
    (0 : Matrix (Fin 4) (Fin 4) F2) ≠ 1 := by
  intro equality
  have entry := congrFun (congrFun equality 0) 0
  simp at entry

/-- A subspace of the characteristic-two heart stable under every generator
word is stable under the two generators, hence is zero or everything. -/
theorem sixPointHeartWordStable_simple
    (subspace : Submodule F2 (Fin 4 → F2))
    (stable : ∀ (word : List Bool) (vector : Fin 4 → F2), vector ∈ subspace →
      Matrix.mulVec (sixPointHeartWordMatrix word) vector ∈ subspace) :
    subspace = ⊥ ∨ subspace = ⊤ := by
  refine sixPointHeartGeneratorStable_simple subspace ⟨?_, ?_⟩
  · intro vector member
    simpa [sixPointHeartWordMatrix] using stable [false] vector member
  · intro vector member
    simpa [sixPointHeartWordMatrix] using stable [true] vector member

/-- The matrix of a word in the three-primary translation (`false`) and
inversion (`true`) generators, composed in the same order as the word. -/
def sixPointThreeHeartWordMatrix : List Bool → Matrix (Fin 4) (Fin 4) F3
  | [] => 1
  | generator :: word =>
      sixPointThreeHeartWordMatrix word *
        (if generator then sixPointThreeHeartInversion
          else sixPointThreeHeartTranslation)

/-- A subspace of the three-primary heart stable under every generator word is
stable under the two generators, hence is zero or everything. -/
theorem sixPointThreeHeartWordStable_simple
    (subspace : Submodule F3 SixPointThreeHeart)
    (stable : ∀ (word : List Bool) (vector : SixPointThreeHeart),
      vector ∈ subspace →
        Matrix.mulVec (sixPointThreeHeartWordMatrix word) vector ∈ subspace) :
    subspace = ⊥ ∨ subspace = ⊤ := by
  refine sixPointThreeHeartGeneratorStable_simple subspace ⟨?_, ?_⟩
  · intro vector member
    simpa [sixPointThreeHeartWordMatrix] using stable [false] vector member
  · intro vector member
    simpa [sixPointThreeHeartWordMatrix] using stable [true] vector member

/-- The commutant of the full generated three-primary action is the same
scalar algebra as the common commutant of the two generators. -/
theorem sixPointThreeHeart_fullActionCommutant_classification
    (matrix : Matrix (Fin 4) (Fin 4) F3) :
    (∀ word : List Bool,
      matrix * sixPointThreeHeartWordMatrix word =
        sixPointThreeHeartWordMatrix word * matrix) ↔
      ∃ value : F3, matrix = Matrix.scalar (Fin 4) value := by
  constructor
  · intro commutes
    refine (sixPointThreeHeart_commonCommutant_classification matrix).mp ⟨?_, ?_⟩
    · simpa [sixPointThreeHeartWordMatrix] using commutes [false]
    · simpa [sixPointThreeHeartWordMatrix] using commutes [true]
  · rintro ⟨value, rfl⟩ word
    exact Matrix.scalar_commute value (fun other => Commute.all value other) _

/-- The two six-point hearts are simple, with endomorphism algebras the field
with four elements in characteristic two and the field with three elements in
characteristic three.

The first three clauses fix the characteristic-two heart: the difference chart
is surjective onto four coordinates, its kernel on the augmentation hyperplane
is exactly the constant vectors, and the two label permutations induce the
displayed generator matrices.  The next two clauses state that every subspace
stable under the generated action is zero or everything, and that the commutant
of the generated action is `{0, 1, W, W + 1}`.  The sixth clause exhibits that
commutant as the field with four elements: `W ^ 2 + W + 1 = 0`, the two nonzero
nonidentity elements are inverse to each other, and the four elements are
pairwise distinct.

The remaining clauses are the characteristic-three statements in the same
order, with the chart given by the linear equivalence of the literal quotient
`Aug(F₃⁶)/⟨1⟩` with four coordinates, and with the commutant consisting of the
scalar matrices alone, that is, the prime field with three elements. -/
theorem sixPointHearts_simple_with_endomorphism_algebras :
    (∀ heart : Fin 4 → F2,
        sixPointHeartCoordinates (sixPointHeartRepresentative heart) = heart) ∧
      (∀ vector : Fin 6 → F2, ∑ point, vector point = 0 →
        (sixPointHeartCoordinates vector = 0 ↔ ∀ point, vector point = vector 5)) ∧
      (∀ heart : Fin 4 → F2,
        sixPointHeartCoordinates
            (sixPointHeartRepresentative heart ∘ sixPointTranslationPreimage) =
          Matrix.mulVec sixPointHeartTranslation heart ∧
        sixPointHeartCoordinates
            (sixPointHeartRepresentative heart ∘ sixPointInversionPreimage) =
          Matrix.mulVec sixPointHeartInversion heart) ∧
      (∀ subspace : Submodule F2 (Fin 4 → F2),
        (∀ (word : List Bool) (vector : Fin 4 → F2), vector ∈ subspace →
          Matrix.mulVec (sixPointHeartWordMatrix word) vector ∈ subspace) →
          subspace = ⊥ ∨ subspace = ⊤) ∧
      (∀ matrix : Matrix (Fin 4) (Fin 4) F2,
        (∀ word : List Bool,
          matrix * sixPointHeartWordMatrix word =
            sixPointHeartWordMatrix word * matrix) ↔
          matrix = 0 ∨ matrix = 1 ∨ matrix = sixPointHeartCommutantRoot ∨
            matrix = sixPointHeartCommutantRoot + 1) ∧
      (sixPointHeartCommutantRoot ^ 2 + sixPointHeartCommutantRoot + 1 = 0 ∧
        sixPointHeartCommutantRoot * (sixPointHeartCommutantRoot + 1) = 1 ∧
        sixPointHeartCommutantRoot ≠ 0 ∧ sixPointHeartCommutantRoot ≠ 1 ∧
        (0 : Matrix (Fin 4) (Fin 4) F2) ≠ 1) ∧
      (∀ vector : SixPointThreeAugmentation,
        sixPointThreeAugmentationQuotientEquivHeart (Submodule.Quotient.mk vector) =
          sixPointThreeHeartCoordinates vector.1) ∧
      (∀ heart : SixPointThreeAugmentationQuotient,
        sixPointThreeAugmentationQuotientEquivHeart
              (sixPointThreeAugmentationQuotientTranslation heart) =
            Matrix.mulVec sixPointThreeHeartTranslation
              (sixPointThreeAugmentationQuotientEquivHeart heart) ∧
          sixPointThreeAugmentationQuotientEquivHeart
              (sixPointThreeAugmentationQuotientInversion heart) =
            Matrix.mulVec sixPointThreeHeartInversion
              (sixPointThreeAugmentationQuotientEquivHeart heart)) ∧
      (∀ subspace : Submodule F3 SixPointThreeHeart,
        (∀ (word : List Bool) (vector : SixPointThreeHeart), vector ∈ subspace →
          Matrix.mulVec (sixPointThreeHeartWordMatrix word) vector ∈ subspace) →
          subspace = ⊥ ∨ subspace = ⊤) ∧
      (∀ matrix : Matrix (Fin 4) (Fin 4) F3,
        (∀ word : List Bool,
          matrix * sixPointThreeHeartWordMatrix word =
            sixPointThreeHeartWordMatrix word * matrix) ↔
          ∃ value : F3, matrix = Matrix.scalar (Fin 4) value) :=
  ⟨sixPointHeartCoordinates_representative,
    sixPointHeartCoordinates_eq_zero_iff_constant,
    fun heart => ⟨sixPointHeartCoordinates_translation heart,
      sixPointHeartCoordinates_inversion heart⟩,
    sixPointHeartWordStable_simple,
    sixPointHeart_fullActionCommutant_classification,
    ⟨sixPointHeartCommutantRoot_quadratic,
      sixPointHeartCommutantRoot_mul_add_one,
      sixPointHeartCommutantRoot_ne_zero,
      sixPointHeartCommutantRoot_ne_one,
      sixPointHeart_zero_ne_one⟩,
    sixPointThreeAugmentationQuotientEquivHeart_mk,
    fun heart => ⟨sixPointThreeAugmentationQuotientEquivHeart_translation heart,
      sixPointThreeAugmentationQuotientEquivHeart_inversion heart⟩,
    sixPointThreeHeartWordStable_simple,
    sixPointThreeHeart_fullActionCommutant_classification⟩

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
