import RelativeConicArcs.Q11Coding

/-!
# The Brianchon--Petersen dictionary of the Clebsch hexagon

This file is a strict-kernel finite certificate for the `q = 11` dictionary used in the
Clebsch-hexagon paper.  It starts from the six certified witness columns in `Q11Coding` and checks:

* the five displayed synthemes form a one-factorization of `K₆`;
* their ten unordered pairs have ten distinct antipodal perfect matchings, exactly the other ten
  perfect matchings of `K₆`;
* the resulting ten two-subsets carry the Petersen graph;
* the three witness chords in each antipodal matching concur at the displayed Brianchon point; and
* all 45 intersections of disjoint chord pairs have multiplicity ledger `3^10 1^15`, with the ten
  triple points exactly the displayed Brianchon points.

All proofs use ordinary `decide`; no native evaluator or external certificate is trusted.
-/

namespace RelativeConicArcs.Examples.Q11BrianchonPetersen

open Certificate Q11Coding

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

abbrev Vertex := Fin 6
abbrev Edge := Vertex × Vertex
abbrev Matching := Finset Edge
abbrev Point := Vec (ZMod 11)
abbrev AffinePointCode := Fin 11 × Fin 11

/-- The six displayed Clebsch vertices, copied transparently from `q11Witness`. -/
def vertexVec (i : Fin 6) : Point :=
  ![
    ![1, 10, 0], ![1, 9, 1], ![1, 4, 7],
    ![1, 8, 5], ![0, 1, 4], ![1, 1, 7]
  ] i

/-- The transparent table is definitionally the witness-vector table used by `Q11Coding`. -/
theorem vertexVec_eq_witnessVec (i : Fin 6) : vertexVec i = witnessVec i := by
  fin_cases i <;> rfl

/-- The canonically oriented edge on two labels. -/
def edge (a b : Vertex) : Edge :=
  if a < b then (a, b) else (b, a)

/-- The fifteen edges of `K₆`, oriented increasingly. -/
def allEdges : Finset Edge :=
  Finset.univ.filter fun e => e.1 < e.2

def edgeVertices (e : Edge) : Finset Vertex := {e.1, e.2}

/-- A concrete matching constructor used by the displayed tables. -/
def matching (a b c d e f : Vertex) : Matching :=
  {edge a b, edge c d, edge e f}

def IsPerfectMatching (M : Matching) : Prop :=
  M ⊆ allEdges ∧ M.card = 3 ∧
    ∀ v : Vertex, (M.filter fun e => v ∈ edgeVertices e).card = 1

instance (M : Matching) : Decidable (IsPerfectMatching M) := by
  unfold IsPerfectMatching
  infer_instance

/-- All fifteen perfect matchings (synthemes) of `K₆`. -/
def allPerfectMatchings : Finset Matching :=
  (allEdges.powersetCard 3).filter IsPerfectMatching

/-- Edge--Dye's five self-polar triangles, as a synthematic total. -/
def invariantTriangle (i : Fin 5) : Matching :=
  ![
    matching 0 1 2 3 4 5,
    matching 0 2 1 4 3 5,
    matching 0 3 1 5 2 4,
    matching 0 4 1 3 2 5,
    matching 0 5 1 2 3 4
  ] i

def invariantTotal : Finset Matching :=
  Finset.univ.image invariantTriangle

/-- The ten unordered pairs of the five invariant triangles, in the paper's table order. -/
def trianglePair (k : Fin 10) : Finset (Fin 5) :=
  ![
    {0, 1}, {0, 2}, {0, 3}, {0, 4}, {1, 2},
    {1, 3}, {1, 4}, {2, 3}, {2, 4}, {3, 4}
  ] k

/-- The distance-three matching in the alternating six-cycle belonging to `trianglePair k`. -/
def brianchonMatching (k : Fin 10) : Matching :=
  ![
    matching 0 5 1 3 2 4,
    matching 0 4 1 2 3 5,
    matching 0 2 1 5 3 4,
    matching 0 3 1 4 2 5,
    matching 0 1 2 5 3 4,
    matching 0 3 1 2 4 5,
    matching 0 4 1 5 2 3,
    matching 0 5 1 4 2 3,
    matching 0 2 1 3 4 5,
    matching 0 1 2 4 3 5
  ] k

