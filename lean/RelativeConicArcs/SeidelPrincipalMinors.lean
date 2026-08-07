import RelativeConicArcs.AlignedFamilyFaithfulness
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith

/-!
# Principal four-by-four minors of a Seidel matrix

A *Seidel matrix* over the integers is a symmetric matrix with vanishing
diagonal whose off-diagonal entries are `1` or `-1`; the hypothesis is recorded
here as `IsSeidelMatrix`, with the entry condition written as `C i j ^ 2 = 1`.
The *triangle sign* of three labels is the product of the three entries joining
them, and the *two-graph* of the matrix is the triangle-bit function recording
where that product is `-1`.  A four-set is aligned when its four triangle bits
agree, which is `Aligned` for that bit function.

The module proves the identification the reconstruction argument uses: on four
distinct labels the principal minor of a Seidel matrix is `-3` exactly on the
aligned four-sets and is `5` on all the others, so the determinant-`(-3)`
family and the aligned family are the same family.  The mechanism is that each
of the three signed Hamilton-cycle products of a four-set omits one pair of
opposite edges, hence is the product of the two triangles avoiding that pair;
so the cycle sum is the first triangle sign times the sum of the other three,
which is `3` exactly when all four triangle signs agree and is `-1` otherwise.
The determinant identity `det = 3 - 2w` turns this into the two values.

Combined with faithfulness of the aligned family on seven or more points, the
identification gives the reconstruction statement in matrix form: two Seidel
matrices on at least seven labels with the same determinant-`(-3)` four-sets
differ by a diagonal switching and one global sign.  The switching signs are
written down explicitly from a chosen label, so nothing beyond the ambient
choice used to pick that label enters.

Every finite step is a case split over the two values of an integer squaring to
one, discharged by kernel reduction, or a polynomial identity discharged by
ring normalization.  No compiled evaluation, generated data, external program,
or unproved axiom is used.
-/

namespace RelativeConicArcs
namespace AlignedTwoGraph

variable {α : Type*}

/-! ## Triangle bits of a symmetric edge signing -/

/-- The four-set parity law holds for the triangle bits of any edge-bit
function: each of the six edges of a four-set lies in exactly two of its four
triangles, so the four triangle bits sum to zero modulo two. -/
theorem fourSetParity_edgeTriangle (g : α → α → Bool) :
    FourSetParity (edgeTriangle g) := by
  intro a b c d
  simp only [edgeTriangle]
  generalize g a b = x₀
  generalize g a c = x₁
  generalize g a d = x₂
  generalize g b c = x₃
  generalize g b d = x₄
  generalize g c d = x₅
  revert x₀ x₁ x₂ x₃ x₄ x₅
  decide

/-- The triangle bits of a symmetric edge-bit function are invariant under
permuting the three labels. -/
theorem triangleSymmetric_edgeTriangle {g : α → α → Bool}
    (hg : ∀ i j, g j i = g i j) : TriangleSymmetric (edgeTriangle g) where
  swap₁₂ a b c := by
    simp only [edgeTriangle, hg a b]
    generalize g a b = x₀
    generalize g a c = x₁
    generalize g b c = x₂
    revert x₀ x₁ x₂
    decide
  swap₂₃ a b c := by
    simp only [edgeTriangle, hg b c]
    generalize g a b = x₀
    generalize g a c = x₁
    generalize g b c = x₂
    revert x₀ x₁ x₂
    decide

/-! ## Seidel matrices and their two-graphs -/

/-- A Seidel matrix over the integers: symmetric, with vanishing diagonal and
off-diagonal entries squaring to one, hence equal to `1` or `-1`. -/
structure IsSeidelMatrix (C : Matrix α α ℤ) : Prop where
  /-- The matrix is symmetric. -/
  symm : ∀ i j, C j i = C i j
  /-- The diagonal vanishes. -/
  diag : ∀ i, C i i = 0
  /-- Every off-diagonal entry squares to one. -/
  sq : ∀ i j, i ≠ j → C i j ^ 2 = 1

