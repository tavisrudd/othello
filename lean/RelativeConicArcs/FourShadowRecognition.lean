import RelativeConicArcs.ClebschOperatorShadows
import Mathlib.LinearAlgebra.Matrix.Notation
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Ring

/-!
# Recognition from the triangle and commutator-Pfaffian cubics

For a symmetric zero-diagonal matrix on six labels, the triangle cubic records
the products around triples, while the commutator Pfaffian is the signed
perfect-matching evaluation of the bracket matrix.  If the latter is a
nonzero scalar multiple of the former and every edge is nonzero, translation
invariance forces all pair moments to vanish.  The matrix square is then
diagonal, and associativity forces its diagonal entries to agree.

The weighted converse is symbolic over an integral domain.  Its coefficient
step factors through a reducible twenty-term table and a proved monomial
mixed-difference identity; no generated certificate or finite classification
is used there.

The scalar-sign results concern root-normalized matrices encoded by ten
Boolean edge signs and their nonzero integral scalar multiples.  They do not
formalize reduction of an arbitrary scalar sign matrix by switching or
uniqueness modulo switching and permutation.  On that locus the five root-pair
balances are five linear equations in the ten edge signs, one for each non-root
vertex, and each says that the vertex carries exactly two positive edges to the
other four non-root vertices.  The positive graph on the five non-root vertices
is then two-regular, hence a pentagon, and the five equations have exactly
twelve solutions, one for each labelled pentagon.  Those twelve are extracted in
two steps.  A proved sign lemma splits four signs summing to zero into its six
balanced patterns, which settles the four edges at the first non-root vertex;
in each of the six resulting branches the six remaining Boolean edge parameters
are enumerated, and every assignment is either refuted by one of the four
remaining balance equations or matched with one of the twelve listed pentagons.
That case analysis is the only finite search in the module: `6 × 64` Boolean
assignments carrying no matrix arithmetic, all discharged by kernel reduction
behind the sign lemma just described.  The twelve resulting cubic identities and
the orientation of the `x₀x₁x₂` coefficient are proved by kernel normalization.
No compiled evaluation, generated certificate, or external computation enters
any declaration of this module.  The rational
rank-fourteen Jacobian calculation for local weighted rigidity is not
formalized in this module.
-/

namespace RelativeConicArcs.FourShadowRecognition

open Matrix
open ClebschGoldenConference
open GoldenCommutatorPfaffian

variable {R : Type*} [CommRing R] [IsDomain R]

/-- Proportionality between the commutator-Pfaffian cubic and the triangle
cubic, with the proportionality scalar displayed explicitly. -/
def CubicsProportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R) : Prop :=
  ∀ x, matchingEvaluation C x = mu * triangleCubic C x

omit [IsDomain R] in
/-- Scaling every matrix entry gives the commutator-Pfaffian cubic weight
three in the matrix. -/
theorem matchingEvaluation_smul (s : R)
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) :
    matchingEvaluation (s • C) x = s ^ 3 * matchingEvaluation C x := by
  simp [matchingEvaluation]
  ring

omit [IsDomain R] in
/-- Scaling every matrix entry gives the triangle cubic weight three in the
matrix. -/
theorem triangleCubic_smul (s : R)
    (C : Matrix (Fin 6) (Fin 6) R) (x : Fin 6 → R) :
    triangleCubic (s • C) x = s ^ 3 * triangleCubic C x := by
  simp [triangleCubic, cubicTerm, triangleSign]
  ring

/-- A nonzero common edge scale does not change the proportionality scalar
between the two cubic shadows. -/
theorem cubicsProportional_smul_iff (s : R) (hs : s ≠ 0)
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R) :
    CubicsProportional (s • C) mu ↔ CubicsProportional C mu := by
  constructor <;> intro h x
  · have hx := h x
    rw [matchingEvaluation_smul, triangleCubic_smul] at hx
    apply mul_left_cancel₀ (pow_ne_zero 3 hs)
    simpa [mul_assoc, mul_left_comm] using hx
  · rw [matchingEvaluation_smul, triangleCubic_smul, h x]
    ring

/-- Nonzero proportionality transfers affine translation invariance from the
commutator-Pfaffian cubic to the triangle cubic. -/
theorem triangleCubic_translate_of_proportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R)
    (hmu : mu ≠ 0) (hprop : CubicsProportional C mu)
    (x : Fin 6 → R) (t : R) :
    triangleCubic C (fun i => x i + t) = triangleCubic C x := by
  apply mul_left_cancel₀ hmu
  rw [← hprop, matchingEvaluation_translate, hprop]

/-- The coordinate vector supported at one of the six labels. -/
def coordinateBump (i : Fin 6) : Fin 6 → R :=
  fun k => if k = i then 1 else 0

/-- The sum of the two coordinate vectors supported at a pair of labels. -/
def pairBump (i j : Fin 6) : Fin 6 → R :=
  fun k => coordinateBump i k + coordinateBump j k

/-- The mixed finite difference of the triangle cubic at the all-one vector
in two coordinate directions. -/
def triangleMixedDifference (C : Matrix (Fin 6) (Fin 6) R)
    (i j : Fin 6) : R :=
  triangleCubic C (fun k => pairBump i j k + 1) -
    triangleCubic C (fun k => coordinateBump i k + 1) -
    triangleCubic C (fun k => coordinateBump j k + 1) +
    triangleCubic C (fun _ => 1)

private def vertexIncidence (i a b c : Fin 6) : R :=
  (if a = i then 1 else 0) + (if b = i then 1 else 0) +
    (if c = i then 1 else 0)

private def pairIncidence (i j a b c : Fin 6) : R :=
  vertexIncidence i a b c * vertexIncidence j a b c

