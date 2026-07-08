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