/-- An integer squaring to one is `1` or `-1`. -/
private theorem eq_one_or_neg_one_of_sq {x : ℤ} (h : x ^ 2 = 1) : x = 1 ∨ x = -1 := by
  have hfac : (x - 1) * (x + 1) = 0 := by linear_combination h
  rcases mul_eq_zero.mp hfac with h' | h'
  · exact Or.inl (by linarith)
  · exact Or.inr (by linarith)

/-- The edge bit of a Seidel matrix: `true` exactly on the entries equal to
`-1`. -/
def seidelEdgeBit (C : Matrix α α ℤ) (a b : α) : Bool := decide (C a b = -1)

/-- The two-graph of a Seidel matrix, recorded as a triangle-bit function: the
bit of a triple is the parity of the number of entries equal to `-1` among the
three edges joining its labels.  On distinct labels this is the bit recording
that the triangle sign is `-1`, by `seidelTriangleBit_eq_decide`. -/
def seidelTriangleBit (C : Matrix α α ℤ) : α → α → α → Bool :=
  edgeTriangle (seidelEdgeBit C)

/-- The triangle sign of three labels: the product of the three entries joining
them. -/
def seidelTriangleSign (C : Matrix α α ℤ) (a b c : α) : ℤ :=
  C a b * C a c * C b c

/-- The edge bits of a symmetric matrix are symmetric. -/
theorem seidelEdgeBit_symm {C : Matrix α α ℤ} (hC : IsSeidelMatrix C) (i j : α) :
    seidelEdgeBit C j i = seidelEdgeBit C i j := by
  simp [seidelEdgeBit, hC.symm i j]

/-- The two-graph of a Seidel matrix satisfies the four-set parity law. -/
theorem fourSetParity_seidelTriangleBit (C : Matrix α α ℤ) :
    FourSetParity (seidelTriangleBit C) :=
  fourSetParity_edgeTriangle _

/-- The two-graph of a Seidel matrix is invariant under permuting the three
labels of a triple. -/
theorem triangleSymmetric_seidelTriangleBit {C : Matrix α α ℤ}
    (hC : IsSeidelMatrix C) : TriangleSymmetric (seidelTriangleBit C) :=
  triangleSymmetric_edgeTriangle (seidelEdgeBit_symm hC)

/-- On three distinct labels the two-graph bit records that the triangle sign
is `-1`: the product of three entries each `1` or `-1` is `-1` exactly when an
odd number of them is. -/
theorem seidelTriangleBit_eq_decide {C : Matrix α α ℤ} (hC : IsSeidelMatrix C)
    {a b c : α} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    seidelTriangleBit C a b c = decide (seidelTriangleSign C a b c = -1) := by
  rcases eq_one_or_neg_one_of_sq (hC.sq a b hab) with h₁ | h₁ <;>
    rcases eq_one_or_neg_one_of_sq (hC.sq a c hac) with h₂ | h₂ <;>
      rcases eq_one_or_neg_one_of_sq (hC.sq b c hbc) with h₃ | h₃ <;>
        simp [seidelTriangleBit, seidelTriangleSign, edgeTriangle, seidelEdgeBit,
          h₁, h₂, h₃]

/-- Two integers squaring to one are equal exactly when the bits recording
which of them is `-1` are equal. -/
private theorem decide_eq_decide_iff {x y : ℤ} (hx : x = 1 ∨ x = -1)
    (hy : y = 1 ∨ y = -1) :
    (decide (x = -1) = decide (y = -1)) ↔ x = y := by
  rcases hx with rfl | rfl <;> rcases hy with rfl | rfl <;> simp

/-- A triangle sign of a Seidel matrix on distinct labels is `1` or `-1`. -/
theorem seidelTriangleSign_eq_one_or_neg_one {C : Matrix α α ℤ}
    (hC : IsSeidelMatrix C) {a b c : α} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    seidelTriangleSign C a b c = 1 ∨ seidelTriangleSign C a b c = -1 := by
  rcases eq_one_or_neg_one_of_sq (hC.sq a b hab) with h₁ | h₁ <;>
    rcases eq_one_or_neg_one_of_sq (hC.sq a c hac) with h₂ | h₂ <;>
      rcases eq_one_or_neg_one_of_sq (hC.sq b c hbc) with h₃ | h₃ <;>
        simp [seidelTriangleSign, h₁, h₂, h₃]

