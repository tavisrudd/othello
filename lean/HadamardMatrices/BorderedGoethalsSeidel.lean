/-
# Bordered Goethals–Seidel arrays over four circulant sequences

Fix `m ≥ 1` and index positions inside a block by the group `ZMod m`.  Four
functions `a b c d : ZMod m → ℤ` are read as the first rows of circulant
matrices of order `m`.  Out of them this file builds a square integer matrix of
order `4 * m + 4`, indexed by `Fin 4 ⊕ Fin 4 × ZMod m`: four *border* indices
followed by four *slabs*, each carrying the `m` offsets of `ZMod m`.

Write `A`, `B`, `C`, `D` for the circulants with first rows `a`, `b`, `c`, `d`,
so that `A i j = a (j - i)`, and let `R` be the back-diagonal permutation matrix
of order `m`, that is `R i j = 1` exactly when `i + j = 0`.  For `e = 0` the
body of the array below is the Goethals–Seidel array

```
    A      B R    C R    D R
  -B R     A      Dᵀ R  -Cᵀ R
  -C R   -Dᵀ R    A      Bᵀ R
  -D R    Cᵀ R  -Bᵀ R    A
```

of J.-M. Goethals and J. J. Seidel, *Orthogonal matrices with zero diagonal*,
Canadian Journal of Mathematics 19 (1967), 1001–1010; the array is displayed in
Section 4 of that paper.  This file treats the one-parameter family in which the
six blocks of the lower right `3 × 3` corner carry an extra cyclic shift by a
fixed `e : ZMod m`: the block `Xᵀ R`, whose entries are `x (i + j)`, is replaced
by the back-circulant with entries `x (i + j + e)`.  Taking `e = 0` returns the
array displayed above.

The body is bordered by four further rows and columns.  A border row is
constant on the columns of each slab, and a body row is constant on each border
column; the three sign tables `cornerSign`, `borderBlockSign` and
`slabPrefixSign` record those values.

The result proved here, `borderedArray_mul_transpose`, is that

```
  H Hᵀ = (4 * m + 4) • 1
```

holds as soon as the four sequences take values in `{1, -1}`, have sums
`2, 0, 0, 0` over a full period, and their periodic autocorrelations satisfy

```
  PAF_a s + PAF_b s + PAF_c s + PAF_d s = -4   for every s ≠ 0.
```

No hypothesis constrains the inner shift `e`; it cancels in every cross term.
Everything in this file is ordinary algebra checked by the Lean kernel: there
is no finite enumeration beyond sums over `Fin 4`, no certificate, and no
external input.
-/
import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Matrix.Mul
import Mathlib.Algebra.BigOperators.Fin

namespace HadamardMatrices

open Finset Matrix

variable {m : ℕ} [NeZero m]

/-! ## Periodic correlations -/

/-- The periodic cross-correlation of `u` and `v` at shift `s`, that is
`∑ t, u t * v (t + s)`.  For `u = v` this is the periodic autocorrelation. -/
def corr (u v : ZMod m → ℤ) (s : ZMod m) : ℤ := ∑ t : ZMod m, u t * v (t + s)

/-- The reversed periodic correlation `∑ t, u t * v (s - t)`.  It is symmetric
in `u` and `v`, and it is the shape taken by those cross terms of the array
that pair a circulant block against a back-circulant one. -/
def revCorr (u v : ZMod m → ℤ) (s : ZMod m) : ℤ := ∑ t : ZMod m, u t * v (s - t)

/-- The sum of the four periodic autocorrelations at shift `s`. -/
def pafSum (a b c d : ZMod m → ℤ) (s : ZMod m) : ℤ :=
  corr a a s + corr b b s + corr c c s + corr d d s

/-- Translation `t ↦ t - c` of `ZMod m`. -/
private def shiftSub (c : ZMod m) : ZMod m ≃ ZMod m where
  toFun t := t - c
  invFun t := t + c
  left_inv t := by simp
  right_inv t := by simp

omit [NeZero m] in
@[simp] private lemma shiftSub_apply (c t : ZMod m) : shiftSub c t = t - c := rfl

/-- Reflection `t ↦ c - t` of `ZMod m`. -/
private def reflect (c : ZMod m) : ZMod m ≃ ZMod m where
  toFun t := c - t
  invFun t := c - t
  left_inv t := by simp
  right_inv t := by simp

