import RelativeConicArcs.ClebschAffineExtensionContraction

/-!
# Equivariant descent of affine contraction

This module equips the coordinate contraction with linear group actions.  An equivariant
retraction `ρ` of an equivariant inclusion `i` makes the contraction

`c ↦ (#ι)c + i(ρ(c))`

equivariant.  Consequently it sends a one-coboundary to the one-coboundary of the contracted
zero-cochain.  These are the exact cochain identities needed to pass the evaluation--coevaluation
formula to first cohomology.

The cohomology quotient itself is not constructed: the terminal theorem proves equality modulo
the explicitly defined coboundary relation.
-/

namespace RelativeConicArcs.ClebschAffineContractionCohomology

open ClebschAffineExtensionContraction

variable {k G ι κ : Type*} [Field k] [Group G]

/-- A linear action of a group on a module. -/
structure LinearAction (V : Type*) [AddCommGroup V] [Module k V] where
  act : G → V →ₗ[k] V
  one_act : act 1 = LinearMap.id
  mul_act : ∀ g h, act (g * h) = (act g).comp (act h)

namespace LinearAction

variable {V W : Type*} [AddCommGroup V] [Module k V]
  [AddCommGroup W] [Module k W]

/-- A linear map intertwines two linear group actions. -/
def Intertwines (A : LinearAction (k := k) (G := G) V)
    (B : LinearAction (k := k) (G := G) W) (f : V →ₗ[k] W) : Prop :=
  ∀ g x, f (A.act g x) = B.act g (f x)

/-- The one-coboundary of a zero-cochain. -/
def coboundary (A : LinearAction (k := k) (G := G) V) (x : V) : G → V :=
  fun g ↦ A.act g x - x

/-- An equivariant linear map sends a coboundary to the coboundary of the mapped vector. -/
theorem map_coboundary (A : LinearAction (k := k) (G := G) V)
    (B : LinearAction (k := k) (G := G) W) (f : V →ₗ[k] W)
    (hf : Intertwines A B f) (x : V) :
    (fun g ↦ f (coboundary A x g)) = coboundary B (f x) := by
  funext g
  simp only [coboundary, map_sub]
  rw [hf]

end LinearAction

variable [Fintype ι]

/-- The coordinate evaluation--coevaluation contraction as a linear endomorphism. -/
def contractionLinearMap
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k)) :
    (κ → k) →ₗ[k] (κ → k) where
  toFun := fun c ↦ (Fintype.card ι : k) • c + i (ρ c)
  map_add' x y := by
    simp only [map_add, smul_add]
    abel
  map_smul' a x := by
    simp only [map_smul, smul_add, smul_smul]
    rw [RingHom.id_apply, mul_comm]

/-- With a genuine retraction, the closed linear contraction is the coordinate categorical
trace defined in `ClebschAffineExtensionContraction`. -/
theorem contractionLinearMap_eq_contractedRankOne
    [DecidableEq ι]
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k))
    (hretract : ∀ x, ρ (i x) = x) (c : κ → k) :
    contractionLinearMap i ρ c = contractedRankOne i ρ c := by
  rw [contractedRankOne_eq i ρ hretract]
  rfl

omit [Fintype ι] in
/-- If `i` and `ρ` intertwine the selected-copy and ambient actions, then their composite
`iρ` intertwines the ambient action with itself. -/
theorem inclusion_retraction_intertwines
    (AS : LinearAction (k := k) (G := G) (ι → k))
    (AF : LinearAction (k := k) (G := G) (κ → k))
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k))
    (hi : LinearAction.Intertwines AS AF i)
    (hρ : LinearAction.Intertwines AF AS ρ) :
    LinearAction.Intertwines AF AF (i.comp ρ) := by
  intro g x
  simp only [LinearMap.comp_apply]
  rw [hρ, hi]

/-- The evaluation--coevaluation contraction intertwines the ambient group action. -/
theorem contraction_intertwines
    (AS : LinearAction (k := k) (G := G) (ι → k))
    (AF : LinearAction (k := k) (G := G) (κ → k))
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k))
    (hi : LinearAction.Intertwines AS AF i)
    (hρ : LinearAction.Intertwines AF AS ρ) :
    LinearAction.Intertwines AF AF (contractionLinearMap i ρ) := by
  intro g x
  change (Fintype.card ι : k) • AF.act g x + i (ρ (AF.act g x)) =
    AF.act g ((Fintype.card ι : k) • x + i (ρ x))
  simp only [map_add, map_smul]
  rw [hρ, hi]

/-- The contracted representative of a coboundary is again a coboundary. -/
theorem contraction_maps_coboundary
    (AS : LinearAction (k := k) (G := G) (ι → k))
    (AF : LinearAction (k := k) (G := G) (κ → k))
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k))
    (hi : LinearAction.Intertwines AS AF i)
    (hρ : LinearAction.Intertwines AF AS ρ) (x : κ → k) :
    (fun g ↦ contractionLinearMap i ρ (LinearAction.coboundary AF x g)) =
      LinearAction.coboundary AF (contractionLinearMap i ρ x) :=
  LinearAction.map_coboundary AF AF (contractionLinearMap i ρ)
    (contraction_intertwines AS AF i ρ hi hρ) x

end RelativeConicArcs.ClebschAffineContractionCohomology
