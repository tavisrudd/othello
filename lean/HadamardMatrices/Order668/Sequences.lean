/-
# Four ±1 sequences of length 166

This file records four explicit `±1` sequences `A`, `B`, `C`, `D` of length
166, indexed by `ZMod 166`, and checks the two elementary facts about them that
the bordered Goethals–Seidel construction needs besides the autocorrelation
identity: every entry is `1` or `-1`, and the four sums over a full period are
`2, 0, 0, 0`.

Each sequence is stored as a list of 166 integers and read as a function on
`ZMod 166` by list lookup; `sequenceOf_val` identifies the two descriptions.
The sequences are the first rows of the four circulant blocks of a Hadamard
matrix of order 668; the autocorrelation identity that makes that array
orthogonal is checked in `HadamardMatrices.Order668.Correlations`, and the
matrix itself is assembled in `HadamardMatrices.Order668.Orthogonality`.

Both facts proved here are exhaustive checks over `ZMod 166` discharged by
kernel reduction (`decide`); nothing is trusted beyond the Lean kernel.
-/
import HadamardMatrices.BorderedGoethalsSeidel

namespace HadamardMatrices
namespace Order668

/-- The first row of the circulant block `A`. -/
def circulantRowA : List ℤ :=
  [1, 1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, -1, 1, -1, -1, 1, 1, 1, -1, 1, 1, -1, -1,
   -1, -1, 1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, -1, -1, -1, -1, 1, 1, 1, -1, -1, -1, 1,
   1, -1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, -1, 1, -1, -1, 1, -1, 1, -1, 1, -1, -1,
   1, 1, -1, 1, -1, -1, 1, -1, -1, 1, -1, -1, -1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, 1,
   -1, 1, 1, -1, -1, -1, 1, -1, -1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, 1, 1, 1, -1, 1,
   1, 1, 1, 1, -1, -1, 1, -1, -1, -1, 1, 1, -1, 1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1,
   1, 1, -1, -1, 1, -1, 1, -1, 1, -1, -1, 1, 1, -1, 1, -1, -1, 1, -1, -1, 1, -1]

/-- The first row of the circulant block `B`. -/
def circulantRowB : List ℤ :=
  [1, -1, -1, -1, -1, 1, 1, 1, -1, 1, 1, 1, -1, 1, 1, -1, 1, -1, 1, 1, 1, 1, -1, 1,
   1, -1, 1, -1, -1, 1, -1, -1, 1, -1, -1, -1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, 1, -1,
   1, -1, 1, -1, -1, -1, 1, -1, -1, 1, -1, 1, -1, 1, -1, 1, -1, -1, 1, 1, -1, -1, -1, 1,
   1, 1, 1, 1, -1, -1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1,
   -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, -1, -1, 1, -1, 1, 1, -1, 1, 1, -1, 1, 1, 1, 1,
   1, 1, -1, 1, -1, 1, 1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, 1, -1, -1, 1, -1, 1, -1,
   1, -1, 1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, 1, 1, -1, -1, -1, -1, -1, 1, 1]

/-- The first row of the circulant block `C`. -/
def circulantRowC : List ℤ :=
  [-1, -1, -1, -1, -1, 1, -1, 1, -1, 1, 1, -1, -1, -1, 1, -1, 1, 1, -1, -1, -1, -1, 1, -1,
   -1, -1, 1, 1, 1, 1, 1, -1, -1, 1, -1, -1, -1, 1, -1, -1, 1, 1, -1, 1, 1, 1, 1, 1,
   1, 1, -1, 1, -1, -1, 1, -1, -1, -1, 1, -1, -1, -1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1,
   -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1, -1, 1, 1, 1, 1, -1, 1, -1, 1, -1, -1, 1, 1,
   1, -1, 1, -1, -1, 1, 1, 1, 1, -1, 1, 1, 1, -1, -1, -1, -1, -1, 1, 1, -1, 1, 1, 1,
   -1, 1, 1, 1, -1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, -1, -1, 1, -1, -1, -1, 1, -1, -1,
   -1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1, -1, 1, 1, -1, -1, -1, 1, 1, 1, -1, -1]

