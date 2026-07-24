import RelativeConicArcs.ClebschTorsorRosettaData
import RelativeConicArcs.Gates.ClebschReplacementSpine
import RelativeConicArcs.Gates.ClebschArithmeticGluing
import RelativeConicArcs.Gates.ClebschWittHadamard
import Mathlib.Tactic

/-!
# The Clebsch torsor dictionary

This module supplies a reusable interface for a free involution on a two-element carrier
and checks the finite dictionaries used by the Clebsch closing theorem.  Separate tagged
carriers record the fixed-child quotient, determinant sign, base-point obstruction,
selector bit, design polarity, signed Fourier sector, Hadamard parent role, and golden
quadratic reduction.  Explicit equivalences intertwine their involutions.

The bounded rank-three statement uses the formal reductions at `5`, `7`, and `11`: the
quadratic parameter is inert at `5`, while the binary and golden working primes split.
At eleven the roots `8` and `4` are exchanged by `r ↦ 1-r`.  The row/column terminal proves
that the displayed finite Hadamard automorphism has no inner witness in its checked
95,040-element closure.

Lean checks the abstract torsor and character arguments, all two-point maps, the polynomial
splitting statements, and the imported finite-action terminals.  Identifying the tagged
carriers with the geometric fixed-child signatures, Čech class, information-theoretic bit,
design and Fourier objects, and `Spec Q(√5)` is exact external certificate evidence.  In
particular this module proves no absolute Galois-cohomology classification, integral cubic
lift, uniform all-prime theorem, genuine-Weil restriction, or embedding of the
square-determinant projective group into the degree-twelve design group.
-/

namespace RelativeConicArcs
namespace ClebschTorsorRosetta

/-- A free `C₂` torsor presented as a fixed-point-free involution on a two-element type. -/
structure FreeC2Torsor (X : Type*) [Fintype X] [DecidableEq X] where
  swap : Equiv.Perm X
  swap_involutive : ∀ x, swap (swap x) = x
  swap_fixedPointFree : ∀ x, swap x ≠ x
  swap_transitive : ∀ x y, y = x ∨ y = swap x
  card_eq_two : Fintype.card X = 2

/-- An isomorphism of presented free `C₂` torsors. -/
structure TorsorEquiv {X Y : Type*} [Fintype X] [DecidableEq X]
    [Fintype Y] [DecidableEq Y] (source : FreeC2Torsor X)
    (target : FreeC2Torsor Y) where
  toEquiv : X ≃ Y
  map_swap : ∀ x, toEquiv (source.swap x) = target.swap (toEquiv x)

/-- Every tagged orientation carrier has its canonical free two-point torsor structure. -/
def taggedOrientationTorsor (tag : Type) : FreeC2Torsor (TaggedOrientation tag) where
  swap := taggedSwap tag
  swap_involutive := by
    rintro ⟨x⟩
    fin_cases x <;> rfl
  swap_fixedPointFree := by
    rintro ⟨x⟩ hx
    have hvalue := congrArg TaggedOrientation.value hx
    fin_cases x <;> simp [taggedSwap, taggedValueEquiv, orientationSwap] at hvalue
  swap_transitive := by
    rintro ⟨x⟩ ⟨y⟩
    fin_cases x <;> fin_cases y <;>
      simp [taggedSwap, taggedValueEquiv, orientationSwap]
  card_eq_two := Fintype.card_congr (taggedValueEquiv tag)

/-- A free two-point torsor has no point fixed by its nontrivial operation. -/
theorem no_invariant_point {X : Type*} [Fintype X] [DecidableEq X]
    (torsor : FreeC2Torsor X) : ¬ ∃ x, torsor.swap x = x := by
  rintro ⟨x, hx⟩
  exact torsor.swap_fixedPointFree x hx

/-- One orientation bit suffices: relative to any chosen point, every point of a free
two-element torsor is either that point or its swapped partner. -/
theorem point_or_swapped_point {X : Type*} [Fintype X] [DecidableEq X]
    (torsor : FreeC2Torsor X) (x y : X) : y = x ∨ y = torsor.swap x :=
  torsor.swap_transitive x y

/-- The value-preserving dictionary between any two tagged carriers intertwines their swaps. -/
theorem retag_intertwines_swap (source target : Type)
    (x : TaggedOrientation source) :
    retag source target (taggedSwap source x) =
      taggedSwap target (retag source target x) := by
  rcases x with ⟨x⟩
  fin_cases x <;> rfl

/-- Every explicit retagging is an isomorphism of the corresponding free torsors. -/
def retagTorsorEquiv (source target : Type) :
    TorsorEquiv (taggedOrientationTorsor source) (taggedOrientationTorsor target) where
  toEquiv := retag source target
  map_swap := retag_intertwines_swap source target

/-- The fixed-child two-sheet quotient and the determinant-sign torsor are isomorphic as
free `C₂` torsors.  The identification with the conic-parametrized fixed-child signatures
is the external finite-certificate premise of this tagged dictionary. -/
theorem fixedChildQuotient_is_signTorsor :
    Nonempty (TorsorEquiv (taggedOrientationTorsor FixedChildQuotientTag)
      (taggedOrientationTorsor DeterminantSignTag)) :=
  ⟨retagTorsorEquiv FixedChildQuotientTag DeterminantSignTag⟩

/-- The base-point obstruction, selector bit, and determinant torsor are three explicit
two-point readouts with the same swap. -/
theorem three_readout_dictionaries :
    (∀ x, cechToSign (taggedSwap CechObstructionTag x) =
      taggedSwap DeterminantSignTag (cechToSign x)) ∧
    (∀ x, selectorToSign (taggedSwap SelectorBitTag x) =
      taggedSwap DeterminantSignTag (selectorToSign x)) ∧
    ¬ ∃ x : DeterminantSign, taggedSwap DeterminantSignTag x = x := by
  exact ⟨retag_intertwines_swap _ _, retag_intertwines_swap _ _,
    no_invariant_point (taggedOrientationTorsor DeterminantSignTag)⟩

/-- Three actions on a two-sheet carrier are the same sign character once their kernels
are the same subgroup.  In the projective-line application that supplied subgroup is the
square-determinant subgroup; its identification with the classical simple subgroup is a
named group-theoretic input, not inferred from cardinality here. -/
theorem one_sign_character_three_readouts {G : Type*} [Group G]
    (cech selector torsor : G →* Equiv.Perm (Fin 2))
    (hcech : cech.ker = torsor.ker) (hselector : selector.ker = torsor.ker) :
    cech = torsor ∧ selector = torsor := by
  exact ⟨ClebschArithmeticGluing.sheetCharacter_eq_of_kernel_eq cech torsor hcech,
    ClebschArithmeticGluing.sheetCharacter_eq_of_kernel_eq selector torsor hselector⟩

/-- Kernel-aware form of the three-readout theorem. -/
theorem one_sign_character_with_named_kernel {G : Type*} [Group G]
    (inner : Subgroup G) (cech selector torsor : G →* Equiv.Perm (Fin 2))
    (hcech : cech.ker = inner) (hselector : selector.ker = inner)
    (htorsor : torsor.ker = inner) :
    cech = torsor ∧ selector = torsor ∧ cech.ker = inner := by
  have hc : cech.ker = torsor.ker := hcech.trans htorsor.symm
  have hs : selector.ker = torsor.ker := hselector.trans htorsor.symm
  exact ⟨(one_sign_character_three_readouts cech selector torsor hc hs).1,
    (one_sign_character_three_readouts cech selector torsor hc hs).2, hcech⟩

/-- Exact bounded rank-three reduction row.  The statement proves one fused marker at the
inert prime and free two-point carriers at the two split primes; the interpretation as
spin-lift or Coxeter-frame fibres is the declared external identification. -/
theorem rankThree_split_inert_orientation_row :
    (¬ ∃ x : ZMod 5, x * x = 2) ∧
    Fintype.card (Fin 1) = 1 ∧
    (Finset.univ.filter fun x : ZMod 7 ↦ x * x = 2) = {3, 4} ∧
    Fintype.card BinaryCoxeterSheet = 2 ∧
    (Finset.univ.filter fun x : ZMod 11 ↦ x * x - x - 1 = 0) = {8, 4} ∧
    Fintype.card GoldenCoxeterSheet = 2 := by
  exact ⟨ClebschArithmeticGluing.a3_two_has_no_root, by decide,
    ClebschArithmeticGluing.b3_two_roots,
    Fintype.card_congr (taggedValueEquiv BinaryCoxeterSheetTag),
    ClebschArithmeticGluing.h3_golden_roots,
    Fintype.card_congr (taggedValueEquiv GoldenCoxeterSheetTag)⟩

/-- The two reductions of the golden quadratic coordinate are exactly `8` and `4`;
the involution on the characteristic-zero coordinate reduces to `r ↦ 1-r` and swaps
the two finite sheets.  The assertion that the source is `Spec Q(√5)` is an external
number-field/descent identification; Lean proves the complete reduction dictionary. -/
theorem golden_characteristic_zero_reduction_dictionary :
    goldenReductionRoot ⟨0⟩ = 8 ∧
    goldenReductionRoot ⟨1⟩ = 4 ∧
    (∀ x : GoldenReduction,
      goldenReductionRoot (taggedSwap GoldenReductionTag x) =
        1 - goldenReductionRoot x) ∧
    (∀ x : GoldenReduction,
      goldenReductionToSign (taggedSwap GoldenReductionTag x) =
        taggedSwap DeterminantSignTag (goldenReductionToSign x)) := by
  constructor
  · decide
  constructor
  · decide
  constructor
  · rintro ⟨x⟩
    fin_cases x <;> decide
  · exact retag_intertwines_swap _ _