private def pairCoefficientTable (C : Matrix (Fin 6) (Fin 6) R)
    (i j : Fin 6) : R :=
  triangleSign C 0 1 2 * pairIncidence i j 0 1 2 +
  triangleSign C 0 1 3 * pairIncidence i j 0 1 3 +
  triangleSign C 0 1 4 * pairIncidence i j 0 1 4 +
  triangleSign C 0 1 5 * pairIncidence i j 0 1 5 +
  triangleSign C 0 2 3 * pairIncidence i j 0 2 3 +
  triangleSign C 0 2 4 * pairIncidence i j 0 2 4 +
  triangleSign C 0 2 5 * pairIncidence i j 0 2 5 +
  triangleSign C 0 3 4 * pairIncidence i j 0 3 4 +
  triangleSign C 0 3 5 * pairIncidence i j 0 3 5 +
  triangleSign C 0 4 5 * pairIncidence i j 0 4 5 +
  triangleSign C 1 2 3 * pairIncidence i j 1 2 3 +
  triangleSign C 1 2 4 * pairIncidence i j 1 2 4 +
  triangleSign C 1 2 5 * pairIncidence i j 1 2 5 +
  triangleSign C 1 3 4 * pairIncidence i j 1 3 4 +
  triangleSign C 1 3 5 * pairIncidence i j 1 3 5 +
  triangleSign C 1 4 5 * pairIncidence i j 1 4 5 +
  triangleSign C 2 3 4 * pairIncidence i j 2 3 4 +
  triangleSign C 2 3 5 * pairIncidence i j 2 3 5 +
  triangleSign C 2 4 5 * pairIncidence i j 2 4 5 +
  triangleSign C 3 4 5 * pairIncidence i j 3 4 5

omit [IsDomain R] in
private theorem cubicTerm_mixedDifference
    (C : Matrix (Fin 6) (Fin 6) R)
    (i j a b c : Fin 6) (hij : i ≠ j)
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    cubicTerm C (fun k => pairBump i j k + 1) a b c -
      cubicTerm C (fun k => coordinateBump i k + 1) a b c -
      cubicTerm C (fun k => coordinateBump j k + 1) a b c +
      cubicTerm C (fun _ => 1) a b c =
        triangleSign C a b c * pairIncidence i j a b c := by
  classical
  simp only [cubicTerm, pairBump, coordinateBump, pairIncidence,
    vertexIncidence]
  split_ifs <;> simp_all <;> ring

omit [IsDomain R] in
private theorem triangleMixedDifference_eq_pairCoefficientTable
    (C : Matrix (Fin 6) (Fin 6) R) (i j : Fin 6) (hij : i ≠ j) :
    triangleMixedDifference C i j = pairCoefficientTable C i j := by
  have h012 := cubicTerm_mixedDifference C i j 0 1 2 hij
    (by decide) (by decide) (by decide)
  have h013 := cubicTerm_mixedDifference C i j 0 1 3 hij
    (by decide) (by decide) (by decide)
  have h014 := cubicTerm_mixedDifference C i j 0 1 4 hij
    (by decide) (by decide) (by decide)
  have h015 := cubicTerm_mixedDifference C i j 0 1 5 hij
    (by decide) (by decide) (by decide)
  have h023 := cubicTerm_mixedDifference C i j 0 2 3 hij
    (by decide) (by decide) (by decide)
  have h024 := cubicTerm_mixedDifference C i j 0 2 4 hij
    (by decide) (by decide) (by decide)
  have h025 := cubicTerm_mixedDifference C i j 0 2 5 hij
    (by decide) (by decide) (by decide)
  have h034 := cubicTerm_mixedDifference C i j 0 3 4 hij
    (by decide) (by decide) (by decide)
  have h035 := cubicTerm_mixedDifference C i j 0 3 5 hij
    (by decide) (by decide) (by decide)
  have h045 := cubicTerm_mixedDifference C i j 0 4 5 hij
    (by decide) (by decide) (by decide)
  have h123 := cubicTerm_mixedDifference C i j 1 2 3 hij
    (by decide) (by decide) (by decide)
  have h124 := cubicTerm_mixedDifference C i j 1 2 4 hij
    (by decide) (by decide) (by decide)
  have h125 := cubicTerm_mixedDifference C i j 1 2 5 hij
    (by decide) (by decide) (by decide)
  have h134 := cubicTerm_mixedDifference C i j 1 3 4 hij
    (by decide) (by decide) (by decide)
  have h135 := cubicTerm_mixedDifference C i j 1 3 5 hij
    (by decide) (by decide) (by decide)
  have h145 := cubicTerm_mixedDifference C i j 1 4 5 hij
    (by decide) (by decide) (by decide)
  have h234 := cubicTerm_mixedDifference C i j 2 3 4 hij
    (by decide) (by decide) (by decide)
  have h235 := cubicTerm_mixedDifference C i j 2 3 5 hij
    (by decide) (by decide) (by decide)
  have h245 := cubicTerm_mixedDifference C i j 2 4 5 hij
    (by decide) (by decide) (by decide)
  have h345 := cubicTerm_mixedDifference C i j 3 4 5 hij
    (by decide) (by decide) (by decide)
  unfold triangleMixedDifference triangleCubic pairCoefficientTable
  linear_combination h012 + h013 + h014 + h015 + h023 + h024 + h025 +
    h034 + h035 + h045 + h123 + h124 + h125 + h134 + h135 + h145 +
    h234 + h235 + h245 + h345

omit [IsDomain R] in
/-- For a symmetric zero-diagonal order-six matrix, the mixed coefficient of
the triangle cubic in two distinct coordinate directions is the sum of the
four triangle products through that pair. -/
theorem triangleMixedDifference_eq_pairTriangleSum
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (i j : Fin 6) (hij : i ≠ j) :
    triangleMixedDifference C i j = pairTriangleSum C i j := by
  rw [triangleMixedDifference_eq_pairCoefficientTable C i j hij]
  have hs : ∀ a b, C a b = C b a := by
    intro a b
    simpa [Matrix.transpose_apply] using
      congrArg (fun M : Matrix (Fin 6) (Fin 6) R => M b a) hsymm
  have h10 := hs 1 0
  have h20 := hs 2 0
  have h21 := hs 2 1
  have h30 := hs 3 0
  have h31 := hs 3 1
  have h32 := hs 3 2
  have h40 := hs 4 0
  have h41 := hs 4 1
  have h42 := hs 4 2
  have h43 := hs 4 3
  have h50 := hs 5 0
  have h51 := hs 5 1
  have h52 := hs 5 2
  have h53 := hs 5 3
  have h54 := hs 5 4
  fin_cases i <;> fin_cases j <;>
    simp only [Fin.mk.injEq, OfNat.ofNat, ne_eq, not_true_eq_false] at hij
  all_goals
    simp [pairCoefficientTable, pairIncidence, vertexIncidence,
      pairTriangleSum, Fin.sum_univ_succ, triangleSign, hdiag, h10, h20, h21,
      h30, h31, h32, h40, h41, h42, h43, h50, h51, h52, h53, h54]
    ring

omit [IsDomain R] in
private theorem triangleCubic_coordinateBump_eq_zero
    (C : Matrix (Fin 6) (Fin 6) R) (i : Fin 6) :
    triangleCubic C (coordinateBump i) = 0 := by
  fin_cases i <;>
    simp [triangleCubic, cubicTerm, coordinateBump]

omit [IsDomain R] in
private theorem triangleCubic_pairBump_eq_zero
    (C : Matrix (Fin 6) (Fin 6) R) (i j : Fin 6) (hij : i ≠ j) :
    triangleCubic C (pairBump i j) = 0 := by
  fin_cases i <;> fin_cases j <;>
    simp_all [triangleCubic, cubicTerm, pairBump, coordinateBump]

omit [IsDomain R] in
/-- Translation invariance of the triangle cubic makes every pair moment
vanish.  The four translated sparse vectors implement the mixed finite
difference which extracts the coefficient through the chosen pair. -/
theorem pairTriangleSum_eq_zero_of_triangleCubic_translate
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (htranslate : ∀ (x : Fin 6 → R) (t : R),
      triangleCubic C (fun i => x i + t) = triangleCubic C x)
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j = 0 := by
  rw [← triangleMixedDifference_eq_pairTriangleSum C hsymm hdiag i j hij]
  have hone : triangleCubic C (fun _ : Fin 6 => (1 : R)) = 0 := by
    have h := htranslate (fun _ => (0 : R)) 1
    simpa [triangleCubic, cubicTerm] using h
  simp only [triangleMixedDifference, htranslate (pairBump i j) 1,
    htranslate (coordinateBump i) 1, htranslate (coordinateBump j) 1, hone,
    triangleCubic_pairBump_eq_zero C i j hij,
    triangleCubic_coordinateBump_eq_zero C i,
    triangleCubic_coordinateBump_eq_zero C j]
  ring

/-- Nonzero proportionality of the two cubic shadows forces all pair moments
of a zero-diagonal matrix to vanish. -/
theorem pairTriangleSum_eq_zero_of_cubicsProportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (hmu : mu ≠ 0) (hprop : CubicsProportional C mu)
    (i j : Fin 6) (hij : i ≠ j) :
    pairTriangleSum C i j = 0 := by
  apply pairTriangleSum_eq_zero_of_triangleCubic_translate C hsymm hdiag _ i j hij
  exact triangleCubic_translate_of_proportional C mu hmu hprop

/-- For a symmetric matrix with nonzero off-diagonal entries whose pair
moments all vanish, each off-diagonal entry of the square is zero.  The pair
moment through a pair equals the joining edge times that entry of the square,
so the domain hypothesis removes the edge factor. -/
theorem mul_self_apply_eq_zero_of_pairBalance
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hedge : ∀ i j, i ≠ j → C i j ≠ 0)
    (hbalance : ∀ i j, i ≠ j → pairTriangleSum C i j = 0)
    (i j : Fin 6) (hij : i ≠ j) :
    (C * C) i j = 0 := by
  have hmoment := pairTriangleSum_eq_mul_mulApply C hsymm i j
  rw [hbalance i j hij] at hmoment
  exact (mul_eq_zero.mp hmoment.symm).resolve_left (hedge i j hij)

omit [IsDomain R] in
private theorem matrix_eq_diagonal_of_offDiagonal_zero
    (D : Matrix (Fin 6) (Fin 6) R)
    (hoff : ∀ i j, i ≠ j → D i j = 0) :
    D = Matrix.diagonal (fun i => D i i) := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp
  · simp [hij, hoff i j hij]

/-- An order-six matrix over an integral domain whose off-diagonal entries are
all nonzero and whose square is diagonal has scalar square.  Symmetry and a
vanishing diagonal are not needed: the hypotheses are exactly that every
off-diagonal entry of `C` is nonzero and every off-diagonal entry of `C * C`
vanishes.  Associativity gives `C * (C * C) = (C * C) * C`, and cancelling the
nonzero entry `C 0 i` in the corresponding entry of that identity equates the
diagonal entries of `C * C`. -/
theorem exists_scalar_mul_self_of_offDiagonal_zero
    (C : Matrix (Fin 6) (Fin 6) R)
    (hedge : ∀ i j, i ≠ j → C i j ≠ 0)
    (hoff : ∀ i j, i ≠ j → (C * C) i j = 0) :
    ∃ lambda : R, C * C = lambda • (1 : Matrix (Fin 6) (Fin 6) R) := by
  have hdiagD : C * C = Matrix.diagonal (fun i => (C * C) i i) :=
    matrix_eq_diagonal_of_offDiagonal_zero (C * C) hoff
  have hcomm : C * (C * C) = (C * C) * C := by
    simp only [Matrix.mul_assoc]
  have hdiag_eq : ∀ i, (C * C) i i = (C * C) 0 0 := by
    intro i
    by_cases hi : i = 0
    · rw [hi]
    · have hentry := congrArg (fun M : Matrix (Fin 6) (Fin 6) R => M 0 i) hcomm
      rw [hdiagD] at hentry
      simp only [Matrix.mul_diagonal, Matrix.diagonal_mul] at hentry
      exact mul_left_cancel₀ (hedge 0 i (Ne.symm hi)) (by rw [hentry]; ring)
  refine ⟨(C * C) 0 0, ?_⟩
  ext i j
  by_cases hij : i = j
  · subst j
    simpa [Matrix.one_apply_eq] using hdiag_eq i
  · simp [hij, hoff i j hij]

