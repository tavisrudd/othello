import Mathlib.Analysis.Real.Sqrt
import RelativeConicArcs.IcosahedralFaceAxes
import RelativeConicArcs.ZonalHarmonicDegreeSix

/-!
# The Gram matrix of the ten face-axis zonal forms

The ten axes through opposite faces of a regular icosahedron are labelled by the
two-element subsets of `Fin 5`, that is, by the vertices of the Kneser graph
`K(5,2)`, which is the Petersen graph.  `RelativeConicArcs.IcosahedralFaceAxes`
supplies the labelled axes in coordinates twice the displayed ones over any
commutative ring carrying a square root of five; here that ring is `ℝ` and the
square root is the nonnegative one.  Dividing by `2 * Real.sqrt 3` produces the
unit representative `unitFaceAxis p`, and `faceAxisZonalForm p` is the degree-six
zonal form of `RelativeConicArcs.ZonalHarmonicDegreeSix` with that unit axis.

The module computes the Gram matrix of the ten zonal forms for the normalized
mean of degree twelve, and reads off the action of that Gram form on the three
Petersen eigenspaces.  Write `I` for the identity matrix, `J` for the all-ones
matrix and `A` for the disjointness adjacency matrix of the Petersen graph on the
labels.  The Gram matrix is

```
G = (196 * I + 47 * J - 112 * A) / 3159,        3159 = 243 * 13,
```

which is `zonalGramEntry` below.  Its three entries are `1/13` on the diagonal,
`-65/3159` on a pair of disjoint labels and `47/3159` on a pair of labels meeting
in one element; they come from the degree-six Legendre polynomial at the three
squared axis inner products `1`, `5/9` and `1/9`.  Only the squares of the inner
products enter, so the sign of the chosen axis representative is irrelevant.

Because the Petersen adjacency operator has the eigenvalues `3`, `-2` and `1`,
the Gram form acts on the three corresponding eigenspaces by the scalars
`110/1053`, `140/1053` and `28/1053`.  Each of the three is stated as an
eigenvector equation, from the hypotheses on the coefficient vector alone; no
eigenspace is constructed here.

## Scope and trust boundary

`normalizedMean` is the explicitly defined functional of
`RelativeConicArcs.SphericalMomentFunctional`, given by a formula on monomials
and by nothing else.  Its classical identification with the normalized surface
integral over the unit two-sphere is not formalized in that module, in
`RelativeConicArcs.ZonalHarmonicDegreeSix`, or here, and it is not used.  No
theorem below is a statement about an integral: each is an identity between real
numbers obtained from explicitly defined polynomial data.  No measure, no
integral and no limit occurs in any statement or proof.  The only ingredient
here that is not algebraic is the existence of the nonnegative square roots of
five and of three: the first realizes the face-axis configuration over the reals
and the second rescales an axis to unit length.

The finite geometric input — the squared length of a face axis and the two
squared inner products of distinct axes — is checked by kernel reduction in
`ℤ√5` inside `RelativeConicArcs.IcosahedralFaceAxes` and transported to `ℝ`
there; no further finite computation is performed here beyond the cardinality
`Fintype.card (Pair 5) = 10`, also checked by kernel reduction.

## Main results

* `normalizedMean_faceAxisZonalForm_mul`: the Gram identity `G` displayed above,
  for every ordered pair of labels.
* `normalizedMean_faceAxisZonalForm_mul_zonalCombination`: the Gram form applied
  to a real combination of the ten zonal forms, expressed through the total pair
  weight and the Petersen adjacency operator.
* `normalizedMean_faceAxisZonalForm_mul_zonalCombination_const`,
  `normalizedMean_faceAxisZonalForm_mul_zonalCombination_of_petersenEigen` and
  `normalizedMean_faceAxisZonalForm_mul_zonalCombination_of_adjacency_eq_self`:
  the three eigenvalues `110/1053`, `140/1053` and `28/1053`.
* `normalizedMean_zonalCombination_mul_self_of_petersenEigen` and
  `zonalCombination_injective_of_petersenEigen`: on the Petersen
  `(-2)`-eigenspace the Gram form is the positive scalar `140/1053` times the
  squared Euclidean norm of the coefficient vector, so the passage from
  coefficient vectors to zonal forms is injective there.
