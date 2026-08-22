import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAlternatingAction
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointPacketLabelGroup

/-!
# The fifteen pairs of labels inside the coefficient heart

The four-dimensional characteristic-two coefficient heart of six labels is the
augmentation hyperplane of `F₂⁶` modulo its constant line.  The indicator
vector of a pair of distinct labels lies in that hyperplane, and the fifteen
pairs give the fifteen nonzero heart vectors, each exactly once.  This module
sets up that correspondence and uses it to describe two structures on the heart
in one another's terms.

The first structure is the distinguished element `W` of the quadratic
commutant, characterized by `W² = W + 1`.  Multiplication by `W` has no nonzero
fixed vector, so it partitions the fifteen nonzero heart vectors into five
orbits of three.

The second structure is the displayed one-factorization of the fifteen pairs
into five perfect matchings, each matching given as a fixed-point-free
involution of the six labels.

Results.  Under the correspondence the two structures agree: two nonzero heart
vectors lie in the same matching exactly when one is obtained from the other by
multiplication by `W` or by `W + 1`, so each matching of the displayed
one-factorization is one orbit of multiplication by `W`.  Consequently a
permutation of the six labels preserves the one-factorization, meaning that it
carries every matching to a matching, exactly when conjugation by its heart
matrix carries `W` to `W` or to `W + 1`.  The permutations whose heart matrix
centralizes `W` are exactly the even permutations among those, so centralizing
`W` is preservation of the one-factorization together with a parity condition,
and not preservation of the one-factorization alone.

The proof that preserving the one-factorization forces the conjugate of `W`
into the pair `W`, `W + 1` is structural rather than an enumeration of the
seven hundred twenty permutations: preservation makes the conjugate carry each
orbit to itself, so at every nonzero vector it agrees with multiplication by
`W` or with multiplication by `W + 1`, and additivity forces one of those two
choices at every vector at once, because a mixed pair of choices evaluates the
conjugate at the sum of the two vectors in two incompatible ways.

The finite inputs are closed equalities over the field with two elements and
over the six labels, checked by kernel reduction.  No native execution,
external certificate, or oracle is used.  The six labels here are abstract; the
module constructs no geometric Galois action and does not identify them with
the six conjugate dihedral subgroups of a geometric argument.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped Matrix

/-- The characteristic-two indicator vector of a pair of labels: it is one at
each of the two labels and zero elsewhere, and it is zero for equal labels. -/
def sixPointDuadVector (first second : Fin 6) : Fin 6 → F2 := fun label ↦
  (if label = first then 1 else 0) + (if label = second then 1 else 0)

/-- The heart coordinates of the indicator vector of a pair of labels. -/
def sixPointDuadHeart (first second : Fin 6) : Fin 4 → F2 :=
  sixPointHeartCoordinates (sixPointDuadVector first second)

/-- Indicator vectors of pairs lie in the augmentation hyperplane: their six
coordinates sum to zero. -/
theorem sixPointDuadVector_sum_zero (first second : Fin 6) :
    ∑ label, sixPointDuadVector first second label = 0 := by
  revert first second
  decide

/-- The heart vector of a pair does not depend on the order of its two
labels. -/
theorem sixPointDuadHeart_comm (first second : Fin 6) :
    sixPointDuadHeart first second = sixPointDuadHeart second first := by
  funext index
  simp [sixPointDuadHeart, sixPointDuadVector, sixPointHeartCoordinates,
    add_comm]

/-- The heart vector of a pair of distinct labels is nonzero. -/
theorem sixPointDuadHeart_ne_zero {first second : Fin 6}
    (distinct : first ≠ second) : sixPointDuadHeart first second ≠ 0 := by
  revert distinct
  revert first second
  decide

/-- Every nonzero heart vector is the heart vector of a pair of distinct
labels. -/
theorem sixPointDuadHeart_exists {vector : Fin 4 → F2} (nonzero : vector ≠ 0) :
    ∃ first second : Fin 6,
      first ≠ second ∧ sixPointDuadHeart first second = vector := by
  revert nonzero
  revert vector
  decide

/-- Permuting the labels of a pair permutes its indicator vector. -/
theorem sixPointDuadVector_comp_symm (permutation : Equiv.Perm (Fin 6))
    (first second : Fin 6) :
    sixPointDuadVector first second ∘ permutation.symm =
      sixPointDuadVector (permutation first) (permutation second) := by
  funext label
  simp [sixPointDuadVector, Function.comp_apply, Equiv.symm_apply_eq]

