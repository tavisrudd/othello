import RelativeConicArcs.GoldenCubicNodeElimination

/-!
# Singular cone of the centered Golden cubic

This module classifies the rational zero set of the five gradient quadrics of
the centered Golden orientation cubic.  It is the union of the six lines
through the vectors \(1-6e_i\).  Consequently the associated projective cubic
has exactly the six displayed rational singular points.

The proof uses exact ideal-membership identities from
GoldenCubicNodeElimination; Lean checks those identities by polynomial
normalization.
-/

namespace RelativeConicArcs.GoldenCubicNodes

open GoldenCubicNodesBase
open GoldenCubicNodeElimination

/-- The Golden gradient is homogeneous of degree two. -/
theorem gradient_smul {K : Type*} [CommRing K] (c : K) (x : Fin 5 → K) :
    gradient (c • x) = c^2 • gradient x := by
  funext j
  fin_cases j <;> simp [gradient] <;> ring

private theorem chart_classification
    {K : Type*} [Field K] [CharZero K] (x0 x1 x2 x3 : K)
    (h0 : chartGradient x0 x1 x2 x3 0 = 0)
    (h1 : chartGradient x0 x1 x2 x3 1 = 0)
    (h2 : chartGradient x0 x1 x2 x3 2 = 0)
    (h3 : chartGradient x0 x1 x2 x3 3 = 0)
    (h4 : chartGradient x0 x1 x2 x3 4 = 0) :
    ∃ c : K, ∃ i : Fin 6,
      ![x0, x1, x2, x3, 1] = c • centeredNode i := by
  have hz := x3_factor x0 x1 x2 x3 h0 h1 h2 h3 h4
  have hz' : (x3 - 1) * (x3 + 5) * (5*x3 + 1) = 0 := by
    ring_nf at hz ⊢
    exact hz
  rcases mul_eq_zero.mp hz' with hz' | hz'
  · rcases mul_eq_zero.mp hz' with h31 | h35
    · have h31e : (1 : K) * x3 + (-1) * 1 = 0 := by
        simpa [sub_eq_add_neg] using h31
      have hx2 := x2_factor_of_x3_eq_one x0 x1 x2 x3 h0 h1 h2 h3 h4 h31e
      have hx2' : (x2 - 1) * (x2 + 5) = 0 := by
        ring_nf at hx2 ⊢
        exact hx2
      rcases mul_eq_zero.mp hx2' with h21 | h25
      · have h21e : (1 : K) * x2 + (-1) * 1 = 0 := by
          simpa [sub_eq_add_neg] using h21
        have hx1 :=
          x1_factor_of_x3_x2_eq_one x0 x1 x2 x3 h0 h1 h2 h3 h4 h31e h21e
        have hx1' : (x1 - 1) * (x1 + 5) = 0 := by
          ring_nf at hx1 ⊢
          exact hx1
        rcases mul_eq_zero.mp hx1' with h11 | h15
        · have h11e : (1 : K) * x1 + (-1) * 1 = 0 := by
            simpa [sub_eq_add_neg] using h11
          have hx0 := x0_factor_of_x3_x2_x1_eq_one
            x0 x1 x2 x3 h0 h1 h2 h3 h4 h31e h21e h11e
          have hx0' : (x0 - 1) * (x0 + 5) = 0 := by
            ring_nf at hx0 ⊢
            exact hx0
          rcases mul_eq_zero.mp hx0' with h01 | h05
          · have hx0v : x0 = 1 := by linear_combination h01
            have hx1v : x1 = 1 := by linear_combination h11
            have hx2v : x2 = 1 := by linear_combination h21
            have hx3v : x3 = 1 := by linear_combination h31
            refine ⟨1, 5, ?_⟩
            funext j
            fin_cases j <;> simp [centeredNode, hx0v, hx1v, hx2v, hx3v]
          · have hx0v : x0 = -5 := by linear_combination h05
            have hx1v : x1 = 1 := by linear_combination h11
            have hx2v : x2 = 1 := by linear_combination h21
            have hx3v : x3 = 1 := by linear_combination h31
            refine ⟨1, 0, ?_⟩
            funext j
            fin_cases j <;> simp [centeredNode, hx0v, hx1v, hx2v, hx3v]
        · have hx0 := x0_eq_one_of_x3_x2_one_x1_neg_five
            x0 x1 x2 x3 h0 h1 h2 h3 h4 h31e h21e (by simpa using h15)
          have hx0v : x0 = 1 := by linear_combination hx0
          have hx1v : x1 = -5 := by linear_combination h15
          have hx2v : x2 = 1 := by linear_combination h21
          have hx3v : x3 = 1 := by linear_combination h31
          refine ⟨1, 1, ?_⟩
          funext j
          fin_cases j <;> simp [centeredNode, hx0v, hx1v, hx2v, hx3v]
      · have hx1 := x1_eq_one_of_x3_one_x2_neg_five
          x0 x1 x2 x3 h0 h1 h2 h3 h4 h31e (by simpa using h25)
        have hx0 := x0_eq_one_of_x3_one_x2_neg_five
          x0 x1 x2 x3 h0 h1 h2 h3 h4 h31e (by simpa using h25)
        have hx0v : x0 = 1 := by linear_combination hx0
        have hx1v : x1 = 1 := by linear_combination hx1
        have hx2v : x2 = -5 := by linear_combination h25
        have hx3v : x3 = 1 := by linear_combination h31
        refine ⟨1, 2, ?_⟩
        funext j
        fin_cases j <;> simp [centeredNode, hx0v, hx1v, hx2v, hx3v]
    · have h35e : (1 : K) * x3 + 5 * 1 = 0 := by simpa using h35
      have hx2 := x2_eq_one_of_x3_neg_five x0 x1 x2 x3 h0 h1 h2 h3 h4 h35e
      have hx1 := x1_eq_one_of_x3_neg_five x0 x1 x2 x3 h0 h1 h2 h3 h4 h35e
      have hx0 := x0_eq_one_of_x3_neg_five x0 x1 x2 x3 h0 h1 h2 h3 h4 h35e
      have hx0v : x0 = 1 := by linear_combination hx0
      have hx1v : x1 = 1 := by linear_combination hx1
      have hx2v : x2 = 1 := by linear_combination hx2
      have hx3v : x3 = -5 := by linear_combination h35
      refine ⟨1, 3, ?_⟩
      funext j
      fin_cases j <;> simp [centeredNode, hx0v, hx1v, hx2v, hx3v]
  · have hz'e : (5 : K) * x3 + 1 * 1 = 0 := by simpa using hz'
    have hx2 := five_x2_add_one_of_five_x3_add_one
      x0 x1 x2 x3 h0 h1 h2 h3 h4 hz'e
    have hx1 := five_x1_add_one_of_five_x3_add_one
      x0 x1 x2 x3 h0 h1 h2 h3 h4 hz'e
    have hx0 := five_x0_add_one_of_five_x3_add_one
      x0 x1 x2 x3 h0 h1 h2 h3 h4 hz'e
    have hx0v : x0 = -(1 : K) / 5 := by
      field_simp
      linear_combination hx0
    have hx1v : x1 = -(1 : K) / 5 := by
      field_simp
      linear_combination hx1
    have hx2v : x2 = -(1 : K) / 5 := by
      field_simp
      linear_combination hx2
    have hx3v : x3 = -(1 : K) / 5 := by
      field_simp
      linear_combination hz'
    refine ⟨-(1 : K) / 5, 4, ?_⟩
    funext j
    fin_cases j <;> simp [centeredNode, hx0v, hx1v, hx2v, hx3v]

