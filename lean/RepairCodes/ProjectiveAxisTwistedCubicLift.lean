import RepairCodes.ProjectiveAxisTwistedCubicInvariants
import RepairCodes.Q9ExtensionLift

/-!
# Extension-field lifts of the projectively completed cubic--axis seed

This module concatenates the completed `[20,4,9]_9` seed with a degree-four
extension-field outer code.  Repair transfer is deliberately bounded at radius four:
ordinary outer dual distance at least six identifies the complete lifted radius-four
hypergraph with the embedded inner hypergraph.  No claim about the lifted code's
unbounded full repair port is made.
-/

namespace RepairCodes

open Finset FiniteGeom

noncomputable section

variable {F L : Type*}
variable [Field F] [Fintype F] [DecidableEq F] [CharP F 3]
variable [Field L] [Fintype L] [DecidableEq L] [Algebra F L]
variable [FiniteDimensional F L] [Algebra.IsSeparable F L]

/-- Embed completed cubic coordinates into lifted blocks. -/
def projectiveQ9LiftCubicEmbedding (iota F : Type*) :
    (iota × ProjectiveTwistedCubicIndex F) ↪
      (iota × ProjectiveAxisTwistedCubicIndex F) where
  toFun p := (p.1, .inl p.2)
  inj' := by rintro ⟨i, x⟩ ⟨j, y⟩ h; simp only [Prod.mk.injEq, Sum.inl.injEq] at h ⊢; exact h

/-- Embed completed axis coordinates into lifted blocks. -/
def projectiveQ9LiftAxisEmbedding (iota F : Type*) :
    (iota × (F ⊕ Unit)) ↪ (iota × ProjectiveAxisTwistedCubicIndex F) where
  toFun p := (p.1, .inr p.2)
  inj' := by rintro ⟨i, x⟩ ⟨j, y⟩ h; simp only [Prod.mk.injEq, Sum.inr.injEq] at h ⊢; exact h

/-- Completed cubic coordinates across every lifted block. -/
def projectiveQ9LiftCubicCoordinates (iota F : Type*)
    [Fintype iota] [DecidableEq iota] [Fintype F] [DecidableEq F] :
    Finset (iota × ProjectiveAxisTwistedCubicIndex F) :=
  univ.map (projectiveQ9LiftCubicEmbedding iota F)

/-- Completed axis coordinates across every lifted block. -/
def projectiveQ9LiftAxisCoordinates (iota F : Type*)
    [Fintype iota] [DecidableEq iota] [Fintype F] [DecidableEq F] :
    Finset (iota × ProjectiveAxisTwistedCubicIndex F) :=
  univ.map (projectiveQ9LiftAxisEmbedding iota F)

omit [Field F] [CharP F 3] in
/-- Cubic and axis coordinates partition the completed lifted coordinate set. -/
theorem projectiveQ9Lift_coordinate_partition
    {iota : Type*} [Fintype iota] [DecidableEq iota] :
    Disjoint (projectiveQ9LiftCubicCoordinates iota F)
        (projectiveQ9LiftAxisCoordinates iota F) ∧
      projectiveQ9LiftCubicCoordinates iota F ∪
        projectiveQ9LiftAxisCoordinates iota F = univ := by
  classical
  constructor
  · simp [projectiveQ9LiftCubicCoordinates, projectiveQ9LiftAxisCoordinates,
      Finset.disjoint_left, projectiveQ9LiftCubicEmbedding,
      projectiveQ9LiftAxisEmbedding]
  · rw [eq_univ_iff_forall]
    rintro ⟨i, x | y⟩ <;>
      simp [projectiveQ9LiftCubicCoordinates, projectiveQ9LiftAxisCoordinates,
        projectiveQ9LiftCubicEmbedding, projectiveQ9LiftAxisEmbedding]

omit [Field F] [CharP F 3] in
/-- At q=9 each block has ten completed cubic and ten completed axis coordinates. -/
theorem projectiveQ9Lift_coordinate_counts
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) :
    (projectiveQ9LiftCubicCoordinates iota F).card = 10 * Fintype.card iota ∧
      (projectiveQ9LiftAxisCoordinates iota F).card = 10 * Fintype.card iota := by
  classical
  simp [projectiveQ9LiftCubicCoordinates, projectiveQ9LiftAxisCoordinates,
    Fintype.card_prod, hcard, Nat.mul_comm]

