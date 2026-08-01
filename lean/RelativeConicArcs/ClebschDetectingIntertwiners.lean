import RelativeConicArcs.ClebschDetectingModuleVanishings

/-!
# Generator tests for detecting-module intertwiners

The detecting-module exclusions reduce to two elementary linear arguments.  In the first, a
source generator is killed by a divided power, while one target coefficient detects every
nonzero multiple of the only possible image.  In characteristic three, a second generator maps
to a second one-dimensional weight space; the lowering coefficient kills the first image and the
raising relation then kills the second.

This module proves those implications for linear intertwiners.  Its hypotheses name the precise
representation-theoretic identifications still required in an application: cyclic generation,
the one-dimensional target weight spaces, and intertwining of the displayed divided powers.  No
Hom-space vanishing is assumed.
-/

namespace RelativeConicArcs.ClebschDetectingIntertwiners

variable {k S T : Type*} [Field k] [AddCommGroup S] [Module k S]
  [AddCommGroup T] [Module k T]

/-- A linear map intertwines a selected source operator with a selected target operator. -/
def IntertwinesOperator (f : S →ₗ[k] T) (source : S →ₗ[k] S)
    (target : T →ₗ[k] T) : Prop :=
  ∀ x, f (source x) = target (f x)

/-- A vector detects a family of linear maps when vanishing on that vector forces the whole map
to vanish.  For a cyclic highest-weight module this follows from generation by the negative root
operators. -/
def DetectsLinearMaps (g : S) : Prop :=
  ∀ f : S →ₗ[k] T, f g = 0 → f = 0

/-- A divided-power coefficient excludes an intertwiner whose source generator satisfies the
corresponding zero relation. -/
theorem eq_zero_of_detected_dividedPower_coefficient
    (g : S) (X : T) (source : S →ₗ[k] S) (target : T →ₗ[k] T)
    (coefficient : T →ₗ[k] k) (detected : DetectsLinearMaps (k := k) (T := T) g)
    (hsource : source g = 0) (targetCoefficient : k)
    (htarget : coefficient (target X) = targetCoefficient)
    (htargetCoefficient : targetCoefficient ≠ 0)
    (f : S →ₗ[k] T) (hf : IntertwinesOperator f source target)
    (alpha : k) (hhead : f g = alpha • X) :
    f = 0 := by
  have hzero : target (f g) = 0 := by
    rw [← hf, hsource, map_zero]
  have halpha : alpha * targetCoefficient = 0 := by
    have := congrArg coefficient hzero
    simpa [hhead, htarget] using this
  have : alpha = 0 := (mul_eq_zero.mp halpha).resolve_right htargetCoefficient
  apply detected f
  simp [hhead, this]

/-- Two selected vectors detect a family of maps when zero images of both vectors force the map
to vanish.  This is the generator statement for the two-section characteristic-three source. -/
def DetectsLinearMapsPair (g v : S) : Prop :=
  ∀ f : S →ₗ[k] T, f g = 0 → f v = 0 → f = 0

/-- Characteristic-three two-generator exclusion.  A lowering coefficient first kills the image
of `g`; the relation `E v = g`, together with `E Y = X`, then kills the image of `v`. -/
theorem eq_zero_of_two_generator_relations
    (g v : S) (X Y : T)
    (lowerSource raisingSource : S →ₗ[k] S)
    (lowerTarget raisingTarget : T →ₗ[k] T)
    (coefficient : T →ₗ[k] k)
    (detected : DetectsLinearMapsPair (k := k) (T := T) g v)
    (hlowerSource : lowerSource g = 0)
    (hraiseSource : raisingSource v = g)
    (hlowerCoefficient : coefficient (lowerTarget X) = 2)
    (hX : X ≠ 0) (hraiseTarget : raisingTarget Y = X)
    (f : S →ₗ[k] T)
    (hlower : IntertwinesOperator f lowerSource lowerTarget)
    (hraise : IntertwinesOperator f raisingSource raisingTarget)
    (alpha beta : k) (hg : f g = alpha • X) (hv : f v = beta • Y)
    (htwo : (2 : k) ≠ 0) :
    f = 0 := by
  have hlowerZero : lowerTarget (f g) = 0 := by
    rw [← hlower, hlowerSource, map_zero]
  have halphaMul : alpha * 2 = 0 := by
    have := congrArg coefficient hlowerZero
    simpa [hg, hlowerCoefficient] using this
  have halpha : alpha = 0 := (mul_eq_zero.mp halphaMul).resolve_right htwo
  have hfg : f g = 0 := by simp [hg, halpha]
  have hraiseImage : raisingTarget (f v) = 0 := by
    rw [← hraise, hraiseSource, hfg]
  have hbetaSmul : beta • X = 0 := by
    simpa [hv, hraiseTarget] using hraiseImage
  have hbeta : beta = 0 := by
    by_contra hb
    exact hX ((smul_eq_zero.mp hbetaSmul).resolve_left hb)
  apply detected f hfg
  simp [hv, hbeta]

end RelativeConicArcs.ClebschDetectingIntertwiners
