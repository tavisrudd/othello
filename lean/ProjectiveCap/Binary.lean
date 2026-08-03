import ProjectiveCap.PlaneTransitivity
import ProjectiveCap.ProjectiveCapGame
import Sumfree.Nonzero

/-!
# Binary projective spaces

Over `ZMod 2`, projective points are just nonzero vectors: the only nonzero
scalar is `1`.  This file starts the bridge between the projective cap game on
`PG(n,2)` and the sum-free/Nofil game on nonzero vectors.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

open Projectivization Module

variable {V : Type*} [AddCommGroup V] [Module (ZMod 2) V]

private theorem zmod2_eq_zero_or_one (x : ZMod 2) : x = 0 ∨ x = 1 := by
  fin_cases x
  · exact Or.inl rfl
  · exact Or.inr rfl

private theorem add_self_eq_zero_zmod2 (x : V) : x + x = 0 := by
  have h : (2 : ℕ) • x = 0 := ZModModule.char_nsmul_eq_zero (n := 2) x
  simpa [two_nsmul] using h

@[simp] theorem binary_mk_rep (v : V) (hv : v ≠ 0) :
    (Projectivization.mk (ZMod 2) v hv).rep = v := by
  obtain ⟨a, ha⟩ :=
    (Projectivization.exists_smul_eq_mk_rep (K := ZMod 2) v hv)
  have ha1 : (a : ZMod 2) = 1 := by
    have ha0 : (a : ZMod 2) ≠ 0 := Units.ne_zero a
    rcases zmod2_eq_zero_or_one (a : ZMod 2) with h0 | h1
    · exact (ha0 h0).elim
    · exact h1
  calc
    (Projectivization.mk (ZMod 2) v hv).rep = (a : ZMod 2) • v := ha.symm
    _ = v := by rw [ha1, one_smul]

/-- In characteristic two with base field `ZMod 2`, projective points are
equivalent to nonzero vectors. -/
noncomputable def binaryPointEquivNonzero :
    Point (ZMod 2) V ≃ {v : V // v ≠ 0} where
  toFun p := ⟨p.rep, p.rep_nonzero⟩
  invFun v := Projectivization.mk (ZMod 2) v.1 v.2
  left_inv p := by
    exact Projectivization.mk_rep p
  right_inv v := by
    apply Subtype.ext
    exact binary_mk_rep v.1 v.2

/-- Over `F₂`, the relation `a + b = c` among representatives makes the
corresponding projective points collinear. -/
theorem binary_collinear_of_rep_add_eq {a b c : Point (ZMod 2) V}
    (h : a.rep + b.rep = c.rep) :
    Collinear (ZMod 2) V a b c := by
  refine (collinear_iff_dependent (K := ZMod 2) (V := V)).mpr ?_
  rw [dependent_iff_not_independent]
  intro hind
  have hli : LinearIndependent (ZMod 2) ![a.rep, b.rep, c.rep] :=
    independent_triple_iff.mp hind
  have hzero : a.rep + b.rep + c.rep = 0 := by
    calc
      a.rep + b.rep + c.rep = c.rep + c.rep := by rw [h]
      _ = 0 := add_self_eq_zero_zmod2 c.rep
  exact (sum_ne_zero_of_li (K := ZMod 2) (V := V) hli) hzero

/-- For three distinct binary projective points, collinearity is exactly
addition of representatives. -/
theorem rep_add_eq_of_binary_collinear {a b c : Point (ZMod 2) V}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hcol : Collinear (ZMod 2) V a b c) :
    a.rep + b.rep = c.rep := by
  have hmem : c.rep ∈ Submodule.span (ZMod 2) {a.rep, b.rep} :=
    rep_mem_span_pair_of_collinear (K := ZMod 2) (V := V) hab hcol
  rcases (Submodule.mem_span_pair.mp hmem) with ⟨s, t, hst⟩
  rcases zmod2_eq_zero_or_one s with rfl | rfl
  · rcases zmod2_eq_zero_or_one t with rfl | rfl
    · simp at hst
      exact (c.rep_nonzero hst.symm).elim
    · simp at hst
      have hbc_eq : b = c := by
        have hmk :
            Projectivization.mk (ZMod 2) b.rep b.rep_nonzero =
              Projectivization.mk (ZMod 2) c.rep c.rep_nonzero :=
          (Projectivization.mk_eq_mk_iff' (ZMod 2) b.rep c.rep
            b.rep_nonzero c.rep_nonzero).mpr ⟨1, by simp [hst]⟩
        simpa [Projectivization.mk_rep] using hmk
      exact (hbc hbc_eq).elim
  · rcases zmod2_eq_zero_or_one t with rfl | rfl
    · simp at hst
      have hac_eq : a = c := by
        have hmk :
            Projectivization.mk (ZMod 2) a.rep a.rep_nonzero =
              Projectivization.mk (ZMod 2) c.rep c.rep_nonzero :=
          (Projectivization.mk_eq_mk_iff' (ZMod 2) a.rep c.rep
            a.rep_nonzero c.rep_nonzero).mpr ⟨1, by simp [hst]⟩
        simpa [Projectivization.mk_rep] using hmk
      exact (hac hac_eq).elim
    · simpa using hst

