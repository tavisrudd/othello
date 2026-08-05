import RelativeConicArcs.OddSixArcAffinePrism
import RelativeConicArcs.ProjectiveBridge
import RelativeConicArcs.SixVertexOneFactorization

/-!
# Extracting the triangular prism from the five-fiber equality case

This file fixes the precise interface between the incidence equality case and
`OddSixArcAffinePrism.triangularPrism_impossible`.  The finite-geometric input is isolated as
`IncidencePrismWitness`: after labelling the six arc vertices, three distinct points of the
disjoint line carry the nine chord incidences of the standard triangular prism.

The chord-intersection construction below turns the five covered points into a proper
five-edge-colouring of `K₆`.  The one-factorization certificate extracts three prism factors,
yielding `incidencePrismWitness_of_five`.  The theorem `projectivePrismWitness_of_incidence` then
changes incidence collinearity to the projectivization predicate and proves that every labelled
vertex is off the direction line.  The resulting theorem excludes the equality case over every
finite field of odd characteristic and supplies the complete six-arc line bound.
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

/-- A labelling of a six-element finset by `Fin 6`, read off the noncomputably chosen equivalence
`Finset.equivFinOfCardEq`.  It depends on that choice and on nothing else: no order, incidence, or
symmetry of the ambient plane determines it, and no invariance under such structure is claimed.
The results below use it only as a fixed index for the six points. -/
noncomputable def chosenLabel (A : Finset (Point K)) (hcard : A.card = 6) : Fin 6 → Point K :=
  fun i => ((Finset.equivFinOfCardEq hcard).symm i : A)

theorem chosenLabel_injective (A : Finset (Point K)) (hcard : A.card = 6) :
    Function.Injective (chosenLabel A hcard) := by
  intro i j hij
  exact (Finset.equivFinOfCardEq hcard).symm.injective (Subtype.ext hij)

theorem mem_iff_exists_chosenLabel (A : Finset (Point K)) (hcard : A.card = 6) (x : Point K) :
    x ∈ A ↔ ∃ i : Fin 6, chosenLabel A hcard i = x := by
  constructor
  · intro hx
    let y : A := ⟨x, hx⟩
    refine ⟨Finset.equivFinOfCardEq hcard y, ?_⟩
    exact congrArg Subtype.val ((Finset.equivFinOfCardEq hcard).symm_apply_apply y)
  · rintro ⟨i, rfl⟩
    exact ((Finset.equivFinOfCardEq hcard).symm i).property

/-- The canonical labelling, packaged as an embedding for mapping endpoint finsets. -/
noncomputable def chosenLabelEmbedding (A : Finset (Point K)) (hcard : A.card = 6) :
    Fin 6 ↪ Point K :=
  ⟨chosenLabel A hcard, chosenLabel_injective A hcard⟩

/-- A valid canonical edge of `K₆`, regarded as an unordered pair of arc points. -/
noncomputable def labelledArcPair (A : Finset (Point K)) (hcard : A.card = 6)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) : ArcPair A := by
  classical
  refine ⟨(SixVertexOneFactorization.edgeVertices e).map
    (chosenLabelEmbedding A hcard), ?_⟩
  rw [Finset.mem_powersetCard]
  constructor
  · intro x hx
    obtain ⟨i, hi, rfl⟩ := Finset.mem_map.mp hx
    exact ((Finset.equivFinOfCardEq hcard).symm i).property
  · rw [Finset.card_map]
    have helt : e.1 < e.2 := (Finset.mem_filter.mp he).2
    simp [SixVertexOneFactorization.edgeVertices, ne_of_lt helt]

theorem chosenLabel_mem_labelledArcPair
    (A : Finset (Point K)) (hcard : A.card = 6)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) {i : Fin 6}
    (hi : i ∈ SixVertexOneFactorization.edgeVertices e) :
    chosenLabel A hcard i ∈ (labelledArcPair A hcard e he).1 := by
  classical
  exact Finset.mem_map.mpr ⟨i, hi, rfl⟩

