import RelativeConicArcs.Q25ExactMinimumRows.All
import RelativeConicArcs.Q25ResidualGroup
import RelativeConicArcs.Q25ResidualCoverBridge

/-!
# Residual orbits of the five Q25 minimizers

The five exact minimizer rows have `32` legal conjugate-pair extensions apiece.  This module
certifies the *sizes* of their residual orbits and their pairwise disjointness, so that the five
representatives account for exactly `1600` minimizing rows.

Nothing here decides an orbit.  Each orbit size comes from `Q25ResidualGroup`'s orbit–stabilizer
identity applied to a decided stabilizer filter, and each disjointness comes from a decided
non-reachability statement over the `400` parameters.  Both decided shapes are `Finset.filter` or
`∀`-quantified equalities over the parameter group, phrased through `residualApplyFast`; neither
deduplicates a multiset of eight-point `Finset`s.
-/

namespace RelativeConicArcs
namespace Q25ResidualMinimumOrbits

open Q25Coordinates Q25MinimumMask Q25ResidualAction Q25ResidualFast Q25ResidualGroup
  Q25ResidualCoverData

set_option maxHeartbeats 400000000
set_option maxRecDepth 100000

def minimumRow0065 : Finset Idx25 := rowConfig ⟨58, by decide⟩ ⟨169, by decide⟩
def minimumRow0267 : Finset Idx25 := rowConfig ⟨61, by decide⟩ ⟨81, by decide⟩
def minimumRow0445 : Finset Idx25 := rowConfig ⟨63, by decide⟩ ⟨141, by decide⟩
def minimumRow0772 : Finset Idx25 := rowConfig ⟨97, by decide⟩ ⟨109, by decide⟩
def minimumRow1002 : Finset Idx25 := rowConfig ⟨113, by decide⟩ ⟨194, by decide⟩

theorem card_legalOrbitSet_minimumRow0065 :
    (legalOrbitSet minimumRow0065).card = 32 := by
  simpa [minimumRow0065, rowConfig, Q25RowCompositionData.class0065A,
    Q25RowCompositionData.class0065B, Q25RowCompositionData.class0065C] using
    Q25ExactMinimumRows.class0065LegalOrbitSet_card_eq_32

theorem card_legalOrbitSet_minimumRow0267 :
    (legalOrbitSet minimumRow0267).card = 32 := by
  simpa [minimumRow0267, rowConfig, Q25RowCompositionData.class0267A,
    Q25RowCompositionData.class0267B, Q25RowCompositionData.class0267C] using
    Q25ExactMinimumRows.class0267LegalOrbitSet_card_eq_32

theorem card_legalOrbitSet_minimumRow0445 :
    (legalOrbitSet minimumRow0445).card = 32 := by
  simpa [minimumRow0445, rowConfig, Q25RowCompositionData.class0445A,
    Q25RowCompositionData.class0445B, Q25RowCompositionData.class0445C] using
    Q25ExactMinimumRows.class0445LegalOrbitSet_card_eq_32

theorem card_legalOrbitSet_minimumRow0772 :
    (legalOrbitSet minimumRow0772).card = 32 := by
  simpa [minimumRow0772, rowConfig, Q25RowCompositionData.class0772A,
    Q25RowCompositionData.class0772B, Q25RowCompositionData.class0772C] using
    Q25ExactMinimumRows.class0772LegalOrbitSet_card_eq_32

theorem card_legalOrbitSet_minimumRow1002 :
    (legalOrbitSet minimumRow1002).card = 32 := by
  simpa [minimumRow1002, rowConfig, Q25RowCompositionData.class1002A,
    Q25RowCompositionData.class1002B, Q25RowCompositionData.class1002C] using
    Q25ExactMinimumRows.class1002LegalOrbitSet_card_eq_32

/-! ## Stabilizers

The only decided orbit-structure facts.  Each is one filter over the `400` parameters. -/

theorem card_residualStabilizer_0065 : (residualStabilizer minimumRow0065).card = 2 := by decide
theorem card_residualStabilizer_0267 : (residualStabilizer minimumRow0267).card = 1 := by decide
theorem card_residualStabilizer_0445 : (residualStabilizer minimumRow0445).card = 1 := by decide
theorem card_residualStabilizer_0772 : (residualStabilizer minimumRow0772).card = 2 := by decide
theorem card_residualStabilizer_1002 : (residualStabilizer minimumRow1002).card = 1 := by decide

/-! ## Orbit sizes

Arithmetic on the stabilizer orders through orbit–stabilizer; no orbit is materialized. -/

theorem card_residualOrbit_0065 : (residualOrbit minimumRow0065).card = 200 := by
  have h := card_residualOrbit_mul_card_residualStabilizer minimumRow0065
  rw [card_residualStabilizer_0065] at h
  omega

theorem card_residualOrbit_0267 : (residualOrbit minimumRow0267).card = 400 := by
  have h := card_residualOrbit_mul_card_residualStabilizer minimumRow0267
  rw [card_residualStabilizer_0267] at h
  omega

theorem card_residualOrbit_0445 : (residualOrbit minimumRow0445).card = 400 := by
  have h := card_residualOrbit_mul_card_residualStabilizer minimumRow0445
  rw [card_residualStabilizer_0445] at h
  omega

theorem card_residualOrbit_0772 : (residualOrbit minimumRow0772).card = 200 := by
  have h := card_residualOrbit_mul_card_residualStabilizer minimumRow0772
  rw [card_residualStabilizer_0772] at h
  omega

theorem card_residualOrbit_1002 : (residualOrbit minimumRow1002).card = 400 := by
  have h := card_residualOrbit_mul_card_residualStabilizer minimumRow1002
  rw [card_residualStabilizer_1002] at h
  omega

