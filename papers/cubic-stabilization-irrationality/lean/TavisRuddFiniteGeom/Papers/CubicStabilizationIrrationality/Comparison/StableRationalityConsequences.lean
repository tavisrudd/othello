import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

/-!
# Stable-rationality consequences

This module isolates two ways in which a hypothetical birational equivalence
between a stabilization of a variety and projective space can be contradicted.

The first uses a stable birational invariant.  The second uses a geometric
witness, such as an integral decomposition of the diagonal, whose existence
pulls back across a birational equivalence and descends from a product with
projective space.  The descent map is an explicit field: it is not inferred
from the name of the witness.

The stabilization index is treated separately.  Rationality at one index is
assumed to imply rationality at every larger index.  This makes the set of
rational stabilization indices upward closed and justifies arguments from an
unbounded set of irrational indices.

The final examples are falsifiers for two tempting strengthenings.  Equality
after multiplying by a nonzero stabilization multiplicity cannot be cancelled
over an arbitrary coefficient group, and an integral algebraic cycle class
need not have an effective representative.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.StableRationalityConsequences

universe uObj uValue uWitness

/-- An invariant that is unchanged by the chosen birational relation and by
product stabilization.  Its value on every projective space is fixed to
`rationalValue`. -/
structure StableInvariant
    (Obj : Type uObj) (Value : Type uValue)
    (Birational : Obj → Obj → Prop)
    (stabilize : Obj → ℕ → Obj) (projective : ℕ → Obj)
    (rationalValue : Value) where
  value : Obj → Value
  birational_eq : ∀ {X Y}, Birational X Y → value X = value Y
  stabilize_eq : ∀ X m, value (stabilize X m) = value X
  projective_eq : ∀ d, value (projective d) = rationalValue

namespace StableInvariant

variable
    {Obj : Type uObj} {Value : Type uValue}
    {Birational : Obj → Obj → Prop}
    {stabilize : Obj → ℕ → Obj} {projective : ℕ → Obj}
    {rationalValue : Value}

/-- A birational parametrization of a stabilized object by projective space
forces the unstabilized object to have the rational value of every stable
birational invariant. -/
theorem baseValue_eq_rationalValue
    (data : StableInvariant Obj Value Birational stabilize projective rationalValue)
    {X : Obj} {m d : ℕ}
    (comparison : Birational (stabilize X m) (projective d)) :
    data.value X = rationalValue := by
  rw [← data.stabilize_eq X m]
  exact (data.birational_eq comparison).trans (data.projective_eq d)

/-- A stable birational invariant with non-rational value rules out every
specified stabilized parametrization. -/
theorem not_birational_of_baseValue_ne
    (data : StableInvariant Obj Value Birational stabilize projective rationalValue)
    {X : Obj} {m d : ℕ}
    (different : data.value X ≠ rationalValue) :
    ¬ Birational (stabilize X m) (projective d) := by
  intro comparison
  exact different (data.baseValue_eq_rationalValue comparison)

end StableInvariant

/-- A stable geometric witness.  `pullback` gives the directed transport used
from projective space to a birational model, while `cancelStabilization` is the
separate theorem that removes the projective factor. -/
structure StableWitness
    (Obj : Type uObj) (Birational : Obj → Obj → Prop)
    (stabilize : Obj → ℕ → Obj) (projective : ℕ → Obj) where
  Witness : Obj → Type uWitness
  pullback : ∀ {X Y}, Birational X Y → Witness Y → Witness X
  projectiveWitness : ∀ d, Witness (projective d)
  cancelStabilization : ∀ X m, Witness (stabilize X m) → Witness X

namespace StableWitness

variable
    {Obj : Type uObj} {Birational : Obj → Obj → Prop}
    {stabilize : Obj → ℕ → Obj} {projective : ℕ → Obj}

/-- A projective-space witness pulls back to the stabilized object and then
descends to the original object. -/
def baseWitness
    (data : StableWitness Obj Birational stabilize projective)
    {X : Obj} {m d : ℕ}
    (comparison : Birational (stabilize X m) (projective d)) :
    data.Witness X :=
  data.cancelStabilization X m
    (data.pullback comparison (data.projectiveWitness d))

/-- Nonexistence of the stable witness on the original object obstructs the
hypothetical stabilized birational parametrization. -/
theorem not_birational_of_isEmpty
    (data : StableWitness Obj Birational stabilize projective)
    {X : Obj} {m d : ℕ}
    (empty : IsEmpty (data.Witness X)) :
    ¬ Birational (stabilize X m) (projective d) := by
  intro comparison
  exact empty.false (data.baseWitness comparison)

end StableWitness

