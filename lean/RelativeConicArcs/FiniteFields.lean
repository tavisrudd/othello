import Mathlib
import Mathlib.Data.ZMod.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions

/-!
# Concrete finite fields for the frozen examples

These types use the integer encodings from the manuscript verifier.  Binary extensions use the
polynomial basis and carryless reduction; `GF9` encodes `a₀ + a₁ α` as `a₀ + 3a₁`.
All field laws are checked by kernel reduction (`decide`), never `native_decide`.
-/

namespace RelativeConicArcs
namespace FiniteFields

set_option maxHeartbeats 10000000

def carryless (a b d : Nat) : Nat :=
  (List.range d).foldl (fun r i => if b.testBit i then r ^^^ (a <<< i) else r) 0

def reduceBinary (r d modulus : Nat) : Nat :=
  (List.range (d - 1)).reverse.foldl (fun r j =>
    let i := d + j
    if r.testBit i then r ^^^ (modulus <<< j) else r) r

structure GF8 where
  val : Fin 8
deriving DecidableEq, Fintype

namespace GF8

def ofNat (n : Nat) : GF8 := ⟨⟨n % 8, Nat.mod_lt _ (by decide)⟩⟩
def add (a b : GF8) : GF8 := ofNat (a.val ^^^ b.val)
def mul (a b : GF8) : GF8 := ofNat (reduceBinary (carryless a.val b.val 3) 3 11)
def inv (a : GF8) : GF8 := ⟨![0, 1, 5, 6, 7, 2, 3, 4] a.val⟩

instance : Add GF8 := ⟨add⟩
instance : Mul GF8 := ⟨mul⟩
instance : Zero GF8 := ⟨ofNat 0⟩
instance : One GF8 := ⟨ofNat 1⟩
instance : Neg GF8 := ⟨id⟩

instance : CommRing GF8 where
  add_assoc := by decide
  zero_add := by decide
  add_zero := by decide
  nsmul := nsmulRec
  zsmul := zsmulRec
  add_comm := by decide
  mul_assoc := by decide
  one_mul := by decide
  mul_one := by decide
  zero_mul := by decide
  mul_zero := by decide
  left_distrib := by decide
  right_distrib := by decide
  neg_add_cancel := by decide
  mul_comm := by decide

instance : Inv GF8 := ⟨inv⟩
instance : Nontrivial GF8 := ⟨⟨ofNat 0, ofNat 1, by decide⟩⟩

instance : Field GF8 where
  mul_inv_cancel := by decide
  inv_zero := by decide
  nnqsmul := _
  nnqsmul_def := fun _ _ => rfl
  qsmul := _
  qsmul_def := fun _ _ => rfl

@[simp] theorem card : Fintype.card GF8 = 8 := by decide

end GF8

structure GF9 where
  val : Fin 9
deriving DecidableEq, Fintype

namespace GF9

def ofNat (n : Nat) : GF9 := ⟨⟨n % 9, Nat.mod_lt _ (by decide)⟩⟩
def encode (x y : Nat) : GF9 := ofNat (x % 3 + 3 * (y % 3))
def add (a b : GF9) : GF9 :=
  encode (a.val % 3 + b.val % 3) (a.val / 3 + b.val / 3)
def mul (a b : GF9) : GF9 :=
  encode (a.val % 3 * (b.val % 3) + 2 * (a.val / 3 * (b.val / 3)))
    (a.val % 3 * (b.val / 3) + a.val / 3 * (b.val % 3))
def neg (a : GF9) : GF9 := encode (3 - a.val % 3) (3 - a.val / 3)
def inv (a : GF9) : GF9 := ⟨![0, 1, 2, 6, 5, 4, 3, 8, 7] a.val⟩

instance : Add GF9 := ⟨add⟩
instance : Mul GF9 := ⟨mul⟩
instance : Zero GF9 := ⟨ofNat 0⟩
instance : One GF9 := ⟨ofNat 1⟩
instance : Neg GF9 := ⟨neg⟩

