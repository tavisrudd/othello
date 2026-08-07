import RelativeConicArcs.KneserPairEigenspace

/-!
# The labelled icosahedral face axes

The ten axes through opposite faces of a regular icosahedron are labelled here by
the two-element subsets of `Fin 5`, that is, by the vertices of the Kneser graph
`K(5,2)`.  The labelling is the explicit finite datum

```
{0,1} ↦ (-1,-1,-1)   {0,2} ↦ (-1,-1, 1)   {0,3} ↦ (-1, 1,-1)   {0,4} ↦ (-1, 1, 1)
{2,3} ↦ (0,-φ⁻¹,-φ)  {1,4} ↦ (0,-φ⁻¹, φ)  {3,4} ↦ (-φ⁻¹,-φ,0)  {1,2} ↦ (-φ⁻¹, φ,0)
{2,4} ↦ (-φ,0,-φ⁻¹)  {1,3} ↦ ( φ,0,-φ⁻¹)
```

where `φ` is a root of `φ² = φ + 1`.  Since `φ` and `φ⁻¹ = φ - 1` are not
integral, the coordinates stored below are twice the displayed ones, which places
them in `ℤ√5`: doubling sends `φ` to `1 + √5` and `φ⁻¹` to `√5 - 1`.  All finite
statements are proved by kernel decision in `ℤ√5` and then transported along the
unique ring homomorphism sending `√5` to a chosen square root of five in an
arbitrary commutative ring.

The content of the module is that this labelling is geometric: every axis has the
same length, and the square of the inner product of two distinct axes takes one
value when the label pairs are disjoint and another when they meet.  In the
doubled coordinates the squared length is `12`, and the two squared inner products
are `80` and `16`; in the displayed coordinates they are `3`, `5` and `1`, so the
unit representatives have squared angles `5/9` and `1/9`.  Hence the incidence
relation "the squared angle is the smaller one" recovers exactly the Kneser
adjacency of `K(5,2)`, which is the Petersen graph.

Nothing here refers to spherical harmonics; the module supplies the geometric
input that fixes the two orbit values of a zonal kernel on these axes.
-/

namespace RelativeConicArcs.IcosahedralFaceAxes

open RelativeConicArcs.KneserPairEigenspace

/-- Twice the displayed coordinates of the face axis labelled by a two-element
subset of `Fin 5`.  Doubling clears the denominators of `φ = (1 + √5)/2` and
`φ⁻¹ = (√5 - 1)/2`, so the coordinates lie in `ℤ√5`.  The value on a subset that
is not one of the ten labels is irrelevant and is set to zero. -/
def doubledAxisCoordinates (s : Finset (Fin 5)) : Fin 3 → ℤ√5 :=
  if s = {0, 1} then ![-2, -2, -2]
  else if s = {0, 2} then ![-2, -2, 2]
  else if s = {0, 3} then ![-2, 2, -2]
  else if s = {0, 4} then ![-2, 2, 2]
  else if s = {2, 3} then ![0, ⟨1, -1⟩, ⟨-1, -1⟩]
  else if s = {1, 4} then ![0, ⟨1, -1⟩, ⟨1, 1⟩]
  else if s = {3, 4} then ![⟨1, -1⟩, ⟨-1, -1⟩, 0]
  else if s = {1, 2} then ![⟨1, -1⟩, ⟨1, 1⟩, 0]
  else if s = {2, 4} then ![⟨-1, -1⟩, 0, ⟨1, -1⟩]
  else if s = {1, 3} then ![⟨1, 1⟩, 0, ⟨1, -1⟩]
  else 0

/-- The face axis of a Kneser vertex, in coordinates twice the displayed ones. -/
def doubledFaceAxis (p : Pair 5) : Fin 3 → ℤ√5 :=
  doubledAxisCoordinates p.vertices

/-- The standard bilinear form on three coordinates over a commutative ring. -/
def coordinateForm {R : Type*} [CommRing R] (u v : Fin 3 → R) : R :=
  ∑ i, u i * v i

/-- Every face axis has the same length: in doubled coordinates its squared
length is `12`, so the displayed coordinates have squared length `3`. -/
theorem coordinateForm_doubledFaceAxis_self (p : Pair 5) :
    coordinateForm (doubledFaceAxis p) (doubledFaceAxis p) = 12 := by
  revert p
  decide

/-- The labelling is geometric.  For two distinct labels the squared inner
product of the doubled axes is `80` when the label pairs are disjoint and `16`
when they meet; in displayed coordinates these are `5` and `1`.  So the wider of
the two angles between distinct axes occurs exactly on the edges of the Kneser
graph `K(5,2)`. -/
theorem coordinateForm_doubledFaceAxis_sq (p q : Pair 5) (hpq : p ≠ q) :
    coordinateForm (doubledFaceAxis p) (doubledFaceAxis q) ^ 2 =
      if Disjoint p.vertices q.vertices then 80 else 16 := by
  revert p q
  decide

section Rotations

