import RepairPorts.CoefficientPort
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Algebra.Polynomial.Div
import Mathlib.Algebra.Polynomial.Eval.Coeff

/-!
# Finite reliability and bounded-radius erasure transforms

A finite helper port is represented by a finite family of helper sets.  Its success indicator is
one exactly when the realized survivor set contains a repair set.  This module develops the
multilinear Bernoulli average of an arbitrary function on finite subsets and then specializes it to
that indicator.

All identities are finite-sum identities.  The deletion--contraction formula is conditioning on
one helper; its coordinate difference is the probability that the helper is pivotal.
-/

namespace RepairPorts

open Finset

variable {ι : Type*} [DecidableEq ι]

/-- The product Bernoulli weight of `A ⊆ U`, with coordinate survival parameters `s`. -/
def subsetWeight (U : Finset ι) (s : ι → ℝ) (A : Finset ι) : ℝ :=
  ∏ v ∈ U, if v ∈ A then s v else 1 - s v

/-- The finite multilinear average of a function on survivor sets. -/
def subsetAverage (U : Finset ι) (f : Finset ι → ℝ) (s : ι → ℝ) : ℝ :=
  ∑ A ∈ U.powerset, subsetWeight U s A * f A

/-- The discrete coordinate derivative of a function on subsets. -/
def discreteDerivative (v : ι) (f : Finset ι → ℝ) (A : Finset ι) : ℝ :=
  f (insert v A) - f A

/-- The empty helper universe has unit Bernoulli weight. -/
@[simp]
theorem subsetWeight_empty (s : ι → ℝ) (A : Finset ι) :
    subsetWeight ∅ s A = 1 := by
  simp [subsetWeight]

/-- Adding an absent, unrealized helper multiplies the weight by its failure probability. -/
theorem subsetWeight_insert_of_notMem {U A : Finset ι} {v : ι}
    (hvU : v ∉ U) (hvA : v ∉ A) (s : ι → ℝ) :
    subsetWeight (insert v U) s A = (1 - s v) * subsetWeight U s A := by
  simp [subsetWeight, hvU, hvA]

/-- Adding an absent, realized helper multiplies the weight by its survival probability. -/
theorem subsetWeight_insert_insert_of_notMem {U A : Finset ι} {v : ι}
    (hvU : v ∉ U) (s : ι → ℝ) :
    subsetWeight (insert v U) s (insert v A) = s v * subsetWeight U s A := by
  rw [subsetWeight, prod_insert hvU, if_pos (mem_insert_self v A)]
  congr 1
  apply prod_congr rfl
  intro u hu
  have huv : u ≠ v := fun huv => hvU (huv ▸ hu)
  simp [huv]

/-- Split a subset average according to whether one new coordinate is absent or present. -/
theorem subsetAverage_insert (U : Finset ι) (v : ι) (hv : v ∉ U)
    (f : Finset ι → ℝ) (s : ι → ℝ) :
    subsetAverage (insert v U) f s =
      (1 - s v) * subsetAverage U f s +
        s v * subsetAverage U (fun A => f (insert v A)) s := by
  classical
  rw [subsetAverage, powerset_insert, sum_union]
  · rw [sum_image]
    · have hdelete :
          (∑ A ∈ U.powerset, subsetWeight (insert v U) s A * f A) =
            (1 - s v) * subsetAverage U f s := by
          rw [subsetAverage, mul_sum]
          apply sum_congr rfl
          intro A hA
          rw [subsetWeight_insert_of_notMem hv
            (notMem_of_mem_powerset_of_notMem hA hv)]
          ring
      have hcontract :
          (∑ A ∈ U.powerset,
              subsetWeight (insert v U) s (insert v A) * f (insert v A)) =
            s v * subsetAverage U (fun A => f (insert v A)) s := by
          rw [subsetAverage, mul_sum]
          apply sum_congr rfl
          intro A hA
          rw [subsetWeight_insert_insert_of_notMem hv]
          ring
      rw [hdelete, hcontract]
    · intro A hA B hB hAB
      have h := congrArg (fun E : Finset ι => E.erase v) hAB
      simpa [notMem_of_mem_powerset_of_notMem hA hv,
        notMem_of_mem_powerset_of_notMem hB hv] using h
  · exact disjoint_left.mpr fun A hA hAi =>
      (notMem_of_mem_powerset_of_notMem hA hv) (by
        obtain ⟨B, hB, rfl⟩ := mem_image.mp hAi
        exact mem_insert_self v B)

/-- A subset average depends only on parameters indexed by its finite universe. -/
theorem subsetAverage_congr_parameters {U : Finset ι} {s t : ι → ℝ}
    (hst : ∀ v ∈ U, s v = t v) (f : Finset ι → ℝ) :
    subsetAverage U f s = subsetAverage U f t := by
  apply sum_congr rfl
  intro A hA
  congr 1
  apply prod_congr rfl
  intro v hv
  rw [hst v hv]

