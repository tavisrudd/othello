import RelativeConicArcs.Q11SemanticLeaders
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# The certified `q = 11` code and extension spectrum

This downstream module extracts the syndrome-index, quadratic-rank, chord-matching, and exact
simultaneous-extension data of the six-point witness.  All finite statements reduce in Lean's
kernel; the external Python/C++ programs are independent provenance only.
-/

namespace RelativeConicArcs.Examples.Q11Coding

open Certificate Q11Residual ConflictGraph Matrix

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype (Conic.Point (ZMod 11)) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point (ZMod 11)) := Classical.decEq _

/-- The six columns span the three-dimensional syndrome space. -/
theorem witness_columns_span :
    Submodule.span (ZMod 11) (Set.range witnessVec) = ⊤ := by
  let B : Fin 3 → Vec (ZMod 11) := fun i => witnessVec ⟨i.1, by omega⟩
  have hB : LinearIndependent (ZMod 11) B := by
    have hdet := witness_distinct_triples_det (0 : Fin 6) 1 2 (by decide) (by decide) (by decide)
    have hli := Matrix.linearIndependent_rows_of_det_ne_zero hdet
    have heq : ![witnessVec (0 : Fin 6), witnessVec 1, witnessVec 2] = B := by
      ext i
      fin_cases i <;> rfl
    rw [heq] at hli
    simpa [Matrix.row] using hli
  let U := Submodule.span (ZMod 11) (Set.range B)
  have hUrank : Module.finrank (ZMod 11) U = 3 := by
    have h := finrank_span_eq_card hB
    simpa [U] using h
  have hUS : U ≤ Submodule.span (ZMod 11) (Set.range witnessVec) := by
    apply Submodule.span_mono
    rintro x ⟨i, rfl⟩
    exact ⟨⟨i.1, by omega⟩, rfl⟩
  apply Submodule.eq_top_of_finrank_eq
  have hle := Submodule.finrank_mono hUS
  have htop : Module.finrank (ZMod 11) (Fin 3 → ZMod 11) = 3 := by simp
  have hSrank : Module.finrank (ZMod 11)
      (Submodule.span (ZMod 11) (Set.range witnessVec)) = 3 := by
    apply le_antisymm
    · simpa [htop] using
        (Submodule.finrank_le (Submodule.span (ZMod 11) (Set.range witnessVec)))
    · omega
  exact hSrank.trans htop.symm

/-- The witness parity-check columns certify a `[6,3,4]₁₁` MDS code. -/
theorem witness_mds_columns :
    CodingBridge.CodimThreeMDSColumns (K := ZMod 11) witnessVec := by
  refine ⟨by simp, witness_columns_span, witness_small_independent⟩

theorem witness_code_finrank :
    Module.finrank (ZMod 11) (CodingBridge.parityCheckCode (K := ZMod 11) witnessVec) = 3 := by
  simpa using witness_mds_columns.code_finrank

theorem witness_code_minimum_distance_four :
    (∀ c : Fin 6 → ZMod 11,
      c ∈ CodingBridge.parityCheckCode (K := ZMod 11) witnessVec → c ≠ 0 →
        4 ≤ CodingBridge.hammingWeight c) ∧
      (∃ c : Fin 6 → ZMod 11,
        c ∈ CodingBridge.parityCheckCode (K := ZMod 11) witnessVec ∧ c ≠ 0 ∧
          CodingBridge.hammingWeight c = 4) := by
  exact ⟨fun _ hc hc0 => witness_mds_columns.minimumDistance_ge_four hc hc0,
    witness_mds_columns.exists_minimumWeight_word (by simp)⟩

/-- The projective distance-three syndrome locus of the six-column code is exactly the standard
twelve-point conic, not merely a subset of it. -/
theorem projective_distanceThreeDirections_eq_standardConic :
    distanceThreeDirections (L := Conic.Point (ZMod 11)) (pointSet q11Witness) =
      Conic.standardConic (K := ZMod 11) := by
  classical
  let A := pointSet q11Witness
  let C := Conic.standardConic (K := ZMod 11)
  have hcomplete : CompleteOutside (L := Conic.Point (ZMod 11)) A C := by
    simpa [A, C] using check_sound q11_check
  have hsub : distanceThreeDirections (L := Conic.Point (ZMod 11)) A ⊆ C :=
    (completeOutside_iff_distanceThreeDirections_subset.mp hcomplete).2.2
  apply Finset.Subset.antisymm hsub
  intro x hxC
  obtain ⟨i, hi⟩ := (conicEmbedding_range x).mp (by simpa [C] using hxC)
  have hvalid : ProjectiveBridge.ParametrizedHoleValid
      (K := ZMod 11) A conicEmbedding ({i} : Finset (Fin 12)) := by
    rw [parametrizedHoleValid_iff]
    simp [IndepValid]
  have hcap : ProjectiveCap.Projective.Cap (ZMod 11) (Fin 3 → ZMod 11)
      (insert (conicEmbedding i) A) := by
    simpa [ProjectiveBridge.ParametrizedHoleValid, Finset.union_comm] using hvalid
  have hnotA : conicEmbedding i ∉ A := by
    intro hxA
    exact (Finset.disjoint_left.mp hcomplete.2.1) hxA (by simpa [C, hi] using hxC)
  have harc : Arc (L := Conic.Point (ZMod 11)) (insert (conicEmbedding i) A) :=
    (ProjectiveBridge.arc_iff_projectiveCap _).mpr hcap
  have hnotCovered : ¬Covered (L := Conic.Point (ZMod 11)) A (conicEmbedding i) :=
    (arc_insert_iff_not_covered hcomplete.1 hnotA).mp harc
  rw [← hi]
  exact mem_distanceThreeDirections.mpr ⟨hnotA, hnotCovered⟩

/-- A fixed conic syndrome avoids every affine span of two witness columns. -/
theorem conicZero_pair_avoidance :
    ∀ i j : Fin 6, ∀ a b : ZMod 11,
      a • witnessVec i + b • witnessVec j ≠ conicVec 0 := by
  decide

/-- The displayed conic vector has affine syndrome distance three. -/
theorem conicZero_syndromeDistanceAtLeast_three :
    CodingBridge.SyndromeDistanceAtLeast (K := ZMod 11) witnessVec (conicVec 0) 3 :=
  CodingBridge.syndromeDistanceAtLeast_three_of_pair_avoidance witnessVec (by simp)
    conicZero_pair_avoidance

/-- The transparent parity-check code has covering radius exactly three. -/
theorem witness_code_coveringRadius_three :
    CodingBridge.HasCoveringRadiusThree (K := ZMod 11) witnessVec := by
  refine ⟨CodingBridge.every_syndrome_has_weight_le_three witnessVec (by simp) (by simp)
    witness_small_independent, ?_⟩
  exact ⟨conicVec 0, conicZero_syndromeDistanceAtLeast_three⟩

/-- Each affine syndrome on the conic-zero direction has exactly `choose(6,3)=20`
minimum weight-three leaders. -/
theorem conicZero_weightThree_leader_count :
    (CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec (conicVec 0) 3).card = 20 := by
  have h := CodingBridge.card_syndromeLeadersOfWeight_three witnessVec (by simp)
    witness_small_independent conicZero_syndromeDistanceAtLeast_three
  rw [h]
  decide

/-- Quadratic monomials `[X²,XY,XZ,Y²,YZ,Z²]`. -/
def quadraticFeatures (v : Vec (ZMod 11)) : Fin 6 → ZMod 11 :=
  ![v 0 * v 0, v 0 * v 1, v 0 * v 2, v 1 * v 1, v 1 * v 2, v 2 * v 2]

/-- Evaluation of all six quadratic monomials on the six witness columns. -/
def quadraticEvaluationMatrix : Matrix (Fin 6) (Fin 6) (ZMod 11) :=
  fun i j => quadraticFeatures (witnessVec i) j

/-- The quadratic evaluation matrix has full rank. -/
theorem quadraticEvaluation_det_ne_zero : quadraticEvaluationMatrix.det ≠ 0 := by
  decide

/-- No nonzero homogeneous quadratic form vanishes on all six witness columns.  This is the
formal no-conic premise used with the classical normal-rational-curve/GRS dictionary. -/
theorem no_nonzero_quadratic_vanishing (c : Fin 6 → ZMod 11)
    (h : quadraticEvaluationMatrix *ᵥ c = 0) : c = 0 := by
  have hunit : IsUnit quadraticEvaluationMatrix.det :=
    (isUnit_iff_ne_zero.mpr quadraticEvaluation_det_ne_zero)
  have hmatrix : IsUnit quadraticEvaluationMatrix :=
    quadraticEvaluationMatrix.isUnit_iff_isUnit_det.mpr hunit
  exact (Matrix.mulVec_injective_iff_isUnit.mpr hmatrix) (by simpa using h)