omit [NeZero m] in
@[simp] private lemma reflect_apply (c t : ZMod m) : reflect c t = c - t := rfl

lemma corr_symm (u v : ZMod m → ℤ) (s : ZMod m) : corr u v s = corr v u (-s) := by
  simp only [corr]
  refine Fintype.sum_equiv (shiftSub (-s)) _ _ fun t => ?_
  simp only [shiftSub_apply]
  rw [mul_comm]
  congr 2 <;> ring

lemma corr_neg_comm (u v : ZMod m → ℤ) (s : ZMod m) : corr u v (-s) = corr v u s := by
  rw [corr_symm u v (-s), neg_neg]

lemma corr_sub_comm (u v : ZMod m → ℤ) (i j : ZMod m) :
    corr u v (i - j) = corr v u (j - i) := by
  rw [corr_symm u v (i - j), neg_sub]

lemma corr_self_sub_comm (u : ZMod m → ℤ) (i j : ZMod m) :
    corr u u (j - i) = corr u u (i - j) := by
  rw [corr_symm u u (j - i), neg_sub]

lemma revCorr_symm (u v : ZMod m → ℤ) (s : ZMod m) : revCorr u v s = revCorr v u s := by
  simp only [revCorr]
  refine Fintype.sum_equiv (reflect s) _ _ fun t => ?_
  simp only [reflect_apply]
  rw [mul_comm]
  congr 2
  ring

/-! ## Normal forms for the block correlations

Each block of the array contributes to an entry of `H Hᵀ` one sum over
`ZMod m` of a product of two sequence values.  Exactly three argument shapes
occur: `t - X` from a circulant block, `-(X + t)` from a back-circulant block of
the outer skeleton, and `X + t + e` from a back-circulant block of the shifted
inner corner.  The lemmas below put each resulting sum into one of the two
normal forms `corr` and `revCorr`. -/

lemma sum_sub_sub (u v : ZMod m → ℤ) (X Y : ZMod m) :
    ∑ t : ZMod m, u (t - X) * v (t - Y) = corr u v (X - Y) := by
  simp only [corr]
  refine Fintype.sum_equiv (shiftSub X) _ _ fun t => ?_
  simp only [shiftSub_apply]
  congr 2
  ring

lemma sum_neg_neg (u v : ZMod m → ℤ) (X Y : ZMod m) :
    ∑ t : ZMod m, u (-(X + t)) * v (-(Y + t)) = corr u v (X - Y) := by
  simp only [corr]
  refine Fintype.sum_equiv (reflect (-X)) _ _ fun t => ?_
  simp only [reflect_apply]
  congr 2 <;> ring

lemma sum_shift_shift (u v : ZMod m → ℤ) (X Y e : ZMod m) :
    ∑ t : ZMod m, u (X + t + e) * v (Y + t + e) = corr u v (Y - X) := by
  simp only [corr]
  refine Fintype.sum_equiv (shiftSub (-(X + e))) _ _ fun t => ?_
  simp only [shiftSub_apply]
  congr 2 <;> ring

lemma sum_sub_shift (u v : ZMod m → ℤ) (X Y e : ZMod m) :
    ∑ t : ZMod m, u (t - X) * v (Y + t + e) = corr u v (X + Y + e) := by
  simp only [corr]
  refine Fintype.sum_equiv (shiftSub X) _ _ fun t => ?_
  simp only [shiftSub_apply]
  congr 2
  ring

lemma sum_shift_sub (u v : ZMod m → ℤ) (X Y e : ZMod m) :
    ∑ t : ZMod m, u (X + t + e) * v (t - Y) = corr u v (-(X + Y + e)) := by
  simp only [corr]
  refine Fintype.sum_equiv (shiftSub (-(X + e))) _ _ fun t => ?_
  simp only [shiftSub_apply]
  congr 2 <;> ring

lemma sum_sub_neg (u v : ZMod m → ℤ) (X Y : ZMod m) :
    ∑ t : ZMod m, u (t - X) * v (-(Y + t)) = revCorr u v (-(X + Y)) := by
  simp only [revCorr]
  refine Fintype.sum_equiv (shiftSub X) _ _ fun t => ?_
  simp only [shiftSub_apply]
  congr 2
  ring

