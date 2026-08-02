import RelativeConicArcs.PaperIOrientationNodes
import Mathlib.GroupTheory.SpecificGroups.Alternating.Simple

/-!
# Matching-normalizer model of the recovered symmetry

The support two-graph singles out five perfect matchings of the six frame
points.  They form one one-factorization of the complete graph.  The
projective symmetry group is constructed as the normalizer of this matching
family in `S₆`; a finite theorem then identifies this intrinsic normalizer
with the permutations preserving the support cubic line.

Conjugation on the five matchings gives a faithful action on five letters.
Its domain and codomain both have order `120`, so it is an isomorphism with
`S₅`.  This core contains the structural normalizer and action.  The
generator module identifies its even subgroup with the oriented cubic
stabilizer and compares the full normalizer with the cubic-line stabilizer.
-/

namespace RelativeConicArcs.PaperIOrientationSymmetry

open Equiv Equiv.Perm
open PaperIOrientationCover
open PaperIOrientationHolonomy

abbrev S5 := Equiv.Perm Letter
abbrev SixPointFrame := Fin 6

set_option maxRecDepth 100000
set_option maxHeartbeats 1000000

/-- The five perfect matchings distinguished by the support two-graph.  The
index records the partner of vertex zero, in the order `1,2,3,4,5`. -/
def distinguishedMatching : Fin 5 → Equiv.Perm SixPointFrame := ![
  Equiv.swap 0 1 * Equiv.swap 2 3 * Equiv.swap 4 5,
  Equiv.swap 0 2 * Equiv.swap 1 4 * Equiv.swap 3 5,
  Equiv.swap 0 3 * Equiv.swap 1 5 * Equiv.swap 2 4,
  Equiv.swap 0 4 * Equiv.swap 1 3 * Equiv.swap 2 5,
  Equiv.swap 0 5 * Equiv.swap 1 2 * Equiv.swap 3 4]

/-- The five displayed matchings are pairwise distinct. -/
theorem distinguishedMatching_injective :
    Function.Injective distinguishedMatching := by
  decide

/-- A reducible formulation of setwise normalization of the five matching
involutions.  Both conjugation directions are displayed so the equivalence
with the abstract normalizer is structural. -/
def NormalizesDistinguishedMatchings
    (sigma : Equiv.Perm SixPointFrame) : Prop :=
  (∀ i : Fin 5, ∃ j : Fin 5,
    sigma * distinguishedMatching i * sigma⁻¹ = distinguishedMatching j) ∧
  (∀ i : Fin 5, ∃ j : Fin 5,
    sigma⁻¹ * distinguishedMatching i * sigma = distinguishedMatching j)

instance (sigma : Equiv.Perm SixPointFrame) :
    Decidable (NormalizesDistinguishedMatchings sigma) := by
  unfold NormalizesDistinguishedMatchings
  infer_instance

/-- The projective symmetry carrier, defined independently as the normalizer
of the five matching involutions determined by the support data. -/
def SupportCubicProjectiveStabilizer :
    Subgroup (Equiv.Perm SixPointFrame) :=
  Subgroup.normalizer
    (Set.range distinguishedMatching : Set (Equiv.Perm SixPointFrame))

/-- The reducible two-sided conjugation predicate is exactly membership in
the abstract group-theoretic normalizer. -/
theorem normalizesDistinguishedMatchings_iff_mem_normalizer
    (sigma : Equiv.Perm SixPointFrame) :
    NormalizesDistinguishedMatchings sigma ↔
      sigma ∈ SupportCubicProjectiveStabilizer := by
  rw [SupportCubicProjectiveStabilizer,
    Subgroup.mem_set_normalizer_iff]
  constructor
  · rintro ⟨hforward, hbackward⟩ tau
    constructor
    · rintro ⟨i, rfl⟩
      obtain ⟨j, hj⟩ := hforward i
      exact ⟨j, hj.symm⟩
    · rintro ⟨j, hj⟩
      obtain ⟨i, hi⟩ := hbackward j
      refine ⟨i, ?_⟩
      rw [← hi, hj]
      simp [mul_assoc]
  · intro h
    constructor
    · intro i
      have hi := (h (distinguishedMatching i)).mp ⟨i, rfl⟩
      obtain ⟨j, hj⟩ := hi
      exact ⟨j, hj.symm⟩
    · intro i
      have hi : sigma⁻¹ * distinguishedMatching i * sigma ∈
          Set.range distinguishedMatching := by
        apply (h (sigma⁻¹ * distinguishedMatching i * sigma)).mpr
        refine ⟨i, ?_⟩
        simp [mul_assoc]
      obtain ⟨j, hj⟩ := hi
      exact ⟨j, hj.symm⟩

