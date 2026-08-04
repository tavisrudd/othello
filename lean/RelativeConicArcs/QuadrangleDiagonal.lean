import ProjectiveCap.PlaneTransitivity

/-!
# Diagonal points of a complete quadrangle

A complete quadrangle in the projective plane over a field `K` is a set of four points, no three of
which are collinear.  Its four points determine six joining lines, which fall into three pairs of
*opposite* sides: the side through the first and second point is opposite the side through the
third and fourth, and likewise for the other two ways of splitting the four points into two pairs.
Each pair of opposite sides meets in one point, and those three points are the *diagonal points* of
the quadrangle.

The theorem of this file is that the three diagonal points are never collinear when two is
invertible in `K`.  In characteristic two the statement fails: there the three diagonal points are
always collinear, and the quadrangle together with its diagonal points is the Fano configuration.
The proof normalizes the quadrangle so that scaled representatives of three of its points form a
basis whose coordinate sum represents the fourth; in that frame the three diagonal points are
represented by the three pairwise sums of the basis vectors, and those three vectors are
independent exactly when two is invertible.

A diagonal point is described here by the two collinearity conditions defining it rather than by a
construction, so the statements apply to any point lying on both of a pair of opposite sides.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace QuadrangleDiagonal

open Projectivization ProjectiveCap.Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- Rescaling the three members of an independent triple by nonzero scalars keeps it
independent. -/
private theorem li_smul_triple {a b c : V} {s t r : K}
    (hs : s ≠ 0) (ht : t ≠ 0) (hr : r ≠ 0)
    (h : LinearIndependent K ![a, b, c]) :
    LinearIndependent K ![s • a, t • b, r • c] := by
  rw [Fintype.linearIndependent_iff] at h ⊢
  intro g hg
  have hexp : g 0 • (s • a) + g 1 • (t • b) + g 2 • (r • c) = 0 := by
    rw [Fin.sum_univ_three] at hg
    simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] using hg
  have h0 := h ![g 0 * s, g 1 * t, g 2 * r] (by
    rw [Fin.sum_univ_three]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (norm := module) hexp)
  have e0 := h0 0
  have e1 := h0 1
  have e2 := h0 2
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
  intro i
  fin_cases i
  · exact (mul_eq_zero.mp e0).resolve_right hs
  · exact (mul_eq_zero.mp e1).resolve_right ht
  · exact (mul_eq_zero.mp e2).resolve_right hr

/-- The three pairwise sums of an independent triple are independent exactly when two is
invertible; this is the algebraic content of the non-collinearity of the diagonal points. -/
private theorem li_pairwise_sums (h2 : (2 : K) ≠ 0) {a b c : V}
    (h : LinearIndependent K ![a, b, c]) :
    LinearIndependent K ![a + b, a + c, b + c] := by
  rw [Fintype.linearIndependent_iff] at h ⊢
  intro g hg
  have hexp : g 0 • (a + b) + g 1 • (a + c) + g 2 • (b + c) = 0 := by
    rw [Fin.sum_univ_three] at hg
    simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] using hg
  have h0 := h ![g 0 + g 1, g 0 + g 2, g 1 + g 2] (by
    rw [Fin.sum_univ_three]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (norm := module) hexp)
  have e0 := h0 0
  have e1 := h0 1
  have e2 := h0 2
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
  have hg0 : g 0 = 0 := by
    have h2g : (2 : K) * g 0 = 0 := by linear_combination e0 + e1 - e2
    exact (mul_eq_zero.mp h2g).resolve_left h2
  have hg1 : g 1 = 0 := by linear_combination e0 - hg0
  have hg2 : g 2 = 0 := by linear_combination e1 - hg0
  intro i
  fin_cases i
  · exact hg0
  · exact hg1
  · exact hg2