/-- The heart matrix of a label permutation carries the heart vector of a pair
to the heart vector of the permuted pair. -/
theorem sixPointHeartPermutationMatrix_mulVec_duadHeart
    (permutation : Equiv.Perm (Fin 6)) (first second : Fin 6) :
    sixPointHeartPermutationMatrix permutation *ᵥ
        sixPointDuadHeart first second =
      sixPointDuadHeart (permutation first) (permutation second) := by
  rw [sixPointDuadHeart, sixPointDuadHeart,
    ← sixPointDuadVector_comp_symm permutation first second,
    sixPointHeartCoordinates_permutation permutation _
      (sixPointDuadVector_sum_zero first second)]

/-- The heart matrix of a label permutation acts injectively on heart
vectors. -/
theorem sixPointHeartPermutationMatrix_mulVec_injective
    (permutation : Equiv.Perm (Fin 6)) {left right : Fin 4 → F2}
    (equal : sixPointHeartPermutationMatrix permutation *ᵥ left =
      sixPointHeartPermutationMatrix permutation *ᵥ right) :
    left = right := by
  have applied := congrArg
    (fun vector ↦ sixPointHeartPermutationMatrix permutation⁻¹ *ᵥ vector) equal
  simpa [Matrix.mulVec_mulVec,
    (sixPointHeartPermutationMatrix_mul_inverse permutation).2] using applied

/-- Each matching of the displayed one-factorization moves every label. -/
theorem sixPointFactor_apply_ne (factor : Fin 5) (label : Fin 6) :
    sixPointFactor factor label ≠ label := by
  revert factor label
  decide

/-- The index of the matching of the displayed one-factorization that contains
a nonzero heart vector, read off as the first matching one of whose three pairs
has that heart vector.  The value at the zero vector carries no meaning. -/
def sixPointHeartFactor (vector : Fin 4 → F2) : Fin 5 :=
  if ∃ label : Fin 6,
      sixPointDuadHeart label (sixPointFactor 0 label) = vector then 0
  else if ∃ label : Fin 6,
      sixPointDuadHeart label (sixPointFactor 1 label) = vector then 1
  else if ∃ label : Fin 6,
      sixPointDuadHeart label (sixPointFactor 2 label) = vector then 2
  else if ∃ label : Fin 6,
      sixPointDuadHeart label (sixPointFactor 3 label) = vector then 3
  else 4

/-- The heart vector of a pair belonging to a matching has that matching's
index. -/
theorem sixPointHeartFactor_duadHeart_factor (factor : Fin 5) (label : Fin 6) :
    sixPointHeartFactor
        (sixPointDuadHeart label (sixPointFactor factor label)) = factor := by
  revert factor label
  decide

/-- The matching indexed by the heart vector of a pair of distinct labels pairs
those two labels with one another. -/
theorem sixPointFactor_heartFactor_duadHeart {first second : Fin 6}
    (distinct : first ≠ second) :
    sixPointFactor (sixPointHeartFactor (sixPointDuadHeart first second))
        first = second := by
  revert distinct
  revert first second
  decide

/-- Multiplication by the distinguished commutant element has no nonzero fixed
vector. -/
theorem sixPointHeartCommutantRoot_mulVec_ne_self {vector : Fin 4 → F2}
    (nonzero : vector ≠ 0) :
    sixPointHeartCommutantRoot *ᵥ vector ≠ vector := by
  revert nonzero
  revert vector
  decide

/-- Multiplication by the distinguished commutant element preserves
nonvanishing. -/
theorem sixPointHeartCommutantRoot_mulVec_ne_zero {vector : Fin 4 → F2}
    (nonzero : vector ≠ 0) : sixPointHeartCommutantRoot *ᵥ vector ≠ 0 := by
  revert nonzero
  revert vector
  decide

