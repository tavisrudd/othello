import RelativeConicArcs.Q11RigiditySpine
import RelativeConicArcs.Q11SemanticRayData
import RelativeConicArcs.Q11Coding
import RelativeConicArcs.ClebschGatewayQ11Extension

/-!
# Projective and coding-language bridges for Clebsch rigidity

The finite q11 certificate package uses the canonical index type `Fin 133`,
whereas the geometric rigidity theorem is stated on abstract points of
`PG(2,11)`.  This module identifies those types through the already proved
normalization of every nonzero syndrome vector.  It also identifies ordinary
uncovered points with projective distance-three syndrome directions directly
from their incidence definitions.

The remaining terminal in this module transports projective equivalence of
the six parity-check columns to monomial equivalence of their kernel codes and
records the affine coset and minimum-leader semantics without conflating
projective, monomial, or literal equality.
-/

namespace RelativeConicArcs.ClebschDye

open Configuration Projectivization
open scoped LinearAlgebra.Projectivization

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

noncomputable local instance : Fintype Point11 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point11 := Classical.decEq _

open RelativeConicArcs.Examples.Q11Coding

/-- The 133 canonical syndrome representatives exhaust the abstract
projective plane over `ZMod 11`. -/
theorem projectiveSyndromePoint_surjective :
    Function.Surjective projectiveSyndromePoint := by
  intro p
  let s : {v : Certificate.Vec K11 // v ≠ 0} := ⟨p.rep, p.rep_nonzero⟩
  let r : AffineRay := affineRayOfVec s
  refine ⟨r.1, ?_⟩
  rw [← Projectivization.mk_rep p]
  unfold projectiveSyndromePoint Certificate.toPoint
  apply (Projectivization.mk_eq_mk_iff' K11
    (projectiveVec r.1) p.rep (projectiveVec_ne_zero r.1) p.rep_nonzero).mpr
  refine ⟨(r.2.1)⁻¹, ?_⟩
  have hr := congrArg Subtype.val (affineRayOfVec_rightInverse s)
  have hr' : r.2.1 • projectiveVec r.1 = p.rep := by
    simpa [r, s, affineRayVec] using hr
  rw [← hr']
  simp [smul_smul, r.2.2]

/-- Canonical q11 point indices are equivalent to abstract projective points;
the forward map sends an index to the ray of its normalized representative. -/
noncomputable def pointIndexEquiv : (Fin 133) ≃ Point11 := by
  apply Equiv.ofBijective projectiveSyndromePoint
  apply (Fintype.bijective_iff_surjective_and_card projectiveSyndromePoint).mpr
  refine ⟨projectiveSyndromePoint_surjective, ?_⟩
  rw [Fintype.card_fin, ← Nat.card_eq_fintype_card,
    Projectivization.card_of_finrank K11 Space11 (n := 3) (by simp)]
  norm_num [Finset.sum_range_succ]

/-- With no prescribed holes, the geometric uncovered locus is literally the
set of projective syndrome directions of distance three. -/
theorem uncovered_eq_distanceThreeDirections (A : Finset Point11) :
    uncovered (L := Point11) A ∅ =
      distanceThreeDirections (L := Point11) A := by
  classical
  ext p
  simp [uncovered, requiredLocus]

/-- Two injective enumerations of the same finite point set differ by a
permutation of their common index type. -/
theorem exists_permutation_of_univ_image_eq
    {I X : Type*} [Fintype I] [DecidableEq I] [DecidableEq X]
    (f g : I → X) (hf : Function.Injective f) (_hg : Function.Injective g)
    (himage : Finset.univ.image f = Finset.univ.image g) :
    ∃ permutation : I ≃ I, ∀ i, f i = g (permutation i) := by
  classical
  have hexists (i : I) : ∃ j : I, g j = f i := by
    have hfi : f i ∈ Finset.univ.image g := by
      rw [← himage]
      exact Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩
    obtain ⟨j, _hj, hji⟩ := Finset.mem_image.mp hfi
    exact ⟨j, hji⟩
  let permutationFun : I → I := fun i ↦ Classical.choose (hexists i)
  have hpermutation (i : I) : f i = g (permutationFun i) :=
    (Classical.choose_spec (hexists i)).symm
  have hinjective : Function.Injective permutationFun := by
    intro i j hij
    apply hf
    rw [hpermutation i, hpermutation j, hij]
  let permutation : I ≃ I := Equiv.ofBijective permutationFun
    ⟨hinjective, Finite.surjective_of_injective hinjective⟩
  exact ⟨permutation, hpermutation⟩

/-- The projective point represented by an explicitly nonzero syndrome
column. -/
def projectiveColumn (v : Fin 6 → Space11) (
    v_ne_zero : ∀ i, v i ≠ 0) (i : Fin 6) : Point11 :=
  Projectivization.mk K11 (v i) (v_ne_zero i)

/-- Projective equivalence of an injectively indexed six-column realization
to the Clebsch point set supplies an actual coordinate permutation and
nonzero column scalars. -/
theorem exists_indexedColumnTransport_of_isClebschHexagon
    (v : Fin 6 → Space11) (v_ne_zero : ∀ i, v i ≠ 0)
    (v_projective_injective : Function.Injective (projectiveColumn v v_ne_zero))
    (hclebsch : IsClebschHexagon
      (Finset.univ.image (projectiveColumn v v_ne_zero))) :
    ∃ rowEquiv : Space11 ≃ₗ[K11] Space11,
      ∃ permutation : Fin 6 ≃ Fin 6,
        ∃ scale : Fin 6 → K11,
          (∀ i, scale i ≠ 0) ∧
          (∀ i, Examples.Q11Coding.witnessVec i =
            scale i • rowEquiv (v (permutation i))) := by
  classical
  obtain ⟨rowEquiv, hset⟩ := hclebsch
  have himage :
      Finset.univ.image
          (fun i ↦ ProjectiveCap.Projective.mapEquiv rowEquiv
            (projectiveColumn v v_ne_zero i)) =
        Finset.univ.image ClebschGateway.Q11Extension.parentPoint := by
    rw [ClebschGateway.Q11Extension.parentPoint_image]
    simpa [Finset.map_eq_image, Finset.image_image, Function.comp_def,
      clebschWitness] using hset
  have hsource : Function.Injective
      (fun i ↦ ProjectiveCap.Projective.mapEquiv rowEquiv
        (projectiveColumn v v_ne_zero i)) :=
    (ProjectiveCap.Projective.mapEquiv rowEquiv).injective.comp
      v_projective_injective
  obtain ⟨sourcePermutation, hpoints⟩ := exists_permutation_of_univ_image_eq
    _ _ hsource ClebschGateway.Q11Extension.parentPoint_injective himage
  have hscalar (i : Fin 6) : ∃ a : K11, a ≠ 0 ∧
      Examples.Q11Coding.witnessVec (sourcePermutation i) =
        a • rowEquiv (v i) := by
    have hp := hpoints i
    unfold projectiveColumn ClebschGateway.Q11Extension.parentPoint
      Certificate.toPoint at hp
    rw [ProjectiveCap.Projective.mapEquiv_mk] at hp
    obtain ⟨a, ha⟩ := (Projectivization.mk_eq_mk_iff' K11
      (Examples.Q11Coding.witnessVec (sourcePermutation i)) (rowEquiv (v i))
      (Examples.q11Witness.get (sourcePermutation i)).2
      (rowEquiv.map_ne_zero_iff.mpr (v_ne_zero i))).mp hp.symm
    have ha0 : a ≠ 0 := by
      intro haZero
      have : Examples.Q11Coding.witnessVec (sourcePermutation i) = 0 := by
        simpa [haZero] using ha.symm
      exact (Examples.q11Witness.get (sourcePermutation i)).2 this
    exact ⟨a, ha0, ha.symm⟩
  let sourceScale : Fin 6 → K11 := fun i ↦ Classical.choose (hscalar i)
  let permutation : Fin 6 ≃ Fin 6 := sourcePermutation.symm
  let scale : Fin 6 → K11 := fun i ↦ sourceScale (sourcePermutation.symm i)
  refine ⟨rowEquiv, permutation, scale, ?_, ?_⟩
  · intro i
    exact (Classical.choose_spec (hscalar (sourcePermutation.symm i))).1
  · intro i
    have hi := (Classical.choose_spec (hscalar (sourcePermutation.symm i))).2
    simpa [permutation, scale, sourceScale] using hi

section MonomialTransport

variable {K W ι : Type*} [Field K] [AddCommGroup W] [Module K W]
  [FiniteDimensional K W] [Fintype ι] [DecidableEq ι] [DecidableEq K]

/-- The coordinate permutation and nonzero rescaling induced by projectively
equivalent indexed parity-check columns. -/
def monomialWordEquiv (permutation : ι ≃ ι) (scale : ι → K)
    (scale_ne_zero : ∀ i, scale i ≠ 0) : (ι → K) ≃ₗ[K] (ι → K) where
  toFun c j := scale (permutation.symm j) * c (permutation.symm j)
  invFun d i := (scale i)⁻¹ * d (permutation i)
  left_inv c := by
    funext i
    simp [scale_ne_zero i]
  right_inv d := by
    funext j
    simp [scale_ne_zero (permutation.symm j)]
  map_add' c d := by
    funext j
    simp [mul_add]
  map_smul' r c := by
    funext j
    simp [mul_assoc, mul_left_comm]

@[simp] theorem monomialWordEquiv_apply
    (permutation : ι ≃ ι) (scale : ι → K)
    (scale_ne_zero : ∀ i, scale i ≠ 0) (c : ι → K) (j : ι) :
    monomialWordEquiv permutation scale scale_ne_zero c j =
      scale (permutation.symm j) * c (permutation.symm j) := by
  rfl

/-- Columnwise projective equivalence intertwines the two parity-check maps
through the associated monomial word equivalence. -/
theorem parityCheckMap_monomialWordEquiv
    (v w : ι → W) (rowEquiv : W ≃ₗ[K] W)
    (permutation : ι ≃ ι) (scale : ι → K)
    (scale_ne_zero : ∀ i, scale i ≠ 0)
    (hcolumns : ∀ i, w i = scale i • rowEquiv (v (permutation i)))
    (c : ι → K) :
    CodingBridge.parityCheckMap (K := K) w c =
      rowEquiv (CodingBridge.parityCheckMap (K := K) v
        (monomialWordEquiv permutation scale scale_ne_zero c)) := by
  classical
  simp only [CodingBridge.parityCheckMap, Fintype.linearCombination_apply]
  rw [map_sum]
  simp_rw [hcolumns, map_smul]
  rw [← permutation.symm.sum_comp]
  apply Finset.sum_congr rfl
  intro i _
  simp only [Equiv.apply_symm_apply, smul_smul, monomialWordEquiv_apply]
  rw [mul_comm]

/-- Projectively equivalent indexed parity-check columns define monomially
equivalent kernel codes.  This is an equivalence of membership propositions,
not literal equality of the two submodules. -/
theorem parityCheckCode_mem_monomialWordEquiv
    (v w : ι → W) (rowEquiv : W ≃ₗ[K] W)
    (permutation : ι ≃ ι) (scale : ι → K)
    (scale_ne_zero : ∀ i, scale i ≠ 0)
    (hcolumns : ∀ i, w i = scale i • rowEquiv (v (permutation i)))
    (c : ι → K) :
    c ∈ CodingBridge.parityCheckCode (K := K) w ↔
      monomialWordEquiv permutation scale scale_ne_zero c ∈
        CodingBridge.parityCheckCode (K := K) v := by
  change CodingBridge.parityCheckMap (K := K) w c = 0 ↔
    CodingBridge.parityCheckMap (K := K) v
      (monomialWordEquiv permutation scale scale_ne_zero c) = 0
  rw [parityCheckMap_monomialWordEquiv v w rowEquiv permutation scale
    scale_ne_zero hcolumns c]
  exact rowEquiv.map_eq_zero_iff

/-- Two ambient words represent the same affine code coset exactly when they
have the same syndrome. -/
theorem sub_mem_parityCheckCode_iff_same_syndrome
    (v : ι → W) (c d : ι → K) :
    c - d ∈ CodingBridge.parityCheckCode (K := K) v ↔
      CodingBridge.parityCheckMap (K := K) v c =
        CodingBridge.parityCheckMap (K := K) v d := by
  change CodingBridge.parityCheckMap (K := K) v (c - d) = 0 ↔ _
  rw [map_sub, sub_eq_zero]

/-- Exact syndrome distance says both that a leader of the displayed weight
exists and that no word in the same affine coset has smaller weight. -/
theorem syndromeDistanceExactly_iff_exists_minimumLeader
    (v : ι → W) (s : W) (d : ℕ) :
    CodingBridge.SyndromeDistanceExactly (K := K) v s d ↔
      (∃ c : ι → K,
        CodingBridge.parityCheckMap (K := K) v c = s ∧
        CodingBridge.hammingWeight c = d) ∧
      (∀ e : ι → K,
        CodingBridge.parityCheckMap (K := K) v e = s →
          d ≤ CodingBridge.hammingWeight e) := by
  simp only [CodingBridge.SyndromeDistanceExactly,
    CodingBridge.SyndromeDistanceAtLeast]
  exact and_comm

end MonomialTransport

/-- **Code-language rigidity terminal.**  If the projective deep-hole locus of
an injectively indexed six-column realization lies on a nonzero plane
quadratic, then the column set is Clebsch and an explicit permutation/rescaling
of coordinates identifies its parity-check kernel with the displayed witness
code.  The conclusion separately records the projective locus equality and the
monomial code equivalence; it does not assert literal equality of either
column matrices or code submodules. -/
theorem deepHoleLocus_rigidifies_witnessCode
    (v : Fin 6 → Space11) (v_ne_zero : ∀ i, v i ≠ 0)
    (v_projective_injective : Function.Injective (projectiveColumn v v_ne_zero))
    (hArc : Arc (L := Point11)
      (Finset.univ.image (projectiveColumn v v_ne_zero)))
    (hcard : (Finset.univ.image (projectiveColumn v v_ne_zero)).card = 6)
    (Q : PlaneQuadraticLocus)
    (hsubset : uncovered (L := Point11)
      (Finset.univ.image (projectiveColumn v v_ne_zero)) ∅ ⊆ Q.points) :
    IsClebschHexagon (Finset.univ.image (projectiveColumn v v_ne_zero)) ∧
      uncovered (L := Point11)
          (Finset.univ.image (projectiveColumn v v_ne_zero)) ∅ =
        distanceThreeDirections (L := Point11)
          (Finset.univ.image (projectiveColumn v v_ne_zero)) ∧
      ∃ rowEquiv : Space11 ≃ₗ[K11] Space11,
        ∃ permutation : Fin 6 ≃ Fin 6,
          ∃ scale : Fin 6 → K11,
            ∃ scale_ne_zero : ∀ i, scale i ≠ 0,
              (∀ i, Examples.Q11Coding.witnessVec i =
                scale i • rowEquiv (v (permutation i))) ∧
                ∀ c : Fin 6 → K11,
                  c ∈ CodingBridge.parityCheckCode (K := K11)
                      Examples.Q11Coding.witnessVec ↔
                    monomialWordEquiv permutation scale scale_ne_zero c ∈
                      CodingBridge.parityCheckCode (K := K11) v := by
  let A := Finset.univ.image (projectiveColumn v v_ne_zero)
  have hclebsch : IsClebschHexagon A :=
    isClebschHexagon_of_uncovered_subset_planeConic hArc hcard Q hsubset
  refine ⟨hclebsch, uncovered_eq_distanceThreeDirections A, ?_⟩
  obtain ⟨rowEquiv, permutation, scale, scale_ne_zero, hcolumns⟩ :=
    exists_indexedColumnTransport_of_isClebschHexagon
      v v_ne_zero v_projective_injective hclebsch
  exact ⟨rowEquiv, permutation, scale, scale_ne_zero, hcolumns, fun c ↦
      parityCheckCode_mem_monomialWordEquiv v Examples.Q11Coding.witnessVec
        rowEquiv permutation scale scale_ne_zero hcolumns c⟩

#print axioms projectiveSyndromePoint_surjective
#print axioms pointIndexEquiv
#print axioms uncovered_eq_distanceThreeDirections
#print axioms parityCheckCode_mem_monomialWordEquiv
#print axioms sub_mem_parityCheckCode_iff_same_syndrome
#print axioms syndromeDistanceExactly_iff_exists_minimumLeader
#print axioms deepHoleLocus_rigidifies_witnessCode

end RelativeConicArcs.ClebschDye