instance : CommRing GF9 where
  add_assoc := by decide
  zero_add := by decide
  add_zero := by decide
  nsmul := nsmulRec
  zsmul := zsmulRec
  add_comm := by decide
  mul_assoc := by decide
  one_mul := by decide
  mul_one := by decide
  zero_mul := by decide
  mul_zero := by decide
  left_distrib := by decide
  right_distrib := by decide
  neg_add_cancel := by decide
  mul_comm := by decide

instance : Inv GF9 := ⟨inv⟩
instance : Nontrivial GF9 := ⟨⟨ofNat 0, ofNat 1, by decide⟩⟩

instance : Field GF9 where
  mul_inv_cancel := by decide
  inv_zero := by decide
  nnqsmul := _
  nnqsmul_def := fun _ _ => rfl
  qsmul := _
  qsmul_def := fun _ _ => rfl

@[simp] theorem card : Fintype.card GF9 = 9 := by decide

end GF9

/-! ## The quadratic field `GF(25)`

The encoding is `a + 5b = a + bω`, with `ω² = 2` over `ZMod 5`.  Since `2` is a
quadratic nonresidue modulo five, this is a field.  As for the smaller concrete fields above,
the complete finite field-law and scalar-extension checks are proofs by kernel reduction.
-/

structure GF25 where
  val : Fin 25
deriving DecidableEq, Fintype

namespace GF25

instance factPrimeFive : Fact (Nat.Prime 5) := ⟨by decide⟩

def ofNat (n : Nat) : GF25 := ⟨⟨n % 25, Nat.mod_lt _ (by decide)⟩⟩
def encode (x y : Nat) : GF25 := ofNat (x % 5 + 5 * (y % 5))
def add (a b : GF25) : GF25 :=
  encode (a.val % 5 + b.val % 5) (a.val / 5 + b.val / 5)
def mul (a b : GF25) : GF25 :=
  encode (a.val % 5 * (b.val % 5) + 2 * (a.val / 5 * (b.val / 5)))
    (a.val % 5 * (b.val / 5) + a.val / 5 * (b.val % 5))
def neg (a : GF25) : GF25 := encode (5 - a.val % 5) (5 - a.val / 5)
def inv (a : GF25) : GF25 :=
  ⟨![0, 1, 3, 2, 4, 15, 9, 11, 14, 6, 20, 7, 17, 18, 8, 5, 22, 12, 13, 23,
      10, 24, 16, 19, 21] a.val⟩

instance : Add GF25 := ⟨add⟩
instance : Mul GF25 := ⟨mul⟩
instance : Zero GF25 := ⟨ofNat 0⟩
instance : One GF25 := ⟨ofNat 1⟩
instance : Neg GF25 := ⟨neg⟩

instance : CommRing GF25 where
  add_assoc := by decide
  zero_add := by decide
  add_zero := by decide
  nsmul := nsmulRec
  zsmul := zsmulRec
  add_comm := by decide
  mul_assoc := by decide
  one_mul := by decide
  mul_one := by decide
  zero_mul := by decide
  mul_zero := by decide
  left_distrib := by decide
  right_distrib := by decide
  neg_add_cancel := by decide
  mul_comm := by decide

instance : Inv GF25 := ⟨inv⟩
instance : Nontrivial GF25 := ⟨⟨ofNat 0, ofNat 1, by decide⟩⟩

instance : Field GF25 where
  mul_inv_cancel := by decide
  inv_zero := by decide
  nnqsmul := _
  nnqsmul_def := fun _ _ => rfl
  qsmul := _
  qsmul_def := fun _ _ => rfl

@[simp] theorem card : Fintype.card GF25 = 25 := by decide

/-- The concrete inclusion of the prime subfield. -/
def baseRingHom : ZMod 5 →+* GF25 where
  toFun a := encode a.val 0
  map_one' := by decide
  map_mul' := by decide
  map_zero' := by decide
  map_add' := by decide

