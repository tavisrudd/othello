import RelativeConicArcs.PaperIOrientationHolonomy
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Coeff
import Mathlib.LinearAlgebra.Matrix.Adjugate
import Mathlib.LinearAlgebra.Matrix.SchurComplement

/-!
# Principal minors and the diagonal determinant pencil

This packet expands the determinant of the golden signed orbital matrix after
adding six diagonal variables.  The coefficients are principal minors.  The
three-by-three coefficient is twice triangle holonomy; complementary minors
then give the size-four value `5`, size-five value `0`, and determinant
`-125`.  The displayed expansion is the Paper-I determinant pencil.
-/

namespace RelativeConicArcs.PaperIOrientationDeterminant

open Matrix
open scoped Matrix
open ClebschGoldenConference
open PaperIOrientationPentagon
open PaperIOrientationHolonomy

/-- Elementary symmetric polynomial in the six displayed coordinates. -/
def elementarySymmetric (k : ℕ) (x : Fin 6 → ℤ) : ℤ :=
  ∑ s ∈ Finset.univ.powersetCard k, ∏ i ∈ s, x i

/-- The diagonal determinant pencil of the signed orbital operator. -/
def determinantPencil (x : Fin 6 → ℤ) : ℤ :=
  Matrix.det (fiberOddOrbitalMatrix + Matrix.diagonal x)

/-- The signed orbital operator over the rational field, where its inverse is
available for Jacobi complementation. -/
def rationalSignedOrbitalMatrix : Matrix (Fin 6) (Fin 6) ℚ :=
  fiberOddOrbitalMatrix.map (Int.castRingHom ℚ)

theorem rationalSignedOrbitalMatrix_sq :
    rationalSignedOrbitalMatrix * rationalSignedOrbitalMatrix =
      5 • (1 : Matrix (Fin 6) (Fin 6) ℚ) := by
  calc
    _ = (fiberOddOrbitalMatrix * fiberOddOrbitalMatrix).map
        (Int.castRingHom ℚ) := by
      rw [rationalSignedOrbitalMatrix, Matrix.map_mul]
    _ = (5 • (1 : Matrix (Fin 6) (Fin 6) ℤ)).map
        (Int.castRingHom ℚ) := by rw [signedOrbitalMatrix_sq]
    _ = 5 • (1 : Matrix (Fin 6) (Fin 6) ℚ) := by
      ext i j
      change (Int.castRingHom ℚ) (5 • ((1 : Matrix (Fin 6) (Fin 6) ℤ) i j)) =
        (5 : ℚ) • ((1 : Matrix (Fin 6) (Fin 6) ℚ) i j)
      by_cases hij : i = j <;> simp [Matrix.one_apply, hij]

/-- The conference equation gives the inverse used in Jacobi's identity. -/
theorem rationalSignedOrbitalMatrix_inv :
    rationalSignedOrbitalMatrix⁻¹ = (1 / 5 : ℚ) • rationalSignedOrbitalMatrix := by
  apply Matrix.inv_eq_right_inv
  rw [Matrix.mul_smul, rationalSignedOrbitalMatrix_sq]
  change (1 / 5 : ℚ) • ((5 : ℚ) • (1 : Matrix (Fin 6) (Fin 6) ℚ)) = 1
  rw [smul_smul]
  norm_num

/-- Reindex six axes as a deleted ordered pair followed by its four-point
complement. -/
noncomputable def pairComplementEquiv (a : Fin 6) (b : Fin 5) :
    Fin 2 ⊕ Fin 4 ≃ Fin 6 := by
  let f : Fin 2 ⊕ Fin 4 → Fin 6
    | Sum.inl i => Fin.cases a (fun _ => a.succAbove b) i
    | Sum.inr i => a.succAbove (b.succAbove i)
  apply Equiv.ofBijective f
  apply (Fintype.bijective_iff_surjective_and_card f).2
  constructor
  · intro x
    exact Fin.succAboveCases a
      ⟨Sum.inl 0, rfl⟩
      (fun i => Fin.succAboveCases b
        ⟨Sum.inl 1, rfl⟩
        (fun j => ⟨Sum.inr j, rfl⟩) i) x
  · simp

/-- Rational conference matrix in deleted-pair block order. -/
noncomputable def pairBlockMatrix (a : Fin 6) (b : Fin 5) :
    Matrix (Fin 2 ⊕ Fin 4) (Fin 2 ⊕ Fin 4) ℚ :=
  Matrix.reindex (pairComplementEquiv a b).symm
    (pairComplementEquiv a b).symm rationalSignedOrbitalMatrix

