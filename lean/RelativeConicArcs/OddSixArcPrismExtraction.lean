import RelativeConicArcs.OddSixArcAffinePrism
import RelativeConicArcs.ProjectiveBridge
import RelativeConicArcs.SixVertexOneFactorization

/-!
# Extracting the triangular prism from the five-fiber equality case

This file fixes the precise interface between the incidence equality case and
`OddSixArcAffinePrism.triangularPrism_impossible`.  The finite-geometric input is isolated as
`IncidencePrismWitness`: after labelling the six arc vertices, three distinct points of the
disjoint line carry the nine chord incidences of the standard triangular prism.

The theorem `projectivePrismWitness_of_incidence` performs all remaining transport.  In
particular, it changes incidence collinearity to the projectivization predicate and proves that
every labelled vertex is off the direction line.  Thus the only open C180 step is to construct an
`IncidencePrismWitness` from the five index-three fibers, using
`SixVertexOneFactorization.oneFactorization_has_triangularPrism_normalForm`.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace OddSixArcPrismExtraction

open Configuration Finset
open ProjectiveCap ProjectiveCap.Projective Projectivization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

abbrev Point (K : Type*) [Field K] := ProjectiveBridge.Point K

noncomputable local instance : Fintype (Point K) := Fintype.ofFinite (Point K)
noncomputable local instance : DecidableEq (Point K) := Classical.decEq (Point K)

noncomputable local instance instDecidableIncidence (p l : Point K) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- A canonical labelling of a six-element finset by `Fin 6`. -/
noncomputable def canonicalLabel (A : Finset (Point K)) (hcard : A.card = 6) : Fin 6 → Point K :=
  fun i => ((Finset.equivFinOfCardEq hcard).symm i : A)

theorem canonicalLabel_injective (A : Finset (Point K)) (hcard : A.card = 6) :
    Function.Injective (canonicalLabel A hcard) := by
  intro i j hij
  exact (Finset.equivFinOfCardEq hcard).symm.injective (Subtype.ext hij)

theorem mem_iff_exists_canonicalLabel (A : Finset (Point K)) (hcard : A.card = 6) (x : Point K) :
    x ∈ A ↔ ∃ i : Fin 6, canonicalLabel A hcard i = x := by
  constructor
  · intro hx
    let y : A := ⟨x, hx⟩
    refine ⟨Finset.equivFinOfCardEq hcard y, ?_⟩
    exact congrArg Subtype.val ((Finset.equivFinOfCardEq hcard).symm_apply_apply y)
  · rintro ⟨i, rfl⟩
    exact ((Finset.equivFinOfCardEq hcard).symm i).property

/-- The exact incidence-geometric datum which the five index-three fibers must supply.

The edge pattern agrees, in order, with the interface of
`OddSixArcAffinePrism.triangularPrism_impossible`: the first three matchings are
`01|23|45`, `02|14|35`, and `03|15|24`.
-/
def IncidencePrismWitness (A : Finset (Point K)) (l : Point K) : Prop :=
  ∃ p : Fin 6 → Point K, ∃ d₀ d₁ d₂ : Point K,
    Function.Injective p ∧
    (∀ x, x ∈ A ↔ ∃ i, p i = x) ∧
    d₀ ≠ d₁ ∧ d₀ ≠ d₂ ∧ d₁ ≠ d₂ ∧
    d₀ ∈ l ∧ d₁ ∈ l ∧ d₂ ∈ l ∧
    Collinear (L := Point K) d₀ (p 0) (p 1) ∧
    Collinear (L := Point K) d₀ (p 2) (p 3) ∧
    Collinear (L := Point K) d₀ (p 4) (p 5) ∧
    Collinear (L := Point K) d₁ (p 0) (p 2) ∧
    Collinear (L := Point K) d₁ (p 1) (p 4) ∧
    Collinear (L := Point K) d₁ (p 3) (p 5) ∧
    Collinear (L := Point K) d₂ (p 0) (p 3) ∧
    Collinear (L := Point K) d₂ (p 1) (p 5) ∧
    Collinear (L := Point K) d₂ (p 2) (p 4)

