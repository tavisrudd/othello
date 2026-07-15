import RelativeConicArcs.ClebschChordDefect

/-!
# The unique one-factorization of `K₆`

This file isolates the finite combinatorics used by the triangular-prism argument for a six-arc.
A matching is represented as three canonically oriented edges on `Fin 6`.  We enumerate the fifteen
perfect matchings and the five-subsets which partition all fifteen edges.  A strict-kernel finite
certificate then proves that every such one-factorization is carried by a vertex relabelling to the
displayed standard total.

The first three matchings of that total form two triangles joined by a perfect matching: the
triangular-prism normal form needed by the affine-geometric argument.  The public theorem exposes
only a bijective relabelling and containment of these three factors, so downstream geometry need not
depend on the enumeration.
-/

namespace RelativeConicArcs
namespace SixVertexOneFactorization

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

abbrev Vertex := Fin 6
abbrev Edge := Vertex × Vertex
abbrev Matching := Finset Edge
abbrev Total := Finset Matching

/-- The canonically oriented edge with endpoints `a` and `b`. -/
def edge (a b : Vertex) : Edge :=
  if a < b then (a, b) else (b, a)

/-- All fifteen (non-loop) edges of `K₆`, oriented increasingly. -/
def allEdges : Finset Edge :=
  Finset.univ.filter fun e => e.1 < e.2

def edgeVertices (e : Edge) : Finset Vertex := {e.1, e.2}

/-- A canonically oriented edge is determined by its unordered endpoint set.  The membership
hypotheses fence the statement to the fifteen genuine edges, where the orientation is increasing. -/
theorem edgeVertices_injective_on_allEdges :
    ∀ ⦃e f : Edge⦄, e ∈ allEdges → f ∈ allEdges →
      edgeVertices e = edgeVertices f → e = f := by
  decide

/-- A convenient constructor for a matching displayed as three pairs. -/
def matching (a b c d e f : Vertex) : Matching :=
  {edge a b, edge c d, edge e f}

/-- A three-edge set is perfect when every vertex occurs exactly once. -/
def IsPerfectMatching (M : Matching) : Prop :=
  M ⊆ allEdges ∧ M.card = 3 ∧
    ∀ v : Vertex, (M.filter fun e => v ∈ edgeVertices e).card = 1

instance (M : Matching) : Decidable (IsPerfectMatching M) := by
  unfold IsPerfectMatching
  infer_instance

/-- The finite set of all perfect matchings of `K₆`. -/
def allPerfectMatchings : Finset Matching :=
  (allEdges.powersetCard 3).filter IsPerfectMatching

/-- All five-subsets of perfect matchings which partition the edge set of `K₆`. -/
def allOneFactorizations : Finset Total :=
  (allPerfectMatchings.powersetCard 5).filter fun T => T.biUnion id = allEdges

/-- Semantic interface for a one-factorization, backed by the finite enumerator. -/
def IsOneFactorization (T : Total) : Prop := T ∈ allOneFactorizations

instance (T : Total) : Decidable (IsOneFactorization T) := by
  unfold IsOneFactorization
  infer_instance

/-- Unpack the enumerator-backed definition into the usual partition conditions. -/
theorem isOneFactorization_iff (T : Total) :
    IsOneFactorization T ↔
      T.card = 5 ∧
      (∀ M ∈ T, IsPerfectMatching M) ∧
      T.biUnion id = allEdges := by
  unfold IsOneFactorization allOneFactorizations
  simp only [Finset.mem_filter, Finset.mem_powersetCard]
  constructor
  · rintro ⟨⟨hsub, hcard⟩, hunion⟩
    refine ⟨hcard, ?_, hunion⟩
    intro M hM
    have hPM := hsub hM
    simp only [allPerfectMatchings, Finset.mem_filter,
      Finset.mem_powersetCard] at hPM
    exact hPM.2
  · rintro ⟨hcard, hperfect, hunion⟩
    refine ⟨⟨?_, hcard⟩, hunion⟩
    intro M hM
    have hPM := hperfect M hM
    simp only [allPerfectMatchings, Finset.mem_filter,
      Finset.mem_powersetCard]
    exact ⟨⟨hPM.1, hPM.2.1⟩, hPM⟩

/-- The five factors in the standard synthematic total. -/
def standardFactor (i : Fin 5) : Matching :=
  ![
    matching 0 1 2 3 4 5,
    matching 0 2 1 4 3 5,
    matching 0 3 1 5 2 4,
    matching 0 4 1 3 2 5,
    matching 0 5 1 2 3 4
  ] i

