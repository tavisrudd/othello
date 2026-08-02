import Mathlib.Tactic.Ring

/-!
# Balanced cuts of an order-six symmetric conference matrix

A three-by-three principal block of a symmetric sign matrix is determined by
its three edge signs.  This module proves the scalar identities behind the
structural `3+3` cut argument: the entries of the squared triangle block, the
determinant of the resulting cross Gram matrix, and the trace contraction in
the fourth conference word.  These identities give determinant `16`, trace
contraction `12`, and fourth-word trace `-42` without enumerating the twenty
balanced sign vectors.

All results are symbolic kernel proofs over a commutative ring.  No generated
certificate, native evaluation, or external computation is used.
-/

namespace RelativeConicArcs
namespace GoldenBalancedCut

/-- The six independent scalar entries of the square of the signed triangle
with edge signs `a`, `b`, and `c`.  This is the entrywise content of
`A² = 2I + abc A`. -/
theorem signedTriangle_sq_entries {R : Type*} [CommRing R] (a b c : R)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) :
    a * a + c * c = 2 ∧
    a * a + b * b = 2 ∧
    c * c + b * b = 2 ∧
    c * b = (a * b * c) * a ∧
    a * b = (a * b * c) * c ∧
    a * c = (a * b * c) * b := by
  constructor
  · rw [ha, hc]
    ring
  constructor
  · rw [ha, hb]
    ring
  constructor
  · rw [hc, hb]
    ring
  constructor
  · calc
      c * b = (a * a) * (c * b) := by rw [ha]; ring
      _ = (a * b * c) * a := by ring
  constructor
  · calc
      a * b = (c * c) * (a * b) := by rw [hc]; ring
      _ = (a * b * c) * c := by ring
  · calc
      a * c = (b * b) * (a * c) := by rw [hb]; ring
      _ = (a * b * c) * b := by ring

/-- Closed determinant polynomial for the cross Gram matrix
`5I - A²`, whose diagonal is `3` and whose off-diagonal entries are the
negatives of the corresponding two-edge products. -/
def crossGramDet {R : Type*} [CommRing R] (a b c : R) : R :=
  27 - 3 * ((b * c) ^ 2 + (a * b) ^ 2 + (a * c) ^ 2) -
    2 * (a * a) * (b * b) * (c * c)

/-- Every balanced cross Gram matrix has determinant `16`; equivalently, its
cross block has determinant squared `16` whenever that block exists. -/
theorem crossGramDet_eq_sixteen {R : Type*} [CommRing R] (a b c : R)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) :
    crossGramDet a b c = 16 := by
  have hab : (a * b) * (a * b) = 1 := by
    calc
      (a * b) * (a * b) = (a * a) * (b * b) := by ring
      _ = 1 := by rw [ha, hb]; ring
  have hac : (a * c) * (a * c) = 1 := by
    calc
      (a * c) * (a * c) = (a * a) * (c * c) := by ring
      _ = 1 := by rw [ha, hc]; ring
  have hbc : (b * c) * (b * c) = 1 := by
    calc
      (b * c) * (b * c) = (b * b) * (c * c) := by ring
      _ = 1 := by rw [hb, hc]; ring
  simp only [crossGramDet, pow_two]
  rw [ha, hb, hc, hab, hac, hbc]
  ring

/-- Scalar expansion of `tr(A²(5I-A²))` for a signed triangle block. -/
def traceContraction {R : Type*} [CommRing R] (a b c : R) : R :=
  18 - 2 * ((b * c) ^ 2 + (a * b) ^ 2 + (a * c) ^ 2)

/-- The trace contraction controlling the off-diagonal contribution to the
fourth conference word is always `12`. -/
theorem traceContraction_eq_twelve {R : Type*} [CommRing R] (a b c : R)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) :
    traceContraction a b c = 12 := by
  have hab : (a * b) * (a * b) = 1 := by
    calc
      (a * b) * (a * b) = (a * a) * (b * b) := by ring
      _ = 1 := by rw [ha, hb]; ring
  have hac : (a * c) * (a * c) = 1 := by
    calc
      (a * c) * (a * c) = (a * a) * (c * c) := by ring
      _ = 1 := by rw [ha, hc]; ring
  have hbc : (b * c) * (b * c) = 1 := by
    calc
      (b * c) * (b * c) = (b * b) * (c * c) := by ring
      _ = 1 := by rw [hb, hc]; ring
  simp only [traceContraction, pow_two]
  rw [hab, hac, hbc]
  ring

/-- Substituting the structural trace contraction into the `3+3` block-trace
formula gives the fourth conference word trace `-42`. -/
theorem fourthWordTrace_from_block_formula {R : Type*} [CommRing R] (a b c : R)
    (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1) :
    (27 : R) + 27 - 8 * traceContraction a b c = -42 := by
  rw [traceContraction_eq_twelve a b c ha hb hc]
  ring

end GoldenBalancedCut
end RelativeConicArcs