/-- The complementary two-by-two block is invertible, with determinant
`-1`; this is the local unit in the Jacobi argument. -/
theorem pairBlockMatrix_toBlocks₁₁_det (a : Fin 6) (b : Fin 5) :
    Matrix.det (pairBlockMatrix a b).toBlocks₁₁ = -1 := by
  rw [Matrix.det_fin_two]
  have hab : a ≠ a.succAbove b := (Fin.succAbove_ne a b).symm
  have hsq := fiberOddOrbitalMatrix_apply_sq a (a.succAbove b) hab
  have hsymm : fiberOddOrbitalMatrix (a.succAbove b) a =
      fiberOddOrbitalMatrix a (a.succAbove b) := by
    simpa [Matrix.transpose_apply] using
      congrArg (fun M => M a (a.succAbove b)) fiberOddOrbitalMatrix_transpose
  change
    (fiberOddOrbitalMatrix a a : ℚ) *
          fiberOddOrbitalMatrix (a.succAbove b) (a.succAbove b) -
        fiberOddOrbitalMatrix a (a.succAbove b) *
          fiberOddOrbitalMatrix (a.succAbove b) a = -1
  rw [fiberOddOrbitalMatrix_apply_self,
    fiberOddOrbitalMatrix_apply_self]
  norm_num only [Int.cast_zero, zero_mul, zero_sub]
  rw [hsymm]
  exact_mod_cast (congrArg Neg.neg hsq)

/-- Multilinearity in the rows expands an arbitrary diagonal perturbation as
a sum of complementary diagonal monomials times principal minors. -/
theorem det_add_diagonal_eq_sum_principalMinors
    {R : Type*} [CommRing R] {n : Type*} [Fintype n] [DecidableEq n]
    (M : Matrix n n R) (x : n → R) :
    Matrix.det (M + Matrix.diagonal x) =
      ∑ s : Finset n, (∏ i ∈ sᶜ, x i) *
        Matrix.det (M.submatrix (Subtype.val : s → n) Subtype.val) := by
  let D := (Matrix.detRowAlternating : (n → R) [⋀^n]→ₗ[R] R)
  change D (M.row + (Matrix.diagonal x).row) = _
  rw [D.map_add_univ]
  apply Finset.sum_congr rfl
  intro s _
  have hrow :
      s.piecewise M.row (Matrix.diagonal x).row =
        fun i => (if i ∈ s then 1 else x i) •
          s.piecewise M.row (1 : Matrix n n R).row i := by
    funext i j
    simp only [Finset.piecewise, Pi.smul_apply, smul_eq_mul]
    split_ifs with hi
    · simp
    · by_cases hij : i = j <;>
        simp [hij]
  rw [hrow, D.map_smul_univ]
  change (∏ i, if i ∈ s then 1 else x i) *
      Matrix.det (Matrix.of (s.piecewise M.row (1 : Matrix n n R).row)) = _
  rw [Matrix.det_piecewise_one_eq_submatrix_det]
  congr 1
  rw [Finset.prod_ite]
  simp only [Finset.prod_const_one, one_mul]
  apply Finset.prod_congr
  · ext i
    simp
  · intro i hi
    rfl

/-- The order-three zero-diagonal symmetric determinant is twice its triangle
product.  This is the local principal-minor calculation used in the pencil. -/
theorem det_signed_three {R : Type*} [CommRing R]
    (a b c : R) :
    Matrix.det !![0, a, c; a, 0, b; c, b, 0] = 2 * (a * b * c) := by
  simp [Matrix.det_fin_three]
  ring

/-- Every three-by-three principal block has determinant twice its triangle
holonomy. -/
theorem det_principal_three (f : Fin 3 → Fin 6) :
    Matrix.det (fun i j => fiberOddOrbitalMatrix (f i) (f j)) =
      2 * (fiberOddOrbitalMatrix (f 0) (f 1) *
        fiberOddOrbitalMatrix (f 1) (f 2) *
        fiberOddOrbitalMatrix (f 2) (f 0)) := by
  rw [Matrix.det_fin_three]
  have hsymm : ∀ i j,
      fiberOddOrbitalMatrix i j = fiberOddOrbitalMatrix j i := by
    intro i j
    simpa [Matrix.transpose_apply] using
      congrArg (fun M => M j i) fiberOddOrbitalMatrix_transpose
  simp [fiberOddOrbitalMatrix_apply_self, hsymm]
  ring

/-- The single explicit sign normalization for the conference determinant. -/
theorem det_signedOrbitalMatrix : Matrix.det fiberOddOrbitalMatrix = -125 := by
  set_option maxRecDepth 16384 in
    decide

theorem det_rationalSignedOrbitalMatrix :
    Matrix.det rationalSignedOrbitalMatrix = -125 := by
  calc
    Matrix.det rationalSignedOrbitalMatrix =
        (Int.castRingHom ℚ) (Matrix.det fiberOddOrbitalMatrix) := by
      exact (RingHom.map_det (Int.castRingHom ℚ) fiberOddOrbitalMatrix).symm
    _ = -125 := by rw [det_signedOrbitalMatrix]; norm_num