/-- For a symmetric zero-diagonal order-six matrix with nonzero edges,
nonzero proportionality between the commutator-Pfaffian cubic and the
triangle cubic forces a scalar quadratic equation. -/
theorem exists_mul_self_eq_scalar_of_cubicsProportional
    (C : Matrix (Fin 6) (Fin 6) R) (mu : R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (hedge : ∀ i j, i ≠ j → C i j ≠ 0)
    (hmu : mu ≠ 0) (hprop : CubicsProportional C mu) :
    ∃ lambda : R, C * C = lambda • (1 : Matrix (Fin 6) (Fin 6) R) := by
  have hbalance : ∀ i j, i ≠ j → pairTriangleSum C i j = 0 :=
    pairTriangleSum_eq_zero_of_cubicsProportional C mu hsymm hdiag hmu hprop
  apply exists_scalar_mul_self_of_offDiagonal_zero C hedge
  exact mul_self_apply_eq_zero_of_pairBalance C hsymm hedge hbalance

/-- Three integral signs whose sum is again a sign have product equal to the
negative of that sum.  Two of the three signs agree with the sum and the third
is opposite to it. -/
private theorem signTriple_prod_eq_neg_sum (x y z : ℤ)
    (hx : x * x = 1) (hy : y * y = 1) (hz : z * z = 1)
    (hsum : (x + y + z) * (x + y + z) = 1) :
    x * y * z = -(x + y + z) := by
  rcases mul_self_eq_one_iff.mp hx with rfl | rfl <;>
    rcases mul_self_eq_one_iff.mp hy with rfl | rfl <;>
      rcases mul_self_eq_one_iff.mp hz with rfl | rfl <;>
        first
          | (exfalso; norm_num at hsum; done)
          | norm_num

/-- Orthogonality of two rows of a root-normalized signing.  Here `a` is the
sign on the edge joining the two chosen vertices, `b, c, d` and `e, f, g` are
the signs on the edges from those two vertices to the three remaining
vertices in a common order, and `h, i, j` are the signs on the edges among the
remaining three, indexed so that `h`, `i`, `j` avoid `b, e`, then `c, f`, then
`d, g` respectively.

The two vertex balances and the three triple identities force the pair moment
`b * e + c * f + d * g` to equal `-1`.  The argument multiplies the three
opposite-edge identities, uses that a triple of signs summing to a sign has
product the negative of that sum, and then splits on the six derived signs
`a * b`, `a * c`, `a * d`, `b * e`, `c * f`, `d * g`; it does not enumerate the
ten free edge signs. -/
private theorem pairMoment_add_one_eq_zero_of_signBalances
    (a b c d e f g h i j : ℤ)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) (hd : d * d = 1)
    (he : e * e = 1) (hf : f * f = 1) (hg : g * g = 1)
    (hh : h * h = 1) (hi : i * i = 1) (hj : j * j = 1)
    (hp : b + c + d = -a) (hq : e + f + g = -a)
    (hst : j = a + b + e) (hrt : i = a + c + f) (hrs : h = a + d + g) :
    1 + b * e + c * f + d * g = 0 := by
  have hsum3 : h + i + j = a := by linarith
  have hbcd : b * c * d = a := by
    have hs : (b + c + d) * (b + c + d) = 1 := by rw [hp]; linear_combination ha
    have hstep := signTriple_prod_eq_neg_sum b c d hb hc hd hs
    rw [hp] at hstep
    linarith [hstep]
  have hhij : h * i * j = -a := by
    have hs : (h + i + j) * (h + i + j) = 1 := by rw [hsum3]; exact ha
    have hstep := signTriple_prod_eq_neg_sum h i j hh hi hj hs
    rw [hsum3] at hstep
    exact hstep
  have hbj : b * j = a * b + 1 + b * e := by rw [hst]; linear_combination hb
  have hci : c * i = a * c + 1 + c * f := by rw [hrt]; linear_combination hc
  have hdh : d * h = a * d + 1 + d * g := by rw [hrs]; linear_combination hd
  have hprod : (a * b + 1 + b * e) * (a * c + 1 + c * f) *
      (a * d + 1 + d * g) = -1 := by
    rw [← hbj, ← hci, ← hdh]
    have hre : b * j * (c * i) * (d * h) = b * c * d * (h * i * j) := by ring
    rw [hre, hbcd, hhij]
    linear_combination -ha
  have hm : a * b + a * c + a * d = -1 := by linear_combination a * hp - ha
  have hab : a * b * (a * b) = 1 := by linear_combination b * b * ha + hb
  have hac : a * c * (a * c) = 1 := by linear_combination c * c * ha + hc
  have had : a * d * (a * d) = 1 := by linear_combination d * d * ha + hd
  have hbe : b * e * (b * e) = 1 := by linear_combination e * e * hb + he
  have hcf : c * f * (c * f) = 1 := by linear_combination f * f * hc + hf
  have hdg : d * g * (d * g) = 1 := by linear_combination g * g * hd + hg
  rcases mul_self_eq_one_iff.mp hab with hA | hA <;>
    rcases mul_self_eq_one_iff.mp hac with hB | hB <;>
      rcases mul_self_eq_one_iff.mp had with hC | hC <;>
        rcases mul_self_eq_one_iff.mp hbe with hD | hD <;>
          rcases mul_self_eq_one_iff.mp hcf with hE | hE <;>
            rcases mul_self_eq_one_iff.mp hdg with hF | hF <;>
              rw [hA, hB, hC, hD, hE, hF] at hprod <;>
                rw [hA, hB, hC] at hm <;>
                  rw [hD, hE, hF] <;>
                    first
                      | (exfalso; omega)
                      | norm_num

