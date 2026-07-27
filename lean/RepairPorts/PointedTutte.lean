import RepairPorts.Reliability
import Mathlib.Tactic

/-!
# Pointed rank sums and the repair-radius boundary

For a distinguished element, deletion and contraction differ in rank by zero or one.  This module
states the corresponding Las Vergnas subset sum without importing a separate matroid formalization:
the deletion rank, contraction rank, and original rank are explicit theorem hypotheses.  It proves
that the third perspective exponent is the distinguished-element rank jump and that the
deletion-minus-contraction rank specialization is the successful-set enumerator.

The final results isolate the information lost by an unfiltered homogeneous enumerator.  Two
three-helper repairs have reliability determined by the sizes of the two repairs and their union.
Thus two ports can agree at full radius while a cardinality cutoff distinguishes them.  These are
finite-sum identities; no executable certificate or native evaluation occurs in their proofs.
-/

namespace RepairPorts

open Finset

variable {ι : Type*} [DecidableEq ι]

/-- The direct distinguished-element subset evaluation of the pointed Tutte rank sum. -/
def pointedTutteSubsetEvaluation
    (U : Finset ι) (x : ι) (totalRank : ℕ) (rank : Finset ι → ℕ)
    (X Y Z : ℤ) : ℤ :=
  ∑ A ∈ U.powerset,
    (X - 1) ^ (totalRank - rank (insert x A)) *
      (Y - 1) ^ (A.card - rank A) *
        Z ^ (rank (insert x A) - rank A)

/-- The rank-one perspective subset evaluation, with deletion rank `deleteRank` and contraction
rank `contractRank`. -/
def elementaryPerspectiveSubsetEvaluation
    (U : Finset ι) (totalRank : ℕ)
    (deleteRank contractRank : Finset ι → ℕ) (X Y Z : ℤ) : ℤ :=
  ∑ A ∈ U.powerset,
    (X - 1) ^ ((totalRank - 1) - contractRank A) *
      (Y - 1) ^ (A.card - deleteRank A) *
        Z ^ (1 - (deleteRank A - contractRank A))

/-- Deletion and contraction turn the rank-one perspective subset sum into the direct pointed
rank-jump sum.  The hypotheses are exactly the deletion-rank identity, the contraction-rank
identity, and the fact that adjoining one element raises rank by at most one. -/
theorem elementaryPerspectiveSubsetEvaluation_eq_pointedTutte
    (U : Finset ι) (x : ι) (totalRank : ℕ)
    (rank deleteRank contractRank : Finset ι → ℕ) (X Y Z : ℤ)
    (hdelete : ∀ A ∈ U.powerset, deleteRank A = rank A)
    (hcontract : ∀ A ∈ U.powerset, contractRank A + 1 = rank (insert x A))
    (hrank_le : ∀ A ∈ U.powerset, rank (insert x A) ≤ totalRank)
    (hmono : ∀ A ∈ U.powerset, rank A ≤ rank (insert x A))
    (hstep : ∀ A ∈ U.powerset, rank (insert x A) ≤ rank A + 1) :
    elementaryPerspectiveSubsetEvaluation U totalRank deleteRank contractRank X Y Z =
      pointedTutteSubsetEvaluation U x totalRank rank X Y Z := by
  classical
  unfold elementaryPerspectiveSubsetEvaluation pointedTutteSubsetEvaluation
  apply sum_congr rfl
  intro A hA
  have hd := hdelete A hA
  have hc := hcontract A hA
  have hr := hrank_le A hA
  have hm := hmono A hA
  have hs := hstep A hA
  have hx :
      totalRank - 1 - contractRank A =
        totalRank - rank (insert x A) := by omega
  have hz :
      1 - (rank A - contractRank A) =
        rank (insert x A) - rank A := by omega
  rw [hd, hx, hz]

/-- The cardinality enumerator of subsets that span the distinguished element. -/
def successfulSetEnumerator
    (U : Finset ι) (x : ι) (rank : Finset ι → ℕ) (u : ℤ) : ℤ :=
  ∑ A ∈ U.powerset, if rank (insert x A) = rank A then u ^ A.card else 0

/-- The cardinality specialization of the deletion-minus-contraction rank difference. -/
def deletionContractionRankDifference
    (U : Finset ι) (deleteRank contractRank : Finset ι → ℕ) (u : ℤ) : ℤ :=
  ∑ A ∈ U.powerset, u ^ A.card * (deleteRank A - contractRank A : ℕ)

