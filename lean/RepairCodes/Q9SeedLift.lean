import RepairCodes.SeedLift
import RepairCodes.Q9Uniform

/-!
# The full q=9 uniform seed-and-lift theorem

This is the finite, formal core of the paper's asymptotic statement.  An outer family is supplied
as an explicit sequence of hypotheses; this module proves the claimed `[19N,4K,≥8D]₉` scaling
and exact transfer of all three repair-invariant rows at each block length.
-/

namespace RepairCodes

open Finset FiniteGeom

noncomputable section

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F] [CharP F 3]

/-- An abstract message-space encoder for the four-dimensional uniform seed.  Its existence is
not an assumption: both spaces have finite dimension four. -/
noncomputable def axisTwistedCubicEncoder :
    (Fin 4 → F) ≃ₗ[F] axisTwistedCubicCode (𝔽 := F) := by
  apply LinearEquiv.ofFinrankEq
  rw [axisTwistedCubicCode_eq_columnCode, axisTwistedCubic_finrank]
  simp

/-- Ordinary concatenation using the full axis–twisted-cubic seed. -/
def q9UniformLiftCode {ι : Type*} [Fintype ι]
    (O : Submodule F (ι → (Fin 4 → F))) :
    Submodule F (ι × AxisTwistedCubicIndex F → F) :=
  concatenatedCode axisTwistedCubicCode axisTwistedCubicEncoder O

omit [Field F] [DecidableEq F] [CharP F 3] in
/-- The lifted coordinate set has the paper's length `19N`. -/
theorem q9UniformLiftCode_length {ι : Type*} [Fintype ι]
    (hcard : Fintype.card F = 9) :
    Fintype.card (ι × AxisTwistedCubicIndex F) = 19 * Fintype.card ι := by
  rw [Fintype.card_prod, card_axisTwistedCubicIndex, hcard]
  omega

set_option maxHeartbeats 1000000 in
omit [CharP F 3] in
/-- The lift preserves the outer code's base-field dimension.  For an
`F_{9^4}`-linear `[N,K]` outer code this is the claimed dimension `4K` over `F_9`. -/
theorem q9UniformLiftCode_finrank {ι : Type*} [Fintype ι] [DecidableEq ι]
    (O : Submodule F (ι → (Fin 4 → F))) :
    Module.finrank F (q9UniformLiftCode O) = Module.finrank F O := by
  unfold q9UniformLiftCode
  exact concatenatedCode_finrank axisTwistedCubicCode axisTwistedCubicEncoder O

/-- The lifted distance is at least eight times the outer symbol distance. -/
theorem q9UniformLiftCode_minDist {ι : Type*} [Fintype ι] [DecidableEq ι]
    (hcard : Fintype.card F = 9)
    (O : Submodule F (ι → (Fin 4 → F))) (hO : O ≠ ⊥) :
    8 * symbolMinDist O ≤ minDist (q9UniformLiftCode O) := by
  have hdist := concatenatedCode_minDist_lower axisTwistedCubicCode
    axisTwistedCubicEncoder O hO
  have hmin : minDist (axisTwistedCubicCode (𝔽 := F)) = 8 := by
    rw [axisTwistedCubicCode_eq_columnCode, axisTwistedCubic_minDist, hcard]
  rwa [hmin] at hdist

/-- Paper-facing finite parameter package.  Supplying the base-field dimension `4K` and outer
symbol distance lower bound `D` yields exactly `[19N,4K,≥8D]₉`. -/
theorem q9UniformLiftCode_parameters
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (hcard : Fintype.card F = 9)
    (O : Submodule F (ι → (Fin 4 → F))) (hO : O ≠ ⊥) (K D : ℕ)
    (hK : Module.finrank F O = 4 * K) (hD : D ≤ symbolMinDist O) :
    Fintype.card (ι × AxisTwistedCubicIndex F) = 19 * Fintype.card ι ∧
      Module.finrank F (q9UniformLiftCode O) = 4 * K ∧
      8 * D ≤ minDist (q9UniformLiftCode O) := by
  refine ⟨q9UniformLiftCode_length hcard, q9UniformLiftCode_finrank O |>.trans hK, ?_⟩
  exact (Nat.mul_le_mul_left 8 hD).trans (q9UniformLiftCode_minDist hcard O hO)

