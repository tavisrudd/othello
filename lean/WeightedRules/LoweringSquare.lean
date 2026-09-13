import WeightedRules.Contract
import Mathlib.LinearAlgebra.Span.Defs

/-!
# Source events and summary transitions

A lowering `G` commutes with source events `F` and summary events `H` when
`G (F x e) = H (G x) e` for every source and event. Such a square transports
every finite event trace. A summary transition exists precisely when source
events preserve the fibers of a surjective lowering. Two equal summaries with
unequal summaries after the same event obstruct every deterministic summary
transition.

For sets of module vectors, adjoining a vector commutes with taking linear span:
the summary update joins the old span with the span of the new vector. This is
the mathematical observation-space contract; it does not verify a serialized
Rust table, transcript parser, or implementation of row reduction. All theorems
use symbolic kernel proofs. The finite checker uses ordinary decidable equality,
with no native decision or foreign oracle in its soundness theorem.
-/

namespace WeightedRules
namespace EventLowering

variable {X Y E : Type*}

/-- Every source event agrees with its summary event after lowering. -/
def Square (F : X → E → X) (G : X → Y) (H : Y → E → Y) : Prop :=
  ∀ x e, G (F x e) = H (G x) e

/-- Apply a finite event list in its written order. -/
def run (F : X → E → X) (x : X) : List E → X
  | [] => x
  | e :: es => run F (F x e) es

/-- A commuting square preserves every finite event trace, including its final state. -/
theorem square_trace (F : X → E → X) (G : X → Y) (H : Y → E → Y)
    (h : Square F G H) (x : X) (events : List E) :
    G (run F x events) = run H (G x) events := by
  induction events generalizing x with
  | nil => rfl
  | cons e es ih =>
    simp only [run, ih, h x e]

/-- Equal source summaries remain equal after each common event. -/
def FiberCompatible (F : X → E → X) (G : X → Y) : Prop :=
  ∀ x y, G x = G y → ∀ e, G (F x e) = G (F y e)

/-- Every deterministic summary update requires compatibility on lowering fibers. -/
theorem square_fiber (F : X → E → X) (G : X → Y) (H : Y → E → Y)
    (h : Square F G H) : FiberCompatible F G := by
  intro x y equal e
  have hx := h x e
  have hy := h y e
  grind

/-- A pair in one lowering fiber with distinct successor summaries rules out a square. -/
theorem incompatible_no_square (F : X → E → X) (G : X → Y)
    (x y : X) (e : E) (same : G x = G y) (different : G (F x e) ≠ G (F y e)) :
    ¬ ∃ H, Square F G H := by
  rintro ⟨H, h⟩
  exact different (square_fiber F G H h x y same e)

/-- For a surjective lowering, fiber compatibility is exactly the condition for a square. -/
theorem exists_square_iff (F : X → E → X) (G : X → Y)
    (surjective : Function.Surjective G) :
    (∃ H, Square F G H) ↔ FiberCompatible F G := by
  classical
  constructor
  · rintro ⟨H, h⟩
    exact square_fiber F G H h
  · intro h
    refine ⟨fun y e => G (F (Classical.choose (surjective y)) e), ?_⟩
    intro x e
    exact h x (Classical.choose (surjective (G x)))
      (Classical.choose_spec (surjective (G x))).symm e

/-- A surjective lowering determines its commuting summary transition uniquely. -/
theorem square_unique (F : X → E → X) (G : X → Y)
    (surjective : Function.Surjective G) (H₁ H₂ : Y → E → Y)
    (h₁ : Square F G H₁) (h₂ : Square F G H₂) : H₁ = H₂ := by
  funext y e
  obtain ⟨x, rfl⟩ := surjective y
  have first := h₁ x e
  have second := h₂ x e
  grind

/-- Exhaustive finite checking covers all source and event coordinates of the supplied functions. -/
def checkSquare {n m k : Nat} (F : Fin n → Fin k → Fin n)
    (G : Fin n → Fin m) (H : Fin m → Fin k → Fin m) : Bool :=
  decide (∀ x e, G (F x e) = H (G x) e)

/-- Acceptance by the finite checker proves the complete supplied lowering square. -/
theorem checkSquare_sound {n m k : Nat} (F : Fin n → Fin k → Fin n)
    (G : Fin n → Fin m) (H : Fin m → Fin k → Fin m)
    (accepted : checkSquare F G H = true) : Square F G H := by
  change ∀ x e, G (F x e) = H (G x) e
  exact of_decide_eq_true accepted

variable {R M : Type*} [Semiring R] [AddCommMonoid M] [Module R M]

/-- Appending an observation vector lowers to adjoining its one-generated submodule. -/
theorem observation_span_square :
    Square (fun (s : Set M) x => insert x s) (Submodule.span R)
      (fun V x => Submodule.span R {x} ⊔ V) := by
  intro s x
  exact Submodule.span_insert x s

/-- Full observation spans preserve every finite sequence of appended vectors. -/
theorem observation_span_trace (s : Set M) (events : List M) :
    Submodule.span R (run (fun (t : Set M) x => insert x t) s events) =
      run (fun V x => Submodule.span R {x} ⊔ V) (Submodule.span R s) events := by
  exact square_trace _ _ _ observation_span_square s events

end EventLowering
end WeightedRules
