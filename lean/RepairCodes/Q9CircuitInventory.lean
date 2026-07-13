import RepairCodes.Q9Uniform

/-!
# Exact small-circuit support counts for the q=9 uniform seed

The circuit classification is proved in `FiniteGeom.AxisTwistedCubicCircuits` and connected to
the code in `RepairCodes.AxisTwistedCubic`.  This file closes the remaining finite inventory:
three axis points give `choose 10 3 = 120` supports, while three cubic parameters together with
their unique normalized axis completion give `choose 9 3 = 84` supports.
-/

namespace RepairCodes

open Finset FiniteGeom

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F] [CharP F 3]

/-- Supports of the three-axis circuits. -/
noncomputable def axisThreeCircuitSupports :
    Finset (Finset (AxisTwistedCubicIndex F)) :=
  (Finset.univ.powersetCard 3).image fun S => S.map Function.Embedding.inr

/-- A support consisting of a three-element cubic set and its normalized completing axis point.
The arbitrary enumeration is harmless: the proved projective uniqueness theorem shows that the
completion depends only on the set, and injectivity below in fact needs only the cubic part. -/
noncomputable def completedCubicTripleSupport (S : Finset F) :
    Finset (AxisTwistedCubicIndex F) :=
  if h : S.card = 3 then
    let e : Fin 3 ≃ S := (S.equivFinOfCardEq h).symm
    S.map Function.Embedding.inl ∪
      {Sum.inr (twistedCubicTripleAxisIndex fun i => (e i : F))}
  else ∅

/-- Supports of the cubic-triple four-circuits. -/
noncomputable def cubicFourCircuitSupports :
    Finset (Finset (AxisTwistedCubicIndex F)) :=
  (Finset.univ.powersetCard 3).image completedCubicTripleSupport

private def cubicVertices (E : Finset (AxisTwistedCubicIndex F)) :
    Finset (AxisTwistedCubicIndex F) :=
  E.filter fun z => z.isLeft

omit [Fintype F] [CharP F 3] in
private theorem cubicVertices_completedCubicTripleSupport {S : Finset F}
    (hS : S.card = 3) :
    cubicVertices (completedCubicTripleSupport S) = S.map Function.Embedding.inl := by
  classical
  rw [completedCubicTripleSupport, dif_pos hS]
  ext z
  cases z <;> simp [cubicVertices]

omit [CharP F 3] in
/-- Exact q=9 small-circuit inventory, after the general circuit classification: 120 axis
three-circuits and 84 completed cubic-triple four-circuits. -/
theorem q9_smallCircuit_support_counts (hcard : Fintype.card F = 9) :
    (axisThreeCircuitSupports (F := F)).card = 120 ∧
      (cubicFourCircuitSupports (F := F)).card = 84 := by
  classical
  constructor
  · rw [axisThreeCircuitSupports,
      Finset.card_image_of_injective _ (Finset.map_injective Function.Embedding.inr),
      Finset.card_powersetCard]
    simp [hcard]
    decide
  · let triples := (Finset.univ : Finset F).powersetCard 3
    have hcount : (cubicFourCircuitSupports (F := F)).card = triples.card := by
      symm
      apply Finset.card_bij (fun S _ => completedCubicTripleSupport S)
      · intro S hS
        exact Finset.mem_image.mpr ⟨S, hS, rfl⟩
      · intro S hS T hT hEq
        have hScard : S.card = 3 := (Finset.mem_powersetCard.mp hS).2
        have hTcard : T.card = 3 := (Finset.mem_powersetCard.mp hT).2
        have hparts := congrArg cubicVertices hEq
        rw [cubicVertices_completedCubicTripleSupport hScard,
          cubicVertices_completedCubicTripleSupport hTcard] at hparts
        exact Finset.map_injective Function.Embedding.inl hparts
      · intro E hE
        obtain ⟨S, hS, rfl⟩ := Finset.mem_image.mp hE
        exact ⟨S, hS, rfl⟩
    rw [hcount, Finset.card_powersetCard]
    simp [hcard]
    decide

#print axioms q9_smallCircuit_support_counts

end RepairCodes
