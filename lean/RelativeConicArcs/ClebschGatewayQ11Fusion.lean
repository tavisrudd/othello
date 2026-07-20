import RelativeConicArcs.ClebschGateway
import Mathlib.Data.Matrix.Basic

/-!
# Displayed q=11 fusion and signed matrix data

This module contains literal finite data: a map from eight relation labels to four labels, two
valency arrays, a permutation of sixteen labels, and a `4 x 4` integer matrix.  Kernel reduction
checks their fibres, size sums, four selected permutation values, and the matrix-square identity.

The module does not define the underlying affine relations, derive the data from a group action or
character sum, or identify the matrix with the Fourier transform of an association scheme.  Those
semantic identifications require separate evidence and do not follow from the computations here.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace Q11Fusion

open Finset Matrix

abbrev FineRelation := Fin 8
abbrev OrthogonalRelation := Fin 4

/-- A displayed map whose fibres are proved below to be
`{0}`, `{3}`, `{1,5,6}`, and `{2,4,7}`. -/
def orthogonalFusion : FineRelation → OrthogonalRelation :=
  ![0, 2, 3, 1, 3, 2, 2, 3]

/-- The set of fine labels mapped to a given coarse label. -/
def fusionFiber (c : OrthogonalRelation) : Finset FineRelation :=
  Finset.univ.filter fun r => orthogonalFusion r = c

/-- The fibre above coarse label zero is the singleton fine label zero. -/
theorem fusionFiber_zero : fusionFiber 0 = {0} := by decide
/-- The fibre above coarse label one is the singleton fine label three. -/
theorem fusionFiber_isotropic : fusionFiber 1 = {3} := by decide
/-- The fibre above coarse label two consists of fine labels one, five, and six. -/
theorem fusionFiber_first_anisotropic : fusionFiber 2 = {1, 5, 6} := by decide
/-- The fibre above coarse label three consists of fine labels two, four, and seven. -/
theorem fusionFiber_second_anisotropic : fusionFiber 3 = {2, 4, 7} := by decide

/-- The displayed fine-valency array.  This module does not prove that these numbers count an
independently defined family of relations. -/
def fineValency : FineRelation → Nat :=
  ![1, 60, 100, 120, 150, 300, 300, 300]

/-- The displayed fused-size array in the chosen block order. -/
def fusedOrbitSize : OrthogonalRelation → Nat :=
  ![1, 120, 660, 550]

/-- Summing the displayed fine valencies over each fibre gives the corresponding displayed fused
size. -/
theorem fusion_preserves_sizes :
    ∀ c : OrthogonalRelation,
      (∑ r ∈ fusionFiber c, fineValency r) = fusedOrbitSize c := by
  decide

/-- The four displayed fused sizes sum to `11^3 = 1331`. -/
theorem fusedOrbitSize_total :
    (∑ c : OrthogonalRelation, fusedOrbitSize c) = 1331 := by
  decide

/-- A displayed involutive permutation of sixteen relation labels.  No geometric action is defined
in this module. -/
def commonJ : Equiv.Perm (Fin 16) where
  toFun := ![0, 10, 2, 13, 4, 5, 14, 7, 8, 11, 1, 9, 12, 3, 6, 15]
  invFun := ![0, 10, 2, 13, 4, 5, 14, 7, 8, 11, 1, 9, 12, 3, 6, 15]
  left_inv := by decide
  right_inv := by decide

/-- Four selected pairs exchanged by the displayed permutation. -/
theorem commonJ_odd_pairs :
    commonJ 1 = 10 ∧ commonJ 3 = 13 ∧ commonJ 6 = 14 ∧ commonJ 9 = 11 := by
  decide

/-- A displayed integer matrix intended for a signed Fourier calculation.  Its identification with
a scheme-theoretic Fourier transform is not proved here. -/
def oddFourier : Matrix (Fin 4) (Fin 4) Int := ![
  ![-11, 0, 44, -22],
  ![0, -11, 22, 44],
  ![22, 11, 11, 0],
  ![-11, 22, 0, 11]
]

/-- The exact signed Fourier identity `M_odd^2 = 1331 I_4`. -/
theorem oddFourier_square :
    oddFourier * oddFourier = (1331 : Int) • (1 : Matrix (Fin 4) (Fin 4) Int) := by
  decide

#print axioms fusion_preserves_sizes
#print axioms commonJ_odd_pairs
#print axioms oddFourier_square

end Q11Fusion
end ClebschGateway
end RelativeConicArcs
