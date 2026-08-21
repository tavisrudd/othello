import Mathlib

/-!
# Pointed direct-sum transport

This module records the asymmetric linear algebra used by a blowup quantum
connection decomposition after restricting scalars to a ring over which the
pairing is bilinear. The represented row uses the marked point in the first
pairing slot. A pairing-preserving comparison which sends that point to the
point in the ambient summand makes the row factor
through ambient projection.  Consequently a row-detected vector cannot hide
entirely in the correction summand.  No identification of correction
summands at two consecutive walls is required.

The declarations below do not construct a quantum-D-module decomposition or
prove that its horizontal normalization carries the Gamma point.  Those are
the geometric source inputs. If an application places the point in the second
slot of a sesquilinear or Euler pairing, it must also supply the opposite-slot,
sign, scalar-base, and inverse-character identifications before using these
bilinear statements.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PointedDirectSum

universe uR uV uW uC

variable (R : Type uR) [CommRing R]
variable (V : Type uV) (W : Type uW) (C : Type uC)
variable [AddCommGroup V] [Module R V]
variable [AddCommGroup W] [Module R W]
variable [AddCommGroup C] [Module R C]

/-- The row-only direct-sum interface.  It contains exactly the covectors
needed by the Boolean consumer and does not require either row to be
represented by a point through a pairing. -/
structure RowedComparison where
  comparison : V ≃ₗ[R] W × C
  sourceRow : V →ₗ[R] R
  ambientRow : W →ₗ[R] R
  scale : Rˣ
  rowComparison : ∀ x,
    sourceRow x = (scale : R) * ambientRow (comparison x).1

namespace RowedComparison

variable {R V W C}

/-- Projection from a rowed direct sum to its ambient factor. -/
def ambientProjection (data : RowedComparison R V W C) : V →ₗ[R] W :=
  LinearMap.fst R W C |>.comp data.comparison.toLinearMap

/-- Inclusion of the ambient factor into a rowed direct sum. -/
def ambientInclusion (data : RowedComparison R V W C) : W →ₗ[R] V :=
  data.comparison.symm.toLinearMap.comp (LinearMap.inl R W C)

/-- The source row is the scaled pullback of the ambient row. -/
theorem sourceRow_eq_scale_smul_ambientRow_comp_projection
    (data : RowedComparison R V W C) :
    data.sourceRow =
      (data.scale : R) • (data.ambientRow.comp data.ambientProjection) := by
  apply LinearMap.ext
  intro x
  simpa [ambientProjection] using data.rowComparison x

/-- A value detected by the source row has a nonzero ambient projection. -/
theorem ambientRow_projection_ne_zero
    (data : RowedComparison R V W C) {x : V}
    (rowNonzero : data.sourceRow x ≠ 0) :
    data.ambientRow (data.ambientProjection x) ≠ 0 := by
  intro ambientVanishes
  apply rowNonzero
  have comparisonVanishes : data.ambientRow (data.comparison x).1 = 0 := by
    simpa [ambientProjection] using ambientVanishes
  rw [data.rowComparison, comparisonVanishes, mul_zero]

/-- Vanishing of a row value is reflected exactly by ambient projection. -/
theorem sourceRow_eq_zero_iff_ambientRow_projection_eq_zero
    (data : RowedComparison R V W C) (x : V) :
    data.sourceRow x = 0 ↔
      data.ambientRow (data.ambientProjection x) = 0 := by
  rw [data.rowComparison]
  change (data.scale : R) * data.ambientRow (data.ambientProjection x) = 0 ↔ _
  constructor
  · intro scaledVanishes
    calc
      data.ambientRow (data.ambientProjection x) =
          ((data.scale⁻¹ : Rˣ) : R) *
            ((data.scale : R) * data.ambientRow (data.ambientProjection x)) := by
              simp
      _ = 0 := by rw [scaledVanishes, mul_zero]
  · intro ambientVanishes
    rw [ambientVanishes, mul_zero]

/-- Ambient inclusion carries the ambient row to the source row up to the
same unit scale. -/
theorem sourceRow_ambientInclusion
    (data : RowedComparison R V W C) (x : W) :
    data.sourceRow (data.ambientInclusion x) =
      (data.scale : R) * data.ambientRow x := by
  rw [data.rowComparison]
  simp [ambientInclusion]