/-- Finite subset averaging preserves pointwise addition. -/
theorem subsetAverage_add (U : Finset ι) (f g : Finset ι → ℝ) (s : ι → ℝ) :
    subsetAverage U (fun A => f A + g A) s =
      subsetAverage U f s + subsetAverage U g s := by
  simp only [subsetAverage, mul_add, sum_add_distrib]

/-- Finite subset averaging preserves pointwise subtraction. -/
theorem subsetAverage_sub (U : Finset ι) (f g : Finset ι → ℝ) (s : ι → ℝ) :
    subsetAverage U (fun A => f A - g A) s =
      subsetAverage U f s - subsetAverage U g s := by
  simp only [subsetAverage, mul_sub, sum_sub_distrib]

/-- A constant scalar factors out of a finite subset average. -/
theorem subsetAverage_const_mul (U : Finset ι) (c : ℝ) (f : Finset ι → ℝ)
    (s : ι → ℝ) :
    subsetAverage U (fun A => c * f A) s = c * subsetAverage U f s := by
  simp only [subsetAverage, ← mul_assoc, mul_left_comm c, mul_sum]

/-- The Bernoulli weights of all subsets of a finite universe sum to one. -/
theorem subsetAverage_one (U : Finset ι) (s : ι → ℝ) :
    subsetAverage U (fun _ => 1) s = 1 := by
  induction U using Finset.induction_on with
  | empty => simp [subsetAverage, subsetWeight]
  | @insert v U hv ih =>
      rw [subsetAverage_insert U v hv]
      simp only [ih]
      ring

/-- Conditioning on one coordinate gives the finite deletion--contraction identity. -/
theorem subsetAverage_delete_contract {U : Finset ι} {v : ι} (hv : v ∈ U)
    (f : Finset ι → ℝ) (s : ι → ℝ) :
    subsetAverage U f s =
      (1 - s v) * subsetAverage (U.erase v) f s +
        s v * subsetAverage (U.erase v) (fun A => f (insert v A)) s := by
  rw [← insert_erase hv]
  simpa using subsetAverage_insert (U.erase v) v (notMem_erase v U) f s

/-- The contract-minus-delete conditional averages equal the averaged discrete derivative. -/
theorem contract_sub_delete_eq_discreteDerivative {U : Finset ι} {v : ι}
    (f : Finset ι → ℝ) (s : ι → ℝ) :
    subsetAverage (U.erase v) (fun A => f (insert v A)) s -
        subsetAverage (U.erase v) f s =
      subsetAverage (U.erase v) (discreteDerivative v f) s := by
  rw [← subsetAverage_sub]
  rfl

private theorem subsetAverage_update_of_notMem {U : Finset ι} {v : ι}
    (hv : v ∉ U) (f : Finset ι → ℝ) (s : ι → ℝ) (t : ℝ) :
    subsetAverage U f (Function.update s v t) = subsetAverage U f s := by
  apply subsetAverage_congr_parameters (f := f)
  intro u hu
  simp [Function.update, ne_of_mem_of_not_mem hu hv]

/-- The partial derivative in one survival parameter is its discrete influence. -/
theorem hasDerivAt_update_subsetAverage {U : Finset ι} {v : ι} (hv : v ∈ U)
    (f : Finset ι → ℝ) (s : ι → ℝ) :
    HasDerivAt (fun t => subsetAverage U f (Function.update s v t))
      (subsetAverage (U.erase v) (discreteDerivative v f) s) (s v) := by
  have hrec : ∀ t : ℝ,
      subsetAverage U f (Function.update s v t) =
        (1 - t) * subsetAverage (U.erase v) f s +
          t * subsetAverage (U.erase v) (fun A => f (insert v A)) s := by
    intro t
    rw [subsetAverage_delete_contract hv]
    simp only [Function.update_self]
    rw [subsetAverage_update_of_notMem (notMem_erase v U),
      subsetAverage_update_of_notMem (notMem_erase v U)]
  have hbase := (((hasDerivAt_id (x := s v)).const_sub 1).mul_const
      (subsetAverage (U.erase v) f s)).add
      ((hasDerivAt_id (x := s v)).mul_const
        (subsetAverage (U.erase v) (fun A => f (insert v A)) s))
  have hcoef :
      -1 * subsetAverage (U.erase v) f s +
          1 * subsetAverage (U.erase v) (fun A => f (insert v A)) s =
        subsetAverage (U.erase v) (discreteDerivative v f) s := by
    calc
      -1 * subsetAverage (U.erase v) f s +
          1 * subsetAverage (U.erase v) (fun A => f (insert v A)) s =
          subsetAverage (U.erase v) (fun A => f (insert v A)) s -
            subsetAverage (U.erase v) f s := by ring
      _ = subsetAverage (U.erase v) (discreteDerivative v f) s :=
        contract_sub_delete_eq_discreteDerivative f s
  exact (hbase.congr_deriv hcoef).congr_of_eventuallyEq
    (Filter.Eventually.of_forall hrec)

/-- A survivor set succeeds when it contains at least one repair set. -/
def PortSucceeds (H : Finset (Finset ι)) (A : Finset ι) : Prop :=
  ∃ E ∈ H, E ⊆ A

