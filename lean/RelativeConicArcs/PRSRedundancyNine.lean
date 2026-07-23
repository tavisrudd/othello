import Mathlib

/-!
# Redundancy-nine projective Reed--Solomon synthesis interface

This module states the exact logical boundary of the high-field redundancy-nine argument.  The
residual-quadratic algebra is kernel-checked in `RelativeConicArcs.PRSResidualQuadratic`.
Geometric integrality of a suitable binary-quartic slice, the rational-point estimate after
deleting determinant/branch/diagonal/collision divisors, and exhaustion by the persistent
tangent and conjugate-sigma families are explicit hypotheses here.  They are not implemented as
axioms or inferred from a finite census.

The terminal theorem combines those hypotheses and checks the orbit-count arithmetic.  Its
conclusion is deliberately restricted to field orders at least `53`.
-/

namespace RelativeConicArcs.PRSRedundancyNine

/-- The geometric and arithmetic inputs required to turn the residual-quadratic construction into
a split squarefree septic witness outside the persistent locus. -/
structure ResidualSliceInput (S : Type*) (q : ℕ) where
  /-- The coding-theoretic deep-syndrome predicate. -/
  isDeep : S → Prop
  /-- Syndromes outside the persistent tangent and conjugate-sigma families. -/
  exceptional : S → Prop
  /-- Existence of a geometrically integral reduced binary-quartic slice of genus at most one. -/
  integralGenusAtMostOneSlice : S → Prop
  /-- The selected slice avoids determinant, branch, diagonal, and fixed/residual collision
  divisors at some rational point. -/
  rationalPointOutsideDeletedDivisors :
    q ≥ 53 → S → Prop
  /-- Such a rational point supplies a split squarefree septic in the Hankel kernel. -/
  splitSquarefreeWitness : S → Prop
  /-- A split squarefree septic in the Hankel kernel makes the syndrome shallow. -/
  witnessMakesShallow : ∀ {s}, splitSquarefreeWitness s → ¬ isDeep s
  pointGivesWitness :
    ∀ (hq : q ≥ 53) {s}, exceptional s →
      integralGenusAtMostOneSlice s →
      rationalPointOutsideDeletedDivisors hq s →
      splitSquarefreeWitness s

namespace ResidualSliceInput

/-- Once the component and deleted-divisor estimates are supplied, every exceptional syndrome has
a split squarefree witness. -/
theorem exceptional_has_splitSquarefreeWitness {S : Type*} {q : ℕ}
    (input : ResidualSliceInput S q) (hq : q ≥ 53)
    (hslice : ∀ s, input.exceptional s → input.integralGenusAtMostOneSlice s)
    (hpoint : ∀ s (_hs : input.exceptional s),
      input.rationalPointOutsideDeletedDivisors hq s) :
    ∀ s, input.exceptional s → input.splitSquarefreeWitness s := by
  intro s hs
  exact input.pointGivesWitness hq hs (hslice s hs) (hpoint s hs)

end ResidualSliceInput

/-- The five arithmetic cases governing the persistent orbit table.  The characteristic-two case
includes the fixed/nonzero tangent split; the last two cases distinguish the Frobenius action on
the order-eight sigma quotient. -/
inductive OrbitArithmeticCase
  | sigmaOrderOne
  | characteristicTwo
  | sigmaOrderTwo
  | sigmaOrderFour
  | sigmaOrderEightFrobeniusFixed
  | sigmaOrderEightFrobeniusFused
  deriving DecidableEq

/-- Number of projective-linear persistent orbits in each arithmetic case. -/
def projectiveOrbitCount : OrbitArithmeticCase → ℕ
  | .sigmaOrderOne => 2
  | .characteristicTwo => 3
  | .sigmaOrderTwo => 3
  | .sigmaOrderFour => 4
  | .sigmaOrderEightFrobeniusFixed => 6
  | .sigmaOrderEightFrobeniusFused => 6

/-- Number of projective-semilinear persistent orbits in each arithmetic case. -/
def semilinearOrbitCount : OrbitArithmeticCase → ℕ
  | .sigmaOrderOne => 2
  | .characteristicTwo => 3
  | .sigmaOrderTwo => 3
  | .sigmaOrderFour => 4
  | .sigmaOrderEightFrobeniusFixed => 6
  | .sigmaOrderEightFrobeniusFused => 5

/-- The exact projective/projective-semilinear orbit-count table. -/
def orbitCountPair : OrbitArithmeticCase → ℕ × ℕ
  | .sigmaOrderOne => (2, 2)
  | .characteristicTwo => (3, 3)
  | .sigmaOrderTwo => (3, 3)
  | .sigmaOrderFour => (4, 4)
  | .sigmaOrderEightFrobeniusFixed => (6, 6)
  | .sigmaOrderEightFrobeniusFused => (6, 5)