theorem labelledArcPair_injective_on
    (A : Finset (Point K)) (hcard : A.card = 6)
    {e f : SixVertexOneFactorization.Edge}
    (he : e ∈ SixVertexOneFactorization.allEdges)
    (hf : f ∈ SixVertexOneFactorization.allEdges)
    (h : labelledArcPair A hcard e he = labelledArcPair A hcard f hf) : e = f := by
  apply SixVertexOneFactorization.edgeVertices_injective_on_allEdges he hf
  apply Finset.map_injective (chosenLabelEmbedding A hcard)
  exact congrArg Subtype.val h

/-- The chord determined by a valid canonical edge. -/
noncomputable def labelledChordLine (A : Finset (Point K)) (hcard : A.card = 6)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) : Point K :=
  (labelledArcPair A hcard e he).line (L := Point K)

theorem labelledChordLine_ne_disjointLine
    {A : Finset (Point K)} (hcard : A.card = 6) {l : Point K}
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) :
    labelledChordLine A hcard e he ≠ l := by
  intro hel
  have hi : e.1 ∈ SixVertexOneFactorization.edgeVertices e := by
    simp [SixVertexOneFactorization.edgeVertices]
  have hpair := chosenLabel_mem_labelledArcPair A hcard e he hi
  have hchord : chosenLabel A hcard e.1 ∈ labelledChordLine A hcard e he :=
    (labelledArcPair A hcard e he).mem_line hpair
  have hA : chosenLabel A hcard e.1 ∈ A :=
    ((Finset.equivFinOfCardEq hcard).symm e.1).property
  exact (Finset.disjoint_left.mp hdisj)
    (mem_pointsOnLine.mpr (hel ▸ hchord)) hA

/-- The point where a labelled chord meets a line disjoint from the arc. -/
noncomputable def chordDirection
    (A : Finset (Point K)) (hcard : A.card = 6) (l : Point K)
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) : Point K :=
  OddSixArcLineBound.lineIntersection (P := Point K) l
    (labelledChordLine A hcard e he)
    (Ne.symm (labelledChordLine_ne_disjointLine hcard hdisj e he))

theorem chordDirection_mem_line
    {A : Finset (Point K)} (hcard : A.card = 6) {l : Point K}
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) :
    chordDirection A hcard l hdisj e he ∈ l :=
  OddSixArcLineBound.lineIntersection_mem_left _ _ _

theorem chordDirection_mem_chordLine
    {A : Finset (Point K)} (hcard : A.card = 6) {l : Point K}
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) :
    chordDirection A hcard l hdisj e he ∈ labelledChordLine A hcard e he :=
  OddSixArcLineBound.lineIntersection_mem_right _ _ _

theorem chordDirection_mem_coveredOnLine
    {A : Finset (Point K)} (hcard : A.card = 6) {l : Point K}
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (e : SixVertexOneFactorization.Edge)
    (he : e ∈ SixVertexOneFactorization.allEdges) :
    chordDirection A hcard l hdisj e he ∈
      OddSixArcLineBound.coveredOnLine (P := Point K) A l := by
  rw [OddSixArcLineBound.mem_coveredOnLine]
  constructor
  · exact OddSixArcLineBound.lineIntersection_mem_left _ _ _
  · rw [covered_iff_exists_secant]
    refine ⟨labelledChordLine A hcard e he, ?_,
      OddSixArcLineBound.lineIntersection_mem_right _ _ _⟩
    obtain ⟨a, b, hab, hp⟩ := (labelledArcPair A hcard e he).exists_eq_pair
    refine ⟨a, (labelledArcPair A hcard e he).subset (by simp [hp]),
      b, (labelledArcPair A hcard e he).subset (by simp [hp]), hab, ?_, ?_⟩
    · exact (labelledArcPair A hcard e he).mem_line (by simp [hp])
    · exact (labelledArcPair A hcard e he).mem_line (by simp [hp])

