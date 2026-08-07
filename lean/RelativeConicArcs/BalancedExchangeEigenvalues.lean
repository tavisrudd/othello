import Mathlib.Analysis.Matrix.Spectrum
import RelativeConicArcs.BalancedExchangeSpectrum

/-!
# Eigenvalues and spectral isometries of the exchange operator

The exchange operator of a balanced cut is treated in
`RelativeConicArcs.BalancedExchangeSpectrum` by characteristic polynomials and
traces alone, over an arbitrary field of characteristic zero and relative to a
supplied isometry onto the fixed space of the normalized matrix.  This module
supplies the two statements that leave that setting, both over the real
numbers.

The first is the eigenvalue reading of the characteristic polynomial: for a real
symmetric `A` the characteristic polynomial of `1 - q⁻¹ • (A * A)` is
`∏ (X - (1 - αᵢ²/q))` over the eigenvalues `αᵢ` of `A`, so the exchange spectrum
of a balanced cut is `{1 - αᵢ²/q}` for `A` the principal block on the chosen
half.

The second removes the isometry hypothesis.  A real symmetric matrix `Q` with
`Q * Q = 1` has an orthonormal eigenbasis with eigenvalues `±1`; collecting the
eigenvectors of eigenvalue `1` gives a matrix `U` with `Uᵀ * U = 1` and
`U * Uᵀ = (1 + Q)/2`, and collecting those of eigenvalue `-1` gives the same for
`(1 - Q)/2`.  When the trace of `Q` vanishes the two eigenspaces have equal
dimension, so for a label set split into two halves of equal size the isometries
can be indexed by the halves themselves, which is the form the cut theorems
consume.  A vanishing diagonal makes that trace zero, so for a real symmetric
matrix with zero diagonal whose square is `q • 1` and whose halves have the same
size, both isometries exist; the closing statements combine that with the
characteristic-polynomial, moment and order-six results of
`RelativeConicArcs.BalancedExchangeSpectrum` and are therefore conditional on
nothing.
-/

namespace RelativeConicArcs.BalancedExchangeEigenvalues

open Matrix Polynomial RelativeConicArcs.BalancedExchangeSpectrum

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

section Conjugation

/-- Conjugating by a unitary matrix leaves the characteristic polynomial
unchanged. -/
private theorem charpoly_unitary_conj (V : Matrix.unitaryGroup ι ℝ) (M : Matrix ι ι ℝ) :
    ((V : Matrix ι ι ℝ) * M * star (V : Matrix ι ι ℝ)).charpoly = M.charpoly := by
  rw [Matrix.charpoly_mul_comm, ← Matrix.mul_assoc,
    Unitary.star_mul_self_of_mem V.2, Matrix.one_mul]

end Conjugation

