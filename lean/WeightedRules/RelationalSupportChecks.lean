import WeightedRules.RelationalSupport

/-!
# Finite relational support controls

A two-atom chain has an input fact at `false` and one admitted rule deriving
`true`. Its full closure has strict ranks and is therefore the least fixed
point. A self-supporting cycle without an input fact fails ranked support,
even though its one-atom set is closed under its rule. These are kernel-checked
finite controls for the two independent premises of the general theorem.
-/

namespace WeightedRules.RelationalSupport

private def unarySignature : RelationSignature := ⟨[1]⟩

example : Fintype (GroundAtom unarySignature 2) := inferInstance
example : DecidableEq (GroundAtom unarySignature 2) := inferInstance

private def chainRule : GroundRule Bool := ⟨true, [false]⟩
private def chainProgram : GroundProgram Bool := ⟨{false}, {chainRule}⟩
private def chainRank (a : Bool) : Nat := if a then 1 else 0

private theorem chain_closed : Closed chainProgram Set.univ := by
  constructor
  · intro _ _
    trivial
  · intro _ _ _
    trivial

private theorem chain_rankedSupport :
    RankedSupport chainProgram Set.univ chainRank := by
  intro a _
  cases a with
  | false =>
      left
      simp [chainProgram]
  | true =>
      right
      refine ⟨chainRule, by simp [chainProgram], rfl, ?_⟩
      intro b hb
      have hfalse : b = false := by simpa [chainRule] using hb
      subst b
      exact ⟨Set.mem_univ _, by decide⟩

/-- The admitted one-rule chain has exactly the two derivable atoms. -/
theorem chain_derivable_all :
    Set.univ = {a | Derivable chainProgram a} :=
  (closed_rankedSupport_iff_derivable chainProgram Set.univ chainRank
    chain_closed chain_rankedSupport).1

private def cycleRule : GroundRule Bool := ⟨true, [true]⟩
private def cycleProgram : GroundProgram Bool := ⟨∅, {cycleRule}⟩
private def cycleClaim : Set Bool := {true}

private theorem cycle_closed : Closed cycleProgram cycleClaim := by
  constructor
  · intro a ha
    simp [cycleProgram] at ha
  · intro r hr _
    have hrule : r = cycleRule := by simpa [cycleProgram] using hr
    subst r
    simp [cycleRule, cycleClaim]

/-- A closed self-cycle has no strictly ranked witness without an input fact. -/
theorem cycle_closed_but_not_rankedSupported :
    Closed cycleProgram cycleClaim ∧
      ¬ RankedSupport cycleProgram cycleClaim (fun _ => 0) := by
  constructor
  · exact cycle_closed
  · intro h
    rcases h true (by simp [cycleClaim]) with hfact | ⟨r, hr, _, hbody⟩
    · simp [cycleProgram] at hfact
    · have hrule : r = cycleRule := by simpa [cycleProgram] using hr
      subst r
      have hbad := (hbody true (by simp [cycleRule])).2
      exact Nat.lt_irrefl 0 hbad

end WeightedRules.RelationalSupport