instance (sigma : Equiv.Perm SixPointFrame) :
    Decidable (sigma ∈ SupportCubicProjectiveStabilizer) :=
  decidable_of_iff (NormalizesDistinguishedMatchings sigma)
    (normalizesDistinguishedMatchings_iff_mem_normalizer sigma)

/-- Reducible lookup for the conjugate of a distinguished matching. -/
def matchingIndex (sigma : SupportCubicProjectiveStabilizer)
    (i : Fin 5) : Fin 5 :=
  if sigma.1 * distinguishedMatching i * sigma.1⁻¹ = distinguishedMatching 0 then 0
  else if sigma.1 * distinguishedMatching i * sigma.1⁻¹ = distinguishedMatching 1 then 1
  else if sigma.1 * distinguishedMatching i * sigma.1⁻¹ = distinguishedMatching 2 then 2
  else if sigma.1 * distinguishedMatching i * sigma.1⁻¹ = distinguishedMatching 3 then 3
  else 4

/-- The lookup returns the matching obtained by conjugation. -/
theorem matchingIndex_spec (sigma : SupportCubicProjectiveStabilizer)
    (i : Fin 5) :
    sigma.1 * distinguishedMatching i * sigma.1⁻¹ =
      distinguishedMatching (matchingIndex sigma i) := by
  have hs :=
    (normalizesDistinguishedMatchings_iff_mem_normalizer sigma.1).2 sigma.2
  obtain ⟨j, hj⟩ := hs.1 i
  have hne (a b : Fin 5) (hab : a ≠ b) :
      distinguishedMatching a ≠ distinguishedMatching b :=
    distinguishedMatching_injective.ne hab
  fin_cases j <;> simp_all [matchingIndex, hne]

/-- Conjugation by a projective stabilizer element permutes the five
distinguished matchings. -/
def matchingPermutation (sigma : SupportCubicProjectiveStabilizer) :
    Equiv.Perm (Fin 5) where
  toFun := matchingIndex sigma
  invFun := matchingIndex sigma⁻¹
  left_inv := by
    intro i
    apply distinguishedMatching_injective
    have h := matchingIndex_spec sigma i
    have hinv := matchingIndex_spec sigma⁻¹ (matchingIndex sigma i)
    have hc := congrArg (fun m => sigma.1⁻¹ * m * sigma.1) h
    exact hinv.symm.trans (by simpa [mul_assoc] using hc.symm)
  right_inv := by
    intro i
    apply distinguishedMatching_injective
    have h := matchingIndex_spec sigma⁻¹ i
    have hinv := matchingIndex_spec sigma (matchingIndex sigma⁻¹ i)
    have hc := congrArg (fun m => sigma.1 * m * sigma.1⁻¹) h
    exact hinv.symm.trans (by simpa [mul_assoc] using hc.symm)

/-- Conjugation on the matching family is a group action. -/
def matchingAction :
    SupportCubicProjectiveStabilizer →* Equiv.Perm (Fin 5) where
  toFun := matchingPermutation
  map_one' := by
    apply Equiv.ext
    intro i
    change matchingIndex 1 i = i
    apply distinguishedMatching_injective
    exact (matchingIndex_spec
      (1 : SupportCubicProjectiveStabilizer) i).symm
  map_mul' := by
    intro sigma tau
    apply Equiv.ext
    intro i
    change matchingIndex (sigma * tau) i =
      matchingIndex sigma (matchingIndex tau i)
    apply distinguishedMatching_injective
    have ht := matchingIndex_spec tau i
    have hs := matchingIndex_spec sigma (matchingIndex tau i)
    have hst := matchingIndex_spec (sigma * tau) i
    rw [← hst]
    calc
      (sigma * tau).1 * distinguishedMatching i * (sigma * tau).1⁻¹ =
          sigma.1 * (tau.1 * distinguishedMatching i * tau.1⁻¹) *
            sigma.1⁻¹ := by simp [mul_assoc]
      _ = sigma.1 * distinguishedMatching (matchingIndex tau i) *
            sigma.1⁻¹ := by rw [ht]
      _ = distinguishedMatching (matchingIndex sigma (matchingIndex tau i)) := hs