/-- The affine cone cut out by the five gradient quadrics is exactly the
union of the six rational lines spanned by the centered node vectors. -/
theorem gradient_eq_zero_iff_smul_centeredNode
    {K : Type*} [Field K] [CharZero K] (x : Fin 5 → K) :
    (∀ j, gradient x j = 0) ↔
      ∃ c : K, ∃ i : Fin 6, x = c • centeredNode i := by
  constructor
  · intro h
    by_cases hx4 : x 4 = 0
    · have g0 : gradient ![x 0, x 1, x 2, x 3, 0] 0 = 0 := by
        simpa [gradient, hx4] using h 0
      have g1 : gradient ![x 0, x 1, x 2, x 3, 0] 1 = 0 := by
        simpa [gradient, hx4] using h 1
      have g2 : gradient ![x 0, x 1, x 2, x 3, 0] 2 = 0 := by
        simpa [gradient, hx4] using h 2
      have g3 : gradient ![x 0, x 1, x 2, x 3, 0] 3 = 0 := by
        simpa [gradient, hx4] using h 3
      have g4 : gradient ![x 0, x 1, x 2, x 3, 0] 4 = 0 := by
        simpa [gradient, hx4] using h 4
      have hx0 : x 0 = 0 :=
        (pow_eq_zero_iff (n := 3) (by norm_num)).mp
          (boundary_x0_cube (x 0) (x 1) (x 2) (x 3) g0 g1 g2 g3 g4)
      have hx1 : x 1 = 0 :=
        (pow_eq_zero_iff (n := 3) (by norm_num)).mp
          (boundary_x1_cube (x 0) (x 1) (x 2) (x 3) g0 g1 g2 g3 g4)
      have hx2 : x 2 = 0 :=
        (pow_eq_zero_iff (n := 3) (by norm_num)).mp
          (boundary_x2_cube (x 0) (x 1) (x 2) (x 3) g0 g1 g2 g3 g4)
      have hx3 : x 3 = 0 :=
        (pow_eq_zero_iff (n := 3) (by norm_num)).mp
          (boundary_x3_cube (x 0) (x 1) (x 2) (x 3) g0 g1 g2 g3 g4)
      refine ⟨0, 0, ?_⟩
      funext j
      fin_cases j <;> simp [centeredNode, hx0, hx1, hx2, hx3, hx4]
    · let y : Fin 5 → K :=
        ![x 0 / x 4, x 1 / x 4, x 2 / x 4, x 3 / x 4, 1]
      have hxy : x = x 4 • y := by
        funext j
        fin_cases j <;> simp [y] <;> field_simp
      have hy : ∀ j, gradient y j = 0 := by
        intro j
        have hs := congrFun (gradient_smul (x 4) y) j
        rw [← hxy] at hs
        have hz : (x 4)^2 * gradient y j = 0 := by
          simpa using hs.symm.trans (h j)
        exact (mul_eq_zero.mp hz).resolve_left (pow_ne_zero 2 hx4)
      have hc := chart_classification (x 0 / x 4) (x 1 / x 4)
        (x 2 / x 4) (x 3 / x 4)
        (by simpa [chartGradient, y] using hy 0)
        (by simpa [chartGradient, y] using hy 1)
        (by simpa [chartGradient, y] using hy 2)
        (by simpa [chartGradient, y] using hy 3)
        (by simpa [chartGradient, y] using hy 4)
      rcases hc with ⟨d, i, hi⟩
      refine ⟨x 4 * d, i, ?_⟩
      have hiy : y = d • centeredNode i := by simpa [y] using hi
      calc
        x = x 4 • y := hxy
        _ = x 4 • (d • centeredNode i) := by rw [hiy]
        _ = (x 4 * d) • centeredNode i := by simp [smul_smul]
  · rintro ⟨c, i, rfl⟩
    intro j
    rw [congrFun (gradient_smul c (centeredNode i : Fin 5 → K)) j]
    have hnode : gradient (centeredNode i : Fin 5 → K) j = 0 := by
      fin_cases i <;> fin_cases j <;> norm_num [gradient, centeredNode]
    simp [hnode]

