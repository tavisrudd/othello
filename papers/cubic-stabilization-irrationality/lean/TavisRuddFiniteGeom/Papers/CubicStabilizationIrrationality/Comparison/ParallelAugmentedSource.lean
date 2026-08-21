import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationDecomposition

/-!
# Parallel rowed decompositions from one augmented source

Several endpoint representations can be compared without composing maps
between their completed coefficient germs.  It is enough to map one marked
source representation isomorphically to each endpoint plus a correction
representation, provided every correction is invisible to the endpoint row.

This module packages one such branch and proves that any two branches from
the same source have the same row-detected generalized-eigenspace Boolean.
The source representation, its based-loop action, and its scalar row are
definitionally shared.  Constructing this common augmented source from a
geometric Fourier or cobordism object is an external hypothesis.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelAugmentedSource

open MarkedLocalSystem
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data

universe uR uLoop uSource uAmbient uCorrection

variable
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Source : Type uSource} [AddCommGroup Source] [Module R Source]
    (source : MarkedLocalSystem.Representation R Loop Source)

/-- One endpoint of a parallel augmented comparison.  Its correction module
and correction monodromy are local to this branch; the source representation
is the fixed value supplied as an index to the structure. -/
structure Branch where
  Ambient : Type uAmbient
  [ambientAddCommGroup : AddCommGroup Ambient]
  [ambientModule : Module R Ambient]
  Correction : Type uCorrection
  [correctionAddCommGroup : AddCommGroup Correction]
  [correctionModule : Module R Correction]
  ambient : MarkedLocalSystem.Representation R Loop Ambient
  decomposition :
    RowedRepresentationDecomposition.Data R Loop
      Source Ambient Correction source ambient

attribute [instance] Branch.ambientAddCommGroup
attribute [instance] Branch.ambientModule
attribute [instance] Branch.correctionAddCommGroup
attribute [instance] Branch.correctionModule

namespace Branch

/-- Detection by the marked row on the common source is equivalent to
detection by the endpoint row of any one augmented branch. -/
theorem source_detects_iff_ambient_detects
    (branch : Branch source)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ) :
    DetectsGeneralizedEigenspace source.row (source.monodromy loop)
        eigenvalue exponent ↔
      DetectsGeneralizedEigenspace branch.ambient.row
        (branch.ambient.monodromy loop) eigenvalue exponent :=
  branch.decomposition.detectsGeneralizedEigenspace_iff
    loop eigenvalue exponent

/-- Two endpoint branches from the same marked augmented source have equal
row-detected generalized-eigenspace Booleans.  Their ambient carriers and
correction representations may be unrelated; the proof compares both only
through the shared source representation. -/
theorem ambient_detects_iff_ambient_detects
    (left right : Branch source)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ) :
    DetectsGeneralizedEigenspace left.ambient.row
        (left.ambient.monodromy loop) eigenvalue exponent ↔
      DetectsGeneralizedEigenspace right.ambient.row
        (right.ambient.monodromy loop) eigenvalue exponent :=
  (left.source_detects_iff_ambient_detects source loop eigenvalue exponent).symm.trans
    (right.source_detects_iff_ambient_detects source loop eigenvalue exponent)

/-- A detected endpoint and an undetected endpoint cannot both be augmented
branches of one marked source for the same loop, eigenvalue, and exponent. -/
theorem false_of_left_detects_of_right_not_detects
    (left right : Branch source)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ)
    (leftDetects :
      DetectsGeneralizedEigenspace left.ambient.row
        (left.ambient.monodromy loop) eigenvalue exponent)
    (rightDoesNotDetect :
      ¬ DetectsGeneralizedEigenspace right.ambient.row
        (right.ambient.monodromy loop) eigenvalue exponent) :
    False :=
  rightDoesNotDetect
    ((left.ambient_detects_iff_ambient_detects source right
      loop eigenvalue exponent).mp leftDetects)

end Branch

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ParallelAugmentedSource