* `sum_pairSum_sq`: pair-sum tightness, `∑ p, pairSum y p ^ 2 = 3 * ∑ i, y i ^ 2`
  for sum-zero vertex weights `y : Fin 5 → ℝ`.
* `normalizedMean_zonalCombination_pairSum_mul_self` and
  `normalizedMean_zonalCombination_stabilizerFixedVertexWeight`: the resulting
  quadratic identity `(140/351) * ∑ i, y i ^ 2`, and its value `2800/351` at the
  vertex weight `(4, -1, -1, -1, -1)`.
-/

namespace RelativeConicArcs.FaceAxisHarmonicGram

open Finset MvPolynomial
open RelativeConicArcs.KneserPairEigenspace RelativeConicArcs.IcosahedralFaceAxes
open RelativeConicArcs.SphericalMomentFunctional RelativeConicArcs.ZonalHarmonicDegreeSix

section UnitAxes

/-- The nonnegative square root of five, squared. -/
lemma sqrt_five_mul_self : Real.sqrt 5 * Real.sqrt 5 = 5 :=
  Real.mul_self_sqrt (by norm_num)

/-- The labelled face axes over the reals, in coordinates twice the displayed
ones, with the nonnegative square root of five chosen in
`RelativeConicArcs.IcosahedralFaceAxes.doubledFaceAxisOver`.  The other choice of
square root produces the conjugate embedded configuration and the same Gram
matrix, since only squared inner products enter below. -/
noncomputable def doubledFaceAxisReal (p : Pair 5) (i : Fin 3) : ℝ :=
  doubledFaceAxisOver (Real.sqrt 5) sqrt_five_mul_self p i

/-- The face axis of a Kneser vertex, rescaled to unit Euclidean length.  The
doubled coordinates have squared length `12`, and `(2 * Real.sqrt 3) ^ 2 = 12`,
so the rescaled vector has squared length one; this is `sum_unitFaceAxis_sq`. -/
noncomputable def unitFaceAxis (p : Pair 5) (i : Fin 3) : ℝ :=
  doubledFaceAxisReal p i / (2 * Real.sqrt 3)

private lemma sq_two_mul_sqrt_three : (2 * Real.sqrt 3) ^ 2 = 12 := by
  rw [mul_pow, Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]
  norm_num

private lemma sum_doubledFaceAxisReal_self (p : Pair 5) :
    ∑ i, doubledFaceAxisReal p i * doubledFaceAxisReal p i = 12 := by
  have h := coordinateForm_doubledFaceAxisOver_self (Real.sqrt 5) sqrt_five_mul_self p
  simp only [coordinateForm] at h
  exact h

private lemma sum_doubledFaceAxisReal_mul_sq (p q : Pair 5) (hpq : p ≠ q) :
    (∑ i, doubledFaceAxisReal p i * doubledFaceAxisReal q i) ^ 2 =
      if Disjoint p.vertices q.vertices then 80 else 16 := by
  have h := coordinateForm_doubledFaceAxisOver_sq (Real.sqrt 5) sqrt_five_mul_self p q hpq
  simp only [coordinateForm] at h
  exact h

private lemma sum_unitFaceAxis_mul (p q : Pair 5) :
    ∑ i, unitFaceAxis p i * unitFaceAxis q i
      = (∑ i, doubledFaceAxisReal p i * doubledFaceAxisReal q i) / 12 := by
  rw [Finset.sum_div]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [unitFaceAxis, unitFaceAxis, div_mul_div_comm, ← pow_two, sq_two_mul_sqrt_three]

private lemma sum_unitFaceAxis_mul_self (p : Pair 5) :
    ∑ i, unitFaceAxis p i * unitFaceAxis p i = 1 := by
  rw [sum_unitFaceAxis_mul, sum_doubledFaceAxisReal_self]
  norm_num

/-- Each rescaled face axis has squared Euclidean length one. -/
theorem sum_unitFaceAxis_sq (p : Pair 5) : ∑ i, unitFaceAxis p i ^ 2 = 1 := by
  rw [← sum_unitFaceAxis_mul_self p]
  exact Finset.sum_congr rfl fun i _ => pow_two (unitFaceAxis p i)

