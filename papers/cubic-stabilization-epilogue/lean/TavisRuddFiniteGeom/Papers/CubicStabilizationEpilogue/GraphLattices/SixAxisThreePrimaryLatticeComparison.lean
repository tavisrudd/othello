import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisPrimaryDiscriminantSplitting

/-!
# The three-primary part of the source discriminant as the kernel of the reduced polarization

Two models of the three-primary discriminant of the six-axis source occur in
this development.  One is the three-torsion part of the discriminant group,
that is of the cokernel of the integral source polarization on the standard
lattice.  The other is the kernel of the same polarization reduced modulo
three, an `F₃`-subspace of `F₃^ι` for `ι` an axis together with an elliptic
homology coordinate; it is the model in which the three-primary coefficient
heart, its minus-dot-product pairing, and the classification of the diagonally
stable four-dimensional subspaces are formalized.  This module identifies them.

The comparison map is division free.  The polarization `F` has an integral
cofactor `C` with `F C = C F = 6`, so the reduction modulo three of `C v`
depends only on the class of `v` in the cokernel, and gives an additive map
from the discriminant group to `F₃^ι`.  Its image lies in the kernel of the
reduced polarization because `F C v = 6 v` is divisible by three; its kernel is
exactly the two-primary part of the discriminant group, because `C v = 3 z`
forces `2 v = F z` and conversely; and it is onto the kernel of the reduced
polarization, because an integral lift `w` of a kernel vector has `F w`
divisible by three, say `F w = 3 u`, and then the class of `u` is three-torsion
with `C u = 2 w`, which reduces to minus `w` modulo three, so that the class of
`-u` reduces to `w`.  This sign is the only place where the three-primary route
differs from the two-primary one, and it comes from `2 ≡ -1` modulo three.

Results.  The comparison map has kernel the two-primary part and image the
kernel of the reduced polarization, and it therefore restricts to an
isomorphism from the three-primary part of the discriminant group onto that
kernel.  Composing with the coordinates already available on the kernel
presents the three-primary part of the discriminant group as four copies of the
rank-two three-torsion module.

Trust boundary.  Every statement is about explicit integral and `F₃` matrices
and finite abelian groups.  No abelian scheme, elliptic scheme, isogeny, Weil
pairing, torsion local system, or geometric commutator pairing is constructed,
and the identification of these lattice-level objects with geometric ones is
supplied elsewhere.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Kronecker
open scoped Matrix

/-- Reducing the entries of the integral source polarization modulo three gives
the three-torsion source polarization. -/
theorem sixAxisSourcePolarization_map_intCast_three :
    (sixAxisSourcePolarization ℤ).map (Int.castRingHom F3) = sixAxisSourcePolarization F3 := by
  ext row column
  obtain ⟨axis, spin⟩ := row
  obtain ⟨otherAxis, otherSpin⟩ := column
  rw [Matrix.map_apply, sixAxisSourcePolarization_apply, sixAxisSourcePolarization_apply,
    map_mul]
  refine congrArg₂ (· * ·) ?_ ?_
  · show ((6 * (if axis = otherAxis then (1 : ℤ) else 0) - 1 : ℤ) : F3) =
      6 * (if axis = otherAxis then (1 : F3) else 0) - 1
    by_cases equalAxes : axis = otherAxis
    · simp only [equalAxes]
      decide
    · simp [equalAxes]
  · fin_cases spin <;> fin_cases otherSpin <;>
      simp [ellipticWeilPairing]

/-- Reduction of integral vectors modulo three, coordinatewise. -/
def integralThreeReduction : (Fin 5 × Fin 2 → ℤ) →ₗ[ℤ] (Fin 5 × Fin 2 → F3) where
  toFun vector := fun index ↦ ((vector index : ℤ) : F3)
  map_add' := by
    intro first second
    funext index
    exact Int.cast_add _ _
  map_smul' := by
    intro scalar vector
    funext index
    simp [zsmul_eq_mul]

/-- Reduction modulo three of an integral vector, coordinatewise. -/
theorem integralThreeReduction_apply (vector : Fin 5 × Fin 2 → ℤ) (index : Fin 5 × Fin 2) :
    integralThreeReduction vector index = ((vector index : ℤ) : F3) :=
  rfl

/-- Reduction commutes with multiplication by the source polarization. -/
theorem integralThreeReduction_mulVec (vector : Fin 5 × Fin 2 → ℤ) :
    integralThreeReduction (sixAxisSourcePolarization ℤ *ᵥ vector) =
      sixAxisSourcePolarization F3 *ᵥ integralThreeReduction vector := by
  funext index
  have reduced := RingHom.map_mulVec (Int.castRingHom F3) (sixAxisSourcePolarization ℤ)
    vector index
  rw [sixAxisSourcePolarization_map_intCast_three] at reduced
  exact reduced