/-- A four-set is aligned for the two-graph of a Seidel matrix exactly when its
four triangle signs are equal. -/
theorem aligned_iff_triangleSign_eq {C : Matrix α α ℤ} (hC : IsSeidelMatrix C)
    {a b c d : α} (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    Aligned (seidelTriangleBit C) a b c d ↔
      (seidelTriangleSign C a b c = seidelTriangleSign C a b d ∧
        seidelTriangleSign C a b c = seidelTriangleSign C a c d ∧
        seidelTriangleSign C a b c = seidelTriangleSign C b c d) := by
  have h₀ := seidelTriangleSign_eq_one_or_neg_one hC hab hac hbc
  have h₁ := seidelTriangleSign_eq_one_or_neg_one hC hab had hbd
  have h₂ := seidelTriangleSign_eq_one_or_neg_one hC hac had hcd
  have h₃ := seidelTriangleSign_eq_one_or_neg_one hC hbc hbd hcd
  simp only [Aligned, seidelTriangleBit_eq_decide hC hab hac hbc,
    seidelTriangleBit_eq_decide hC hab had hbd,
    seidelTriangleBit_eq_decide hC hac had hcd,
    seidelTriangleBit_eq_decide hC hbc hbd hcd,
    decide_eq_decide_iff h₀ h₁, decide_eq_decide_iff h₀ h₂,
    decide_eq_decide_iff h₀ h₃]

/-! ## The principal minor on four labels -/

/-- The principal submatrix of a Seidel matrix on four labels, listed in the
displayed order, is the four-by-four sign matrix built from its six edges. -/
theorem submatrix_eq_fourSigningMatrix {C : Matrix α α ℤ} (hC : IsSeidelMatrix C)
    (a b c d : α) :
    C.submatrix ![a, b, c, d] ![a, b, c, d] =
      fourSigningMatrix (C a b) (C a c) (C a d) (C b c) (C b d) (C c d) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [fourSigningMatrix, Matrix.submatrix_apply, hC.diag, hC.symm]

/-- The sum of the three signed Hamilton-cycle products of a four-set is the
first triangle sign times the sum of the other three.  Each Hamilton cycle
omits one pair of opposite edges, so it is the product of the two triangles
avoiding that pair, and every such product shares its first triangle. -/
private theorem fourCycleSum_eq_triangleSign_mul {C : Matrix α α ℤ}
    (hC : IsSeidelMatrix C) {a b c d : α} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    fourCycleSum (C a b) (C a c) (C a d) (C b c) (C b d) (C c d) =
      seidelTriangleSign C a b c *
        (seidelTriangleSign C a b d + seidelTriangleSign C a c d +
          seidelTriangleSign C b c d) := by
  simp only [fourCycleSum, seidelTriangleSign]
  linear_combination (-(C a c * C a d * C b c * C b d)) * hC.sq a b hab +
    (-(C a b * C a d * C b c * C c d)) * hC.sq a c hac +
    (-(C a b * C a c * C b d * C c d)) * hC.sq b c hbc

/-- Four integers squaring to one have the last three equal to the first
exactly when the first times their sum is `3`. -/
private theorem sum_mul_eq_three_iff {t₀ t₁ t₂ t₃ : ℤ}
    (h₀ : t₀ = 1 ∨ t₀ = -1) (h₁ : t₁ = 1 ∨ t₁ = -1)
    (h₂ : t₂ = 1 ∨ t₂ = -1) (h₃ : t₃ = 1 ∨ t₃ = -1) :
    t₀ * (t₁ + t₂ + t₃) = 3 ↔ (t₀ = t₁ ∧ t₀ = t₂ ∧ t₀ = t₃) := by
  rcases h₀ with rfl | rfl <;> rcases h₁ with rfl | rfl <;>
    rcases h₂ with rfl | rfl <;> rcases h₃ with rfl | rfl <;> decide

/-- For four integers squaring to one and multiplying to one, the first times
the sum of the other three is `3` or `-1`.  The product condition is what
excludes the intermediate values `1` and `-3`. -/
private theorem sum_mul_eq_three_or_neg_one {t₀ t₁ t₂ t₃ : ℤ}
    (h₀ : t₀ = 1 ∨ t₀ = -1) (h₁ : t₁ = 1 ∨ t₁ = -1)
    (h₂ : t₂ = 1 ∨ t₂ = -1) (h₃ : t₃ = 1 ∨ t₃ = -1)
    (hprod : t₀ * t₁ * t₂ * t₃ = 1) :
    t₀ * (t₁ + t₂ + t₃) = 3 ∨ t₀ * (t₁ + t₂ + t₃) = -1 := by
  revert hprod
  rcases h₀ with rfl | rfl <;> rcases h₁ with rfl | rfl <;>
    rcases h₂ with rfl | rfl <;> rcases h₃ with rfl | rfl <;> decide

/-- The four triangle signs of a four-set multiply to one, because every one of
its six edges lies in exactly two of the four triangles. -/
theorem triangleSign_prod_eq_one {C : Matrix α α ℤ} (hC : IsSeidelMatrix C)
    {a b c d : α} (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    seidelTriangleSign C a b c * seidelTriangleSign C a b d *
      seidelTriangleSign C a c d * seidelTriangleSign C b c d = 1 := by
  simp only [seidelTriangleSign]
  linear_combination
    (C a c ^ 2 * C a d ^ 2 * C b c ^ 2 * C b d ^ 2 * C c d ^ 2) * hC.sq a b hab +
      (C a d ^ 2 * C b c ^ 2 * C b d ^ 2 * C c d ^ 2) * hC.sq a c hac +
      (C b c ^ 2 * C b d ^ 2 * C c d ^ 2) * hC.sq a d had +
      (C b d ^ 2 * C c d ^ 2) * hC.sq b c hbc +
      (C c d ^ 2) * hC.sq b d hbd + hC.sq c d hcd

/-- The principal minor of a Seidel matrix on four distinct labels is `3 - 2w`,
where `w` is the first triangle sign times the sum of the other three. -/
theorem det_submatrix_eq {C : Matrix α α ℤ} (hC : IsSeidelMatrix C)
    {a b c d : α} (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    (C.submatrix ![a, b, c, d] ![a, b, c, d]).det =
      3 - 2 * (seidelTriangleSign C a b c *
        (seidelTriangleSign C a b d + seidelTriangleSign C a c d +
          seidelTriangleSign C b c d)) := by
  rw [submatrix_eq_fourSigningMatrix hC,
    det_fourSigningMatrix_eq_three_sub_two_cycleSum _ _ _ _ _ _
      (hC.sq a b hab) (hC.sq a c hac) (hC.sq a d had) (hC.sq b c hbc)
      (hC.sq b d hbd) (hC.sq c d hcd),
    fourCycleSum_eq_triangleSign_mul hC hab hac hbc]

/-- Identification of the determinant-`(-3)` family with the aligned family: on
four distinct labels the principal minor of a Seidel matrix is `-3` exactly
when the four-set is aligned for the two-graph of that matrix. -/
theorem det_submatrix_eq_neg_three_iff_aligned {C : Matrix α α ℤ}
    (hC : IsSeidelMatrix C) {a b c d : α} (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    (C.submatrix ![a, b, c, d] ![a, b, c, d]).det = -3 ↔
      Aligned (seidelTriangleBit C) a b c d := by
  rw [det_submatrix_eq hC hab hac had hbc hbd hcd,
    aligned_iff_triangleSign_eq hC hab hac had hbc hbd hcd,
    ← sum_mul_eq_three_iff (seidelTriangleSign_eq_one_or_neg_one hC hab hac hbc)
      (seidelTriangleSign_eq_one_or_neg_one hC hab had hbd)
      (seidelTriangleSign_eq_one_or_neg_one hC hac had hcd)
      (seidelTriangleSign_eq_one_or_neg_one hC hbc hbd hcd)]
  constructor
  · intro h; linarith
  · intro h; rw [h]; ring

/-- A principal four-by-four minor of a Seidel matrix on distinct labels takes
only the values `-3` and `5`, the first exactly on the aligned four-sets. -/
theorem det_submatrix_eq_neg_three_or_five {C : Matrix α α ℤ}
    (hC : IsSeidelMatrix C) {a b c d : α} (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d)
    (hbc : b ≠ c) (hbd : b ≠ d) (hcd : c ≠ d) :
    (C.submatrix ![a, b, c, d] ![a, b, c, d]).det = -3 ∨
      (C.submatrix ![a, b, c, d] ![a, b, c, d]).det = 5 := by
  rw [det_submatrix_eq hC hab hac had hbc hbd hcd]
  rcases sum_mul_eq_three_or_neg_one
      (seidelTriangleSign_eq_one_or_neg_one hC hab hac hbc)
      (seidelTriangleSign_eq_one_or_neg_one hC hab had hbd)
      (seidelTriangleSign_eq_one_or_neg_one hC hac had hcd)
      (seidelTriangleSign_eq_one_or_neg_one hC hbc hbd hcd)
      (triangleSign_prod_eq_one hC hab hac had hbc hbd hcd) with h | h
  · exact Or.inl (by rw [h]; ring)
  · exact Or.inr (by rw [h]; ring)

/-! ## Reconstruction of the signing -/

section Reconstruction

variable {C D : Matrix α α ℤ}

/-- Every entry of a Seidel matrix is recovered from the triangle sign through
a chosen third label and the two entries joining that label to the pair. -/
private theorem entry_eq_triangleSign_mul (hC : IsSeidelMatrix C) {r i j : α}
    (hri : r ≠ i) (hrj : r ≠ j) :
    C i j = seidelTriangleSign C r i j * C r i * C r j := by
  simp only [seidelTriangleSign]
  linear_combination (-(C i j) * C r j ^ 2) * hC.sq r i hri -
    C i j * hC.sq r j hrj

/-- Reconstruction of a Seidel signing from its determinant-`(-3)` family.  Two
Seidel matrices on at least seven labels whose principal four-by-four minors on
four distinct labels take the value `-3` on the same four-sets differ by a
diagonal switching and one global sign: there are label signs `e i` squaring to
one and a sign `eta` squaring to one with `D i j = eta * e i * e j * C i j` for
all `i ≠ j`.

The route is the identification of the determinant-`(-3)` family with the
aligned family, faithfulness of the aligned family on seven or more points, and
the recovery of every entry from the triangle signs through a chosen label. -/
theorem exists_switching_of_det_family_eq [Fintype α] [DecidableEq α]
    (hC : IsSeidelMatrix C) (hD : IsSeidelMatrix D) (hcard : 7 ≤ Fintype.card α)
    (hfam : ∀ a b c d : α, DistinctQuadruple a b c d →
      ((C.submatrix ![a, b, c, d] ![a, b, c, d]).det = -3 ↔
        (D.submatrix ![a, b, c, d] ![a, b, c, d]).det = -3)) :
    ∃ (e : α → ℤ) (eta : ℤ), (∀ i, e i ^ 2 = 1) ∧ eta ^ 2 = 1 ∧
      ∀ i j, i ≠ j → D i j = eta * e i * e j * C i j := by
  classical
  -- The two two-graphs have the same aligned four-sets.
  have haligned : ∀ a b c d : α, DistinctQuadruple a b c d →
      (Aligned (seidelTriangleBit C) a b c d ↔
        Aligned (seidelTriangleBit D) a b c d) := by
    intro a b c d hq
    obtain ⟨hab, hac, had, hbc, hbd, hcd⟩ := hq
    rw [← det_submatrix_eq_neg_three_iff_aligned hC hab hac had hbc hbd hcd,
      ← det_submatrix_eq_neg_three_iff_aligned hD hab hac had hbc hbd hcd]
    exact hfam a b c d ⟨hab, hac, had, hbc, hbd, hcd⟩
  obtain ⟨epsilon, hbit⟩ :=
    exists_complementBit_of_alignedFamily_eq
      (triangleSymmetric_seidelTriangleBit hC) (fourSetParity_seidelTriangleBit C)
      (triangleSymmetric_seidelTriangleBit hD) (fourSetParity_seidelTriangleBit D)
      hcard haligned
  -- The complement bit becomes a global sign relating the triangle signs.
  obtain ⟨eta, heta, hsign⟩ : ∃ eta : ℤ, eta * eta = 1 ∧
      ∀ a b c : α, DistinctTriple a b c →
        seidelTriangleSign D a b c = eta * seidelTriangleSign C a b c := by
    refine ⟨if epsilon then -1 else 1, by cases epsilon <;> norm_num, ?_⟩
    rintro a b c ⟨hab, hac, hbc⟩
    have hbit' := hbit a b c ⟨hab, hac, hbc⟩
    rw [seidelTriangleBit_eq_decide hD hab hac hbc,
      seidelTriangleBit_eq_decide hC hab hac hbc] at hbit'
    rcases seidelTriangleSign_eq_one_or_neg_one hC hab hac hbc with hc | hc <;>
      rcases seidelTriangleSign_eq_one_or_neg_one hD hab hac hbc with hd | hd <;>
        cases epsilon <;> simp_all
  -- Switch every label other than a chosen one by the two matrices' edges to it.
  obtain ⟨r⟩ : Nonempty α := Fintype.card_pos_iff.mp (by omega)
  set e : α → ℤ := fun i => if i = r then 1 else eta * D r i * C r i with hedef
  have her : e r = 1 := by simp [hedef]
  have hei : ∀ i : α, i ≠ r → e i = eta * D r i * C r i := by
    intro i hi
    simp [hedef, hi]
  refine ⟨e, eta, ?_, ?_, ?_⟩
  · intro i
    by_cases hi : i = r
    · rw [hi, her]; norm_num
    · have hri : r ≠ i := fun h => hi h.symm
      have hCsq : C r i * C r i = 1 := by rw [← pow_two]; exact hC.sq r i hri
      have hDsq : D r i * D r i = 1 := by rw [← pow_two]; exact hD.sq r i hri
      rw [hei i hi]
      linear_combination (D r i * D r i * (C r i * C r i)) * heta +
        (C r i * C r i) * hDsq + hCsq
  · rw [pow_two]; exact heta
  · intro i j hij
    by_cases hir : i = r
    · have hrj : r ≠ j := hir ▸ hij
      have hjr : j ≠ r := fun h => hrj h.symm
      have hCsq : C r j * C r j = 1 := by rw [← pow_two]; exact hC.sq r j hrj
      rw [hir, her, hei j hjr]
      linear_combination (-(D r j) * (C r j * C r j)) * heta - D r j * hCsq
    · by_cases hjr : j = r
      · have hri : r ≠ i := fun h => hir h.symm
        have hCsq : C r i * C r i = 1 := by rw [← pow_two]; exact hC.sq r i hri
        rw [hjr, her, hei i hir, hC.symm r i, hD.symm r i]
        linear_combination (-(D r i) * (C r i * C r i)) * heta - D r i * hCsq
      · have hri : r ≠ i := fun h => hir h.symm
        have hrj : r ≠ j := fun h => hjr h.symm
        have hDij := entry_eq_triangleSign_mul hD hri hrj
        rw [hei i hir, hei j hjr, hDij, hsign r i j ⟨hri, hrj, hij⟩]
        simp only [seidelTriangleSign]
        linear_combination
          (-(C r i * C r j * C i j * D r i * D r j) * eta) * heta

end Reconstruction

end AlignedTwoGraph
end RelativeConicArcs