/-- Independent residual sets of fixed cardinality. -/
def independentSetsOfCard (n : ℕ) : Finset (Finset (Fin 12)) :=
  (Finset.univ.powersetCard n).filter (IndepValid Adj)

/-- Maximal residual independent sets of fixed cardinality. -/
def maximalIndependentSetsOfCard (n : ℕ) : Finset (Finset (Fin 12)) :=
  (independentSetsOfCard n).filter fun S =>
    ∀ i ∈ (Finset.univ \ S), ¬IndepValid Adj (insert i S)

/-- The exact independence polynomial of the icosahedral extension graph. -/
theorem extension_independence_spectrum :
    (independentSetsOfCard 0).card = 1 ∧
    (independentSetsOfCard 1).card = 12 ∧
    (independentSetsOfCard 2).card = 36 ∧
    (independentSetsOfCard 3).card = 20 ∧
    (independentSetsOfCard 4).card = 0 := by
  decide

/-- No zero- or one-column extension is maximal, while exactly six two-column and twenty
three-column extensions are maximal; hence the fixed seed has six complete eight-arcs and twenty
complete nine-arcs, with no ten-arc superextension. -/
theorem maximal_extension_spectrum :
    (maximalIndependentSetsOfCard 0).card = 0 ∧
    (maximalIndependentSetsOfCard 1).card = 0 ∧
    (maximalIndependentSetsOfCard 2).card = 6 ∧
    (maximalIndependentSetsOfCard 3).card = 20 := by
  decide

/-- Every residual set counted as maximal yields an ordinary complete projective arc, not merely
a set maximal inside a preselected residual subset.  Relative completeness confines every new
point to the conic, and the certified residual maximality then excludes those points as well. -/
theorem maximal_independent_extension_complete {n : ℕ} {S : Finset (Fin 12)}
    (hS : S ∈ maximalIndependentSetsOfCard n) :
    CompleteOutside (L := Conic.Point (ZMod 11))
      (pointSet q11Witness ∪ S.map conicEmbedding) ∅ := by
  classical
  let A := pointSet q11Witness
  let E := Conic.standardConic (K := ZMod 11)
  let T := S.map conicEmbedding
  have hseed : CompleteOutside (L := Conic.Point (ZMod 11)) A E := by
    simpa [A, E] using check_sound q11_check
  have hSind : IndepValid Adj S := by
    have hmem := (Finset.mem_filter.mp hS).1
    exact (Finset.mem_filter.mp hmem).2
  have hSmax : ∀ i ∈ (Finset.univ \ S), ¬IndepValid Adj (insert i S) :=
    (Finset.mem_filter.mp hS).2
  have hfull : ∀ x, x ∈ E ↔ x ∉ A ∧ Arc (L := Conic.Point (ZMod 11)) (insert x A) := by
    intro x
    change x ∈ Conic.standardConic (K := ZMod 11) ↔
      x ∉ pointSet q11Witness ∧
        Arc (L := Conic.Point (ZMod 11)) (insert x (pointSet q11Witness))
    rw [← projective_distanceThreeDirections_eq_standardConic]
    constructor
    · intro hx
      obtain ⟨hxA, hxCovered⟩ := mem_distanceThreeDirections.mp hx
      exact ⟨hxA, (arc_insert_iff_not_covered hseed.1 hxA).mpr hxCovered⟩
    · rintro ⟨hxA, hxArc⟩
      exact mem_distanceThreeDirections.mpr
        ⟨hxA, (arc_insert_iff_not_covered hseed.1 hxA).mp hxArc⟩
  have hmax : MaximalExtensionIn (L := Conic.Point (ZMod 11)) A E T := by
    refine ⟨?_, ?_, ?_⟩
    · intro x hx
      obtain ⟨i, _hi, rfl⟩ := Finset.mem_map.mp hx
      exact conicPoint_mem_standardConic i
    · apply (ProjectiveBridge.arc_iff_projectiveCap _).mpr
      exact (parametrizedHoleValid_iff S).mpr hSind
    · intro x hxE hxT hxArc
      obtain ⟨i, hi⟩ := conicEmbedding_range x |>.mp (by simpa [E] using hxE)
      have hiS : i ∉ S := by
        intro hiS
        apply hxT
        exact Finset.mem_map.mpr ⟨i, hiS, hi⟩
      have hbad := hSmax i (by simp [hiS])
      apply hbad
      apply (parametrizedHoleValid_iff (insert i S)).mp
      apply (ProjectiveBridge.arc_iff_projectiveCap _).mp
      simpa [A, T, hi, Finset.map_insert] using hxArc
  simpa [A, E, T] using
    completeOutside_empty_of_maximalExtensionIn_full (L := Conic.Point (ZMod 11)) hfull hmax