/-- A reduced coordinate vanishes exactly when three divides the integer. -/
theorem integralThreeReduction_apply_eq_zero_iff (vector : Fin 5 × Fin 2 → ℤ)
    (index : Fin 5 × Fin 2) :
    integralThreeReduction vector index = 0 ↔ (3 : ℤ) ∣ vector index := by
  show ((vector index : ℤ) : F3) = 0 ↔ (3 : ℤ) ∣ vector index
  rw [ZMod.intCast_zmod_eq_zero_iff_dvd]
  norm_num

/-- The comparison of the two models: the reduction modulo three of the
cofactor image of a representative.  The cofactor identity `C F = 6` makes it
depend only on the class in the discriminant group. -/
def sixAxisSourceThreePrimaryComparison :
    sixAxisSourceDiscriminantGroup →ₗ[ℤ] (Fin 5 × Fin 2 → F3) :=
  Submodule.liftQ _
    (integralThreeReduction.comp (Matrix.mulVecLin sixAxisSourcePolarizationCofactor))
    (by
      intro vector membership
      obtain ⟨source, rfl⟩ := mem_latticeImage_iff.mp membership
      refine LinearMap.mem_ker.mpr ?_
      show integralThreeReduction (sixAxisSourcePolarizationCofactor *ᵥ
        (sixAxisSourcePolarization ℤ *ᵥ source)) = 0
      rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
        Matrix.one_mulVec]
      funext index
      refine (integralThreeReduction_apply_eq_zero_iff _ index).mpr ?_
      exact ⟨2 * source index, by simp [Pi.smul_apply]; ring⟩)

/-- The comparison computes on the class of a representative. -/
theorem sixAxisSourceThreePrimaryComparison_mk (vector : Fin 5 × Fin 2 → ℤ) :
    sixAxisSourceThreePrimaryComparison (Submodule.Quotient.mk vector) =
      integralThreeReduction (sixAxisSourcePolarizationCofactor *ᵥ vector) :=
  rfl

/-- The comparison lands in the kernel of the reduced polarization, because the
cofactor identity makes the polarization of a cofactor image divisible by
three. -/
theorem sixAxisSourceThreePrimaryComparison_mem_kernel
    (element : sixAxisSourceDiscriminantGroup) :
    sixAxisSourceThreePrimaryComparison element ∈ sixAxisSourceThreePrimaryDiscriminant := by
  obtain ⟨vector, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  refine LinearMap.mem_ker.mpr ?_
  rw [Matrix.mulVecLin_apply, sixAxisSourceThreePrimaryComparison_mk,
    ← integralThreeReduction_mulVec, Matrix.mulVec_mulVec,
    sixAxisSourcePolarization_mul_cofactor, Matrix.smul_mulVec, Matrix.one_mulVec]
  funext index
  refine (integralThreeReduction_apply_eq_zero_iff _ index).mpr ?_
  exact ⟨2 * vector index, by simp [Pi.smul_apply]; ring⟩