/-- Encode one degree-four extension symbol with the completed seed. -/
noncomputable def projectiveQ9ExtensionEncoder (hdeg : Module.finrank F L = 4) :
    L ≃ₗ[F] projectiveAxisTwistedCubicCode (𝔽 := F) := by
  apply LinearEquiv.ofFinrankEq
  rw [hdeg, projectiveAxisTwistedCubicCode_eq_columnCode,
    projectiveAxisTwistedCubic_finrank]

/-- Concatenation of an `L`-linear outer code with the completed q=9 seed. -/
def projectiveQ9ExtensionLiftCode {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L)) :
    Submodule F (iota × ProjectiveAxisTwistedCubicIndex F → F) :=
  concatenatedCode projectiveAxisTwistedCubicCode
    (projectiveQ9ExtensionEncoder hdeg) (O.restrictScalars F)

omit [Algebra.IsSeparable F L] in
/-- Exact length and dimension scaling, with the usual concatenated distance bound. -/
theorem projectiveQ9ExtensionLiftCode_parameters
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) (hdeg : Module.finrank F L = 4)
    (O : Submodule L (iota → L)) (hO : O ≠ ⊥) :
    Fintype.card (iota × ProjectiveAxisTwistedCubicIndex F) =
        20 * Fintype.card iota ∧
      Module.finrank F (projectiveQ9ExtensionLiftCode hdeg O) =
        4 * Module.finrank L O ∧
      9 * minDist O ≤ minDist (projectiveQ9ExtensionLiftCode hdeg O) := by
  constructor
  · simp [Fintype.card_prod, hcard, Nat.mul_comm]
  constructor
  · rw [projectiveQ9ExtensionLiftCode, concatenatedCode_finrank,
      finrank_restrictScalars_eq_mul O, hdeg]
  · have hO' : O.restrictScalars F ≠ ⊥ := by simpa using hO
    have hdist := concatenatedCode_minDist_lower projectiveAxisTwistedCubicCode
      (projectiveQ9ExtensionEncoder hdeg) (O.restrictScalars F) hO'
    have hmin : minDist (projectiveAxisTwistedCubicCode (𝔽 := F)) = 9 := by
      rw [projectiveAxisTwistedCubicCode_eq_columnCode,
        projectiveAxisTwistedCubic_minDist, hcard]
    simpa only [hmin, symbolMinDist_restrictScalars_eq_minDist,
      projectiveQ9ExtensionLiftCode] using hdist

omit [Fintype L] in
/-- Ordinary outer dual distance six transfers every repair hypergraph through radius four. -/
theorem projectiveQ9ExtensionLiftCode_repairHypergraph_of_radius_le_four
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 6 ≤ dualDist O) (r : ℕ) (hr : r ≤ 4)
    (j : iota) (z : ProjectiveAxisTwistedCubicIndex F) :
    repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) r =
      embedHypergraph (blockEmbedding j)
        (projectiveAxisTwistedCubicRepairHypergraph z r) := by
  unfold projectiveQ9ExtensionLiftCode projectiveAxisTwistedCubicRepairHypergraph
  apply repairHypergraph_concatenatedCode_eq_embed projectiveAxisTwistedCubicCode
    (projectiveQ9ExtensionEncoder hdeg) (O.restrictScalars F) r
  · rw [projectiveAxisTwistedCubicCode_dualDist]
    omega
  · exact hasFunctionalDualDistanceAtLeast_restrictScalars O (r + 2) (by omega)

omit [Fintype L] in
/-- The complete lifted radius-four hypergraph is exactly one embedded inner block. -/
theorem projectiveQ9ExtensionLiftCode_repairHypergraph_four
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 6 ≤ dualDist O) (j : iota)
    (z : ProjectiveAxisTwistedCubicIndex F) :
    repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 4 =
      embedHypergraph (blockEmbedding j)
        (projectiveAxisTwistedCubicRepairHypergraph z 4) :=
  projectiveQ9ExtensionLiftCode_repairHypergraph_of_radius_le_four
    hdeg O hdO 4 (by omega) j z

