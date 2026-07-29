import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas
import Mathlib.LinearAlgebra.Goursat

/-!
# The common quotient of two evaluation maps

Let `positive : R →ₗ[k] P` and `negative : R →ₗ[k] N` be surjective
evaluation maps onto two sheets.  Their combined image is a subdirect
product of `P × N`.  Linear Goursat theory identifies the dependence
between the sheets with a common quotient.

In finite dimension, the codimension of the combined image is exactly

`finrank (R ⧸ (ker positive ⊔ ker negative))`.

Consequently, a unique trade is equivalent to this common quotient having
dimension one.  This statement does not impose a semisimplicity or
projectivity hypothesis.
-/

namespace RelativeConicArcs.TwoSheetCommonQuotient

open Function LinearMap

noncomputable section

variable {k R P N : Type*} [Field k]
  [AddCommGroup R] [Module k R]
  [AddCommGroup P] [Module k P]
  [AddCommGroup N] [Module k N]

/-- The simultaneous image of the two sheet-evaluation maps. -/
def combinedRange (positive : R →ₗ[k] P) (negative : R →ₗ[k] N) :
    Submodule k (P × N) :=
  LinearMap.range (positive.prod negative)

/-- If the positive evaluation is onto, the combined image projects onto
the positive sheet. -/
theorem combinedRange_fst_surjective
    (positive : R →ₗ[k] P) (negative : R →ₗ[k] N)
    (hpositive : Function.Surjective positive) :
    Function.Surjective
      (Prod.fst ∘ (combinedRange positive negative).subtype) := by
  intro p
  obtain ⟨r, hr⟩ := hpositive p
  let point : combinedRange positive negative :=
    ⟨(positive.prod negative) r, LinearMap.mem_range.mpr ⟨r, rfl⟩⟩
  exact ⟨point, hr⟩

/-- If the negative evaluation is onto, the combined image projects onto
the negative sheet. -/
theorem combinedRange_snd_surjective
    (positive : R →ₗ[k] P) (negative : R →ₗ[k] N)
    (hnegative : Function.Surjective negative) :
    Function.Surjective
      (Prod.snd ∘ (combinedRange positive negative).subtype) := by
  intro n
  obtain ⟨r, hr⟩ := hnegative n
  let point : combinedRange positive negative :=
    ⟨(positive.prod negative) r, LinearMap.mem_range.mpr ⟨r, rfl⟩⟩
  exact ⟨point, hr⟩

/-- Goursat's lemma applied to two surjective sheet evaluations: their
combined image is the graph of an isomorphism between quotient sheets. -/
theorem combinedRange_goursat
    (positive : R →ₗ[k] P) (negative : R →ₗ[k] N)
    (hpositive : Function.Surjective positive)
    (hnegative : Function.Surjective negative) :
    ∃ e :
        (P ⧸ (combinedRange positive negative).goursatFst) ≃ₗ[k]
          N ⧸ (combinedRange positive negative).goursatSnd,
      LinearMap.range
          (((combinedRange positive negative).goursatFst.mkQ.prodMap
              (combinedRange positive negative).goursatSnd.mkQ).comp
            (combinedRange positive negative).subtype) =
        e.graph :=
  Submodule.goursat_surjective
    (combinedRange_fst_surjective positive negative hpositive)
    (combinedRange_snd_surjective positive negative hnegative)

/-- The trade dimension of two surjective evaluations equals the dimension
of their common source quotient. -/
theorem finrank_combinedRange_quotient_eq_finrank_kernelSup_quotient
    [Module.Finite k R] [Module.Finite k P] [Module.Finite k N]
    (positive : R →ₗ[k] P) (negative : R →ₗ[k] N)
    (hpositive : Function.Surjective positive)
    (hnegative : Function.Surjective negative) :
    Module.finrank k ((P × N) ⧸ combinedRange positive negative) =
      Module.finrank k
        (R ⧸ (LinearMap.ker positive ⊔ LinearMap.ker negative)) := by
  have hp := positive.finrank_range_add_finrank_ker
  have hn := negative.finrank_range_add_finrank_ker
  have hc := (positive.prod negative).finrank_range_add_finrank_ker
  rw [LinearMap.range_eq_top.mpr hpositive] at hp
  rw [LinearMap.range_eq_top.mpr hnegative] at hn
  simp only [finrank_top] at hp hn
  rw [LinearMap.ker_prod] at hc
  have hsup :=
    Submodule.finrank_sup_add_finrank_inf_eq
      (LinearMap.ker positive) (LinearMap.ker negative)
  have htarget :=
    (combinedRange positive negative).finrank_quotient_add_finrank
  have hsource :=
    (LinearMap.ker positive ⊔ LinearMap.ker negative).finrank_quotient_add_finrank
  change
    Module.finrank k
          ((P × N) ⧸ LinearMap.range (positive.prod negative)) +
        Module.finrank k (LinearMap.range (positive.prod negative)) =
      Module.finrank k (P × N) at htarget
  rw [Module.finrank_prod] at htarget
  change
    Module.finrank k (LinearMap.range (positive.prod negative)) +
        Module.finrank k
          (LinearMap.ker positive ⊓ LinearMap.ker negative : Submodule k R) =
      Module.finrank k R at hc
  change
    Module.finrank k ((P × N) ⧸ LinearMap.range (positive.prod negative)) =
      Module.finrank k
        (R ⧸ (LinearMap.ker positive ⊔ LinearMap.ker negative))
  omega