def brianchonMatchings : Finset Matching :=
  Finset.univ.image brianchonMatching

/-- Codes `(y,z)` for the normalized points `(1,y,z)`, in the paper's table order. -/
def brianchonPointCode (k : Fin 10) : AffinePointCode :=
  ![
    (3, 3), (7, 10), (5, 4), (5, 7), (3, 7),
    (0, 3), (6, 6), (0, 9), (7, 9), (6, 4)
  ] k

def pointOfCode (p : AffinePointCode) : Point :=
  ![1, (p.1.1 : ZMod 11), (p.2.1 : ZMod 11)]

def brianchonPoint (k : Fin 10) : Point :=
  pointOfCode (brianchonPointCode k)

def brianchonPointCodes : Finset AffinePointCode :=
  Finset.univ.image brianchonPointCode

/-- Adjacency in the alternating six-cycle formed by triangles `i` and `j`. -/
def cycleAdj (i j : Fin 5) (a b : Vertex) : Prop :=
  edge a b ∈ invariantTriangle i ∪ invariantTriangle j

instance (i j : Fin 5) (a b : Vertex) : Decidable (cycleAdj i j a b) := by
  unfold cycleAdj
  infer_instance

/-- In a six-cycle, distinct nonadjacent vertices with no common neighbour are antipodal. -/
def cycleOpposite (i j : Fin 5) (a b : Vertex) : Prop :=
  a ≠ b ∧ ¬cycleAdj i j a b ∧
    ¬∃ c : Vertex, cycleAdj i j a c ∧ cycleAdj i j c b

instance (i j : Fin 5) (a b : Vertex) : Decidable (cycleOpposite i j a b) := by
  unfold cycleOpposite
  infer_instance

/-- The pair indices recorded in an entry. -/
def trianglePairLeft (k : Fin 10) : Fin 5 :=
  ![0, 0, 0, 0, 1, 1, 1, 2, 2, 3] k

def trianglePairRight (k : Fin 10) : Fin 5 :=
  ![1, 2, 3, 4, 2, 3, 4, 3, 4, 4] k

def IsAntipodalMatching (k : Fin 10) (M : Matching) : Prop :=
  ∀ e ∈ M,
    cycleOpposite (trianglePairLeft k) (trianglePairRight k) e.1 e.2

instance (k : Fin 10) (M : Matching) : Decidable (IsAntipodalMatching k M) := by
  unfold IsAntipodalMatching
  infer_instance

/-- The five triangles really form a one-factorization of `K₆`. -/
theorem invariant_total_oneFactorization :
    allEdges.card = 15 ∧
      invariantTotal.card = 5 ∧
      (∀ i : Fin 5, IsPerfectMatching (invariantTriangle i)) ∧
      Finset.univ.biUnion invariantTriangle = allEdges := by
  decide

/-- There are fifteen perfect matchings; the ten table matchings are precisely those outside the
invariant synthematic total. -/
theorem brianchon_matchings_are_complement :
    allPerfectMatchings.card = 15 ∧
      brianchonMatchings.card = 10 ∧
      (∀ k : Fin 10, IsPerfectMatching (brianchonMatching k)) ∧
      Disjoint invariantTotal brianchonMatchings ∧
      invariantTotal ∪ brianchonMatchings = allPerfectMatchings := by
  decide

/-- The table lists every unordered pair of invariant triangles exactly once. -/
theorem triangle_pairs_complete :
    (Finset.univ.image trianglePair).card = 10 ∧
      Finset.univ.image trianglePair = (Finset.univ : Finset (Fin 5)).powersetCard 2 := by
  decide

/-- The matching in each table row is characterized intrinsically as the unique perfect matching
whose three edges join antipodal vertices of the corresponding alternating six-cycle. -/
theorem brianchon_matching_is_unique_antipodal :
    ∀ k : Fin 10,
      allPerfectMatchings.filter (IsAntipodalMatching k) = {brianchonMatching k} := by
  intro k
  fin_cases k <;> decide