/-- Cramer's identity together with `B⁻¹=B/5` gives
`adj(B)=-25B`. -/
theorem adjugate_rationalSignedOrbitalMatrix :
    Matrix.adjugate rationalSignedOrbitalMatrix =
      (-25 : ℚ) • rationalSignedOrbitalMatrix := by
  ext i j
  have h := congrArg (fun M : Matrix (Fin 6) (Fin 6) ℚ => M i j)
    (Matrix.inv_def rationalSignedOrbitalMatrix)
  rw [rationalSignedOrbitalMatrix_inv, det_rationalSignedOrbitalMatrix] at h
  simp only [Matrix.smul_apply, smul_eq_mul] at h ⊢
  norm_num at h ⊢
  linarith

/-- Five-by-five principal minor obtained by deleting one axis. -/
def principalMinorFive (a : Fin 6) : Matrix (Fin 5) (Fin 5) ℤ :=
  fun i j => fiberOddOrbitalMatrix (a.succAbove i) (a.succAbove j)

/-- The size-five principal minors vanish. -/
theorem det_principalMinorFive (a : Fin 6) :
    Matrix.det (principalMinorFive a) = 0 := by
  have hcof := Matrix.adjugate_fin_succ_eq_det_submatrix
    rationalSignedOrbitalMatrix a a
  have hdiag : Matrix.adjugate rationalSignedOrbitalMatrix a a = 0 := by
    rw [adjugate_rationalSignedOrbitalMatrix]
    simp [rationalSignedOrbitalMatrix, fiberOddOrbitalMatrix_apply_self]
  rw [hdiag] at hcof
  have heven : Even (a.val + a.val) := Even.add_self a.val
  rw [heven.neg_one_pow, one_mul] at hcof
  have hbridge : rationalSignedOrbitalMatrix.submatrix a.succAbove a.succAbove =
      (principalMinorFive a).map (Int.castRingHom ℚ) := by
    ext i j
    rfl
  rw [hbridge] at hcof
  have hdetq : Matrix.det ((principalMinorFive a).map (Int.castRingHom ℚ)) = 0 := by
    exact hcof.symm
  have hcast : ((Matrix.det (principalMinorFive a) : ℤ) : ℚ) = 0 := by
    calc
      _ = Matrix.det ((principalMinorFive a).map (Int.castRingHom ℚ)) :=
        RingHom.map_det (Int.castRingHom ℚ) (principalMinorFive a)
      _ = 0 := hdetq
  exact_mod_cast hcast

/-- Four-by-four principal minor obtained by deleting an ordered pair of
distinct axes. -/
def principalMinorFour (a : Fin 6) (b : Fin 5) : Matrix (Fin 4) (Fin 4) ℤ :=
  fun i j => fiberOddOrbitalMatrix
    (a.succAbove (b.succAbove i)) (a.succAbove (b.succAbove j))

set_option maxRecDepth 4096 in
theorem pairBlockMatrix_toBlocks₂₂ (a : Fin 6) (b : Fin 5) :
    (pairBlockMatrix a b).toBlocks₂₂ =
      (principalMinorFour a b).map (Int.castRingHom ℚ) := by
  ext i j
  rfl

/-- The order-four complete graph over `F₂`.  Every signed order-four
principal block reduces to this matrix. -/
def completeFourMatrixModTwo : Matrix (Fin 4) (Fin 4) (ZMod 2) :=
  fun i j => if i = j then 0 else 1

theorem principalMinorFour_map_modTwo (a : Fin 6) (b : Fin 5) :
    (principalMinorFour a b).map (Int.castRingHom (ZMod 2)) =
      completeFourMatrixModTwo := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [principalMinorFour, completeFourMatrixModTwo,
      fiberOddOrbitalMatrix_apply_self]
  · have hab : a.succAbove (b.succAbove i) ≠
        a.succAbove (b.succAbove j) := by
      intro h
      apply hij
      exact Fin.succAbove_right_injective
        (Fin.succAbove_right_injective h)
    have hsq := fiberOddOrbitalMatrix_apply_sq
      (a.succAbove (b.succAbove i)) (a.succAbove (b.succAbove j)) hab
    rcases (mul_self_eq_one_iff.mp hsq) with h | h
    · simp [principalMinorFour, completeFourMatrixModTwo, hij, h]
    · simp [principalMinorFour, completeFourMatrixModTwo, hij, h]

theorem det_completeFourMatrixModTwo :
    Matrix.det completeFourMatrixModTwo = 1 := by
  decide

/-- Structural nonsingularity needed to apply the Schur/Jacobi identity:
modulo two every signed four-point block is the complete-graph matrix, whose
determinant is one. -/
theorem det_principalMinorFour_ne_zero (a : Fin 6) (b : Fin 5) :
    Matrix.det (principalMinorFour a b) ≠ 0 := by
  intro hzero
  have hmap := RingHom.map_det (Int.castRingHom (ZMod 2))
    (principalMinorFour a b)
  rw [hzero] at hmap
  simp only [map_zero] at hmap
  have hdetmap : Matrix.det
      ((principalMinorFour a b).map (Int.castRingHom (ZMod 2))) = 1 := by
    rw [principalMinorFour_map_modTwo, det_completeFourMatrixModTwo]
  exact zero_ne_one (hmap.trans hdetmap)

/-- Jacobi's complementary-principal-minor identity in block form.  The
bottom-right block is assumed invertible; Schur complementation identifies
its determinant with the determinant of the whole matrix times the matching
principal block of the inverse. -/
theorem det_bottomRight_eq_det_mul_det_inv_topLeft
    {K : Type*} [Field K]
    {m n : Type*} [Fintype m] [Fintype n] [DecidableEq m] [DecidableEq n]
    (A : Matrix m m K) (B : Matrix m n K)
    (C : Matrix n m K) (D : Matrix n n K)
    [Invertible D] [Invertible (Matrix.fromBlocks A B C D)] :
    Matrix.det D = Matrix.det (Matrix.fromBlocks A B C D) *
      Matrix.det (⅟(Matrix.fromBlocks A B C D)).toBlocks₁₁ := by
  let S := A - B * ⅟D * C
  letI : Invertible S :=
    Matrix.invertibleOfFromBlocks₂₂Invertible A B C D
  letI : Invertible (Matrix.det S) := Matrix.detInvertibleOfInvertible S
  have hinv := Matrix.invOf_fromBlocks₂₂_eq A B C D
  have htop : (⅟(Matrix.fromBlocks A B C D)).toBlocks₁₁ = ⅟S := by
    rw [hinv]
    rfl
  rw [Matrix.det_fromBlocks₂₂, htop, Matrix.det_invOf]
  change Matrix.det D = Matrix.det D * Matrix.det S * ⅟(Matrix.det S)
  rw [mul_assoc, mul_invOf_self, mul_one]

theorem det_pairBlockMatrix (a : Fin 6) (b : Fin 5) :
    Matrix.det (pairBlockMatrix a b) = -125 := by
  rw [pairBlockMatrix, Matrix.det_reindex_self]
  exact det_rationalSignedOrbitalMatrix

theorem pairBlockMatrix_inv_topLeft (a : Fin 6) (b : Fin 5) :
    (pairBlockMatrix a b)⁻¹.toBlocks₁₁ =
      (1 / 5 : ℚ) • (pairBlockMatrix a b).toBlocks₁₁ := by
  rw [pairBlockMatrix, Matrix.inv_reindex, rationalSignedOrbitalMatrix_inv]
  ext i j
  rfl

/-- Every size-four principal minor is `5`. -/
theorem det_principalMinorFour (a : Fin 6) (b : Fin 5) :
    Matrix.det (principalMinorFour a b) = 5 := by
  let M := pairBlockMatrix a b
  let A := M.toBlocks₁₁
  let B := M.toBlocks₁₂
  let C := M.toBlocks₂₁
  let D := M.toBlocks₂₂
  have hMdet : Matrix.det M = -125 := det_pairBlockMatrix a b
  have hMne : Matrix.det M ≠ 0 := by rw [hMdet]; norm_num
  have hDne : Matrix.det D ≠ 0 := by
    rw [show D = (principalMinorFour a b).map (Int.castRingHom ℚ) by
      exact pairBlockMatrix_toBlocks₂₂ a b]
    intro hzero
    have hcast : ((Matrix.det (principalMinorFour a b) : ℤ) : ℚ) = 0 := by
      calc
        _ = Matrix.det ((principalMinorFour a b).map (Int.castRingHom ℚ)) :=
          RingHom.map_det (Int.castRingHom ℚ) (principalMinorFour a b)
        _ = 0 := hzero
    exact det_principalMinorFour_ne_zero a b (by exact_mod_cast hcast)
  letI : Invertible D :=
    Matrix.invertibleOfIsUnitDet (A := D) (isUnit_iff_ne_zero.mpr hDne)
  have hblocks : Matrix.fromBlocks A B C D = M := by
    exact Matrix.fromBlocks_toBlocks M
  letI : Invertible (Matrix.fromBlocks A B C D) :=
    Matrix.invertibleOfIsUnitDet (A := Matrix.fromBlocks A B C D)
      (isUnit_iff_ne_zero.mpr (by
      rw [hblocks]
      exact hMne))
  have hj := det_bottomRight_eq_det_mul_det_inv_topLeft A B C D
  have hFdet : Matrix.det (Matrix.fromBlocks A B C D) = -125 := by
    rw [hblocks]
    exact hMdet
  have htopdet : Matrix.det
      (⅟(Matrix.fromBlocks A B C D)).toBlocks₁₁ = (-1 / 25 : ℚ) := by
    rw [Matrix.invOf_eq_nonsing_inv, hblocks,
      show M = pairBlockMatrix a b by rfl,
      pairBlockMatrix_inv_topLeft, Matrix.det_smul,
      pairBlockMatrix_toBlocks₁₁_det]
    norm_num
  rw [hFdet, htopdet] at hj
  norm_num at hj
  have hcast : ((Matrix.det (principalMinorFour a b) : ℤ) : ℚ) = 5 := by
    calc
      _ = Matrix.det ((principalMinorFour a b).map (Int.castRingHom ℚ)) :=
        RingHom.map_det (Int.castRingHom ℚ) (principalMinorFour a b)
      _ = Matrix.det D := by rw [show D =
          (principalMinorFour a b).map (Int.castRingHom ℚ) by
            exact pairBlockMatrix_toBlocks₂₂ a b]
      _ = 5 := hj
  exact_mod_cast hcast

