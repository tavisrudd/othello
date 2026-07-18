import RelativeConicArcs.Q25ResidualMinimumOrbits

/-!
# Semantic target for the five residual equality classes

`ResidualMapsTo C D` records an actual checked member of the order-`400` residual action sending
`C` to `D`; it is not a claim about a generated class index.

The certified orbits of `Q25ResidualMinimumOrbits` answer this predicate exactly:
`IsMinimumResidualClass C` holds precisely for the `1600` rows of `minimumOrbitUnion`.  What
remains for the classification is the converse containment — that every exceptional-profile row
attaining `32` lies in that union — which is an exhaustion statement against the residual-cover
machinery, not a fact about this action.
-/

namespace RelativeConicArcs
namespace Q25ResidualEquality

open Q25Coordinates Q25ResidualAction Q25ResidualGroup Q25ResidualMinimumOrbits

set_option maxRecDepth 100000

def ResidualMapsTo (C D : Finset Idx25) : Prop :=
  ∃ g : ResidualParameter, C.map (parameterEmbedding g) = D

def IsMinimumResidualClass (C : Finset Idx25) : Prop :=
  ResidualMapsTo C minimumRow0065 ∨
    ResidualMapsTo C minimumRow0267 ∨
      ResidualMapsTo C minimumRow0445 ∨
        ResidualMapsTo C minimumRow0772 ∨
          ResidualMapsTo C minimumRow1002

theorem residualMapsTo_iff_mem_residualOrbit (C D : Finset Idx25) :
    ResidualMapsTo C D ↔ D ∈ residualOrbit C := by
  rw [mem_residualOrbit_iff]
  constructor
  · rintro ⟨g, hg⟩
    exact ⟨g, by rw [smul_eq_map]; exact hg⟩
  · rintro ⟨g, hg⟩
    exact ⟨g, by rw [← smul_eq_map]; exact hg⟩

/-- `C` maps onto a minimizer representative exactly when `C` is one of the `1600` rows of the
five certified orbits. -/
theorem isMinimumResidualClass_iff_mem_minimumOrbitUnion (C : Finset Idx25) :
    IsMinimumResidualClass C ↔ C ∈ minimumOrbitUnion := by
  have key : ∀ R : Finset Idx25, ResidualMapsTo C R ↔ C ∈ residualOrbit R := by
    intro R
    rw [residualMapsTo_iff_mem_residualOrbit]
    exact ⟨mem_residualOrbit_comm, mem_residualOrbit_comm⟩
  rw [IsMinimumResidualClass, key, key, key, key, key, minimumOrbitUnion]
  simp only [Finset.mem_union, or_assoc]

/-- The rows satisfying `IsMinimumResidualClass` are exactly the members of a `1600`-element
`Finset`; `card_minimumOrbitUnion` supplies the count. -/
theorem exists_minimumClass_finset :
    ∃ U : Finset (Finset Idx25),
      U.card = 1600 ∧ ∀ C : Finset Idx25, IsMinimumResidualClass C ↔ C ∈ U :=
  ⟨minimumOrbitUnion, card_minimumOrbitUnion, isMinimumResidualClass_iff_mem_minimumOrbitUnion⟩

end Q25ResidualEquality
end RelativeConicArcs