/-- The first row of the circulant block `D`. -/
def circulantRowD : List ℤ :=
  [-1, 1, 1, 1, -1, -1, -1, 1, -1, 1, -1, -1, 1, 1, -1, -1, -1, -1, 1, -1, -1, 1, -1, 1,
   1, 1, -1, 1, -1, -1, 1, 1, -1, -1, -1, -1, -1, -1, 1, 1, 1, -1, -1, 1, 1, 1, 1, 1,
   1, -1, 1, -1, -1, 1, 1, -1, -1, 1, -1, 1, 1, -1, -1, -1, 1, -1, -1, 1, 1, -1, -1, -1,
   1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1, -1, -1, -1, -1, 1, 1, 1, -1, 1, -1, 1, 1, -1,
   -1, 1, 1, 1, 1, -1, 1, 1, -1, 1, -1, -1, -1, 1, -1, 1, 1, -1, -1, 1, 1, 1, 1, 1,
   1, -1, -1, -1, 1, 1, 1, 1, 1, 1, 1, 1, -1, 1, -1, -1, 1, 1, -1, -1, 1, -1, 1, 1,
   1, -1, -1, 1, -1, -1, 1, 1, -1, -1, -1, 1, -1, -1, -1, 1, 1, -1, -1, 1, -1, 1]

/-- Read a stored row as a function on `ZMod 166`: the value at `t` is the entry
of the list at position `ZMod.val t`.  All four rows have length 166, so the
default never applies. -/
def sequenceOf (row : List ℤ) (t : ZMod 166) : ℤ := row.getD t.val 0

/-- The first row of the circulant block `A`, as a function on `ZMod 166`. -/
def sequenceA : ZMod 166 → ℤ := sequenceOf circulantRowA

/-- The first row of the circulant block `B`, as a function on `ZMod 166`. -/
def sequenceB : ZMod 166 → ℤ := sequenceOf circulantRowB

/-- The first row of the circulant block `C`, as a function on `ZMod 166`. -/
def sequenceC : ZMod 166 → ℤ := sequenceOf circulantRowC

/-- The first row of the circulant block `D`, as a function on `ZMod 166`. -/
def sequenceD : ZMod 166 → ℤ := sequenceOf circulantRowD

/-! ## A constant-time reading of the same four sequences

Reading a sequence by list lookup costs a traversal, which makes the
autocorrelation identity of `HadamardMatrices.Order668.Correlations` — a sum of
664 products at each of 165 shifts — expensive to reduce.  The same four
sequences are therefore also presented by packing their signs into the binary
digits of a single natural number, where a lookup is one arithmetic operation on
numerals.  The four bridging lemmas below check, entry by entry, that the two
presentations agree, so the packed form carries no independent data. -/

/-- The sequence packed into the binary digits of `w`: the entry at position `t`
is `1` when digit `t` of `w` is `1`, and `-1` when it is `0`. -/
def packedSign (w : ℕ) (t : ZMod 166) : ℤ := if w / 2 ^ t.val % 2 = 1 then 1 else -1

/-- The binary digits of the first row of the circulant block `A`. -/
def packedRowA : ℕ := 26817002754010096664673725533991516053093578384727

/-- The binary digits of the first row of the circulant block `B`. -/
def packedRowB : ℕ := 70862252980713644921310023357742371980485502791393

/-- The binary digits of the first row of the circulant block `C`. -/
def packedRowC : ℕ := 20740320449961167167865081185323687032687348106912

/-- The binary digits of the first row of the circulant block `D`. -/
def packedRowD : ℕ := 60702490722191209455868608290772867416281191821966

/-! ## The two elementary conditions

Both are exhaustive checks over the 166 residues, and both are discharged by
kernel reduction.  The recursion limit is raised because unfolding a sum or a
universal quantifier over `ZMod 166` nests 166 deep. -/

set_option maxRecDepth 4000

lemma sequenceA_eq_packed : sequenceA = packedSign packedRowA := by
  funext t; revert t; decide

lemma sequenceB_eq_packed : sequenceB = packedSign packedRowB := by
  funext t; revert t; decide

lemma sequenceC_eq_packed : sequenceC = packedSign packedRowC := by
  funext t; revert t; decide

lemma sequenceD_eq_packed : sequenceD = packedSign packedRowD := by
  funext t; revert t; decide

lemma sequenceA_sq (t : ZMod 166) : sequenceA t * sequenceA t = 1 := by
  revert t; decide

lemma sequenceB_sq (t : ZMod 166) : sequenceB t * sequenceB t = 1 := by
  revert t; decide

lemma sequenceC_sq (t : ZMod 166) : sequenceC t * sequenceC t = 1 := by
  revert t; decide

lemma sequenceD_sq (t : ZMod 166) : sequenceD t * sequenceD t = 1 := by
  revert t; decide

lemma sequenceA_sum : ∑ t : ZMod 166, sequenceA t = 2 := by decide

lemma sequenceB_sum : ∑ t : ZMod 166, sequenceB t = 0 := by decide

lemma sequenceC_sum : ∑ t : ZMod 166, sequenceC t = 0 := by decide

lemma sequenceD_sum : ∑ t : ZMod 166, sequenceD t = 0 := by decide

end Order668
end HadamardMatrices