/-- The two orbit-count functions agree with the exact arithmetic table. -/
theorem orbit_count_pair (c : OrbitArithmeticCase) :
    (projectiveOrbitCount c, semilinearOrbitCount c) = orbitCountPair c := by
  cases c <;> rfl

/-- Frobenius fusion changes the persistent orbit count only in the order-eight fused case. -/
theorem semilinearOrbitCount_eq_projectiveOrbitCount_iff
    (c : OrbitArithmeticCase) :
    semilinearOrbitCount c = projectiveOrbitCount c ↔
      c ≠ .sigmaOrderEightFrobeniusFused := by
  cases c <;> decide

/-- Persistent-family data at field order `q`.  Cardinalities are recorded without division so
the hypotheses are valid uniformly in every characteristic. -/
structure PersistentFamilyData (S : Type*) (q : ℕ) [Fintype S] [DecidableEq S] where
  tangent : Finset S
  sigma : Finset S
  deep : Finset S
  tangent_sigma_disjoint : Disjoint tangent sigma
  deep_eq : deep = tangent ∪ sigma
  fieldOrderPositive : 0 < q
  tangent_card : tangent.card = q * (q + 1)
  sigma_card_doubled : 2 * sigma.card = q * (q ^ 2 - 1)
  orbitCase : OrbitArithmeticCase

namespace PersistentFamilyData

/-- The tangent and sigma cardinalities give twice the exact total
`q(q+1)²/2`. -/
theorem deep_card_doubled {S : Type*} {q : ℕ} [Fintype S] [DecidableEq S]
    (data : PersistentFamilyData S q) :
    2 * data.deep.card = q * (q + 1) ^ 2 := by
  rw [data.deep_eq, Finset.card_union_of_disjoint data.tangent_sigma_disjoint,
    Nat.mul_add, data.tangent_card, data.sigma_card_doubled]
  obtain ⟨k, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.ne_of_gt data.fieldOrderPositive)
  simp only [Nat.succ_eq_add_one]
  have hsquare : (k + 1) ^ 2 - 1 = k ^ 2 + 2 * k := by
    have hexpand : (k + 1) ^ 2 = k ^ 2 + 2 * k + 1 := by ring
    omega
  rw [hsquare]
  ring

/-- Exact persistent deep-syndrome cardinality. -/
theorem deep_card {S : Type*} {q : ℕ} [Fintype S] [DecidableEq S]
    (data : PersistentFamilyData S q) :
    data.deep.card = q * (q + 1) ^ 2 / 2 := by
  apply Nat.eq_div_of_mul_eq_right (by decide : (2 : ℕ) ≠ 0)
  simpa [Nat.mul_comm] using data.deep_card_doubled

end PersistentFamilyData

/-- Complete high-field synthesis.  The conclusion packages witness existence off the persistent
locus, the exact deep-syndrome classification, persistent cardinality, and the
projective/projective-semilinear orbit counts. -/
theorem redundancyNineSynthesis {S : Type*} {q : ℕ} [Fintype S] [DecidableEq S]
    (hq : q ≥ 53)
    (slice : ResidualSliceInput S q)
    (families : PersistentFamilyData S q)
    (exceptional_iff : ∀ s, slice.exceptional s ↔ s ∉ families.deep)
    (persistentDeep : ∀ s, s ∈ families.deep → slice.isDeep s)
    (hslice : ∀ s, slice.exceptional s → slice.integralGenusAtMostOneSlice s)
    (hpoint : ∀ s (_hs : slice.exceptional s),
      slice.rationalPointOutsideDeletedDivisors hq s) :
    (∀ s, slice.isDeep s ↔ s ∈ families.deep) ∧
      (∀ s, s ∉ families.deep → slice.splitSquarefreeWitness s) ∧
      families.deep.card = q * (q + 1) ^ 2 / 2 ∧
      (projectiveOrbitCount families.orbitCase,
        semilinearOrbitCount families.orbitCase) =
      orbitCountPair families.orbitCase := by
  have witnessOutside : ∀ s, s ∉ families.deep → slice.splitSquarefreeWitness s := by
    intro s hs
    exact slice.exceptional_has_splitSquarefreeWitness hq hslice hpoint s
      ((exceptional_iff s).2 hs)
  refine ⟨?_, witnessOutside, families.deep_card, orbit_count_pair families.orbitCase⟩
  intro s
  constructor
  · intro hsDeep
    by_contra hsMem
    exact slice.witnessMakesShallow (witnessOutside s hsMem) hsDeep
  · exact persistentDeep s

end RelativeConicArcs.PRSRedundancyNine
