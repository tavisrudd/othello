import RepairCodes.Q9SeedLift
import RepairCodes.TraceDual

/-!
# The q=9 lift from an extension-field-linear outer code

This module removes the paper-facing mismatch between a conventional outer code over a
degree-four extension `L/F` and the coordinate-free base-field outer hypothesis used by
`Q9SeedLift`.  Restriction of scalars gives four base-field message coordinates per outer
symbol; `TraceDual` proves that ordinary `L`-dual distance supplies the exact functional-dual
gate needed for radius-three repair transfer.
-/

namespace RepairCodes

open Finset FiniteGeom

noncomputable section

variable {F L : Type*}
variable [Field F] [Fintype F] [DecidableEq F] [CharP F 3]
variable [Field L] [Fintype L] [DecidableEq L] [Algebra F L]
variable [FiniteDimensional F L] [Algebra.IsSeparable F L]

/-- Embedding of the cubic-coordinate type into one lifted coordinate block. -/
def q9LiftCubicEmbedding (iota F : Type*) :
    (iota × F) ↪ (iota × AxisTwistedCubicIndex F) where
  toFun p := (p.1, .inl p.2)
  inj' := by
    rintro ⟨a, x⟩ ⟨b, y⟩ h
    simp only [Prod.mk.injEq, Sum.inl.injEq] at h ⊢
    exact h

/-- Embedding of the finite-axis-coordinate type into one lifted coordinate block. -/
def q9LiftFiniteAxisEmbedding (iota F : Type*) :
    (iota × F) ↪ (iota × AxisTwistedCubicIndex F) where
  toFun p := (p.1, .inr (.inl p.2))
  inj' := by
    rintro ⟨a, x⟩ ⟨b, y⟩ h
    simp only [Prod.mk.injEq, Sum.inr.injEq, Sum.inl.injEq] at h ⊢
    exact h

/-- Embedding of the unique infinity-axis coordinate in every lifted block. -/
def q9LiftInfinityAxisEmbedding (iota F : Type*) :
    iota ↪ (iota × AxisTwistedCubicIndex F) where
  toFun j := (j, .inr (.inr Unit.unit))
  inj' := fun _ _ h ↦ congrArg Prod.fst h

/-- The cubic coordinates across all lifted blocks. -/
def q9LiftCubicCoordinates (iota F : Type*)
    [Fintype iota] [DecidableEq iota] [Fintype F] [DecidableEq F] :
    Finset (iota × AxisTwistedCubicIndex F) :=
  Finset.univ.map (q9LiftCubicEmbedding iota F)

/-- The finite-axis coordinates across all lifted blocks. -/
def q9LiftFiniteAxisCoordinates (iota F : Type*)
    [Fintype iota] [DecidableEq iota] [Fintype F] [DecidableEq F] :
    Finset (iota × AxisTwistedCubicIndex F) :=
  Finset.univ.map (q9LiftFiniteAxisEmbedding iota F)

/-- The infinity-axis coordinates across all lifted blocks. -/
def q9LiftInfinityAxisCoordinates (iota F : Type*)
    [Fintype iota] [DecidableEq iota] [Fintype F] [DecidableEq F] :
    Finset (iota × AxisTwistedCubicIndex F) :=
  Finset.univ.map (q9LiftInfinityAxisEmbedding iota F)