/-- Two nonzero heart vectors have the same matching index exactly when the
second is the first, or the first multiplied by the distinguished commutant
element, or the first multiplied by that element plus one.  So the matchings of
the displayed one-factorization are exactly the orbits of multiplication by
that element. -/
theorem sixPointHeartFactor_eq_iff {left right : Fin 4 → F2}
    (leftNonzero : left ≠ 0) (rightNonzero : right ≠ 0) :
    sixPointHeartFactor left = sixPointHeartFactor right ↔
      right = left ∨ right = sixPointHeartCommutantRoot *ᵥ left ∨
        right = (sixPointHeartCommutantRoot + 1) *ᵥ left := by
  revert leftNonzero rightNonzero
  revert left right
  decide

/-- Multiplication by the distinguished commutant element preserves the
matching index. -/
theorem sixPointHeartFactor_mulVec_root {vector : Fin 4 → F2}
    (nonzero : vector ≠ 0) :
    sixPointHeartFactor (sixPointHeartCommutantRoot *ᵥ vector) =
      sixPointHeartFactor vector :=
  ((sixPointHeartFactor_eq_iff nonzero
    (sixPointHeartCommutantRoot_mulVec_ne_zero nonzero)).2
      (Or.inr (Or.inl rfl))).symm

/-- The heart matrix of a label permutation intertwines multiplication by the
distinguished commutant element with multiplication by its conjugate. -/
theorem sixPointHeartPermutationMatrix_mul_commutantRoot
    (permutation : Equiv.Perm (Fin 6)) :
    sixPointHeartPermutationMatrix permutation * sixPointHeartCommutantRoot =
      sixPointHeartConjugate permutation sixPointHeartCommutantRoot *
        sixPointHeartPermutationMatrix permutation := by
  rw [sixPointHeartConjugate,
    mul_assoc (sixPointHeartPermutationMatrix permutation *
      sixPointHeartCommutantRoot),
    (sixPointHeartPermutationMatrix_mul_inverse permutation).2, mul_one]

/-- A permutation of the six labels preserves the displayed one-factorization
when it carries every matching to a matching. -/
def SixPointFactorizationPreserving (permutation : Equiv.Perm (Fin 6)) : Prop :=
  ∀ factor : Fin 5, ∃ image : Fin 5,
    permutation * sixPointFactor factor * permutation⁻¹ = sixPointFactor image

/-- If a label permutation carries one matching to another, then it carries the
heart vector of every pair of the first matching to a heart vector of the
second. -/
theorem sixPointHeartFactor_duadHeart_conjugate
    {permutation : Equiv.Perm (Fin 6)} {factor image : Fin 5}
    (carries : permutation * sixPointFactor factor * permutation⁻¹ =
      sixPointFactor image)
    {first second : Fin 6} (distinct : first ≠ second)
    (index : sixPointHeartFactor (sixPointDuadHeart first second) = factor) :
    sixPointHeartFactor
        (sixPointDuadHeart (permutation first) (permutation second)) =
      image := by
  have paired : sixPointFactor factor first = second := by
    rw [← index]
    exact sixPointFactor_heartFactor_duadHeart distinct
  have transported :
      permutation second = sixPointFactor image (permutation first) := by
    have evaluated := congrArg
      (fun element : Equiv.Perm (Fin 6) ↦ element (permutation first)) carries
    simpa [Equiv.Perm.mul_apply, paired] using evaluated
  rw [transported]
  exact sixPointHeartFactor_duadHeart_factor image (permutation first)