/-! ## Non-conjugacy

Ten decided statements: no parameter carries one representative to another. -/

theorem notReachable_0065_0267 : ∀ g : ResidualParameter,
    minimumRow0065.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow0267 := by decide
theorem notReachable_0065_0445 : ∀ g : ResidualParameter,
    minimumRow0065.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow0445 := by decide
theorem notReachable_0065_0772 : ∀ g : ResidualParameter,
    minimumRow0065.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow0772 := by decide
theorem notReachable_0065_1002 : ∀ g : ResidualParameter,
    minimumRow0065.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow1002 := by decide
theorem notReachable_0267_0445 : ∀ g : ResidualParameter,
    minimumRow0267.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow0445 := by decide
theorem notReachable_0267_0772 : ∀ g : ResidualParameter,
    minimumRow0267.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow0772 := by decide
theorem notReachable_0267_1002 : ∀ g : ResidualParameter,
    minimumRow0267.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow1002 := by decide
theorem notReachable_0445_0772 : ∀ g : ResidualParameter,
    minimumRow0445.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow0772 := by decide
theorem notReachable_0445_1002 : ∀ g : ResidualParameter,
    minimumRow0445.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow1002 := by decide
theorem notReachable_0772_1002 : ∀ g : ResidualParameter,
    minimumRow0772.image (residualApplyFast g.1.1 g.2.1) ≠ minimumRow1002 := by decide

theorem disjoint_0065_0267 :
    Disjoint (residualOrbit minimumRow0065) (residualOrbit minimumRow0267) :=
  disjoint_residualOrbit _ _ notReachable_0065_0267
theorem disjoint_0065_0445 :
    Disjoint (residualOrbit minimumRow0065) (residualOrbit minimumRow0445) :=
  disjoint_residualOrbit _ _ notReachable_0065_0445
theorem disjoint_0065_0772 :
    Disjoint (residualOrbit minimumRow0065) (residualOrbit minimumRow0772) :=
  disjoint_residualOrbit _ _ notReachable_0065_0772
theorem disjoint_0065_1002 :
    Disjoint (residualOrbit minimumRow0065) (residualOrbit minimumRow1002) :=
  disjoint_residualOrbit _ _ notReachable_0065_1002
theorem disjoint_0267_0445 :
    Disjoint (residualOrbit minimumRow0267) (residualOrbit minimumRow0445) :=
  disjoint_residualOrbit _ _ notReachable_0267_0445
theorem disjoint_0267_0772 :
    Disjoint (residualOrbit minimumRow0267) (residualOrbit minimumRow0772) :=
  disjoint_residualOrbit _ _ notReachable_0267_0772
theorem disjoint_0267_1002 :
    Disjoint (residualOrbit minimumRow0267) (residualOrbit minimumRow1002) :=
  disjoint_residualOrbit _ _ notReachable_0267_1002
theorem disjoint_0445_0772 :
    Disjoint (residualOrbit minimumRow0445) (residualOrbit minimumRow0772) :=
  disjoint_residualOrbit _ _ notReachable_0445_0772
theorem disjoint_0445_1002 :
    Disjoint (residualOrbit minimumRow0445) (residualOrbit minimumRow1002) :=
  disjoint_residualOrbit _ _ notReachable_0445_1002
theorem disjoint_0772_1002 :
    Disjoint (residualOrbit minimumRow0772) (residualOrbit minimumRow1002) :=
  disjoint_residualOrbit _ _ notReachable_0772_1002

/-! ## The union -/

def minimumOrbitUnion : Finset (Finset Idx25) :=
  residualOrbit minimumRow0065 ∪ residualOrbit minimumRow0267 ∪
    residualOrbit minimumRow0445 ∪ residualOrbit minimumRow0772 ∪
      residualOrbit minimumRow1002

theorem card_minimumOrbitUnion : minimumOrbitUnion.card = 1600 := by
  have e2 : (residualOrbit minimumRow0065 ∪ residualOrbit minimumRow0267).card = 600 := by
    rw [Finset.card_union_of_disjoint disjoint_0065_0267, card_residualOrbit_0065,
      card_residualOrbit_0267]
  have e3 : (residualOrbit minimumRow0065 ∪ residualOrbit minimumRow0267 ∪
      residualOrbit minimumRow0445).card = 1000 := by
    rw [Finset.card_union_of_disjoint
      (Finset.disjoint_union_left.mpr ⟨disjoint_0065_0445, disjoint_0267_0445⟩), e2,
      card_residualOrbit_0445]
  have e4 : (residualOrbit minimumRow0065 ∪ residualOrbit minimumRow0267 ∪
      residualOrbit minimumRow0445 ∪ residualOrbit minimumRow0772).card = 1200 := by
    rw [Finset.card_union_of_disjoint
      (Finset.disjoint_union_left.mpr
        ⟨Finset.disjoint_union_left.mpr ⟨disjoint_0065_0772, disjoint_0267_0772⟩,
          disjoint_0445_0772⟩), e3, card_residualOrbit_0772]
  rw [minimumOrbitUnion, Finset.card_union_of_disjoint
    (Finset.disjoint_union_left.mpr
      ⟨Finset.disjoint_union_left.mpr
        ⟨Finset.disjoint_union_left.mpr ⟨disjoint_0065_1002, disjoint_0267_1002⟩,
          disjoint_0445_1002⟩,
        disjoint_0772_1002⟩), e4, card_residualOrbit_1002]

end Q25ResidualMinimumOrbits
end RelativeConicArcs