/-- The principal block retained after deleting the axes in `t`.  Writing the
diagonal expansion in terms of deleted axes makes its monomial have exactly
degree `#t`. -/
def complementPrincipalBlock (t : Finset (Fin 6)) : Matrix ↑(tᶜ) ↑(tᶜ) ℤ :=
  fiberOddOrbitalMatrix.submatrix Subtype.val Subtype.val

theorem det_principal_card_zero (s : Finset (Fin 6)) (hs : s.card = 0) :
    Matrix.det (fiberOddOrbitalMatrix.submatrix
      (Subtype.val : s → Fin 6) Subtype.val) = 1 := by
  rw [Finset.card_eq_zero.mp hs]
  simp

theorem det_principal_card_one (s : Finset (Fin 6)) (hs : s.card = 1) :
    Matrix.det (fiberOddOrbitalMatrix.submatrix
      (Subtype.val : s → Fin 6) Subtype.val) = 0 := by
  let e : Fin 1 ≃ s := (s.equivFinOfCardEq hs).symm
  rw [← Matrix.det_submatrix_equiv_self e]
  simp [fiberOddOrbitalMatrix_apply_self]

theorem det_principal_card_two (s : Finset (Fin 6)) (hs : s.card = 2) :
    Matrix.det (fiberOddOrbitalMatrix.submatrix
      (Subtype.val : s → Fin 6) Subtype.val) = -1 := by
  let e : Fin 2 ≃ s := (s.equivFinOfCardEq hs).symm
  rw [← Matrix.det_submatrix_equiv_self e, Matrix.det_fin_two]
  have hne : (e 0).val ≠ (e 1).val := by
    intro h
    have : e 0 = e 1 := Subtype.ext h
    exact Fin.zero_ne_one (e.injective this)
  have hsymm : fiberOddOrbitalMatrix (e 1).val (e 0).val =
      fiberOddOrbitalMatrix (e 0).val (e 1).val := by
    simpa [Matrix.transpose_apply] using congrArg
      (fun M => M (e 0).val (e 1).val) fiberOddOrbitalMatrix_transpose
  simp only [Matrix.submatrix_apply]
  rw [fiberOddOrbitalMatrix_apply_self,
    fiberOddOrbitalMatrix_apply_self, hsymm]
  have hsq := fiberOddOrbitalMatrix_apply_sq (e 0).val (e 1).val hne
  omega

theorem det_principal_card_six (s : Finset (Fin 6)) (hs : s.card = 6) :
    Matrix.det (fiberOddOrbitalMatrix.submatrix
      (Subtype.val : s → Fin 6) Subtype.val) = -125 := by
  let e : Fin 6 ≃ s := (s.equivFinOfCardEq hs).symm
  let f : Fin 6 → Fin 6 := fun i => (e i).val
  have hf : Function.Bijective f :=
    (Fintype.bijective_iff_injective_and_card f).2
      ⟨fun _ _ h => e.injective (Subtype.ext h), rfl⟩
  let p : Fin 6 ≃ Fin 6 := Equiv.ofBijective f hf
  rw [← Matrix.det_submatrix_equiv_self e]
  change Matrix.det (fiberOddOrbitalMatrix.submatrix p p) = -125
  rw [Matrix.det_submatrix_equiv_self]
  exact det_signedOrbitalMatrix

/-- Deleting one axis leaves one of the five-by-five cofactor blocks. -/
theorem det_complement_card_one (t : Finset (Fin 6)) (ht : t.card = 1) :
    Matrix.det (complementPrincipalBlock t) = 0 := by
  let a : Fin 6 := t.orderEmbOfFin ht 0
  have hta : t = {a} := by
    simpa [a] using (t.image_orderEmbOfFin_univ ht).symm
  let f : Fin 5 → ↑(tᶜ) := fun i => ⟨a.succAbove i, by
    simp [hta, a.succAbove_ne i]⟩
  have hf_inj : Function.Injective f := by
    intro i j h
    apply Fin.succAbove_right_injective
    exact congrArg Subtype.val h
  have hf : Function.Bijective f :=
    (Fintype.bijective_iff_injective_and_card f).2 ⟨hf_inj, by
      simp [ht]⟩
  let e : Fin 5 ≃ ↑(tᶜ) := Equiv.ofBijective f hf
  rw [← Matrix.det_submatrix_equiv_self e]
  change Matrix.det (principalMinorFive a) = 0
  exact det_principalMinorFive a

