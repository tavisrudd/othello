import RelativeConicArcs.Certificate
import RelativeConicArcs.FiniteFields

/-!
# Frozen small examples

Coordinates are copied verbatim from `verify_relative_conic_arcs.py`.  For extension fields the
integers are polynomial-basis encodings documented in `FiniteFields.lean`.
-/

namespace RelativeConicArcs
namespace Examples

open Certificate Conic FiniteFields

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private def v8 (x y z : Nat) : Vec GF8 :=
  ![GF8.ofNat x, GF8.ofNat y, GF8.ofNat z]

def q8Witness : List (RawPoint GF8) := [
  ⟨v8 0 1 1, by decide⟩,
  ⟨v8 0 1 2, by decide⟩,
  ⟨v8 1 0 1, by decide⟩,
  ⟨v8 1 0 2, by decide⟩,
  ⟨v8 1 1 2, by decide⟩,
  ⟨v8 1 1 6, by decide⟩]

private def v9 (x y z : Nat) : Vec GF9 :=
  ![GF9.ofNat x, GF9.ofNat y, GF9.ofNat z]

def q9Witness : List (RawPoint GF9) := [
  ⟨v9 1 0 4, by decide⟩,
  ⟨v9 1 0 5, by decide⟩,
  ⟨v9 1 1 0, by decide⟩,
  ⟨v9 1 1 2, by decide⟩,
  ⟨v9 1 2 3, by decide⟩,
  ⟨v9 1 2 4, by decide⟩]

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

private def v11 (x y z : Nat) : Vec (ZMod 11) :=
  ![x, y, z]

def q11Witness : List (RawPoint (ZMod 11)) := [
  ⟨v11 1 10 0, by decide⟩,
  ⟨v11 1 9 1, by decide⟩,
  ⟨v11 1 4 7, by decide⟩,
  ⟨v11 1 8 5, by decide⟩,
  ⟨v11 0 1 4, by decide⟩,
  ⟨v11 1 1 7, by decide⟩]

private def v16 (x y z : Nat) : Vec GF16 :=
  ![GF16.ofNat x, GF16.ofNat y, GF16.ofNat z]

def q16Witness : List (RawPoint GF16) := [
  ⟨v16 1 5 14, by decide⟩,
  ⟨v16 1 5 3, by decide⟩,
  ⟨v16 1 9 2, by decide⟩,
  ⟨v16 1 0 9, by decide⟩,
  ⟨v16 1 13 13, by decide⟩,
  ⟨v16 1 6 10, by decide⟩,
  ⟨v16 1 3 9, by decide⟩,
  ⟨v16 0 1 11, by decide⟩,
  ⟨v16 1 10 2, by decide⟩]

end Examples
end RelativeConicArcs