/-- The source row is nonzero exactly when the ambient row is nonzero. -/
theorem sourceRow_ne_zero_iff_ambientRow_ne_zero
    (data : RowedComparison R V W C) :
    data.sourceRow ≠ 0 ↔ data.ambientRow ≠ 0 := by
  constructor
  · intro sourceNonzero ambientVanishes
    apply sourceNonzero
    rw [data.sourceRow_eq_scale_smul_ambientRow_comp_projection,
      ambientVanishes]
    simp
  · intro ambientNonzero sourceVanishes
    apply ambientNonzero
    apply LinearMap.ext
    intro x
    have includedRow := data.sourceRow_ambientInclusion x
    rw [sourceVanishes] at includedRow
    have scaledVanishes : (data.scale : R) * data.ambientRow x = 0 := by
      simpa using includedRow.symm
    calc
      data.ambientRow x =
          ((data.scale⁻¹ : Rˣ) : R) *
            ((data.scale : R) * data.ambientRow x) := by simp
      _ = 0 := by rw [scaledVanishes, mul_zero]

end RowedComparison

/-- Generatorwise endpoint-row agreement on one common source.  This record
is independent of pairings and point representatives, so it can be filled
directly by coefficient formulas for two Fourier or gauged endpoint maps. -/
structure CommonSourceGeneratorRows
    (S : Type*) [AddCommGroup S] [Module R S] where
  comparison : V ≃ₗ[R] W × C
  sourceEquiv : S ≃ₗ[R] V
  ambientMap : S →ₗ[R] W
  sourceRow : V →ₗ[R] R
  ambientRow : W →ₗ[R] R
  scale : Rˣ
  mapSquare : ∀ s, (comparison (sourceEquiv s)).1 = ambientMap s
  generators : Set S
  generatorsSpan : Submodule.span R generators = ⊤
  rowAgreementOnGenerators : Set.EqOn
    (sourceRow.comp sourceEquiv.toLinearMap)
    (scale • (ambientRow.comp ambientMap))
    generators

namespace CommonSourceGeneratorRows

/-- Generatorwise common-source agreement constructs the row-only direct-sum
interface by linear extension. -/
def toRowedComparison
    (S : Type*) [AddCommGroup S] [Module R S]
    (data : CommonSourceGeneratorRows R V W C S) :
    RowedComparison R V W C where
  comparison := data.comparison
  sourceRow := data.sourceRow
  ambientRow := data.ambientRow
  scale := data.scale
  rowComparison x := by
    have rowMapEquality :
        data.sourceRow.comp data.sourceEquiv.toLinearMap =
          data.scale • (data.ambientRow.comp data.ambientMap) :=
      LinearMap.ext_on data.generatorsSpan data.rowAgreementOnGenerators
    let s := data.sourceEquiv.symm x
    have sourceIdentity : data.sourceEquiv s = x := by
      exact data.sourceEquiv.apply_symm_apply x
    have rowEquality := LinearMap.congr_fun rowMapEquality s
    change data.sourceRow (data.sourceEquiv s) =
      (data.scale : R) * data.ambientRow (data.ambientMap s) at rowEquality
    rw [← data.mapSquare] at rowEquality
    simpa [sourceIdentity] using rowEquality

end CommonSourceGeneratorRows

/-- A pairing-compatible direct-sum comparison with named source and ambient
points, but no assertion that the comparison carries one point to the other.
This is the level supplied by an uncalibrated formal decomposition. -/
structure UncalibratedData where
  comparison : V ≃ₗ[R] W × C
  pairingV : V →ₗ[R] V →ₗ[R] R
  pairingW : W →ₗ[R] W →ₗ[R] R
  pairingC : C →ₗ[R] C →ₗ[R] R
  pointV : V
  pointW : W
  pairingComparison : ∀ x y,
    pairingV x y =
      pairingW (comparison x).1 (comparison y).1 +
        pairingC (comparison x).2 (comparison y).2

/-- The load-bearing exact flat-point calibration.  Agreement only after a
specialization or only in a leading coefficient is intentionally a different
type and cannot be consumed here. -/
structure ExactPointCalibration (data : UncalibratedData R V W C) : Prop where
  pointComparison : data.comparison data.pointV = (data.pointW, 0)