omit [Field F] [CharP F 3] in
/-- The three lifted coordinate types are pairwise disjoint and exhaust every coordinate. -/
theorem q9Lift_coordinate_type_partition
    {iota : Type*} [Fintype iota] [DecidableEq iota] :
    Disjoint (q9LiftCubicCoordinates iota F) (q9LiftFiniteAxisCoordinates iota F) ∧
      Disjoint (q9LiftCubicCoordinates iota F) (q9LiftInfinityAxisCoordinates iota F) ∧
      Disjoint (q9LiftFiniteAxisCoordinates iota F) (q9LiftInfinityAxisCoordinates iota F) ∧
      q9LiftCubicCoordinates iota F ∪ q9LiftFiniteAxisCoordinates iota F ∪
          q9LiftInfinityAxisCoordinates iota F = Finset.univ := by
  classical
  simp only [Finset.disjoint_left, Finset.mem_map, Finset.mem_univ, true_and,
    q9LiftCubicCoordinates, q9LiftFiniteAxisCoordinates, q9LiftInfinityAxisCoordinates]
  refine ⟨?_, ?_, ?_, ?_⟩
  · rintro ⟨j, z⟩ ⟨⟨j₁, x⟩, -, rfl⟩ ⟨⟨j₂, y⟩, -, h⟩
  · rintro ⟨j, z⟩ ⟨⟨j₁, x⟩, -, rfl⟩ ⟨j₂, -, h⟩
  · rintro ⟨j, z⟩ ⟨⟨j₁, x⟩, -, rfl⟩ ⟨j₂, -, h⟩
  · ext ⟨j, z⟩
    cases z with
    | inl x => simp [q9LiftCubicEmbedding]
    | inr y =>
        cases y with
        | inl a => simp [q9LiftFiniteAxisEmbedding]
        | inr u => cases u; simp [q9LiftInfinityAxisEmbedding]

omit [Field F] [CharP F 3] in
/-- Exact coordinate-type multiplicities in an `N`-block q=9 lift: `9N`, `9N`, and `N`. -/
theorem q9Lift_coordinate_type_counts
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) :
    (q9LiftCubicCoordinates iota F).card = 9 * Fintype.card iota ∧
      (q9LiftFiniteAxisCoordinates iota F).card = 9 * Fintype.card iota ∧
      (q9LiftInfinityAxisCoordinates iota F).card = Fintype.card iota := by
  simp [q9LiftCubicCoordinates, q9LiftFiniteAxisCoordinates,
    q9LiftInfinityAxisCoordinates, Fintype.card_prod, hcard, Nat.mul_comm]

/-- Encode one degree-four extension symbol by the axis–twisted-cubic inner code. -/
noncomputable def q9ExtensionEncoder (hdeg : Module.finrank F L = 4) :
    L ≃ₗ[F] axisTwistedCubicCode (𝔽 := F) := by
  apply LinearEquiv.ofFinrankEq
  rw [hdeg, axisTwistedCubicCode_eq_columnCode, axisTwistedCubic_finrank]

/-- Concatenate an `L`-linear outer code with the q=9 uniform seed after restriction to `F`. -/
def q9ExtensionLiftCode {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L)) :
    Submodule F (iota × AxisTwistedCubicIndex F → F) :=
  concatenatedCode axisTwistedCubicCode (q9ExtensionEncoder hdeg) (O.restrictScalars F)

omit [Fintype F] [DecidableEq F] [CharP F 3] [DecidableEq L]
  [Algebra.IsSeparable F L] in
/-- Restriction of scalars multiplies the outer dimension by the extension degree. -/
theorem finrank_restrictScalars_eq_mul
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (O : Submodule L (iota → L)) :
    Module.finrank F (O.restrictScalars F) =
      Module.finrank F L * Module.finrank L O := by
  rw [← Module.finrank_mul_finrank F L (O.restrictScalars F)]
  congr 1

omit [Fintype L] in
/-- Extension-field and arbitrary-symbol minimum distance are definitionally the same
support minimum when the symbol space itself is the field. -/
theorem symbolMinDist_eq_minDist
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (O : Submodule L (iota → L)) : symbolMinDist O = minDist O := rfl

omit [Fintype F] [DecidableEq F] [CharP F 3] [Fintype L]
  [FiniteDimensional F L] [Algebra.IsSeparable F L] in
/-- Restriction of scalars changes only the scalar action, not codewords or supports. -/
theorem symbolMinDist_restrictScalars_eq_minDist
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (O : Submodule L (iota → L)) :
    symbolMinDist (O.restrictScalars F) = minDist O := rfl

