import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisPrimaryDiscriminantSplitting

/-!
# The two-primary part of the source discriminant as the kernel of the reduced polarization

Two models of the two-primary discriminant of the six-axis source occur in this
development.  One is the two-torsion part of the discriminant group, that is of
the cokernel of the integral source polarization on the standard lattice.  The
other is the kernel of the same polarization reduced modulo two, an
`F₂`-subspace of `F₂^ι` for `ι` an axis together with an elliptic homology
coordinate; it is the model in which the coefficient heart, the rank-eight
tensor form, and the classification of stable maximal-isotropic subspaces are
formalized.  This module identifies them.

The comparison map is division free.  The polarization `F` has an integral
cofactor `C` with `F C = C F = 6`, so the reduction modulo two of `C v` depends
only on the class of `v` in the cokernel, and gives an additive map from the
discriminant group to `F₂^ι`.  Its image lies in the kernel of the reduced
polarization because `F C v = 6 v` is even; its kernel is exactly the
three-primary part of the discriminant group, because `C v = 2 z` forces
`3 v = F z` and conversely; and it is onto the kernel of the reduced
polarization, because an integral lift `w` of a kernel vector has `F w` even,
say `F w = 2 u`, and then the class of `u` is two-torsion with `C u = 3 w`,
which reduces to `w` modulo two.

Results.  The comparison map has kernel the three-primary part and image the
kernel of the reduced polarization, and it therefore restricts to an
isomorphism from the two-primary part of the discriminant group onto that
kernel.  Composing with the coordinates already available on the kernel
presents the two-primary part of the discriminant group as four copies of the
rank-two two-torsion module.

Trust boundary.  Every statement is about explicit integral and `F₂` matrices
and finite abelian groups.  No abelian scheme, elliptic scheme, isogeny, Weil
pairing, torsion local system, or geometric commutator pairing is constructed,
and the identification of these lattice-level objects with geometric ones is
supplied elsewhere.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Kronecker
open scoped Matrix

/-- Reducing the entries of the integral source polarization modulo two gives
the two-torsion source polarization. -/
theorem sixAxisSourcePolarization_map_intCast :
    (sixAxisSourcePolarization ℤ).map (Int.castRingHom F2) = sixAxisSourcePolarization F2 := by
  ext row column
  obtain ⟨axis, spin⟩ := row
  obtain ⟨otherAxis, otherSpin⟩ := column
  rw [Matrix.map_apply, sixAxisSourcePolarization_apply, sixAxisSourcePolarization_apply,
    map_mul]
  refine congrArg₂ (· * ·) ?_ ?_
  · show ((6 * (if axis = otherAxis then (1 : ℤ) else 0) - 1 : ℤ) : F2) =
      6 * (if axis = otherAxis then (1 : F2) else 0) - 1
    by_cases equalAxes : axis = otherAxis
    · simp only [equalAxes]
      decide
    · simp [equalAxes]
  · fin_cases spin <;> fin_cases otherSpin <;>
      simp [ellipticWeilPairing]

/-- Reduction of integral vectors modulo two, coordinatewise. -/
def integralTwoReduction : (Fin 5 × Fin 2 → ℤ) →ₗ[ℤ] (Fin 5 × Fin 2 → F2) where
  toFun vector := fun index ↦ ((vector index : ℤ) : F2)
  map_add' := by
    intro first second
    funext index
    exact Int.cast_add _ _
  map_smul' := by
    intro scalar vector
    funext index
    simp [zsmul_eq_mul]

/-- Reduction commutes with multiplication by the source polarization. -/
theorem integralTwoReduction_mulVec (vector : Fin 5 × Fin 2 → ℤ) :
    integralTwoReduction (sixAxisSourcePolarization ℤ *ᵥ vector) =
      sixAxisSourcePolarization F2 *ᵥ integralTwoReduction vector := by
  funext index
  have reduced := RingHom.map_mulVec (Int.castRingHom F2) (sixAxisSourcePolarization ℤ)
    vector index
  rw [sixAxisSourcePolarization_map_intCast] at reduced
  exact reduced

/-- A reduced coordinate vanishes exactly when the integer is even. -/
theorem integralTwoReduction_apply_eq_zero_iff (vector : Fin 5 × Fin 2 → ℤ)
    (index : Fin 5 × Fin 2) :
    integralTwoReduction vector index = 0 ↔ (2 : ℤ) ∣ vector index := by
  show ((vector index : ℤ) : F2) = 0 ↔ (2 : ℤ) ∣ vector index
  rw [ZMod.intCast_zmod_eq_zero_iff_dvd]
  norm_num

