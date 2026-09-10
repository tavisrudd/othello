import Mathlib.Tactic
import Mathlib.RingTheory.PowerSeries.Inverse

/-!
# Formal constancy of an idempotent image

An idempotent formal series over any possibly noncommutative ring is conjugate
to its constant idempotent by a unit whose constant term is one. The explicit
intertwiner is p e + (1-p)(1-e), where e is the constant idempotent. If the
coefficient ring is a ring of equivariant endomorphisms, this construction
stays in that ring and hence preserves the full representation image. No
invariant-vector operation or assumed constancy of representation classes
enters the argument.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The elementary intertwiner between two idempotents. -/
def idempotentIntertwiner {A : Type*} [Ring A] (p e : A) : A :=
  p*e+(1-p)*(1-e)

/-- The elementary intertwiner carries the image of the second idempotent
to the image of the first, as an exact ring identity. -/
theorem idempotentIntertwiner_intertwines {A : Type*} [Ring A]
    (p e : A) (hp : p*p=p) (he : e*e=e) :
    p * idempotentIntertwiner p e = idempotentIntertwiner p e * e := by
  simp only [idempotentIntertwiner, mul_add, add_mul, sub_mul, mul_sub,
    mul_one, one_mul, ← mul_assoc, hp]
  simp only [mul_assoc, he]
  abel

/-- The elementary intertwiner of an idempotent with itself is one. -/
theorem idempotentIntertwiner_self {A : Type*} [Ring A] (e : A) (he : e*e=e) :
    idempotentIntertwiner e e=1 := by
  simp only [idempotentIntertwiner, sub_mul, mul_sub, one_mul, mul_one, he]
  abel

/-- Every formal idempotent is conjugate to its constant idempotent by a
constructed unit with constant coefficient one. -/
theorem formalIdempotent_conjugate_constant
    {A : Type*} [Ring A] (p : PowerSeries A) (idempotent : p*p=p) :
    ∃ u : (PowerSeries A)ˣ, PowerSeries.constantCoeff (u : PowerSeries A)=1 ∧
      p=(u : PowerSeries A) * PowerSeries.C (PowerSeries.constantCoeff p) * (↑(u⁻¹) : PowerSeries A) := by
  let e := PowerSeries.C (PowerSeries.constantCoeff p)
  have constantIdempotent : PowerSeries.constantCoeff p * PowerSeries.constantCoeff p=
      PowerSeries.constantCoeff p := by
    simpa only [map_mul] using congrArg PowerSeries.constantCoeff idempotent
  have he : e*e=e := by
    dsimp [e]
    rw [← map_mul, constantIdempotent]
  let comparison := idempotentIntertwiner p e
  have constantOne : PowerSeries.constantCoeff comparison=1 := by
    simpa only [comparison, idempotentIntertwiner, map_add, map_mul, map_sub, map_one,
      e, PowerSeries.constantCoeff_C] using idempotentIntertwiner_self
        (PowerSeries.constantCoeff p) constantIdempotent
  have unit : IsUnit comparison := PowerSeries.isUnit_iff_constantCoeff.mpr (constantOne ▸ isUnit_one)
  obtain ⟨u,hu⟩ := unit
  refine ⟨u,hu ▸ constantOne,?_⟩
  have intertwines := idempotentIntertwiner_intertwines p e idempotent he
  change p*comparison=comparison*e at intertwines
  rw [← hu] at intertwines
  have h := congrArg (fun x : PowerSeries A => x * (↑(u⁻¹) : PowerSeries A)) intertwines
  simpa [mul_assoc] using h

/-- An idempotent over a multivariate formal base is conjugate to its constant
idempotent by a unit whose constant coefficient is one. The coefficient ring
may be a noncommutative ring of equivariant endomorphisms. -/
theorem multivariateFormalIdempotent_conjugate_constant
    {A σ : Type*} [Ring A] (p : MvPowerSeries σ A) (idempotent : p*p=p) :
    ∃ u : (MvPowerSeries σ A)ˣ, MvPowerSeries.constantCoeff (u : MvPowerSeries σ A)=1 ∧
      p=(u : MvPowerSeries σ A) * MvPowerSeries.C (MvPowerSeries.constantCoeff p) * (↑(u⁻¹) : MvPowerSeries σ A) := by
  let e : MvPowerSeries σ A := MvPowerSeries.C (MvPowerSeries.constantCoeff p)
  have constantIdempotent : MvPowerSeries.constantCoeff p * MvPowerSeries.constantCoeff p=
      MvPowerSeries.constantCoeff p := by
    simpa only [map_mul] using congrArg MvPowerSeries.constantCoeff idempotent
  have he : e*e=e := by
    dsimp [e]
    rw [← map_mul, constantIdempotent]
  let comparison := idempotentIntertwiner p e
  have constantOne : MvPowerSeries.constantCoeff comparison=1 := by
    simpa only [comparison, idempotentIntertwiner, map_add, map_mul, map_sub, map_one,
      e, MvPowerSeries.constantCoeff_C] using idempotentIntertwiner_self
        (MvPowerSeries.constantCoeff p) constantIdempotent
  have unit : IsUnit comparison := MvPowerSeries.isUnit_iff_constantCoeff.mpr (constantOne ▸ isUnit_one)
  obtain ⟨u,hu⟩ := unit
  refine ⟨u,hu ▸ constantOne,?_⟩
  have intertwines := idempotentIntertwiner_intertwines p e idempotent he
  change p*comparison=comparison*e at intertwines
  rw [← hu] at intertwines
  have h := congrArg (fun x : MvPowerSeries σ A => x * (↑(u⁻¹) : MvPowerSeries σ A)) intertwines
  simpa [mul_assoc] using h

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
