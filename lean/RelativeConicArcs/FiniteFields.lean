import Mathlib

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