/-- The characteristic polynomial of the exchange normalization of a real
symmetric block, read through the eigenvalues of the block: its roots are
`1 - αᵢ²/q`, one for each eigenvalue `αᵢ` of `A`.  Combined with the identity of
`RelativeConicArcs.BalancedExchangeSpectrum` between the characteristic
polynomial of the exchange operator of a balanced cut and that of
`1 - q⁻¹ • (A * A)`, this is the manuscript's spectral formula. -/
theorem charpoly_one_sub_smul_mul_self_eq_prod (A : Matrix ι ι ℝ) (hA : A.IsHermitian)
    (q : ℝ) :
    ((1 : Matrix ι ι ℝ) - q⁻¹ • (A * A)).charpoly
      = ∏ i, (X - C (1 - q⁻¹ * hA.eigenvalues i ^ 2)) := by
  set V : Matrix.unitaryGroup ι ℝ := hA.eigenvectorUnitary with hVdef
  set Dg : Matrix ι ι ℝ := diagonal (RCLike.ofReal ∘ hA.eigenvalues) with hDdef
  have hVV : (V : Matrix ι ι ℝ) * star (V : Matrix ι ι ℝ) = 1 :=
    Unitary.mul_star_self_of_mem V.2
  have hspec : A = (V : Matrix ι ι ℝ) * Dg * star (V : Matrix ι ι ℝ) := by
    conv_lhs => rw [hA.spectral_theorem]
    rw [Unitary.conjStarAlgAut_apply]
  have hAA : A * A = (V : Matrix ι ι ℝ) * (Dg * Dg) * star (V : Matrix ι ι ℝ) := by
    conv_lhs => rw [hspec]
    simp only [Matrix.mul_assoc]
    rw [← Matrix.mul_assoc (star (V : Matrix ι ι ℝ)) (V : Matrix ι ι ℝ) (Dg * _),
      Unitary.star_mul_self_of_mem V.2, Matrix.one_mul]
  have hM : (1 : Matrix ι ι ℝ) - q⁻¹ • (A * A)
      = (V : Matrix ι ι ℝ) * (1 - q⁻¹ • (Dg * Dg)) * star (V : Matrix ι ι ℝ) := by
    rw [hAA, Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_one, hVV, Matrix.mul_smul,
      Matrix.smul_mul]
  have hdiag : (1 : Matrix ι ι ℝ) - q⁻¹ • (Dg * Dg)
      = diagonal fun i => 1 - q⁻¹ * hA.eigenvalues i ^ 2 := by
    ext i j
    by_cases hij : i = j
    · subst hij
      simp [hDdef, Matrix.diagonal_mul_diagonal, Matrix.sub_apply, Matrix.smul_apply,
        Matrix.one_apply_eq, Matrix.diagonal_apply_eq, RCLike.ofReal_real_eq_id, sq]
    · simp [hDdef, Matrix.diagonal_mul_diagonal, Matrix.sub_apply, Matrix.smul_apply,
        Matrix.one_apply_ne hij, Matrix.diagonal_apply_ne _ hij]
  rw [hM, charpoly_unitary_conj, hdiag, Matrix.charpoly_diagonal]

section Isometries

omit [Fintype ι] [DecidableEq ι] in
/-- Over the reals the star of a matrix is its transpose. -/
private theorem star_eq_transpose (M : Matrix ι ι ℝ) : star M = Mᵀ := by
  ext i j
  simp

omit [Fintype ι] [DecidableEq ι] in
/-- Over the reals a Hermitian matrix is a symmetric one. -/
private theorem transpose_of_isHermitian {M : Matrix ι ι ℝ} (hM : M.IsHermitian) : Mᵀ = M := by
  have hct : Mᴴ = Mᵀ := by
    ext i j
    simp
  rw [← hct]
  exact hM

/-- Conjugation by a unitary matrix is injective. -/
private theorem eq_of_unitary_conj (V : Matrix.unitaryGroup ι ℝ) {M N : Matrix ι ι ℝ}
    (h : (V : Matrix ι ι ℝ) * M * star (V : Matrix ι ι ℝ)
      = (V : Matrix ι ι ℝ) * N * star (V : Matrix ι ι ℝ)) : M = N := by
  have hVs : star (V : Matrix ι ι ℝ) * (V : Matrix ι ι ℝ) = 1 :=
    Unitary.star_mul_self_of_mem V.2
  have hsV : (V : Matrix ι ι ℝ) * star (V : Matrix ι ι ℝ) = 1 :=
    Unitary.mul_star_self_of_mem V.2
  have key : ∀ X : Matrix ι ι ℝ,
      star (V : Matrix ι ι ℝ) * ((V : Matrix ι ι ℝ) * X * star (V : Matrix ι ι ℝ))
        * (V : Matrix ι ι ℝ) = X := by
    intro X
    calc star (V : Matrix ι ι ℝ) * ((V : Matrix ι ι ℝ) * X * star (V : Matrix ι ι ℝ))
          * (V : Matrix ι ι ℝ)
        = (star (V : Matrix ι ι ℝ) * (V : Matrix ι ι ℝ)) * X
            * (star (V : Matrix ι ι ℝ) * (V : Matrix ι ι ℝ)) := by
          simp only [Matrix.mul_assoc]
      _ = X := by rw [hVs, Matrix.one_mul, Matrix.mul_one]
  rw [← key M, h, key N]

