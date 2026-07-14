import RepairCodes.ProjectiveAxisTwistedCubicInvariants

/-!
# External-point transversal spectrum of the projective twisted cubic (completion §6.5)

For an external point `x ∈ PG(3,q)` over a characteristic-three field, completion §6.5 studies
`ρ(x) = τ { B ∈ C(C,3) : x ∈ ⟨B⟩ }`, the minimum transversal (hitting set) of the 3-secant planes
of the twisted cubic `C` through `x`.  This module certifies the value on the **axis orbit**.

At the nucleus (the axis point at infinity) the projection from `x` sends `C` to the cuspidal cubic
`v² = u³`: the finite cubic points form the additive group `(𝔽,+)` with three of them coplanar with
`x` exactly when their parameters sum to zero, while the cubic point at infinity is the cusp and lies
on no 3-secant plane through `x`.  Hence the secant hypergraph is `zeroSumTripleHypergraph 𝔽` plus an
isolated vertex, and

  `τ(nucleus) = Fintype.card 𝔽 - zeroSumCapNumber 𝔽 = q - r₃(h)`.

This reduces the §6.5 axis-orbit transversal spectrum to the affine cap-set number `r₃(h)`
(`zeroSumCapNumber 𝔽`), reusing `FiniteGeom.ZeroSumTriple` and the axis repair-clutter machinery.
By orbit constancy under `projectiveShiftInvIndexEquiv` the same value holds at every axis point.

See `notes/2026-07-13-c115-twisted-cubic-tau-reduction.md`.
-/

namespace RepairCodes

open Finset FiniteGeom

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- The completion §6.5 secant-transversal hypergraph at a projective axis external point `y`:
the cubic-only part of the minimal repair clutter for the axis target `y`, i.e. the triples of
projective cubic points whose 3-secant plane passes through `y`. -/
noncomputable def projectiveTwistedCubicSecantHypergraph (y : 𝔽 ⊕ Unit) :
    Finset (Finset (ProjectiveAxisTwistedCubicIndex 𝔽)) :=
  (minimalProjectiveAxisTwistedCubicRepairHypergraph (Sum.inr y) 3).filter fun E => ∀ z ∈ E, z.isLeft

-- The affine→projective coordinate inclusion preserves cubic-versus-axis membership.
omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp] lemma affineToProjectiveAxisIndexEmbedding_isLeft (z : AxisTwistedCubicIndex 𝔽) :
    (affineToProjectiveAxisIndexEmbedding z).isLeft = z.isLeft := by
  cases z <;> rfl

/-- At the nucleus the projective secant clutter is the affine cubic repair component, embedded:
the cubic point at infinity lies on no 3-secant plane, so it contributes no edge. -/
theorem projectiveTwistedCubicSecantHypergraph_infinity_eq_embed [CharP 𝔽 3] :
    projectiveTwistedCubicSecantHypergraph (Sum.inr Unit.unit : 𝔽 ⊕ Unit)
      = embedHypergraph (affineToProjectiveAxisIndexEmbedding (𝔽 := 𝔽))
          (axisCubicRepairComponent (Sum.inr Unit.unit : 𝔽 ⊕ Unit)) := by
  unfold projectiveTwistedCubicSecantHypergraph axisCubicRepairComponent
  rw [minimalProjectiveAxisInfinityRepair_eq_embedAffine]
  ext E
  simp only [embedHypergraph, Finset.mem_filter, Finset.mem_image]
  constructor
  · rintro ⟨⟨s, hs, rfl⟩, hleft⟩
    refine ⟨s, ⟨hs, ?_⟩, rfl⟩
    intro z hz
    have h := hleft _ (Finset.mem_map_of_mem affineToProjectiveAxisIndexEmbedding hz)
    simpa using h
  · rintro ⟨s, ⟨hs, hsleft⟩, rfl⟩
    refine ⟨⟨s, hs, rfl⟩, ?_⟩
    intro z hz
    obtain ⟨w, hw, rfl⟩ := Finset.mem_map.mp hz
    simpa using hsleft w hw

/-- **Completion §6.5, axis orbit (nucleus).**  The external-point transversal number of the
projective twisted cubic at the nucleus equals `q - r₃(h)`, reducing the axis-orbit transversal
spectrum to the affine cap-set number `zeroSumCapNumber 𝔽`. -/
theorem projectiveTwistedCubicSecantTransversal_infinity [CharP 𝔽 3] :
    transversalNumber (projectiveTwistedCubicSecantHypergraph (Sum.inr Unit.unit : 𝔽 ⊕ Unit))
      = Fintype.card 𝔽 - zeroSumCapNumber 𝔽 := by
  have hne : ∀ E ∈ axisCubicRepairComponent (Sum.inr Unit.unit : 𝔽 ⊕ Unit), E.Nonempty := by
    intro E hE
    rw [mem_axisCubicRepairComponent_iff] at hE
    obtain ⟨s, t, u, _, _, _, _, rfl⟩ := hE
    exact ⟨(Sum.inl s : AxisTwistedCubicIndex 𝔽), Finset.mem_insert_self _ _⟩
  rw [projectiveTwistedCubicSecantHypergraph_infinity_eq_embed,
      transversalNumber_embedHypergraph _ _ hne,
      axisCubicRepairComponent_infinity_transversalNumber,
      transversalNumber_zeroSumTripleHypergraph]

#print axioms projectiveTwistedCubicSecantHypergraph_infinity_eq_embed
#print axioms projectiveTwistedCubicSecantTransversal_infinity

end RepairCodes