/-- A label permutation whose heart matrix conjugates the distinguished
commutant element into the pair consisting of that element and that element
plus one carries pairs with a common matching to pairs with a common
matching. -/
theorem sixPointHeartFactor_duadHeart_map
    {permutation : Equiv.Perm (Fin 6)}
    (member : permutation ∈ sixPointLabelPacketGroup)
    {first second third fourth : Fin 6}
    (firstDistinct : first ≠ second) (secondDistinct : third ≠ fourth)
    (same : sixPointHeartFactor (sixPointDuadHeart first second) =
      sixPointHeartFactor (sixPointDuadHeart third fourth)) :
    sixPointHeartFactor
        (sixPointDuadHeart (permutation first) (permutation second)) =
      sixPointHeartFactor
        (sixPointDuadHeart (permutation third) (permutation fourth)) := by
  have imageNonzero :
      sixPointDuadHeart (permutation first) (permutation second) ≠ 0 :=
    sixPointDuadHeart_ne_zero fun equality ↦
      firstDistinct (permutation.injective equality)
  have secondImageNonzero :
      sixPointDuadHeart (permutation third) (permutation fourth) ≠ 0 :=
    sixPointDuadHeart_ne_zero fun equality ↦
      secondDistinct (permutation.injective equality)
  have intertwine : ∀ vector : Fin 4 → F2,
      sixPointHeartPermutationMatrix permutation *ᵥ
          (sixPointHeartCommutantRoot *ᵥ vector) =
        sixPointHeartConjugate permutation sixPointHeartCommutantRoot *ᵥ
          (sixPointHeartPermutationMatrix permutation *ᵥ vector) := by
    intro vector
    rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec,
      sixPointHeartPermutationMatrix_mul_commutantRoot]
  have shifted : ∀ vector : Fin 4 → F2,
      sixPointHeartPermutationMatrix permutation *ᵥ
          ((sixPointHeartCommutantRoot + 1) *ᵥ vector) =
        (sixPointHeartConjugate permutation sixPointHeartCommutantRoot + 1) *ᵥ
          (sixPointHeartPermutationMatrix permutation *ᵥ vector) := by
    intro vector
    rw [Matrix.add_mulVec, Matrix.add_mulVec, Matrix.one_mulVec,
      Matrix.one_mulVec, Matrix.mulVec_add, intertwine]
  have firstImage :
      sixPointHeartPermutationMatrix permutation *ᵥ
          sixPointDuadHeart first second =
        sixPointDuadHeart (permutation first) (permutation second) :=
    sixPointHeartPermutationMatrix_mulVec_duadHeart permutation first second
  have secondImage :
      sixPointHeartPermutationMatrix permutation *ᵥ
          sixPointDuadHeart third fourth =
        sixPointDuadHeart (permutation third) (permutation fourth) :=
    sixPointHeartPermutationMatrix_mulVec_duadHeart permutation third fourth
  have expanded :=
    (sixPointHeartFactor_eq_iff (sixPointDuadHeart_ne_zero firstDistinct)
      (sixPointDuadHeart_ne_zero secondDistinct)).1 same
  refine (sixPointHeartFactor_eq_iff imageNonzero secondImageNonzero).2 ?_
  rcases member with fixed | moved
  · rcases expanded with equal | root | conjugate
    · exact Or.inl (by rw [← firstImage, ← secondImage, equal])
    · exact Or.inr (Or.inl (by
        rw [← firstImage, ← secondImage, root, intertwine, fixed]))
    · exact Or.inr (Or.inr (by
        rw [← firstImage, ← secondImage, conjugate, shifted, fixed]))
  · rcases expanded with equal | root | conjugate
    · exact Or.inl (by rw [← firstImage, ← secondImage, equal])
    · exact Or.inr (Or.inr (by
        rw [← firstImage, ← secondImage, root, intertwine, moved]))
    · exact Or.inr (Or.inl (by
        rw [← firstImage, ← secondImage, conjugate, shifted, moved,
          sixPointHeartMatrix_add_one_add_one]))

/-- A label permutation whose heart matrix conjugates the distinguished
commutant element into the pair consisting of that element and that element
plus one preserves the displayed one-factorization. -/
theorem sixPointFactorizationPreserving_of_mem_packetGroup
    {permutation : Equiv.Perm (Fin 6)}
    (member : permutation ∈ sixPointLabelPacketGroup) :
    SixPointFactorizationPreserving permutation := by
  intro factor
  refine ⟨sixPointHeartFactor (sixPointDuadHeart (permutation 0)
    (permutation (sixPointFactor factor 0))), ?_⟩
  refine Equiv.ext fun label ↦ ?_
  simp only [Equiv.Perm.mul_apply]
  set source := permutation⁻¹ label with sourceDefinition
  have restore : permutation source = label := by
    rw [sourceDefinition]
    simp
  have distinct : source ≠ sixPointFactor factor source := fun equality ↦
    sixPointFactor_apply_ne factor source equality.symm
  have baseDistinct : (0 : Fin 6) ≠ sixPointFactor factor 0 := fun equality ↦
    sixPointFactor_apply_ne factor 0 equality.symm
  have sameFactor :
      sixPointHeartFactor
          (sixPointDuadHeart source (sixPointFactor factor source)) =
        sixPointHeartFactor
          (sixPointDuadHeart 0 (sixPointFactor factor 0)) := by
    rw [sixPointHeartFactor_duadHeart_factor,
      sixPointHeartFactor_duadHeart_factor]
  have transported :=
    sixPointHeartFactor_duadHeart_map member distinct baseDistinct sameFactor
  have imageDistinct :
      permutation source ≠ permutation (sixPointFactor factor source) :=
    fun equality ↦ distinct (permutation.injective equality)
  have paired := sixPointFactor_heartFactor_duadHeart imageDistinct
  rw [transported] at paired
  rw [← restore]
  exact paired.symm

