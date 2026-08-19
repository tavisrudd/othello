import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.IntegralDiscriminantGroup
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixAxisSourcePolarization

/-!
# The discriminant group of the six-axis source polarization

The six-axis source polarization is the Kronecker product of the five-axis
coefficient matrix `6I₅-J₅` with the standard alternating rank-two pairing on
the integral first homology of an elliptic curve, indexed by an axis together
with a homology coordinate.  It is alternating with determinant `6⁸`, so the
general theory of discriminant groups of integral alternating lattices applies
to it.

Results.  Its discriminant group, the dual quotient `Λ^#/Λ` in the cokernel
presentation, is finite of order `6⁸`, and carries a nondegenerate `ℚ/ℤ`-valued
discriminant pairing.  If an integral comparison matrix pulls a unimodular
alternating form back to the source polarization, its cokernel embeds in that
group with image of order `6⁴`; the image is isotropic, equal to its own
orthogonal complement, and therefore maximal isotropic, and its order is the
square root of the order of the discriminant group.

Trust boundary.  For a relative isogeny of polarized abelian schemes inducing
the comparison matrix on integral first homology, these are the order of the
kernel of the source polarization, the degree of the isogeny, and maximal
isotropy of its kernel.  No abelian scheme, elliptic scheme, isogeny, Weil
pairing, or geometric commutator pairing is constructed here: every statement
is about explicit integral matrices and finite abelian groups, and the
identification of those matrices with maps induced by geometry is supplied
elsewhere.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Matrix

/-- The integral six-axis source polarization is nondegenerate. -/
theorem sixAxisSourcePolarization_det_ne_zero : (sixAxisSourcePolarization ℤ).det ≠ 0 := by
  rw [sixAxisSourcePolarization_det]
  norm_num

/-- The discriminant group of the six-axis source polarization: the dual
quotient of the integral source lattice by itself, presented as the cokernel of
the polarization. -/
abbrev sixAxisSourceDiscriminantGroup : Type :=
  discriminantGroup (sixAxisSourcePolarization ℤ)

/-- The discriminant pairing of the six-axis source polarization, valued in
`ℚ/ℤ`. -/
noncomputable def sixAxisSourceDiscriminantPairing :
    sixAxisSourceDiscriminantGroup →ₗ[ℤ] sixAxisSourceDiscriminantGroup →ₗ[ℤ] RationalsModOne :=
  discriminantPairing (sixAxisSourcePolarization_transpose ℤ) sixAxisSourcePolarization_det_ne_zero

/-- The discriminant pairing of the six-axis source polarization is
nondegenerate. -/
theorem sixAxisSourceDiscriminantPairing_eq_zero_of_forall
    {element : sixAxisSourceDiscriminantGroup}
    (orthogonal : ∀ other : sixAxisSourceDiscriminantGroup,
      sixAxisSourceDiscriminantPairing element other = 0) :
    element = 0 :=
  discriminantPairing_eq_zero_of_forall (sixAxisSourcePolarization_transpose ℤ)
    sixAxisSourcePolarization_det_ne_zero orthogonal

/-- The discriminant group of the six-axis source polarization has order `6⁸`.
This is the lattice-level form of the manuscript's order of the kernel of the
source polarization. -/
theorem natCard_sixAxisSourceDiscriminantGroup :
    Nat.card sixAxisSourceDiscriminantGroup = 6 ^ 8 := by
  rw [natCard_integralCokernel sixAxisSourcePolarization_det_ne_zero,
    sixAxisSourcePolarization_det]
  rfl

section Comparison

variable {comparison target : Matrix (Fin 5 × Fin 2) (Fin 5 × Fin 2) ℤ}

/-- The image in the discriminant group of the cokernel of a comparison matrix
pulling a unimodular form back to the six-axis source polarization has order
`6⁴`.  This is the lattice-level form of the degree of the corresponding
relative isogeny. -/
theorem natCard_sixAxisSourceKernelSubgroup (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Nat.card (comparisonKernelSubgroup pullback) = 6 ^ 4 := by
  rw [natCard_comparisonKernelSubgroup principal
      (sixAxisPolarizationPullback_det_ne_zero principal pullback) pullback,
    sixAxisPolarizationPullback_natAbs_det principal pullback]

/-- That subgroup is exactly its own orthogonal complement for the discriminant
pairing. -/
theorem sixAxisSourceKernelSubgroup_eq_perp (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    comparisonKernelSubgroup pullback =
      discriminantPerp (sixAxisSourcePolarization_transpose ℤ)
        sixAxisSourcePolarization_det_ne_zero (comparisonKernelSubgroup pullback) :=
  comparisonKernelSubgroup_eq_perp (sixAxisSourcePolarization_transpose ℤ)
    sixAxisSourcePolarization_det_ne_zero principal pullback

/-- The lattice model of the kernel of the relative isogeny is a maximal
isotropic subgroup of the discriminant group of the six-axis source
polarization. -/
theorem sixAxisSourceKernelSubgroup_isMaximalIsotropic (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    IsMaximalIsotropicSubgroup (sixAxisSourcePolarization_transpose ℤ)
      sixAxisSourcePolarization_det_ne_zero (comparisonKernelSubgroup pullback) :=
  comparisonKernelSubgroup_isMaximalIsotropic (sixAxisSourcePolarization_transpose ℤ)
    sixAxisSourcePolarization_det_ne_zero principal pullback

/-- The kernel subgroup has square-root order in the discriminant group: `6⁴`
against `6⁸`. -/
theorem natCard_sixAxisSourceDiscriminantGroup_eq_sq (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = sixAxisSourcePolarization ℤ) :
    Nat.card sixAxisSourceDiscriminantGroup =
      Nat.card (comparisonKernelSubgroup pullback) ^ 2 :=
  natCard_discriminantGroup_eq_sq principal
    (sixAxisPolarizationPullback_det_ne_zero principal pullback) pullback

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
