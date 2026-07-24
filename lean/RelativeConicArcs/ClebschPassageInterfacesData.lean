import Mathlib.Data.Matrix.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.GroupTheory.SpecificGroups.Alternating

/-!
# Finite data for passage interfaces

This definitions-only module records four exact finite interfaces.

* Binary representatives encode the even-subset theta quadratic forms in dimensions six and
  ten.  Fixing the last branch bit to zero chooses one representative modulo complement.
* Two constant intersection tables record the same-sheet matching-Lagrangian calculations at
  seven and eleven branch-field points.
* Integer matrices record the rank-sixteen Fourier restriction and its signed four-dimensional
  block.
* Matrices over `ZMod 11` record the two golden parity checks and the displayed monomial and
  signed-Fourier support transports.

The data do not identify Jacobians, theta characteristics, Weil representations, quantum-state
classification classes, or projective automorphism groups.  Those interpretations require the
separate geometric and representation-theoretic inputs from which the tables were obtained.
-/

namespace RelativeConicArcs
namespace ClebschPassageInterfaces

abbrev F11 := ZMod 11

/-- Parity of the first `bits` binary digits of `m`. -/
def binaryParity (bits m : Nat) : Nat :=
  ((Finset.range bits).filter fun i ↦ Nat.testBit m i).card % 2

/-- Weight of the canonical even subset represented by `m`: its free binary digits followed by
their parity bit and a final zero bit. -/
def canonicalEvenWeight (bits m : Nat) : Nat :=
  ((Finset.range bits).filter fun i ↦ Nat.testBit m i).card + binaryParity bits m

/-- The finite quadratic refinement `|S|/2 mod 2` on canonical even-subset representatives. -/
def thetaQuadratic (bits m : Nat) : Nat := canonicalEvenWeight bits m / 2 % 2

/-- Same-sheet intersection dimensions for the two seven-element matching packings. -/
def sevenLagrangianIntersection (_sheet : Fin 2) (i j : Fin 7) : Nat :=
  if i = j then 3 else 1

/-- Same-sheet intersection dimensions for the two eleven-element matching packings. -/
def elevenLagrangianIntersection (_sheet : Fin 2) (i j : Fin 11) : Nat :=
  if i = j then 5 else 1

/-- Weight of the nonzero intersection representative in either seven-element sheet. -/
def sevenIntersectionWeight (_sheet : Fin 2) (i j : Fin 7) : Nat :=
  if i = j then 0 else 4

/-- Weight of the nonzero intersection representative in either eleven-element sheet. -/
def elevenIntersectionWeight (_sheet : Fin 2) (i j : Fin 11) : Nat :=
  if i = j then 0 else 6

/-- The frozen rank-sixteen raw Fourier matrix in common-refinement orbit order. -/
def rankSixteenFourier : List (List ℤ) :=
  [[1,60,40,60,120,30,120,60,120,120,60,120,120,60,120,120],
   [1,-6,-4,-6,10,8,32,-6,-12,-12,5,10,10,-6,-12,-12],
   [1,-6,-4,-6,-12,-3,21,27,21,-12,-6,-12,-12,-6,21,-12],
   [1,-6,-4,-6,-12,8,10,-6,10,32,-6,-12,-12,5,-12,10],
   [1,5,-4,-6,-1,-3,-12,5,10,10,5,10,10,-6,-12,-12],
   [1,16,-4,16,-12,19,-12,16,-12,-12,16,-12,-12,16,-12,-12],
   [1,16,7,5,-12,-3,10,-6,-1,-1,-6,-1,-1,-6,-1,-1],
   [1,-6,18,-6,10,8,-12,5,10,-12,-6,-12,10,-6,-12,10],
   [1,-6,7,5,10,-3,-1,5,-12,10,-6,10,-12,5,-1,-12],
   [1,-6,-4,16,10,-3,-1,-6,10,-1,5,-12,-1,-6,-1,-1],
   [1,5,-4,-6,10,8,-12,-6,-12,10,-6,-12,10,-6,32,-12],
   [1,5,-4,-6,10,-3,-1,-6,10,-12,-6,-1,-1,16,-1,-1],
   [1,5,-4,-6,10,-3,-1,5,-12,-1,5,-1,-12,-6,-1,21],
   [1,-6,-4,5,-12,8,-12,-6,10,-12,-6,32,-12,-6,10,10],
   [1,-6,7,-6,-12,-3,-1,-6,-1,-1,16,-1,-1,5,10,-1],
   [1,-6,-4,5,-12,-3,-1,5,-12,-1,-6,-1,21,5,-1,10]]

