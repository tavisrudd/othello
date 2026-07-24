import Mathlib.Data.Fin.Basic
import Mathlib.Data.ZMod.Basic

/-!
# Two-point orientation dictionaries

This definitions-only module separates the carriers used by the Clebsch orientation
dictionaries.  Every carrier is a tagged copy of a two-element set; the tags prevent
different geometric, arithmetic, and coding-theoretic readouts from becoming
definitionally identical.  The maps between them are supplied explicitly.

The tags carry no claim that the underlying geometric objects have been constructed in
Lean.  Their interpretation as fixed-child sheets, determinant signs, design polarities,
Fourier sectors, Hadamard parents, or quadratic reductions is the external finite-certificate
boundary.  The downstream theorem module checks the complete two-point dictionaries and
connects them to the finite reduction and row/column terminals already formalized in Lean.
-/

namespace RelativeConicArcs
namespace ClebschTorsorRosetta

/-- A tagged two-element carrier.  The phantom tag keeps distinct orientation readouts
type-correct until an explicit dictionary is provided. -/
structure TaggedOrientation (tag : Type) where
  value : Fin 2

/-- Forget the tag on a two-element orientation carrier. -/
def taggedValueEquiv (tag : Type) : TaggedOrientation tag ≃ Fin 2 where
  toFun := TaggedOrientation.value
  invFun := TaggedOrientation.mk
  left_inv := by rintro ⟨x⟩; rfl
  right_inv := by intro x; rfl

instance taggedOrientationDecidableEq (tag : Type) :
    DecidableEq (TaggedOrientation tag) := fun x y =>
  if h : x.value = y.value then
    isTrue (by cases x; cases y; simp_all)
  else
    isFalse fun hxy => h (congrArg TaggedOrientation.value hxy)

instance taggedOrientationFintype (tag : Type) : Fintype (TaggedOrientation tag) :=
  Fintype.ofEquiv (Fin 2) (taggedValueEquiv tag).symm

/-- The nontrivial permutation of a two-element set. -/
def orientationSwap : Equiv.Perm (Fin 2) := Equiv.swap 0 1

/-- The nontrivial permutation transported to a tagged orientation carrier. -/
def taggedSwap (tag : Type) : Equiv.Perm (TaggedOrientation tag) :=
  (taggedValueEquiv tag).trans (orientationSwap.trans (taggedValueEquiv tag).symm)

/-- The value-preserving dictionary between two differently tagged orientation carriers. -/
def retag (source target : Type) : TaggedOrientation source ≃ TaggedOrientation target :=
  (taggedValueEquiv source).trans (taggedValueEquiv target).symm

inductive FixedChildQuotientTag
inductive DeterminantSignTag
inductive CechObstructionTag
inductive SelectorBitTag
inductive DesignPolarityTag
inductive SignedFourierSectorTag
inductive HadamardParentTag
inductive GoldenReductionTag
inductive BinaryCoxeterSheetTag
inductive GoldenCoxeterSheetTag

/-- The two sheets in the fixed-child quotient. -/
abbrev FixedChildQuotient := TaggedOrientation FixedChildQuotientTag

/-- The determinant-square orientation torsor. -/
abbrev DeterminantSign := TaggedOrientation DeterminantSignTag

/-- The two-valued shadow of the base-point obstruction. -/
abbrev CechObstruction := TaggedOrientation CechObstructionTag

/-- The one-bit selector output. -/
abbrev SelectorBit := TaggedOrientation SelectorBitTag

/-- The two design polarities exchanged by the outer operation. -/
abbrev DesignPolarity := TaggedOrientation DesignPolarityTag

/-- The two signed Fourier sectors. -/
abbrev SignedFourierSector := TaggedOrientation SignedFourierSectorTag

/-- The two row/column parent roles at the Hadamard hinge. -/
abbrev HadamardParent := TaggedOrientation HadamardParentTag

/-- The two reductions of the golden quadratic coordinate at eleven. -/
abbrev GoldenReduction := TaggedOrientation GoldenReductionTag

/-- The two binary Coxeter sheets at the split working prime. -/
abbrev BinaryCoxeterSheet := TaggedOrientation BinaryCoxeterSheetTag

/-- The two golden Coxeter sheets at the split working prime. -/
abbrev GoldenCoxeterSheet := TaggedOrientation GoldenCoxeterSheetTag

/-- Fixed-child quotient to determinant-sign dictionary. -/
def fixedChildToSign : FixedChildQuotient ≃ DeterminantSign :=
  retag FixedChildQuotientTag DeterminantSignTag

/-- Base-point obstruction to determinant-sign dictionary. -/
def cechToSign : CechObstruction ≃ DeterminantSign :=
  retag CechObstructionTag DeterminantSignTag

/-- Selector-bit to determinant-sign dictionary. -/
def selectorToSign : SelectorBit ≃ DeterminantSign :=
  retag SelectorBitTag DeterminantSignTag

/-- Design-polarity to determinant-sign dictionary. -/
def designToSign : DesignPolarity ≃ DeterminantSign :=
  retag DesignPolarityTag DeterminantSignTag

/-- Signed-Fourier-sector to determinant-sign dictionary. -/
def fourierToSign : SignedFourierSector ≃ DeterminantSign :=
  retag SignedFourierSectorTag DeterminantSignTag

/-- Hadamard-parent to determinant-sign dictionary. -/
def hadamardToSign : HadamardParent ≃ DeterminantSign :=
  retag HadamardParentTag DeterminantSignTag

/-- Golden-reduction to determinant-sign dictionary. -/
def goldenReductionToSign : GoldenReduction ≃ DeterminantSign :=
  retag GoldenReductionTag DeterminantSignTag

/-- Binary-sheet to determinant-sign dictionary. -/
def binarySheetToSign : BinaryCoxeterSheet ≃ DeterminantSign :=
  retag BinaryCoxeterSheetTag DeterminantSignTag

/-- Golden-sheet to determinant-sign dictionary. -/
def goldenSheetToSign : GoldenCoxeterSheet ≃ DeterminantSign :=
  retag GoldenCoxeterSheetTag DeterminantSignTag

/-- The two roots used for the reductions of the golden coordinate, ordered by sheet. -/
def goldenReductionRoot (x : GoldenReduction) : ZMod 11 :=
  if x.value = 0 then 8 else 4

end ClebschTorsorRosetta
end RelativeConicArcs