/-- Deleting two axes leaves one of the four-by-four Jacobi blocks. -/
theorem det_complement_card_two (t : Finset (Fin 6)) (ht : t.card = 2) :
    Matrix.det (complementPrincipalBlock t) = 5 := by
  let a : Fin 6 := t.orderEmbOfFin ht 0
  let c : Fin 6 := t.orderEmbOfFin ht 1
  have hac : a ≠ c := by
    intro h
    have : (0 : Fin 2) = 1 := (t.orderEmbOfFin ht).injective h
    exact Fin.zero_ne_one this
  obtain ⟨b, hb⟩ := Fin.exists_succAbove_eq hac.symm
  have hta : t = {a, c} := by
    have hu : (Finset.univ : Finset (Fin 2)) = {0, 1} := by decide
    rw [← t.image_orderEmbOfFin_univ ht, hu]
    simp [a, c]
  let f : Fin 4 → ↑(tᶜ) := fun i => ⟨a.succAbove (b.succAbove i), by
    have hne_a : a.succAbove (b.succAbove i) ≠ a :=
      a.succAbove_ne (b.succAbove i)
    have hne_c : a.succAbove (b.succAbove i) ≠ c := by
      rw [← hb]
      intro h
      exact (b.succAbove_ne i)
        (Fin.succAbove_right_injective h)
    simp [hta, hne_a, hne_c]⟩
  have hf_inj : Function.Injective f := by
    intro i j h
    apply Fin.succAbove_right_injective
    apply Fin.succAbove_right_injective
    exact congrArg Subtype.val h
  have hf : Function.Bijective f :=
    (Fintype.bijective_iff_injective_and_card f).2 ⟨hf_inj, by
      simp [ht]⟩
  let e : Fin 4 ≃ ↑(tᶜ) := Equiv.ofBijective f hf
  rw [← Matrix.det_submatrix_equiv_self e]
  change Matrix.det (principalMinorFour a b) = 5
  exact det_principalMinorFour a b

theorem det_complement_card_four (t : Finset (Fin 6)) (ht : t.card = 4) :
    Matrix.det (complementPrincipalBlock t) = -1 := by
  apply det_principal_card_two
  simp [Finset.card_compl, ht]

theorem det_complement_card_five (t : Finset (Fin 6)) (ht : t.card = 5) :
    Matrix.det (complementPrincipalBlock t) = 0 := by
  apply det_principal_card_one
  simp [Finset.card_compl, ht]

theorem det_complement_card_six (t : Finset (Fin 6)) (ht : t.card = 6) :
    Matrix.det (complementPrincipalBlock t) = 1 := by
  apply det_principal_card_zero
  simp [Finset.card_compl, ht]

theorem det_complement_card_zero (t : Finset (Fin 6)) (ht : t.card = 0) :
    Matrix.det (complementPrincipalBlock t) = -125 := by
  apply det_principal_card_six
  simp [Finset.card_compl, ht]

/-- The ten positive triples in the normalized six-axis switching class.  This
is the sole explicit orientation table used by the determinant argument. -/
def positiveSupportTripleFinsets : Finset (Finset (Fin 6)) :=
  {{0, 1, 4}, {0, 1, 5}, {0, 2, 3}, {0, 2, 5}, {0, 3, 4},
   {1, 2, 3}, {1, 2, 4}, {1, 3, 5}, {2, 4, 5}, {3, 4, 5}}

/-- Reducible evaluation of the normalized holonomy sign on an unordered
three-subset.  It is zero off cardinality three. -/
def principalHolonomy (s : Finset (Fin 6)) : ℤ :=
  if s.card = 3 then
    if s ∈ positiveSupportTripleFinsets then 1 else -1
  else 0

/-- The reducible table agrees with triangle holonomy on increasing triples.
This is a bounded normalization check over the twenty three-subsets, not a
determinant calculation. -/
theorem triangleSign_eq_principalHolonomy_of_lt :
    ∀ i j k : Fin 6, i < j → j < k →
      triangleSign fiberOddOrbitalMatrix i j k =
        principalHolonomy {i, j, k} := by
  decide

theorem principalHolonomy_triple_of_lt (i j k : Fin 6)
    (hij : i < j) (hjk : j < k) :
    principalHolonomy {i, j, k} =
      triangleSign fiberOddOrbitalMatrix i j k :=
  (triangleSign_eq_principalHolonomy_of_lt i j k hij hjk).symm

theorem det_principal_card_three (s : Finset (Fin 6)) (hs : s.card = 3) :
    Matrix.det (fiberOddOrbitalMatrix.submatrix
      (Subtype.val : s → Fin 6) Subtype.val) = 2 * principalHolonomy s := by
  let f : Fin 3 ↪o Fin 6 := s.orderEmbOfFin hs
  let e : Fin 3 ≃ s := (s.orderIsoOfFin hs).toEquiv
  rw [← Matrix.det_submatrix_equiv_self e]
  change Matrix.det (fun i j =>
    fiberOddOrbitalMatrix (f i) (f j)) = _
  rw [det_principal_three]
  have h01 : f 0 < f 1 := f.strictMono (by decide)
  have h12 : f 1 < f 2 := f.strictMono (by decide)
  rw [show fiberOddOrbitalMatrix (f 0) (f 1) *
      fiberOddOrbitalMatrix (f 1) (f 2) *
      fiberOddOrbitalMatrix (f 2) (f 0) =
        triangleSign fiberOddOrbitalMatrix (f 0) (f 1) (f 2) by rfl]
  rw [triangleSign_eq_principalHolonomy_of_lt (f 0) (f 1) (f 2) h01 h12]
  congr 2
  rw [← s.image_orderEmbOfFin_univ hs]
  have hu : (Finset.univ : Finset (Fin 3)) = {0, 1, 2} := by decide
  rw [hu]
  simp [f]

theorem det_complement_card_three (t : Finset (Fin 6)) (ht : t.card = 3) :
    Matrix.det (complementPrincipalBlock t) =
      2 * principalHolonomy tᶜ := by
  apply det_principal_card_three
  rw [Finset.card_compl]
  simp only [Fintype.card_fin]
  omega

/-- The twenty increasing triples used by the displayed support cubic. -/
def supportTripleFinsets : Finset (Finset (Fin 6)) :=
  {{0, 1, 2}, {0, 1, 3}, {0, 1, 4}, {0, 1, 5},
   {0, 2, 3}, {0, 2, 4}, {0, 2, 5}, {0, 3, 4}, {0, 3, 5}, {0, 4, 5},
   {1, 2, 3}, {1, 2, 4}, {1, 2, 5}, {1, 3, 4}, {1, 3, 5}, {1, 4, 5},
   {2, 3, 4}, {2, 3, 5}, {2, 4, 5}, {3, 4, 5}}

theorem powersetCard_three_fin_six :
    (Finset.univ : Finset (Fin 6)).powersetCard 3 = supportTripleFinsets := by
  decide

/-- The normalized six-point switching class assigns opposite holonomy to
complementary triples.  This is the small twenty-triple orientation table,
separate from all determinant calculations. -/
theorem principalHolonomy_compl (t : Finset (Fin 6)) (ht : t.card = 3) :
    principalHolonomy tᶜ = -principalHolonomy t := by
  have htmem : t ∈ supportTripleFinsets := by
    rw [← powersetCard_three_fin_six]
    exact Finset.mem_powersetCard.mpr ⟨Finset.subset_univ t, ht⟩
  simp only [supportTripleFinsets, Finset.mem_insert,
    Finset.mem_singleton] at htmem
  rcases htmem with
    (rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl |
     rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl) <;>
    decide

/-- The increasing three-subsets give the twenty displayed monomials in the
definition of the support cubic. -/
theorem supportCubic_eq_sum_principalHolonomy (x : Fin 6 → ℤ) :
    supportCubic x =
      ∑ t ∈ Finset.univ.powersetCard 3,
        principalHolonomy t * ∏ i ∈ t, x i := by
  rw [powersetCard_three_fin_six]
  rw [supportTripleFinsets]
  repeat rw [Finset.sum_insert (by decide)]
  rw [Finset.sum_singleton]
  simp only [supportCubic, triangleCubic, cubicTerm]
  rw [principalHolonomy_triple_of_lt 0 1 2 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 1 3 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 1 4 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 1 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 2 3 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 2 4 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 2 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 3 4 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 3 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 0 4 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 1 2 3 (by decide) (by decide),
    principalHolonomy_triple_of_lt 1 2 4 (by decide) (by decide),
    principalHolonomy_triple_of_lt 1 2 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 1 3 4 (by decide) (by decide),
    principalHolonomy_triple_of_lt 1 3 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 1 4 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 2 3 4 (by decide) (by decide),
    principalHolonomy_triple_of_lt 2 3 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 2 4 5 (by decide) (by decide),
    principalHolonomy_triple_of_lt 3 4 5 (by decide) (by decide)]
  simp
  ring

