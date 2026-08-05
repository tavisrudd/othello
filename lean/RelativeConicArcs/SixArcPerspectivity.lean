import RelativeConicArcs.FrameCoordinates

/-!
# Triple perspectivity from double perspectivity

Two triangles in a projective plane are *perspective* under a correspondence of their vertices
when the three lines joining corresponding vertices are concurrent.  This file proves the
classical statement that two triangles in double perspective are in triple perspective, in the
hexagonal labelling convenient for six-point arcs: for six points `p1, …, p6` satisfying the
non-degeneracy hypotheses listed on the theorem, if the three chords `p1p2`, `p3p4`, `p5p6` pass
through a common point `x` and the three chords `p1p6`, `p2p3`, `p4p5` pass through a common
point `y`, then the three chords `p1p4`, `p2p5`, `p3p6` also pass through a common point.
Equivalently, the triangles `p1p3p5` and `p2p4p6` are perspective under the vertex
correspondences `1↦2, 3↦4, 5↦6` and `1↦6, 3↦2, 5↦4`, and the conclusion is perspectivity under
`1↦4, 3↦6, 5↦2`.

Points are one-dimensional subspaces of a three-dimensional vector space `V` over a field `K`,
as in `Projectivization K V`, and collinearity is `ProjectiveCap.Projective.Collinear`.  The
proof normalizes the triangle `p1, p3, p5` to a coordinate frame whose unit point is `x`, using
`ProjectiveCap.Projective.quad_normal_form`; the collinearity hypotheses then pin the frame
coordinates of `p2`, `p4`, `p6` to the shapes `(a : s : s)`, `(m : b : m)`, `(n : n : c)`
through the determinant criterion
`RelativeConicArcs.FrameCoordinates.collinear_iff_det_eq_zero`.  The concurrence at `y` and the
desired third concurrence reduce to the same multiplicative identity in these entries — their
concurrence determinants are negatives of each other — so a common point of the third chord
triple can be written down explicitly in the frame.  The argument uses only field arithmetic;
there is no characteristic and no finiteness assumption.

Each non-collinearity hypothesis of the theorem is a condition on a triple drawn from
`p1, p2, p3, p4, p5, x, y`; all of them hold automatically when the six points form an arc
(no three collinear) and `x` and `y` are distinct from the six points, since a concurrence
point lying on a side of one of the triangles would be forced onto one of the six points.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace SixArcPerspectivity

open Matrix Module Projectivization ProjectiveCap.Projective FrameCoordinates

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- **Two triangles in double perspective are in triple perspective**, in hexagonal labelling.

