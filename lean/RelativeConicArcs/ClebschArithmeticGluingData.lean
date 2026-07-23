import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Finset.Card
import Mathlib.Data.Matrix.Basic
import Mathlib.Tactic

/-!
# Frozen rank-three reduction data

This module records the literal finite data for the rank-three Coxeter reductions at
`q = 5, 7, 11`.  A projective-line point is represented by `none` for infinity and by
`some x` for the affine coordinate `x`.  Matchings are sets of two-element endpoint sets, so
their definitions do not depend on an ordering of either edges or endpoints.

The data comprise:

* the two coordinate reductions of the `A3`, `B3`, and `H3` vertex sets;
* the fused `A3` matching, the two silver `B3` matchings, and the two golden `H3` matchings;
* the silver sheet exchange `x ↦ -x` and the golden exchange `(x-1)/(x+1)`;
* the split Coxeter-square multipliers at the three primes.

This module also reconstructs the projective linear groups from normalized matrices and checks
the reduction, inverse-action, `A3`, and `B3` leaves.  The companion module checks the heavier
`H3` orbit and generation leaves in a separate elaboration environment.  No abstract-group
name, orthogonal-group identification, spinor norm, or number-field reciprocity statement is
encoded in these tables.
-/

namespace RelativeConicArcs
namespace ClebschArithmeticGluing

/-- The projective line over the prime field with `q` elements, with `none` denoting infinity. -/
abbrev ProjectivePoint (q : Nat) := Option (Fin q)

/-- An unordered projective-line edge. -/
abbrev ProjectiveEdge (q : Nat) := Finset (ProjectivePoint q)

/-- A perfect matching represented as a set of unordered edges. -/
abbrev ProjectiveMatching (q : Nat) := Finset (ProjectiveEdge q)

/-- Construct an unordered edge from two endpoints. -/
def edge {q : Nat} (x y : ProjectivePoint q) : ProjectiveEdge q := {x, y}

/-- The two reductions of the six `A3` vertices, for `i = 2` and `i = 3`. -/
def a3VertexReductions : Fin 2 → List (ProjectivePoint 5)
  | 0 => [some 0, none, some 1, some 4, some 2, some 3]
  | 1 => [some 0, none, some 1, some 4, some 3, some 2]

/-- The fused `A3` antipodal matching over `F_5`. -/
def a3Matching : ProjectiveMatching 5 :=
  {edge (some 0) none, edge (some 1) (some 4), edge (some 2) (some 3)}

/-- Ordered representatives of the three fused `A3` matching edges. -/
def a3MatchingEdges : List (ProjectivePoint 5 × ProjectivePoint 5) :=
  [(some 0, none), (some 1, some 4), (some 2, some 3)]

/-- The two reductions of the eight `B3` vertices, for `sqrt(2) = 3` and `sqrt(2) = 4`. -/
def b3VertexReductions : Fin 2 → List (ProjectivePoint 7)
  | 0 => [some 0, none, some 3, some 5, some 6, some 1, some 2, some 4]
  | 1 => [some 0, none, some 4, some 2, some 1, some 6, some 5, some 3]

/-- The silver matching obtained from the residue `sqrt(2) = 3`. -/
def b3NegativeMatching : ProjectiveMatching 7 :=
  {edge (some 0) none, edge (some 1) (some 3), edge (some 2) (some 6),
    edge (some 4) (some 5)}

/-- Ordered representatives of the four negative silver matching edges. -/
def b3NegativeMatchingEdges : List (ProjectivePoint 7 × ProjectivePoint 7) :=
  [(some 0, none), (some 1, some 3), (some 2, some 6), (some 4, some 5)]

/-- The silver matching obtained from the residue `sqrt(2) = 4`. -/
def b3PositiveMatching : ProjectiveMatching 7 :=
  {edge (some 0) none, edge (some 1) (some 5), edge (some 2) (some 3),
    edge (some 4) (some 6)}

/-- Ordered representatives of the four positive silver matching edges. -/
def b3PositiveMatchingEdges : List (ProjectivePoint 7 × ProjectivePoint 7) :=
  [(some 0, none), (some 1, some 5), (some 2, some 3), (some 4, some 6)]

/-- The two reductions of the twelve `H3` vertices, for the two primes above eleven. -/
def h3VertexReductions : Fin 2 → List (ProjectivePoint 11)
  | 0 =>
      [some 0, none, some 2, some 6, some 7, some 8, some 10,
        some 1, some 3, some 4, some 5, some 9]
  | 1 =>
      [some 0, none, some 9, some 4, some 3, some 1, some 5,
        some 2, some 7, some 10, some 6, some 8]

/-- The golden matching obtained from the residue `φ = 8`. -/
def h3BaseMatching : ProjectiveMatching 11 :=
  {edge (some 0) (some 1), edge (some 2) (some 5), edge (some 3) (some 7),
    edge (some 4) (some 9), edge (some 6) (some 8), edge (some 10) none}

/-- Ordered representatives of the six base golden matching edges. -/
def h3BaseMatchingEdges : List (ProjectivePoint 11 × ProjectivePoint 11) :=
  [(some 0, some 1), (some 2, some 5), (some 3, some 7),
    (some 4, some 9), (some 6, some 8), (some 10, none)]

/-- The golden matching obtained from the residue `φ = 4`. -/
def h3ConjugateMatching : ProjectiveMatching 11 :=
  {edge (some 0) (some 10), edge (some 1) none, edge (some 2) (some 7),
    edge (some 3) (some 5), edge (some 4) (some 8), edge (some 6) (some 9)}

/-- Ordered representatives of the six conjugate golden matching edges. -/
def h3ConjugateMatchingEdges : List (ProjectivePoint 11 × ProjectivePoint 11) :=
  [(some 0, some 10), (some 1, none), (some 2, some 7),
    (some 3, some 5), (some 4, some 8), (some 6, some 9)]

/-- A `2 × 2` matrix, written by rows in slots `0,1,2,3`. -/
abbrev ProjectiveMatrix (q : Nat) := Fin 4 → Fin q

/-- Construct a `2 × 2` matrix from its row-major entries. -/
def projectiveMatrix {q : Nat} (a b c d : Fin q) : ProjectiveMatrix q := ![a, b, c, d]

/-- The silver transporter `x ↦ -x` over `F_7`. -/
def silverTransporter : ProjectiveMatrix 7 :=
  projectiveMatrix 1 0 0 6

/-- The golden transporter `(x-1)/(x+1)` over `F_11`. -/
def goldenTransporter : ProjectiveMatrix 11 :=
  projectiveMatrix 1 10 1 1

/-- Coxeter-square multipliers in the `A3`, `B3`, and two `H3` prime frames. -/
def coxeterSquareMultipliers : List (Nat × Nat) :=
  [(5, 4), (7, 2), (11, 9), (11, 4)]

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

section ProjectiveLinear

variable {q : Nat} [NeZero q] [Fact q.Prime]

/-- Multiplicative inverse in a prime field, computed by Fermat's formula. -/
def finiteInverse (x : Fin q) : Fin q := x ^ (q - 2)

