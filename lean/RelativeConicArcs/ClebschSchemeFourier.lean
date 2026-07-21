/-
# Character sums and checks of frozen q = 11 Fourier tables

This development proves an abstract scalar-line character identity over `F_11` and
checks exact consequences of frozen integer tables reconstructed from the reduced
projective icosahedral action on `F_11^3`:

* the scalar-line additive-character sum, from which the eigenvalues arise;
* the frozen candidate `P` entry formula from candidate projective hyperplane-incidence
  counts as `11 * z - ℓ`;
* equality of the frozen `P` and `Q` tables and the products `P * Q = P^2 = 1331 * I`;
* equality of the frozen candidate valencies with row zero of `Q`; and
* successful classification and additive nonclosure of the recorded witness pair for
  every proper nonempty union of the seven nonidentity relation labels.

The geometric identification of these literals with the orbit relations, eigenmatrices,
hyperplane incidences, and primitivity criterion of a translation association scheme is
an external exact-enumeration boundary. Lean does not define that scheme or prove this
identification. The generator, schema data, pinned construction, and
comparison certificate are under `lean/verification/clebsch_scheme_fourier/`; the
theorems below are kernel-checked consequences of their frozen output.
-/
import RelativeConicArcs.ClebschSchemeFourierData
import Mathlib.Tactic
import Mathlib.RingTheory.RootsOfUnity.Basic
import Mathlib.Algebra.BigOperators.Fin

namespace RelativeConicArcs
namespace ClebschSchemeFourier

open scoped BigOperators

/-! ## Scalar-line additive-character sum

Every nonzero relation of the scheme is a union of full scalar lines. Summing a
nontrivial additive character over such a line contributes `q - 1 = 10` when the line is
orthogonal to the character and `-1` otherwise; the totalled contribution of an orbit of
`ℓ` lines with `z` of them orthogonal is `11 z - ℓ`. The underlying identity is the
following character sum over `F_11`. -/

/-- Additive-character sum over `F_11`: for a primitive eleventh root of unity `ζ` in an
integral domain and `s : F_11`, the sum of `ζ^{(a s).val}` over all `a` is the order `11`
when `s = 0` and `0` otherwise. This is the Fourier-analytic source of the scheme's
eigenvalues. -/
theorem characterSum {R : Type*} [CommRing R] [IsDomain R]
    {ζ : R} (hζ : IsPrimitiveRoot ζ 11) (s : ZMod 11) :
    (∑ a : ZMod 11, ζ ^ (a * s).val) = if s = 0 then 11 else 0 := by
  letI : Fact (Nat.Prime 11) := ⟨by norm_num⟩
  by_cases hs : s = 0
  · subst hs
    simp
  · rw [if_neg hs]
    -- Multiplication by the unit `s` permutes `F_11`, so the sum is over all residues.
    have hs' : s ≠ 0 := hs
    have hreindex : (∑ a : ZMod 11, ζ ^ (a * s).val) = ∑ a : ZMod 11, ζ ^ a.val := by
      exact Equiv.sum_comp (Equiv.mulRight₀ s hs') (fun a => ζ ^ a.val)
    rw [hreindex]
    -- The residue sum is a full geometric sum of eleventh roots of unity.
    have hrange : (∑ a : ZMod 11, ζ ^ a.val) = ∑ i ∈ Finset.range 11, ζ ^ i := by
      exact Fin.sum_univ_eq_sum_range (fun i : ℕ => ζ ^ i) 11
    rw [hrange]
    -- The residue sum is fixed by multiplication by `ζ` (a cyclic shift of the exponents
    -- modulo eleven, using `ζ^11 = ζ^0 = 1`), so `(ζ - 1) · sum = 0`, and `ζ ≠ 1` forces
    -- the sum to vanish.
    have hpow : ζ ^ 11 = 1 := hζ.pow_eq_one
    have hne : ζ - 1 ≠ 0 := sub_ne_zero.mpr (hζ.ne_one (by norm_num))
    have hshift : ζ * (∑ i ∈ Finset.range 11, ζ ^ i) = ∑ i ∈ Finset.range 11, ζ ^ i := by
      have hsplitLast :
          (∑ i ∈ Finset.range 12, ζ ^ i) = (∑ i ∈ Finset.range 11, ζ ^ i) + ζ ^ 11 :=
        Finset.sum_range_succ (fun i => ζ ^ i) 11
      have hsplitFirst :
          (∑ i ∈ Finset.range 12, ζ ^ i)
            = (∑ i ∈ Finset.range 11, ζ ^ (i + 1)) + ζ ^ 0 :=
        Finset.sum_range_succ' (fun i => ζ ^ i) 11
      have hcancel :
          (∑ i ∈ Finset.range 11, ζ ^ (i + 1)) = ∑ i ∈ Finset.range 11, ζ ^ i := by
        have h := hsplitLast.symm.trans hsplitFirst
        rw [hpow, pow_zero] at h
        exact (add_right_cancel h).symm
      rw [Finset.mul_sum,
        show (∑ i ∈ Finset.range 11, ζ * ζ ^ i) = ∑ i ∈ Finset.range 11, ζ ^ (i + 1) from
          Finset.sum_congr rfl (fun i _ => by rw [pow_succ'])]
      exact hcancel
    have hzero : (ζ - 1) * (∑ i ∈ Finset.range 11, ζ ^ i) = 0 := by
      rw [sub_mul, one_mul, hshift, sub_self]
    exact (mul_eq_zero.mp hzero).resolve_left hne

/-- Removing the zero scalar from `characterSum` gives the contribution of a nonzero
scalar line: `10` for an orthogonal line and `-1` otherwise. Summing this identity over
`ell` lines, of which `z` are orthogonal, gives the integer expression `11*z - ell` used
by `scalarLineEigenvalue` below. -/
theorem nonzeroScalarLineContribution {R : Type*} [CommRing R] [IsDomain R]
    {ζ : R} (hζ : IsPrimitiveRoot ζ 11) (s : ZMod 11) :
    (∑ a : ZMod 11, ζ ^ (a * s).val) - 1 = if s = 0 then 10 else -1 := by
  rw [characterSum hζ s]
  by_cases hs : s = 0
  · simp [hs]
    norm_num
  · simp [hs]

/-- If `dots` lists the dot products of a character with `ell = dots.length` scalar-line
representatives and exactly `z = dots.count 0` of them are orthogonal, the total
nonzero-scalar contribution is `11*z - ell`. This is the general character-sum-to-count
formula used to interpret the frozen integer expression below. -/
theorem scalarLineContributionsSum {R : Type*} [CommRing R] [IsDomain R]
    {ζ : R} (hζ : IsPrimitiveRoot ζ 11) (dots : List (ZMod 11)) :
    (dots.map fun s => (∑ a : ZMod 11, ζ ^ (a * s).val) - 1).sum =
      (11 : R) * (dots.count 0 : R) - (dots.length : R) := by
  induction dots with
  | nil => simp
  | cons s dots ih =>
      rw [List.map_cons, List.sum_cons, nonzeroScalarLineContribution hζ s, ih]
      by_cases hs : s = 0
      · subst s
        simp
        ring
      · simp [hs]
        ring

/-- Integer total contributed by `ell` scalar lines when exactly `z` are orthogonal. -/
def scalarLineEigenvalue (z ell : ℤ) : ℤ := 11 * z - ell

/-! ## Frozen integer matrices: representation and index helpers -/

/-- Row-by-column product of two integer matrices presented as lists of rows. Missing
entries are read as zero; the public shape checks below rule that out for the frozen
matrices. -/
def matMul (a b : List (List ℤ)) : List (List ℤ) :=
  a.map fun row => (List.range b.length).map fun j =>
    (List.zipWith (fun x brow => x * brow.getD j 0) row b).sum

/-- The `k × k` scalar matrix `n • I`, as a list of rows. -/
def scaledIdentity (n : ℤ) (k : ℕ) : List (List ℤ) :=
  (List.range k).map fun i => (List.range k).map fun j => if i = j then n else 0

/-- Entry `(i, j)` of a matrix presented as a list of rows, defaulting to `0`. -/
def entry (m : List (List ℤ)) (i j : ℕ) : ℤ := (m.getD i []).getD j 0

/-! ## Exact checks of the frozen matrices -/

/-- Every frozen candidate eigenmatrix and hyperplane-count table has exactly
`schemeRank` rows, each of length `schemeRank`; the valency list has the same length. -/
theorem frozen_table_shapes :
    firstEigenmatrix.length = schemeRank ∧
      (∀ row ∈ firstEigenmatrix, row.length = schemeRank) ∧
      secondEigenmatrix.length = schemeRank ∧
      (∀ row ∈ secondEigenmatrix, row.length = schemeRank) ∧
      hyperplaneLineCounts.length = schemeRank ∧
      (∀ row ∈ hyperplaneLineCounts, row.length = schemeRank) ∧
      valencies.length = schemeRank := by
  decide

/-- The frozen first and second candidate eigenmatrices coincide in the fixed ordering. -/
theorem frozen_eigenmatrices_equal : firstEigenmatrix = secondEigenmatrix := by decide

/-- The frozen candidate matrices satisfy `P * Q = schemeOrder * I`. -/
theorem frozen_eigenmatrix_product :
    matMul firstEigenmatrix secondEigenmatrix =
      scaledIdentity schemeOrder schemeRank := by
  set_option maxRecDepth 10000 in decide

/-- The frozen candidate first eigenmatrix satisfies `P^2 = schemeOrder * I`. -/
theorem frozen_first_eigenmatrix_sq :
    matMul firstEigenmatrix firstEigenmatrix =
      scaledIdentity schemeOrder schemeRank := by
  set_option maxRecDepth 10000 in decide

/-- Row zero of the frozen candidate `Q` table equals the candidate valency list. -/
theorem frozen_q_row_zero_eq_valencies :
    secondEigenmatrix.getD 0 [] = valencies := by decide

/-- Frozen scalar-line formula: off the identity column, entry
`(i, j)` equals `11 z(i,j) - ℓ(j)`, where `z(i,j)` is the number of projective lines of
relation `j` orthogonal to the character of relation `i` and `ℓ(j)` (row zero) is the
number of projective lines in relation `j`; the identity column is all ones. The
per-line values `10` and `-1` are proved by `nonzeroScalarLineContribution`; identifying
the frozen counts with the stated geometry remains external. -/
theorem frozen_eigenmatrix_scalar_line_formula : ∀ i j : Fin schemeRank,
    entry firstEigenmatrix i j =
      (if j.val = 0 then 1 else scalarLineEigenvalue
        (entry hyperplaneLineCounts i j) (entry hyperplaneLineCounts 0 j)) := by
  decide

/-! ## Additive-nonclosure certificate

The frozen external construction labels every nonzero vector by the relation assigned to
its leading-coefficient-one projective representative. The definitions below check the
recorded classifier and witnesses without formalizing that geometric construction. -/

/-- Multiplicative inverse in `F_11` via the frozen table. -/
def inv11 (a : ZMod 11) : ZMod 11 := inverseModEleven.getD a.val 0

/-- The frozen table inverts every nonzero residue of `F_11`. -/
theorem inv11_mul : ∀ a : ZMod 11, a ≠ 0 → inv11 a * a = 1 := by decide

/-- Leading-coefficient-one projective normalization; the zero vector is fixed. The pivot
is the first nonzero coordinate, scaled to `1`. -/
def normalizeVector (v : SchemeVector) : SchemeVector :=
  if v.1 ≠ 0 then (inv11 v.1 * v.1, inv11 v.1 * v.2.1, inv11 v.1 * v.2.2)
  else if v.2.1 ≠ 0 then (0, inv11 v.2.1 * v.2.1, inv11 v.2.1 * v.2.2)
  else if v.2.2 ≠ 0 then (0, 0, inv11 v.2.2 * v.2.2)
  else v

/-- The optional frozen relation index of a vector. The origin is classified as `0`;
a nonzero vector returns `none` rather than a default index if its normalized projective
representative is absent from the frozen classifier. -/
def relationOf? (v : SchemeVector) : Option (Fin schemeRank) :=
  if v = (0, 0, 0) then some ⟨0, by decide⟩
  else (lineRelationClassifier.find? fun p => decide (p.1 = normalizeVector v)).map (·.2)

/-- The relations recorded in a witness are exactly the nonidentity relations selected by
its seven-bit mask. -/
def maskRelations (m : Nat) : List (Fin 8) :=
  ([1, 2, 3, 4, 5, 6, 7] : List (Fin 8)).filter fun i => m >>> (i.val - 1) &&& 1 = 1

/-- Every witness lists precisely the relations encoded by its mask. -/
theorem primitivity_witness_masks_decode :
    ∀ w ∈ primitivityWitnesses, w.2.1 = maskRelations w.1 := by
  set_option maxRecDepth 100000 in decide

/-- The witness masks enumerate exactly the `126` proper nonempty subsets of the seven
nonidentity relations. -/
theorem primitivity_masks_exhaustive :
    primitivityWitnesses.map (fun w => w.1) =
      (List.range 128).filter (fun m => decide (m ≠ 0 ∧ m ≠ 127)) := by
  set_option maxRecDepth 100000 in decide

/-- Additive-nonclosure check for the frozen certificate: every witness vector is
successfully classified into its listed union, and the nonzero sum is successfully
classified outside that union. A missing classifier lookup cannot satisfy any conjunct.
Transferring this literal check to primitivity of the geometric orbit scheme uses the
external orbit/classifier identification. -/
theorem frozen_witnesses_break_additive_closure :
    ∀ w ∈ primitivityWitnesses,
      (∃ r ∈ w.2.1, relationOf? w.2.2.1 = some r) ∧
        (∃ r ∈ w.2.1, relationOf? w.2.2.2 = some r) ∧
          (∃ r, r ∉ w.2.1 ∧ relationOf? (w.2.2.1 + w.2.2.2) = some r) ∧
            w.2.2.1 + w.2.2.2 ≠ (0, 0, 0) := by
  set_option maxRecDepth 100000 in decide

end ClebschSchemeFourier
end RelativeConicArcs
