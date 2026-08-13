import Mathlib.Algebra.Ring.Pi
import Mathlib.RingTheory.Ideal.Lattice
import Mathlib.RingTheory.Ideal.Quotient.Defs

/-!
# Quotients of a decreasing ideal filtration

A decreasing sequence of ideals in a commutative ring gives coefficient rings
at finite levels and canonical reduction maps from level `n + 1` to level `n`.
An endomorphism preserving every ideal descends to every quotient, and the
descended endomorphisms commute with reduction.  Thus the coefficient rings,
reductions, and compatible substitutions used by a finite-level formal base
shift can be constructed from explicit filtered-ring data.

Compatible quotient families form a pointwise commutative ring.  The canonical
ring homomorphism from the original ring is injective exactly when the
intersection of the filtration ideals is zero, and it is bijective exactly
when this separatedness condition is joined by surjectivity onto compatible
families.  The latter surjectivity is the coefficientwise completeness
predicate used here.

This module does not construct the manuscript's coefficient ring or its
filtration, prove that the supplied filtration is complete or separated,
identify the quotients with geometric coefficient rings, or construct
monodromy matrices and gauges.  All proofs are symbolic and kernel checked,
with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u

/-- A decreasing natural-number-indexed ideal filtration of a commutative
ring. -/
structure DecreasingIdealFiltration (R : Type u) [CommRing R] where
  ideal : ℕ → Ideal R
  antitone : Antitone ideal

namespace DecreasingIdealFiltration