/-- Division in a prime field, computed by Fermat's formula. -/
def finiteDivide (x y : Fin q) : Fin q := x * finiteInverse y

/-- The determinant of a projective matrix representative. -/
def determinant (m : ProjectiveMatrix q) : Fin q := m 0 * m 3 - m 1 * m 2

/-- Leading-entry projective normalization: scale the first nonzero entry to one. -/
def normalize (m : ProjectiveMatrix q) : ProjectiveMatrix q :=
  let s : Fin q :=
    if m 0 ≠ 0 then finiteInverse (m 0)
    else if m 1 ≠ 0 then finiteInverse (m 1)
    else if m 2 ≠ 0 then finiteInverse (m 2)
    else finiteInverse (m 3)
  projectiveMatrix (s * m 0) (s * m 1) (s * m 2) (s * m 3)

/-- Whether a representative is in leading-entry projective normal form. -/
def isNormalized (m : ProjectiveMatrix q) : Bool :=
  (m 0 == 1) ||
    ((m 0 == 0) && (m 1 == 1)) ||
    ((m 0 == 0) && (m 1 == 0) && (m 2 == 1)) ||
    ((m 0 == 0) && (m 1 == 0) && (m 2 == 0) && (m 3 == 1))

/-- Leading-entry-normalized representatives of `PGL₂(F_q)`. -/
def pgl : Finset (ProjectiveMatrix q) :=
  Finset.univ.filter fun m ↦ isNormalized m = true ∧ determinant m ≠ 0

/-- The square-determinant half of `PGL₂(F_q)`. -/
def hasSquareDeterminant (m : ProjectiveMatrix q) : Bool :=
  (List.ofFn fun x : Fin q ↦ x).any fun x ↦ decide (x * x = determinant m)

/-- Leading-entry-normalized representatives of the square-determinant projective subgroup. -/
def psl : Finset (ProjectiveMatrix q) := pgl.filter fun m ↦ hasSquareDeterminant m = true

/-- Multiplication of normalized projective representatives. -/
def projectiveMul (m n : ProjectiveMatrix q) : ProjectiveMatrix q :=
  normalize
    (projectiveMatrix
      (m 0 * n 0 + m 1 * n 2) (m 0 * n 1 + m 1 * n 3)
      (m 2 * n 0 + m 3 * n 2) (m 2 * n 1 + m 3 * n 3))

/-- The fractional-linear action on the projective line. -/
def projectiveAction (m : ProjectiveMatrix q) : ProjectivePoint q → ProjectivePoint q
  | none => if m 2 = 0 then none else some (finiteDivide (m 0) (m 2))
  | some x =>
      let den := m 2 * x + m 3
      if den = 0 then none else some (finiteDivide (m 0 * x + m 1) den)

/-- Transport an unordered edge by a projective matrix. -/
def transportEdge (m : ProjectiveMatrix q) (e : ProjectiveEdge q) : ProjectiveEdge q :=
  e.image (projectiveAction m)

/-- Transport a matching by a projective matrix. -/
def transportMatching (m : ProjectiveMatrix q)
    (matching : ProjectiveMatching q) : ProjectiveMatching q :=
  matching.image (transportEdge m)

/-- The mate involution specified by a list of disjoint matching edges. -/
def matchingMate (edges : List (ProjectivePoint q × ProjectivePoint q))
    (x : ProjectivePoint q) : ProjectivePoint q :=
  match edges.find? fun e ↦ decide (x = e.1 ∨ x = e.2) with
  | none => x
  | some e => if x = e.1 then e.2 else e.1

/-- Convert an ordered list of endpoint pairs to the unordered matching representation. -/
def matchingFromEdges (edges : List (ProjectivePoint q × ProjectivePoint q)) :
    ProjectiveMatching q :=
  edges.foldl (fun matching e ↦ insert (edge e.1 e.2) matching) ∅

/-- Read a matching from fixed pairs of positions in a reduced vertex list. -/
def matchingFromReduction (vertices : List (ProjectivePoint q))
    (pairs : List (Nat × Nat)) : ProjectiveMatching q :=
  matchingFromEdges <| pairs.map fun ij ↦
    (vertices.getD ij.1 none, vertices.getD ij.2 none)

/-- Antipodal position pairs in the frozen `A3` vertex ordering. -/
def a3AntipodalIndexPairs : List (Nat × Nat) := [(0, 1), (2, 3), (4, 5)]

/-- Antipodal position pairs in the frozen `B3` vertex ordering. -/
def b3AntipodalIndexPairs : List (Nat × Nat) := [(0, 1), (2, 5), (3, 7), (4, 6)]

/-- The fixed enumeration `∞,0,1,...,q-1` of the projective line. -/
def projectivePointList : List (ProjectivePoint q) :=
  none :: List.ofFn fun x : Fin q ↦ some x

/-- Boolean preservation test for a matching mate involution. -/
def preservesMate (m : ProjectiveMatrix q)
    (edges : List (ProjectivePoint q × ProjectivePoint q)) : Bool :=
  projectivePointList.all fun x ↦
    decide (projectiveAction m (matchingMate edges x) =
      matchingMate edges (projectiveAction m x))

/-- Projective stabilizer computed from the mate involution rather than nested finite sets. -/
def mateStabilizer (edges : List (ProjectivePoint q × ProjectivePoint q)) :
    Finset (ProjectiveMatrix q) :=
  pgl.filter fun m ↦ preservesMate m edges = true

/-- The inverse projective transformation in normalized coordinates. -/
def projectiveInv (m : ProjectiveMatrix q) : ProjectiveMatrix q :=
  normalize (projectiveMatrix (m 3) (-m 1) (-m 2) (m 0))

/-- The transported mate involution, serialized in the fixed point order. -/
def transportedMateSignature (m : ProjectiveMatrix q)
    (edges : List (ProjectivePoint q × ProjectivePoint q)) : List (ProjectivePoint q) :=
  projectivePointList.map fun x ↦
    projectiveAction m (matchingMate edges (projectiveAction (projectiveInv m) x))

/-- The orbit of a matching, represented by its distinct transported mate signatures. -/
def mateOrbit (g : Finset (ProjectiveMatrix q))
    (edges : List (ProjectivePoint q × ProjectivePoint q)) :
    Finset (List (ProjectivePoint q)) :=
  g.image fun m ↦ transportedMateSignature m edges

/-- Pairwise products of two finite matrix sets. -/
def setProduct (s t : Finset (ProjectiveMatrix q)) : Finset (ProjectiveMatrix q) :=
  s.biUnion fun m ↦ t.image (projectiveMul m)

/-- One closure step under multiplication by the original generators. -/
def closureStep (generators reached : Finset (ProjectiveMatrix q)) :
    Finset (ProjectiveMatrix q) :=
  reached ∪ setProduct reached generators

/-- Elements represented by words of length at most `n` in `generators`. -/
def boundedClosure (n : Nat) (generators : Finset (ProjectiveMatrix q)) :
    Finset (ProjectiveMatrix q) :=
  Nat.iterate (closureStep generators) n generators