/-- Swapping the last two members of an independent triple keeps it independent. -/
private theorem li_swap12 {a b c : V} (h : LinearIndependent K ![a, b, c]) :
    LinearIndependent K ![a, c, b] := by
  rw [Fintype.linearIndependent_iff] at h ⊢
  intro g hg
  have hexp : g 0 • a + g 1 • c + g 2 • b = 0 := by
    rw [Fin.sum_univ_three] at hg
    simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] using hg
  have h0 := h ![g 0, g 2, g 1] (by
    rw [Fin.sum_univ_three]
    simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    linear_combination (norm := module) hexp)
  have e0 := h0 0
  have e1 := h0 1
  have e2 := h0 2
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
  intro i
  fin_cases i
  · exact e0
  · exact e2
  · exact e1

/-- Coordinates of a vector in the frame supplied by an independent triple spanning a
three-dimensional space. -/
private noncomputable def frameCoord (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (v : V) : Fin 3 → K :=
  (basisOfLinearIndependentOfCardEqFinrank hu
    (show Fintype.card (Fin 3) = Module.finrank K V by simp [hrank])).repr v

/-- The frame coordinates recover the vector. -/
private theorem frameCoord_spec (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u) (v : V) :
    frameCoord hrank hu v 0 • u 0 + frameCoord hrank hu v 1 • u 1 +
      frameCoord hrank hu v 2 • u 2 = v := by
  classical
  set b := basisOfLinearIndependentOfCardEqFinrank hu
    (show Fintype.card (Fin 3) = Module.finrank K V by simp [hrank]) with hb
  have hcoe : ⇑b = u := by
    rw [hb]
    exact coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hrepr := b.sum_repr v
  rw [Fin.sum_univ_three, hcoe] at hrepr
  exact hrepr

/-- Reindexing an independent family on `Fin 3` into matrix notation. -/
private theorem li_triple_of_fun {u : Fin 3 → V} (hu : LinearIndependent K u) :
    LinearIndependent K ![u 0, u 1, u 2] := by
  have huu : ![u 0, u 1, u 2] = u := by
    funext i
    fin_cases i <;> rfl
  rw [huu]
  exact hu

/-- In a normalized quadrangle frame, the diagonal point on the sides through the first two and
through the last two points is represented by the sum of the first two frame vectors. -/
private theorem rep_eq_smul_add_of_opposite
    (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u)
    {p1 p2 p3 p4 x : Point K V}
    (hp1 : Projectivization.mk K (u 0) (hu.ne_zero 0) = p1)
    (hp2 : Projectivization.mk K (u 1) (hu.ne_zero 1) = p2)
    (hp3 : Projectivization.mk K (u 2) (hu.ne_zero 2) = p3)
    (hp4 : u 0 + u 1 + u 2 = p4.rep)
    (hx12 : Collinear K V p1 p2 x) (hx34 : Collinear K V p3 p4 x) :
    ∃ t : K, t ≠ 0 ∧ x.rep = t • (u 0 + u 1) := by
  classical
  set c := frameCoord hrank hu x.rep with hc
  have hexp : c 0 • u 0 + c 1 • u 1 + c 2 • u 2 = x.rep := frameCoord_spec hrank hu x.rep
  have hli := Fintype.linearIndependent_iff.mp hu
  have hc2 : c 2 = 0 := by
    by_contra hne
    have hindep : LinearIndependent K ![u 0, u 1, x.rep] := by
      rw [Fintype.linearIndependent_iff]
      intro g hg
      have hg' : g 0 • u 0 + g 1 • u 1 + g 2 • x.rep = 0 := by
        rw [Fin.sum_univ_three] at hg
        simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons] using hg
      rw [← hexp] at hg'
      have h0 := hli ![g 0 + g 2 * c 0, g 1 + g 2 * c 1, g 2 * c 2] (by
        rw [Fin.sum_univ_three]
        simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons]
        linear_combination (norm := module) hg')
      have e0 := h0 0
      have e1 := h0 1
      have e2 := h0 2
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
      have hg2 : g 2 = 0 := (mul_eq_zero.mp e2).resolve_right hne
      intro i
      fin_cases i
      · simpa [hg2] using e0
      · simpa [hg2] using e1
      · exact hg2
    have hIndep : Independent ![p1, p2, x] := by
      have h := independent_triple_of_li (K := K) (V := V) (hu.ne_zero 0) (hu.ne_zero 1)
        x.rep_nonzero hindep
      rwa [hp1, hp2, Projectivization.mk_rep] at h
    exact (not_collinear_iff_independent.mpr hIndep) hx12
  have hsum : u 0 + u 1 + u 2 ≠ 0 := sum_ne_zero_of_li (li_triple_of_fun hu)
  have hp4' : Projectivization.mk K (u 0 + u 1 + u 2) hsum = p4 := by
    simp only [hp4, Projectivization.mk_rep]
  have hc01 : c 0 = c 1 := by
    by_contra hne
    have hindep : LinearIndependent K ![u 2, u 0 + u 1 + u 2, x.rep] := by
      rw [Fintype.linearIndependent_iff]
      intro g hg
      have hg' : g 0 • u 2 + g 1 • (u 0 + u 1 + u 2) + g 2 • x.rep = 0 := by
        rw [Fin.sum_univ_three] at hg
        simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons] using hg
      rw [← hexp] at hg'
      have h0 := hli ![g 1 + g 2 * c 0, g 1 + g 2 * c 1, g 0 + g 1 + g 2 * c 2] (by
        rw [Fin.sum_univ_three]
        simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons]
        linear_combination (norm := module) hg')
      have e0 := h0 0
      have e1 := h0 1
      have e2 := h0 2
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
      have hdiff : g 2 * (c 0 - c 1) = 0 := by linear_combination e0 - e1
      have hg2 : g 2 = 0 := by
        rcases mul_eq_zero.mp hdiff with h | h
        · exact h
        · exact absurd (sub_eq_zero.mp h) hne
      have hg1 : g 1 = 0 := by
        have := e0
        rw [hg2] at this
        linear_combination this
      have hg0 : g 0 = 0 := by
        have := e2
        rw [hg1, hg2] at this
        linear_combination this
      intro i
      fin_cases i
      · exact hg0
      · exact hg1
      · exact hg2
    have hIndep : Independent ![p3, p4, x] := by
      have h := independent_triple_of_li (K := K) (V := V) (hu.ne_zero 2) hsum
        x.rep_nonzero hindep
      rwa [hp3, hp4', Projectivization.mk_rep] at h
    exact (not_collinear_iff_independent.mpr hIndep) hx34
  refine ⟨c 0, ?_, ?_⟩
  · intro hzero
    apply x.rep_nonzero
    rw [← hexp, hzero, hc2, ← hc01, hzero]
    module
  · rw [← hexp, hc2, ← hc01]
    module

/-- In a normalized quadrangle frame, the diagonal point on the sides through the first and last
and through the middle two points is represented by the sum of the last two frame vectors. -/
private theorem rep_eq_smul_add_of_opposite_outer
    (hrank : Module.finrank K V = 3)
    {u : Fin 3 → V} (hu : LinearIndependent K u)
    {p1 p2 p3 p4 z : Point K V}
    (hp1 : Projectivization.mk K (u 0) (hu.ne_zero 0) = p1)
    (hp2 : Projectivization.mk K (u 1) (hu.ne_zero 1) = p2)
    (hp3 : Projectivization.mk K (u 2) (hu.ne_zero 2) = p3)
    (hp4 : u 0 + u 1 + u 2 = p4.rep)
    (hz14 : Collinear K V p1 p4 z) (hz23 : Collinear K V p2 p3 z) :
    ∃ t : K, t ≠ 0 ∧ z.rep = t • (u 1 + u 2) := by
  classical
  set c := frameCoord hrank hu z.rep with hc
  have hexp : c 0 • u 0 + c 1 • u 1 + c 2 • u 2 = z.rep := frameCoord_spec hrank hu z.rep
  have hli := Fintype.linearIndependent_iff.mp hu
  have hsum : u 0 + u 1 + u 2 ≠ 0 := sum_ne_zero_of_li (li_triple_of_fun hu)
  have hp4' : Projectivization.mk K (u 0 + u 1 + u 2) hsum = p4 := by
    simp only [hp4, Projectivization.mk_rep]
  have hc0 : c 0 = 0 := by
    by_contra hne
    have hindep : LinearIndependent K ![u 1, u 2, z.rep] := by
      rw [Fintype.linearIndependent_iff]
      intro g hg
      have hg' : g 0 • u 1 + g 1 • u 2 + g 2 • z.rep = 0 := by
        rw [Fin.sum_univ_three] at hg
        simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons] using hg
      rw [← hexp] at hg'
      have h0 := hli ![g 2 * c 0, g 0 + g 2 * c 1, g 1 + g 2 * c 2] (by
        rw [Fin.sum_univ_three]
        simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons]
        linear_combination (norm := module) hg')
      have e0 := h0 0
      have e1 := h0 1
      have e2 := h0 2
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
      have hg2 : g 2 = 0 := (mul_eq_zero.mp e0).resolve_right hne
      intro i
      fin_cases i
      · simpa [hg2] using e1
      · simpa [hg2] using e2
      · exact hg2
    have hIndep : Independent ![p2, p3, z] := by
      have h := independent_triple_of_li (K := K) (V := V) (hu.ne_zero 1) (hu.ne_zero 2)
        z.rep_nonzero hindep
      rwa [hp2, hp3, Projectivization.mk_rep] at h
    exact (not_collinear_iff_independent.mpr hIndep) hz23
  have hc12 : c 1 = c 2 := by
    by_contra hne
    have hindep : LinearIndependent K ![u 0, u 0 + u 1 + u 2, z.rep] := by
      rw [Fintype.linearIndependent_iff]
      intro g hg
      have hg' : g 0 • u 0 + g 1 • (u 0 + u 1 + u 2) + g 2 • z.rep = 0 := by
        rw [Fin.sum_univ_three] at hg
        simpa only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons] using hg
      rw [← hexp] at hg'
      have h0 := hli ![g 0 + g 1 + g 2 * c 0, g 1 + g 2 * c 1, g 1 + g 2 * c 2] (by
        rw [Fin.sum_univ_three]
        simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
          Matrix.head_cons, Matrix.tail_cons]
        linear_combination (norm := module) hg')
      have e0 := h0 0
      have e1 := h0 1
      have e2 := h0 2
      simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
        Matrix.head_cons, Matrix.tail_cons] at e0 e1 e2
      have hdiff : g 2 * (c 1 - c 2) = 0 := by linear_combination e1 - e2
      have hg2 : g 2 = 0 := by
        rcases mul_eq_zero.mp hdiff with h | h
        · exact h
        · exact absurd (sub_eq_zero.mp h) hne
      have hg1 : g 1 = 0 := by
        have := e1
        rw [hg2] at this
        linear_combination this
      have hg0 : g 0 = 0 := by
        have := e0
        rw [hg1, hg2] at this
        linear_combination this
      intro i
      fin_cases i
      · exact hg0
      · exact hg1
      · exact hg2
    have hIndep : Independent ![p1, p4, z] := by
      have h := independent_triple_of_li (K := K) (V := V) (hu.ne_zero 0) hsum
        z.rep_nonzero hindep
      rwa [hp1, hp4', Projectivization.mk_rep] at h
    exact (not_collinear_iff_independent.mpr hIndep) hz14
  refine ⟨c 1, ?_, ?_⟩
  · intro hzero
    apply z.rep_nonzero
    rw [← hexp, hc0, hzero, ← hc12, hzero]
    module
  · rw [← hexp, hc0, ← hc12]
    module

variable [DecidableEq (Point K V)]

/-- **The diagonal points of a complete quadrangle are not collinear** when two is invertible.
Here `x` is a point on the two opposite sides `p₁p₂` and `p₃p₄`, `y` a point on `p₁p₃` and `p₂p₄`,
and `z` a point on `p₁p₄` and `p₂p₃`. -/
theorem not_collinear_diagonalPoints
    (hrank : Module.finrank K V = 3) (h2 : (2 : K) ≠ 0)
    {p1 p2 p3 p4 x y z : Point K V}
    (h123 : ¬ Collinear K V p1 p2 p3) (h124 : ¬ Collinear K V p1 p2 p4)
    (h134 : ¬ Collinear K V p1 p3 p4) (h234 : ¬ Collinear K V p2 p3 p4)
    (hx12 : Collinear K V p1 p2 x) (hx34 : Collinear K V p3 p4 x)
    (hy13 : Collinear K V p1 p3 y) (hy24 : Collinear K V p2 p4 y)
    (hz14 : Collinear K V p1 p4 z) (hz23 : Collinear K V p2 p3 z) :
    ¬ Collinear K V x y z := by
  classical
  have i123 : Independent ![p1, p2, p3] := not_collinear_iff_independent.mp h123
  have i124 : Independent ![p1, p2, p4] := not_collinear_iff_independent.mp h124
  have i134 : Independent ![p1, p3, p4] := not_collinear_iff_independent.mp h134
  have i234 : Independent ![p2, p3, p4] := not_collinear_iff_independent.mp h234
  obtain ⟨hcap, _hcard⟩ := cap_quad_of_independent i123 i124 i134 i234
  have hli123 := independent_triple_iff.mp i123
  have hli124 := independent_triple_iff.mp i124
  have hli134 := independent_triple_iff.mp i134
  have h12 : p1 ≠ p2 := ne_of_li_pair (li_sub01 hli123)
  have h13 : p1 ≠ p3 := ne_of_li_pair (li_sub02 hli123)
  have h23 : p2 ≠ p3 := ne_of_li_pair (li_sub12 hli123)
  have h14 : p1 ≠ p4 := ne_of_li_pair (li_sub02 hli124)
  have h24 : p2 ≠ p4 := ne_of_li_pair (li_sub12 hli124)
  have h34 : p3 ≠ p4 := ne_of_li_pair (li_sub12 hli134)
  obtain ⟨u, hu, ⟨hu0, hp1⟩, ⟨hu1, hp2⟩, ⟨hu2, hp3⟩, hp4⟩ :=
    quad_normal_form hrank hcap h12 h13 h14 h23 h24 h34
  have hp1' : Projectivization.mk K (u 0) (hu.ne_zero 0) = p1 := hp1
  have hp2' : Projectivization.mk K (u 1) (hu.ne_zero 1) = p2 := hp2
  have hp3' : Projectivization.mk K (u 2) (hu.ne_zero 2) = p3 := hp3
  obtain ⟨t, ht, hxrep⟩ :=
    rep_eq_smul_add_of_opposite hrank hu hp1' hp2' hp3' hp4 hx12 hx34
  -- the second diagonal point is obtained from the first by swapping the roles of `p2` and `p3`
  have huswap : LinearIndependent K (![u 0, u 2, u 1] : Fin 3 → V) :=
    li_swap12 (li_triple_of_fun hu)
  have hs0 : (![u 0, u 2, u 1] : Fin 3 → V) 0 = u 0 := rfl
  have hs1 : (![u 0, u 2, u 1] : Fin 3 → V) 1 = u 2 := rfl
  have hs2 : (![u 0, u 2, u 1] : Fin 3 → V) 2 = u 1 := rfl
  have hp4swap : (![u 0, u 2, u 1] : Fin 3 → V) 0 + (![u 0, u 2, u 1] : Fin 3 → V) 1 +
      (![u 0, u 2, u 1] : Fin 3 → V) 2 = p4.rep := by
    rw [hs0, hs1, hs2, ← hp4]
    module
  obtain ⟨s, hs, hyrep⟩ :=
    rep_eq_smul_add_of_opposite hrank huswap hp1' hp3' hp2' hp4swap hy13 hy24
  rw [hs0, hs1] at hyrep
  obtain ⟨r, hr, hzrep⟩ :=
    rep_eq_smul_add_of_opposite_outer hrank hu hp1' hp2' hp3' hp4 hz14 hz23
  have hindep : LinearIndependent K ![x.rep, y.rep, z.rep] := by
    rw [hxrep, hyrep, hzrep]
    exact li_smul_triple ht hs hr (li_pairwise_sums h2 (li_triple_of_fun hu))
  have hIndep : Independent ![x, y, z] := independent_triple_iff.mpr hindep
  exact not_collinear_iff_independent.mpr hIndep

#print axioms not_collinear_diagonalPoints

end QuadrangleDiagonal
end RelativeConicArcs