instance : Algebra (ZMod 5) GF25 := baseRingHom.toAlgebra

@[simp] theorem algebraMap_apply (a : ZMod 5) :
    algebraMap (ZMod 5) GF25 a = encode a.val 0 := rfl

/-- Coefficients in the polynomial basis `1,ω`. -/
def coeffEquiv : GF25 ≃ₗ[ZMod 5] (Fin 2 → ZMod 5) where
  toFun a := ![(a.val.val % 5 : Nat), (a.val.val / 5 : Nat)]
  invFun v := encode (v 0).val (v 1).val
  left_inv := by decide
  right_inv := by decide
  map_add' := by decide
  map_smul' := by decide

/-- The concrete extension has degree two over its prime subfield. -/
@[simp] theorem finrank : Module.finrank (ZMod 5) GF25 = 2 := by
  calc
    Module.finrank (ZMod 5) GF25 =
        Module.finrank (ZMod 5) (Fin 2 → ZMod 5) := coeffEquiv.finrank_eq
    _ = 2 := Module.finrank_fin_fun (ZMod 5)

end GF25

structure GF16 where
  val : Fin 16
deriving DecidableEq, Fintype

namespace GF16

def ofNat (n : Nat) : GF16 := ⟨⟨n % 16, Nat.mod_lt _ (by decide)⟩⟩
def add (a b : GF16) : GF16 := ofNat (a.val ^^^ b.val)
/-- Four-bit carryless multiplication, unrolled so large kernel-checked certificates do not
repeatedly interpret list folds. -/
def carryless4 (a b : Nat) : Nat :=
  (if b.testBit 0 then a else 0) ^^^
  (if b.testBit 1 then a <<< 1 else 0) ^^^
  (if b.testBit 2 then a <<< 2 else 0) ^^^
  (if b.testBit 3 then a <<< 3 else 0)

/-- Reduction modulo `x⁴+x+1`, from the highest possible bit down. -/
def reduce4 (r : Nat) : Nat :=
  let r := if r.testBit 6 then r ^^^ (19 <<< 2) else r
  let r := if r.testBit 5 then r ^^^ (19 <<< 1) else r
  if r.testBit 4 then r ^^^ 19 else r

def mul (a b : GF16) : GF16 := ofNat (reduce4 (carryless4 a.val b.val))
def inv (a : GF16) : GF16 :=
  ⟨![0, 1, 9, 14, 13, 11, 7, 6, 15, 2, 12, 5, 10, 4, 3, 8] a.val⟩

instance : Add GF16 := ⟨add⟩
instance : Mul GF16 := ⟨mul⟩
instance : Zero GF16 := ⟨ofNat 0⟩
instance : One GF16 := ⟨ofNat 1⟩
instance : Neg GF16 := ⟨id⟩

instance : CommRing GF16 where
  add_assoc := by decide
  zero_add := by decide
  add_zero := by decide
  nsmul := nsmulRec
  zsmul := zsmulRec
  add_comm := by decide
  mul_assoc := by decide
  one_mul := by decide
  mul_one := by decide
  zero_mul := by decide
  mul_zero := by decide
  left_distrib := by decide
  right_distrib := by decide
  neg_add_cancel := by decide
  mul_comm := by decide

instance : Inv GF16 := ⟨inv⟩
instance : Nontrivial GF16 := ⟨⟨ofNat 0, ofNat 1, by decide⟩⟩

instance : Field GF16 where
  mul_inv_cancel := by decide
  inv_zero := by decide
  nnqsmul := _
  nnqsmul_def := fun _ _ => rfl
  qsmul := _
  qsmul_def := fun _ _ => rfl

@[simp] theorem card : Fintype.card GF16 = 16 := by decide

end GF16

end FiniteFields
end RelativeConicArcs
