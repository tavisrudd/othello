import Mathlib.Data.Fin.VecNotation
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic.FinCases

/-!
# Self-contained coordinate model for order-eleven certificates

This module contains only the transparent coordinate data needed to state the
order-eleven point-action certificates.  It depends on Mathlib alone.  Downstream
libraries compare this frozen model with their own geometric and coding interfaces;
the certificate model does not import those interfaces.
-/

namespace RelativeConicArcs.Q11CertificateModel

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

abbrev Scalar := ZMod 11
abbrev Vec3 := Fin 3 → Scalar
abbrev PointIndex := Fin 133

/-- The six displayed witness vectors used by the order-eleven certificate. -/
def witnessVec (i : Fin 6) : Vec3 :=
  ![
    ![1, 10, 0], ![1, 9, 1], ![1, 4, 7],
    ![1, 8, 5], ![0, 1, 4], ![1, 1, 7]
  ] i

/-- Canonical representatives `[1:y:z]`, `[0:1:z]`, and `[0:0:1]` of `PG(2,11)`. -/
def projectiveVec (p : PointIndex) : Vec3 :=
  if _ : p.1 < 121 then
    ![1, ((p.1 / 11 : ℕ) : Scalar), ((p.1 % 11 : ℕ) : Scalar)]
  else if _ : p.1 < 132 then
    ![0, 1, ((p.1 - 121 : ℕ) : Scalar)]
  else
    ![0, 0, 1]

/-- The six witness directions in canonical point indexing. -/
def witnessIndex (i : Fin 6) : PointIndex := ![110, 100, 51, 93, 125, 18] i

/-- The certificate's canonical point representative. -/
def pointVec (p : PointIndex) : Vec3 := projectiveVec p

/-- The indexed certificate points are exactly the displayed witness vectors. -/
theorem pointVec_witnessIndex (i : Fin 6) : pointVec (witnessIndex i) = witnessVec i := by
  fin_cases i <;> decide

end RelativeConicArcs.Q11CertificateModel