/-- The complete radius-three repair hypergraph is copied block-for-block. -/
theorem q9UniformLiftCode_repairHypergraph
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (O : Submodule F (ι → (Fin 4 → F)))
    (hdO : HasFunctionalDualDistanceAtLeast O 5) (j : ι) (z : AxisTwistedCubicIndex F) :
    repairHypergraph (q9UniformLiftCode O) (j, z) 3 =
      embedHypergraph (blockEmbedding j) (axisTwistedCubicRepairHypergraph z 3) := by
  apply repairHypergraph_concatenatedCode_eq_embed axisTwistedCubicCode
    axisTwistedCubicEncoder O 3
  · rw [axisTwistedCubicCode_dualDist]
    omega
  · exact hdO

/-- Every lifted coordinate has locality at most three. -/
theorem q9UniformLiftCode_allSymbol_locality_three
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (O : Submodule F (ι → (Fin 4 → F)))
    (hdO : HasFunctionalDualDistanceAtLeast O 5) (j : ι) (z : AxisTwistedCubicIndex F) :
    ∃ R, R ∈ repairHypergraph (q9UniformLiftCode O) (j, z) 3 := by
  obtain ⟨R, hR⟩ := axisTwistedCubic_allSymbol_locality_three z
  refine ⟨R.map (blockEmbedding j), ?_⟩
  rw [q9UniformLiftCode_repairHypergraph O hdO j z]
  exact Finset.mem_image.mpr ⟨R, hR, rfl⟩

/-- Every lifted coordinate has exactly the corresponding q=9 `(ν,τ)` row. -/
theorem q9UniformLiftCode_row_invariants
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (hcard : Fintype.card F = 9)
    (O : Submodule F (ι → (Fin 4 → F)))
    (hdO : HasFunctionalDualDistanceAtLeast O 5) (j : ι) (z : AxisTwistedCubicIndex F) :
    match z with
    | .inl _ =>
        matchingNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) = 4 ∧
          transversalNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) = 7
    | .inr (Sum.inr _) =>
        matchingNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) = 7 ∧
          transversalNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) = 13
    | .inr (Sum.inl _) =>
        matchingNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) = 6 ∧
          transversalNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) = 12 := by
  rw [q9UniformLiftCode_repairHypergraph O hdO j z,
    matchingNumber_embedHypergraph,
    transversalNumber_embedHypergraph (blockEmbedding j) _
      (fun E hE => axisTwistedCubicRepair_edge_nonempty hE)]
  cases z with
  | inl x => exact axisTwistedCubic_q9_row_invariants hcard (.inl x)
  | inr y =>
      cases y with
      | inl a => exact axisTwistedCubic_q9_row_invariants hcard (.inr (.inl a))
      | inr u => cases u; exact axisTwistedCubic_q9_row_invariants hcard (.inr (.inr Unit.unit))

/-- Integral form of the uniform bound `τ/ν ≥ 7/4`. -/
theorem q9UniformLiftCode_ratio
    {ι : Type*} [Fintype ι] [DecidableEq ι]
    (hcard : Fintype.card F = 9)
    (O : Submodule F (ι → (Fin 4 → F)))
    (hdO : HasFunctionalDualDistanceAtLeast O 5) (j : ι) (z : AxisTwistedCubicIndex F) :
    7 * matchingNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) ≤
      4 * transversalNumber (repairHypergraph (q9UniformLiftCode O) (j, z) 3) := by
  have hrow := q9UniformLiftCode_row_invariants hcard O hdO j z
  cases z with
  | inl x => rw [hrow.1, hrow.2]
  | inr y =>
      cases y with
      | inl a => rw [hrow.1, hrow.2]; norm_num
      | inr u => cases u; rw [hrow.1, hrow.2]; norm_num

#print axioms q9UniformLiftCode_repairHypergraph
#print axioms q9UniformLiftCode_parameters
#print axioms q9UniformLiftCode_allSymbol_locality_three
#print axioms q9UniformLiftCode_row_invariants
#print axioms q9UniformLiftCode_ratio

end
end RepairCodes