section Finite

variable [Fintype V] [DecidableEq V] [Fintype (Point (ZMod 2) V)]
  [DecidableEq (Point (ZMod 2) V)]

/-- The representatives of a finite set of binary projective points, viewed as
ambient vectors. -/
noncomputable def binaryRepFinset (S : Finset (Point (ZMod 2) V)) : Finset V :=
  (S.map (binaryPointEquivNonzero (V := V)).toEmbedding).map
    (Sumfree.Game.nonzeroEmbedding (G := V))

omit [Fintype V] [DecidableEq V] [Fintype (Point (ZMod 2) V)]
  [DecidableEq (Point (ZMod 2) V)] in
@[simp] theorem mem_binaryRepFinset {S : Finset (Point (ZMod 2) V)} {x : V} :
    x ∈ binaryRepFinset (V := V) S ↔ ∃ p ∈ S, p.rep = x := by
  classical
  simp [binaryRepFinset, binaryPointEquivNonzero, Sumfree.Game.nonzeroEmbedding]
  constructor
  · rintro ⟨hx0, hxS⟩
    exact ⟨Projectivization.mk (ZMod 2) x hx0, hxS, by simp⟩
  · rintro ⟨p, hpS, hp⟩
    have hx0 : x ≠ 0 := by
      intro hx
      exact p.rep_nonzero (by simp [hp, hx])
    refine ⟨hx0, ?_⟩
    have hmk :
        Projectivization.mk (ZMod 2) x hx0 = p := by
      have hmk' :
          Projectivization.mk (ZMod 2) x hx0 =
            Projectivization.mk (ZMod 2) p.rep p.rep_nonzero :=
        (Projectivization.mk_eq_mk_iff' (ZMod 2) x p.rep
          hx0 p.rep_nonzero).mpr ⟨1, by simp [hp]⟩
      exact hmk'.trans (Projectivization.mk_rep p)
    simpa [hmk] using hpS

omit [Fintype V] [DecidableEq V] [Fintype (Point (ZMod 2) V)]
  [DecidableEq (Point (ZMod 2) V)] in
@[simp] theorem rep_mem_binaryRepFinset {S : Finset (Point (ZMod 2) V)}
    {p : Point (ZMod 2) V} :
    p.rep ∈ binaryRepFinset (V := V) S ↔ p ∈ S := by
  classical
  rw [mem_binaryRepFinset]
  constructor
  · rintro ⟨q, hqS, hq⟩
    have hpq : q = p := by
      have hmk :
          Projectivization.mk (ZMod 2) q.rep q.rep_nonzero =
            Projectivization.mk (ZMod 2) p.rep p.rep_nonzero :=
        (Projectivization.mk_eq_mk_iff' (ZMod 2) q.rep p.rep
          q.rep_nonzero p.rep_nonzero).mpr ⟨1, by simp [hq]⟩
      simpa [Projectivization.mk_rep] using hmk
    simpa [hpq] using hqS
  · intro hpS
    exact ⟨p, hpS, rfl⟩

omit [Fintype V] [DecidableEq V] [Fintype (Point (ZMod 2) V)]
  [DecidableEq (Point (ZMod 2) V)] in
