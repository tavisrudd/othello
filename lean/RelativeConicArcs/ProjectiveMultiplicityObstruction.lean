import Mathlib.CategoryTheory.Preadditive.Projective.Basic
import Mathlib.CategoryTheory.Preadditive.Basic
import Mathlib.RepresentationTheory.Rep.Iso

/-!
# Lifting projective summands through a quadratic evaluation map

Let `evaluation : R ⟶ E` be an epimorphism in a category.  If a projective
object `Q` embeds in `E`, projectivity lifts that embedding to a morphism
`Q ⟶ R`; because its composite with `evaluation` is monic, the lift itself
is monic.  The same statement applied to `Q ⊞ Q` shows:

*if a target contains two copies of a projective object, then every object
surjecting onto that target also contains two copies.*

For a two-sheet quadratic evaluation module, the two copies arise from a
nonprincipal projective summand of the sheet permutation module.  Thus an
ambient theorem excluding two copies of every nonprincipal projective
summand rules those summands out.  This module formalizes the categorical
lifting implication; it does not assert the representation-specific
multiplicity bound for a conic quotient.
-/

namespace RelativeConicArcs.ProjectiveMultiplicityObstruction

open CategoryTheory CategoryTheory.Limits

noncomputable section

universe v u

variable {C : Type u} [Category.{v} C]

/-- A monomorphism from a projective object into the target of an
epimorphism lifts to a monomorphism into its source. -/
theorem projectiveMonomorphism_lifts
    {Q R E : C} [Projective Q]
    (evaluation : R ⟶ E) [Epi evaluation]
    (summand : Q ⟶ E) [Mono summand] :
    ∃ lift : Q ⟶ R, lift ≫ evaluation = summand ∧ Mono lift := by
  let lift := Projective.factorThru summand evaluation
  have hlift : lift ≫ evaluation = summand :=
    Projective.factorThru_comp summand evaluation
  haveI : Mono lift := mono_of_mono_fac hlift
  exact ⟨lift, hlift, inferInstance⟩

/-- If `Q ⊞ Q` embeds in the target of an epimorphism and is projective,
then two copies of `Q` embed in the source. -/
theorem twoProjectiveCopies_lift
    [HasZeroMorphisms C]
    {Q R E : C} [HasBinaryBiproduct Q Q] [Projective (Q ⊞ Q)]
    (evaluation : R ⟶ E) [Epi evaluation]
    (twoCopies : Q ⊞ Q ⟶ E) [Mono twoCopies] :
    ∃ lift : Q ⊞ Q ⟶ R, Mono lift := by
  obtain ⟨lift, _, hlift⟩ :=
    projectiveMonomorphism_lifts evaluation twoCopies
  exact ⟨lift, hlift⟩

/-- An object excludes two copies of `Q` when no morphism
`Q ⊞ Q ⟶ R` is monic. -/
def ExcludesTwoCopies
    [HasZeroMorphisms C]
    (Q R : C) [HasBinaryBiproduct Q Q] : Prop :=
  ∀ inclusion : Q ⊞ Q ⟶ R, ¬ Mono inclusion

/-- If the quadratic source excludes two copies of a projective object,
then no epimorphic quadratic evaluation target can contain two copies of
that object. -/
theorem target_excludesTwoProjectiveCopies
    [HasZeroMorphisms C]
    {Q R E : C} [HasBinaryBiproduct Q Q] [Projective (Q ⊞ Q)]
    (evaluation : R ⟶ E) [Epi evaluation]
    (hsource : ExcludesTwoCopies Q R) :
    ∀ inclusion : Q ⊞ Q ⟶ E, ¬ Mono inclusion := by
  intro inclusion hinclusion
  letI : Mono inclusion := hinclusion
  obtain ⟨lift, hlift⟩ :=
    twoProjectiveCopies_lift evaluation inclusion
  exact hsource lift hlift

/-! ### The two-sheet kernel -/

section TwoSheets

variable [CategoryTheory.Preadditive C] [CategoryTheory.Limits.HasBinaryBiproducts C]

/-- The two copies of `Q` inside two copies of `P₀ ⊞ Q`. -/
def nonprincipalCopies (P₀ Q : C) :
    Q ⊞ Q ⟶ (P₀ ⊞ Q) ⊞ (P₀ ⊞ Q) :=
  biprod.map biprod.inr biprod.inr

instance nonprincipalCopies_mono (P₀ Q : C) :
    Mono (nonprincipalCopies P₀ Q) := by
  dsimp [nonprincipalCopies]
  infer_instance

/-- If every morphism `Q ⟶ T` is zero, then any functional from two
copies of `P₀ ⊞ Q` to `T` vanishes on the two displayed copies of `Q`. -/
theorem nonprincipalCopies_comp_eq_zero
    {P₀ Q T : C}
    (functional : (P₀ ⊞ Q) ⊞ (P₀ ⊞ Q) ⟶ T)
    (horthogonal : ∀ f : Q ⟶ T, f = 0) :
    nonprincipalCopies P₀ Q ≫ functional = 0 := by
  apply biprod.hom_ext'
  · simpa [nonprincipalCopies, Category.assoc] using
      horthogonal (biprod.inl ≫ nonprincipalCopies P₀ Q ≫ functional)
  · simpa [nonprincipalCopies, Category.assoc] using
      horthogonal (biprod.inr ≫ nonprincipalCopies P₀ Q ≫ functional)

