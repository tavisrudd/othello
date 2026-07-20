import RelativeConicArcs.ClebschGateway
import Mathlib.Data.Matrix.Basic

/-!
# C380 q=11 leaf: frozen C378 fusion and signed Fourier block

This bounded leaf freezes exactly the paper-facing C378 interface: the rank-eight relation fusion,
the induced orbit sizes, the involution pairs in the rank-sixteen refinement, and the signed
four-dimensional Fourier square.  It does not reconstruct the projective groups or claim a
general involution-grading theorem.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace Q11Fusion

open Finset Matrix

abbrev FineRelation := Fin 8
abbrev OrthogonalRelation := Fin 4

/-- C378's exact rank-eight to rank-four fusion:
`{0}`, `{3}`, `{1,5,6}`, `{2,4,7}`. -/
def orthogonalFusion : FineRelation → OrthogonalRelation :=
  ![0, 2, 3, 1, 3, 2, 2, 3]

def fusionFiber (c : OrthogonalRelation) : Finset FineRelation :=
  Finset.univ.filter fun r => orthogonalFusion r = c

theorem fusionFiber_zero : fusionFiber 0 = {0} := by decide
theorem fusionFiber_isotropic : fusionFiber 1 = {3} := by decide
theorem fusionFiber_first_anisotropic : fusionFiber 2 = {1, 5, 6} := by decide
theorem fusionFiber_second_anisotropic : fusionFiber 3 = {2, 4, 7} := by decide

/-- C372's fine valencies in the relation order consumed by C378. -/
def fineValency : FineRelation → Nat :=
  ![1, 60, 100, 120, 150, 300, 300, 300]

/-- The corresponding fused affine orbit sizes in this chosen block order. -/
def fusedOrbitSize : OrthogonalRelation → Nat :=
  ![1, 120, 660, 550]

theorem fusion_preserves_sizes :
    ∀ c : OrthogonalRelation,
      (∑ r ∈ fusionFiber c, fineValency r) = fusedOrbitSize c := by
  decide

theorem fusedOrbitSize_total :
    (∑ c : OrthogonalRelation, fusedOrbitSize c) = 1331 := by
  decide

/-- The action of `J` on the rank-sixteen common refinement. -/
def commonJ : Equiv.Perm (Fin 16) where
  toFun := ![0, 10, 2, 13, 4, 5, 14, 7, 8, 11, 1, 9, 12, 3, 6, 15]
  invFun := ![0, 10, 2, 13, 4, 5, 14, 7, 8, 11, 1, 9, 12, 3, 6, 15]
  left_inv := by decide
  right_inv := by decide

/-- The four exchanged relation pairs carrying the chirality-odd sector. -/
theorem commonJ_odd_pairs :
    commonJ 1 = 10 ∧ commonJ 3 = 13 ∧ commonJ 6 = 14 ∧ commonJ 9 = 11 := by
  decide

/-- C378's signed Fourier transform on oriented relation differences. -/
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
