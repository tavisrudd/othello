# Lean statement-adequacy source

The manuscript places Lean-level trust on the following public
declarations.  The redundancy-eight inventory is imported by
`RelativeConicArcs.Gates.PRSRedundancyEight` and audited by the adjacent
`PRSRedundancyEightAxiomAudit` gate.  The redundancy-nine definitions
and terminal theorem are reproduced from
`RelativeConicArcs/PRSResidualQuadratic.lean` and
`RelativeConicArcs/PRSRedundancyNine.lean`.  The paper-to-formal
correspondence keeps geometric and coding inputs visible rather than
turning them into project axioms.

## Redundancy-eight public terminals

The exact public declaration inventory is:

```text
threeMarkerContraction_map
projectiveSequenceContraction_comm
threeMarkerContraction_swap_first
threeMarkerContraction_swap_last
threeMarkerContraction_affine_apply
threeMarkerContraction_affine_eq_of_elementarySymmetric
exact_deletion_and_polar_budgets
threeMarker_genusOne_hasseWeil_bound
threeMarker_genusOne_hasseWeil_exact_threshold
primePowerOrder_at_least_fortyThree
finiteFieldOrder_at_least_fortyThree
redundancyEightHighFieldSynthesis
redundancyEightPrimePowerSynthesis
redundancyEightFiniteFieldSynthesis
PersistentFamilyData.classified_card
OrbitArithmetic.seventhPower_sigmaInversionOrbitCount
OrbitArithmetic.orbit_count_pairs
tangentTranslateSeven_of_cast_eq_zero
tangentTranslateSeven_surjective
CharacteristicSevenCarrierBoundary.proved_boundary
```

The numerical and synthesis statements are:

```lean
theorem exact_deletion_and_polar_budgets :
    threeMarkerDeletionDegree = 30 ∧
      transverseCarrierBudget + markedCollisionBudget = 14

theorem threeMarker_genusOne_hasseWeil_exact_threshold :
    42 + 1 > 2 * Nat.sqrt 42 + threeMarkerDeletionDegree ∧
      ¬(41 + 1 > 2 * Nat.sqrt 41 + threeMarkerDeletionDegree)

theorem primePowerOrder_at_least_fortyThree
    {q : ℕ} (hprimePower : IsPrimePow q) (hq : 42 ≤ q) :
    43 ≤ q

theorem finiteFieldOrder_at_least_fortyThree
    {K : Type*} [Field K] [Fintype K]
    (hq : 42 ≤ Fintype.card K) :
    43 ≤ Fintype.card K

theorem redundancyEightHighFieldSynthesis
    {Syndrome Marker Witness : Type*}
    [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (hq : 43 ≤ q)
    (input : RedundancyEightInput Syndrome Marker Witness q)
    (syndrome : Syndrome) :
    input.fixedLevel.radius.isDeep syndrome ↔
      input.fixedLevel.polar.persistent syndrome

theorem redundancyEightPrimePowerSynthesis
    {Syndrome Marker Witness : Type*}
    [Fintype Marker] [DecidableEq Marker]
    {q : ℕ} (hprimePower : IsPrimePow q) (hq : 42 ≤ q)
    (input : RedundancyEightInput Syndrome Marker Witness q)
    (syndrome : Syndrome) :
    input.fixedLevel.radius.isDeep syndrome ↔
      input.fixedLevel.polar.persistent syndrome

theorem redundancyEightFiniteFieldSynthesis
    {K Syndrome Marker Witness : Type*} [Field K] [Fintype K]
    [Fintype Marker] [DecidableEq Marker]
    (hq : 42 ≤ Fintype.card K)
    (input :
      RedundancyEightInput Syndrome Marker Witness (Fintype.card K))
    (syndrome : Syndrome) :
    input.fixedLevel.radius.isDeep syndrome ↔
      input.fixedLevel.polar.persistent syndrome
```

`RedundancyEightInput` retains the concrete geometric-$S_3$ slice,
lower-cover membership, contained/modular exclusion, and coding data
as structure fields.  Thus the terminals check contraction,
arithmetic, and logical synthesis without claiming a Lean proof of
geometric integrality, the actual group actions, or the covering-radius
theorem.  The characteristic-seven terminal records only the proved
`q=7` rootless count and the `q=49` shallow witness.

## Redundancy-nine public terminal

```lean
def dividedPowerContraction {n : ℕ} (r : R)
    (a : Fin (n + 2) → R) : Fin (n + 1) → R :=
  fun i => a i.succ - r * a i.castSucc

structure ResidualSliceInput (S : Type*) (q : ℕ) where
  isDeep : S → Prop
  exceptional : S → Prop
  integralGenusAtMostOneSlice : S → Prop
  rationalPointOutsideDeletedDivisors :
    q ≥ 53 → S → Prop
  splitSquarefreeWitness : S → Prop
  witnessMakesShallow :
    ∀ {s}, splitSquarefreeWitness s → ¬ isDeep s
  pointGivesWitness :
    ∀ (hq : q ≥ 53) {s}, exceptional s →
      integralGenusAtMostOneSlice s →
      rationalPointOutsideDeletedDivisors hq s →
      splitSquarefreeWitness s

structure PersistentFamilyData (S : Type*) (q : ℕ)
    [Fintype S] [DecidableEq S] where
  tangent : Finset S
  sigma : Finset S
  deep : Finset S
  tangent_sigma_disjoint : Disjoint tangent sigma
  deep_eq : deep = tangent ∪ sigma
  fieldOrderPositive : 0 < q
  tangent_card : tangent.card = q * (q + 1)
  sigma_card_doubled : 2 * sigma.card = q * (q ^ 2 - 1)
  orbitCase : OrbitArithmeticCase

theorem redundancyNineSynthesis {S : Type*} {q : ℕ}
    [Fintype S] [DecidableEq S]
    (hq : q ≥ 53)
    (slice : ResidualSliceInput S q)
    (families : PersistentFamilyData S q)
    (exceptional_iff :
      ∀ s, slice.exceptional s ↔ s ∉ families.deep)
    (persistentDeep :
      ∀ s, s ∈ families.deep → slice.isDeep s)
    (hslice :
      ∀ s, slice.exceptional s →
        slice.integralGenusAtMostOneSlice s)
    (hpoint :
      ∀ s (_hs : slice.exceptional s),
        slice.rationalPointOutsideDeletedDivisors hq s) :
    (∀ s, slice.isDeep s ↔ s ∈ families.deep) ∧
      (∀ s, s ∉ families.deep →
        slice.splitSquarefreeWitness s) ∧
      families.deep.card = q * (q + 1) ^ 2 / 2 ∧
      (projectiveOrbitCount families.orbitCase,
        semilinearOrbitCount families.orbitCase) =
      orbitCountPair families.orbitCase
```