def standardTotal : Total := Finset.univ.image standardFactor

/-- The three standard factors whose union is a triangular prism.  Its triangular faces are
`{0,2,3}` and `{1,4,5}`; the remaining three edges join corresponding vertices. -/
def prismFactors : Total :=
  {standardFactor 0, standardFactor 1, standardFactor 2}

/-- The labelled triangular-prism graph: triangles `023` and `145`, joined by the matching
`01,24,35`. -/
def triangularPrismEdges : Finset Edge :=
  {edge 0 2, edge 2 3, edge 0 3,
   edge 1 4, edge 4 5, edge 1 5,
   edge 0 1, edge 2 4, edge 3 5}

/-- The union of the three named factors really is the displayed triangular prism. -/
theorem prismFactors_biUnion : prismFactors.biUnion id = triangularPrismEdges := by
  decide

/-- Relabel a canonically oriented edge by a vertex map. -/
def relabelEdge (p : Vertex → Vertex) (e : Edge) : Edge :=
  edge (p e.1) (p e.2)

def relabelMatching (p : Vertex → Vertex) (M : Matching) : Matching :=
  M.image (relabelEdge p)

def relabelTotal (p : Vertex → Vertex) (T : Total) : Total :=
  T.image (relabelMatching p)

/-! ## From a proper five-edge-colouring to a one-factorization -/

/-- The five-edge star at a vertex of `K₆`. -/
def incidentEdges (v : Vertex) : Finset Edge :=
  allEdges.filter fun e => v ∈ edgeVertices e

/-- Properness for a five-colouring of the edges of `K₆`: distinct edges with a common
endpoint receive distinct colours.  Values of `color` away from `allEdges` are irrelevant. -/
def IsProperFiveEdgeColoring (color : Edge → Fin 5) : Prop :=
  ∀ ⦃e f : Edge⦄, e ∈ allEdges → f ∈ allEdges → e ≠ f →
    (∃ v : Vertex, v ∈ edgeVertices e ∧ v ∈ edgeVertices f) → color e ≠ color f

/-- The matching consisting of the edges of one colour. -/
def colorFiber (color : Edge → Fin 5) (i : Fin 5) : Matching :=
  allEdges.filter fun e => color e = i

/-- The five colour fibres, regarded as a candidate synthematic total. -/
def colorTotal (color : Edge → Fin 5) : Total :=
  Finset.univ.image (colorFiber color)

private theorem incidentEdges_card (v : Vertex) : (incidentEdges v).card = 5 := by
  fin_cases v <;> decide

private theorem incident_color_image_eq_univ
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) (v : Vertex) :
    (incidentEdges v).image color = Finset.univ := by
  apply Finset.eq_of_subset_of_card_le (Finset.subset_univ _)
  rw [Finset.card_univ, Fintype.card_fin, Finset.card_image_iff.mpr]
  · exact (incidentEdges_card v).ge
  · intro e he f hf hef
    by_contra hne
    exact hproper
      (Finset.mem_filter.mp he).1
      (Finset.mem_filter.mp hf).1
      hne
      ⟨v, (Finset.mem_filter.mp he).2, (Finset.mem_filter.mp hf).2⟩
      hef

private theorem colorFiber_incident_card
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color)
    (i : Fin 5) (v : Vertex) :
    ((colorFiber color i).filter fun e => v ∈ edgeVertices e).card = 1 := by
  have hi : i ∈ (incidentEdges v).image color := by
    rw [incident_color_image_eq_univ color hproper v]
    simp
  obtain ⟨e, he, hei⟩ := Finset.mem_image.mp hi
  have heall : e ∈ allEdges := (Finset.mem_filter.mp he).1
  have hev : v ∈ edgeVertices e := (Finset.mem_filter.mp he).2
  have hecolor : color e = i := hei
  rw [show (colorFiber color i).filter (fun f => v ∈ edgeVertices f) = {e} by
    ext f
    simp only [Finset.mem_filter, Finset.mem_singleton, colorFiber]
    constructor
    · rintro ⟨⟨hfall, hfcolor⟩, hfv⟩
      by_contra hfe
      exact hproper hfall heall hfe
        ⟨v, hfv, hev⟩ (hfcolor.trans hecolor.symm)
    · rintro rfl
      exact ⟨⟨heall, hecolor⟩, hev⟩]
  simp