/-- The two-orbit law for the unit face axes: the squared inner product of two
distinct unit axes is `5/9` when the label pairs are disjoint and `1/9` when they
meet.  The larger value, that is the narrower angle between the two lines, occurs
exactly on the edges of the Kneser graph `K(5,2)`. -/
theorem sum_unitFaceAxis_mul_sq (p q : Pair 5) (hpq : p ≠ q) :
    (∑ i, unitFaceAxis p i * unitFaceAxis q i) ^ 2 =
      if Disjoint p.vertices q.vertices then 5 / 9 else 1 / 9 := by
  rw [sum_unitFaceAxis_mul, div_pow, sum_doubledFaceAxisReal_mul_sq p q hpq]
  by_cases hd : Disjoint p.vertices q.vertices
  · rw [if_pos hd, if_pos hd]; norm_num
  · rw [if_neg hd, if_neg hd]; norm_num

end UnitAxes

section GramMatrix

/-- The degree-six zonal form of the face axis labelled by a Kneser vertex: the
zonal form of `RelativeConicArcs.ZonalHarmonicDegreeSix` with the unit axis
`unitFaceAxis p` as its axis. -/
noncomputable def faceAxisZonalForm (p : Pair 5) : MvPolynomial (Fin 3) ℝ :=
  zonalHarmonic (unitFaceAxis p)

/-- The entry of the Gram matrix of the ten face-axis zonal forms at the ordered
pair of labels `(p, q)`, in the form `(196 * I + 47 * J - 112 * A) / 3159` with
`I` the identity matrix, `J` the all-ones matrix and `A` the disjointness
adjacency matrix of the Petersen graph on the labels.  Here `3159 = 243 * 13`;
the factor `243` normalizes the Legendre values and the factor `13` is the one
supplied by the addition theorem
`RelativeConicArcs.ZonalHarmonicDegreeSix.normalizedMean_zonalHarmonic_mul`. -/
noncomputable def zonalGramEntry (p q : Pair 5) : ℝ :=
  (196 * (if p = q then 1 else 0) + 47
    - 112 * (if Disjoint p.vertices q.vertices then 1 else 0)) / 3159

private lemma not_disjoint_vertices_self (p : Pair 5) :
    ¬ Disjoint p.vertices p.vertices := by
  intro h
  obtain ⟨a, ha⟩ : p.vertices.Nonempty :=
    Finset.card_pos.mp (by rw [Pair.card_vertices]; norm_num)
  exact Finset.disjoint_left.mp h ha ha

/-- The Gram matrix of the ten face-axis zonal forms for the normalized mean of
degree twelve.  The zonal forms have degree six, so their products have degree
twelve, and the entry is `zonalGramEntry p q`; unwinding that definition, it is
`1/13` when `p = q`, `-65/3159` when the labels are disjoint and `47/3159` when
they meet in one element. -/
theorem normalizedMean_faceAxisZonalForm_mul (p q : Pair 5) :
    normalizedMean 12 (faceAxisZonalForm p * faceAxisZonalForm q) = zonalGramEntry p q := by
  rw [faceAxisZonalForm, faceAxisZonalForm,
    normalizedMean_zonalHarmonic_mul (unitFaceAxis p) (unitFaceAxis q)
      (sum_unitFaceAxis_sq p) (sum_unitFaceAxis_sq q)]
  by_cases hpq : p = q
  · subst hpq
    rw [sum_unitFaceAxis_mul_self p, legendreSix_one, zonalGramEntry,
      if_neg (not_disjoint_vertices_self p)]
    norm_num
  · rw [legendreSix_of_sq (sum_unitFaceAxis_mul_sq p q hpq), zonalGramEntry]
    by_cases hd : Disjoint p.vertices q.vertices
    · simp only [if_pos hd, if_neg hpq]
      norm_num
    · simp only [if_neg hd, if_neg hpq]
      norm_num

/-- The diagonal Gram entry: a face-axis zonal form has normalized mean square
`1/13`, the reciprocal of the dimension of the real degree-six harmonics. -/
theorem normalizedMean_faceAxisZonalForm_mul_self (p : Pair 5) :
    normalizedMean 12 (faceAxisZonalForm p * faceAxisZonalForm p) = 1 / 13 := by
  rw [normalizedMean_faceAxisZonalForm_mul, zonalGramEntry,
    if_neg (not_disjoint_vertices_self p)]
  norm_num

