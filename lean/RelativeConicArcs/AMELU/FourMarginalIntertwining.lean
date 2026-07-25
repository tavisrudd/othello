import RelativeConicArcs.AMELU.StateMarginalCovariance
import RelativeConicArcs.AMELU.MarginalAxisRigidity

/-!
# Four-party marginal intertwining from a local-unitary equality

Reduced-matrix covariance is transported through the subsystem
product-Weyl basis and an ordering of the four retained parties.  The
shortening-coordinate relabellings on the source and target cancel
around the ordinary local Weyl-coordinate conjugations, producing the
exact `FourMarginalIntertwining` consumed by the diagonal axis theorem.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Ordinary ordered product-Weyl coefficient array of a reduced
matrix. -/
noncomputable def orderedMarginalWeylArray
    (w : WeylConvention 𝔽) (ψ : State 𝔽)
    {S : Finset Party} (e : Fin 4 ≃ S) :
    FourArray (𝔽 × 𝔽) :=
  orderedFourArray e
    (subsystemWeylCoordinateEquiv w S
      (fun x y => marginalEntry ψ S x y))

/-- The ordinary ordered coefficient array evaluates to the repository
marginal coefficient at the corresponding ordered local labels. -/
theorem orderedMarginalWeylArray_apply
    (w : WeylConvention 𝔽) (ψ : State 𝔽)
    {S : Finset Party} (e : Fin 4 ≃ S)
    (a b c d : 𝔽 × 𝔽) :
    orderedMarginalWeylArray w ψ e a b c d =
      marginalWeylCoefficient w ψ S
        (fun i => ![a, b, c, d] (e.symm i)) := by
  rw [marginalWeylCoefficient_eq_subsystemCoordinate]
  rfl

/-- Reindexing the ordinary marginal array by the four shortening label
equivalences gives `reindexedFourMarginalArray`. -/
theorem reindexedFourMarginalArray_eq_relabelled
    (w : WeylConvention 𝔽)
    {C : Submodule 𝔽 (BasisLabel 𝔽)} (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S) :
    reindexedFourMarginalArray w hC hS e =
      mapFourArray
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hC hS (e 0).2)).symm
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hC hS (e 1).2)).symm
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hC hS (e 2).2)).symm
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hC hS (e 3).2)).symm
        (orderedMarginalWeylArray w (equalPhaseState C) e) := by
  funext a b c d
  simp only [reindexedFourMarginalArray,
    orderedMarginalWeylArray, orderedFourArray,
    mapFourArray, mapFourFirst, mapFourSecond, mapFourThird,
    mapFourFourth, relabelCoordinateEquiv]
  rw [marginalWeylCoefficient_eq_subsystemCoordinate]
  apply congrArg
  funext i
  unfold reindexedFourLabels
  generalize hj : e.symm i = j
  have he : e j = i := by
    rw [← hj, e.apply_symm_apply]
  subst i
  fin_cases j <;> rfl

private theorem transportedLocalConjugation_cancel_source
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    {S : Finset Party} (hS : S.card = 4)
    {i : Party} (hi : i ∈ S)
    (U : LocalMatrix 𝔽) (hU : IsUnitaryMatrix U)
    (f : 𝔽 × 𝔽 → ℂ) :
    transportedLocalConjugation w hC hD hS hi U hU
        ((relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hC hS hi)).symm f) =
      (relabelCoordinateEquiv
        (shorteningLocalLabelEquiv hD hS hi)).symm
          (unitaryConjugationWeylEquiv w U hU f) := by
  change
    (relabelCoordinateEquiv
        (shorteningLocalLabelEquiv hD hS hi)).symm
      (unitaryConjugationWeylEquiv w U hU
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hC hS hi)
          ((relabelCoordinateEquiv
            (shorteningLocalLabelEquiv hC hS hi)).symm f))) =
      _
  rw [(relabelCoordinateEquiv
    (shorteningLocalLabelEquiv hC hS hi)).apply_symm_apply]

private theorem shorteningLocalLabelEquiv_apply_symm_explicit
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C)
    {S : Finset Party} (hS : S.card = 4)
    {i : Party} (hi : i ∈ S) (v : 𝔽 × 𝔽) :
    (((shorteningLocalLabelEquiv hC hS hi).symm v).1 *
        (fourShorteningGenerator C hC S hS).word i,
      ((shorteningLocalLabelEquiv hC hS hi).symm v).2 *
        (fourShorteningGenerator (FiniteGeom.dualCode C)
          (isMDSCode634_dualCode hC) S hS).word i) = v := by
  exact (shorteningLocalLabelEquiv hC hS hi).apply_symm_apply v