/-- For two surjective sheet evaluations, having a one-dimensional trade
space is equivalent to having a one-dimensional common quotient. -/
theorem uniqueTrade_iff_commonQuotient_finrank_eq_one
    [Module.Finite k R] [Module.Finite k P] [Module.Finite k N]
    (positive : R →ₗ[k] P) (negative : R →ₗ[k] N)
    (hpositive : Function.Surjective positive)
    (hnegative : Function.Surjective negative) :
    Module.finrank k ((P × N) ⧸ combinedRange positive negative) = 1 ↔
      Module.finrank k
        (R ⧸ (LinearMap.ker positive ⊔ LinearMap.ker negative)) = 1 := by
  rw [
    finrank_combinedRange_quotient_eq_finrank_kernelSup_quotient
      positive negative hpositive hnegative
  ]

/-- A common quotient of dimension at least two forces at least two
independent trades. -/
theorem two_le_tradeDimension_of_two_le_commonQuotient
    [Module.Finite k R] [Module.Finite k P] [Module.Finite k N]
    (positive : R →ₗ[k] P) (negative : R →ₗ[k] N)
    (hpositive : Function.Surjective positive)
    (hnegative : Function.Surjective negative)
    (hcommon :
      2 ≤ Module.finrank k
        (R ⧸ (LinearMap.ker positive ⊔ LinearMap.ker negative))) :
    2 ≤ Module.finrank k ((P × N) ⧸ combinedRange positive negative) := by
  rwa [
    finrank_combinedRange_quotient_eq_finrank_kernelSup_quotient
      positive negative hpositive hnegative
  ]

/-! ### A simple factor surviving in the trade kernel -/

variable {S T : Type*}
  [AddCommGroup S] [Module k S]
  [AddCommGroup T] [Module k T]

/-- Put scalar multiples of the same sheet submodule into the two
coordinates. -/
def pairedCopy (inclusion : S →ₗ[k] P) (a b : k) :
    S →ₗ[k] P × P :=
  (a • inclusion).prod (b • inclusion)

/-- A paired copy is injective as soon as the original inclusion is
injective and its two coefficients are not both zero. -/
theorem pairedCopy_injective
    (inclusion : S →ₗ[k] P) (hinclusion : Function.Injective inclusion)
    (a b : k) (hcoefficients : a ≠ 0 ∨ b ≠ 0) :
    Function.Injective (pairedCopy inclusion a b) := by
  intro x y hxy
  rcases hcoefficients with ha | hb
  · apply hinclusion
    have hfirst : a • inclusion x = a • inclusion y := by
      simpa [pairedCopy] using congrArg Prod.fst hxy
    have hzero : a • (inclusion x - inclusion y) = 0 := by
      rw [smul_sub, hfirst, sub_self]
    exact sub_eq_zero.mp ((smul_eq_zero.mp hzero).resolve_left ha)
  · apply hinclusion
    have hsecond : b • inclusion x = b • inclusion y := by
      simpa [pairedCopy] using congrArg Prod.snd hxy
    have hzero : b • (inclusion x - inclusion y) = 0 := by
      rw [smul_sub, hsecond, sub_self]
    exact sub_eq_zero.mp ((smul_eq_zero.mp hzero).resolve_left hb)

/-- If a nonzero scalar combination of the two sheet copies has zero
quadratic moments, that copy lies in the trade kernel. -/
theorem pairedCopy_range_le_tradeKernel
    (moments : P × P →ₗ[k] T)
    (inclusion : S →ₗ[k] P) (a b : k)
    (hrelation : moments.comp (pairedCopy inclusion a b) = 0) :
    LinearMap.range (pairedCopy inclusion a b) ≤ LinearMap.ker moments := by
  rintro _ ⟨x, rfl⟩
  change moments (pairedCopy inclusion a b x) = 0
  simpa using LinearMap.congr_fun hrelation x

/-- A surviving paired copy gives the corresponding lower bound on the
trade dimension. -/
theorem finrank_le_tradeKernel_of_pairedCopy
    (moments : P × P →ₗ[k] T)
    [Module.Finite k S] [Module.Finite k (LinearMap.ker moments)]
    (inclusion : S →ₗ[k] P) (hinclusion : Function.Injective inclusion)
    (a b : k) (hcoefficients : a ≠ 0 ∨ b ≠ 0)
    (hrelation : moments.comp (pairedCopy inclusion a b) = 0) :
    Module.finrank k S ≤ Module.finrank k (LinearMap.ker moments) := by
  let surviving : S →ₗ[k] LinearMap.ker moments :=
    (pairedCopy inclusion a b).codRestrict
      (LinearMap.ker moments)
      (fun c =>
        pairedCopy_range_le_tradeKernel moments inclusion a b hrelation
          (LinearMap.mem_range.mpr ⟨c, rfl⟩))
  have hinjective : Function.Injective surviving := by
    intro x y hxy
    apply pairedCopy_injective inclusion hinclusion a b hcoefficients
    exact congrArg Subtype.val hxy
  exact surviving.finrank_le_finrank_of_injective hinjective

end

end RelativeConicArcs.TwoSheetCommonQuotient