lemma sum_neg_sub (u v : ZMod m → ℤ) (X Y : ZMod m) :
    ∑ t : ZMod m, u (-(X + t)) * v (t - Y) = revCorr u v (-(X + Y)) := by
  simp only [revCorr]
  refine Fintype.sum_equiv (reflect (-X)) _ _ fun t => ?_
  simp only [reflect_apply]
  congr 2 <;> ring

lemma sum_neg_shift (u v : ZMod m → ℤ) (X Y e : ZMod m) :
    ∑ t : ZMod m, u (-(X + t)) * v (Y + t + e) = revCorr u v (Y - X + e) := by
  simp only [revCorr]
  refine Fintype.sum_equiv (reflect (-X)) _ _ fun t => ?_
  simp only [reflect_apply]
  congr 2 <;> ring

lemma sum_shift_neg (u v : ZMod m → ℤ) (X Y e : ZMod m) :
    ∑ t : ZMod m, u (X + t + e) * v (-(Y + t)) = revCorr u v (X - Y + e) := by
  simp only [revCorr]
  refine Fintype.sum_equiv (shiftSub (-(X + e))) _ _ fun t => ?_
  simp only [shiftSub_apply]
  congr 2 <;> ring

/-- Summing a sequence over one full period is invariant under translating the
index, so a circulant block has the same row sum in every row. -/
lemma sum_sub_row (u : ZMod m → ℤ) (X : ZMod m) :
    ∑ t : ZMod m, u (t - X) = ∑ t : ZMod m, u t :=
  Fintype.sum_equiv (shiftSub X) _ _ fun _ => rfl

lemma sum_neg_row (u : ZMod m → ℤ) (X : ZMod m) :
    ∑ t : ZMod m, u (-(X + t)) = ∑ t : ZMod m, u t := by
  refine Fintype.sum_equiv (reflect (-X)) _ _ fun t => ?_
  simp only [reflect_apply]
  congr 1
  ring

lemma sum_shift_row (u : ZMod m → ℤ) (X e : ZMod m) :
    ∑ t : ZMod m, u (X + t + e) = ∑ t : ZMod m, u t := by
  refine Fintype.sum_equiv (shiftSub (-(X + e))) _ _ fun t => ?_
  simp only [shiftSub_apply]
  congr 1
  ring

/-! ## The array -/

/-- The index set of the array: four border indices, then four slabs of `m`
offsets each.  Its cardinality is `4 * m + 4`. -/
abbrev ArrayIndex (m : ℕ) : Type := Fin 4 ⊕ Fin 4 × ZMod m

/-- The `4 × 4` corner where the border rows meet the border columns. -/
def cornerSign : Fin 4 → Fin 4 → ℤ
  | 0, 0 => -1 | 0, 1 =>  1 | 0, 2 =>  1 | 0, 3 => -1
  | 1, 0 =>  1 | 1, 1 => -1 | 1, 2 =>  1 | 1, 3 => -1
  | 2, 0 =>  1 | 2, 1 =>  1 | 2, 2 => -1 | 2, 3 => -1
  | 3, 0 => -1 | 3, 1 => -1 | 3, 2 => -1 | 3, 3 => -1

/-- The entry of border row `r` on every column of slab `l`. -/
def borderBlockSign : Fin 4 → Fin 4 → ℤ
  | 0, 0 => -1 | 0, 1 => -1 | 0, 2 => -1 | 0, 3 =>  1
  | 1, 0 => -1 | 1, 1 => -1 | 1, 2 =>  1 | 1, 3 => -1
  | 2, 0 => -1 | 2, 1 =>  1 | 2, 2 => -1 | 2, 3 => -1
  | 3, 0 =>  1 | 3, 1 => -1 | 3, 2 => -1 | 3, 3 => -1

/-- The entry of every body row of slab `k` on border column `r`. -/
def slabPrefixSign : Fin 4 → Fin 4 → ℤ
  | 0, 0 =>  1 | 0, 1 =>  1 | 0, 2 =>  1 | 0, 3 => -1
  | 1, 0 => -1 | 1, 1 => -1 | 1, 2 =>  1 | 1, 3 => -1
  | 2, 0 => -1 | 2, 1 =>  1 | 2, 2 => -1 | 2, 3 => -1
  | 3, 0 =>  1 | 3, 1 => -1 | 3, 2 => -1 | 3, 3 => -1