/-- A characteristic-two matrix that annihilates or fixes each heart vector
individually annihilates every heart vector or fixes every heart vector. -/
theorem sixPointHeartMatrix_eq_zero_or_one_of_pointwise
    {matrix : Matrix (Fin 4) (Fin 4) F2}
    (pointwise : ∀ vector : Fin 4 → F2,
      matrix *ᵥ vector = 0 ∨ matrix *ᵥ vector = vector) :
    matrix = 0 ∨ matrix = 1 := by
  by_cases uniform : ∀ vector : Fin 4 → F2, matrix *ᵥ vector = 0
  · refine Or.inl (sixPointHeartMatrix_ext fun vector ↦ ?_)
    rw [uniform vector, Matrix.zero_mulVec]
  · obtain ⟨witness, witnessMoved⟩ := not_forall.1 uniform
    have witnessFixed : matrix *ᵥ witness = witness :=
      (pointwise witness).resolve_left witnessMoved
    have witnessNonzero : witness ≠ 0 := by
      intro zero
      exact witnessMoved (by rw [zero, Matrix.mulVec_zero])
    refine Or.inr (sixPointHeartMatrix_ext fun vector ↦ ?_)
    rw [Matrix.one_mulVec]
    rcases pointwise vector with annihilated | fixed
    · have sumValue : matrix *ᵥ (vector + witness) = witness := by
        rw [Matrix.mulVec_add, annihilated, witnessFixed, zero_add]
      rcases pointwise (vector + witness) with sumZero | sumFixed
      · exact absurd (sumValue.symm.trans sumZero) witnessNonzero
      · have collapsed : vector + witness = 0 + witness := by
          rw [zero_add]
          exact (sumValue.symm.trans sumFixed).symm
        have zeroVector : vector = 0 := add_right_cancel collapsed
        rw [zeroVector, Matrix.mulVec_zero]
    · exact fixed

/-- A heart matrix agreeing at every nonzero vector with multiplication by the
distinguished commutant element or with multiplication by that element plus one
makes the same choice at every vector. -/
theorem sixPointHeartMatrix_eq_commutantRoot_or_conjugate
    {matrix : Matrix (Fin 4) (Fin 4) F2}
    (pointwise : ∀ vector : Fin 4 → F2, vector ≠ 0 →
      matrix *ᵥ vector = sixPointHeartCommutantRoot *ᵥ vector ∨
        matrix *ᵥ vector = (sixPointHeartCommutantRoot + 1) *ᵥ vector) :
    matrix = sixPointHeartCommutantRoot ∨
      matrix = sixPointHeartCommutantRoot + 1 := by
  have difference : ∀ vector : Fin 4 → F2,
      (matrix - sixPointHeartCommutantRoot) *ᵥ vector = 0 ∨
        (matrix - sixPointHeartCommutantRoot) *ᵥ vector = vector := by
    intro vector
    by_cases zero : vector = 0
    · exact Or.inl (by rw [zero, Matrix.mulVec_zero])
    rcases pointwise vector zero with root | conjugate
    · exact Or.inl (by rw [Matrix.sub_mulVec, root, sub_self])
    · refine Or.inr ?_
      rw [Matrix.sub_mulVec, conjugate, Matrix.add_mulVec, Matrix.one_mulVec,
        add_sub_cancel_left]
  rcases sixPointHeartMatrix_eq_zero_or_one_of_pointwise difference with
    zero | one
  · exact Or.inl (sub_eq_zero.1 zero)
  · refine Or.inr ?_
    rw [sub_eq_iff_eq_add] at one
    rw [one, add_comm]