/-- Binary projective caps are exactly sum-free sets of nonzero vector
representatives. -/
theorem binary_nonzeroValid_iff_cap (S : Finset (Point (ZMod 2) V)) :
    Sumfree.Game.NonzeroValid (G := V)
      (S.map (binaryPointEquivNonzero (V := V)).toEmbedding) ↔
      Cap (ZMod 2) V S := by
  classical
  change Sumfree.Game.Valid (binaryRepFinset (V := V) S) ↔ Cap (ZMod 2) V S
  constructor
  · intro hvalid a b c ha hb hc hab hac hbc hcol
    have hadd : a.rep + b.rep = c.rep :=
      rep_add_eq_of_binary_collinear (V := V) hab hac hbc hcol
    exact hvalid (a := a.rep) (b := b.rep) (c := c.rep)
      ((rep_mem_binaryRepFinset (V := V) (S := S) (p := a)).2 ha)
      ((rep_mem_binaryRepFinset (V := V) (S := S) (p := b)).2 hb)
      ((rep_mem_binaryRepFinset (V := V) (S := S) (p := c)).2 hc)
      hadd
  · intro hcap x y z hx hy hz hsum
    rcases (mem_binaryRepFinset (V := V) (S := S) (x := x)).1 hx with ⟨a, haS, rfl⟩
    rcases (mem_binaryRepFinset (V := V) (S := S) (x := y)).1 hy with ⟨b, hbS, rfl⟩
    rcases (mem_binaryRepFinset (V := V) (S := S) (x := z)).1 hz with ⟨c, hcS, rfl⟩
    have hab : a ≠ b := by
      intro h
      subst b
      have hzero : a.rep + a.rep = 0 := add_self_eq_zero_zmod2 a.rep
      rw [hzero] at hsum
      exact c.rep_nonzero hsum.symm
    have hac : a ≠ c := by
      intro h
      subst c
      have hb0 : b.rep = 0 := by
        have h := congrArg (fun t => t + a.rep) hsum
        calc
          b.rep = (a.rep + a.rep) + b.rep := by
            rw [add_self_eq_zero_zmod2 a.rep, zero_add]
          _ = a.rep + b.rep + a.rep := by abel
          _ = a.rep + a.rep := h
          _ = 0 := add_self_eq_zero_zmod2 a.rep
      exact b.rep_nonzero hb0
    have hbc : b ≠ c := by
      intro h
      subst c
      have ha0 : a.rep = 0 := by
        have h := congrArg (fun t => t + b.rep) hsum
        calc
          a.rep = a.rep + (b.rep + b.rep) := by
            rw [add_self_eq_zero_zmod2 b.rep, add_zero]
          _ = a.rep + b.rep + b.rep := by abel
          _ = b.rep + b.rep := h
          _ = 0 := add_self_eq_zero_zmod2 b.rep
      exact a.rep_nonzero ha0
    exact (hcap haS hbS hcS hab hac hbc)
      (binary_collinear_of_rep_add_eq (V := V) hsum)

/-- Binary projective spaces of projective dimension at least one are
P-positions for the cap/Nofil game. -/
theorem initialPStatement_binary_of_finrank_ge_two
    (hfinrank : 2 ≤ Module.finrank (ZMod 2) V) :
    InitialPStatement (K := ZMod 2) (V := V) := by
  let e := binaryPointEquivNonzero (V := V)
  have hnonzero :
      FiniteBuildGame.IsP (Sumfree.Game.NonzeroValid (G := V))
        (∅ : Finset {x : V // x ≠ 0}) :=
    Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two (G := V) hfinrank
  change FiniteBuildGame.IsP (Cap (ZMod 2) V) (∅ : Finset (Point (ZMod 2) V))
  exact (FiniteBuildGame.isP_equiv
    (α := Point (ZMod 2) V) (β := {x : V // x ≠ 0})
    (Validα := Cap (ZMod 2) V) (Validβ := Sumfree.Game.NonzeroValid (G := V))
    e binary_nonzeroValid_iff_cap
    (∅ : Finset (Point (ZMod 2) V))).mp (by simpa [e] using hnonzero)

/-- Projective-dimension formulation: if `finrank V = n + 1` with `n ≥ 1`,
then `PG(n,2)` is a P-position for the cap/Nofil game. -/
theorem initialPStatement_binary_of_projectiveDim_ge_one {n : ℕ}
    (hn : 1 ≤ n) (hfinrank : Module.finrank (ZMod 2) V = n + 1) :
    InitialPStatement (K := ZMod 2) (V := V) := by
  apply initialPStatement_binary_of_finrank_ge_two (V := V)
  omega

end Finite

end Projective
end ProjectiveCap