/-- Colour a canonical chord by its intersection point on a five-point covered line. -/
noncomputable def chordColor
    (A : Finset (Point K)) (hcard : A.card = 6) (l : Point K)
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5) :
    SixVertexOneFactorization.Edge → Fin 5 := fun e =>
  if he : e ∈ SixVertexOneFactorization.allEdges then
    Finset.equivFinOfCardEq hfive
      ⟨chordDirection A hcard l hdisj e he,
        chordDirection_mem_coveredOnLine hcard hdisj e he⟩
  else 0

theorem chordColor_eq_iff_direction_eq
    {A : Finset (Point K)} (hcard : A.card = 6) {l : Point K}
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5)
    {e f : SixVertexOneFactorization.Edge}
    (he : e ∈ SixVertexOneFactorization.allEdges)
    (hf : f ∈ SixVertexOneFactorization.allEdges) :
    chordColor A hcard l hdisj hfive e = chordColor A hcard l hdisj hfive f ↔
      chordDirection A hcard l hdisj e he = chordDirection A hcard l hdisj f hf := by
  simp only [chordColor, dif_pos he, dif_pos hf]
  constructor
  · intro h
    exact congrArg Subtype.val ((Finset.equivFinOfCardEq hfive).injective h)
  · intro h
    exact congrArg (Finset.equivFinOfCardEq hfive) (Subtype.ext h)

theorem chordColor_proper
    (A : Finset (Point K)) (hA : Arc (L := Point K) A) (hcard : A.card = 6)
    (l : Point K) (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5) :
    SixVertexOneFactorization.IsProperFiveEdgeColoring
      (chordColor A hcard l hdisj hfive) := by
  intro e f he hf hef
  rintro ⟨i, hie, hif⟩ hcolor
  have hd : chordDirection A hcard l hdisj e he =
      chordDirection A hcard l hdisj f hf :=
    (chordColor_eq_iff_direction_eq hcard hdisj hfive he hf).mp hcolor
  have hiA : chosenLabel A hcard i ∈ A :=
    ((Finset.equivFinOfCardEq hcard).symm i).property
  have hil : chosenLabel A hcard i ∉ l := by
    intro hil
    exact (Finset.disjoint_left.mp hdisj) (mem_pointsOnLine.mpr hil) hiA
  have hiE : chosenLabel A hcard i ∈ labelledChordLine A hcard e he :=
    (labelledArcPair A hcard e he).mem_line
      (chosenLabel_mem_labelledArcPair A hcard e he hie)
  have hiF : chosenLabel A hcard i ∈ labelledChordLine A hcard f hf :=
    (labelledArcPair A hcard f hf).mem_line
      (chosenLabel_mem_labelledArcPair A hcard f hf hif)
  have hdE := chordDirection_mem_chordLine hcard hdisj e he
  have hdF := chordDirection_mem_chordLine hcard hdisj f hf
  have hid : chosenLabel A hcard i ≠ chordDirection A hcard l hdisj e he := by
    intro hid
    exact hil (hid ▸ chordDirection_mem_line hcard hdisj e he)
  have hlines : labelledChordLine A hcard e he = labelledChordLine A hcard f hf :=
    (Configuration.Nondegenerate.eq_or_eq hiE hdE hiF (hd ▸ hdF)).resolve_left hid
  exact hef (labelledArcPair_injective_on A hcard he hf
    ((ArcPair.line_injective hA) hlines))

/-- The covered point named by a chord colour. -/
noncomputable def colorPoint (A : Finset (Point K)) (l : Point K)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5)
    (i : Fin 5) : Point K :=
  ((Finset.equivFinOfCardEq hfive).symm i :
    OddSixArcLineBound.coveredOnLine (P := Point K) A l)

theorem colorPoint_mem_line (A : Finset (Point K)) (l : Point K)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5)
    (i : Fin 5) : colorPoint A l hfive i ∈ l :=
  (OddSixArcLineBound.mem_coveredOnLine.mp
    ((Finset.equivFinOfCardEq hfive).symm i).property).1