/-- Cross product of two point or line coordinate vectors. -/
def cross (u v : Point) : Point :=
  ![
    u 1 * v 2 - u 2 * v 1,
    u 2 * v 0 - u 0 * v 2,
    u 0 * v 1 - u 1 * v 0
  ]

def dot (u v : Point) : ZMod 11 :=
  u 0 * v 0 + u 1 * v 1 + u 2 * v 2

/-- The line through two displayed Clebsch vertices. -/
def rawChordLine (e : Edge) : Point :=
  cross (vertexVec e.1) (vertexVec e.2)

def Incident (p line : Point) : Prop := dot line p = 0

instance (p line : Point) : Decidable (Incident p line) := by
  unfold Incident
  infer_instance

/-- Every table matching consists of three chords through its displayed Brianchon point. -/
theorem brianchon_concurrences :
    brianchonPointCodes.card = 10 ∧
      ∀ k : Fin 10, ∀ e ∈ brianchonMatching k,
        Incident (brianchonPoint k) (rawChordLine e) := by
  refine ⟨by decide, ?_⟩
  intro k
  fin_cases k <;>
    simp [brianchonMatching, matching, edge, Incident, rawChordLine, cross, dot,
      brianchonPoint, brianchonPointCode, pointOfCode, vertexVec] <;>
    norm_num <;> decide

def EdgesDisjoint (e f : Edge) : Prop :=
  e.1 ≠ f.1 ∧ e.1 ≠ f.2 ∧ e.2 ≠ f.1 ∧ e.2 ≠ f.2

instance (e f : Edge) : Decidable (EdgesDisjoint e f) := by
  unfold EdgesDisjoint
  infer_instance

/-- The fifteen edges in lexicographic order. -/
def chordEdge (i : Fin 15) : Edge :=
  ![
    (0, 1), (0, 2), (0, 3), (0, 4), (0, 5),
    (1, 2), (1, 3), (1, 4), (1, 5),
    (2, 3), (2, 4), (2, 5),
    (3, 4), (3, 5), (4, 5)
  ] i

/-- The 45 disjoint chord pairs, represented by indices into `chordEdge`. -/
def formalChordIndexPair (i : Fin 45) : Fin 15 × Fin 15 :=
  ![
    (0, 9), (0, 10), (0, 11), (0, 12), (0, 13), (0, 14),
    (1, 6), (1, 7), (1, 8), (1, 12), (1, 13), (1, 14),
    (2, 5), (2, 7), (2, 8), (2, 10), (2, 11), (2, 14),
    (3, 5), (3, 6), (3, 8), (3, 9), (3, 11), (3, 13),
    (4, 5), (4, 6), (4, 7), (4, 9), (4, 10), (4, 12),
    (5, 12), (5, 13), (5, 14),
    (6, 10), (6, 11), (6, 14),
    (7, 9), (7, 11), (7, 13),
    (8, 9), (8, 10), (8, 12),
    (9, 14), (10, 13), (11, 12)
  ] i

def indexedFormalChordPair (i : Fin 45) : Edge × Edge :=
  (chordEdge (formalChordIndexPair i).1, chordEdge (formalChordIndexPair i).2)

/-- The 45 formal intersections of chord pairs with four distinct endpoints. -/
def formalDisjointChordPairs : Finset (Edge × Edge) :=
  Finset.univ.image indexedFormalChordPair

def EdgeLexLess (e f : Edge) : Prop :=
  e.1 < f.1 ∨ (e.1 = f.1 ∧ e.2 < f.2)

instance (e f : Edge) : Decidable (EdgeLexLess e f) := by
  unfold EdgeLexLess
  infer_instance

/-- Normalized affine codes for those 45 intersections, in matching order. -/
def chordIntersectionCode (i : Fin 45) : AffinePointCode :=
  ![
    (2,8), (6,4), (3,7), (3,7), (6,4), (8,2),
    (7,9), (3,10), (5,4), (5,4), (2,2), (7,9),
    (0,3), (5,7), (2,9), (1,6), (5,7), (0,3),
    (7,10), (0,4), (6,6), (6,6), (9,7), (7,10),
    (2,5), (3,3), (0,9), (0,9), (3,3), (6,8),
    (10,2), (7,10), (0,3),
    (3,3), (2,7), (7,9),
    (0,9), (5,7), (4,3),
    (6,6), (7,8), (5,4),
    (5,1), (6,4), (3,7)
  ] i