/-- The exact calibration consumed by the row argument.  This can be
proved directly by a full-variable point-insertion identity, without first
identifying the point vector in the direct sum. Under a perfect target
pairing it is equivalent to exact point calibration; no weaker-QDM claim is
made here. -/
structure ExactRowCalibration (data : UncalibratedData R V W C) : Prop where
  rowComparison : ∀ x,
    data.pairingV data.pointV x =
      data.pairingW data.pointW (data.comparison x).1

/-- The unit-scaled calibration sufficient for preservation of row
nonvanishing. -/
structure ScaledRowCalibration (data : UncalibratedData R V W C) where
  scale : Rˣ
  rowComparison : ∀ x,
    data.pairingV data.pointV x =
      (scale : R) * data.pairingW data.pointW (data.comparison x).1

/-- A common-receiver factorization of the source and ambient rows.  The two
endpoint maps are compared before either row is evaluated, so this record can
be supplied by an augmented common-source or support-localization theorem.
The scale equation is multiplicative and therefore requires no division. -/
structure CommonReceiverRowFactorization
    (S : Type*) [AddCommGroup S] [Module R S]
    (data : UncalibratedData R V W C) where
  sourceMap : V →ₗ[R] S
  ambientMap : W →ₗ[R] S
  receiverRow : S →ₗ[R] R
  sourceScale : Rˣ
  ambientScale : Rˣ
  comparisonScale : Rˣ
  mapSquare : ∀ x, sourceMap x = ambientMap (data.comparison x).1
  sourceRowFactorization : ∀ x,
    data.pairingV data.pointV x =
      (sourceScale : R) * receiverRow (sourceMap x)
  ambientRowFactorization : ∀ y,
    data.pairingW data.pointW y =
      (ambientScale : R) * receiverRow (ambientMap y)
  scaleCompatibility : sourceScale = comparisonScale * ambientScale

namespace CommonReceiverRowFactorization

/-- A common-receiver diagram constructs the unit-scaled row calibration.
This bypasses any uniqueness assertion for a flat point vector: the proof uses
only the two endpoint row factorizations and the displayed map square. -/
def toScaledRowCalibration
    (S : Type*) [AddCommGroup S] [Module R S]
    (data : UncalibratedData R V W C)
    (factorization : CommonReceiverRowFactorization R V W C S data) :
    ScaledRowCalibration R V W C data where
  scale := factorization.comparisonScale
  rowComparison x := by
    rw [factorization.sourceRowFactorization, factorization.mapSquare,
      factorization.ambientRowFactorization]
    have scaleEquality :
        (factorization.sourceScale : R) =
          (factorization.comparisonScale : R) *
            (factorization.ambientScale : R) := by
      exact congrArg ((↑·) : Rˣ → R) factorization.scaleCompatibility
    rw [scaleEquality, mul_assoc]

end CommonReceiverRowFactorization

/-- A common-source factorization of the two endpoint rows.  The source
equivalence models one augmented Fourier or gauged source, while `ambientMap`
is its second endpoint map.  The map square identifies their ratio with the
ambient projection of the direct-sum comparison. -/
structure CommonSourceRowFactorization
    (S : Type*) [AddCommGroup S] [Module R S]
    (data : UncalibratedData R V W C) where
  sourceEquiv : S ≃ₗ[R] V
  ambientMap : S →ₗ[R] W
  commonRow : S →ₗ[R] R
  sourceScale : Rˣ
  ambientScale : Rˣ
  comparisonScale : Rˣ
  mapSquare : ∀ s, (data.comparison (sourceEquiv s)).1 = ambientMap s
  sourceRowFactorization : ∀ s,
    data.pairingV data.pointV (sourceEquiv s) =
      (sourceScale : R) * commonRow s
  ambientRowFactorization : ∀ s,
    data.pairingW data.pointW (ambientMap s) =
      (ambientScale : R) * commonRow s
  scaleCompatibility : sourceScale = comparisonScale * ambientScale

namespace CommonSourceRowFactorization

