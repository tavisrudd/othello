import RelativeConicArcs.BalancedExchangeEigenvalues
import RelativeConicArcs.BalancedExchangeRigidity

/-!
# The balanced cut determined by a half of the label set

`RelativeConicArcs.BalancedExchangeSpectrum` and
`RelativeConicArcs.BalancedExchangeEigenvalues` treat the exchange operator of a
balanced cut for a matrix already presented in cut coordinates, that is as
`Matrix.fromBlocks A B Bᵀ E` on a sum type.  The cut-dependence statement of
`RelativeConicArcs.BalancedExchangeRigidity` is instead about a symmetric matrix
`C` on a single label set and a subset `Y` of that set.  This module connects
the two presentations.

Relabelling `C` along `Equiv.sumCompl (· ∈ Y)` lists the labels of `Y` first and
so puts `C` in cut coordinates: the upper-left block is the submatrix of `C` on
`Y`, the upper-right block is the submatrix from `Y` to its complement, and
symmetry of `C` makes the lower-left block the transpose of that cross block.
Two invariants of the upper-left block are then read on `Y` itself:

* its fourth trace is the fourfold sum over `Y` of the closed four-walk weights
  `C i j * C j k * C k l * C l i`, the quantity whose dependence on `Y` is
  settled in `RelativeConicArcs.BalancedExchangeRigidity`; and
* its aligned four-sets — the four-subsets of Hamilton-cycle weight `3` — are
  the images of the aligned four-subsets of `Y` under the inclusion of `Y` into
  the label set, so the two counts agree.

Over the real numbers the spectral isometries of a balanced cut exist, so the
second exchange moment of the cut at a half is unconditionally
`(d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c)/q²`, with `d` the
size of the half and `c` its number of aligned four-subsets.  For a symmetric
matrix with zero diagonal and entries squaring to one on `2d` labels with
`4 ≤ d` whose square is `q • 1`, no real number is that second moment for every
balanced half.

Throughout, a *half* is a subset `Y` of the labels with `Fintype.card n = 2 * Y.card`,
and the two index types of the cut are the subtypes `{x // x ∈ Y}` and
`{x // x ∉ Y}`.
-/

namespace RelativeConicArcs.BalancedExchangeHalfCut

open Finset Matrix RelativeConicArcs.BalancedExchangeSpectrum

section Blocks

variable {R : Type*} [CommRing R] {n : Type*} [Fintype n] [DecidableEq n]

