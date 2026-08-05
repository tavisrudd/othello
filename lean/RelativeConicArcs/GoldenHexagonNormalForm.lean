import RelativeConicArcs.FrameCoordinates

/-!
# The golden normal form of a hexagon with four concurrent chord triples

A perfect matching of six labelled points of a projective plane is *concurrent* when the three
chords joining its pairs pass through a common point.  This file determines the six points, up to
a projective change of frame, from the concurrence of four specific matchings.

Label the points `p1, …, p6` and consider the four matchings

* `{p1p2, p3p4, p5p6}`, concurrent at `x`;
* `{p1p4, p2p3, p5p6}`, concurrent at `q₁`;
* `{p1p3, p2p5, p4p6}`, concurrent at `q₂`;
* `{p1p4, p2p5, p3p6}`, concurrent at `q₃`.

Normalizing `p1, p3, p5` to a coordinate frame whose unit point is `x` forces
`p2 = (φ : 1 : 1)`, `p4 = (1 : φ : 1)` and `p6 = (1 : 1 : ψ)` for scalars satisfying
`ψ = 2 - φ` and `φ² = φ + 1`, so the six points are the golden hexagon.  The three concurrences
beyond the frame-defining one contribute exactly the three relations `φ = φ'` (the parameters of
`p2` and `p4` agree), `φ + ψ = 2`, and `φ · φ' · ψ = 1`; eliminating gives
`φ³ - 2φ² + 1 = (φ - 1)(φ² - φ - 1) = 0`, and the root `φ = 1` is excluded by `p2 ≠ x`.

The argument is field arithmetic in frame coordinates through
`RelativeConicArcs.FrameCoordinates.collinear_iff_det_eq_zero`, with no characteristic and no
finiteness assumption.  In particular the golden relation `φ² = φ + 1` is solvable in the ground
field whenever such a configuration exists.

Every non-collinearity hypothesis below is a condition on a triple drawn from `p1, …, p6, x`; all
of them hold when the six points form an arc and `x` is none of them.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace GoldenHexagonNormalForm

open Matrix Module Projectivization ProjectiveCap.Projective FrameCoordinates

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- Expansion of a three-by-three frame-coordinate determinant, as a plain polynomial in the
entries. -/
private theorem det_coord_expand (r0 r1 r2 : Fin 3 → K) :
    Matrix.det (Matrix.of ![r0, r1, r2]) =
      r0 0 * (r1 1 * r2 2 - r1 2 * r2 1) - r0 1 * (r1 0 * r2 2 - r1 2 * r2 0)
        + r0 2 * (r1 0 * r2 1 - r1 1 * r2 0) := by
  rw [Matrix.det_fin_three]
  simp only [Matrix.of_apply, Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
    Matrix.head_cons, Matrix.tail_cons]
  ring

/-- **The golden normal form.**  Six points of a projective plane whose matchings
`{p1p2, p3p4, p5p6}`, `{p1p4, p2p3, p5p6}`, `{p1p3, p2p5, p4p6}` and `{p1p4, p2p5, p3p6}` are all
concurrent, and which satisfy the listed non-degeneracy conditions, carry a frame `u` in which
they are

`p1 = (1 : 0 : 0)`, `p2 = (φ : 1 : 1)`, `p3 = (0 : 1 : 0)`,
`p4 = (1 : φ : 1)`, `p5 = (0 : 0 : 1)`, `p6 = (1 : 1 : 2 - φ)`