theorem chordDirection_eq_colorPoint
    (A : Finset (Point K)) (hcard : A.card = 6) (l : Point K)
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5)
    {e : SixVertexOneFactorization.Edge}
    (he : e ∈ SixVertexOneFactorization.allEdges) {i : Fin 5}
    (hcolor : chordColor A hcard l hdisj hfive e = i) :
    chordDirection A hcard l hdisj e he = colorPoint A l hfive i := by
  have hsub : (⟨chordDirection A hcard l hdisj e he,
        chordDirection_mem_coveredOnLine hcard hdisj e he⟩ :
      OddSixArcLineBound.coveredOnLine (P := Point K) A l) =
      (Finset.equivFinOfCardEq hfive).symm i := by
    apply (Finset.equivFinOfCardEq hfive).injective
    simpa [chordColor, he] using hcolor
  exact congrArg Subtype.val hsub

theorem collinear_colorPoint_edge
    (A : Finset (Point K)) (hcard : A.card = 6) (l : Point K)
    (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5)
    {i : Fin 5} {a b : SixVertexOneFactorization.Vertex} (hab : a ≠ b)
    (hcolor : chordColor A hcard l hdisj hfive
      (SixVertexOneFactorization.edge a b) = i) :
    Collinear (L := Point K) (colorPoint A l hfive i)
      (chosenLabel A hcard a) (chosenLabel A hcard b) := by
  have he : SixVertexOneFactorization.edge a b ∈ SixVertexOneFactorization.allEdges :=
    SixVertexOneFactorization.edge_mem_allEdges_of_ne hab
  refine ⟨labelledChordLine A hcard (SixVertexOneFactorization.edge a b) he, ?_, ?_, ?_⟩
  · rw [← chordDirection_eq_colorPoint A hcard l hdisj hfive he hcolor]
    exact chordDirection_mem_chordLine hcard hdisj _ he
  · apply (labelledArcPair A hcard (SixVertexOneFactorization.edge a b) he).mem_line
    apply chosenLabel_mem_labelledArcPair A hcard _ he
    rw [SixVertexOneFactorization.edgeVertices_edge]
    simp
  · apply (labelledArcPair A hcard (SixVertexOneFactorization.edge a b) he).mem_line
    apply chosenLabel_mem_labelledArcPair A hcard _ he
    rw [SixVertexOneFactorization.edgeVertices_edge]
    simp

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

/-- The equality case of the disjoint-line incidence bound supplies the required triangular
prism.  This is the internal extraction step linking the five index-three chord fibers to the
odd-characteristic affine obstruction. -/
theorem incidencePrismWitness_of_five
    (A : Finset (Point K)) (hA : Arc (L := Point K) A) (hcard : A.card = 6)
    (l : Point K) (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hfive : (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card = 5) :
    IncidencePrismWitness (K := K) A l := by
  let color := chordColor A hcard l hdisj hfive
  have hproper : SixVertexOneFactorization.IsProperFiveEdgeColoring color :=
    chordColor_proper A hA hcard l hdisj hfive
  obtain ⟨q, hq, i₀, i₁, i₂, hi01, hi02, hi12,
      hc01, hc23, hc45, hc02, hc14, hc35, hc03, hc15, hc24⟩ :=
    SixVertexOneFactorization.properFiveEdgeColoring_extract_prism_edges color hproper
  let p : Fin 6 → Point K := fun j => chosenLabel A hcard (q j)
  let d₀ := colorPoint A l hfive i₀
  let d₁ := colorPoint A l hfive i₁
  let d₂ := colorPoint A l hfive i₂
  have hp : Function.Injective p :=
    (chosenLabel_injective A hcard).comp hq.1
  have hpA (x : Point K) : x ∈ A ↔ ∃ i, p i = x := by
    rw [mem_iff_exists_chosenLabel A hcard x]
    constructor
    · rintro ⟨j, rfl⟩
      obtain ⟨i, rfl⟩ := hq.2 j
      exact ⟨i, rfl⟩
    · rintro ⟨i, rfl⟩
      exact ⟨q i, rfl⟩
  have hd_ne {i j : Fin 5} (hij : i ≠ j) :
      colorPoint A l hfive i ≠ colorPoint A l hfive j := by
    intro h
    apply hij
    apply (Finset.equivFinOfCardEq hfive).symm.injective
    exact Subtype.ext h
  refine ⟨p, d₀, d₁, d₂, hp, hpA,
    hd_ne hi01, hd_ne hi02, hd_ne hi12,
    colorPoint_mem_line A l hfive i₀,
    colorPoint_mem_line A l hfive i₁,
    colorPoint_mem_line A l hfive i₂, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals simp only [p, d₀, d₁, d₂]
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (0 : Fin 6) ≠ 1)) hc01
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (2 : Fin 6) ≠ 3)) hc23
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (4 : Fin 6) ≠ 5)) hc45
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (0 : Fin 6) ≠ 2)) hc02
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (1 : Fin 6) ≠ 4)) hc14
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (3 : Fin 6) ≠ 5)) hc35
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (0 : Fin 6) ≠ 3)) hc03
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (1 : Fin 6) ≠ 5)) hc15
  · exact collinear_colorPoint_edge A hcard l hdisj hfive
      (hq.1.ne (by decide : (2 : Fin 6) ≠ 4)) hc24

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
excludes the case. -/
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

