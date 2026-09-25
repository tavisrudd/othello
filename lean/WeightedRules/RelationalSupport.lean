import WeightedRules.Relations
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Fintype.Sigma

/-!
# Finite relational support and closure

A ground atom identifies one tuple of one declared relation over a finite
domain. An admitted ground rule has a head atom and a list of body atoms; its
membership in the program's finite rule set is the rule-admission premise.
The source language, grounding procedure, and correspondence between a source
rule match and a ground rule are outside this theorem.

A claimed relation set is the least fixed point when it contains every input
fact, is closed under every admitted ground rule, and each claimed non-input
atom has one admitted rule witness whose body atoms have strictly smaller
natural-number ranks. The rank condition rules out circular support. The
proof constructs derivations by induction on rank, and closure shows that no
derivable atom was omitted.

For a negative literal, a complement restricted to a product of column domains
is exact on positive-body matches when range restriction places each queried
value in a binding column and that column's values are contained in the domain
used at the layer boundary. The theorem makes those two obligations explicit;
it does not establish them for any particular compiler or verifier.
-/

namespace WeightedRules
namespace RelationalSupport

universe u v w

/-- One finite ground rule instance: the body is a conjunction, with an empty
body representing an unconditional rule. -/
structure GroundRule (Atom : Type u) where
  head : Atom
  body : List Atom
  deriving DecidableEq

/-- Finite input facts and the finite set of admitted ground rule instances. -/
structure GroundProgram (Atom : Type u) [Fintype Atom] [DecidableEq Atom] where
  facts : Finset Atom
  rules : Finset (GroundRule Atom)

variable {Atom : Type u} [Fintype Atom] [DecidableEq Atom]

/-- A set contains the input facts and every head implied by a rule whose
entire body is present. -/
def Closed (P : GroundProgram Atom) (S : Set Atom) : Prop :=
  (∀ a ∈ P.facts, a ∈ S) ∧
    ∀ r ∈ P.rules, (∀ b ∈ r.body, b ∈ S) → r.head ∈ S

/-- One simultaneous application of facts and admitted ground rules. -/
def step (P : GroundProgram Atom) (S : Set Atom) : Set Atom :=
  {a | a ∈ P.facts ∨ ∃ r ∈ P.rules, r.head = a ∧ ∀ b ∈ r.body, b ∈ S}

/-- Every claimed atom is a fact or has one admitted rule witness. Each
premise of that witness is claimed at a strictly smaller rank. -/
def RankedSupport (P : GroundProgram Atom) (S : Set Atom)
    (rank : Atom → Nat) : Prop :=
  ∀ a ∈ S, a ∈ P.facts ∨
    ∃ r ∈ P.rules, r.head = a ∧
      ∀ b ∈ r.body, b ∈ S ∧ rank b < rank a

/-- Finite derivations use only admitted rules and terminate at input facts. -/
inductive Derivable (P : GroundProgram Atom) : Atom → Prop where
  | fact {a} : a ∈ P.facts → Derivable P a
  | rule (r : GroundRule Atom) : r ∈ P.rules →
      (∀ b ∈ r.body, Derivable P b) → Derivable P r.head

/-- The derivable atoms form a model of every admitted ground rule. -/
theorem derivable_closed (P : GroundProgram Atom) :
    Closed P {a | Derivable P a} := by
  constructor
  · intro a ha
    exact Derivable.fact ha
  · intro r hr hbody
    exact Derivable.rule r hr hbody

/-- Ranked support places every claimed atom in every closed model. -/
theorem rankedSupport_subset_closed (P : GroundProgram Atom) (S T : Set Atom)
    (rank : Atom → Nat) (hs : RankedSupport P S rank) (ht : Closed P T) :
    S ⊆ T := by
  have h : ∀ n : Nat, ∀ a : Atom, rank a = n → a ∈ S → a ∈ T := by
    intro n
    induction n using Nat.strong_induction_on with
    | h n ih =>
      intro a haRank ha
      rcases hs a ha with hfact | ⟨r, hr, hhead, hbody⟩
      · exact ht.1 a hfact
      · have hheadT : r.head ∈ T := ht.2 r hr (by
          intro b hb
          have hpremise := hbody b hb
          exact ih (rank b) (by simpa only [haRank] using hpremise.2)
            b rfl hpremise.1)
        rwa [hhead] at hheadT
  intro a ha
  exact h (rank a) a rfl ha

/-- A ranked witness is a finite derivation from input facts. -/
theorem rankedSupport_derivable (P : GroundProgram Atom) (S : Set Atom)
    (rank : Atom → Nat) (hs : RankedSupport P S rank) :
    ∀ a ∈ S, Derivable P a := by
  have h := rankedSupport_subset_closed P S {a | Derivable P a}
    rank hs (derivable_closed P)
  intro a ha
  exact h ha

/-- Closure prevents any finite derivation from escaping the claimed set. -/
theorem derivable_subset_closed (P : GroundProgram Atom) (S : Set Atom)
    (hs : Closed P S) :
    ∀ a, Derivable P a → a ∈ S := by
  intro a h
  induction h with
  | fact hfact => exact hs.1 _ hfact
  | rule r hr hbody ih =>
      exact hs.2 r hr (fun b hb => ih b hb)