/-- The orbit of a multiplicative projective scaling on the projective line. -/
def scalingOrbit (u : Fin q) (x : ProjectivePoint q) : Finset (ProjectivePoint q) :=
  (Finset.range q).image fun n ↦
    match x with
    | none => none
    | some y => some (u ^ n * y)

end ProjectiveLinear

/-! ## Kernel-checked reduction and small-field leaves -/

/-- Each frozen vertex list is a bijective enumeration of its projective line. -/
theorem vertexReductions_are_bijective :
    (∀ s, (a3VertexReductions s).Nodup ∧ (a3VertexReductions s).length = 6) ∧
    (∀ s, (b3VertexReductions s).Nodup ∧ (b3VertexReductions s).length = 8) ∧
    (∀ s, (h3VertexReductions s).Nodup ∧ (h3VertexReductions s).length = 12) := by
  decide

/-- The spin parameter `x² = 2` is inert over `F_5`: it has no root there. -/
theorem a3_two_has_no_root : ¬ ∃ x : ZMod 5, x * x = 2 := by decide

/-- The silver parameter `x² = 2` has exactly the two roots `3,4` over `F_7`. -/
theorem b3_two_roots :
    (Finset.univ.filter fun x : ZMod 7 ↦ x * x = 2) = {3, 4} := by
  decide

/-- The golden parameter `x² = 5` has exactly the two roots `4,7` over `F_11`. -/
theorem h3_five_roots :
    (Finset.univ.filter fun x : ZMod 11 ↦ x * x = 5) = {4, 7} := by
  decide

/-- The golden integers `φ = 8,4` are exactly the roots of `x²-x-1` over `F_11`. -/
theorem h3_golden_roots :
    (Finset.univ.filter fun x : ZMod 11 ↦ x * x - x - 1 = 0) = {8, 4} := by
  decide

/-- The reduced affine vertex polynomial `X^q-X` vanishes on every element of each field. -/
theorem reduced_vertex_polynomials_split :
    (∀ x : ZMod 5, x ^ 5 - x = 0) ∧
    (∀ x : ZMod 7, x ^ 7 - x = 0) ∧
    (∀ x : ZMod 11, x ^ 11 - x = 0) := by
  decide

/-- The ordered edge lists encode exactly the five frozen unordered matchings. -/
theorem matchingEdgeLists_encode_frozen_matchings :
    matchingFromEdges a3MatchingEdges = a3Matching ∧
    matchingFromEdges b3NegativeMatchingEdges = b3NegativeMatching ∧
    matchingFromEdges b3PositiveMatchingEdges = b3PositiveMatching ∧
    matchingFromEdges h3BaseMatchingEdges = h3BaseMatching ∧
    matchingFromEdges h3ConjugateMatchingEdges = h3ConjugateMatching := by
  decide

/-- Every frozen matching-edge list defines a fixed-point-free involution. -/
theorem frozen_matching_mates_are_fixedPointFree_involutions :
    (∀ x, matchingMate a3MatchingEdges x ≠ x ∧
      matchingMate a3MatchingEdges (matchingMate a3MatchingEdges x) = x) ∧
    (∀ x, matchingMate b3NegativeMatchingEdges x ≠ x ∧
      matchingMate b3NegativeMatchingEdges (matchingMate b3NegativeMatchingEdges x) = x) ∧
    (∀ x, matchingMate b3PositiveMatchingEdges x ≠ x ∧
      matchingMate b3PositiveMatchingEdges (matchingMate b3PositiveMatchingEdges x) = x) ∧
    (∀ x, matchingMate h3BaseMatchingEdges x ≠ x ∧
      matchingMate h3BaseMatchingEdges (matchingMate h3BaseMatchingEdges x) = x) ∧
    (∀ x, matchingMate h3ConjugateMatchingEdges x ≠ x ∧
      matchingMate h3ConjugateMatchingEdges
        (matchingMate h3ConjugateMatchingEdges x) = x) := by
  decide

/-- Both reduced `A3` vertex tables induce the frozen antipodal matching. -/
theorem a3_matching_is_fused :
    matchingFromReduction (a3VertexReductions 0) a3AntipodalIndexPairs = a3Matching ∧
    matchingFromReduction (a3VertexReductions 1) a3AntipodalIndexPairs = a3Matching := by
  decide

/-- The two reduced `B3` vertex tables induce the two distinct silver matchings. -/
theorem b3_reductions_induce_split_matchings :
    matchingFromReduction (b3VertexReductions 0) b3AntipodalIndexPairs =
      b3NegativeMatching ∧
    matchingFromReduction (b3VertexReductions 1) b3AntipodalIndexPairs =
      b3PositiveMatching ∧
    b3NegativeMatching ≠ b3PositiveMatching := by
  decide

/-- The silver outer transporter exchanges the two `B3` matchings. -/
theorem silverTransporter_swaps_matchings :
    (∀ x, projectiveAction silverTransporter (matchingMate b3NegativeMatchingEdges x) =
      matchingMate b3PositiveMatchingEdges (projectiveAction silverTransporter x)) ∧
    (∀ x, projectiveAction silverTransporter (matchingMate b3PositiveMatchingEdges x) =
      matchingMate b3NegativeMatchingEdges (projectiveAction silverTransporter x)) := by
  decide

/-- The golden transporter exchanges the two `H3` matchings. -/
theorem goldenTransporter_swaps_matchings :
    (∀ x, projectiveAction goldenTransporter (matchingMate h3BaseMatchingEdges x) =
      matchingMate h3ConjugateMatchingEdges (projectiveAction goldenTransporter x)) ∧
    (∀ x, projectiveAction goldenTransporter (matchingMate h3ConjugateMatchingEdges x) =
      matchingMate h3BaseMatchingEdges (projectiveAction goldenTransporter x)) := by
  decide

/-- The split Coxeter-square actions have the two fixed poles and all displayed moving
orbits, including both characteristic-eleven multipliers. -/
theorem coxeterSquare_orbits :
    scalingOrbit (4 : Fin 5) none = {none} ∧
    scalingOrbit (4 : Fin 5) (some 0) = {some 0} ∧
    scalingOrbit (4 : Fin 5) (some 1) = {some 1, some 4} ∧
    scalingOrbit (4 : Fin 5) (some 2) = {some 2, some 3} ∧
    scalingOrbit (2 : Fin 7) none = {none} ∧
    scalingOrbit (2 : Fin 7) (some 0) = {some 0} ∧
    scalingOrbit (2 : Fin 7) (some 1) = {some 1, some 2, some 4} ∧
    scalingOrbit (2 : Fin 7) (some 3) = {some 3, some 5, some 6} ∧
    scalingOrbit (9 : Fin 11) none = {none} ∧
    scalingOrbit (9 : Fin 11) (some 0) = {some 0} ∧
    scalingOrbit (9 : Fin 11) (some 1) = {some 1, some 3, some 4, some 5, some 9} ∧
    scalingOrbit (9 : Fin 11) (some 2) = {some 2, some 6, some 7, some 8, some 10} ∧
    scalingOrbit (4 : Fin 11) none = {none} ∧
    scalingOrbit (4 : Fin 11) (some 0) = {some 0} ∧
    scalingOrbit (4 : Fin 11) (some 1) = {some 1, some 3, some 4, some 5, some 9} ∧
    scalingOrbit (4 : Fin 11) (some 2) = {some 2, some 6, some 7, some 8, some 10} := by
  decide