private theorem colorFiber_biUnion_edgeVertices
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) (i : Fin 5) :
    (colorFiber color i).biUnion edgeVertices = Finset.univ := by
  ext v
  simp only [Finset.mem_biUnion, Finset.mem_univ, iff_true]
  have hi : i ∈ (incidentEdges v).image color := by
    rw [incident_color_image_eq_univ color hproper v]
    simp
  obtain ⟨e, he, hei⟩ := Finset.mem_image.mp hi
  exact ⟨e, Finset.mem_filter.mpr ⟨(Finset.mem_filter.mp he).1, hei⟩,
    (Finset.mem_filter.mp he).2⟩

private theorem colorFiber_pairwiseDisjoint
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) (i : Fin 5) :
    ((colorFiber color i : Finset Edge) : Set Edge).PairwiseDisjoint edgeVertices := by
  intro e he f hf hef
  change Disjoint (edgeVertices e) (edgeVertices f)
  rw [Finset.disjoint_left]
  intro v hve hvf
  have he' := Finset.mem_filter.mp he
  have hf' := Finset.mem_filter.mp hf
  exact hproper he'.1 hf'.1 hef ⟨v, hve, hvf⟩ (he'.2.trans hf'.2.symm)

private theorem colorFiber_card
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) (i : Fin 5) :
    (colorFiber color i).card = 3 := by
  have hunion := colorFiber_biUnion_edgeVertices color hproper i
  have hcardUnion := Finset.card_biUnion (colorFiber_pairwiseDisjoint color hproper i)
  rw [hunion, Finset.card_univ, Fintype.card_fin] at hcardUnion
  have hedgeCard : ∀ e ∈ colorFiber color i, (edgeVertices e).card = 2 := by
    intro e he
    have helt : e.1 < e.2 :=
      (Finset.mem_filter.mp (Finset.mem_filter.mp he).1).2
    simp [edgeVertices, ne_of_lt helt]
  rw [show (∑ e ∈ colorFiber color i, (edgeVertices e).card) =
      ∑ _e ∈ colorFiber color i, 2 by
    apply Finset.sum_congr rfl
    intro e he
    exact hedgeCard e he] at hcardUnion
  simp at hcardUnion
  omega

private theorem colorFiber_isPerfectMatching
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) (i : Fin 5) :
    IsPerfectMatching (colorFiber color i) := by
  refine ⟨Finset.filter_subset _ _, colorFiber_card color hproper i, ?_⟩
  exact colorFiber_incident_card color hproper i

private theorem colorFiber_injective
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) :
    Function.Injective (colorFiber color) := by
  intro i j hij
  have hi : i ∈ (incidentEdges 0).image color := by
    rw [incident_color_image_eq_univ color hproper 0]
    simp
  obtain ⟨e, he, hei⟩ := Finset.mem_image.mp hi
  have hefi : e ∈ colorFiber color i :=
    Finset.mem_filter.mpr ⟨(Finset.mem_filter.mp he).1, hei⟩
  have hefj : e ∈ colorFiber color j := hij ▸ hefi
  exact hei.symm.trans (Finset.mem_filter.mp hefj).2

/-- The five colour classes of every proper five-edge-colouring of `K₆` are precisely a
one-factorization. -/
theorem properFiveEdgeColoring_isOneFactorization
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) :
    IsOneFactorization (colorTotal color) := by
  rw [isOneFactorization_iff]
  refine ⟨?_, ?_, ?_⟩
  · rw [colorTotal,
      Finset.card_image_of_injective _ (colorFiber_injective color hproper)]
    simp
  · intro M hM
    obtain ⟨i, -, rfl⟩ := Finset.mem_image.mp hM
    exact colorFiber_isPerfectMatching color hproper i
  · ext e
    simp [colorTotal, colorFiber]

/-- The displayed total is itself a one-factorization. -/
theorem standardTotal_isOneFactorization : IsOneFactorization standardTotal := by
  decide

/-- The three prism factors occur in the standard total. -/
theorem prismFactors_subset_standardTotal : prismFactors ⊆ standardTotal := by
  decide

/-- The six permutations fixing `0,1,2` and permuting `3,4,5`. -/
def tailPermutation (i : Fin 6) : Vertex → Vertex :=
  ![
    ![0, 1, 2, 3, 4, 5],
    ![0, 1, 2, 3, 5, 4],
    ![0, 1, 2, 4, 3, 5],
    ![0, 1, 2, 5, 3, 4],
    ![0, 1, 2, 4, 5, 3],
    ![0, 1, 2, 5, 4, 3]
  ] i