/-- The principal block of `C` on a subset `Y` of the labels: the submatrix
indexed by the elements of `Y`. -/
def principalBlock (C : Matrix n n R) (Y : Finset n) :
    Matrix {x // x ∈ Y} {x // x ∈ Y} R :=
  C.submatrix Subtype.val Subtype.val

/-- The cross block of `C` at a subset `Y` of the labels: the rectangular
submatrix with rows indexed by `Y` and columns by its complement. -/
def crossBlock (C : Matrix n n R) (Y : Finset n) :
    Matrix {x // x ∈ Y} {x // x ∉ Y} R :=
  C.submatrix Subtype.val Subtype.val

/-- The principal block of `C` on the complement of a subset `Y` of the
labels. -/
def complementBlock (C : Matrix n n R) (Y : Finset n) :
    Matrix {x // x ∉ Y} {x // x ∉ Y} R :=
  C.submatrix Subtype.val Subtype.val

/-- The matrix `C` in the cut coordinates determined by a subset `Y` of the
labels, written in blocks.  For symmetric `C` this is exactly the relabelling of
`C` along `Equiv.sumCompl (· ∈ Y)`, as `cutMatrix_eq_submatrix` records. -/
def cutMatrix (C : Matrix n n R) (Y : Finset n) :
    Matrix ({x // x ∈ Y} ⊕ {x // x ∉ Y}) ({x // x ∈ Y} ⊕ {x // x ∉ Y}) R :=
  Matrix.fromBlocks (principalBlock C Y) (crossBlock C Y) (crossBlock C Y)ᵀ
    (complementBlock C Y)

omit [CommRing R] [Fintype n] [DecidableEq n] in
/-- The principal block is the submatrix along the inclusion of `Y` read as a
bundled injection, the form the four-subset transport uses. -/
theorem principalBlock_eq_submatrix_embedding (C : Matrix n n R) (Y : Finset n) :
    principalBlock C Y
      = C.submatrix (Function.Embedding.subtype (· ∈ Y)) (Function.Embedding.subtype (· ∈ Y)) :=
  rfl

omit [CommRing R] [Fintype n] in
/-- For a symmetric matrix the block form of the cut is the relabelling along
`Equiv.sumCompl`, which lists the labels of `Y` before those of its
complement. -/
theorem cutMatrix_eq_submatrix (C : Matrix n n R) (hsym : ∀ i j, C j i = C i j) (Y : Finset n) :
    cutMatrix C Y
      = C.submatrix (Equiv.sumCompl (· ∈ Y)) (Equiv.sumCompl (· ∈ Y)) := by
  ext i j
  match i, j with
  | Sum.inl i, Sum.inl j => rfl
  | Sum.inl i, Sum.inr j => rfl
  | Sum.inr i, Sum.inl j => exact hsym (i : n) (j : n)
  | Sum.inr i, Sum.inr j => rfl

/-- A symmetric matrix whose square is the scalar `q` has the same square in the
cut coordinates of any subset of the labels: relabelling along an equivalence is
a ring map on matrices. -/
theorem cutMatrix_mul_self (C : Matrix n n R) (hsym : ∀ i j, C j i = C i j) (Y : Finset n)
    {q : R} (hCC : C * C = q • 1) :
    cutMatrix C Y * cutMatrix C Y = q • 1 := by
  rw [cutMatrix_eq_submatrix C hsym Y, Matrix.submatrix_mul_equiv, hCC]
  ext i j
  simp [Matrix.submatrix_apply, Matrix.one_apply]

omit [CommRing R] [Fintype n] [DecidableEq n] in
/-- The principal block of a symmetric matrix is symmetric. -/
theorem principalBlock_transpose (C : Matrix n n R) (hsym : ∀ i j, C j i = C i j)
    (Y : Finset n) : (principalBlock C Y)ᵀ = principalBlock C Y := by
  ext i j
  exact hsym (i : n) (j : n)

omit [CommRing R] [Fintype n] [DecidableEq n] in
/-- The principal block on the complement of a symmetric matrix is symmetric. -/
theorem complementBlock_transpose (C : Matrix n n R) (hsym : ∀ i j, C j i = C i j)
    (Y : Finset n) : (complementBlock C Y)ᵀ = complementBlock C Y := by
  ext i j
  exact hsym (i : n) (j : n)

/-- The complement of a half has as many labels as the half. -/
theorem card_compl_of_card_eq_two_mul {Y : Finset n} (hcard : Fintype.card n = 2 * Y.card) :
    Fintype.card {x // x ∉ Y} = Y.card := by
  rw [Fintype.card_subtype_compl, Fintype.card_coe, hcard]
  omega

end Blocks

section FourthTrace

variable {R : Type*} [CommRing R] {n : Type*} [Fintype n] [DecidableEq n]

omit [Fintype n] [DecidableEq n] in
private theorem sum_subtype_mem {M : Type*} [AddCommMonoid M] (Y : Finset n) (g : n → M) :
    ∑ i : {x // x ∈ Y}, g (i : n) = ∑ i ∈ Y, g i :=
  (Finset.sum_subtype Y (fun _ => Iff.rfl) g).symm

omit [Fintype n] [DecidableEq n] in
private theorem sum_subtype_mem_four {M : Type*} [AddCommMonoid M] (Y : Finset n)
    (g : n → n → n → n → M) :
    ∑ i : {x // x ∈ Y}, ∑ j : {x // x ∈ Y}, ∑ k : {x // x ∈ Y}, ∑ l : {x // x ∈ Y},
        g (i : n) (j : n) (k : n) (l : n)
      = ∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, g i j k l := by
  rw [sum_subtype_mem Y fun i =>
    ∑ j : {x // x ∈ Y}, ∑ k : {x // x ∈ Y}, ∑ l : {x // x ∈ Y}, g i (j : n) (k : n) (l : n)]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [sum_subtype_mem Y fun j => ∑ k : {x // x ∈ Y}, ∑ l : {x // x ∈ Y}, g i j (k : n) (l : n)]
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [sum_subtype_mem Y fun k => ∑ l : {x // x ∈ Y}, g i j k (l : n)]
  refine Finset.sum_congr rfl fun k _ => ?_
  exact sum_subtype_mem Y fun l => g i j k l

omit [Fintype n] [DecidableEq n] in
/-- The fourth trace of the principal block on a subset `Y` of the labels is the
fourfold sum over `Y` of the closed four-walk weights of `C`. -/
theorem trace_pow_four_principalBlock (C : Matrix n n R) (Y : Finset n) :
    Matrix.trace (principalBlock C Y * principalBlock C Y * principalBlock C Y
        * principalBlock C Y)
      = ∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, C i j * C j k * C k l * C l i := by
  have htrace : ∀ A : Matrix {x // x ∈ Y} {x // x ∈ Y} R,
      Matrix.trace (A * A * A * A)
        = ∑ i, ∑ j, ∑ k, ∑ l, A i j * A j k * A k l * A l i := by
    intro A
    simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply, Finset.sum_mul]
    refine Finset.sum_congr rfl fun i _ => ?_
    refine Eq.trans (Finset.sum_congr rfl fun _ _ => Finset.sum_comm) ?_
    refine Eq.trans Finset.sum_comm ?_
    exact Finset.sum_congr rfl fun _ _ => Finset.sum_comm
  rw [htrace]
  simp only [principalBlock, Matrix.submatrix_apply]
  exact sum_subtype_mem_four Y fun i j k l => C i j * C j k * C k l * C l i

end FourthTrace

section AlignedFourSets

variable {R : Type*} [CommRing R] [DecidableEq R] {n : Type*} [Fintype n] [DecidableEq n]

omit [DecidableEq R] [Fintype n] in
/-- The closed four-walk weight of a four-set is unchanged by relabelling along
an injection: the weight of `K` for the submatrix along `f` is the weight of the
image of `K` for the original matrix. -/
theorem closedFourWalkSum_map {n' : Type*} [Fintype n'] [DecidableEq n']
    (C : Matrix n n R) (hsym : ∀ i j, C j i = C i j) (f : n' ↪ n)
    {K : Finset n'} (hK : K.card = 4) :
    ConferenceCutBlocks.closedFourWalkSum (C.submatrix f f) K
      = ConferenceCutBlocks.closedFourWalkSum C (K.map f) := by
  obtain ⟨a, b, c, d, hab, hac, had, hbc, hbd, hcd, rfl⟩ := Finset.card_eq_four.mp hK
  have hsym' : ∀ i j, (C.submatrix f f) j i = (C.submatrix f f) i j := fun i j => hsym _ _
  have hmap : ({a, b, c, d} : Finset n').map f = {f a, f b, f c, f d} := by
    simp
  rw [hmap,
    ConferenceCutBlocks.closedFourWalkSum_labelled (C.submatrix f f) hsym' hab hac had hbc hbd hcd,
    ConferenceCutBlocks.closedFourWalkSum_labelled C hsym (f.injective.ne hab)
      (f.injective.ne hac) (f.injective.ne had) (f.injective.ne hbc) (f.injective.ne hbd)
      (f.injective.ne hcd)]
  simp only [Matrix.submatrix_apply]

omit [Fintype n] in
/-- The aligned four-sets of the principal block on `Y` are the aligned
four-subsets of `Y`: mapping a four-subset of the subtype `{x // x ∈ Y}` to its
image in the label set is a bijection preserving the closed four-walk weight. -/
theorem alignedFourSetCount_principalBlock (C : Matrix n n R) (hsym : ∀ i j, C j i = C i j)
    (Y : Finset n) :
    alignedFourSetCount (principalBlock C Y) Finset.univ = alignedFourSetCount C Y := by
  classical
  have hweight : ∀ K : Finset {x // x ∈ Y}, K.card = 4 →
      ConferenceCutBlocks.closedFourWalkSum (principalBlock C Y) K
        = ConferenceCutBlocks.closedFourWalkSum C (K.map (Function.Embedding.subtype _)) := by
    intro K hK
    rw [principalBlock_eq_submatrix_embedding]
    exact closedFourWalkSum_map C hsym (Function.Embedding.subtype (· ∈ Y)) hK
  refine Finset.card_bij' (fun K _ => K.map (Function.Embedding.subtype _))
    (fun K _ => K.subtype (· ∈ Y)) ?_ ?_ ?_ ?_
  · intro K hK
    obtain ⟨hKmem, hKw⟩ := Finset.mem_filter.mp hK
    have hKcard : K.card = 4 := (Finset.mem_powersetCard.mp hKmem).2
    refine Finset.mem_filter.mpr ⟨Finset.mem_powersetCard.mpr ⟨?_, ?_⟩, ?_⟩
    · intro x hx
      exact Finset.property_of_mem_map_subtype K hx
    · rw [Finset.card_map, hKcard]
    · rw [← hweight K hKcard]
      exact hKw
  · intro K hK
    obtain ⟨hKmem, hKw⟩ := Finset.mem_filter.mp hK
    obtain ⟨hKsub, hKcard⟩ := Finset.mem_powersetCard.mp hKmem
    have hmap : (K.subtype (· ∈ Y)).map (Function.Embedding.subtype _) = K :=
      Finset.subtype_map_of_mem fun x hx => hKsub hx
    have hcard : (K.subtype (· ∈ Y)).card = 4 := by
      rw [← Finset.card_map (Function.Embedding.subtype (· ∈ Y)), hmap, hKcard]
    refine Finset.mem_filter.mpr ⟨Finset.mem_powersetCard.mpr ⟨Finset.subset_univ _, hcard⟩, ?_⟩
    rw [hweight _ hcard, hmap]
    exact hKw
  · intro K hK
    have hall : ∀ x ∈ K.map (Function.Embedding.subtype (· ∈ Y)), x ∈ Y := fun x hx =>
      Finset.property_of_mem_map_subtype K hx
    exact Finset.map_injective (Function.Embedding.subtype (· ∈ Y))
      (Finset.subtype_map_of_mem hall)
  · intro K hK
    obtain ⟨hKmem, -⟩ := Finset.mem_filter.mp hK
    exact Finset.subtype_map_of_mem fun x hx => (Finset.mem_powersetCard.mp hKmem).1 hx

end AlignedFourSets

section Real

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Over the reals a symmetric matrix is a Hermitian one. -/
private theorem isHermitian_of_transpose {ι : Type*} {M : Matrix ι ι ℝ} (hM : Mᵀ = M) :
    M.IsHermitian := by
  show Mᴴ = M
  ext i j
  simpa using congrFun (congrFun hM i) j

/-- The second exchange moment of the cut at a half, read on the half itself.
For a real symmetric matrix `C` with zero diagonal and off-diagonal entries
squaring to one, whose square is `q • 1`, and a subset `Y` with
`Fintype.card n = 2 * Y.card`, an isometry onto the fixed space of the
normalization exists and the exchange operator it defines has

`tr(H²) = (d q² - 2 q d(d-1) + d(d-1) + 12·C(d,3) - 8·C(d,4) + 32 c)/q²`,

where `d` is the size of `Y` and `c` is the number of four-subsets of `Y` whose
three signed Hamilton-cycle products sum to `3`.  Every summand except the last
is determined by the order. -/
theorem exists_isometry_trace_pow_two_exchangeCompression_half {C : Matrix n n ℝ}
    (hdiag : ∀ i, C i i = 0) (hsym : ∀ i j, C j i = C i j)
    (hsq : ∀ i j, i ≠ j → C i j * C i j = 1) {q s : ℝ} (hCC : C * C = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0) (Y : Finset n) (hcard : Fintype.card n = 2 * Y.card) :
    ∃ U : Matrix ({x // x ∈ Y} ⊕ {x // x ∉ Y}) {x // x ∈ Y} ℝ,
      Uᵀ * U = 1 ∧ U * Uᵀ = fixedProjection (s⁻¹ • cutMatrix C Y)
        ∧ Matrix.trace
            (exchangeCompression (cutInvolution _ _ ℝ) (s⁻¹ • cutMatrix C Y) U ^ 2)
          = ((Y.card : ℝ) * q ^ 2
              - 2 * q * ((Y.card : ℝ) * ((Y.card : ℝ) - 1))
              + ((Y.card : ℝ) * ((Y.card : ℝ) - 1)
                + 12 * (Y.card.choose 3 : ℝ)
                - 8 * (Y.card.choose 4 : ℝ)
                + 32 * (alignedFourSetCount C Y : ℝ))) / q ^ 2 := by
  have hAt : (principalBlock C Y)ᵀ = principalBlock C Y := principalBlock_transpose C hsym Y
  have hEt : (complementBlock C Y)ᵀ = complementBlock C Y := complementBlock_transpose C hsym Y
  have hCC' : cutMatrix C Y * cutMatrix C Y = q • 1 := cutMatrix_mul_self C hsym Y hCC
  have hdA : ∀ i, principalBlock C Y i i = 0 := fun i => hdiag (i : n)
  have hdE : ∀ i, complementBlock C Y i i = 0 := fun i => hdiag (i : n)
  have hsymA : ∀ i j, principalBlock C Y j i = principalBlock C Y i j := fun i j =>
    hsym (i : n) (j : n)
  have hsqA : ∀ i j, i ≠ j → principalBlock C Y i j * principalBlock C Y i j = 1 :=
    fun i j hij => hsq (i : n) (j : n) (Subtype.coe_injective.ne hij)
  have hcard' : Fintype.card {x // x ∈ Y} = Fintype.card {x // x ∉ Y} := by
    rw [Fintype.card_coe, card_compl_of_card_eq_two_mul hcard]
  obtain ⟨⟨U, hU, hUU⟩, -⟩ :=
    BalancedExchangeEigenvalues.exists_isometries_cut hAt hEt hCC' hs hs0 hdA hdE hcard'
  refine ⟨U, hU, hUU, ?_⟩
  simp only [cutMatrix] at hCC' ⊢
  rw [trace_pow_two_exchangeCompression_cut hAt hEt hCC' hs hs0 hU hUU hdA hsymA hsqA,
    Fintype.card_coe, alignedFourSetCount_principalBlock C hsym Y]

/-- The exchange spectrum of the cut at a half, read in the eigenvalues of the
principal block on that half.  For a real symmetric matrix `C` with zero
diagonal whose square is `q • 1`, and a subset `Y` with
`Fintype.card n = 2 * Y.card`, an isometry onto the fixed space of the
normalization exists and the exchange operator it defines has characteristic
polynomial `∏ (X - (1 - αᵢ²/q))` over the eigenvalues `αᵢ` of the submatrix of
`C` on `Y`. -/
theorem exists_isometry_charpoly_exchangeCompression_half {C : Matrix n n ℝ}
    (hdiag : ∀ i, C i i = 0) (hsym : ∀ i j, C j i = C i j) {q s : ℝ} (hCC : C * C = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0) (Y : Finset n) (hcard : Fintype.card n = 2 * Y.card)
    (hA : (principalBlock C Y).IsHermitian) :
    ∃ U : Matrix ({x // x ∈ Y} ⊕ {x // x ∉ Y}) {x // x ∈ Y} ℝ,
      Uᵀ * U = 1 ∧ U * Uᵀ = fixedProjection (s⁻¹ • cutMatrix C Y)
        ∧ (exchangeCompression (cutInvolution _ _ ℝ) (s⁻¹ • cutMatrix C Y) U).charpoly
          = ∏ i, (Polynomial.X - Polynomial.C (1 - q⁻¹ * hA.eigenvalues i ^ 2)) :=
  BalancedExchangeEigenvalues.exists_isometry_charpoly_exchangeCompression_cut hA
    (isHermitian_of_transpose (complementBlock_transpose C hsym Y))
    (cutMatrix_mul_self C hsym Y hCC) hs hs0 (fun i => hdiag (i : n)) (fun i => hdiag (i : n))
    (by rw [Fintype.card_coe, card_compl_of_card_eq_two_mul hcard])

/-- At order six the exchange spectrum does not depend on the half: for every
three-element subset of a six-element label set the exchange operator of the
resulting cut has characteristic polynomial `(X - 1/5)(X - 4/5)²`.  This is the
one order above two at which cut-independence survives. -/
theorem exists_isometry_charpoly_exchangeCompression_half_card_three {C : Matrix n n ℝ}
    (hdiag : ∀ i, C i i = 0) (hsym : ∀ i j, C j i = C i j)
    (hsq : ∀ i j, i ≠ j → C i j * C i j = 1) {s : ℝ} (hCC : C * C = (5 : ℝ) • 1)
    (hs : s * s = (5 : ℝ)) (hs0 : s ≠ 0) (Y : Finset n) (hY : Y.card = 3)
    (hcard : Fintype.card n = 6) :
    ∃ U : Matrix ({x // x ∈ Y} ⊕ {x // x ∉ Y}) {x // x ∈ Y} ℝ,
      Uᵀ * U = 1 ∧ U * Uᵀ = fixedProjection (s⁻¹ • cutMatrix C Y)
        ∧ (exchangeCompression (cutInvolution _ _ ℝ) (s⁻¹ • cutMatrix C Y) U).charpoly
          = (Polynomial.X - Polynomial.C ((5 : ℝ)⁻¹))
            * (Polynomial.X - Polynomial.C (4 * (5 : ℝ)⁻¹)) ^ 2 := by
  have hbal : Fintype.card n = 2 * Y.card := by rw [hcard, hY]
  refine BalancedExchangeEigenvalues.exists_isometry_charpoly_exchangeCompression_cut_card_three
    (isHermitian_of_transpose (principalBlock_transpose C hsym Y))
    (isHermitian_of_transpose (complementBlock_transpose C hsym Y))
    (cutMatrix_mul_self C hsym Y hCC) hs hs0 (fun i => hdiag (i : n)) (fun i => hdiag (i : n))
    (fun i j => hsym (i : n) (j : n))
    (fun i j hij => hsq (i : n) (j : n) (Subtype.coe_injective.ne hij)) ?_ ?_
  · rw [Fintype.card_coe, hY]
  · rw [card_compl_of_card_eq_two_mul hbal, hY]

/-- The second exchange moment depends on the half.  For a real symmetric matrix
with zero diagonal and off-diagonal entries squaring to one on `2d` labels with
`4 ≤ d`, whose square is `q • 1`, no real number is the trace of the square of
the exchange operator of the cut at every balanced half. -/
theorem not_forall_trace_pow_two_exchangeCompression_half_eq {C : Matrix n n ℝ}
    (hdiag : ∀ i, C i i = 0) (hsym : ∀ i j, C j i = C i j)
    (hsq : ∀ i j, i ≠ j → C i j * C i j = 1) {q s : ℝ} (hCC : C * C = q • 1)
    (hs : s * s = q) (hs0 : s ≠ 0) {d : ℕ} (hd : 4 ≤ d) (hn : Fintype.card n = 2 * d)
    (t : ℝ) :
    ¬ ∀ Y : Finset n, Y.card = d →
        ∀ U : Matrix ({x // x ∈ Y} ⊕ {x // x ∉ Y}) {x // x ∈ Y} ℝ,
          Uᵀ * U = 1 → U * Uᵀ = fixedProjection (s⁻¹ • cutMatrix C Y) →
            Matrix.trace
              (exchangeCompression (cutInvolution _ _ ℝ) (s⁻¹ • cutMatrix C Y) U ^ 2) = t := by
  intro hconst
  have hq : q ≠ 0 := by rw [← hs]; exact mul_ne_zero hs0 hs0
  have key : ∀ Z : Finset n, Z.card = d →
      (32 : ℝ) * (alignedFourSetCount C Z : ℝ)
        = t * q ^ 2 - ((d : ℝ) * q ^ 2 - 2 * q * ((d : ℝ) * ((d : ℝ) - 1))
            + ((d : ℝ) * ((d : ℝ) - 1) + 12 * (d.choose 3 : ℝ) - 8 * (d.choose 4 : ℝ))) := by
    intro Z hZ
    obtain ⟨U, hU, hUU, htr⟩ := exists_isometry_trace_pow_two_exchangeCompression_half
      hdiag hsym hsq hCC hs hs0 Z (by rw [hZ]; exact hn)
    rw [hconst Z hZ U hU hUU, hZ, eq_div_iff (pow_ne_zero 2 hq)] at htr
    linear_combination -htr
  obtain ⟨Y₀, -, hY₀⟩ :=
    Finset.exists_subset_card_eq (s := (Finset.univ : Finset n)) (n := d)
      (by rw [Finset.card_univ, hn]; omega)
  refine BalancedExchangeSpectrum.not_forall_alignedFourSetCount_eq C hdiag hsym hsq hCC hd hn
    (alignedFourSetCount C Y₀) ?_
  intro Y _ hY
  have hcast : (alignedFourSetCount C Y : ℝ) = (alignedFourSetCount C Y₀ : ℝ) := by
    have h1 := key Y hY
    have h2 := key Y₀ hY₀
    linarith
  exact_mod_cast hcast

end Real

end RelativeConicArcs.BalancedExchangeHalfCut
