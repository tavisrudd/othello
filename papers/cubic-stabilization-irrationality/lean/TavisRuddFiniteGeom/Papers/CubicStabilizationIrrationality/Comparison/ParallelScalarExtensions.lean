import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelAugmentedSource
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PrimaryDetectionBaseChange

/-!
# Parallel conservative scalar extensions

Opposite Novikov chambers need not embed in one ordinary completion.  A
parallel-source argument can instead start with one marked representation
before completion and realize it separately over each chamber ring.

This module records the exact conservativity required of one such realization:
the chosen scalar extension must reflect the row-detected generalized-primary
predicate.  After that reflection, a branch-local augmented decomposition
transports the predicate to its endpoint.  Two endpoints over unrelated
coefficient rings can therefore be compared through the definitionally shared
pre-completion source.

The reflection field is a genuine source obligation.  It is not inferred from
an arbitrary specialization or completion; quotient base change can kill a
row, and a turning specialization can create a new primary block.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelScalarExtensions

open MarkedLocalSystem
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data
open ParallelAugmentedSource
open PrimaryDetectionBaseChange
open TensorProduct

universe uR uK uLoop uCore uLocal uAmbient uCorrection

variable
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Core : Type uCore} [AddCommGroup Core] [Module R Core]
    (core : MarkedLocalSystem.Representation R Loop Core)

/-- One chamber-local realization of a common marked source, followed by an
augmented endpoint decomposition over that chamber's coefficient ring. -/
structure Branch where
  K : Type uK
  [coefficientRing : CommRing K]
  scalarMap : R →+* K
  LocalSource : Type uLocal
  [localSourceAddCommGroup : AddCommGroup LocalSource]
  [localSourceModule : Module K LocalSource]
  localSource : MarkedLocalSystem.Representation K Loop LocalSource
  localDetects_iff_coreDetects : ∀ loop eigenvalue exponent,
    DetectsGeneralizedEigenspace localSource.row
        (localSource.monodromy loop) (scalarMap eigenvalue) exponent ↔
      DetectsGeneralizedEigenspace core.row
        (core.monodromy loop) eigenvalue exponent
  Ambient : Type uAmbient
  [ambientAddCommGroup : AddCommGroup Ambient]
  [ambientModule : Module K Ambient]
  Correction : Type uCorrection
  [correctionAddCommGroup : AddCommGroup Correction]
  [correctionModule : Module K Correction]
  ambient : MarkedLocalSystem.Representation K Loop Ambient
  decomposition :
    RowedRepresentationDecomposition.Data K Loop
      LocalSource Ambient Correction localSource ambient

attribute [instance] Branch.coefficientRing
attribute [instance] Branch.localSourceAddCommGroup
attribute [instance] Branch.localSourceModule
attribute [instance] Branch.ambientAddCommGroup
attribute [instance] Branch.ambientModule
attribute [instance] Branch.correctionAddCommGroup
attribute [instance] Branch.correctionModule

namespace Branch

/-- Build a conservative branch from an honest faithfully flat scalar
extension of the common marked representation.  In particular, opposite
Laurent-series fields may be treated independently when their complete marked
local sources both descend from the same rational core. -/
noncomputable def ofFaithfullyFlatBaseChange
    {K : Type uK} [CommRing K] [Algebra R K] [Module.FaithfullyFlat R K]
    {Ambient : Type uAmbient} [AddCommGroup Ambient] [Module K Ambient]
    {Correction : Type uCorrection} [AddCommGroup Correction] [Module K Correction]
    (ambient : MarkedLocalSystem.Representation K Loop Ambient)
    (decomposition :
      RowedRepresentationDecomposition.Data K Loop
        (K ⊗[R] Core) Ambient Correction
        (baseChangeRepresentation core) ambient) :
    Branch core where
  K := K
  scalarMap := algebraMap R K
  LocalSource := K ⊗[R] Core
  localSource := baseChangeRepresentation core
  localDetects_iff_coreDetects := fun loop eigenvalue exponent =>
    detectsGeneralizedEigenspace_baseChange_iff core loop eigenvalue exponent
  Ambient := Ambient
  Correction := Correction
  ambient := ambient
  decomposition := decomposition

/-- A conservative chamber realization and its augmented decomposition carry
the common-source Boolean to the chamber endpoint. -/
theorem ambient_detects_iff_core_detects
    (branch : Branch core)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ) :
    DetectsGeneralizedEigenspace branch.ambient.row
        (branch.ambient.monodromy loop) (branch.scalarMap eigenvalue) exponent ↔
      DetectsGeneralizedEigenspace core.row
        (core.monodromy loop) eigenvalue exponent :=
  (branch.decomposition.detectsGeneralizedEigenspace_iff
      loop (branch.scalarMap eigenvalue) exponent).symm.trans
    (branch.localDetects_iff_coreDetects loop eigenvalue exponent)

/-- Endpoints over two unrelated chamber rings have equal detection Booleans
when both scalar extensions conservatively realize the same marked source. -/
theorem ambient_detects_iff_ambient_detects
    (left right : Branch core)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ) :
    DetectsGeneralizedEigenspace left.ambient.row
        (left.ambient.monodromy loop) (left.scalarMap eigenvalue) exponent ↔
      DetectsGeneralizedEigenspace right.ambient.row
        (right.ambient.monodromy loop) (right.scalarMap eigenvalue) exponent :=
  (left.ambient_detects_iff_core_detects core loop eigenvalue exponent).trans
    (right.ambient_detects_iff_core_detects core loop eigenvalue exponent).symm

/-- A detected endpoint and an undetected endpoint cannot arise from two
conservative scalar realizations of the same marked source. -/
theorem false_of_left_detects_of_right_not_detects
    (left right : Branch core)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ)
    (leftDetects :
      DetectsGeneralizedEigenspace left.ambient.row
        (left.ambient.monodromy loop) (left.scalarMap eigenvalue) exponent)
    (rightDoesNotDetect :
      ¬ DetectsGeneralizedEigenspace right.ambient.row
        (right.ambient.monodromy loop) (right.scalarMap eigenvalue) exponent) :
    False :=
  rightDoesNotDetect
    ((left.ambient_detects_iff_ambient_detects core right
      loop eigenvalue exponent).mp leftDetects)

end Branch

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelScalarExtensions
