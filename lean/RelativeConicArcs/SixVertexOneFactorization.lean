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

#print axioms oneFactorization_has_triangularPrism_normalForm

end SixVertexOneFactorization
end RelativeConicArcs
