import Mathlib.Data.Fintype.Card
import Mathlib.Data.Nat.Factorization.PrimePow
import Mathlib.Tactic

/-!
# The combinatorial spine of the Clebsch chord-defect argument

This file isolates two field-independent pieces of the Clebsch-hexagon argument.

* A perfect matching on six labelled vertices is represented by its partner map: a
  fixed-point-free involution of `Fin 6`.  Kernel reduction certifies that there are exactly
  fifteen such maps.  Consequently any finite collection injecting into the matchings has
  cardinality at most fifteen.  In the geometric application, the collection is the set of
  off-arc triple-concurrence points and the injection sends a point to the three disjoint chords
  through it.
* If a prime power `q` and a nonnegative defect count `c` satisfy
  `c = (q - 6) * (q - 9)` over the integers and `c <= 15`, then
  `q` is one of `4, 5, 9, 11`.

The projective-incidence double count producing the displayed defect equation is deliberately
separate.  Thus the hypotheses below state exactly what the finite combinatorial and arithmetic
layers consume, without hiding any geometric input in a computation.
-/

namespace RelativeConicArcs

namespace ClebschChordDefect

/-- A partner map on six labelled vertices encodes a perfect matching precisely when it is a
fixed-point-free involution. -/
def IsSixVertexPerfectMatching (partner : Fin 6 → Fin 6) : Prop :=
  (∀ v, partner v ≠ v) ∧ ∀ v, partner (partner v) = v

instance instDecidablePredIsSixVertexPerfectMatching :
    DecidablePred IsSixVertexPerfectMatching := fun partner => by
  unfold IsSixVertexPerfectMatching
  infer_instance

/-- The finite set of all perfect matchings on six labelled vertices, represented by their
partner maps. -/
def sixVertexPerfectMatchings : Finset (Fin 6 → Fin 6) :=
  Finset.univ.filter IsSixVertexPerfectMatching

@[simp] theorem mem_sixVertexPerfectMatchings (partner : Fin 6 → Fin 6) :
    partner ∈ sixVertexPerfectMatchings ↔ IsSixVertexPerfectMatching partner := by
  simp [sixVertexPerfectMatchings]

set_option maxHeartbeats 2000000 in
set_option maxRecDepth 100000 in
/-- There are exactly `(6 - 1)!! = 15` perfect matchings on six labelled vertices.

This is a strict-kernel finite certificate: `decide` enumerates the `6^6` partner maps and checks
the fixed-point-free involution predicate. -/
theorem card_sixVertexPerfectMatchings : sixVertexPerfectMatchings.card = 15 := by
  decide

/-- **Six-vertex perfect-matching bound.** A finite collection that assigns distinct six-vertex
perfect matchings to distinct elements has at most fifteen elements.

For chord concurrences, `centers` is the set counted by `c(A)`.  Geometry supplies `hmatching`
(the three concurrent chords have disjoint endpoint pairs) and `hinjective` (a fixed three-chord
matching has a unique common point). -/
theorem card_le_fifteen_of_injective_matching
    {Center : Type*} [DecidableEq Center]
    (centers : Finset Center) (matching : Center → Fin 6 → Fin 6)
    (hmatching : ∀ x ∈ centers, IsSixVertexPerfectMatching (matching x))
    (hinjective : Set.InjOn matching centers) :
    centers.card ≤ 15 := by
  have hle : centers.card ≤ sixVertexPerfectMatchings.card :=
    Finset.card_le_card_of_injOn matching
      (fun x hx => (mem_sixVertexPerfectMatchings (matching x)).2 (hmatching x hx))
      hinjective
  rw [card_sixVertexPerfectMatchings] at hle
  exact hle

/-- The algebraic chord-defect identity from the two chord moments and the
covered/uncovered partition.

Here `n i` counts off-arc points lying on exactly `i` chords, `u` is the number of uncovered
points, and `c = n3` is the triple-concurrence count.  The three hypotheses expose exactly the
incidence statements still to be supplied by the projective layer:

* `n1 + 2*n2 + 3*n3 = 15*(q-1)` counts chord--point incidences;
* `n2 + 3*n3 = 45` counts unordered pairs of endpoint-disjoint chords; and
* `u + n1 + n2 + n3 = q^2 + q - 5` partitions the points off the six-arc.

All equations are stated in `ℤ`, avoiding truncated subtraction at small `q`. -/
theorem chordDefect_identity_of_moments
    (q n1 n2 n3 u : ℕ)
    (hincidence :
      (n1 : ℤ) + 2 * (n2 : ℤ) + 3 * (n3 : ℤ) = 15 * ((q : ℤ) - 1))
    (hpairs : (n2 : ℤ) + 3 * (n3 : ℤ) = 45)
    (hpartition :
      (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) + (n3 : ℤ) =
        (q : ℤ) ^ 2 + (q : ℤ) - 5) :
    (u : ℤ) = (q : ℤ) ^ 2 - 14 * (q : ℤ) + 55 - (n3 : ℤ) := by
  linarith

/-- If the uncovered set in the preceding identity has conic cardinality `q + 1`, the
triple-concurrence count is `(q - 6)(q - 9)`. -/
theorem chordDefect_equation_of_uncovered_card
    (q c u : ℕ)
    (hidentity :
      (u : ℤ) = (q : ℤ) ^ 2 - 14 * (q : ℤ) + 55 - (c : ℤ))
    (hu : u = q + 1) :
    (c : ℤ) = ((q : ℤ) - 6) * ((q : ℤ) - 9) := by
  subst u
  push_cast at hidentity
  nlinarith

/-- The arithmetic candidate reduction in the chord-defect proof.

The equation is stated in `ℤ`: for `q = 4, 5`, both factors are negative and their product is
positive, so natural-number subtraction would state the wrong theorem.  `IsPrimePow q` is the
finite-field-order input and, in particular, excludes the otherwise arithmetically possible
integers `6` and `10`. -/
theorem primePower_candidates_of_chordDefect
    (q c : ℕ) (hq : IsPrimePow q) (hc : c ≤ 15)
    (hdefect : (c : ℤ) = ((q : ℤ) - 6) * ((q : ℤ) - 9)) :
    q = 4 ∨ q = 5 ∨ q = 9 ∨ q = 11 := by
  have hq6 : q ≠ 6 := by
    rintro rfl
    exact (by decide : ¬ IsPrimePow 6) hq
  have hq10 : q ≠ 10 := by
    rintro rfl
    exact (by decide : ¬ IsPrimePow 10) hq
  have hq_le : q ≤ 11 := by
    by_contra hnot
    have hq12 : 12 ≤ q := by omega
    have hfirst : 0 ≤ (q : ℤ) - 12 := by omega
    have hsecond : 0 ≤ (q : ℤ) - 3 := by omega
    have hproduct : 0 ≤ ((q : ℤ) - 12) * ((q : ℤ) - 3) :=
      mul_nonneg hfirst hsecond
    have hc' : (c : ℤ) ≤ 15 := by exact_mod_cast hc
    nlinarith
  interval_cases q <;> norm_num at hdefect ⊢ <;> omega

#print axioms card_sixVertexPerfectMatchings
#print axioms chordDefect_identity_of_moments
#print axioms primePower_candidates_of_chordDefect

end ClebschChordDefect

end RelativeConicArcs