/-- The inverse table for `tailPermutation`. -/
def tailPermutationInv (i : Fin 6) : Vertex → Vertex :=
  ![
    ![0, 1, 2, 3, 4, 5],
    ![0, 1, 2, 3, 5, 4],
    ![0, 1, 2, 4, 3, 5],
    ![0, 1, 2, 4, 5, 3],
    ![0, 1, 2, 5, 3, 4],
    ![0, 1, 2, 5, 4, 3]
  ] i

def candidateTotal (i : Fin 6) : Total :=
  relabelTotal (tailPermutation i) standardTotal

/-- There are only six labelled one-factorizations.  This certificate enumerates the 3003
five-subsets of the fifteen perfect matchings, without nesting an existential search over all
`6^6` vertex maps. -/
private theorem allOneFactorizations_eq_candidates :
    allOneFactorizations = Finset.univ.image candidateTotal := by
  decide

private theorem tailPermutationInv_bijective (i : Fin 6) :
    Function.Bijective (tailPermutationInv i) := by
  fin_cases i <;> decide

private theorem relabel_candidateTotal_inverse (i : Fin 6) :
    relabelTotal (tailPermutationInv i) (candidateTotal i) = standardTotal := by
  fin_cases i <;> decide

/-- Every one-factorization of `K₆` can be carried to the standard total by a bijective vertex
relabeling. -/
theorem oneFactorization_relabel_to_standard (T : Total) (hT : IsOneFactorization T) :
    ∃ p : Vertex → Vertex,
      Function.Bijective p ∧ relabelTotal p T = standardTotal := by
  have hmem : T ∈ Finset.univ.image candidateTotal := by
    rw [← allOneFactorizations_eq_candidates]
    exact hT
  obtain ⟨i, _hi, rfl⟩ := Finset.mem_image.mp hmem
  exact ⟨tailPermutationInv i, tailPermutationInv_bijective i,
    relabel_candidateTotal_inverse i⟩

/-- **Triangular-prism normal form.**  After a bijective relabelling of the six vertices, three
factors of any one-factorization are the three displayed prism factors. -/
theorem oneFactorization_has_triangularPrism_normalForm
    (T : Total) (hT : IsOneFactorization T) :
    ∃ p : Vertex → Vertex,
      Function.Bijective p ∧ prismFactors ⊆ relabelTotal p T := by
  obtain ⟨p, hp, hstandard⟩ := oneFactorization_relabel_to_standard T hT
  refine ⟨p, hp, ?_⟩
  rw [hstandard]
  exact prismFactors_subset_standardTotal

/-- **Coloured triangular-prism normal form.**  Three colour classes of every proper
five-edge-colouring of `K₆` become the displayed prism factors after a bijective relabelling. -/
theorem properFiveEdgeColoring_has_triangularPrism_normalForm
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) :
    ∃ p : Vertex → Vertex,
      Function.Bijective p ∧ prismFactors ⊆ relabelTotal p (colorTotal color) := by
  exact oneFactorization_has_triangularPrism_normalForm
    (colorTotal color) (properFiveEdgeColoring_isOneFactorization color hproper)

/-- Geometry-facing form of the coloured prism normal form.  After relabelling the vertices,
three *distinct named colours* become the three displayed prism factors.  This removes both layers
of `Finset.image` witnesses from the interface used by the projective-geometric extraction. -/
theorem properFiveEdgeColoring_extract_prism_colors
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) :
    ∃ p : Vertex → Vertex, Function.Bijective p ∧
      ∃ i₀ i₁ i₂ : Fin 5,
        i₀ ≠ i₁ ∧ i₀ ≠ i₂ ∧ i₁ ≠ i₂ ∧
        relabelMatching p (colorFiber color i₀) = standardFactor 0 ∧
        relabelMatching p (colorFiber color i₁) = standardFactor 1 ∧
        relabelMatching p (colorFiber color i₂) = standardFactor 2 := by
  obtain ⟨p, hp, hprism⟩ :=
    properFiveEdgeColoring_has_triangularPrism_normalForm color hproper
  have h₀ : standardFactor 0 ∈ relabelTotal p (colorTotal color) := hprism (by decide)
  have h₁ : standardFactor 1 ∈ relabelTotal p (colorTotal color) := hprism (by decide)
  have h₂ : standardFactor 2 ∈ relabelTotal p (colorTotal color) := hprism (by decide)
  simp only [relabelTotal, colorTotal, Finset.mem_image, Finset.mem_univ, true_and] at h₀ h₁ h₂
  obtain ⟨M₀, ⟨i₀, hi₀⟩, hM₀⟩ := h₀
  obtain ⟨M₁, ⟨i₁, hi₁⟩, hM₁⟩ := h₁
  obtain ⟨M₂, ⟨i₂, hi₂⟩, hM₂⟩ := h₂
  subst M₀
  subst M₁
  subst M₂
  refine ⟨p, hp, i₀, i₁, i₂, ?_, ?_, ?_, hM₀, hM₁, hM₂⟩
  · intro h
    subst i₁
    have : standardFactor (0 : Fin 5) = standardFactor 1 := hM₀.symm.trans hM₁
    exact (by decide : standardFactor (0 : Fin 5) ≠ standardFactor 1) this
  · intro h
    subst i₂
    have : standardFactor (0 : Fin 5) = standardFactor 2 := hM₀.symm.trans hM₂
    exact (by decide : standardFactor (0 : Fin 5) ≠ standardFactor 2) this
  · intro h
    subst i₂
    have : standardFactor (1 : Fin 5) = standardFactor 2 := hM₁.symm.trans hM₂
    exact (by decide : standardFactor (1 : Fin 5) ≠ standardFactor 2) this