/-- Termwise differentiation of the two ordinary rank polynomials at rank variable one gives the
successful-set enumerator.  The displayed sum is that evaluated derivative difference. -/
theorem deletionContractionRankDifference_eq_successfulSetEnumerator
    (U : Finset ι) (x : ι) (rank deleteRank contractRank : Finset ι → ℕ) (u : ℤ)
    (hdelete : ∀ A ∈ U.powerset, deleteRank A = rank A)
    (hcontract : ∀ A ∈ U.powerset, contractRank A + 1 = rank (insert x A))
    (hmono : ∀ A ∈ U.powerset, rank A ≤ rank (insert x A))
    (hstep : ∀ A ∈ U.powerset, rank (insert x A) ≤ rank A + 1) :
    deletionContractionRankDifference U deleteRank contractRank u =
      successfulSetEnumerator U x rank u := by
  classical
  unfold deletionContractionRankDifference successfulSetEnumerator
  apply sum_congr rfl
  intro A hA
  have hd := hdelete A hA
  have hc := hcontract A hA
  have hm := hmono A hA
  have hs := hstep A hA
  by_cases heq : rank (insert x A) = rank A
  · have hdiff : deleteRank A - contractRank A = 1 := by omega
    simp [heq, hdiff]
  · have hdiff : deleteRank A - contractRank A = 0 := by omega
    simp [heq, hdiff]

/-- The indicator of containing either of two fixed repair sets satisfies inclusion--exclusion. -/
theorem twoRepair_successIndicator
    (E F A : Finset ι) :
    portSuccessIndicator {E, F} A =
      portSuccessIndicator {E} A + portSuccessIndicator {F} A -
        portSuccessIndicator {E ∪ F} A := by
  classical
  unfold portSuccessIndicator PortSucceeds
  by_cases hE : E ⊆ A <;> by_cases hF : F ⊆ A <;>
    simp [hE, hF, union_subset_iff]

