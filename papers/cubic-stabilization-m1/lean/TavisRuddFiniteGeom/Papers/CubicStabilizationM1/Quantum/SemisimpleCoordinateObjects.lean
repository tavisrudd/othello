import Mathlib.Tactic
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.CategoryTheory.Category.Basic

/-!
# Objects and doubled cancellation in an explicit semisimple category

Fix a set of simple labels and a division ring for each label. An object is
a finite-support family of finite-dimensional left vector spaces over those
division rings; its morphisms and isomorphisms are componentwise linear maps
and linear equivalences. This is an explicit semisimple category, with
actual vector spaces rather than only a multiset of dimensions. Multiplicity
coordinates classify these objects, and an isomorphism of doubled objects
constructs an isomorphism of the original objects.

An equivalence from a geometric category of polarizable rational Hodge
structures to this model is not constructed. In particular, no integral
lattice or polarization is encoded by a coordinate object.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

open CategoryTheory

universe u v

/-- A finite-support object in the category with prescribed division-ring
simple coordinates. The carrier and its linear structure are retained. -/
structure SemisimpleCoordinateObject (ι : Type u) (division : ι → Type v)
    [∀ i, DivisionRing (division i)] where
  carrier : ι → Type v
  [additive : ∀ i, AddCommGroup (carrier i)]
  [scalarAction : ∀ i, Module (division i) (carrier i)]
  [finite : ∀ i, Module.Finite (division i) (carrier i)]
  finiteSupport : Set.Finite {i | Module.finrank (division i) (carrier i) ≠ 0}

attribute [instance] SemisimpleCoordinateObject.additive SemisimpleCoordinateObject.scalarAction
  SemisimpleCoordinateObject.finite

/-- An actual isomorphism of semisimple coordinate objects is a family of
linear equivalences over the prescribed division rings. -/
abbrev SemisimpleCoordinateObject.Iso
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (left right : SemisimpleCoordinateObject ι division) :=
  ∀ i, left.carrier i ≃ₗ[division i] right.carrier i

/-- Multiplicity coordinates are finite because the object has finite support. -/
noncomputable def SemisimpleCoordinateObject.multiplicity
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (object : SemisimpleCoordinateObject ι division) : ι →₀ ℕ :=
  Finsupp.ofSupportFinite (fun i => Module.finrank (division i) (object.carrier i)) object.finiteSupport

/-- An isomorphism preserves every simple multiplicity. -/
theorem SemisimpleCoordinateObject.multiplicity_eq_of_iso
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    {left right : SemisimpleCoordinateObject ι division} (equiv : left.Iso right) :
    left.multiplicity=right.multiplicity := by
  ext i
  exact (equiv i).finrank_eq

/-- Equal multiplicities construct actual componentwise linear equivalences. -/
noncomputable def SemisimpleCoordinateObject.isoOfMultiplicityEq
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (left right : SemisimpleCoordinateObject ι division)
    (equal : left.multiplicity=right.multiplicity) : left.Iso right :=
  fun i => LinearEquiv.ofFinrankEq (left.carrier i) (right.carrier i) (congrArg (fun m : ι →₀ ℕ => m i) equal)

/-- Direct sum is the product of the actual vector spaces in each coordinate. -/
def SemisimpleCoordinateObject.sum
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (left right : SemisimpleCoordinateObject ι division) : SemisimpleCoordinateObject ι division where
  carrier i := left.carrier i × right.carrier i
  additive _ := inferInstance
  scalarAction _ := inferInstance
  finite _ := inferInstance
  finiteSupport := (left.finiteSupport.union right.finiteSupport).subset <| by
    intro i nonzero
    by_contra neither
    simp only [Set.mem_union, Set.mem_setOf_eq, not_or, not_not] at neither
    apply nonzero
    simp [Module.finrank_prod, neither.1, neither.2]

/-- Direct sum adds simple multiplicities. -/
theorem SemisimpleCoordinateObject.multiplicity_sum
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (left right : SemisimpleCoordinateObject ι division) :
    (left.sum right).multiplicity=left.multiplicity+right.multiplicity := by
  ext i
  exact Module.finrank_prod