omit [Algebra.IsSeparable F L] in
/-- Exact length, dimension scaling, and the concatenated distance bound. -/
theorem q9ExtensionLiftCode_parameters
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) (hdeg : Module.finrank F L = 4)
    (O : Submodule L (iota → L)) (hO : O ≠ ⊥) :
    Fintype.card (iota × AxisTwistedCubicIndex F) = 19 * Fintype.card iota ∧
      Module.finrank F (q9ExtensionLiftCode hdeg O) = 4 * Module.finrank L O ∧
      8 * minDist O ≤ minDist (q9ExtensionLiftCode hdeg O) := by
  refine ⟨q9UniformLiftCode_length hcard, ?_, ?_⟩
  · rw [q9ExtensionLiftCode, concatenatedCode_finrank,
      finrank_restrictScalars_eq_mul O, hdeg]
  · have hO' : O.restrictScalars F ≠ ⊥ := by simpa using hO
    have hdist := concatenatedCode_minDist_lower axisTwistedCubicCode
      (q9ExtensionEncoder hdeg) (O.restrictScalars F) hO'
    have hmin : minDist (axisTwistedCubicCode (𝔽 := F)) = 8 := by
      rw [axisTwistedCubicCode_eq_columnCode, axisTwistedCubic_minDist, hcard]
    simpa only [hmin, symbolMinDist_restrictScalars_eq_minDist,
      q9ExtensionLiftCode] using hdist

omit [Fintype L] in
/-- Ordinary extension-field dual distance five transfers every repair hypergraph through
radius three, including the smaller radii needed to certify exact mixed locality. -/
theorem q9ExtensionLiftCode_repairHypergraph_of_radius_le_three
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 5 ≤ dualDist O) (r : ℕ) (hr : r ≤ 3)
    (j : iota) (z : AxisTwistedCubicIndex F) :
    repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) r =
      embedHypergraph (blockEmbedding j) (axisTwistedCubicRepairHypergraph z r) := by
  unfold q9ExtensionLiftCode axisTwistedCubicRepairHypergraph
  apply repairHypergraph_concatenatedCode_eq_embed axisTwistedCubicCode
    (q9ExtensionEncoder hdeg) (O.restrictScalars F) r
  · rw [axisTwistedCubicCode_dualDist]
    omega
  · exact hasFunctionalDualDistanceAtLeast_restrictScalars O (r + 2) (by omega)

omit [Fintype L] in
/-- Ordinary extension-field dual distance five is sufficient for exact radius-three transfer. -/
theorem q9ExtensionLiftCode_repairHypergraph
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 5 ≤ dualDist O) (j : iota) (z : AxisTwistedCubicIndex F) :
    repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3 =
      embedHypergraph (blockEmbedding j) (axisTwistedCubicRepairHypergraph z 3) :=
  q9ExtensionLiftCode_repairHypergraph_of_radius_le_three hdeg O hdO 3 (by omega) j z

omit [Fintype L] in
/-- Every coordinate of the extension-field lift has a repair set of size at most three. -/
theorem q9ExtensionLiftCode_allSymbol_locality_three
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 5 ≤ dualDist O) (j : iota) (z : AxisTwistedCubicIndex F) :
    ∃ R, R ∈ repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3 := by
  obtain ⟨R, hR⟩ := axisTwistedCubic_allSymbol_locality_three z
  refine ⟨R.map (blockEmbedding j), ?_⟩
  rw [q9ExtensionLiftCode_repairHypergraph hdeg O hdO j z]
  exact Finset.mem_image.mpr ⟨R, hR, rfl⟩

omit [Fintype L] in
/-- Cubic coordinates retain exact locality three after the extension-field lift. -/
theorem q9ExtensionLiftCode_cubic_exact_locality_three
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 5 ≤ dualDist O) (j : iota) (x : F) :
    (∃ R, R ∈ repairHypergraph (q9ExtensionLiftCode hdeg O) (j, .inl x) 3) ∧
      (∀ R, R ∉ repairHypergraph (q9ExtensionLiftCode hdeg O) (j, .inl x) 2) := by
  constructor
  · exact q9ExtensionLiftCode_allSymbol_locality_three hdeg O hdO j (.inl x)
  · intro R hR
    rw [q9ExtensionLiftCode_repairHypergraph_of_radius_le_three
      hdeg O hdO 2 (by omega) j (.inl x)] at hR
    obtain ⟨S, hS, -⟩ := Finset.mem_image.mp hR
    exact (cubicCoordinate_exact_locality_three x).2 S hS