/-- A nonzero rational singular vector lies on one of the six centered node
lines. -/
theorem nonzero_gradient_zero_iff_projective_centeredNode
    {K : Type*} [Field K] [CharZero K] (x : Fin 5 → K) (hx : x ≠ 0) :
    (∀ j, gradient x j = 0) ↔
      ∃ c : K, c ≠ 0 ∧ ∃ i : Fin 6, x = c • centeredNode i := by
  rw [gradient_eq_zero_iff_smul_centeredNode]
  constructor
  · rintro ⟨c, i, hi⟩
    refine ⟨c, ?_, i, hi⟩
    intro hc
    apply hx
    simpa [hc] using hi
  · rintro ⟨c, _, i, hi⟩
    exact ⟨c, i, hi⟩

/-- Nonzero scalar multiples of two centered node vectors agree only when
both the node labels and the scalars agree. -/
theorem smul_centeredNode_injective
    (i j : Fin 6) (c d : ℚ) (hc : c ≠ 0) (hd : d ≠ 0)
    (h : c • (centeredNode i : Fin 5 → ℚ) =
      d • (centeredNode j : Fin 5 → ℚ)) :
    i = j ∧ c = d := by
  have h0 := congrFun h 0
  have h1 := congrFun h 1
  have h2 := congrFun h 2
  have h3 := congrFun h 3
  have h4 := congrFun h 4
  have hc2 : 0 < c * c := mul_self_pos.mpr hc
  have hd2 : 0 < d * d := mul_self_pos.mpr hd
  fin_cases i <;> fin_cases j <;>
    norm_num [centeredNode] at h0 h1 h2 h3 h4 ⊢ <;>
    nlinarith [hc2, hd2]

end RelativeConicArcs.GoldenCubicNodes
