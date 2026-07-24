import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

/-!
# Finite carriers for quadratic orientation dictionaries

This module defines the actual finite root carriers used by the rank-three orientation
statement.  At the binary working prime the carrier consists of the two roots of
`x² = 2` in `F₇`; at the golden working prime it consists of the two roots of
`x² - x - 1` in `F₁₁`.  Their nontrivial involutions are respectively `x ↦ -x`
and `x ↦ 1-x`.

The characteristic-five control is represented by a geometric two-point fibre with
Frobenius exchanging its points and a single Frobenius orbit.  Its identification with
the geometric roots of the irreducible quadratic `x²-2` is a standard quadratic-algebra
input; the downstream theorem separately checks that the polynomial has no root in
`F₅`.

The 22-element fixed-child indexing below has two explicit fibres of size eleven and
an involution exchanging paired indices.  A semantic fixed-child certificate must
supply an equivariant indexing of its actual parent carrier by this finite model.
-/

namespace RelativeConicArcs
namespace ClebschTorsorRosetta

/-- The standard two-valued orientation carrier. -/
abbrev Orientation := Fin 2

/-- The nontrivial permutation of the orientation carrier. -/
def orientationSwap : Equiv.Perm Orientation := Equiv.swap 0 1

/-- The two roots of `x²=2` in `F₇`. -/
abbrev BinaryRoot := {x : ZMod 7 // x * x = 2}

/-- The two roots of `x²-x-1` in `F₁₁`. -/
abbrev GoldenRoot := {x : ZMod 11 // x * x - x - 1 = 0}

/-- Negation exchanges the two binary roots. -/
def binaryRootSwap : Equiv.Perm BinaryRoot where
  toFun x := ⟨-x.1, by simpa using x.2⟩
  invFun x := ⟨-x.1, by simpa using x.2⟩
  left_inv := by intro x; ext; simp
  right_inv := by intro x; ext; simp

/-- Golden conjugation `x ↦ 1-x` exchanges the two golden roots. -/
def goldenRootSwap : Equiv.Perm GoldenRoot where
  toFun x := ⟨1 - x.1, by
    have hx := x.2
    ring_nf at hx ⊢
    exact hx⟩
  invFun x := ⟨1 - x.1, by
    have hx := x.2
    ring_nf at hx ⊢
    exact hx⟩
  left_inv := by intro x; ext; simp
  right_inv := by intro x; ext; simp

/-- The binary root `3` is labelled by orientation zero and the root `4` by orientation one. -/
def binaryRootToOrientation : BinaryRoot ≃ Orientation where
  toFun x := if x.1 = 3 then 0 else 1
  invFun i := if i = 0 then ⟨3, by decide⟩ else ⟨4, by decide⟩
  left_inv := by decide +revert
  right_inv := by decide +revert

/-- The golden root `8` is labelled by orientation zero and the root `4` by orientation one. -/
def goldenRootToOrientation : GoldenRoot ≃ Orientation where
  toFun x := if x.1 = 8 then 0 else 1
  invFun i := if i = 0 then ⟨8, by decide⟩ else ⟨4, by decide⟩
  left_inv := by decide +revert
  right_inv := by decide +revert

/-- The two geometric labels of the inert characteristic-five quadratic fibre. -/
abbrev InertGeometricLabel := Fin 2

/-- Frobenius on the geometric labels of the inert quadratic fibre. -/
def inertFrobenius : Equiv.Perm InertGeometricLabel := orientationSwap

/-- The unique displayed Frobenius orbit of the inert geometric fibre. -/
def inertClosedOrbits : Finset (Finset InertGeometricLabel) := {Finset.univ}

/-- The 22 indexed parents in the fixed-child finite model. -/
abbrev FixedChildParentIndex := Fin 22

/-- The two eleven-element quotient fibres of the fixed-child model. -/
def fixedChildSheet (i : FixedChildParentIndex) : Orientation :=
  if i.val < 11 then 0 else 1

/-- The paired-parent involution exchanges index `i` with `i+11` modulo 22. -/
def pairedParentSwap : Equiv.Perm FixedChildParentIndex where
  toFun i :=
    if h : i.val < 11 then
      ⟨i.val + 11, by omega⟩
    else
      ⟨i.val - 11, by omega⟩
  invFun i :=
    if h : i.val < 11 then
      ⟨i.val + 11, by omega⟩
    else
      ⟨i.val - 11, by omega⟩
  left_inv := by decide +revert
  right_inv := by decide +revert

end ClebschTorsorRosetta
end RelativeConicArcs