/-- The comparison of the two models: the reduction modulo two of the cofactor
image of a representative.  The cofactor identity `C F = 6` makes it depend
only on the class in the discriminant group. -/
def sixAxisSourceTwoPrimaryComparison :
    sixAxisSourceDiscriminantGroup →ₗ[ℤ] (Fin 5 × Fin 2 → F2) :=
  Submodule.liftQ _
    (integralTwoReduction.comp (Matrix.mulVecLin sixAxisSourcePolarizationCofactor))
    (by
      intro vector membership
      obtain ⟨source, rfl⟩ := mem_latticeImage_iff.mp membership
      refine LinearMap.mem_ker.mpr ?_
      show integralTwoReduction (sixAxisSourcePolarizationCofactor *ᵥ
        (sixAxisSourcePolarization ℤ *ᵥ source)) = 0
      rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
        Matrix.one_mulVec]
      funext index
      refine (integralTwoReduction_apply_eq_zero_iff _ index).mpr ?_
      exact ⟨3 * source index, by simp [Pi.smul_apply]; ring⟩)

/-- The comparison computes on the class of a representative. -/
theorem sixAxisSourceTwoPrimaryComparison_mk (vector : Fin 5 × Fin 2 → ℤ) :
    sixAxisSourceTwoPrimaryComparison (Submodule.Quotient.mk vector) =
      integralTwoReduction (sixAxisSourcePolarizationCofactor *ᵥ vector) :=
  rfl

/-- The comparison lands in the kernel of the reduced polarization, because
the cofactor identity makes the polarization of a cofactor image even. -/
theorem sixAxisSourceTwoPrimaryComparison_mem_kernel
    (element : sixAxisSourceDiscriminantGroup) :
    sixAxisSourceTwoPrimaryComparison element ∈ sixAxisSourceTwoPrimaryDiscriminant := by
  obtain ⟨vector, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  refine LinearMap.mem_ker.mpr ?_
  rw [Matrix.mulVecLin_apply, sixAxisSourceTwoPrimaryComparison_mk,
    ← integralTwoReduction_mulVec, Matrix.mulVec_mulVec,
    sixAxisSourcePolarization_mul_cofactor, Matrix.smul_mulVec, Matrix.one_mulVec]
  funext index
  refine (integralTwoReduction_apply_eq_zero_iff _ index).mpr ?_
  exact ⟨3 * vector index, by simp [Pi.smul_apply]; ring⟩

/-- The kernel of the comparison is exactly the three-primary part of the
discriminant group. -/
theorem sixAxisSourceTwoPrimaryComparison_ker :
    LinearMap.ker sixAxisSourceTwoPrimaryComparison =
      sixAxisSourceDiscriminantPrimaryPart 3 := by
  ext element
  obtain ⟨vector, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  constructor
  · intro vanishing
    have divisibility : ∀ index : Fin 5 × Fin 2,
        (2 : ℤ) ∣ (sixAxisSourcePolarizationCofactor *ᵥ vector) index := by
      intro index
      refine (integralTwoReduction_apply_eq_zero_iff _ index).mp ?_
      have applied := LinearMap.mem_ker.mp vanishing
      rw [sixAxisSourceTwoPrimaryComparison_mk] at applied
      exact congrFun applied index
    obtain ⟨half, equation⟩ := exists_smul_of_forall_dvd divisibility
    have polarized : (6 : ℤ) • vector = (2 : ℤ) • (sixAxisSourcePolarization ℤ *ᵥ half) := by
      calc (6 : ℤ) • vector
          = ((6 : ℤ) • (1 : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ)) *ᵥ vector := by
            rw [Matrix.smul_mulVec, Matrix.one_mulVec]
        _ = sixAxisSourcePolarization ℤ *ᵥ (sixAxisSourcePolarizationCofactor *ᵥ vector) := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarization_mul_cofactor]
        _ = (2 : ℤ) • (sixAxisSourcePolarization ℤ *ᵥ half) := by
            rw [equation, Matrix.mulVec_smul]
    have cancelled : (3 : ℤ) • vector = sixAxisSourcePolarization ℤ *ᵥ half := by
      refine smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (2 : ℤ) ≠ 0) ?_
      show (2 : ℤ) • ((3 : ℤ) • vector) = (2 : ℤ) • (sixAxisSourcePolarization ℤ *ᵥ half)
      rw [smul_smul, show (2 : ℤ) * 3 = 6 by norm_num]
      exact polarized
    refine mem_torsionBy_iff_smul_eq_zero.mpr ?_
    rw [← sixAxisSourceDiscriminant_mk_smul]
    exact (Submodule.Quotient.mk_eq_zero _).mpr (mem_latticeImage_iff.mpr ⟨half, cancelled.symm⟩)
  · intro membership
    have torsion : (3 : ℤ) • (Submodule.Quotient.mk vector : sixAxisSourceDiscriminantGroup) = 0 :=
      mem_torsionBy_iff_smul_eq_zero.mp membership
    rw [← sixAxisSourceDiscriminant_mk_smul] at torsion
    obtain ⟨source, equation⟩ :=
      mem_latticeImage_iff.mp ((Submodule.Quotient.mk_eq_zero _).mp torsion)
    have tripled : (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ vector) =
        (2 : ℤ) • ((3 : ℤ) • source) := by
      calc (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ vector)
          = sixAxisSourcePolarizationCofactor *ᵥ ((3 : ℤ) • vector) := by
            rw [Matrix.mulVec_smul]
        _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ source) := by
            rw [equation]
        _ = (6 : ℤ) • source := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
              Matrix.one_mulVec]
        _ = (2 : ℤ) • ((3 : ℤ) • source) := by rw [smul_smul]; norm_num
    have halved : sixAxisSourcePolarizationCofactor *ᵥ vector = (2 : ℤ) • source := by
      refine smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (3 : ℤ) ≠ 0) ?_
      show (3 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ vector) =
        (3 : ℤ) • ((2 : ℤ) • source)
      rw [tripled, smul_comm]
    refine LinearMap.mem_ker.mpr ?_
    rw [sixAxisSourceTwoPrimaryComparison_mk, halved]
    funext index
    refine (integralTwoReduction_apply_eq_zero_iff _ index).mpr ?_
    exact ⟨source index, by simp [Pi.smul_apply]⟩