/-- An isometry onto the fixed space of a real symmetric involution exists on any
index type of half the size of the label set.  The eigenvalues of such an
involution are `±1`; a vanishing trace makes the two eigenspaces equally large,
and the eigenvectors of eigenvalue one, transported along a bijection, are the
columns of the isometry. -/
theorem exists_isometry_fixedProjection {κ : Type*} [Fintype κ] [DecidableEq κ]
    (Q : Matrix ι ι ℝ) (hQt : Qᵀ = Q) (hQ : Q * Q = 1) (htr : Matrix.trace Q = 0)
    (hcard : Fintype.card ι = 2 * Fintype.card κ) :
    ∃ U : Matrix ι κ ℝ, Uᵀ * U = 1 ∧ U * Uᵀ = fixedProjection Q := by
  classical
  have hct : Qᴴ = Qᵀ := by
    ext i j
    simp [Matrix.conjTranspose_apply, Matrix.transpose_apply]
  have hQh : Q.IsHermitian := by
    show Qᴴ = Q
    rw [hct, hQt]
  set V : Matrix.unitaryGroup ι ℝ := hQh.eigenvectorUnitary with hVdef
  set μ : ι → ℝ := hQh.eigenvalues with hμdef
  have hstar : star (V : Matrix ι ι ℝ) = (V : Matrix ι ι ℝ)ᵀ := star_eq_transpose _
  have hVs : star (V : Matrix ι ι ℝ) * (V : Matrix ι ι ℝ) = 1 :=
    Unitary.star_mul_self_of_mem V.2
  have hsV : (V : Matrix ι ι ℝ) * star (V : Matrix ι ι ℝ) = 1 :=
    Unitary.mul_star_self_of_mem V.2
  have hcast : (RCLike.ofReal ∘ μ) = μ := by
    funext i
    simp [RCLike.ofReal_real_eq_id]
  have hspec : Q = (V : Matrix ι ι ℝ) * diagonal μ * star (V : Matrix ι ι ℝ) := by
    conv_lhs => rw [hQh.spectral_theorem]
    rw [Unitary.conjStarAlgAut_apply, hcast]
  -- the eigenvalues of an involution are `±1`
  have hDD : diagonal μ * diagonal μ = (1 : Matrix ι ι ℝ) := by
    refine eq_of_unitary_conj V ?_
    rw [show (V : Matrix ι ι ℝ) * (diagonal μ * diagonal μ) * star (V : Matrix ι ι ℝ)
        = ((V : Matrix ι ι ℝ) * diagonal μ * star (V : Matrix ι ι ℝ))
          * ((V : Matrix ι ι ℝ) * diagonal μ * star (V : Matrix ι ι ℝ)) by
      simp only [Matrix.mul_assoc]
      rw [← Matrix.mul_assoc (star (V : Matrix ι ι ℝ)) (V : Matrix ι ι ℝ) (diagonal μ * _),
        hVs, Matrix.one_mul], ← hspec, hQ, Matrix.mul_one, hsV]
  have hμ : ∀ i, μ i * μ i = 1 := by
    intro i
    have h := congrFun (congrFun hDD i) i
    rwa [Matrix.diagonal_mul_diagonal, Matrix.diagonal_apply_eq, Matrix.one_apply_eq] at h
  have hμcases : ∀ i, μ i = 1 ∨ μ i = -1 := by
    intro i
    have h := hμ i
    have : (μ i - 1) * (μ i + 1) = 0 := by linear_combination h
    rcases mul_eq_zero.mp this with h' | h'
    · exact Or.inl (by linear_combination h')
    · exact Or.inr (by linear_combination h')
  -- the two eigenspaces are equally large
  set S : Finset ι := Finset.univ.filter fun i => μ i = 1 with hSdef
  set T : Finset ι := Finset.univ.filter fun i => ¬ μ i = 1 with hTdef
  have hsum : ∑ i, μ i = 0 := by
    have htrd : Matrix.trace (diagonal μ) = Matrix.trace Q := by
      rw [hspec, Matrix.trace_mul_comm, ← Matrix.mul_assoc, hVs, Matrix.one_mul]
    rw [Matrix.trace_diagonal] at htrd
    rw [htrd, htr]
  have hmem₁ : ∀ i ∈ S, μ i = 1 := by
    intro i hi
    rw [hSdef] at hi
    exact (Finset.mem_filter.mp hi).2
  have hmem₂ : ∀ i ∈ T, μ i = -1 := by
    intro i hi
    rw [hTdef] at hi
    exact (hμcases i).resolve_left (Finset.mem_filter.mp hi).2
  have hsplit : ∑ i, μ i = (S.card : ℝ) - (T.card : ℝ) := by
    rw [← Finset.sum_filter_add_sum_filter_not Finset.univ (fun i => μ i = 1) μ, ← hSdef,
      ← hTdef, Finset.sum_congr rfl hmem₁, Finset.sum_congr rfl hmem₂, Finset.sum_const,
      Finset.sum_const, nsmul_eq_mul, nsmul_eq_mul, mul_one, mul_neg, mul_one]
    ring
  have hcards : S.card + T.card = Fintype.card ι := by
    rw [hSdef, hTdef, Finset.card_filter_add_card_filter_not, Finset.card_univ]
  have hcardS : S.card = Fintype.card κ := by
    have hreal : (S.card : ℝ) = (T.card : ℝ) := by
      have h := hsplit.symm.trans hsum
      linarith
    have hnat : S.card = T.card := by exact_mod_cast hreal
    omega
  -- the isometry
  obtain ⟨e⟩ : Nonempty (κ ≃ {x // x ∈ S}) :=
    ⟨Fintype.equivOfCardEq (by rw [Fintype.card_coe, hcardS])⟩
  refine ⟨(V : Matrix ι ι ℝ).submatrix id fun a => ((e a : {x // x ∈ S}) : ι), ?_, ?_⟩
  · ext a b
    have hVtV : (V : Matrix ι ι ℝ)ᵀ * (V : Matrix ι ι ℝ) = 1 := by rw [← hstar]; exact hVs
    have hentry : ((((V : Matrix ι ι ℝ).submatrix id fun a => ((e a : {x // x ∈ S}) : ι))ᵀ
        * ((V : Matrix ι ι ℝ).submatrix id fun a => ((e a : {x // x ∈ S}) : ι))) a b)
        = ((V : Matrix ι ι ℝ)ᵀ * (V : Matrix ι ι ℝ)) ((e a : {x // x ∈ S}) : ι)
            ((e b : {x // x ∈ S}) : ι) := by
      simp [Matrix.mul_apply, Matrix.submatrix_apply, Matrix.transpose_apply]
    rw [hentry, hVtV, Matrix.one_apply, Matrix.one_apply]
    by_cases hab : a = b
    · simp [hab]
    · have hne : ((e a : {x // x ∈ S}) : ι) ≠ ((e b : {x // x ∈ S}) : ι) := fun h =>
        hab (e.injective (Subtype.ext h))
      simp [hne, hab]
  · have hind : fixedProjection Q
        = (V : Matrix ι ι ℝ) * diagonal (fun i => if μ i = 1 then (1 : ℝ) else 0)
            * (V : Matrix ι ι ℝ)ᵀ := by
      have hdiagform : (2 : ℝ)⁻¹ • ((1 : Matrix ι ι ℝ) + diagonal μ)
          = diagonal fun i => if μ i = 1 then (1 : ℝ) else 0 := by
        ext i j
        by_cases hij : i = j
        · subst hij
          rcases hμcases i with h | h <;>
            simp [Matrix.smul_apply, Matrix.add_apply, Matrix.one_apply_eq,
              Matrix.diagonal_apply_eq, h] <;> norm_num
        · simp [Matrix.smul_apply, Matrix.add_apply, Matrix.one_apply_ne hij,
            Matrix.diagonal_apply_ne _ hij]
      rw [fixedProjection, hspec, hstar, ← hdiagform, Matrix.mul_smul, Matrix.smul_mul,
        Matrix.mul_add, Matrix.add_mul, Matrix.mul_one, ← hstar, hsV]
    ext i j
    rw [hind]
    have hrhs : ((V : Matrix ι ι ℝ) * diagonal (fun i => if μ i = 1 then (1 : ℝ) else 0)
        * (V : Matrix ι ι ℝ)ᵀ) i j
        = ∑ k ∈ S, (V : Matrix ι ι ℝ) i k * (V : Matrix ι ι ℝ) j k := by
      rw [Matrix.mul_apply]
      simp only [Matrix.mul_diagonal, Matrix.transpose_apply]
      rw [hSdef, Finset.sum_filter]
      exact Finset.sum_congr rfl fun k _ => by by_cases h : μ k = 1 <;> simp [h]
    have hlhs : (((V : Matrix ι ι ℝ).submatrix id fun a => ((e a : {x // x ∈ S}) : ι))
        * ((V : Matrix ι ι ℝ).submatrix id fun a => ((e a : {x // x ∈ S}) : ι))ᵀ) i j
        = ∑ k ∈ S, (V : Matrix ι ι ℝ) i k * (V : Matrix ι ι ℝ) j k := by
      rw [Matrix.mul_apply]
      simp only [Matrix.submatrix_apply, Matrix.transpose_apply, id_eq]
      rw [← Finset.sum_coe_sort S fun k =>
        (V : Matrix ι ι ℝ) i k * (V : Matrix ι ι ℝ) j k]
      exact Equiv.sum_comp e fun s : {x // x ∈ S} =>
        (V : Matrix ι ι ℝ) i (s : ι) * (V : Matrix ι ι ℝ) j (s : ι)
    rw [hlhs, hrhs]

/-- An isometry onto the antifixed space exists under the same hypotheses: it is
an isometry onto the fixed space of the negated involution. -/
theorem exists_isometry_antifixedProjection {κ : Type*} [Fintype κ] [DecidableEq κ]
    (Q : Matrix ι ι ℝ) (hQt : Qᵀ = Q) (hQ : Q * Q = 1) (htr : Matrix.trace Q = 0)
    (hcard : Fintype.card ι = 2 * Fintype.card κ) :
    ∃ W : Matrix ι κ ℝ, Wᵀ * W = 1 ∧ W * Wᵀ = antifixedProjection Q := by
  obtain ⟨W, hW, hWW⟩ := exists_isometry_fixedProjection (κ := κ) (-Q)
    (by rw [Matrix.transpose_neg, hQt]) (by rw [Matrix.neg_mul, Matrix.mul_neg, neg_neg, hQ])
    (by rw [Matrix.trace_neg, htr, neg_zero]) hcard
  refine ⟨W, hW, ?_⟩
  rw [hWW, fixedProjection, antifixedProjection, ← sub_eq_add_neg]

end Isometries

section Cut

variable {n m : Type*} [Fintype n] [DecidableEq n] [Fintype m] [DecidableEq m]

/-- Both spectral isometries of a balanced cut exist, for a real symmetric
matrix with zero diagonal whose square is `q • 1` and whose two halves have the
same size.  The vanishing diagonal is what makes the trace of the normalized
matrix zero, hence its two eigenspaces equally large. -/
theorem exists_isometries_cut {A : Matrix n n ℝ} {B : Matrix n m ℝ} {E : Matrix m m ℝ}
    {q s : ℝ} (hAt : Aᵀ = A) (hEt : Eᵀ = E)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0) (hdA : ∀ i, A i i = 0) (hdE : ∀ i, E i i = 0)
    (hcard : Fintype.card n = Fintype.card m) :
    (∃ U : Matrix (n ⊕ m) n ℝ, Uᵀ * U = 1
        ∧ U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E))
      ∧ ∃ W : Matrix (n ⊕ m) m ℝ, Wᵀ * W = 1
        ∧ W * Wᵀ = antifixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) := by
  have hq : q ≠ 0 := by rw [← hs]; exact mul_ne_zero hs0 hs0
  set C := Matrix.fromBlocks A B Bᵀ E with hC
  set Q := s⁻¹ • C with hQdef
  have hQt : Qᵀ = Q := by
    rw [hQdef, Matrix.transpose_smul, hC, Matrix.fromBlocks_transpose, hAt, hEt,
      Matrix.transpose_transpose]
  have hQ : Q * Q = 1 := by
    rw [hQdef, Matrix.smul_mul, Matrix.mul_smul, smul_smul, hC, hCC, smul_smul,
      show s⁻¹ * s⁻¹ * q = 1 by rw [← mul_inv, hs, inv_mul_cancel₀ hq], one_smul]
  have htrC : Matrix.trace C = 0 := by
    rw [hC]
    simp [Matrix.trace, Matrix.diag_apply, Fintype.sum_sum_type, hdA, hdE]
  have htr : Matrix.trace Q = 0 := by
    rw [hQdef, Matrix.trace_smul, htrC, smul_zero]
  have hcardn : Fintype.card (n ⊕ m) = 2 * Fintype.card n := by
    rw [Fintype.card_sum, ← hcard]
    ring
  have hcardm : Fintype.card (n ⊕ m) = 2 * Fintype.card m := by
    rw [Fintype.card_sum, hcard]
    ring
  exact ⟨exists_isometry_fixedProjection Q hQt hQ htr hcardn,
    exists_isometry_antifixedProjection Q hQt hQ htr hcardm⟩

/-- The exchange spectrum of a balanced cut, unconditionally.  For a real
symmetric matrix with zero diagonal whose square is `q • 1`, split into two
halves of the same size, an isometry onto the fixed space of the normalized
matrix exists, and the characteristic polynomial of the exchange operator it
defines is `∏ (X - (1 - αᵢ²/q))` over the eigenvalues `αᵢ` of the principal
block on the chosen half. -/
theorem exists_isometry_charpoly_exchangeCompression_cut {A : Matrix n n ℝ} {B : Matrix n m ℝ}
    {E : Matrix m m ℝ} {q s : ℝ} (hA : A.IsHermitian) (hE : E.IsHermitian)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0) (hdA : ∀ i, A i i = 0) (hdE : ∀ i, E i i = 0)
    (hcard : Fintype.card n = Fintype.card m) :
    ∃ U : Matrix (n ⊕ m) n ℝ, Uᵀ * U = 1
      ∧ U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E)
      ∧ (exchangeCompression (cutInvolution n m ℝ) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U).charpoly
          = ∏ i, (X - C (1 - q⁻¹ * hA.eigenvalues i ^ 2)) := by
  have hAt : Aᵀ = A := transpose_of_isHermitian hA
  have hEt : Eᵀ = E := transpose_of_isHermitian hE
  obtain ⟨⟨U, hU, hUU⟩, ⟨W, hW, hWW⟩⟩ :=
    exists_isometries_cut hAt hEt hCC hs hs0 hdA hdE hcard
  refine ⟨U, hU, hUU, ?_⟩
  rw [charpoly_exchangeCompression_cut hAt hEt hCC hs hs0 hU hUU hW hWW hcard,
    charpoly_one_sub_smul_mul_self_eq_prod A hA q]

/-- The second exchange moment of a balanced cut, unconditionally: an isometry
onto the fixed space exists, and the trace of the square of the exchange
operator it defines is
`(d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c)/q²` for `d` the size
of the half and `c` the number of its aligned four-sets. -/
theorem exists_isometry_trace_pow_two_exchangeCompression_cut {A : Matrix n n ℝ}
    {B : Matrix n m ℝ} {E : Matrix m m ℝ} {q s : ℝ} (hA : A.IsHermitian) (hE : E.IsHermitian)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0) (hdA : ∀ i, A i i = 0) (hdE : ∀ i, E i i = 0)
    (hsym : ∀ i j, A j i = A i j) (hsq : ∀ i j, i ≠ j → A i j * A i j = 1)
    (hcard : Fintype.card n = Fintype.card m) :
    ∃ U : Matrix (n ⊕ m) n ℝ, Uᵀ * U = 1
      ∧ U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E)
      ∧ Matrix.trace (exchangeCompression (cutInvolution n m ℝ)
            (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U ^ 2)
          = ((Fintype.card n : ℝ) * q ^ 2
              - 2 * q * ((Fintype.card n : ℝ) * ((Fintype.card n : ℝ) - 1))
              + ((Fintype.card n : ℝ) * ((Fintype.card n : ℝ) - 1)
                + 12 * ((Fintype.card n).choose 3 : ℝ)
                - 8 * ((Fintype.card n).choose 4 : ℝ)
                + 32 * (alignedFourSetCount A Finset.univ : ℝ))) / q ^ 2 := by
  have hAt : Aᵀ = A := transpose_of_isHermitian hA
  have hEt : Eᵀ = E := transpose_of_isHermitian hE
  obtain ⟨⟨U, hU, hUU⟩, -⟩ := exists_isometries_cut hAt hEt hCC hs hs0 hdA hdE hcard
  exact ⟨U, hU, hUU,
    trace_pow_two_exchangeCompression_cut hAt hEt hCC hs hs0 hU hUU hdA hsym hsq⟩

/-- At order six the exchange operator of a balanced cut has characteristic
polynomial `(X - 1/5)(X - 4/5)²`, unconditionally and whatever the cut. -/
theorem exists_isometry_charpoly_exchangeCompression_cut_card_three {A : Matrix n n ℝ}
    {B : Matrix n m ℝ} {E : Matrix m m ℝ} {s : ℝ} (hA : A.IsHermitian) (hE : E.IsHermitian)
    (hCC : Matrix.fromBlocks A B Bᵀ E * Matrix.fromBlocks A B Bᵀ E = (5 : ℝ) • 1)
    (hs : s * s = (5 : ℝ)) (hs0 : s ≠ 0) (hdA : ∀ i, A i i = 0) (hdE : ∀ i, E i i = 0)
    (hsym : ∀ i j, A j i = A i j) (hsq : ∀ i j, i ≠ j → A i j * A i j = 1)
    (hn : Fintype.card n = 3) (hm : Fintype.card m = 3) :
    ∃ U : Matrix (n ⊕ m) n ℝ, Uᵀ * U = 1
      ∧ U * Uᵀ = fixedProjection (s⁻¹ • Matrix.fromBlocks A B Bᵀ E)
      ∧ (exchangeCompression (cutInvolution n m ℝ) (s⁻¹ • Matrix.fromBlocks A B Bᵀ E) U).charpoly
          = (X - C ((5 : ℝ)⁻¹)) * (X - C (4 * (5 : ℝ)⁻¹)) ^ 2 := by
  have hAt : Aᵀ = A := transpose_of_isHermitian hA
  have hEt : Eᵀ = E := transpose_of_isHermitian hE
  obtain ⟨⟨U, hU, hUU⟩, ⟨W, hW, hWW⟩⟩ :=
    exists_isometries_cut hAt hEt hCC hs hs0 hdA hdE (by rw [hn, hm])
  exact ⟨U, hU, hUU, charpoly_exchangeCompression_cut_card_three hAt hEt hCC hs hs0 hU hUU
    hW hWW hdA hsym hsq hn hm⟩

end Cut

end RelativeConicArcs.BalancedExchangeEigenvalues
