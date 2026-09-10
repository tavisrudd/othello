import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.ExactResidueSelectors

/-!
# Exact residue of the classical even curve connection

In the adapted order (point class, unit), the centered leading matrix has only
its upper-right entry nonzero and the regular grading is diagonal with entries
minus one-half and one-half. The elementary modification has equal diagonal
residues and zero discriminant. This computes the residue from the actual
formal loop coefficients; geometric identification with a curve connection
and the treatment of elliptic and projective-line spectra are separate inputs.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The pole-cleared classical curve loop in the adapted point/unit frame. -/
noncomputable def classicalCurveAdaptedLoop
    {K : Type*} [Field K] [CharZero K] (euler : K) :
    PowerSeries (Matrix (Fin 2) (Fin 2) K) :=
  PowerSeries.mk fun n => if n=0 then !![0,euler;0,0]
    else if n=1 then !![-1/2,0;0,1/2] else 0

/-- The actual modified residue has equal diagonal entries and vanishing
lower-left entry, with the Euler characteristic appearing only off diagonal. -/
theorem classicalCurveAdaptedLoop_modifiedResidue
    {K : Type*} [Field K] [CharZero K] (euler : K) :
    modifiedResidue (classicalCurveAdaptedLoop euler)=!![-1/2,euler;0,-1/2] := by
  rw [modifiedResidue_eq]
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [classicalCurveAdaptedLoop]

/-- Classical curve loops have zero exact-residue discriminant, hence zero
exact-spectrum atom, including the full resonant convention. -/
theorem classicalCurveAdaptedLoop_exactSpectrum_zero
    {K : Type*} [Field K] [CharZero K] (euler : K) :
    residueDiscriminant (modifiedResidue (classicalCurveAdaptedLoop euler))=0 ∧
      rankTwoExactSpectrumAtom (classicalCurveAdaptedLoop euler)=0 := by
  have discriminant : residueDiscriminant (modifiedResidue (classicalCurveAdaptedLoop euler))=0 := by
    rw [classicalCurveAdaptedLoop_modifiedResidue]
    norm_num [residueDiscriminant, Matrix.trace_fin_two, Matrix.det_fin_two]
  refine ⟨discriminant,?_⟩
  simp [rankTwoExactSpectrumAtom, discriminant, exactDiscriminantAtom]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
