import RelativeConicArcs.FiniteFields

/-!
# The Sylvester obstruction over `GF(9)`

This file is the strict-kernel certificate for the `q = 9` leaf in the Clebsch-hexagon
uniqueness argument.  We use the existing concrete field
`GF(9) = GF(3)[i]/(i^2+1)` and the canonical representatives

* `[1:y:z]`, indexed by `0,...,80`;
* `[0:1:z]`, indexed by `81,...,89`;
* `[0:0:1]`, indexed by `90`.

The quadratic form is `XZ-Y^2`.  Its 36 internal points carry the polarity-conjugacy
graph `H`.  Kernel reduction checks the Sylvester intersection array, identifies passant
joins with exact distance two in `H`, and certifies that the exact-distance-two graph has
clique number five.

The clique upper bound does **not** enumerate powersets and does not trust an external
maximum-clique program.  A checked proper six-colouring forces any hypothetical six-clique to
be rainbow.  A reflected compatible-prefix computation across the six colour classes has sizes
`6,24,66,120,126,0`; the empty final level forbids that rainbow transversal.
All computations below use `decide`, never `native_decide`.
-/

namespace RelativeConicArcs
namespace Q9Sylvester

open FiniteFields

set_option maxHeartbeats 100000000
set_option maxRecDepth 100000

abbrev K := GF9
abbrev Vec3 := Fin 3 → K
abbrev ProjectiveIndex := Fin 91
abbrev Vertex := Fin 36

/-- Canonical representatives of the 91 points of `PG(2,9)`. -/
def projectiveVec (p : ProjectiveIndex) : Vec3 :=
  if _ : p.1 < 81 then
    ![1, GF9.ofNat (p.1 / 9), GF9.ofNat (p.1 % 9)]
  else if _ : p.1 < 90 then
    ![0, 1, GF9.ofNat (p.1 - 81)]
  else
    ![0, 0, 1]

/-- `XZ-Y^2`, in the coordinates used by the manuscript and the independent checker. -/
def quadratic (v : Vec3) : K := v 0 * v 2 - v 1 * v 1

def IsSquare (x : K) : Prop := ∃ y : K, y * y = x

instance (x : K) : Decidable (IsSquare x) := Fintype.decidableExistsFintype

/-- The square-class definition of an internal point for the standard conic. -/
def IsInternalVec (v : Vec3) : Prop := quadratic v ≠ 0 ∧ ¬ IsSquare (quadratic v)

instance (v : Vec3) : Decidable (IsInternalVec v) := by
  unfold IsInternalVec
  infer_instance

/-- The complete catalog of canonical projective indices whose representatives are internal. -/
def internalProjectiveIndex (v : Vertex) : ProjectiveIndex :=
  ![4, 5, 7, 8, 12, 14, 15, 17, 21, 23, 24, 26,
    30, 31, 33, 34, 37, 38, 40, 41, 46, 47, 52, 53,
    57, 58, 60, 61, 64, 65, 70, 71, 73, 74, 76, 77] v

def internalVec (v : Vertex) : Vec3 := projectiveVec (internalProjectiveIndex v)

/-- All 36 catalog entries are internal. -/
theorem catalog_sound : ∀ v : Vertex, IsInternalVec (internalVec v) := by decide

/-- The internal catalog has no duplicate projective indices. -/
theorem catalog_injective : Function.Injective internalProjectiveIndex := by decide

/-- The catalog is complete among the 91 canonical representatives. -/
theorem catalog_complete :
    ∀ p : ProjectiveIndex,
      IsInternalVec (projectiveVec p) ↔ ∃ v : Vertex, internalProjectiveIndex v = p := by
  decide

/-- There are ten canonical points on `XZ-Y^2=0`. -/
theorem conic_point_count :
    ((Finset.univ : Finset ProjectiveIndex).filter
      fun p => quadratic (projectiveVec p) = 0).card = 10 := by
  decide

/-- The polar form of `XZ-Y^2`; in characteristic three, `-2=1`. -/
def polarPair (u v : Vec3) : K := u 0 * v 2 + u 2 * v 0 + u 1 * v 1

/-- Adjacency in the polarity-conjugacy graph on internal points. -/
def HAdjacent (u v : Vertex) : Prop := u ≠ v ∧ polarPair (internalVec u) (internalVec v) = 0

instance (u v : Vertex) : Decidable (HAdjacent u v) := by
  unfold HAdjacent
  infer_instance