private theorem mapFourArray_transported_relabelled
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S)
    (U : Party → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (T : FourArray (𝔽 × 𝔽)) :
    mapFourArray
        (transportedLocalConjugation w hC hD hS (e 0).2
          (U (e 0)) (hU (e 0)))
        (transportedLocalConjugation w hC hD hS (e 1).2
          (U (e 1)) (hU (e 1)))
        (transportedLocalConjugation w hC hD hS (e 2).2
          (U (e 2)) (hU (e 2)))
        (transportedLocalConjugation w hC hD hS (e 3).2
          (U (e 3)) (hU (e 3)))
        (mapFourArray
          (relabelCoordinateEquiv
            (shorteningLocalLabelEquiv hC hS (e 0).2)).symm
          (relabelCoordinateEquiv
            (shorteningLocalLabelEquiv hC hS (e 1).2)).symm
          (relabelCoordinateEquiv
            (shorteningLocalLabelEquiv hC hS (e 2).2)).symm
          (relabelCoordinateEquiv
            (shorteningLocalLabelEquiv hC hS (e 3).2)).symm T) =
      mapFourArray
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hD hS (e 0).2)).symm
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hD hS (e 1).2)).symm
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hD hS (e 2).2)).symm
        (relabelCoordinateEquiv
          (shorteningLocalLabelEquiv hD hS (e 3).2)).symm
        (mapFourArray
          (unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0)))
          (unitaryConjugationWeylEquiv w (U (e 1)) (hU (e 1)))
          (unitaryConjugationWeylEquiv w (U (e 2)) (hU (e 2)))
          (unitaryConjugationWeylEquiv w (U (e 3)) (hU (e 3))) T) := by
  funext a b c d
  simp [transportedLocalConjugation, mapFourArray, mapFourFirst,
    mapFourSecond, mapFourThird, mapFourFourth,
    relabelCoordinateEquiv,
    shorteningLocalLabelEquiv_apply_symm_explicit]

/-- A phase-normalized local product action between two equal-phase MDS
states intertwines every ordered four-party marginal in shortening
coordinates. -/
theorem fourMarginalIntertwining_of_localAction_eq
    (w : WeylConvention 𝔽)
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (hC : IsMDSCode634 C) (hD : IsMDSCode634 D)
    (U : Party → LocalMatrix 𝔽) (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (hstate :
      localAction U (equalPhaseState C) =
        phase • equalPhaseState D)
    {S : Finset Party} (hS : S.card = 4) (e : Fin 4 ≃ S) :
    FourMarginalIntertwining w hC hD hS e U hU := by
  classical
  have hmarginal :=
    marginalEntry_eq_product_conjugation_of_localAction_eq
      U hU phase hphase (equalPhaseState C) (equalPhaseState D)
        hstate S
  have hcoordinate := congrArg
    (subsystemWeylCoordinateEquiv w S) hmarginal
  have hsubsystem :
      subsystemUnitaryConjugationWeylEquiv w S
          (fun i => U i.1) (fun i => hU i.1)
          (subsystemWeylCoordinateEquiv w S
            (fun x y => marginalEntry (equalPhaseState C) S x y)) =
        subsystemWeylCoordinateEquiv w S
          (fun x y => marginalEntry (equalPhaseState D) S x y) := by
    simpa [subsystemUnitaryConjugationWeylEquiv,
      subsystemUnitaryConjugationEquiv] using hcoordinate
  have hordered := congrArg (orderedFourArray e) hsubsystem
  rw [orderedFourArray_subsystemUnitaryConjugation] at hordered
  change
    mapFourArray
        (unitaryConjugationWeylEquiv w (U (e 0)) (hU (e 0)))
        (unitaryConjugationWeylEquiv w (U (e 1)) (hU (e 1)))
        (unitaryConjugationWeylEquiv w (U (e 2)) (hU (e 2)))
        (unitaryConjugationWeylEquiv w (U (e 3)) (hU (e 3)))
        (orderedMarginalWeylArray w (equalPhaseState C) e) =
      orderedMarginalWeylArray w (equalPhaseState D) e at hordered
  change
    mapFourArray
        (transportedLocalConjugation w hC hD hS (e 0).2
          (U (e 0)) (hU (e 0)))
        (transportedLocalConjugation w hC hD hS (e 1).2
          (U (e 1)) (hU (e 1)))
        (transportedLocalConjugation w hC hD hS (e 2).2
          (U (e 2)) (hU (e 2)))
        (transportedLocalConjugation w hC hD hS (e 3).2
          (U (e 3)) (hU (e 3)))
        (reindexedFourMarginalArray w hC hS e) =
      reindexedFourMarginalArray w hD hS e
  rw [reindexedFourMarginalArray_eq_relabelled w hC hS e,
    reindexedFourMarginalArray_eq_relabelled w hD hS e]
  rw [mapFourArray_transported_relabelled]
  rw [hordered]

end RelativeConicArcs.AMELU