for a scalar `φ` satisfying the golden relation `φ * φ = φ + 1`.  The proof is frame arithmetic
over an arbitrary field; no characteristic or finiteness hypothesis is used. -/
theorem golden_normal_form_of_concurrent_matchings
    (hrank : Module.finrank K V = 3)
    {p1 p2 p3 p4 p5 p6 x q1 q2 q3 : Point K V}
    (h135 : ¬ Collinear K V p1 p3 p5)
    (h13x : ¬ Collinear K V p1 p3 x)
    (h15x : ¬ Collinear K V p1 p5 x)
    (h35x : ¬ Collinear K V p3 p5 x)
    (h132 : ¬ Collinear K V p1 p3 p2)
    (h134 : ¬ Collinear K V p1 p3 p4)
    (h136 : ¬ Collinear K V p1 p3 p6)
    (h156 : ¬ Collinear K V p1 p5 p6)
    (h154 : ¬ Collinear K V p1 p5 p4)
    (h352 : ¬ Collinear K V p3 p5 p2)
    (hp2x : p2 ≠ x)
    (h12x : Collinear K V p1 p2 x)
    (h34x : Collinear K V p3 p4 x)
    (h56x : Collinear K V p5 p6 x)
    (h14q1 : Collinear K V p1 p4 q1)
    (h23q1 : Collinear K V p2 p3 q1)
    (h56q1 : Collinear K V p5 p6 q1)
    (h13q2 : Collinear K V p1 p3 q2)
    (h25q2 : Collinear K V p2 p5 q2)
    (h46q2 : Collinear K V p4 p6 q2)
    (h14q3 : Collinear K V p1 p4 q3)
    (h25q3 : Collinear K V p2 p5 q3)
    (h36q3 : Collinear K V p3 p6 q3) :
    ∃ (u : Fin 3 → V) (_ : LinearIndependent K u) (φ : K), φ * φ = φ + 1 ∧
      (∃ h : u 0 ≠ 0, Projectivization.mk K (u 0) h = p1) ∧
      (∃ h : u 1 ≠ 0, Projectivization.mk K (u 1) h = p3) ∧
      (∃ h : u 2 ≠ 0, Projectivization.mk K (u 2) h = p5) ∧
      (∃ h : φ • u 0 + u 1 + u 2 ≠ 0, Projectivization.mk K (φ • u 0 + u 1 + u 2) h = p2) ∧
      (∃ h : u 0 + φ • u 1 + u 2 ≠ 0, Projectivization.mk K (u 0 + φ • u 1 + u 2) h = p4) ∧
      (∃ h : u 0 + u 1 + (2 - φ) • u 2 ≠ 0,
        Projectivization.mk K (u 0 + u 1 + (2 - φ) • u 2) h = p6) := by
  classical
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
  -- Frame coordinates of the three triangle vertices.
  obtain ⟨a1, ha1⟩ := (Projectivization.mk_eq_mk_iff' K (u 0) p1.rep hu0 p1.rep_nonzero).mp
    (by rw [hp1, Projectivization.mk_rep])
  obtain ⟨a3, ha3⟩ := (Projectivization.mk_eq_mk_iff' K (u 1) p3.rep hu1 p3.rep_nonzero).mp
    (by rw [hp3, Projectivization.mk_rep])
  obtain ⟨a5, ha5⟩ := (Projectivization.mk_eq_mk_iff' K (u 2) p5.rep hu2 p5.rep_nonzero).mp
    (by rw [hp5, Projectivization.mk_rep])
  have ha1ne : a1 ≠ 0 := by rintro rfl; rw [zero_smul] at ha1; exact hu0 ha1.symm
  have ha3ne : a3 ≠ 0 := by rintro rfl; rw [zero_smul] at ha3; exact hu1 ha3.symm
  have ha5ne : a5 ≠ 0 := by rintro rfl; rw [zero_smul] at ha5; exact hu2 ha5.symm
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
  -- Frame coordinates of the unit point.
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
  -- The three chords through `x` pin the shapes `(a : s : s)`, `(m : b : m)`, `(n : n : k)`.
  have h2eq : coord hrank hu p2 1 = coord hrank hu p2 2 := by
    have h := (collinear_iff_det_eq_zero hrank hu p1 p2 x).mp h12x
    rw [det_coord_expand, h1_1, h1_2, hx0, hx1, hx2] at h
    have hfac : coord hrank hu p1 0 * (coord hrank hu p2 1 - coord hrank hu p2 2) = 0 := by
      linear_combination h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h1_0ne)
  have h4eq : coord hrank hu p4 0 = coord hrank hu p4 2 := by
    have h := (collinear_iff_det_eq_zero hrank hu p3 p4 x).mp h34x
    rw [det_coord_expand, h3_0, h3_2, hx0, hx1, hx2] at h
    have hfac : coord hrank hu p3 1 * (coord hrank hu p4 0 - coord hrank hu p4 2) = 0 := by
      linear_combination -h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h3_1ne)
  have h6eq : coord hrank hu p6 0 = coord hrank hu p6 1 := by
    have h := (collinear_iff_det_eq_zero hrank hu p5 p6 x).mp h56x
    rw [det_coord_expand, h5_0, h5_1, hx0, hx1, hx2] at h
    have hfac : coord hrank hu p5 2 * (coord hrank hu p6 0 - coord hrank hu p6 1) = 0 := by
      linear_combination h
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h5_2ne)
  -- Abbreviations for the six free entries.
  set A := coord hrank hu p2 0 with hAdef
  set S := coord hrank hu p2 2 with hSdef
  set M := coord hrank hu p4 2 with hMdef
  set B := coord hrank hu p4 1 with hBdef
  set N := coord hrank hu p6 0 with hNdef
  set C := coord hrank hu p6 2 with hCdef
  -- Non-degeneracy of those entries, each from one non-collinearity hypothesis.
  have hSne : S ≠ 0 := by
    intro h0
    apply h132
    rw [collinear_iff_det_eq_zero hrank hu, det_coord_expand, h1_1, h1_2, h3_0, h3_2,
      ← hAdef, h2eq, ← hSdef, h0]
    ring
  have hMne : M ≠ 0 := by
    intro h0
    apply h134
    rw [collinear_iff_det_eq_zero hrank hu, det_coord_expand, h1_1, h1_2, h3_0, h3_2,
      h4eq, ← hMdef, h0]
    ring
  have hCne : C ≠ 0 := by
    intro h0
    apply h136
    rw [collinear_iff_det_eq_zero hrank hu, det_coord_expand, h1_1, h1_2, h3_0, h3_2,
      ← hCdef, h0]
    ring
  have hNne : N ≠ 0 := by
    intro h0
    apply h156
    rw [collinear_iff_det_eq_zero hrank hu, det_coord_expand, h1_1, h1_2, h5_0, h5_1,
      ← h6eq, ← hNdef, h0]
    ring
  have hBne : B ≠ 0 := by
    intro h0
    apply h154
    rw [collinear_iff_det_eq_zero hrank hu, det_coord_expand, h1_1, h1_2, h5_0, h5_1,
      ← hBdef, h0]
    ring
  have hAne : A ≠ 0 := by
    intro h0
    apply h352
    rw [collinear_iff_det_eq_zero hrank hu, det_coord_expand, h3_0, h3_2, h5_0, h5_1,
      ← hAdef, h0]
    ring
  -- First concurrence: the chords `p1p4`, `p2p3`, `p5p6` meet at `q1`, giving `B * S = M * A`.
  have hBS : B * S = M * A := by
    have e14 : B * coord hrank hu q1 2 = M * coord hrank hu q1 1 := by
      have h := (collinear_iff_det_eq_zero hrank hu p1 p4 q1).mp h14q1
      rw [det_coord_expand, h1_1, h1_2, h4eq, ← hMdef, ← hBdef] at h
      have hfac : coord hrank hu p1 0 *
          (B * coord hrank hu q1 2 - M * coord hrank hu q1 1) = 0 := by linear_combination h
      exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h1_0ne)
    have e23 : A * coord hrank hu q1 2 = S * coord hrank hu q1 0 := by
      have h := (collinear_iff_det_eq_zero hrank hu p2 p3 q1).mp h23q1
      rw [det_coord_expand, h3_0, h3_2, ← hAdef, h2eq, ← hSdef] at h
      have hfac : coord hrank hu p3 1 *
          (A * coord hrank hu q1 2 - S * coord hrank hu q1 0) = 0 := by linear_combination h
      exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h3_1ne)
    have e56 : coord hrank hu q1 1 = coord hrank hu q1 0 := by
      have h := (collinear_iff_det_eq_zero hrank hu p5 p6 q1).mp h56q1
      rw [det_coord_expand, h5_0, h5_1, ← h6eq, ← hNdef] at h
      have hfac : coord hrank hu p5 2 * N *
          (coord hrank hu q1 1 - coord hrank hu q1 0) = 0 := by linear_combination h
      have := (mul_eq_zero.mp hfac).resolve_left (mul_ne_zero h5_2ne hNne)
      exact sub_eq_zero.mp this
    have hq12ne : coord hrank hu q1 2 ≠ 0 := by
      intro h0
      have h1 : M * coord hrank hu q1 1 = 0 := by rw [← e14, h0]; ring
      have hq11 : coord hrank hu q1 1 = 0 := (mul_eq_zero.mp h1).resolve_left hMne
      have hq10 : coord hrank hu q1 0 = 0 := by rw [← e56, hq11]
      rcases exists_coord_ne_zero hrank hu q1 with h | h | h
      · exact h hq10
      · exact h hq11
      · exact h h0
    have hfac : coord hrank hu q1 2 * (B * S - M * A) = 0 := by
      linear_combination S * e14 - M * e23 + M * S * e56
    exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left hq12ne)
  -- Third concurrence: the chords `p1p4`, `p2p5`, `p3p6` meet at `q3`, giving `A * B * C = M*S*N`.
  have hprod : A * B * C = M * S * N := by
    have e14 : B * coord hrank hu q3 2 = M * coord hrank hu q3 1 := by
      have h := (collinear_iff_det_eq_zero hrank hu p1 p4 q3).mp h14q3
      rw [det_coord_expand, h1_1, h1_2, h4eq, ← hMdef, ← hBdef] at h
      have hfac : coord hrank hu p1 0 *
          (B * coord hrank hu q3 2 - M * coord hrank hu q3 1) = 0 := by linear_combination h
      exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h1_0ne)
    have e25 : A * coord hrank hu q3 1 = S * coord hrank hu q3 0 := by
      have h := (collinear_iff_det_eq_zero hrank hu p2 p5 q3).mp h25q3
      rw [det_coord_expand, h5_0, h5_1, ← hAdef, h2eq, ← hSdef] at h
      have hfac : coord hrank hu p5 2 *
          (A * coord hrank hu q3 1 - S * coord hrank hu q3 0) = 0 := by linear_combination -h
      exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h5_2ne)
    have e36 : N * coord hrank hu q3 2 = C * coord hrank hu q3 0 := by
      have h := (collinear_iff_det_eq_zero hrank hu p3 p6 q3).mp h36q3
      rw [det_coord_expand, h3_0, h3_2, ← h6eq, ← hNdef, ← hCdef] at h
      have hfac : coord hrank hu p3 1 *
          (N * coord hrank hu q3 2 - C * coord hrank hu q3 0) = 0 := by linear_combination -h
      exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h3_1ne)
    have hq32ne : coord hrank hu q3 2 ≠ 0 := by
      intro h0
      have h1 : M * coord hrank hu q3 1 = 0 := by rw [← e14, h0]; ring
      have hq31 : coord hrank hu q3 1 = 0 := (mul_eq_zero.mp h1).resolve_left hMne
      have h2 : S * coord hrank hu q3 0 = 0 := by rw [← e25, hq31]; ring
      have hq30 : coord hrank hu q3 0 = 0 := (mul_eq_zero.mp h2).resolve_left hSne
      rcases exists_coord_ne_zero hrank hu q3 with h | h | h
      · exact h hq30
      · exact h hq31
      · exact h h0
    have hq30ne : coord hrank hu q3 0 ≠ 0 := by
      intro h0
      have h1 : N * coord hrank hu q3 2 = 0 := by rw [e36, h0]; ring
      exact hq32ne ((mul_eq_zero.mp h1).resolve_left hNne)
    have hfac : coord hrank hu q3 2 * coord hrank hu q3 0 * (A * B * C - M * S * N) = 0 := by
      linear_combination (A * C * coord hrank hu q3 0) * e14
        + (M * C * coord hrank hu q3 0) * e25 - (M * S * coord hrank hu q3 0) * e36
    have := (mul_eq_zero.mp hfac).resolve_left (mul_ne_zero hq32ne hq30ne)
    exact sub_eq_zero.mp this
  -- Second concurrence: the chords `p1p3`, `p2p5`, `p4p6` meet at `q2`, giving the cubic relation.
  have hcubic : A * B * C - M * C * S + M * N * S - M * N * A = 0 := by
    have e13 : coord hrank hu q2 2 = 0 := by
      have h := (collinear_iff_det_eq_zero hrank hu p1 p3 q2).mp h13q2
      rw [det_coord_expand, h1_1, h1_2, h3_0, h3_2] at h
      have hfac : coord hrank hu p1 0 * coord hrank hu p3 1 * coord hrank hu q2 2 = 0 := by
        linear_combination h
      exact (mul_eq_zero.mp hfac).resolve_left (mul_ne_zero h1_0ne h3_1ne)
    have e25 : A * coord hrank hu q2 1 = S * coord hrank hu q2 0 := by
      have h := (collinear_iff_det_eq_zero hrank hu p2 p5 q2).mp h25q2
      rw [det_coord_expand, h5_0, h5_1, ← hAdef, h2eq, ← hSdef] at h
      have hfac : coord hrank hu p5 2 *
          (A * coord hrank hu q2 1 - S * coord hrank hu q2 0) = 0 := by linear_combination -h
      exact sub_eq_zero.mp ((mul_eq_zero.mp hfac).resolve_left h5_2ne)
    have e46 : M * C * coord hrank hu q2 1 - B * C * coord hrank hu q2 0
        - M * N * coord hrank hu q2 1 + M * N * coord hrank hu q2 0 = 0 := by
      have h := (collinear_iff_det_eq_zero hrank hu p4 p6 q2).mp h46q2
      rw [det_coord_expand, h4eq, ← hMdef, ← hBdef, ← h6eq, ← hNdef, ← hCdef, e13] at h
      linear_combination -h
    have hq20ne : coord hrank hu q2 0 ≠ 0 := by
      intro h0
      have h1 : A * coord hrank hu q2 1 = 0 := by rw [e25, h0]; ring
      have hq21 : coord hrank hu q2 1 = 0 := (mul_eq_zero.mp h1).resolve_left hAne
      rcases exists_coord_ne_zero hrank hu q2 with h | h | h
      · exact h h0
      · exact h hq21
      · exact h e13
    have hfac : coord hrank hu q2 0 * (A * B * C - M * C * S + M * N * S - M * N * A) = 0 := by
      linear_combination (-A) * e46 + (M * C - M * N) * e25
    exact (mul_eq_zero.mp hfac).resolve_left hq20ne
  -- Eliminate: the three relations force the golden relation on `φ = A / S`.
  set φ := A / S with hφdef
  have hAφ : A = φ * S := by rw [hφdef]; field_simp
  have hBφ : B = φ * M := by
    have : B * S = φ * M * S := by rw [hBS, hAφ]; ring
    exact mul_right_cancel₀ hSne this
  have hsum : C * S + N * A = 2 * (N * S) := by
    have h := hcubic
    rw [hprod] at h
    have hfac : M * (C * S + N * A - 2 * (N * S)) = 0 := by linear_combination -h
    have h' := (mul_eq_zero.mp hfac).resolve_left hMne
    linear_combination h'
  have hCφ : C = (2 - φ) * N := by
    have h : C * S = (2 - φ) * N * S := by
      rw [hAφ] at hsum
      linear_combination hsum
    exact mul_right_cancel₀ hSne h
  have hφcubic : φ * φ * (2 - φ) = 1 := by
    have h := hprod
    rw [hAφ, hBφ, hCφ] at h
    have hne : S * M * N ≠ 0 := mul_ne_zero (mul_ne_zero hSne hMne) hNne
    apply mul_right_cancel₀ hne
    linear_combination h
  have hφne1 : φ ≠ 1 := by
    intro h1
    apply hp2x
    have hArep : A = S := by rw [hAφ, h1]; ring
    have hrep : p2.rep = S • x.rep := by
      have h := coordOf_spec hrank hu p2.rep
      have hxr := hxrep
      rw [show coordOf hrank hu p2.rep = coord hrank hu p2 from rfl, ← hAdef, h2eq, ← hSdef,
        hArep] at h
      rw [← h, ← hxr, smul_add, smul_add]
    have hSne' : S ≠ 0 := hSne
    calc p2 = Projectivization.mk K p2.rep p2.rep_nonzero := (Projectivization.mk_rep p2).symm
      _ = Projectivization.mk K x.rep x.rep_nonzero := by
          rw [Projectivization.mk_eq_mk_iff' K p2.rep x.rep p2.rep_nonzero x.rep_nonzero]
          exact ⟨S, hrep.symm⟩
      _ = x := Projectivization.mk_rep x
  have hgolden : φ * φ = φ + 1 := by
    have hfac : (φ - 1) * (φ * φ - φ - 1) = 0 := by linear_combination -hφcubic
    have := (mul_eq_zero.mp hfac).resolve_left (sub_ne_zero.mpr hφne1)
    linear_combination this
  -- Assemble the normal form.
  refine ⟨u, hu, φ, hgolden, ⟨hu0, hp1⟩, ⟨hu1, hp3⟩, ⟨hu2, hp5⟩, ?_, ?_, ?_⟩
  · have hrep : p2.rep = S • (φ • u 0 + u 1 + u 2) := by
      have h := coordOf_spec hrank hu p2.rep
      rw [show coordOf hrank hu p2.rep = coord hrank hu p2 from rfl, ← hAdef, h2eq, ← hSdef,
        hAφ] at h
      rw [← h, smul_add, smul_add, smul_smul]
      ring_nf
    have hne : φ • u 0 + u 1 + u 2 ≠ 0 := by
      intro h0
      rw [h0, smul_zero] at hrep
      exact p2.rep_nonzero hrep
    refine ⟨hne, ?_⟩
    symm
    calc p2 = Projectivization.mk K p2.rep p2.rep_nonzero := (Projectivization.mk_rep p2).symm
      _ = Projectivization.mk K (φ • u 0 + u 1 + u 2) hne := by
          rw [Projectivization.mk_eq_mk_iff' K p2.rep _ p2.rep_nonzero hne]
          exact ⟨S, hrep.symm⟩
  · have hrep : p4.rep = M • (u 0 + φ • u 1 + u 2) := by
      have h := coordOf_spec hrank hu p4.rep
      rw [show coordOf hrank hu p4.rep = coord hrank hu p4 from rfl, h4eq, ← hMdef, ← hBdef,
        hBφ] at h
      rw [← h, smul_add, smul_add, smul_smul]
      ring_nf
    have hne : u 0 + φ • u 1 + u 2 ≠ 0 := by
      intro h0
      rw [h0, smul_zero] at hrep
      exact p4.rep_nonzero hrep
    refine ⟨hne, ?_⟩
    symm
    calc p4 = Projectivization.mk K p4.rep p4.rep_nonzero := (Projectivization.mk_rep p4).symm
      _ = Projectivization.mk K (u 0 + φ • u 1 + u 2) hne := by
          rw [Projectivization.mk_eq_mk_iff' K p4.rep _ p4.rep_nonzero hne]
          exact ⟨M, hrep.symm⟩
  · have hrep : p6.rep = N • (u 0 + u 1 + (2 - φ) • u 2) := by
      have h := coordOf_spec hrank hu p6.rep
      rw [show coordOf hrank hu p6.rep = coord hrank hu p6 from rfl, ← h6eq, ← hNdef,
        ← hCdef, hCφ] at h
      rw [← h, smul_add, smul_add, smul_smul]
      ring_nf
    have hne : u 0 + u 1 + (2 - φ) • u 2 ≠ 0 := by
      intro h0
      rw [h0, smul_zero] at hrep
      exact p6.rep_nonzero hrep
    refine ⟨hne, ?_⟩
    symm
    calc p6 = Projectivization.mk K p6.rep p6.rep_nonzero := (Projectivization.mk_rep p6).symm
      _ = Projectivization.mk K (u 0 + u 1 + (2 - φ) • u 2) hne := by
          rw [Projectivization.mk_eq_mk_iff' K p6.rep _ p6.rep_nonzero hne]
          exact ⟨N, hrep.symm⟩

#print axioms golden_normal_form_of_concurrent_matchings

end GoldenHexagonNormalForm
end RelativeConicArcs