theorem edgeVertices_relabelEdge (p : Vertex → Vertex) (hp : Function.Injective p)
    (e : Edge) :
    edgeVertices (relabelEdge p e) = (edgeVertices e).map ⟨p, hp⟩ := by
  unfold relabelEdge edge edgeVertices
  split <;> simp_all [Finset.pair_comm]

theorem edge_mem_allEdges_of_ne {a b : Vertex} (hab : a ≠ b) : edge a b ∈ allEdges := by
  unfold edge allEdges
  split_ifs with h
  · simp [h]
  · simp only [Finset.mem_filter, Finset.mem_univ, true_and]
    exact lt_of_le_of_ne (not_lt.mp h) (Ne.symm hab)

theorem relabelEdge_injective_on
    (p : Vertex → Vertex) (hp : Function.Injective p)
    {e f : Edge} (he : e ∈ allEdges) (hf : f ∈ allEdges)
    (hrel : relabelEdge p e = relabelEdge p f) : e = f := by
  have hvmap : (edgeVertices e).map ⟨p, hp⟩ = (edgeVertices f).map ⟨p, hp⟩ := by
    rw [← edgeVertices_relabelEdge p hp e,
      ← edgeVertices_relabelEdge p hp f, hrel]
  exact edgeVertices_injective_on_allEdges he hf (Finset.map_injective _ hvmap)

theorem edge_comm (a b : Vertex) : edge a b = edge b a := by
  unfold edge
  by_cases hab : a < b
  · have hba : ¬ b < a := not_lt_of_ge (le_of_lt hab)
    simp [hab, hba]
  · by_cases hba : b < a
    · simp [hab, hba]
    · have heq : a = b := le_antisymm (le_of_not_gt hba) (le_of_not_gt hab)
      simp [heq]

theorem edgeVertices_edge (a b : Vertex) :
    edgeVertices (edge a b) = {a, b} := by
  unfold edge edgeVertices
  split <;> simp_all [Finset.pair_comm]

theorem relabelEdge_edge (p : Vertex → Vertex) (a b : Vertex) :
    relabelEdge p (edge a b) = edge (p a) (p b) := by
  unfold relabelEdge
  by_cases hab : a < b
  · simp [edge, hab]
  · rw [show edge a b = (b, a) by simp [edge, hab]]
    exact edge_comm (p b) (p a)

