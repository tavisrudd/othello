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
/-- Ordinary extension-field dual distance five is sufficient for exact radius-three transfer. -/
theorem q9ExtensionLiftCode_repairHypergraph
    {iota : Type*} [Fintype iota] [DecidableEq iota]
    (hdeg : Module.finrank F L = 4) (O : Submodule L (iota → L))
    (hdO : 5 ≤ dualDist O) (j : iota) (z : AxisTwistedCubicIndex F) :
    repairHypergraph (q9ExtensionLiftCode hdeg O) (j, z) 3 =
      embedHypergraph (blockEmbedding j) (axisTwistedCubicRepairHypergraph z 3) := by
  unfold q9ExtensionLiftCode axisTwistedCubicRepairHypergraph
  apply repairHypergraph_concatenatedCode_eq_embed axisTwistedCubicCode
    (q9ExtensionEncoder hdeg) (O.restrictScalars F) 3
  · rw [axisTwistedCubicCode_dualDist]
    omega
  · exact hasFunctionalDualDistanceAtLeast_restrictScalars O 5 hdO

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

#print axioms finrank_restrictScalars_eq_mul
#print axioms q9ExtensionLiftCode_parameters
#print axioms q9ExtensionLiftCode_repairHypergraph
#print axioms q9ExtensionLiftCode_allSymbol_locality_three
#print axioms q9ExtensionLiftCode_row_invariants

end
end RepairCodes