/-- Cancellation of doubled objects returns an isomorphism of actual objects;
it is derived by cancellation of each finite simple multiplicity. -/
noncomputable def SemisimpleCoordinateObject.isoOfDoubleIso
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (left right : SemisimpleCoordinateObject ι division)
    (doubled : (left.sum left).Iso (right.sum right)) : left.Iso right := by
  apply left.isoOfMultiplicityEq right
  have equal := multiplicity_eq_of_iso doubled
  rw [multiplicity_sum, multiplicity_sum] at equal
  ext i
  have h := congrArg (fun m : ι →₀ ℕ => m i) equal
  simp only [Finsupp.add_apply] at h
  omega

/-- Relabeling splitting branches gives an actual linear equivalence of
unlabelled direct sums in every simple coordinate. No individually labelled
branch is required to descend to a smaller coefficient field. -/
def SemisimpleCoordinateObject.branchSumReindex
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    {J J' : Type v} (equiv : J ≃ J')
    (family : J' → SemisimpleCoordinateObject ι division) :
    ∀ i, (∀ j : J, (family (equiv j)).carrier i) ≃ₗ[division i]
      (∀ j : J', (family j).carrier i) :=
  fun i => LinearEquiv.piCongrLeft (division i) (fun j => (family j).carrier i) equiv

/-- Morphisms are actual componentwise linear maps over the division rings. -/
instance semisimpleCoordinateCategory
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)] :
    CategoryTheory.Category (SemisimpleCoordinateObject ι division) where
  Hom left right := ∀ i, left.carrier i →ₗ[division i] right.carrier i
  id object i := LinearMap.id
  comp f g i := (g i).comp (f i)
  id_comp := by intros; funext i; ext x; rfl
  comp_id := by intros; funext i; ext x; rfl
  assoc := by intros; funext i; ext x; rfl

/-- Coordinatewise equivalences define an isomorphism in the actual category
of semisimple coordinate objects. -/
def SemisimpleCoordinateObject.categoryIso
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    {left right : SemisimpleCoordinateObject ι division} (equiv : left.Iso right) :
    CategoryTheory.Iso left right where
  hom i := (equiv i).toLinearMap
  inv i := (equiv i).symm.toLinearMap
  hom_inv_id := by funext i; ext x; exact (equiv i).symm_apply_apply x
  inv_hom_id := by funext i; ext x; exact (equiv i).apply_symm_apply x

/-- Realize a finite multiplicity vector by actual division-ring coordinate spaces. -/
noncomputable def SemisimpleCoordinateObject.ofMultiplicity
    {ι : Type u} (division : ι → Type v) [∀ i, DivisionRing (division i)]
    (multiplicity : ι →₀ ℕ) : SemisimpleCoordinateObject ι division where
  carrier i := Fin (multiplicity i) → division i
  additive _ := inferInstance
  scalarAction _ := inferInstance
  finite _ := inferInstance
  finiteSupport := by
    apply multiplicity.support.finite_toSet.subset
    intro i h
    exact Finsupp.mem_support_iff.mpr (by simpa using h)

/-- The constructed coordinate object has exactly the specified multiplicities. -/
theorem SemisimpleCoordinateObject.multiplicity_ofMultiplicity
    {ι : Type u} (division : ι → Type v) [∀ i, DivisionRing (division i)]
    (multiplicity : ι →₀ ℕ) : (ofMultiplicity division multiplicity).multiplicity=multiplicity := by
  ext i
  change Module.finrank (division i) (Fin (multiplicity i) → division i)=multiplicity i
  simp

/-- An isomorphism in the coordinate category supplies the actual linear
inverse maps in each simple coordinate. -/
def SemisimpleCoordinateObject.coordinateIsoOfCategoryIso
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    {left right : SemisimpleCoordinateObject ι division} (equiv : CategoryTheory.Iso left right) :
    left.Iso right := fun i =>
  { equiv.hom i with
    invFun := equiv.inv i
    left_inv x := congrArg (fun f : left ⟶ left => f i x) equiv.hom_inv_id
    right_inv x := congrArg (fun f : right ⟶ right => f i x) equiv.inv_hom_id }

/-- Doubled cancellation expressed entirely as actual category isomorphisms. -/
noncomputable def SemisimpleCoordinateObject.cancelDoubleCategoryIso
    {ι : Type u} {division : ι → Type v} [∀ i, DivisionRing (division i)]
    (left right : SemisimpleCoordinateObject ι division)
    (doubled : CategoryTheory.Iso (left.sum left) (right.sum right)) :
    CategoryTheory.Iso left right :=
  SemisimpleCoordinateObject.categoryIso (left.isoOfDoubleIso right (coordinateIsoOfCategoryIso doubled))

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