/-- A permutation of the six vertices centralizing all five matching
involutions is the identity.  Kernel reduction checks the `720 × 5` bounded
domain. -/
theorem centralizes_distinguishedMatchings_implies_identity
    (sigma : Equiv.Perm SixPointFrame)
    (h : ∀ i : Fin 5,
      sigma * distinguishedMatching i * sigma⁻¹ = distinguishedMatching i) :
    sigma = 1 := by
  decide +revert

/-- The action on the five distinguished matchings is faithful. -/
theorem matchingAction_injective : Function.Injective matchingAction := by
  rw [← MonoidHom.ker_eq_bot_iff]
  ext sigma
  constructor
  · intro hsigma
    have hperm : matchingAction sigma = 1 := matchingAction.mem_ker.mp hsigma
    have hcentral : ∀ i : Fin 5,
        sigma.1 * distinguishedMatching i * sigma.1⁻¹ =
          distinguishedMatching i := by
      intro i
      rw [matchingIndex_spec]
      have hi := congrArg (fun e : Equiv.Perm (Fin 5) => e i) hperm
      change matchingIndex sigma i = i at hi
      exact congrArg distinguishedMatching hi
    apply Subtype.ext
    exact centralizes_distinguishedMatchings_implies_identity sigma.1 hcentral
  · rintro rfl
    simp

/-- The matching normalizer has order `120`.  The reducible membership test
checks all `720` permutations of the six-point frame. -/
theorem supportCubicProjectiveStabilizer_card :
    Fintype.card SupportCubicProjectiveStabilizer = 120 := by
  decide

/-- The action on the five matchings is bijective. -/
theorem matchingAction_bijective : Function.Bijective matchingAction := by
  refine ⟨matchingAction_injective, ?_⟩
  apply matchingAction_injective.surjective_of_finite
    (Fintype.equivOfCardEq (α := SupportCubicProjectiveStabilizer)
      (β := Equiv.Perm (Fin 5)) ?_)
  rw [supportCubicProjectiveStabilizer_card, Fintype.card_perm]
  decide

/-- The projective stabilizer of the support cubic is `S₅`. -/
noncomputable def supportCubic_projectiveStabilizer_equiv_S5 :
    SupportCubicProjectiveStabilizer ≃* S5 :=
  (MulEquiv.ofBijective matchingAction matchingAction_bijective).trans
    (ZMod.finEquiv 5).toEquiv.permCongrHom

/-- A frame permutation preserves the support cubic line when it either
preserves every triangle coefficient or reverses every coefficient.  Repeated
indices contribute zero, so this is equivalent to checking the twenty
unordered triples. -/
def PreservesSupportCubicLine (sigma : Equiv.Perm SixPointFrame) : Prop :=
  (∀ i j k,
    supportSign (sigma i) (sigma j) (sigma k) = supportSign i j k) ∨
  (∀ i j k,
    supportSign (sigma i) (sigma j) (sigma k) = -supportSign i j k)

instance (sigma : Equiv.Perm SixPointFrame) :
    Decidable (PreservesSupportCubicLine sigma) := by
  unfold PreservesSupportCubicLine
  infer_instance

/-- A frame permutation preserves the chosen orientation when it preserves
every triangle coefficient. -/
def PreservesOrientedSupportCubic
    (sigma : Equiv.Perm SixPointFrame) : Prop :=
  ∀ i j k,
    supportSign (sigma i) (sigma j) (sigma k) = supportSign i j k

instance (sigma : Equiv.Perm SixPointFrame) :
    Decidable (PreservesOrientedSupportCubic sigma) := by
  unfold PreservesOrientedSupportCubic
  infer_instance

#print axioms normalizesDistinguishedMatchings_iff_mem_normalizer
#print axioms matchingIndex_spec
#print axioms matchingAction_injective
#print axioms supportCubicProjectiveStabilizer_card
#print axioms supportCubic_projectiveStabilizer_equiv_S5

end RelativeConicArcs.PaperIOrientationSymmetry