/-- The comparison is injective on the two-primary part of the discriminant
group, since the two primary parts meet only in zero. -/
theorem sixAxisSourceTwoPrimaryComparison_injOn
    {left right : sixAxisSourceDiscriminantGroup}
    (leftMember : left ∈ sixAxisSourceDiscriminantPrimaryPart 2)
    (rightMember : right ∈ sixAxisSourceDiscriminantPrimaryPart 2)
    (equalImages : sixAxisSourceTwoPrimaryComparison left =
      sixAxisSourceTwoPrimaryComparison right) :
    left = right := by
  have differenceKernel : left - right ∈ LinearMap.ker sixAxisSourceTwoPrimaryComparison := by
    refine LinearMap.mem_ker.mpr ?_
    rw [map_sub, equalImages, sub_self]
  have differenceMember : left - right ∈
      sixAxisSourceDiscriminantPrimaryPart 2 ⊓ sixAxisSourceDiscriminantPrimaryPart 3 :=
    Submodule.mem_inf.mpr
      ⟨Submodule.sub_mem _ leftMember rightMember,
        sixAxisSourceTwoPrimaryComparison_ker ▸ differenceKernel⟩
  have vanishing : left - right = 0 := by
    rw [sixAxisSourceDiscriminant_primaryDecomposition.2.1] at differenceMember
    exact (Submodule.mem_bot ℤ).mp differenceMember
  exact sub_eq_zero.mp vanishing