/-- Each displayed multiplier has the required order and its diagonal projective matrix
lies in the square-determinant subgroup. -/
theorem coxeterSquare_orders_and_square_determinants :
    (4 : Fin 5) ^ 2 = 1 ∧ (4 : Fin 5) ≠ 1 ∧
    projectiveMatrix (1 : Fin 5) 0 0 4 ∈ psl ∧
    (2 : Fin 7) ^ 3 = 1 ∧ (2 : Fin 7) ≠ 1 ∧
    projectiveMatrix (1 : Fin 7) 0 0 4 ∈ psl ∧
    (9 : Fin 11) ^ 5 = 1 ∧ (9 : Fin 11) ≠ 1 ∧
    projectiveMatrix (1 : Fin 11) 0 0 5 ∈ psl ∧
    (4 : Fin 11) ^ 5 = 1 ∧ (4 : Fin 11) ≠ 1 ∧
    projectiveMatrix (1 : Fin 11) 0 0 3 ∈ psl := by
  decide

/-- The normalized matrix enumerations have the expected projective group orders. -/
theorem projective_group_orders :
    (pgl (q := 5)).card = 120 ∧ (psl (q := 5)).card = 60 ∧
    (pgl (q := 7)).card = 336 ∧ (psl (q := 7)).card = 168 ∧
    (pgl (q := 11)).card = 1320 ∧ (psl (q := 11)).card = 660 := by
  decide

/-- The `A3` matching stabilizer and its projective and square-determinant orbits. -/
theorem a3_fused_stabilizer_and_orbit :
    (mateStabilizer a3MatchingEdges).card = 24 ∧
    ((mateStabilizer a3MatchingEdges) ∩ psl).card = 12 ∧
    (mateOrbit pgl a3MatchingEdges).card = 5 ∧
    (mateOrbit psl a3MatchingEdges).card = 5 := by
  decide

/-- The two silver stabilizers and their disjoint square-determinant orbit halves. -/
theorem b3_split_stabilizers_and_orbits :
    (mateStabilizer b3NegativeMatchingEdges).card = 24 ∧
    (mateStabilizer b3PositiveMatchingEdges).card = 24 ∧
    ((mateStabilizer b3NegativeMatchingEdges) ∩
      mateStabilizer b3PositiveMatchingEdges).card = 6 ∧
    mateStabilizer b3NegativeMatchingEdges ⊆ psl ∧
    mateStabilizer b3PositiveMatchingEdges ⊆ psl ∧
    (mateOrbit pgl b3NegativeMatchingEdges).card = 14 ∧
    (mateOrbit psl b3NegativeMatchingEdges).card = 7 ∧
    (mateOrbit psl b3PositiveMatchingEdges).card = 7 ∧
    Disjoint (mateOrbit psl b3NegativeMatchingEdges)
      (mateOrbit psl b3PositiveMatchingEdges) := by
  decide

/- BEGIN ARITHMETIC GLUING CERTIFICATE DATA -/
/- Generated by `verification/clebsch_arithmetic_gluing/generate.py`, schema
`clebsch-arithmetic-gluing-lean-v1`. -/
/-- The sixty leading-normalized matrices stabilizing the base golden matching. -/
def h3BaseStabilizerCertificate : List (ProjectiveMatrix 11) :=
  [projectiveMatrix 0 1 2 3,
    projectiveMatrix 0 1 6 7,
    projectiveMatrix 0 1 7 8,
    projectiveMatrix 0 1 8 9,
    projectiveMatrix 0 1 10 0,
    projectiveMatrix 1 0 0 1,
    projectiveMatrix 1 0 3 9,
    projectiveMatrix 1 0 7 5,
    projectiveMatrix 1 0 8 4,
    projectiveMatrix 1 0 9 3,
    projectiveMatrix 1 1 1 2,
    projectiveMatrix 1 1 1 4,
    projectiveMatrix 1 1 1 5,
    projectiveMatrix 1 1 1 6,
    projectiveMatrix 1 1 1 10,
    projectiveMatrix 1 2 2 9,
    projectiveMatrix 1 2 4 1,
    projectiveMatrix 1 2 5 8,
    projectiveMatrix 1 2 6 4,
    projectiveMatrix 1 2 10 10,
    projectiveMatrix 1 3 0 9,
    projectiveMatrix 1 3 3 2,
    projectiveMatrix 1 3 7 0,
    projectiveMatrix 1 3 8 5,
    projectiveMatrix 1 3 9 10,
    projectiveMatrix 1 4 2 1,
    projectiveMatrix 1 4 4 6,
    projectiveMatrix 1 4 5 3,
    projectiveMatrix 1 4 6 0,
    projectiveMatrix 1 4 10 10,
    projectiveMatrix 1 5 2 8,
    projectiveMatrix 1 5 4 3,
    projectiveMatrix 1 5 5 6,
    projectiveMatrix 1 5 6 9,
    projectiveMatrix 1 5 10 10,
    projectiveMatrix 1 6 2 4,
    projectiveMatrix 1 6 4 0,
    projectiveMatrix 1 6 5 9,
    projectiveMatrix 1 6 6 7,
    projectiveMatrix 1 6 10 10,
    projectiveMatrix 1 7 0 5,
    projectiveMatrix 1 7 3 0,
    projectiveMatrix 1 7 7 8,
    projectiveMatrix 1 7 8 10,
    projectiveMatrix 1 7 9 1,
    projectiveMatrix 1 8 0 4,
    projectiveMatrix 1 8 3 5,
    projectiveMatrix 1 8 7 10,
    projectiveMatrix 1 8 8 3,
    projectiveMatrix 1 8 9 7,
    projectiveMatrix 1 9 0 3,
    projectiveMatrix 1 9 3 10,
    projectiveMatrix 1 9 7 1,
    projectiveMatrix 1 9 8 7,
    projectiveMatrix 1 9 9 2,
    projectiveMatrix 1 10 2 10,
    projectiveMatrix 1 10 4 10,
    projectiveMatrix 1 10 5 10,
    projectiveMatrix 1 10 6 10,
    projectiveMatrix 1 10 10 10]