/-- A label permutation preserving the displayed one-factorization has a heart
matrix whose conjugate of the distinguished commutant element is that element
or that element plus one. -/
theorem mem_sixPointLabelPacketGroup_of_factorizationPreserving
    {permutation : Equiv.Perm (Fin 6)}
    (preserving : SixPointFactorizationPreserving permutation) :
    permutation ∈ sixPointLabelPacketGroup := by
  rw [mem_sixPointLabelPacketGroup_iff]
  refine sixPointHeartMatrix_eq_commutantRoot_or_conjugate ?_
  intro vector nonzero
  obtain ⟨first, second, distinct, represented⟩ :=
    sixPointDuadHeart_exists nonzero
  subst represented
  set source := permutation⁻¹ first with sourceDefinition
  set target := permutation⁻¹ second with targetDefinition
  have sourceDistinct : source ≠ target := fun equality ↦
    distinct (by
      have := congrArg (fun label ↦ permutation label) equality
      simpa [sourceDefinition, targetDefinition] using this)
  have preimage :
      sixPointHeartPermutationMatrix permutation⁻¹ *ᵥ
          sixPointDuadHeart first second =
        sixPointDuadHeart source target :=
    sixPointHeartPermutationMatrix_mulVec_duadHeart permutation⁻¹ first second
  have preimageNonzero : sixPointDuadHeart source target ≠ 0 :=
    sixPointDuadHeart_ne_zero sourceDistinct
  obtain ⟨third, fourth, imageDistinct, rotated⟩ :=
    sixPointDuadHeart_exists
      (sixPointHeartCommutantRoot_mulVec_ne_zero preimageNonzero)
  have rotatedFactor :
      sixPointHeartFactor (sixPointDuadHeart third fourth) =
        sixPointHeartFactor (sixPointDuadHeart source target) := by
    rw [rotated]
    exact sixPointHeartFactor_mulVec_root preimageNonzero
  obtain ⟨image, carries⟩ :=
    preserving (sixPointHeartFactor (sixPointDuadHeart source target))
  have rotatedImage :
      sixPointHeartFactor
          (sixPointDuadHeart (permutation third) (permutation fourth)) =
        image :=
    sixPointHeartFactor_duadHeart_conjugate carries imageDistinct rotatedFactor
  have sourceImage :
      sixPointHeartFactor
          (sixPointDuadHeart (permutation source) (permutation target)) =
        image :=
    sixPointHeartFactor_duadHeart_conjugate carries sourceDistinct rfl
  have restoreFirst : permutation source = first := by
    rw [sourceDefinition]
    simp
  have restoreSecond : permutation target = second := by
    rw [targetDefinition]
    simp
  have conjugateValue :
      sixPointHeartConjugate permutation sixPointHeartCommutantRoot *ᵥ
          sixPointDuadHeart first second =
        sixPointDuadHeart (permutation third) (permutation fourth) := by
    have expanded :
        sixPointHeartConjugate permutation sixPointHeartCommutantRoot *ᵥ
            sixPointDuadHeart first second =
          sixPointHeartPermutationMatrix permutation *ᵥ
            (sixPointHeartCommutantRoot *ᵥ
              (sixPointHeartPermutationMatrix permutation⁻¹ *ᵥ
                sixPointDuadHeart first second)) := by
      rw [Matrix.mulVec_mulVec, Matrix.mulVec_mulVec, sixPointHeartConjugate,
        mul_assoc]
    rw [expanded, preimage, ← rotated,
      sixPointHeartPermutationMatrix_mulVec_duadHeart]
  have sameFactor :
      sixPointHeartFactor (sixPointDuadHeart first second) =
        sixPointHeartFactor
          (sixPointHeartConjugate permutation sixPointHeartCommutantRoot *ᵥ
            sixPointDuadHeart first second) := by
    rw [conjugateValue, rotatedImage, ← restoreFirst, ← restoreSecond,
      sourceImage]
  have conjugateNonzero :
      sixPointHeartConjugate permutation sixPointHeartCommutantRoot *ᵥ
          sixPointDuadHeart first second ≠ 0 := by
    rw [conjugateValue]
    exact sixPointDuadHeart_ne_zero fun equality ↦
      imageDistinct (permutation.injective equality)
  have alternatives :=
    (sixPointHeartFactor_eq_iff (sixPointDuadHeart_ne_zero distinct)
      conjugateNonzero).1 sameFactor
  rcases alternatives with equal | root | conjugate
  · exfalso
    have imageEqual :
        sixPointHeartPermutationMatrix permutation *ᵥ
            sixPointDuadHeart third fourth =
          sixPointHeartPermutationMatrix permutation *ᵥ
            sixPointDuadHeart source target := by
      rw [sixPointHeartPermutationMatrix_mulVec_duadHeart,
        sixPointHeartPermutationMatrix_mulVec_duadHeart, restoreFirst,
        restoreSecond, ← conjugateValue, equal]
    have collapsed :=
      sixPointHeartPermutationMatrix_mulVec_injective permutation imageEqual
    rw [rotated] at collapsed
    exact sixPointHeartCommutantRoot_mulVec_ne_self preimageNonzero collapsed
  · exact Or.inl root
  · exact Or.inr conjugate