/-- The Gram entry on an edge of the Petersen graph, that is on two labels with
no common element. -/
theorem normalizedMean_faceAxisZonalForm_mul_of_disjoint {p q : Pair 5}
    (hd : Disjoint p.vertices q.vertices) :
    normalizedMean 12 (faceAxisZonalForm p * faceAxisZonalForm q) = -65 / 3159 := by
  have hpq : ¬ p = q := by
    rintro rfl
    exact not_disjoint_vertices_self p hd
  rw [normalizedMean_faceAxisZonalForm_mul, zonalGramEntry, if_neg hpq, if_pos hd]
  norm_num

/-- The Gram entry on two distinct labels meeting in one element. -/
theorem normalizedMean_faceAxisZonalForm_mul_of_not_disjoint {p q : Pair 5} (hpq : ¬ p = q)
    (hd : ¬ Disjoint p.vertices q.vertices) :
    normalizedMean 12 (faceAxisZonalForm p * faceAxisZonalForm q) = 47 / 3159 := by
  rw [normalizedMean_faceAxisZonalForm_mul, zonalGramEntry, if_neg hpq, if_neg hd]
  norm_num

end GramMatrix

section GramOperator

/-- The real combination of the ten face-axis zonal forms with coefficient vector
`x` indexed by the Kneser vertices. -/
noncomputable def zonalCombination (x : Pair 5 → ℝ) : MvPolynomial (Fin 3) ℝ :=
  ∑ p, C (x p) * faceAxisZonalForm p

private lemma mul_zonalCombination (w : MvPolynomial (Fin 3) ℝ) (x : Pair 5 → ℝ) :
    w * zonalCombination x = ∑ q, C (x q) * (w * faceAxisZonalForm q) := by
  rw [zonalCombination, Finset.mul_sum]
  exact Finset.sum_congr rfl fun q _ => by ring

private lemma zonalCombination_mul (x : Pair 5 → ℝ) (w : MvPolynomial (Fin 3) ℝ) :
    zonalCombination x * w = ∑ p, C (x p) * (faceAxisZonalForm p * w) := by
  rw [zonalCombination, Finset.sum_mul]
  exact Finset.sum_congr rfl fun p _ => by ring

/-- The Gram form applied to a combination of the ten zonal forms.  The three
matrix coefficients of `zonalGramEntry` reappear as the coefficient of `x p`, of
the total pair weight `totalPairSum x`, and of the Petersen adjacency operator
`adjacency x p`. -/
theorem normalizedMean_faceAxisZonalForm_mul_zonalCombination (x : Pair 5 → ℝ) (p : Pair 5) :
    normalizedMean 12 (faceAxisZonalForm p * zonalCombination x)
      = (196 * x p + 47 * totalPairSum x - 112 * adjacency x p) / 3159 := by
  have hterm : ∀ q : Pair 5,
      normalizedMean 12 (C (x q) * (faceAxisZonalForm p * faceAxisZonalForm q))
        = (196 * (if p = q then x q else 0) + 47 * x q
            - 112 * (if Disjoint p.vertices q.vertices then x q else 0)) / 3159 := by
    intro q
    rw [normalizedMean_C_mul, normalizedMean_faceAxisZonalForm_mul, zonalGramEntry]
    by_cases h2 : Disjoint p.vertices q.vertices
    · have h1 : ¬ p = q := by
        rintro rfl
        exact not_disjoint_vertices_self p h2
      simp only [if_pos h2, if_neg h1]
      ring
    · by_cases h1 : p = q
      · simp only [if_neg h2, if_pos h1]
        ring
      · simp only [if_neg h2, if_neg h1]
        ring
  have h1 : ∑ q : Pair 5, (if p = q then x q else 0) = x p := by simp
  have h2 : ∑ q : Pair 5, x q = totalPairSum x := rfl
  have h3 : ∑ q : Pair 5, (if Disjoint p.vertices q.vertices then x q else 0)
      = adjacency x p := rfl
  rw [mul_zonalCombination, normalizedMean_sum, Finset.sum_congr rfl fun q _ => hterm q,
    ← Finset.sum_div, Finset.sum_sub_distrib, Finset.sum_add_distrib, ← Finset.mul_sum,
    ← Finset.mul_sum, ← Finset.mul_sum, h1, h2, h3]