/-- The sixty leading-normalized matrices stabilizing the conjugate golden matching. -/
def h3ConjugateStabilizerCertificate : List (ProjectiveMatrix 11) :=
  [projectiveMatrix 0 1 2 8,
    projectiveMatrix 0 1 6 4,
    projectiveMatrix 0 1 7 3,
    projectiveMatrix 0 1 8 2,
    projectiveMatrix 0 1 10 0,
    projectiveMatrix 1 0 0 1,
    projectiveMatrix 1 0 2 3,
    projectiveMatrix 1 0 3 4,
    projectiveMatrix 1 0 4 5,
    projectiveMatrix 1 0 8 9,
    projectiveMatrix 1 1 1 10,
    projectiveMatrix 1 1 5 10,
    projectiveMatrix 1 1 6 10,
    projectiveMatrix 1 1 7 10,
    projectiveMatrix 1 1 9 10,
    projectiveMatrix 1 2 0 3,
    projectiveMatrix 1 2 2 2,
    projectiveMatrix 1 2 3 7,
    projectiveMatrix 1 2 4 1,
    projectiveMatrix 1 2 8 10,
    projectiveMatrix 1 3 0 4,
    projectiveMatrix 1 3 2 7,
    projectiveMatrix 1 3 3 3,
    projectiveMatrix 1 3 4 10,
    projectiveMatrix 1 3 8 5,
    projectiveMatrix 1 4 0 5,
    projectiveMatrix 1 4 2 1,
    projectiveMatrix 1 4 3 10,
    projectiveMatrix 1 4 4 8,
    projectiveMatrix 1 4 8 0,
    projectiveMatrix 1 5 1 10,
    projectiveMatrix 1 5 5 7,
    projectiveMatrix 1 5 6 9,
    projectiveMatrix 1 5 7 0,
    projectiveMatrix 1 5 9 4,
    projectiveMatrix 1 6 1 10,
    projectiveMatrix 1 6 5 9,
    projectiveMatrix 1 6 6 6,
    projectiveMatrix 1 6 7 3,
    projectiveMatrix 1 6 9 8,
    projectiveMatrix 1 7 1 10,
    projectiveMatrix 1 7 5 0,
    projectiveMatrix 1 7 6 3,
    projectiveMatrix 1 7 7 6,
    projectiveMatrix 1 7 9 1,
    projectiveMatrix 1 8 0 9,
    projectiveMatrix 1 8 2 10,
    projectiveMatrix 1 8 3 5,
    projectiveMatrix 1 8 4 0,
    projectiveMatrix 1 8 8 2,
    projectiveMatrix 1 9 1 10,
    projectiveMatrix 1 9 5 4,
    projectiveMatrix 1 9 6 8,
    projectiveMatrix 1 9 7 1,
    projectiveMatrix 1 9 9 9,
    projectiveMatrix 1 10 10 2,
    projectiveMatrix 1 10 10 4,
    projectiveMatrix 1 10 10 5,
    projectiveMatrix 1 10 10 6,
    projectiveMatrix 1 10 10 10]

/-- Representatives for the twenty-two projective cosets of the base stabilizer. -/
def h3ProjectiveCosetRepresentatives : List (ProjectiveMatrix 11) :=
  [projectiveMatrix 0 1 1 0,
    projectiveMatrix 0 1 1 1,
    projectiveMatrix 0 1 1 2,
    projectiveMatrix 0 1 1 3,
    projectiveMatrix 0 1 1 4,
    projectiveMatrix 0 1 1 5,
    projectiveMatrix 0 1 1 6,
    projectiveMatrix 0 1 1 7,
    projectiveMatrix 0 1 1 8,
    projectiveMatrix 0 1 1 9,
    projectiveMatrix 0 1 1 10,
    projectiveMatrix 0 1 2 0,
    projectiveMatrix 0 1 2 1,
    projectiveMatrix 0 1 2 2,
    projectiveMatrix 0 1 2 3,
    projectiveMatrix 0 1 2 4,
    projectiveMatrix 0 1 2 5,
    projectiveMatrix 0 1 2 6,
    projectiveMatrix 0 1 2 7,
    projectiveMatrix 0 1 2 8,
    projectiveMatrix 0 1 2 9,
    projectiveMatrix 0 1 2 10]

/-- Representatives for the eleven square-determinant cosets of the base stabilizer. -/
def h3BaseSquareCosetRepresentatives : List (ProjectiveMatrix 11) :=
  [projectiveMatrix 0 1 2 0,
    projectiveMatrix 0 1 2 1,
    projectiveMatrix 0 1 2 2,
    projectiveMatrix 0 1 2 3,
    projectiveMatrix 0 1 2 4,
    projectiveMatrix 0 1 2 5,
    projectiveMatrix 0 1 2 6,
    projectiveMatrix 0 1 2 7,
    projectiveMatrix 0 1 2 8,
    projectiveMatrix 0 1 2 9,
    projectiveMatrix 0 1 2 10]

/-- Representatives for the eleven square-determinant cosets of the conjugate stabilizer. -/
def h3ConjugateSquareCosetRepresentatives : List (ProjectiveMatrix 11) :=
  [projectiveMatrix 0 1 2 0,
    projectiveMatrix 0 1 2 1,
    projectiveMatrix 0 1 2 2,
    projectiveMatrix 0 1 2 3,
    projectiveMatrix 0 1 2 4,
    projectiveMatrix 0 1 2 5,
    projectiveMatrix 0 1 2 6,
    projectiveMatrix 0 1 2 7,
    projectiveMatrix 0 1 2 8,
    projectiveMatrix 0 1 2 9,
    projectiveMatrix 0 1 2 10]