omit [Fintype L] in
/-- Axis coordinates retain exact locality two after the extension-field lift. -/
theorem q9ExtensionLiftCode_axis_exact_locality_two
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 5 ≤ dualDist O) (j : iota) (y : F ⊕ Unit) :
    (∃ R, R ∈ repairHypergraph (q9ExtensionLiftCode hdeg O) (j, .inr y) 2) ∧
      (∀ R, R ∉ repairHypergraph (q9ExtensionLiftCode hdeg O) (j, .inr y) 1) := by
  constructor
  · obtain ⟨R, hR⟩ := (axisCoordinate_exact_locality_two y).1
    refine ⟨R.map (blockEmbedding j), ?_⟩
    rw [q9ExtensionLiftCode_repairHypergraph_of_radius_le_three
      hdeg O hdO 2 (by omega) j (.inr y)]
    exact Finset.mem_image.mpr ⟨R, hR, rfl⟩
  · intro R hR
    rw [q9ExtensionLiftCode_repairHypergraph_of_radius_le_three
      hdeg O hdO 1 (by omega) j (.inr y)] at hR
    obtain ⟨S, hS, -⟩ := Finset.mem_image.mp hR
    exact (axisCoordinate_exact_locality_two y).2 S hS

omit [Fintype L] in
/-- Every coordinate retains the exact q=9 row of matching/transversal invariants. -/
theorem q9ExtensionLiftCode_row_invariants
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) (hdeg : Module.finrank F L = 4)
    (O : Submodule L (iota → L)) (hdO : 5 ≤ dualDist O)
    (j : iota) (z : AxisTwistedCubicIndex F) :
    match z with
    | .inl _ =>
        matchingNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) = 4 ∧
          transversalNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) = 7
    | .inr (Sum.inr _) =>
        matchingNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) = 7 ∧
          transversalNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) = 13
    | .inr (Sum.inl _) =>
        matchingNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) = 6 ∧
          transversalNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) = 12 := by
  rw [q9ExtensionLiftCode_repairHypergraph hdeg O hdO j z,
    matchingNumber_embedHypergraph,
    transversalNumber_embedHypergraph (blockEmbedding j) _
      (fun E hE ↦ axisTwistedCubicRepair_edge_nonempty hE)]
  cases z with
  | inl x => exact axisTwistedCubic_q9_row_invariants hcard (.inl x)
  | inr y =>
      cases y with
      | inl a => exact axisTwistedCubic_q9_row_invariants hcard (.inr (.inl a))
      | inr u => cases u; exact axisTwistedCubic_q9_row_invariants hcard (.inr (.inr Unit.unit))

omit [Fintype L] in
/-- Exact guaranteed helper-failure thresholds `tau-1` for all three lifted coordinate types. -/
theorem q9ExtensionLiftCode_failure_thresholds
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hcard : Fintype.card F = 9) (hdeg : Module.finrank F L = 4)
    (O : Submodule L (iota → L)) (hdO : 5 ≤ dualDist O)
    (j : iota) (z : AxisTwistedCubicIndex F) :
    match z with
    | .inl _ =>
        transversalNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) - 1 = 6
    | .inr (Sum.inr _) =>
        transversalNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) - 1 = 12
    | .inr (Sum.inl _) =>
        transversalNumber (repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3) - 1 = 11 := by
  have h := q9ExtensionLiftCode_row_invariants hcard hdeg O hdO j z
  split at h <;> omega

#print axioms q9Lift_coordinate_type_partition
#print axioms q9Lift_coordinate_type_counts
#print axioms finrank_restrictScalars_eq_mul
#print axioms q9ExtensionLiftCode_parameters
#print axioms q9ExtensionLiftCode_repairHypergraph_of_radius_le_three
#print axioms q9ExtensionLiftCode_repairHypergraph
#print axioms q9ExtensionLiftCode_allSymbol_locality_three
#print axioms q9ExtensionLiftCode_cubic_exact_locality_three
#print axioms q9ExtensionLiftCode_axis_exact_locality_two
#print axioms q9ExtensionLiftCode_row_invariants
#print axioms q9ExtensionLiftCode_failure_thresholds

end
end RepairCodes