/-- The rationality profile of a fixed variety under products with projective
spaces.  The monotonicity field is the geometric fact that adjoining further
independent variables preserves rationality. -/
structure StabilizationProfile where
  rationalAt : ℕ → Prop
  upward : Monotone rationalAt

namespace StabilizationProfile

/-- Irrationality at a later stabilization index forces irrationality at every
earlier index. -/
theorem not_rationalAt_of_le
    (profile : StabilizationProfile) {m n : ℕ} (order : m ≤ n)
    (notLater : ¬ profile.rationalAt n) :
    ¬ profile.rationalAt m := by
  intro rationalEarlier
  exact notLater (profile.upward order rationalEarlier)

/-- If irrational stabilization indices occur above every bound, no
stabilization index can be rational. -/
theorem no_rational_stabilization_of_unbounded_irrationality
    (profile : StabilizationProfile)
    (unbounded : ∀ m, ∃ n, m ≤ n ∧ ¬ profile.rationalAt n) :
    ∀ m, ¬ profile.rationalAt m := by
  intro m
  obtain ⟨n, order, notLater⟩ := unbounded m
  exact profile.not_rationalAt_of_le order notLater

end StabilizationProfile

/-- A certificate that a scalar operation reflects equality.  Cancellation
arguments consume this record rather than a bare nonvanishing assertion about
the scalar. -/
structure ReflectsEquality {M : Type*} (scale : M → M) where
  injective : Function.Injective scale

namespace ReflectsEquality

/-- Equality after a certified equality-reflecting operation can be
cancelled. -/
theorem eq_of_scaled_eq
    {M : Type*} {scale : M → M} (data : ReflectsEquality scale)
    {x y : M} (scaled : scale x = scale y) :
    x = y :=
  data.injective scaled

end ReflectsEquality

/-- Multiplication by the stabilization multiplicity in `ZMod n`.  It is the
zero operation and therefore cannot support cancellation when `n > 1`. -/
def stabilizationMultiplicityScale (n : ℕ) : ZMod n → ZMod n :=
  fun x => (n : ZMod n) * x

/-- A nonzero natural stabilization multiplicity does not by itself make
multiplication equality-reflecting over arbitrary coefficient groups. -/
theorem stabilizationMultiplicityScale_not_injective
    (n : ℕ) (nontrivial : 1 < n) :
    ¬ Function.Injective (stabilizationMultiplicityScale n) := by
  letI : Fact (1 < n) := ⟨nontrivial⟩
  intro injective
  have one_eq_zero : (1 : ZMod n) = 0 := injective (by
    simp [stabilizationMultiplicityScale])
  exact one_ne_zero one_eq_zero

/-- Regression instances for stabilization indices one, two, three, four,
and thirteen, whose multiplicities are two, three, four, five, and fourteen. -/
theorem named_stabilizationMultiplicityScales_not_injective :
    ¬ Function.Injective (stabilizationMultiplicityScale 2) ∧
      ¬ Function.Injective (stabilizationMultiplicityScale 3) ∧
      ¬ Function.Injective (stabilizationMultiplicityScale 4) ∧
      ¬ Function.Injective (stabilizationMultiplicityScale 5) ∧
      ¬ Function.Injective (stabilizationMultiplicityScale 14) := by
  exact ⟨stabilizationMultiplicityScale_not_injective 2 (by norm_num),
    stabilizationMultiplicityScale_not_injective 3 (by norm_num),
    stabilizationMultiplicityScale_not_injective 4 (by norm_num),
    stabilizationMultiplicityScale_not_injective 5 (by norm_num),
    stabilizationMultiplicityScale_not_injective 14 (by norm_num)⟩

/-- The class of a signed cycle built from generators of classes three and
two. -/
def signedCycleClass (positive negative : ℕ) : ℤ :=
  3 * (positive : ℤ) - 2 * (negative : ℤ)

/-- The class one has a signed algebraic representative: it is three minus
two. -/
theorem one_has_signedCycleClass_representative :
    ∃ positive negative, signedCycleClass positive negative = 1 := by
  exact ⟨1, 1, by norm_num [signedCycleClass]⟩

/-- The class of an effective cycle built from generators of classes two and
three. -/
def effectiveCycleClass (first second : ℕ) : ℕ :=
  2 * first + 3 * second

/-- The same class one has no effective representative in the monoid
generated by classes two and three.  Thus existence of a signed integral
cycle cannot be upgraded formally to existence of an effective curve. -/
theorem one_has_no_effectiveCycleClass_representative :
    ¬ ∃ first second, effectiveCycleClass first second = 1 := by
  rintro ⟨first, second, equality⟩
  change 2 * first + 3 * second = 1 at equality
  omega

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.StableRationalityConsequences