/-- Under the same orthogonality hypothesis, the kernel of a two-sheet
functional contains two copies of `Q`. -/
theorem twoNonprincipalCopies_embed_kernel
    {P₀ Q T : C}
    (functional : (P₀ ⊞ Q) ⊞ (P₀ ⊞ Q) ⟶ T)
    [HasKernel functional]
    (horthogonal : ∀ f : Q ⟶ T, f = 0) :
    ∃ inclusion : Q ⊞ Q ⟶ kernel functional, Mono inclusion := by
  let inclusion :=
    kernel.lift functional (nonprincipalCopies P₀ Q)
      (nonprincipalCopies_comp_eq_zero functional horthogonal)
  have hinclusion :
      inclusion ≫ kernel.ι functional = nonprincipalCopies P₀ Q :=
    kernel.lift_ι _ _ _
  haveI : Mono inclusion := mono_of_mono_fac hinclusion
  exact ⟨inclusion, inferInstance⟩

/-- If the quadratic source excludes two copies of a projective `Q`, it
cannot surject onto the kernel of a two-sheet functional whose nonprincipal
sheet summands are copies of `Q`. -/
theorem no_epimorphism_to_twoSheetKernel
    {P₀ Q T R : C} [Projective (Q ⊞ Q)]
    (functional : (P₀ ⊞ Q) ⊞ (P₀ ⊞ Q) ⟶ T)
    [HasKernel functional]
    (horthogonal : ∀ f : Q ⟶ T, f = 0)
    (hsource : ExcludesTwoCopies Q R) :
    ∀ evaluation : R ⟶ kernel functional, ¬ Epi evaluation := by
  intro evaluation hevaluation
  letI : Epi evaluation := hevaluation
  obtain ⟨inclusion, hinclusion⟩ :=
    twoNonprincipalCopies_embed_kernel functional horthogonal
  exact target_excludesTwoProjectiveCopies evaluation hsource inclusion hinclusion

end TwoSheets

/-! ### Specialization to finite-group representations -/

/-- If an epimorphic evaluation target contains two projective copies of
`Q`, their total dimension is a lower bound for the dimension of the
source.  This is the numerical form of `twoProjectiveCopies_lift` used by
finite computations of a concrete quadratic conic representation. -/
theorem representation_twoCopies_finrank_le_source
    {k G : Type*} [Field k] [Group G]
    {Q R E : Rep k G} [Projective (Q ⊞ Q)]
    [Module.Finite k (Q ⊞ Q).V] [Module.Finite k R.V]
    (evaluation : R ⟶ E) [Epi evaluation]
    (twoCopies : Q ⊞ Q ⟶ E) [Mono twoCopies] :
    Module.finrank k (Q ⊞ Q).V ≤ Module.finrank k R.V := by
  obtain ⟨lift, hlift⟩ :=
    twoProjectiveCopies_lift evaluation twoCopies
  have hinjective : Function.Injective lift.hom :=
    (Rep.mono_iff_injective lift).mp hlift
  exact lift.hom.finrank_le_finrank_of_injective hinjective

/-- A finite-dimensional representation cannot contain two copies of `Q`
when its underlying dimension is smaller than that of `Q ⊞ Q`. -/
theorem representation_excludesTwoCopies_of_finrank_lt
    {k G : Type*} [Field k] [Group G]
    {Q R : Rep k G}
    [Module.Finite k (Q ⊞ Q).V] [Module.Finite k R.V]
    (hdimension : Module.finrank k R.V < Module.finrank k (Q ⊞ Q).V) :
    ExcludesTwoCopies Q R := by
  intro inclusion hinclusion
  have hinjective : Function.Injective inclusion.hom :=
    (Rep.mono_iff_injective inclusion).mp hinclusion
  have hle : Module.finrank k (Q ⊞ Q).V ≤ Module.finrank k R.V :=
    inclusion.hom.finrank_le_finrank_of_injective hinjective
  omega

/-- In the category of representations of a group over a field, the
two-sheet obstruction applies verbatim.  To use it for a concrete quadratic
conic module one must supply projectivity of `Q ⊞ Q`, orthogonality
`Q ⟶ T = 0`, and the source multiplicity bound `ExcludesTwoCopies Q R`. -/
theorem representation_no_epimorphism_to_twoSheetKernel
    {k G : Type*} [Field k] [Group G]
    {P₀ Q T R : Rep k G} [Projective (Q ⊞ Q)]
    (functional : (P₀ ⊞ Q) ⊞ (P₀ ⊞ Q) ⟶ T)
    [HasKernel functional]
    (horthogonal : ∀ f : Q ⟶ T, f = 0)
    (hsource : ExcludesTwoCopies Q R) :
    ∀ evaluation : R ⟶ kernel functional, ¬ Epi evaluation :=
  no_epimorphism_to_twoSheetKernel functional horthogonal hsource

/-- A finite-dimensional quadratic source cannot surject onto a two-sheet
kernel containing two projective copies of `Q` when it is too small to
contain `Q ⊞ Q`. -/
theorem representation_no_epimorphism_of_finrank_lt
    {k G : Type*} [Field k] [Group G]
    {P₀ Q T R : Rep k G} [Projective (Q ⊞ Q)]
    [Module.Finite k (Q ⊞ Q).V] [Module.Finite k R.V]
    (functional : (P₀ ⊞ Q) ⊞ (P₀ ⊞ Q) ⟶ T)
    [HasKernel functional]
    (horthogonal : ∀ f : Q ⟶ T, f = 0)
    (hdimension : Module.finrank k R.V < Module.finrank k (Q ⊞ Q).V) :
    ∀ evaluation : R ⟶ kernel functional, ¬ Epi evaluation :=
  representation_no_epimorphism_to_twoSheetKernel functional horthogonal
    (representation_excludesTwoCopies_of_finrank_lt hdimension)

end

end RelativeConicArcs.ProjectiveMultiplicityObstruction