/-- The real-valued success indicator of a finite helper port. -/
noncomputable def portSuccessIndicator (H : Finset (Finset ι)) (A : Finset ι) : ℝ := by
  classical
  exact if PortSucceeds H A then 1 else 0

/-- Reliability of a finite helper port under independent helper survival. -/
noncomputable def portReliability (U : Finset ι) (H : Finset (Finset ι))
    (s : ι → ℝ) : ℝ :=
  subsetAverage U (portSuccessIndicator H) s

/-- The deletion of a helper removes every repair set using it. -/
def deleteHelper (H : Finset (Finset ι)) (v : ι) : Finset (Finset ι) :=
  H.filter fun E => v ∉ E

/-- The contraction of a helper removes it from every repair set. -/
def contractHelper (H : Finset (Finset ι)) (v : ι) : Finset (Finset ι) :=
  H.image fun E => E.erase v

/-- On sets avoiding `v`, deleting `v` from the port does not change success. -/
theorem portSucceeds_deleteHelper_iff {H : Finset (Finset ι)} {v : ι}
    {A : Finset ι} (hvA : v ∉ A) :
    PortSucceeds (deleteHelper H v) A ↔ PortSucceeds H A := by
  constructor
  · rintro ⟨E, hE, hEA⟩
    exact ⟨E, (mem_filter.mp hE).1, hEA⟩
  · rintro ⟨E, hE, hEA⟩
    have hvE : v ∉ E := fun hvE => hvA (hEA hvE)
    exact ⟨E, mem_filter.mpr ⟨hE, hvE⟩, hEA⟩