private theorem color_inverseEdge_of_factor
    (color : Edge → Fin 5) (p : Vertex → Vertex) (hp : Function.Bijective p)
    (i j : Fin 5)
    (hfactor : relabelMatching p (colorFiber color i) = standardFactor j)
    {a b : Vertex} (hab : a ≠ b) (hedge : edge a b ∈ standardFactor j) :
    color (edge ((Equiv.ofBijective p hp).symm a)
      ((Equiv.ofBijective p hp).symm b)) = i := by
  have himage : edge a b ∈ relabelMatching p (colorFiber color i) := by
    rw [hfactor]
    exact hedge
  obtain ⟨e, hecolor, hrel⟩ := Finset.mem_image.mp himage
  have he : e ∈ allEdges := (Finset.mem_filter.mp hecolor).1
  have hinvne : (Equiv.ofBijective p hp).symm a ≠ (Equiv.ofBijective p hp).symm b :=
    (Equiv.ofBijective p hp).symm.injective.ne hab
  let f : Edge := edge ((Equiv.ofBijective p hp).symm a)
      ((Equiv.ofBijective p hp).symm b)
  have hf : f ∈ allEdges := edge_mem_allEdges_of_ne hinvne
  have hfrel : relabelEdge p f = edge a b := by
    rw [show f = edge ((Equiv.ofBijective p hp).symm a)
      ((Equiv.ofBijective p hp).symm b) from rfl,
      relabelEdge_edge]
    have ha := (Equiv.ofBijective p hp).apply_symm_apply a
    have hb := (Equiv.ofBijective p hp).apply_symm_apply b
    change p ((Equiv.ofBijective p hp).symm a) = a at ha
    change p ((Equiv.ofBijective p hp).symm b) = b at hb
    rw [ha, hb]
  have hef : e = f := relabelEdge_injective_on p hp.1 he hf (hrel.trans hfrel.symm)
  simpa [f, hef] using (Finset.mem_filter.mp hecolor).2

/-- Geometry-facing edge form of the prism extraction: after a bijective vertex relabelling,
the nine displayed prism edges have the indicated three distinct colours. -/
theorem properFiveEdgeColoring_extract_prism_edges
    (color : Edge → Fin 5) (hproper : IsProperFiveEdgeColoring color) :
    ∃ q : Vertex → Vertex, Function.Bijective q ∧
      ∃ i₀ i₁ i₂ : Fin 5,
        i₀ ≠ i₁ ∧ i₀ ≠ i₂ ∧ i₁ ≠ i₂ ∧
        color (edge (q 0) (q 1)) = i₀ ∧
        color (edge (q 2) (q 3)) = i₀ ∧
        color (edge (q 4) (q 5)) = i₀ ∧
        color (edge (q 0) (q 2)) = i₁ ∧
        color (edge (q 1) (q 4)) = i₁ ∧
        color (edge (q 3) (q 5)) = i₁ ∧
        color (edge (q 0) (q 3)) = i₂ ∧
        color (edge (q 1) (q 5)) = i₂ ∧
        color (edge (q 2) (q 4)) = i₂ := by
  obtain ⟨p, hp, i₀, i₁, i₂, h01, h02, h12, hf0, hf1, hf2⟩ :=
    properFiveEdgeColoring_extract_prism_colors color hproper
  let ep : Vertex ≃ Vertex := Equiv.ofBijective p hp
  refine ⟨ep.symm, ep.symm.bijective, i₀, i₁, i₂, h01, h02, h12, ?_⟩
  have c01 := color_inverseEdge_of_factor color p hp i₀ 0 hf0
    (a := 0) (b := 1) (by decide) (by decide)
  have c23 := color_inverseEdge_of_factor color p hp i₀ 0 hf0
    (a := 2) (b := 3) (by decide) (by decide)
  have c45 := color_inverseEdge_of_factor color p hp i₀ 0 hf0
    (a := 4) (b := 5) (by decide) (by decide)
  have c02 := color_inverseEdge_of_factor color p hp i₁ 1 hf1
    (a := 0) (b := 2) (by decide) (by decide)
  have c14 := color_inverseEdge_of_factor color p hp i₁ 1 hf1
    (a := 1) (b := 4) (by decide) (by decide)
  have c35 := color_inverseEdge_of_factor color p hp i₁ 1 hf1
    (a := 3) (b := 5) (by decide) (by decide)
  have c03 := color_inverseEdge_of_factor color p hp i₂ 2 hf2
    (a := 0) (b := 3) (by decide) (by decide)
  have c15 := color_inverseEdge_of_factor color p hp i₂ 2 hf2
    (a := 1) (b := 5) (by decide) (by decide)
  have c24 := color_inverseEdge_of_factor color p hp i₂ 2 hf2
    (a := 2) (b := 4) (by decide) (by decide)
  simpa [ep] using ⟨c01, c23, c45, c02, c14, c35, c03, c15, c24⟩

#print axioms oneFactorization_has_triangularPrism_normalForm
#print axioms properFiveEdgeColoring_isOneFactorization
#print axioms properFiveEdgeColoring_has_triangularPrism_normalForm
#print axioms properFiveEdgeColoring_extract_prism_colors
#print axioms properFiveEdgeColoring_extract_prism_edges

end SixVertexOneFactorization
end RelativeConicArcs