/-- The kernel of the comparison is exactly the two-primary part of the
discriminant group. -/
theorem sixAxisSourceThreePrimaryComparison_ker :
    LinearMap.ker sixAxisSourceThreePrimaryComparison =
      sixAxisSourceDiscriminantPrimaryPart 2 := by
  ext element
  obtain ⟨vector, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  constructor
  · intro vanishing
    have divisibility : ∀ index : Fin 5 × Fin 2,
        (3 : ℤ) ∣ (sixAxisSourcePolarizationCofactor *ᵥ vector) index := by
      intro index
      refine (integralThreeReduction_apply_eq_zero_iff _ index).mp ?_
      have applied := LinearMap.mem_ker.mp vanishing
      rw [sixAxisSourceThreePrimaryComparison_mk] at applied
      exact congrFun applied index
    obtain ⟨third, equation⟩ := exists_smul_of_forall_dvd divisibility
    have polarized : (6 : ℤ) • vector = (3 : ℤ) • (sixAxisSourcePolarization ℤ *ᵥ third) := by
      calc (6 : ℤ) • vector
          = ((6 : ℤ) • (1 : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ)) *ᵥ vector := by
            rw [Matrix.smul_mulVec, Matrix.one_mulVec]
        _ = sixAxisSourcePolarization ℤ *ᵥ (sixAxisSourcePolarizationCofactor *ᵥ vector) := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarization_mul_cofactor]
        _ = (3 : ℤ) • (sixAxisSourcePolarization ℤ *ᵥ third) := by
            rw [equation, Matrix.mulVec_smul]
    have cancelled : (2 : ℤ) • vector = sixAxisSourcePolarization ℤ *ᵥ third := by
      refine smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (3 : ℤ) ≠ 0) ?_
      show (3 : ℤ) • ((2 : ℤ) • vector) = (3 : ℤ) • (sixAxisSourcePolarization ℤ *ᵥ third)
      rw [smul_smul, show (3 : ℤ) * 2 = 6 by norm_num]
      exact polarized
    refine mem_torsionBy_iff_smul_eq_zero.mpr ?_
    rw [← sixAxisSourceDiscriminant_mk_smul]
    exact (Submodule.Quotient.mk_eq_zero _).mpr (mem_latticeImage_iff.mpr ⟨third, cancelled.symm⟩)
  · intro membership
    have torsion : (2 : ℤ) • (Submodule.Quotient.mk vector : sixAxisSourceDiscriminantGroup) = 0 :=
      mem_torsionBy_iff_smul_eq_zero.mp membership
    rw [← sixAxisSourceDiscriminant_mk_smul] at torsion
    obtain ⟨source, equation⟩ :=
      mem_latticeImage_iff.mp ((Submodule.Quotient.mk_eq_zero _).mp torsion)
    have doubled : (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ vector) =
        (2 : ℤ) • ((3 : ℤ) • source) := by
      calc (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ vector)
          = sixAxisSourcePolarizationCofactor *ᵥ ((2 : ℤ) • vector) := by
            rw [Matrix.mulVec_smul]
        _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ source) := by
            rw [equation]
        _ = (6 : ℤ) • source := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
              Matrix.one_mulVec]
        _ = (2 : ℤ) • ((3 : ℤ) • source) := by rw [smul_smul]; norm_num
    have thirded : sixAxisSourcePolarizationCofactor *ᵥ vector = (3 : ℤ) • source :=
      smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (2 : ℤ) ≠ 0) doubled
    refine LinearMap.mem_ker.mpr ?_
    rw [sixAxisSourceThreePrimaryComparison_mk, thirded]
    funext index
    refine (integralThreeReduction_apply_eq_zero_iff _ index).mpr ?_
    exact ⟨source index, by simp [Pi.smul_apply]⟩

/-- The comparison is injective on the three-primary part of the discriminant
group, since the two primary parts meet only in zero. -/
theorem sixAxisSourceThreePrimaryComparison_injOn
    {left right : sixAxisSourceDiscriminantGroup}
    (leftMember : left ∈ sixAxisSourceDiscriminantPrimaryPart 3)
    (rightMember : right ∈ sixAxisSourceDiscriminantPrimaryPart 3)
    (equalImages : sixAxisSourceThreePrimaryComparison left =
      sixAxisSourceThreePrimaryComparison right) :
    left = right := by
  have differenceKernel : left - right ∈ LinearMap.ker sixAxisSourceThreePrimaryComparison := by
    refine LinearMap.mem_ker.mpr ?_
    rw [map_sub, equalImages, sub_self]
  have differenceMember : left - right ∈
      sixAxisSourceDiscriminantPrimaryPart 2 ⊓ sixAxisSourceDiscriminantPrimaryPart 3 :=
    Submodule.mem_inf.mpr
      ⟨sixAxisSourceThreePrimaryComparison_ker ▸ differenceKernel,
        Submodule.sub_mem _ leftMember rightMember⟩
  have vanishing : left - right = 0 := by
    rw [sixAxisSourceDiscriminant_primaryDecomposition.2.1] at differenceMember
    exact (Submodule.mem_bot ℤ).mp differenceMember
  exact sub_eq_zero.mp vanishing