/-- Closure and ranked support identify exactly the inductively derivable
atoms; equivalently, the claimed set is the least closed model. -/
theorem closed_rankedSupport_iff_derivable (P : GroundProgram Atom)
    (S : Set Atom) (rank : Atom → Nat)
    (hclosed : Closed P S) (hsupport : RankedSupport P S rank) :
    S = {a | Derivable P a} ∧
      ∀ T, Closed P T → S ⊆ T := by
  constructor
  · ext a
    constructor
    · exact rankedSupport_derivable P S rank hsupport a
    · exact derivable_subset_closed P S hclosed a
  · intro T hT
    exact rankedSupport_subset_closed P S T rank hsupport hT

/-- A closed, ranked-supported set is a fixed point of the immediate
consequence operator and is contained in every other closed set. -/
theorem closed_rankedSupport_leastFixed (P : GroundProgram Atom)
    (S : Set Atom) (rank : Atom → Nat)
    (hclosed : Closed P S) (hsupport : RankedSupport P S rank) :
    step P S = S ∧ ∀ T, Closed P T → S ⊆ T := by
  constructor
  · ext a
    constructor
    · intro ha
      rcases ha with hfact | ⟨r, hr, hhead, hbody⟩
      · exact hclosed.1 a hfact
      · have hh := hclosed.2 r hr hbody
        rwa [hhead] at hh
    · intro ha
      rcases hsupport a ha with hfact | ⟨r, hr, hhead, hbody⟩
      · exact Or.inl hfact
      · exact Or.inr ⟨r, hr, hhead, fun b hb => (hbody b hb).1⟩
  · exact (closed_rankedSupport_iff_derivable P S rank hclosed hsupport).2

/-- For a finite relation signature over `Fin domain`, admitted ground rule
instances and input tuples satisfying closure and strict ranked support form
the least fixed relational valuation. Every declared tuple coordinate,
including nullary tuples, belongs to `GroundAtom`. -/
theorem groundAtoms_leastFixed
    (signature : RelationSignature) (domain : Nat)
    [Fintype (GroundAtom signature domain)]
    [DecidableEq (GroundAtom signature domain)]
    (P : GroundProgram (GroundAtom signature domain))
    (S : Set (GroundAtom signature domain))
    (rank : GroundAtom signature domain → Nat)
    (hclosed : Closed P S) (hsupport : RankedSupport P S rank) :
    step P S = S ∧ ∀ T, Closed P T → S ⊆ T :=
  closed_rankedSupport_leastFixed P S rank hclosed hsupport

section Complement

variable {Assignment : Type v} {Column : Type w} {Value : Type u}

/-- The tuples whose value in each argument position belongs to that
position's chosen domain. -/
def columnProduct (domains : Column → Set Value) : Set (Column → Value) :=
  {tuple | ∀ i, tuple i ∈ domains i}

/-- A relation's complement restricted to the product of argument domains. -/
def restrictedComplement (domains : Column → Set Value)
    (relation : Set (Column → Value)) : Set (Column → Value) :=
  columnProduct domains \ relation

/-- Range restriction supplies values from positive-body binding columns;
layer completeness places every such value in the materialized domain. The
negative relation is the exact checked closure at the frozen layer boundary.
On these assignments, restricted complement membership is exact negation. -/
theorem restrictedComplement_exact
    (positiveBody : Assignment → Prop)
    (tuple : Assignment → Column → Value)
    (bindingValues domains : Column → Set Value)
    (checkedRelation sourceRelation : Set (Column → Value))
    (rangeRestricted : ∀ σ, positiveBody σ →
      ∀ i, tuple σ i ∈ bindingValues i)
    (layerComplete : ∀ i, bindingValues i ⊆ domains i)
    (relationExact : checkedRelation = sourceRelation)
    (σ : Assignment) (hbody : positiveBody σ) :
    tuple σ ∈ restrictedComplement domains checkedRelation ↔
      tuple σ ∉ sourceRelation := by
  constructor
  · intro h
    simpa only [relationExact] using h.2
  · intro hnot
    constructor
    · intro i
      exact layerComplete i (rangeRestricted σ hbody i)
    · simpa only [relationExact] using hnot

/-- An empty chosen column domain excludes every positive-body assignment
whose queried value is bound by the declared complete column source. -/
theorem empty_column_excludes_positive
    (positiveBody : Assignment → Prop)
    (tuple : Assignment → Column → Value)
    (bindingValues domains : Column → Set Value)
    (rangeRestricted : ∀ σ, positiveBody σ →
      ∀ i, tuple σ i ∈ bindingValues i)
    (layerComplete : ∀ i, bindingValues i ⊆ domains i)
    (i : Column) (hempty : domains i = ∅) (σ : Assignment) :
    ¬ positiveBody σ := by
  intro hbody
  have hvalue := layerComplete i (rangeRestricted σ hbody i)
  rw [hempty] at hvalue
  exact hvalue

end Complement
end RelationalSupport
end WeightedRules