/-- Preserving the displayed one-factorization of the fifteen pairs of labels
and preserving the pair consisting of the distinguished commutant element and
that element plus one are the same condition on a label permutation. -/
theorem sixPointFactorizationPreserving_iff_mem_packetGroup
    (permutation : Equiv.Perm (Fin 6)) :
    SixPointFactorizationPreserving permutation ↔
      permutation ∈ sixPointLabelPacketGroup :=
  ⟨mem_sixPointLabelPacketGroup_of_factorizationPreserving,
    sixPointFactorizationPreserving_of_mem_packetGroup⟩

/-- Every word in the displayed translation and involution is an even
permutation of the six labels. -/
theorem sixPointPermutationWord_sign (word : List Bool) :
    Equiv.Perm.sign (sixPointPermutationWord word) = 1 := by
  induction word with
  | nil => simp [sixPointPermutationWord]
  | cons generator word induction =>
      rw [sixPointPermutationWord, map_mul, induction]
      by_cases inversion : generator
      · rw [if_pos inversion, sixPointInversionPermutation_sign, one_mul]
      · rw [if_neg inversion, sixPointTranslationPermutation_sign, one_mul]

/-- A label permutation whose heart matrix centralizes the distinguished
commutant element is an even permutation of the six labels. -/
theorem sixPointLabelCommutantGroup_sign {permutation : Equiv.Perm (Fin 6)}
    (member : permutation ∈ sixPointLabelCommutantGroup) :
    Equiv.Perm.sign permutation = 1 := by
  rw [sixPointLabelCommutantGroup_eq_alternatingRange] at member
  obtain ⟨element, represented⟩ := member
  obtain ⟨word, wordEquality⟩ :=
    sixPointGeneratedAction_realizes_alternatingGroup.2.1 element.1 element.2
  have elementEquality : sixPointFactorWordA5 word = element :=
    Subtype.ext wordEquality
  rw [← represented, ← elementEquality, alternatingFiveSixPointAction_word]
  exact sixPointPermutationWord_sign word

/-- A label permutation centralizes the distinguished commutant element exactly
when it preserves the displayed one-factorization and is an even permutation of
the six labels.  Preservation of the one-factorization alone is the weaker
condition of preserving the pair consisting of that element and that element
plus one. -/
theorem mem_sixPointLabelCommutantGroup_iff_even_factorizationPreserving
    (permutation : Equiv.Perm (Fin 6)) :
    permutation ∈ sixPointLabelCommutantGroup ↔
      SixPointFactorizationPreserving permutation ∧
        Equiv.Perm.sign permutation = 1 := by
  constructor
  · intro member
    exact ⟨sixPointFactorizationPreserving_of_mem_packetGroup
      (sixPointLabelCommutantGroup_le_packetGroup member),
      sixPointLabelCommutantGroup_sign member⟩
  · rintro ⟨preserving, even⟩
    rcases mem_sixPointLabelPacketGroup_of_factorizationPreserving preserving
      with fixed | moved
    · exact fixed
    · exfalso
      have centralizes :
          sixPointScalingPermutation * permutation ∈
            sixPointLabelCommutantGroup := by
        rw [mem_sixPointLabelCommutantGroup_iff, sixPointHeartConjugate_mul,
          moved, sixPointHeartConjugate_add, sixPointHeartConjugate_identity,
          sixPointHeartConjugate_scaling, sixPointHeartMatrix_add_one_add_one]
      have signEquality := sixPointLabelCommutantGroup_sign centralizes
      rw [map_mul, sixPointScalingPermutation_sign, even, mul_one]
        at signEquality
      exact absurd signEquality (by decide)

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