private lemma card_pair_five : Fintype.card (Pair 5) = 10 := by decide

private lemma totalPairSum_const (c : ℝ) : totalPairSum (fun _ : Pair 5 => c) = 10 * c := by
  simp only [totalPairSum, Finset.sum_const, Finset.card_univ, card_pair_five, nsmul_eq_mul]
  norm_num

private lemma adjacency_const (c : ℝ) (p : Pair 5) :
    adjacency (fun _ : Pair 5 => c) p = 3 * c := by
  have h : adjacency (fun _ : Pair 5 => c) p = ∑ _q ∈ disjointPairs p, c := by
    simp only [adjacency, disjointPairs]
    rw [← Finset.sum_filter]
  rw [h, Finset.sum_const, card_disjointPairs, show Nat.choose (5 - 2) 2 = 3 from rfl,
    nsmul_eq_mul]
  norm_num

/-- The Gram eigenvalue on the constant coefficient vectors, which span the
`3`-eigenspace of the Petersen adjacency operator: the total pair weight is
`10 * c` and each adjacency value is `3 * c`, giving the scalar `110/1053`. -/
theorem normalizedMean_faceAxisZonalForm_mul_zonalCombination_const (c : ℝ) (p : Pair 5) :
    normalizedMean 12 (faceAxisZonalForm p * zonalCombination (fun _ => c))
      = 110 / 1053 * c := by
  rw [normalizedMean_faceAxisZonalForm_mul_zonalCombination]
  simp only [totalPairSum_const, adjacency_const]
  ring

/-- The Gram eigenvalue on the Petersen `(-2)`-eigenspace.  A `-2` eigenvector
has total pair weight zero, so only the coefficients `196` and `-112 * (-2)`
survive and the scalar is `140/1053`. -/
theorem normalizedMean_faceAxisZonalForm_mul_zonalCombination_of_petersenEigen
    {x : Pair 5 → ℝ} (hx : IsPetersenNegTwoEigenvector x) (p : Pair 5) :
    normalizedMean 12 (faceAxisZonalForm p * zonalCombination x) = 140 / 1053 * x p := by
  rw [normalizedMean_faceAxisZonalForm_mul_zonalCombination,
    totalPairSum_eq_zero_of_petersenEigen (by norm_num) hx, hx p]
  ring

/-- The Gram eigenvalue on the `1`-eigenspace of the Petersen adjacency operator,
stated from the two hypotheses that the total pair weight vanishes and that the
adjacency operator fixes the coefficient vector: the scalar is `28/1053`. -/
theorem normalizedMean_faceAxisZonalForm_mul_zonalCombination_of_adjacency_eq_self
    {x : Pair 5 → ℝ} (htot : totalPairSum x = 0) (hadj : ∀ p, adjacency x p = x p)
    (p : Pair 5) :
    normalizedMean 12 (faceAxisZonalForm p * zonalCombination x) = 28 / 1053 * x p := by
  rw [normalizedMean_faceAxisZonalForm_mul_zonalCombination, htot, hadj p]
  ring

end GramOperator

section PetersenEigenspace

/-- On the Petersen `(-2)`-eigenspace the Gram form is the scalar `140/1053`
times the squared Euclidean norm of the coefficient vector. -/
theorem normalizedMean_zonalCombination_mul_self_of_petersenEigen
    {x : Pair 5 → ℝ} (hx : IsPetersenNegTwoEigenvector x) :
    normalizedMean 12 (zonalCombination x * zonalCombination x)
      = 140 / 1053 * ∑ p, x p ^ 2 := by
  have hterm : ∀ p : Pair 5,
      normalizedMean 12 (C (x p) * (faceAxisZonalForm p * zonalCombination x))
        = 140 / 1053 * x p ^ 2 := by
    intro p
    rw [normalizedMean_C_mul,
      normalizedMean_faceAxisZonalForm_mul_zonalCombination_of_petersenEigen hx p]
    ring
  rw [zonalCombination_mul, normalizedMean_sum, Finset.sum_congr rfl fun p _ => hterm p,
    ← Finset.mul_sum]