/-- Chords contributed by one witness column, oriented by the parameter order. -/
def witnessChordEdges (a : Fin 6) : Finset (Fin 12 × Fin 12) :=
  Finset.univ.filter fun e =>
    e.1 < e.2 ∧ Matrix.det ![conicVec e.1, conicVec e.2, witnessVec a] = 0

/-- The determinant-defined residual edges in the same orientation. -/
def residualEdges : Finset (Fin 12 × Fin 12) :=
  Finset.univ.filter fun e => e.1 < e.2 ∧ Adj e.1 e.2

/-- Each witness column contributes a five-edge near-perfect chord matching. -/
theorem witness_chords_nearPerfect (a : Fin 6) :
    (witnessChordEdges a).card = 5 ∧
      ∀ e ∈ witnessChordEdges a, ∀ f ∈ witnessChordEdges a,
        e ≠ f → e.1 ≠ f.1 ∧ e.1 ≠ f.2 ∧ e.2 ≠ f.1 ∧ e.2 ≠ f.2 := by
  fin_cases a <;> decide

/-- The two vertices missed by each witness-coloured matching form an antipodal pair. -/
theorem witness_chords_miss_antipodes (a : Fin 6) :
    ∃ i : Fin 12,
      (Finset.univ.filter fun x =>
        ∀ e ∈ witnessChordEdges a, x ≠ e.1 ∧ x ≠ e.2) = {i, antipode i} := by
  fin_cases a <;> decide

/-- The six witness-coloured chord matchings are disjoint and partition all 30 residual edges. -/
theorem witness_chords_partition :
    (Finset.univ.biUnion witnessChordEdges) = residualEdges ∧
      ((Finset.univ : Finset (Fin 6)) : Set (Fin 6)).PairwiseDisjoint witnessChordEdges := by
  constructor
  · decide
  · intro a _ b _ hab
    change Disjoint (witnessChordEdges a) (witnessChordEdges b)
    fin_cases a <;> fin_cases b <;> simp_all <;> decide

/-- The antipodal edge missed by the witness-coloured near-perfect matching. -/
def witnessMissingEdge : Fin 6 → Fin 12 × Fin 12 :=
  ![(0, 9), (3, 4), (1, 7), (6, 10), (2, 11), (5, 8)]

/-- Adjoin the unique missing antipodal edge to a witness-coloured matching. -/
def completedWitnessChordEdges (a : Fin 6) : Finset (Fin 12 × Fin 12) :=
  insert (witnessMissingEdge a) (witnessChordEdges a)

/-- The six augmented colour classes are genuinely six distinct perfect matchings and form a
one-factorization of the icosahedral conflict graph augmented by its six antipodal edges. -/
theorem completed_witness_matchings_oneFactorization :
    (∀ a : Fin 6,
      (completedWitnessChordEdges a).card = 6 ∧
        ∀ x : Fin 12,
          ((completedWitnessChordEdges a).filter fun e => x = e.1 ∨ x = e.2).card = 1) ∧
    (Finset.univ.image witnessMissingEdge).card = 6 ∧
    (Finset.univ.biUnion completedWitnessChordEdges) =
      residualEdges ∪ Finset.univ.image witnessMissingEdge ∧
    ((Finset.univ : Finset (Fin 6)) : Set (Fin 6)).PairwiseDisjoint
      completedWitnessChordEdges := by
  refine ⟨?_, by decide, by decide, ?_⟩
  · intro a
    fin_cases a <;> decide
  · intro a _ b _ hab
    change Disjoint (completedWitnessChordEdges a) (completedWitnessChordEdges b)
    fin_cases a <;> fin_cases b <;> simp_all <;> decide

end RelativeConicArcs.Examples.Q11Coding