/-- Negating all six variables multiplies the degree-`k` elementary symmetric
polynomial by `(-1)^k`. -/
theorem elementarySymmetric_neg (k : ℕ) (x : Fin 6 → ℤ) :
    elementarySymmetric k (-x) = (-1 : ℤ) ^ k * elementarySymmetric k x := by
  rw [elementarySymmetric, elementarySymmetric, Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro s hs
  simp only [Pi.neg_apply]
  rw [Finset.prod_neg, (Finset.mem_powersetCard.mp hs).2]

/-- The support cubic is homogeneous of odd degree three. -/
theorem supportCubic_neg (x : Fin 6 → ℤ) :
    supportCubic (-x) = -supportCubic x := by
  simp only [supportCubic, triangleCubic, cubicTerm, Pi.neg_apply]
  ring

/-- Complementation reindexes the multilinear determinant expansion by the
deleted axes. -/
theorem sum_principal_eq_sum_complement (x : Fin 6 → ℤ) :
    (∑ s : Finset (Fin 6), (∏ i ∈ sᶜ, x i) *
      Matrix.det (fiberOddOrbitalMatrix.submatrix
        (Subtype.val : s → Fin 6) Subtype.val)) =
    ∑ t : Finset (Fin 6), (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) := by
  let e : Finset (Fin 6) ≃ Finset (Fin 6) :=
    Equiv.ofBijective (fun s => sᶜ) compl_bijective
  rw [← e.sum_comp]
  simp [e, complementPrincipalBlock]
  rfl

/-- The middle-degree complementary minors carry the opposite triangle
holonomy.  This is the finite orientation matching for the twenty triples;
the determinant of each block itself is supplied by `det_principal_card_three`.
-/
theorem sum_card_three_complementary_minors (x : Fin 6 → ℤ) :
    ∑ t ∈ Finset.univ.powersetCard 3, (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) = -2 * supportCubic x := by
  rw [supportCubic_eq_sum_principalHolonomy]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro t ht
  have hcard : t.card = 3 := (Finset.mem_powersetCard.mp ht).2
  rw [det_complement_card_three t hcard]
  rw [principalHolonomy_compl t hcard]
  ring

/-- Structural collection of the diagonal expansion by the number of deleted
axes. -/
theorem sum_complementary_minors (x : Fin 6 → ℤ) :
    (∑ t : Finset (Fin 6), (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t)) =
      elementarySymmetric 6 x - elementarySymmetric 4 x +
        5 * elementarySymmetric 2 x - 125 - 2 * supportCubic x := by
  rw [← Finset.powerset_univ, Finset.powerset_card_disjiUnion,
    Finset.sum_disjiUnion]
  simp only [Finset.card_univ, Fintype.card_fin, Finset.sum_range_succ]
  have h0 : ∑ t ∈ Finset.univ.powersetCard 0, (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) = -125 := by
    simp [det_complement_card_zero]
  have h1 : ∑ t ∈ Finset.univ.powersetCard 1, (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) = 0 := by
    apply Finset.sum_eq_zero
    intro t ht
    rw [det_complement_card_one t (Finset.mem_powersetCard.mp ht).2]
    simp
  have h2 : ∑ t ∈ Finset.univ.powersetCard 2, (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) = 5 * elementarySymmetric 2 x := by
    rw [elementarySymmetric]
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro t ht
    rw [det_complement_card_two t (Finset.mem_powersetCard.mp ht).2]
    ring
  have h3 := sum_card_three_complementary_minors x
  have h4 : ∑ t ∈ Finset.univ.powersetCard 4, (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) = -elementarySymmetric 4 x := by
    rw [elementarySymmetric]
    calc
      _ = ∑ t ∈ Finset.univ.powersetCard 4, -(∏ i ∈ t, x i) := by
        apply Finset.sum_congr rfl
        intro t ht
        rw [det_complement_card_four t (Finset.mem_powersetCard.mp ht).2]
        ring
      _ = -∑ t ∈ Finset.univ.powersetCard 4, ∏ i ∈ t, x i := by
        simp
  have h5 : ∑ t ∈ Finset.univ.powersetCard 5, (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) = 0 := by
    apply Finset.sum_eq_zero
    intro t ht
    rw [det_complement_card_five t (Finset.mem_powersetCard.mp ht).2]
    simp
  have h6 : ∑ t ∈ Finset.univ.powersetCard 6, (∏ i ∈ t, x i) *
      Matrix.det (complementPrincipalBlock t) = elementarySymmetric 6 x := by
    rw [elementarySymmetric]
    apply Finset.sum_congr rfl
    intro t ht
    rw [det_complement_card_six t (Finset.mem_powersetCard.mp ht).2]
    ring
  rw [h0, h1, h2, h3, h4, h5, h6]
  ring

/-- Full multilinear diagonal expansion of the determinant pencil. -/
theorem det_signedOrbital_add_diagonal (x : Fin 6 → ℤ) :
    determinantPencil x =
      elementarySymmetric 6 x - elementarySymmetric 4 x +
        5 * elementarySymmetric 2 x - 125 - 2 * supportCubic x := by
  classical
  rw [determinantPencil, det_add_diagonal_eq_sum_principalMinors]
  rw [sum_principal_eq_sum_complement, sum_complementary_minors]

/-- Homogeneous odd part of the determinant pencil.  Written without division,
so the identity remains integral. -/
theorem determinantPencil_oddPart_eq_supportCubic (x : Fin 6 → ℤ) :
    determinantPencil x - determinantPencil (-x) = -4 * supportCubic x := by
  rw [det_signedOrbital_add_diagonal, det_signedOrbital_add_diagonal]
  rw [elementarySymmetric_neg, elementarySymmetric_neg,
    elementarySymmetric_neg, supportCubic_neg]
  norm_num
  ring

#print axioms det_signed_three
#print axioms det_principal_three
#print axioms det_principalMinorFive
#print axioms det_principalMinorFour
#print axioms det_signedOrbitalMatrix
#print axioms det_signedOrbital_add_diagonal
#print axioms determinantPencil_oddPart_eq_supportCubic

end RelativeConicArcs.PaperIOrientationDeterminant