/-- A line disjoint from a six-arc in an odd Desarguesian plane cannot have exactly five covered
points. -/
theorem card_coveredOnLine_ne_five
    {A : Finset (Point K)} (hA : Arc (L := Point K) A) (hcard : A.card = 6)
    {l : Point K} (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hodd : (2 : K) ≠ 0) :
    (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card ≠ 5 := by
  apply card_coveredOnLine_ne_five_of_incidence_extraction hA hcard hdisj hodd
  exact incidencePrismWitness_of_five A hA hcard l hdisj

/-- A line disjoint from a six-arc over a finite field of odd characteristic cannot contain
exactly five covered points.  The proof extracts a one-factorization of the fifteen chords and
excludes its triangular-prism normal form by affine parallelism. -/
theorem disjointLine_fiveUncovered_impossible
    {A : Finset (Point K)} (hA : Arc (L := Point K) A) (hcard : A.card = 6)
    {l : Point K} (hdisj : Disjoint (pointsOnLine (P := Point K) l) A)
    (hodd : (2 : K) ≠ 0) :
    (OddSixArcLineBound.coveredOnLine (P := Point K) A l).card ≠ 5 :=
  card_coveredOnLine_ne_five hA hcard hdisj hodd

/-- Every projective line contains at most `q - 5` ordinary uncovered points of a six-arc in the
Desarguesian plane over a finite field `K` of odd characteristic, where `q` is the plane order. -/
theorem sixArc_uncoveredOnLine_card_le_order_sub_five
    {A : Finset (Point K)} (hA : Arc (L := Point K) A) (hcard : A.card = 6)
    (hodd : (2 : K) ≠ 0) (l : Point K) :
    (OddSixArcLineBound.uncoveredOnLine (P := Point K) A l).card ≤
      PlaneOrder (Point K) (Point K) - 5 := by
  apply OddSixArcLineBound.uncoveredOnLine_card_le_order_sub_five hA hcard
  intro m hdisj
  exact disjointLine_fiveUncovered_impossible hA hcard hdisj hodd

#print axioms incidencePrismWitness_of_five
#print axioms projectivePrismWitness_of_incidence
#print axioms card_coveredOnLine_ne_five_of_incidence_extraction
#print axioms card_coveredOnLine_ne_five
#print axioms disjointLine_fiveUncovered_impossible
#print axioms sixArc_uncoveredOnLine_card_le_order_sub_five

end OddSixArcPrismExtraction
end RelativeConicArcs
