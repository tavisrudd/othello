import Mathlib.LinearAlgebra.Prod
import Mathlib.Tactic

/-!
# Pullback splitting for the projective trade map

Let `boundary : Q → E` be a linear map and let `i : S → E`.  The pullback of
`boundary` along `i` is the kernel of

`(q, s) ↦ boundary q - i s`.

Whenever `i` lifts through `boundary`, the lift gives a linear section of the
pullback projection to `S`.  If the restricted boundary is zero, the same lift
lands in `ker boundary`.  These are the two linear-algebra conclusions used
when a simple summand of a two-sheet permutation module is mapped into a
quadratic moment module.  The assertions are purely diagrammatic: no
semisimplicity, group representation, or cohomology calculation is assumed.
-/

namespace RelativeConicArcs.ClebschProjectiveTradeReduction

variable {R S Q E : Type*}
variable [CommRing R]
variable [AddCommGroup S] [Module R S]
variable [AddCommGroup Q] [Module R Q]
variable [AddCommGroup E] [Module R E]

/-- The difference map whose kernel realizes the pullback of `boundary` along
`i`. -/
def pullbackDifference (boundary : Q →ₗ[R] E) (i : S →ₗ[R] E) :
    Q × S →ₗ[R] E :=
  boundary.comp (LinearMap.fst R Q S) - i.comp (LinearMap.snd R Q S)

/-- The linear pullback of `boundary : Q → E` along `i : S → E`. -/
abbrev Pullback (boundary : Q →ₗ[R] E) (i : S →ₗ[R] E) : Submodule R (Q × S) :=
  (pullbackDifference boundary i).ker

/-- Projection from the pullback to the module along which it was formed. -/
def pullbackProjection (boundary : Q →ₗ[R] E) (i : S →ₗ[R] E) :
    Pullback boundary i →ₗ[R] S :=
  (LinearMap.snd R Q S).domRestrict (Pullback boundary i)

/-- A lift through `boundary` gives the canonical section of the pullback. -/
def pullbackSection (boundary : Q →ₗ[R] E) (i : S →ₗ[R] E)
    (j : S →ₗ[R] Q) (hlift : boundary.comp j = i) :
    S →ₗ[R] Pullback boundary i where
  toFun s := by
    refine ⟨(j s, s), ?_⟩
    rw [LinearMap.mem_ker]
    change boundary (j s) - i s = 0
    exact sub_eq_zero.mpr (LinearMap.congr_fun hlift s)
  map_add' x y := by
    ext <;> simp
  map_smul' r x := by
    ext <;> simp

/-- The section obtained from a lift is a right inverse to the pullback
projection. -/
theorem pullbackProjection_comp_pullbackSection
    (boundary : Q →ₗ[R] E) (i : S →ₗ[R] E)
    (j : S →ₗ[R] Q) (hlift : boundary.comp j = i) :
    (pullbackProjection boundary i).comp
        (pullbackSection boundary i j hlift) = LinearMap.id := by
  ext s
  rfl

/-- If the boundary of a lift vanishes, its image lies in the kernel of the
boundary map. -/
theorem range_le_ker_of_boundary_comp_eq_zero
    (boundary : Q →ₗ[R] E) (j : S →ₗ[R] Q)
    (hzero : boundary.comp j = 0) :
    LinearMap.range j ≤ LinearMap.ker boundary := by
  rintro q ⟨s, rfl⟩
  rw [LinearMap.mem_ker]
  have hs := LinearMap.congr_fun hzero s
  simpa using hs

/-- A lift whose restricted boundary is either zero or injective satisfies
the projective-trade dichotomy: it lands in the quadratic kernel in the first
case, while in the second case it supplies a split pullback along an embedding.
-/
theorem kernel_or_split_pullback
    (boundary : Q →ₗ[R] E) (j : S →ₗ[R] Q)
    (hdichotomy : boundary.comp j = 0 ∨ Function.Injective (boundary.comp j)) :
    LinearMap.range j ≤ LinearMap.ker boundary ∨
      (Function.Injective (boundary.comp j) ∧
        ∃ splitting : S →ₗ[R] Pullback boundary (boundary.comp j),
          (pullbackProjection boundary (boundary.comp j)).comp splitting = LinearMap.id) := by
  rcases hdichotomy with hzero | hinjective
  · exact Or.inl (range_le_ker_of_boundary_comp_eq_zero boundary j hzero)
  · refine Or.inr ⟨hinjective, ?_⟩
    exact ⟨pullbackSection boundary (boundary.comp j) j rfl,
      pullbackProjection_comp_pullbackSection boundary (boundary.comp j) j rfl⟩

end RelativeConicArcs.ClebschProjectiveTradeReduction