/-- Four times each of three rotations of three-space that preserve the set of
face axes.  The scaling by four clears the denominators of the third matrix,
whose displayed entries are `-φ/2`, `(φ - 1)/2` and `-1/2`, so all entries lie in
`ℤ√5`.  The first is the half-turn about the first coordinate axis, the second is
the cyclic permutation of coordinates, and the third is the circulant matrix
built from those three golden entries. -/
def scaledRotation : Fin 3 → Fin 3 → Fin 3 → ℤ√5
  | 0 => ![![4, 0, 0], ![0, -4, 0], ![0, 0, -4]]
  | 1 => ![![0, 0, 4], ![4, 0, 0], ![0, 4, 0]]
  | 2 => ![![⟨-1, -1⟩, ⟨-1, 1⟩, -2], ![⟨-1, 1⟩, -2, ⟨-1, -1⟩], ![-2, ⟨-1, -1⟩, ⟨-1, 1⟩]]

/-- The action of a scaled rotation on a coordinate vector. -/
def scaledRotationApply (r : Fin 3) (v : Fin 3 → ℤ√5) : Fin 3 → ℤ√5 :=
  fun i => ∑ j, scaledRotation r i j * v j

/-- The permutation of the five labels induced by each of the three rotations:
the transpositions-in-pairs `(1 4)(2 3)`, the three-cycle `(2 4 3)` and
`(0 1)(2 4)` in the labelling `Fin 5`. -/
def labelPermutation : Fin 3 → Fin 5 → Fin 5
  | 0 => ![0, 4, 3, 2, 1]
  | 1 => ![0, 1, 4, 2, 3]
  | 2 => ![1, 0, 4, 3, 2]

/-- Each scaled rotation is four times an orthogonal matrix: its rows are
pairwise orthogonal of squared length sixteen. -/
theorem scaledRotation_rows_orthogonal (r i j : Fin 3) :
    ∑ k, scaledRotation r i k * scaledRotation r j k = if i = j then 16 else 0 := by
  revert r i j
  decide

/-- Each of the three matrices is a rotation rather than a reflection: scaled by
four in three coordinates, its determinant is `4³ = 64`. -/
theorem scaledRotation_det (r : Fin 3) :
    Matrix.det (Matrix.of (scaledRotation r)) = 64 := by
  revert r
  decide

/-- Each label permutation is injective, hence a permutation of the five
labels. -/
theorem labelPermutation_injective (r : Fin 3) :
    Function.Injective (labelPermutation r) := by
  revert r
  decide

/-- The three rotations permute the ten face axes, up to sign, and the induced
permutation of the labels is the displayed one.  The sign is unavoidable: a
rotation fixes each axis as a line, not each chosen representative vector. -/
theorem scaledRotationApply_doubledFaceAxis (r : Fin 3) (p : Pair 5) :
    ∃ q : Pair 5, q.vertices = p.vertices.image (labelPermutation r) ∧
      (scaledRotationApply r (doubledFaceAxis p) =
          (fun i => 4 * doubledFaceAxis q i) ∨
        scaledRotationApply r (doubledFaceAxis p) =
          (fun i => -(4 * doubledFaceAxis q i))) := by
  revert r p
  decide

end Rotations

section Transport

variable {R : Type*} [CommRing R] (s : R)

/-- The ring homomorphism from `ℤ√5` determined by a chosen square root of five. -/
noncomputable def goldenCast (hs : s * s = 5) : ℤ√5 →+* R :=
  Zsqrtd.lift ⟨s, by rw [hs]; norm_num⟩

/-- The face axes over an arbitrary commutative ring carrying a square root `s` of
five, in coordinates twice the displayed ones.  Taking `s` to the other square
root replaces the configuration by its conjugate, which is the same statement as
the manuscript's remark that conjugating `φ` gives the conjugate embedded
configuration. -/
noncomputable def doubledFaceAxisOver (hs : s * s = 5) (p : Pair 5) (i : Fin 3) : R :=
  goldenCast s hs (doubledFaceAxis p i)

/-- The squared length of a face axis over any commutative ring with a square root
of five. -/
theorem coordinateForm_doubledFaceAxisOver_self (hs : s * s = 5) (p : Pair 5) :
    coordinateForm (doubledFaceAxisOver s hs p) (doubledFaceAxisOver s hs p) = 12 := by
  have h := congrArg (goldenCast s hs) (coordinateForm_doubledFaceAxis_self p)
  simpa [coordinateForm, doubledFaceAxisOver, map_sum, map_mul, map_ofNat] using h

/-- The two-orbit inner-product law over any commutative ring with a square root
of five. -/
theorem coordinateForm_doubledFaceAxisOver_sq (hs : s * s = 5) (p q : Pair 5)
    (hpq : p ≠ q) :
    coordinateForm (doubledFaceAxisOver s hs p) (doubledFaceAxisOver s hs q) ^ 2 =
      if Disjoint p.vertices q.vertices then 80 else 16 := by
  have h := congrArg (goldenCast s hs) (coordinateForm_doubledFaceAxis_sq p q hpq)
  by_cases hd : Disjoint p.vertices q.vertices <;>
    simpa [coordinateForm, doubledFaceAxisOver, map_sum, map_mul, map_pow, map_ofNat, hd] using h

end Transport

end RelativeConicArcs.IcosahedralFaceAxes
