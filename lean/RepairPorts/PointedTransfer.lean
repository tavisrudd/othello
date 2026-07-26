import RepairPorts.FunctionalCost
import RepairCodes.WeightedStrictExample

/-!
# Exact pointed confinement and weighted transfer

A concatenated dual word determines one inner functional in each outer block.  The obstruction to
confinement in a distinguished block has three disjoint strata: every block functional is zero,
exactly one is nonzero, or at least two are nonzero.  The zero stratum consists of a pointed
inner-dual word in the target block and a nonzero inner-dual word in another block.  In the other
two strata, independent minimization in the functional fibers gives the exact cost.

The paper-facing theorems below collect the existing exact stratum formulas and identify their
minimum with the first nonembedded pointed witness.  If this cost is at least `r + 2`, every
pointed dual witness using at most `r` helpers is the zero-extension of an inner repair word, so
the complete radius-`r` support port transfers exactly.  No fiber enumerator or finite computation
occurs in these proofs.
-/

namespace RepairPorts

open Finset FiniteGeom RepairCodes

variable {ι κ V 𝔽 : Type*}
variable [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]
variable [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V] [DecidableEq V]

/-- **Exact functional-stratum formulas.**  With at least two outer blocks and a nontrivial
inner dual, the zero-, singleton-, and multisupport-functional lower-bound profiles are exactly
their closed terms. -/
theorem exactFunctionalStrata
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (hcard : 2 ≤ Fintype.card ι)
    (hdual : dualCode I ≠ ⊥) (d : ℕ) :
    (HasZeroFunctionalMultiblockAtLeast I e O d ↔ d ≤ 2 * dualDist I) ∧
      (HasSingletonFunctionalMultiblockAtLeast I e O d ↔
        HasSingletonFunctionalTermAtLeast I e O d) ∧
      (HasMultisupportFunctionalMultiblockAtLeast I e O d ↔
        HasMultisupportFunctionalTermAtLeast I e O d) := by
  exact ⟨hasZeroFunctionalMultiblockAtLeast_iff_le_two_dualDist
      I e O hcard hdual d,
    hasSingletonFunctionalMultiblockAtLeast_iff_term I e O hcard hdual d,
    hasMultisupportFunctionalMultiblockAtLeast_iff_term I e O d⟩

/-- **Exact pointed confinement and transfer.**  The first pointed dual witness not confined to
the target block has the minimum of the zero-functional closed cost and the nonzero
functional-tuple cost.  A lower bound of `r + 2` on this exact obstruction gives literal equality
of the complete radius-`r` support ports. -/
theorem exactPointedConfinementAndTransfer
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (O : Submodule 𝔽 (ι → V)) (j : ι) (x : κ) (r : ℕ) :
    pointedNonembeddedCost I e O j x =
        min (zeroFunctionalPointedClosedCost I e j x)
          (nonzeroOuterPointedFiberCost I e O j x) ∧
      (((r + 2 : ℕ) : WithTop ℕ) ≤ pointedNonembeddedCost I e O j x →
        repairHypergraph (concatenatedCode I e O) (j, x) r =
          embedHypergraph (blockEmbedding j) (repairHypergraph I x r)) := by
  refine ⟨pointedNonembeddedCost_eq_min_closed_nonzero I e O j x, ?_⟩
  intro hcost
  apply repairHypergraph_concatenatedCode_eq_embed_pointed I e O r j x
  exact (hasPointedNonembeddedDualDistanceAtLeast_iff_le_pointedCost
    I e O j x (r + 2)).2 hcost

#print axioms RepairPorts.exactFunctionalStrata
#print axioms RepairPorts.exactPointedConfinementAndTransfer

end RepairPorts