/-- Two rowed endpoint maps from one common source construct the unit-scaled
row calibration of their induced direct-sum comparison.  In particular, the
construction does not select a flat point by a leading-term uniqueness
argument. -/
def toScaledRowCalibration
    (S : Type*) [AddCommGroup S] [Module R S]
    (data : UncalibratedData R V W C)
    (factorization : CommonSourceRowFactorization R V W C S data) :
    ScaledRowCalibration R V W C data where
  scale := factorization.comparisonScale
  rowComparison x := by
    let s := factorization.sourceEquiv.symm x
    have sourceIdentity : factorization.sourceEquiv s = x := by
      exact factorization.sourceEquiv.apply_symm_apply x
    rw [← sourceIdentity, factorization.sourceRowFactorization]
    rw [factorization.mapSquare, factorization.ambientRowFactorization]
    have scaleEquality :
        (factorization.sourceScale : R) =
          (factorization.comparisonScale : R) *
            (factorization.ambientScale : R) := by
      exact congrArg ((↑·) : Rˣ → R) factorization.scaleCompatibility
    rw [scaleEquality, mul_assoc]

end CommonSourceRowFactorization

/-- A generatorwise version of the common-source row comparison.  This is
adapted to Fourier maps defined on an explicit spanning family: exact formulas
on the generators replace any uniqueness claim based on a leading term. -/
structure CommonSourceGeneratorAgreement
    (S : Type*) [AddCommGroup S] [Module R S]
    (data : UncalibratedData R V W C) where
  sourceEquiv : S ≃ₗ[R] V
  ambientMap : S →ₗ[R] W
  comparisonScale : Rˣ
  mapSquare : ∀ s, (data.comparison (sourceEquiv s)).1 = ambientMap s
  generators : Set S
  generatorsSpan : Submodule.span R generators = ⊤
  rowAgreementOnGenerators : Set.EqOn
    ((data.pairingV data.pointV).comp sourceEquiv.toLinearMap)
    (comparisonScale • ((data.pairingW data.pointW).comp ambientMap))
    generators

namespace CommonSourceGeneratorAgreement

/-- Exact row agreement on a spanning source family constructs the scaled row
calibration of the induced direct-sum comparison. -/
def toScaledRowCalibration
    (S : Type*) [AddCommGroup S] [Module R S]
    (data : UncalibratedData R V W C)
    (agreement : CommonSourceGeneratorAgreement R V W C S data) :
    ScaledRowCalibration R V W C data where
  scale := agreement.comparisonScale
  rowComparison x := by
    have rowMapEquality :
        (data.pairingV data.pointV).comp agreement.sourceEquiv.toLinearMap =
          agreement.comparisonScale •
            ((data.pairingW data.pointW).comp agreement.ambientMap) :=
      LinearMap.ext_on agreement.generatorsSpan agreement.rowAgreementOnGenerators
    let s := agreement.sourceEquiv.symm x
    have sourceIdentity : agreement.sourceEquiv s = x := by
      exact agreement.sourceEquiv.apply_symm_apply x
    have rowEquality := LinearMap.congr_fun rowMapEquality s
    change data.pairingV data.pointV (agreement.sourceEquiv s) =
      (agreement.comparisonScale : R) *
        data.pairingW data.pointW (agreement.ambientMap s) at rowEquality
    rw [← agreement.mapSquare] at rowEquality
    simpa [sourceIdentity] using rowEquality

end CommonSourceGeneratorAgreement

namespace ExactRowCalibration

/-- Exact calibration is the unit-one case of scaled calibration. -/
def toScaledCalibration
    (data : UncalibratedData R V W C)
    (calibration : ExactRowCalibration R V W C data) :
    ScaledRowCalibration R V W C data where
  scale := 1
  rowComparison x := by simpa using calibration.rowComparison x

end ExactRowCalibration

namespace ExactPointCalibration

/-- Exact point transport and pairing compatibility imply exact row
transport. No converse or perfectness claim is made. -/
theorem toRowCalibration
    (data : UncalibratedData R V W C)
    (calibration : ExactPointCalibration R V W C data) :
    ExactRowCalibration R V W C data where
  rowComparison x := by
    have pairing := data.pairingComparison data.pointV x
    rw [calibration.pointComparison] at pairing
    simpa using pairing

end ExactPointCalibration

/-- A pairing-compatible direct-sum comparison carrying a unit-scaled row
calibration. Perfectness is not needed by the asymmetric consumer. -/
structure Data extends UncalibratedData R V W C where
  rowCalibration : ScaledRowCalibration R V W C toUncalibratedData

/-- The stronger pointed provider.  It is separate from `Data` so a source may
instead prove the exact row equation directly. -/
structure PointedData extends UncalibratedData R V W C where
  pointCalibration : ExactPointCalibration R V W C toUncalibratedData

namespace PointedData