/-- The coefficient ring obtained by quotienting by the ideal at a given
level. -/
abbrev QuotientRing {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (level : ℕ) :=
  R ⧸ filtration.ideal level

/-- The canonical reduction from the quotient at level `n + 1` to the quotient
at level `n`. -/
def reduction {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (level : ℕ) :
    filtration.QuotientRing (level + 1) →+* filtration.QuotientRing level :=
  Ideal.Quotient.factor (filtration.antitone (Nat.le_succ level))

/-- Reduction sends the class of a ring element to its class at the lower
level. -/
@[simp]
theorem reduction_mk {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (level : ℕ) (value : R) :
    filtration.reduction level
        (Ideal.Quotient.mk (filtration.ideal (level + 1)) value) =
      Ideal.Quotient.mk (filtration.ideal level) value :=
  Ideal.Quotient.factor_mk _ _

/-- A ring endomorphism preserving each ideal of a decreasing filtration. -/
structure PreservingEndomorphism {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) where
  toRingHom : R →+* R
  maps_mem : ∀ level value, value ∈ filtration.ideal level →
    toRingHom value ∈ filtration.ideal level

namespace PreservingEndomorphism

/-- The endomorphism induced on one quotient ring. -/
def quotientEndomorphism {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    (endomorphism : filtration.PreservingEndomorphism) (level : ℕ) :
    filtration.QuotientRing level →+* filtration.QuotientRing level :=
  Ideal.Quotient.lift (filtration.ideal level)
    ((Ideal.Quotient.mk (filtration.ideal level)).comp endomorphism.toRingHom)
    (by
      intro value hvalue
      rw [RingHom.comp_apply, Ideal.Quotient.eq_zero_iff_mem]
      exact endomorphism.maps_mem level value hvalue)

/-- The quotient endomorphism sends the class of a ring element to the class
of its image. -/
@[simp]
theorem quotientEndomorphism_mk {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    (endomorphism : filtration.PreservingEndomorphism) (level : ℕ)
    (value : R) :
    endomorphism.quotientEndomorphism level
        (Ideal.Quotient.mk (filtration.ideal level) value) =
      Ideal.Quotient.mk (filtration.ideal level)
        (endomorphism.toRingHom value) :=
  rfl

/-- The quotient endomorphisms commute with every adjacent reduction map. -/
theorem reduction_quotientEndomorphism {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    (endomorphism : filtration.PreservingEndomorphism) (level : ℕ)
    (coefficient : filtration.QuotientRing (level + 1)) :
    filtration.reduction level
        (endomorphism.quotientEndomorphism (level + 1) coefficient) =
      endomorphism.quotientEndomorphism level
        (filtration.reduction level coefficient) := by
  induction coefficient using Quotient.inductionOn' with
  | _ value => rfl

end PreservingEndomorphism

/-- A coefficientwise compatible family in the inverse system of quotient
rings.  This is an explicit family with adjacent compatibility, not a
categorical limit construction. -/
structure CompatibleQuotientFamily {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) where
  value : ∀ level, filtration.QuotientRing level
  compatible : ∀ level,
    filtration.reduction level (value (level + 1)) = value level

namespace CompatibleQuotientFamily

/-- Two compatible quotient families are equal when all of their components
are equal. -/
@[ext]
theorem ext {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R}
    {left right : filtration.CompatibleQuotientFamily}
    (h : ∀ level, left.value level = right.value level) : left = right := by
  cases left with
  | mk leftValue leftCompatible =>
    cases right with
    | mk rightValue rightCompatible =>
      have hvalue : leftValue = rightValue := funext h
      subst rightValue
      rfl

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    Zero filtration.CompatibleQuotientFamily where
  zero :=
    { value := fun _ => 0
      compatible := fun level => (filtration.reduction level).map_zero }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    One filtration.CompatibleQuotientFamily where
  one :=
    { value := fun _ => 1
      compatible := fun level => (filtration.reduction level).map_one }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    Add filtration.CompatibleQuotientFamily where
  add left right :=
    { value := fun level => left.value level + right.value level
      compatible := fun level => by
        rw [map_add, left.compatible, right.compatible] }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    Mul filtration.CompatibleQuotientFamily where
  mul left right :=
    { value := fun level => left.value level * right.value level
      compatible := fun level => by
        rw [map_mul, left.compatible, right.compatible] }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    Neg filtration.CompatibleQuotientFamily where
  neg family :=
    { value := fun level => -family.value level
      compatible := fun level => by rw [map_neg, family.compatible] }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    Sub filtration.CompatibleQuotientFamily where
  sub left right :=
    { value := fun level => left.value level - right.value level
      compatible := fun level => by
        rw [map_sub, left.compatible, right.compatible] }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    SMul ℕ filtration.CompatibleQuotientFamily where
  smul scalar family :=
    { value := fun level => scalar • family.value level
      compatible := fun level => by
        rw [map_nsmul, family.compatible] }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    SMul ℤ filtration.CompatibleQuotientFamily where
  smul scalar family :=
    { value := fun level => scalar • family.value level
      compatible := fun level => by
        rw [map_zsmul, family.compatible] }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    Pow filtration.CompatibleQuotientFamily ℕ where
  pow family exponent :=
    { value := fun level => family.value level ^ exponent
      compatible := fun level => by
        rw [map_pow, family.compatible] }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    NatCast filtration.CompatibleQuotientFamily where
  natCast scalar :=
    { value := fun _ => scalar
      compatible := fun level => map_natCast (filtration.reduction level) scalar }

instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    IntCast filtration.CompatibleQuotientFamily where
  intCast scalar :=
    { value := fun _ => scalar
      compatible := fun level => map_intCast (filtration.reduction level) scalar }

/-- Compatible quotient families form a commutative ring under pointwise
operations. -/
instance {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} :
    CommRing filtration.CompatibleQuotientFamily := by
  letI : ∀ level, CommRing (filtration.QuotientRing level) :=
    fun _ => inferInstance
  exact Function.Injective.commRing
    (fun family : filtration.CompatibleQuotientFamily => family.value)
    (fun _ _ h => ext fun level => congrFun h level)
    rfl rfl (fun _ _ => rfl) (fun _ _ => rfl) (fun _ => rfl)
    (fun _ _ => rfl) (fun _ _ => rfl) (fun _ _ => rfl)
    (fun _ _ => rfl) (fun _ => rfl) (fun _ => rfl)

/-- Evaluation at one quotient level is a ring homomorphism. -/
def evaluation {R : Type u} [CommRing R]
    {filtration : DecreasingIdealFiltration R} (level : ℕ) :
    filtration.CompatibleQuotientFamily →+* filtration.QuotientRing level where
  toFun family := family.value level
  map_one' := by change (1 : filtration.QuotientRing level) = 1; rfl
  map_mul' left right := by
    change left.value level * right.value level = _
    rfl
  map_zero' := by change (0 : filtration.QuotientRing level) = 0; rfl
  map_add' left right := by
    change left.value level + right.value level = _
    rfl

end CompatibleQuotientFamily

/-- The compatible quotient family represented by one element of the original
ring. -/
def ofRingElement {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (value : R) :
    filtration.CompatibleQuotientFamily where
  value level := Ideal.Quotient.mk (filtration.ideal level) value
  compatible level := filtration.reduction_mk level value

/-- The canonical ring homomorphism from the original ring to its compatible
quotient-family model. -/
def quotientFamilyRingHom {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) :
    R →+* filtration.CompatibleQuotientFamily where
  toFun := filtration.ofRingElement
  map_one' := by
    ext level
    change Ideal.Quotient.mk (filtration.ideal level) 1 = 1
    exact map_one _
  map_mul' left right := by
    ext level
    change Ideal.Quotient.mk (filtration.ideal level) (left * right) =
      Ideal.Quotient.mk (filtration.ideal level) left *
        Ideal.Quotient.mk (filtration.ideal level) right
    exact map_mul _ _ _
  map_zero' := by
    ext level
    change Ideal.Quotient.mk (filtration.ideal level) 0 = 0
    exact map_zero _
  map_add' left right := by
    ext level
    change Ideal.Quotient.mk (filtration.ideal level) (left + right) =
      Ideal.Quotient.mk (filtration.ideal level) left +
        Ideal.Quotient.mk (filtration.ideal level) right
    exact map_add _ _ _

/-- The component of the family represented by a ring element is its quotient
class at that level. -/
@[simp]
theorem ofRingElement_value {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) (value : R) (level : ℕ) :
    (filtration.ofRingElement value).value level =
      Ideal.Quotient.mk (filtration.ideal level) value :=
  rfl

/-- The canonical function from the original ring to its compatible
quotient-family model is injective exactly when the intersection of the
filtration ideals is zero. -/
theorem ofRingElement_injective_iff_iInf_eq_bot
    {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) :
    Function.Injective filtration.ofRingElement ↔
      iInf filtration.ideal = ⊥ := by
  constructor
  · intro hinjective
    apply le_antisymm
    · intro value hvalue
      have hall : ∀ level, value ∈ filtration.ideal level :=
        Ideal.mem_iInf.mp hvalue
      have hfamily : filtration.ofRingElement value =
          filtration.ofRingElement 0 := by
        ext level
        rw [ofRingElement_value, ofRingElement_value]
        exact Ideal.Quotient.eq_zero_iff_mem.mpr (hall level)
      have : value = 0 := hinjective hfamily
      subst value
      exact Ideal.zero_mem ⊥
    · exact bot_le
  · intro hseparated left right hequal
    have hall : ∀ level, left - right ∈ filtration.ideal level := by
      intro level
      have hlevel := congrArg
        (fun family : filtration.CompatibleQuotientFamily => family.value level)
        hequal
      simpa only [ofRingElement_value, Ideal.Quotient.mk_eq_mk_iff_sub_mem]
        using hlevel
    have hintersection : left - right ∈ iInf filtration.ideal :=
      Ideal.mem_iInf.mpr hall
    rw [hseparated] at hintersection
    exact sub_eq_zero.mp hintersection

/-- Completeness of the coefficientwise quotient-family model means that every
compatible family is represented by an element of the original ring. -/
def IsComplete {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) : Prop :=
  Function.Surjective filtration.quotientFamilyRingHom

/-- The canonical ring homomorphism is bijective exactly when the filtration
is complete in the coefficientwise compatible-family sense and separated by
zero intersection. -/
theorem quotientFamilyRingHom_bijective_iff_complete_and_iInf_eq_bot
    {R : Type u} [CommRing R]
    (filtration : DecreasingIdealFiltration R) :
    Function.Bijective filtration.quotientFamilyRingHom ↔
      filtration.IsComplete ∧ iInf filtration.ideal = ⊥ := by
  constructor
  · rintro ⟨hinjective, hsurjective⟩
    refine ⟨hsurjective, ?_⟩
    exact filtration.ofRingElement_injective_iff_iInf_eq_bot.mp hinjective
  · rintro ⟨hsurjective, hseparated⟩
    refine ⟨?_, hsurjective⟩
    exact filtration.ofRingElement_injective_iff_iInf_eq_bot.mpr hseparated

end DecreasingIdealFiltration

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