set_option maxHeartbeats 800000 in
/-- Over every finite characteristic-three field, every completed cubic coordinate has exact
locality three.  The cardinal lower bound is separated so the circuit argument stays reusable. -/
theorem projectiveAxisTwistedCubic_cubic_exact_locality_three
    (hcard : 3 ≤ Fintype.card F) (x : ProjectiveTwistedCubicIndex F) :
    HasExactLocalityAt (projectiveAxisTwistedCubicCode (𝔽 := F)) (.inl x) 3 := by
  constructor
  · change (projectiveAxisTwistedCubicRepairHypergraph (.inl x) 3).Nonempty
    cases x with
    | inl a =>
        obtain ⟨b, hba⟩ : ∃ b : F, b ≠ a := by
          by_contra h
          push Not at h
          have hu : (univ : Finset F) = {a} := by ext z; simp [h z]
          have hc : Fintype.card F = 1 := by simpa using congrArg Finset.card hu
          omega
        obtain ⟨c, hca, hcb⟩ : ∃ c : F, c ≠ a ∧ c ≠ b := by
          by_contra h
          push Not at h
          have hu : (univ : Finset F) = {a, b} := by
            ext z
            simp only [mem_univ, mem_insert, mem_singleton, true_iff]
            by_cases hza : z = a
            · exact Or.inl hza
            · exact Or.inr (h z hza)
          have hab : a ≠ b := Ne.symm hba
          have hc : Fintype.card F = 2 := by
            simpa [hab] using congrArg Finset.card hu
          omega
        let v : Fin 3 → F := ![a, b, c]
        have hv : Function.Injective v := by
          intro i j hij
          fin_cases i <;> fin_cases j <;> simp_all [v]
        exact ⟨projectiveFiniteCubicTripleRepairHelpers v,
          projectiveFiniteCubicTripleRepairHelpers_mem hv⟩
    | inr u =>
        have hu : u = Unit.unit := Subsingleton.elim _ _
        subst u
        exact ⟨{(.inl (.inl 0) : ProjectiveAxisTwistedCubicIndex F),
            .inl (.inl 1), .inr (.inl 1)},
          by simpa using projectiveCubicInfinityRepairHelpers_mem (𝔽 := F) (zero_ne_one)⟩
  · intro s hs hnonempty
    obtain ⟨R, hR⟩ := hnonempty
    have hcardR : R.card ≤ 2 := by
      exact (mem_repairHypergraph.mp hR).2.1.trans (by omega)
    have hcardI : (insert (.inl x) R).card ≤ 3 :=
      (card_insert_le (.inl x) R).trans (by omega)
    have hli :=
      projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_three_of_containsCubic
        (𝔽 := F) (S := insert (.inl x) R)
        hcardI ⟨x, Finset.mem_insert_self _ _⟩
    exact projectiveAxisTwistedCubicRepair_edge_dependent hR hli

/-- q=9 specialization used by the completed extension-field lift. -/
theorem projectiveAxisTwistedCubic_q9_cubic_exact_locality_three
    (hcard : Fintype.card F = 9) (x : ProjectiveTwistedCubicIndex F) :
    HasExactLocalityAt (projectiveAxisTwistedCubicCode (𝔽 := F)) (.inl x) 3 :=
  projectiveAxisTwistedCubic_cubic_exact_locality_three (by omega) x

/-- Over every finite characteristic-three field, every completed axis coordinate has exact
locality two. -/
theorem projectiveAxisTwistedCubic_axis_exact_locality_two (y : F ⊕ Unit) :
    HasExactLocalityAt (projectiveAxisTwistedCubicCode (𝔽 := F)) (.inr y) 2 := by
  constructor
  · cases y with
    | inl a =>
        refine ⟨{(.inr (.inr Unit.unit) : ProjectiveAxisTwistedCubicIndex F),
            .inr (.inl (a + 1))}, ?_⟩
        apply mem_projectiveAxisRepairHypergraph_two_iff.mpr
        exact ⟨.inr Unit.unit, .inl (a + 1), by simp, by simp, by simp⟩
    | inr u =>
        refine ⟨{(.inr (.inl 0) : ProjectiveAxisTwistedCubicIndex F),
            .inr (.inl 1)}, ?_⟩
        apply mem_projectiveAxisRepairHypergraph_two_iff.mpr
        exact ⟨.inl 0, .inl 1, by simp, by simp, by simp⟩
  · intro s hs hnonempty
    obtain ⟨R, hR⟩ := hnonempty
    have hcardR : R.card ≤ 1 := (mem_repairHypergraph.mp hR).2.1.trans (by omega)
    have hcardI : (insert (.inr y) R).card ≤ 2 :=
      (card_insert_le (.inr y) R).trans (by omega)
    have hli := projectiveAxisTwistedCubic_selected_linearIndependent_of_card_le_two
      (𝔽 := F) (S := insert (.inr y) R) (Finset.insert_nonempty _ _) hcardI
    exact projectiveAxisTwistedCubicRepair_edge_dependent hR hli

