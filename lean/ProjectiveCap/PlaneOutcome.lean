import ProjectiveCap.ConicLocalization
import ProjectiveCap.EscapeParity
import ProjectiveCap.GridMirror

/-!
# Projective-plane outcome bridges

This file composes the residual odd-plane kernels with the rank-three
projective cap-game theorem.  The hard open theorem remains the residual
odd-escape/on-conic statement; these lemmas make the downstream consequence
explicit.
-/

namespace ProjectiveCap

variable {K V : Type*} [Field K] [Fintype K] [DecidableEq K]
variable [AddCommGroup V] [Module K V]
variable [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]

/-- A finite field of even cardinality has characteristic two, in the form
needed by the characteristic-two mirror theorem. -/
theorem two_eq_zero_of_even_card (hcard : Even (Fintype.card K)) :
    (2 : K) = 0 := by
  classical
  by_contra h2
  have hnonzeroEven : Even ((Finset.univ : Finset K).erase 0).card :=
    ConicLocalization.even_card_of_involutive_fpf_on_finset
      ((Finset.univ : Finset K).erase 0) (fun x : K => -x)
      (fun x hx => by
        simp only [Finset.mem_erase, Finset.mem_univ, and_true] at hx ⊢
        exact neg_ne_zero.mpr hx)
      (fun x _hx => by simp)
      (fun x hx hfix => by
        simp only [Finset.mem_erase, Finset.mem_univ, and_true] at hx
        have hmul : (2 : K) * x = 0 := by
          have hsum : x + x = 0 := by
            nth_rewrite 2 [← hfix]
            exact add_neg_cancel x
          simpa [two_mul] using hsum
        rcases mul_eq_zero.mp hmul with htwo | hxzero
        · exact h2 htwo
        · exact hx hxzero)
  obtain ⟨n, hn⟩ := hnonzeroEven
  have hcardErase : ((Finset.univ : Finset K).erase 0).card = Fintype.card K - 1 := by
    simp
  have hcardOdd : Odd (Fintype.card K) := by
    refine ⟨n, ?_⟩
    have hpos : 0 < Fintype.card K := Fintype.card_pos_iff.mpr ⟨(0 : K)⟩
    omega
  exact (Nat.not_odd_iff_even.mpr hcard) hcardOdd

/-- Even-cardinality projective-plane theorem in any rank-three model. -/
theorem initialPStatement_of_even_card_finrank
    (hcard : Even (Fintype.card K))
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) :=
  GridMirror.initialPStatement_of_charTwo_finrank
    (K := K) (V := V) (two_eq_zero_of_even_card (K := K) hcard) hrank

/-- The residual bad-parity criterion implies the full projective-plane outcome
in any odd-cardinality rank-three model. -/
theorem initialPStatement_of_forall_even_bad_finrank
    (hq : Odd (Fintype.card K))
    (hbad : ∀ S : Finset (GridPoint K), S.card = 3 -> GridCap (K := K) S ->
      Even (GridGame.BadExtensions (K := K) S).card)
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) :=
  GridMirror.initialPStatement_of_oddEscapeStatement_finrank
    (K := K) (V := V)
    (oddEscapeGameStatement_of_forall_even_bad (K := K) hq hbad) hrank

namespace ConicLocalization

variable {K V : Type*} [Field K] [Fintype K] [DecidableEq K]
variable [AddCommGroup V] [Module K V]
variable [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]

/-- The on-conic escape refinement implies the full projective-plane outcome
in any rank-three model. -/
theorem initialPStatement_of_onConicEscapeStatement_finrank
    (hON : OnConicEscapeStatement (K := K))
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) :=
  GridMirror.initialPStatement_of_oddEscapeStatement_finrank
    (K := K) (V := V)
    (oddEscapeStatement_of_onConicEscapeStatement (K := K) hON) hrank

/-- The on-conic bad-even reduction implies the full projective-plane outcome
in any odd-cardinality rank-three model. -/
theorem initialPStatement_of_forall_even_onConic_bad_finrank
    (hq : Odd (Fintype.card K))
    (hbad : ∀ S : Finset (GridPoint K), ∀ rho A B : K,
      S.card = 3 ->
      GridCap (K := K) S ->
      B ≠ 0 ->
      HyperbolaFits (K := K) S rho A B ->
        Even (OnConicBadExtensions (K := K) S rho A B).card)
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) :=
  initialPStatement_of_onConicEscapeStatement_finrank
    (K := K) (V := V)
    (onConicEscapeStatement_of_forall_even_onConic_bad
      (K := K) hq hbad) hrank

/-- The restricted `psi_u` pairing criterion implies the full projective-plane
outcome in any odd-cardinality rank-three model. -/
theorem initialPStatement_of_psiPairingCriterion_finrank
    (hq : Odd (Fintype.card K))
    (hpair : OnConicPsiPairingCriterion (K := K))
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) :=
  initialPStatement_of_onConicEscapeStatement_finrank
    (K := K) (V := V)
    (onConicEscapeStatement_of_psiPairingCriterion
      (K := K) hq hpair) hrank

end ConicLocalization
end ProjectiveCap