/-- The union of the two golden matching stabilizers, in fixed matrix order. -/
def h3GenerationGenerators : List (ProjectiveMatrix 11) :=
  [projectiveMatrix 0 1 2 3,
    projectiveMatrix 0 1 2 8,
    projectiveMatrix 0 1 6 4,
    projectiveMatrix 0 1 6 7,
    projectiveMatrix 0 1 7 3,
    projectiveMatrix 0 1 7 8,
    projectiveMatrix 0 1 8 2,
    projectiveMatrix 0 1 8 9,
    projectiveMatrix 0 1 10 0,
    projectiveMatrix 1 0 0 1,
    projectiveMatrix 1 0 2 3,
    projectiveMatrix 1 0 3 4,
    projectiveMatrix 1 0 3 9,
    projectiveMatrix 1 0 4 5,
    projectiveMatrix 1 0 7 5,
    projectiveMatrix 1 0 8 4,
    projectiveMatrix 1 0 8 9,
    projectiveMatrix 1 0 9 3,
    projectiveMatrix 1 1 1 2,
    projectiveMatrix 1 1 1 4,
    projectiveMatrix 1 1 1 5,
    projectiveMatrix 1 1 1 6,
    projectiveMatrix 1 1 1 10,
    projectiveMatrix 1 1 5 10,
    projectiveMatrix 1 1 6 10,
    projectiveMatrix 1 1 7 10,
    projectiveMatrix 1 1 9 10,
    projectiveMatrix 1 2 0 3,
    projectiveMatrix 1 2 2 2,
    projectiveMatrix 1 2 2 9,
    projectiveMatrix 1 2 3 7,
    projectiveMatrix 1 2 4 1,
    projectiveMatrix 1 2 5 8,
    projectiveMatrix 1 2 6 4,
    projectiveMatrix 1 2 8 10,
    projectiveMatrix 1 2 10 10,
    projectiveMatrix 1 3 0 4,
    projectiveMatrix 1 3 0 9,
    projectiveMatrix 1 3 2 7,
    projectiveMatrix 1 3 3 2,
    projectiveMatrix 1 3 3 3,
    projectiveMatrix 1 3 4 10,
    projectiveMatrix 1 3 7 0,
    projectiveMatrix 1 3 8 5,
    projectiveMatrix 1 3 9 10,
    projectiveMatrix 1 4 0 5,
    projectiveMatrix 1 4 2 1,
    projectiveMatrix 1 4 3 10,
    projectiveMatrix 1 4 4 6,
    projectiveMatrix 1 4 4 8,
    projectiveMatrix 1 4 5 3,
    projectiveMatrix 1 4 6 0,
    projectiveMatrix 1 4 8 0,
    projectiveMatrix 1 4 10 10,
    projectiveMatrix 1 5 1 10,
    projectiveMatrix 1 5 2 8,
    projectiveMatrix 1 5 4 3,
    projectiveMatrix 1 5 5 6,
    projectiveMatrix 1 5 5 7,
    projectiveMatrix 1 5 6 9,
    projectiveMatrix 1 5 7 0,
    projectiveMatrix 1 5 9 4,
    projectiveMatrix 1 5 10 10,
    projectiveMatrix 1 6 1 10,
    projectiveMatrix 1 6 2 4,
    projectiveMatrix 1 6 4 0,
    projectiveMatrix 1 6 5 9,
    projectiveMatrix 1 6 6 6,
    projectiveMatrix 1 6 6 7,
    projectiveMatrix 1 6 7 3,
    projectiveMatrix 1 6 9 8,
    projectiveMatrix 1 6 10 10,
    projectiveMatrix 1 7 0 5,
    projectiveMatrix 1 7 1 10,
    projectiveMatrix 1 7 3 0,
    projectiveMatrix 1 7 5 0,
    projectiveMatrix 1 7 6 3,
    projectiveMatrix 1 7 7 6,
    projectiveMatrix 1 7 7 8,
    projectiveMatrix 1 7 8 10,
    projectiveMatrix 1 7 9 1,
    projectiveMatrix 1 8 0 4,
    projectiveMatrix 1 8 0 9,
    projectiveMatrix 1 8 2 10,
    projectiveMatrix 1 8 3 5,
    projectiveMatrix 1 8 4 0,
    projectiveMatrix 1 8 7 10,
    projectiveMatrix 1 8 8 2,
    projectiveMatrix 1 8 8 3,
    projectiveMatrix 1 8 9 7,
    projectiveMatrix 1 9 0 3,
    projectiveMatrix 1 9 1 10,
    projectiveMatrix 1 9 3 10,
    projectiveMatrix 1 9 5 4,
    projectiveMatrix 1 9 6 8,
    projectiveMatrix 1 9 7 1,
    projectiveMatrix 1 9 8 7,
    projectiveMatrix 1 9 9 2,
    projectiveMatrix 1 9 9 9,
    projectiveMatrix 1 10 2 10,
    projectiveMatrix 1 10 4 10,
    projectiveMatrix 1 10 5 10,
    projectiveMatrix 1 10 6 10,
    projectiveMatrix 1 10 10 2,
    projectiveMatrix 1 10 10 4,
    projectiveMatrix 1 10 10 5,
    projectiveMatrix 1 10 10 6,
    projectiveMatrix 1 10 10 10]