private lemma adjacency_sub (x z : Pair 5 → ℝ) :
    adjacency (x - z) = adjacency x - adjacency z := by
  funext p
  simp only [adjacency, Pi.sub_apply]
  rw [← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun q _ => ?_
  by_cases h : Disjoint p.vertices q.vertices <;> simp [h]

private lemma isPetersenNegTwoEigenvector_sub {x z : Pair 5 → ℝ}
    (hx : IsPetersenNegTwoEigenvector x) (hz : IsPetersenNegTwoEigenvector z) :
    IsPetersenNegTwoEigenvector (x - z) := by
  intro p
  rw [show adjacency (x - z) p = adjacency x p - adjacency z p from
      congrFun (adjacency_sub x z) p, hx p, hz p, Pi.sub_apply]
  ring

private lemma zonalCombination_sub (x z : Pair 5 → ℝ) :
    zonalCombination (x - z) = zonalCombination x - zonalCombination z := by
  rw [zonalCombination, zonalCombination, zonalCombination, ← Finset.sum_sub_distrib]
  refine Finset.sum_congr rfl fun p _ => ?_
  rw [Pi.sub_apply, map_sub, sub_mul]

/-- A Petersen `(-2)`-eigenvector whose combination of zonal forms vanishes is
itself zero.  The scalar `140/1053` is positive, so the squared Euclidean norm of
the coefficient vector vanishes. -/
theorem eq_zero_of_zonalCombination_eq_zero_of_petersenEigen
    {x : Pair 5 → ℝ} (hx : IsPetersenNegTwoEigenvector x)
    (hzero : zonalCombination x = 0) : x = 0 := by
  have h := normalizedMean_zonalCombination_mul_self_of_petersenEigen hx
  rw [hzero, mul_zero, show normalizedMean 12 (0 : MvPolynomial (Fin 3) ℝ) = 0 by
    simp [normalizedMean]] at h
  have hsum : ∑ p, x p ^ 2 = 0 := by linarith
  funext p
  have hp : x p ^ 2 = 0 :=
    (Finset.sum_eq_zero_iff_of_nonneg fun q _ => sq_nonneg (x q)).mp hsum p (Finset.mem_univ p)
  simpa using sq_eq_zero_iff.mp hp

/-- The passage from coefficient vectors to combinations of the ten face-axis
zonal forms is injective on the Petersen `(-2)`-eigenspace.  The domain of the
statement is exactly that eigenspace: both coefficient vectors are assumed to be
`-2` eigenvectors of the Petersen adjacency operator.  No claim is made about the
whole ten-dimensional coefficient space. -/
theorem zonalCombination_injective_of_petersenEigen {x z : Pair 5 → ℝ}
    (hx : IsPetersenNegTwoEigenvector x) (hz : IsPetersenNegTwoEigenvector z)
    (h : zonalCombination x = zonalCombination z) : x = z := by
  have hdiff : x - z = 0 :=
    eq_zero_of_zonalCombination_eq_zero_of_petersenEigen (isPetersenNegTwoEigenvector_sub hx hz)
      (by rw [zonalCombination_sub, h, sub_self])
  exact sub_eq_zero.mp hdiff

end PetersenEigenspace

section PairSumTightness

private lemma sum_over_vertices_swap {n : ℕ} (f : Fin n → Pair n → ℝ) :
    ∑ p : Pair n, ∑ i ∈ p.vertices, f i p = ∑ i, ∑ p ∈ incidentPairs i, f i p := by
  classical
  calc ∑ p : Pair n, ∑ i ∈ p.vertices, f i p
      = ∑ p : Pair n, ∑ i : Fin n, if i ∈ p.vertices then f i p else 0 :=
        Finset.sum_congr rfl fun p _ => by simp
    _ = ∑ i : Fin n, ∑ p : Pair n, if i ∈ p.vertices then f i p else 0 := Finset.sum_comm
    _ = ∑ i, ∑ p ∈ incidentPairs i, f i p := by
        refine Finset.sum_congr rfl fun i _ => ?_
        simp only [incidentPairs]
        rw [← Finset.sum_filter]

/-- Pair-sum tightness.  For a vertex weighting `y : Fin 5 → ℝ` of total weight
zero, the squared pair sums add up to three times the squared vertex weights.
Each `y i ^ 2` occurs in the four pairs through `i`, and the cross terms
assemble into `(∑ i, y i) ^ 2` minus the squares, which is the source of the
factor three. -/
theorem sum_pairSum_sq {y : Fin 5 → ℝ} (hy : ∑ i, y i = 0) :
    ∑ p : Pair 5, pairSum y p ^ 2 = 3 * ∑ i, y i ^ 2 := by
  have step1 : ∀ p : Pair 5, pairSum y p ^ 2 = ∑ i ∈ p.vertices, y i * pairSum y p := by
    intro p
    simp only [pairSum]
    rw [pow_two, Finset.sum_mul]
  have step3 : ∀ i : Fin 5, incidenceSum (pairSum y) i = 3 * y i := by
    intro i
    rw [incidenceSum_pairSum (by norm_num) y i, hy, add_zero,
      show (5 - 2 : ℕ) = 3 from rfl, nsmul_eq_mul]
    norm_num
  have step4 : ∀ i : Fin 5, ∑ p ∈ incidentPairs i, y i * pairSum y p = 3 * y i ^ 2 := by
    intro i
    rw [← Finset.mul_sum, show ∑ p ∈ incidentPairs i, pairSum y p = incidenceSum (pairSum y) i
      from rfl, step3 i]
    ring
  rw [Finset.sum_congr rfl fun p _ => step1 p, sum_over_vertices_swap,
    Finset.sum_congr rfl fun i _ => step4 i, ← Finset.mul_sum]

private lemma isPetersenNegTwoEigenvector_pairSum {y : Fin 5 → ℝ} (hy : ∑ i, y i = 0) :
    IsPetersenNegTwoEigenvector (pairSum y) := by
  intro p
  rw [adjacency_pairSum_of_sum_eq_zero (by norm_num) y hy p,
    show (5 - 3 : ℕ) = 2 from rfl, nsmul_eq_mul]
  norm_num

/-- The quadratic identity for the pair-sum coefficient vectors.  Combining
pair-sum tightness with the Gram eigenvalue `140/1053` on the Petersen
`(-2)`-eigenspace, a sum-zero vertex weighting `y` gives the normalized mean
square `(140/351) * ∑ i, y i ^ 2`. -/
theorem normalizedMean_zonalCombination_pairSum_mul_self {y : Fin 5 → ℝ}
    (hy : ∑ i, y i = 0) :
    normalizedMean 12 (zonalCombination (pairSum y) * zonalCombination (pairSum y))
      = 140 / 351 * ∑ i, y i ^ 2 := by
  rw [normalizedMean_zonalCombination_mul_self_of_petersenEigen
    (isPetersenNegTwoEigenvector_pairSum hy), sum_pairSum_sq hy]
  ring

/-- The vertex weighting taking the value `4` at the first label and `-1` at each
of the other four.  Its total weight is zero, and it is visibly constant on the
last four labels, hence fixed by every permutation of them. -/
noncomputable def stabilizerFixedVertexWeight : Fin 5 → ℝ := ![4, -1, -1, -1, -1]

/-- The normalized mean square of the combination of face-axis zonal forms
attached to the pair sums of `stabilizerFixedVertexWeight`.  That weighting has
squared Euclidean norm `20`, so the quadratic identity gives `2800/351`. -/
theorem normalizedMean_zonalCombination_stabilizerFixedVertexWeight :
    normalizedMean 12 (zonalCombination (pairSum stabilizerFixedVertexWeight)
        * zonalCombination (pairSum stabilizerFixedVertexWeight))
      = 2800 / 351 := by
  have e0 : stabilizerFixedVertexWeight 0 = 4 := rfl
  have e1 : stabilizerFixedVertexWeight 1 = -1 := rfl
  have e2 : stabilizerFixedVertexWeight 2 = -1 := rfl
  have e3 : stabilizerFixedVertexWeight 3 = -1 := rfl
  have e4 : stabilizerFixedVertexWeight 4 = -1 := rfl
  have hy : ∑ i, stabilizerFixedVertexWeight i = 0 := by
    rw [Fin.sum_univ_five, e0, e1, e2, e3, e4]
    norm_num
  have hnorm : ∑ i, stabilizerFixedVertexWeight i ^ 2 = 20 := by
    rw [Fin.sum_univ_five, e0, e1, e2, e3, e4]
    norm_num
  rw [normalizedMean_zonalCombination_pairSum_mul_self hy, hnorm]
  norm_num

end PairSumTightness

end RelativeConicArcs.FaceAxisHarmonicGram