/-- Valencies, equivalently squared norms of the raw orbit-indicator basis. -/
def rankSixteenNorms : List ℤ :=
  [1,60,40,60,120,30,120,60,120,120,60,120,120,60,120,120]

/-- The signed four-dimensional raw Fourier restriction. -/
def signedFourier : Matrix (Fin 4) (Fin 4) ℤ :=
  ![
    ![-11, 0, 44, -22],
    ![0, -11, 22, 44],
    ![22, 11, 11, 0],
    ![-11, 22, 0, 11]
  ]

/-- Squared norms of the ordered signed orbit-difference basis. -/
def signedNorms : Fin 4 → ℤ := ![120, 120, 240, 240]

/-- The parity-check matrix of the six-column pencil at parameter `t`. -/
def pencilCheck (t : F11) : Matrix (Fin 3) (Fin 6) F11 :=
  ![
    ![0, 0, 1, 1, 1, 1],
    ![1, 1, 1-t, t-1, 0, 0],
    ![1-t, t-1, 0, 0, -t, t]
  ]

/-- The displayed row intertwiner for the monomial transport from parameter eight to four. -/
def monomialRowIntertwiner : Matrix (Fin 3) (Fin 3) F11 :=
  ![![1, 0, 0], ![0, 0, 1], ![0, 10, 0]]

/-- Source-coordinate scalars for the displayed monomial transport. -/
def monomialScalars : Fin 6 → F11 := ![4, 7, 1, 1, 1, 1]

/-- Source-to-target party permutation for the displayed monomial transport. -/
def monomialPartyMap : Fin 6 → Fin 6 := ![0, 1, 4, 5, 3, 2]

/-- Matrix of the displayed monomial transport, written in target-coordinate order. -/
def monomialTransportMatrix : Matrix (Fin 6) (Fin 6) F11 :=
  ![
    ![4, 0, 0, 0, 0, 0],
    ![0, 7, 0, 0, 0, 0],
    ![0, 0, 0, 0, 0, 1],
    ![0, 0, 0, 0, 1, 0],
    ![0, 0, 1, 0, 0, 0],
    ![0, 0, 0, 1, 0, 0]
  ]

/-- Inverse matrix of the displayed monomial transport. -/
def monomialTransportInverseMatrix : Matrix (Fin 6) (Fin 6) F11 :=
  ![
    ![3, 0, 0, 0, 0, 0],
    ![0, 8, 0, 0, 0, 0],
    ![0, 0, 0, 0, 1, 0],
    ![0, 0, 0, 0, 0, 1],
    ![0, 0, 0, 1, 0, 0],
    ![0, 0, 1, 0, 0, 0]
  ]

/-- Inverse of `monomialRowIntertwiner`. -/
def monomialRowIntertwinerInverse : Matrix (Fin 3) (Fin 3) F11 :=
  ![![1, 0, 0], ![0, 0, 10], ![0, 1, 0]]

/-- The four-minus, two-plus diagonal used in the fixed-party Fourier support identity. -/
def fourierSupportSigns : Fin 6 → F11 := ![10, 10, 10, 10, 1, 1]

/-- Parametrization matrix for the signed source dual inside the target code. -/
def fourierSupportMatrix : Matrix (Fin 6) (Fin 3) F11 :=
  ![
    ![0, 10, 7],
    ![0, 10, 4],
    ![10, 7, 0],
    ![10, 4, 0],
    ![1, 0, 3],
    ![1, 0, 8]
  ]

/-- A left inverse of `fourierSupportMatrix`. -/
def fourierSupportRecoverMatrix : Matrix (Fin 3) (Fin 6) F11 :=
  ![
    ![0, 0, 0, 0, 6, 6],
    ![10, 0, 0, 0, 3, 8],
    ![0, 0, 0, 0, 2, 9]
  ]

/-- Correction matrix expressing the identity as support projection plus a parity-check term. -/
def fourierSupportCorrection : Matrix (Fin 6) (Fin 3) F11 :=
  ![
    ![0, 0, 0],
    ![0, 0, 4],
    ![6, 9, 8],
    ![6, 2, 3],
    ![0, 0, 0],
    ![0, 0, 0]
  ]

end ClebschPassageInterfaces
end RelativeConicArcs