/-- The projective form consumed directly by the affine triangular-prism obstruction. -/
def ProjectivePrismWitness (A : Finset (Point K)) (l : Point K) : Prop :=
  ∃ p : Fin 6 → Point K, ∃ d₀ d₁ d₂ : Point K,
    Function.Injective p ∧
    (∀ x, x ∈ A ↔ ∃ i, p i = x) ∧
    d₀ ≠ d₁ ∧ d₀ ≠ d₂ ∧ d₁ ≠ d₂ ∧
    d₀ ∈ l ∧ d₁ ∈ l ∧ d₂ ∈ l ∧
    (∀ i, ¬ ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₀ d₁ (p i)) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₀ d₁ d₂ ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₀ (p 0) (p 1) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₀ (p 2) (p 3) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₀ (p 4) (p 5) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₁ (p 0) (p 2) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₁ (p 1) (p 4) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₁ (p 3) (p 5) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₂ (p 0) (p 3) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₂ (p 1) (p 5) ∧
    ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₂ (p 2) (p 4)

/-- Incidence extraction is exactly sufficient for the projective affine-prism theorem. -/
theorem projectivePrismWitness_of_incidence
    {A : Finset (Point K)} {l : Point K}
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (h : IncidencePrismWitness (K := K) A l) :
    ProjectivePrismWitness (K := K) A l := by
  rcases h with ⟨p, d₀, d₁, d₂, hp, hpA, h01, h02, h12,
    hd₀l, hd₁l, hd₂l, h001, h023, h045, h102, h114, h135, h203, h215, h224⟩
  have toProjective {a b c : Point K} (hc : Collinear (L := Point K) a b c) :
      ProjectiveCap.Projective.Collinear K (Fin 3 → K) a b c :=
    ProjectiveBridge.collinear_iff_projective_collinear.mp hc
  have hinfInc : Collinear (L := Point K) d₀ d₁ d₂ :=
    ⟨l, hd₀l, hd₁l, hd₂l⟩
  have hoff (i : Fin 6) :
      ¬ ProjectiveCap.Projective.Collinear K (Fin 3 → K) d₀ d₁ (p i) := by
    intro hcol
    have hinc : Collinear (L := Point K) d₀ d₁ (p i) :=
      ProjectiveBridge.collinear_iff_projective_collinear.mpr hcol
    obtain ⟨m, hd₀m, hd₁m, hpim⟩ := hinc
    have hml : m = l :=
      (Configuration.Nondegenerate.eq_or_eq hd₀m hd₁m hd₀l hd₁l).resolve_left h01
    have hpiA : p i ∈ A := (hpA (p i)).2 ⟨i, rfl⟩
    exact (Finset.disjoint_left.mp hdisj)
      (mem_pointsOnLine.mpr (hml ▸ hpim)) hpiA
  exact ⟨p, d₀, d₁, d₂, hp, hpA, h01, h02, h12,
    hd₀l, hd₁l, hd₂l, hoff, toProjective hinfInc,
    toProjective h001, toProjective h023, toProjective h045,
    toProjective h102, toProjective h114, toProjective h135,
    toProjective h203, toProjective h215, toProjective h224⟩

/-- Once the equality-case fibers have been converted to an incidence prism, odd characteristic
excludes the case immediately.  This theorem is the intended consumer of the remaining extraction
lemma. -/
theorem card_coveredOnLine_ne_five_of_incidence_extraction
    {A : Finset (Point K)} (hA : Arc (L := Point K) A) (hcard : A.card = 6)
    {l : Point K} (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hodd : (2 : K) ≠ 0)
    (hextract : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5 →
      IncidencePrismWitness (K := K) A l) :
    (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card ≠ 5 := by
  intro hfive
  rcases projectivePrismWitness_of_incidence hdisj (hextract hfive) with
    ⟨p, d₀, d₁, d₂, hp, _hpA, _h01, _h02, _h12, _hd₀l, _hd₁l, _hd₂l,
      hoff, hinf, h001, h023, h045, h102, h114, h135, h203, h215, h224⟩
  exact OddSixArcAffinePrism.triangularPrism_impossible hodd p hp d₀ d₁ d₂
    hoff hinf h001 h023 h045 h102 h114 h135 h203 h215 h224

#print axioms projectivePrismWitness_of_incidence
#print axioms card_coveredOnLine_ne_five_of_incidence_extraction

end OddSixArcPrismExtraction
end RelativeConicArcs