def hNeighbors (v : Vertex) : Finset Vertex :=
  Finset.univ.filter fun w => HAdjacent v w

/-- A coordinate-free executable description of graph distance in the diameter-three graph `H`. -/
def hDistance (u v : Vertex) : Nat :=
  if u = v then 0
  else if HAdjacent u v then 1
  else if ∃ w : Vertex, HAdjacent u w ∧ HAdjacent w v then 2
  else 3

/-- Every internal point has five polarity conjugates. -/
theorem h_regular_degree_five : ∀ v : Vertex, (hNeighbors v).card = 5 := by decide

def distanceLayer (base : Vertex) (d : Nat) : Finset Vertex :=
  Finset.univ.filter fun v => hDistance base v = d

/-- The distance distribution from every vertex is `(1,5,20,10)`. -/
theorem h_distance_layers :
    ∀ base : Vertex,
      (distanceLayer base 0).card = 1 ∧
      (distanceLayer base 1).card = 5 ∧
      (distanceLayer base 2).card = 20 ∧
      (distanceLayer base 3).card = 10 := by
  decide

/-- Counts of neighbours one layer down, in the same layer, and one layer up. -/
def intersectionProfile (base v : Vertex) : Nat × Nat × Nat :=
  (((hNeighbors v).filter fun w => hDistance base w + 1 = hDistance base v).card,
   ((hNeighbors v).filter fun w => hDistance base w = hDistance base v).card,
   ((hNeighbors v).filter fun w => hDistance base w = hDistance base v + 1).card)

/-- The full Sylvester intersection array `{5,4,2;1,1,4}`, checked at every ordered pair. -/
theorem h_intersection_array :
    ∀ base v : Vertex,
      (hDistance base v = 0 → intersectionProfile base v = (0, 0, 5)) ∧
      (hDistance base v = 1 → intersectionProfile base v = (1, 0, 4)) ∧
      (hDistance base v = 2 → intersectionProfile base v = (1, 2, 2)) ∧
      (hDistance base v = 3 → intersectionProfile base v = (4, 1, 0)) := by
  decide

/-- Coefficients of the join of two represented points. -/
def lineCoefficients (u v : Vec3) : Vec3 :=
  ![u 1 * v 2 - u 2 * v 1,
    u 2 * v 0 - u 0 * v 2,
    u 0 * v 1 - u 1 * v 0]

/-- For this polarity the pole of `aX+bY+cZ=0` is represented by `(c,b,a)`. -/
def linePoleVec (u v : Vec3) : Vec3 :=
  let l := lineCoefficients u v
  ![l 2, l 1, l 0]

/-- The join of two internal points is passant exactly when its pole is internal. -/
def PassantJoin (u v : Vertex) : Prop :=
  u ≠ v ∧ IsInternalVec (linePoleVec (internalVec u) (internalVec v))

instance (u v : Vertex) : Decidable (PassantJoin u v) := by
  unfold PassantJoin
  infer_instance

/-- Polarity identifies passant joins with exact distance two in the Sylvester graph. -/
theorem passantJoin_iff_distance_two :
    ∀ u v : Vertex, PassantJoin u v ↔ hDistance u v = 2 := by
  decide

/-- There are 360 unordered passant joins among the 36 internal points. -/
theorem passant_join_count :
    ((Finset.univ : Finset (Vertex × Vertex)).filter
      fun uv => uv.1 < uv.2 ∧ PassantJoin uv.1 uv.2).card = 360 := by
  decide

/-- Reflected adjacency masks for the exact-distance-two graph.  The next theorem checks every
entry against the geometric distance definition before the masks are used by the clique checker. -/
def distanceTwoMask (u : Vertex) : Nat :=
  ![53594597232, 54622190240, 33466854864, 50697329312,
    63824194053, 58724112139, 14964046341, 15700999438,
    31119556773, 43984470139, 59650584741, 46500376798,
    56823057642, 61057862871, 16554789690, 16866674493,
    54456794716, 55269416380, 32811049815, 49179284459,
    46289315251, 59240701555, 45030815181, 33219238862,
    51006779082, 22821109191, 63096202170, 22831944573,
    60377693011, 21572204515, 47437237341, 21570768062,
    3953972716, 1440541660, 3198629175, 1434140219] u

def DistanceTwoAdjacent (u v : Vertex) : Prop :=
  (distanceTwoMask u).testBit v.1 = true