/-- Forget exact vector transport only after deriving the row calibration. -/
def toData (data : PointedData R V W C) : Data R V W C where
  toUncalibratedData := data.toUncalibratedData
  rowCalibration := ExactRowCalibration.toScaledCalibration R V W C
    data.toUncalibratedData (ExactPointCalibration.toRowCalibration R V W C
      data.toUncalibratedData data.pointCalibration)

end PointedData

namespace Data

variable {R V W C}

/-- The row represented by the marked point in the source. -/
def sourceRow (data : Data R V W C) : V →ₗ[R] R := data.pairingV data.pointV

/-- The row represented by the marked point in the ambient target. -/
def ambientRow (data : Data R V W C) : W →ₗ[R] R := data.pairingW data.pointW

/-- Projection from the source to the ambient summand. -/
def ambientProjection (data : Data R V W C) : V →ₗ[R] W :=
  LinearMap.fst R W C |>.comp data.comparison.toLinearMap

/-- Inclusion of the ambient summand into the source. -/
def ambientInclusion (data : Data R V W C) : W →ₗ[R] V :=
  data.comparison.symm.toLinearMap.comp (LinearMap.inl R W C)

/-- Forget the point and pairing presentation after extracting its two rows. -/
def toRowedComparison (data : Data R V W C) : RowedComparison R V W C where
  comparison := data.comparison
  sourceRow := data.sourceRow
  ambientRow := data.ambientRow
  scale := data.rowCalibration.scale
  rowComparison := data.rowCalibration.rowComparison

/-- The point row on the source is the calibrated unit multiple of ambient
row after projection. -/
theorem sourceRow_eq_scale_smul_ambientRow_comp_projection
    (data : Data R V W C) :
    data.sourceRow =
      (data.rowCalibration.scale : R) •
        (data.ambientRow.comp data.ambientProjection) := by
  apply LinearMap.ext
  intro x
  simpa [sourceRow, ambientRow, ambientProjection] using
    data.rowCalibration.rowComparison x

/-- A nonzero source row value has a nonzero ambient projection. -/
theorem ambientRow_projection_ne_zero
    (data : Data R V W C) {x : V} (rowNonzero : data.sourceRow x ≠ 0) :
    data.ambientRow (data.ambientProjection x) ≠ 0 := by
  intro ambientVanishes
  apply rowNonzero
  have rowEquation := LinearMap.congr_fun
    data.sourceRow_eq_scale_smul_ambientRow_comp_projection x
  simpa [ambientVanishes] using rowEquation

/-- Ambient inclusion preserves the marked row up to the stored unit scale. -/
theorem sourceRow_ambientInclusion (data : Data R V W C) (x : W) :
    data.sourceRow (data.ambientInclusion x) =
      (data.rowCalibration.scale : R) * data.ambientRow x := by
  rw [data.sourceRow_eq_scale_smul_ambientRow_comp_projection]
  simp [ambientProjection, ambientInclusion]

/-- Compatible monodromies on a pointed direct-sum decomposition. -/
structure Monodromy (data : Data R V W C) where
  source : V ≃ₗ[R] V
  ambient : W ≃ₗ[R] W
  correction : C ≃ₗ[R] C
  comparisonIntertwines : ∀ x,
    data.comparison (source x) =
      (ambient (data.comparison x).1, correction (data.comparison x).2)

namespace Monodromy

/-- Ambient projection intertwines the selected source and ambient
monodromies. -/
theorem ambientProjection_intertwines
    (data : Data R V W C) (monodromy : data.Monodromy) (x : V) :
    data.ambientProjection (monodromy.source x) =
      monodromy.ambient (data.ambientProjection x) := by
  have comparison := monodromy.comparisonIntertwines x
  exact congrArg Prod.fst comparison

/-- The intertwining law persists along every forward iterate of the selected
invertible monodromy. -/
theorem ambientProjection_iterate
    (data : Data R V W C) (monodromy : data.Monodromy) (n : ℕ) (x : V) :
    data.ambientProjection (((monodromy.source : V → V)^[n]) x) =
      ((monodromy.ambient : W → W)^[n]) (data.ambientProjection x) := by
  induction n generalizing x with
  | zero => rfl
  | succ n inductionHypothesis =>
      rw [Function.iterate_succ_apply, Function.iterate_succ_apply]
      rw [inductionHypothesis, monodromy.ambientProjection_intertwines]

end Monodromy

end Data

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PointedDirectSum