/-- Length-three padded words covering every square-determinant projective matrix. -/
def h3GenerationWords : List (List Nat) :=
  [[2, 90, 9],
    [2, 7, 13],
    [5, 82, 9],
    [0, 9, 9],
    [7, 36, 9],
    [1, 3, 77],
    [0, 2, 48],
    [6, 81, 9],
    [1, 9, 9],
    [4, 37, 9],
    [2, 3, 25],
    [6, 72, 9],
    [1, 81, 9],
    [4, 90, 9],
    [1, 5, 67],
    [2, 9, 9],
    [1, 0, 11],
    [0, 1, 15],
    [3, 9, 9],
    [0, 4, 57],
    [5, 27, 9],
    [0, 36, 9],
    [0, 2, 56],
    [6, 37, 9],
    [1, 72, 9],
    [4, 9, 9],
    [1, 0, 40],
    [2, 81, 9],
    [3, 36, 9],
    [0, 1, 88],
    [5, 9, 9],
    [0, 45, 9],
    [7, 82, 9],
    [4, 0, 40],
    [0, 2, 100],
    [6, 9, 9],
    [1, 90, 9],
    [4, 72, 9],
    [3, 82, 9],
    [2, 37, 9],
    [5, 45, 9],
    [0, 27, 9],
    [7, 9, 9],
    [0, 4, 50],
    [8, 9, 9],
    [0, 4, 101],
    [2, 3, 69],
    [3, 45, 9],
    [6, 90, 9],
    [1, 37, 9],
    [0, 82, 9],
    [7, 27, 9],
    [2, 72, 9],
    [3, 2, 56],
    [0, 1, 79],
    [9, 9, 9],
    [4, 0, 73],
    [0, 2, 32],
    [6, 42, 9],
    [2, 65, 9],
    [0, 4, 20],
    [0, 2, 19],
    [6, 74, 9],
    [1, 51, 9],
    [2, 7, 2],
    [2, 3, 94],
    [10, 9, 9],
    [1, 42, 9],
    [4, 65, 9],
    [5, 52, 9],
    [3, 85, 9],
    [1, 65, 9],
    [11, 9, 9],
    [1, 5, 91],
    [12, 9, 9],
    [6, 65, 9],
    [4, 42, 9],
    [1, 0, 73],
    [13, 9, 9],
    [7, 75, 9],
    [1, 74, 9],
    [3, 52, 9],
    [2, 51, 9],
    [1, 0, 4],
    [1, 3, 41],
    [0, 52, 9],
    [2, 74, 9],
    [3, 75, 9],
    [0, 1, 5],
    [0, 2, 86],
    [7, 60, 9],
    [5, 85, 9],
    [0, 1, 53],
    [14, 9, 9],
    [6, 51, 9],
    [2, 42, 9],
    [0, 60, 9],
    [15, 9, 9],
    [0, 4, 35],
    [16, 9, 9],
    [3, 2, 32],
    [17, 9, 9],
    [0, 85, 9],
    [5, 60, 9],
    [4, 74, 9],
    [0, 1, 39],
    [0, 4, 89],
    [7, 52, 9],
    [0, 75, 9],
    [2, 3, 104],
    [0, 1, 100],
    [0, 1, 65],
    [5, 67, 9],
    [0, 40, 9],
    [0, 1, 56],
    [18, 9, 9],
    [19, 9, 9],
    [20, 9, 9],
    [21, 9, 9],
    [22, 9, 9],
    [0, 4, 12],
    [0, 4, 74],
    [0, 98, 9],
    [7, 28, 9],
    [0, 4, 92],
    [2, 3, 87],
    [5, 40, 9],
    [7, 67, 9],
    [1, 3, 61],
    [4, 0, 27],
    [3, 98, 9],
    [0, 28, 9],
    [0, 2, 79],
    [0, 2, 96],
    [0, 2, 15],
    [6, 53, 9],
    [6, 62, 9],
    [6, 35, 9],
    [6, 71, 9],
    [23, 9, 9],
    [1, 53, 9],
    [1, 35, 9],
    [1, 71, 9],
    [1, 62, 9],
    [24, 9, 9],
    [4, 35, 9],
    [4, 62, 9],
    [0, 67, 9],
    [4, 53, 9],
    [25, 9, 9],
    [1, 0, 27],
    [2, 3, 4],
    [3, 67, 9],
    [7, 40, 9],
    [1, 5, 82],
    [2, 71, 9],
    [2, 53, 9],
    [2, 35, 9],
    [2, 62, 9],
    [26, 9, 9],
    [1, 0, 104],
    [3, 28, 9],
    [2, 7, 103],
    [5, 98, 9],
    [3, 2, 79],
    [0, 4, 5],
    [27, 9, 9],
    [7, 49, 9],
    [3, 69, 9],
    [4, 101, 9],
    [1, 5, 10],
    [4, 0, 70],
    [4, 64, 9],
    [2, 89, 9],
    [0, 1, 20],
    [28, 9, 9],
    [0, 2, 62],
    [2, 3, 76],
    [3, 2, 97],
    [29, 9, 9],
    [0, 4, 9],
    [1, 0, 38],
    [30, 9, 9],
    [2, 101, 9],
    [0, 1, 81],
    [2, 7, 36],
    [31, 9, 9],
    [7, 23, 9],
    [0, 1, 42],
    [1, 101, 9],
    [4, 89, 9],
    [5, 23, 9],
    [0, 4, 55],
    [0, 2, 97],
    [32, 9, 9],
    [3, 23, 9],
    [33, 9, 9],
    [2, 3, 13],
    [6, 64, 9],
    [0, 4, 96],
    [5, 49, 9],
    [2, 64, 9],
    [7, 69, 9],
    [3, 4, 9],
    [1, 89, 9],
    [0, 69, 9],
    [5, 4, 9],
    [1, 3, 82],
    [6, 101, 9],
    [34, 9, 9],
    [1, 64, 9],
    [1, 0, 70],
    [6, 89, 9],
    [0, 49, 9],
    [0, 2, 7],
    [6, 18, 9],
    [0, 23, 9],
    [2, 18, 9],
    [1, 18, 9],
    [35, 9, 9],
    [6, 86, 9],
    [3, 25, 9],
    [36, 9, 9],
    [1, 3, 67],
    [37, 9, 9],
    [0, 4, 19],
    [1, 68, 9],
    [6, 12, 9],
    [1, 0, 34],
    [0, 2, 21],
    [6, 3, 9],
    [4, 0, 83],
    [38, 9, 9],
    [1, 86, 9],
    [0, 1, 29],
    [0, 6, 9],
    [39, 9, 9],
    [40, 9, 9],
    [0, 2, 72],
    [1, 0, 83],
    [2, 3, 9],
    [7, 93, 9],
    [0, 4, 48],
    [4, 86, 9],
    [41, 9, 9],
    [1, 12, 9],
    [3, 87, 9],
    [2, 68, 9],
    [5, 93, 9],
    [2, 3, 58],
    [0, 87, 9],
    [2, 12, 9],
    [4, 68, 9],
    [0, 1, 0],
    [3, 2, 51],
    [42, 9, 9],
    [0, 1, 71],
    [6, 68, 9],
    [2, 7, 28],
    [3, 6, 9],
    [2, 86, 9],
    [0, 25, 9],
    [43, 9, 9],
    [1, 3, 9],
    [5, 6, 9],
    [5, 25, 9],
    [7, 6, 9],
    [0, 4, 78],
    [4, 12, 9],
    [44, 9, 9],
    [2, 3, 103],
    [1, 5, 106],
    [7, 87, 9],
    [0, 93, 9],
    [0, 2, 51],
    [3, 77, 9],
    [7, 13, 9],
    [3, 2, 99],
    [45, 9, 9],
    [1, 79, 9],
    [4, 55, 9],
    [2, 17, 9],
    [1, 3, 23],
    [0, 1, 18],
    [1, 0, 16],
    [0, 2, 35],
    [46, 9, 9],
    [2, 79, 9],
    [1, 5, 41],
    [5, 34, 9],
    [0, 1, 9],
    [6, 79, 9],
    [0, 4, 90],
    [3, 13, 9],
    [47, 9, 9],
    [1, 0, 63],
    [48, 9, 9],
    [49, 9, 9],
    [2, 3, 36],
    [0, 1, 78],
    [4, 17, 9],
    [3, 34, 9],
    [50, 9, 9],
    [0, 1, 68],
    [0, 4, 29],
    [51, 9, 9],
    [4, 0, 16],
    [2, 3, 85],
    [6, 55, 9],
    [0, 34, 9],
    [7, 77, 9],
    [0, 4, 102],
    [0, 2, 92],
    [2, 55, 9],
    [1, 17, 9],
    [52, 9, 9],
    [2, 7, 69],
    [0, 77, 9],
    [0, 2, 99],
    [5, 1, 9],
    [0, 13, 9],
    [1, 55, 9],
    [5, 77, 9],
    [7, 1, 9],
    [6, 17, 9],
    [2, 19, 9],
    [1, 19, 9],
    [6, 19, 9],
    [4, 19, 9],
    [53, 9, 9],
    [1, 96, 9],
    [4, 50, 9],
    [0, 11, 9],
    [1, 5, 6],
    [2, 7, 75],
    [5, 106, 9],
    [0, 106, 9],
    [3, 106, 9],
    [7, 106, 9],
    [54, 9, 9],
    [7, 83, 9],
    [2, 96, 9],
    [0, 2, 71],
    [1, 0, 76],
    [55, 9, 9],
    [7, 94, 9],
    [2, 50, 9],
    [5, 11, 9],
    [6, 96, 9],
    [0, 1, 72],
    [0, 83, 9],
    [1, 50, 9],
    [56, 9, 9],
    [1, 3, 52],
    [3, 2, 71],
    [0, 2, 17],
    [0, 1, 51],
    [57, 9, 9],
    [58, 9, 9],
    [0, 4, 64],
    [0, 4, 15],
    [1, 0, 93],
    [5, 83, 9],
    [6, 99, 9],
    [59, 9, 9],
    [60, 9, 9],
    [0, 4, 33],
    [4, 0, 93],
    [2, 99, 9],
    [0, 94, 9],
    [3, 94, 9],
    [6, 50, 9],
    [4, 96, 9],
    [2, 3, 2],
    [0, 2, 29],
    [3, 11, 9],
    [61, 9, 9],
    [0, 1, 101],
    [1, 99, 9],
    [2, 3, 38],
    [4, 20, 9],
    [2, 20, 9],
    [6, 20, 9],
    [1, 20, 9],
    [62, 9, 9],
    [0, 30, 9],
    [5, 76, 9],
    [1, 15, 9],
    [0, 4, 7],
    [2, 3, 98],
    [5, 105, 9],
    [2, 44, 9],
    [7, 105, 9],
    [0, 105, 9],
    [63, 9, 9],
    [2, 15, 9],
    [64, 9, 9],
    [1, 0, 24],
    [0, 26, 9],
    [2, 7, 47],
    [2, 32, 9],
    [6, 15, 9],
    [5, 30, 9],
    [3, 2, 3],
    [0, 4, 72],
    [65, 9, 9],
    [0, 1, 14],
    [4, 0, 24],
    [3, 26, 9],
    [1, 32, 9],
    [0, 2, 89],
    [0, 1, 33],
    [4, 44, 9],
    [7, 26, 9],
    [66, 9, 9],
    [1, 3, 10],
    [0, 4, 88],
    [67, 9, 9],
    [68, 9, 9],
    [1, 5, 61],
    [1, 44, 9],
    [0, 76, 9],
    [69, 9, 9],
    [0, 2, 74],
    [2, 3, 54],
    [6, 32, 9],
    [3, 76, 9],
    [4, 15, 9],
    [7, 30, 9],
    [1, 0, 45],
    [6, 44, 9],
    [3, 30, 9],
    [0, 2, 3],
    [0, 1, 50],
    [70, 9, 9],
    [4, 21, 9],
    [1, 21, 9],
    [2, 21, 9],
    [6, 21, 9],
    [71, 9, 9],
    [2, 48, 9],
    [6, 14, 9],
    [2, 3, 26],
    [72, 9, 9],
    [0, 47, 9],
    [3, 104, 9],
    [0, 104, 9],
    [6, 92, 9],
    [5, 104, 9],
    [73, 9, 9],
    [1, 14, 9],
    [0, 70, 9],
    [4, 48, 9],
    [6, 0, 9],
    [7, 10, 9],
    [74, 9, 9],
    [2, 3, 34],
    [1, 48, 9],
    [0, 2, 81],
    [4, 0, 9],
    [6, 48, 9],
    [1, 5, 23],
    [0, 4, 100],
    [2, 0, 9],
    [0, 10, 9],
    [75, 9, 9],
    [4, 0, 49],
    [2, 7, 54],
    [7, 70, 9],
    [1, 92, 9],
    [5, 10, 9],
    [2, 92, 9],
    [76, 9, 9],
    [1, 0, 58],
    [0, 2, 42],
    [0, 1, 62],
    [77, 9, 9],
    [78, 9, 9],
    [3, 2, 81],
    [1, 0, 49],
    [1, 0, 9],
    [7, 47, 9],
    [0, 1, 97],
    [2, 14, 9],
    [79, 9, 9],
    [1, 3, 91],
    [80, 9, 9],
    [3, 47, 9],
    [0, 4, 86],
    [4, 92, 9],
    [5, 70, 9],
    [3, 10, 9],
    [0, 2, 102],
    [0, 4, 44],
    [0, 1, 12],
    [7, 41, 9],
    [2, 100, 9],
    [81, 9, 9],
    [0, 2, 57],
    [82, 9, 9],
    [3, 2, 18],
    [0, 4, 21],
    [6, 39, 9],
    [1, 33, 9],
    [0, 2, 18],
    [4, 100, 9],
    [6, 7, 9],
    [0, 1, 99],
    [5, 16, 9],
    [83, 9, 9],
    [3, 41, 9],
    [1, 100, 9],
    [84, 9, 9],
    [0, 2, 9],
    [4, 7, 9],
    [85, 9, 9],
    [0, 4, 65],
    [6, 100, 9],
    [2, 3, 45],
    [2, 7, 9],
    [1, 39, 9],
    [2, 33, 9],
    [5, 58, 9],
    [1, 0, 1],
    [2, 3, 75],
    [0, 16, 9],
    [2, 39, 9],
    [3, 58, 9],
    [4, 33, 9],
    [2, 7, 94],
    [3, 2, 9],
    [6, 33, 9],
    [1, 5, 77],
    [5, 41, 9],
    [86, 9, 9],
    [1, 7, 9],
    [87, 9, 9],
    [88, 9, 9],
    [0, 4, 62],
    [0, 1, 44],
    [7, 2, 9],
    [4, 0, 1],
    [89, 9, 9],
    [0, 41, 9],
    [1, 0, 98],
    [0, 2, 68],
    [0, 58, 9],
    [7, 16, 9],
    [0, 1, 92],
    [1, 3, 106],
    [0, 2, 50],
    [90, 9, 9],
    [6, 78, 9],
    [2, 56, 9],
    [5, 24, 9],
    [7, 103, 9],
    [1, 102, 9],
    [3, 103, 9],
    [0, 103, 9],
    [91, 9, 9],
    [0, 61, 9],
    [0, 1, 55],
    [6, 5, 9],
    [1, 78, 9],
    [1, 3, 6],
    [1, 56, 9],
    [4, 5, 9],
    [0, 2, 37],
    [7, 24, 9],
    [92, 9, 9],
    [4, 78, 9],
    [3, 61, 9],
    [6, 56, 9],
    [2, 5, 9],
    [0, 38, 9],
    [2, 102, 9],
    [93, 9, 9],
    [3, 2, 14],
    [7, 61, 9],
    [1, 5, 30],
    [5, 38, 9],
    [4, 102, 9],
    [0, 1, 3],
    [0, 2, 14],
    [94, 9, 9],
    [2, 3, 63],
    [95, 9, 9],
    [6, 102, 9],
    [1, 0, 85],
    [0, 24, 9],
    [1, 5, 9],
    [0, 1, 89],
    [96, 9, 9],
    [2, 78, 9],
    [0, 4, 53],
    [97, 9, 9],
    [0, 4, 42],
    [2, 7, 87],
    [2, 3, 28],
    [98, 9, 9],
    [0, 4, 17],
    [4, 0, 105],
    [5, 61, 9],
    [3, 38, 9],
    [1, 0, 105],
    [1, 0, 25],
    [1, 0, 60],
    [4, 57, 9],
    [1, 88, 9],
    [0, 4, 0],
    [0, 1, 19],
    [2, 97, 9],
    [2, 3, 11],
    [4, 29, 9],
    [2, 3, 47],
    [3, 54, 9],
    [2, 88, 9],
    [3, 91, 9],
    [3, 63, 9],
    [99, 9, 9],
    [0, 1, 90],
    [2, 7, 26],
    [2, 57, 9],
    [6, 88, 9],
    [0, 4, 37],
    [5, 91, 9],
    [5, 63, 9],
    [1, 57, 9],
    [5, 73, 9],
    [100, 9, 9],
    [0, 73, 9],
    [0, 91, 9],
    [0, 54, 9],
    [0, 63, 9],
    [101, 9, 9],
    [7, 73, 9],
    [6, 29, 9],
    [7, 91, 9],
    [7, 54, 9],
    [102, 9, 9],
    [2, 29, 9],
    [1, 97, 9],
    [0, 2, 39],
    [1, 3, 30],
    [0, 4, 68],
    [3, 2, 39],
    [4, 88, 9],
    [6, 57, 9],
    [0, 2, 64],
    [4, 0, 60],
    [0, 1, 32],
    [1, 5, 52],
    [1, 29, 9],
    [6, 97, 9],
    [0, 2, 5],
    [103, 9, 9],
    [104, 9, 9],
    [105, 9, 9],
    [106, 9, 9],
    [107, 9, 9]]
/- END ARITHMETIC GLUING CERTIFICATE DATA -/

end ClebschArithmeticGluing
end RelativeConicArcs