instance (u v : Vertex) : Decidable (DistanceTwoAdjacent u v) := by
  unfold DistanceTwoAdjacent
  infer_instance

/-- The reflected masks are extensionally the exact-distance-two relation obtained from geometry. -/
theorem distanceTwoAdjacent_iff_hDistance :
    ∀ u v : Vertex, DistanceTwoAdjacent u v ↔ hDistance u v = 2 := by
  decide

theorem distanceTwoAdjacent_irrefl : ∀ u : Vertex, ¬ DistanceTwoAdjacent u u := by decide

theorem distanceTwoAdjacent_symmetric :
    ∀ u v : Vertex, DistanceTwoAdjacent u v ↔ DistanceTwoAdjacent v u := by
  decide

/-- A checked proper six-colouring of the exact-distance-two graph. -/
def vertexColor (v : Vertex) : Fin 6 :=
  ![0, 1, 0, 1, 1, 4, 1, 4, 1, 2, 1, 2,
    0, 3, 0, 3, 4, 3, 4, 3, 2, 3, 2, 3,
    0, 5, 0, 5, 4, 5, 4, 5, 2, 5, 2, 5] v

theorem vertexColor_proper :
    ∀ u v : Vertex, DistanceTwoAdjacent u v → vertexColor u ≠ vertexColor v := by
  decide

/-- The six independent colour classes, each in increasing vertex order. -/
def colorClass (c : Fin 6) : List Vertex :=
  ![[0, 2, 12, 14, 24, 26],
    [1, 3, 4, 6, 8, 10],
    [9, 11, 20, 22, 32, 34],
    [13, 15, 17, 19, 21, 23],
    [5, 7, 16, 18, 28, 30],
    [25, 27, 29, 31, 33, 35]] c

theorem mem_colorClass_iff :
    ∀ c : Fin 6, ∀ v : Vertex, v ∈ colorClass c ↔ vertexColor v = c := by
  decide

def CompatibleWith (v : Vertex) (xs : List Vertex) : Prop :=
  ∀ u ∈ xs, DistanceTwoAdjacent v u

instance (v : Vertex) (xs : List Vertex) : Decidable (CompatibleWith v xs) := by
  unfold CompatibleWith
  infer_instance

/-- Extend compatible rainbow prefixes by one prescribed colour.  Prefixes are stored reversed. -/
def extendPrefixes (c : Fin 6) (xss : List (List Vertex)) : List (List Vertex) :=
  xss.flatMap fun xs =>
    ((colorClass c).filter fun v => CompatibleWith v xs).map fun v => v :: xs

def rainbowLevel0 : List (List Vertex) := [[]]
def rainbowLevel1 : List (List Vertex) := extendPrefixes 0 rainbowLevel0
def rainbowLevel2 : List (List Vertex) := extendPrefixes 1 rainbowLevel1
def rainbowLevel3 : List (List Vertex) := extendPrefixes 2 rainbowLevel2
def rainbowLevel4 : List (List Vertex) := extendPrefixes 3 rainbowLevel3
def rainbowLevel5 : List (List Vertex) := extendPrefixes 4 rainbowLevel4
def rainbowLevel6 : List (List Vertex) := extendPrefixes 5 rainbowLevel5

/-- Small reflected prefix counts; the empty final level is the no-rainbow-six certificate. -/
theorem rainbow_level1_card : rainbowLevel1.length = 6 := by decide
theorem rainbow_level2_card : rainbowLevel2.length = 24 := by decide
theorem rainbow_level3_card : rainbowLevel3.length = 66 := by decide
theorem rainbow_level4_card : rainbowLevel4.length = 120 := by decide
theorem rainbow_level5_card : rainbowLevel5.length = 126 := by decide
theorem rainbow_level6_empty : rainbowLevel6 = [] := by decide

theorem mem_extendPrefixes {c : Fin 6} {xss : List (List Vertex)} {xs : List Vertex}
    {v : Vertex} (hxs : xs ∈ xss) (hv : v ∈ colorClass c)
    (hcompat : CompatibleWith v xs) : v :: xs ∈ extendPrefixes c xss := by
  apply List.mem_flatMap.mpr
  refine ⟨xs, hxs, ?_⟩
  apply List.mem_map.mpr
  exact ⟨v, List.mem_filter.mpr ⟨hv, decide_eq_true hcompat⟩, rfl⟩

