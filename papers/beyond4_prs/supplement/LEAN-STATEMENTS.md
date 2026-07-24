# Lean statement-adequacy source

The manuscript places Lean-level trust on the following definitions and
terminal theorem.  They are reproduced verbatim from
`RelativeConicArcs/PRSResidualQuadratic.lean` and
`RelativeConicArcs/PRSRedundancyNine.lean`.  The manuscript appendix explains
the paper-to-formal correspondence and trust boundary without interrupting the
mathematical conclusion with source code.

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