/-- On sets avoiding `v`, contraction records success after adjoining `v`. -/
theorem portSucceeds_contractHelper_iff {H : Finset (Finset ι)} {v : ι}
    {A : Finset ι} (hvA : v ∉ A) :
    PortSucceeds (contractHelper H v) A ↔ PortSucceeds H (insert v A) := by
  constructor
  · rintro ⟨E', hE', hE'A⟩
    obtain ⟨E, hE, rfl⟩ := mem_image.mp hE'
    refine ⟨E, hE, ?_⟩
    intro u hu
    by_cases huv : u = v
    · simp [huv]
    · exact mem_insert_of_mem (hE'A (mem_erase.mpr ⟨huv, hu⟩))
  · rintro ⟨E, hE, hEins⟩
    refine ⟨E.erase v, mem_image.mpr ⟨E, hE, rfl⟩, ?_⟩
    intro u hu
    have huins := hEins (mem_of_mem_erase hu)
    rcases mem_insert.mp huins with rfl | huA
    · exact False.elim ((mem_erase.mp hu).1 rfl)
    · exact huA

/-- The deletion success indicators agree on survivor sets avoiding the deleted helper. -/
theorem portSuccessIndicator_deleteHelper {H : Finset (Finset ι)} {v : ι}
    {A : Finset ι} (hvA : v ∉ A) :
    portSuccessIndicator (deleteHelper H v) A = portSuccessIndicator H A := by
  classical
  unfold portSuccessIndicator
  rw [portSucceeds_deleteHelper_iff hvA]

/-- The contraction indicator agrees with the original indicator after adjoining the helper. -/
theorem portSuccessIndicator_contractHelper {H : Finset (Finset ι)} {v : ι}
    {A : Finset ι} (hvA : v ∉ A) :
    portSuccessIndicator (contractHelper H v) A =
      portSuccessIndicator H (insert v A) := by
  classical
  unfold portSuccessIndicator
  rw [portSucceeds_contractHelper_iff hvA]

/-- Reliability obeys deletion--contraction by conditioning on one helper. -/
theorem portReliability_delete_contract {U : Finset ι} {H : Finset (Finset ι)}
    {v : ι} (hv : v ∈ U) (s : ι → ℝ) :
    portReliability U H s =
      (1 - s v) * portReliability (U.erase v) (deleteHelper H v) s +
        s v * portReliability (U.erase v) (contractHelper H v) s := by
  rw [portReliability, subsetAverage_delete_contract hv]
  have hdelete :
      subsetAverage (U.erase v) (portSuccessIndicator H) s =
        subsetAverage (U.erase v) (portSuccessIndicator (deleteHelper H v)) s := by
    unfold subsetAverage
    apply sum_congr rfl
    intro A hA
    congr 1
    exact (portSuccessIndicator_deleteHelper (H := H)
      (notMem_of_mem_powerset_of_notMem hA (notMem_erase v U))).symm
  have hcontract :
      subsetAverage (U.erase v) (fun A => portSuccessIndicator H (insert v A)) s =
        subsetAverage (U.erase v) (portSuccessIndicator (contractHelper H v)) s := by
    unfold subsetAverage
    apply sum_congr rfl
    intro A hA
    congr 1
    exact (portSuccessIndicator_contractHelper
      (notMem_of_mem_powerset_of_notMem hA (notMem_erase v U))).symm
  rw [hdelete, hcontract, portReliability, portReliability]

/-- A helper is pivotal when adding it changes failure into success. -/
noncomputable def pivotalIndicator (H : Finset (Finset ι)) (v : ι)
    (A : Finset ι) : ℝ := by
  classical
  exact if ¬PortSucceeds H A ∧ PortSucceeds H (insert v A) then 1 else 0

/-- The discrete derivative of a monotone port indicator is exactly its pivotal indicator. -/
theorem discreteDerivative_portSuccessIndicator {H : Finset (Finset ι)}
    {v : ι} {A : Finset ι} :
    discreteDerivative v (portSuccessIndicator H) A = pivotalIndicator H v A := by
  unfold discreteDerivative portSuccessIndicator pivotalIndicator
  by_cases hA : PortSucceeds H A
  · have hins : PortSucceeds H (insert v A) := by
      obtain ⟨E, hE, hEA⟩ := hA
      exact ⟨E, hE, hEA.trans (subset_insert v A)⟩
    simp [hA, hins]
  · by_cases hins : PortSucceeds H (insert v A) <;> simp [hA, hins]

/-- The probability that `v` is pivotal, with `v` itself left unexposed. -/
noncomputable def pivotalProbability (U : Finset ι) (H : Finset (Finset ι))
    (v : ι) (s : ι → ℝ) : ℝ :=
  subsetAverage (U.erase v) (pivotalIndicator H v) s

/-- The coordinate derivative of reliability is the pivotal probability. -/
theorem hasDerivAt_portReliability_update {U : Finset ι} {H : Finset (Finset ι)}
    {v : ι} (hv : v ∈ U) (s : ι → ℝ) :
    HasDerivAt (fun t => portReliability U H (Function.update s v t))
      (pivotalProbability U H v s) (s v) := by
  change HasDerivAt
    (fun t => subsetAverage U (portSuccessIndicator H) (Function.update s v t))
    (subsetAverage (U.erase v) (pivotalIndicator H v) s) (s v)
  have h := hasDerivAt_update_subsetAverage hv (portSuccessIndicator H) s
  convert h using 1
  unfold subsetAverage
  apply sum_congr rfl
  intro A hA
  congr 1
  exact (discreteDerivative_portSuccessIndicator (H := H) (v := v) (A := A)).symm

/-- The sum of all coordinate influences of a multilinear subset function. -/
def totalDiscreteInfluence (U : Finset ι) (f : Finset ι → ℝ) (s : ι → ℝ) : ℝ :=
  ∑ v ∈ U, subsetAverage (U.erase v) (discreteDerivative v f) s

private theorem discreteDerivative_insert_comm {u v : ι} (_huv : u ≠ v)
    (f : Finset ι → ℝ) (A : Finset ι) :
    discreteDerivative u f (insert v A) =
      discreteDerivative u (fun B => f (insert v B)) A := by
  simp [discreteDerivative, insert_comm u v]

private theorem totalDiscreteInfluence_insert (U : Finset ι) (v : ι) (hv : v ∉ U)
    (f : Finset ι → ℝ) (s : ℝ) :
    totalDiscreteInfluence (insert v U) f (fun _ => s) =
      subsetAverage U (discreteDerivative v f) (fun _ => s) +
        (1 - s) * totalDiscreteInfluence U f (fun _ => s) +
        s * totalDiscreteInfluence U (fun A => f (insert v A)) (fun _ => s) := by
  classical
  rw [totalDiscreteInfluence, sum_insert hv]
  have hverase : (insert v U).erase v = U := by simp [hv]
  rw [hverase]
  have htail :
      (∑ u ∈ U,
          subsetAverage ((insert v U).erase u) (discreteDerivative u f) (fun _ => s)) =
        (1 - s) * totalDiscreteInfluence U f (fun _ => s) +
          s * totalDiscreteInfluence U (fun A => f (insert v A)) (fun _ => s) := by
    calc
      (∑ u ∈ U,
          subsetAverage ((insert v U).erase u) (discreteDerivative u f) (fun _ => s)) =
          ∑ u ∈ U,
            ((1 - s) *
                subsetAverage (U.erase u) (discreteDerivative u f) (fun _ => s) +
              s * subsetAverage (U.erase u)
                (discreteDerivative u (fun A => f (insert v A))) (fun _ => s)) := by
            apply sum_congr rfl
            intro u hu
            have huv : u ≠ v := fun huv => hv (huv ▸ hu)
            have herase : (insert v U).erase u = insert v (U.erase u) := by
              ext z
              by_cases hzv : z = v <;> by_cases hzu : z = u <;>
                simp [hzv, hzu, huv, huv.symm]
            rw [herase, subsetAverage_insert (U.erase u) v
              (fun hvu => hv (mem_of_mem_erase hvu))]
            congr 1
            congr 1
            apply sum_congr rfl
            intro A hA
            congr 1
            exact discreteDerivative_insert_comm huv f A
      _ = (1 - s) * totalDiscreteInfluence U f (fun _ => s) +
          s * totalDiscreteInfluence U (fun A => f (insert v A)) (fun _ => s) := by
            simp only [sum_add_distrib, ← mul_sum, totalDiscreteInfluence]
  rw [htail]
  ring

/-- Russo--Margulis for a finite multilinear subset average: along homogeneous survival
probability, the derivative is the sum of the coordinate influences. -/
theorem hasDerivAt_homogeneous_subsetAverage (U : Finset ι) (f : Finset ι → ℝ)
    (s : ℝ) :
    HasDerivAt (fun t => subsetAverage U f (fun _ => t))
      (totalDiscreteInfluence U f (fun _ => s)) s := by
  classical
  induction U using Finset.induction_on generalizing f s with
  | empty =>
      have hconst : ∀ t : ℝ, subsetAverage ∅ f (fun _ => t) = f ∅ := by
        intro t
        simp [subsetAverage, subsetWeight]
      have hzero : totalDiscreteInfluence ∅ f (fun _ => s) = 0 := by
        simp [totalDiscreteInfluence]
      rw [hzero]
      exact (hasDerivAt_const (x := s) (c := f ∅)).congr_of_eventuallyEq
        (Filter.Eventually.of_forall hconst)
  | @insert v U hv ih =>
      let f₀ : Finset ι → ℝ := f
      let f₁ : Finset ι → ℝ := fun A => f (insert v A)
      have hrec : ∀ t : ℝ,
          subsetAverage (insert v U) f (fun _ => t) =
            (1 - t) * subsetAverage U f₀ (fun _ => t) +
              t * subsetAverage U f₁ (fun _ => t) := by
        intro t
        simpa [f₀, f₁] using subsetAverage_insert U v hv f (fun _ => t)
      have hdel := ih f₀
      have hcon := ih f₁
      have hbase :=
        (((hasDerivAt_id (x := s)).const_sub 1).mul (hdel s)).add
          ((hasDerivAt_id (x := s)).mul (hcon s))
      have hcoef :
          (-1 * subsetAverage U f₀ (fun _ => s) +
              (1 - s) * totalDiscreteInfluence U f₀ (fun _ => s)) +
            (1 * subsetAverage U f₁ (fun _ => s) +
              s * totalDiscreteInfluence U f₁ (fun _ => s)) =
            totalDiscreteInfluence (insert v U) f (fun _ => s) := by
        rw [totalDiscreteInfluence_insert U v hv f s]
        have hdiff :
            subsetAverage U (discreteDerivative v f) (fun _ => s) =
              subsetAverage U f₁ (fun _ => s) - subsetAverage U f₀ (fun _ => s) := by
          rw [← subsetAverage_sub]
          rfl
        rw [hdiff]
        simp only [f₀, f₁]
        ring
      exact (hbase.congr_deriv hcoef).congr_of_eventuallyEq
        (Filter.Eventually.of_forall hrec)

/-- Homogeneous port reliability has derivative equal to the sum of pivotal probabilities. -/
theorem hasDerivAt_homogeneous_portReliability
    (U : Finset ι) (H : Finset (Finset ι)) (s : ℝ) :
    HasDerivAt (fun t => portReliability U H (fun _ => t))
      (∑ v ∈ U, pivotalProbability U H v (fun _ => s)) s := by
  change HasDerivAt (fun t => subsetAverage U (portSuccessIndicator H) (fun _ => t))
    (∑ v ∈ U, pivotalProbability U H v (fun _ => s)) s
  have h := hasDerivAt_homogeneous_subsetAverage U (portSuccessIndicator H) s
  apply h.congr_deriv
  unfold totalDiscreteInfluence pivotalProbability
  apply sum_congr rfl
  intro v hv
  unfold subsetAverage
  apply sum_congr rfl
  intro A hA
  congr 1
  exact discreteDerivative_portSuccessIndicator (H := H) (v := v) (A := A)

/-- Extrinsic erasure failure: the target is unavailable and helper `v` is erased with
probability `p v`. -/
noncomputable def erasureFailureProbability
    (U : Finset ι) (H : Finset (Finset ι)) (p : ι → ℝ) : ℝ :=
  1 - portReliability U H (fun v => 1 - p v)

/-- In erasure variables, conditioning has the failure-sign deletion--contraction form. -/
theorem erasureFailureProbability_delete_contract
    {U : Finset ι} {H : Finset (Finset ι)} {v : ι} (hv : v ∈ U) (p : ι → ℝ) :
    erasureFailureProbability U H p =
      p v * erasureFailureProbability (U.erase v) (deleteHelper H v) p +
        (1 - p v) * erasureFailureProbability (U.erase v) (contractHelper H v) p := by
  unfold erasureFailureProbability
  rw [portReliability_delete_contract hv]
  ring

/-- Restrict a port to repairs using at most `r` helpers. -/
def truncatePort (H : Finset (Finset ι)) (r : ℕ) : Finset (Finset ι) :=
  H.filter fun E => E.card ≤ r

omit [DecidableEq ι] in
/-- Increasing the radius can only add truncated repair sets. -/
theorem truncatePort_mono {H : Finset (Finset ι)} {r q : ℕ} (hrq : r ≤ q) :
    truncatePort H r ⊆ truncatePort H q := by
  intro E hE
  obtain ⟨hEH, hcard⟩ := mem_filter.mp hE
  exact mem_filter.mpr ⟨hEH, hcard.trans hrq⟩

omit [DecidableEq ι] in
/-- A survivor set successful for a subport remains successful for a larger port. -/
theorem portSucceeds_mono {H K : Finset (Finset ι)} (hHK : H ⊆ K)
    {A : Finset ι} (hA : PortSucceeds H A) : PortSucceeds K A := by
  obtain ⟨E, hEH, hEA⟩ := hA
  exact ⟨E, hHK hEH, hEA⟩

/-- The indicator that a repair is newly available in `K`, after being unavailable in `H`. -/
noncomputable def newlyRepairableIndicator
    (H K : Finset (Finset ι)) (A : Finset ι) : ℝ := by
  classical
  exact if ¬PortSucceeds H A ∧ PortSucceeds K A then 1 else 0

/-- The indicator that no repair in the port is available. -/
noncomputable def noRepairIndicator (H : Finset (Finset ι)) (A : Finset ι) : ℝ := by
  classical
  exact if ¬PortSucceeds H A then 1 else 0

omit [DecidableEq ι] in
/-- Failure is the complement of the success indicator, pointwise. -/
theorem noRepairIndicator_eq_one_sub (H : Finset (Finset ι)) (A : Finset ι) :
    noRepairIndicator H A = 1 - portSuccessIndicator H A := by
  classical
  unfold noRepairIndicator portSuccessIndicator
  by_cases h : PortSucceeds H A <;> simp [h]

/-- Averaging the no-repair event gives the extrinsic erasure failure probability. -/
theorem noRepairProbability_eq_erasureFailure
    (U : Finset ι) (H : Finset (Finset ι)) (p : ι → ℝ) :
    subsetAverage U (noRepairIndicator H) (fun v => 1 - p v) =
      erasureFailureProbability U H p := by
  have hpoint :
      noRepairIndicator H =
        (fun A => (fun _ : Finset ι => (1 : ℝ)) A - portSuccessIndicator H A) := by
    funext A
    exact noRepairIndicator_eq_one_sub H A
  rw [hpoint, subsetAverage_sub, subsetAverage_one]
  rfl

omit [DecidableEq ι] in
/-- For nested ports, the new-success indicator is the difference of success indicators. -/
theorem newlyRepairableIndicator_eq_sub {H K : Finset (Finset ι)}
    (hHK : H ⊆ K) (A : Finset ι) :
    newlyRepairableIndicator H K A =
      portSuccessIndicator K A - portSuccessIndicator H A := by
  classical
  unfold newlyRepairableIndicator portSuccessIndicator
  by_cases hH : PortSucceeds H A
  · have hK := portSucceeds_mono hHK hH
    simp [hH, hK]
  · by_cases hK : PortSucceeds K A <;> simp [hH, hK]

/-- Success gained between two nested radii is exactly the probability that the cheapest
available repair enters in that radius step. -/
theorem newlyRepairableProbability_eq_reliability_sub
    {U : Finset ι} {H K : Finset (Finset ι)} (hHK : H ⊆ K) (s : ι → ℝ) :
    subsetAverage U (newlyRepairableIndicator H K) s =
      portReliability U K s - portReliability U H s := by
  rw [portReliability, portReliability, ← subsetAverage_sub]
  unfold subsetAverage
  apply sum_congr rfl
  intro A hA
  congr 1
  exact newlyRepairableIndicator_eq_sub hHK A

/-- For the cardinality filtration, the reliability increment from radius `r-1` to `r` is the
probability that the cheapest available repair has size exactly `r`. -/
theorem cheapestRepairRadiusProbability
    (U : Finset ι) (H : Finset (Finset ι)) (r : ℕ) (s : ι → ℝ) :
    subsetAverage U
        (newlyRepairableIndicator (truncatePort H (r - 1)) (truncatePort H r)) s =
      portReliability U (truncatePort H r) s -
        portReliability U (truncatePort H (r - 1)) s := by
  apply newlyRepairableProbability_eq_reliability_sub
  exact truncatePort_mono (Nat.sub_le r 1)

/-- In erasure notation, the cheapest-radius mass is the preceding failure curve minus the new
failure curve. -/
theorem cheapestRepairRadiusProbability_eq_failure_sub
    (U : Finset ι) (H : Finset (Finset ι)) (r : ℕ) (p : ι → ℝ) :
    subsetAverage U
        (newlyRepairableIndicator (truncatePort H (r - 1)) (truncatePort H r))
        (fun v => 1 - p v) =
      erasureFailureProbability U (truncatePort H (r - 1)) p -
        erasureFailureProbability U (truncatePort H r) p := by
  rw [cheapestRepairRadiusProbability]
  unfold erasureFailureProbability
  ring

/-- The number of size-`k` failure blockers contained in the helper universe. -/
noncomputable def blockerCount
    (U : Finset ι) (H : Finset (Finset ι)) (k : ℕ) : ℕ := by
  classical
  exact ((U.powersetCard k).filter fun F => FiniteGeom.IsTransversal H F).card

/-- A minimal blocker is a transversal with no proper transversal subset. -/
def IsMinimalBlocker (H : Finset (Finset ι)) (F : Finset ι) : Prop :=
  FiniteGeom.IsTransversal H F ∧
    ∀ G, G ⊂ F → ¬FiniteGeom.IsTransversal H G

/-- A minimum-cardinality transversal is an inclusion-minimal blocker. -/
theorem isMinimalBlocker_of_minimum_card
    {U : Finset ι} {H : Finset (Finset ι)} {τ : ℕ} {F : Finset ι}
    (hmin : ∀ G ∈ U.powerset, FiniteGeom.IsTransversal H G → τ ≤ G.card)
    (hFU : F ⊆ U) (hcard : F.card = τ) (htrans : FiniteGeom.IsTransversal H F) :
    IsMinimalBlocker H F := by
  refine ⟨htrans, ?_⟩
  intro G hGF hGtrans
  have hGU : G ⊆ U := hGF.1.trans hFU
  have hlower := hmin G (mem_powerset.mpr hGU) hGtrans
  have hlt := card_lt_card hGF
  omega

/-- The number of inclusion-minimal size-`k` blockers in a helper universe. -/
noncomputable def minimalBlockerCount
    (U : Finset ι) (H : Finset (Finset ι)) (k : ℕ) : ℕ := by
  classical
  exact ((U.powersetCard k).filter fun F => IsMinimalBlocker H F).card

/-- At the minimum size, `blockerCount` counts precisely the inclusion-minimal blockers. -/
theorem blockerCount_eq_minimalBlockerCount_at_minimum
    {U : Finset ι} {H : Finset (Finset ι)} {τ : ℕ}
    (hmin : ∀ F ∈ U.powerset, FiniteGeom.IsTransversal H F → τ ≤ F.card) :
    blockerCount U H τ = minimalBlockerCount U H τ := by
  classical
  unfold blockerCount minimalBlockerCount
  apply congrArg card
  ext F
  simp only [mem_filter, mem_powersetCard]
  constructor
  · rintro ⟨hpow, htrans⟩
    exact ⟨hpow, isMinimalBlocker_of_minimum_card hmin hpow.1 hpow.2 htrans⟩
  · rintro ⟨hpow, hminimal⟩
    exact ⟨hpow, hminimal.1⟩

/-- The homogeneous failure polynomial grouped by the number of erased helpers. -/
noncomputable def blockerFailurePolynomial
    (U : Finset ι) (H : Finset (Finset ι)) : Polynomial ℝ :=
  ∑ k ∈ range (U.card + 1),
    Polynomial.C (blockerCount U H k : ℝ) * Polynomial.X ^ k *
      (1 - Polynomial.X) ^ (U.card - k)

/-- If no blocker has size below `τ`, then every lower blocker count vanishes. -/
theorem blockerCount_eq_zero_of_lt_minimum
    {U : Finset ι} {H : Finset (Finset ι)} {τ k : ℕ}
    (hmin : ∀ F ∈ U.powerset, FiniteGeom.IsTransversal H F → τ ≤ F.card)
    (hk : k < τ) :
    blockerCount U H k = 0 := by
  classical
  unfold blockerCount
  rw [card_eq_zero]
  apply eq_empty_iff_forall_notMem.mpr
  intro F hF
  obtain ⟨hpow, htrans⟩ := mem_filter.mp hF
  obtain ⟨hFU, hcard⟩ := mem_powersetCard.mp hpow
  exact (not_le_of_gt hk) (hcard ▸ hmin F (mem_powerset.mpr hFU) htrans)

/-- If `τ` is the minimum blocker size, then the first possible nonzero coefficient of the
homogeneous failure polynomial is its number of size-`τ` blockers.  This exact polynomial statement
is the finite algebra behind the expansion
`b_τ p^τ + O(p^(τ+1))`. -/
theorem coeff_blockerFailurePolynomial_at_minimum
    {U : Finset ι} {H : Finset (Finset ι)} {τ : ℕ}
    (hτ : τ ≤ U.card)
    (hmin : ∀ F ∈ U.powerset, FiniteGeom.IsTransversal H F → τ ≤ F.card) :
    (blockerFailurePolynomial U H).coeff τ = blockerCount U H τ := by
  classical
  unfold blockerFailurePolynomial
  rw [Polynomial.finsetSum_coeff]
  calc
    (∑ k ∈ range (U.card + 1),
        (Polynomial.C (blockerCount U H k : ℝ) * Polynomial.X ^ k *
          (1 - Polynomial.X) ^ (U.card - k)).coeff τ) =
        (Polynomial.C (blockerCount U H τ : ℝ) * Polynomial.X ^ τ *
          (1 - Polynomial.X) ^ (U.card - τ)).coeff τ := by
      apply sum_eq_single τ
      · intro k hk hne
        by_cases hkt : k < τ
        · rw [blockerCount_eq_zero_of_lt_minimum hmin hkt]
          simp
        · have htk : τ < k := lt_of_le_of_ne (Nat.le_of_not_gt hkt) hne.symm
          rw [show Polynomial.C (blockerCount U H k : ℝ) * Polynomial.X ^ k *
              (1 - Polynomial.X) ^ (U.card - k) =
              Polynomial.X ^ k *
                (Polynomial.C (blockerCount U H k : ℝ) *
                  (1 - Polynomial.X) ^ (U.card - k)) by ring,
            Polynomial.coeff_X_pow_mul']
          simp [not_le_of_gt htk]
      · intro hnot
        exact False.elim (hnot (mem_range.mpr (Nat.lt_succ_of_le hτ)))
    _ = (blockerCount U H τ : ℝ) := by
      rw [show Polynomial.C (blockerCount U H τ : ℝ) * Polynomial.X ^ τ *
          (1 - Polynomial.X) ^ (U.card - τ) =
          Polynomial.X ^ τ *
            (Polynomial.C (blockerCount U H τ : ℝ) *
              (1 - Polynomial.X) ^ (U.card - τ)) by ring]
      have hcoeff := Polynomial.coeff_X_pow_mul
        (Polynomial.C (blockerCount U H τ : ℝ) *
          (1 - Polynomial.X) ^ (U.card - τ)) τ 0
      simp only [Nat.zero_add] at hcoeff
      rw [hcoeff]
      simp [Polynomial.coeff_zero_eq_eval_zero]

/-- No coefficient below the minimum blocker size can occur. -/
theorem coeff_blockerFailurePolynomial_eq_zero_below_minimum
    {U : Finset ι} {H : Finset (Finset ι)} {τ d : ℕ}
    (hmin : ∀ F ∈ U.powerset, FiniteGeom.IsTransversal H F → τ ≤ F.card)
    (hd : d < τ) :
    (blockerFailurePolynomial U H).coeff d = 0 := by
  classical
  unfold blockerFailurePolynomial
  rw [Polynomial.finsetSum_coeff]
  apply sum_eq_zero
  intro k hk
  by_cases hkd : k ≤ d
  · have hkt : k < τ := hkd.trans_lt hd
    rw [blockerCount_eq_zero_of_lt_minimum hmin hkt]
    simp
  · rw [show Polynomial.C (blockerCount U H k : ℝ) * Polynomial.X ^ k *
        (1 - Polynomial.X) ^ (U.card - k) =
        Polynomial.X ^ k *
          (Polynomial.C (blockerCount U H k : ℝ) *
            (1 - Polynomial.X) ^ (U.card - k)) by ring,
      Polynomial.coeff_X_pow_mul']
    simp [hkd]

/-- The homogeneous failure polynomial is its minimum-blocker term plus a polynomial remainder
divisible by `X^(τ+1)`.  Evaluating at a real failure probability is the exact algebraic form of
`b_τ p^τ + O(p^(τ+1))`. -/
theorem blockerFailurePolynomial_eq_minimum_term_add_remainder
    {U : Finset ι} {H : Finset (Finset ι)} {τ : ℕ}
    (hτ : τ ≤ U.card)
    (hmin : ∀ F ∈ U.powerset, FiniteGeom.IsTransversal H F → τ ≤ F.card) :
    ∃ Q : Polynomial ℝ,
      blockerFailurePolynomial U H =
        Polynomial.C (blockerCount U H τ : ℝ) * Polynomial.X ^ τ +
          Polynomial.X ^ (τ + 1) * Q := by
  have hdiv :
      Polynomial.X ^ (τ + 1) ∣
        blockerFailurePolynomial U H -
          Polynomial.C (blockerCount U H τ : ℝ) * Polynomial.X ^ τ := by
    rw [Polynomial.X_pow_dvd_iff]
    intro d hd
    rw [Polynomial.coeff_sub, Polynomial.coeff_C_mul_X_pow]
    by_cases hdt : d < τ
    · rw [coeff_blockerFailurePolynomial_eq_zero_below_minimum hmin hdt]
      simp [ne_of_lt hdt]
    · have hdeq : d = τ := by omega
      subst d
      rw [coeff_blockerFailurePolynomial_at_minimum hτ hmin]
      simp
  obtain ⟨Q, hQ⟩ := hdiv
  refine ⟨Q, ?_⟩
  calc
    blockerFailurePolynomial U H =
        (blockerFailurePolynomial U H -
          Polynomial.C (blockerCount U H τ : ℝ) * Polynomial.X ^ τ) +
            Polynomial.C (blockerCount U H τ : ℝ) * Polynomial.X ^ τ := by ring
    _ = Polynomial.C (blockerCount U H τ : ℝ) * Polynomial.X ^ τ +
          Polynomial.X ^ (τ + 1) * Q := by rw [hQ]; ring

/-- Evaluating the homogeneous failure polynomial gives its finite Bernstein sum, grouped by
blocker cardinality. -/
theorem eval_blockerFailurePolynomial
    (U : Finset ι) (H : Finset (Finset ι)) (p : ℝ) :
    (blockerFailurePolynomial U H).eval p =
      ∑ k ∈ range (U.card + 1),
        (blockerCount U H k : ℝ) * p ^ k * (1 - p) ^ (U.card - k) := by
  classical
  simp [blockerFailurePolynomial, Polynomial.eval_finsetSum]

end RepairPorts