/-- No choice of one vertex from each colour class is a clique. -/
theorem no_rainbow_six (r : Fin 6 → Vertex)
    (hmem : ∀ c : Fin 6, r c ∈ colorClass c)
    (hadj : ∀ c d : Fin 6, c ≠ d → DistanceTwoAdjacent (r c) (r d)) : False := by
  have h0 : ([] : List Vertex) ∈ rainbowLevel0 := by simp [rainbowLevel0]
  have h1 : [r 0] ∈ rainbowLevel1 := by
    apply mem_extendPrefixes h0 (hmem 0)
    simp [CompatibleWith]
  have h2 : [r 1, r 0] ∈ rainbowLevel2 := by
    apply mem_extendPrefixes h1 (hmem 1)
    simp [CompatibleWith, hadj]
  have h3 : [r 2, r 1, r 0] ∈ rainbowLevel3 := by
    apply mem_extendPrefixes h2 (hmem 2)
    simp [CompatibleWith, hadj]
  have h4 : [r 3, r 2, r 1, r 0] ∈ rainbowLevel4 := by
    apply mem_extendPrefixes h3 (hmem 3)
    simp [CompatibleWith, hadj]
  have h5 : [r 4, r 3, r 2, r 1, r 0] ∈ rainbowLevel5 := by
    apply mem_extendPrefixes h4 (hmem 4)
    simp [CompatibleWith, hadj]
  have h6 : [r 5, r 4, r 3, r 2, r 1, r 0] ∈ rainbowLevel6 := by
    apply mem_extendPrefixes h5 (hmem 5)
    simp [CompatibleWith, hadj]
  rw [rainbow_level6_empty] at h6
  simp at h6

def sixTuple (a b c d e f : Vertex) : Fin 6 → Vertex := ![a, b, c, d, e, f]

/-- Semantic six-clique predicate, indexed so finite-colour bijectivity applies directly. -/
def SixClique (a b c d e f : Vertex) : Prop :=
  ∀ i j : Fin 6, i ≠ j →
    DistanceTwoAdjacent (sixTuple a b c d e f i) (sixTuple a b c d e f j)

instance (a b c d e f : Vertex) : Decidable (SixClique a b c d e f) := by
  unfold SixClique
  infer_instance

/-- The exact-distance-two graph has no six-clique. -/
theorem no_six_clique : ¬ ∃ a b c d e f : Vertex, SixClique a b c d e f := by
  rintro ⟨a, b, c, d, e, f, hclique⟩
  let vertices := sixTuple a b c d e f
  let colors : Fin 6 → Fin 6 := fun i => vertexColor (vertices i)
  have hcolorsInjective : Function.Injective colors := by
    intro i j hij
    by_contra hne
    exact vertexColor_proper (vertices i) (vertices j) (hclique i j hne) hij
  have hcolorsBijective : Function.Bijective colors :=
    (Fintype.bijective_iff_injective_and_card colors).2 ⟨hcolorsInjective, rfl⟩
  let e : Fin 6 ≃ Fin 6 := Equiv.ofBijective colors hcolorsBijective
  let rainbow : Fin 6 → Vertex := fun c => vertices (e.symm c)
  apply no_rainbow_six rainbow
  · intro c
    apply (mem_colorClass_iff c (rainbow c)).mpr
    change colors (e.symm c) = c
    exact e.apply_symm_apply c
  · intro c d hcd
    apply hclique
    exact e.symm.injective.ne hcd

/-- An explicit five-clique in the exact-distance-two graph. -/
def fiveClique : Finset Vertex := {0, 4, 9, 18, 21}

def IsClique (s : Finset Vertex) : Prop :=
  ∀ u ∈ s, ∀ v ∈ s, u ≠ v → DistanceTwoAdjacent u v

instance (s : Finset Vertex) : Decidable (IsClique s) := by
  unfold IsClique
  infer_instance

theorem fiveClique_card : fiveClique.card = 5 := by decide

theorem fiveClique_isClique : IsClique fiveClique := by decide

/-- Exact clique-number certificate: an explicit `K_5` and a semantic exclusion of `K_6`. -/
theorem distanceTwo_clique_number_five :
    fiveClique.card = 5 ∧ IsClique fiveClique ∧
      ¬ ∃ a b c d e f : Vertex, SixClique a b c d e f :=
  ⟨fiveClique_card, fiveClique_isClique, no_six_clique⟩

#print axioms catalog_complete
#print axioms conic_point_count
#print axioms passantJoin_iff_distance_two
#print axioms distanceTwo_clique_number_five

end Q9Sylvester
end RelativeConicArcs
