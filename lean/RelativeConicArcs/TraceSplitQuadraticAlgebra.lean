import Mathlib.RingTheory.AdjoinRoot
import Mathlib.Tactic
import RelativeConicArcs.SplitQuadraticPinching

/-!
# Trace-split quadratic algebras and their split charts

For a commutative ring `R` and `d : R`, the trace-split quadratic algebra is
`R[z]/(z²-d)`.  Its distinguished generator squares to `d`.  After a base
change on which `d = a²`, evaluation at the two roots `a` and `-a` maps the
algebra to the split pinching algebra consisting of pairs congruent modulo
`a`.  If two is invertible, every pinched pair is obtained from a linear
expression `p + qz`.
-/

namespace RelativeConicArcs.TraceSplitQuadraticAlgebra

open Polynomial

variable {R : Type*} [CommRing R]

/-- The monic quadratic relation defining a trace-split algebra. -/
noncomputable def relation (d : R) : R[X] := X ^ 2 - C d

/-- The quadratic algebra `R[z]/(z²-d)`. -/
abbrev Algebra (d : R) := AdjoinRoot (relation d)

/-- The distinguished trace-zero generator. -/
noncomputable def generator (d : R) : Algebra d := AdjoinRoot.root (relation d)

/-- The distinguished generator satisfies its defining quadratic relation. -/
theorem generator_sq (d : R) :
    generator d ^ 2 = algebraMap R (Algebra d) d := by
  change AdjoinRoot.root (relation d) ^ 2 = AdjoinRoot.of (relation d) d
  have h := AdjoinRoot.eval₂_root (relation d)
  rw [show relation d = X ^ 2 - C d from rfl, eval₂_sub, eval₂_pow,
    eval₂_X, eval₂_C] at h
  exact sub_eq_zero.mp h

/-- Diagonal scalars in the split pinching algebra. -/
def diagonal (a : R) : R →+* SplitQuadraticPinching.splitPinching a where
  toFun r := ⟨(r, r), ⟨0, by simp⟩⟩
  map_one' := rfl
  map_mul' _ _ := rfl
  map_zero' := rfl
  map_add' _ _ := rfl

/-- The pair of roots `(a,-a)` belongs to the pinching algebra. -/
def splitGenerator (a : R) : SplitQuadraticPinching.splitPinching a :=
  ⟨(a, -a), ⟨2, by ring⟩⟩

private theorem relation_eval₂_splitGenerator (a : R) :
    (relation (a ^ 2)).eval₂ (diagonal a) (splitGenerator a) = 0 := by
  simp only [relation, eval₂_sub, eval₂_pow, eval₂_X, eval₂_C]
  ext <;> simp [diagonal, splitGenerator]

/-- Evaluation at the two split roots, with codomain restricted to the
pinching algebra. -/
noncomputable def splitComparison (a : R) :
    Algebra (a ^ 2) →+* SplitQuadraticPinching.splitPinching a :=
  AdjoinRoot.lift (diagonal a) (splitGenerator a) (relation_eval₂_splitGenerator a)

/-- Scalars evaluate diagonally on the split chart. -/
@[simp]
theorem splitComparison_of (a r : R) :
    splitComparison a (AdjoinRoot.of (relation (a ^ 2)) r) = diagonal a r := by
  simp [splitComparison]

/-- The trace-zero generator evaluates to the pair of split roots. -/
@[simp]
theorem splitComparison_generator (a : R) :
    splitComparison a (generator (a ^ 2)) = splitGenerator a := by
  simp [splitComparison, generator]

/-- A linear expression `p + qz` evaluates to `(p+aq,p-aq)`. -/
theorem splitComparison_linear (a p q : R) :
    splitComparison a
        (AdjoinRoot.of (relation (a ^ 2)) p +
          AdjoinRoot.of (relation (a ^ 2)) q * generator (a ^ 2)) =
      ⟨SplitQuadraticPinching.splitEvaluate a p q,
        SplitQuadraticPinching.splitEvaluate_mem a p q⟩ := by
  rw [map_add, map_mul, splitComparison_of, splitComparison_generator]
  ext <;> simp [diagonal, splitGenerator, SplitQuadraticPinching.splitEvaluate] <;> ring

/-- When two is invertible, the split-chart comparison is surjective onto the
pinching algebra. -/
theorem splitComparison_surjective [Invertible (2 : R)] (a : R) :
    Function.Surjective (splitComparison a) := by
  intro x
  obtain ⟨p, q, hpq⟩ := SplitQuadraticPinching.exists_splitEvaluate x.property
  refine ⟨AdjoinRoot.of (relation (a ^ 2)) p +
      AdjoinRoot.of (relation (a ^ 2)) q * generator (a ^ 2), ?_⟩
  rw [splitComparison_linear]
  exact Subtype.ext hpq

end RelativeConicArcs.TraceSplitQuadraticAlgebra