The six points `p1, …, p6` of a projective plane are assumed to satisfy the listed
non-collinearity conditions; all of them hold automatically when the six points form an arc (no
three collinear) and `x`, `y` are distinct from the six points.  If the three chords
`p1p2`, `p3p4`, `p5p6` pass through the common point `x` and the three chords `p1p6`, `p2p3`,
`p4p5` pass through the common point `y`, then the three chords `p1p4`, `p2p5`, `p3p6` also pass
through a common point.  Equivalently: the triangles `p1p3p5` and `p2p4p6` are perspective under
the vertex correspondences `1↦2, 3↦4, 5↦6` and `1↦6, 3↦2, 5↦4`, and the conclusion is
perspectivity under `1↦4, 3↦6, 5↦2`.  The proof is by frame coordinates and holds over every
field, with no characteristic or finiteness assumption. -/
theorem triple_perspectivity_of_double_perspectivity
    (hrank : Module.finrank K V = 3)
    {p1 p2 p3 p4 p5 p6 x y : Point K V}
    (h135 : ¬ Collinear K V p1 p3 p5)
    (h132 : ¬ Collinear K V p1 p3 p2)
    (h134 : ¬ Collinear K V p1 p3 p4)
    (h13x : ¬ Collinear K V p1 p3 x)
    (h15x : ¬ Collinear K V p1 p5 x)
    (h35x : ¬ Collinear K V p3 p5 x)
    (h13y : ¬ Collinear K V p1 p3 y)
    (h15y : ¬ Collinear K V p1 p5 y)
    (h35y : ¬ Collinear K V p3 p5 y)
    (h12x : Collinear K V p1 p2 x)
    (h34x : Collinear K V p3 p4 x)
    (h56x : Collinear K V p5 p6 x)
    (h16y : Collinear K V p1 p6 y)
    (h23y : Collinear K V p2 p3 y)
    (h45y : Collinear K V p4 p5 y) :
    ∃ z : Point K V,
      Collinear K V p1 p4 z ∧ Collinear K V p2 p5 z ∧ Collinear K V p3 p6 z := by
  classical
  letI : DecidableEq (Point K V) := Classical.decEq _
  -- Normalize the triangle `p1 p3 p5` to the frame whose unit point is `x`.
  have i135 := not_collinear_iff_independent.mp h135
  have i13x := not_collinear_iff_independent.mp h13x
  have i15x := not_collinear_iff_independent.mp h15x
  have i35x := not_collinear_iff_independent.mp h35x
  obtain ⟨hcap, -⟩ := cap_quad_of_independent i135 i13x i15x i35x
  have hli135 := independent_triple_iff.mp i135
  have hli13x := independent_triple_iff.mp i13x
  have hli35x := independent_triple_iff.mp i35x
  obtain ⟨u, hu, ⟨hu0, hp1⟩, ⟨hu1, hp3⟩, ⟨hu2, hp5⟩, hxrep⟩ :=
    quad_normal_form hrank hcap
      (ne_of_li_pair (li_sub01 hli135)) (ne_of_li_pair (li_sub02 hli135))
      (ne_of_li_pair (li_sub02 hli13x)) (ne_of_li_pair (li_sub12 hli135))
      (ne_of_li_pair (li_sub12 hli13x)) (ne_of_li_pair (li_sub12 hli35x))
  -- Coordinate entries of the three triangle vertices: each is a nonzero multiple of a unit
  -- vector.
  obtain ⟨a1, ha1⟩ := (Projectivization.mk_eq_mk_iff' K (u 0) p1.rep hu0 p1.rep_nonzero).mp
    (by rw [hp1, Projectivization.mk_rep])
  obtain ⟨a3, ha3⟩ := (Projectivization.mk_eq_mk_iff' K (u 1) p3.rep hu1 p3.rep_nonzero).mp
    (by rw [hp3, Projectivization.mk_rep])
  obtain ⟨a5, ha5⟩ := (Projectivization.mk_eq_mk_iff' K (u 2) p5.rep hu2 p5.rep_nonzero).mp
    (by rw [hp5, Projectivization.mk_rep])
  have ha1ne : a1 ≠ 0 := by
    rintro rfl; rw [zero_smul] at ha1; exact hu0 ha1.symm
  have ha3ne : a3 ≠ 0 := by
    rintro rfl; rw [zero_smul] at ha3; exact hu1 ha3.symm
  have ha5ne : a5 ≠ 0 := by
    rintro rfl; rw [zero_smul] at ha5; exact hu2 ha5.symm
  have hc1 : ∀ j, a1 * coord hrank hu p1 j = if (0 : Fin 3) = j then 1 else 0 := by
    intro j
    have h := coordOf_smul_apply hrank hu a1 p1.rep j
    rw [ha1, coordOf_frame_apply hrank hu 0 j] at h
    exact h.symm
  have hc3 : ∀ j, a3 * coord hrank hu p3 j = if (1 : Fin 3) = j then 1 else 0 := by
    intro j
    have h := coordOf_smul_apply hrank hu a3 p3.rep j
    rw [ha3, coordOf_frame_apply hrank hu 1 j] at h
    exact h.symm
  have hc5 : ∀ j, a5 * coord hrank hu p5 j = if (2 : Fin 3) = j then 1 else 0 := by
    intro j
    have h := coordOf_smul_apply hrank hu a5 p5.rep j
    rw [ha5, coordOf_frame_apply hrank hu 2 j] at h
    exact h.symm
  have h1_1 : coord hrank hu p1 1 = 0 := by
    have h := hc1 1; rw [if_neg (by decide)] at h
    exact (mul_eq_zero.mp h).resolve_left ha1ne
  have h1_2 : coord hrank hu p1 2 = 0 := by
    have h := hc1 2; rw [if_neg (by decide)] at h
    exact (mul_eq_zero.mp h).resolve_left ha1ne
  have h1_0ne : coord hrank hu p1 0 ≠ 0 := by
    have h := hc1 0; rw [if_pos rfl] at h
    exact right_ne_zero_of_mul_eq_one h
  have h3_0 : coord hrank hu p3 0 = 0 := by
    have h := hc3 0; rw [if_neg (by decide)] at h
    exact (mul_eq_zero.mp h).resolve_left ha3ne
  have h3_2 : coord hrank hu p3 2 = 0 := by
    have h := hc3 2; rw [if_neg (by decide)] at h
    exact (mul_eq_zero.mp h).resolve_left ha3ne
  have h3_1ne : coord hrank hu p3 1 ≠ 0 := by
    have h := hc3 1; rw [if_pos rfl] at h
    exact right_ne_zero_of_mul_eq_one h
  have h5_0 : coord hrank hu p5 0 = 0 := by
    have h := hc5 0; rw [if_neg (by decide)] at h
    exact (mul_eq_zero.mp h).resolve_left ha5ne
  have h5_1 : coord hrank hu p5 1 = 0 := by
    have h := hc5 1; rw [if_neg (by decide)] at h
    exact (mul_eq_zero.mp h).resolve_left ha5ne
  have h5_2ne : coord hrank hu p5 2 ≠ 0 := by
    have h := hc5 2; rw [if_pos rfl] at h
    exact right_ne_zero_of_mul_eq_one h
  -- Coordinate entries of the unit point `x`.
  have hx : ∀ j, coord hrank hu x j =
      coordOf hrank hu (u 0) j + coordOf hrank hu (u 1) j + coordOf hrank hu (u 2) j := by
    intro j
    show coordOf hrank hu x.rep j = _
    rw [← hxrep, coordOf_add_apply, coordOf_add_apply]
  have hx0 : coord hrank hu x 0 = 1 := by
    rw [hx 0, coordOf_frame_apply, coordOf_frame_apply, coordOf_frame_apply]; simp
  have hx1 : coord hrank hu x 1 = 1 := by
    rw [hx 1, coordOf_frame_apply, coordOf_frame_apply, coordOf_frame_apply]; simp
  have hx2 : coord hrank hu x 2 = 1 := by
    rw [hx 2, coordOf_frame_apply, coordOf_frame_apply, coordOf_frame_apply]; simp
  -- `p2` lies on the line `p1 x`: its middle and last coordinates agree.
  have h2eq : coord hrank hu p2 1 = coord hrank hu p2 2 := by
    have h := (collinear_iff_det_eq_zero hrank hu p1 p2 x).mp h12x
    rw [Matrix.det_fin_three] at h
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] at h
    rw [h1_1, h1_2, hx0, hx1, hx2] at h
    have hfac : coord hrank hu p1 0 * (coord hrank hu p2 1 - coord hrank hu p2 2) = 0 := by
      linear_combination h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h1_0ne)
  -- `p4` lies on the line `p3 x`: its first and last coordinates agree.
  have h4eq : coord hrank hu p4 0 = coord hrank hu p4 2 := by
    have h := (collinear_iff_det_eq_zero hrank hu p3 p4 x).mp h34x
    rw [Matrix.det_fin_three] at h
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] at h
    rw [h3_0, h3_2, hx0, hx1, hx2] at h
    have hfac : coord hrank hu p3 1 * (coord hrank hu p4 0 - coord hrank hu p4 2) = 0 := by
      linear_combination -h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h3_1ne)
  -- `p6` lies on the line `p5 x`: its first and middle coordinates agree.
  have h6eq : coord hrank hu p6 0 = coord hrank hu p6 1 := by
    have h := (collinear_iff_det_eq_zero hrank hu p5 p6 x).mp h56x
    rw [Matrix.det_fin_three] at h
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] at h
    rw [h5_0, h5_1, hx0, hx1, hx2] at h
    have hfac : coord hrank hu p5 2 * (coord hrank hu p6 0 - coord hrank hu p6 1) = 0 := by
      linear_combination h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h5_2ne)
  -- The last coordinates of `p2` and `p4` are nonzero: otherwise `p2` (resp. `p4`) would lie on
  -- the line `p1 p3`.
  have h22ne : coord hrank hu p2 2 ≠ 0 := by
    intro h0
    apply h132
    rw [collinear_iff_det_eq_zero hrank hu, Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h1_1, h1_2, h3_0, h3_2, h0]
    ring
  have h42ne : coord hrank hu p4 2 ≠ 0 := by
    intro h0
    apply h134
    rw [collinear_iff_det_eq_zero hrank hu, Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h1_1, h1_2, h3_0, h3_2, h0]
    ring
  -- The coordinates of `y` avoid the three sides of the coordinate triangle.
  have hd0 : coord hrank hu y 0 ≠ 0 := by
    intro h0
    apply h35y
    rw [collinear_iff_det_eq_zero hrank hu, Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h3_0, h3_2, h5_0, h5_1, h0]
    ring
  have hd1 : coord hrank hu y 1 ≠ 0 := by
    intro h0
    apply h15y
    rw [collinear_iff_det_eq_zero hrank hu, Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h1_1, h1_2, h5_0, h5_1, h0]
    ring
  have hd2 : coord hrank hu y 2 ≠ 0 := by
    intro h0
    apply h13y
    rw [collinear_iff_det_eq_zero hrank hu, Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h1_1, h1_2, h3_0, h3_2, h0]
    ring
  -- The three concurrence conditions at `y`, in coordinate form.
  have hy16r : coord hrank hu p6 1 * coord hrank hu y 2
      = coord hrank hu p6 2 * coord hrank hu y 1 := by
    have h := (collinear_iff_det_eq_zero hrank hu p1 p6 y).mp h16y
    rw [Matrix.det_fin_three] at h
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] at h
    rw [h1_1, h1_2] at h
    have hfac : coord hrank hu p1 0 * (coord hrank hu p6 1 * coord hrank hu y 2
        - coord hrank hu p6 2 * coord hrank hu y 1) = 0 := by
      linear_combination h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h1_0ne)
  have hy23r : coord hrank hu p2 0 * coord hrank hu y 2
      = coord hrank hu p2 2 * coord hrank hu y 0 := by
    have h := (collinear_iff_det_eq_zero hrank hu p2 p3 y).mp h23y
    rw [Matrix.det_fin_three] at h
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] at h
    rw [h3_0, h3_2] at h
    have hfac : coord hrank hu p3 1 * (coord hrank hu p2 0 * coord hrank hu y 2
        - coord hrank hu p2 2 * coord hrank hu y 0) = 0 := by
      linear_combination h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h3_1ne)
  have hy45r : coord hrank hu p4 1 * coord hrank hu y 0
      = coord hrank hu p4 0 * coord hrank hu y 1 := by
    have h := (collinear_iff_det_eq_zero hrank hu p4 p5 y).mp h45y
    rw [Matrix.det_fin_three] at h
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons] at h
    rw [h5_0, h5_1] at h
    have hfac : coord hrank hu p5 2 * (coord hrank hu p4 1 * coord hrank hu y 0
        - coord hrank hu p4 0 * coord hrank hu y 1) = 0 := by
      linear_combination h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h5_2ne)
  -- The multiplicative identity that makes the third matching concurrent.
  have key : coord hrank hu p6 2 * (coord hrank hu p2 0 * coord hrank hu p4 1)
      = coord hrank hu p6 0 * (coord hrank hu p4 2 * coord hrank hu p2 2) := by
    have hdne : coord hrank hu y 0 * coord hrank hu y 1 * coord hrank hu y 2 ≠ 0 :=
      mul_ne_zero (mul_ne_zero hd0 hd1) hd2
    apply mul_right_cancel₀ hdne
    linear_combination
      (coord hrank hu p6 2 * coord hrank hu p4 1 * coord hrank hu y 0 * coord hrank hu y 1)
        * hy23r
      + (coord hrank hu p6 2 * coord hrank hu p2 2 * coord hrank hu y 0 * coord hrank hu y 1)
        * hy45r
      - (coord hrank hu p4 0 * coord hrank hu p2 2 * coord hrank hu y 0 * coord hrank hu y 1)
        * hy16r
      - (coord hrank hu p4 0 * coord hrank hu p2 2 * coord hrank hu y 0 * coord hrank hu y 1
          * coord hrank hu y 2) * h6eq
      + (coord hrank hu p6 0 * coord hrank hu p2 2 * coord hrank hu y 0 * coord hrank hu y 1
          * coord hrank hu y 2) * h4eq
  -- The common point of the third matching, written down explicitly in the frame.
  set A := coord hrank hu p2 0 * coord hrank hu p4 1 with hAdef
  set B := coord hrank hu p4 1 * coord hrank hu p2 2 with hBdef
  set C := coord hrank hu p4 2 * coord hrank hu p2 2 with hCdef
  have hCne : C ≠ 0 := mul_ne_zero h42ne h22ne
  have hzc : ∀ j, coordOf hrank hu (A • u 0 + B • u 1 + C • u 2) j
      = A * coordOf hrank hu (u 0) j + B * coordOf hrank hu (u 1) j
        + C * coordOf hrank hu (u 2) j := by
    intro j
    rw [coordOf_add_apply, coordOf_add_apply, coordOf_smul_apply, coordOf_smul_apply,
      coordOf_smul_apply]
  have hz0 : coordOf hrank hu (A • u 0 + B • u 1 + C • u 2) 0 = A := by
    rw [hzc 0, coordOf_frame_apply, coordOf_frame_apply, coordOf_frame_apply]; simp
  have hz1 : coordOf hrank hu (A • u 0 + B • u 1 + C • u 2) 1 = B := by
    rw [hzc 1, coordOf_frame_apply, coordOf_frame_apply, coordOf_frame_apply]; simp
  have hz2 : coordOf hrank hu (A • u 0 + B • u 1 + C • u 2) 2 = C := by
    rw [hzc 2, coordOf_frame_apply, coordOf_frame_apply, coordOf_frame_apply]; simp
  have hzne : A • u 0 + B • u 1 + C • u 2 ≠ 0 := by
    intro h0
    apply hCne
    rw [← hz2, h0]
    simp [coordOf]
  refine ⟨Projectivization.mk K (A • u 0 + B • u 1 + C • u 2) hzne, ?_, ?_, ?_⟩
  · -- the chord `p1 p4` passes through the new point
    apply collinear_mk_of_det_eq_zero hrank hu
    rw [Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h1_1, h1_2, hz0, hz1, hz2, hBdef, hCdef]
    ring
  · -- the chord `p2 p5` passes through the new point
    apply collinear_mk_of_det_eq_zero hrank hu
    rw [Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h5_0, h5_1, hz0, hz1, hz2, hAdef, hBdef]
    linear_combination
      (coord hrank hu p5 2 * coord hrank hu p2 0 * coord hrank hu p4 1) * h2eq
  · -- the chord `p3 p6` passes through the new point
    apply collinear_mk_of_det_eq_zero hrank hu
    rw [Matrix.det_fin_three]
    simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.head_cons, Matrix.tail_cons]
    rw [h3_0, h3_2, hz0, hz1, hz2]
    linear_combination coord hrank hu p3 1 * key

#print axioms triple_perspectivity_of_double_perspectivity

end SixArcPerspectivity
end RelativeConicArcs