/-- The q=11 design polarity, signed Fourier sector, and Hadamard parent role all map to
the same two-point swap.  Their geometric meanings are supplied by the finite dictionary
certificates; the equations themselves are exhaustive on the displayed carriers. -/
theorem q11_three_outer_readouts :
    (∀ x, designToSign (taggedSwap DesignPolarityTag x) =
      taggedSwap DeterminantSignTag (designToSign x)) ∧
    (∀ x, fourierToSign (taggedSwap SignedFourierSectorTag x) =
      taggedSwap DeterminantSignTag (fourierToSign x)) ∧
    (∀ x, hadamardToSign (taggedSwap HadamardParentTag x) =
      taggedSwap DeterminantSignTag (hadamardToSign x)) := by
  exact ⟨retag_intertwines_swap _ _, retag_intertwines_swap _ _,
    retag_intertwines_swap _ _⟩

/-- Exact forced-outer boundary at the degree-twelve hinge: the simultaneous generator
assignment is a bijective automorphism graph with the checked inner square, but no element
of the 95,040-element coordinate closure realizes that assignment by conjugation. -/
theorem q11_hadamard_hinge_is_forced_outer :
    ClebschWittHadamard.rowColumnAssignmentChecks ∧
      ClebschWittHadamard.rowColumnNonInnerCheck :=
  ⟨ClebschWittHadamard.row_column_assignment_is_automorphism_graph,
    ClebschWittHadamard.row_column_hinge_has_no_inner_witness⟩

/-- Paper-facing bounded assembly: the fixed-child bridge, the three obstruction readouts,
the rank-three split/inert row, the q=11 outer dictionaries and forced-outer hinge, and the
golden quadratic reduction all hold simultaneously at their stated trust boundaries. -/
theorem torsor_rosetta_closing_theorem :
    Nonempty (TorsorEquiv (taggedOrientationTorsor FixedChildQuotientTag)
      (taggedOrientationTorsor DeterminantSignTag)) ∧
    ((∀ x, cechToSign (taggedSwap CechObstructionTag x) =
      taggedSwap DeterminantSignTag (cechToSign x)) ∧
     (∀ x, selectorToSign (taggedSwap SelectorBitTag x) =
      taggedSwap DeterminantSignTag (selectorToSign x)) ∧
     ¬ ∃ x : DeterminantSign, taggedSwap DeterminantSignTag x = x) ∧
    ((¬ ∃ x : ZMod 5, x * x = 2) ∧
     Fintype.card (Fin 1) = 1 ∧
     (Finset.univ.filter fun x : ZMod 7 ↦ x * x = 2) = {3, 4} ∧
     Fintype.card BinaryCoxeterSheet = 2 ∧
     (Finset.univ.filter fun x : ZMod 11 ↦ x * x - x - 1 = 0) = {8, 4} ∧
     Fintype.card GoldenCoxeterSheet = 2) ∧
    ((∀ x, designToSign (taggedSwap DesignPolarityTag x) =
      taggedSwap DeterminantSignTag (designToSign x)) ∧
     (∀ x, fourierToSign (taggedSwap SignedFourierSectorTag x) =
      taggedSwap DeterminantSignTag (fourierToSign x)) ∧
     (∀ x, hadamardToSign (taggedSwap HadamardParentTag x) =
      taggedSwap DeterminantSignTag (hadamardToSign x))) ∧
    (ClebschWittHadamard.rowColumnAssignmentChecks ∧
      ClebschWittHadamard.rowColumnNonInnerCheck) ∧
    (goldenReductionRoot ⟨0⟩ = 8 ∧
     goldenReductionRoot ⟨1⟩ = 4 ∧
     (∀ x : GoldenReduction,
       goldenReductionRoot (taggedSwap GoldenReductionTag x) =
         1 - goldenReductionRoot x) ∧
     (∀ x : GoldenReduction,
       goldenReductionToSign (taggedSwap GoldenReductionTag x) =
         taggedSwap DeterminantSignTag (goldenReductionToSign x))) := by
  exact ⟨fixedChildQuotient_is_signTorsor, three_readout_dictionaries,
    rankThree_split_inert_orientation_row, q11_three_outer_readouts,
    q11_hadamard_hinge_is_forced_outer,
    golden_characteristic_zero_reduction_dictionary⟩

end ClebschTorsorRosetta
end RelativeConicArcs