private theorem five_sign_balances_force_inner_products
    (a b c d e f g h i j : ℤ)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (hd : d * d = 1) (he : e * e = 1) (hf : f * f = 1)
    (hg : g * g = 1) (hh : h * h = 1) (hi : i * i = 1)
    (hj : j * j = 1)
    (r1 : a + b + c + d = 0)
    (r2 : a + e + f + g = 0)
    (r3 : b + e + h + i = 0)
    (r4 : c + f + h + j = 0)
    (r5 : d + g + i + j = 0) :
    1 + b * e + c * f + d * g = 0 ∧
    1 + a * e + c * h + d * i = 0 ∧
    1 + a * f + b * h + d * j = 0 ∧
    1 + a * g + b * i + c * j = 0 ∧
    1 + a * b + f * h + g * i = 0 ∧
    1 + a * c + e * h + g * j = 0 ∧
    1 + a * d + e * i + f * j = 0 ∧
    1 + b * c + e * f + i * j = 0 ∧
    1 + b * d + e * g + h * j = 0 ∧
    1 + c * d + f * g + h * i = 0 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact pairMoment_add_one_eq_zero_of_signBalances a b c d e f g h i j
      ha hb hc hd he hf hg hh hi hj (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances b a c d e h i f g j
      hb ha hc hd he hh hi hf hg hj (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances c a b d f h j e g i
      hc ha hb hd hf hh hj he hg hi (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances d a b c g i j e f h
      hd ha hb hc hg hi hj he hf hh (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances e a f g b h i c d j
      he ha hf hg hb hh hi hc hd hj (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances f a e g c h j b d i
      hf ha he hg hc hh hj hb hd hi (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances g a e f d i j b c h
      hg ha he hf hd hi hj hb hc hh (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances h b e i c f j a d g
      hh hb he hi hc hf hj ha hd hg (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances i b e h d g j a c f
      hi hb he hh hd hg hj ha hc hf (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)
  · exact pairMoment_add_one_eq_zero_of_signBalances j c f h d g i a b e
      hj hc hf hh hd hg hi ha hb he (by linarith) (by linarith) (by linarith)
      (by linarith) (by linarith)

/-- The integral sign represented by a Boolean edge bit.  `false` denotes a
positive edge and `true` a negative edge. -/
def boolSign (b : Bool) : ℤ := if b then -1 else 1

private theorem boolSign_false : boolSign false = 1 := rfl

private theorem boolSign_true : boolSign true = -1 := rfl

/-- A root-normalized symmetric sign matrix.  The ten Boolean parameters are
the edges `12,13,14,15,23,24,25,34,35,45`, in that order. -/
def normalizedSignMatrix (bits : Fin 10 → Bool) : Matrix (Fin 6) (Fin 6) ℤ :=
  !![0, 1, 1, 1, 1, 1;
     1, 0, boolSign (bits 0), boolSign (bits 1), boolSign (bits 2), boolSign (bits 3);
     1, boolSign (bits 0), 0, boolSign (bits 4), boolSign (bits 5), boolSign (bits 6);
     1, boolSign (bits 1), boolSign (bits 4), 0, boolSign (bits 7), boolSign (bits 8);
     1, boolSign (bits 2), boolSign (bits 5), boolSign (bits 7), 0, boolSign (bits 9);
     1, boolSign (bits 3), boolSign (bits 6), boolSign (bits 8), boolSign (bits 9), 0]

/-- The five root-pair moments used by the normalized recognition packet. -/
def FirstRowBalanced (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  ∀ i, i ≠ 0 → pairTriangleSum C 0 i = 0

/-- The positive graph away from the normalized root has degree two at every
vertex.  A simple two-regular graph on five vertices is a pentagon, so this is
the labelled gauge form of the pentagon classification. -/
def PentagonGauge (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  (∀ i, i ≠ 0 → C 0 i = 1) ∧
  ∀ i, i ≠ 0 →
    ((Finset.univ.filter fun j : Fin 6 => j ≠ 0 ∧ j ≠ i ∧ C i j = 1).card = 2)

/-- Four edge signs sum to zero exactly when two of them are positive and two
are negative.  The six listed patterns are the six ways of choosing which two
of the four edges at a vertex are positive. -/
private theorem four_bool_sum_zero_cases (a b c d : Bool)
    (hsum : boolSign a + boolSign b + boolSign c + boolSign d = 0) :
    (a = false ∧ b = false ∧ c = true ∧ d = true) ∨
    (a = false ∧ b = true ∧ c = false ∧ d = true) ∨
    (a = false ∧ b = true ∧ c = true ∧ d = false) ∨
    (a = true ∧ b = false ∧ c = false ∧ d = true) ∨
    (a = true ∧ b = false ∧ c = true ∧ d = false) ∨
    (a = true ∧ b = true ∧ c = false ∧ d = false) := by
  revert hsum
  cases a <;> cases b <;> cases c <;> cases d <;> decide

/-- The five root-pair balances put every root-normalized signing in pentagon
gauge.  Each vertex away from the root contributes its own four incident
signs, so the four Boolean parameters of that row alone decide its positive
degree. -/
theorem pentagonGauge_of_firstRowBalanced (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    PentagonGauge (normalizedSignMatrix bits) := by
  refine ⟨?_, ?_⟩
  · intro i hi
    fin_cases i <;> simp_all [normalizedSignMatrix]
  · intro i hi
    fin_cases i
    · exact absurd rfl hi
    · have hb := hbalance 1 (by decide)
      revert hb
      cases h0 : bits 0 <;> cases h1 : bits 1 <;> cases h2 : bits 2 <;>
        cases h3 : bits 3 <;>
          simp [pairTriangleSum, triangleSign,
            normalizedSignMatrix, boolSign, h0, h1, h2, h3,
            Fin.sum_univ_succ] <;>
          decide
    · have hb := hbalance 2 (by decide)
      revert hb
      cases h0 : bits 0 <;> cases h4 : bits 4 <;> cases h5 : bits 5 <;>
        cases h6 : bits 6 <;>
          simp [pairTriangleSum, triangleSign,
            normalizedSignMatrix, boolSign, h0, h4, h5, h6,
            Fin.sum_univ_succ] <;>
          decide
    · have hb := hbalance 3 (by decide)
      revert hb
      cases h1 : bits 1 <;> cases h4 : bits 4 <;> cases h7 : bits 7 <;>
        cases h8 : bits 8 <;>
          simp [pairTriangleSum, triangleSign,
            normalizedSignMatrix, boolSign, h1, h4, h7, h8,
            Fin.sum_univ_succ] <;>
          decide
    · have hb := hbalance 4 (by decide)
      revert hb
      cases h2 : bits 2 <;> cases h5 : bits 5 <;> cases h7 : bits 7 <;>
        cases h9 : bits 9 <;>
          simp [pairTriangleSum, triangleSign,
            normalizedSignMatrix, boolSign, h2, h5, h7, h9,
            Fin.sum_univ_succ] <;>
          decide
    · have hb := hbalance 5 (by decide)
      revert hb
      cases h3 : bits 3 <;> cases h6 : bits 6 <;> cases h8 : bits 8 <;>
        cases h9 : bits 9 <;>
          simp [pairTriangleSum, triangleSign,
            normalizedSignMatrix, boolSign, h3, h6, h8, h9,
            Fin.sum_univ_succ] <;>
          decide

/-- The five root-pair balances of a root-normalized signing, written as five
linear equations in the ten edge signs.  The `i`-th equation collects the four
edges joining the non-root vertex `i` to the other four non-root vertices, so
it says that `i` carries as many positive as negative such edges. -/
private theorem firstRowBalanced_rowSums (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    boolSign (bits 0) + boolSign (bits 1) + boolSign (bits 2) +
        boolSign (bits 3) = 0 ∧
      boolSign (bits 0) + boolSign (bits 4) + boolSign (bits 5) +
        boolSign (bits 6) = 0 ∧
      boolSign (bits 1) + boolSign (bits 4) + boolSign (bits 7) +
        boolSign (bits 8) = 0 ∧
      boolSign (bits 2) + boolSign (bits 5) + boolSign (bits 7) +
        boolSign (bits 9) = 0 ∧
      boolSign (bits 3) + boolSign (bits 6) + boolSign (bits 8) +
        boolSign (bits 9) = 0 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · have hb := hbalance 1 (by decide)
    simp [pairTriangleSum, triangleSign,
      normalizedSignMatrix, Fin.sum_univ_succ] at hb
    linarith
  · have hb := hbalance 2 (by decide)
    simp [pairTriangleSum, triangleSign,
      normalizedSignMatrix, Fin.sum_univ_succ] at hb
    linarith
  · have hb := hbalance 3 (by decide)
    simp [pairTriangleSum, triangleSign,
      normalizedSignMatrix, Fin.sum_univ_succ] at hb
    linarith
  · have hb := hbalance 4 (by decide)
    simp [pairTriangleSum, triangleSign,
      normalizedSignMatrix, Fin.sum_univ_succ] at hb
    linarith
  · have hb := hbalance 5 (by decide)
    simp [pairTriangleSum, triangleSign,
      normalizedSignMatrix, Fin.sum_univ_succ] at hb
    linarith

/-- The pentagon balance equations imply the conference square by ten
symbolic inner-product identities.  This is the structural converse; it does
not enumerate the `2^10` normalized signings. -/
theorem normalizedSignMatrix_sq_of_firstRowBalanced (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    normalizedSignMatrix bits * normalizedSignMatrix bits =
      5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  have hsq : ∀ k, boolSign (bits k) * boolSign (bits k) = 1 := by
    intro k
    cases bits k <;> simp [boolSign]
  obtain ⟨hr1, hr2, hr3, hr4, hr5⟩ := firstRowBalanced_rowSums bits hbalance
  obtain ⟨h12, h13, h14, h15, h23, h24, h25, h34, h35, h45⟩ :=
    five_sign_balances_force_inner_products (boolSign (bits 0))
      (boolSign (bits 1)) (boolSign (bits 2)) (boolSign (bits 3))
      (boolSign (bits 4)) (boolSign (bits 5)) (boolSign (bits 6))
      (boolSign (bits 7)) (boolSign (bits 8)) (boolSign (bits 9))
      (hsq 0) (hsq 1) (hsq 2) (hsq 3) (hsq 4) (hsq 5) (hsq 6) (hsq 7) (hsq 8)
      (hsq 9) hr1 hr2 hr3 hr4 hr5
  ext p q
  fin_cases p <;> fin_cases q <;>
    simp [Matrix.mul_apply, Fin.sum_univ_succ, normalizedSignMatrix] <;>
    linarith [hsq 0, hsq 1, hsq 2, hsq 3, hsq 4, hsq 5, hsq 6, hsq 7, hsq 8,
      hsq 9, h12, h13, h14, h15, h23, h24, h25, h34, h35, h45, hr1, hr2, hr3,
      hr4, hr5]

/-- The coefficient of `x₀x₁x₂` in the commutator-Pfaffian cubic, in the Hodge
orientation fixed by the bracket expansion.  It is the negative of the
determinant of the lower-left three-by-three block of `C`, expanded here along
the first row of that block. -/
def shadowCoefficient012 (C : Matrix (Fin 6) (Fin 6) ℤ) : ℤ :=
  C 3 1 * (C 4 0 * C 5 2 - C 4 2 * C 5 0) -
  C 3 0 * (C 4 1 * C 5 2 - C 4 2 * C 5 1) -
  C 3 2 * (C 4 0 * C 5 1 - C 4 1 * C 5 0)

/-- One coefficient fixes the positive Hodge orientation in the normalized
six-test packet. -/
def PositiveOrientation012 (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  shadowCoefficient012 C = 4 * triangleSign C 0 1 2

/-- One coefficient fixes the opposite Hodge orientation in the normalized
six-test packet. -/
def NegativeOrientation012 (C : Matrix (Fin 6) (Fin 6) ℤ) : Prop :=
  shadowCoefficient012 C = -4 * triangleSign C 0 1 2

/-- The twelve labelled pentagons, read off from the five vertex balances.
The ten Boolean parameters are the edges `12,13,14,15,23,24,25,34,35,45`, in
that order, with `true` a negative edge, and the five hypotheses are the vertex
balances at `1,2,3,4,5`.  Splitting the four edges at vertex `1` into the six
patterns with two positive edges leaves six branches; in each of them the four
remaining balances determine the six remaining edge parameters, and that step
is checked by kernel reduction over those `2^6` assignments. -/
private theorem pentagon_bit_classification
    (b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 : Bool)
    (r1 : boolSign b0 + boolSign b1 + boolSign b2 + boolSign b3 = 0)
    (r2 : boolSign b0 + boolSign b4 + boolSign b5 + boolSign b6 = 0)
    (r3 : boolSign b1 + boolSign b4 + boolSign b7 + boolSign b8 = 0)
    (r4 : boolSign b2 + boolSign b5 + boolSign b7 + boolSign b9 = 0)
    (r5 : boolSign b3 + boolSign b6 + boolSign b8 + boolSign b9 = 0) :
    (b0 = false ∧ b1 = false ∧ b2 = true ∧ b3 = true ∧ b4 = true ∧
      b5 = false ∧ b6 = true ∧ b7 = true ∧ b8 = false ∧ b9 = false) ∨
    (b0 = false ∧ b1 = false ∧ b2 = true ∧ b3 = true ∧ b4 = true ∧
      b5 = true ∧ b6 = false ∧ b7 = false ∧ b8 = true ∧ b9 = false) ∨
    (b0 = false ∧ b1 = true ∧ b2 = false ∧ b3 = true ∧ b4 = false ∧
      b5 = true ∧ b6 = true ∧ b7 = true ∧ b8 = false ∧ b9 = false) ∨
    (b0 = false ∧ b1 = true ∧ b2 = false ∧ b3 = true ∧ b4 = true ∧
      b5 = true ∧ b6 = false ∧ b7 = false ∧ b8 = false ∧ b9 = true) ∨
    (b0 = false ∧ b1 = true ∧ b2 = true ∧ b3 = false ∧ b4 = false ∧
      b5 = true ∧ b6 = true ∧ b7 = false ∧ b8 = true ∧ b9 = false) ∨
    (b0 = false ∧ b1 = true ∧ b2 = true ∧ b3 = false ∧ b4 = true ∧
      b5 = false ∧ b6 = true ∧ b7 = false ∧ b8 = false ∧ b9 = true) ∨
    (b0 = true ∧ b1 = false ∧ b2 = false ∧ b3 = true ∧ b4 = false ∧
      b5 = true ∧ b6 = false ∧ b7 = true ∧ b8 = true ∧ b9 = false) ∨
    (b0 = true ∧ b1 = false ∧ b2 = false ∧ b3 = true ∧ b4 = true ∧
      b5 = false ∧ b6 = false ∧ b7 = true ∧ b8 = false ∧ b9 = true) ∨
    (b0 = true ∧ b1 = false ∧ b2 = true ∧ b3 = false ∧ b4 = false ∧
      b5 = false ∧ b6 = true ∧ b7 = true ∧ b8 = true ∧ b9 = false) ∨
    (b0 = true ∧ b1 = false ∧ b2 = true ∧ b3 = false ∧ b4 = true ∧
      b5 = false ∧ b6 = false ∧ b7 = false ∧ b8 = true ∧ b9 = true) ∨
    (b0 = true ∧ b1 = true ∧ b2 = false ∧ b3 = false ∧ b4 = false ∧
      b5 = false ∧ b6 = true ∧ b7 = true ∧ b8 = false ∧ b9 = true) ∨
    (b0 = true ∧ b1 = true ∧ b2 = false ∧ b3 = false ∧ b4 = false ∧
      b5 = true ∧ b6 = false ∧ b7 = false ∧ b8 = true ∧ b9 = true) := by
  rcases four_bool_sum_zero_cases b0 b1 b2 b3 r1 with
    ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ |
    ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ | ⟨rfl, rfl, rfl, rfl⟩ <;>
  cases b4 <;> cases b5 <;> cases b6 <;> cases b7 <;> cases b8 <;> cases b9 <;>
  simp only [boolSign_false, boolSign_true] at r2 r3 r4 r5 <;>
  first
    | omega
    | simp

private theorem orientation012_disjoint (bits : Fin 10 → Bool) :
    ¬(PositiveOrientation012 (normalizedSignMatrix bits) ∧
      NegativeOrientation012 (normalizedSignMatrix bits)) := by
  rintro ⟨hpos, hneg⟩
  have hsign : triangleSign (normalizedSignMatrix bits) 0 1 2 ≠ 0 := by
    cases h0 : bits 0 <;>
      simp [triangleSign, normalizedSignMatrix, boolSign, h0]
  simp only [PositiveOrientation012] at hpos
  simp only [NegativeOrientation012] at hneg
  exact hsign (by linarith)

/-- Every root-normalized signing whose five root-pair moments vanish
satisfies the full cubic identity, with proportionality scalar `4` or `-4`,
and its `x₀x₁x₂` coefficient records which of the two scalars occurs.  The
five balances put the signing in pentagon gauge and single out the twelve
labelled pentagons; each of them then yields one polynomial identity in the
six coordinates and one integer coefficient comparison. -/
private theorem cubicsProportional_orientation_of_firstRowBalanced
    (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    (CubicsProportional (normalizedSignMatrix bits) 4 ∧
        PositiveOrientation012 (normalizedSignMatrix bits)) ∨
      (CubicsProportional (normalizedSignMatrix bits) (-4) ∧
        NegativeOrientation012 (normalizedSignMatrix bits)) := by
  obtain ⟨hr1, hr2, hr3, hr4, hr5⟩ := firstRowBalanced_rowSums bits hbalance
  rcases pentagon_bit_classification (bits 0) (bits 1) (bits 2) (bits 3)
      (bits 4) (bits 5) (bits 6) (bits 7) (bits 8) (bits 9)
      hr1 hr2 hr3 hr4 hr5 with
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩ |
    ⟨h0, h1, h2, h3, h4, h5, h6, h7, h8, h9⟩
  · refine Or.inr ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [NegativeOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inl ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [PositiveOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inl ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [PositiveOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inr ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [NegativeOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inr ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [NegativeOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inl ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [PositiveOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inr ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [NegativeOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inl ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [PositiveOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inl ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [PositiveOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inr ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [NegativeOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inr ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [NegativeOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]
  · refine Or.inl ⟨?_, ?_⟩
    · intro x
      simp [matchingEvaluation, GoldenMatchingCubics.bracket, triangleCubic,
        cubicTerm, triangleSign, normalizedSignMatrix, boolSign,
        h0, h1, h2, h3, h4, h5, h6, h7, h8, h9]
      ring
    · simp [PositiveOrientation012, shadowCoefficient012, triangleSign,
        normalizedSignMatrix, boolSign, h0, h1, h2, h3, h4, h5, h6, h7,
        h8, h9]

private theorem orientation012_of_firstRowBalanced (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
    PositiveOrientation012 (normalizedSignMatrix bits) ∨
      NegativeOrientation012 (normalizedSignMatrix bits) := by
  rcases cubicsProportional_orientation_of_firstRowBalanced bits hbalance with
    h | h
  · exact Or.inl h.2
  · exact Or.inr h.2

/-- Five root-pair balances and the `x₀x₁x₂` coefficient with positive Hodge
orientation force the complete cubic identity.  The balances put the signing
in pentagon gauge, and the coefficient selects the orientation among the
twelve labelled pentagons. -/
theorem cubicsProportional_four_of_sixTests (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits))
    (horientation : PositiveOrientation012 (normalizedSignMatrix bits)) :
    CubicsProportional (normalizedSignMatrix bits) 4 := by
  rcases cubicsProportional_orientation_of_firstRowBalanced bits hbalance with
    h | h
  · exact h.1
  · exact absurd ⟨horientation, h.2⟩ (orientation012_disjoint bits)

/-- The same recognition packet with the opposite coefficient orientation
forces the cubic proportionality scalar `-4`. -/
theorem cubicsProportional_neg_four_of_sixTests (bits : Fin 10 → Bool)
    (hbalance : FirstRowBalanced (normalizedSignMatrix bits))
    (horientation : NegativeOrientation012 (normalizedSignMatrix bits)) :
    CubicsProportional (normalizedSignMatrix bits) (-4) := by
  rcases cubicsProportional_orientation_of_firstRowBalanced bits hbalance with
    h | h
  · exact absurd ⟨h.2, horientation⟩ (orientation012_disjoint bits)
  · exact h.1

/-- On normalized scalar sign matrices, nonzero proportionality of the two
cubic shadows is equivalent to the conference square.  The two possible
proportionality scalars are the two Hodge orientations. -/
theorem exists_nonzero_cubicsProportional_iff_conferenceSquare
    (bits : Fin 10 → Bool) :
    (∃ mu : ℤ, mu ≠ 0 ∧ CubicsProportional (normalizedSignMatrix bits) mu) ↔
      normalizedSignMatrix bits * normalizedSignMatrix bits =
        5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  constructor
  · rintro ⟨mu, hmu, hprop⟩
    apply normalizedSignMatrix_sq_of_firstRowBalanced bits
    intro i hi
    exact pairTriangleSum_eq_zero_of_cubicsProportional
      (normalizedSignMatrix bits) mu (by
        ext p q
        fin_cases p <;> fin_cases q <;> rfl) (by
        intro k
        fin_cases k <;> rfl) hmu hprop 0 i (Ne.symm hi)
  · intro hsq
    have hsymm : (normalizedSignMatrix bits).transpose = normalizedSignMatrix bits := by
      ext i j
      fin_cases i <;> fin_cases j <;> rfl
    have hbalance : FirstRowBalanced (normalizedSignMatrix bits) := by
      intro i hi
      exact pairTriangleSum_eq_zero (normalizedSignMatrix bits) 5 hsymm hsq 0 i
        (Ne.symm hi)
    rcases orientation012_of_firstRowBalanced bits hbalance with hpos | hneg
    · exact ⟨4, by norm_num, cubicsProportional_four_of_sixTests bits hbalance hpos⟩
    · exact ⟨-4, by norm_num, cubicsProportional_neg_four_of_sixTests bits hbalance hneg⟩

/-- The normalized conference-square characterization is unchanged after
multiplying every edge by one nonzero integral scalar. -/
theorem exists_nonzero_cubicsProportional_smul_iff_conferenceSquare
    (bits : Fin 10 → Bool) (s : ℤ) (hs : s ≠ 0) :
    (∃ mu : ℤ, mu ≠ 0 ∧
      CubicsProportional (s • normalizedSignMatrix bits) mu) ↔
      normalizedSignMatrix bits * normalizedSignMatrix bits =
        5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  rw [← exists_nonzero_cubicsProportional_iff_conferenceSquare bits]
  constructor
  · rintro ⟨mu, hmu, hprop⟩
    exact ⟨mu, hmu, (cubicsProportional_smul_iff s hs _ mu).mp hprop⟩
  · rintro ⟨mu, hmu, hprop⟩
    exact ⟨mu, hmu, (cubicsProportional_smul_iff s hs _ mu).mpr hprop⟩

end RelativeConicArcs.FourShadowRecognition
