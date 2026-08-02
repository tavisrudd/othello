import RelativeConicArcs.PassantCodeQ13.Geometry

/-!
# The cyclic tangent graph used in the weight-eight exclusion

After fixing one internal point, the tangent-product reduction produces a graph on three cyclic
orbits of length fourteen.  Its six difference sets are encoded below.  The finite checks enumerate
the 4-cliques, extend each by its common neighbor, and verify that the resulting 5-cliques have no
further common neighbor.  Thus the computation checks the five-row unique-closure leaf used by the
weight-eight argument without enumerating binary words of length 78.

The terminal checks use native evaluation on 42 vertices.  Their dependency therefore contains the
declaration-local native-decision axiom reported by the pinned Lean toolchain.
-/

namespace RelativeConicArcs.PassantCodeQ13.WeightEight

/-- A vertex consists of one of three cyclic orbits and an index modulo fourteen. -/
abbrev Vertex := Fin 3 × Fin 14

/-- The forty-two vertices in orbit-major cyclic order. -/
def vertices : List Vertex :=
  List.ofFn fun index : Fin 42 =>
    (⟨index.1 / 14, by omega⟩, ⟨index.1 % 14, Nat.mod_lt _ (by decide)⟩)

/-- The allowed positive cyclic differences for an ordered pair of orbit labels. -/
def allowedDifference (first second : Fin 3) (difference : Fin 14) : Bool :=
  match first.1, second.1 with
  | 0, 0 => difference.1 ∈ [4, 6, 8, 10]
  | 0, 1 => difference.1 ∈ [6, 7, 11, 12]
  | 0, 2 => difference.1 ∈ [1, 3]
  | 1, 1 => difference.1 ∈ [6, 8]
  | 1, 2 => difference.1 ∈ [3, 5, 6, 8, 9, 11]
  | 2, 2 => difference.1 ∈ [2, 4, 10, 12]
  | _, _ => false

/-- Adjacency in the symmetric three-orbit cyclic tangent graph. -/
def adjacent (first second : Vertex) : Bool :=
  if first.1.1 ≤ second.1.1 then
    allowedDifference first.1 second.1
      ⟨(second.2.1 + 14 - first.2.1) % 14, Nat.mod_lt _ (by decide)⟩
  else
    allowedDifference second.1 first.1
      ⟨(first.2.1 + 14 - second.2.1) % 14, Nat.mod_lt _ (by decide)⟩

/-- Executable clique predicate for a finite vertex set. -/
def isClique (members : List Vertex) : Bool :=
  members.all fun first =>
    members.all fun second => first == second || adjacent first second

/-- Vertices outside a set adjacent to every member of the set. -/
def commonNeighbors (members : List Vertex) : List Vertex :=
  vertices.filter fun candidate =>
    !members.contains candidate && members.all fun member => adjacent candidate member

/-- All 4-cliques in the tangent graph. -/
def fourCliques : List (List Vertex) :=
  (vertices.sublistsLen 4).filter isClique

/-- The orbit-major bit encoding of a finite vertex list. -/
def encodeVertices (members : List Vertex) : Nat :=
  members.foldl (fun answer vertex => answer ||| (1 <<< (14 * vertex.1.1 + vertex.2.1))) 0

/-- The distinct 5-cliques obtained by adjoining the unique common neighbor of a 4-clique. -/
def fiveCliqueCodes : List Nat :=
  (fourCliques.flatMap fun members =>
    (commonNeighbors members).map fun candidate => encodeVertices (candidate :: members)).eraseDups

/-- There are exactly seventy 4-cliques in the tangent graph. -/
theorem fourCliques_length : fourCliques.length = 70 := by
  native_decide

/-- Every enumerated 4-clique has exactly one common neighbor. -/
theorem fourClique_unique_extension_check :
    fourCliques.all (fun members => (commonNeighbors members).length == 1) = true := by
  native_decide

/-- Unique extension collapses the seventy 4-cliques to fourteen 5-cliques. -/
theorem fiveCliqueCodes_length : fiveCliqueCodes.length = 14 := by
  native_decide

/-- None of the fourteen 5-cliques admits a further common neighbor. -/
theorem fiveClique_maximality_check :
    fourCliques.all (fun members =>
      (commonNeighbors members).all fun candidate =>
        (commonNeighbors (candidate :: members)).isEmpty) = true := by
  native_decide

end RelativeConicArcs.PassantCodeQ13.WeightEight