/-- q=9 specialization used by the completed extension-field lift. -/
theorem projectiveAxisTwistedCubic_q9_axis_exact_locality_two
    (_hcard : Fintype.card F = 9) (y : F ⊕ Unit) :
    HasExactLocalityAt (projectiveAxisTwistedCubicCode (𝔽 := F)) (.inr y) 2 :=
  projectiveAxisTwistedCubic_axis_exact_locality_two y

omit [Fintype L] in
/-- Exact mixed locality survives the radius-four lift gate. -/
theorem projectiveQ9ExtensionLiftCode_exact_locality
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) (hdeg : Module.finrank F L = 4)
    (O : Submodule L (iota → L)) (hdO : 6 ≤ dualDist O)
    (j : iota) (z : ProjectiveAxisTwistedCubicIndex F) :
    match z with
    | .inl _ => HasExactLocalityAt (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 3
    | .inr _ => HasExactLocalityAt (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 2 := by
  have hfun : HasFunctionalDualDistanceAtLeast (O.restrictScalars F) 6 :=
    hasFunctionalDualDistanceAtLeast_restrictScalars O 6 hdO
  cases z with
  | inl x =>
      exact (hasExactLocalityAt_concatenatedCode_iff_of_le
        projectiveAxisTwistedCubicCode (projectiveQ9ExtensionEncoder hdeg)
        (O.restrictScalars F) 4 3 (by omega) (by
          rw [projectiveAxisTwistedCubicCode_dualDist]; omega) hfun j (.inl x)).2
        (projectiveAxisTwistedCubic_q9_cubic_exact_locality_three hcard x)
  | inr y =>
      exact (hasExactLocalityAt_concatenatedCode_iff_of_le
        projectiveAxisTwistedCubicCode (projectiveQ9ExtensionEncoder hdeg)
        (O.restrictScalars F) 4 2 (by omega) (by
          rw [projectiveAxisTwistedCubicCode_dualDist]; omega) hfun j (.inr y)).2
        (projectiveAxisTwistedCubic_q9_axis_exact_locality_two hcard y)

omit [Fintype L] in
/-- Exact q=9 radius-four matching, transversal, and failure-threshold rows. -/
theorem projectiveQ9ExtensionLiftCode_row_invariants
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) (hdeg : Module.finrank F L = 4)
    (O : Submodule L (iota → L)) (hdO : 6 ≤ dualDist O)
    (j : iota) (z : ProjectiveAxisTwistedCubicIndex F) :
    match z with
    | .inl _ =>
        matchingNumber (repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 4) = 4 ∧
          transversalNumber (repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 4) = 8 ∧
          transversalNumber (repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 4) - 1 = 7
    | .inr _ =>
        matchingNumber (repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 4) = 7 ∧
          transversalNumber (repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 4) = 15 ∧
          transversalNumber (repairHypergraph (projectiveQ9ExtensionLiftCode hdeg O) (j, z) 4) - 1 = 14 := by
  rw [projectiveQ9ExtensionLiftCode_repairHypergraph_four hdeg O hdO j z,
    matchingNumber_embedHypergraph,
    transversalNumber_embedHypergraph (blockEmbedding j) _
      (fun E hE => projectiveAxisTwistedCubicRepair_edge_nonempty hE),
    ← matchingNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph,
    ← transversalNumber_minimalProjectiveAxisTwistedCubicRepairHypergraph]
  cases z with
  | inl x =>
      have h := minimalProjectiveCubicRepair_four_invariants (𝔽 := F) x
      simp [hcard] at h ⊢
      exact h
  | inr y =>
      have h := minimalProjectiveAxisRepair_four_invariants (𝔽 := F) y
      simp [hcard] at h ⊢
      exact h

#print axioms projectiveQ9Lift_coordinate_counts
#print axioms projectiveQ9ExtensionLiftCode_parameters
#print axioms projectiveQ9ExtensionLiftCode_repairHypergraph_of_radius_le_four
#print axioms projectiveAxisTwistedCubic_cubic_exact_locality_three
#print axioms projectiveAxisTwistedCubic_q9_cubic_exact_locality_three
#print axioms projectiveAxisTwistedCubic_axis_exact_locality_two
#print axioms projectiveAxisTwistedCubic_q9_axis_exact_locality_two
#print axioms projectiveQ9ExtensionLiftCode_exact_locality
#print axioms projectiveQ9ExtensionLiftCode_row_invariants

end
end RepairCodes