/-- Under homogeneous independent survival, the probability that a survivor set contains a fixed
set `E` is `s` to the cardinality of `E`. -/
theorem subsetAverage_contains
    (U E : Finset ι) (hEU : E ⊆ U) (s : ℝ) :
    subsetAverage U (fun A => if E ⊆ A then 1 else 0) (fun _ => s) = s ^ E.card := by
  classical
  induction U using Finset.induction_on generalizing E with
  | empty =>
      have hE : E = ∅ := Subset.antisymm hEU (empty_subset E)
      subst E
      simp [subsetAverage, subsetWeight]
  | @insert v U hv ih =>
      rw [subsetAverage_insert U v hv]
      by_cases hvE : v ∈ E
      · let E' := E.erase v
        have hE'U : E' ⊆ U := by
          intro w hw
          have hwE : w ∈ E := (mem_erase.mp hw).2
          have hwInsert : w ∈ insert v U := hEU hwE
          exact (mem_insert.mp hwInsert).resolve_left (mem_erase.mp hw).1
        have hcard : E.card = E'.card + 1 := by
          exact (card_erase_add_one hvE).symm
        have hwithout :
            subsetAverage U (fun A => if E ⊆ A then 1 else 0) (fun _ => s) = 0 := by
          unfold subsetAverage
          apply sum_eq_zero
          intro A hA
          have hvA : v ∉ A := notMem_of_mem_powerset_of_notMem hA hv
          have hnot : ¬ E ⊆ A := fun hEA => hvA (hEA hvE)
          simp [hnot]
        have hwith :
            subsetAverage U (fun A => if E ⊆ insert v A then 1 else 0) (fun _ => s) =
              s ^ E'.card := by
          have hindicator :
              (fun A => if E ⊆ insert v A then (1 : ℝ) else 0) =
                fun A => if E' ⊆ A then 1 else 0 := by
            funext A
            apply if_congr
            constructor
            · intro h w hw
              have hwInsert := h (mem_of_mem_erase hw)
              exact (mem_insert.mp hwInsert).resolve_left (mem_erase.mp hw).1
            · intro h w hw
              by_cases hwv : w = v
              · exact hwv ▸ mem_insert_self v A
              · exact mem_insert_of_mem (h (mem_erase.mpr ⟨hwv, hw⟩))
            · rfl
            · rfl
          rw [hindicator, ih E' hE'U]
        rw [hwithout, hwith, hcard]
        ring
      · have hEU' : E ⊆ U := by
          intro w hw
          exact (mem_insert.mp (hEU hw)).resolve_left (fun hwv => hvE (hwv ▸ hw))
        have hwithout :
            subsetAverage U (fun A => if E ⊆ A then 1 else 0) (fun _ => s) =
              s ^ E.card := ih E hEU'
        have hwith :
            subsetAverage U (fun A => if E ⊆ insert v A then 1 else 0) (fun _ => s) =
              s ^ E.card := by
          have hindicator :
              (fun A => if E ⊆ insert v A then (1 : ℝ) else 0) =
                fun A => if E ⊆ A then 1 else 0 := by
            funext A
            apply if_congr
            constructor
            · intro h w hw
              have hwInsert := h hw
              exact (mem_insert.mp hwInsert).resolve_left fun hwv => hvE (hwv ▸ hw)
            · intro h w hw
              exact mem_insert_of_mem (h hw)
            · rfl
            · rfl
          rw [hindicator, ih E hEU']
        rw [hwithout, hwith]
        ring

/-- Two fixed repair sets have homogeneous reliability
`s^|E| + s^|F| - s^|E ∪ F|`. -/
theorem portReliability_pair_homogeneous
    (U E F : Finset ι) (hEU : E ⊆ U) (hFU : F ⊆ U) (s : ℝ) :
    portReliability U {E, F} (fun _ => s) =
      s ^ E.card + s ^ F.card - s ^ (E ∪ F).card := by
  rw [portReliability, show portSuccessIndicator {E, F} =
      fun A => portSuccessIndicator {E} A + portSuccessIndicator {F} A -
        portSuccessIndicator {E ∪ F} A by
      funext A
      exact twoRepair_successIndicator E F A]
  rw [subsetAverage_sub, subsetAverage_add]
  have hsingle (K : Finset ι) (hKU : K ⊆ U) :
      subsetAverage U (portSuccessIndicator {K}) (fun _ => s) = s ^ K.card := by
    have hindicator :
        portSuccessIndicator {K} = fun A => if K ⊆ A then 1 else 0 := by
      funext A
      unfold portSuccessIndicator PortSucceeds
      simp
    rw [hindicator, subsetAverage_contains U K hKU s]
  rw [hsingle E hEU, hsingle F hFU, hsingle (E ∪ F) (union_subset hEU hFU)]

section RadiusThreeWitness

/-- The six-helper universe for the symbolic radius-three overlap witness. -/
def sixHelperUniverse : Finset (Fin 6) := Finset.univ

/-- Two disjoint three-helper repairs. -/
def disjointTripleRepairs : Finset (Finset (Fin 6)) :=
  {{0, 3, 4}, {1, 2, 5}}

/-- Two three-helper repairs meeting in helper one. -/
def overlappingTripleRepairs : Finset (Finset (Fin 6)) :=
  {{0, 1, 2}, {1, 4, 5}}

/-- Two disjoint three-helper repairs have homogeneous reliability `2s³-s⁶`. -/
theorem disjointTripleRepairs_reliability (s : ℝ) :
    portReliability sixHelperUniverse disjointTripleRepairs (fun _ => s) =
      2 * s ^ 3 - s ^ 6 := by
  rw [show disjointTripleRepairs = ({{0, 3, 4}, {1, 2, 5}} :
      Finset (Finset (Fin 6))) by rfl]
  rw [portReliability_pair_homogeneous]
  · change s ^ 3 + s ^ 3 - s ^ 6 = 2 * s ^ 3 - s ^ 6
    ring
  · simp [sixHelperUniverse]
  · simp [sixHelperUniverse]

/-- Two three-helper repairs meeting in one helper have homogeneous reliability `2s³-s⁵`. -/
theorem overlappingTripleRepairs_reliability (s : ℝ) :
    portReliability sixHelperUniverse overlappingTripleRepairs (fun _ => s) =
      2 * s ^ 3 - s ^ 5 := by
  rw [show overlappingTripleRepairs = ({{0, 1, 2}, {1, 4, 5}} :
      Finset (Finset (Fin 6))) by rfl]
  rw [portReliability_pair_homogeneous]
  · change s ^ 3 + s ^ 3 - s ^ 5 = 2 * s ^ 3 - s ^ 5
    ring
  · simp [sixHelperUniverse]
  · simp [sixHelperUniverse]

/-- At survival probability one half, the disjoint and overlapping radius-three ports have
different reliabilities. -/
theorem disjointTripleRepairs_reliability_ne_overlapping :
    portReliability sixHelperUniverse disjointTripleRepairs (fun _ => (1 / 2 : ℝ)) ≠
      portReliability sixHelperUniverse overlappingTripleRepairs (fun _ => (1 / 2 : ℝ)) := by
  rw [disjointTripleRepairs_reliability, overlappingTripleRepairs_reliability]
  norm_num

end RadiusThreeWitness

end RepairPorts