/-- The entry of the body block in slab row `k` and slab column `l` at offsets
`i` (row) and `j` (column).  A diagonal block is the circulant with first row
`a`; a block of the outer skeleton is back-circulant in `-(i + j)`; a block of
the lower right `3 × 3` corner is back-circulant in `i + j + e`. -/
def bodyEntry (a b c d : ZMod m → ℤ) (e : ZMod m) :
    Fin 4 → Fin 4 → ZMod m → ZMod m → ℤ
  | 0, 0, i, j => a (j - i)
  | 0, 1, i, j => b (-(i + j))
  | 0, 2, i, j => c (-(i + j))
  | 0, 3, i, j => d (-(i + j))
  | 1, 0, i, j => -b (-(i + j))
  | 1, 1, i, j => a (j - i)
  | 1, 2, i, j => d (i + j + e)
  | 1, 3, i, j => -c (i + j + e)
  | 2, 0, i, j => -c (-(i + j))
  | 2, 1, i, j => -d (i + j + e)
  | 2, 2, i, j => a (j - i)
  | 2, 3, i, j => b (i + j + e)
  | 3, 0, i, j => -d (-(i + j))
  | 3, 1, i, j => c (i + j + e)
  | 3, 2, i, j => -b (i + j + e)
  | 3, 3, i, j => a (j - i)

/-- The entries of the bordered array, before packaging them as a matrix. -/
def borderedEntry (a b c d : ZMod m → ℤ) (e : ZMod m) : ArrayIndex m → ArrayIndex m → ℤ
  | Sum.inl r, Sum.inl r' => cornerSign r r'
  | Sum.inl r, Sum.inr q => borderBlockSign r q.1
  | Sum.inr p, Sum.inl r' => slabPrefixSign p.1 r'
  | Sum.inr p, Sum.inr q => bodyEntry a b c d e p.1 q.1 p.2 q.2

/-- The bordered Goethals–Seidel array of order `4 * m + 4` determined by the
four first rows `a`, `b`, `c`, `d` and the inner shift `e`. -/
def borderedArray (a b c d : ZMod m → ℤ) (e : ZMod m) : Matrix (ArrayIndex m) (ArrayIndex m) ℤ :=
  Matrix.of (borderedEntry a b c d e)

omit [NeZero m] in
@[simp] lemma borderedArray_apply (a b c d : ZMod m → ℤ) (e : ZMod m) (p q : ArrayIndex m) :
    borderedArray a b c d e p q = borderedEntry a b c d e p q := rfl

lemma card_arrayIndex : Fintype.card (ArrayIndex m) = 4 * m + 4 := by
  simp only [Fintype.card_sum, Fintype.card_prod, Fintype.card_fin, ZMod.card]
  omega

omit [NeZero m] in
/-- Every entry of the array is `1` or `-1` once the four sequences are. -/
lemma borderedEntry_sq (a b c d : ZMod m → ℤ) (e : ZMod m)
    (hsa : ∀ t, a t * a t = 1) (hsb : ∀ t, b t * b t = 1)
    (hsc : ∀ t, c t * c t = 1) (hsd : ∀ t, d t * d t = 1) (p q : ArrayIndex m) :
    borderedEntry a b c d e p q * borderedEntry a b c d e p q = 1 := by
  rcases p with r | ⟨k, i⟩ <;> rcases q with r' | ⟨l, j⟩ <;> simp only [borderedEntry]
  · revert r r'; decide
  · revert r l; decide
  · revert k r'; decide
  · fin_cases k <;> fin_cases l <;>
      simp only [bodyEntry, neg_mul_neg] <;>
      first
        | exact hsa _ | exact hsb _ | exact hsc _ | exact hsd _

/-! ## Gram entries involving the border -/

lemma corner_gram (r r' : Fin 4) :
    (∑ s : Fin 4, cornerSign r s * cornerSign r' s) = if r = r' then 4 else 0 := by
  revert r r'; decide

lemma borderBlock_gram (r r' : Fin 4) :
    (∑ l : Fin 4, borderBlockSign r l * borderBlockSign r' l) = if r = r' then 4 else 0 := by
  revert r r'; decide

lemma prefix_gram (k l : Fin 4) :
    (∑ s : Fin 4, slabPrefixSign k s * slabPrefixSign l s) = if k = l then 4 else 0 := by
  revert k l; decide

lemma corner_prefix (r k : Fin 4) :
    (∑ s : Fin 4, cornerSign r s * slabPrefixSign k s) + borderBlockSign r k * 2 = 0 := by
  revert r k; decide

lemma prefix_corner (k r : Fin 4) :
    (∑ s : Fin 4, slabPrefixSign k s * cornerSign r s) + 2 * borderBlockSign r k = 0 := by
  revert k r; decide

/-! ## Gram entries of the body -/

variable (a b c d : ZMod m → ℤ) (e : ZMod m)

/-- The sum of a body row over one slab of columns.  Only the diagonal block
contributes, because the three remaining sequences sum to zero. -/
lemma body_row_sum (k l : Fin 4) (i : ZMod m)
    (hrb : ∑ t : ZMod m, b t = 0) (hrc : ∑ t : ZMod m, c t = 0)
    (hrd : ∑ t : ZMod m, d t = 0) :
    ∑ t : ZMod m, bodyEntry a b c d e k l i t
      = if k = l then ∑ t : ZMod m, a t else 0 := by
  fin_cases k <;> fin_cases l <;>
    simp only [bodyEntry, Finset.sum_neg_distrib] <;>
    first
      | (rw [sum_sub_row a i]; simp)
      | (rw [sum_neg_row b i, hrb]; simp)
      | (rw [sum_neg_row c i, hrc]; simp)
      | (rw [sum_neg_row d i, hrd]; simp)
      | (rw [sum_shift_row b i e, hrb]; simp)
      | (rw [sum_shift_row c i e, hrc]; simp)
      | (rw [sum_shift_row d i e, hrd]; simp)

/-- Two body rows in the same slab: their inner product over the body columns
is the sum of the four periodic autocorrelations at the difference of their
offsets. -/
lemma body_gram_diag (k : Fin 4) (i j : ZMod m) :
    ∑ l : Fin 4, ∑ t : ZMod m, bodyEntry a b c d e k l i t * bodyEntry a b c d e k l j t
      = pafSum a b c d (i - j) := by
  simp only [pafSum]
  fin_cases k <;>
    simp only [Fin.sum_univ_four, bodyEntry, mul_neg, neg_mul, neg_neg]
  · rw [sum_sub_sub a a i j, sum_neg_neg b b i j, sum_neg_neg c c i j, sum_neg_neg d d i j]
  · rw [sum_neg_neg b b i j, sum_sub_sub a a i j, sum_shift_shift d d i j e,
      sum_shift_shift c c i j e, corr_self_sub_comm d i j, corr_self_sub_comm c i j]
    ring
  · rw [sum_neg_neg c c i j, sum_shift_shift d d i j e, sum_sub_sub a a i j,
      sum_shift_shift b b i j e, corr_self_sub_comm d i j, corr_self_sub_comm b i j]
    ring
  · rw [sum_neg_neg d d i j, sum_shift_shift c c i j e, sum_shift_shift b b i j e,
      sum_sub_sub a a i j, corr_self_sub_comm c i j, corr_self_sub_comm b i j]
    ring

/-- Two body rows in different slabs are orthogonal over the body columns, for
every choice of the four sequences and of the inner shift.  The four block
contributions cancel in two pairs. -/
lemma body_gram_off (k l : Fin 4) (hkl : k ≠ l) (i j : ZMod m) :
    ∑ p : Fin 4, ∑ t : ZMod m, bodyEntry a b c d e k p i t * bodyEntry a b c d e l p j t
      = 0 := by
  fin_cases k <;> fin_cases l <;>
    first
      | exact absurd rfl hkl
      | (simp only [Fin.sum_univ_four, bodyEntry, mul_neg, neg_mul, neg_neg,
            Finset.sum_neg_distrib]
         first
          | (rw [sum_sub_neg a b i j, sum_neg_sub b a i j, sum_neg_shift c d i j e,
                sum_neg_shift d c i j e, revCorr_symm b a, revCorr_symm d c]; ring)
          | (rw [sum_sub_neg a c i j, sum_neg_shift b d i j e, sum_neg_sub c a i j,
                sum_neg_shift d b i j e, revCorr_symm c a, revCorr_symm d b]; ring)
          | (rw [sum_sub_neg a d i j, sum_neg_shift b c i j e, sum_neg_shift c b i j e,
                sum_neg_sub d a i j, revCorr_symm d a, revCorr_symm c b]; ring)
          | (rw [sum_neg_sub b a i j, sum_sub_neg a b i j, sum_shift_neg d c i j e,
                sum_shift_neg c d i j e, revCorr_symm b a, revCorr_symm d c]; ring)
          | (rw [sum_neg_neg b c i j, sum_sub_shift a d i j e, sum_shift_sub d a i j e,
                sum_shift_shift c b i j e, corr_neg_comm d a (i + j + e),
                corr_sub_comm c b j i]; ring)
          | (rw [sum_neg_neg b d i j, sum_sub_shift a c i j e, sum_shift_shift d b i j e,
                sum_shift_sub c a i j e, corr_neg_comm c a (i + j + e),
                corr_sub_comm d b j i]; ring)
          | (rw [sum_neg_sub c a i j, sum_shift_neg d b i j e, sum_sub_neg a c i j,
                sum_shift_neg b d i j e, revCorr_symm c a, revCorr_symm d b]; ring)
          | (rw [sum_neg_neg c b i j, sum_shift_sub d a i j e, sum_sub_shift a d i j e,
                sum_shift_shift b c i j e, corr_neg_comm d a (i + j + e),
                corr_sub_comm b c j i]; ring)
          | (rw [sum_neg_neg c d i j, sum_shift_shift d c i j e, sum_sub_shift a b i j e,
                sum_shift_sub b a i j e, corr_neg_comm b a (i + j + e),
                corr_sub_comm d c j i]; ring)
          | (rw [sum_neg_sub d a i j, sum_shift_neg c b i j e, sum_shift_neg b c i j e,
                sum_sub_neg a d i j, revCorr_symm d a, revCorr_symm c b]; ring)
          | (rw [sum_neg_neg d b i j, sum_shift_sub c a i j e, sum_shift_shift b d i j e,
                sum_sub_shift a c i j e, corr_neg_comm c a (i + j + e),
                corr_sub_comm b d j i]; ring)
          | (rw [sum_neg_neg d c i j, sum_shift_shift c d i j e, sum_shift_sub b a i j e,
                sum_sub_shift a b i j e, corr_neg_comm b a (i + j + e),
                corr_sub_comm c d j i]; ring))

/-! ## Orthogonality -/

lemma gram_border_border (r r' : Fin 4) :
    ∑ x : ArrayIndex m, borderedEntry a b c d e (Sum.inl r) x * borderedEntry a b c d e (Sum.inl r') x
      = if r = r' then 4 * (m : ℤ) + 4 else 0 := by
  rw [Fintype.sum_sum_type]
  simp only [borderedEntry, Fintype.sum_prod_type, Finset.sum_const, Finset.card_univ, ZMod.card,
    nsmul_eq_mul, ← Finset.mul_sum]
  rw [corner_gram, borderBlock_gram]
  by_cases h : r = r'
  · simp only [if_pos h]; ring
  · simp only [if_neg h]; ring

lemma gram_border_body (r l : Fin 4) (j : ZMod m)
    (hra : ∑ t : ZMod m, a t = 2) (hrb : ∑ t : ZMod m, b t = 0)
    (hrc : ∑ t : ZMod m, c t = 0) (hrd : ∑ t : ZMod m, d t = 0) :
    ∑ x : ArrayIndex m, borderedEntry a b c d e (Sum.inl r) x * borderedEntry a b c d e (Sum.inr (l, j)) x = 0 := by
  rw [Fintype.sum_sum_type]
  simp only [borderedEntry, Fintype.sum_prod_type, ← Finset.mul_sum,
    body_row_sum a b c d e l _ j hrb hrc hrd, hra, mul_ite, mul_zero]
  rw [Finset.sum_ite_eq]
  simp only [Finset.mem_univ, if_true]
  exact corner_prefix r l

lemma gram_body_border (k r' : Fin 4) (i : ZMod m)
    (hra : ∑ t : ZMod m, a t = 2) (hrb : ∑ t : ZMod m, b t = 0)
    (hrc : ∑ t : ZMod m, c t = 0) (hrd : ∑ t : ZMod m, d t = 0) :
    ∑ x : ArrayIndex m, borderedEntry a b c d e (Sum.inr (k, i)) x * borderedEntry a b c d e (Sum.inl r') x = 0 := by
  rw [Fintype.sum_sum_type]
  simp only [borderedEntry, Fintype.sum_prod_type, ← Finset.sum_mul,
    body_row_sum a b c d e k _ i hrb hrc hrd, hra, ite_mul, zero_mul]
  rw [Finset.sum_ite_eq]
  simp only [Finset.mem_univ, if_true]
  exact prefix_corner k r'

lemma gram_body_body (k l : Fin 4) (i j : ZMod m)
    (hpaf0 : pafSum a b c d 0 = 4 * (m : ℤ))
    (hpaf : ∀ s : ZMod m, s ≠ 0 → pafSum a b c d s = -4) :
    ∑ x : ArrayIndex m, borderedEntry a b c d e (Sum.inr (k, i)) x * borderedEntry a b c d e (Sum.inr (l, j)) x
      = if k = l ∧ i = j then 4 * (m : ℤ) + 4 else 0 := by
  rw [Fintype.sum_sum_type]
  simp only [borderedEntry, Fintype.sum_prod_type]
  by_cases hkl : k = l
  · subst hkl
    rw [prefix_gram, if_pos rfl, body_gram_diag]
    by_cases hij : i = j
    · subst hij
      rw [sub_self, hpaf0, if_pos ⟨rfl, rfl⟩]
      ring
    · rw [hpaf _ (sub_ne_zero.mpr hij), if_neg (by simp [hij])]
      ring
  · rw [prefix_gram, if_neg hkl, body_gram_off a b c d e k l hkl i j,
      if_neg (by simp [hkl])]
    ring

/-- A bordered Goethals–Seidel array of order `4 * m + 4` satisfies
`H Hᵀ = (4 * m + 4) • 1` as soon as its four sequences take values in
`{1, -1}`, sum to `2, 0, 0, 0` over a full period, and have periodic
autocorrelations summing to `-4` at every nonzero shift.  The inner shift `e`
is unconstrained.  Together with `borderedEntry_sq` this makes the array a Hadamard
matrix of order `4 * m + 4`. -/
theorem borderedArray_mul_transpose
    (hsa : ∀ t, a t * a t = 1) (hsb : ∀ t, b t * b t = 1)
    (hsc : ∀ t, c t * c t = 1) (hsd : ∀ t, d t * d t = 1)
    (hra : ∑ t : ZMod m, a t = 2) (hrb : ∑ t : ZMod m, b t = 0)
    (hrc : ∑ t : ZMod m, c t = 0) (hrd : ∑ t : ZMod m, d t = 0)
    (hpaf : ∀ s : ZMod m, s ≠ 0 → pafSum a b c d s = -4) :
    borderedArray a b c d e * (borderedArray a b c d e)ᵀ
      = (4 * (m : ℤ) + 4) • (1 : Matrix (ArrayIndex m) (ArrayIndex m) ℤ) := by
  have hcorr : ∀ u : ZMod m → ℤ, (∀ t, u t * u t = 1) → corr u u 0 = (m : ℤ) := by
    intro u hu
    simp only [corr, add_zero]
    rw [Finset.sum_congr rfl fun t _ => hu t]
    simp [ZMod.card]
  have hpaf0 : pafSum a b c d 0 = 4 * (m : ℤ) := by
    simp only [pafSum, hcorr a hsa, hcorr b hsb, hcorr c hsc, hcorr d hsd]
    ring
  ext p q
  rw [Matrix.mul_apply]
  simp only [Matrix.transpose_apply, borderedArray_apply, Matrix.smul_apply, smul_eq_mul,
    Matrix.one_apply, mul_ite, mul_one, mul_zero]
  rcases p with r | ⟨k, i⟩ <;> rcases q with r' | ⟨l, j⟩
  · rw [gram_border_border a b c d e r r']
    by_cases h : r = r'
    · rw [if_pos h, if_pos (congrArg Sum.inl h)]
    · rw [if_neg h, if_neg (by simpa using h)]
  · rw [gram_border_body a b c d e r l j hra hrb hrc hrd, if_neg (by simp)]
  · rw [gram_body_border a b c d e k r' i hra hrb hrc hrd, if_neg (by simp)]
  · rw [gram_body_body a b c d e k l i j hpaf0 hpaf]
    by_cases hkl : k = l
    · by_cases hij : i = j
      · rw [if_pos ⟨hkl, hij⟩, if_pos (by rw [hkl, hij])]
      · rw [if_neg (by simp [hij]), if_neg (by simp [hij])]
    · rw [if_neg (by simp [hkl]), if_neg (by simp [hkl])]

end HadamardMatrices