/-- Every vector in the kernel of the reduced polarization is the comparison
image of a two-torsion class: an integral lift `w` has `F w` even, say
`F w = 2 u`, and the class of `u` is two-torsion with cofactor image `3 w`. -/
theorem sixAxisSourceTwoPrimaryComparison_surjOn
    {target : Fin 5 × Fin 2 → F2} (membership : target ∈ sixAxisSourceTwoPrimaryDiscriminant) :
    ∃ element ∈ sixAxisSourceDiscriminantPrimaryPart 2,
      sixAxisSourceTwoPrimaryComparison element = target := by
  classical
  obtain ⟨lift, lifted⟩ : ∃ lift : Fin 5 × Fin 2 → ℤ, integralTwoReduction lift = target := by
    refine ⟨fun index ↦ (ZMod.cast (target index) : ℤ), ?_⟩
    funext index
    exact ZMod.intCast_zmod_cast (target index)
  have polarizedEven : ∀ index : Fin 5 × Fin 2,
      (2 : ℤ) ∣ (sixAxisSourcePolarization ℤ *ᵥ lift) index := by
    intro index
    refine (integralTwoReduction_apply_eq_zero_iff _ index).mp ?_
    rw [integralTwoReduction_mulVec, lifted]
    exact congrFun (LinearMap.mem_ker.mp membership) index
  obtain ⟨half, equation⟩ := exists_smul_of_forall_dvd polarizedEven
  refine ⟨Submodule.Quotient.mk half, ?_, ?_⟩
  · refine mem_torsionBy_iff_smul_eq_zero.mpr ?_
    rw [← sixAxisSourceDiscriminant_mk_smul]
    exact (Submodule.Quotient.mk_eq_zero _).mpr (mem_latticeImage_iff.mpr ⟨lift, equation⟩)
  · have tripled : (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ half) =
        (2 : ℤ) • ((3 : ℤ) • lift) := by
      calc (2 : ℤ) • (sixAxisSourcePolarizationCofactor *ᵥ half)
          = sixAxisSourcePolarizationCofactor *ᵥ ((2 : ℤ) • half) := by rw [Matrix.mulVec_smul]
        _ = sixAxisSourcePolarizationCofactor *ᵥ (sixAxisSourcePolarization ℤ *ᵥ lift) := by
            rw [← equation]
        _ = (6 : ℤ) • lift := by
            rw [Matrix.mulVec_mulVec, sixAxisSourcePolarizationCofactor_mul, Matrix.smul_mulVec,
              Matrix.one_mulVec]
        _ = (2 : ℤ) • ((3 : ℤ) • lift) := by rw [smul_smul]; norm_num
    have cofactorValue : sixAxisSourcePolarizationCofactor *ᵥ half = (3 : ℤ) • lift :=
      smul_right_injective (Fin 5 × Fin 2 → ℤ) (by norm_num : (2 : ℤ) ≠ 0) tripled
    rw [sixAxisSourceTwoPrimaryComparison_mk, cofactorValue, map_smul, lifted]
    funext index
    show (3 : ℤ) • target index = target index
    have three : ((3 : ℤ) : F2) = 1 := by decide
    rw [zsmul_eq_mul, three, one_mul]

/-- The comparison restricted to the two-primary part of the discriminant
group and valued in the kernel of the reduced polarization.  Both sides are
annihilated by two, so an additive map between them is automatically
`F₂`-linear. -/
def sixAxisSourceTwoPrimaryRestriction :
    sixAxisSourceDiscriminantPrimaryPart 2 →+ sixAxisSourceTwoPrimaryDiscriminant :=
  AddMonoidHom.mk'
    (fun element ↦
      ⟨sixAxisSourceTwoPrimaryComparison element.1,
        sixAxisSourceTwoPrimaryComparison_mem_kernel element.1⟩)
    (fun left right ↦ Subtype.ext (map_add sixAxisSourceTwoPrimaryComparison left.1 right.1))

/-- The two-primary part of the discriminant group of the six-axis source
polarization is isomorphic to the kernel of the two-torsion reduction of that
polarization, by the reduction modulo two of the cofactor image. -/
noncomputable def sixAxisSourceTwoPrimaryLatticeEquiv :
    sixAxisSourceDiscriminantPrimaryPart 2 ≃+ sixAxisSourceTwoPrimaryDiscriminant :=
  AddEquiv.ofBijective sixAxisSourceTwoPrimaryRestriction
    ⟨fun left right equalImages ↦
        Subtype.ext
          (sixAxisSourceTwoPrimaryComparison_injOn left.2 right.2
            (congrArg Subtype.val equalImages)),
      fun target ↦ by
        obtain ⟨element, membership, value⟩ :=
          sixAxisSourceTwoPrimaryComparison_surjOn target.2
        exact ⟨⟨element, membership⟩, Subtype.ext value⟩⟩

/-- The two-primary part of the discriminant group in the four normalized
coefficient coordinates with the rank-two two-torsion module as tensor factor:
the lattice-level form of the two-primary identification with `H₂ ⊗ E[2]`. -/
noncomputable def sixAxisSourceTwoPrimaryLatticeCoordinates :
    sixAxisSourceDiscriminantPrimaryPart 2 ≃+ (Fin 4 → Fin 2 → F2) :=
  sixAxisSourceTwoPrimaryLatticeEquiv.trans
    sixAxisSourceTwoPrimaryDiscriminantCoordinates.toAddEquiv

/-- The two-primary part of the discriminant group has order `2⁸`: it is
isomorphic to four copies of the rank-two two-torsion module. -/
theorem natCard_sixAxisSourceDiscriminantPrimaryPart_two :
    Nat.card (sixAxisSourceDiscriminantPrimaryPart 2) = 2 ^ 8 := by
  classical
  rw [Nat.card_congr sixAxisSourceTwoPrimaryLatticeCoordinates.toEquiv,
    Nat.card_eq_fintype_card]
  simp [Fintype.card_fun]

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