def chordIntersectionCodes : Finset AffinePointCode :=
  Finset.univ.image chordIntersectionCode

def chordIntersectionMultiplicity (p : AffinePointCode) : ℕ :=
  (Finset.univ.filter fun i : Fin 45 => chordIntersectionCode i = p).card

def tripleChordIntersectionCodes : Finset AffinePointCode :=
  chordIntersectionCodes.filter fun p => chordIntersectionMultiplicity p = 3

def singletonChordIntersectionCodes : Finset AffinePointCode :=
  chordIntersectionCodes.filter fun p => chordIntersectionMultiplicity p = 1

/-- The explicit index table enumerates the intrinsic set of formal disjoint chord pairs. -/
theorem formal_chord_pair_table_complete :
    formalDisjointChordPairs.card = 45 ∧
      (∀ i : Fin 45,
        EdgeLexLess (indexedFormalChordPair i).1 (indexedFormalChordPair i).2 ∧
          EdgesDisjoint (indexedFormalChordPair i).1 (indexedFormalChordPair i).2) := by
  constructor
  · decide
  · intro i
    fin_cases i <;> decide

/-- Each tabulated intersection code lies on both of its indexed raw chord lines. -/
theorem chord_intersection_table_sound :
    ∀ i : Fin 45,
      let p := pointOfCode (chordIntersectionCode i)
      let pair := indexedFormalChordPair i
      Incident p (rawChordLine pair.1) ∧ Incident p (rawChordLine pair.2) := by
  intro i
  fin_cases i <;>
    norm_num [chordIntersectionCode, indexedFormalChordPair, formalChordIndexPair, chordEdge,
      pointOfCode, Incident, rawChordLine, cross, dot, vertexVec] <;>
    decide

/-- The independent complete chord-intersection ledger: `45 = 10·3 + 15·1`, and the ten
triple points are exactly the Brianchon points constructed from the triangle pairs. -/
theorem disjoint_chord_intersection_ledger :
    formalDisjointChordPairs.card = 45 ∧
      chordIntersectionCodes.card = 25 ∧
      tripleChordIntersectionCodes.card = 10 ∧
      singletonChordIntersectionCodes.card = 15 ∧
      tripleChordIntersectionCodes ∪ singletonChordIntersectionCodes =
        chordIntersectionCodes ∧
      tripleChordIntersectionCodes = brianchonPointCodes := by
  refine ⟨by decide, by decide, by decide, by decide, by decide, by decide⟩

/-- Petersen adjacency on the ten triangle pairs is disjointness as two-subsets of five labels. -/
def PetersenAdj (i j : Fin 10) : Prop :=
  i ≠ j ∧ Disjoint (trianglePair i) (trianglePair j)

instance (i j : Fin 10) : Decidable (PetersenAdj i j) := by
  unfold PetersenAdj
  infer_instance

def petersenNeighbors (i : Fin 10) : Finset (Fin 10) :=
  Finset.univ.filter (PetersenAdj i)

def petersenEdges : Finset (Fin 10 × Fin 10) :=
  Finset.univ.filter fun e => e.1 < e.2 ∧ PetersenAdj e.1 e.2

/-- The disjointness graph is the strongly regular Petersen graph with parameters `(10,3,0,1)`. -/
theorem petersen_parameters :
    petersenEdges.card = 15 ∧
      (∀ i : Fin 10, (petersenNeighbors i).card = 3) ∧
      (∀ i j : Fin 10, i ≠ j → PetersenAdj i j →
        ((petersenNeighbors i).filter fun k => k ∈ petersenNeighbors j).card = 0) ∧
      (∀ i j : Fin 10, i ≠ j → ¬PetersenAdj i j →
        ((petersenNeighbors i).filter fun k => k ∈ petersenNeighbors j).card = 1) := by
  decide

#print axioms invariant_total_oneFactorization
#print axioms brianchon_concurrences
#print axioms disjoint_chord_intersection_ledger
#print axioms petersen_parameters

end RelativeConicArcs.Examples.Q11BrianchonPetersen