/-- Every vector in the kernel of the reduced polarization is the comparison
image of a three-torsion class: an integral lift `w` has `F w` divisible by
three, say `F w = 3 u`, the class of `u` is three-torsion with cofactor image
`2 w`, and `2` is `-1` modulo three, so the class of `-u` is carried to the
reduction of `w`. -/
theorem sixAxisSourceThreePrimaryComparison_surjOn
    {target : Fin 5 × Fin 2 → F3} (membership : target ∈ sixAxisSourceThreePrimaryDiscriminant) :
    ∃ element ∈ sixAxisSourceDiscriminantPrimaryPart 3,
      sixAxisSourceThreePrimaryComparison element = target := by
  classical
  obtain ⟨lift, lifted⟩ : ∃ lift : Fin 5 × Fin 2 → ℤ, integralThreeReduction lift = target := by
    refine ⟨fun index ↦ (ZMod.cast (target index) : ℤ), ?_⟩
    funext index
    exact ZMod.intCast_zmod_cast (target index)
  have polarizedDivisible : ∀ index : Fin 5 × Fin 2,
      (3 : ℤ) ∣ (sixAxisSourcePolarization ℤ *ᵥ lift) index := by
    intro index
    refine (integralThreeReduction_apply_eq_zero_iff _ index).mp ?_
    rw [integralThreeReduction_mulVec, lifted]
    exact congrFun (LinearMap.mem_ker.mp membership) index
  obtain ⟨third, equation⟩ := exists_smul_of_forall_dvd polarizedDivisible
  have torsionMember : (Submodule.Quotient.mk third : sixAxisSourceDiscriminantGroup) ∈
      sixAxisSourceDiscriminantPrimaryPart 3 := by
    refine mem_torsionBy_iff_smul_eq_zero.mpr ?_
    rw [← sixAxisSourceDiscriminant_mk_smul]
    exact (Submodule.Quotient.mk_eq_zero _).mpr (mem_latticeImage_iff.mpr ⟨lift, equation⟩)
  have comparisonValue :
      sixAxisSourceThreePrimaryComparison (Submodule.Quotient.mk third) = -target := by
    have tripled : (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ third) =
        (3 : ℤ) • ((2 : ℤ) • lift) := by
      calc (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ third)
          = sixAxisSourcePolarizationCofactor *ᵥ ((3 : ℤ) • third) := by rw [Matrix.mulVec_smul]
        _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ lift) := by
            rw [← equation]
        _ = (6 : ℤ) • lift := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
              Matrix.one_mulVec]
        _ = (3 : ℤ) • ((2 : ℤ) • lift) := by rw [smul_smul]; norm_num
    have cofactorValue : sixAxisSourcePolarizationCofactor *ᵥ third = (2 : ℤ) • lift :=
      smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (3 : ℤ) ≠ 0) tripled
    rw [sixAxisSourceThreePrimaryComparison_mk, cofactorValue, map_smul, lifted]
    funext index
    show (2 : ℤ) • target index = -target index
    have two : ((2 : ℤ) : F3) = -1 := by decide
    rw [zsmul_eq_mul, two, neg_one_mul]
  refine ⟨-(Submodule.Quotient.mk third), Submodule.neg_mem _ torsionMember, ?_⟩
  rw [map_neg, comparisonValue, neg_neg]

/-- The comparison restricted to the three-primary part of the discriminant
group and valued in the kernel of the reduced polarization.  Both sides are
annihilated by three, so an additive map between them is automatically
`F₃`-linear. -/
def sixAxisSourceThreePrimaryRestriction :
    sixAxisSourceDiscriminantPrimaryPart 3 →+ sixAxisSourceThreePrimaryDiscriminant :=
  AddMonoidHom.mk'
    (fun element ↦
      ⟨sixAxisSourceThreePrimaryComparison element.1,
        sixAxisSourceThreePrimaryComparison_mem_kernel element.1⟩)
    (fun left right ↦ Subtype.ext (map_add sixAxisSourceThreePrimaryComparison left.1 right.1))

/-- The three-primary part of the discriminant group of the six-axis source
polarization is isomorphic to the kernel of the three-torsion reduction of that
polarization, by the reduction modulo three of the cofactor image. -/
noncomputable def sixAxisSourceThreePrimaryLatticeEquiv :
    sixAxisSourceDiscriminantPrimaryPart 3 ≃+ sixAxisSourceThreePrimaryDiscriminant :=
  AddEquiv.ofBijective sixAxisSourceThreePrimaryRestriction
    ⟨fun left right equalImages ↦
        Subtype.ext
          (sixAxisSourceThreePrimaryComparison_injOn left.2 right.2
            (congrArg Subtype.val equalImages)),
      fun target ↦ by
        obtain ⟨element, membership, value⟩ :=
          sixAxisSourceThreePrimaryComparison_surjOn target.2
        exact ⟨⟨element, membership⟩, Subtype.ext value⟩⟩

/-- The three-primary part of the discriminant group in the four normalized
coefficient coordinates with the rank-two three-torsion module as tensor
factor: the lattice-level form of the three-primary identification with
`H₃ ⊗ E[3]`. -/
noncomputable def sixAxisSourceThreePrimaryLatticeCoordinates :
    sixAxisSourceDiscriminantPrimaryPart 3 ≃+ (Fin 4 → Fin 2 → F3) :=
  sixAxisSourceThreePrimaryLatticeEquiv.trans
    sixAxisSourceThreePrimaryDiscriminantCoordinates.toAddEquiv

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
