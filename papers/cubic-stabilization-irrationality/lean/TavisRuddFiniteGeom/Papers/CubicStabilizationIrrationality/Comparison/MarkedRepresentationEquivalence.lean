import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationDecomposition

/-!
# Marked equivalences of loop representations

A marked loop representation consists of a monodromy representation and a
scalar row. Two sectorial frames of one meromorphic connection need not be
equal: their transition may contain a Stokes factor. What is invariant is the
whole marked representation. This module proves that any linear equivalence
which conjugates every loop and transports the row preserves the Boolean
detected support of every generalized eigenspace.

The statements are purely algebraic. Interpreting two frames as sectorial
realizations of one geometric connection requires independently supplied
marked equivalences to that connection.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedRepresentationEquivalence

open MarkedLocalSystem
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data

universe uLoop uR uV uW uU

/-- An equivalence of loop representations which also transports the marked
scalar row. -/
structure Equivalence
    (R : Type uR) [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {V : Type uV} {W : Type uW}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module R W]
    (source : MarkedLocalSystem.Representation R Loop V)
    (target : MarkedLocalSystem.Representation R Loop W) where
  map : V ≃ₗ[R] W
  naturality : ∀ loop x,
    map (source.monodromy loop x) = target.monodromy loop (map x)
  rowNaturality : ∀ x, target.row (map x) = source.row x

namespace Equivalence

variable
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {V : Type uV} {W : Type uW} {U : Type uU}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module R W]
    [AddCommGroup U] [Module R U]
    {source : MarkedLocalSystem.Representation R Loop V}
    {middle : MarkedLocalSystem.Representation R Loop W}
    {target : MarkedLocalSystem.Representation R Loop U}

/-- Reverse a marked representation equivalence. -/
def symm (equivalence : Equivalence R source middle) :
    Equivalence R middle source where
  map := equivalence.map.symm
  naturality := by
    intro loop y
    obtain ⟨x, rfl⟩ := equivalence.map.surjective y
    apply equivalence.map.injective
    simpa using (equivalence.naturality loop x).symm
  rowNaturality := by
    intro y
    obtain ⟨x, rfl⟩ := equivalence.map.surjective y
    simpa using (equivalence.rowNaturality x).symm

/-- Compose marked representation equivalences. -/
def trans
    (first : Equivalence R source middle)
    (second : Equivalence R middle target) :
    Equivalence R source target where
  map := first.map.trans second.map
  naturality := by
    intro loop x
    simp only [LinearEquiv.trans_apply]
    rw [first.naturality, second.naturality]
  rowNaturality := by
    intro x
    simp only [LinearEquiv.trans_apply]
    rw [second.rowNaturality, first.rowNaturality]

/-- A marked equivalence intertwines the shifted monodromy operator used to
define a generalized eigenspace. -/
theorem map_shiftedMonodromy
    (equivalence : Equivalence R source middle)
    (loop : Loop) (eigenvalue : R) (x : V) :
    equivalence.map
        (source.monodromy loop x - eigenvalue • x) =
      middle.monodromy loop (equivalence.map x) -
        eigenvalue • equivalence.map x := by
  rw [map_sub, map_smul, equivalence.naturality]

/-- A marked equivalence carries generalized eigenvectors to generalized
eigenvectors with the same eigenvalue and exponent. -/
theorem map_isGeneralizedEigenvector
    (equivalence : Equivalence R source middle)
    (loop : Loop) (eigenvalue : R) (n : ℕ) (x : V)
    (primary : IsGeneralizedEigenvector
      (source.monodromy loop) eigenvalue n x) :
    IsGeneralizedEigenvector
      (middle.monodromy loop) eigenvalue n (equivalence.map x) := by
  induction n generalizing x with
  | zero =>
      simpa [IsGeneralizedEigenvector] using congrArg equivalence.map primary
  | succ n inductionHypothesis =>
      rw [IsGeneralizedEigenvector, Function.iterate_succ_apply] at primary ⊢
      rw [← equivalence.map_shiftedMonodromy]
      exact inductionHypothesis
        (source.monodromy loop x - eigenvalue • x) primary

/-- A marked representation equivalence preserves, in both directions, the
Boolean detected support of every generalized eigenspace. -/
theorem detectsGeneralizedEigenspace_iff
    (equivalence : Equivalence R source middle)
    (loop : Loop) (eigenvalue : R) (n : ℕ) :
    DetectsGeneralizedEigenspace
        source.row (source.monodromy loop) eigenvalue n ↔
      DetectsGeneralizedEigenspace
        middle.row (middle.monodromy loop) eigenvalue n := by
  constructor
  · rintro ⟨x, primary, rowNonzero⟩
    refine ⟨equivalence.map x,
      equivalence.map_isGeneralizedEigenvector loop eigenvalue n x primary, ?_⟩
    simpa [equivalence.rowNaturality x] using rowNonzero
  · rintro ⟨y, primary, rowNonzero⟩
    refine ⟨equivalence.map.symm y,
      equivalence.symm.map_isGeneralizedEigenvector
        loop eigenvalue n y primary, ?_⟩
    intro sourceZero
    apply rowNonzero
    calc
      middle.row y = source.row (equivalence.map.symm y) :=
        (equivalence.symm.rowNaturality y).symm
      _ = 0 := sourceZero

/-- If two frames are marked-equivalent to one common carrier, then their
detected generalized-eigenspace Booleans agree. No equality or uniqueness of
the two frames is required. -/
theorem detectsGeneralizedEigenspace_iff_of_commonCarrier
    {left : MarkedLocalSystem.Representation R Loop V}
    {right : MarkedLocalSystem.Representation R Loop W}
    {carrier : MarkedLocalSystem.Representation R Loop U}
    (leftToCarrier : Equivalence R left carrier)
    (rightToCarrier : Equivalence R right carrier)
    (loop : Loop) (eigenvalue : R) (n : ℕ) :
    DetectsGeneralizedEigenspace
        left.row (left.monodromy loop) eigenvalue n ↔
      DetectsGeneralizedEigenspace
        right.row (right.monodromy loop) eigenvalue n := by
  exact (leftToCarrier.trans rightToCarrier.symm).detectsGeneralizedEigenspace_iff
    loop eigenvalue n

end Equivalence

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedRepresentationEquivalence
